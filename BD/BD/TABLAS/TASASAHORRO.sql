-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAHORRO
DELIMITER ;
DROP TABLE IF EXISTS `TASASAHORRO`;DELIMITER $$

CREATE TABLE `TASASAHORRO` (
  `TasaAhorroID` int(11) NOT NULL COMMENT 'Numero de Tasa de Ahorro',
  `TipoCuentaID` int(11) NOT NULL COMMENT 'Numero de Tipo de Cuentas',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de persona:  F =Fisica, M =Moral, A= Fisica con Actividad Empresarial',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda del Tipo de Cuenta',
  `MontoInferior` decimal(12,2) DEFAULT NULL,
  `MontoSuperior` decimal(12,2) DEFAULT NULL,
  `Tasa` decimal(12,4) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TasaAhorroID`),
  KEY `fk_TASASAHORRO_1` (`TipoCuentaID`),
  KEY `fk_TASASAHORRO_2` (`MonedaID`),
  CONSTRAINT `fk_TASASAHORRO_1` FOREIGN KEY (`TipoCuentaID`) REFERENCES `TIPOSCUENTAS` (`TipoCuentaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TASASAHORRO_2` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tasas de Ahorro'$$