-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESROL
DELIMITER ;
DROP TABLE IF EXISTS `OPCIONESROL`;DELIMITER $$

CREATE TABLE `OPCIONESROL` (
  `RolID` int(11) NOT NULL COMMENT 'RolID :clave foranea con tabla ROLES\n\n ',
  `OpcionMenuID` varchar(50) NOT NULL COMMENT 'OpcionMenuID:clave foranea con tabla OPCIONESMENU\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_rol` (`RolID`),
  KEY `fk_opcionMenu` (`OpcionMenuID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$