-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESCREDITOSMOVS
DELIMITER ;
DROP TABLE IF EXISTS `RESCREDITOSMOVS`;
DELIMITER $$


CREATE TABLE `RESCREDITOSMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TranRespaldo` bigint(20) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'ID del Credito Respaldo',
  `AmortiCreID` int(4) DEFAULT NULL COMMENT 'ID de la Amortizacion Respaldo',
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Tranasaccion Respaldo',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha Real de la Operacion Respaldo',
  `FechaAplicacion` date DEFAULT NULL COMMENT 'Fecha de Aplicacion Respaldo',
  `TipoMovCreID` int(4) DEFAULT NULL COMMENT 'Tipo de Movimiento de CreditoRespaldo ',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento\nC .- Cargo\nA .- Abono',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda del Movimiento Respaldo',
  `Cantidad` decimal(14,4) DEFAULT NULL COMMENT 'Movimiento Respaldo',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Movimiento Respaldo',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Referencia del Movimiento Respaldo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  KEY `CreditoID` (`CreditoID`) USING BTREE,
  KEY `AmortiCreditoID` (`AmortiCreID`),
  KEY `TranRespaldo` (`TranRespaldo`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Respaldo por Reversa de pago Detalle de Movimientos o Transa'$$
