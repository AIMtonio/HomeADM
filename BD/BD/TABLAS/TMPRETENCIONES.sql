-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPRETENCIONES
DELIMITER ;
DROP TABLE IF EXISTS `TMPRETENCIONES`;DELIMITER $$

CREATE TABLE `TMPRETENCIONES` (
  `ClienteID` int(11) DEFAULT NULL,
  `TipoInstrumentoID` int(11) DEFAULT NULL,
  `Instrumento` bigint(20) DEFAULT NULL,
  `Monto` decimal(12,2) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL,
  `FechaVencimiento` date DEFAULT NULL,
  `NumTransaccion` int(11) DEFAULT NULL,
  KEY `idxClienteID` (`ClienteID`),
  KEY `idxInstrumento` (`Instrumento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$