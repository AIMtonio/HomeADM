-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEDOSFINFIRA
DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOSFINFIRA`;DELIMITER $$

CREATE TABLE `TMPEDOSFINFIRA` (
  `ConceptoFinanID` int(11) NOT NULL COMMENT 'ID del Concepto Financiero',
  `ConsecutivoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Número consecutivo de los conceptos.',
  `EsCalculado` char(1) DEFAULT NULL COMMENT 'Indica si es un Campo calculado(Con formulas)\nS .- SI\nN .- NO',
  `TipoCalculo` char(1) DEFAULT NULL COMMENT 'Indica si es una suma o resta\nS.- Suma\nR.- Resta',
  `NombreCampo` varchar(20) DEFAULT NULL COMMENT 'Nombre del Campo, para el select dinamico ',
  `Saldo` decimal(18,2) DEFAULT '0.00' COMMENT 'Saldo de la cuenta.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  KEY `TMPEDOSFINFIRA_IDX_1` (`ConsecutivoID`,`NumTransaccion`),
  KEY `TMPEDOSFINFIRA_IDX_2` (`NumTransaccion`,`EsCalculado`),
  KEY `TMPEDOSFINFIRA_IDX_3` (`NombreCampo`,`NumTransaccion`,`EsCalculado`),
  KEY `TMPEDOSFINFIRA_IDX_4` (`NumTransaccion`),
  KEY `TMPEDOSFINFIRA_IDX_5` (`ConceptoFinanID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos temporal de las cuenta que forman parte de una fórmula.'$$