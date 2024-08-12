-- Crear la base de datos
CREATE DATABASE assoed_store;

-- Conectar a la base de datos
\c assoed_store;

-- Crear la tabla Clientes
CREATE TABLE Clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion TEXT NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear la tabla Productos
CREATE TABLE Productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10, 2) CHECK (precio >= 0) NOT NULL,
    stock INT CHECK (stock >= 0) NOT NULL,
    categoria VARCHAR(50) NOT NULL
);

-- Crear la tabla Pedidos
CREATE TABLE Pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES Clientes(id_cliente) ON DELETE CASCADE,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('procesando', 'enviado', 'entregado')) NOT NULL,
    precio_total NUMERIC(10, 2) CHECK (precio_total >= 0) NOT NULL
);

-- Crear la tabla Detalle_pedidos
CREATE TABLE Detalle_pedidos (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INT REFERENCES Pedidos(id_pedido) ON DELETE CASCADE,
    id_producto INT REFERENCES Productos(id_producto),
    cantidad INT CHECK (cantidad > 0) NOT NULL,
    precio_unitario NUMERIC(10, 2) CHECK (precio_unitario >= 0) NOT NULL,
    CONSTRAINT precio_detalle_pos CHECK (cantidad * precio_unitario >= 0)
);

-- Crear la tabla Reseñas
CREATE TABLE Reseñas (
    id_reseña SERIAL PRIMARY KEY,
    id_producto INT REFERENCES Productos(id_producto) ON DELETE CASCADE,
    id_cliente INT REFERENCES Clientes(id_cliente) ON DELETE CASCADE,
    calificación INT CHECK (calificación BETWEEN 1 AND 5) NOT NULL,
    comentario TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear la tabla Lista_deseos
CREATE TABLE Lista_deseos (
    id_lista SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES Clientes(id_cliente) ON DELETE CASCADE,
    id_producto INT REFERENCES Productos(id_producto) ON DELETE CASCADE
);

-- Crear la tabla Inventario
CREATE TABLE Inventario (
    id_inventario SERIAL PRIMARY KEY,
    id_producto INT REFERENCES Productos(id_producto) ON DELETE CASCADE,
    stock_actual INT CHECK (stock_actual >= 0) NOT NULL
);

-- Triggers para actualizar el stock en la tabla Inventario cuando se realiza una compra
CREATE OR REPLACE FUNCTION actualizar_stock() 
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Inventario
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_actualizar_stock
AFTER INSERT ON Detalle_pedidos
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock();


-- Insertar datos en la tabla Clientes
INSERT INTO Clientes (nombre, apellido, direccion, telefono, correo_electronico)
VALUES 
('John', 'Doe', '123 Main St, Springfield', '555-1234', 'john.doe@hotmail.com'),
('Jane', 'Smith', '456 Elm St, Springfield', '555-5678', 'jane.smith@hotmail.com'),
('Michael', 'Johnson', '789 Oak St, Springfield', '555-8765', 'michael.johnson@hotmail.com'),
('Emily', 'Davis', '101 Maple St, Springfield', '555-4321', 'emily.davis@hotmail.com'),
('David', 'Wilson', '202 Pine St, Springfield', '555-9876', 'david.wilson@hotmail.com'),
('Sophia', 'Martinez', '303 Cedar St, Springfield', '555-6543', 'sophia.martinez@hotmail.com'),
('James', 'Brown', '404 Birch St, Springfield', '555-3210', 'james.brown@hotmail.com');


-- Insertar datos en la tabla Productos
INSERT INTO Productos (nombre, descripcion, precio, stock, categoria)
VALUES
('Laptop HP', 'Laptop HP con procesador Intel i5, 8GB RAM, 256GB SSD', 750.00, 25, 'Electrónica'),
('Smartphone Samsung', 'Samsung Galaxy S21 con pantalla AMOLED, 128GB', 999.99, 40, 'Electrónica'),
('Audífonos Sony', 'Audífonos inalámbricos Sony con cancelación de ruido', 199.99, 60, 'Accesorios'),
('Televisor LG', 'Televisor LG 55 pulgadas 4K UHD', 1200.00, 15, 'Electrónica'),
('Cámara Canon', 'Cámara réflex Canon EOS 200D con lente 18-55mm', 450.00, 10, 'Fotografía'),
('Smartwatch Apple', 'Apple Watch Series 6 con GPS y monitor de salud', 399.99, 30, 'Accesorios'),
('Tablet Amazon', 'Tablet Amazon Fire HD 8, 32GB', 89.99, 50, 'Electrónica');

-- Insertar datos en la tabla Pedidos
INSERT INTO Pedidos (id_cliente, estado, precio_total)
VALUES
(1, 'procesando', 1749.99),
(2, 'enviado', 1200.00),
(3, 'entregado', 650.00),
(4, 'procesando', 999.99),
(5, 'entregado', 150.00),
(6, 'enviado', 399.99),
(7, 'procesando', 199.99);

-- Insertar datos en la tabla Detalle_pedidos
INSERT INTO Detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario)
VALUES
(1, 1, 1, 750.00),
(1, 2, 1, 999.99),
(2, 4, 1, 1200.00),
(3, 5, 1, 450.00),
(3, 7, 1, 199.99),
(4, 2, 1, 999.99),
(5, 3, 1, 150.00),
(6, 6, 1, 399.99),
(7, 3, 1, 199.99);

-- Insertar datos en la tabla Reseñas
INSERT INTO Reseñas (id_producto, id_cliente, calificación, comentario)
VALUES
(1, 1, 5, 'Excelente laptop, muy rápida.'),
(2, 2, 4, 'Buen smartphone, pero la batería podría durar más.'),
(3, 3, 4, 'Muy buenos audífonos, cancelan el ruido perfectamente.'),
(4, 4, 5, 'La calidad de imagen es impresionante.'),
(5, 5, 3, 'Buena cámara, pero esperaba más funciones.'),
(6, 6, 5, 'El mejor smartwatch que he tenido.'),
(7, 7, 4, 'Buena tablet, pero un poco lenta.');

-- Insertar datos en la tabla Lista_deseos
INSERT INTO Lista_deseos (id_cliente, id_producto)
VALUES
(1, 6),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 5),
(7, 7);

-- Insertar datos en la tabla Inventario
INSERT INTO Inventario (id_producto, stock_actual)
VALUES
(1, 24),
(2, 38),
(3, 58),
(4, 14),
(5, 9),
(6, 29),
(7, 49);

--## 5 consultas que aporten valor al negocio.

--Productos más vendidos
SELECT p.nombre, SUM(dp.cantidad) AS total_vendido
FROM Productos p
JOIN Detalle_pedidos dp ON p.id_producto = dp.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY total_vendido DESC
LIMIT 10;


--Clientes con mayor compras
SELECT c.nombre, c.apellido, SUM(p.precio_total) AS total_gastado
FROM Clientes c
JOIN Pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre, c.apellido
ORDER BY total_gastado DESC
LIMIT 10;

--Productos con menor stock
SELECT p.nombre, i.stock_actual
FROM Productos p
JOIN Inventario i ON p.id_producto = i.id_producto
WHERE i.stock_actual <= 10
ORDER BY i.stock_actual ASC;


--Promedio de calificación por producto
SELECT p.nombre, AVG(r.calificación) AS promedio_calificación
FROM Productos p
JOIN Reseñas r ON p.id_producto = r.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY promedio_calificación DESC;

--Ingresos por mes
SELECT TO_CHAR(p.fecha_hora, 'YYYY-MM') AS mes, SUM(p.precio_total) AS ingresos_mensuales
FROM Pedidos p
GROUP BY TO_CHAR(p.fecha_hora, 'YYYY-MM')
ORDER BY mes DESC;

--### 5 procedimientos almacenados que aporten valor al negocio.

--Actualizar el stock después de una venta
CREATE OR REPLACE PROCEDURE actualizar_stock_venta(
    p_id_producto INT,
    p_cantidad_vendida INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Inventario
    SET stock_actual = stock_actual - p_cantidad_vendida
    WHERE id_producto = p_id_producto;
    
    IF (SELECT stock_actual FROM Inventario WHERE id_producto = p_id_producto) <= 5 THEN
		 RAISE NOTICE 'El producto % tiene un stock bajo de % unidades', p_id_producto, (SELECT stock_actual FROM Inventario WHERE id_producto = p_id_producto);
    END IF;
END;
$$;

CALL actualizar_stock_venta(1, 3);
SELECT * FROM Inventario WHERE id_producto = 1;
--Generar reporte de ventas mensual

CREATE OR REPLACE PROCEDURE reporte_ventas_mensual(
    p_year INT,
    p_mes INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_pedidos INT;
    v_total_ingresos NUMERIC;
    v_promedio_por_pedido NUMERIC;
BEGIN
    SELECT COUNT(id_pedido), 
           SUM(precio_total), 
           AVG(precio_total)
    INTO v_total_pedidos, 
         v_total_ingresos, 
         v_promedio_por_pedido
    FROM Pedidos
    WHERE EXTRACT(YEAR FROM fecha_hora) = p_year
      AND EXTRACT(MONTH FROM fecha_hora) = p_mes;

    RAISE NOTICE 'Reporte de Ventas para el Mes %-%:', p_year, p_mes;
    RAISE NOTICE 'Total de Pedidos: %', v_total_pedidos;
    RAISE NOTICE 'Total de Ingresos: %', v_total_ingresos;
    RAISE NOTICE 'Promedio por Pedido: %', v_promedio_por_pedido;
END;
$$;

CALL reporte_ventas_mensual(2024, 8);
--Añadir un producto a la lista de deseos

CREATE OR REPLACE PROCEDURE agregar_a_lista_deseos(
    p_id_cliente INT,
    p_id_producto INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Lista_deseos 
        WHERE id_cliente = p_id_cliente 
          AND id_producto = p_id_producto
    ) THEN
        INSERT INTO Lista_deseos (id_cliente, id_producto)
        VALUES (p_id_cliente, p_id_producto);
    ELSE
        RAISE NOTICE 'El producto % ya está en la lista de deseos del cliente %', p_id_producto, p_id_cliente;
    END IF;
END;
$$;


CALL agregar_a_lista_deseos(1, 2);
SELECT * FROM Lista_deseos WHERE id_cliente = 1;

--Marcar un pedido como enviado
CREATE OR REPLACE PROCEDURE marcar_pedido_enviado(
    p_id_pedido INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Pedidos
    SET estado = 'enviado'
    WHERE id_pedido = p_id_pedido
      AND estado = 'procesando';

    IF FOUND THEN
        RAISE NOTICE 'El pedido % ha sido marcado como enviado', p_id_pedido;
    ELSE
        RAISE NOTICE 'El pedido % ya está en estado enviado o no existe', p_id_pedido;
    END IF;
END;
$$;

CALL marcar_pedido_enviado(1);
SELECT * FROM Pedidos WHERE id_pedido = 1;

--Obtener promedio de calificación de un producto

CREATE OR REPLACE PROCEDURE obtener_promedio_calificacion(
    p_id_producto INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_promedio_calificacion NUMERIC;
BEGIN
    SELECT AVG(calificación)
    INTO v_promedio_calificacion
    FROM Reseñas
    WHERE id_producto = p_id_producto;

    RAISE NOTICE 'El promedio de calificación para el producto % es %', p_id_producto, v_promedio_calificacion;
END;
$$;


CALL obtener_promedio_calificacion(1);


--5 funciones que aporten valor al negocio.

--Calcular el total de ingresos generados por cliente

CREATE OR REPLACE FUNCTION total_ingresos_por_cliente(
    p_id_cliente INT
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_ingresos NUMERIC;
BEGIN
    SELECT SUM(precio_total)
    INTO v_total_ingresos
    FROM Pedidos
    WHERE id_cliente = p_id_cliente;

    RETURN COALESCE(v_total_ingresos, 0);
END;
$$;

SELECT total_ingresos_por_cliente(5);

--Obtener la cantidad de productos en una categoría

CREATE OR REPLACE FUNCTION cantidad_productos_por_categoria(
    p_id_categoria VARCHAR(50)
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_cantidad INT;
BEGIN
    SELECT COUNT(*)
    INTO v_cantidad
    FROM Productos
    WHERE categoria = p_id_categoria;

    RETURN v_cantidad;
END;
$$;

SELECT cantidad_productos_por_categoria('Electrónica');

--Calcular el descuento aplicado en un pedido
CREATE OR REPLACE FUNCTION calcular_descuento_pedido(
    p_id_pedido INT
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_precio_original NUMERIC;
    v_precio_final NUMERIC;
BEGIN
    SELECT SUM(precio_unitario * cantidad)
    INTO v_precio_original
    FROM Detalle_pedidos
    WHERE id_pedido = p_id_pedido;

    SELECT precio_total
    INTO v_precio_final
    FROM Pedidos
    WHERE id_pedido = p_id_pedido;

    RETURN COALESCE(v_precio_original - v_precio_final, 0);
END;
$$;

SELECT calcular_descuento_pedido(2);

--Verificar disponibilidad de stock
CREATE OR REPLACE FUNCTION verificar_stock_disponible(
    p_id_producto INT,
    p_cantidad INT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_actual INT;
BEGIN
    SELECT stock_actual
    INTO v_stock_actual
    FROM Inventario
    WHERE id_producto = p_id_producto;

    RETURN v_stock_actual >= p_cantidad;
END;
$$;

SELECT verificar_stock_disponible(1, 5);
SELECT verificar_stock_disponible(5, 10);

--Obtener el producto que genera mas ganacia
CREATE OR REPLACE FUNCTION nivel_stock_bajo(
    p_umbral_minimo INT
)
RETURNS TABLE(
    id_producto INT,
    nombre_producto VARCHAR(100),
    stock_actual INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id_producto,
        p.nombre,
        i.stock_actual AS stock_actual
    FROM 
        Productos p
    JOIN 
        Inventario i ON p.id_producto = i.id_producto
    WHERE 
        i.stock_actual < p_umbral_minimo
    ORDER BY 
        stock_actual ASC;
END;
$$;

SELECT * FROM nivel_stock_bajo(10);