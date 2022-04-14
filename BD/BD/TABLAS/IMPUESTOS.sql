-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IMPUESTOS
DELIMITER ;
DROP TABLE IF EXISTS `IMPUESTOS`;DELIMITER $$

CREATE TABLE `IMPUESTOS` (
  `ImpuestoID` int(11) NOT NULL COMMENT 'Id del impuesto\\n',
  `Descripcion` varchar(70) DEFAULT NULL COMMENT 'Descripcion completa del impuesto\\n',
  `DescripCorta` varchar(10) DEFAULT NULL COMMENT 'Descripcion Corta\\n',
  `Tasa` decimal(12,4) DEFAULT NULL COMMENT 'Tasa del impuesto',
  `GravaRetiene` char(1) DEFAULT NULL COMMENT 'G= Grava o  R = Retiene  ',
  `BaseCalculo` char(1) DEFAULT '' COMMENT 'Importe base sobre el cual se calculara el impuesto\nSubtotal S\nImporte Impuesto  I',
  `ImpuestoCalculo` int(11) DEFAULT '0' COMMENT 'Impuesto en el cual se aplicara el calculo.',
  `CtaEnTransito` varchar(25) DEFAULT NULL COMMENT 'Cuenta Contable  en Transito\\\\n',
  `CtaRealizado` varchar(25) DEFAULT NULL COMMENT 'Cuenta Contable en Realizado\\\\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ImpuestoID`),
  KEY `fk_IMPUESTOS_1_idx` (`CtaEnTransito`),
  KEY `fk_IMPUESTOS_1_idx1` (`CtaRealizado`),
  KEY `fk_IMPUESTOS_transito_idx` (`CtaEnTransito`),
  KEY `fk_IMPUESTOS_realizado_idx` (`CtaRealizado`),
  CONSTRAINT `fk_IMPUESTOS_realizado` FOREIGN KEY (`CtaRealizado`) REFERENCES `CUENTASCONTABLES` (`CuentaCompleta`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_IMPUESTOS_transito` FOREIGN KEY (`CtaEnTransito`) REFERENCES `CUENTASCONTABLES` (`CuentaCompleta`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Impuestos'$$