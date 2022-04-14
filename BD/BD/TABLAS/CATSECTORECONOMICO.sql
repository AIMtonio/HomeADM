-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATSECTORECONOMICO
DELIMITER ;
DROP TABLE IF EXISTS `CATSECTORECONOMICO`;DELIMITER $$

CREATE TABLE `CATSECTORECONOMICO` (
  `SectorEcoID` int(11) NOT NULL COMMENT 'PK Sector Economico',
  `CatParamRiesgosID` int(11) DEFAULT NULL COMMENT 'ID del catalogo de Parametros de Riesgos CATPARAMRIESGOS',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion Sector Economico',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SectorEcoID`),
  KEY `fk_CATSECTORECONOMICO_1_idx` (`CatParamRiesgosID`),
  CONSTRAINT `fk_CATSECTORECONOMICO_1` FOREIGN KEY (`CatParamRiesgosID`) REFERENCES `CATPARAMRIESGOS` (`CatParamRiesgosID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo Sectores Economicos'$$