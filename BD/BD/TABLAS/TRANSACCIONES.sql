-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANSACCIONES
DELIMITER ;
DROP TABLE IF EXISTS `TRANSACCIONES`;
DELIMITER $$


CREATE TABLE `TRANSACCIONES` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `NumeroTransaccion` bigint(20) NOT NULL COMMENT 'Numero de \nTransaccion',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Consecutivos de Numeros de Transaccion'$$
