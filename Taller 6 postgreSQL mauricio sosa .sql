-- CREACION BASE DATOS
CREATE DATABASE "XYZ_store"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE "XYZ_store"
    IS 'taller postgreSQL  Mauricio Sosa';


create table Clientes (
cliente_id serial   primary key  , 
nombre varchar (50)    NOT NULL, 
apellido varchar (50)    NOT NULL, 
direccion varchar (100)    , 
telefono varchar (20)    , 
correo_electronico varchar (200)    UNIQUE NOT NULL, 
fecha_registro TIMESTAMP      DEFAULT CURRENT_TIMESTAMP, 
estado varchar (10)    NOT NULL check (estado IN('Activo', 'Inactivo') ) DEFAULT 'Activo'
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
create table Transacciones (
transaccion_id serial   primary key  , 
pedido_id int      REFERENCES Pedidos(pedido_id) not null, 
tipo_transaccion varchar (20)    NOT NULL check (tipo_transaccion IN('carrito', 'procesando', 'enviado', 'entregado') ), 
fecha_transaccion TIMESTAMP      NOT NULL
);

---
--consultas
---
--lsta de deseos con información de cliente para hacer gestión y terminar la compra o para ofrecer ofeertas de interes

select ld.cliente_id as "Identificación cliente", c.nombre , c.apellido , 
ld.producto_id as "Cod producto", p.descripción as "Descripción producto" ,
  c.telefono , c.correo_electronico , p.precio 
from Lista_de_deseos ld left join clientes c on (ld.cliente_id = c.cliente_id) 
inner join productos p on (ld.producto_id=p.producto_id);

-- consulta de pedidos realizado en el ultimo mes por cliente 

Select cliente_id, sum(precio) as "valor pedido" , count(pedido_id) as "Cantidad pedidos"
from Pedidos 
where fecha_registro  >= CURRENT_DATE - INTERVAL '1 month'               
group by cliente_id;

-- transacciones tipo entrega en el ultimo día 

select * 
from Transacciones 
where tipo_transaccion = 'entregado'  and fecha_transaccion  >= CURRENT_DATE - INTERVAL '1 day'               ;

-- productos sin stock en almacen

select *
from productos 
where "stock " > '1.0' ;


--- CLientes sin pedidos
Select * 
from clientes c Left join pedidos p on (c.cliente_id = p.cliente_id) 
where p.pedido_id isnull ;


-----------------------------------------------------------------------
--- store procedures
----------------------------------------------------------------------
--- creación pedido

create or replace procedure crear_pedido (
	id_cliente integer, 
	id_producto integer,
	unidades numeric(15, 0))
language plpgsql
as $$
 
	declare existencia  boolean;
	declare existe_producto boolean;
	declare existe_cliente  boolean;
	declare valor  numeric(15, 2);
 
    begin
	
	   if id_cliente = 0  then 
	       raise exception 'Debe ingresar el cliente';
       end if;

      if id_producto = 0  then 
	       raise exception 'Debe ingresar un producto a pedir';
       end if;

      if unidades = 0  then 
	       raise exception 'Debe ingresar unidades a pedir';
       end if;

	
	   select case when count(1) > 0 then '1' else '0' end into existe_cliente
       from clientes  where cliente_id = id_cliente ;
	   if not existe_dato then 
	      raise exception 'El cliente no esta registrado';
	   end if;
		
       select case when count(1) > 0 then '1' else '0' end into existe_producto
       from productos  where prodicto_id = id_producto; 
		 
	   select case when max("stock ") > 0 then '1' else '0' end into existencia
       from productos  where producto_id = id_producto; 
		
       select precio into valor
       from productos  where producto_id = id_producto; 
		
  	   insert into pedidos(producto_id, cliente_id , cantidades , precio ,	
						   estado, fecha_registro )
	   values(id_producto, id_cliente, unidades , valor , 
			'carrito',	current_timestamp );
    end;
$$; 


----función reporte de pedidos

create or replace function reporte_pedidos (fecha_inicial timestamp, fecha_final timestamp)
returns table( cliente_id_rpt integer, 
	         pedido_id_rpt integer,
			 producto_id_rpt integer,
			 cantidades_rpt numeric ,
			 precio_rpt  numeric,
			 fecha_registro_rpt timestamp,
			 estado   varchar) 
 language plpgsql
 as $$
 
    begin
    -- logica de la funcion
	   return query
       select *
       from pedidos
	   where fecha_registro between fecha_inicial and fecha_final
	   order by cliente_id , pedido_id , producto_id ;
    end;
$$; 

