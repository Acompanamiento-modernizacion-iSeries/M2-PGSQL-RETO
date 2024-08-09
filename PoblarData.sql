-- Poblar tabla usuarios
INSERT INTO usuarios (nombre, apellido, direccion, telefono, email) VALUES
('Carlos', 'Rodríguez', 'Calle 72 #10-34, Bogotá', '3101234567', 'carlos.rodriguez@email.com'),
('María', 'González', 'Carrera 43A #1-50, Medellín', '3157654321', 'maria.gonzalez@email.com'),
('Juan', 'Martínez', 'Calle 8 #38-20, Cali', '3203334444', 'juan.martinez@email.com'),
('Ana', 'López', 'Carrera 54 #68-80, Barranquilla', '3112223333', 'ana.lopez@email.com'),
('Luis', 'Hernández', 'Avenida 4 #14-60, Bucaramanga', '3145556666', 'luis.hernandez@email.com'),
('Laura', 'Díaz', 'Calle 11 #4-21, Cartagena', '3187778888', 'laura.diaz@email.com'),
('Pedro', 'Sánchez', 'Carrera 23 #65-41, Manizales', '3209998888', 'pedro.sanchez@email.com'),
('Sofia', 'Ramírez', 'Avenida Circunvalar #10-50, Pereira', '3132221111', 'sofia.ramirez@email.com'),
('Diego', 'Torres', 'Calle 19 #9-50, Santa Marta', '3165554444', 'diego.torres@email.com'),
('Valentina', 'Castro', 'Carrera 5 #10-63, Pasto', '3108887777', 'valentina.castro@email.com');

-- Poblar tabla productos
INSERT INTO productos (nombre, descripcion, precio, stock, categoria) VALUES
('Auriculares Bluetooth', 'Auriculares inalámbricos con cancelación de ruido', 199.99, 50, 'Audio'),
('Laptop Gamer', 'Laptop de alto rendimiento para gaming', 1299.99, 20, 'Portátiles'),
('Smartphone Galaxy S21', 'Último modelo de Samsung con cámara de alta resolución', 799.99, 30, 'Smartphones'),
('iMac 27"', 'Computadora todo en uno de Apple', 1799.99, 15, 'Computadoras'),
('Teclado Mecánico', 'Teclado para gaming con switches Cherry MX', 129.99, 40, 'Periféricos'),
('Cargador Portátil', 'Batería externa de 20000mAh', 49.99, 100, 'Accesorios'),
('Cámara DSLR', 'Cámara profesional con lente intercambiable', 899.99, 25, 'Fotografía'),
('Drone DJI', 'Drone con cámara 4K y estabilizador', 799.99, 10, 'Video'),
('PlayStation 5', 'Consola de última generación de Sony', 499.99, 5, 'Consolas'),
('Smartwatch', 'Reloj inteligente con monitor de ritmo cardíaco', 249.99, 35, 'Wearables');

-- Poblar tabla pedidos
INSERT INTO pedidos (id_usuario, precio_total, estado) VALUES
(1, 199.99, 'procesando'),
(2, 1299.99, 'enviado'),
(3, 849.98, 'entregado'),
(4, 1799.99, 'procesando'),
(5, 179.98, 'enviado'),
(6, 899.99, 'entregado'),
(7, 549.98, 'procesando'),
(8, 799.99, 'enviado'),
(9, 499.99, 'entregado'),
(10, 249.99, 'procesando');
(1, 2099.98, 'procesando'),
(3, 1599.98, 'enviado'),
(5, 949.98, 'entregado'),
(2, 2599.97, 'procesando'),
(4, 1349.98, 'enviado'),
(6, 1699.98, 'entregado'),
(8, 1299.98, 'procesando'),
(7, 1049.98, 'enviado'),
(9, 1799.98, 'entregado'),
(10, 699.98, 'procesando');

-- Poblar tabla detalles_pedido
INSERT INTO detalles_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 199.99),
(2, 2, 1, 1299.99),
(3, 3, 1, 799.99),
(3, 6, 1, 49.99),
(4, 4, 1, 1799.99),
(5, 5, 1, 129.99),
(5, 6, 1, 49.99),
(6, 7, 1, 899.99),
(7, 1, 1, 199.99),
(7, 10, 1, 249.99),
(8, 8, 1, 799.99),
(9, 9, 1, 499.99),
(10, 10, 1, 249.99);
(11, 2, 1, 1299.99),
(11, 1, 4, 199.99),
(12, 3, 2, 799.99),
(13, 5, 2, 129.99),
(13, 10, 1, 249.99),
(13, 5, 3, 129.99),
(14, 4, 1, 1799.99),
(14, 6, 2, 49.99),
(14, 10, 3, 249.99),
(15, 7, 1, 899.99),
(15, 1, 2, 199.99),
(16, 8, 2, 799.99),
(16, 6, 2, 49.99),
(17, 2, 1, 1299.99),
(17, 9, 1, 499.99),
(18, 1, 3, 199.99),
(18, 5, 1, 129.99),
(18, 10, 1, 249.99),
(19, 4, 1, 1799.99),
(19, 9, 1, 499.99),
(20, 3, 1, 799.99),
(20, 6, 2, 49.99),
(20, 3, 1, 799.99);

-- Poblar tabla carrito
INSERT INTO carrito (id_usuario, id_producto, cantidad) VALUES
(1, 2, 1),
(2, 3, 1),
(3, 4, 1),
(4, 5, 2),
(5, 6, 3),
(6, 7, 1),
(7, 8, 1),
(8, 9, 1),
(9, 10, 2),
(10, 1, 1);

-- Poblar tabla resenas
INSERT INTO resenas (id_usuario, id_producto, calificacion, comentario) VALUES
(1, 1, 5, 'Excelente calidad de sonido y cómodos de usar.'),
(2, 2, 4, 'Muy buen rendimiento para gaming, pero un poco ruidoso.'),
(3, 3, 5, 'La cámara es increíble, muy satisfecho con la compra.'),
(4, 4, 4, 'Pantalla espectacular, pero el precio es algo elevado.'),
(5, 5, 5, 'El mejor teclado que he usado, perfecto para largas sesiones de juego.'),
(6, 6, 3, 'Funciona bien, pero esperaba que cargara más rápido.'),
(7, 7, 5, 'Fotos profesionales con esta cámara, altamente recomendada.'),
(8, 8, 4, 'Fácil de volar y buena calidad de video, pero la batería dura poco.'),
(9, 9, 5, 'Gráficos impresionantes y carga rápida, vale cada peso.'),
(10, 10, 4, 'Buen smartwatch, pero la duración de la batería podría ser mejor.');

-- Poblar tabla lista_deseos
INSERT INTO lista_deseos (id_usuario, id_producto) VALUES
(1, 3),
(2, 4),
(3, 5),
(4, 6),
(5, 7),
(6, 8),
(7, 9),
(8, 10),
(9, 1),
(10, 2);