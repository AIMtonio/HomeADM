-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATFRECUENCIAS
DELIMITER ;
DROP TABLE IF EXISTS `CATFRECUENCIAS`;DELIMITER $$

CREATE TABLE `CATFRECUENCIAS` (
  `FrecuenciaID` char(1) NOT NULL COMMENT 'Letra de Frecuencia',
  `Orden` int(11) NOT NULL COMMENT 'Orden para los combos',
  `Dias` int(11) DEFAULT NULL COMMENT 'Numero de dias de la frecuencia',
  `DescSingular` varchar(20) DEFAULT NULL COMMENT 'Descripción singular',
  `DescPlural` varchar(20) DEFAULT NULL COMMENT 'Descripcion plurar',
  `DescInfinitivo` varchar(20) DEFAULT NULL COMMENT 'Descripcion en infinitivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FrecuenciaID`),
  UNIQUE KEY `FrecuenciaID_UNIQUE` (`FrecuenciaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Frecuencias'$$