-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACOMPRECRE
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMACOMPRECRE`;DELIMITER $$

CREATE TABLE `ESQUEMACOMPRECRE` (
  `ProductoCreditoID` int(11) NOT NULL,
  `PermiteLiqAntici` char(1) NOT NULL COMMENT 'Permite Liquidacion Anticipada\nS .- Si\nN .- No',
  `CobraComLiqAntici` char(1) NOT NULL COMMENT 'Cobra Comision por Liquidacion Anticipada\nS .- Si\nN .- No',
  `TipComLiqAntici` char(1) NOT NULL COMMENT 'Tipo de Cobro de Comision por Liquidacion Anticipada\nP .- Proyeccion de Interes\nS .- Porcentaje del Saldo Insoluto\nM .- Monto Fijo\n',
  `ComisionLiqAntici` decimal(14,4) NOT NULL COMMENT 'Valor de la Comision por Liquidacion Anticipada',
  `DiasGraciaLiqAntici` int(11) NOT NULL COMMENT 'Dias de Gracia para los cuales no Cobrar la Comision por Liquidacion Anticipada',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProductoCreditoID`),
  KEY `fk_ESQUEMACOMPRECRE_1` (`ProductoCreditoID`),
  CONSTRAINT `fk_ESQUEMACOMPRECRE_1` FOREIGN KEY (`ProductoCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Esquema de Comisiones en Prepagos de Credito	'$$