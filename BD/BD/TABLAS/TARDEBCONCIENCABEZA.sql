-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIENCABEZA
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCONCIENCABEZA`;DELIMITER $$

CREATE TABLE `TARDEBCONCIENCABEZA` (
  `ConciliaID` int(11) NOT NULL COMMENT 'ID Conciliacion',
  `NomInstituGenera` varchar(20) DEFAULT NULL COMMENT 'Institucion que genera el archivo',
  `NomInstituRecibe` varchar(20) DEFAULT NULL COMMENT 'Nombre Institucion que recibe',
  `FechaProceso` varchar(6) DEFAULT NULL COMMENT 'Fecha de proceso de la transaccion \n',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Numero consecutivo de archivo para una institucion en el mismo dia',
  `NombreArchivo` varchar(150) DEFAULT NULL COMMENT 'Nombre del archivo cargado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConciliaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$