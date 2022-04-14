-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEAFONDEA
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSLINEAFONDEA`;DELIMITER $$

CREATE TABLE `TIPOSLINEAFONDEA` (
  `TipoLinFondeaID` int(4) NOT NULL COMMENT 'ID de tipos de\nLine Fondeo',
  `InstitutFondID` int(11) NOT NULL COMMENT 'Id de instituciones de fondeo',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion\n',
  `EmpresaID` varchar(45) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoLinFondeaID`,`InstitutFondID`),
  KEY `fk_InstitutFondID_idx` (`InstitutFondID`),
  CONSTRAINT `fk_InstitutFondID` FOREIGN KEY (`InstitutFondID`) REFERENCES `INSTITUTFONDEO` (`InstitutFondID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipo de Lineas o Programas de Fondeo'$$