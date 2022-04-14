-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIATMENC
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCONCIATMENC`;DELIMITER $$

CREATE TABLE `TARDEBCONCIATMENC` (
  `ConciliaATMID` int(11) NOT NULL COMMENT 'PK de la tabla',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha del Archivo STAT (DDMMAA)',
  `Codigo` varchar(12) DEFAULT NULL COMMENT 'Codigo de archivo cargado',
  `TotalTransac` int(11) DEFAULT NULL COMMENT 'Numero Total de Transacciones en el archivo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(40) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConciliaATMID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Encabezado del archivo STAT de Conciliacion de Transacciones de Cajeros ATM '$$