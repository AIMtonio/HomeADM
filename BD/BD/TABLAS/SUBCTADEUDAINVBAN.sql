-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTADEUDAINVBAN
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTADEUDAINVBAN`;DELIMITER $$

CREATE TABLE `SUBCTADEUDAINVBAN` (
  `ConceptoInvBanID` int(11) NOT NULL DEFAULT '0' COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVERBAN',
  `TipoDeuGuber` varchar(6) DEFAULT NULL COMMENT 'Tipo de deuda Gubernamental',
  `TipoDeuBanca` varchar(6) DEFAULT NULL COMMENT 'Tipo de deuda Bancaria',
  `TipoDeuOtros` varchar(6) DEFAULT NULL COMMENT 'Tipo de deuda Otros Titulos',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Dirección IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa ID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Número de Transacción',
  PRIMARY KEY (`ConceptoInvBanID`),
  KEY `fk_SUBCTAINVBANRESDEU_1` (`ConceptoInvBanID`),
  CONSTRAINT `fk_SUBCTADEUDAINVBAN_1` FOREIGN KEY (`ConceptoInvBanID`) REFERENCES `CONCEPTOSINVBAN` (`ConceptoInvBanID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Deudas para el Modulo de Inversiones Bancarias'$$