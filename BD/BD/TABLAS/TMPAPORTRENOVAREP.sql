-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAPORTRENOVAREP
DELIMITER ;
DROP TABLE IF EXISTS `TMPAPORTRENOVAREP`;
DELIMITER $$

CREATE TABLE `TMPAPORTRENOVAREP` (
  `AportacionID` int(11) NOT NULL COMMENT 'ID de la Aportación.',
  `ClienteID` int(11) NOT NULL COMMENT 'LLave Primaria para Identificar los Clientes\n',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `PlazoOriginal` int(11) DEFAULT NULL COMMENT 'Plazo Original de la Aportación.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de inicio de la Aportación.',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de vencimiento.',
  `MontoRenovacion` decimal(18,2) DEFAULT '0.00' COMMENT 'Monto Renovación',
  `TasaFija` decimal(14,4) DEFAULT NULL COMMENT 'tasa fija.',
  `TasaBruta` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Bruta de la aportacion',
  `EstatusRenovacion` varchar(20) DEFAULT '' COMMENT 'Estatus de la Renovación.',
  `AportacionRenovada` int(11) DEFAULT '0' COMMENT 'Numero de Aportación que Fue Renovada.',
  `Motivo` varchar(500) DEFAULT '' COMMENT 'Motivo por el cual No se Renovó la Aportación.',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  `TipoRenovacion` VARCHAR(30) NULL COMMENT 'Indicara el Tipo Renovacion:\nCapital\nCapital + Interes',
  `TipoDocumento` VARCHAR(30) NULL COMMENT 'Indica Tipo de Aportación\n- Renovación\n- Renovación con -\n- Renovación con +\n- Consolidación',
  `TipoInteres` VARCHAR(30) NULL COMMENT 'Tipo de Interes:\n- Capitalizable\n- Mensual\n- Al vencimiento',
  PRIMARY KEY (`AportacionID`,`NumTransaccion`),
  KEY `INDEX_TMPAPORTRENOVAREP_1` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Reporte de Aportaciones Renovadas.'$$