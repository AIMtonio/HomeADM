-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ALGORITMODEPREF
DELIMITER ;
DROP TABLE IF EXISTS `ALGORITMODEPREF`;
DELIMITER $$


CREATE TABLE `ALGORITMODEPREF` (
  `AlgoritmoID` int(11) NOT NULL COMMENT 'ID de algoritmo',
  `InstitucionID` int(11) NOT NULL DEFAULT 999 COMMENT 'ID de la instucion asociada',
  `NombreAlgoritmo` varchar(100) NOT NULL COMMENT 'Nombre del algoritmo',
  `Procedimiento` varchar(100) NOT NULL COMMENT 'Nombre del procenimiento del algoritmo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Nombre de Usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual del Sistema',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa',
  `Sucursal` int(11) NOT NULL COMMENT 'Nombre de la Sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  PRIMARY KEY (`AlgoritmoID`),
  KEY `idx_ALGORITMODEPREF_1` (`Procedimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacenara Algoritmos para generar depositos referenciados'$$
