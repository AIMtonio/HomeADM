
-- APORTCONSOLIDADAS --

DELIMITER  ;
DROP TABLE IF EXISTS `APORTCONSOLIDADAS`;

DELIMITER  $$
CREATE TABLE `APORTCONSOLIDADAS` (
  `AportacionID` INT(11) NOT NULL COMMENT 'Número de la Aportación a Consolidar.',
  `AportConsID` INT(11) NOT NULL COMMENT 'Número de la Aportación Consolidada.',
  `FechaVencimiento` DATE NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Vencimiento de la Aportación Consolidada.',
  `Capital` DECIMAL(18,2) NULL DEFAULT 0.00 COMMENT 'Monto Capital de la Aportación Consolidada.',
  `Interes` DECIMAL(18,2) NULL DEFAULT 0.00 COMMENT 'Interés Generado de la Aportación Consolidada.',
  `ISR` DECIMAL(18,2) NULL DEFAULT 0.00 COMMENT 'Interés a Retener de la Aportación Consolidada.',
  `TotalAport` DECIMAL(18,2) NULL DEFAULT 0.00 COMMENT 'Monto Total de la Aportación Consolidada.\nMonto + Interes - ISR',
  `Reinvertir` CHAR(3) NULL DEFAULT '' COMMENT 'Tipo de Reinversión de la Aportación Consolidada.\nElegido desde Condiciones de Vencimiento.\nC: Sólo Capital\nCI: Capital + Intereses',
  `TotalCons` DECIMAL(18,2) NULL DEFAULT 0.00 COMMENT 'Monto Toal a Reinvertir de la Aportación Consolidada.\nDe acuerdo al campo Reinvertir.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  PRIMARY KEY (`AportacionID`, `AportConsID`),
  KEY `INDEX_APORTCONSOLIDADAS_1` (`AportacionID`),
  KEY `INDEX_APORTCONSOLIDADAS_2` (`AportConsID`)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Almacena las aportaciones de una Consolidación';$$