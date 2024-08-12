-- Primero se crea la base de datos XYZStore

CREATE DATABASE "XYZStore"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;


-- Se crean las tablas necesarias para la base de datos

CREATE TABLE clientes (
    cliente_id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    direccion character varying(100),
    telefono character varying(20),
    correo_electronico character varying(200) NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE productos (
    producto_id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion character varying(50) NOT NULL,
    precio decimal(18,2),
    stock int,
    categoria character varying(50) NOT NULL
);

CREATE TABLE pedidos (
    pedido_id integer NOT NULL,
    cliente_id int REFERENCES Clientes(cliente_id) NOT NULL,
    fecha_pedido timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    precio_total decimal(18,2),
    estado character varying(50) NOT NULL
);


CREATE TABLE DetallePedidos (
    detalle_id integer PRIMARY KEY NOT NULL,
    pedido_id int REFERENCES Pedidos(pedido_id) NOT NULL,
    producto_pedido int REFERENCES Productos(producto_id) NOT NULL,
    cantidad int NOT NULL,
    precio_unitario decimal (18,2) NOT NULL
);


CREATE TABLE Reseñas (
    reseña_id integer PRIMARY KEY NOT NULL,
    cliente_id int REFERENCES Clientes(cliente_id) NOT NULL,
    producto_id int REFERENCES Productos(producto_id) NOT NULL,
    comentario varchar (500) NOT NULL,
    calificacion INT NOT NULL,
    fecha_reseña timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE ListaDeseos (
    deseo_id integer PRIMARY KEY NOT NULL,
    cliente_id int REFERENCES Clientes(cliente_id) NOT NULL,
    producto_id int REFERENCES Productos(producto_id) NOT NULL,
    fecha_reseña timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


-- Laas relaciones entre las tablas ya se encuentran definidas con las claves foraneas

--Se procede a crear los procedimientos almacenados de importancia y que generan valor 
-- al negocio




CREATE OR REPLACE PROCEDURE ActualizarEstadoPedido(
    p_PedidoID INT,
    p_NuevoEstado VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Pedidos
    SET estado = p_NuevoEstado
    WHERE pediddo_id = p_PedidoID;

    RAISE NOTICE 'Estado del pedido % actualizado a %', p_PedidoID, p_NuevoEstado;
END;
$$;



CREATE OR REPLACE PROCEDURE AgregarProductoListaDeseos(
    p_ClienteID INT,
    p_ProductoID INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM ListaDeseos
        WHERE cliente_id = p_ClienteID AND producto_id = p_ProductoID
    ) THEN
        INSERT INTO ListaDeseos (cliente_id, producto_id, fecha_agregado)
        VALUES (p_ClienteID, p_ProductoID);
        
        RAISE NOTICE 'Producto % agregado a la lista de deseos del cliente %', p_ProductoID, p_ClienteID;
    ELSE
        RAISE NOTICE 'El producto % ya está en la lista de deseos del cliente %', p_ProductoID, p_ClienteID;
    END IF;
END;
$$;


CREATE OR REPLACE PROCEDURE RegistrarReseña(
    p_ClienteID INT,
    p_ProductoID INT,
    p_Calificacion INT,
    p_Comentario TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM DetallePedidos DP
        JOIN Pedidos P ON DP.pedido_id = P.pedido_id
        WHERE P.cliente_id = p_ClienteID AND DP.producto_id = p_ProductoID
    ) THEN
        INSERT INTO Reseñas (cliente_id, producto_id, calificacion, comentario, fecha_reseña)
        VALUES (p_ClienteID, p_ProductoID, p_Calificacion, p_Comentario);

        RAISE NOTICE 'Reseña registrada exitosamente';
    ELSE
        RAISE EXCEPTION 'El cliente % no ha comprado el producto %', p_ClienteID, p_ProductoID;
    END IF;
END;
$$;


CREATE OR REPLACE PROCEDURE EliminarProductosSinStock()
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Productos
    WHERE stock <= 0;

    RAISE NOTICE 'Productos sin stock eliminados de la base de datos';
END;
$$;


CREATE OR REPLACE PROCEDURE ActualizarPrecioProducto(
    p_ProductoID INT,
    p_NuevoPrecio DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Productos
    SET precio = p_NuevoPrecio
    WHERE producto_id = p_ProductoID;

    RAISE NOTICE 'Precio del producto % actualizado a %', p_ProductoID, p_NuevoPrecio;
END;
$$;


CREATE OR REPLACE PROCEDURE AplicarDescuento(
    p_PedidoID INT,
    p_MontoMinimo DECIMAL,
    p_PorcentajeDescuento DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Pedidos
    SET precio_total = precio_total - (precio_total * p_PorcentajeDescuento / 100)
    WHERE pedido_id = p_PedidoID AND precio_total > p_MontoMinimo;

    RAISE NOTICE 'Descuento de % aplicado al pedido %', p_PorcentajeDescuento, p_PedidoID;
END;
$$;


--Se procede a crear funciones importantes que generan valor para el negocio

CREATE OR REPLACE FUNCTION ObtenerStockProducto(p_ProductoID INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_Stock INT;
BEGIN
    SELECT Stock
    INTO v_Stock
    FROM Productos
    WHERE producto_id = p_ProductoID;

    RETURN v_Stock;
END;
$$;


CREATE OR REPLACE FUNCTION CalcularTotalPedido(p_PedidoID INT)
RETURNS DECIMAL(18, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_Total DECIMAL(18, 2);
BEGIN
    SELECT SUM(DP.cantidad * DP.precio_unitario)
    INTO v_Total
    FROM DetallePedidos dp
    WHERE dp.pedido_id = p_PedidoID;

    RETURN COALESCE(v_Total, 0);
END;
$$;


CREATE OR REPLACE FUNCTION ContarPedidosCliente(p_ClienteID INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_NumeroPedidos INT;
BEGIN
    SELECT COUNT(*)
    INTO v_NumeroPedidos
    FROM Pedidos
    WHERE cliente_id = p_ClienteID;

    RETURN v_NumeroPedidos;
END;
$$;


CREATE OR REPLACE FUNCTION EstaEnListaDeseos(p_ClienteID INT, p_ProductoID INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_Existe BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM ListaDeseos
        WHERE cliente_id = p_ClienteID AND producto_id = p_ProductoID
    )
    INTO v_Existe;

    RETURN v_Existe;
END;
$$;


-- Se crean algunas consultas de interes para el negocio

SELECT * FROM Pedidos
WHERE cliente_id = 4
  AND fecha_pedido = '2024-01-10';


SELECT cliente_id, nombre, apellido, correo_electronico, fecha_registro
FROM Clientes;


SELECT p.ProductoID, p.Nombre, SUM(DP.cantidad) AS TotalVentas
FROM Productos P
JOIN DetallePedidos DP ON P.producto_id = DP.producto_id
GROUP BY P.producto_id, P.nombre
ORDER BY TotalVentas DESC
LIMIT 5;



SELECT AVG(Calificacion) AS CalificacionPromedio
FROM Reseñas
WHERE producto_id = 101;

SELECT pedido_id, Fecha_Pedido, Precio_Total, Estado
FROM Pedidos
WHERE Cliente_ID = 1;