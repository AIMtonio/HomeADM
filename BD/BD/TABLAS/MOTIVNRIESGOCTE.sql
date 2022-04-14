-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOTIVNRIESGOCTE
DELIMITER ;
DROP TABLE IF EXISTS `MOTIVNRIESGOCTE`;DELIMITER $$

CREATE TABLE `MOTIVNRIESGOCTE` (
  `MotivoNRiesgoID` char(3) NOT NULL COMMENT 'clave de motivos de nivel de riesgo',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion de motivos del nivel de riesgo cliente',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MotivoNRiesgoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de motivos de la asignacion de nivel de riesgo'$$