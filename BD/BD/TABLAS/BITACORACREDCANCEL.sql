-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACREDCANCEL
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACREDCANCEL`;DELIMITER $$

CREATE TABLE `BITACORACREDCANCEL` (
  `CreditoID` int(11) NOT NULL COMMENT 'Numero de Credito',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Cuenta Eje',
  `FechaCancel` date NOT NULL COMMENT 'Fecha de Cancelacion',
  `MotivoCancel` varchar(500) DEFAULT NULL COMMENT 'Motivo de cancelacion',
  `MontoCancel` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la cancelacion',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Capital del Crédito',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes del Crédito',
  `PolizaID` bigint(12) DEFAULT NULL COMMENT 'Poliza de la Cancelacion',
  `MontoGarantia` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la Garantia Liq',
  `Comisiones` decimal(18,2) DEFAULT NULL COMMENT 'Comisiones (Comision por Apertura)\n',
  `UsuarioCancelID` int(11) DEFAULT NULL COMMENT 'Usuario que realiza la cancelacion',
  `UsuarioAutID` int(11) DEFAULT NULL COMMENT 'Usuario que realiza la autorizacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para la Bitacora de los créditos cancelados.'$$