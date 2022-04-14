-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUM024INV
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTARESUM024INV`;
DELIMITER $$


CREATE TABLE `EDOCTARESUM024INV` (
  `AnioMes` int(11) NOT NULL COMMENT 'Periodo de generacion del Estado de Cuenta',
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de Sucursal del Cliente',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero identificador cliente',
  `InversionID` int(11) NOT NULL COMMENT 'Identificador de la Inversion',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la Inversion',
  `FechaVence` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la inversion',
  `FechaVenAnt` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Vencimiento Anterior al Mes Actual de procesamiento',
  `Etiqueta` varchar(100) DEFAULT NULL COMMENT 'Etiqueta aplicada a la inversion',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Monto de capital de la inversion',
  `Tasa` decimal(14,2) DEFAULT NULL COMMENT 'Tasa de la inversion',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Plazo de la inversion',
  `Interes` decimal(14,2) DEFAULT NULL COMMENT 'Monto del interes de la inversion',
  `ISR` decimal(14,2) DEFAULT NULL COMMENT 'ISR de la inversion',
  `InteresNeto` decimal(14,2) DEFAULT NULL COMMENT 'Interes neto de la inversion',
  `Descripcion` varchar(45) DEFAULT NULL COMMENT 'Nombre del producto',
  `GatInformativo` decimal(12,2) DEFAULT NULL COMMENT 'Gat Informativo',
  `GATReal` DECIMAL(12,2) DEFAULT NULL COMMENT 'Gat Real',
  `GATNominal` DECIMAL(12,2) DEFAULT NULL COMMENT 'Gat Nominal',
  `Estatus` char(1) DEFAULT NULL COMMENT ' ''A''.- Alta (no autorizada)\n ''N''.- Vigente (cargada a cuenta)\n ''P''.- Pagada (abonada a cuenta)\n ''C''.- Cancelada\n ''V''.- Vencida',
  `EstatusDescri` varchar(45) DEFAULT NULL COMMENT 'Describe el significado del caracter unico asignado a la columna Estatus',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioMes`,`SucursalID`,`ClienteID`,`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Resumen  de las inversiones del Cliente Crediclub'$$