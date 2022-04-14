-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTOTALPAGO
DELIMITER ;
DROP TABLE IF EXISTS `TMPTOTALPAGO`;DELIMITER $$

CREATE TABLE `TMPTOTALPAGO` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Crédito',
  `MontoTotal` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Pagado',
  KEY `IDX_TMPTOTALPAGO_1` (`Transaccion`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$