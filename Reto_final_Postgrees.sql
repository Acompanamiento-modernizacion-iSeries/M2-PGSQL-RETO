--Creación de tablas, relaciones y cheks.
--5 consultas que aporten valor al negocio.
--5 procedimientos almacenados que aporten valor al negocio.
--5 funciones que aporten valor al negocio.

--Enunciado
/*XYZ Store es una tienda en línea especializada en la venta de productos electrónicos y de consumo. 
La plataforma permite a los clientes navegar por una amplia gama de productos, 
realizar pedidos y gestionar sus cuentas de usuario. 
La base de datos de XYZ Store debe manejar información detallada sobre los productos, 
los clientes, los pedidos y las transacciones.*/

/*En XYZ Store, cada cliente tiene un perfil con su información personal, incluyendo nombre, 
apellido, dirección, teléfono, correo electrónico y fecha de registro. 
Los clientes pueden explorar el catálogo de productos, 
añadir productos a su carrito de compras, y realizar pedidos. 
Cada producto en el catálogo tiene atributos como el identificador del producto, nombre, 
descripción, precio, stock y categoría.*/

/*Cuando un cliente desea realizar una compra, selecciona productos y 
los añade a su carrito de compras. Al confirmar la compra, 
se genera un pedido que contiene información sobre los productos comprados, 
las cantidades, el precio total, y el estado del pedido (por ejemplo, procesando, 
enviado, entregado). Cada pedido está asociado a un cliente y puede contener múltiples productos. 
Los pedidos registran la fecha y hora en que se realizaron.*/


/*Los clientes pueden revisar sus pedidos pasados y realizar búsquedas de pedidos realizados 
en un periodo específico. La plataforma también permite a los clientes dejar reseñas y 
calificaciones para los productos que han comprado, proporcionando feedback a otros clientes y a 
la tienda. Cada reseña incluye la calificación, un comentario y la fecha en que se realizó.*/

/*Además, XYZ Store maneja una lista de deseos donde los clientes pueden guardar 
productos que les interesan para futuras compras. 
La lista de deseos de cada cliente puede contener múltiples productos y se 
actualiza según las preferencias del cliente.*/


/*La gestión del inventario es crucial para XYZ Store. Cuando se realiza una venta, 
el stock de los productos vendidos se actualiza automáticamente. 
Los clientes pueden consultar el stock actual de un producto antes de realizar una compra, 
y la tienda debe asegurarse de que la información de stock sea precisa y 
actualizada para evitar problemas de sobreventa.*/


/*XYZ Store valora la opinión de sus clientes y utiliza las calificaciones y 
comentarios dejados por los clientes para mejorar su servicio y la selección de productos. 
Los clientes pueden consultar las reseñas y calificaciones de un producto 
específico antes de tomar una decisión de compra, lo que les ayuda a tomar decisiones 
informadas basadas en las experiencias de otros usuarios.*/

create  table clientes(
   cliente_id integer primary key,
   nombre varchar(50) not null,
   apellido varchar(50) not null,
   direccion varchar(100),
   telefono varchar(20),
   email varchar(200) not null,
   fecha_registro timestamp default current_timestamp);
   

create table categoria_producto(
	categoria_id serial primary key,
	nombre varchar(100) not null
);


create table productos(
	producto_id serial primary key,
	nombre varchar(200) not null,
	categoria_id integer not null references categoria_producto(categoria_id) ,
	descripcion varchar(500),
	precio numeric(15, 2) not null,
	stock integer not null
);

 create table estados(
	estado_id serial primary key,
	normbre_estado varchar(20) not null
);

create table carro_compras(
	cliente_id integer references clientes(cliente_id) ,
	producto_id integer references productos(producto_id),
	cantidad integer not null,
	estado integer not null references estados(estado_id),
	fecha_pedido timestamp default current_timestamp ,	
	primary key(cliente_id, producto_id, fecha_pedido)
);

create table compras(
	compra_id serial primary key,
	cliente_id integer references clientes(cliente_id),
	producto_id integer references productos(producto_id) not null,
	cantidad integer not null,
	valor_total numeric(15,2) not null,
	estado_id integer references estados(estado_id) not null,
	fecha date  not null default current_date,
	hora time not null default current_time
);



create table reseñas_Cliente_producto(
	compra_id integer references compras(compra_id),
	producto_id integer references productos(producto_id),
	calificacion smallint not null check (calificacion between 1 and 10),
	comentario varchar(200),
	fecha_resena timestamp not null default current_timestamp,
	primary key(compra_id, producto_id)
);


create table deseos_cliente_producto(
	cliente_id integer references clientes(cliente_id),
	producto_id integer references productos(producto_id),
	fecha_registro timestamp not null default current_timestamp,
	primary key (cliente_id, producto_id)
);

insert into  Clientes 
values
(1037575512, 'Andres', 'Garcia', 'Calle 49B # 20-01', '3017540958', 'abadom54@gmail.com', '2021-09-26'),
(1022345653,'Camilo', 'Vergas', 'Calle 57A # 31-70', '3152345678', 'Camvergas@gmail.com', '2019-01-12'),
(689837636, 'Sara',   'Pineda', 'Calle 10A # 43-10', '3145674532', 'SaraPin@gmail.com', '2022-07-15'),
(1056736499,'Margarita', 'Corrales', 'Calle 50E # 40-67', '3218976545', 'Margara@gmail.com', '2015-09-22'),
(12345678,'Juan','Pérez', 'Calle Falsa 123, Ciudad, País',         '+1234567890', 'juan.perez@email.com', '2024-08-09'),
(87654321,'Ana', 'Gómez',       'Avenida Siempre Viva 456, Ciudad, País','+987 654 3210','ana.gomez@email.com','2023-01-15'),
(12223344,'Luis','Martínez',	'Plaza Central 789, Ciudad, País',	     '321 654 9870',	'luis.martinez@email.com',	'2021-06-12'),
(55667788,'María','Rodríguez',	'Calle Nueva 101, Ciudad, País',	     '+654 321 0987',	'maria.rodriguez@email.com',	'2020-08-20'),
(99887766,'Pedro','Fernández',	'Calle Vieja 202, Ciudad, País',	     '+432 109 8765',	'pedro.fernandez@email.com',	'2019-10-05'),
(22334455,'Laura','Sánchez',	'Calle del Sol 303, Ciudad, País',	     '+789 012 3456',	'laura.sanchez@email.com',	'2024-02-27'),
(33445566,'Carlos','Morales',	'Avenida del Río 404, Ciudad, País',	 '+210 987 6543',	'carlos.morales@email.com',	'2021-11-15'),
(44556677,'Elena','Fernández',	'Calle del Mar 505, Ciudad, País',	     '+345 678 9012',	'elena.fernandez@email.com',	'2018-04-19'),
(55667789,'Miguel','Castillo',	'Plaza del Pueblo 606, Ciudad, País',	 '+567 890 1234',	'miguel.castillo@email.com',	'2019-08-23'),
(66778899,'Isabel','Vargas',	'Calle de la Luna 707, Ciudad, País',	 '+678 901 2345',	'isabel.vargas@email.com',	'2017-09-22'),
(77889900,'Javier','Ortega',	'Avenida del Norte 808, Ciudad, País',   '+789 012 3456',	'javier.ortega@email.com',	'2018-09-26'),
(88990011,'Beatriz','Ruiz',	    'Calle del Este 909, Ciudad, País',	     '+890 123 4567',	'beatriz.ruiz@email.com',	'2015-03-10'),
(99001122,'Francisco','Gómez',	'Avenida del Sur 1010, Ciudad, País',	 '+901 234 5678',	'francisco.gomez@email.com',	'2024-08-08'),
(10112233,'Teresa','Martínez',	'Calle del Oeste 1111, Ciudad, País',  	 '+012 345 6789',	'teresa.martinez@email.com',	'2024-08-08'),
(15223344,'Roberto','Hernández','Calle del Ávila 1212, Ciudad, País',	 '+123 456 7891',	'roberto.hernandez@email.com',	'2024-08-08');

insert into categoria_producto(nombre)
values
('Computadoras y Periféricos'),
('Dispositivos Móviles'),
('Redes y Conectividad'),
('Tecnología de Audio y Video'),
('Electrodomésticos Inteligentes'),
('Dispositivos Portátiles y Wearables'),
('Tecnología de Audio y Video'),
('Electrónica de Consumo'),
('Dispositivos de Energía'),
('Tecnología de Oficina'),
('Robótica y Automatización'),
('Tecnología de Realidad Virtual y Aumentada'),
('Tecnología de Impresión y Copiado'),
('Tecnología de Salud y Bienestar');

insert into productos(nombre, categoria_id, descripcion, precio, stock)
values('Computadora de Escritorio HP Pavilion', 1,'Computadora de escritorio con procesador Intel Core i7, 16GB de RAM, 1TB HDD y 512GB SSD. Ideal para tareas multitarea y juegos ligeros.',	1200.00, 10),
('Laptop Dell XPS 13',	1 , 'Laptop ultradelgada con pantalla de 13.3" 4K, procesador Intel Core i7, 16GB de RAM, 512GB SSD. Ligera y potente, ideal para profesionales en movimiento.',	1500.00, 1),
('Estación de Trabajo Lenovo ThinkStation P520', 1,	 'Estación de trabajo con procesador Intel Xeon, 32GB de RAM, 1TB SSD y tarjeta gráfica NVIDIA Quadro. Diseñada para tareas intensivas y diseño gráfico.',	2500.00, 16),
('Monitor ASUS ProArt PA32UCX',	1,'Monitor de 32" 4K UHD con calibración de fábrica y cobertura de color Adobe RGB. Ideal para edición de fotos y video profesional.',	1000.00, 20),
('Teclado Mecánico Corsair K95 RGB'	, 1,'Teclado mecánico con retroiluminación RGB, teclas programables y switches Cherry MX. Perfecto para jugadores y escritores.',	200.00, 40),
('Ratón Logitech MX Master 3',	1,'Ratón ergonómico con conexión inalámbrica, rueda de desplazamiento de precisión y botones programables. Ideal para profesionales y diseñadores.',	100.00, 20),
('Impresora HP OfficeJet Pro 9015',	13 , 'Impresora multifunción con capacidades de impresión, escaneo, copiado y fax. Compatible con impresión inalámbrica y automática a doble cara.',	250.00, 1),
('Escáner Epson Perfection V600',	13 ,'Escáner de alta resolución con capacidad para escanear fotos, documentos y negativos. Ideal para archivos digitales de alta calidad.',	300.00, 4),
('Webcam Logitech C920', 1  ,'Webcam Full HD 1080p con enfoque automático y micrófono integrado. Ideal para videoconferencias y streaming.',	80.00, 3),
('Almacenamiento Externo Seagate Backup Plus 2TB', 1, 'Disco duro externo con capacidad de 2TB, compatible con USB 3.0. Ideal para copias de seguridad y almacenamiento adicional.',	120.00, 2),
('Laptop Apple MacBook Pro 16"',	1 ,  'Laptop con pantalla Retina de 16", procesador Apple M1 Max, 32GB de RAM, 1TB SSD. Ideal para tareas profesionales de alto rendimiento.',	2400.00, 8),
('Computadora de Escritorio Dell Inspiron',	1 ,'Computadora de escritorio con procesador AMD Ryzen 5, 8GB de RAM, 512GB SSD y gráfica integrada Radeon. Ideal para uso diario y tareas ligeras.',	800.00, 9),
('Monitor Dell UltraSharp U2720Q',	1 ,'Monitor de 27" 4K UHD con panel IPS, conexión USB-C y ajuste ergonómico. Perfecto para trabajo de diseño y productividad.',	650.00, 23),
('Teclado Logitech G Pro X',1  , 'Teclado mecánico compacto con switches intercambiables y retroiluminación RGB. Diseñado para jugadores y entusiastas del teclado.', 130.00, 60),
('Ratón Razer DeathAdder V2',1,	'Ratón ergonómico con sensor óptico de 20,000 DPI, retroiluminación RGB y botones programables. Ideal para gamers.',	70.00, 10),
('Impresora Canon imageCLASS MF743Cdw',	13 ,'Impresora láser multifunción con impresión, escaneo, copiado y fax en color. Capaz de manejar grandes volúmenes de impresión.',	500.00, 3),
('Escáner Fujitsu ScanSnap iX1600',	 13 ,  'Escáner de documentos compacto con capacidad de escaneo inalámbrico y doble cara. Ideal para oficina en casa y pequeñas empresas.',	300.00, 9),
('Webcam Razer Kiyo Pro',	1 ,'Webcam Full HD 1080p con lente de alta calidad y ajuste de brillo. Ideal para streaming y videoconferencias profesionales.',	100.00, 80),
('Almacenamiento Externo Western Digital My Passport 4TB', 1,  'Disco duro externo portátil con capacidad de 4TB, compatible con USB 3.0. Perfecto para grandes volúmenes de datos.',	150.00, 10),
('Docking Station Kensington SD5700T', 1,  'Estación de acoplamiento con soporte para conexiones USB-C, múltiples puertos USB, HDMI y Ethernet. Ideal para aumentar la conectividad de laptops.',	250.00, 15),
('Monitor LG UltraWide 34WN80C-B',	1  ,'Monitor curvo de 34" UltraWide QHD con soporte para HDR10 y múltiples puertos de entrada. Ideal para multitarea y trabajo creativo.',	 750.00, 34),
('Teclado Razer BlackWidow V3',	1, 'Teclado mecánico con retroiluminación RGB, switches mecánicos Razer Green y diseño duradero. Diseñado para una experiencia de escritura y juego óptima.',	180.00, 10),
('Ratón Logitech G502 Hero',	 1, 'Ratón para juegos con sensor HERO de 16,000 DPI, 11 botones programables y retroiluminación RGB. Ideal para gamers profesionales.',	80.00, 56),
('Impresora Brother MFC-L2750DW', 13, 'Impresora láser multifunción en blanco y negro con capacidades de impresión, escaneo, copiado y fax. Ideal para pequeñas oficinas y trabajo desde casa.',	300.00, 100),
('Escáner HP ScanJet Pro 2500 f1',	13, 'Escáner de documentos con capacidades de escaneo a color y doble cara. Ideal para digitalización de documentos y fotos.',	350.00, 30),
('iPhone 14 Pro',  2,	'Smartphone con pantalla Super Retina XDR y cámara de 48 MP.',	999.99,	20),
('Samsung Galaxy S23 Ultra'	,2, 'Smartphone con pantalla AMOLED de 6.8" y cámara cuádruple de 200 MP.',	1199.99,	15),
('Google Pixel 7',  2,	'Smartphone con pantalla OLED de 6.3" y cámara dual de 50 MP.',	599.99,	30),
('OnePlus 11', 2,	'Smartphone con pantalla Fluid AMOLED de 6.7" y cámara triple de 50 MP.',	749.99,	25),
('Xiaomi Mi 13 Pro', 2,	'Smartphone con pantalla AMOLED de 6.73" y cámara principal de 50 MP.',	849.99,	18),
('Sony Xperia 1 IV', 2,	'Smartphone con pantalla 4K OLED de 6.5" y cámara cuádruple de 12 MP.',	1199.99,	10),
('Motorola Edge 40',  2,	'Smartphone con pantalla OLED de 6.5" y cámara triple de 50 MP.',	699.99,	22),
('Oppo Find X6 Pro', 2,	'Smartphone con pantalla AMOLED de 6.82" y cámara principal de 50 MP.',	899.99,	17),
('Asus ROG Phone 7',  2,	'Smartphone gamer con pantalla AMOLED de 6.78" y cámara triple de 50 MP.',	1099.99,	12),
('Huawei P60 Pro',  2,	'Smartphone con pantalla OLED de 6.67" y cámara cuádruple de 50 MP.',	899.99,	14),
('Realme GT 3', 2,	'Smartphone con pantalla AMOLED de 6.74" y cámara triple de 50 MP.',	749.99,	20),
('Vivo X90 Pro', 2,	'Smartphone con pantalla AMOLED de 6.78" y cámara triple de 50 MP.',	849.99,	16),
('Nokia X40',  2,	'Smartphone con pantalla AMOLED de 6.43" y cámara dual de 64 MP.',	499.99,	25),
('TCL Stylus 5G', 2,	'Smartphone con pantalla LCD de 6.9" y cámara cuádruple de 48 MP.',	349.99,	30),
('LG V70 ThinQ',  2,	'Smartphone con pantalla OLED de 6.8" y cámara triple de 64 MP.',	799.99,	13),
('ZTE Axon 40 Ultra' ,  2,	'Smartphone con pantalla AMOLED de 6.8" y cámara triple de 64 MP.',	1099.99,	11),
('Sony WH-1000XM5',  4, 'Auriculares inalámbricos con cancelación de ruido y calidad de sonido superior', 349.99,  25),
('Bose QuietComfort 45',   4, 'Auriculares de diadema con tecnología de cancelación activa de ruido y sonido premium', 329.99,  18),
('Apple AirPods Pro (2ª generación)', 4, 'Auriculares verdaderamente inalámbricos con cancelación activa de ruido y modo de transparencia', 249.99,  30),
('Samsung QLED 55" Q80T',  4, 'Televisor QLED 4K de 55 pulgadas con tecnología de retroiluminación directa y sonido Dolby Atmos', 1299.99,  12),
('LG OLED65CXPUA',  4, 'Televisor OLED 4K de 65 pulgadas con soporte para Dolby Vision y Dolby Atmos', 1799.99,  8),
('Sonos Arc',  4, 'Barra de sonido premium con soporte para Dolby Atmos y sonido envolvente 3D', 899.99,  15),
('Amazon Fire TV Stick 4K',  4, 'Dispositivo de streaming con soporte para 4K Ultra HD y Alexa integrada', 49.99,  35),
('Roku Streaming Stick+',  4, 'Dispositivo de streaming con resolución 4K HDR y control remoto con botones de acceso rápido', 39.99,  40),
('Logitech C920 HD Pro Webcam', 4, 'Cámara web Full HD con enfoque automático y micrófonos estéreo', 79.99,  28),
('GoPro HERO11 Black',  4, 'Cámara de acción con video 5.3K y estabilización avanzada HyperSmooth', 399.99,  20),
('Apple iPad Pro 12.9" (6ª generación)', 8, 'Tableta con pantalla Liquid Retina XDR, chip M2 y soporte para Apple Pencil', 1199.99, 22),
('Samsung Galaxy Tab S9 Ultra',   8, 'Tableta con pantalla AMOLED de 14.6", procesador Snapdragon 8 Gen 2 y S Pen incluido', 1299.99, 18),
('Microsoft Surface Laptop 5',  8, 'Portátil con pantalla táctil de 13.5", procesador Intel Core i7 y 512 GB de SSD', 1499.99, 15),
('Sony PlayStation 5',  8, 'Consola de videojuegos con soporte para 4K Ultra HD, GPU personalizada y unidad de disco Blu-ray', 499.99, 30),
('Xbox Series X', 8, 'Consola de videojuegos con rendimiento 4K, almacenamiento SSD de 1 TB y retrocompatibilidad', 499.99, 20),
('Apple Watch Series 8', 8, 'Reloj inteligente con pantalla Retina siempre activa, sensor de oxígeno en sangre y seguimiento de fitness', 399.99, 25),
('Fitbit Charge 5',  8, 'Pulsera de actividad con monitorización de salud, GPS integrado y pantalla AMOLED', 179.99, 35),
('Amazon Echo Dot (5ª generación)',  8, 'Altavoz inteligente con Alexa, sonido de 1.6" y control por voz', 49.99, 40),
('Google Nest Hub Max',  8, 'Pantalla inteligente de 10", con altavoz integrado, Google Assistant y videollamadas', 229.99, 28),
('Roku Ultra 2024',  8, 'Dispositivo de streaming 4K HDR con control remoto mejorado y soporte para Dolby Vision', 99.99, 32),
('Samsung Family Hub Refrigerator',  10, 'Refrigerador inteligente con pantalla táctil de 21.5", conectividad Wi-Fi, y capacidad para gestionar recetas y listas de compras', 3299.99, 10),
('iRobot Roomba j7+',  10, 'Aspiradora robot con tecnología de navegación avanzada y función de vaciado automático del depósito', 649.99, 15),
('Nest Learning Thermostat (3ª generación)',  10, 'Termostato inteligente con capacidad de aprendizaje automático y control remoto desde smartphone', 249.99, 20),
('Philips Hue Lightstrip Plus',  10, 'Tira de luces LED inteligentes con control de color y brillo desde smartphone, compatible con Alexa y Google Assistant', 89.99, 25),
('LG WashTower',  10, 'Lavadora y secadora inteligentes en una sola unidad con capacidad de carga frontal, control desde app móvil y tecnología de inteligencia artificial', 2499.99, 12),
('Dyson Airwrap Complete',  10, 'Herramienta de estilizado de cabello inteligente con múltiples accesorios y control de temperatura para evitar daños', 599.99, 18),
('Ecobee SmartThermostat with Voice Control',  10, 'Termostato inteligente con control de voz integrado y sensor de ocupación, compatible con Alexa, Google Assistant y Apple HomeKit', 249.99, 22),
('August Smart Lock Pro',  10, 'Cerradura inteligente con acceso remoto, compatibilidad con sistemas de control de voz y fácil instalación sobre cerraduras existentes', 279.99, 30),
('Smart Plugs TP-Link Kasa',  10, 'Enchufes inteligentes con control remoto desde app móvil y compatibilidad con Alexa y Google Assistant', 29.99, 40),
('Keurig K-Elite Coffee Maker',  10, 'Cafetera inteligente con múltiples opciones de preparación, ajustes de intensidad y capacidad para conectarse con app móvil', 179.99, 28);


insert into estados(normbre_estado) 
values('proceso venta'),
('Vendido'),
('Enviado'),
('Entregado'),
('en reparto'),
('en bodega origen'),
('en bodega destino'),
('garantia'),
('Devolución');

insert into carro_compras
values
(1037575512, 1001, 1, 10, '2024-01-01'),
(1022345653, 1002, 3, 1, '2024-02-01'),
(689837636,  1003, 10, 3, '2024-03-02'),
(1037575512, 1004, 2, 4, '2024-04-10'),
(689837636,  1005, 1, 9, '2024-01-20'),
(87654321,   1006, 4, 1, '2024-07-08'),
(77889900,   1007, 5, 2, '2024-07-08'),
(22334455,   1008, 3, 3, '2024-06-08'),
(1022345653, 1009, 2, 4, '2024-03-08'),
(10112233,   1010, 1, 5, '2024-04-08'),
(87654321,   1001, 1, 6, '2024-05-15'),
(1056736499, 1002, 1, 7, '2024-02-22'),
(689837636,  1020, 2, 2, '2024-01-25'),
(55667788,   1011, 1, 8, '2024-06-24'),
(87654321,   1015, 1, 9, '2024-02-23'),
(1022345653, 1034, 3, 2, '2024-03-12'),
(1056736499, 1040, 1, 10, '2024-03-12'),
(22334455,   1010, 6, 10, '2024-05-11'),
(10112233,   1020, 9, 10, '2024-06-09'),
(1056736499, 1050, 10, 10, '2024-07-10'),
(87654321,   1001, 1, 2, '2023-09-07'),
(77889900,   1002, 1, 7, '2023-10-06'),
(55667788,   1054, 2, 6, '2023-11-05'),
(1037575512, 1040, 1, 5, '2023-10-04'),
(87654321,   1030, 3, 4, '2024-08-03'),
(87654321,   1031, 1, 2, '2024-08-02'),
(689837636,  1032, 1, 3, '2024-07-01'),
(99001122,   1033, 6, 9, '2024-06-22'),
(1022345653, 1056, 1, 8, '2024-05-21'),
(87654321,   1019, 3, 3, '2024-04-20'),
(1056736499, 1020, 1, 1, '2024-03-19'),
(87654321,   1021, 1, 10, '2024-02-18'),
(99001122,   1040, 1, 7, '2024-01-17'),
(1037575512, 1050, 2, 3, '2024-07-16'),
(77889900,   1051, 3, 5, '2024-06-15'),
(689837636,  1052, 1, 6, '2024-05-14'),
(87654321,   1060, 4, 2, '2024-04-13'),
(1022345653, 1070, 5, 2, '2024-03-12'),
(22334455,   1069, 4, 2, '2024-02-11'),
(1056736499, 1010, 1, 2, '2024-01-10');

--se insertan los registros en la tabla compras basado en la tabla carro de compras que tienen estado vendido y se asigna el estado entregado
--y siesta en estado proceso de venta se asigna enviado

insert into compras(cliente_id, producto_id, cantidad, valor_total, estado_id,
				   fecha, hora)
select a.cliente_id, a.producto_id, a.cantidad, b.precio * a.cantidad, 
       case when a.estado = 2 then 4
	        when a.estado = 10 then 3 end, date(a.fecha_pedido),
	  (substr(cast((random() * (interval '90 days')) + '30 days' as text), 9, 8))::time
from carro_compras a
join productos b on b.producto_id = a.producto_id
where a.estado in( 2, 10);

insert into reseñas_Cliente_producto
values
(1,	1001,	5,	'Comentario prueba cliente:87654321',	'2023-09-07'),
(3,	1002,	7,	'Comentario prueba cliente:77889900',	'2023-10-06'),
(5,	1003,	8,	'Comentario prueba cliente:689837636',	'2024-03-02'),
(6,	1004,	1,	'Comentario prueba cliente:1037575512',	'2024-04-10'),
(7,	1005,	6,	'Comentario prueba cliente:689837636',	'2024-01-20'),
(8,	1006,	5,	'Comentario prueba cliente:87654321',	'2024-07-08'),
(9,	1007,	10,	'Comentario prueba cliente:77889900',	'2024-07-08'),
(12,1010,	7,	'Comentario prueba cliente:1056736499',	'2024-01-10'),
(15,1015,	7,	'Comentario prueba cliente:87654321',	'2024-02-23'),
(16,1019,	8,	'Comentario prueba cliente:87654321',	'2024-04-20'),
(17,1020,	7,	'Comentario prueba cliente:1056736499',	'2024-03-19'),
(19,1020,	10,	'Comentario prueba cliente:689837636',	'2024-01-25'),
(21,1030,	5,	'Comentario prueba cliente:87654321',	'2024-08-03'),
(22,1031,	9,	'Comentario prueba cliente:87654321',	'2024-08-02'),
(23,1034,	7,	'Comentario prueba cliente:1022345653',	'2024-03-12'),
(24,1040,	3,	'Comentario prueba cliente:99001122',	'2024-01-17'),
(25,1040,	10,	'Comentario prueba cliente:1037575512',	'2023-10-04'),
(26,1040,	1,	'Comentario prueba cliente:1056736499',	'2024-03-12'),
(27,1050,	4,	'Comentario prueba cliente:1037575512',	'2024-07-16'),
(29,1051,	10,	'Comentario prueba cliente:77889900',	'2024-06-15'),
(30,1054,	5,	'Comentario prueba cliente:55667788',	'2023-11-05'),
(31,1060,	7,	'Comentario prueba cliente:87654321',	'2024-04-13'),
(32,1069,	8,	'Comentario prueba cliente:22334455',	'2024-02-11'),
(33,1070,	8,	'Comentario prueba cliente:1022345653',	'2024-03-12');

insert into deseos_cliente_producto(cliente_id, producto_id)
values
(1056736499, 1045 ),
(1022345653, 1049 ),
(55667789, 1034),
(22334455, 1026),
(12345678, 1063),
(1037575512, 1056 );



select * from clientes;
select * from categoria_producto;
select * from productos;
select * from estados;
select * from carro_compras;
select * from compras;
select * from reseñas_Cliente_producto;



--Consultas
--1. consulta de productos que estan en inventario y cuales se deben comprar
select a.producto_id, a.nombre, b.nombre as categoria, stock,
case when stock = 0 then 'producto sin stock, contactar proveedores para avastecer' 
     when stock < 3 then 'producto con poco stock, contactar proveedores para abastecer'
end
as Alerta
from productos a
join categoria_producto b on b.categoria_id = a.categoria_id;

--2. consulta de productos por categoria
select a.producto_id, a.nombre, b.nombre as categoria, a.precio, a.stock, a.descripcion
from productos a
join categoria_producto b on b.categoria_id = a.categoria_id 
where upper(b.nombre) like '%COMPUTADO%';

--3. consulta de los productos mas comprados por lo clientes para ofrecer promociones y nuevos productos

select a.cliente_id, a.nombre||' '||a.apellido, c.producto_id, c.nombre, sum(b.cantidad) cantidad_compra_total, 
sum(valor_total) valor_comptra_total
from clientes a
join compras b on b.cliente_id = a.cliente_id
join productos c on c.producto_id = b.producto_id
where b.estado_id not in(1, 2, 9, 8)
group by a.cliente_id, a.nombre, a.apellido , c.producto_id, c.nombre
order by  sum(valor_total) DESC ;

--Procedimientos almacenados
--  1.stored procedure que asigna producto al carro de compras

create or replace procedure crea_producto_carro_compras (
	id_cliente integer, 
	id_producto integer,
	cantidad_ integer,
    estado_ integer)
language plpgsql
as $$
    -- creacion de variables
	declare existe_cliente boolean;
	declare existe_producto boolean;
	declare existe_stock boolean;
	declare existe_carro_compras boolean;
	
    begin
	-- se valida cliente
	   if id_cliente = 0  then 
	       raise exception 'Debe ingresar el id del cliente';
       end if;
	
	-- se valida que el cliente exista		
	   select case when count(1) > 0 then '1' else '0' end into existe_cliente
       from clientes  where cliente_id = id_cliente ;
	   if not existe_cliente then 
	      RAISE EXCEPTION 'El id de cliente no esta registrado en el sistema';
	   end if;
	   
	   	-- se valida que el producto exista		
	   select case when count(1) > 0 then '1' else '0' end into existe_producto
       from productos  where producto_id = id_producto ;
	   if not existe_producto then 
	      RAISE EXCEPTION 'El producto no existe en el sistema';
	   end if;
	   
	   --valida stock del producto en inventario
	   select   case when stock < cantidad_ then '0' else '1' end into existe_stock
       from productos  where producto_id = id_producto ;
	   if not existe_stock then 
	      RAISE EXCEPTION 'Lo sentimos, el producto no cuenta con la cantidad solicitada en stock';
	   end if;
	   
	   if estado_ not in(1, 2, 10) then
	      RAISE EXCEPTION 'Estado incorrecto';
	   end if;
	
    -- logica de la funcion
	   insert into carro_compras
	   values(id_cliente, id_producto, cantidad_, estado_, current_timestamp );
    end;
$$; 

call crea_producto_carro_compras(1037575512, 1055, 1, 10);

  --2. stored procedure que crea la compra
create or replace procedure crear_compra (
	id_cliente integer, 
	id_producto integer,
    estado_ integer)
language plpgsql
as $$
    -- creacion de variables
	declare existe_cliente boolean;
	declare existe_producto boolean;
	declare existe_stock boolean;
	declare existe_carro_compras boolean;
	declare cantidad_ integer;
	declare valor_productos real;
	
    begin
	-- se valida cliente
	   if id_cliente = 0  then 
	       raise exception 'Debe ingresar el id del cliente';
       end if;
	
	-- se valida que el cliente exista		
	   select case when count(1) > 0 then '1' else '0' end into existe_cliente
       from clientes  where cliente_id = id_cliente ;
	   if not existe_cliente then 
	      RAISE EXCEPTION 'El id de cliente no esta registrado en el sistema';
	   end if;
	   
	   --valida stock del producto en inventario
	   select   case when stock < cantidad_ then '0' else '1' end into existe_stock
       from productos  where producto_id = id_producto ;
	   if not existe_stock then 
	      RAISE EXCEPTION 'Lo sentimos, el producto no cuenta con la cantidad solicitada en stock';
	   end if;
	   
	   -- valida que exista en carro de compras y que este en estado proceso de venta
	   select  case when count(1) > 0 then '1' else '0' end into existe_carro_compras
       from carro_compras  
	   where cliente_id = id_cliente and 
	         producto_id = id_producto and estado = 10;
	   if not existe_carro_compras then 
	      RAISE EXCEPTION 'Lo sentimos, no se ha agregado el producto al carro de compras';
	   end if;
	   
	   select a.cantidad, (a.cantidad * b.precio) into cantidad_ , valor_productos
	   from carro_compras a
	   join productos b on b.producto_id = a.producto_id
	   where a.cliente_id = id_cliente and a.producto_id = id_producto and estado = 10;
	   	
    -- logica de la funcion
	   insert into compras(cliente_id, producto_id, cantidad, valor_total, estado_id)
	   values(id_cliente, id_producto, cantidad_, valor_productos, estado_ );
	-- se actualiza stock de inventario
	   update productos set stock = stock - cantidad_ where producto_id = id_producto;
    end;
$$; 

select * from productos where producto_id = 1055;
call crear_compra(1037575512, 1055, 2 );
select * from compras where cliente_id = 1037575512;

--3 procedimiento para crear productos:
create or replace procedure crear_producto (
	nombre_producto varchar(200), 
	id_categoria integer,
    descripcion_producto varchar(500),
    precio_producto numeric(15, 2),
    cantidad_stock integer)
language plpgsql
as $$
    -- creacion de variables
	declare existe_categoria boolean;
	declare existe_producto boolean;
	
    begin
	-- se valida nombre producto
	   if trim(nombre_producto) = ''  then 
	       raise exception 'Debe ingresar el nombre del producto';
       end if;
	   
	   	-- se valida categoria producto
	   if id_categoria = 0  then 
	       raise exception 'Debe ingresar la categoria del producto';
       end if;
	   
	   -- se valida la categoria
	   select case when count(1) > 0 then '1' else '0' end into existe_categoria
       from categoria_producto  where categoria_id = id_categoria ;
	   if not existe_categoria then
	      raise exception 'categoria no existe';
	   end if;

	   insert into productos(nombre, categoria_id, descripcion , precio, stock)
		  values(nombre_producto, id_categoria, descripcion_producto,
			   precio_producto, cantidad_stock);
    end;
$$; 
call crear_producto('Nuevo producto prueba', 3, 'Esto es una prueba de crear producto', 150000.00, 100);
select * from productos;

--4. stor procedure par crear clientes
create or replace  procedure insertar_cliente(
	p_identificacion integer,
    p_nombre VARCHAR(50),
    p_apellido VARCHAR(50),
    p_direccion VARCHAR(100) ,
    p_telefono VARCHAR(20),
    p_email VARCHAR(200)
) language plpgsql 
as $$
begin
    INSERT INTO clientes (cliente_id, nombre, apellido, direccion, telefono, email)
    VALUES (p_identificacion, p_nombre, p_apellido, p_direccion, p_telefono, p_email);
end;
$$;

select * from clientes;
call insertar_cliente(1054986437, 'Jessica', 'Agudelo', 'Barrio el savador', '3212665676', 'jessica_hermosa@gmail.com' );



--Funciones

-- 1. función que retorna todas las ventas de un producto determinado ( 
--valor total de  ventas)

create or replace function total_ventas_producto (id_producto integer)
returns numeric(15,2)
language plpgsql
as $$
    -- creacion de variables
    declare total_venta numeric(15, 2) default 0.00;
	DECLARE existe_producto boolean;
 
    begin
	--
	-- se valida cliente
	   if id_producto = 0  then 
	       raise exception 'Debe ingresar el id del producto';
       end if;
	   
	   	-- se valida que el producto exista		
	   select case when count(1) > 0 then '1' else '0' end into existe_producto
       from productos  where producto_id = id_producto ;
	   if not existe_producto then 
	      RAISE EXCEPTION 'El producto no existe en el sistema';
	   end if;
	 
	
    -- logica de la funcion
       select sum(valor_total)
	   into total_venta
       from compras 
	   where producto_id = id_producto;

    -- retorno la variable con el resultado
       return total_venta;
    end;
$$; 

select total_ventas_producto(2055);

--2 -- se crea UDF que retorna una tabla con los datos del carrito de compras por cliente
create or replace function consultar_carro_compras (id_cliente integer)
returns table(id_producto integer,
			  nombre_producto varchar,
			  cantidad_producto integer,
			  valor_producto  numeric,
			  estado integer,
			  nombre_estado varchar,
			  fecha_transaccion_ timestamp) 
 language plpgsql
 as $$
    -- creacion de variables
 
    begin
    -- logica de la funcion
	   return query
       select a.producto_id, b.nombre, a.cantidad, b.precio, 
       a.estado, c.normbre_estado, a.fecha_pedido
       from carro_compras a
       join productos b on b.producto_id = a.producto_id
       join estados c on c.estado_id = a.estado
       where a.cliente_id = id_cliente;
    end;
$$; 

select * from estados;
select consultar_carro_compras(1037575512);


