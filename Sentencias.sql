--5 consultas que aporten valor al negocio
--1. Productos más vendidos
SELECT p.nombre, p.categoria, SUM(dp.cantidad) as total_vendido
FROM productos p
JOIN detalles_pedido dp ON p.id_producto = dp.id_producto
JOIN pedidos ped ON dp.id_pedido = ped.id_pedido
WHERE ped.estado = 'entregado'
GROUP BY p.id_producto, p.nombre, p.categoria
ORDER BY total_vendido DESC
LIMIT 5;

--2 Clientes que han comprado mas
SELECT u.id_usuario, u.nombre, u.apellido, SUM(p.precio_total) as total_gastado
FROM usuarios u
JOIN pedidos p ON u.id_usuario = p.id_usuario
WHERE p.estado = 'entregado'
GROUP BY u.id_usuario, u.nombre, u.apellido
ORDER BY total_gastado DESC
LIMIT 5;

--3 Productos con bajo stock
SELECT nombre, categoria, stock
FROM productos
WHERE stock < 10
ORDER BY stock ASC;

--4 Productos con mas satisfacción
SELECT p.nombre, p.categoria, 
       AVG(r.calificacion) as calificacion_promedio, 
       COUNT(r.id_resena) as total_resenas
FROM productos p
LEFT JOIN resenas r ON p.id_producto = r.id_producto
GROUP BY p.id_producto, p.nombre, p.categoria
ORDER BY calificacion_promedio DESC, total_resenas DESC;

--5 Mayores ventas por categoría y mes
SELECT 
    p.categoria,
    DATE_TRUNC('month', ped.fecha_pedido) as mes,
    SUM(dp.cantidad * dp.precio_unitario) as total_ventas
FROM productos p
JOIN detalles_pedido dp ON p.id_producto = dp.id_producto
JOIN pedidos ped ON dp.id_pedido = ped.id_pedido
WHERE ped.estado = 'entregado'
GROUP BY p.categoria, DATE_TRUNC('month', ped.fecha_pedido)
ORDER BY p.categoria, mes;