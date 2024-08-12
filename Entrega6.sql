-- Crear tabla de Clientes
CREATE TABLE Clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion VARCHAR(100),
    telefono VARCHAR(20),
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de Categorías de Productos
CREATE TABLE Categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Crear tabla de Productos
CREATE TABLE Productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10, 2) CHECK (precio > 0),
    stock INTEGER CHECK (stock >= 0),
    categoria_id INT REFERENCES Categorias(categoria_id)
);

-- Crear tabla de Pedidos
CREATE TABLE Pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES Clientes(cliente_id),
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) CHECK (estado IN ('procesando', 'enviado', 'entregado')),
    precio_total NUMERIC(10, 2) CHECK (precio_total >= 0)
);

-- Crear tabla de Detalle de Pedidos
CREATE TABLE Detalle_Pedidos (
    detalle_id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES Pedidos(pedido_id),
    producto_id INT REFERENCES Productos(producto_id),
    cantidad INTEGER CHECK (cantidad > 0),
    precio NUMERIC(10, 2) CHECK (precio > 0)
);

-- Crear tabla de Reseñas
CREATE TABLE Resenas (
    reseña_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES Clientes(cliente_id),
    producto_id INT REFERENCES Productos(producto_id),
    calificacion INTEGER CHECK (calificacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha_resena TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de Lista de Deseos
CREATE TABLE Lista_Deseos (
    lista_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES Clientes(cliente_id),
    producto_id INT REFERENCES Productos(producto_id),
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Datos para las tablas
INSERT INTO Categorias (nombre)
VALUES 
('Electrónica'),
('Hogar'),
('Computación'),
('Móviles'),
('Gaming');

INSERT INTO Productos (nombre, descripcion, precio, stock, categoria_id)
VALUES
('Laptop Dell Inspiron', 'Laptop con procesador Intel Core i7', 800.00, 50, 3),
('iPhone 13', 'Teléfono inteligente de Apple', 999.99, 30, 4),
('Samsung TV 55"', 'Televisor 4K UHD', 600.00, 20, 1),
('Mouse Gamer Logitech', 'Mouse óptico para gaming', 50.00, 100, 5),
('Aspiradora Dyson', 'Aspiradora inalámbrica para el hogar', 400.00, 15, 2);


INSERT INTO Clientes (nombre, apellido, direccion, telefono, correo_electronico)
VALUES
('Juan', 'Pérez', 'Calle Falsa 123', '555-1234', 'juan.perez@example.com'),
('María', 'Gómez', 'Av. Siempre Viva 742', '555-5678', 'maria.gomez@example.com'),
('Carlos', 'López', 'Carrera 50 #20-30', '555-9101', 'carlos.lopez@example.com'),
('Ana', 'Martínez', 'Pasaje Luna 234', '555-1122', 'ana.martinez@example.com'),
('Luis', 'Rodríguez', 'Boulevard Sol 987', '555-3344', 'luis.rodriguez@example.com');

INSERT INTO Pedidos (cliente_id, estado, precio_total)
VALUES
(1, 'procesando', 1850.00),
(2, 'enviado', 999.99),
(3, 'entregado', 1050.00),
(4, 'procesando', 50.00),
(5, 'entregado', 400.00);

INSERT INTO Detalle_Pedidos (pedido_id, producto_id, cantidad, precio)
VALUES
(1, 1, 2, 1600.00),
(1, 4, 5, 250.00),
(2, 2, 1, 999.99),
(3, 3, 1, 600.00),
(3, 5, 1, 400.00),
(4, 4, 1, 50.00),
(5, 5, 1, 400.00);

INSERT INTO Resenas (cliente_id, producto_id, calificacion, comentario)
VALUES
(1, 1, 5, 'Excelente laptop, muy rápida y eficiente.'),
(2, 2, 4, 'Muy buen teléfono, pero un poco caro.'),
(3, 3, 5, 'Gran calidad de imagen, me encanta.'),
(4, 4, 3, 'El mouse es cómodo, pero podría ser más barato.'),
(5, 5, 5, 'La mejor aspiradora que he comprado.');

INSERT INTO Lista_Deseos (cliente_id, producto_id)
VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 5),
(4, 3),
(5, 4);


-- Consulta 1: Obtener el top 5 de productos más vendidos
SELECT p.nombre, SUM(dp.cantidad) AS total_vendidos
FROM Productos p
JOIN Detalle_Pedidos dp ON p.producto_id = dp.producto_id
GROUP BY p.nombre
ORDER BY total_vendidos DESC
LIMIT 5;

-- Consulta 2: Obtener el historial de pedidos de un cliente específico
SELECT p.pedido_id, p.fecha_pedido, p.estado, p.precio_total
FROM Pedidos p
WHERE p.cliente_id = 1;  -- Reemplazar con el cliente_id deseado

-- Consulta 3: Consultar las Resenas de un producto específico
SELECT r.calificacion, r.comentario, c.nombre, c.apellido
FROM Resenas r
JOIN Clientes c ON r.cliente_id = c.cliente_id
WHERE r.producto_id = 1;  -- Reemplazar con el producto_id deseado

-- Consulta 4: Verificar el stock disponible de un producto antes de comprar
SELECT nombre, stock
FROM Productos
WHERE producto_id = 1;  -- Reemplazar con el producto_id deseado

-- Consulta 5: Obtener la lista de deseos de un cliente específico
SELECT p.nombre, p.descripcion, p.precio
FROM Productos p
JOIN Lista_Deseos ld ON p.producto_id = ld.producto_id
WHERE ld.cliente_id = 1;  -- Reemplazar con el cliente_id deseado


-- Procedimiento 1: Crear un nuevo cliente
CREATE OR REPLACE PROCEDURE CrearCliente(
    nombre VARCHAR,
    apellido VARCHAR,
    direccion VARCHAR,
    telefono VARCHAR,
    correo_electronico VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Clientes (nombre, apellido, direccion, telefono, correo_electronico)
    VALUES (nombre, apellido, direccion, telefono, correo_electronico);
END;
$$;

-- Procedimiento 2: Crear un nuevo producto
CREATE OR REPLACE PROCEDURE CrearProducto(
    nombre VARCHAR,
    descripcion TEXT,
    precio NUMERIC,
    stock INTEGER,
    categoria_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Productos (nombre, descripcion, precio, stock, categoria_id)
    VALUES (nombre, descripcion, precio, stock, categoria_id);
END;
$$;

-- Procedimiento 3: Crear un nuevo pedido
CREATE OR REPLACE PROCEDURE CrearPedido(
    cliente_id INT,
    estado VARCHAR,
    precio_total NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Pedidos (cliente_id, estado, precio_total)
    VALUES (cliente_id, estado, precio_total);
END;
$$;

-- Procedimiento 4: Actualizar el stock de un producto después de una venta
CREATE OR REPLACE PROCEDURE ActualizarStock(
    producto_id INT,
    cantidad_vendida INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Productos
    SET stock = stock - cantidad_vendida
    WHERE producto_id = producto_id;
END;
$$;

-- Procedimiento 5: Crear una reseña para un producto
CREATE OR REPLACE PROCEDURE CrearReseña(
    cliente_id INT,
    producto_id INT,
    calificacion INT,
    comentario TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Resenas (cliente_id, producto_id, calificacion, comentario)
    VALUES (cliente_id, producto_id, calificacion, comentario);
END;
$$;


-- Función 1: Calcular el precio total de un pedido
CREATE OR REPLACE FUNCTION CalcularPrecioTotal(pedido_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total NUMERIC := 0;
BEGIN
    SELECT SUM(dp.precio * dp.cantidad) INTO total
    FROM Detalle_Pedidos dp
    WHERE dp.pedido_id = pedido_id;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- Función 2: Contar el número de productos en una categoría
CREATE OR REPLACE FUNCTION ContarProductosEnCategoria(categoria_id INT)
RETURNS INTEGER AS $$
DECLARE
    total_productos INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_productos
    FROM Productos
    WHERE categoria_id = categoria_id;
    RETURN total_productos;
END;
$$ LANGUAGE plpgsql;

-- Función 3: Obtener el promedio de calificación de un producto
CREATE OR REPLACE FUNCTION PromedioCalificacion(producto_id INT)
RETURNS NUMERIC AS $$
DECLARE
    promedio NUMERIC;
BEGIN
    SELECT AVG(calificacion) INTO promedio
    FROM Resenas
    WHERE producto_id = producto_id;
    RETURN promedio;
END;
$$ LANGUAGE plpgsql;

-- Función 4: Verificar si un producto está en la lista de deseos de un cliente
CREATE OR REPLACE FUNCTION EstaEnListaDeseos(cliente_id INT, producto_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    existe BOOLEAN;
BEGIN
    SELECT EXISTS(
        SELECT 1
        FROM Lista_Deseos
        WHERE cliente_id = cliente_id AND producto_id = producto_id
    ) INTO existe;
    RETURN existe;
END;
$$ LANGUAGE plpgsql;

-- Función 5: Obtener el total de pedidos realizados por un cliente
CREATE OR REPLACE FUNCTION TotalPedidosCliente(cliente_id INT)
RETURNS INTEGER AS $$
DECLARE
    total_pedidos INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_pedidos
    FROM Pedidos
    WHERE cliente_id = cliente_id;
    RETURN total_pedidos;
END;
$$ LANGUAGE plpgsql;

