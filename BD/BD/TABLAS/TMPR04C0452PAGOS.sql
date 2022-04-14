-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPR04C0452PAGOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPR04C0452PAGOS`;DELIMITER $$

CREATE TABLE `TMPR04C0452PAGOS` (
  `CreditoID` bigint(20) NOT NULL COMMENT 'ID del Credit',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha del Pago Completo Realizado',
  `MontoPago` decimal(16,2) DEFAULT NULL COMMENT 'Monto del Pago Completo Realizado',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`CreditoID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para el Regulatorio R04C0452, Montos y Fechas de Ultimos pagos Completos Realizados'$$