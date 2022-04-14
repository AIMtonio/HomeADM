
-- TMPAPORTDISPROC --

DELIMITER  ;
DROP TABLE IF EXISTS `TMPAPORTDISPROC`;

DELIMITER  $$
CREATE TABLE `TMPAPORTDISPROC` (
  `AportacionID` int(11) NOT NULL COMMENT 'ID de Aportación.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion.',
  `TMPID` int(11) NOT NULL COMMENT 'Consecutivo.',
  `CuentaTranID` int(11) NOT NULL COMMENT 'No consecutivo de cuentas transfer por cliente.',
  `TipoPago` int(2) DEFAULT NULL COMMENT 'Tipo de Pago SPEI.',
  `CuentaAho` bigint(12) DEFAULT NULL COMMENT 'Número de la cuenta de ahorro.',
  `TipoCuentaOrd` int(2) DEFAULT NULL COMMENT 'Tipo de Cuenta Ordenante.',
  `CuentaOrd` varchar(20) DEFAULT NULL COMMENT 'Núm de Cuenta Ordenante.',
  `NombreOrd` varchar(100) DEFAULT NULL COMMENT 'Nombre del Ordenante.',
  `RFCOrd` varchar(18) DEFAULT NULL COMMENT 'RFC del Ordenante.',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'ID de la Moneda de la Cuenta del Ord.',
  `TipoOperacion` int(2) DEFAULT NULL COMMENT 'Tipo de Operacion.',
  `MontoTransferir` decimal(16,2) DEFAULT NULL COMMENT 'Monto a transferir.',
  `IVAPorPagar` decimal(16,2) DEFAULT NULL COMMENT 'IVA',
  `ComisionTrans` decimal(16,2) DEFAULT NULL COMMENT 'Comisión transferencia.',
  `IVAComision` decimal(16,2) DEFAULT NULL COMMENT 'IVA Comisión.',
  `TotalCargoCuenta` decimal(18,2) DEFAULT NULL COMMENT 'Total de cargo a cta.',
  `InstiReceptora` int(5) DEFAULT NULL COMMENT 'ID de la Institución Receptora.',
  `CuentaBeneficiario` varchar(20) DEFAULT NULL COMMENT 'Núm. de la Cuenta del Beneficiario.',
  `NombreBeneficiario` varchar(100) DEFAULT NULL COMMENT 'Nombre Beneficiario.',
  `RFCBeneficiario` varchar(18) DEFAULT NULL COMMENT 'RFC Beneficiario.',
  `TipoCuentaBen` int(2) DEFAULT NULL COMMENT 'Tipo de Cuenta Beneficiario.',
  `ConceptoPago` varchar(40) DEFAULT NULL COMMENT 'Concepto de Pago.',
  `CuentaBenefiDos` varchar(20) DEFAULT NULL COMMENT 'Núm. de la Cuenta del Beneficiario 2.',
  `NombreBenefiDos` varchar(100) DEFAULT NULL COMMENT 'Nombre Beneficiario 2.',
  `RFCBenefiDos` varchar(18) DEFAULT NULL COMMENT 'RFC Beneficiario 2.',
  `TipoCuentaBenDos` int(2) DEFAULT NULL COMMENT 'Tipo de Cuenta Beneficiario 2.',
  `ConceptoPagoDos` varchar(40) DEFAULT NULL COMMENT 'Concepto de Pago 2.',
  `ReferenciaCobranza` varchar(40) DEFAULT NULL COMMENT 'Referencia de Cobranza.',
  `ReferenciaNum` int(7) DEFAULT NULL COMMENT 'Referencia Numérica.',
  `UsuarioEnvio` varchar(30) DEFAULT NULL COMMENT 'Nombre del USuario de Envío.',
  `AreaEmiteID` int(2) DEFAULT NULL COMMENT 'Área de Emisión.',
  `OrigenOperacion` char(1) DEFAULT NULL COMMENT 'Origen Aportacion.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `AportBeneficiarioID` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Número ID de la tabla APORTBENEFICIARIOS.',
  PRIMARY KEY (`AportacionID`,`AmortizacionID`,`TMPID`),
  KEY `INDEX_TMPAPORTDISPROC_1` (`NumTransaccion`),
  KEY `INDEX_TMPAPORTDISPROC_2` (`AportacionID`,`AmortizacionID`,`NumTransaccion`),
  KEY `INDEX_TMPAPORTDISPROC_3` (`AportacionID`,`AmortizacionID`,`TMPID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Dispersiones a Procesar SPEI en Aportaciones.'$$