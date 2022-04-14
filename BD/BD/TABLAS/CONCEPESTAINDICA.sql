-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPESTAINDICA
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPESTAINDICA`;DELIMITER $$

CREATE TABLE `CONCEPESTAINDICA` (
  `ConEstadisIndID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla',
  `TipoIndicador` varchar(300) DEFAULT NULL COMMENT 'Tipo de indicador',
  `Descripcion` varchar(300) DEFAULT NULL COMMENT 'Descripcion del indicador',
  `Formula` varchar(300) DEFAULT NULL COMMENT 'Formula para calcular el indicador',
  PRIMARY KEY (`ConEstadisIndID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los conceptos para Indicadores'$$