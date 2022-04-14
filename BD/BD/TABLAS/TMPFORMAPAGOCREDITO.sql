-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFORMAPAGOCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `TMPFORMAPAGOCREDITO`;DELIMITER $$

CREATE TABLE `TMPFORMAPAGOCREDITO` (
  `TipoInstrumentoID` int(11) DEFAULT NULL COMMENT 'Tipo de Instrumento',
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de transaccion',
  PRIMARY KEY (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena de manera temporal los movimientos con intrumento 15=CAJA VENTANILLA'$$