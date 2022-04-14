-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTOTALCAP
DELIMITER ;
DROP TABLE IF EXISTS `TMPTOTALCAP`;DELIMITER $$

CREATE TABLE `TMPTOTALCAP` (
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Calculo',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ClienteID',
  `SaldoCaptacion` decimal(14,2) DEFAULT NULL COMMENT 'Promedio Total Captacion Cliente',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus C.-Calculado P.-Pendiente',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Fecha`,`ClienteID`),
  KEY `IDX_TMPTOTALCAP_1` (`Fecha`),
  KEY `IDX_TMPTOTALCAP_2` (`ClienteID`),
  KEY `IDX_TMPTOTALCAP_3` (`NumTransaccion`),
  KEY `IDX_TMPTOTALCAP_4` (`Fecha`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Total Captacion por Periodo.'$$