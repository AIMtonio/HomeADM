-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDETPOLIZA
DELIMITER ;
DROP TABLE IF EXISTS `TMPDETPOLIZA`;
DELIMITER $$


CREATE TABLE `TMPDETPOLIZA` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de la \nPoliza',
  `Fecha` date NOT NULL COMMENT 'Fecha de la \nPoliza',
  `CentroCostoID` int(11) NOT NULL COMMENT 'Centro de \nCostos',
  `CuentaCompleta` varchar(50) NOT NULL COMMENT 'Cuenta Contable\nCompleta',
  `Instrumento` varchar(20) NOT NULL COMMENT 'Instrumento\nque origino el\nmovimiento',
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda',
  `Cargos` decimal(14,4) DEFAULT NULL,
  `Abonos` decimal(14,4) DEFAULT NULL,
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del\nMovimiento',
  `Referencia` varchar(50) NOT NULL COMMENT 'Referencia',
  `ProcedimientoCont` varchar(30) DEFAULT NULL COMMENT 'Procedimiento\nContable que\nArma la Cuenta\nContable',
  `CreditoID` bigint(20) DEFAULT NULL COMMENT 'ID o Numero de Credito',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'Clasificacion\nC .- Comercial\nO .- Consumo\nH .- Hipotecario',
  `ProductoCreditoID` int(11) DEFAULT NULL,
  `ConceptoContable` int(11) DEFAULT NULL COMMENT 'Concepto Contable',
  `SubClasificacion` int(11) DEFAULT NULL COMMENT 'SubClasificacion del Credito',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal Detalle de Poliza Contable'$$
