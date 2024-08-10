--5 consultas que aporten valor al negocio
--1. Productos más vendidos
SELECT p.nombre, p.categoria, SUM(dp.cantidad) as total_vendido
FROM productos p
JOIN detalles_pedido dp ON p.id_producto = dp.id_producto
JOIN pedidos ped ON dp.id_pedido = ped.id_pedido
WHERE ped.estado = 'entregado'
GROUP BY p.id_producto, p.nombre, p.categoria
ORDER BY total_vendido DESC
LIMIT 5;

--2 Clientes que han comprado mas
SELECT u.id_usuario, u.nombre, u.apellido, SUM(p.precio_total) as total_gastado
FROM usuarios u
JOIN pedidos p ON u.id_usuario = p.id_usuario
WHERE p.estado = 'entregado'
GROUP BY u.id_usuario, u.nombre, u.apellido
ORDER BY total_gastado DESC
LIMIT 5;

--3 Productos con bajo stock
SELECT nombre, categoria, stock
FROM productos
WHERE stock < 10
ORDER BY stock ASC;

--4 Productos con mas satisfacción
SELECT p.nombre, p.categoria, 
       AVG(r.calificacion) as calificacion_promedio, 
       COUNT(r.id_resena) as total_resenas
FROM productos p
LEFT JOIN resenas r ON p.id_producto = r.id_producto
GROUP BY p.id_producto, p.nombre, p.categoria
ORDER BY calificacion_promedio DESC, total_resenas DESC;

--5 Mayores ventas por categoría y mes
SELECT 
    p.categoria,
    DATE_TRUNC('month', ped.fecha_pedido) as mes,
    SUM(dp.cantidad * dp.precio_unitario) as total_ventas
FROM productos p
JOIN detalles_pedido dp ON p.id_producto = dp.id_producto
JOIN pedidos ped ON dp.id_pedido = ped.id_pedido
WHERE ped.estado = 'entregado'
GROUP BY p.categoria, DATE_TRUNC('month', ped.fecha_pedido)
ORDER BY p.categoria, mes;

--5 procedimientos almacenados que aporten valor al negocio

--1.Procedimiento que permite ingresar los datos de los clientes
CREATE OR REPLACE PROCEDURE insertar_cliente(
    p_nombre VARCHAR(50),
    p_apellido VARCHAR(50),
    p_direccion TEXT,
    p_telefono VARCHAR(20),
    p_email VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_cliente_id INT;
BEGIN
    -- Verificar si el email ya existe
    SELECT id_usuario INTO v_cliente_id
    FROM usuarios
    WHERE email = p_email;
    
    IF v_cliente_id IS NOT NULL THEN
        RAISE EXCEPTION 'Ya existe un cliente con el email: %', p_email;
    END IF;

    -- Insertar el nuevo cliente
    INSERT INTO usuarios (nombre, apellido, direccion, telefono, email)
    VALUES (p_nombre, p_apellido, p_direccion, p_telefono, p_email);
    

    -- Confirmar la inserción
    RAISE NOTICE 'Cliente insertado con éxito. ID: %', v_cliente_id;

END;
$$;

CALL insertar_cliente(
    'Gabriel', 
    'García', 
    'Calle 10 #5-51, Bogotá', 
    '3001234567', 
    'gabriel.garcia@yahoo.com'
);

--2 Procedimiento que permite actualizar el stock de productos después de una venta
CREATE OR REPLACE PROCEDURE actualizar_stock(pedido_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE productos p
    SET stock = p.stock - dp.cantidad
    FROM detalles_pedido dp
    WHERE dp.id_pedido = pedido_id
    AND p.id_producto = dp.id_producto;
    
    COMMIT;
END;
$$;

CALL actualizar_stock(1);

--3. Procedimiento almacenado que permita a los clientes agregar productos a su lista de deseos
CREATE OR REPLACE PROCEDURE agregar_a_lista_deseos(
    p_id_usuario INT,
    p_id_producto INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_existe BOOLEAN;
BEGIN
    -- Verificar si el producto ya está en la lista de deseos del usuario
    SELECT EXISTS (
        SELECT 1 
        FROM lista_deseos 
        WHERE id_usuario = p_id_usuario AND id_producto = p_id_producto
    ) INTO v_existe;

    IF v_existe THEN
        RAISE NOTICE 'El producto ya está en la lista de deseos del usuario.';
    ELSE
        -- Insertar el producto en la lista de deseos
        INSERT INTO lista_deseos (id_usuario, id_producto)
        VALUES (p_id_usuario, p_id_producto);
        
        RAISE NOTICE 'Producto agregado a la lista de deseos exitosamente.';
    END IF;
END;
$$;

CALL agregar_a_lista_deseos(1, 5);

--4. Generar informe de productos con bajo stock
CREATE OR REPLACE PROCEDURE generar_informe_bajo_stock(umbral INT)
LANGUAGE plpgsql
AS $$
DECLARE
    producto_record RECORD;
BEGIN
    FOR producto_record IN 
        SELECT nombre, stock, categoria
        FROM productos
        WHERE stock <= umbral
        ORDER BY stock ASC
    LOOP
        RAISE NOTICE 'Producto: %, Categoría: %, Stock actual: %', 
                     producto_record.nombre, 
                     producto_record.categoria, 
                     producto_record.stock;
    END LOOP;
END;
$$;
CALL generar_informe_bajo_stock(20);

--5. Procedimiento almacenado que maneje el proceso de compra, desde añadir productos al carrito
-- hasta generar el pedido
CREATE OR REPLACE PROCEDURE realizar_compra(
    p_id_usuario INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_pedido INT;
    v_precio_total DECIMAL(10, 2);
    v_producto RECORD;
BEGIN
    -- Iniciar la transacción
    BEGIN
        -- Calcular el precio total del carrito
        SELECT SUM(c.cantidad * p.precio)
        INTO v_precio_total
        FROM carrito c
        JOIN productos p ON c.id_producto = p.id_producto
        WHERE c.id_usuario = p_id_usuario;

        -- Si el carrito está vacío, lanzar una excepción
        IF v_precio_total = 0 THEN
            RAISE EXCEPTION 'El carrito está vacío';
        END IF;

        -- Crear el pedido
        INSERT INTO pedidos (id_usuario, precio_total, estado)
        VALUES (p_id_usuario, v_precio_total, 'procesando')
        RETURNING id_pedido INTO v_id_pedido;

        -- Transferir productos del carrito al pedido
        FOR v_producto IN (
            SELECT c.id_producto, c.cantidad, p.precio
            FROM carrito c
            JOIN productos p ON c.id_producto = p.id_producto
            WHERE c.id_usuario = p_id_usuario
        ) LOOP
            -- Insertar en detalles_pedido
            INSERT INTO detalles_pedido (id_pedido, id_producto, cantidad, precio_unitario)
            VALUES (v_id_pedido, v_producto.id_producto, v_producto.cantidad, v_producto.precio);

            -- Actualizar el stock
            UPDATE productos
            SET stock = stock - v_producto.cantidad
            WHERE id_producto = v_producto.id_producto;

            -- Verificar si el stock es suficiente
            IF (SELECT stock FROM productos WHERE id_producto = v_producto.id_producto) < 0 THEN
                RAISE EXCEPTION 'Stock insuficiente para el producto con ID %', v_producto.id_producto;
            END IF;
        END LOOP;

        -- Limpiar el carrito del usuario
        DELETE FROM carrito WHERE id_usuario = p_id_usuario;

        -- Confirmar la transacción
        RAISE NOTICE 'Compra realizada con éxito. ID del pedido: %', v_id_pedido;    
    END;
END;
$$;
CALL realizar_compra(2);

-- 5 funciones que aporten valor al negocio.

--1. Funcion Calcular el total de ventas por período
CREATE OR REPLACE FUNCTION calcular_ventas_periodo(fecha_inicio DATE, fecha_fin DATE)
RETURNS TABLE (total_ventas DECIMAL(10,2))
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT COALESCE(SUM(precio_total), 0) as total_ventas
    FROM pedidos
    WHERE fecha_pedido BETWEEN fecha_inicio AND fecha_fin
    AND estado = 'entregado';
END;
$$;

SELECT * FROM calcular_ventas_periodo(
    (CURRENT_DATE - INTERVAL '1 month')::DATE,
    CURRENT_DATE
);


--2. Funcion para que los clientes pueden revisar sus pedidos pasados y
--realizar búsquedas de pedidos realizados en un periodo específico
CREATE OR REPLACE FUNCTION buscar_pedidos_cliente(
    p_id_usuario INT,
    p_fecha_inicio DATE DEFAULT NULL,
    p_fecha_fin DATE DEFAULT NULL
)
RETURNS TABLE (
    id_pedido INT,
    fecha_pedido TIMESTAMP,
    precio_total DECIMAL(10,2),
    estado VARCHAR(20),
    detalles TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id_pedido,
        p.fecha_pedido,
        p.precio_total,
        p.estado,
        string_agg(
            'Producto: ' || pr.nombre || ', Cantidad: ' || dp.cantidad || ', Precio: $' || dp.precio_unitario,
            E'\n'
        ) AS detalles
    FROM pedidos p
    JOIN detalles_pedido dp ON p.id_pedido = dp.id_pedido
    JOIN productos pr ON dp.id_producto = pr.id_producto
    WHERE p.id_usuario = p_id_usuario
    AND (p_fecha_inicio IS NULL OR p.fecha_pedido >= p_fecha_inicio)
    AND (p_fecha_fin IS NULL OR p.fecha_pedido <= p_fecha_fin)
    GROUP BY p.id_pedido, p.fecha_pedido, p.precio_total, p.estado
    ORDER BY p.fecha_pedido DESC;
END;
$$;

SELECT * FROM buscar_pedidos_cliente(1);
SELECT * FROM buscar_pedidos_cliente(1, '2024-08-01', '2024-08-30');

--3 Funcion que permite a los clientes consultar las reseñas y calificaciones de un producto específico
CREATE OR REPLACE FUNCTION consultar_resenas_producto(
    p_id_producto INT
)
RETURNS TABLE (
    nombre_producto VARCHAR(100),
    categoria VARCHAR(50),
    promedio_calificacion DECIMAL(3,2),
    total_resenas BIGINT,
    resena_id INT,
    calificacion INT,
    comentario TEXT,
    fecha_resena TIMESTAMP,
    nombre_usuario TEXT  -- Cambiado de VARCHAR(100) a TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    WITH resumen_producto AS (
        SELECT 
            p.nombre AS nombre_producto,
            p.categoria,
            AVG(r.calificacion) AS promedio_calificacion,
            COUNT(r.id_resena) AS total_resenas
        FROM productos p
        LEFT JOIN resenas r ON p.id_producto = r.id_producto
        WHERE p.id_producto = p_id_producto
        GROUP BY p.id_producto, p.nombre, p.categoria
    )
    SELECT 
        rp.nombre_producto,
        rp.categoria,
        rp.promedio_calificacion,
        rp.total_resenas,
        r.id_resena,
        r.calificacion,
        r.comentario,
        r.fecha_resena,
        CONCAT(u.nombre, ' ', u.apellido) AS nombre_usuario
    FROM resumen_producto rp
    LEFT JOIN resenas r ON r.id_producto = p_id_producto
    LEFT JOIN usuarios u ON r.id_usuario = u.id_usuario
    ORDER BY r.fecha_resena DESC;
END;
$$;

SELECT * FROM consultar_resenas_producto(1);

--4. Funcion que permite ver la lista de deseos
CREATE OR REPLACE FUNCTION ver_lista_deseos(p_id_usuario INT)
RETURNS TABLE (
    id_producto INT,
    nombre_producto VARCHAR(100),
    precio DECIMAL(10, 2),
    categoria VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id_producto,
        p.nombre AS nombre_producto,
        p.precio,
        p.categoria
    FROM lista_deseos ld
    JOIN productos p ON ld.id_producto = p.id_producto
    WHERE ld.id_usuario = p_id_usuario
    ORDER BY ld.fecha_agregado DESC;
END;
$$;

SELECT * FROM ver_lista_deseos(1);

--5 Funcion que permite a los clientes consultar el stock actual de un producto
-- antes de realizar una compra
CREATE OR REPLACE FUNCTION consultar_stock_producto(
    p_id_producto INT
)
RETURNS TABLE (
    id_producto INT,
    nombre_producto VARCHAR(100),
    categoria VARCHAR(50),
    precio DECIMAL(10, 2),
    stock_actual INT,
    estado_stock TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id_producto,
        p.nombre AS nombre_producto,
        p.categoria,
        p.precio,
        p.stock AS stock_actual,
        CASE
            WHEN p.stock > 20 THEN 'Disponible'
            WHEN p.stock > 0 THEN 'Pocas unidades'
            ELSE 'Agotado'
        END AS estado_stock
    FROM productos p
    WHERE p.id_producto = p_id_producto;
END;
$$;

SELECT * FROM consultar_stock_producto(1);