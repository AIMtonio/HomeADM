-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAINFADICIONAL
DELIMITER ;
DROP TABLE IF EXISTS `POLIZAINFADICIONAL`;DELIMITER $$

CREATE TABLE `POLIZAINFADICIONAL` (
  `PolizaID` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de Poliza',
  `Movimiento` char(1) DEFAULT NULL COMMENT 'Movimiento\nI:Ingreso \nE:Egreso',
  `InstitucionID` varchar(50) DEFAULT '' COMMENT 'Institucion Bancaria',
  `NumCtaInstit` varchar(20) DEFAULT NULL COMMENT 'Numero de Cuenta en el Banco(Institucion)',
  `CueClave` char(18) DEFAULT NULL COMMENT 'Clave Interbancaria',
  `TipoMovimiento` int(11) DEFAULT NULL COMMENT 'Tipo de Movimiento \n I:Ingreso  \n E:Egreso',
  `Folio` varchar(10) DEFAULT NULL COMMENT 'Consecutivo del cheque o transferencia',
  `PersonaID` int(11) DEFAULT NULL COMMENT 'Clave del Proveedor o Cliente',
  `Importe` decimal(14,2) DEFAULT NULL COMMENT 'Importe del Movimiento en la Informacion Adicional (Ingreso/Egreso)',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Referencia de la Informacion Adicional',
  `MetodoPagoID` int(11) DEFAULT NULL COMMENT 'Clave del Metodo de Pago',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Clave Moneda',
  `TipoCambio` decimal(14,2) DEFAULT NULL COMMENT 'Tipo de Cambio',
  `InstitucionOrigen` int(11) DEFAULT NULL COMMENT 'Institucion de Origen',
  `CueClaveOrigen` char(18) DEFAULT NULL COMMENT 'Cuenta Clabe de Origen',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`PolizaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Informacion Adicional de la Poliza'$$