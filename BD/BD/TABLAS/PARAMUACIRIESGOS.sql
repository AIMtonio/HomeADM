-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMUACIRIESGOS
DELIMITER ;
DROP TABLE IF EXISTS `PARAMUACIRIESGOS`;DELIMITER $$

CREATE TABLE `PARAMUACIRIESGOS` (
  `ParamRiesgosID` int(11) NOT NULL COMMENT 'PK Parametros de Riesgos',
  `CatParamRiesgosID` int(11) DEFAULT NULL COMMENT 'FK de Catalogo de Parametros de Riesgos',
  `ReferenciaID` int(11) DEFAULT NULL,
  `Descripcion` varchar(200) DEFAULT NULL,
  `Porcentaje` decimal(10,2) DEFAULT NULL COMMENT 'Porcentaje',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ParamRiesgosID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros de Riesgos'$$