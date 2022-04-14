-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESCREDITOSCONTMOVS
DELIMITER ;
DROP TABLE IF EXISTS `RESCREDITOSCONTMOVS`;
DELIMITER $$


CREATE TABLE `RESCREDITOSCONTMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TranRespaldo` bigint(20) DEFAULT NULL COMMENT 'transaccion del respaldo',
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
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` int(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `CreditoID` (`CreditoID`) USING BTREE,
  KEY `AmortiCreditoID` (`AmortiCreID`),
  KEY `TranRespaldo` (`TranRespaldo`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Respaldo por Reversa de pago Detalle de Movimientos  continegente o Transa'$$
