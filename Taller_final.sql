create table Clientes (
cliente_id serial   primary key  , 
nombre varchar (50)    NOT NULL, 
apellido varchar (50)    NOT NULL, 
direccion varchar (100)    , 
telefono varchar (20)    , 
correo_electronico varchar (200)    UNIQUE NOT NULL, 
fecha_registro TIMESTAMP      DEFAULT CURRENT_TIMESTAMP, 
estado varchar (10)    NOT NULL check (estado IN('activo', 'inactivo') ) DEFAULT 'activo'
);
create table Productos (
producto_id serial   primary key  , 
nombre varchar (50)    NOT NULL, 
descripción varchar (200)    NOT NULL, 
precio numeric (15, 2)    NOT NULL, 
stock  numeric (15, 0)    NOT NULL, 
categoría varchar (20)    NOT NULL
);
create table Pedidos (
pedido_id serial   primary key  , 
producto_id int      REFERENCES Productos(producto_id) not null, 
cliente_id int      REFERENCES Clientes(cliente_id) not null, 
cantidades numeric (15, 0)    NOT NULL, 
precio numeric (15, 2)    NOT NULL, 
estado varchar (20)    NOT NULL check (estado IN('carrito', 'procesando', 'enviado', 'entregado') ) DEFAULT 'carrito', 
fecha_registro TIMESTAMP      DEFAULT CURRENT_TIMESTAMP 
);
create table Lista_de_deseos (
lista_id serial   primary key  , 
producto_id int      REFERENCES Productos(producto_id) not null, 
cliente_id int      REFERENCES Clientes(cliente_id) not null 
);

select * from Lista_de_deseos;

create table Transacciones (
transaccion_id serial   primary key  , 
pedido_id int      REFERENCES Pedidos(pedido_id) not null, 
tipo_transaccion varchar (20)    NOT NULL check (tipo_transaccion IN('carrito', 'procesando', 'enviado', 'entregado') ), 
fecha_transaccion TIMESTAMP      NOT NULL
);

insert into Clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro,
					  estado) values ('Beatriz', 'Jimenez', 'Calle 44 Prado', 1233666, 'bjimenez_85@hotmail.com', current_timestamp, 
									  'activo'); 
insert into Clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro,
					  estado) values ('Martha', 'Grisales', 'Calle 45 Miraflores', 128978, 'mgrisales@hotmail.com', '2024-08-11 18:33:38.0219',  
										'activo');
insert into Clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro,
					  estado) values ('Pedro', 'Montoya', 'Calle 70 - 89 Chapinero', 987896, 'pmontoya@gmail.com', '2024-08-11 18:33:38.0219', 
'activo');	

insert into Clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro,
					  estado) values ('Adrian', 'Ramirez', 'Calle 89- 45 Bosques Verdes', 75634589, 'aramirez@gmail.com', current_timestamp,  
										'inactivo');
insert into Clientes (nombre, apellido, direccion, telefono, correo_electronico, fecha_registro,
					  estado) values ('Aura', 'Arias', 'Calle 12 - 50 Poblado', 4575796, 'aarias@gmail.com', current_timestamp,  
										'activo');
select * from clientes;	

select * from productos;

ALTER TABLE Productos
RENAME COLUMN categorÃ­a TO categoria;



INSERT INTO Productos (nombre, descripcion, precio, stock, categoria)
VALUES 
('Smartphone', 'Smartphone de última generación con 128GB de almacenamiento', 699.99, 50, 'Electrónica'),
('Televisor', 'Televisor LED 4K de 55 pulgadas', 1199.99, 30, 'Electrónica'),
('Tablet', 'Tablet de 10 pulgadas con 64GB de almacenamiento', 329.99, 40, 'Electrónica'),
('Cámara Digital', 'Cámara digital de 20MP con zoom óptico 10x', 449.99, 25, 'Electrónica'),
('Auriculares Bluetooth', 'Auriculares inalámbricos con cancelación de ruido', 199.99, 100, 'Electrónica');

INSERT INTO Pedidos (producto_id, cliente_id , cantidades, precio, estado, fecha_registro)
values (1, 2, 1, 1000000, 'carrito', CURRENT_TIMESTAMP);

INSERT INTO Pedidos (producto_id, cliente_id , cantidades, precio, estado, fecha_registro)
values (2, 2, 1, 21000000, 'procesando', CURRENT_TIMESTAMP);

insert into Lista_de_deseos (producto_id , cliente_id)
values (2, 2);
insert into Lista_de_deseos (producto_id , cliente_id)
values (2, 5);


select * from pedidos;
commit;

-- ---consultas
select estado, fecha_registro, count(*) from Clientes
group by estado, fecha_registro order by estado;

select a.cliente_id, a.nombre,b.pedido_id, b.producto_id  from 
Clientes a inner join Pedidos b on a.cliente_id  = b.cliente_id
where a.cliente_id = 2;


select pedido_id, cliente_id, sum(precio) valor_total_pedido from Pedidos 
group by pedido_id, cliente_id;

select * from Transacciones where tipo_transaccion = 'entregado';

select * from Lista_de_deseos where cliente_id =2 ;

----
-- Funcion crear_cliente
create or replace procedure crear_cliente(
	nombre_cliente varchar (50),
    apellido_cliente varchar (50), 
    direccion_cliente varchar (100) , 
    telefono_cliente varchar (20), 
    correo_electronico_cliente varchar (200)    )
language plpgsql
as $$

    begin
	   if nombre_cliente = ' '  then
	      raise exception 'Nombre del cliente en Blanco';
	   end if;
           if apellido_cliente = ' '  then
	      raise exception 'Apellido del cliente en Blanco';
	   end if;
           if correo_electronico_cliente = ' '  then
	      raise exception 'Correo electronico del cliente en Blanco';
	   end if;

       insert into Clientes(nombre,apellido,direccion,telefono,correo_electronico) 
	   values(nombre_cliente,apellido_cliente,direccion_cliente,telefono_cliente,correo_electronico_cliente);
    end;
$$;

create or replace procedure modificar_correo_cliente
(id_cliente int ,
 correo_electronico_act varchar (200)    )
language plpgsql
as $$

    begin
	  if id_cliente = 0  then 
	    raise exception 'Debe ingresar el cliente';
      end if;
		
	   if correo_electronico_act = ' '  then
	      raise exception 'Correo electronico del cliente en Blanco';
	   else
		update Clientes set correo_electronico = correo_electronico_act
		where cliente_id = id_cliente; 
	   end if;
   end;	   
$$;

call modificar_correo_cliente (2, 'prueba@gmail.com');

create or replace procedure actualiza_Producto
(id_producto int,
precio_act numeric (15, 2), 
stock_act numeric (15, 0) , 
categoria_act varchar (20) 
)	   
language plpgsql
as $$
    begin
       if precio_act = 0  then
	      raise exception 'Precio del producto esta en cero';
	   else
	     update Productos set precio = precio_act   
		 where producto_id = id_producto; 
	   end if;
	   
       if stock_act = 0  then
	      raise exception 'stock producto en cero';
	   else
	     update Productos set stock = stock + stock_act
		 where producto_id = id_producto; 
	   end if;
	   
	   if categoria_act = ' '  then
	      raise exception 'Categoria del Producto en blanco';
	   else
	     update Productos set categoria = categoria_act   where producto_id = id_producto; 
	   end if;
	end;
$$;

select * from productos;
call actualiza_Producto (5, 1200000, 1, 'Electronica');

----
create or replace procedure Crear_Producto(
nombre_ing varchar (50), 
descripcion_ing varchar (200), 
precio_ing numeric (15,2), 
stock_ing  numeric (15,0),
categoria_ing varchar (20)
)
 
language plpgsql
as $$
    begin
	   if nombre_ing = ' '  then
	      raise exception 'Nombre del producto en blanco';
	   end if;
           if descripcion_ing = ' '  then
	      raise exception 'Descripcion producto en blanco';
	   end if;
           if precio_ing = 0  then
	      raise exception 'Precio producto en blanco';
	   end if;

       insert into Productos(nombre, descripcion, precio, stock, categoria) 
	   values(nombre_ing, descripcion_ing, precio_ing, stock_ing, categoria_ing);
    end;
$$;

select * from productos;

call  Crear_Producto('Audifonos_Iphone', 'Audifonos ultima generacion', 5000000.00 , 1.00 , 'Digital');

---
create or replace procedure Rep_clientes_estado 
(estado_rep varchar ) 
 language plpgsql
 as $$
   
 
    begin
    -- logica de la funcion
	    PERFORM * from Clientes 
		where estado = estado_rep;
    end;
$$;


call Rep_clientes_estado('inactivo');  

--- funciones
-- Consultar valor de un producto
create or replace function valor_producto (producto_id_con int )
returns decimal(15,2)
 language plpgsql
 as $$
   declare nro_valor numeric(15, 2) default 0.00;
 
    begin
    -- logica de la funcion
	    
       select precio into nro_valor
       from Productos 
	   where producto_id = producto_id_con;
	   return nro_valor;
    end;
$$; 
select * from productos;
select valor_producto (5);

-- validar inventario producto 
create or replace function stock_producto (producto_id_con int )
returns decimal(15,2)
 language plpgsql
 as $$
   declare nro_stock numeric(15, 2) default 0.00;
 
    begin
       
       select stock into nro_stock
       from Productos 
	   where producto_id = producto_id_con;
	   return nro_stock;
    end;
$$; 

select stock_producto(1);

select * from pedidos;

-- consultar valor del pedido del cliente
create or replace function Totalpedido_cliente (cliente_id_con int )
returns  decimal(15,2)
 language plpgsql
 as $$
   declare valor_cliente numeric(15, 2) default 0.00;
 
    begin
     
       select sum(precio) into valor_cliente
       from Pedidos 
	   where cliente_id = cliente_id_con;
	   return valor_cliente;
    end;
$$; 

select Totalpedido_cliente (2);
select * from transacciones;


INSERT INTO transacciones (pedido_id, tipo_transaccion , fecha_transaccion)
values (1, 'carrito', CURRENT_TIMESTAMP);

INSERT INTO transacciones (pedido_id, tipo_transaccion , fecha_transaccion)
values (2, 'carrito', CURRENT_TIMESTAMP);

create or replace function Rep_trans (fecha_inicial timestamp, fecha_final timestamp)
returns table(transaccion_id_rep integer,
			 pedido_id_rep integer,
			 tipo_transaccion_rep varchar,
			 monto_rep  numeric,
			 fecha_transaccion_rep date) 
 language plpgsql
 as $$
   
    begin
      return query
       select *
       from transacciones 
	   where fecha_transaccion between fecha_inicial and fecha_final;
    end;
$$;

SELECT * FROM Rep_trans('2024-08-01 00:00:00', '2024-08-11 23:59:59');

--- DEseos por cliente

create or replace function Deseos_cliente (cliente_id_bus int )
returns table(lista_id_bus integer,
			 producto_id_bus integer) 
 language plpgsql
 as $$
   
    begin
       return query
       select lista_id, producto_id
       from transacciones 
	   where cliente_id = cliente_id_bus;
    end;
$$; 
