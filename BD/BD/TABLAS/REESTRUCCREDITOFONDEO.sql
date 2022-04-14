-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REESTRUCCREDITOFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `REESTRUCCREDITOFONDEO`;DELIMITER $$

CREATE TABLE `REESTRUCCREDITOFONDEO` (
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha de Registro de la Reestructura.',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID o numero de Usuario que realizo la Reestructura',
  `CreditoOrigenID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del Credito a Reestructurar',
  `CreditoDestinoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del Credito Reestructurador',
  `SaldoCredAnteri` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Del credito anterior al momento de hacer la Reestructura',
  `EstatusCredAnt` char(1) DEFAULT NULL COMMENT 'Estatus del Credito anterior al momento de hacer la Reestructura',
  `EstatusCreacion` char(1) NOT NULL COMMENT 'Estatus contable con que nace el credito N:Vigente',
  `NumDiasAtraOri` int(11) DEFAULT '0' COMMENT 'Numero de Dias de Atraso del Credito a Reestructurar',
  `NumPagoSoste` int(11) DEFAULT '0' COMMENT 'Numero de Pagos Sostenidos para Regularizacion',
  `NumPagoActual` int(11) DEFAULT '0' COMMENT 'Numero de Pagos Sostenidos Realizados Actualmente',
  `Regularizado` char(1) DEFAULT NULL COMMENT 'Indica si ya se Regularizo o No (S/N), de acuerdo a los pagos Sostenidos.',
  `FechaRegula` date DEFAULT NULL COMMENT 'Fecha de Regularizacion de acuerdo a los pagos sostenidos',
  `NumeroReest` int(11) DEFAULT NULL COMMENT 'Numero de Reestructuras o Renovaciones sobre el Credito Original',
  `ReservaInteres` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Estimaciones Preventivas por el Saldo del Interes\n en Cuentas de Orden',
  `SaldoInteres` decimal(14,2) DEFAULT NULL COMMENT 'Saldo del Interes refinanciado con el tratamiento al credito',
  `SaldoInteresMora` decimal(14,2) DEFAULT NULL COMMENT 'Saldo del Interes moratorio refinanciado con el tratamiento al credito',
  `SaldoComisiones` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de comisiones refinanciadas con el tratamiento al credito',
  `EstatusReest` char(1) NOT NULL COMMENT 'Estatus en esta tabla A:Alta C:Cancelada D: Desembolsada',
  `Origen` char(1) DEFAULT NULL COMMENT 'Indica el tratamiento al credito origen, R=Reestructura',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoOrigenID`,`CreditoDestinoID`),
  KEY `INDEX_REESTRUCCREDITOFONDEO_1` (`FechaRegistro`),
  KEY `INDEX_REESTRUCCREDITOFONDEO_2` (`CreditoDestinoID`),
  KEY `INDEX_REESTRUCCREDITOFONDEO_3` (`FechaRegula`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Reestructuras que se le han hecho a un credito pasivo en el modulo de FONDEO'$$