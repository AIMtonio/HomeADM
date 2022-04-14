-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCATMOTIVPREO
DELIMITER ;
DROP TABLE IF EXISTS `PLDCATMOTIVPREO`;DELIMITER $$

CREATE TABLE `PLDCATMOTIVPREO` (
  `CatMotivPreoID` varchar(15) NOT NULL COMMENT 'Clave del motivo de la operación preocupante',
  `DesCorta` varchar(50) DEFAULT NULL COMMENT 'descripcion corta del motivo de la operación preocupante',
  `DesLarga` varchar(500) DEFAULT NULL COMMENT 'descripcion larga del motivo de la operación preocupante',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del motivo de la operación preocupante\nV=Vigente, \nB=Baja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CatMotivPreoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de motivos de operaciones Internas Preocupantes'$$