-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NIVELRIESCTEPLD
DELIMITER ;
DROP TABLE IF EXISTS `NIVELRIESCTEPLD`;DELIMITER $$

CREATE TABLE `NIVELRIESCTEPLD` (
  `NivelRiesgoID` int(11) NOT NULL COMMENT 'clave de nivel de riesgo',
  `Descripcion` varchar(30) DEFAULT NULL COMMENT 'Descripcion del nivel de riesgo cliente',
  `PeriodiciVisita` int(2) DEFAULT NULL COMMENT 'periodo de visitas periodicas programadas y verificación de operaciones\nmeses',
  `AntMinConFecEva` int(2) DEFAULT NULL COMMENT 'Antigüedad minima que debe tener el contrato a la fecha de evaluación en campo\nmeses',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`NivelRiesgoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de niveles de riesgo'$$