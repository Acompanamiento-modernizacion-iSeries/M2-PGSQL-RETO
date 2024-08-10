CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Direccion VARCHAR(255),
    Telefono VARCHAR(15),
    CorreoElectronico VARCHAR(100) UNIQUE,
    FechaRegistro DATE
);

CREATE TABLE Productos (
    ProductoID INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Descripcion TEXT,
    Precio DECIMAL(10, 2),
    Stock INT,
    Categoria VARCHAR(50)
);

CREATE TABLE Pedidos (
    PedidoID INT PRIMARY KEY ,
    ClienteID INT,
    FechaHora DATE,
    Estado VARCHAR(2),
	TransaccionID INT,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

CREATE TABLE Transacciones (
    TransaccionID INT PRIMARY KEY ,
    PedidoID INT,
    Monto DECIMAL(10, 2),
    Fecha DATE,
    MetodoPago VARCHAR(30),
    Estado VARCHAR(2),
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID)
);

CREATE TABLE DetallePedidos (
    DetalleID INT PRIMARY KEY,
    PedidoID INT,
    ProductoID INT,
    Cantidad INT,
    Precio DECIMAL(10, 2),
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);

CREATE TABLE Reseñas (
    ReseñaID INT PRIMARY KEY,
    ProductoID INT,
    ClienteID INT,
    Calificación INT CHECK (Calificación BETWEEN 1 AND 5),
    Comentario TEXT,
    Fecha DATE,
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID),
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

CREATE TABLE ListaDeseos (
    ListaID INT PRIMARY KEY,
    ClienteID INT,
    ProductoID INT,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID),
    FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
);

SELECT c.ClienteID, c.Nombre, c.Apellido, COUNT(p.PedidoID) AS TotalPedidos
FROM Clientes c
JOIN Pedidos p ON c.ClienteID = p.ClienteID
GROUP BY c.ClienteID
HAVING COUNT(p.PedidoID) > 5;

SELECT PedidoID, FechaHora, Estado
FROM Pedidos
WHERE FechaHora BETWEEN '01-01-2022' AND '01-01-2024';

SELECT p.Nombre, AVG(r.Calificación) AS PromedioCalificacion
FROM Reseñas r
JOIN Productos p ON r.ProductoID = p.ProductoID
GROUP BY p.ProductoID
ORDER BY PromedioCalificacion DESC
LIMIT 1;

SELECT p.PedidoID, p.FechaHora, p.Estado, d.ProductoID, pr.Nombre, d.Cantidad, d.Precio
FROM Pedidos p
JOIN DetallePedidos d ON p.PedidoID = d.PedidoID
JOIN Productos pr ON d.ProductoID = pr.ProductoID
WHERE p.ClienteID = 1;

SELECT Nombre, Stock
FROM Productos
WHERE Stock < 10;

CREATE OR REPLACE PROCEDURE RegistrarTransaccion(
    IN PedidoID INT,
    IN Monto DECIMAL(10, 2),
    IN MetodoPago TEXT,
    IN Estado TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Transacciones (PedidoID, Monto, Fecha, MetodoPago, Estado)
    VALUES (PedidoID, Monto, NOW(), MetodoPago, Estado);

    -- Opcional: Actualizar la tabla Pedidos para asociar la transacción
    UPDATE Pedidos
    SET TransaccionID = currval(pg_get_serial_sequence('Transacciones', 'TransaccionID'))
    WHERE PedidoID = PedidoID;
END;
$$;

CREATE OR REPLACE PROCEDURE ActualizarEstadoTransaccion(
    IN TransaccionID INT,
    IN NuevoEstado TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Transacciones
    SET Estado = NuevoEstado
    WHERE TransaccionID = TransaccionID;
END;
$$;

CREATE OR REPLACE PROCEDURE AgregarListaDeseos(
    IN ClienteID INT,
    IN ProductoID INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO ListaDeseos (ClienteID, ProductoID)
    VALUES (ClienteID, ProductoID);
END;
$$;


CREATE OR REPLACE PROCEDURE InformeVentasMensuales(
    IN Mes INT,
    IN Año INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT p.Nombre, SUM(d.Cantidad) AS TotalVendidos, SUM(d.Cantidad * d.Precio) AS Ingresos
    FROM DetallePedidos d
    JOIN Productos p ON d.ProductoID = p.ProductoID
    JOIN Pedidos pd ON d.PedidoID = pd.PedidoID
    WHERE EXTRACT(MONTH FROM pd.FechaHora) = Mes AND EXTRACT(YEAR FROM pd.FechaHora) = Año
    GROUP BY p.ProductoID;
END;
$$;

CREATE OR REPLACE PROCEDURE CambiarEstadoPedido(
    IN PedidoID INT,
    IN NuevoEstado TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Pedidos
    SET Estado = NuevoEstado
    WHERE PedidoID = PedidoID;
END;
$$;

CREATE OR REPLACE FUNCTION VerificarDisponibilidad(ProductoID INT, Cantidad INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    StockActual INT;
BEGIN
    SELECT Stock INTO StockActual
    FROM Productos
    WHERE ProductoID = ProductoID;

    RETURN StockActual >= Cantidad;
END;
$$;


CREATE OR REPLACE FUNCTION PrecioMedio(ProductoID INT)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    Precio DECIMAL(10, 2);
BEGIN
    SELECT AVG(Precio) INTO Precio
    FROM DetallePedidos
    WHERE ProductoID = ProductoID;

    RETURN Precio;
END;
$$;


CREATE OR REPLACE FUNCTION TieneListaDeseos(ClienteID INT)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    Existe BOOLEAN;
BEGIN
    SELECT EXISTS (SELECT 1 FROM ListaDeseos WHERE ClienteID = ClienteID) INTO Existe;

    RETURN Existe;
END;
$$;


CREATE OR REPLACE FUNCTION ContarReseñas(ProductoID INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    TotalReseñas INT;
BEGIN
    SELECT COUNT(*) INTO TotalReseñas
    FROM Reseñas
    WHERE ProductoID = ProductoID;

    RETURN TotalReseñas;
END;
$$;


CREATE OR REPLACE FUNCTION CalcularTotalPedido(PedidoID INT)
RETURNS DECIMAL(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    Total DECIMAL(10, 2);
BEGIN
    SELECT SUM(Cantidad * Precio) INTO Total
    FROM DetallePedidos
    WHERE PedidoID = PedidoID;

    RETURN Total;
END;
$$;


