
-- HISAPORTDISPERSIONES --

DELIMITER  ;
DROP TABLE IF EXISTS `HISAPORTDISPERSIONES`;

DELIMITER  $$
CREATE TABLE `HISAPORTDISPERSIONES` (
  `AportacionID` int(11) NOT NULL COMMENT 'ID de Aportación.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID.',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Número de la Cuenta.',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Capital.',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes.',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR.',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR .',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Dispersión.\nP.- Pendiente por Dispersar\nD.- Dispersada',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento.',
  `FechaDispersion` date DEFAULT NULL COMMENT 'Fecha en la que se realizó la Dispersión.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`AportacionID`,`AmortizacionID`),
  KEY `INDEX_HISAPORTDISPERSIONES_1` (`AportacionID`,`AmortizacionID`,`NumTransaccion`),
  KEY `INDEX_HISAPORTDISPERSIONES_2` (`NumTransaccion`),
  KEY `INDEX_HISAPORTDISPERSIONES_3` (`AportacionID`,`AmortizacionID`,`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='His: Dispersiones Procesadas de Aportaciones.'$$