-- Tabla de Clientes
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(20),
    correo_electronico VARCHAR(150) UNIQUE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT NOW()
);

-- Tabla de Categorías de Productos
CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla de Productos
CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    categoria_id INT REFERENCES categorias(categoria_id) ON DELETE SET NULL
);

-- Tabla de Pedidos
CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id) ON DELETE CASCADE,
    fecha_pedido TIMESTAMP DEFAULT NOW(),
    precio_total DECIMAL(10, 2) NOT NULL,
    estado VARCHAR(50) NOT NULL CHECK (estado IN ('Procesando', 'Enviado', 'Entregado'))
);

-- Tabla de Detalles del Pedido (productos en cada pedido)
CREATE TABLE detalle_pedidos (
    detalle_pedido_id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES pedidos(pedido_id) ON DELETE CASCADE,
    producto_id INT REFERENCES productos(producto_id) ON DELETE CASCADE,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL
);

-- Tabla de Resenas de Productos
CREATE TABLE resenas (
    resena_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id) ON DELETE CASCADE,
    producto_id INT REFERENCES productos(producto_id) ON DELETE CASCADE,
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha TIMESTAMP DEFAULT NOW()
);

-- Tabla de Lista de Deseos
CREATE TABLE lista_deseos (
    lista_deseos_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id) ON DELETE CASCADE
);

-- Tabla de Productos en la Lista de Deseos
CREATE TABLE productos_lista_deseos (
    lista_deseos_id INT REFERENCES lista_deseos(lista_deseos_id) ON DELETE CASCADE,
    producto_id INT REFERENCES productos(producto_id) ON DELETE CASCADE,
    PRIMARY KEY (lista_deseos_id, producto_id)
);

-- Actualización de stock en cada venta
CREATE OR REPLACE FUNCTION actualizar_stock() RETURNS TRIGGER AS $$
BEGIN
    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE producto_id = NEW.producto_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar el stock tras insertar en detalle_pedidos
CREATE TRIGGER trigger_actualizar_stock
AFTER INSERT ON detalle_pedidos
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock();

-- Índices para mejorar la búsqueda por cliente y fecha de pedido
CREATE INDEX idx_pedidos_cliente_fecha ON pedidos(cliente_id, fecha_pedido);
CREATE INDEX idx_resenas_producto_fecha ON resenas(producto_id, fecha);

--5 Consultas
--1 Consulta Ventas mensuales por categoría de producto
SELECT c.nombre AS categoria, 
       EXTRACT(MONTH FROM p.fecha_pedido) AS mes, 
       SUM(dp.cantidad * dp.precio_unitario) AS total_ventas
FROM pedidos p
JOIN detalle_pedidos dp ON p.pedido_id = dp.pedido_id
JOIN productos pr ON dp.producto_id = pr.producto_id
JOIN categorias c ON pr.categoria_id = c.categoria_id
WHERE EXTRACT(YEAR FROM p.fecha_pedido) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY c.nombre, EXTRACT(MONTH FROM p.fecha_pedido)
ORDER BY c.nombre, mes;


--2 Cosulta Clientes con más pedidos realizados en el último ano
SELECT c.nombre, c.apellido, COUNT(p.pedido_id) AS cantidad_pedidos
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.fecha_pedido >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY c.nombre, c.apellido
ORDER BY cantidad_pedidos DESC
LIMIT 10;

-- 3 Consulta Productos más vendidos en el último trimestre
SELECT pr.nombre AS producto, SUM(dp.cantidad) AS total_vendido
FROM productos pr
JOIN detalle_pedidos dp ON pr.producto_id = dp.producto_id
JOIN pedidos p ON dp.pedido_id = p.pedido_id
WHERE p.fecha_pedido >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY pr.nombre
ORDER BY total_vendido DESC
LIMIT 10;


--4 Consulta Promedio de calificaciones por categoría de producto
SELECT c.nombre AS categoria, 
       AVG(r.calificacion) AS promedio_calificacion
FROM productos pr
JOIN categorias c ON pr.categoria_id = c.categoria_id
JOIN resenas r ON pr.producto_id = r.producto_id
GROUP BY c.nombre
ORDER BY promedio_calificacion DESC;


--5 Consulta Clientes con mayor gasto total en el último ano
SELECT c.nombre, c.apellido, SUM(dp.cantidad * dp.precio_unitario) AS gasto_total
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
JOIN detalle_pedidos dp ON p.pedido_id = dp.pedido_id
WHERE p.fecha_pedido >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY c.nombre, c.apellido
ORDER BY gasto_total DESC
LIMIT 10;


--5 Procedimientos Almacenados

-- 1 Proc Generar reporte de ventas totales por categoría en un período
CREATE OR REPLACE PROCEDURE reporte_ventas_categoria(fecha_inicio DATE, fecha_fin DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT c.nombre AS categoria, 
           SUM(dp.cantidad * dp.precio_unitario) AS total_ventas
    FROM productos pr
    JOIN categorias c ON pr.categoria_id = c.categoria_id
    JOIN detalle_pedidos dp ON pr.producto_id = dp.producto_id
    JOIN pedidos p ON dp.pedido_id = p.pedido_id
    WHERE p.fecha_pedido BETWEEN fecha_inicio AND fecha_fin
    GROUP BY c.nombre
    ORDER BY total_ventas DESC;
END;
$$;


--2 Proc Calcular las ventas mensuales por cliente en el último ano
CREATE OR REPLACE PROCEDURE ventas_mensuales_por_cliente()
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT c.nombre, c.apellido, 
           EXTRACT(MONTH FROM p.fecha_pedido) AS mes, 
           SUM(dp.cantidad * dp.precio_unitario) AS total_ventas
    FROM clientes c
    JOIN pedidos p ON c.cliente_id = p.cliente_id
    JOIN detalle_pedidos dp ON p.pedido_id = dp.pedido_id
    WHERE p.fecha_pedido >= CURRENT_DATE - INTERVAL '1 year'
    GROUP BY c.nombre, c.apellido, EXTRACT(MONTH FROM p.fecha_pedido)
    ORDER BY c.nombre, mes;
END;
$$;

--3 Proc Actualizar el stock de productos vendidos en un período
CREATE OR REPLACE PROCEDURE actualizar_stock_periodo(fecha_inicio DATE, fecha_fin DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE productos pr
    SET stock = stock - (
        SELECT SUM(dp.cantidad)
        FROM detalle_pedidos dp
        JOIN pedidos p ON dp.pedido_id = p.pedido_id
        WHERE dp.producto_id = pr.producto_id
        AND p.fecha_pedido BETWEEN fecha_inicio AND fecha_fin
    )
    WHERE pr.producto_id IN (
        SELECT dp.producto_id
        FROM detalle_pedidos dp
        JOIN pedidos p ON dp.pedido_id = p.pedido_id
        WHERE p.fecha_pedido BETWEEN fecha_inicio AND fecha_fin
    );
END;
$$;


--4 Proc Calcular el promedio de ventas diarias en un período
CREATE OR REPLACE PROCEDURE promedio_ventas_diarias(fecha_inicio DATE, fecha_fin DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT AVG(total_diario) AS promedio_ventas_diarias
    FROM (
        SELECT SUM(dp.cantidad * dp.precio_unitario) AS total_diario
        FROM pedidos p
        JOIN detalle_pedidos dp ON p.pedido_id = dp.pedido_id
        WHERE p.fecha_pedido BETWEEN fecha_inicio AND fecha_fin
        GROUP BY DATE(p.fecha_pedido)
    ) AS ventas_diarias;
END;
$$;


--5 Proc Reporte de productos más vendidos y su stock restante en un período
CREATE OR REPLACE PROCEDURE reporte_productos_vendidos_stock(fecha_inicio DATE, fecha_fin DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT pr.nombre AS producto, 
           SUM(dp.cantidad) AS total_vendido, 
           pr.stock
    FROM productos pr
    JOIN detalle_pedidos dp ON pr.producto_id = dp.producto_id
    JOIN pedidos p ON dp.pedido_id = p.pedido_id
    WHERE p.fecha_pedido BETWEEN fecha_inicio AND fecha_fin
    GROUP BY pr.nombre, pr.stock
    ORDER BY total_vendido DESC;
END;
$$;

--5 Funciones

--1 Func Función para calcular el total de gasto de un cliente en el último ano
CREATE OR REPLACE FUNCTION gasto_total_cliente(cliente_id INT) RETURNS DECIMAL AS $$
DECLARE
    total_gasto DECIMAL;
BEGIN
    SELECT SUM(dp.cantidad * dp.precio_unitario) INTO total_gasto
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.pedido_id = dp.pedido_id
    WHERE p.cliente_id = cliente_id
    AND p.fecha_pedido >= CURRENT_DATE - INTERVAL '1 year';
    RETURN COALESCE(total_gasto, 0);
END;
$$ LANGUAGE plpgsql;


--2 Func Función para obtener el stock restante de un producto específico
CREATE OR REPLACE FUNCTION stock_restante_producto(producto_id INT) RETURNS INT AS $$
DECLARE
    stock INT;
BEGIN
    SELECT pr.stock INTO stock
    FROM productos pr
    WHERE pr.producto_id = producto_id;
    RETURN stock;
END;
$$ LANGUAGE plpgsql;


--3 Función para calcular el promedio de calificación de un producto
CREATE OR REPLACE FUNCTION promedio_calificacion_producto(producto_id INT) RETURNS DECIMAL AS $$
DECLARE
    promedio DECIMAL;
BEGIN
    SELECT AVG(r.calificacion) INTO promedio
    FROM resenas r
    WHERE r.producto_id = producto_id;
    RETURN COALESCE(promedio, 0);
END;
$$ LANGUAGE plpgsql;


--4 Func Función para obtener el número de productos en la lista de deseos de un cliente
CREATE OR REPLACE FUNCTION productos_en_lista_deseos(cliente_id INT) RETURNS INT AS $$
DECLARE
    total_productos INT;
BEGIN
    SELECT COUNT(*) INTO total_productos
    FROM productos_lista_deseos pld
    JOIN lista_deseos ld ON pld.lista_deseos_id = ld.lista_deseos_id
    WHERE ld.cliente_id = cliente_id;
    RETURN total_productos;
END;
$$ LANGUAGE plpgsql;


--5 Func Función para calcular el ingreso total de ventas en un rango de fechas
CREATE OR REPLACE FUNCTION ingreso_total_ventas(fecha_inicio DATE, fecha_fin DATE) 
RETURNS DECIMAL AS $$
DECLARE
    total_ingreso DECIMAL;
BEGIN
    SELECT SUM(dp.cantidad * dp.precio_unitario) 
    INTO total_ingreso
    FROM detalle_pedidos dp
    JOIN pedidos p ON dp.pedido_id = p.pedido_id
    WHERE p.fecha_pedido BETWEEN fecha_inicio AND fecha_fin;
    
    RETURN COALESCE(total_ingreso, 0);  -- Devuelve 0 si no hay ventas en el período
END;
$$ LANGUAGE plpgsql;