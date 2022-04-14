-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALCAJASDESTINATARIOS
DELIMITER ;
DROP TABLE IF EXISTS `VALCAJASDESTINATARIOS`;
DELIMITER $$
CREATE TABLE `VALCAJASDESTINATARIOS` (
	`UsuarioID`			INT(11)		NOT NULL COMMENT 'ID del usuario',
	`Tipo`				CHAR(1)		NOT NULL COMMENT 'Tipo de usuario. D=Dirigido, C=con copia, O=con copia oculto',

	`EmpresaID`			INT(11)		NOT NULL COMMENT 'Parámetro de auditoría',
	`Usuario`			INT(11)		NOT NULL COMMENT 'Parámetro de auditoría',
	`FechaActual`		DATETIME	NOT NULL COMMENT 'Parámetro de auditoría',
	`DireccionIP`		VARCHAR(15)	NOT NULL COMMENT 'Parámetro de auditoría',
	`ProgramaID`		VARCHAR(50)	NOT NULL COMMENT 'Parámetro de auditoría',
	`Sucursal`			INT(11)		NOT NULL COMMENT 'Parámetro de auditoría',
	`NumTransaccion`	BIGINT(20)	NOT NULL COMMENT 'Parámetro de auditoría',
	PRIMARY KEY (`UsuarioID`, `Tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el registro de los usuarios destinarios del correo'$$