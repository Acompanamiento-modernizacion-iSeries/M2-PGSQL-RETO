CREATE TABLE Clientes(
	cliente_id INTEGER PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	apellido VARCHAR (50) NOT NULL,
	direccion VARCHAR (100),
	telefono VARCHAR (20),
	correo_electronico VARCHAR (200) UNIQUE NOT NULL,
	fecha_registro TIMESTAMP NOT NULL
	);

CREATE TABLE Usuarios(
	usuario_id SERIAL PRIMARY KEY,
	nombre_usuario VARCHAR(30) UNIQUE NOT NULL,
	contrasena VARCHAR(20) NOT NULL,
	correo_electronico_id VARCHAR (200) REFERENCES Clientes(correo_electronico) NOT NULL
	);

CREATE TABLE Tipo_Productos(
	id_tipo_producto INTEGER PRIMARY KEY,
	descripcion VARCHAR (50) NOT NULL,
	estado VARCHAR (12) NOT NULL CHECK (estado IN ('ACTIVO','INACTIVO'))
	);	

CREATE TABLE Catalogos(
	catalogo_id INTEGER PRIMARY KEY,
	nombre_catalogo VARCHAR (100) NOT NULL
	);

CREATE TABLE Productos(
	producto_id INTEGER PRIMARY KEY,
	nombre VARCHAR (50) NOT NULL,
	descripcion VARCHAR (200) NOT NULL,
	stock INTEGER NOT NULL,
	precio NUMERIC (15, 2) NOT NULL,
	tipo_producto INTEGER REFERENCES Tipo_Productos(id_tipo_producto) NOT NULL,
	catalogo INTEGER REFERENCES Catalogos(catalogo_id) NOT NULL
	);
	
CREATE TABLE Pedidos(
	pedidos_id SERIAL PRIMARY KEY,
	cliente_id INTEGER REFERENCES Clientes(cliente_id) NOT NULL,
	producto_id INTEGER REFERENCES Productos(producto_id) NOT NULL,
	cantidad INTEGER NOT NULL,
	precio NUMERIC (15, 2) NOT NULL,
	estado VARCHAR (12) NOT NULL CHECK (estado IN ('PROCESANDO','ENVIADO','ENTREGADO'))	
	);

CREATE TABLE Cliente_Pedido(
	cliente_id INTEGER REFERENCES Clientes(cliente_id) NOT NULL,
    pedido_id INTEGER REFERENCES Pedidos(pedidos_id) NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);

CREATE TABLE Comentarios(
	comentario_id SERIAL PRIMARY KEY,
	cliente_id INTEGER REFERENCES Clientes(cliente_id) NOT NULL,
	producto_id INTEGER REFERENCES Productos(producto_id) NOT NULL,
	feedback  VARCHAR(250) NOT NULL,
	calificacion NUMERIC (1, 0) NOT NULL,
	fecha_comentario TIMESTAMP DEFAULT CURRENT_TIMESTAMP
	);
	
CREATE TABLE Lista_Deseos(
	deseo_id SERIAL PRIMARY KEY,
	cliente_id INTEGER REFERENCES Clientes(cliente_id) NOT NULL,
	producto_id INTEGER REFERENCES Productos(producto_id) NOT NULL
	);

INSERT INTO Clientes (cliente_id, nombre, apellido, direccion, telefono, correo_electronico, fecha_registro)
Values (1045869521, 'Pedro', 'Perez', 'Carrera 6 # 7 - 58', '3585247962', 'pedro_perez@correo_electronico.com', '2021-05-24'),
       (1025487632,'Juan', 'Diaz', 'Calle 9 # 6 - 36', '3458796524', 'juan_diaz@correo_electronico.com', '2020-06-23'),
       (1150264527,'Daniel', 'Duarte', 'Diagonal 1 # 20 - 45', '3205487621', 'daniel_duarte@correo_electronico.com', '2022-05-23'),
       (1254879562,'Leidy', 'Draco', 'Manzan1 Casa3', '25684521125', 'leidy_draco@correo_electronico.com', '2023-07-10'),
       (1522487947,'Diana', 'Cardozo', 'Manzan1 Casa3', '25684521125', 'diana_cardozo@correo_electronico.com', '2024-07-10');

INSERT INTO Usuarios(nombre_usuario, contrasena, correo_electronico_id)
Values ('pedro_perez','usuario','pedro_perez@correo_electronico.com'),
		('juan_diaz','usuario','juan_diaz@correo_electronico.com'),
		('daniel_duarte','usuario','daniel_duarte@correo_electronico.com'),
		('leidy_draco','usuario','leidy_draco@correo_electronico.com'),
		('diana_cardozo','usuario','diana_cardozo@correo_electronico.com');


INSERT INTO Tipo_productos(id_tipo_producto, descripcion, estado)
Values(1,'Aseo','ACTIVO'),
		(2,'Viveres','ACTIVO'),
		(3,'Licores','ACTIVO'),
		(4,'Herramientas','ACTIVO'),
		(5,'Ropa','ACTIVO'),
		(6,'Electrodumesticos','ACTIVO'),
		(7,'Celulares','ACTIVO'),
		(8,'Frutas','ACTIVO'),
		(9,'Verduras','ACTIVO'),
		(10,'Lacteos','ACTIVO');

INSERT INTO Catalogos(catalogo_id, nombre_catalogo)
Values (1, 'Limpieza'),
		(2, 'Bebidas'),
		(3, 'Arinas'),
		(4, 'Tecnología'),
		(5, 'Granos'),
		(6, 'Construcción'),
		(7, 'Frutas, verduras y hortalizas'),
		(8, 'Sin catalogo'),
		(9, 'Hombres'),
		(10, 'Damas');
		
INSERT INTO Productos(producto_id, nombre, descripcion, stock, precio, tipo_producto, catalogo)
Values(1,'Leche Colanta', 'Bolsa de 500 ml', 12, 2200, 10, 2),
		(2,'Tomate', 'Bolsa de 10 tomates', 24, 3500, 9, 7),
		(3,'Lechuga', 'Lechuga Fresca', 15, 2500, 9, 7),
		(4,'Manzanas', 'Manzana Verde', 30, 2800, 8, 7),
		(5,'Arroz', 'Arroz Diana x 500 grs', 30, 7500, 2, 5),
		(6,'Aceite', 'Aceite Dorado x 1 ltr', 15, 2500, 2, 8),
		(7,'Cerveza', 'Six pack', 30, 18000, 3, 2),
		(8,'Desodorante', 'Unidad 300 ml', 26, 10800, 1, 1),
		(9,'Jabon Rey', 'Barra x 3', 55, 6800, 1, 1),
		(10,'Alicate', 'Amarillo Electrico', 22, 38000, 4, 6),
		(11,'Blusa', 'Dama Surtida', 48, 35000, 5, 10),
		(12,'Tenis', 'Blanco Hombre', 12, 120000, 5, 9),
		(13,'Televisor', 'Samsun 55 pulgadas', 8, 1220000, 6, 4),
		(14,'Impresora', 'HP Desktop 72', 10, 250000, 6, 4),
		(15,'SmartPhone', 'Hauwei Mate 20 pro', 6, 250000, 7, 4);

--Clientes ingresados en 2022-01-01 y 2023-12-31
Select * 
from Clientes
Where CAST(fecha_registro AS VARCHAR) between '2022-01-01' And '2023-12-31';

--Recuperar Usuario con correo electronico:
Select nombre_usuario 
from Usuarios
Where correo_electronico_id = 'pedro_perez@correo_electronico.com';

--Cantidad de productos en el almacen XYZ STORE
Select sum(stock) 
from Productos;

--Listar los Catalogos y los productos que contiene cada Catalogo y su detalle
Select * 
from Catalogos As T1
Join Productos As T2 On T1.catalogo_id = T2.catalogo;

--Productos mas proximo a terminarse en existencia
Select producto_id, nombre, stock
From Productos
Where stock=(Select MIN(stock) From Productos);

--Eliminar Tablas
--Drop Table Lista_Deseos;
--Drop Table Comentarios;
--Drop Table Cliente_Pedido;
--DROP TABLE Pedidos;
--Drop Table Productos;
--Drop Table Tipo_productos;
--Drop Table Usuarios;
--Drop Table Clientes;

--Crear Cliente, usuario y contraseña
CREATE OR REPLACE PROCEDURE nuevo_cliente_usuario(
	v_cliente_id INTEGER,
	v_nombre VARCHAR,
	v_apellido VARCHAR,
	v_direccion VARCHAR,
	v_telefono VARCHAR,
	v_correo_electronico VARCHAR,
	v_fecha_registro VARCHAR
)
LANGUAGE plpgsql
AS $$
	DECLARE
	v_nom_usu VARCHAR;
	v_pass VARCHAR;
		BEGIN
			IF v_cliente_id = 0 THEN
				RAISE EXCEPTION 'El id del cliente no puede estar vacio';
			END IF;
			IF v_nombre = ' ' THEN
				RAISE EXCEPTION 'El campo nombre no puede estar vacio';
			END IF;
			IF v_apellido = ' ' THEN
				RAISE EXCEPTION 'El campo apellido no puede estar vacio';
			END IF;
			IF v_correo_electronico = ' ' THEN
				RAISE EXCEPTION 'El campo email no puede estar vacio';
			END IF;
			
			IF v_fecha_registro = ' ' THEN
				v_fecha_registro = CURRENT_TIMESTAMP;	
			END IF;
 			
			
			v_nom_usu = v_nombre ||'_'|| v_apellido;
			v_pass = v_nom_usu;
			
			INSERT INTO Clientes (cliente_id, nombre, apellido, direccion, telefono, correo_electronico, fecha_registro)
			VALUES (v_cliente_id, v_nombre, v_apellido, v_direccion, v_telefono, v_correo_electronico, CAST(v_fecha_registro As TIMESTAMP));
			
			INSERT INTO Usuarios(nombre_usuario, contrasena, correo_electronico_id)
			VALUES (v_nom_usu, v_pass, v_correo_electronico);
			
				RAISE NOTICE 'usuario creado con satisfacción: %', v_nom_usu;
				RAISE NOTICE 'contraseña el mismo usuario, se recomienda cambiarlo: %', v_pass;
		END;
$$;

CALL nuevo_cliente_usuario(1902938877, 'angel', 'rodriguez', 'Carrera 6 # 7 - 58', '3229487212', 'snaider182@gmail.com', ' ');


--Actualizar Cliente usuario y contraseña
CREATE OR REPLACE PROCEDURE actualizar_cliente(
	v_cliente_id INTEGER,
	v_nombre VARCHAR,
	v_apellido VARCHAR,
	v_direccion VARCHAR,
	v_telefono VARCHAR,
	v_correo_electronico VARCHAR,
	v_fecha_registro VARCHAR
)
LANGUAGE plpgsql
AS $$
	DECLARE
	v_nom_usu VARCHAR;
	v_pass VARCHAR;
	v_mail VARCHAR;
		BEGIN
			IF v_cliente_id = 0 THEN
				RAISE EXCEPTION 'El id del cliente no puede estar vacio';
			END IF;
			IF v_nombre = ' ' THEN
				RAISE EXCEPTION 'El campo nombre no puede estar vacio';
			END IF;
			IF v_apellido = ' ' THEN
				RAISE EXCEPTION 'El campo apellido no puede estar vacio';
			END IF;
			IF v_correo_electronico = ' ' THEN
				RAISE EXCEPTION 'El campo email no puede estar vacio';
			END IF;
			
			IF v_fecha_registro = ' ' THEN
				v_fecha_registro = CURRENT_TIMESTAMP;	
			END IF;
			
 			v_nom_usu = v_nombre ||'_'|| v_apellido;
			v_pass = v_nom_usu;
			
			Select correo_electronico Into v_mail
			From Clientes
			Where cliente_id = v_cliente_id;
			
			Delete From Usuarios
			Where correo_electronico_id = v_mail;
			
			Update Clientes 
				Set nombre = v_nombre,
					apellido = v_apellido,
					direccion = v_direccion, 
					telefono = v_telefono, 
					correo_electronico = v_correo_electronico,
					fecha_registro = CAST(v_fecha_registro As TIMESTAMP)
					Where cliente_id = v_cliente_id;
					
			INSERT INTO Usuarios(nombre_usuario, contrasena, correo_electronico_id)
			VALUES (v_nom_usu, v_pass, v_correo_electronico);
			
				RAISE NOTICE 'Cliente actualizado con exito: %', v_cliente_id;
				RAISE NOTICE 'usuario creado con satisfacción: %', v_nom_usu;
				RAISE NOTICE 'contraseña el mismo usuario, se recomienda cambiarla: %', v_pass;
				RAISE NOTICE 'nuevo email actualizado: %', v_correo_electronico;
		END;
$$;

CALL actualizar_cliente(1049616876, 'snaider', 'rodriguez', 'Carrera 6 # 7 - 58R', '5557778886', 'snaider182@reddians.com', ' ');

--Eliminar Cliente y usuario
CREATE OR REPLACE PROCEDURE eliminar_cliente(
	v_cliente_id INTEGER
)
LANGUAGE plpgsql
AS $$
	DECLARE
	v_mail VARCHAR;
		BEGIN
			IF v_cliente_id = 0 THEN
				RAISE EXCEPTION 'identificación del cliente no puede estar vacio';
			END IF;
			Select correo_electronico Into v_mail
			From Clientes
			Where cliente_id = v_cliente_id;
			
			Delete from Usuarios Where correo_electronico_id = v_mail;
 			Delete from Clientes Where cliente_id = v_cliente_id;
			
				RAISE NOTICE 'Cliente y usuario eliminados con exito';
		END;
$$;

CALL eliminar_cliente(1049616876);

--Buscar producto
CREATE OR REPLACE PROCEDURE buscar_producto(
	v_nom_pro VARCHAR
)
LANGUAGE plpgsql
AS $$
	DECLARE
	v_nombre VARCHAR;
	v_descripcion VARCHAR;
	v_stock INTEGER;
	v_precio NUMERIC;
		BEGIN
			IF v_nom_pro = ' ' THEN
				RAISE EXCEPTION 'nombre de producto no puede estar vacio';
			END IF;
			FOR v_nombre, v_descripcion, v_stock, v_precio IN
				Select nombre, descripcion, stock, precio
				From Productos
				Where nombre Like '%'||v_nom_pro||'%'
				Or descripcion Like '%'||v_nom_pro||'%'
			LOOP
				RAISE NOTICE 'nombre: %', v_nombre;
				RAISE NOTICE 'descripción: %', v_descripcion;
				RAISE NOTICE 'cantidad en bodega: %', v_stock;
				RAISE NOTICE 'precio: %', v_precio;
			END LOOP;
		END;
$$;

CALL buscar_producto('A');

--Ingresar producto
CREATE OR REPLACE PROCEDURE ingresar_producto(
	v_producto_id INTEGER, 
	v_nombre VARCHAR,
	v_descripcion VARCHAR,
	v_stock INTEGER, 
	v_precio NUMERIC, 
	v_tipo_producto INTEGER, 
	v_catalogo INTEGER
)
LANGUAGE plpgsql
AS $$
	DECLARE
		BEGIN
			IF v_producto_id <= 0 THEN
				RAISE EXCEPTION 'id de producto erroneo';
			END IF;
			IF v_nombre = ' ' THEN
				RAISE EXCEPTION 'nombre de producto no puede estar vacio';
			END IF;
			IF v_descripcion = ' ' THEN
				RAISE EXCEPTION 'descripción de producto no puede estar vacio';
			END IF;
			IF v_stock < 0 THEN
				RAISE EXCEPTION 'cantidad de productos no puede ser menor que cero';
			END IF;
			IF v_precio < 0 THEN
				RAISE EXCEPTION 'precio de productos no puede ser menor que cero';
			END IF;
			IF v_tipo_producto < 0 THEN
				RAISE EXCEPTION 'tipo de producto no puede se menor que cero';
			END IF;
			IF v_catalogo = 0 THEN
				v_catalogo = 8;
			END IF;
			INSERT INTO Productos(producto_id, nombre, descripcion, stock, precio, tipo_producto, catalogo)
			Values(v_producto_id, v_nombre, v_descripcion, v_stock, v_precio, v_tipo_producto, v_catalogo);
			RAISE NOTICE 'Se ingreso el producto: %', v_producto_id;
			RAISE NOTICE 'nombre: %', v_nombre;
			RAISE NOTICE 'descripción: %', v_descripcion;
			RAISE NOTICE 'cantidad en bodega: %', v_stock;
			RAISE NOTICE 'precio: %', v_precio;
		END;
$$;

CALL ingresar_producto(17,'Smarth Phone', 'Sansumg 30', 6, 350000, 7, 4);

--Agregar al carrito de compras
CREATE OR REPLACE PROCEDURE ingresar_pedido(
	v_cliente_id INTEGER,
	v_producto_id INTEGER,
	v_cantidad INTEGER
)
LANGUAGE plpgsql
AS $$
	DECLARE
	v_estado VARCHAR;
	v_precio INTEGER;
	w_nombre VARCHAR;
		BEGIN
			IF v_cliente_id <= 0 THEN
				RAISE EXCEPTION 'id de cliente erroneo';
			END IF;
			IF v_producto_id <= 0 THEN
				RAISE EXCEPTION 'id del producto erroneo';
			END IF;
			IF v_cantidad <= 0 THEN
				RAISE EXCEPTION 'debe selecionar almenos un producto';
			END IF;
			v_estado = 'PROCESANDO';
			Select precio Into v_precio
			From Productos
			Where producto_id = v_producto_id;
			
			v_precio = v_precio * v_cantidad;
			
			Insert Into Pedidos(cliente_id, producto_id, cantidad, precio, estado)
			Values(v_cliente_id, v_producto_id, v_cantidad, v_precio,v_estado);
			
			Select nombre Into w_nombre
			From Productos
			Where producto_id = v_producto_id; 
			
			RAISE NOTICE 'Se ingreso pedido para el cliente: %', v_cliente_id;
			RAISE NOTICE 'nombre del producto: %', w_nombre;
			RAISE NOTICE 'cantidad: %', v_cantidad;
			RAISE NOTICE 'precio: %', v_precio;
			RAISE NOTICE 'estado del pedido: %', v_estado;
		END;
$$;

CALL ingresar_pedido(1150264527,7, 2);

--Valor total de un pedido por cliente
CREATE OR REPLACE PROCEDURE total_pagar_pedidoXcliente(
	v_cliente_id INTEGER
)
LANGUAGE plpgsql
AS $$
	DECLARE
	v_estado VARCHAR;
	v_precio INTEGER;
		BEGIN
			IF v_cliente_id <= 0 THEN
				RAISE EXCEPTION 'id de cliente erroneo';
			END IF;
			Select SUM(precio) Into v_precio
			From Pedidos
			Where cliente_id = v_cliente_id
			And estado = 'PROCESANDO';
			RAISE NOTICE 'El cliente: %', v_cliente_id;	
			RAISE NOTICE 'Valor total del pedido: %', v_precio;	
		END;
$$;

CALL total_pagar_pedidoXcliente(1045869521);

--Confirmar pago de un cliente
CREATE OR REPLACE PROCEDURE confirmar_pago(
	v_cliente_id INTEGER,
	v_tot_pagar NUMERIC
)
LANGUAGE plpgsql
AS $$
	DECLARE
	v_estado VARCHAR;
	v_precio INTEGER;
		BEGIN
			IF v_cliente_id <= 0 THEN
				RAISE EXCEPTION 'id de cliente erroneo';
			END IF;
			
			Select SUM(precio) Into v_precio
			From Pedidos
			Where cliente_id = v_cliente_id
			And estado = 'PROCESANDO';
			
			IF v_tot_pagar < v_precio THEN
				RAISE EXCEPTION 'saldo insuficiente';
			END IF;
			v_tot_pagar = v_tot_pagar - v_precio;
			
			UPDATE Pedidos Set estado='ENVIADO'
			Where cliente_id = v_cliente_id;
			
			RAISE NOTICE 'Actualizado el estado del pedido ENVIADO para el cliente: %', v_cliente_id;	
			RAISE NOTICE 'Sobrante para el cliente: %', v_tot_pagar;	
		END;
$$;

CALL confirmar_pago(1045869521, 312100);

--Cambiar estado del pedido de un cliente
CREATE OR REPLACE PROCEDURE cambiar_estado_pedido(
	v_cliente_id INTEGER,
	v_estado VARCHAR
)
LANGUAGE plpgsql
AS $$
	DECLARE
		BEGIN
			IF v_cliente_id <= 0 THEN
				RAISE EXCEPTION 'id de cliente erroneo';
			END IF;	
			IF v_estado <> 'ENVIADO'
			And v_estado <> 'PROCESANDO'
			And v_estado <> 'ENTREGADO' THEN
				RAISE EXCEPTION 'estado del pedido erroneo: %', v_estado;
			END IF;
			UPDATE Pedidos 
				Set estado = v_estado
				Where cliente_id = v_cliente_id;
			
			RAISE NOTICE 'Actualizado el estado del pedido para el cliente: %', v_cliente_id;	
			RAISE NOTICE 'nuevo estado: %', v_estado;	
		END;
$$;

CALL cambiar_estado_pedido(1045869521, 'PROCESANDO'); -->Recibe 'PROCESANDO','ENVIADO','ENTREGADO'

--Ingresar comentario
CREATE OR REPLACE PROCEDURE ingresar_comentario(
	v_cliente_id INTEGER, 
	v_producto_id INTEGER,
	v_feedback VARCHAR,
	v_calificacion INTEGER
)
LANGUAGE plpgsql
AS $$
	DECLARE
	w_nombre VARCHAR;
		BEGIN
			IF v_cliente_id <= 0 THEN
				RAISE EXCEPTION 'id de cliente erroneo';
			END IF;
			IF v_producto_id <= 0 THEN
				RAISE EXCEPTION 'id de producto erroneo';
			END IF;
			IF v_feedback = ' ' THEN
				RAISE EXCEPTION 'ingrese almenos 1 comentario';
			END IF;
			IF v_calificacion < 0 THEN
				RAISE EXCEPTION 'calificación debe estar entre 1 y 10 siendo 10 lo más alto';
			END IF;
			
			INSERT INTO Comentarios(cliente_id, producto_id, feedback, calificacion)
			Values(v_cliente_id, v_producto_id, v_feedback, v_calificacion);
			
			Select nombre Into w_nombre
			From Productos
			Where producto_id = v_producto_id; 
			
			RAISE NOTICE 'El cliente: %', v_cliente_id;
			RAISE NOTICE 'ingreso el comentario: %', v_feedback;
			RAISE NOTICE 'sobre el producto: %', w_nombre;
			RAISE NOTICE 'con calificación: %', v_calificacion;
		END;
$$;

CALL ingresar_comentario(1045869521, 7, 'Buena compra llega rapido', 8);
