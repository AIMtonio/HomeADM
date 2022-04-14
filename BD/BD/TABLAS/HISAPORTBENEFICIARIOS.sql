
-- HISAPORTBENEFICIARIOS --

DELIMITER  ;
DROP TABLE IF EXISTS `HISAPORTBENEFICIARIOS`;

DELIMITER  $$
CREATE TABLE `HISAPORTBENEFICIARIOS` (
  `HisBenefID` bigint(20) NOT NULL COMMENT 'ID Histórico de Beneficiarios.',
  `AportacionID` int(11) NOT NULL COMMENT 'ID de Aportación.',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion.',
  `CuentaTranID` int(11) NOT NULL COMMENT 'No consecutivo de cuentas transfer por cliente.',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Institucion Participante SPEI.',
  `TipoCuentaSpei` int(2) DEFAULT NULL COMMENT 'Tipo de Cuenta de Envio para SPEI (TIPOSCUENTASPEI).',
  `Clabe` varchar(20) DEFAULT NULL COMMENT 'Numero de Cuenta para Envío SPEI.',
  `Beneficiario` varchar(100) DEFAULT NULL COMMENT 'Nombre del Beneficiario.',
  `EsPrincipal` char(1) DEFAULT 'N' COMMENT 'Indica si la Cuenta Destino es Principal.\nS.- Si\nN.- No',
  `MontoDispersion` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la Dispersión por Beneficiario.',
  `ClaveDispMov` int(11) DEFAULT NULL COMMENT 'Clave de la dispersión corresponde a la tabla DISPERSIONMOV',
  `TipoBaja` int(11) DEFAULT '0' COMMENT 'Tipo de Baja 01 Pantalla 02 Disperson',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  PRIMARY KEY (`HisBenefID`),
  KEY `INDEX_HISAPORTBENEFICIARIOS_1` (`AportacionID`,`AmortizacionID`,`CuentaTranID`),
  KEY `INDEX_HISAPORTBENEFICIARIOS_2` (`InstitucionID`),
  KEY `INDEX_HISAPORTBENEFICIARIOS_3` (`AportacionID`,`AmortizacionID`,`NumTransaccion`),
  KEY `INDEX_HISAPORTBENEFICIARIOS_4` (`TipoCuentaSpei`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='His: Beneficiarios de las Dispersiones SPEI para Aportaciones.'$$