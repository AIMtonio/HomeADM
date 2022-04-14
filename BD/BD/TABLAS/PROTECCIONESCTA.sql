-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROTECCIONESCTA
DELIMITER ;
DROP TABLE IF EXISTS `PROTECCIONESCTA`;DELIMITER $$

CREATE TABLE `PROTECCIONESCTA` (
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente que se esta cancelando',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `TipoCuentaID` int(11) DEFAULT NULL COMMENT 'ID del tipo de cuenta de ahorro',
  `Saldo` decimal(14,2) DEFAULT NULL COMMENT 'Total saldo original de la cuentas de captación',
  `InteresesCap` decimal(14,2) DEFAULT NULL COMMENT 'Intereses por captación a los días que hayan transcurridos en el mes al momento de la cancelación del socio',
  `InteresRetener` decimal(14,2) DEFAULT NULL COMMENT 'ISR por captación a los días que hayan transcurridos en el mes al momento de la cancelación del socio',
  `TotalHaberes` decimal(14,2) DEFAULT NULL COMMENT 'Total de haberes del ex - socio [(TotalSaldoOriCap + ParteSocial + InteresesCap) - InteresRetener]',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  KEY `FK_ClienteID_9` (`ClienteID`),
  KEY `FK_CuentaAhoID_2` (`CuentaAhoID`),
  KEY `FK_TipoCuentaID_1` (`TipoCuentaID`),
  CONSTRAINT `FK_ClienteID_9` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `FK_CuentaAhoID_2` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`),
  CONSTRAINT `FK_TipoCuentaID_1` FOREIGN KEY (`TipoCuentaID`) REFERENCES `TIPOSCUENTAS` (`TipoCuentaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla en donde se registran las cuentas activas al momento d'$$