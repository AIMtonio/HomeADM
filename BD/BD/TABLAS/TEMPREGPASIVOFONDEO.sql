-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMPREGPASIVOFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `TEMPREGPASIVOFONDEO`;DELIMITER $$

CREATE TABLE `TEMPREGPASIVOFONDEO` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion\n',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Consecutivo',
  `LineaFondeoID` int(11) NOT NULL COMMENT 'Linea de Fondeo ID',
  `CapitalVigente` decimal(18,2) DEFAULT '0.00' COMMENT 'Corresponde al capital vigente con recursos FIRA',
  `FinaAdicionalVig` decimal(18,2) DEFAULT '0.00' COMMENT 'Corresponde al capital vigente que la financiera ha recibió por parte de FIRA como financiamientos adicionales (esquema SIMFA)',
  `InteresDev` decimal(18,2) DEFAULT NULL COMMENT ' Corresponde al total de intereses devengados vigentes de la cartera FIRA (este campo se puede corroborar con el dato de intereses del pasivo del balance general).',
  `CapitalVencido` decimal(18,2) DEFAULT NULL COMMENT 'Corresponde al capital vencido con recursos FIRA',
  `FinaAdicionalVen` decimal(18,2) DEFAULT NULL COMMENT 'Corresponde al total de intereses devengados vencidos de la cartera FIRA.',
  `InteresVenc` decimal(18,2) DEFAULT NULL COMMENT 'Corresponde al capital vencido con recursos FIRA.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Transaccion`,`LineaFondeoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para guardar la sumatoria por linea de credito de fondeo'$$