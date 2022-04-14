-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOPROD
DELIMITER ;
DROP TABLE IF EXISTS `CALENDARIOPROD`;DELIMITER $$

CREATE TABLE `CALENDARIOPROD` (
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'Producto de credito',
  `FecInHabTomar` char(1) DEFAULT NULL COMMENT 'En Fecha Inhabil Tomar\\\\\\\\nS: Dia Habil Siguiente\\\\\\\\nA: Dia Habil Anterior',
  `AjusFecExigVenc` char(1) DEFAULT NULL COMMENT 'Ajustar Fecha Exigible a \\\\nVencimiento\\nS: Si\\nN: No',
  `PermCalenIrreg` char(1) DEFAULT NULL COMMENT 'Permite\\\\nCalendario\\\\nIrregular\\nS: Si\\nN: No',
  `AjusFecUlAmoVen` char(1) DEFAULT NULL COMMENT 'Ajustar fecha de ultima amortización a fecha de vencimiento del credito\\nS: Si\\nN: No',
  `TipoPagoCapital` char(15) DEFAULT NULL COMMENT 'Tipo Pago Capital\\nC : Crecientes\\nI: Iguales\\nL: Libres',
  `IguaCalenIntCap` char(1) DEFAULT NULL COMMENT 'Igualdad\\\\nEn Calendario\\\\nDe Interes y \\\\nCapital\\\\n\\nS: Si\\nN: No',
  `Frecuencias` varchar(200) DEFAULT NULL COMMENT 'Frecuencia de Pago de las Amortizaciones de Capital\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual\nL.- Libres',
  `PlazoID` varchar(2000) DEFAULT NULL COMMENT 'Plazo',
  `DiaPagoCapital` char(1) DEFAULT NULL COMMENT 'Dia de pago de Capital\\\\nF.-Pago  final del mes \\\\nA.- Por aniversario\\\\nD.- Dia del mes\\nI. Indistinto',
  `DiaPagoInteres` char(1) DEFAULT NULL COMMENT 'Dia de pago de Interes\\\\nF.-Pago  final del mes \\\\nA.- Por aniversario\\\\nD.- Dia del mes\\nI. Indistinto',
  `TipoDispersion` varchar(100) DEFAULT NULL COMMENT 'Tipo de DispersionS .- SPEI\\nC .- Cheque\\nO .- Orden de Pago\\nE.- Efectivo',
  `DiaPagoQuincenal` char(1) DEFAULT '' COMMENT 'Día de Pago solo para Frecuencia Quincenal.\nD.- Día Quincena (fechas de pago específicas).\nQ.- Quincenal (funcionamiento normal).\nI.- Indistinto.',
  `DiasReqPrimerAmor` int(11) DEFAULT '0' COMMENT 'Dias requeridos para la primera amortizacion para Calendario Irregular de Frecuencia Libre',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(60) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProductoCreditoID`),
  KEY `fk_CALENDARIOPROD_1_idx` (`ProductoCreditoID`),
  KEY `fk_CALENDARIOPROD_1_idx1` (`PlazoID`),
  CONSTRAINT `fk_ProductoCred` FOREIGN KEY (`ProductoCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Calendario Por Producto'$$