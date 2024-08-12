
-- 1. Creación de tablas, relaciones y cheks.
CREATE TABLE Clientes (
	cliente_id SERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	direccion VARCHAR(100),
	telefono VARCHAR(20),
	correo VARCHAR(200) unique NOT NULL,
	fecha_registro TIMESTAMP,
	estado VARCHAR (8) NOT NULL CHECK (estado IN('activo','inactivo' )));

CREATE TABLE Productos( 
	producto_id SERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	precio_unitario INTEGER NOT NULL, 
	stock INTEGER NOT NULL, 
	descripcion VARCHAR(500),
	categoria VARCHAR (8) NOT NULL CHECK (categoria IN('Electrodomesticos', 'Herramientas', 'Juguetes', 'Maquinas' )),
	estado VARCHAR (8) NOT NULL CHECK (estado IN('activo','inactivo' )));

ALTER TABLE Productos ALTER COLUMN categoria TYPE varchar(20);
	
CREATE TABLE carrito_compras (
	carrito_id SERIAL PRIMARY KEY,
	cliente_id INTEGER REFERENCES Clientes(cliente_id) NOT NULL,
	fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE carrito_compras_detalle (
	detalle_carrito_id SERIAL PRIMARY KEY,
	carrito_id INTEGER REFERENCES carrito_compras(carrito_id) NOT NULL,
	producto_id INTEGER REFERENCES Productos(producto_id) NOT NULL,
	cantidad INTEGER NOT NULL, 
	valor_unitario INTEGER NOT NULL, 
	estado VARCHAR (12) NOT NULL CHECK (estado IN('pendiente', 'confirmado')));
	
CREATE TABLE pedidos(
	pedido_id SERIAL PRIMARY KEY,
	cliente_id INTEGER REFERENCES Clientes(cliente_id)  NOT NULL,
	fecha_pedido TIMESTAMP NOT NULL,
	fecha_envio TIMESTAMP NOT NULL,
	total INTEGER NOT NULL, 
	direccion_envio VARCHAR (200) NOT NULL,
	medio_pago VARCHAR (15) NOT NULL CHECK (medio_pago IN('tarjeta', 'pse', 'transferencia')),
	notas VARCHAR (200),
	estado VARCHAR (12) NOT NULL CHECK (estado IN('procesando', 'enviado', 'entregado', 'cancelado' )));
	
CREATE TABLE pedido_detalle (
	pedido_detalle_id SERIAL PRIMARY KEY,
	pedido_id INTEGER REFERENCES pedidos(pedido_id)  NOT NULL,
	producto_id INTEGER REFERENCES Productos(producto_id)  NOT NULL,
	cantidad INTEGER NOT NULL,
	valor_unitario INTEGER NOT NULL,
	estado VARCHAR (12) NOT NULL CHECK (estado IN('pendiente', 'confirmado')));

	
INSERT INTO Clientes (nombre, apellido, direccion, telefono, correo, fecha_registro, estado) 
VALUES 
('Juan', 'Pérez', 'Calle Falsa 123', '555-1234', 'juan.perez@example.com', NOW(), 'activo'),
('Ana', 'García', 'Avenida Siempre Viva 456', '555-5678', 'ana.garcia@example.com', NOW(), 'activo'),
('Luis', 'Martínez', 'Boulevard de los Sueños 789', '555-8765', 'luis.martinez@example.com', NOW(), 'activo'),
('María', 'López', 'Calle de la Rosa 321', '555-4321', 'maria.lopez@example.com', NOW(), 'activo'),
('Pedro', 'Hernández', 'Avenida del Sol 654', '555-9876', 'pedro.hernandez@example.com', NOW(), 'activo'),
('Lucía', 'González', 'Calle del Lago 987', '555-7654', 'lucia.gonzalez@example.com', NOW(), 'inactivo'),
('Carlos', 'Rodríguez', 'Calle de la Luna 654', '555-8765', 'carlos.rodriguez@example.com', NOW(), 'activo'),
('Carmen', 'Sánchez', 'Calle del Mar 543', '555-6789', 'carmen.sanchez@example.com', NOW(), 'activo'),
('Miguel', 'Ramírez', 'Calle del Bosque 432', '555-7890', 'miguel.ramirez@example.com', NOW(), 'inactivo'),
('Laura', 'Flores', 'Calle del Viento 321', '555-8901', 'laura.flores@example.com', NOW(), 'activo'),
('Sofía', 'Jiménez', 'Avenida de la Paz 210', '555-9012', 'sofia.jimenez@example.com', NOW(), 'activo'),
('Jorge', 'Morales', 'Boulevard de la Esperanza 101', '555-0123', 'jorge.morales@example.com', NOW(), 'inactivo'),
('Elena', 'Ortiz', 'Calle de la Niebla 789', '555-2345', 'elena.ortiz@example.com', NOW(), 'activo'),
('David', 'Ruiz', 'Avenida de la Luna 987', '555-3456', 'david.ruiz@example.com', NOW(), 'inactivo'),
('Gloria', 'Torres', 'Calle de las Flores 456', '555-4567', 'gloria.torres@example.com', NOW(), 'activo');

INSERT INTO Productos (nombre, precio_unitario, stock, descripcion, categoria, estado) 
VALUES 
('Aspiradora X2000', 150, 25, 'Aspiradora potente para todo tipo de superficies', 'Electrodomesticos', 'activo'),
('Taladro Bosch', 80, 50, 'Taladro de alta precisión con múltiples velocidades', 'Herramientas', 'activo'),
('Lavarropas LG', 300, 15, 'Lavadora de alta eficiencia con carga superior', 'Electrodomesticos', 'activo'),
('Juego de Construcción Lego', 40, 100, 'Set de construcción con 500 piezas', 'Juguetes', 'activo'),
('Sierra Eléctrica', 120, 30, 'Sierra eléctrica para corte de madera', 'Herramientas', 'activo'),
('Cafetera Express', 100, 20, 'Cafetera para espresso y capuchino', 'Electrodomesticos', 'activo'),
('Robot de Cocina', 200, 10, 'Robot multifuncional para preparar comidas', 'Electrodomesticos', 'activo'),
('Bicicleta de Montaña', 250, 15, 'Bicicleta para rutas montañosas con suspensión avanzada', 'Juguetes', 'activo'),
('Generador Eléctrico', 400, 5, 'Generador de energía eléctrica de alta capacidad', 'Maquinas', 'activo'),
('Set de Destornilladores', 20, 200, 'Set completo de destornilladores de precisión', 'Herramientas', 'activo'),
('Plancha a Vapor', 50, 40, 'Plancha a vapor con control de temperatura', 'Electrodomesticos', 'activo'),
('Lijadora Orbital', 90, 30, 'Lijadora orbital para acabados suaves', 'Herramientas', 'activo'),
('Coche de Juguete', 25, 150, 'Coche de juguete con control remoto', 'Juguetes', 'activo'),
('Compresor de Aire', 350, 8, 'Compresor de aire de alta presión para uso industrial', 'Maquinas', 'activo'),
('Ventilador de Pie', 70, 45, 'Ventilador ajustable con múltiples velocidades', 'Electrodomesticos', 'inactivo');

INSERT INTO carrito_compras (cliente_id) VALUES 
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10);

INSERT INTO carrito_compras_detalle (carrito_id, producto_id, cantidad, valor_unitario, estado) VALUES 
(1, 1, 2, 150, 'pendiente'),
(1, 2, 1, 80, 'pendiente'),
(2, 3, 1, 300, 'confirmado'),
(2, 4, 3, 40, 'pendiente'),
(3, 5, 1, 120, 'confirmado'),
(3, 6, 1, 100, 'pendiente'),
(4, 7, 2, 200, 'confirmado'),
(4, 8, 1, 250, 'pendiente'),
(5, 9, 1, 400, 'confirmado'),
(5, 10, 10, 20, 'pendiente'),
(6, 11, 2, 50, 'pendiente'),
(6, 12, 1, 90, 'confirmado'),
(7, 13, 5, 25, 'pendiente'),
(7, 14, 1, 350, 'confirmado'),
(8, 15, 1, 70, 'pendiente');

INSERT INTO pedidos (cliente_id, fecha_pedido, fecha_envio, total, direccion_envio, medio_pago, notas, estado) VALUES 
(1, '2024-08-01 10:00:00', '2024-08-03 14:00:00', 300, 'Calle Falsa 123, Ciudad Ficticia', 'tarjeta', 'Entregar en la tarde', 'procesando'),
(2, '2024-08-02 12:00:00', '2024-08-05 16:00:00', 500, 'Avenida Siempre Viva 456, Ciudad Ficticia', 'pse', NULL, 'enviado'),
(3, '2024-08-03 14:00:00', '2024-08-06 18:00:00', 150, 'Boulevard de los Sueños 789, Ciudad Ficticia', 'transferencia', 'Llamar antes de entregar', 'entregado'),
(4, '2024-08-04 16:00:00', '2024-08-07 20:00:00', 400, 'Calle de la Rosa 321, Ciudad Ficticia', 'tarjeta', NULL, 'cancelado'),
(5, '2024-08-05 18:00:00', '2024-08-08 22:00:00', 250, 'Avenida del Sol 654, Ciudad Ficticia', 'tarjeta', 'Entregar sin contacto', 'procesando'),
(6, '2024-08-06 08:00:00', '2024-08-09 10:00:00', 350, 'Calle del Lago 987, Ciudad Ficticia', 'pse', NULL, 'enviado'),
(7, '2024-08-07 09:00:00', '2024-08-10 11:00:00', 200, 'Calle de la Luna 654, Ciudad Ficticia', 'transferencia', 'Dejar en portería', 'entregado'),
(8, '2024-08-08 10:00:00', '2024-08-11 12:00:00', 450, 'Calle del Mar 543, Ciudad Ficticia', 'tarjeta', NULL, 'procesando'),
(9, '2024-08-09 11:00:00', '2024-08-12 13:00:00', 600, 'Calle del Bosque 432, Ciudad Ficticia', 'pse', 'Entregar en la oficina', 'enviado'),
(10, '2024-08-10 12:00:00', '2024-08-13 14:00:00', 275, 'Calle del Viento 321, Ciudad Ficticia', 'tarjeta', NULL, 'procesando');

INSERT INTO pedido_detalle (pedido_id, producto_id, cantidad, valor_unitario, estado) VALUES 
(1, 1, 2, 150, 'confirmado'),
(2, 3, 1, 300, 'confirmado'),
(3, 5, 1, 120, 'confirmado'),
(4, 7, 2, 200, 'pendiente'),
(5, 9, 1, 400, 'confirmado'),
(6, 11, 2, 50, 'confirmado'),
(7, 13, 5, 25, 'confirmado'),
(8, 15, 1, 70, 'confirmado'),
(9, 2, 1, 80, 'confirmado'),
(10, 4, 3, 40, 'pendiente'),
(1, 6, 1, 100, 'confirmado'),
(2, 8, 1, 250, 'confirmado'),
(3, 10, 10, 20, 'confirmado'),
(4, 12, 1, 90, 'pendiente'),
(5, 14, 1, 350, 'confirmado');

-- ================================================================================================================================================	
-- 2. Consultas que aporten valor al negocio.

-- 2.1. Consultar el valor promedio y la cantidad de pedidos por estado

SELECT TRUNC(AVG(total), 2) AS Vlr_promedio, count(*) as Cantidad_pedidos, estado 
	FROM public.pedidos
	GROUP BY estado 
	ORDER BY estado DESC;

-- 2.2. Conslta los datos de los clientes a los cuales se les entrego el pedido en un rango de fechas determinado

SELECT clientes.nombre, clientes.apellido, clientes.direccion, clientes.telefono, pedidos.direccion_envio, total, fecha_envio
	FROM public.clientes
	JOIN public.pedidos ON clientes.cliente_id = pedidos.cliente_id
	WHERE pedidos.estado = 'entregado' AND fecha_envio BETWEEN  '2024-08-06' AND '2024-08-15'
	ORDER BY fecha_envio DESC;
	
-- 2.3. Consultar los productos con stock inferior a 100 unidades 
	SELECT productos.* FROM public.productos 
	WHERE stock <= 100
	ORDER BY nombre, categoria, stock ASC;

-- 2.4. Consultar cual es el producto q mas se ha pedido y su valor

SELECT productos.nombre, pedido_detalle.cantidad, pedido_detalle.valor_unitario, (pedido_detalle.cantidad * pedido_detalle.valor_unitario) as Total
	FROM public.productos
	JOIN public.pedido_detalle ON productos.producto_id = pedido_detalle.producto_id
	JOIN public.pedidos ON pedido_detalle.pedido_id  = pedidos.pedido_id
	ORDER BY cantidad DESC LIMIT 5
	
-- ================================================================================================================================================
-- 3. Procedimientos almacenados que aporten valor al negocio.

-- 3.1. Agregar stock a un determinado producto 

CREATE OR REPLACE PROCEDURE update_stock(
	IN id_producto INTEGER, 
	IN cantidad INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE public.productos SET stock = (stock + cantidad) WHERE producto_id = id_producto ;
END;
$$;

CALL update_stock (5, 70);

-- 3.2. 



-- ================================================================================================================================================
-- 4. Funciones que aporten valor al negocio.

-- 4.1. Listado de productos por nombre (o parte del nombre)	

CREATE OR REPLACE PROCEDURE busqueda_por_nombre(
	IN criterio_busqueda VARCHAR )
	
LANGUAGE plpgsql
AS $$
DECLARE
    resultado RECORD;
BEGIN
	FOR resultado IN
    	SELECT nombre, precio_unitario, stock, descripcion, categoria 
			FROM Productos 
			WHERE nombre like '%' || criterio_busqueda || '%'
			ORDER BY nombre, categoria ASC
    LOOP
        RAISE NOTICE 'Nombre: %, Valor: %, Stock: %, Descripcion: %, Categoria: %',
						resultado.nombre, resultado.precio_unitario, resultado.stock, resultado.descripcion, resultado.categoria ;
    END LOOP;
END;
$$;

CALL busqueda_por_nombre('ador');

-- 4.2 Listado de productos por categoria 

CREATE OR REPLACE PROCEDURE busqueda_por_categoria(
	IN criterio_busqueda VARCHAR )
	
LANGUAGE plpgsql
AS $$
DECLARE
    resultado RECORD;
BEGIN
	FOR resultado IN
    	SELECT nombre, precio_unitario, stock, descripcion, categoria 
			FROM Productos 
			WHERE categoria = criterio_busqueda
			ORDER BY nombre, categoria ASC
    LOOP
        RAISE NOTICE 'Nombre: %, Valor: %, Stock: %, Descripcion: %, Categoria: %',
						resultado.nombre, resultado.precio_unitario, resultado.stock, resultado.descripcion, resultado.categoria ;
    END LOOP;
END;
$$;

CALL busqueda_por_categoria('Electrodomesticos');

-- 4.3. Agregar productos al carrito de compra de un cliente especifico

CREATE OR REPLACE PROCEDURE agregar_producto_carrito_compras(
	IN clienteid INTEGER, 
	IN fechacreacion DATE, 
	IN productoid  INTEGER, 
	IN cant INTEGER, 
	IN valorunitario INTEGER, 
	IN status VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.carrito_compras (cliente_id, fecha_creacion)	
    	VALUES (clienteid, fechacreacion) ;
	INSERT INTO public.carrito_compras_detalle (carrito_id, producto_id, cantidad, Valor_unitario)
		VALUES ((select max(carrito_id) from public.carrito_compras ), productoid, cant, valorunitario );
END;
$$;

CALL agregar_producto_carrito_compras(7, CURRENT_DATE, 2, 5, 200, 'activo' );


-- ================================================================================================================================================
