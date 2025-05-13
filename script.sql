CREATE DATABASE prueba;
CREATE TABLE clientes (
	id SERIAL PRIMARY KEY,
  	nombre VARCHAR(50),
  	apellido VARCHAR(50),
  	direccion VARCHAR(100),
  	correoElectronico VARCHAR(100),
  	telefono VARCHAR(12)
);

CREATE TABLE productos (
id SERIAL PRIMARY KEY,
  nombre VARCHAR(50),
  descripcion VARCHAR(100),
  precio DECIMAL(10, 2),
  categoria VARCHAR(50),
  stock INTEGER
);

CREATE TABLE pedidos (
id SERIAL PRIMARY KEY,
  id_cliente INTEGER REFERENCES clientes(id),
  fecha DATE,
  estado VARCHAR(50),
  total DECIMAL(10, 2)
);

CREATE TABLE ventas (
id SERIAL PRIMARY KEY,
  id_pedido INTEGER REFERENCES pedidos(id),
  id_producto INTEGER REFERENCES productos(id),
  cantidad INTEGER,
  precioVenta DECIMAL(10, 2)
);

INSERT INTO clientes (nombre, apellido, direccion, correoElectronico, telefono)
VALUES ('Angel', 'Cordova', 'Av Maracay','angel@gmail.com', '0412-5254856'), 
('Valentina', 'Perez', 'Residencias Los Jardines', 'valentina.perez@yahoo.com', '0416-9513574'),
('Carlos', 'Gomez', 'Sector El Centro', 'carlos.gomez@hotmail.com', '0412-6543210'),
('Luisa', 'Martinez', 'Urbanizacion La Esperanza', 'luisa.mtz@correo.com', '0424-1239876'),
('Javier', 'Rojas', 'Av Bolivar', 'javier.rojas@mail.com', '0416-3654789'),
('Maria', 'Fernandez', 'Calle Los Pinos', 'mariaf@gmail.com', '0412-7896543')
;

INSERT INTO productos (nombre, descripcion, precio, categoria, stock) VALUES
('Laptop Gamer', 'Portatil con procesador i7 y RTX 3060', 200.50, 'Electronica', 10),
('Smartphone X', 'Telefono móvil con pantalla AMOLED', 150.00, 'Electronica', 25),
('Camisa manga larga', 'Camisa manga larga de caballero', 100.00, 'Camisetas', 15),
('Silla Ergonómica', 'Silla de oficina con soporte lumbar', 300.55, 'Muebles', 8),
('Bicicleta MTB', 'Bicicleta de montaña con marco de aluminio', 500.00, 'Deportes', 12);

INSERT INTO pedidos (id_cliente, fecha, estado, total) VALUES
(1, '2025-04-10', 'Procesando', 350.50),
(1, '2025-03-11', 'Enviado', 100.00),
(2, '2025-02-09', 'Entregado', 100.00),
(3, '2025-01-12', 'Pendiente', 150.00),
(4, '2025-01-10', 'Cancelado', 500.00),
(5, '2025-01-11', 'Procesando', 300.55),
(5, '2025-05-08', 'Enviado', 200.50),
(6, '2025-05-07', 'Entregado', 100.00),
(6, '2025-05-12', 'Pendiente', 200.50),
(6, '2025-05-10', 'Procesando', 500.00);

INSERT INTO ventas (id_pedido, id_producto, cantidad, precioVenta) VALUES
(1, 1, 1, 250.50),
(1, 2, 1, 150.00),
(2, 3, 1, 100.00),
(3, 3, 1, 150.00),
(5, 4, 1, 300.55),
(4, 5, 1, 500.00),
(5, 1, 1, 200.50),
(6, 1, 1, 100.00),
(6, 1, 1, 200.50),
(6, 5, 1, 500.00);


-- CONSULTAS SELECT--
--CONSULTA 1--
/*SELECT 
c.nombre, c.apellido, c.direccion, c.correoElectronico FROM
clientes c LEFT JOIN pedidos p ON c.id = p.id_cliente WHERE  p.fecha >= CURRENT_DATE - INTERVAL '30 days';*/

--CONSULTA 2--
SELECT 
    p.nombre, 
    SUM(v.cantidad) AS total_vendido
FROM ventas v
JOIN productos p ON v.id_producto = p.id
JOIN pedidos ped ON v.id_pedido = ped.id
WHERE ped.fecha >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY p.nombre
ORDER BY total_vendido DESC;

--CONSULTA 3--
SELECT 
    c.nombre, 
    c.apellido, 
    COUNT(p.id) AS cantidad_pedidos
FROM clientes c
JOIN pedidos p ON c.id = p.id_cliente
WHERE p.fecha >= CURRENT_DATE - INTERVAL '1 year'
GROUP BY c.id, c.nombre, c.apellido
ORDER BY cantidad_pedidos DESC;


--ACTUALIZACIONES--
UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Camisetas';


--DELETE--
DELETE FROM pedidos
WHERE NOT EXISTS (
    SELECT 1 FROM ventas v 
    WHERE v.id_pedido = pedidos.id
);

--VISTA--
CREATE VIEW vista_clientes_pedidos AS
SELECT 
    c.nombre || ' ' || c.apellido AS nombre_completo,
    p.fecha,
    p.total
FROM clientes c
JOIN pedidos p ON c.id = p.id_cliente;
