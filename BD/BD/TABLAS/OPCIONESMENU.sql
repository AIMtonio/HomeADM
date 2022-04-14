-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESMENU
DELIMITER ;
DROP TABLE IF EXISTS `OPCIONESMENU`;DELIMITER $$

CREATE TABLE `OPCIONESMENU` (
  `OpcionMenuID` int(11) NOT NULL COMMENT 'Opcion del Menu',
  `GrupoMenuID` int(11) NOT NULL COMMENT 'Grupo del MEnu\nal que pertenece\nla Opcion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Id de la Empresa',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion',
  `Desplegado` varchar(50) NOT NULL COMMENT 'Leyenda o\nDesplegado a\nMostar en le Menu',
  `Recurso` varchar(45) NOT NULL COMMENT 'Recurso o Nombre\nde la Pagina',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden de la \nOpcion dentro\ndel Grupo y a \nSu vez del Menu',
  `RequiereCajero` char(1) DEFAULT NULL COMMENT 'S .- Si requiere Cajero\nN .- No requiere Cajero',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`OpcionMenuID`),
  KEY `idx_OPCIONESMENU_1` (`Recurso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Opciones o Pantallas del\nMenu de la Aplicacion'$$