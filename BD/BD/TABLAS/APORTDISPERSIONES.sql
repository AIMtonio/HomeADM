
-- APORTDISPERSIONES --

DELIMITER  ;
DROP TABLE IF EXISTS `APORTDISPERSIONES`;

DELIMITER  $$
CREATE TABLE `APORTDISPERSIONES` (
  `AportacionID` int(11) NOT NULL COMMENT 'ID de Aportación.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID.',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Número de la Cuenta.',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Capital.',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes.',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR.',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR .',
  `Beneficiarios` char(1) DEFAULT 'N' COMMENT 'Indica si la Dsipersión cuenta con Beneficiarios Capturados.\nS.- Sí\nN.- No.',
  `Estatus` char(1) DEFAULT 'P' COMMENT 'Estatus de la Dispersión.\nP.- Pendiente por Dispersar\nS.- Seleccionada\nD.- Dispersada',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento.',
  `CuentaTranID` int(11) DEFAULT NULL COMMENT 'No consecutivo de cuentas transfer por cliente',
  `MontoPendiente` decimal(18,2) DEFAULT '0.00',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`AportacionID`,`AmortizacionID`),
  KEY `INDEX_APORTDISPERSIONES_1` (`ClienteID`),
  KEY `INDEX_APORTDISPERSIONES_2` (`CuentaAhoID`),
  KEY `INDEX_APORTDISPERSIONES_3` (`ClienteID`,`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Dispersiones de Aportaciones.'$$