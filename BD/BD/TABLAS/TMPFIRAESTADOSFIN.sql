-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFIRAESTADOSFIN
DELIMITER ;
DROP TABLE IF EXISTS `TMPFIRAESTADOSFIN`;

DELIMITER $$
CREATE TABLE `TMPFIRAESTADOSFIN` (
  `ConsecutivoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Número consecutivo de los conceptos.',
  `ConceptoFinanID` int(11) NOT NULL COMMENT 'ID del Concepto Financiero',
  `CuentaContable` varchar(500) NOT NULL COMMENT 'Rango de Cuentas que Integran el Concepto Financiero',
  `NombreCampo` varchar(20) DEFAULT NULL COMMENT 'Nombre del Campo, para el select dinamico ',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`ConsecutivoID`,`ConceptoFinanID`,`NumTransaccion`),
  KEY `INDEX_TMPFIRAESTADOSFIN_1` (`ConsecutivoID`),
  KEY `INDEX_TMPFIRAESTADOSFIN_2` (`NumTransaccion`),
  KEY `INDEX_TMPFIRAESTADOSFIN_3` (`ConceptoFinanID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal Conceptos que Integran los Estados Financieros FIRA.'$$