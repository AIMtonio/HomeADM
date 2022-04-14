-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGALISTASPLD
DELIMITER ;
DROP TABLE IF EXISTS `CARGALISTASPLD`;DELIMITER $$

CREATE TABLE `CARGALISTASPLD` (
  `CargaListasID` int(11) NOT NULL COMMENT 'ID de la tabla de carga de listas',
  `TipoLista` varchar(3) NOT NULL COMMENT 'Indica el tipo de lista, a la que esta destinada la carga de datos\nLN .- Listas Negras \nLPB .- Listas de Personas Bloq.',
  `RutaArchivo` varchar(200) NOT NULL COMMENT 'Ruta donde se encuetra el archivo con extension .xls',
  `FechaCarga` date NOT NULL COMMENT 'Fecha de carga',
  `Estatus` varchar(1) NOT NULL COMMENT 'Indica el Estatus de carga del archivo para las listas PLD\nV.- Archivo valido, cargado con Exito\nI.- Archivo no valido, no fue cargado\nP.- Archivo en proceso de carga',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`CargaListasID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena la ubicacion de los archivos que se usaran para la carga masiva de listas PLD (Listas Negras y Listas de Pers. Bloq.) '$$