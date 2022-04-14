-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IMPUESTOSCARGAMASIVA
DELIMITER ;
DROP TABLE IF EXISTS `IMPUESTOSCARGAMASIVA`;
DELIMITER $$

CREATE TABLE `IMPUESTOSCARGAMASIVA` (
  `ImpuestoID` INT(11) NOT NULL COMMENT 'Id del impuesto en relacion al catalogo IMPUESTOS',
  `Descripcion` VARCHAR(70) DEFAULT NULL COMMENT 'Descripcion completa del impuesto en relacion al catalogo IMPUESTOS',
  `DescripCorta` VARCHAR(20) DEFAULT NULL COMMENT 'Descripcion Corta en relacion al catalogo IMPUESTOS',
  PRIMARY KEY (ImpuestoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Configuracion de tipos de impuestos para el proceso de carga masiva de facturas'$$