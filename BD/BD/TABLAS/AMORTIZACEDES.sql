-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZACEDES
DELIMITER ;
DROP TABLE IF EXISTS `AMORTIZACEDES`;DELIMITER $$

CREATE TABLE `AMORTIZACEDES` (
  `CedeID` int(11) NOT NULL COMMENT 'Numero o ID de Cede',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento ( la fecha que se utiliza para calcular los intereses ) ',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha en que se pagan los intereses, mientras no sea la fecha en que se paga capital se refiere a un dia habil antes\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Amortizacion\nN .- Vigente o en Proceso\nP .- Pagada',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Capital',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR ',
  `Dias` int(11) DEFAULT NULL COMMENT 'numero de dias que hay entre la fecha de incio y la de vencimiento ',
  `SaldoProvision` decimal(18,2) DEFAULT NULL COMMENT 'Saldo provision de la amortizacion',
  `ISRCal` decimal(18,2) DEFAULT '0.00' COMMENT 'Campo que guarda el ISR  provisionado del monto acumulado por cliente.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`CedeID`,`AmortizacionID`),
  KEY `fk_AMORTIZACEDES_1_idx` (`CedeID`),
  KEY `INDEX_AMORTIZACEDES_1` (`Estatus`),
  CONSTRAINT `fk_AMORTIZACEDES_1` FOREIGN KEY (`CedeID`) REFERENCES `CEDES` (`CedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Amortizaciones de Cedes'$$