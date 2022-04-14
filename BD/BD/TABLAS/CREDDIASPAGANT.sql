-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDDIASPAGANT
DELIMITER ;
DROP TABLE IF EXISTS `CREDDIASPAGANT`;DELIMITER $$

CREATE TABLE `CREDDIASPAGANT` (
  `ProducCreditoID` int(11) NOT NULL,
  `Frecuencia` char(1) NOT NULL COMMENT 'Frecuencia de Pago de las Amortizaciones de Capital\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual',
  `NumDias` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProducCreditoID`,`Frecuencia`),
  KEY `fk_CREDDIASPAGANT_1` (`ProducCreditoID`),
  CONSTRAINT `fk_CREDDIASPAGANT_1` FOREIGN KEY (`ProducCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Control de Dias para el Pago Anticipado de Credit'$$