-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDLIQUIDACIONANT
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDLIQUIDACIONANT`;DELIMITER $$

CREATE TABLE `TMPPLDLIQUIDACIONANT` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `TotalPago` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Pagado',
  KEY `IDX_TMPPLDLIQUIDACIONANT_1` (`Transaccion`,`CreditoID`),
  KEY `IDX_TMPPLDLIQUIDACIONANT_2` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$