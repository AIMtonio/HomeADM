-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCRW
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASMAYORCRW`;

DELIMITER $$
CREATE TABLE `CUENTASMAYORCRW` (
  `ConceptoCRWID` int(11) NOT NULL COMMENT 'ID del Concepto y FK que corresponde con la tabla de CONCEPTOSCRW.',
  `Cuenta` varchar(12) NOT NULL COMMENT 'Cuenta de Mayor',
  `Nomenclatura` varchar(30) NOT NULL COMMENT 'Nomenclatura de la Cuenta',
  `NomenclaturaCR` varchar(30) NOT NULL COMMENT 'Nomenclatura del Centro de Costo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`ConceptoCRWID`),
  KEY `fk_CUENTASMAYORCRW_1` (`ConceptoCRWID`),
  CONSTRAINT `fk_CUENTASMAYORCRW_1` FOREIGN KEY (`ConceptoCRWID`) REFERENCES `CONCEPTOSCRW` (`ConceptoCRWID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Cuentas Mayor para el Módulo de Crowdfunding.'$$