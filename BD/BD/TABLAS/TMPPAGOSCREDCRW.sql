-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPAGOSCREDCRW
DELIMITER ;
DROP TABLE IF EXISTS `TMPPAGOSCREDCRW`;

DELIMITER $$
CREATE TABLE `TMPPAGOSCREDCRW` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TmpID` bigint(20) NOT NULL COMMENT 'Numero consecutivo tmp',
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero o ID del Cliente',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'No de Sucursal a la que pertenece el cliente, Llave Foranea Hacia Tabla SUCURSALES\n',
  `PagaISR` char(1) DEFAULT NULL COMMENT 'Paga ISR en Inversiones\nEspecifica si el cliente paga o no ISR por los \nIntereses de Inversión\n	''S''.- Si Paga\n	''N''.- No Paga',
  `CuentaAhoID` bigint(20) DEFAULT NULL COMMENT 'Cuenta de \nAhorro del \nCliente o \nInversionista',
  `NumRetirosMes` int(11) DEFAULT NULL COMMENT 'Numero de \nRetiros en el\nMes',
  `PorcentajeComisi` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje de Participacion en Comisiones',
  `PorcentajeFondeo` decimal(10,6) DEFAULT NULL COMMENT 'Porcentaje del Fondeo',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario',
  `PorcentajeCapital` decimal(9,6) DEFAULT NULL COMMENT 'Porcentaje de Capital Respecto a la parte activa (AMORTICREDITO)',
  `SaldoCapVigente` decimal(12,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nVigente',
  `SaldoCapExigible` decimal(12,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nExigible o\nen Atraso',
  `SaldoCapCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'Capital que se encuentra en las cuentas de orden(capital que se uso para aplicar la garantia del credito)',
  `SaldoIntMoratorio` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio calculado en el cierre',
  `PorcentajeInteres` decimal(9,6) DEFAULT NULL COMMENT 'Porcentaje Interés Respecto al Interés En la Parte Activa',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada ',
  `RetencionIntAcum` decimal(14,4) DEFAULT NULL COMMENT 'Monto\nde la Retencion\nde Interes\nAcumulada\nDiaria',
  `SaldoIntCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'interes que se encuentra en cuentas de Orden(interes que se uso para aplicar la garantia al credito)',
  `SaldoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Saldo\nde Interes',
  `TipoProcesoPago` int(11) DEFAULT NULL COMMENT 'Tipo de proceso de pago.\n1: Pago Capital.\n2: Falta de pago.\n3: Pago de int provisionado.\n4: Pago de int moratorio.\n5: Pago Interes cobrados.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  KEY `INDEX_TMPPAGOSCREDCRW_1` (`SolFondeoID`),
  KEY `INDEX_TMPPAGOSCREDCRW_2` (`TipoProcesoPago`,`NumTransaccion`),
  KEY `INDEX_TMPPAGOSCREDCRW_3` (`TipoProcesoPago`,`NumTransaccion`,`TmpID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal usada para pagos en fondeos crowdfunding.'$$
