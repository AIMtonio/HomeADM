-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDDIASANTICIPADO
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDDIASANTICIPADO`;DELIMITER $$

CREATE TABLE `TMPPLDDIASANTICIPADO` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  KEY `IDX_TMPPLDDIASANTICIPADO_1` (`Transaccion`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$