-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBLOQUEOSREF
DELIMITER ;
DROP TABLE IF EXISTS `TMPBLOQUEOSREF`;DELIMITER $$

CREATE TABLE `TMPBLOQUEOSREF` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion del Bloqueo',
  `NReg` bigint(21) NOT NULL COMMENT 'Numero de reg',
  `BloqueoID` int(11) NOT NULL COMMENT 'ID del bloqueo',
  `MontoBloq` decimal(12,2) DEFAULT NULL COMMENT 'Monto Bloqueado',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente\n',
  `CuentaID` bigint(12) DEFAULT NULL COMMENT 'Numero de Cuenta',
  `ReferenciaPago` varchar(20) DEFAULT NULL COMMENT 'Refencia de Pago (Para el proceso de Pago Refenreciado)',
  PRIMARY KEY (`TransaccionID`,`NReg`),
  KEY `IDX_TMPBLOQUEOSREF_1` (`TransaccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para el bloquedo x referencia'$$