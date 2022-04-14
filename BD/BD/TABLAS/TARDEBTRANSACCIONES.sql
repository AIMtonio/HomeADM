-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBTRANSACCIONES
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBTRANSACCIONES`;DELIMITER $$

CREATE TABLE `TARDEBTRANSACCIONES` (
  `NumeroTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion para Operaciones POS Tarjeta Débito'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Consecutivos de Numeros de Transaccion POS Tarjeta Debito'$$