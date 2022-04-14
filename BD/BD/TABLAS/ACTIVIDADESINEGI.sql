-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVIDADESINEGI
DELIMITER ;
DROP TABLE IF EXISTS `ACTIVIDADESINEGI`;DELIMITER $$

CREATE TABLE `ACTIVIDADESINEGI` (
  `ActividadINEGIID` int(11) NOT NULL COMMENT 'ID o Numero de Actividad INEGI\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'No. Empresa\n',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripción de la Actividad\n',
  `SectorEcoID` int(11) DEFAULT NULL COMMENT 'Sector Economico\n',
  `Clave` int(3) DEFAULT NULL COMMENT 'Clave de la Actividad\n',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ActividadINEGIID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Actividades Segun el INEGI'$$