--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

-- Started on 2024-08-11 23:26:30

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 228 (class 1255 OID 17461)
-- Name: actualizar_estado_pedido(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.actualizar_estado_pedido(IN var_pedido_id integer, IN var_nuevo_estado character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Pedidos
    SET estado = var_nuevo_estado
    WHERE pedido_id = var_pedido_id;
END;
$$;


ALTER PROCEDURE public.actualizar_estado_pedido(IN var_pedido_id integer, IN var_nuevo_estado character varying) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 17466)
-- Name: actualizar_stock(integer, integer, integer, numeric); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.actualizar_stock(IN var_cliente_id integer, IN var_producto_id integer, IN var_cantidad integer, IN var_precio numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    vr_pedido_id INT;
    vr_stock INT;
BEGIN

    INSERT INTO Pedidos (cliente_id, fecha_pedido, estado)
    VALUES (var_cliente_id, CURRENT_TIMESTAMP, 'Procesando')
    RETURNING pedido_id INTO vr_pedido_id;

    INSERT INTO Detalle_Pedidos (pedido_id, producto_id, cantidad, precio)
    VALUES (vr_pedido_id, var_producto_id, var_cantidad, var_precio);

    UPDATE Productos
    SET stock = stock - var_cantidad
    WHERE producto_id = var_producto_id
    RETURNING stock INTO vr_stock;
    IF vr_stock = 1 THEN
        RAISE NOTICE 'El stock del producto está en 1';
    END IF;
    RAISE NOTICE 'Se realizó el pedido';
END;
$$;


ALTER PROCEDURE public.actualizar_stock(IN var_cliente_id integer, IN var_producto_id integer, IN var_cantidad integer, IN var_precio numeric) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 17470)
-- Name: agregar_cliente(character varying, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.agregar_cliente(IN var_nombre character varying, IN var_apellido character varying, IN var_direccion character varying, IN var_telefono character varying, IN var_correo_electronico character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Clientes (nombre, apellido, direccion, telefono, correo_electronico)
    VALUES (var_nombre, var_apellido, var_direccion, var_telefono, var_correo_electronico);
END;
$$;


ALTER PROCEDURE public.agregar_cliente(IN var_nombre character varying, IN var_apellido character varying, IN var_direccion character varying, IN var_telefono character varying, IN var_correo_electronico character varying) OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 17474)
-- Name: contar_reseñas_producto(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."contar_reseñas_producto"(var_producto_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM Reseñas
        WHERE producto_id = var_producto_id
    );
END;
$$;


ALTER FUNCTION public."contar_reseñas_producto"(var_producto_id integer) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 17471)
-- Name: eliminar_producto_lista_deseos(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.eliminar_producto_lista_deseos(IN var_cliente_id integer, IN var_producto_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Lista_Deseos
    WHERE cliente_id = var_cliente_id AND producto_id = var_producto_id;
END;
$$;


ALTER PROCEDURE public.eliminar_producto_lista_deseos(IN var_cliente_id integer, IN var_producto_id integer) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 17464)
-- Name: obtener_resumen_pedidos(timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.obtener_resumen_pedidos(var_fecha_inicio timestamp without time zone, var_fecha_fin timestamp without time zone) RETURNS TABLE(pedido_id integer, fecha_pedido timestamp without time zone, nombre_cliente character varying, apellido_cliente character varying, total_pedido numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT p.pedido_id, p.fecha_pedido, c.nombre, c.apellido, SUM(dp.cantidad * dp.precio) AS total_pedido
    FROM Pedidos p
    INNER JOIN Clientes c ON p.cliente_id = c.cliente_id
    INNER JOIN Detalle_Pedidos dp ON p.pedido_id = dp.pedido_id
    WHERE p.fecha_pedido BETWEEN var_fecha_inicio AND var_fecha_fin
    GROUP BY p.pedido_id, p.fecha_pedido, c.nombre, c.apellido
    ORDER BY p.fecha_pedido ASC;
END;
$$;


ALTER FUNCTION public.obtener_resumen_pedidos(var_fecha_inicio timestamp without time zone, var_fecha_fin timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 17475)
-- Name: stock_producto(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stock_producto(var_producto_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (
        SELECT stock
        FROM Productos
        WHERE producto_id = var_producto_id
    );
END;
$$;


ALTER FUNCTION public.stock_producto(var_producto_id integer) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 17467)
-- Name: sumar_stock(integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.sumar_stock(IN var_producto_id integer, IN var_cantidad integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Productos
    SET stock = stock + var_cantidad
    WHERE producto_id = var_producto_id;
END;
$$;


ALTER PROCEDURE public.sumar_stock(IN var_producto_id integer, IN var_cantidad integer) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 17472)
-- Name: total_pedidos_cliente(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.total_pedidos_cliente(var_cliente_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (
        SELECT SUM(dp.cantidad * dp.precio)
        FROM Detalle_Pedidos dp
        JOIN Pedidos p ON dp.pedido_id = p.pedido_id
        WHERE p.cliente_id = var_cliente_id
    );
END;
$$;


ALTER FUNCTION public.total_pedidos_cliente(var_cliente_id integer) OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 17473)
-- Name: ultima_fecha_pedido(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ultima_fecha_pedido(var_cliente_id integer) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (
        SELECT MAX(fecha_pedido)
        FROM Pedidos
        WHERE cliente_id = var_cliente_id
    );
END;
$$;


ALTER FUNCTION public.ultima_fecha_pedido(var_cliente_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 17357)
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    cliente_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    direccion character varying(200),
    telefono character varying(20),
    correo_electronico character varying(200) NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 17356)
-- Name: clientes_cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clientes_cliente_id_seq OWNER TO postgres;

--
-- TOC entry 3411 (class 0 OID 0)
-- Dependencies: 214
-- Name: clientes_cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_cliente_id_seq OWNED BY public.clientes.cliente_id;


--
-- TOC entry 221 (class 1259 OID 17392)
-- Name: detalle_pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_pedidos (
    detalle_id integer NOT NULL,
    pedido_id integer,
    producto_id integer,
    cantidad integer NOT NULL,
    precio numeric(10,2) NOT NULL
);


ALTER TABLE public.detalle_pedidos OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17391)
-- Name: detalle_pedidos_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_pedidos_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.detalle_pedidos_detalle_id_seq OWNER TO postgres;

--
-- TOC entry 3412 (class 0 OID 0)
-- Dependencies: 220
-- Name: detalle_pedidos_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_pedidos_detalle_id_seq OWNED BY public.detalle_pedidos.detalle_id;


--
-- TOC entry 227 (class 1259 OID 17444)
-- Name: lista_deseos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lista_deseos (
    lista_deseos_id integer NOT NULL,
    cliente_id integer,
    producto_id integer,
    fecha_agregado timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.lista_deseos OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17443)
-- Name: lista_deseos_lista_deseos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lista_deseos_lista_deseos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lista_deseos_lista_deseos_id_seq OWNER TO postgres;

--
-- TOC entry 3413 (class 0 OID 0)
-- Dependencies: 226
-- Name: lista_deseos_lista_deseos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lista_deseos_lista_deseos_id_seq OWNED BY public.lista_deseos.lista_deseos_id;


--
-- TOC entry 219 (class 1259 OID 17378)
-- Name: pedidos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedidos (
    pedido_id integer NOT NULL,
    cliente_id integer,
    fecha_pedido timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(20),
    CONSTRAINT pedidos_estado_check CHECK (((estado)::text = ANY ((ARRAY['Procesando'::character varying, 'Enviado'::character varying, 'Entregado'::character varying])::text[])))
);


ALTER TABLE public.pedidos OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17377)
-- Name: pedidos_pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedidos_pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pedidos_pedido_id_seq OWNER TO postgres;

--
-- TOC entry 3414 (class 0 OID 0)
-- Dependencies: 218
-- Name: pedidos_pedido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedidos_pedido_id_seq OWNED BY public.pedidos.pedido_id;


--
-- TOC entry 217 (class 1259 OID 17369)
-- Name: productos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productos (
    producto_id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    precio numeric(10,2) NOT NULL,
    stock integer NOT NULL,
    categoria character varying(50)
);


ALTER TABLE public.productos OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17368)
-- Name: productos_producto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.productos_producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.productos_producto_id_seq OWNER TO postgres;

--
-- TOC entry 3415 (class 0 OID 0)
-- Dependencies: 216
-- Name: productos_producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.productos_producto_id_seq OWNED BY public.productos.producto_id;


--
-- TOC entry 225 (class 1259 OID 17423)
-- Name: reseñas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."reseñas" (
    "reseña_id" integer NOT NULL,
    cliente_id integer,
    producto_id integer,
    calificacion integer,
    comentario text,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "reseñas_calificacion_check" CHECK (((calificacion >= 1) AND (calificacion <= 5)))
);


ALTER TABLE public."reseñas" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17422)
-- Name: reseñas_reseña_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."reseñas_reseña_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."reseñas_reseña_id_seq" OWNER TO postgres;

--
-- TOC entry 3416 (class 0 OID 0)
-- Dependencies: 224
-- Name: reseñas_reseña_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."reseñas_reseña_id_seq" OWNED BY public."reseñas"."reseña_id";


--
-- TOC entry 223 (class 1259 OID 17409)
-- Name: transacciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transacciones (
    transaccion_id integer NOT NULL,
    pedido_id integer,
    fecha_transaccion timestamp without time zone,
    monto numeric(10,2),
    tipo_transaccion character varying(50),
    descripcion text
);


ALTER TABLE public.transacciones OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17408)
-- Name: transacciones_transaccion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transacciones_transaccion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transacciones_transaccion_id_seq OWNER TO postgres;

--
-- TOC entry 3417 (class 0 OID 0)
-- Dependencies: 222
-- Name: transacciones_transaccion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transacciones_transaccion_id_seq OWNED BY public.transacciones.transaccion_id;


--
-- TOC entry 3213 (class 2604 OID 17360)
-- Name: clientes cliente_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN cliente_id SET DEFAULT nextval('public.clientes_cliente_id_seq'::regclass);


--
-- TOC entry 3218 (class 2604 OID 17395)
-- Name: detalle_pedidos detalle_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos ALTER COLUMN detalle_id SET DEFAULT nextval('public.detalle_pedidos_detalle_id_seq'::regclass);


--
-- TOC entry 3222 (class 2604 OID 17447)
-- Name: lista_deseos lista_deseos_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_deseos ALTER COLUMN lista_deseos_id SET DEFAULT nextval('public.lista_deseos_lista_deseos_id_seq'::regclass);


--
-- TOC entry 3216 (class 2604 OID 17381)
-- Name: pedidos pedido_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos ALTER COLUMN pedido_id SET DEFAULT nextval('public.pedidos_pedido_id_seq'::regclass);


--
-- TOC entry 3215 (class 2604 OID 17372)
-- Name: productos producto_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos ALTER COLUMN producto_id SET DEFAULT nextval('public.productos_producto_id_seq'::regclass);


--
-- TOC entry 3220 (class 2604 OID 17426)
-- Name: reseñas reseña_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reseñas" ALTER COLUMN "reseña_id" SET DEFAULT nextval('public."reseñas_reseña_id_seq"'::regclass);


--
-- TOC entry 3219 (class 2604 OID 17412)
-- Name: transacciones transaccion_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacciones ALTER COLUMN transaccion_id SET DEFAULT nextval('public.transacciones_transaccion_id_seq'::regclass);


--
-- TOC entry 3393 (class 0 OID 17357)
-- Dependencies: 215
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (cliente_id, nombre, apellido, direccion, telefono, correo_electronico, fecha_registro) FROM stdin;
1	Carlos	García	Calle 45 #12-34, Bogotá	3101234567	carlos.garcia@gmail.com	2024-01-15 00:00:00
2	Ana	Pérez	Carrera 14 #23-56, Medellín	3007654321	ana.perez@hotmail.com	2023-02-20 00:00:00
3	María	Rodríguez	Avenida Siempre Viva #123, Cali	3156789123	maria.rodriguez@hotmail.com	2024-08-10 00:00:00
4	Juan	Martínez	Calle 9 #45-78, Barranquilla	3209876543	juan.martinez@gmail.com	2024-04-05 00:00:00
5	Luis	Gómez	Carrera 67 #89-12, Cartagena	3012345678	luis.gomez@gmail.com	2023-05-18 00:00:00
6	Juan	Pérez	Calle Falsa 123	123-456-7890	juan.perez@email.com	2024-08-11 23:15:19.66547
\.


--
-- TOC entry 3399 (class 0 OID 17392)
-- Dependencies: 221
-- Data for Name: detalle_pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_pedidos (detalle_id, pedido_id, producto_id, cantidad, precio) FROM stdin;
1	1	1	2	30000.00
2	1	3	1	120000.00
3	2	5	1	180000.00
4	3	4	2	450000.00
5	3	7	1	90000.00
6	4	2	3	25000.00
7	4	6	1	220000.00
8	5	9	1	1300000.00
9	1	1	2	30000.00
12	9	1	1	190000.00
\.


--
-- TOC entry 3405 (class 0 OID 17444)
-- Dependencies: 227
-- Data for Name: lista_deseos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lista_deseos (lista_deseos_id, cliente_id, producto_id, fecha_agregado) FROM stdin;
1	1	3	2024-08-01 08:00:00
2	2	7	2024-08-02 09:30:00
3	3	5	2024-08-03 10:45:00
4	1	4	2024-08-04 11:15:00
5	2	6	2024-08-05 12:20:00
\.


--
-- TOC entry 3397 (class 0 OID 17378)
-- Dependencies: 219
-- Data for Name: pedidos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedidos (pedido_id, cliente_id, fecha_pedido, estado) FROM stdin;
1	1	2024-08-01 10:00:00	Procesando
2	2	2024-08-02 14:30:00	Enviado
3	3	2024-08-03 16:45:00	Entregado
4	1	2024-08-04 12:15:00	Procesando
5	2	2024-08-05 09:20:00	Entregado
6	1	2023-08-01 10:00:00	Enviado
9	1	2024-08-11 22:56:57.370717	Procesando
\.


--
-- TOC entry 3395 (class 0 OID 17369)
-- Dependencies: 217
-- Data for Name: productos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productos (producto_id, nombre, descripcion, precio, stock, categoria) FROM stdin;
2	Cargador Rápido USB	Cargador rápido USB para dispositivos móviles, 18W.	25000.00	150	Cargador
4	Tablet 10 pulgadas	Tablet de 10 pulgadas con 64GB de almacenamiento y cámara HD.	450000.00	40	Tablet
5	Smartwatch	Smartwatch con monitor de ritmo cardíaco y notificaciones inteligentes.	180000.00	100	Reloj
6	Cámara de Seguridad Wi-Fi	Cámara de seguridad Wi-Fi con visión nocturna y detección de movimiento.	220000.00	75	Cámaras
7	Parlantes Bluetooth	Bocina Bluetooth portátil con sonido envolvente 360 grados.	90000.00	80	Sonido
8	Cargador Inalámbrico	Cargador inalámbrico compatible con smartphones y otros dispositivos	70000.00	120	Cargador
9	Smart TV 50 pulgadas	Smart TV 4K de 50 pulgadas	1300000.00	30	Televisor
10	Laptop	Laptop con procesador core i7, 16GB RAM y tarjeta gráfica RTX	3500000.00	20	Computador
1	Reloj Despertador Digital	Reloj despertador digital con alarma y luz nocturna.	30000.00	199	Reloj
3	Auriculares Inalámbricos	Auriculares inalámbricos con cancelación de ruido y micrófono integrado.	120000.00	63	Auriculares
\.


--
-- TOC entry 3403 (class 0 OID 17423)
-- Dependencies: 225
-- Data for Name: reseñas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."reseñas" ("reseña_id", cliente_id, producto_id, calificacion, comentario, fecha) FROM stdin;
1	1	1	4	Buen reloj, cumple su función pero el sonido de la alarma podría ser mejor.	2024-08-11 22:10:38.792909
2	2	5	5	Excelente smartwatch, muy útil para el día a día.	2024-08-11 22:10:38.792909
3	3	4	4	La tablet funciona bien, aunque la batería podría durar más.	2024-08-11 22:10:38.792909
4	1	6	5	Muy buena cámara de seguridad, fácil de instalar.	2024-08-11 22:10:38.792909
5	2	9	5	Increíble calidad de imagen en esta Smart TV.	2024-08-11 22:10:38.792909
\.


--
-- TOC entry 3401 (class 0 OID 17409)
-- Dependencies: 223
-- Data for Name: transacciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transacciones (transaccion_id, pedido_id, fecha_transaccion, monto, tipo_transaccion, descripcion) FROM stdin;
1	1	2024-08-01 11:00:00	180000.00	Pago con tarjeta de crédito	Compra de productos
2	2	2024-08-02 15:00:00	180000.00	Pago con PayPal	Compra de smartwatch
3	3	2024-08-03 17:00:00	990000.00	Pago con tarjeta de débito	Compra de tablet y bocina
4	4	2024-08-04 13:00:00	295000.00	Pago con transferencia bancaria	Compra de cargador y cámara
5	5	2024-08-05 10:00:00	1300000.00	Pago con tarjeta de crédito	Compra de Smart TV
6	6	2023-08-01 11:00:00	180000.00	Pago con tarjeta de crédito	Compra de productos
\.


--
-- TOC entry 3418 (class 0 OID 0)
-- Dependencies: 214
-- Name: clientes_cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_cliente_id_seq', 6, true);


--
-- TOC entry 3419 (class 0 OID 0)
-- Dependencies: 220
-- Name: detalle_pedidos_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_pedidos_detalle_id_seq', 12, true);


--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 226
-- Name: lista_deseos_lista_deseos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lista_deseos_lista_deseos_id_seq', 5, true);


--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 218
-- Name: pedidos_pedido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedidos_pedido_id_seq', 9, true);


--
-- TOC entry 3422 (class 0 OID 0)
-- Dependencies: 216
-- Name: productos_producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.productos_producto_id_seq', 10, true);


--
-- TOC entry 3423 (class 0 OID 0)
-- Dependencies: 224
-- Name: reseñas_reseña_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."reseñas_reseña_id_seq"', 5, true);


--
-- TOC entry 3424 (class 0 OID 0)
-- Dependencies: 222
-- Name: transacciones_transaccion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transacciones_transaccion_id_seq', 6, true);


--
-- TOC entry 3227 (class 2606 OID 17367)
-- Name: clientes clientes_correo_electronico_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_correo_electronico_key UNIQUE (correo_electronico);


--
-- TOC entry 3229 (class 2606 OID 17365)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cliente_id);


--
-- TOC entry 3235 (class 2606 OID 17397)
-- Name: detalle_pedidos detalle_pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_pkey PRIMARY KEY (detalle_id);


--
-- TOC entry 3241 (class 2606 OID 17450)
-- Name: lista_deseos lista_deseos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_deseos
    ADD CONSTRAINT lista_deseos_pkey PRIMARY KEY (lista_deseos_id);


--
-- TOC entry 3233 (class 2606 OID 17385)
-- Name: pedidos pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_pkey PRIMARY KEY (pedido_id);


--
-- TOC entry 3231 (class 2606 OID 17376)
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (producto_id);


--
-- TOC entry 3239 (class 2606 OID 17432)
-- Name: reseñas reseñas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reseñas"
    ADD CONSTRAINT "reseñas_pkey" PRIMARY KEY ("reseña_id");


--
-- TOC entry 3237 (class 2606 OID 17416)
-- Name: transacciones transacciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacciones
    ADD CONSTRAINT transacciones_pkey PRIMARY KEY (transaccion_id);


--
-- TOC entry 3243 (class 2606 OID 17398)
-- Name: detalle_pedidos detalle_pedidos_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(pedido_id);


--
-- TOC entry 3244 (class 2606 OID 17403)
-- Name: detalle_pedidos detalle_pedidos_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_pedidos
    ADD CONSTRAINT detalle_pedidos_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(producto_id);


--
-- TOC entry 3248 (class 2606 OID 17451)
-- Name: lista_deseos lista_deseos_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_deseos
    ADD CONSTRAINT lista_deseos_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(cliente_id);


--
-- TOC entry 3249 (class 2606 OID 17456)
-- Name: lista_deseos lista_deseos_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_deseos
    ADD CONSTRAINT lista_deseos_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.productos(producto_id);


--
-- TOC entry 3242 (class 2606 OID 17386)
-- Name: pedidos pedidos_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedidos
    ADD CONSTRAINT pedidos_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(cliente_id);


--
-- TOC entry 3246 (class 2606 OID 17433)
-- Name: reseñas reseñas_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reseñas"
    ADD CONSTRAINT "reseñas_cliente_id_fkey" FOREIGN KEY (cliente_id) REFERENCES public.clientes(cliente_id);


--
-- TOC entry 3247 (class 2606 OID 17438)
-- Name: reseñas reseñas_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."reseñas"
    ADD CONSTRAINT "reseñas_producto_id_fkey" FOREIGN KEY (producto_id) REFERENCES public.productos(producto_id);


--
-- TOC entry 3245 (class 2606 OID 17417)
-- Name: transacciones transacciones_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transacciones
    ADD CONSTRAINT transacciones_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedidos(pedido_id);


-- Completed on 2024-08-11 23:26:30

--
-- PostgreSQL database dump complete
--

