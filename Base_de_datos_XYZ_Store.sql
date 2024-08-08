-----------------------------------------------------------------------
--RETO FINAL.
--SCRIPT CREADO POR: JUAN PABLO VALDERRAMA PELÁEZ
--CREACIÓN BASE DE DATOS COMPLETA PARA XYZ STORE.
------------------------------------------------------------------------
-- Creación de tablas.
------------------------------------------------------------------------

-- Tabla Clientes.
CREATE TABLE Clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    documento_identificacion VARCHAR(50) UNIQUE NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    correo_electronico VARCHAR(255) UNIQUE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Productos.
CREATE TABLE Productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10, 2) NOT NULL,
    stock INT NOT NULL,
    categoria VARCHAR(100)
);

-- Tabla Estados Pedidos.
CREATE TABLE Estados_Pedido (
    estado_pedido_id SERIAL PRIMARY KEY,
    nombre_estado VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla Pedidos.
CREATE TABLE Pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES Clientes(cliente_id),
    precio_total NUMERIC(10, 2) NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_pedido_id INT REFERENCES Estados_Pedido(estado_pedido_id)
);

-- Tabla Articulos Pedido.
CREATE TABLE Articulos_Pedido (
    pedido_id INT REFERENCES Pedidos(pedido_id),
    producto_id INT REFERENCES Productos(producto_id),
    cantidad INT NOT NULL,
    precio NUMERIC(10, 2) NOT NULL,
	PRIMARY KEY (pedido_id, producto_id)
);

-- Tabla Reseñas.
CREATE TABLE Reseñas (
    reseña_id SERIAL PRIMARY KEY,
    producto_id INT REFERENCES Productos(producto_id),
    cliente_id INT REFERENCES Clientes(cliente_id),
    calificacion INT CHECK (calificacion >= 1 AND calificacion <= 5),
    comentario TEXT,
    fecha_reseña TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Listas de Deseos.
CREATE TABLE Listas_Deseos (
    lista_deseos_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES Clientes(cliente_id),
	fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla Articulos de la Lista de Deseos.
CREATE TABLE Articulos_Lista_Deseos (
    lista_deseos_id INT REFERENCES Listas_Deseos(lista_deseos_id),
    producto_id INT REFERENCES Productos(producto_id),
	PRIMARY KEY (lista_deseos_id, producto_id)
);

-- Tabla Datos de Login.
CREATE TABLE Login (
    login_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES Clientes(cliente_id),
    usuario VARCHAR(50) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla metodos de pago.
CREATE TABLE Metodos_Pago (
    metodo_pago_id SERIAL PRIMARY KEY,
    nombre_metodo VARCHAR(50) UNIQUE NOT NULL 
);

--Tabla Estados de las transacciones.
CREATE TABLE Estados_Transaccion (
    estado_transaccion_id SERIAL PRIMARY KEY,
    nombre_estado VARCHAR(50) UNIQUE NOT NULL  
);

-- Tabla Transacciones.
CREATE TABLE Transacciones (
    transaccion_id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES Pedidos(pedido_id),
    cliente_id INT REFERENCES Clientes(cliente_id),
    monto NUMERIC(10, 2),
    fecha_transaccion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metodo_pago_id INT REFERENCES Metodos_Pago(metodo_pago_id),
    estado_transaccion_id INT REFERENCES Estados_Transaccion(estado_transaccion_id)
);

------------------------------------------------------------------------
-- Inserción de datos.
------------------------------------------------------------------------

-- Inserciones en la Tabla Clientes.
INSERT INTO Clientes (nombre, apellido, documento_identificacion, direccion, telefono, correo_electronico)
VALUES
('Juan', 'Pérez', '12345678', 'Calle Falsa 123', '3001234567', 'juan.perez@gmail.com'),
('Ana', 'Gómez', '23456789', 'Avenida Siempre Viva 456', '3002345678', 'ana.gomez@gmail.com'),
('Pedro', 'Martínez', '34567890', 'Carrera 7 #45-67', '3003456789', 'pedro.martinez@gmail.com'),
('Laura', 'Ramos', '45678901', 'Diagonal 22 #88-99', '3004567890', 'laura.ramos@gmail.com'),
('Carlos', 'Rodríguez', '56789012', 'Calle del Sol 101', '3005678901', 'carlos.rodriguez@gmail.com'),
('María', 'Vásquez', '67890123', 'Avenida de los Pinos 202', '3006789012', 'maria.vasquez@gmail.com'),
('Luis', 'Fernández', '78901234', 'Calle del Río 303', '3007890123', 'luis.fernandez@gmail.com'),
('Elena', 'Cabrera', '89012345', 'Calle del Mar 404', '3008901234', 'elena.cabrera@gmail.com'),
('Jorge', 'Ortega', '90123456', 'Avenida Central 505', '3009012345', 'jorge.ortega@gmail.com'),
('Sandra', 'Moreno', '01234567', 'Calle de la Luna 606', '3000123456', 'sandra.moreno@gmail.com');

-- Inserciones en la Tabla Productos.
INSERT INTO Productos (nombre, descripcion, precio, stock, categoria)
VALUES
('Laptop Gamer HP', 'Laptop de última generación', 3500000, 10, 'Electrónica'),
('Smartphone Iphone 15', 'Smartphone con cámara de alta resolución', 4500000, 15, 'Electrónica'),
('Tablet Samsung J5', 'Tablet con pantalla de 10 pulgadas', 3200000, 20, 'Electrónica'),
('Auriculares Gaming Razer', 'Auriculares inalámbricos', 380000, 25, 'Accesorios'),
('Teclado Mecanico ', 'Teclado mecánico RGB', 150000, 30, 'Accesorios'),
('Ratón Logitech', 'Ratón ergonómico', 80000, 35, 'Accesorios'),
('Monitor LG Curvo', 'Monitor 4K de 27 pulgadas', 1650000, 40, 'Electrónica'),
('Disco Duro', 'Disco duro externo de 1TB', 250000, 45, 'Electrónica'),
('Cámara Profesional', 'Cámara DSLR con lente incluido', 2800000, 50, 'Electrónica'),
('Impresora', 'Impresora láser a color', 420000, 55, 'Electrónica');

-- Inserciones en la Tabla Estados_Pedido.
INSERT INTO Estados_Pedido (nombre_estado)
VALUES
('Procesando'),
('Enviado'),
('Entregado'),
('Cancelado'),
('Devuelto');

-- Inserciones en la Tabla Pedidos.
INSERT INTO Pedidos (cliente_id, precio_total, fecha_pedido, estado_pedido_id)
VALUES
(1, 8000000, '2024-08-01 10:00:00', 1), 
(2, 3580000, '2024-08-03 12:00:00', 3),
(3, 230000, '2024-08-04 13:00:00', 2), 
(4, 1900000, '2024-08-05 14:00:00', 1), 
(5, 2800000, '2024-08-06 15:00:00', 1),
(6, 420000, '2024-08-07 16:00:00', 2), 
(7, 11200000, '2024-08-08 17:00:00', 3), 
(8, 610000, '2024-08-09 18:00:00', 1), 
(9, 4700000, '2024-08-10 19:00:00', 2), 
(10, 8230000, '2024-08-11 20:00:00', 1); 

-- Inserciones en la Tabla Articulos_Pedido.
INSERT INTO Articulos_Pedido (pedido_id, producto_id, cantidad, precio)
VALUES
(1, 1, 1, 3500000),   
(1, 2, 1, 4500000),    
(2, 3, 1, 3200000),    
(2, 4, 1, 380000),     
(3, 5, 1, 150000),     
(3, 6, 1, 80000),      
(4, 7, 1, 1650000),    
(4, 8, 1, 250000),     
(5, 9, 1, 2800000),    
(6, 10, 1, 420000),    
(7, 1, 1, 3500000),    
(7, 2, 1, 4500000),    
(7, 3, 1, 3200000),    
(8, 4, 2, 380000),     
(8, 5, 1, 150000),     
(8, 6, 2, 80000),      
(9, 7, 1, 1650000),    
(9, 8, 1, 250000),     
(9, 9, 1, 2800000),   
(10, 1, 1, 3500000),   
(10, 2, 1, 4500000),   
(10, 5, 1, 150000),    
(10, 6, 1, 80000);     

-- Inserciones en la Tabla Listas_Deseos.
INSERT INTO Listas_Deseos (cliente_id, fecha_creacion)
VALUES
(1, '2024-08-01 10:00:00'),
(2, '2024-08-02 11:00:00'),
(3, '2024-08-03 12:00:00'),
(4, '2024-08-04 13:00:00'),
(5, '2024-08-05 14:00:00'),
(6, '2024-08-06 15:00:00'),
(7, '2024-08-07 16:00:00'),
(8, '2024-08-08 17:00:00'),
(9, '2024-08-09 18:00:00'),
(10, '2024-08-10 19:00:00');

-- Inserciones en la Tabla Articulos_Lista_Deseos.
INSERT INTO Articulos_Lista_Deseos (lista_deseos_id, producto_id)
VALUES
(1, 1), 
(1, 3), 
(2, 2), 
(2, 4), 
(2, 7), 
(3, 5), 
(3, 6), 
(4, 9), 
(4, 10), 
(5, 8), 
(5, 1), 
(5, 2), 
(6, 3),
(6, 4),
(6, 7),
(7, 8),
(7, 9),
(8, 1), 
(8, 2),
(8, 3), 
(8, 4), 
(9, 5), 
(9, 6),
(9, 7), 
(9, 8),
(10, 9), 
(10, 10); 

-- Inserciones en la Tabla Reseñas.
INSERT INTO Reseñas (producto_id, cliente_id, calificacion, comentario, fecha_reseña)
VALUES
(1, 1, 5, 'Excelente laptop, muy rápido y eficiente.', '2024-08-01 11:00:00'),
(1, 2, 4, 'Buena laptop pero un poco cara.', '2024-08-02 12:00:00'),
(1, 3, 5, 'Muy buena laptop, funciona perfectamente.', '2024-08-03 13:00:00'),
(2, 4, 4, 'Smartphone excelente, aunque puede mejorar en batería.', '2024-08-04 14:00:00'),
(2, 5, 5, 'Smartphone de gran calidad, gran cámara y rendimiento.', '2024-08-05 15:00:00'),
(2, 6, 3, 'Smartphone bien, pero esperaba más.', '2024-08-06 16:00:00'),
(3, 7, 4, 'Tablet con buen rendimiento, aunque el precio es elevado.', '2024-08-07 17:00:00'),
(3, 8, 5, 'La tablet es fantástica, gran compra.', '2024-08-08 18:00:00'),
(4, 9, 5, 'Monitor con excelente resolución, muy recomendable.', '2024-08-09 19:00:00'),
(4, 10, 4, 'Buen monitor, aunque la instalación es complicada.', '2024-08-10 20:00:00'),
(5, 1, 5, 'Cámara excepcional, captura detalles increíbles.', '2024-08-11 21:00:00'),
(5, 2, 4, 'Cámara buena, pero el precio es alto.', '2024-08-12 22:00:00'),
(6, 3, 5, 'Disco duro muy útil, funciona perfectamente.', '2024-08-13 23:00:00'),
(6, 4, 4, 'Disco duro rápido y confiable.', '2024-08-14 10:00:00'),
(7, 5, 3, 'Impresora decente, pero el cartucho se agota rápido.', '2024-08-15 11:00:00'),
(7, 6, 4, 'Impresora buena para uso básico.', '2024-08-16 12:00:00'),
(8, 7, 5, 'Ratón ergonómico, muy cómodo para el uso prolongado.', '2024-08-17 13:00:00'),
(8, 8, 4, 'Ratón eficiente, pero puede ser un poco ruidoso.', '2024-08-18 14:00:00'),
(9, 9, 5, 'Teclado mecánico excelente, muy satisfecho.', '2024-08-19 15:00:00'),
(9, 10, 4, 'Teclado bueno, pero el diseño podría mejorar.', '2024-08-20 16:00:00'),
(10, 1, 5, 'Auriculares con gran sonido y comodidad.', '2024-08-21 17:00:00'),
(10, 2, 4, 'Auriculares de buena calidad, pero algo caros.', '2024-08-22 18:00:00');

-- Inserciones en la Tabla Login.
INSERT INTO Login (cliente_id, usuario, contraseña)
VALUES
(1, 'juanperez', 'AHJSGYDShnjzbx76xcs52'),
(2, 'anagomez', 'TGZLMnPL9Xwz70XpTp6u8'),
(3, 'pedromartinez', 'WFTxL8GSRnN4c7JHk9U2'),
(4, 'lauraramos', 'UJY9MNtGH7x2pQr5bV8d'),
(5, 'carlosrodriguez', 'NBX4JDnG6Lp90mOXY7Va'),
(6, 'mariavasquez', 'W7LZX4GH4a9tYQmn3V8D'),
(7, 'luisfernandez', 'H8R7XYsG3vzL9kp1Lt2F'),
(8, 'elenacabrera', 'K9X5y8Np6zG3h4Tq7L0U'),
(9, 'jorgeortega', 'V1Pn8QF7y9H5m3VZr0xG'),
(10, 'sandramoreno', 'Z3K0xL8PTv9s2YwR7U5G');

-- Inserciones en la Tabla Metodos de pago.
INSERT INTO Metodos_Pago (nombre_metodo) 
VALUES
('Tarjeta de Crédito'),
('PayPal'),
('Transferencia Bancaria'),
('Criptomonedas');

-- Inserciones en la Tabla Estados de la transaccion.
INSERT INTO Estados_Transaccion (nombre_estado) 
VALUES
('Completado'),
('Fallido'),
('Pendiente'),
('Reembolsado');

-- Inserciones en la Tabla Transacciones.
INSERT INTO Transacciones (pedido_id, cliente_id, monto, fecha_transaccion, metodo_pago_id, estado_transaccion_id)
VALUES
(1, 1, 8000000, '2024-08-01 10:05:00', 1, 1), 
(2, 2, 3580000, '2024-08-03 12:10:00', 2, 1), 
(3, 3, 230000, '2024-08-04 13:15:00', 3, 2), 
(4, 4, 1900000, '2024-08-05 14:20:00', 4, 1), 
(5, 5, 2800000, '2024-08-06 15:25:00', 1, 1), 
(6, 6, 420000, '2024-08-07 16:30:00', 2, 3), 
(7, 7, 11200000, '2024-08-08 17:35:00', 3, 1), 
(8, 8, 610000, '2024-08-09 18:40:00', 4, 2), 
(9, 9, 4700000, '2024-08-10 19:45:00', 1, 1), 
(10, 10, 8230000, '2024-08-11 20:50:00', 2, 1); 

------------------------------------------------------------------------
-- Querys relevantes para el negocio.
------------------------------------------------------------------------

-- 1.Clientes que han realizado más pedidos.
SELECT C.cliente_id, C.nombre, C.apellido, COUNT(P.pedido_id) AS numero_pedidos
FROM Clientes C
JOIN Pedidos P ON C.cliente_id = P.cliente_id
GROUP BY C.cliente_id, C.nombre, C.apellido
ORDER BY numero_pedidos DESC;

-- 2.Productos más vendidos.
SELECT P.producto_id, P.nombre, SUM(AP.cantidad) AS total_vendido
FROM Productos P
JOIN Articulos_Pedido AP ON P.producto_id = AP.producto_id
GROUP BY P.producto_id, P.nombre
ORDER BY total_vendido DESC;

-- 3.Total de ventas por mes.
SELECT TO_CHAR(DATE_TRUNC('month', fecha_pedido), 'YYYY-MM') AS mes, SUM(precio_total) AS total_ventas
FROM Pedidos
GROUP BY mes
ORDER BY mes;

-- 4.Promedio de Calificación reseña producto.
SELECT P.producto_id, P.nombre, AVG(R.calificacion) AS calificacion_promedio
FROM Productos P
LEFT JOIN Reseñas R ON P.producto_id = R.producto_id
GROUP BY P.producto_id, P.nombre
ORDER BY calificacion_promedio DESC;

-- 5.Clientes registrados en el mes actual.
SELECT *
FROM Clientes
WHERE fecha_registro >= DATE_TRUNC('month', CURRENT_DATE)
ORDER BY fecha_registro DESC;

------------------------------------------------------------------------
-- Procedimientos almacenados.
------------------------------------------------------------------------

-- 1.Procedimiento para crear nuevos clientes y sus datos de login.
CREATE OR REPLACE PROCEDURE Crear_Cliente_Nuevo(
    p_nombre VARCHAR,
    p_apellido VARCHAR,
    p_documento_identificacion VARCHAR,
    p_direccion VARCHAR,
    p_telefono VARCHAR,
    p_correo_electronico VARCHAR,
    p_usuario VARCHAR,
    p_contraseña VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    cliente_existente INT;
    nuevo_cliente_id INT;
BEGIN
    -- Verificar si el cliente ya existe.
    SELECT cliente_id INTO cliente_existente
    FROM Clientes
    WHERE documento_identificacion = p_documento_identificacion
       OR correo_electronico = p_correo_electronico;

    IF cliente_existente IS NOT NULL THEN
        RAISE EXCEPTION 'El cliente con el documento de identificación o correo electrónico proporcionado ya existe.';
    END IF;

    -- Insertar el nuevo cliente.
    INSERT INTO Clientes (nombre, apellido, documento_identificacion, direccion, telefono, correo_electronico)
    VALUES (p_nombre, p_apellido, p_documento_identificacion, p_direccion, p_telefono, p_correo_electronico)
    RETURNING cliente_id INTO nuevo_cliente_id;

    -- Insertar los datos de login del nuevo cliente.
    INSERT INTO Login (cliente_id, usuario, contraseña)
    VALUES (nuevo_cliente_id, p_usuario, p_contraseña);
    
    RAISE NOTICE 'Cliente creado exitosamente con ID %', nuevo_cliente_id;
END;
$$;


--Llamado al procedimiento.
CALL Crear_Cliente_Nuevo('Juan Pablo', 'Valderrama', '1128456', 'Cra 59 # 70-349', '3104378899', 'juan.valderrama@hotmail.com', 
						 'jvalderr', 'HyauJg837xbc'  );

--Validación de los datos creados.
SELECT * FROM Clientes;
SELECT * FROM Login;

-- 2.Procedimiento para agregar nuevos productos a la tienda.
CREATE OR REPLACE PROCEDURE Agregar_Producto(
    p_nombre VARCHAR,
    p_descripcion TEXT,
    p_precio NUMERIC(10, 2),
    p_stock INT,
    p_categoria VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insertar el nuevo producto en la tabla Productos.
    INSERT INTO Productos (nombre, descripcion, precio, stock, categoria)
    VALUES (p_nombre, p_descripcion, p_precio, p_stock, p_categoria);
    
    RAISE NOTICE 'Producto "%", categoría "%", añadido con éxito.', p_nombre, p_categoria;
END;
$$;

--Llamado al procedimiento.
CALL Agregar_Producto('PS5', 'Play Station 5 versión disco', 2050000, 10, 'Electrónica' );

--Validación de los datos creados.
SELECT * FROM Productos;


-- 3.Procedimiento para eliminar productos que ya no se venderan.
CREATE OR REPLACE PROCEDURE Eliminar_Producto(
    p_producto_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verificar si el producto existe antes de eliminarlo.
    IF EXISTS (SELECT 1 FROM Productos WHERE producto_id = p_producto_id) THEN
        -- Eliminar el producto de la tabla Productos.
        DELETE FROM Productos WHERE producto_id = p_producto_id;
        
        RAISE NOTICE 'Producto con ID % eliminado con éxito.', p_producto_id;
    ELSE
        RAISE NOTICE 'No se encontró ningún producto con ID %.', p_producto_id;
    END IF;
END;
$$;

--Llamado al procedimiento.
CALL Eliminar_Producto(11);

--Validación de los datos.
SELECT * FROM Productos;

-- 4.Procedimiento para crear nuevas listas de desesos de los clientes.
CREATE OR REPLACE PROCEDURE Crear_Lista_Deseos(
    p_cliente_id INT,
    p_productos INT[]
)
LANGUAGE plpgsql
AS $$
DECLARE
    nuevo_lista_deseos_id INT;
    p_producto_id INT;  
BEGIN
    -- Verificar si el cliente existe.
    IF NOT EXISTS (SELECT 1 FROM Clientes WHERE cliente_id = p_cliente_id) THEN
        RAISE EXCEPTION 'Cliente con ID % no existe.', p_cliente_id;
    END IF;

    -- Crear la nueva lista de deseos.
    INSERT INTO Listas_Deseos (cliente_id)
    VALUES (p_cliente_id)
    RETURNING lista_deseos_id INTO nuevo_lista_deseos_id;

    -- Agregar productos a la lista de deseos.
    FOREACH p_producto_id IN ARRAY p_productos
    LOOP
        -- Verificar si el producto existe.
        IF EXISTS (SELECT 1 FROM Productos WHERE producto_id = p_producto_id) THEN
            -- Agregar el producto a la lista de deseos.
            INSERT INTO Articulos_Lista_Deseos (lista_deseos_id, producto_id)
            VALUES (nuevo_lista_deseos_id, p_producto_id);
        ELSE
            RAISE NOTICE 'Producto con ID % no existe. No se agregará a la lista de deseos.', p_producto_id;
        END IF;
    END LOOP;

    RAISE NOTICE 'Lista de deseos creada con ID % y productos agregados.', nuevo_lista_deseos_id;
END;
$$;

--Llamado al procedimiento.
CALL Crear_Lista_Deseos(11, ARRAY[1, 3, 5]);

--Validación de los datos.
SELECT * FROM Listas_Deseos;
SELECT * FROM Articulos_Lista_Deseos;

-- 5.Procedimiento para disminuir el stock de un producto comprado por cliente.
CREATE OR REPLACE PROCEDURE Disminuir_Stock_Producto(
    p_producto_id INT,
    p_cantidad INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_actual INT;
BEGIN
    -- Verificar si el producto existe.
    IF NOT EXISTS (SELECT 1 FROM Productos WHERE producto_id = p_producto_id) THEN
        RAISE EXCEPTION 'Producto con ID % no existe.', p_producto_id;
    END IF;

    -- Obtener el stock actual del producto.
    SELECT stock INTO v_stock_actual
    FROM Productos
    WHERE producto_id = p_producto_id;

    -- Verificar si hay suficiente stock para la reducción.
    IF v_stock_actual < p_cantidad THEN
        RAISE EXCEPTION 'No hay suficiente stock para el producto con ID %.', p_producto_id;
    END IF;

    -- Disminuir el stock del producto.
    UPDATE Productos
    SET stock = stock - p_cantidad
    WHERE producto_id = p_producto_id;

    RAISE NOTICE 'Stock del producto con ID % reducido en % unidades. Stock actual: %', p_producto_id, p_cantidad, v_stock_actual - p_cantidad;
END;
$$;

--Llamado al procedimiento.
CALL Disminuir_Stock_Producto(4, 5);

--Validación de los datos.
SELECT * FROM Productos;

------------------------------------------------------------------------
-- Funciones.
------------------------------------------------------------------------

-- 1.Función que retorna las compras de un cliente.
CREATE OR REPLACE FUNCTION Compras_Por_Cliente(p_cliente_id INT)
RETURNS TABLE (
    pedido_id INT,
    fecha_pedido TIMESTAMP,
    producto_id INT,
    nombre_producto VARCHAR,  
    cantidad INT,
    precio NUMERIC,
    precio_total NUMERIC
) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.pedido_id,
        p.fecha_pedido,
        ap.producto_id,
        pr.nombre AS nombre_producto,
        ap.cantidad,
        ap.precio,
        ap.cantidad * ap.precio AS precio_total
    FROM Pedidos p
    JOIN Articulos_Pedido ap ON p.pedido_id = ap.pedido_id
    JOIN Productos pr ON ap.producto_id = pr.producto_id
    WHERE p.cliente_id = p_cliente_id;
END;
$$;

--Verificando función.
SELECT * FROM Compras_Por_Cliente(2);

-- 2.Función que retorna el total de ventas del mes actual.
CREATE OR REPLACE FUNCTION Total_Ventas_Mes_Actual()
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    total NUMERIC;
BEGIN
    SELECT SUM(p.precio_total)
    INTO total
    FROM Pedidos p
    WHERE EXTRACT(YEAR FROM p.fecha_pedido) = EXTRACT(YEAR FROM CURRENT_DATE)
      AND EXTRACT(MONTH FROM p.fecha_pedido) = EXTRACT(MONTH FROM CURRENT_DATE);
    
    RETURN COALESCE(total, 0);  
END;
$$;

--Verificando función.
SELECT total_ventas_mes_actual();

-- 3.Función que retorna las listas de desesos de un cliente.
CREATE OR REPLACE FUNCTION Listas_Deseos_Cliente(p_cliente_id INT)
RETURNS TABLE (
    lista_deseos_id INT,
    nombre_producto VARCHAR,
    fecha_creacion TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        l.lista_deseos_id,
        p.nombre AS nombre_producto,
        l.fecha_creacion
    FROM 
        Listas_Deseos l
    JOIN 
        Articulos_Lista_Deseos al ON l.lista_deseos_id = al.lista_deseos_id
    JOIN 
        Productos p ON al.producto_id = p.producto_id
    WHERE 
        l.cliente_id = p_cliente_id; 
END;
$$ LANGUAGE plpgsql;


--Verificando función.
SELECT Listas_Deseos_Cliente(1);

-- 4.Función que retorna un listado de los productos mas vendidos.
CREATE OR REPLACE FUNCTION Ranking_Productos_Mas_Vendidos()
RETURNS TABLE (
    producto_id INT,
    nombre_producto VARCHAR,
    cantidad_vendida INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.producto_id,
        p.nombre AS nombre_producto,
        CAST(COALESCE(SUM(ap.cantidad), 0) AS INT) AS cantidad_vendida
    FROM 
        Productos p
    LEFT JOIN 
        Articulos_Pedido ap ON p.producto_id = ap.producto_id
    GROUP BY 
        p.producto_id, p.nombre
    ORDER BY 
        cantidad_vendida DESC;
END;
$$ LANGUAGE plpgsql;

--Verificando función.
SELECT * FROM Ranking_Productos_Mas_Vendidos();

-- 5.Función que retorna un listado de los productos mejor calificados y que opinan los clientes.
CREATE OR REPLACE FUNCTION Ranking_Productos_Por_Calificacion()
RETURNS TABLE (
    producto_id INT,
    nombre_producto VARCHAR,
    promedio_calificacion NUMERIC,
    comentario TEXT,
    cliente_nombre VARCHAR,
    cliente_apellido VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.producto_id,
        p.nombre AS nombre_producto,
        COALESCE(AVG(r.calificacion), 0) AS promedio_calificacion,
        r.comentario,
        c.nombre AS cliente_nombre,
        c.apellido AS cliente_apellido
    FROM 
        Productos p
    LEFT JOIN 
        Reseñas r ON p.producto_id = r.producto_id
    LEFT JOIN 
        Clientes c ON r.cliente_id = c.cliente_id
    GROUP BY 
        p.producto_id, p.nombre, r.comentario, c.nombre, c.apellido
    ORDER BY 
        promedio_calificacion DESC;
END;
$$ LANGUAGE plpgsql;

--Verificando función.
SELECT * FROM Ranking_Productos_Por_Calificacion();

