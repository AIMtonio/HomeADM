-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USRGUARDAVALORES
DELIMITER ;
DROP TABLE IF EXISTS `USRGUARDAVALORES`;

DELIMITER $$
CREATE TABLE `USRGUARDAVALORES` (
	UsrGuardaValoresID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
	ParamGuardaValoresID		INT(11)			NOT NULL COMMENT 'ID de Tabla PARAMGUARDAVALORES',
	PuestoFacultado				VARCHAR(10)		NOT NULL COMMENT 'ID de Tabla PUESTOS',
	UsuarioFacultadoID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS',
	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`UsrGuardaValoresID`),
	KEY `IDX_USRGUARDAVALORES_1` (`ParamGuardaValoresID`),
	KEY `IDX_USRGUARDAVALORES_2` (`PuestoFacultado`),
	KEY `IDX_USRGUARDAVALORES_3` (`UsuarioFacultadoID`),
	KEY `IDX_USRGUARDAVALORES_4` (`ParamGuardaValoresID`,`PuestoFacultado`),
	KEY `IDX_USRGUARDAVALORES_5` (`ParamGuardaValoresID`,`UsuarioFacultadoID`),
	CONSTRAINT `FK_USRGUARDAVALORES_1` FOREIGN KEY (`ParamGuardaValoresID`) REFERENCES `PARAMGUARDAVALORES` (`ParamGuardaValoresID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de parametros para los Puestos y los Usuarios Facultados para el Menu Guarda Valores.'$$