-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREVCRWRESFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `TMPREVCRWRESFONDEO`;

DELIMITER $$
CREATE TABLE `TMPREVCRWRESFONDEO` (
  `TmpID` int(11) DEFAULT NULL COMMENT 'Numero de Consecutivo.',
  `TranRespaldo` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion de respaldo',
  `SolFondeoID` bigint(20) DEFAULT NULL COMMENT 'ID del Fondeo Crowdfunding.',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Cuenta de Ahorro del Cliente o Inversionista',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `INDEX_TMPREVCRWRESFONDEO_1` (`TranRespaldo`),
  KEY `INDEX_TMPREVCRWRESFONDEO_2` (`NumTransaccion`),
  KEY `INDEX_TMPREVCRWRESFONDEO_3` (`TmpID`, `NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla de paso para la Reversa de Pago CRW.'$$
