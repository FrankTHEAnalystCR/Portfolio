--Crear base de datos destino
CREATE DATABASE destino_VET_EXAM

--Crear la Dimension fecha tipo 0
CREATE TABLE DIM_FECHA (
  date_key int NOT NULL primary key,
  date_value date NOT NULL,
  date_short char(12) NOT NULL,
  date_medium char(16) NOT NULL,
  date_long char(24) NOT NULL,
  date_full char(75) NOT NULL,
  day_in_year smallint NOT NULL,
  day_in_month tinyint NOT NULL,
  is_first_day_in_month char(10) NOT NULL,
  is_last_day_in_month char(10) NOT NULL,
  day_abbreviation char(3) NOT NULL,
  day_name char(12) NOT NULL,
  week_in_year tinyint NOT NULL,
  week_in_month tinyint NOT NULL,
  is_first_day_in_week char(10) NOT NULL,
  is_last_day_in_week char(10) NOT NULL,
  month_number tinyint NOT NULL,
  month_abbreviation char(3) NOT NULL,
  month_name char(12) NOT NULL,
  year2 char(4) NOT NULL,
  year4 smallint NOT NULL,
  quarter_name char(2) NOT NULL,
  quarter_number tinyint NOT NULL,
  year_quarter char(7) NOT NULL,
  year_month_number char(7) NOT NULL,
  year_month_abbreviation char(8) NOT NULL
) ;

--Crear la dimension tipo 2 de mascota
DROP TABLE DIM_MASCOTA

CREATE TABLE DIM_MASCOTAS (
ID_FILA_MASCOTA int primary key,
ID_MASCOTA int DEFAULT NULL, 
ALIAS_MASCOTA varchar(50), 
RAZA varchar(50), 
COLOR_PELO varchar(50), 
FECHA_NACIMIENTO date DEFAULT NULL,
ULTIMA_MODIFICACION datetime NOT NULL DEFAULT '1970-01-01 00:00:00',
masc_version_number smallint DEFAULT NULL,
masc_valid_from date DEFAULT NULL,
masc_valid_through date DEFAULT NULL,
masc_active char(3) DEFAULT NULL
);

SELECT *
FROM DIM_MASCOTAS;

SELECT
	ID_MASCOTA,
	ALIAS_MASCOTA,
	RAZA,
	COLOR_PELO,
	FECHA_NACIMIENTO,
	ULTIMA_MODIFICACION
FROM
	VETERINARIO.dbo.MASCOTA
WHERE 
	ULTIMA_MODIFICACION > '1970-01-01 00:00:00'

--Actualizar registros e insertar registros nuevos
USE VETERINARIO

UPDATE VETERINARIO.dbo.MASCOTA
SET COLOR_PELO = 'Negro'
WHERE ID_MASCOTA = 100;

INSERT INTO MASCOTA (ID_MASCOTA, ID_CLIENTE, ALIAS_MASCOTA, RAZA, COLOR_PELO,
FECHA_NACIMIENTO, ULTIMA_MODIFICACION)
values
(101, 40, 'Lizzy', 'French poodle', 'Blanco', '2017-01-01', '2024-05-04 00:00:00.000')

USE destino_VET_EXAM

SELECT * FROM DIM_MASCOTAS 
TRUNCATE TABLE DIM_MASCOTAS

--CREACION DIMENSION TIPO 1 de cliente
CREATE TABLE DIM_CLIENTE (
ID_FILA_CLIENTE int PRIMARY KEY IDENTITY,
ID_CLIENTE int DEFAULT NULL, 
NOMBRE varchar (50) DEFAULT NULL, 
APELLIDOS varchar (50) DEFAULT NULL, 
TELEFONO varchar (50) DEFAULT NULL, 
CUENTA_BANCO varchar (50) DEFAULT NULL,
ULTIMA_MODIFICACION datetime NOT NULL
);

USE VETERINARIO

SELECT 
ID_CLIENTE,
NOMBRE,
APELLIDOS,
TELEFONO,
CUENTA_BANCO,
ULTIMA_MODIFICACION
FROM VETERINARIO.dbo.CLIENTE
WHERE ULTIMA_MODIFICACION > ?

USE destino_VET_EXAM

SELECT *
FROM DIM_CLIENTE

--Actualizar registros e insertar registros nuevos

UPDATE CLIENTE
SET APELLIDOS = 'Mendez Carpio'
WHERE ID_CLIENTE = 10;

INSERT INTO CLIENTE (ID_CLIENTE, NOMBRE, APELLIDOS, TELEFONO, CUENTA_BANCO, ULTIMA_MODIFICACION)
	values
(50, 'Frank', 'Van Gio', '9999-9999', '3647-6785-9999-4444', '2024-05-07 00:00:00.000');

--CARGA ETL
USE destino_VET_EXAM

SELECT * FROM DIM_CLIENTE;

--Creacion de la tabla fact de citas
DROP TABLE FACT_CITA
CREATE TABLE FACT_CITA (
ID_CITA int NOT NULL,
ID_CLIENTE int NOT NULL,
ID_MASCOTA int NOT NULL,
date_key int NULL,
ID_FILA_MASCOTA int NULL,
ID_FILA_CLIENTE int NULL,
PESO_MASCOTA decimal(5,2) NULL,
REQUERIO_VACUNA bit NULL,
FECHA_CITA date NULL,
ULTIMA_MODIFICACION datetime NOT NULL DEFAULT '1970-01-01 00:00:00'
PRIMARY KEY(ID_CITA)
);

USE VETERINARIO
SELECT
	ID_CITA, PESO_MASCOTA,
	REQUERIO_VACUNA, FECHA_CITA,
	ULTIMA_MODIFICACION
FROM 
	VETERINARIO.dbo.CITAS
WHERE
	ULTIMA_MODIFICACION > '1970-01-01 00:00:00';

--Se cargan datos desde el ETL
SELECT *
FROM FACT_CITA;
