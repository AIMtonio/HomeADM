
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_APORTRECALEXT

DELIMITER ;
DROP TABLE IF EXISTS `TMP_APORTRECALEXT`;

DELIMITER $$
CREATE TABLE `TMP_APORTRECALEXT` (
  `AportacionID` int(11) NOT NULL COMMENT 'ID de la Aportación PK.',
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de operación.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario.',
  `ClienteID` int(11) NOT NULL COMMENT 'LLave Primaria para Identificar los Clientes\n',
  `PaisResidencia` int(11) DEFAULT NULL COMMENT 'Pais de Residencia, Llave Foranea Hacia tabla PAISES',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria.',
  `ExisteCambioISR` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`NumTransaccion`, `AportacionID`, `AmortizacionID`),
  KEY `INDEX_TMP_APORTRECALEXT_001`(`NumTransaccion`),
  KEY `INDEX_TMP_APORTRECALEXT_002`(`AportacionID`),
  KEY `INDEX_TMP_APORTRECALEXT_003`(`AmortizacionID`),
  KEY `INDEX_TMP_APORTRECALEXT_004`(`ClienteID`),
  KEY `INDEX_TMP_APORTRECALEXT_005`(`PaisResidencia`),
  KEY `INDEX_TMP_APORTRECALEXT_006`(`AportacionID`,`AmortizacionID`),
  KEY `INDEX_TMP_APORTRECALEXT_007`(`AportacionID`,`AmortizacionID`,`Fecha`),
  KEY `INDEX_TMP_APORTRECALEXT_008`(`NumTransaccion`,`ExisteCambioISR`,`Fecha`),
  KEY `INDEX_TMP_APORTRECALEXT_009`(`NumTransaccion`,`Fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal para actualización de calendarios de aportaciones extranjeras.'$$
