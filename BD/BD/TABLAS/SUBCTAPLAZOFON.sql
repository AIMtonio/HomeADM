-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOFON
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAPLAZOFON`;DELIMITER $$

CREATE TABLE `SUBCTAPLAZOFON` (
  `ConceptoFonID` int(11) NOT NULL,
  `TipoFondeo` char(1) NOT NULL COMMENT 'Indica el tipo de Fondeador INVERSIONISTA(I)/FONDEADOR(F)',
  `CortoPlazo` char(6) DEFAULT NULL,
  `LargoPlazo` char(6) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`ConceptoFonID`,`TipoFondeo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='subcuenta plazo contable de fondeo'$$