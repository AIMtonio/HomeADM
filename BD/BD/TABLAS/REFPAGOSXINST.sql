-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFPAGOSXINST
DELIMITER ;
DROP TABLE IF EXISTS `REFPAGOSXINST`;DELIMITER $$

CREATE TABLE `REFPAGOSXINST` (
  `RefPagoID` int(11) NOT NULL COMMENT 'ID de la referencia de pago.',
  `TipoCanalID` int(11) NOT NULL COMMENT 'ID del tipo de canal sólo para 1= creditos, 2 = Cuentas y 3= tarjetas\nCorresponde a TIPOCANAL.',
  `InstrumentoID` bigint(12) NOT NULL COMMENT 'ID del instrumento (CuentaAhoID, CreditoID, tarjeta)',
  `Origen` int(11) NOT NULL COMMENT 'Instituciones Bancarias 1.- Instituciones',
  `InstitucionID` int(11) NOT NULL COMMENT 'ID de INSTITUCIONES. Si es tipo Tercero viene en 0',
  `NombInstitucion` varchar(100) NOT NULL COMMENT 'Nombre largo de la Institucion o del Tercero.',
  `Referencia` varchar(45) NOT NULL COMMENT 'Nombre de la Rerferencia (Alfanumérico).',
  `TipoReferencia` char(1) DEFAULT 'M' COMMENT 'Tipo de referencia M = Manual, A = Automatica',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`RefPagoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registra las referencias de pagos por tipo de instrumento.'$$