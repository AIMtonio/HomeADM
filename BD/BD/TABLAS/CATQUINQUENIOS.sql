-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATQUINQUENIOS
DELIMITER ;
DROP TABLE IF EXISTS `CATQUINQUENIOS`;
DELIMITER $$


CREATE TABLE `CATQUINQUENIOS` (
  `QuinquenioID` int(11) NOT NULL COMMENT 'id de la tabla',
  `Descripcion` VARCHAR(100) DEFAULT NULL COMMENT 'Descripcion',
  `DescripcionCorta` VARCHAR(20) DEFAULT NULL COMMENT 'Descripcion corta',  
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`QuinquenioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catalogo de QUINQUENIOS'$$
