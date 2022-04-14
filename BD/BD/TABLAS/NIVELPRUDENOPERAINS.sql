-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NIVELPRUDENOPERAINS
DELIMITER ;
DROP TABLE IF EXISTS `NIVELPRUDENOPERAINS`;DELIMITER $$

CREATE TABLE `NIVELPRUDENOPERAINS` (
  `NivelPrudOperaID` int(11) NOT NULL COMMENT 'Consecutivo de los registros',
  `Anio` int(11) NOT NULL COMMENT 'Anio de registro de la clave de nivel Prudencial y operacion',
  `Mes` int(11) NOT NULL COMMENT 'Anio de registro de la clave de nivel Prudencial y operacion',
  `ClaveNivInstitucion` varchar(6) NOT NULL COMMENT 'Clave del nivel Prudencial y operacion',
  `FechaPeriodo` date DEFAULT NULL COMMENT 'Fecha en que se registra la clave',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usario ID',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`NivelPrudOperaID`),
  KEY `index1` (`Anio`),
  KEY `index2` (`Mes`),
  KEY `fk_NIVELPRUDENOPERAINS_1_idx` (`ClaveNivInstitucion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda el registro de las actualizaciones de la clave de nivel institucion'$$