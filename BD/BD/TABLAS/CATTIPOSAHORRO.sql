-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOSAHORRO
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOSAHORRO`;DELIMITER $$

CREATE TABLE `CATTIPOSAHORRO` (
  `TipoAhorroID` int(11) NOT NULL COMMENT 'PK Tipos de Ahorro',
  `CatParamRiesgosID` int(11) DEFAULT NULL COMMENT 'ID del catalogo de Parametros de Riesgos CATPARAMRIESGOS',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion de tipos de ahorro',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoAhorroID`),
  KEY `fk_CATTIPOSAHORRO_1_idx` (`CatParamRiesgosID`),
  CONSTRAINT `fk_CATTIPOSAHORRO_1` FOREIGN KEY (`CatParamRiesgosID`) REFERENCES `CATPARAMRIESGOS` (`CatParamRiesgosID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo Tipos de Ahorro'$$