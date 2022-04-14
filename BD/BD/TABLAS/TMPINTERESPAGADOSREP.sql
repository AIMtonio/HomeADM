-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPINTERESPAGADOSREP
DELIMITER ;
DROP TABLE IF EXISTS `TMPINTERESPAGADOSREP`;DELIMITER $$

CREATE TABLE `TMPINTERESPAGADOSREP` (
  `Fecha` date NOT NULL COMMENT 'Fecha Registro informacion para el calculo del Interes Real',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `NombreCompleto` varchar(200) NOT NULL DEFAULT '' COMMENT 'Nombre completo del cliente',
  `InstrumentoID` bigint(12) NOT NULL COMMENT 'Numero de Instrumento',
  `FechaInicio` date NOT NULL COMMENT 'Fecha de inicio para el calculo del interes real',
  `FechaFin` date NOT NULL COMMENT 'Fecha final para el calculo del interes real',
  `Monto` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto del instrumento',
  `TasaInteres` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT 'Tasa de Interes',
  `InteresGenerado` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Interes Generado',
  `ISR` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Impuesto Retenido',
  `InteresReal` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor Interes Real',
  KEY `INDEX_TMPINTERESPAGADOSREP_1` (`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena informacion para generar reporte de intereses pagados.'$$