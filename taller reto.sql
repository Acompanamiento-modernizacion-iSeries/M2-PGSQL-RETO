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
create table Transacciones (
transaccion_id serial   primary key  , 
pedido_id int      REFERENCES Pedidos(pedido_id) not null, 
tipo_transaccion varchar (20)    NOT NULL check (tipo_transaccion IN('carrito', 'procesando', 'enviado', 'entregado') ), 
fecha_transaccion TIMESTAMP      NOT NULL
);

---consultas
select * from Clientes where estado = 'activo';
select a.cliente_id, a.nombre,b.pedido_id, b.producto_id  from 
Clientes a inner join Pedidos b on a.cliente_id  = b.cliente_id
where a.cliente_id = 3;
select pedido_id, cliente_id, sum(precio) valor_total_pedido from Pedidos 
group by pedido_id, cliente_id;
select * from Transacciones where tipo_transaccion = 'carrito';
select * from Lista_de_deseos where cliente_id =3 ;

-----
create or replace procedure crear_cliente(
	nombre_new varchar (50), apellido_new varchar (50), direccion_new varchar (100) , telefono_new varchar (20), correo_electronico_new varchar (200)    )
language plpgsql
as $$
    


    begin
	   if nombre_new = ' '  then
	      raise exception 'nombre cliente en blanco';
	   end if;
           if apellido_new = ' '  then
	      raise exception 'apellido cliente en blanco';
	   end if;
           if correo_electronico_new = ' '  then
	      raise exception 'email cliente en blanco';
	   end if;

           insert into Clientes(nombre,apellido,direccion,telefono,correo_electronico) 
	   values(nombre_new,apellido_new,direccion_new,telefono_new,correo_electronico_new);
    end;
$$;

create or replace procedure modificar_cliente(id_cliente int ,
	direccion_new varchar (100) , telefono_new varchar (20), correo_electronico_new varchar (200)    )
language plpgsql
as $$
    


    begin
       	if id_cliente = 0  then 
	    raise exception 'Debe ingresar el cliente';
        end if;

        if correo_electronico_new = ' '  then
	      raise exception 'email cliente en blanco';
	else
		update Clientes set correo_electronico = correo_electronico_new where cliente_id = id_cliente; 
	end if;

        
	   if direccion_new  <> '' then	
             update Clientes set direccion = direccion_new   where cliente_id = id_cliente; 
	   end if;	
	   if telefono_new  <> '' then	
             update Clientes set telefono = telefono_new where cliente_id = id_cliente; 
	   end if;
    end;
$$;

create or replace procedure crear_Producto(
nombre_new varchar (50)  , 
descripción_new varchar (200)  , 
precio_new numeric (15, 2)    , 
stock_new  numeric (15, 0)    , 
categoría_new varchar (20)   
   )
language plpgsql
as $$
    


    begin
	   if nombre_new = ' '  then
	      raise exception 'nombre producto en blanco';
	   end if;
           if descripción_new = ' '  then
	      raise exception 'descripción producto en blanco';
	   end if;
           if precio_new = 0  then
	      raise exception 'precio producto en blanco';
	   end if;

           insert into Productos(nombre,descripción,precio,stock, categoría) 
	   values(nombre_new,descripción_new,precio_new,stock_new, categoría_new);
    end;
$$;

create or replace procedure actualiza_Producto(id_producto int,
precio_new numeric (15, 2)    , 
stock_new  numeric (15, 0)    , 
categoría_new varchar (20)    
								   
   )
language plpgsql
as $$
    


    begin

       if precio_new = 0  then
	      raise exception 'precio producto en cero';
	   else
	   
             update Productos set precio = precio_new   where producto_id = id_producto; 
		   
	   end if;
       if stock_new  = 0  then
	      raise exception 'stock producto en cero';
	   else
	   
             update Productos set stock = stock_new    where producto_id = id_producto; 
		   
	   end if;
	   if categoría_new = ' '  then
	      raise exception 'categori producto en blanco';
	   else
	   
             update Productos set categoría = categoría_new   where producto_id = id_producto; 
		   
	   end if;
	   
   
    end;
$$;

create or replace procedure modificar_Producto_stock(id_producto int,

stock_new  numeric (15, 0)     
 
   )
language plpgsql
as $$
    


    begin


             update Productos set stock = stock + stock_new    where producto_id = id_producto; 

    end;
$$; 

---------------------------funciones
create or replace function reporte_Transacciones (fecha_inicial timestamp, fecha_final timestamp)
returns table(transaccion_id_bus integer,
			 pedido_id_bus integer,
			 tipo_transaccion_bus varchar,
			 fecha_transaccion_bus timestamp) 
 language plpgsql
 as $$
   
 
    begin
    -- logica de la funcion
	   return query
       select transaccion_id, pedido_id, tipo_transaccion,  fecha_transaccion
       from transacciones 
	   where fecha_transaccion between fecha_inicial and fecha_final;
    end;
$$;

create or replace function deseos_cliente (cliente_id_bus int )
returns table(lista_id_bus integer,
			 producto_id_bus integer) 
 language plpgsql
 as $$
   
    begin
    -- logica de la funcion
	   return query
       select lista_id, producto_id
       from transacciones 
	   where cliente_id = cliente_id_bus;
    end;
$$; 

create or replace function valorpedido_cliente (cliente_id_bus int )
returns  decimal(15,2)
 language plpgsql
 as $$
   declare valor_cliente numeric(15, 2) default 0.00;
 
    begin
    -- logica de la funcion
	    
       select sum(precio) into valor_cliente
       from Pedidos 
	   where cliente_id = cliente_id_bus;
	   return valor_cliente;
    end;
$$; 

create or replace function stock_procuto (producto_id_bus int )
returns decimal(15,2)
 language plpgsql
 as $$
   declare nro_stock numeric(15, 2) default 0.00;
 
    begin
    -- logica de la funcion
	    
       select stock  into nro_stock
       from Productos 
	   where producto_id = producto_id_bus;
	   return nro_stock;
    end;
$$; 

create or replace function valor_procuto (producto_id_bus int )
returns decimal(15,2)
 language plpgsql
 as $$
   declare nro_valor numeric(15, 2) default 0.00;
 
    begin
    -- logica de la funcion
	    
       select precio into nro_valor
       from Productos 
	   where producto_id = producto_id_bus;
	   return nro_valor;
    end;
$$; 