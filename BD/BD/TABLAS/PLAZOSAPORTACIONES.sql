-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLAZOSAPORTACIONES
DELIMITER ;
DROP TABLE IF EXISTS `PLAZOSAPORTACIONES`;DELIMITER $$

CREATE TABLE `PLAZOSAPORTACIONES` (
  `TipoAportacionID` int(11) NOT NULL COMMENT 'Tipo de Aportacion',
  `PlazoInferior` int(11) NOT NULL COMMENT 'Plazo Inferior ',
  `PlazoSuperior` int(11) NOT NULL COMMENT 'Plazo Superior',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoAportacionID`,`PlazoInferior`,`PlazoSuperior`),
  CONSTRAINT `fk_PLAZOSAPORTACIONES_1` FOREIGN KEY (`TipoAportacionID`) REFERENCES `TIPOSAPORTACIONES` (`TipoAportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el esquema de plazos para las aportaciones.'$$