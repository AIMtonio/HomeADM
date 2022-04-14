-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAPORTACIONES
DELIMITER ;
DROP TABLE IF EXISTS `TASASAPORTACIONES`;DELIMITER $$

CREATE TABLE `TASASAPORTACIONES` (
  `TasaAportacionID` int(11) NOT NULL COMMENT 'ID y consecutivo de la tabla',
  `TipoAportacionID` int(11) NOT NULL COMMENT 'Tipo de Aportacion.',
  `MontoInferior` decimal(18,2) NOT NULL COMMENT 'Fk de la tabla de MONTOSAPORTACIONES',
  `MontoSuperior` decimal(18,2) NOT NULL COMMENT 'Fk de la tabla de MONTOSAPORTACIONES',
  `PlazoInferior` int(11) NOT NULL COMMENT 'Fk de la tabla de PLAZOSAPORTACIONES',
  `PlazoSuperior` int(11) NOT NULL COMMENT 'Fk de la tabla de PLAZOSAPORTACIONES',
  `Calificacion` char(1) NOT NULL COMMENT 'Calificacion del cliente  N:NO ASIGNADA A:EXCELENTE  B:BUENA C:REGULAR',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Tasa Fija ',
  `TasaBase` int(11) DEFAULT NULL COMMENT 'Valor de la tasa Base',
  `SobreTasa` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Sobre Tasa',
  `PisoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Valor del Piso Tasa',
  `TechoTasa` decimal(12,4) DEFAULT NULL COMMENT 'Valor del Techo Tasa',
  `CalculoInteres` int(11) DEFAULT NULL COMMENT 'Calculo de interes ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoAportacionID`,`MontoInferior`,`MontoSuperior`,`PlazoInferior`,`PlazoSuperior`,`TasaAportacionID`,`Calificacion`),
  KEY `fk_PLAZOSAPORTACIONES_idx` (`TipoAportacionID`,`PlazoInferior`,`PlazoSuperior`),
  KEY `fk_MONTOSAPORTACIONES` (`TipoAportacionID`,`MontoInferior`,`MontoSuperior`),
  KEY `fk_TASASAPORTACIONES_1_idx` (`TasaBase`),
  CONSTRAINT `fk_MONTOSAPORTACIONES` FOREIGN KEY (`TipoAportacionID`, `MontoInferior`, `MontoSuperior`) REFERENCES `MONTOSAPORTACIONES` (`TipoAportacionID`, `MontoInferior`, `MontoSuperior`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PLAZOSAPORTACIONES` FOREIGN KEY (`TipoAportacionID`, `PlazoInferior`, `PlazoSuperior`) REFERENCES `PLAZOSAPORTACIONES` (`TipoAportacionID`, `PlazoInferior`, `PlazoSuperior`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el esquema de tasas para las aportaciones.'$$