CREATE TABLE Clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    correo_electronico VARCHAR(200) UNIQUE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Productos (
    producto_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10, 2) NOT NULL,
    stock INT NOT NULL,
    categoria VARCHAR(50)
);

CREATE TABLE Pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES Clientes(cliente_id),
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) CHECK (estado IN ('Procesando', 'Enviado', 'Entregado'))
);

CREATE TABLE Detalle_Pedidos (
    detalle_id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES Pedidos(pedido_id),
    producto_id INT REFERENCES Productos(producto_id),
    cantidad INT NOT NULL,
    precio NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Transacciones (
    transaccion_id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES Pedidos(pedido_id),
    fecha_transaccion TIMESTAMP,
    monto NUMERIC(10, 2),
    tipo_transaccion VARCHAR(50),
    descripcion TEXT
);

CREATE TABLE Reseñas (
    reseña_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES Clientes(cliente_id),
    producto_id INT REFERENCES Productos(producto_id),
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
    comentario TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Lista_Deseos (
    lista_deseos_id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES Clientes(cliente_id),
    producto_id INT REFERENCES Productos(producto_id),
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro)
VALUES 
('Carlos', 'García', 'Calle 45 #12-34, Bogotá', '3101234567', 'carlos.garcia@gmail.com', '2024-01-15'),
('Ana', 'Pérez', 'Carrera 14 #23-56, Medellín', '3007654321', 'ana.perez@hotmail.com', '2023-02-20'),
('María', 'Rodríguez', 'Avenida Siempre Viva #123, Cali', '3156789123', 'maria.rodriguez@hotmail.com', '2024-08-10'),
('Juan', 'Martínez', 'Calle 9 #45-78, Barranquilla', '3209876543', 'juan.martinez@gmail.com', '2024-04-05'),
('Luis', 'Gómez', 'Carrera 67 #89-12, Cartagena', '3012345678', 'luis.gomez@gmail.com', '2023-05-18');

INSERT INTO Productos (nombre, descripcion, precio, stock, categoria)
VALUES 
('Reloj Despertador Digital', 'Reloj despertador digital con alarma y luz nocturna.', 30000, 200, 'Reloj'),
('Cargador Rápido USB', 'Cargador rápido USB para dispositivos móviles, 18W.', 25000, 150, 'Cargador'),
('Auriculares Inalámbricos', 'Auriculares inalámbricos con cancelación de ruido y micrófono integrado.', 120000, 60, 'Auriculares'),
('Tablet 10 pulgadas', 'Tablet de 10 pulgadas con 64GB de almacenamiento y cámara HD.', 450000, 40, 'Tablet'),
('Smartwatch', 'Smartwatch con monitor de ritmo cardíaco y notificaciones inteligentes.', 180000, 100, 'Reloj'),
('Cámara de Seguridad Wi-Fi', 'Cámara de seguridad Wi-Fi con visión nocturna y detección de movimiento.', 220000, 75, 'Cámaras'),
('Parlantes Bluetooth', 'Bocina Bluetooth portátil con sonido envolvente 360 grados.', 90000, 80, 'Sonido'),
('Cargador Inalámbrico', 'Cargador inalámbrico compatible con smartphones y otros dispositivos', 70000, 120, 'Cargador'),
('Smart TV 50 pulgadas', 'Smart TV 4K de 50 pulgadas', 1300000, 30, 'Televisor'),
('Laptop', 'Laptop con procesador core i7, 16GB RAM y tarjeta gráfica RTX', 3500000, 20, 'Computador');

SELECT * FROM Productos

INSERT INTO Pedidos (cliente_id, fecha_pedido, estado)
VALUES 
(1, '2024-08-01 10:00:00', 'Procesando'),
(2, '2024-08-02 14:30:00', 'Enviado'),
(3, '2024-08-03 16:45:00', 'Entregado'),
(1, '2024-08-04 12:15:00', 'Procesando'),
(2, '2024-08-05 09:20:00', 'Entregado');

select * from Pedidos

INSERT INTO Detalle_Pedidos (pedido_id, producto_id, cantidad, precio)
VALUES 
(1, 1, 2, 30000),
(1, 3, 1, 120000),
(2, 5, 1, 180000),
(3, 4, 2, 450000),
(3, 7, 1, 90000),
(4, 2, 3, 25000),
(4, 6, 1, 220000),
(5, 9, 1, 1300000);

INSERT INTO Transacciones (pedido_id, fecha_transaccion, monto, tipo_transaccion, descripcion)
VALUES 
(1, '2023-08-01 11:00:00', 180000, 'Pago con tarjeta de crédito', 'Compra de productos'),
(2, '2024-08-02 15:00:00', 180000, 'Pago con PayPal', 'Compra de smartwatch'),
(3, '2024-08-03 17:00:00', 990000, 'Pago con tarjeta de débito', 'Compra de tablet y bocina'),
(4, '2024-08-04 13:00:00', 295000, 'Pago con transferencia bancaria', 'Compra de cargador y cámara'),
(5, '2024-08-05 10:00:00', 1300000, 'Pago con tarjeta de crédito', 'Compra de Smart TV');

INSERT INTO Reseñas (cliente_id, producto_id, calificacion, comentario)
VALUES 
(1, 1, 4, 'Buen reloj, cumple su función pero el sonido de la alarma podría ser mejor.'),
(2, 5, 5, 'Excelente smartwatch, muy útil para el día a día.'),
(3, 4, 4, 'La tablet funciona bien, aunque la batería podría durar más.'),
(1, 6, 5, 'Muy buena cámara de seguridad, fácil de instalar.'),
(2, 9, 5, 'Increíble calidad de imagen en esta Smart TV.');

INSERT INTO Lista_Deseos (cliente_id, producto_id, fecha_agregado)
VALUES 
(1, 3, '2024-08-01 08:00:00'),
(2, 7, '2024-08-02 09:30:00'),
(3, 5, '2024-08-03 10:45:00'),
(1, 4, '2024-08-04 11:15:00'),
(2, 6, '2024-08-05 12:20:00');

SELECT * FROM Lista_Deseos

/*CONSULTAS*/

--1 Total de ventas por categoría ordenado en forma descendente

SELECT p.categoria, SUM(dp.cantidad * dp.precio) AS total_ingresos FROM Detalle_Pedidos dp INNER JOIN Productos p ON dp.producto_id = p.producto_id GROUP BY p.categoria ORDER BY total_ingresos DESC;

--2 Clientes que mas han realizado compras

SELECT c.cliente_id, c.nombre, c.apellido, COUNT(p.pedido_id) AS numero_pedidos
FROM Clientes c INNER JOIN Pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nombre, c.apellido
HAVING COUNT(p.pedido_id) > 2 ORDER BY numero_pedidos DESC;

--3 Reseñas positivas

SELECT p.producto_id, p.nombre, AVG(r.calificacion) AS calificacion_promedio, COUNT(r.reseña_id) AS numero_reseñas
FROM Reseñas r INNER JOIN Productos p ON r.producto_id = p.producto_id
GROUP BY p.producto_id, p.nombre HAVING AVG(r.calificacion) >= 4
ORDER BY calificacion_promedio DESC, numero_reseñas DESC;

--4 Resumen compra del cliente
SELECT c.nombre AS nombre_cliente, c.apellido AS apellido_cliente, p.nombre AS nombre_producto, dp.cantidad, dp.precio, (dp.cantidad * dp.precio) AS total_compra
FROM Clientes c
INNER JOIN Pedidos pd ON c.cliente_id = pd.cliente_id INNER JOIN Detalle_Pedidos dp ON pd.pedido_id = dp.pedido_id INNER JOIN Productos p ON dp.producto_id = p.producto_id
ORDER BY nombre_cliente ASC, total_compra DESC;

--5 Cantidad de productos comprados por clientes
SELECT c.nombre AS nombre_cliente, c.apellido AS apellido_cliente, SUM(dp.cantidad) AS total_productos_comprados
FROM Clientes c
INNER JOIN Pedidos pd ON c.cliente_id = pd.cliente_id INNER JOIN Detalle_Pedidos dp ON pd.pedido_id = dp.pedido_id
GROUP BY c.nombre, c.apellido ORDER BY total_productos_comprados DESC;

--6 Actualizar el estado de un pedido
CREATE OR REPLACE PROCEDURE actualizar_estado_pedido(
    var_pedido_id INT,
    var_nuevo_estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Pedidos
    SET estado = var_nuevo_estado
    WHERE pedido_id = var_pedido_id;
END;
$$;

CALL actualizar_estado_pedido(6, 'Enviado')
SELECT * FROM pedidos

--7 Actualizar el stock y decir cuando el stock esté en 1

CREATE OR REPLACE PROCEDURE actualizar_stock(
    var_cliente_id INT,
    var_producto_id INT,
    var_cantidad INT,
    var_precio NUMERIC(10, 2)
)
LANGUAGE plpgsql
AS $$
DECLARE
    vr_pedido_id INT;
    vr_stock INT;
BEGIN

    INSERT INTO Pedidos (cliente_id, fecha_pedido, estado)
    VALUES (var_cliente_id, CURRENT_TIMESTAMP, 'Procesando')
    RETURNING pedido_id INTO vr_pedido_id;

    INSERT INTO Detalle_Pedidos (pedido_id, producto_id, cantidad, precio)
    VALUES (vr_pedido_id, var_producto_id, var_cantidad, var_precio);

    UPDATE Productos
    SET stock = stock - var_cantidad
    WHERE producto_id = var_producto_id
    RETURNING stock INTO vr_stock;
    IF vr_stock = 1 THEN
        RAISE NOTICE 'El stock del producto está en 1';
    END IF;
    RAISE NOTICE 'Se realizó el pedido';
END;
$$;

CALL actualizar_stock(1, 1, 1, 190000);
SELECT * FROM Pedidos

--8 agregar stock a productos

CREATE OR REPLACE PROCEDURE sumar_stock(
    var_producto_id INT,
    var_cantidad INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Productos
    SET stock = stock + var_cantidad
    WHERE producto_id = var_producto_id;
END;
$$;
CALL sumar_stock(3,3)
SELECT * FROM Productos


--9 Eliminar producto de lista de deseo

CREATE OR REPLACE PROCEDURE eliminar_producto_lista_deseos(
    var_cliente_id INT,
    var_producto_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Lista_Deseos
    WHERE cliente_id = var_cliente_id AND producto_id = var_producto_id;
END;
$$;
CALL eliminar_producto_lista_deseos(1,1)
SELECT * FROM Lista_Deseos

--10 Insertar un nuevo cliente
CREATE OR REPLACE PROCEDURE agregar_cliente(
    var_nombre VARCHAR,
    var_apellido VARCHAR,
    var_direccion VARCHAR,
    var_telefono VARCHAR,
    var_correo_electronico VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Clientes (nombre, apellido, direccion, telefono, correo_electronico)
    VALUES (var_nombre, var_apellido, var_direccion, var_telefono, var_correo_electronico);
END;
$$;

CALL agregar_cliente('Juan', 'Pérez', 'Calle Falsa 123', '123-456-7890', 'juan.perez@email.com');

--11 Resumen pedidos en un rango de fecha
CREATE OR REPLACE FUNCTION obtener_resumen_pedidos(
    var_fecha_inicio TIMESTAMP,
    var_fecha_fin TIMESTAMP
)
RETURNS TABLE(
    pedido_id INT,
    fecha_pedido TIMESTAMP,
    nombre_cliente VARCHAR(100),
    apellido_cliente VARCHAR(100),
    total_pedido NUMERIC(10, 2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT p.pedido_id, p.fecha_pedido, c.nombre, c.apellido, SUM(dp.cantidad * dp.precio) AS total_pedido
    FROM Pedidos p
    INNER JOIN Clientes c ON p.cliente_id = c.cliente_id
    INNER JOIN Detalle_Pedidos dp ON p.pedido_id = dp.pedido_id
    WHERE p.fecha_pedido BETWEEN var_fecha_inicio AND var_fecha_fin
    GROUP BY p.pedido_id, p.fecha_pedido, c.nombre, c.apellido
    ORDER BY p.fecha_pedido ASC;
END;
$$;
SELECT * FROM obtener_resumen_pedidos('2024-08-01 00:00:00', '2024-08-30 23:59:59');

--12 Calcular total de pedidos
CREATE OR REPLACE FUNCTION total_pedidos_cliente(
    var_cliente_id INT
)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT SUM(dp.cantidad * dp.precio)
        FROM Detalle_Pedidos dp
        JOIN Pedidos p ON dp.pedido_id = p.pedido_id
        WHERE p.cliente_id = var_cliente_id
    );
END;
$$ LANGUAGE plpgsql;
SELECT total_pedidos_cliente(1) AS total_pedido;


--13 Última fecha de pedido
CREATE OR REPLACE FUNCTION ultima_fecha_pedido(
    var_cliente_id INT
)
RETURNS TIMESTAMP AS $$
BEGIN
    RETURN (
        SELECT MAX(fecha_pedido)
        FROM Pedidos
        WHERE cliente_id = var_cliente_id
    );
END;
$$ LANGUAGE plpgsql;
SELECT ultima_fecha_pedido(2) AS ultima_fecha;


--14 Contar reseñas de un producto
CREATE OR REPLACE FUNCTION contar_reseñas_producto(
    var_producto_id INT
)
RETURNS INT AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM Reseñas
        WHERE producto_id = var_producto_id
    );
END;
$$ LANGUAGE plpgsql;
SELECT contar_reseñas_producto(4) AS total_reseñas;

--15 Obtener stock producto
CREATE OR REPLACE FUNCTION stock_producto(
    var_producto_id INT
)
RETURNS INT AS $$
BEGIN
    RETURN (
        SELECT stock
        FROM Productos
        WHERE producto_id = var_producto_id
    );
END;
$$ LANGUAGE plpgsql;
SELECT stock_producto(1) AS stock_disponible;



