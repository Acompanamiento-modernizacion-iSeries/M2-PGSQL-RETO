CREATE TABLE clientes (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10, 2),
    stock INT,
    categoria VARCHAR(50)
);

CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY ,
    id_usuario INT,
    fecha DATE,
    estado VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE detalle_pedidos (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

CREATE TABLE lista_deseos (
    id_lista_deseos SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES clientes(id_usuario),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);