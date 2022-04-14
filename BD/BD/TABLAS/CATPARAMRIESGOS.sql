-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPARAMRIESGOS
DELIMITER ;
DROP TABLE IF EXISTS `CATPARAMRIESGOS`;DELIMITER $$

CREATE TABLE `CATPARAMRIESGOS` (
  `CatParamRiesgosID` int(11) NOT NULL COMMENT 'ID del Parametro de Riesgos',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion del Parametro de Riestos',
  `Dinamico` char(1) DEFAULT NULL COMMENT 'Es Dinamico: S=Si N=No',
  `Encabezado` varchar(200) DEFAULT NULL COMMENT 'Encabezado del Parametro de Riesgo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CatParamRiesgosID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Parametros de Riesgos'$$