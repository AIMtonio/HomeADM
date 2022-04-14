-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDISPERSIONAPOR
DELIMITER ;
DROP TABLE IF EXISTS `TMPDISPERSIONAPOR`;
DELIMITER $$

CREATE TABLE `TMPDISPERSIONAPOR` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'ID de Aportación.',
  `NumReg` int(11) NOT NULL COMMENT 'ID de Aportación.',
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
  `AportBeneficiarioID` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Número ID de la tabla APORTBENEFICIARIOS.',
  `BloqueoID` int(11) DEFAULT '0' COMMENT 'Número de Bloqueo.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TransaccionID`,`NumReg`,`AportacionID`,`AmortizacionID`,`CuentaTranID`,`AportBeneficiarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla para guardar las dispersiones que se van por el módulo de Tesorería.'$$
