-- Crear la base de datos

CREATE DATABASE electro_store;


-- Crear tabla de clientes

CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(15),
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de categorías de productos

CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);


-- Crear tabla de productos

CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    categoria_id INT REFERENCES categorias(categoria_id)
);


-- Crear tabla de carrito de compras

CREATE TABLE carrito (
    carrito_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id),
    producto_id INT REFERENCES productos(producto_id),
    cantidad INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Crear tabla de pedidos

CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id),
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) NOT NULL
);

-- Crear tabla de detalles de pedidos

CREATE TABLE detalles_pedidos (
    detalle_id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES pedidos(pedido_id),
    producto_id INT REFERENCES productos(producto_id),
    cantidad INT NOT NULL,
    precio_total DECIMAL(10, 2) NOT NULL
);


-- Crear tabla de reseñas de productos

CREATE TABLE resenas (
    resena_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id),
    producto_id INT REFERENCES productos(producto_id),
    calificacion INT CHECK (calificacion >= 1 AND calificacion <= 5),
    comentario TEXT,
    fecha_resena TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Crear tabla lista de deseos

CREATE TABLE lista_deseos (
    lista_deseos_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id),
    producto_id INT REFERENCES productos(producto_id),
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Insertar registros en la tabla categorías

INSERT INTO categorias (nombre) VALUES 
('Electrónica'),
('Computadoras y Accesorios'),
('Telefonía'),
('Audio y Video'),
('Electrodomésticos'),
('Hogar y Oficina'),
('Juguetes y Juegos');


-- Insertar registros en la tabla productos

INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id) VALUES
('Smartphone', 'Smartphone', 700, 50, 3),
('Laptop', 'Laptop', 1000, 30, 2),
('Televisor', 'Televisor', 500, 20, 4),
('Auriculares', 'Auriculares', 200, 100, 4),
('Microondas', 'Microondas', 300, 25, 5),
('Escritorio', 'Escritorio ergonómico ', 500, 10, 6),
('Consola de Juegos', 'Consola ', 400, 40, 7);


-- Insertar registros en la tabla clientes

INSERT INTO clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro) VALUES
('Juan', 'Pérez', 'Calle 1', '555-1234', 'juan@gmail.com', '2023-01-15 09:30:00'),
('María', 'Gómez', 'Calle 2', '555-5678', 'maria@gmail.com', '2023-02-20 14:45:00'),
('Carlos', 'López', 'Calle 3', '555-9876', 'carlos@gmail.com', '2023-03-10 11:20:00'),
('Ana', 'Martínez', 'Calle 4', '555-4321', 'ana@gmail.com', '2023-04-05 16:00:00'),
('Luis', 'Hernández', 'Calle 5', '555-6543', 'luis@gmail.com', '2023-05-25 08:10:00'),
('Sofía', 'Rodríguez', 'Calle 6', '555-3456', 'sofia@gmail.com', '2023-06-18 10:50:00'),
('Diego', 'Fernández', 'Calle 7', '555-8765', 'diego@gmail.com', '2023-07-12 13:35:00');


-- Insertar registros en la tabla carrito

INSERT INTO carrito (cliente_id, producto_id, cantidad, fecha_agregado) VALUES
(1, 1, 2, '2023-08-01 10:00:00'),
(2, 3, 1, '2023-08-02 11:00:00'),
(3, 2, 1, '2023-08-03 12:00:00'),
(4, 5, 1, '2023-08-04 13:00:00'),
(5, 4, 3, '2023-08-05 14:00:00'),
(6, 7, 1, '2023-08-06 15:00:00'),
(7, 6, 2, '2023-08-07 16:00:00');


-- Insertar registros en la tabla pedidos

INSERT INTO pedidos (cliente_id, fecha_pedido, estado) VALUES
(1, '2023-08-08 10:00:00', 'Procesando'),
(2, '2023-08-09 11:00:00', 'Enviado'),
(3, '2023-08-10 12:00:00', 'Entregado'),
(4, '2023-08-11 13:00:00', 'Procesando'),
(5, '2023-08-12 14:00:00', 'Enviado'),
(6, '2023-08-13 15:00:00', 'Entregado'),
(7, '2023-08-14 16:00:00', 'Procesando');

-- Insertar registros en la tabla detalles_pedidos

INSERT INTO detalles_pedidos (pedido_id, producto_id, cantidad, precio_total) VALUES
(1, 1, 2, 1400.00),
(2, 3, 1, 500.00),
(3, 2, 1, 1000.00),
(4, 5, 1, 300.00),
(5, 4, 3, 600.00),
(6, 7, 1, 400.00),
(7, 6, 2, 1000.00);


-- Insertar registros en la tabla reseñas

INSERT INTO resenas (cliente_id, producto_id, calificacion, comentario, fecha_resena) VALUES
(1, 1, 5, 'Excelente', '2023-08-15 10:00:00'),
(2, 3, 4, 'Buena calidad', '2023-08-16 11:00:00'),
(3, 2, 5, 'Rápida y ligera', '2023-08-17 12:00:00'),
(4, 5, 3, 'Regular calidad', '2023-08-18 13:00:00'),
(5, 4, 5, 'Excelente', '2023-08-19 14:00:00'),
(6, 7, 4, 'Buena calidad', '2023-08-20 15:00:00'),
(7, 6, 5, 'Excelente', '2023-08-21 16:00:00');



-- Realizar 5 consultas


-- Consulta para obtener la cantidad de pedidos por cliente

SELECT 
    c.cliente_id, 
    c.nombre, 
    c.apellido, 
    COUNT(p.pedido_id) AS cantidad_pedidos
FROM 
    clientes c
LEFT JOIN 
    pedidos p ON c.cliente_id = p.cliente_id
GROUP BY 
    c.cliente_id, 
    c.nombre, 
    c.apellido
ORDER BY 
    cantidad_pedidos DESC;


-- Consulta para obtener el producto más solicitado

SELECT 
    p.producto_id,
    p.nombre,
    SUM(dp.cantidad) AS total_solicitado
FROM 
    productos p
JOIN 
    detalles_pedidos dp ON p.producto_id = dp.producto_id
GROUP BY 
    p.producto_id, 
    p.nombre
ORDER BY 
    total_solicitado DESC
LIMIT 1;


-- Consulta para obtener el producto con menos stock

SELECT 
    producto_id,
    nombre,
    stock
FROM 
    productos
ORDER BY 
    stock ASC
LIMIT 1;



-- Consulta para obtener la peor reseña y el nombre del producto

SELECT 
    r.resena_id,
    r.cliente_id,
    r.producto_id,
    r.calificacion,
    r.comentario,
    p.nombre AS producto_nombre
FROM 
    resenas r
JOIN 
    productos p ON r.producto_id = p.producto_id
ORDER BY 
    r.calificacion ASC
LIMIT 1;


-- Consulta para obtener la mejor reseña y el nombre del producto

SELECT 
    r.resena_id,
    r.cliente_id,
    r.producto_id,
    r.calificacion,
    r.comentario,
    p.nombre AS producto_nombre
FROM 
    resenas r
JOIN 
    productos p ON r.producto_id = p.producto_id
ORDER BY 
    r.calificacion DESC
LIMIT 1;



-- 5 procedimientos almacenados



-- Crear un procedimiento almacenado para insertar un nuevo cliente

CREATE OR REPLACE PROCEDURE crear_cliente(
    p_nombre VARCHAR,
    p_apellido VARCHAR,
    p_direccion TEXT,
    p_telefono VARCHAR,
    p_correo_electronico VARCHAR,
    p_fecha_registro TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro)
    VALUES (p_nombre, p_apellido, p_direccion, p_telefono, p_correo_electronico, p_fecha_registro);
END;
$$;

CALL crear_cliente('Juan','Pérez','Calle 8','555-1234','juan2@gmail.com','2024-08-12 09:00:00');


-- Crear un procedimiento almacenado para insertar un nuevo producto

CREATE OR REPLACE PROCEDURE crear_producto(
    p_nombre VARCHAR,
    p_descripcion TEXT,
    p_precio DECIMAL(10, 2),
    p_stock INTEGER,
    p_categoria_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO productos (nombre, descripcion, precio, stock, categoria_id)
    VALUES (p_nombre, p_descripcion, p_precio, p_stock, p_categoria_id);
END;
$$;

 
CALL crear_producto('Smartphone LG','Smartphone LG',1500.00,50,3);


-- Crear un procedimiento almacenado para insertar un pedido y actualizar el stock

CREATE OR REPLACE PROCEDURE realizar_pedido(
    p_cliente_id INTEGER,
    p_estado VARCHAR,
    p_fecha_pedido TIMESTAMP,
    p_detalles JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_pedido_id INTEGER;
    v_producto_id INTEGER;
    v_cantidad INTEGER;
    v_precio DECIMAL(10, 2);
BEGIN
    -- Insertar el nuevo pedido
    INSERT INTO pedidos (cliente_id, fecha_pedido, estado)
    VALUES (p_cliente_id, p_fecha_pedido, p_estado)
    RETURNING pedido_id INTO v_pedido_id;

    -- Insertar los detalles del pedido
    FOR v_producto_id, v_cantidad IN
        SELECT
            (detalle->>'producto_id')::INTEGER,
            (detalle->>'cantidad')::INTEGER
        FROM jsonb_array_elements(p_detalles) AS detalle
    LOOP
        -- Obtener el precio del producto
        SELECT precio INTO v_precio
        FROM productos
        WHERE producto_id = v_producto_id;

        -- Insertar detalle del pedido
        INSERT INTO detalles_pedidos (pedido_id, producto_id, cantidad, precio_total)
        VALUES (v_pedido_id, v_producto_id, v_cantidad, v_cantidad * v_precio);

        -- Actualizar el stock del producto
        UPDATE productos
        SET stock = stock - v_cantidad
        WHERE producto_id = v_producto_id;
    END LOOP;
END;
$$;


CALL realizar_pedido(1,'Procesando','2024-08-12 12:12:12','[{"producto_id": 1, "cantidad": 2}]'::jsonb);


-- Crear un procedimiento almacenado para insertar una nueva reseña

CREATE OR REPLACE PROCEDURE agregar_resena(
    p_cliente_id INTEGER,
    p_producto_id INTEGER,
    p_calificacion INTEGER,
    p_comentario TEXT,
    p_fecha_resena TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insertar la nueva reseña en la tabla reseñas
    INSERT INTO resenas (cliente_id, producto_id, calificacion, comentario, fecha_resena)
    VALUES (p_cliente_id, p_producto_id, p_calificacion, p_comentario, p_fecha_resena);
END;
$$;

CALL agregar_resena(1,2,5,'Excelente','2024-08-12 10:00:00');


-- Crear un procedimiento almacenado para obtener el producto con el menor stock

CREATE OR REPLACE PROCEDURE obtener_producto_menor_stock(
    OUT p_producto_id INTEGER,
    OUT p_nombre VARCHAR,
    OUT p_stock INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Consulta para seleccionar el producto con el menor stock
    SELECT 
        producto_id,
        nombre,
        stock
    INTO 
        p_producto_id,
        p_nombre,
        p_stock
    FROM 
        productos
    ORDER BY 
        stock ASC
    LIMIT 1;
END;
$$;


DO $$
DECLARE
    v_producto_id INTEGER;
    v_nombre VARCHAR;
    v_stock INTEGER;
BEGIN
    -- Llamar al procedimiento y capturar los resultados en las variables
    CALL obtener_producto_menor_stock(v_producto_id, v_nombre, v_stock);
    
    -- Mostrar los resultados
    RAISE NOTICE 'Producto con menor stock ID: %, Nombre: %, Stock: %', v_producto_id, v_nombre, v_stock;
END;
$$;




-- 5 funciones


-- Producto mas vendido 

CREATE OR REPLACE FUNCTION obtener_producto_mas_vendido()
RETURNS TABLE (
    producto_id INTEGER,
    nombre VARCHAR,
    total_vendido BIGINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.producto_id,
        p.nombre,
        SUM(dp.cantidad) AS total_vendido
    FROM 
        productos p
    JOIN 
        detalles_pedidos dp ON p.producto_id = dp.producto_id
    GROUP BY 
        p.producto_id, p.nombre
    ORDER BY 
        total_vendido DESC
    LIMIT 1;
END;
$$;


select  obtener_producto_mas_vendido();

-- Total ventas por fecha

CREATE OR REPLACE FUNCTION total_ventas_por_fecha(p_inicio TIMESTAMP, p_fin TIMESTAMP)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_ventas DECIMAL(10, 2);
BEGIN
    SELECT 
        SUM(dp.cantidad * dp.precio_total) 
    INTO 
        v_total_ventas
    FROM 
        pedidos p
    JOIN 
        detalles_pedidos dp ON p.pedido_id = dp.pedido_id
    WHERE 
        p.fecha_pedido BETWEEN p_inicio AND p_fin;
    
    RETURN v_total_ventas;
END;
$$;


select total_ventas_por_fecha('2023-08-08 10:00:00','2024-08-08 10:00:00');


-- Clientes con mayor gasto

CREATE OR REPLACE FUNCTION cliente_mayor_gasto()
RETURNS TABLE (
    cliente_id INTEGER,
    nombre_cliente TEXT,
    total_gasto DECIMAL(10, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.cliente_id,
        c.nombre || ' ' || c.apellido AS nombre_cliente,
        SUM(dp.cantidad * dp.precio_total) AS total_gasto
    FROM 
        clientes c
    JOIN 
        pedidos p ON c.cliente_id = p.cliente_id
    JOIN 
        detalles_pedidos dp ON p.pedido_id = dp.pedido_id
    GROUP BY 
        c.cliente_id, c.nombre, c.apellido
    ORDER BY 
        total_gasto DESC
    LIMIT 1;
END;
$$;

SELECT cliente_mayor_gasto();


-- Consultar producto con menor stock según parametro de cantidad menor a

CREATE OR REPLACE FUNCTION productos_bajo_stock(p_umbral INTEGER)
RETURNS TABLE (
    v_producto_id INTEGER,
    v_nombre VARCHAR,
    v_stock INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        producto_id,
        nombre,
        stock
    FROM 
        productos
    WHERE 
        stock < p_umbral;
END;
$$;

select productos_bajo_stock(11);


-- Obtener las ultimas reseñas de un producto enviando como parametro el di del producto y la cantidad de reseñas quye deseo ver 

CREATE OR REPLACE FUNCTION obtener_resenas_recientes(p_producto_id INTEGER, p_limite INTEGER)
RETURNS TABLE (
    resena_id INTEGER,
    cliente_id INTEGER,
    calificacion INTEGER,
    comentario TEXT,
    fecha_resena TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.resena_id,
        r.cliente_id,
        r.calificacion,
        r.comentario,
        r.fecha_resena
    FROM 
        resenas r
    WHERE 
        r.producto_id = p_producto_id
    ORDER BY 
        r.fecha_resena DESC
    LIMIT p_limite;
END;
$$;

select obtener_resenas_recientes(2,5);