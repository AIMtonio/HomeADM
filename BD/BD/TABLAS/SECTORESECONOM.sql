-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SECTORESECONOM
DELIMITER ;
DROP TABLE IF EXISTS `SECTORESECONOM`;DELIMITER $$

CREATE TABLE `SECTORESECONOM` (
  `SectorEcoID` int(11) NOT NULL COMMENT 'ID o Numero de Sector Economico',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripción del Sector',
  `Calificacion` char(2) NOT NULL COMMENT 'Calificacion Segun Analista\n',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SectorEcoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Sectores Economicos'$$