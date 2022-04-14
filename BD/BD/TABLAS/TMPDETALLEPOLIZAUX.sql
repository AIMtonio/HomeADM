-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDETALLEPOLIZAUX
DELIMITER ;
DROP TABLE IF EXISTS `TMPDETALLEPOLIZAUX`;DELIMITER $$

CREATE TABLE `TMPDETALLEPOLIZAUX` (
  `Transaccion` bigint(20) DEFAULT NULL,
  `PolizaID` bigint(20) DEFAULT NULL,
  `Instrumento` int(11) DEFAULT NULL,
  `TipoInstrumentoID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$