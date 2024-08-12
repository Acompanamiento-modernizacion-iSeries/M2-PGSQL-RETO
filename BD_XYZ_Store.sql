-- Database: XYZ_Store

CREATE DATABASE "XYZ_Store"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Colombia.1252'
    LC_CTYPE = 'Spanish_Colombia.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
-- Create Table:

CREATE TABLE Productos (
	producto_id SERIAL PRIMARY KEY,
	nombre_producto VARCHAR (50) UNIQUE NOT NULL,
	descripcion VARCHAR (50) NOT NULL,
	precio NUMERIC (15,2) NOT NULL, 
	stock INTEGER NOT NULL,
	categoria VARCHAR (50)
);

CREATE TABLE Clientes (
	cliente_id SERIAL PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	apellido VARCHAR (50) NOT NULL,
	direccion VARCHAR (100) NOT NULL,
	telefono VARCHAR (20) NOT NULL,
	correo_electronico VARCHAR (200) UNIQUE NOT NULL,
	fecha_registro TIMESTAMP NOT NULL
);

CREATE TABLE Resenas (
	resena_id SERIAL PRIMARY KEY,
	calificacion INTEGER NOT NULL,
	comentario VARCHAR (100) NOT NULL,
	direccion VARCHAR (100) NOT NULL,
	fecha_resena TIMESTAMP NOT NULL,
	cliente_id INTEGER REFERENCES Clientes(cliente_id),
	producto_id INTEGER REFERENCES Productos(producto_id)
);

CREATE TABLE Carro_Compras (
	carro_compra_id SERIAL PRIMARY KEY,
	cliente_id INTEGER REFERENCES Clientes(cliente_id),
	estado VARCHAR (20) NOT NULL CHECK (estado IN ('ACTIVA', 'CONFIRMADA'))
);

CREATE TABLE Pedidos (
	pedido_id SERIAL PRIMARY KEY,
	cantidad_total INTEGER NOT NULL,
	precio_total NUMERIC (15,2) NOT NULL,
	estado VARCHAR (20) NOT NULL CHECK (estado IN ('PROCESANDO', 'ENVIADO', 'ENTREGADO')),
	fecha_pedido TIMESTAMP NOT NULL,
	cliente_id INTEGER REFERENCES Clientes(cliente_id),
	carro_compra_id INTEGER REFERENCES Carro_Compras(carro_compra_id)
);

CREATE TABLE Transacciones (
	transaccion_id SERIAL PRIMARY KEY,
	pedido_id INTEGER REFERENCES Pedidos(pedido_id),
	estado VARCHAR (20) NOT NULL CHECK (estado IN ('EN PROCESO', 'PAGADO'))
);

CREATE TABLE Deseos (
	deseo_id SERIAL PRIMARY KEY,
	producto_id INTEGER REFERENCES Productos(producto_id),
	cliente_id INTEGER REFERENCES Clientes(cliente_id)
);

CREATE TABLE Productos_Carro_Compras (
	producto_carro_compra_id SERIAL PRIMARY KEY,
	producto_id INTEGER REFERENCES Productos(producto_id),
	carro_compra_id INTEGER REFERENCES carro_compras(carro_compra_id),
	cantidad INTEGER NOT NULL
);


INSERT INTO Productos (nombre_producto, descripcion, precio, stock, categoria) VALUES
('Producto A', 'Descripción del Producto A', 10990, 100, 'Categoría 1'),
('Producto B', 'Descripción del Producto B', 15500, 200, 'Categoría 2'),
('Producto C', 'Descripción del Producto C', 7250, 150, 'Categoría 1'),
('Producto D', 'Descripción del Producto D', 20000, 80, 'Categoría 3'),
('Producto E', 'Descripción del Producto E', 5990, 300, 'Categoría 2'),
('Producto F', 'Descripción del Producto F', 12490, 60, 'Categoría 1'),
('Producto G', 'Descripción del Producto G', 8750, 90, 'Categoría 3'),
('Producto H', 'Descripción del Producto H', 14990, 120, 'Categoría 2'),
('Producto I', 'Descripción del Producto I', 9500, 110, 'Categoría 1'),
('Producto J', 'Descripción del Producto J', 18000, 70, 'Categoría 3');

INSERT INTO Clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro) VALUES
('Juan', 'Pérez', 'Calle Falsa 123', '555-1234', 'juan.perez@example.com', NOW()),
('Ana', 'Gómez', 'Avenida Siempre Viva 742', '555-5678', 'ana.gomez@example.com', NOW()),
('Luis', 'Martínez', 'Boulevard de los Sueños Rotos 456', '555-8765', 'luis.martinez@example.com', NOW()),
('María', 'López', 'Calle de la Amargura 789', '555-4321', 'maria.lopez@example.com', NOW()),
('Carlos', 'Sánchez', 'Plaza Mayor s/n ', '555-9876', 'carlos.sanchez@example.com', NOW()),
('Laura', 'Torres', 'Calle del Sol 1010', '555-6543', 'laura.torres@example.com', NOW()),
('Jorge', 'Ramírez', 'Avenida Libertad 2020', '555-3210', 'jorge.ramirez@example.com', NOW()),
('Patricia', 'Díaz', 'Calle de la Paz 3030', '555-1111', 'patricia.diaz@example.com', NOW()),
('Fernando', 'Ruiz', 'Calle del Río 4040', '555-2222', 'fernando.ruiz@example.com', NOW()),
('Sofía', 'Morales', 'Calle de las Flores 5050','555-3333','sofia.morales@example.com' ,NOW());

INSERT INTO Resenas (calificacion, comentario, direccion, fecha_resena, cliente_id, producto_id) VALUES
(5, 'Excelente producto, lo recomiendo.', 'Calle Falsa 123', NOW(), 1, 1),
(4, 'Muy bueno, aunque podría mejorar.', 'Avenida Siempre Viva 742', NOW(), 2, 2),
(3, 'Cumple su función pero no es lo que esperaba.', 'Boulevard de los Sueños Rotos 456', NOW(), 3, 3),
(2, 'No estoy satisfecho con la calidad.', 'Calle de la Amargura 789', NOW(), 4, 4),
(1, 'Definitivamente no lo volvería a comprar.', 'Plaza Mayor s/n', NOW(), 5, 5),
(4, 'Buen producto por el precio.', 'Calle del Sol 1010', NOW(), 6, 6),
(5, 'Me encantó! Volveré a comprar.', 'Avenida Libertad 2020', NOW(), 7, 7),
(3, 'Está bien pero esperaba más.', 'Calle de la Paz 3030', NOW(), 8, 8),
(4, 'Satisfecho con mi compra.', 'Calle del Río 4040', NOW(), 9, 9),
(2, 'No cumplió mis expectativas.', 'Calle de las Flores 5050', NOW(), 10, 10);


INSERT INTO Carro_Compras (cliente_id, estado) VALUES
(1, 'ACTIVA'),      
(2, 'ACTIVA'),      
(3, 'CONFIRMADA'),  
(4, 'ACTIVA'),      
(5, 'CONFIRMADA'),  
(6, 'ACTIVA'),     
(7, 'CONFIRMADA'),  
(8, 'ACTIVA'),      
(9, 'CONFIRMADA'),  
(10, 'ACTIVA');    

INSERT INTO Pedidos (cantidad_total, precio_total, estado, fecha_pedido, cliente_id, carro_compra_id) VALUES
(3, 150.00, 'PROCESANDO', NOW(), 1, 1), 
(1, 75.50, 'ENVIADO', NOW(), 2, 2),      
(5, 300.00, 'ENTREGADO', NOW(), 3, 3),    
(2, 120.00, 'PROCESANDO', NOW(), 4, 4),   
(4, 200.00, 'ENVIADO', NOW(), 5, 5),      
(6, 360.00, 'ENTREGADO', NOW(), 6, 6),    
(1, 50.00, 'PROCESANDO', NOW(), 7, 7),   
(3, 180.00, 'ENVIADO', NOW(), 8, 8),       
(2, 100.00, 'ENTREGADO', NOW(), 9, 9),     
(4, 220.00, 'PROCESANDO', NOW(), 10, 10);   

INSERT INTO Transacciones (pedido_id, estado) VALUES
(1, 'EN PROCESO'),  
(2, 'PAGADO'),       
(3, 'EN PROCESO'),   
(4, 'PAGADO'),       
(5, 'EN PROCESO'),   
(6, 'PAGADO'),      
(7, 'EN PROCESO'),   
(8, 'PAGADO'),       
(9, 'EN PROCESO'),  
(10, 'PAGADO');    

INSERT INTO Deseos (producto_id, cliente_id) VALUES
(1, 1),  
(2, 1),  
(3, 2),  
(4, 3),  
(5, 4),  
(6, 5),  
(7, 6),  
(8, 7),  
(9, 8),  
(10, 9); 

INSERT INTO Productos_Carro_Compras (producto_id, carro_compra_id, cantidad) VALUES
(1, 1, 2), 
(2, 1, 1),  
(3, 2, 3),  
(4, 3, 1), 
(5, 4, 5),  
(6, 5, 2), 
(7, 6, 4),  
(8, 7, 1), 
(9, 8, 3), 
(10, 9, 2); 