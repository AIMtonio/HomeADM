-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCONCEPTOSINVFIRA
DELIMITER ;
DROP TABLE IF EXISTS `TMPCONCEPTOSINVFIRA`;DELIMITER $$

CREATE TABLE `TMPCONCEPTOSINVFIRA` (
  `ConsecutivoID` int(11) DEFAULT NULL COMMENT 'Número consecutivo.',
  `ConceptoFiraID` int(11) DEFAULT NULL COMMENT 'ID del concepto de inversión.',
  `TipoRecurso` char(2) DEFAULT NULL COMMENT 'Tipo de recurso.',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion del concepto.',
  `DescripcionBold` varchar(150) DEFAULT 'false' COMMENT 'Indica si la etiqueta será negrita.',
  `NoUnidades` varchar(150) DEFAULT NULL COMMENT 'Número de unidades.',
  `Unidad` varchar(150) DEFAULT NULL COMMENT 'Unidad del concepto.',
  `UnidadBold` varchar(150) DEFAULT 'false' COMMENT 'Indica si la etiqueta será negrita.',
  `UnidadAlingn` varchar(150) DEFAULT 'CENTER' COMMENT 'Alineación de la etiqueta.',
  `UnidadBorderLeft` varchar(150) DEFAULT '1' COMMENT 'Borde izquierdo de la celda.',
  `Monto` varchar(150) DEFAULT '' COMMENT 'Monto con formato moneda.',
  `MontoDecimal` decimal(18,2) DEFAULT '0.00' COMMENT 'Monto en decimal.',
  `MontoBold` varchar(150) DEFAULT 'false' COMMENT 'Indica si el monto será negrita',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número del crédito.',
  KEY `IDX_TMPCONCEPTOSINVFIRA_1` (`CreditoID`),
  KEY `IDX_TMPCONCEPTOSINVFIRA_2` (`ConsecutivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Temporal para conceptos de inversión en contratos agro.'$$