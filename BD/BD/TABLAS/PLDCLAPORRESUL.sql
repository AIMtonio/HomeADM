-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCLAPORRESUL
DELIMITER ;
DROP TABLE IF EXISTS `PLDCLAPORRESUL`;DELIMITER $$

CREATE TABLE `PLDCLAPORRESUL` (
  `TipoResultEscID` char(1) NOT NULL COMMENT 'ID Clave del resultado del escalamiento',
  `ClaveJustEscIntID` int(11) NOT NULL COMMENT 'ID o Consecutivo de la Clave de Justificacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Registro',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa Origen',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal Origen',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`TipoResultEscID`,`ClaveJustEscIntID`),
  KEY `fk_PLDCLAPORRESUL_1` (`TipoResultEscID`),
  KEY `fk_PLDCLAPORRESUL_2` (`ClaveJustEscIntID`),
  CONSTRAINT `fk_PLDCLAPORRESUL_1` FOREIGN KEY (`TipoResultEscID`) REFERENCES `TIPORESULESCPLD` (`TipoResultEscID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PLDCLAPORRESUL_2` FOREIGN KEY (`ClaveJustEscIntID`) REFERENCES `PLDCLAJUSESCINTER` (`ClaveJustEscIntID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Claves o Motivos de Justificacion por Resultado para Operaci'$$