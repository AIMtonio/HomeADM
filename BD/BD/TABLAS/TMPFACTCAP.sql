-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFACTCAP
DELIMITER ;
DROP TABLE IF EXISTS `TMPFACTCAP`;DELIMITER $$

CREATE TABLE `TMPFACTCAP` (
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Calculo',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ClienteID',
  `InstrumentoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Número del Instrumento de Captación\n2.-Ahorro\n13.-Inversiones\n28.-CEDES',
  `ProductoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID de Cuenta, Inversión o CEDE.',
  `TotalFactor` decimal(14,4) DEFAULT NULL COMMENT 'Total del Factor de Captación.',
  `Diferencia` decimal(14,8) DEFAULT NULL COMMENT 'En caso de que el factor no sume exactamemte 1, se guarda la diferencia.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Fecha`,`ClienteID`),
  KEY `IDX_TMPTOTALCAP_1` (`Fecha`),
  KEY `IDX_TMPTOTALCAP_2` (`ClienteID`),
  KEY `IDX_TMPTOTALCAP_3` (`NumTransaccion`),
  KEY `IDX_TMPTOTALCAP_4` (`Fecha`,`NumTransaccion`),
  KEY `IDX_TMPTOTALCAP_5` (`Fecha`,`ClienteID`,`InstrumentoID`,`ProductoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Total Factor Captacion por Periodo.'$$