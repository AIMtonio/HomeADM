-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCATMOTIVINU
DELIMITER ;
DROP TABLE IF EXISTS `PLDCATMOTIVINU`;DELIMITER $$

CREATE TABLE `PLDCATMOTIVINU` (
  `CatMotivInuID` varchar(15) NOT NULL COMMENT 'Clave del motivo de la operación preocupante',
  `DesCorta` varchar(50) DEFAULT NULL COMMENT 'descripcion corta del motivo de la operación preocupante',
  `DesLarga` varchar(500) DEFAULT NULL COMMENT 'descripcion larga del motivo de la operación preocupante',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del motivo de la operación preocupante\nV=Vigente, \nB=Baja',
  `Mostrar` char(1) DEFAULT NULL COMMENT 'Determina si el motivo de la op. inusual se muestra en pantalla. (Listas).\nS.- Si se muestra\nN.- No se muestra',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CatMotivInuID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de motivos de operaciones Internas Preocupantes'$$