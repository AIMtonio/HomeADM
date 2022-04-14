-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSIMULADORCEDE
DELIMITER ;
DROP TABLE IF EXISTS `TMPSIMULADORCEDE`;
DELIMITER $$


CREATE TABLE `TMPSIMULADORCEDE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'NUmero de Transaccion',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Consecutivo',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha Calculo',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha de pago',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto de Capital',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Interes',
  `ISR` decimal(18,2) DEFAULT NULL COMMENT 'Monto de ISR',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Monto Total',
  `Dias` int(11) DEFAULT NULL COMMENT 'Dias que hay entre la fecha de inicio y la de vencimiento',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de inicio del cede',
  KEY `index_NumTransaccion` (`NumTransaccion`,`Consecutivo`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena la simulacion de los cedes.'$$
