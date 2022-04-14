-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPROCEDIMIENTOS
DELIMITER ;
DROP TABLE IF EXISTS `CATPROCEDIMIENTOS`;DELIMITER $$

CREATE TABLE `CATPROCEDIMIENTOS` (
  `ProcedimientoID` int(11) NOT NULL COMMENT 'Identificador de procedimiento',
  `CliProEspID` int(11) NOT NULL COMMENT 'Identificador de cliente',
  `NomProc` varchar(30) NOT NULL COMMENT 'Nombre de Procedimiento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ProcedimientoID`,`CliProEspID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena informacion de los stores especificos.'$$