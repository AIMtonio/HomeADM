-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAEXCLUSIONES
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAEXCLUSIONES`;

DELIMITER $$
CREATE TABLE `BITACORAEXCLUSIONES` (
	BitacoraExclusionesID		BIGINT(20)		NOT NULL COMMENT 'ID de Tabla',
	RompimientoID 				INT(11)			NOT NULL COMMENT 'Numero de Rompimiento de Grupo',
	FechaRegistro 				DATE 			NOT NULL COMMENT 'Fecha de Registro del Rompimiento del Grupo',
	ClienteID					INT(11)			NOT NULL COMMENT 'ID de Tabla CLIENTES',
	CreditoID					BIGINT(20)		NOT NULL COMMENT 'ID de Tabla CREDITOS',

	GrupoID						INT(11) 		NOT NULL COMMENT 'ID de Tabla GRUPOSCREDITO',
	CicloID 					INT(11) 		NOT NULL COMMENT 'Numero de Ciclo del Grupo',
	ExigibleIndividual			DECIMAL(14,2)	NOT NULL COMMENT 'Exigible del Credito que se Excluye',
	DeudaGrupal 				DECIMAL(14,2)	NOT NULL COMMENT 'Deuda Grupal',
	UsuarioRegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Registra el Rompimiento de Grupo',

	SucursalRegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla SUCURSALES \Sucursal que Registra el Rompimiento de Grupo',

	EmpresaID					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`BitacoraExclusionesID`),
	KEY `IDX_BITACORAEXCLUSIONES_1` (`BitacoraExclusionesID`),
	KEY `IDX_BITACORAEXCLUSIONES_2` (`FechaRegistro`),
	KEY `IDX_BITACORAEXCLUSIONES_3` (`ClienteID`),
	KEY `IDX_BITACORAEXCLUSIONES_4` (`CreditoID`),
	KEY `IDX_BITACORAEXCLUSIONES_5` (`GrupoID`),
	KEY `IDX_BITACORAEXCLUSIONES_6` (`UsuarioRegistroID`),
	KEY `IDX_BITACORAEXCLUSIONES_7` (`SucursalRegistroID`),
	KEY `IDX_BITACORAEXCLUSIONES_8` (`NumTransaccion`),
	CONSTRAINT `FK_BITACORAEXCLUSIONES_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
	CONSTRAINT `FK_BITACORAEXCLUSIONES_2` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`),
	CONSTRAINT `FK_BITACORAEXCLUSIONES_3` FOREIGN KEY (`GrupoID`) REFERENCES `GRUPOSCREDITO` (`GrupoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Bitácora de Exclusión de Integrantes de un Grupo de Crédito.'$$