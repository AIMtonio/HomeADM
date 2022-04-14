-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NGRAVEFALTASPLD
DELIMITER ;
DROP TABLE IF EXISTS `NGRAVEFALTASPLD`;DELIMITER $$

CREATE TABLE `NGRAVEFALTASPLD` (
  `NivGravedadID` char(2) NOT NULL COMMENT 'clave del nivel de gravedad en inconsistencias',
  `DescripCorta` varchar(20) DEFAULT NULL COMMENT 'descripcion corta del nivel de gravedad en inconsistencias encontradas',
  `DescripLarga` varchar(50) DEFAULT NULL COMMENT 'descripcion larga del nivel de gravedad en inconsistencias encontradas',
  `CambioNriesgo` int(1) DEFAULT NULL COMMENT 'numero de niveles de riesgo que se debe aumentar en automático\nsuma al nivel actual de riesgo',
  `Estatus` int(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`NivGravedadID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de niveles de gravedad en faltas o inconsistencias '$$