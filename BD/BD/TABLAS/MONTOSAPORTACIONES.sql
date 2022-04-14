-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSAPORTACIONES
DELIMITER ;
DROP TABLE IF EXISTS `MONTOSAPORTACIONES`;DELIMITER $$

CREATE TABLE `MONTOSAPORTACIONES` (
  `TipoAportacionID` int(11) NOT NULL COMMENT 'PK Tipo de APORTACION',
  `MontoInferior` decimal(18,2) NOT NULL COMMENT 'PK Monto inferior ',
  `MontoSuperior` decimal(18,2) NOT NULL COMMENT 'PK Monto superior',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoAportacionID`,`MontoInferior`,`MontoSuperior`),
  CONSTRAINT `fk_MONTOSAPORTACIONES_1` FOREIGN KEY (`TipoAportacionID`) REFERENCES `TIPOSAPORTACIONES` (`TipoAportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el esquema de montos para las aportaciones.'$$