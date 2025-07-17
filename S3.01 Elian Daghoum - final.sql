-- ------------------------------------------------------
-- NIVEL 1
-- ------------------------------------------------------

-- 1) diseñar y crear una tabla llamada "credit_card"

 CREATE TABLE IF NOT EXISTS credit_card (
        id VARCHAR(20) PRIMARY KEY,
        iban VARCHAR(34) NOT NULL,
        pan VARCHAR(16) NOT NULL, 
        pin CHAR(4)NOT NULL,
        cvv CHAR(3)NOT NULL,
        expiring_date VARCHAR(10) NOT NULL
        );
  
-- generando conexiones

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

SELECT * FROM credit_card;

-- ----------------------------------------------------

-- 2) cambiar la tarjeta de crédito con ID CcU-2938 a el IBAN  TR323456312213576817699999


SELECT * FROM credit_card
Where id = "CcU-2938";

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = "CcU-2938";

SELECT * FROM credit_card
Where id = "CcU-2938";


-- ------------------------------------------------------

-- 3) En la tabla "transaction" ingresa un nuevo usuario con la siguiente información:


INSERT INTO credit_card (id)
VALUES ('CcU-9999');

INSERT INTO company (id)
VALUES ('b-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', NULL, '111.11', '0');

SELECT * FROM transaction
Where id = "108B1D1D-5B23-A76C-55EF-C568E49A99DD";

-- ------------------------------------------------------


-- 4) eliminar columna pan de credit_card

alter table credit_card drop column pan;
SELECT * FROM credit_card;


-- ----------------------------------------------------
-- NIVEL 2
-- ------------------------------------------------------


-- 1) eliminar de transaction el registro  ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

SELECT * FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

-- ------------------------------------------------------


-- 2) Crea  VistaMarketing con: 
-- Nombre de la compañía. Teléfono. País. Promedio de compra DESC.

CREATE VIEW VistaMarketing AS
SELECT c.id, c.company_name, c.phone, c.country, 
ROUND(AVG(t.amount),2)  AS 'Media de ventas'
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.id;

--  Presenta la vista creada, ordenando los datos de mayor a menor media de compra. 

SELECT * FROM VistaMarketing
ORDER BY 'Media de ventas' DESC;

-- ------------------------------------------------------


-- 3) Filtra la vista VistaMarketing para mostrar sólo las compañías que tienen su país de residencia en "Germany"

SELECT * FROM VistaMarketing
WHERE country = "Germany";

-- ----------------------------------------------------
-- NIVEL 3
-- ------------------------------------------------------


-- 1) describe el "paso a paso" de las tareas realizadas

-- Comenzamos creando la tabla "user"

CREATE TABLE IF NOT EXISTS user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);

-- introducimos los datos del archivo "dades_introduir_user"

SHOW CREATE TABLE transaction;
SHOW CREATE TABLE user;

-- como id.user es char, y user_id.transaction es Int, hay que igualarlos.  

ALTER TABLE user
MODIFY COLUMN id INT;

-- creamos las conexiones uniendo los user id de ambas tablas

ALTER TABLE transaction
ADD FOREIGN key (user_id) references user(id);

-- reajustamos el nombre de la tabla user y otros cambios para ajustarnos a la imagen

ALTER TABLE user RENAME TO data_user;

ALTER TABLE data_user
RENAME COLUMN email TO personal_email;

ALTER TABLE company
DROP COLUMN website;

ALTER TABLE credit_card
ADD COLUMN fecha_actual DATE DEFAULT (CURDATE());

-- 2) crear una vista llamada "InformeTecnico"

CREATE VIEW InformeTecnico AS
SELECT u.name As Nombre, u.surname AS Apellido, cr.iban, 
t.id AS "id transacción" , t.amount AS Cantidad, 
c.company_name AS 'Beneficiario transacción', 
u.country AS 'Lugar transacción'
FROM transaction t
JOIN credit_card cr ON cr.id = t.credit_card_id
JOIN data_user u ON u.id = t.user_id
JOIN company c ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY t.id;

SELECT * FROM InformeTecnico
ORDER BY "id transacción" DESC;
    
