-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAAPORT
DELIMITER ;
DROP TABLE IF EXISTS `AMORTIZAAPORT`;
DELIMITER $$

CREATE TABLE `AMORTIZAAPORT` (
  `AportacionID` int(11) NOT NULL COMMENT 'Numero o ID de Aportación.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio.',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento ( la fecha que se utiliza para calcular los intereses ) .',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha en que se pagan los intereses, mientras no sea la fecha en que se paga capital se refiere a un dia habil antes\n.',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\nN =vigente\nP =Pagada\nC =Cancelada\nA =Registrada\nL =Autorizada.',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Capital.',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes.',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR.',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR .',
  `Dias` int(11) DEFAULT NULL COMMENT 'numero de dias que hay entre la fecha de incio y la de vencimiento .',
  `SaldoProvision` decimal(18,2) DEFAULT NULL COMMENT 'Saldo provision de la amortizacion.',
  `SaldoISR` decimal(18,2) DEFAULT '0.00' COMMENT 'Saldo del devengo diario de ISR',
  `SaldoIsrAcum` decimal(18,2) DEFAULT '0.00' COMMENT 'Saldo ISR acumulado por devengamiento diario, hasta el momento de un cambio de tasa de ISR',
  `ISRCal` decimal(18,2) DEFAULT '0.00' COMMENT 'Campo que guarda el ISR  provisionado del monto acumulado por cliente.',
  `SaldoCap` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo capital para aportaciones que permiten capitalizacion.',
  `TipoPeriodo` char(1) DEFAULT '' COMMENT 'Tipo de Periodo para el Cálculo de Interés e ISR.\nR.- Periodo Regular.\nI.- Periodo Irregular.',
  `InteresRetenerRec` decimal(18,2) DEFAULT '0.00' COMMENT 'Interes a retener cuando existió un cambio de tasa en la Aportación.\nTotal por Cuota con la nueva tasa.\nNace con el total original, se recalcula hasta el nuevo cambio de tasa.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria.',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria.',
  PRIMARY KEY (`AportacionID`,`AmortizacionID`),
  KEY `fk_AMORTIZAAPORT_1_idx` (`AportacionID`),
  KEY `INDEX_AMORTIZAAPORT_1` (`Estatus`),
  CONSTRAINT `fk_AMORTIZAAPORT_1` FOREIGN KEY (`AportacionID`) REFERENCES `APORTACIONES` (`AportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Amortizaciones de las Aportaciones.'$$