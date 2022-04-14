-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPR04C0452PAGEXI
DELIMITER ;
DROP TABLE IF EXISTS `TMPR04C0452PAGEXI`;DELIMITER $$

CREATE TABLE `TMPR04C0452PAGEXI` (
  `CreditoID` bigint(20) NOT NULL COMMENT 'ID del Credito',
  `FechaLiquida` date DEFAULT NULL COMMENT 'Fecha ultima cuota liquidada',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'ID de la ultima Amortizacion liquidada',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`CreditoID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para el Regulatorio R04C0452, Seguimiento Cartera, Pagos Exigibles Realizados'$$