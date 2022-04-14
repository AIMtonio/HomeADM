-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCRWREVERSAFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCRWREVERSAFONDEO`;
DELIMITER $$
CREATE TABLE `TMPCRWREVERSAFONDEO` (
  `TmpID` bigint(20) DEFAULT NULL COMMENT 'Consecutivo ID.',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente o ID, del Inversionista o  Fondeador.',
  `MontoFondeo` decimal(12,2) NOT NULL COMMENT 'Monto del Fondeo.',
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda.',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Cuenta de Ahorro del Cliente o Inversionista.',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'No de Sucursal a la que pertenece el cliente.',
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Número de Solicitud de Fondeo.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  KEY `INDEX_TMPCRWREVERSAFONDEO_1` (`TmpID`,`NumTransaccion`),
  KEY `INDEX_TMPCRWREVERSAFONDEO_2` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal de paso para la reversa de Fondeos Crowdfunding.'$$
