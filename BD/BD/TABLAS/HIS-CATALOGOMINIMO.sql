-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-CATALOGOMINIMO
DELIMITER ;
DROP TABLE IF EXISTS `HIS-CATALOGOMINIMO`;DELIMITER $$

CREATE TABLE `HIS-CATALOGOMINIMO` (
  `Anio` int(11) NOT NULL DEFAULT '0' COMMENT 'Ano del reporte',
  `Mes` int(11) NOT NULL DEFAULT '0' COMMENT 'Mes del Reporte',
  `ConceptoFinanID` int(11) NOT NULL COMMENT 'ID del Concepto Financiero',
  `CuentaContable` varchar(500) NOT NULL COMMENT 'Cuenta Fija del Reporte CNBV',
  `Monto` varchar(14) DEFAULT NULL COMMENT 'Monto en Pesos',
  `MonedaExt` decimal(21,2) DEFAULT NULL COMMENT 'Monto en Moneda Extrangera',
  PRIMARY KEY (`Anio`,`Mes`,`ConceptoFinanID`),
  KEY `idx_CATALOGOMINIMO_1` (`Anio`,`Mes`,`CuentaContable`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que lleva el registro historico del Catalogo Minimo'$$