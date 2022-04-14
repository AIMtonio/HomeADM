-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMAMORTICREDITOAGRO
DELIMITER ;
DROP TABLE IF EXISTS `TEMAMORTICREDITOAGRO`;DELIMITER $$

CREATE TABLE `TEMAMORTICREDITOAGRO` (
  `Transaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Parametros de Auditoria',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `AmortizacionID` int(4) NOT NULL DEFAULT '0' COMMENT 'No Amortizacion',
  `CreditoFondeoID` bigint(12) NOT NULL COMMENT 'Numero de Credito de Fondeo (Pasivo)',
  `AmortizaPasivoID` int(11) NOT NULL COMMENT 'No Amortizacion en el Credito Pasivo',
  `NRegistro` int(11) NOT NULL COMMENT 'Numero de registro esto se ocupa para los ciclos',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio\n',
  `FechaVencim` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Capital',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`Transaccion`,`CreditoID`,`AmortizacionID`),
  KEY `IDX_TEMAMORTICREDITOAGRO_1` (`CreditoFondeoID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para crear las amortizaciones del credito pasivo de los creditos grupales'$$