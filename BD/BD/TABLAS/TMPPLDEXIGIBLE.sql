-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDEXIGIBLE
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDEXIGIBLE`;DELIMITER $$

CREATE TABLE `TMPPLDEXIGIBLE` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Cuenta'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$