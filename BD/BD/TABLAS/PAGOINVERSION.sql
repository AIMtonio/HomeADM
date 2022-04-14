-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOINVERSION
DELIMITER ;
DROP TABLE IF EXISTS `PAGOINVERSION`;
DELIMITER $$


CREATE TABLE `PAGOINVERSION` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `ConsecutivoID` int(11) DEFAULT NULL COMMENT 'Consecutivo ID',
  `InversionID` int(11) DEFAULT NULL COMMENT 'Parametro ID de la Inversion',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Parametro Cuenta de Ahorrro ligada a la Inversion',
  `TipoInversionID` int(11) DEFAULT NULL COMMENT 'Parametro Tipo de Inversion',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Parametro ID Moneda',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Parametro de Monto de la Inversion',
  `InteresGenerado` decimal(14,2) DEFAULT NULL COMMENT 'Parametro de Interes Generado de la Inversion',
  `InteresRetener` decimal(14,2) DEFAULT NULL COMMENT 'Parametro de Interes a Retener de la Inversion',
  `ISRReal` decimal(14,2) DEFAULT NULL COMMENT 'Parametro de ISR de la Inversion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Parametro Cliente ID de la Inversion',
  `SaldoProvision` decimal(14,2) DEFAULT NULL COMMENT 'Parametro Saldo Provision de la Inversion',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Parametro Sucursal',
  `FechaInicio` date DEFAULT NULL COMMENT 'Parametro Fecha de Inicio de la Inversion',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Parametro Fecha de Vencimiento de la Inversion',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  KEY `idx_PAGOINVERSION_1` (`InversionID`),
  KEY `idx_PAGOINVERSION_2` (`CuentaAhoID`),
  KEY `idx_PAGOINVERSION_3` (`ClienteID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que almacena los registros de las Inversiones'$$
