-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCARGAMOVSHEAD
DELIMITER ;
DROP TABLE IF EXISTS `PLDCARGAMOVSHEAD`;DELIMITER $$

CREATE TABLE `PLDCARGAMOVSHEAD` (
  `CargaID` bigint(20) NOT NULL COMMENT 'Identificador de la carga realizada, consiste en la fecha de carga acompañada de la hora realizada, sin los guines',
  `PIDTarea` varchar(50) NOT NULL COMMENT 'Numero referente a la tarea',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de los archivos, C.- Cargado, P.- Procesado, E.- Error, por defecto inicia como vacio',
  `NombreArchivo` varchar(27) NOT NULL COMMENT 'Nombre del archivo cargado que consta de PLDMOVS acompañado de la FechaIni y FechaFin',
  `CheckSum` varchar(50) NOT NULL COMMENT 'Valor del checksum del archivo cargado',
  `FechaCarga` datetime NOT NULL COMMENT 'Fecha en la que se realizo la carga de los movimientos',
  `FechaIni` date NOT NULL COMMENT 'Fecha de inicio de los movimientos',
  `FechaFin` date NOT NULL COMMENT 'Fecha de finalizacion de los movimientos',
  `MensajeError` varchar(400) NOT NULL COMMENT 'Mensaje de error',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`CargaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar el historico de los movimientos del cliente cargados.'$$