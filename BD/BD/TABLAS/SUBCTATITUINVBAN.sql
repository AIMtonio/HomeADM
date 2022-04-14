-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATITUINVBAN
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTATITUINVBAN`;DELIMITER $$

CREATE TABLE `SUBCTATITUINVBAN` (
  `ConceptoInvBanID` int(11) NOT NULL DEFAULT '0' COMMENT 'PK de la tabla, Y FK que corresponde con la tabla de CONCEPTOSINVERBAN',
  `TituNegocio` varchar(6) DEFAULT NULL COMMENT 'Titulos para negociar',
  `TituDispVenta` varchar(6) DEFAULT NULL COMMENT 'Titulos Disponibles para Venta',
  `TituConsVenc` varchar(6) DEFAULT NULL COMMENT 'Titulos Conservados al Vencimiento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Dirección IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa ID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Número de Transacción',
  PRIMARY KEY (`ConceptoInvBanID`),
  KEY `fk_SUBCTATITUINVBAN_1` (`ConceptoInvBanID`),
  CONSTRAINT `fk_SUBCTATITUINVBAN_1` FOREIGN KEY (`ConceptoInvBanID`) REFERENCES `CONCEPTOSINVBAN` (`ConceptoInvBanID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Subcuenta de Titulos para el Modulo de Inversiones Bancarias'$$