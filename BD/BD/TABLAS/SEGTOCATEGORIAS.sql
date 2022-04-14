-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCATEGORIAS
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOCATEGORIAS`;DELIMITER $$

CREATE TABLE `SEGTOCATEGORIAS` (
  `CategoriaID` int(11) NOT NULL COMMENT 'Identificador de la Categoria',
  `TipoGestionID` int(11) DEFAULT NULL COMMENT 'ID del tipo de Gestoria al que pertenece la Categoria, \nFK TIPOGESTION',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion de la Categoria	',
  `NombreCorto` varchar(45) DEFAULT NULL COMMENT 'Nombre Corto de la Categoria',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Categoria V.- Vigente, C.- Cancelado\n',
  `TipoCobranza` char(1) DEFAULT NULL COMMENT 'Indica si la categoría compete cobranza\nS - Si\nN - No',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CategoriaID`),
  KEY `fk_SEGTOCATEGORIAS_1_idx` (`TipoGestionID`),
  CONSTRAINT `fk_SEGTOCATEGORIAS_1` FOREIGN KEY (`TipoGestionID`) REFERENCES `TIPOGESTION` (`TipoGestionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Categorias de Seguimiento'$$