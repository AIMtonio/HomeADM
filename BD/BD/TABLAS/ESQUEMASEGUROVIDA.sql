-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROVIDA
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMASEGUROVIDA`;DELIMITER $$

CREATE TABLE `ESQUEMASEGUROVIDA` (
  `EsquemaSeguroID` int(11) NOT NULL COMMENT 'PK de la tabla',
  `ProducCreditoID` int(11) NOT NULL COMMENT 'Producto de Crédito',
  `TipoPagoSeguro` char(1) NOT NULL COMMENT 'Tipo de cobro del Seguro. A: Anticipado, D: Deduccion, F: Financiamiento',
  `FactorRiesgoSeguro` decimal(12,6) DEFAULT NULL COMMENT 'Factor de Riesgo del Seguro',
  `DescuentoSeguro` decimal(12,2) DEFAULT NULL COMMENT 'Descuento en el Monto de Cobro de Seguro, de acuerdo al Tipo de Pago del mismo',
  `MontoPolSegVida` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Poliza del Seguro de Vida en caso de siniestro',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProducCreditoID`,`EsquemaSeguroID`,`TipoPagoSeguro`),
  KEY `fk_ESQUEMASEGUROVIDA_1_idx` (`ProducCreditoID`,`EsquemaSeguroID`,`TipoPagoSeguro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$