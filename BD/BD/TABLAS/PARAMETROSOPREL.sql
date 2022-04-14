-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSOPREL
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSOPREL`;
DELIMITER $$


CREATE TABLE `PARAMETROSOPREL` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `MonedaLimOPR` int(11) NOT NULL COMMENT 'Moneda limite de operaciones relevantes\n',
  `LimiteInferior` decimal(12,2) NOT NULL COMMENT 'LImite inferior',
  `FechaInicioVig` date DEFAULT NULL COMMENT 'fecha de inicio de vigencia',
  `FechaFinVig` date DEFAULT NULL COMMENT 'fecha de fin de vigencia',
  `LimMensualMicro` decimal(12,2) DEFAULT NULL,
  `MonedaLimMicro` int(11) DEFAULT NULL COMMENT 'Moneda limite de operaciones de microcredito',
  `EvaluaOpeAcumMes` char(1) DEFAULT NULL COMMENT 'Especifica si evalúa automáticamente las operaciones relevantes acumuladas en el mes, S=SI, N=NO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'campo de auditoria ',
  `FechaActual` datetime DEFAULT NULL COMMENT 'campo de auditoria \n',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'campo de auditoria ',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'campo de auditoria ',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'campo de auditoria ',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'campo de auditoria ',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de parametros de operaciones reelevantes'$$
