-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAPORTAPERTURAFP
DELIMITER ;
DROP TABLE IF EXISTS `TMPAPORTAPERTURAFP`;DELIMITER $$

CREATE TABLE `TMPAPORTAPERTURAFP` (
  `ConsecutivoID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID consecutivo de los registros',
  `AportacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID de la Aportacion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ClienteID',
  `CuentaAhoID` bigint(20) DEFAULT NULL COMMENT 'CuentaAhoID a la cual se Carga y Abonara',
  `TipoAportacionID` int(11) DEFAULT NULL COMMENT 'TipoAportacionID.',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'MonedaID',
  `AperturaAport` char(2) DEFAULT 'FA' COMMENT 'Indica apertura de aportacion. FA:Fecha Actual / FP:Fecha Posterior',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la Aportacion',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la Aportación',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Nueva Fecha de Vencimiento para la Aportación Renovada',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha de pago.',
  `TasaFija` decimal(14,4) DEFAULT NULL COMMENT 'tasa fija.',
  `TipoPagoInt` char(1) DEFAULT NULL COMMENT 'Indica la forma de pago de interes.\nV - Vencimiento\nF - Fin del Mes\nP - Por Periodo.\nE - Programado.',
  `DiasPeriodo` int(11) DEFAULT '0' COMMENT 'Indica el numero de dias si la forma de pago de interes es por PERIODO.',
  `PagoIntCal` char(2) DEFAULT NULL COMMENT 'Indica el tipo de pago de interes.\nI - Iguales\nD - Devengado.',
  `DiasPago` int(11) DEFAULT '0' COMMENT 'Indica el dia de pago de la aportacion',
  `PlazoOriginal` int(11) DEFAULT NULL COMMENT 'Plazo Original de la Aportación.',
  `PagoIntCapitaliza` char(1) DEFAULT 'I' COMMENT 'Indica si capitaliza interes S:Si, N:No, I:Indistinto',
  `SaldoCta` decimal(18,4) DEFAULT '0.0000' COMMENT 'Saldo disponible en la cuenta del cliente.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ConsecutivoID`,`AportacionID`),
  KEY `ClienteID` (`ClienteID`),
  KEY `TipoAportacionID` (`TipoAportacionID`),
  KEY `CuentaAhoID` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla para verificacion de aportaciones con apertura en fecha posterior.'$$