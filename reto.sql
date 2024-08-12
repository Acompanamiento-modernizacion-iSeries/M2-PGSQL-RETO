--Taller nro 5 reto, CAMILO ANDRES GARCIA CRUZ
-- Tabla Clientes
CREATE TABLE Clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Productos
CREATE TABLE Productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    categoria VARCHAR(50)
);

-- Tabla Pedidos
CREATE TABLE Pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    precio_total DECIMAL(10, 2) NOT NULL,
    estado VARCHAR(20) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

-- Tabla Detalles de Pedido
CREATE TABLE DetallesPedido (
    detalle_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);

-- Tabla Reseñas
CREATE TABLE Reseñas (
    reseña_id SERIAL PRIMARY KEY,
    producto_id INT NOT NULL,
    cliente_id INT NOT NULL,
    calificacion INT CHECK (calificacion >= 1 AND calificacion <= 5),
    comentario TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id)
);

-- Tabla Lista de Deseos
CREATE TABLE ListaDeseos (
    lista_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    FOREIGN KEY (producto_id) REFERENCES Productos(producto_id)
);



-- Insertar datos en la tabla Clientes
INSERT INTO Clientes (nombre, apellido, direccion, telefono, correo_electronico)
VALUES
('Juan', 'Perez', 'Calle 123', '123456789', 'juan.perez@example.com'),
('Maria', 'Gomez', 'Avenida 456', '987654321', 'maria.gomez@example.com');

-- Insertar datos en la tabla Productos
INSERT INTO Productos (nombre, descripcion, precio, stock, categoria)
VALUES
('Laptop', 'Laptop de alta gama', 1500.00, 10, 'Electrónica'),
('Smartphone', 'Smartphone con gran capacidad', 800.00, 20, 'Electrónica');

-- Insertar datos en la tabla Pedidos
INSERT INTO Pedidos (cliente_id, precio_total, estado)
VALUES
(1, 2300.00, 'procesando'),
(2, 800.00, 'enviado');

-- Insertar datos en la tabla DetallesPedido
INSERT INTO DetallesPedido (pedido_id, producto_id, cantidad, precio)
VALUES
(1, 1, 1, 1500.00),
(1, 2, 1, 800.00),
(2, 2, 1, 800.00);

-- Insertar datos en la tabla Reseñas
INSERT INTO Reseñas (producto_id, cliente_id, calificacion, comentario)
VALUES
(1, 1, 5, 'Excelente producto'),
(2, 2, 4, 'Muy buen smartphone');

-- Insertar datos en la tabla ListaDeseos
INSERT INTO ListaDeseos (cliente_id, producto_id)
VALUES
(1, 2),
(2, 1);


-- Consulta 1: Obtener el total de ventas por producto
SELECT p.nombre, SUM(dp.cantidad) AS total_vendido
FROM Productos p
JOIN DetallesPedido dp ON p.producto_id = dp.producto_id
GROUP BY p.nombre
ORDER BY total_vendido DESC;

-- Consulta 2: Listar los productos más vendidos
SELECT p.nombre, COUNT(dp.producto_id) AS cantidad_vendida
FROM Productos p
JOIN DetallesPedido dp ON p.producto_id = dp.producto_id
GROUP BY p.nombre
ORDER BY cantidad_vendida DESC
LIMIT 10;

-- Consulta 3: Obtener el historial de pedidos de un cliente específico
SELECT pe.pedido_id, pe.fecha_pedido, pe.precio_total, pe.estado
FROM Pedidos pe
JOIN Clientes c ON pe.cliente_id = c.cliente_id
WHERE c.correo_electronico = 'juan.perez@example.com'
ORDER BY pe.fecha_pedido DESC;

-- Consulta 4: Listar las reseñas de un producto específico
SELECT r.calificacion, r.comentario, r.fecha, c.nombre, c.apellido
FROM Reseñas r
JOIN Clientes c ON r.cliente_id = c.cliente_id
WHERE r.producto_id = 1
ORDER BY r.fecha DESC;

-- Consulta 5: Obtener la lista de deseos de un cliente específico
SELECT p.nombre, p.descripcion, p.precio, ld.fecha_agregado
FROM ListaDeseos ld
JOIN Productos p ON ld.producto_id = p.producto_id
JOIN Clientes c ON ld.cliente_id = c.cliente_id
WHERE c.correo_electronico = 'maria.gomez@example.com'
ORDER BY ld.fecha_agregado DESC;



-- Procedure 1: Obtener el total de ventas por producto
CREATE OR REPLACE PROCEDURE obtener_total_ventas_por_producto()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT p.nombre, SUM(dp.cantidad) AS total_vendido
        FROM Productos p
        JOIN DetallesPedido dp ON p.producto_id = dp.producto_id
        GROUP BY p.nombre
        ORDER BY total_vendido DESC
    LOOP
        RAISE NOTICE 'Nombre: %, Total Vendido: %', rec.nombre, rec.total_vendido;
    END LOOP;
END;
$$;

CALL obtener_total_ventas_por_producto();

-- Procedure 2: Listar los productos más vendidos
CREATE OR REPLACE PROCEDURE listar_productos_mas_vendidos()
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT p.nombre, SUM(dp.cantidad) AS total_vendido
        FROM Productos p
        JOIN DetallesPedido dp ON p.producto_id = dp.producto_id
        GROUP BY p.nombre
        ORDER BY total_vendido DESC
    LOOP
        RAISE NOTICE 'Nombre: %, Total Vendido: %', rec.nombre, rec.total_vendido;
    END LOOP;
END;
$$;

CALL listar_productos_mas_vendidos();

-- Procedure 3: Obtener el historial de pedidos de un cliente específico
CREATE OR REPLACE PROCEDURE obtener_historial_pedidos_cliente(docCliente VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT pe.pedido_id, pe.fecha_pedido, pe.precio_total, pe.estado
        FROM Pedidos pe
        JOIN Clientes c ON pe.cliente_id = c.cliente_id
        WHERE c.correo_electronico = docCliente
        ORDER BY pe.fecha_pedido DESC
    LOOP
        RAISE NOTICE 'Pedido ID: %, Fecha: %, Precio Total: %, Estado: %', rec.pedido_id, rec.fecha_pedido, rec.precio_total, rec.estado;
    END LOOP;
END;
$$;

CALL obtener_historial_pedidos_cliente('juan.perez@example.com');

-- Procedure 4: listar reseña producto
CREATE OR REPLACE PROCEDURE listar_reseñas_producto(p_producto_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT r.calificacion, r.comentario, r.fecha, c.nombre, c.apellido
        FROM Reseñas r
        JOIN Clientes c ON r.cliente_id = c.cliente_id
        WHERE r.producto_id = p_producto_id
        ORDER BY r.fecha DESC
    LOOP
        RAISE NOTICE 'Calificación: %, Comentario: %, Fecha: %, Nombre: %, Apellido: %', rec.calificacion, rec.comentario, rec.fecha, rec.nombre, rec.apellido;
    END LOOP;
END;
$$;

CALL listar_reseñas_producto(2);

-- Procedure 5: Obtener la lista de deseos de un cliente específico
CREATE OR REPLACE PROCEDURE obtener_lista_deseos_cliente(docCliente VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT p.nombre, p.descripcion, p.precio, ld.fecha_agregado
        FROM ListaDeseos ld
        JOIN Productos p ON ld.producto_id = p.producto_id
        JOIN Clientes c ON ld.cliente_id = c.cliente_id
        WHERE c.correo_electronico = docCliente
        ORDER BY ld.fecha_agregado DESC
    LOOP
        RAISE NOTICE 'Nombre: %, Descripción: %, Precio: %, Fecha Agregado: %', rec.nombre, rec.descripcion, rec.precio, rec.fecha_agregado;
    END LOOP;
END;
$$;

CALL obtener_lista_deseos_cliente('maria.gomez@example.com');



-- Function 1: Obtener el total de ventas por cliente
CREATE OR REPLACE FUNCTION obtener_total_ventas_por_cliente()
RETURNS TABLE(nombre VARCHAR, apellido VARCHAR, total_ventas NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT c.nombre, c.apellido, SUM(dp.cantidad * dp.precio) AS total_ventas
        FROM Clientes c
        JOIN Pedidos pe ON c.cliente_id = pe.cliente_id
        JOIN DetallesPedido dp ON pe.pedido_id = dp.pedido_id
        GROUP BY c.nombre, c.apellido
        ORDER BY total_ventas DESC;
END;
$$;

SELECT * FROM obtener_total_ventas_por_cliente();

-- Function 2: Obtener los productos más vendidos
CREATE OR REPLACE FUNCTION obtener_productos_mas_vendidos()
RETURNS TABLE(nombre VARCHAR, total_vendido BIGINT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT p.nombre, SUM(dp.cantidad) AS total_vendido
        FROM Productos p
        JOIN DetallesPedido dp ON p.producto_id = dp.producto_id
        GROUP BY p.nombre
        ORDER BY total_vendido DESC;
END;
$$;

SELECT * FROM obtener_productos_mas_vendidos();

-- Function 3: Obtener el historial de reseñas de un cliente
CREATE OR REPLACE FUNCTION obtener_historial_reseñas_cliente(docCliente VARCHAR)
RETURNS TABLE(calificacion INT, comentario TEXT, fecha TIMESTAMP, producto VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT r.calificacion, r.comentario, r.fecha, p.nombre AS producto
        FROM Reseñas r
        JOIN Clientes c ON r.cliente_id = c.cliente_id
        JOIN Productos p ON r.producto_id = p.producto_id
        WHERE c.correo_electronico = docCliente
        ORDER BY r.fecha DESC;
END;
$$;

SELECT * FROM obtener_historial_reseñas_cliente('maria.gomez@example.com');

-- Function 4: Obtener los productos en la lista de deseos de un cliente
CREATE OR REPLACE FUNCTION obtener_productos_lista_deseos_cliente(docCliente VARCHAR)
RETURNS TABLE(nombre VARCHAR, descripcion TEXT, precio NUMERIC, fecha_agregado TIMESTAMP)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT p.nombre, p.descripcion, p.precio, ld.fecha_agregado
        FROM ListaDeseos ld
        JOIN Productos p ON ld.producto_id = p.producto_id
        JOIN Clientes c ON ld.cliente_id = c.cliente_id
        WHERE c.correo_electronico = docCliente
        ORDER BY ld.fecha_agregado DESC;
END;
$$;

SELECT * FROM obtener_productos_lista_deseos_cliente('maria.gomez@example.com');

-- Function 5: Obtener el total de pedidos por estado
CREATE OR REPLACE FUNCTION obtener_total_pedidos_por_estado()
RETURNS TABLE(estado VARCHAR, total_pedidos BIGINT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT pe.estado, COUNT(*) AS total_pedidos
        FROM Pedidos pe
        GROUP BY pe.estado
        ORDER BY total_pedidos DESC;
END;
$$;

SELECT * FROM obtener_total_pedidos_por_estado();
