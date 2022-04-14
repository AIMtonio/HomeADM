-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCGUARDAVALORES
DELIMITER ;
DROP TABLE IF EXISTS `DOCGUARDAVALORES`;

DELIMITER $$
CREATE TABLE `DOCGUARDAVALORES` (
	DocGuardaValoresID			INT(11)			NOT NULL COMMENT 'ID de Tabla',
	ParamGuardaValoresID		INT(11)			NOT NULL COMMENT 'ID de Tabla PARAMGUARDAVALORES',
	DocumentoID					INT(11)			NOT NULL COMMENT 'ID de Usuario',
	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la transacción',
	PRIMARY KEY (`DocGuardaValoresID`),
	KEY `IDX_DOCGUARDAVALORES_1` (`ParamGuardaValoresID`),
	KEY `IDX_DOCGUARDAVALORES_2` (`DocumentoID`),
	KEY `IDX_DOCGUARDAVALORES_3` (`ParamGuardaValoresID`,`DocumentoID`),
	CONSTRAINT `FK_DOCGUARDAVALORES_1` FOREIGN KEY (`ParamGuardaValoresID`) REFERENCES `PARAMGUARDAVALORES` (`ParamGuardaValoresID`),
	CONSTRAINT `FK_DOCGUARDAVALORES_2` FOREIGN KEY (`DocumentoID`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de parámetros para los Documentos del Menú Guarda Valores.'$$