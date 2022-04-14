-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCATEDOSPREO
DELIMITER ;
DROP TABLE IF EXISTS `PLDCATEDOSPREO`;DELIMITER $$

CREATE TABLE `PLDCATEDOSPREO` (
  `CatEdosPreoID` int(11) NOT NULL COMMENT 'Clave del Estado de la operación preocupante',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'descripcion de estados de las operaciones preocupantes',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del motivo de la operación preocupante\nV=Vigente, \nB=Baja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CatEdosPreoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de estados de operaciones Internas Preocupantes'$$