-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATEGORIAPTO
DELIMITER ;
DROP TABLE IF EXISTS `CATEGORIAPTO`;
DELIMITER $$


CREATE TABLE `CATEGORIAPTO` (
  `CategoriaID` int(11) NOT NULL COMMENT 'Clave del tipo de Categoria',
  `Descripcion` varchar(40) DEFAULT NULL COMMENT 'descripcion del tipo de categoria',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Categoria\nV=Vigente, \nB=Baja',
  `NivelJerarquia` int(11) NOT NULL COMMENT 'Define el nivel de los puestos donde el nivel con ID 1 sera el nivel de puesto mas alto, las categorias mayores a 1 seran los niveles inferiores, considerando el ID mayor como el nivel jerarquico mas bajo.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CategoriaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Categorias para los Puestos'$$