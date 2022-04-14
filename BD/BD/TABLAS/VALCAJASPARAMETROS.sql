-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALCAJASPARAMETROS
DELIMITER ;
DROP TABLE IF EXISTS `VALCAJASPARAMETROS`;
DELIMITER $$
CREATE TABLE `VALCAJASPARAMETROS` (
	`ValCajaParamID`	INT(11)		NOT NULL COMMENT 'Llave primaria',
	`HoraInicio`		VARCHAR(5)	NOT NULL COMMENT 'Horario en el que iniciará el proceso automático',
	`NumEjecuciones`	TINYINT(2)	NOT NULL COMMENT 'Número de veces que se ejecutará el proceso',
	`Intervalo`			TINYINT(2)	NOT NULL COMMENT 'Intervalo de tiempo entre cada ejecución',
	`RemitenteID`		INT(11)		NOT NULL COMMENT 'ID del usuario remitente',

	`EmpresaID`			INT(11)		NOT NULL COMMENT 'Parámetro de auditoría',
	`Usuario`			INT(11)		NOT NULL COMMENT 'Parámetro de auditoría',
	`FechaActual`		DATETIME	NOT NULL COMMENT 'Parámetro de auditoría',
	`DireccionIP`		VARCHAR(15)	NOT NULL COMMENT 'Parámetro de auditoría',
	`ProgramaID`		VARCHAR(50)	NOT NULL COMMENT 'Parámetro de auditoría',
	`Sucursal`			INT(11)		NOT NULL COMMENT 'Parámetro de auditoría',
	`NumTransaccion`	BIGINT(20)	NOT NULL COMMENT 'Parámetro de auditoría',
	PRIMARY KEY (`ValCajaParamID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el registro de los usuarios destinarios del correo'$$