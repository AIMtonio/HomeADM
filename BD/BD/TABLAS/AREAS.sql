-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AREAS
DELIMITER ;
DROP TABLE IF EXISTS `AREAS`;DELIMITER $$

CREATE TABLE `AREAS` (
  `AreaID` bigint(20) NOT NULL COMMENT 'ID o clave del Area',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del Area',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`AreaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Areas Existentes en la Empresa'$$