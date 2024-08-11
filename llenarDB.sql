-- llenar la tabla 'clientes'
INSERT INTO clientes (nombre, apellido, direccion, telefono, email)
VALUES 
('Juan', 'Pérez', 'Calle Falsa 123', '555-1234', 'juan.perez@example.com'),
('María', 'González', 'Avenida Siempre Viva 742', '555-5678', 'maria.gonzalez@example.com'),
('Carlos', 'Ramírez', 'Boulevard de los Sueños Rotos 456', '555-8765', 'carlos.ramirez@example.com'),
('Ana', 'Martínez', 'Plaza de la Constitución 789', '555-4321', 'ana.martinez@example.com'),
('Luis', 'Fernández', 'Camino Real 101', '555-6789', 'luis.fernandez@example.com');


-- llenar la tabla 'productos'
INSERT INTO productos (id_producto, nombre, descripcion, precio, stock, categoria)
VALUES 
(1, 'Smartphone XYZ', 'Smartphone con pantalla de 6.5 pulgadas y 128GB de almacenamiento', 299.99, 50, 'Electrónica'),
(2, 'Laptop ABC', 'Laptop con procesador Intel i7 y 16GB de RAM', 899.99, 30, 'Computadoras'),
(3, 'Tablet 123', 'Tablet con pantalla de 10 pulgadas y 64GB de almacenamiento', 199.99, 40, 'Electrónica'),
(4, 'Smartwatch DEF', 'Reloj inteligente con monitor de ritmo cardíaco y GPS', 149.99, 60, 'Accesorios'),
(5, 'Auriculares Bluetooth', 'Auriculares inalámbricos con cancelación de ruido', 79.99, 100, 'Accesorios'),
(6, 'Cámara Digital', 'Cámara digital con resolución de 20MP y zoom óptico 10x', 499.99, 20, 'Fotografía'),
(7, 'Monitor 4K', 'Monitor con resolución 4K y tamaño de 27 pulgadas', 349.99, 25, 'Computadoras'),
(8, 'Teclado Mecánico', 'Teclado mecánico con retroiluminación RGB', 89.99, 70, 'Accesorios'),
(9, 'Disco Duro Externo', 'Disco duro externo de 1TB con conexión USB 3.0', 59.99, 80, 'Almacenamiento'),
(10, 'Router WiFi', 'Router WiFi de doble banda con velocidad de hasta 1200Mbps', 129.99, 45, 'Redes');

-- llenar la tabla 'pedidos'
INSERT INTO pedidos (id_pedido, id_usuario, fecha_registro, estado)
VALUES 
(1, '2023-01-01', 'en camino'),
(1, '2023-01-15', 'entregado'),
(2, '2023-02-01', 'en camino'),
(2, '2023-02-15', 'entregado'),
(3, '2023-03-01', 'en camino'),
(3, '2023-03-15', 'entregado'),
(4, '2023-04-01', 'en camino'),
(4, '2023-04-15', 'entregado'),
(5, '2023-05-01', 'en camino'),
(5, '2023-05-15', 'entregado');

INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 1, 1),
(2, 3, 4),
(3, 2, 2),
(3, 3, 1);

-- llenar la tabla  'lista_deseos'
INSERT INTO lista_deseos (id_usuario, id_producto)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);