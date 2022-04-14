-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORARCHIVOSBAJ
DELIMITER ;
DROP TABLE IF EXISTS `BITACORARCHIVOSBAJ`;
DELIMITER $$

CREATE TABLE `BITACORARCHIVOSBAJ` (
	`ArchivoBajID` BIGINT(20) NOT NULL COMMENT 'Consecutivo General de la Tabla',
	`TipoInstrumento` INT(11) NOT NULL COMMENT 'Tipo de Instrumento, ID de Tabla TIPOINSTRUMENTOS',
	`NumeroInstrumento` BIGINT(20) NOT NULL COMMENT 'ID del Instrumento: ClienteID, CuentaAhoID, SolicitudCreditoID, CreditoID, ProspectoID',
	`TipoDocumento` INT(11) NOT NULL COMMENT 'Tipo de documento si es Solicitud de Credito->ID de Tabla CLASIFICATIPDOC, si es Cliente,Prospecto, Cuenta o Credito->ID de Tabla TIPOSDOCUMENTOS',
	`FechaBaja` DATE DEFAULT '1900-01-01' COMMENT 'Fecha en la que se elimina el documento',
	`UsuarioBaja` INT(11) DEFAULT 0 COMMENT 'Usuario que elimina el documento',
	`NombreUsuarioBaja` VARCHAR(200) DEFAULT '' COMMENT 'Nombre del Usuario que elimina el documento',
	`EmpresaID` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
	`Usuario` INT(11) DEFAULT NULL  COMMENT 'Campo de Auditoria',
	`FechaActual` DATETIME DEFAULT NULL  COMMENT 'Campo de Auditoria',
	`DireccionIP` VARCHAR(15) DEFAULT NULL  COMMENT 'Campo de Auditoria',
	`ProgramaID` VARCHAR(50) DEFAULT NULL  COMMENT 'Campo de Auditoria',
	`Sucursal` INT(11) DEFAULT NULL  COMMENT 'Campo de Auditoria',
	`NumTransaccion` BIGINT(20) DEFAULT NULL  COMMENT 'Campo de Auditoria',
	PRIMARY KEY (`ArchivoBajID`),
	KEY `idx_BITACLIENTEARCHBAJ_1` (`TipoDocumento`),
	KEY `idx_BITACLIENTEARCHBAJ_2` (`TipoInstrumento`),
	KEY `idx_BITACLIENTEARCHBAJ_3` (`NumeroInstrumento`),
	CONSTRAINT `fk_BITACLIENTEARCHBAJ_2` FOREIGN KEY (`TipoInstrumento`) REFERENCES `TIPOINSTRUMENTOS` (`TipoInstrumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='BITACORA QUE ALMACENA ARCHIVOS ELIMINADOS DE LOS INSTRUMENTOS'$$
