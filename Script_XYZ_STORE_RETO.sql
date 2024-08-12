-- RETO BASE DE DATOS
-- HAROLD CHOLES MEJIA 

-- CREACION DE LA BASE DE DATOS
CREATE DATABASE XYZ_STORE;

-- CREACION DE LA TABLA DE CLIENTES
CREATE TABLE CLIENTES (
    CLIENTE_ID SERIAL PRIMARY KEY,
    NOMBRE VARCHAR(50) NOT NULL,
    APELLIDO VARCHAR(50) NOT NULL,
    DIRECCION VARCHAR(200),
    TELEFONO VARCHAR(100),
    CORREO_ELECTRONICO VARCHAR(100) UNIQUE NOT NULL,
    FECHA_REGISTRO TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CREACION DE LA TABLA DE PRODUCTOS
CREATE TABLE PRODUCTOS (
    PRODUCTO_ID SERIAL PRIMARY KEY,
    NOMBRE VARCHAR(100) NOT NULL,
    DESCRIPCION TEXT,
    PRECIO NUMERIC(10, 2) NOT NULL,
    STOCK INTEGER NOT NULL,
    CATEGORIA VARCHAR(50)
);

-- CREACION DE LA TABLA DE PEDIDOS
CREATE TABLE PEDIDOS (
    PEDIDO_ID SERIAL PRIMARY KEY,
    CLIENTE_ID INTEGER REFERENCES CLIENTES(CLIENTE_ID) ON DELETE CASCADE,
    FECHA_PEDIDO TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ESTADO VARCHAR(20) NOT NULL CHECK (ESTADO IN ('PROCESANDO', 'ENVIADO', 'ENTREGADO')),
    PRECIO_TOTAL NUMERIC(10, 2) NOT NULL
);

-- CREAR LA TABLA DE DETALLES DEL PEDIDO
CREATE TABLE DETALLE_PEDIDO (
    DETALLE_ID SERIAL PRIMARY KEY,
    PEDIDO_ID INTEGER REFERENCES PEDIDOS(PEDIDO_ID) ON DELETE CASCADE,
    PRODUCTO_ID INTEGER REFERENCES PRODUCTOS(PRODUCTO_ID),
    CANTIDAD INTEGER NOT NULL CHECK (CANTIDAD > 0),
    PRECIO_UNITARIO NUMERIC(10, 2) NOT NULL,
    SUBTOTAL NUMERIC(10, 2) GENERATED ALWAYS AS (CANTIDAD * PRECIO_UNITARIO) STORED
);


-- CREACION DE LA TABLA DE RESEÑAS
CREATE TABLE RESENAS (
    RESENA_ID SERIAL PRIMARY KEY,
    PRODUCTO_ID INTEGER REFERENCES PRODUCTOS(PRODUCTO_ID),
    CLIENTE_ID INTEGER REFERENCES CLIENTES(CLIENTE_ID),
    CALIFICACION INTEGER CHECK (CALIFICACION BETWEEN 1 AND 5),
    COMENTARIO TEXT,
    FECHA_RESENA TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CREACION DE LA TABLA DE LISTA DE DESEOS
CREATE TABLE LISTA_DESEOS (
    LISTA_ID SERIAL PRIMARY KEY,
    CLIENTE_ID INTEGER REFERENCES CLIENTES(CLIENTE_ID),
    PRODUCTO_ID INTEGER REFERENCES PRODUCTOS(PRODUCTO_ID)
);


--INSERCION DE REGISTROS

--TABLA CLIENTES
INSERT INTO CLIENTES (NOMBRE, APELLIDO, DIRECCION, TELEFONO, CORREO_ELECTRONICO)
VALUES
('ANA', 'GARCÍA', 'CALLE 123, CIUDAD', '555-0101', 'ANA.GARCIA@EXAMPLE.COM'),
('LUIS', 'PÉREZ', 'AVENIDA 456, CIUDAD', '555-0102', 'LUIS.PEREZ@EXAMPLE.COM'),
('MARÍA', 'RODRÍGUEZ', 'CALLE 789, CIUDAD', '555-0103', 'MARIA.RODRIGUEZ@EXAMPLE.COM'),
('JORGE', 'MARTÍNEZ', 'BOULEVARD 101, CIUDAD', '555-0104', 'JORGE.MARTINEZ@EXAMPLE.COM'),
('LAURA', 'GÓMEZ', 'CALLE 202, CIUDAD', '555-0105', 'LAURA.GOMEZ@EXAMPLE.COM'),
('CARLOS', 'SÁNCHEZ', 'AVENIDA 303, CIUDAD', '555-0106', 'CARLOS.SANCHEZ@EXAMPLE.COM'),
('PATRICIA', 'TORRES', 'CALLE 404, CIUDAD', '555-0107', 'PATRICIA.TORRES@EXAMPLE.COM'),
('PEDRO', 'HERNÁNDEZ', 'BOULEVARD 505, CIUDAD', '555-0108', 'PEDRO.HERNANDEZ@EXAMPLE.COM'),
('ISABEL', 'MORALES', 'CALLE 606, CIUDAD', '555-0109', 'ISABEL.MORALES@EXAMPLE.COM'),
('RICARDO', 'JIMÉNEZ', 'AVENIDA 707, CIUDAD', '555-0110', 'RICARDO.JIMENEZ@EXAMPLE.COM');

--TABLA PRODUCTOS
INSERT INTO PRODUCTOS (NOMBRE, DESCRIPCION, PRECIO, STOCK, CATEGORIA)
VALUES
('SMARTPHONE X1', 'SMARTPHONE CON PANTALLA DE 6.5 PULGADAS', 499.99, 30, 'ELECTRÓNICA'),
('LAPTOP PRO', 'LAPTOP POTENTE PARA JUEGOS Y TRABAJO', 1299.99, 15, 'ELECTRÓNICA'),
('AURICULARES BLUETOOTH', 'AURICULARES INALÁMBRICOS CON CANCELACIÓN DE RUIDO', 89.99, 50, 'ELECTRÓNICA'),
('TELEVISOR 4K', 'TELEVISOR ULTRA HD DE 55 PULGADAS', 799.99, 20, 'ELECTRÓNICA'),
('CÁMARA DIGITAL', 'CÁMARA CON LENTE INTERCAMBIABLE', 349.99, 25, 'ELECTRÓNICA'),
('TECLADO MECÁNICO', 'TECLADO CON RETROILUMINACIÓN RGB', 99.99, 40, 'ELECTRÓNICA'),
('MONITOR LED', 'MONITOR FULL HD DE 27 PULGADAS', 199.99, 35, 'ELECTRÓNICA'),
('TABLET PRO', 'TABLET CON SOPORTE PARA LÁPIZ DIGITAL', 399.99, 22, 'ELECTRÓNICA'),
('RELOJ INTELIGENTE', 'RELOJ CON MONITOR DE SALUD Y NOTIFICACIONES', 149.99, 60, 'ELECTRÓNICA'),
('ALTAVOZ INTELIGENTE', 'ALTAVOZ CON ASISTENTE DE VOZ INTEGRADO', 79.99, 45, 'ELECTRÓNICA');

--TABLA PEDIDOS
INSERT INTO PEDIDOS (CLIENTE_ID, FECHA_PEDIDO, ESTADO, PRECIO_TOTAL)
VALUES
(1, '2024-08-01 10:30:00', 'PROCESANDO', 589.98),
(2, '2024-08-02 14:45:00', 'ENVIADO', 1299.99),
(3, '2024-08-03 09:00:00', 'ENTREGADO', 89.99),
(4, '2024-08-04 11:15:00', 'PROCESANDO', 799.99),
(5, '2024-08-05 13:00:00', 'ENVIADO', 349.99),
(6, '2024-08-06 15:30:00', 'ENTREGADO', 99.99),
(7, '2024-08-07 10:00:00', 'PROCESANDO', 199.99),
(8, '2024-08-08 16:45:00', 'ENVIADO', 399.99),
(9, '2024-08-09 12:30:00', 'ENTREGADO', 149.99),
(10, '2024-08-10 14:00:00', 'PROCESANDO', 79.99);


--TABLA DETALLE PEDIDO
INSERT INTO DETALLE_PEDIDO (PEDIDO_ID, PRODUCTO_ID, CANTIDAD, PRECIO_UNITARIO)
VALUES
(1, 1, 1, 499.99),
(1, 3, 1, 89.99),
(2, 2, 1, 1299.99),
(3, 3, 1, 89.99),
(4, 4, 1, 799.99),
(5, 5, 1, 349.99),
(6, 6, 1, 99.99),
(7, 7, 1, 199.99),
(8, 8, 1, 399.99),
(9, 9, 1, 149.99);

--TABLA RESEÑAS
INSERT INTO RESENAS (PRODUCTO_ID, CLIENTE_ID, CALIFICACION, COMENTARIO)
VALUES
(1, 1, 5, 'EXCELENTE SMARTPHONE, MUY RECOMENDADO.'),
(2, 2, 4, 'MUY POTENTE, PERO UN POCO CARO.'),
(3, 3, 5, 'GRAN CALIDAD DE SONIDO, ME ENCANTA.'),
(4, 4, 3, 'BUENA IMAGEN, PERO LLEGÓ UN POCO TARDE.'),
(5, 5, 4, 'BUENA CÁMARA, PERO EL PRECIO ES ALTO.'),
(6, 6, 5, 'PERFECTO PARA ESCRIBIR Y JUGAR.'),
(7, 7, 4, 'BUEN MONITOR, PERO PODRÍA SER MÁS GRANDE.'),
(8, 8, 5, 'IDEAL PARA DIBUJAR Y TRABAJAR.'),
(9, 9, 4, 'BUEN RELOJ, AUNQUE LA BATERÍA PODRÍA DURAR MÁS.'),
(10, 1, 3, 'ALTAVOZ BÁSICO, CUMPLE SU FUNCIÓN.');

--TABLA LISTA DE DESEOS
INSERT INTO LISTA_DESEOS (CLIENTE_ID, PRODUCTO_ID)
VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 4),
(3, 5),
(4, 6),
(5, 7),
(6, 8),
(7, 9),
(8, 10);


-- CONSULTAS 

-- 1. CONSULTA PARA OBTENER EL TOTAL DE VENTAS POR CLIENTE
SELECT C.CLIENTE_ID, C.NOMBRE, C.APELLIDO, SUM(P.PRECIO_TOTAL) AS TOTAL_GASTADO
FROM CLIENTES C
JOIN PEDIDOS P ON C.CLIENTE_ID = P.CLIENTE_ID
GROUP BY C.CLIENTE_ID, C.NOMBRE, C.APELLIDO
ORDER BY TOTAL_GASTADO DESC;

--2. CONSULTA PARA VER LOS DETALLES DE UN PEDIDO ESPECÍFICO
SELECT 
    P.PEDIDO_ID,P.ESTADO AS ESTADO_PEDIDO,P.CLIENTE_ID,
	C.NOMBRE AS NOMBRE_CLIENTE,C.APELLIDO AS APELLIDO_CLIENTE,
    DP.PRODUCTO_ID,DP.CANTIDAD,DP.PRECIO_UNITARIO,DP.SUBTOTAL,P.FECHA_PEDIDO
FROM PEDIDOS P
JOIN CLIENTES C ON P.CLIENTE_ID = C.CLIENTE_ID
JOIN DETALLE_PEDIDO DP ON P.PEDIDO_ID = DP.PEDIDO_ID
WHERE P.PEDIDO_ID = 1; 

--3. CONSULTA PARA OBTENER EL STOCK ACTUAL DE TODOS LOS PRODUCTOS
SELECT PRODUCTO_ID, NOMBRE, STOCK
FROM PRODUCTOS 
ORDER BY NOMBRE;

--4. CONSULTA PARA OBTENER EL STOCK ACTUAL DE UN PRODUCTO EN ESPECIFICO
SELECT PRODUCTO_ID, NOMBRE,STOCK
FROM PRODUCTOS
WHERE PRODUCTO_ID = 5;

--5 CONSULTA PARA BUSCAR PRODUCTOS POR CATEGORÍA Y RANGO DE PRECIO
SELECT PRODUCTO_ID, NOMBRE,DESCRIPCION,PRECIO,STOCK
FROM PRODUCTOS
WHERE CATEGORIA = 'ELECTRÓNICA' AND PRECIO BETWEEN 100 AND 500
ORDER BY PRECIO;

-- 6. CONSULTA PARA VER EL HISTORIAL DE RESEÑAS DE UN PRODUCTO ESPECÍFICO
SELECT R.RESENA_ID,R.CLIENTE_ID,C.NOMBRE AS CLIENTE_NOMBRE,C.APELLIDO AS CLIENTE_APELLIDO,
    R.CALIFICACION,R.COMENTARIO,R.FECHA_RESENA
FROM RESENAS R
JOIN CLIENTES C ON R.CLIENTE_ID = C.CLIENTE_ID
WHERE R.PRODUCTO_ID = 1  
ORDER BY R.FECHA_RESENA DESC;


--7. HISTORIAL DE PEDIDOS DE UN CLIENTE
SELECT P.PEDIDO_ID,P.FECHA_PEDIDO,P.ESTADO,P.PRECIO_TOTAL
FROM PEDIDOS P
WHERE P.CLIENTE_ID = 3
ORDER BY P.FECHA_PEDIDO DESC;

--8. BUSCAR PRODUCTOS EN UNA CATEGORÍA CON BAJO STOCK
SELECT PRODUCTO_ID,NOMBRE,STOCK,PRECIO
FROM PRODUCTOS
WHERE CATEGORIA = 'ELECTRÓNICA' AND STOCK < 10;

--9.  CONOCER EL TOTAL DE VENTAS DE UN PRODUCTO
SELECT P.PRODUCTO_ID,P.NOMBRE,SUM(DP.SUBTOTAL) AS TOTAL_VENTAS
FROM PRODUCTOS P
JOIN DETALLE_PEDIDO DP ON P.PRODUCTO_ID = DP.PRODUCTO_ID
GROUP BY P.PRODUCTO_ID, P.NOMBRE
ORDER BY TOTAL_VENTAS DESC;

--PROCEDIMIENTOS ALMACENADOS

--1. PROCEDIMIENTO PARA ACTUALIZAR EL STOCK DE UN PRODUCTO
CREATE OR REPLACE PROCEDURE ACTUALIZAR_STOCK_PRODUCTO(
    P_PRODUCTO_ID INTEGER, 
	P_NUEVO_STOCK INTEGER
)
LANGUAGE PLPGSQL
AS $$
	BEGIN
		UPDATE PRODUCTOS SET STOCK = P_NUEVO_STOCK WHERE PRODUCTO_ID = P_PRODUCTO_ID;

		IF NOT FOUND THEN
			RAISE EXCEPTION 'PRODUCTO CON ID % NO ENCONTRADO.', P_PRODUCTO_ID;
		END IF;
	END;
$$;

CALL ACTUALIZAR_STOCK_PRODUCTO(5,20);

--2. PROCEDIMIENTO PARA CREAR UN NUEVO PEDIDO
CREATE OR REPLACE PROCEDURE CREAR_NUEVO_PEDIDO(
    P_CLIENTE_ID INTEGER,
    P_ESTADO VARCHAR(20),
    P_PRECIO_TOTAL NUMERIC(10, 2),
    P_PRODUCTO_ID INTEGER,
    P_CANTIDAD INTEGER,
    P_PRECIO_UNITARIO NUMERIC(10, 2)
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    V_PEDIDO_ID INTEGER;
	BEGIN
		-- INSERTAR EL NUEVO PEDIDO
		INSERT INTO PEDIDOS (CLIENTE_ID, ESTADO, PRECIO_TOTAL)
		VALUES (P_CLIENTE_ID, P_ESTADO, P_PRECIO_TOTAL)
		RETURNING PEDIDO_ID INTO V_PEDIDO_ID;

		-- INSERTAR DETALLE DEL PEDIDO
		INSERT INTO DETALLE_PEDIDO (PEDIDO_ID, PRODUCTO_ID, CANTIDAD, PRECIO_UNITARIO)
		VALUES (V_PEDIDO_ID, P_PRODUCTO_ID, P_CANTIDAD, P_PRECIO_UNITARIO);

		-- ACTUALIZAR EL STOCK DEL PRODUCTO
		UPDATE PRODUCTOS
		SET STOCK = STOCK - P_CANTIDAD
		WHERE PRODUCTO_ID = P_PRODUCTO_ID;

		IF NOT FOUND THEN
			RAISE EXCEPTION 'PRODUCTO CON ID % NO ENCONTRADO.', P_PRODUCTO_ID;
		END IF;

	END;
$$;

CALL CREAR_NUEVO_PEDIDO(3,'ENVIADO',120.50,1,2,30.00);


--3. REGISTRAR UNA NUEVA RESEÑA
CREATE OR REPLACE PROCEDURE REGISTRAR_RESENA(
    P_PRODUCTO_ID INTEGER,
    P_CLIENTE_ID INTEGER,
    P_CALIFICACION INTEGER,
    P_COMENTARIO TEXT
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    INSERT INTO RESENAS (PRODUCTO_ID, CLIENTE_ID, CALIFICACION, COMENTARIO)
    VALUES (P_PRODUCTO_ID, P_CLIENTE_ID, P_CALIFICACION, P_COMENTARIO);

    IF NOT FOUND THEN
        RAISE EXCEPTION 'NO SE PUDO REGISTRAR LA RESEÑA PARA EL PRODUCTO CON ID %.', P_PRODUCTO_ID;
    END IF;
END;
$$;

CALL REGISTRAR_RESENA(1, 2, 5,'EXCELENTE PRODUCTO, LO RECOMIENDO!');

--4. ACTUALIZAR EL STOCK DE UN PRODUCTO
CREATE OR REPLACE PROCEDURE ACTUALIZAR_STOCK_PRODUCTO(
    P_PRODUCTO_ID INTEGER,
    P_NUEVO_STOCK INTEGER
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    -- ACTUALIZAR EL STOCK DEL PRODUCTO
    UPDATE PRODUCTOS
    SET STOCK = P_NUEVO_STOCK
    WHERE PRODUCTO_ID = P_PRODUCTO_ID;
    
    -- VERIFICAR SI EL PRODUCTO FUE ACTUALIZADO
    IF NOT FOUND THEN
        RAISE EXCEPTION 'PRODUCTO CON ID % NO ENCONTRADO', P_PRODUCTO_ID;
    END IF;
END;
$$;

CALL ACTUALIZAR_STOCK_PRODUCTO(1, 100);

--5. AGREGAR UN NUEVO CLIENTE
CREATE OR REPLACE PROCEDURE AGREGAR_CLIENTE(
    P_NOMBRE VARCHAR(50),
    P_APELLIDO VARCHAR(50),
    P_DIRECCION VARCHAR(200),
    P_TELEFONO VARCHAR(100),
    P_CORREO_ELECTRONICO VARCHAR(100)
)
LANGUAGE PLPGSQL
AS $$
BEGIN
    -- INSERTAR UN NUEVO CLIENTE
    INSERT INTO CLIENTES (NOMBRE, APELLIDO, DIRECCION, TELEFONO, CORREO_ELECTRONICO)
    VALUES (P_NOMBRE, P_APELLIDO, P_DIRECCION, P_TELEFONO, P_CORREO_ELECTRONICO);
END;
$$;

CALL AGREGAR_CLIENTE('JUAN', 'PÉREZ', 'CALLE FALSA 123', '555-1234', 'JUAN.PEREZ@EXAMPLE.COM');


-- FUNCIONES

--1. CALCULAR EL PRECIO TOTAL DE UN PEDIDO
CREATE OR REPLACE FUNCTION CALCULAR_PRECIO_TOTAL_PEDIDO(P_PEDIDO_ID INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    V_PRECIO_TOTAL NUMERIC;
BEGIN
    SELECT COALESCE(SUM(SUBTOTAL), 0)
    INTO V_PRECIO_TOTAL
    FROM DETALLE_PEDIDO
    WHERE PEDIDO_ID = P_PEDIDO_ID;

    RETURN V_PRECIO_TOTAL;
END;
$$ LANGUAGE PLPGSQL;

SELECT CALCULAR_PRECIO_TOTAL_PEDIDO(1);

--2. OBTENER EL NOMBRE DEL CLIENTE POR ID
CREATE OR REPLACE FUNCTION OBTENER_NOMBRE_CLIENTE(P_CLIENTE_ID INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    V_NOMBRE_COMPLETO VARCHAR;
BEGIN
    SELECT CONCAT(NOMBRE, ' ', APELLIDO)
    INTO V_NOMBRE_COMPLETO
    FROM CLIENTES
    WHERE CLIENTE_ID = P_CLIENTE_ID;

    RETURN V_NOMBRE_COMPLETO;
END;
$$ LANGUAGE PLPGSQL;

SELECT OBTENER_NOMBRE_CLIENTE(1);

--3. VERIFICAR EL STOCK DE UN PRODUCTO
CREATE OR REPLACE FUNCTION VERIFICAR_STOCK_PRODUCTO(P_PRODUCTO_ID INTEGER, P_CANTIDAD_REQUERIDA INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    V_STOCK_ACTUAL INTEGER;
BEGIN
    SELECT STOCK
    INTO V_STOCK_ACTUAL
    FROM PRODUCTOS
    WHERE PRODUCTO_ID = P_PRODUCTO_ID;

    RETURN V_STOCK_ACTUAL >= P_CANTIDAD_REQUERIDA;
END;
$$ LANGUAGE PLPGSQL;

SELECT VERIFICAR_STOCK_PRODUCTO(1, 5);


--4. OBTENER LA CANTIDAD DE PEDIDOS POR CLIENTE
CREATE OR REPLACE FUNCTION CANTIDAD_PEDIDOS_POR_CLIENTE(P_CLIENTE_ID INTEGER)
RETURNS INTEGER AS $$
DECLARE
    V_CANTIDAD_PEDIDOS INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO V_CANTIDAD_PEDIDOS
    FROM PEDIDOS
    WHERE CLIENTE_ID = P_CLIENTE_ID;

    RETURN V_CANTIDAD_PEDIDOS;
END;
$$ LANGUAGE PLPGSQL;

SELECT CANTIDAD_PEDIDOS_POR_CLIENTE(1);

--5. OBTENER RESEÑAS PROMEDIO DE UN PRODUCTO
CREATE OR REPLACE FUNCTION CALCULAR_CALIFICACION_PROMEDIO(P_PRODUCTO_ID INTEGER)
RETURNS NUMERIC AS $$
DECLARE
    V_CALIFICACION_PROMEDIO NUMERIC;
BEGIN
    SELECT COALESCE(AVG(CALIFICACION), 0)
    INTO V_CALIFICACION_PROMEDIO
    FROM RESENAS
    WHERE PRODUCTO_ID = P_PRODUCTO_ID;

    RETURN V_CALIFICACION_PROMEDIO;
END;
$$ LANGUAGE PLPGSQL;

SELECT CALCULAR_CALIFICACION_PROMEDIO(1);

