-- 5 consultas que aporten valor al negocio.

-- 1. Obtener el nombre y apellido de los clientes que han realizado pedidos
SELECT c.nombre, c.apellido
FROM clientes c
JOIN pedidos p ON c.id_usuario = p.id_usuario;


--2. Obtener el nombre y descripción de los productos que están en la lista de deseos
SELECT p.nombre, p.descripcion
FROM productos p
JOIN lista_deseos ld ON p.id_producto = ld.id_producto;


--3. Obtener el nombre y precio de los productos que tienen un stock menor a 50
SELECT nombre, precio
FROM productos
WHERE stock < 50;


--4. Obtener el nombre y categoría de los productos que han sido pedidos
SELECT p.nombre, p.categoria
FROM productos p
JOIN detalle_pedidos dp ON p.id_producto = dp.id_producto
JOIN pedidos pe ON dp.id_pedido = pe.id_pedido;

--5. cantidad de productos que han sido pedidos
SELECT SUM(cantidad) AS total_productos_pedidos
FROM detalle_pedidos;

------------
-- 5 procedimientos almacenados que aporten valor al negocio.
--1 Procedimiento para insertar un nuevo cliente
CREATE OR REPLACE PROCEDURE insertarCliente(
    p_nombre VARCHAR,
    p_apellido VARCHAR,
    p_email VARCHAR,
    p_telefono VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO clientes (nombre, apellido, email, telefono)
    VALUES (p_nombre, p_apellido, p_email, p_telefono);
END;
$$;

CALL insertarCliente('andres', 'adsd', 'andres.peresdz@example.com', '123456789');


--2 Procedimiento para insertar un nuevo producto
CREATE OR REPLACE PROCEDURE insertarProducto(
    p_nombre VARCHAR,
    p_descripcion VARCHAR,
    p_precio NUMERIC,
    p_stock INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO productos (nombre, descripcion, precio, stock)
    VALUES (p_nombre, p_descripcion, p_precio, p_stock);
END;
$$;

CALL insertarProducto('Producto A', 'Descripción del Producto A', 19.99, 100);


--3 Procedimiento para insertar un nuevo pedido
CREATE OR REPLACE PROCEDURE insertarPedido(
    p_id_cliente INT,
    p_fecha DATE,
    p_total DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO pedidos (id_cliente, fecha, total)
    VALUES (p_id_cliente, p_fecha, p_total);
END;
$$;

CALL insertarPedido(1, '2023-10-01', 150.75);


--4 Procedimiento para insertar un nuevo detalle de pedido
CREATE OR REPLACE PROCEDURE insertarDetallePedido(
    p_id_pedido INT,
    p_id_producto INT,
    p_cantidad INT,
    p_precio_unitario DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO detalles_pedido (id_pedido, id_producto, cantidad, precio_unitario)
    VALUES (p_id_pedido, p_id_producto, p_cantidad, p_precio_unitario);
END;
$$;

CALL insertarDetallePedido(1, 101, 2, 19.99);


--5 Procedimiento para insertar un nuevo producto en la lista de deseos
CREATE OR REPLACE PROCEDURE insertarProductoListaDeseos(
    p_id_cliente INT,
    p_id_producto INT,
    p_fecha_agregado DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO lista_deseos (id_cliente, id_producto, fecha_agregado)
    VALUES (p_id_cliente, p_id_producto, p_fecha_agregado);
END;
$$;

CALL insertarProductoListaDeseos(1, 101, '2023-10-01');


------------
-- 5 funciones que aporten valor al negocio.
--1 Función para obtener el total de productos en stock
CREATE OR REPLACE FUNCTION obtenerTotalProductosEnStock()
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total_stock INT;
BEGIN
    SELECT SUM(stock) INTO total_stock FROM productos;
    RETURN total_stock;
END;
$$;

SELECT obtenerTotalProductosEnStock();


--2 Funcion para obtener el total de clientes
CREATE OR REPLACE FUNCTION obtenerTotalClientes()
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total_clientes INT;
BEGIN
    SELECT COUNT(*) INTO total_clientes FROM clientes;
    RETURN total_clientes;
END;
$$;

SELECT obtenerTotalClientes();


--3 Función para obtener el total de pedidos
CREATE OR REPLACE FUNCTION obtenerTotalPedidos()
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total_pedidos INT;
BEGIN
    SELECT COUNT(*) INTO total_pedidos FROM pedidos;
    RETURN total_pedidos;
END;
$$;

SELECT obtenerTotalPedidos();


--3 Función para obtener el total de productos en la lista de deseos
CREATE OR REPLACE FUNCTION obtenerTotalProductosListaDeseos()
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    total_productos INT;
BEGIN
    SELECT COUNT(*) INTO total_productos FROM lista_deseos;
    RETURN total_productos;
END;
$$;


SELECT obtenerTotalProductosListaDeseos();
