-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROTECCIONESINV
DELIMITER ;
DROP TABLE IF EXISTS `PROTECCIONESINV`;DELIMITER $$

CREATE TABLE `PROTECCIONESINV` (
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente que se esta cancelando',
  `InversionID` int(12) DEFAULT NULL COMMENT 'ID de la inversion',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Total saldo original de la cuentas de captación',
  `InteresGenerado` decimal(14,2) DEFAULT NULL COMMENT 'Intereses por captación a los días que hayan transcurridos en el mes al momento de la cancelación del socio',
  `InteresRetener` decimal(14,2) DEFAULT NULL COMMENT 'ISR por captación a los días que hayan transcurridos en el mes al momento de la cancelación del socio',
  `Total` decimal(14,2) DEFAULT NULL COMMENT 'Total Recibir  [(monto + InteresGenerado ) - InteresRetener]',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  KEY `FK_ClienteID_10` (`ClienteID`),
  KEY `FK_InversionID_1` (`InversionID`),
  CONSTRAINT `FK_ClienteID_10` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `FK_InversionID_1` FOREIGN KEY (`InversionID`) REFERENCES `INVERSIONES` (`InversionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla en donde se registran las inversiones vigentes al mome'$$