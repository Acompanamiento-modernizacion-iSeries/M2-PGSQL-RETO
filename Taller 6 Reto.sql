-- Crear tablas
CREATE TABLE clientes(
	cliente_id SERIAL PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	apellido VARCHAR (50) NOT NULL,
	direccion VARCHAR (100),
	telefono VARCHAR (20),
	correo_electronico VARCHAR (200) UNIQUE NOT NULL,
	fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE productos(
	producto_id SERIAL PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	descripcion VARCHAR (100) NOT NULL,
	precio DECIMAL (15,2),
	stock boolean,
	categoria VARCHAR (50) NOT NULL
);

CREATE TABLE pedidos(
	pedido_id SERIAL PRIMARY KEY,
	cliente_id INT REFERENCES clientes(cliente_id) NOT NULL,
	cantidad INTEGER NOT NULL,
	precio_total DECIMAL (15,2),
	estado VARCHAR (50) NOT NULL,
	fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE relacion_pedido_productos(
	relacion_pedido_productos_id SERIAL PRIMARY KEY,
	pedido_id INT REFERENCES pedidos(pedido_id) NOT NULL,
	producto_id INT REFERENCES productos(producto_id) NOT NULL
);

CREATE TABLE resena(
	resena_id SERIAL PRIMARY KEY,
	producto_id INT REFERENCES productos(producto_id) NOT NULL,
	cliente_id INT REFERENCES clientes(cliente_id) NOT NULL,
	calificacion INTEGER NOT NULL,
	comentario VARCHAR (100) NOT NULL,
	fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lista_deseos(
	lista_deseos_id SERIAL PRIMARY KEY,
	cliente_id INT REFERENCES clientes(cliente_id) NOT NULL,
	nombre_lista VARCHAR (50) NOT NULL
);

CREATE TABLE relacion_lista_deseo_productos(
	relacion_lista_deseo_productos_id SERIAL PRIMARY KEY,
	lista_deseos_id INT REFERENCES lista_deseos(lista_deseos_id) NOT NULL,
	producto_id INT REFERENCES productos(producto_id) NOT NULL
);

-- Poblar tablas
INSERT INTO clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro) VALUES
('Juan', 'Pérez', 'Calle Falsa 123, Ciudad', '555-1234', 'juan.perez@example.com', CURRENT_TIMESTAMP),
('Ana', 'Gómez', 'Avenida Siempre Viva 456, Ciudad', '555-5678', 'ana.gomez@example.com', CURRENT_TIMESTAMP),
('Luis', 'Martínez', 'Calle Real 789, Ciudad', '555-8765', 'luis.martinez@example.com', CURRENT_TIMESTAMP),
('Marta', 'Rodríguez', 'Calle Luna 101, Ciudad', '555-4321', 'marta.rodriguez@example.com', CURRENT_TIMESTAMP),
('Pedro', 'Sánchez', 'Calle Sol 202, Ciudad', '555-6789', 'pedro.sanchez@example.com', CURRENT_TIMESTAMP),
('Laura', 'Fernández', 'Avenida del Mar 303, Ciudad', '555-3456', 'laura.fernandez@example.com', CURRENT_TIMESTAMP),
('Carlos', 'Jiménez', 'Calle del Viento 404, Ciudad', '555-7890', 'carlos.jimenez@example.com', CURRENT_TIMESTAMP),
('Isabel', 'Castro', 'Calle del Bosque 505, Ciudad', '555-2345', 'isabel.castro@example.com', CURRENT_TIMESTAMP),
('Jorge', 'Hernández', 'Avenida de los Olivos 606, Ciudad', '555-6780', 'jorge.hernandez@example.com', CURRENT_TIMESTAMP),
('Beatriz', 'Moreno', 'Calle del Lago 707, Ciudad', '555-4320', 'beatriz.moreno@example.com', CURRENT_TIMESTAMP);

INSERT INTO productos (nombre, descripcion, precio, stock, categoria) VALUES
('Camiseta', 'Camiseta de algodón 100%', 19.99, true, 'Ropa'),
('Pantalones', 'Pantalones vaqueros de mezclilla', 39.99, true, 'Ropa'),
('Zapatos', 'Zapatos deportivos para hombre', 59.99, false, 'Calzado'),
('Chaqueta', 'Chaqueta de invierno con forro', 89.99, true, 'Ropa'),
('Gorra', 'Gorra de béisbol ajustable', 15.99, true, 'Accesorios'),
('Bufanda', 'Bufanda de lana', 25.99, true, 'Accesorios'),
('Reloj', 'Reloj digital resistente al agua', 99.99, false, 'Electrónica'),
('Auriculares', 'Auriculares inalámbricos Bluetooth', 79.99, true, 'Electrónica'),
('Tablet', 'Tablet de 10 pulgadas con 64GB de almacenamiento', 299.99, true, 'Electrónica'),
('Mochila', 'Mochila para laptop con múltiples compartimentos', 45.99, true, 'Accesorios');

-- Consultas

-- 1.Consultar productos en stock
SELECT * FROM productos WHERE stock is true;

-- 2.Consultar pedidos por cliente
SELECT * FROM pedidos WHERE cliente_id = 1;

--	3.Consultar los productos por pedido
SELECT pro.*
FROM pedidos ped
INNER JOIN relacion_pedido_productos rpp
ON rpp.pedido_id = ped.pedido_id
INNER JOIN productos pro
ON pro.producto_id = rpp.producto_id
WHERE ped.pedido_id = 1;

--	4.Consultar las reseñas por producto
SELECT res.*
FROM resena res
INNER JOIN productos pro
ON pro.producto_id = res.producto_id
WHERE pro.producto_id = 1;

--	5.Consultar productos en lista de deseo por cliente
SELECT pro.*
FROM lista_deseos ld
INNER JOIN relacion_lista_deseo_productos rldp
ON rldp.lista_deseos_id = ld.lista_deseos_id
INNER JOIN productos pro
ON pro.producto_id = rldp.producto_id
WHERE ld.cliente_id = 1;

-- Procedimientos almacenados

--	1.Cambiar estado del producto
CREATE OR REPLACE PROCEDURE cambiar_estado_producto(
	par_producto_id INTEGER,
	par_estado BOOLEAN
)language plpgsql
as $$
	DECLARE
		var_existe_producto boolean;
	BEGIN
		SELECT EXISTS(SELECT 1 FROM productos where producto_id = par_producto_id) INTO var_existe_producto;
		
		IF NOT var_existe_producto THEN
			RAISE EXCEPTION 'El id del producto no esta disponible: %', par_producto_id;
		END IF;
		
		UPDATE productos SET stock = par_estado WHERE producto_id = par_producto_id;
	END;
$$;

CALL cambiar_estado_producto(3, TRUE);

--	2.Agregar productos al pedido
CREATE OR REPLACE PROCEDURE agregar_producto_pedido(
	par_producto_id INTEGER,
	par_pedido_id INTEGER,
	par_cliente_id INTEGER
)language plpgsql
as $$
	DECLARE
		var_existe_producto boolean;
		var_existe_pedido boolean;
		var_existe_cliente boolean;
	BEGIN
		SELECT EXISTS(SELECT 1 FROM productos where producto_id = par_producto_id AND stock IS TRUE) INTO var_existe_producto;
		SELECT EXISTS(SELECT 1 FROM clientes where cliente_id = par_cliente_id) INTO var_existe_cliente;
		SELECT EXISTS(SELECT 1 FROM pedidos where pedido_id = par_pedido_id) INTO var_existe_pedido;
		
		IF NOT var_existe_producto THEN
			RAISE EXCEPTION 'El id del producto no esta disponible: %', par_producto_id;
		END IF;
		
		IF NOT var_existe_cliente THEN
			RAISE EXCEPTION 'El id del cliente no es existe: %', par_cliente_id;
		END IF;
		
		IF par_pedido_id IS NULL THEN
			INSERT INTO pedidos (cliente_id, cantidad, precio_total, estado)
				VALUES (par_cliente_id, 1, (SELECT precio FROM productos WHERE producto_id = par_producto_id),
				   'carrito compras');
			INSERT INTO relacion_pedido_productos (pedido_id, producto_id)
				VALUES ((SELECT pedido_id FROM pedidos WHERE cliente_id = par_cliente_id 
						 AND estado = 'carrito compras' AND fecha_registro = CURRENT_TIMESTAMP), par_producto_id);
			UPDATE productos SET stock = FALSE WHERE producto_id = par_producto_id;
		ELSIF var_existe_pedido THEN
			UPDATE pedidos SET cantidad = (SELECT cantidad FROM pedidos WHERE pedido_id = par_pedido_id) + 1,
				precio_total = (SELECT precio_total FROM pedidos WHERE pedido_id = par_pedido_id) + 
				(SELECT precio FROM productos WHERE producto_id = par_producto_id)
				WHERE pedido_id = par_pedido_id;
			INSERT INTO relacion_pedido_productos (pedido_id, producto_id)
				VALUES (par_pedido_id, par_producto_id);
			CALL cambiar_estado_producto(par_producto_id, FALSE);
		END IF;
	END;
$$;

CALL agregar_producto_pedido(1, NULL, 1);
CALL agregar_producto_pedido(2, 3, 1);

--	3.Eliminar productos del pedido
CREATE OR REPLACE PROCEDURE eliminar_productos_pedido(
	par_producto_id INTEGER,
	par_pedido_id INTEGER,
	par_cliente_id INTEGER
)language plpgsql
as $$
	DECLARE
		var_existe_producto boolean;
		var_existe_pedido boolean;
		var_existe_cliente boolean;
	BEGIN
		SELECT EXISTS(SELECT 1 FROM productos where producto_id = par_producto_id) INTO var_existe_producto;
		SELECT EXISTS(SELECT 1 FROM clientes where cliente_id = par_cliente_id) INTO var_existe_cliente;
		SELECT EXISTS(SELECT 1 FROM pedidos where pedido_id = par_pedido_id) INTO var_existe_pedido;
		
		IF NOT var_existe_producto THEN
			RAISE EXCEPTION 'El id del producto no esta disponible: %', par_producto_id;
		END IF;
		
		IF NOT var_existe_cliente THEN
			RAISE EXCEPTION 'El id del cliente no es existe: %', par_cliente_id;
		END IF;
		
		IF NOT var_existe_pedido THEN
			RAISE EXCEPTION 'El id del pedido no es existe: %', par_pedido_id;
		END IF;
		
		UPDATE pedidos SET cantidad = (SELECT cantidad FROM pedidos WHERE pedido_id = par_pedido_id) - 1,
				precio_total = (SELECT precio_total FROM pedidos WHERE pedido_id = par_pedido_id) - 
				(SELECT precio FROM productos WHERE producto_id = par_producto_id)
				WHERE pedido_id = par_pedido_id;
		CALL cambiar_estado_producto(par_producto_id, TRUE);
		DELETE FROM relacion_pedido_productos WHERE pedido_id = par_pedido_id AND producto_id = par_producto_id;
	END;
$$;

CALL eliminar_productos_pedido(2, 3, 1);

--	4.Cambiar estado del pedido
CREATE OR REPLACE PROCEDURE cambiar_estado_pedido(
	par_pedido_id INTEGER,
	par_estado_pedido VARCHAR(50)
)language plpgsql
as $$
	DECLARE
		var_existe_pedido boolean;
	BEGIN
		SELECT EXISTS(SELECT 1 FROM pedidos where pedido_id = par_pedido_id) INTO var_existe_pedido;
		
		IF NOT var_existe_pedido THEN
			RAISE EXCEPTION 'El id del pedido no es existe: %', par_pedido_id;
		END IF;
		
		UPDATE pedidos SET estado = par_estado_pedido WHERE pedido_id = par_pedido_id;		
	END;
$$;

CALL cambiar_estado_pedido(3, 'procesando');

--	5.Agregar reseña por producto y cliente --------------
CREATE OR REPLACE PROCEDURE agregar_resena_producto_cliente(
	par_producto_id INTEGER,
	par_cliente_id INTEGER,
	par_calificacion INTEGER,
	par_comentario VARCHAR(100)
)language plpgsql
as $$
	DECLARE
		var_existe_producto boolean;
		var_existe_cliente boolean;
		var_existe_resena boolean;
	BEGIN
		SELECT EXISTS(SELECT 1 FROM productos where producto_id = par_producto_id) INTO var_existe_producto;
		SELECT EXISTS(SELECT 1 FROM clientes where cliente_id = par_cliente_id) INTO var_existe_cliente;
		SELECT EXISTS(SELECT 1 FROM resena where cliente_id = par_cliente_id 
					  AND producto_id = par_producto_id) INTO var_existe_resena;
		
		IF NOT var_existe_producto THEN
			RAISE EXCEPTION 'El id del producto no esta disponible: %', par_producto_id;
		END IF;
		
		IF NOT var_existe_cliente THEN
			RAISE EXCEPTION 'El id del cliente no es existe: %', par_cliente_id;
		END IF;
		
		IF var_existe_resena THEN
			RAISE EXCEPTION 'Ya existe una reseña del cliente: % al producto: %', par_cliente_id, par_producto_id;
		ELSE
			INSERT INTO resena (producto_id, cliente_id, calificacion, comentario)
				VALUES (par_producto_id, par_cliente_id, par_calificacion, par_comentario);
		END IF;
	END;
$$;

CALL agregar_resena_producto_cliente(1, 1, 5, 'Excelente producto');

-- Funciones

-- 1.Consultar productos
CREATE OR REPLACE FUNCTION consular_productos_stock()
RETURNS TABLE(producto_id INTEGER,
	nombre VARCHAR (50),
	descripcion VARCHAR (100),
	precio DECIMAL (15,2),
	stock boolean,
	categoria VARCHAR (50)
)language plpgsql
as $$
	BEGIN
		return query
		SELECT pro.producto_id, pro.nombre, pro.descripcion, pro.precio, pro.stock, pro.categoria 
			FROM productos pro WHERE pro.stock is true;
	END;
$$;

SELECT consular_productos_stock();

-- 2.Consultar pedidos por cliente
CREATE OR REPLACE FUNCTION consular_pedidos_cliente(p_cliente_id INTEGER)
RETURNS TABLE(pedido_id INTEGER,
	cliente_id INTEGER,
	cantidad INTEGER,
	precio_total DECIMAL (15,2),
	estado VARCHAR (50),
	fecha_registro TIMESTAMP
)language plpgsql
as $$
	BEGIN
		return query
		SELECT ped.pedido_id, ped.cliente_id, ped.cantidad, ped.precio_total, ped.estado, ped.fecha_registro
			FROM pedidos ped WHERE ped.cliente_id = p_cliente_id;
	END;
$$;

SELECT consular_pedidos_cliente(1);

--	3.Consultar los productos por pedido
CREATE OR REPLACE FUNCTION consular_producto_pedido(p_pedido_id INTEGER)
RETURNS TABLE(producto_id INTEGER,
	nombre VARCHAR (50),
	descripcion VARCHAR (100),
	precio DECIMAL (15,2),
	stock boolean,
	categoria VARCHAR (50)
)language plpgsql
as $$
	BEGIN
		return query
		SELECT pro.producto_id, pro.nombre, pro.descripcion, pro.precio, pro.stock, pro.categoria 
			FROM pedidos ped
			INNER JOIN relacion_pedido_productos rpp
			ON rpp.pedido_id = ped.pedido_id
			INNER JOIN productos pro
			ON pro.producto_id = rpp.producto_id
			WHERE ped.pedido_id = p_pedido_id;
	END;
$$;

SELECT consular_producto_pedido(3);

--	4.Consultar las reseñas por producto
CREATE OR REPLACE FUNCTION consular_resenas_producto(p_producto_id INTEGER)
RETURNS TABLE(resena_id INTEGER,
	producto_id INTEGER,
	cliente_id INTEGER,
	calificacion INTEGER,
	comentario VARCHAR (100),
	fecha_registro TIMESTAMP
)language plpgsql
as $$
	BEGIN
		return query
		SELECT res.*
			FROM resena res
			INNER JOIN productos pro
			ON pro.producto_id = res.producto_id
			WHERE pro.producto_id = p_producto_id;
	END;
$$;

SELECT consular_resenas_producto(1);

--	5.Consultar productos en lista de deseo por cliente
CREATE OR REPLACE FUNCTION consular_productos_deseo_cliente(p_cliente_id INTEGER)
RETURNS TABLE(producto_id INTEGER,
	nombre VARCHAR (50),
	descripcion VARCHAR (100),
	precio DECIMAL (15,2),
	stock boolean,
	categoria VARCHAR (50)
)language plpgsql
as $$
	BEGIN
		return query
		SELECT pro.*
			FROM lista_deseos ld
			INNER JOIN relacion_lista_deseo_productos rldp
			ON rldp.lista_deseos_id = ld.lista_deseos_id
			INNER JOIN productos pro
			ON pro.producto_id = rldp.producto_id
			WHERE ld.cliente_id = p_cliente_id;
	END;
$$;

SELECT consular_productos_deseo_cliente(1);