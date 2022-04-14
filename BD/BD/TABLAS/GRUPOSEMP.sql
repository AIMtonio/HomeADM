-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSEMP
DELIMITER ;
DROP TABLE IF EXISTS `GRUPOSEMP`;DELIMITER $$

CREATE TABLE `GRUPOSEMP` (
  `GrupoEmpID` int(11) NOT NULL COMMENT 'Numero de Grupo',
  `EmpresaID` int(11) DEFAULT NULL,
  `NombreGrupo` varchar(100) NOT NULL COMMENT 'Nombre del Grupo',
  `Observacion` varchar(200) NOT NULL COMMENT 'Observaciones',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GrupoEmpID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Grupos Empresariales'$$