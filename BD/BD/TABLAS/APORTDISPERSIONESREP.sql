-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTDISPERSIONESREP
DELIMITER ;
DROP TABLE IF EXISTS `APORTDISPERSIONESREP`;
DELIMITER $$

 CREATE TABLE `APORTDISPERSIONESREP` (
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Número de la Cuenta.',
  `AportacionID` int(11) DEFAULT NULL COMMENT 'ID de Aportación.',
  `AmortizacionID` int(11) DEFAULT '0' COMMENT 'Id de la Amortizacion.',
  `CuentaTranID` int(11) DEFAULT NULL COMMENT 'No consecutivo de cuentas transfer por cliente.',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID.',
  `NombreAportante` varchar(100) DEFAULT NULL COMMENT 'Nombre del Aportante.',
  `PromotorID` int(11) DEFAULT NULL COMMENT 'ID de Promotor.',
  `NombrePromotor` varchar(100) DEFAULT NULL COMMENT 'Nombre del Aportante.',
  `FechaCorte` date DEFAULT NULL COMMENT 'Fecha de Corte.',
  `NumAportaciones` int(11) DEFAULT NULL COMMENT 'ID de Aportación.',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Capital.',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes.',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR.',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total Capital + Interes - ISR .',
  `MontoDispersion` decimal(18,2) DEFAULT NULL COMMENT 'Monto Dispersion.',
  `Estatus` char(1) DEFAULT 'P' COMMENT 'Estatus de la Dispersión.\nP.- Pendiente por Dispersar\nS.- Seleccionada\nD.- Dispersada',
  `DesEstatus` varchar(100) DEFAULT NULL COMMENT 'Descripcion del Estatus',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Institucion Participante SPEI.',
  `NombreInstitucion` varchar(100) DEFAULT NULL COMMENT 'Nombre de la Institucion',
  `TipoCuentaSpei` int(2) DEFAULT NULL COMMENT 'Tipo de Cuenta de Envio para SPEI (TIPOSCUENTASPEI).',
  `TipoCuentaSpeiDes` varchar(100) DEFAULT NULL COMMENT 'Tipo de Cuenta de Envio para SPEI (TIPOSCUENTASPEI).',
  `Clabe` varchar(20) DEFAULT NULL COMMENT 'Numero de Cuenta para Envío SPEI.',
  `Beneficiario` varchar(100) DEFAULT NULL COMMENT 'Nombre del Beneficiario.',
  `CantidadPagada` decimal(18,2) DEFAULT NULL COMMENT 'Monto Pagado.',
  `CantidadenDispersion` decimal(18,2) DEFAULT NULL COMMENT 'Monto Por Pagar.',
  `CantidadPendiente` decimal(18,2) DEFAULT NULL COMMENT 'Monto Pendiente por Pagar.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `MontoPendiente` decimal(18,2) DEFAULT '0.00' COMMENT 'Campo de Monto Pendiente.',
  KEY `INDEX_APORTDISPERSIONES_1` (`ClienteID`,`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Dispersiones de Aportaciones.'$$