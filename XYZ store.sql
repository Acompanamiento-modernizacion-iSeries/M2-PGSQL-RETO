-------------------------------Tablas---------------------------------

CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    correo_electronico VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200),
    precio NUMERIC CHECK(precio >= 0),
    stock INT CHECK(stock >= 0),
    tipo_producto VARCHAR (50) CHECK(tipo_producto in ('Electronico', 'Consumo'))
);

CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(cliente_id) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) CHECK (estado IN ('Procesando', 'Enviado', 'Entregado'))
);

CREATE TABLE Transacciones (
    transaccion_id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES pedidos(pedido_id) NOT NULL,
    producto_id INT REFERENCES productos(producto_id) NOT NULL,
    cantidad INT CHECK(cantidad >= 0),
    precio NUMERIC CHECK(precio >= 0)
);

CREATE TABLE reseñas (
    reseña_id SERIAL PRIMARY KEY,
    producto_id INT REFERENCES productos(producto_id) NOT NULL,
    cliente_id INT REFERENCES clientes(Cliente_id) NOT NULL,
    calificacion INT CHECK(calificacion BETWEEN 1 AND 5),
    comentario VARCHAR(500),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lista_deseos (
    deseo_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES clientes(Cliente_id) NOT NULL,
    producto_id INT REFERENCES productos(producto_id) NOT NULL
);
--------------------------------------------------------------------------------
-------------------------------Insertar registros-------------------------------
INSERT INTO clientes (nombre, apellido, direccion, telefono, correo_electronico)
VALUES
('Juan', 'Perez', 'Calle 123', '123456789', 'juan.perez@mail.com'),
('Maria', 'Gomez', 'Calle 456', '123456788', 'maria.gomez@mail.com'),
('Carlos', 'Rodriguez', 'Calle 789', '123456787', 'carlos.rodriguez@mail.com');

INSERT INTO productos (nombre, descripcion, precio, stock, tipo_producto)
VALUES
('Laptop', 'Laptop de última generación', 1500.00, 10, 'Electronico'),
('Smartphone', 'Smartphone con pantalla AMOLED', 800.00, 25, 'Electronico'),
('Auriculares', 'Auriculares inalámbricos con cancelación de ruido', 200.00, 50, 'Consumo');

INSERT INTO pedidos (cliente_id, fecha, estado)
VALUES
(1,'2024-08-11', 'Procesando'),
(2,'2024-08-12', 'Enviado'),
(3,'2024-08-13', 'Entregado');

INSERT INTO transacciones (pedido_id, producto_id, cantidad, precio)
VALUES
(1, 1, 1, 1500.00),
(1, 3, 2, 400.00),
(2, 2, 1, 800.00),
(3, 3, 3, 600.00);

INSERT INTO reseñas (producto_id, cliente_id, calificacion, comentario)
VALUES
(1, 1, 5, 'Excelente producto, muy rápido y eficiente.'),
(2, 2, 4, 'Buen smartphone, pero la batería podría durar más.'),
(3, 3, 5, 'Los auriculares son geniales, la cancelación de ruido funciona perfecto.');


INSERT INTO lista_deseos (cliente_id, producto_id)
VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 2);
--------------------------------------------------------------------------------
-------------------------------------Consultas----------------------------------
-- 1. Consultar 2 productos más vendidos
SELECT p.nombre, SUM(tr.cantidad) AS total_vendido
FROM productos p
JOIN Transacciones tr ON p.producto_id = tr.producto_id
GROUP BY p.producto_id
ORDER BY total_vendido DESC
LIMIT 2;

-- 2. Consultar los clientes con mas compras
SELECT c.nombre, c.apellido, COUNT(p.cliente_id) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id
ORDER BY total_pedidos DESC
LIMIT 2;

-- 3. Consultar el inventario productos
SELECT nombre, stock
FROM productos
ORDER BY stock DESC;

-- 4. Consultar las reseñas de un producto 
SELECT c.nombre, c.apellido, r.calificacion, r.comentario, r.fecha
FROM reseñas r
JOIN clientes c ON r.cliente_id = c.cliente_id
WHERE r.producto_id = 1
ORDER BY r.fecha DESC;

-- 5. Consultar los pedidos realizados en un periodo 
SELECT p.cliente_id, p.fecha, p.estado, c.nombre, c.apellido
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id
WHERE p.fecha BETWEEN '2024-08-09' AND '2024-08-11'
ORDER BY p.fecha DESC;

--------------------------------------------------------------------------------
-----------------------------Procedimientos-------------------------------------
-- 1. Agregar un producto al inventario
CREATE OR REPLACE PROCEDURE agregarproducto(
    nombre VARCHAR, 
	descripcion VARCHAR, 
	precio NUMERIC,
	stock INT, 
	tipoproducto VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO productos (nombre, descripcion, precio, stock, tipo_producto)
    VALUES (nombre, descripcion, precio, stock, tipoproducto);
END;
$$;

Call agregarproducto('Cable HDMI','Cable de alta tecnologia, 2mts largo', 210.00, 40, 'Consumo')

-- 2. Actualizar el stock de un producto
CREATE OR REPLACE PROCEDURE actualizarstock(
	productoid INT, 
	nuevostock INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE productos
    SET stock = nuevostock
    WHERE producto_id = productoid;
END;
$$;

Call actualizarstock(1, 15);

-- 3. Generar un reporte de transacciones en un rango de fechas
CREATE OR REPLACE PROCEDURE generarreportetx(
	fechainicio TIMESTAMP, 
	fechafin TIMESTAMP
)
LANGUAGE plpgsql
AS $$

DECLARE
	transaccion RECORD;
BEGIN
    FOR transaccion IN
        SELECT p.pedido_id, p.cliente_id, tr.producto_id, tr.precio, p.estado, p.fecha
        FROM pedidos p
		JOIN transacciones tr on tr.pedido_id = p.pedido_id
        WHERE fecha BETWEEN fechainicio AND fechafin
    LOOP
        RAISE NOTICE 'ID: %, cliente: %, producto: %, precio: %, estado: %, Fecha: %',
            transaccion.pedido_id, transaccion.cliente_id, transaccion.producto_id, transaccion.precio, transaccion.estado, transaccion.fecha;
    END LOOP;
END;
$$;

Call generarreportetx('2024-07-09','2024-09-10');

-- 5. Procedimiento para agregar un producto a la lista de deseos
CREATE OR REPLACE PROCEDURE agregar_a_lista_deseos(cliente_id INT, producto_id INT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lista_deseos (cliente_id, producto_id)
    VALUES (cliente_id, producto_id);
END;
$$;

--------------------------------------------------------------------------------
-------------------------------FUNCIONES----------------------------------------

-- 1. Obtener detalles del pedido
CREATE OR REPLACE FUNCTION obtener_detalles_pedido(pedido_id INT)
RETURNS TABLE (
    cliente_id INT,
    nombre_cliente VARCHAR,
    apellido_cliente VARCHAR,
    direccion_cliente VARCHAR,
    telefono_cliente VARCHAR,
    correo_cliente VARCHAR,
    producto_id INT,
    nombre_producto VARCHAR,
    cantidad INT,
    precio NUMERIC,
    fecha_pedido TIMESTAMP,
    estado_pedido VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT c.cliente_id, c.nombre, c.apellido, c.direccion, c.telefono, c.correo_electronico,
           p.producto_id, p.nombre, t.cantidad, t.precio, pe.fecha, pe.estado
    FROM pedidos pe
    JOIN clientes c ON pe.cliente_id = c.cliente_id
    JOIN transacciones t ON pe.pedido_id = t.pedido_id
    JOIN productos p ON t.producto_id = p.producto_id
    WHERE pe.pedido_id = pedido_id;
END; $$
LANGUAGE plpgsql;

-- 2. Calcular total de ventas en un período
CREATE OR REPLACE FUNCTION calcular_total_ventas(fecha_inicio TIMESTAMP, fecha_fin TIMESTAMP)
RETURNS NUMERIC AS $$
DECLARE
    total_ventas NUMERIC;
BEGIN
    SELECT SUM(t.precio * t.cantidad) INTO total_ventas
    FROM transacciones t
    JOIN pedidos p ON t.pedido_id = p.pedido_id
    WHERE p.fecha BETWEEN fecha_inicio AND fecha_fin;

    RETURN total_ventas;
END; $$
LANGUAGE plpgsql;

--3. Valida el cliente con mas pedidos
CREATE OR REPLACE FUNCTION obtener_cliente_con_mas_pedidos()
RETURNS TABLE (
    cliente_id INT,
    nombre_cliente VARCHAR,
    apellido_cliente VARCHAR,
    total_pedidos INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT c.cliente_id, c.nombre, c.apellido, COUNT(p.pedido_id) AS total_pedidos
    FROM clientes c
    JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nombre, c.apellido
    ORDER BY total_pedidos DESC
    LIMIT 1;
END; $$
LANGUAGE plpgsql;

--4. valida disponibilidad del producto
CREATE OR REPLACE FUNCTION verificar_disponibilidad_producto(producto_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    stock_actual INT;
BEGIN
    SELECT stock INTO stock_actual
    FROM productos
    WHERE producto_id = producto_id;

    RETURN stock_actual > 0;
END; $$
LANGUAGE plpgsql;

-- 5. Obtener reseñas del producto
CREATE OR REPLACE FUNCTION obtener_reseñas_producto(producto_id INT)
RETURNS TABLE (
    reseña_id INT,
    cliente_id INT,
    nombre_cliente VARCHAR,
    apellido_cliente VARCHAR,
    calificacion INT,
    comentario VARCHAR,
    fecha TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT r.reseña_id, r.cliente_id, c.nombre, c.apellido, r.calificacion, r.comentario, r.fecha
    FROM reseñas r
    JOIN clientes c ON r.cliente_id = c.cliente_id
    WHERE r.producto_id = producto_id
    ORDER BY r.fecha DESC;
END; $$
LANGUAGE plpgsql;
--------------------------------------------------------------------------------