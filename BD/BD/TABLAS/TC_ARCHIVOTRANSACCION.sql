-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_ARCHIVOTRANSACCION
DELIMITER ;
DROP TABLE IF EXISTS `TC_ARCHIVOTRANSACCION`;DELIMITER $$

CREATE TABLE `TC_ARCHIVOTRANSACCION` (
  `ArchivoTarCredID` int(11) DEFAULT NULL COMMENT 'Consecutivo de Carga',
  `FechaCarga` date DEFAULT NULL COMMENT 'Fecha de Carga del Archivo',
  `FechaReporte` date DEFAULT NULL COMMENT 'Fecha de Reporte en el archivo',
  `HoraReporte` time DEFAULT NULL COMMENT 'Hora en que se genero el reporte',
  `NombreArchivo` varchar(150) DEFAULT NULL COMMENT 'Nombre del archivo',
  `TipoArchivo` char(1) DEFAULT NULL COMMENT 'L: Local, I: Internacional',
  `TotalAplicar` decimal(18,2) DEFAULT NULL COMMENT 'Total de cargos a Aplicar',
  `NumRegistros` int(11) DEFAULT NULL COMMENT 'Numero de transacciones',
  `BinExterno` varchar(10) DEFAULT NULL COMMENT 'Bin Externo - Transacciones Internacionales',
  `TipoCarga` char(1) DEFAULT NULL COMMENT 'Tipos:\nC = ARCHIVO DE COMPRAS\nP = ARCHIVO DE PAGOS/RECARGAS',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Lleva el registro de archivos que se han cargado al sistema'$$