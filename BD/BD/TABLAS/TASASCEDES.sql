-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASCEDES
DELIMITER ;
DROP TABLE IF EXISTS `TASASCEDES`;DELIMITER $$

CREATE TABLE `TASASCEDES` (
  `TasaCedeID` int(11) NOT NULL COMMENT 'ID y consecutivo de la tabla',
  `TipoCedeID` int(11) NOT NULL COMMENT 'Tipo de Cede.',
  `MontoInferior` decimal(18,2) NOT NULL COMMENT 'Fk de la tabla de MONTOCEDES',
  `MontoSuperior` decimal(18,2) NOT NULL COMMENT 'Fk de la tabla de MONTOCEDES',
  `PlazoInferior` int(11) NOT NULL COMMENT 'Fk de la tabla de PLAZOSCEDES',
  `PlazoSuperior` int(11) NOT NULL COMMENT 'Fk de la tabla de PLAZOSCEDES',
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
  PRIMARY KEY (`TipoCedeID`,`MontoInferior`,`MontoSuperior`,`PlazoInferior`,`PlazoSuperior`,`TasaCedeID`,`Calificacion`),
  KEY `fk_PLAZOSCEDES_idx` (`TipoCedeID`,`PlazoInferior`,`PlazoSuperior`),
  KEY `fk_MONTOSCEDES` (`TipoCedeID`,`MontoInferior`,`MontoSuperior`),
  KEY `fk_TASASCEDES_1_idx` (`TasaBase`),
  CONSTRAINT `fk_MONTOSCEDES` FOREIGN KEY (`TipoCedeID`, `MontoInferior`, `MontoSuperior`) REFERENCES `MONTOSCEDES` (`TipoCedeID`, `MontoInferior`, `MontoSuperior`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PLAZOSCEDES` FOREIGN KEY (`TipoCedeID`, `PlazoInferior`, `PlazoSuperior`) REFERENCES `PLAZOSCEDES` (`TipoCedeID`, `PlazoInferior`, `PlazoSuperior`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el esquema de tasas para las cedes.'$$