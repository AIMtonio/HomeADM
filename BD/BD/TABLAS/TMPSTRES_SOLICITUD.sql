-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSTRES_SOLICITUD
DELIMITER ;
DROP TABLE IF EXISTS `TMPSTRES_SOLICITUD`;DELIMITER $$

CREATE TABLE `TMPSTRES_SOLICITUD` (
  `clienteID` int(12) NOT NULL,
  `cuentaClabe` varchar(45) DEFAULT NULL,
  `tipoDispersion` varchar(45) DEFAULT NULL,
  `calificacion` varchar(45) DEFAULT NULL,
  `plazo` varchar(45) DEFAULT NULL,
  `periodicidad` varchar(45) DEFAULT NULL,
  `tasaActiva` varchar(45) DEFAULT NULL,
  `montoSolici` varchar(45) DEFAULT NULL,
  `fechaRegistro` varchar(45) DEFAULT NULL,
  `productoCreditoID` varchar(45) DEFAULT NULL,
  `prospectoID` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`clienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Borrarla si la ves: Para Prueba de Estresss de Carga de Soli'$$