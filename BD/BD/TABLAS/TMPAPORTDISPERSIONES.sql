
-- TMPAPORTDISPERSIONES --

DELIMITER  ;
DROP TABLE IF EXISTS `TMPAPORTDISPERSIONES`;

DELIMITER  $$
CREATE TABLE `TMPAPORTDISPERSIONES` (
  `AportacionID` int(11) NOT NULL COMMENT 'ID de Aportación.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion.',
  `Estatus` char(1) DEFAULT 'P' COMMENT 'Estatus de la Dispersión.\nP.- Pendiente por Dispersar\nS.- Seleccionada\nD.- Dispersada',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID.',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo del Cliente.',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Capital.',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes.',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR.',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR .',
  `CuentaTranID` int(11) DEFAULT NULL COMMENT 'No consecutivo de cuentas transfer por cliente',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Institucion',
  `Nombre` varchar(100) DEFAULT NULL COMMENT 'Nombre de la Institucion',
  `TipoCuentaSpei` int(11) DEFAULT NULL COMMENT 'Tipo de cuenta SPEI.',
  `TipoCuentaDesc` varchar(100) DEFAULT NULL COMMENT 'Descripción del Tipo de cuenta SPEI.',
  `Clabe` varchar(20) DEFAULT NULL COMMENT 'Numero de Cuenta Clabe',
  `Beneficiario` varchar(100) DEFAULT NULL COMMENT 'Nombre del Beneficiario',
  `EsPrincipal` char(1) DEFAULT 'N' COMMENT 'Indica si la Cuenta Destino es Principal.\nS.- Si\nN.- No',
  `TotalBenef` int(11) DEFAULT '0' COMMENT 'Número total de Beneficiarios, no Cuentas Destino.',
  `MontoDispersion` decimal(18,2) DEFAULT '0.00' COMMENT 'Monto de la Dispersión por Beneficiario.',
  `TotalBenP` int(11) DEFAULT NULL COMMENT 'Número total de beneficiarios principal activa',
  `TotalBenNP` int(11) DEFAULT NULL COMMENT 'Número total de beneficiarios no principal activa',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `TieneBen` char(1) DEFAULT 'N' COMMENT 'Indica si tiene benef no principales.',
  `TipoAportacionID` int(11) DEFAULT '0',
  `CuentaAhoID` bigint(12) DEFAULT '0',
  `MontoPendiente` decimal(18,2) DEFAULT '0.00',
  `MontoTotalPendiente` decimal(18,2) DEFAULT '0.00',
  KEY `INDEX_TMPAPORTDISPERSIONES_1` (`AportacionID`),
  KEY `INDEX_TMPAPORTDISPERSIONES_2` (`AmortizacionID`),
  KEY `INDEX_TMPAPORTDISPERSIONES_3` (`ClienteID`),
  KEY `INDEX_TMPAPORTDISPERSIONES_4` (`InstitucionID`),
  KEY `INDEX_TMPAPORTDISPERSIONES_5` (`NumTransaccion`),
  KEY `INDEX_TMPAPORTDISPERSIONES_6` (`AportacionID`,`AmortizacionID`),
  KEY `INDEX_TMPAPORTDISPERSIONES_7` (`NumTransaccion`,`TotalBenef`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Lista de Dispersiones en Aportaciones.'$$
