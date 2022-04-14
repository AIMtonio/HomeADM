-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRONRIESGCTEPLD
DELIMITER ;
DROP TABLE IF EXISTS `PRONRIESGCTEPLD`;DELIMITER $$

CREATE TABLE `PRONRIESGCTEPLD` (
  `ProNriesgoCteID` char(3) NOT NULL COMMENT 'clave de proceso que generan cambio de nivel de riesgo',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'descripcion de proceso que generan cambio de nivel de riesgo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProNriesgoCteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de procesos que asignan nivel de riesgo'$$