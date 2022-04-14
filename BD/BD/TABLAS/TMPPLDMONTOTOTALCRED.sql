-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDMONTOTOTALCRED
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDMONTOTOTALCRED`;DELIMITER $$

CREATE TABLE `TMPPLDMONTOTOTALCRED` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
  `MontoTotal` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Pagado',
  KEY `IDX_TMPPLDMONTOTOTALCRED_1` (`Transaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$