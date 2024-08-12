-- CONSULTAS

-- 1. Número de pedidos por estado
SELECT estado, COUNT(*) AS cantidad 
FROM Pedidos 
GROUP BY estado;

-- 2. Precio total de todos los pedidos de un cliente específico
SELECT SUM(precio_total) AS total_gastado 
FROM Pedidos 
WHERE cliente_id = 1;

-- 3. Recuperar todos los productos según los deseos de un cliente específico.
SELECT d.deseo_id, p.producto_id, p.nombre_producto
FROM Deseos d
JOIN Productos p ON d.producto_id = p.producto_id
WHERE d.cliente_id = 1;

-- 4. Ver todos los pedidos con sus transacciones asociadas
SELECT p.pedido_id, p.cantidad_total, p.precio_total, t.estado AS estado_transaccion
FROM Pedidos p
LEFT JOIN Transacciones t ON p.pedido_id = t.pedido_id;

-- 5. Pedidos recientes (ordenados por fecha)
SELECT * 
FROM Pedidos 
ORDER BY fecha_pedido DESC 
LIMIT 10;

-- 6. Número de deseos por producto
SELECT producto_id COUNT(*) AS cantidad_deseos 
FROM Deseos 
GROUP BY producto_id;

-- PROCEDIMIENTOS

-- 1. Agregar un nuevo pedido
CREATE OR REPLACE PROCEDURE agregar_pedido(
    p_cliente_id INTEGER,
    p_precio_total DECIMAL,
    p_cantidad_total INTEGER
)
LANGUAGE plpgsql 
AS $$
	BEGIN
    	INSERT INTO Pedidos (cliente_id, precio_total, cantidad_total)
    	VALUES (p_cliente_id, p_precio_total, p_cantidad_total);
	END;
$$;

-- 2. Actualizar el estado de una transacción
CREATE OR REPLACE PROCEDURE actualizar_estado_transaccion(
    p_transaccion_id INTEGER,
    p_nuevo_estado VARCHAR(20)
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Transacciones
    SET estado = p_nuevo_estado
    WHERE transaccion_id = p_transaccion_id;
END;
$$;

-- 3. Eliminar un deseo
CREATE OR REPLACE PROCEDURE eliminar_deseo(p_deseo_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Deseos 
    WHERE deseo_id = p_deseo_id;
END;
$$;

-- 4. Agregar un nuevo deseo 
CREATE OR REPLACE PROCEDURE agregar_deseo(
    p_cliente_id INTEGER,
    p_producto_id INTEGER
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Deseos (cliente_id, producto_id)
    VALUES (p_cliente_id, p_producto_id);
END;
$$;

-- 5. Recuperar todos los pedidos de un cliente específico
CREATE OR REPLACE PROCEDURE obtener_pedidos_por_cliente(
    p_cliente_id INTEGER,
    OUT p_pedido_id INTEGER,
    OUT p_precio_total DECIMAL,
    OUT p_fecha_pedido TIMESTAMP
)
LANGUAGE plpgsql AS $$
BEGIN
    FOR p_pedido_id, p_precio_total, p_fecha_pedido IN 
        SELECT pedido_id, precio_total, fecha_pedido 
        FROM Pedidos 
        WHERE cliente_id = p_cliente_id 
	LOOP
    END LOOP;
END;
$$;

-- FUNCIONES

-- 1. Calcular el precio total de todos los pedidos de un cliente específico
CREATE OR REPLACE FUNCTION calcular_total_pedidos(p_cliente_id INTEGER)
RETURNS DECIMAL AS $$
DECLARE
    total DECIMAL;
BEGIN
    SELECT SUM(precio_total) INTO total 
    FROM Pedidos 
    WHERE cliente_id = p_cliente_id;

    RETURN COALESCE(total, 0); 
END;
$$ LANGUAGE plpgsql;

-- 2. Comprobar si un producto está presente en los deseos de un cliente
CREATE OR REPLACE FUNCTION producto_en_deseos(p_producto_id INTEGER, p_cliente_id INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    existe BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1 
        FROM Deseos 
        WHERE producto_id = p_producto_id AND cliente_id = p_cliente_id
    ) INTO existe;

    RETURN existe;
END;
$$ LANGUAGE plpgsql;

-- 3. Devolver el número de deseos de un producto específico.
CREATE OR REPLACE FUNCTION contar_deseos_por_producto(p_producto_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    cantidad INTEGER;
BEGIN
    SELECT COUNT(*) INTO cantidad 
    FROM Deseos 
    WHERE producto_id = p_producto_id;

    RETURN cantidad;
END;
$$ LANGUAGE plpgsql;

-- 4. Obtener el número total de pedidos por cliente
CREATE OR REPLACE FUNCTION contar_pedidos_por_cliente(p_cliente_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
	total_pedidos INTEGER;
BEGIN
	SELECT COUNT(*) INTO total_pedidos
	FROM Pedidos
	WHERE cliente_id = p_cliente_id;

	RETURN total_pedidos;
END;
$$ LANGUAGE plpgsql;

-- 5. Devolver el último pedido de un cliente específico
CREATE OR REPLACE FUNCTION obtener_ultima_pedido(p_cliente_id INTEGER)
RETURNS TABLE(pedido_id INTEGER, fecha_pedido TIMESTAMP) AS $$
BEGIN
    RETURN QUERY 
    SELECT pedido_id, fecha_pedido 
    FROM Pedidos 
    WHERE cliente_id = p_cliente_id 
    ORDER BY fecha_pedido DESC 
    LIMIT 1; 
END;
$$ LANGUAGE plpgsql;