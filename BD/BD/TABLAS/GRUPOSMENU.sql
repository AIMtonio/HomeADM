-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSMENU
DELIMITER ;
DROP TABLE IF EXISTS `GRUPOSMENU`;DELIMITER $$

CREATE TABLE `GRUPOSMENU` (
  `GrupoMenuID` int(11) NOT NULL COMMENT 'Grupo del Menu',
  `MenuID` int(11) NOT NULL COMMENT 'Id del Menu',
  `EmpresaID` varchar(45) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del\nGrupo',
  `Desplegado` varchar(45) NOT NULL COMMENT 'Desplegado a \nMostrar en el\nMenu',
  `Orden` varchar(45) NOT NULL COMMENT 'Orden del Grupo\n',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GrupoMenuID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Grupos del Menu de la Aplicacion'$$