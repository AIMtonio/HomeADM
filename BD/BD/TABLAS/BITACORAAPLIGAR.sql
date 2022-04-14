-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAAPLIGAR
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAAPLIGAR`;
DELIMITER $$


CREATE TABLE `BITACORAAPLIGAR` (
  `TipoGarantiaID` int(11) NOT NULL COMMENT 'Tipo de Garantia Fira:\n1- FEGA\n2- FONAGA\n3-AMBAS',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito activo al que se aplica la garantia',
  `CreditoFondeoID` bigint(20) NOT NULL COMMENT 'Credito pasivo al que se aplica la garantia',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de cliente',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Numero de cuenta de ahorro',
  `MontoGLApli` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto de garantia liquida aplicado',
  `PorcentajeApli` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT 'Porcentaje de garantia aplicado',
  `MontoGarApli` decimal(16,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto de garantia aplicado',
  `FechaAplica` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de aplicacion de la garantia',
  `FechaAtraso` date DEFAULT NULL COMMENT 'Indica la fecha a partir de la cual el credito entro en estatus atrasado',
  `DiasAtraso` int(11) DEFAULT NULL COMMENT 'Numero de dias de atraso del credito',
  `CreditoContFondeador` bigint(20) NOT NULL COMMENT 'ID del crédito con el cual el fondeador tiene registrado el crédito Contingente.',
  `Observacion` varchar(500) NOT NULL COMMENT 'Motivo u Observación por la que afectó la garantía',
  `AcreditadoIDFIRA` bigint(20)NULL DEFAULT 0 COMMENT 'Numero Anterior de Identificador de Acreditado por FIRA',
  `CreditoIDFIRA` bigint(20) NULL DEFAULT 0 COMMENT 'Numero Anterior de Identificador de Credito por FIRA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoGarantiaID`,`CreditoID`,`FechaAplica`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el registro de aplicacion de garantias fira.'$$