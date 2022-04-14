-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REESTRUCCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `HIS-REESTRUCCREDITO`;DELIMITER $$

CREATE TABLE `HIS-REESTRUCCREDITO` (
  `Consecutivo` bigint(20) NOT NULL COMMENT 'Numero consecutivo',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de Registro de la Reestructura o Renovacion.',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID o numero de Usuario que realizo la Reestructura o Renovacion',
  `CreditoOrigenID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del Credito a Reestructurar o Renovar',
  `CreditoDestinoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del Credito Reestructurador o Renovador',
  `SaldoCredAnteri` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Del credito anterior al momento de hacer la Reestructura o Renovacion',
  `EstatusCredAnt` char(1) DEFAULT NULL COMMENT 'Estatus del Credito anterior al momento de hacer la Reestructura o Renovacion',
  `EstatusCreacion` char(1) NOT NULL COMMENT 'Estatus contable con que nace el credito V:Vigente B:Vencido',
  `NumDiasAtraOri` int(11) DEFAULT NULL COMMENT 'Numero de Dias de Atraso del Credito a Reestructurar o Renovar',
  `NumPagoSoste` int(11) DEFAULT NULL COMMENT 'Numero de Pagos Sostenidos para Regularizacion',
  `NumPagoActual` int(11) DEFAULT NULL COMMENT 'Numero de Pagos Sostenidos Realizados Actualmente',
  `Regularizado` char(1) DEFAULT NULL COMMENT 'Indica si ya se Regularizo o No (S/N), de acuerdo a los pagos Sostenidos.',
  `FechaRegula` date DEFAULT NULL COMMENT 'Fecha de Regularizacion de acuerdo a los pagos sostenidos',
  `NumeroReest` int(11) DEFAULT NULL COMMENT 'Numero de Reestructuras o Renovaciones sobre el Credito Original',
  `ReservaInteres` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Estimaciones Preventivas por el Saldo del Interes\n en Cuentas de Orden',
  `SaldoInteres` decimal(14,2) DEFAULT NULL COMMENT 'Saldo del Interes refinanciado con el tratamiento al credito',
  `SaldoInteresMora` decimal(14,2) DEFAULT NULL COMMENT 'Saldo del Interes moratorio refinanciado con el tratamiento al credito',
  `SaldoComisiones` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de comisiones refinanciadas con el tratamiento al credito',
  `EstatusReest` char(1) NOT NULL COMMENT 'Estatus en esta tabla A:Alta C:Cancelada D: Desembolsada',
  `Origen` char(1) DEFAULT NULL COMMENT 'Indica si el tratamiento al credito origen, R=Reestructura, O= Renovacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`Consecutivo`),
  KEY `idx_HIS-REESTRUCCREDITO_01` (`FechaRegistro`),
  KEY `idx_HIS-REESTRUCCREDITO_02` (`CreditoDestinoID`),
  KEY `idx_HIS-REESTRUCCREDITO_03` (`FechaRegula`),
  KEY `FK_HIS-REESTRUCCREDITO_1_idx` (`CreditoOrigenID`),
  CONSTRAINT `FK_HIS-REESTRUCCREDITO_1` FOREIGN KEY (`CreditoOrigenID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_HIS-REESTRUCCREDITO_2` FOREIGN KEY (`CreditoDestinoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Reestructuras de Credito'$$