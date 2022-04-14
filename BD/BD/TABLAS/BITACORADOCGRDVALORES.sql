-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORADOCGRDVALORES
DELIMITER ;
DROP TABLE IF EXISTS `BITACORADOCGRDVALORES`;

DELIMITER $$
CREATE TABLE `BITACORADOCGRDVALORES` (
	BitacoraDocGrdValoresID		BIGINT(20)		NOT NULL COMMENT 'ID de Tabla',
	DocumentoID					BIGINT(20)		NOT NULL COMMENT 'ID de Tabla DOCUMENTOSGRDVALORES',
	FechaRegistro				DATE			NOT NULL COMMENT 'Fecha de Registro del Documento',
	HoraRegistro				TIME			NOT NULL COMMENT 'Hora de Registro del Documento',
	UsuarioRegistroID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Registra la Modificación del Documento',

	UsuarioPrestamoID			INT(11)			NOT NULL COMMENT 'ID de Tabla USUARIOS \nUsuario que Solicita el Préstamo del Documento',
	EstatusPrevio				CHAR(1)			NOT NULL COMMENT 'Estatus Previo del Documento \nR = Registrado \nC= Custodia \nP=  Préstamo \nB= Baja.',
	EstatusActual				CHAR(1)			NOT NULL COMMENT 'Estatus Actual del Documento \nR = Registrado \nC= Custodia \nP=  Préstamo \nB= Baja.',
	Observaciones				VARCHAR(500)	NOT NULL COMMENT 'Observaciones del Cambio de estatus',

	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`BitacoraDocGrdValoresID`),
	KEY `IDX_BITACORADOCGRDVALORES_1` (`DocumentoID`),
	KEY `IDX_BITACORADOCGRDVALORES_2` (`BitacoraDocGrdValoresID`,`DocumentoID`),
	KEY `IDX_BITACORADOCGRDVALORES_3` (`FechaRegistro`),
	KEY `IDX_BITACORADOCGRDVALORES_4` (`UsuarioRegistroID`),
	KEY `IDX_BITACORADOCGRDVALORES_5` (`UsuarioPrestamoID`),
	KEY `IDX_BITACORADOCGRDVALORES_6` (`NumTransaccion`),
	CONSTRAINT `FK_BITACORADOCGRDVALORES_1` FOREIGN KEY (`DocumentoID`) REFERENCES `DOCUMENTOSGRDVALORES` (`DocumentoID`),
	CONSTRAINT `FK_BITACORADOCGRDVALORES_2` FOREIGN KEY (`UsuarioRegistroID`) REFERENCES `USUARIOS` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Bitácora de  Documentos para la Guarda de Valores.'$$