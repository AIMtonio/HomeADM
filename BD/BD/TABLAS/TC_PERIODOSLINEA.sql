-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_PERIODOSLINEA
DELIMITER ;
DROP TABLE IF EXISTS `TC_PERIODOSLINEA`;
DELIMITER $$


CREATE TABLE `TC_PERIODOSLINEA` (
  `FechaCorte` date NOT NULL COMMENT 'Fecha de corte de la linea',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de inicio del periodo actual',
  `LineaTarCredID` int(11) NOT NULL COMMENT 'Identificador de la linea de credito',
  `SaldoInicial` decimal(16,2) DEFAULT NULL COMMENT 'Saldo Inicial de la Linea',
  `TotalCompras` decimal(16,2) DEFAULT NULL COMMENT 'Total de las Compras realizadas en el periodo',
  `TotalInteres` decimal(16,2) DEFAULT NULL COMMENT 'Total de interes generado en el periodo, incluye el IVA',
  `TotalComisiones` decimal(16,2) DEFAULT NULL COMMENT 'Total de comisiones generadas en el periodo,  com anual, con falta de pago, incluye el IVA',
  `TotalCargosPer` decimal(16,2) DEFAULT NULL COMMENT 'Sumatora del total de cargos del periodo',
  `TotalPagos` decimal(16,2) DEFAULT NULL COMMENT 'Suma del total de pagos realizados en el periodo',
  `SaldoCorte` decimal(16,2) DEFAULT NULL COMMENT 'Saldo de la linea a la fecha de corte',
  `PagoNoGenInteres` decimal(16,2) DEFAULT NULL COMMENT 'Monto del Pago para no generar intereses',
  `PagoMinimo` decimal(16,2) DEFAULT NULL COMMENT 'Monto del Pago Minimo requerido',
  `DiasPeriodo` int(11) DEFAULT NULL COMMENT 'Dias del periodo ',
  `SaldoPromedio` decimal(16,2) DEFAULT NULL COMMENT 'Saldo promedio de la linea',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha limite de pago exigible',
  `FechaProxCorte` date DEFAULT NULL COMMENT 'Fecha del Proximo Corte',
  `FechaUltPago` date DEFAULT NULL COMMENT 'Fecha del ultimo pago realizado al periodo entre la fecha de corte y la fecha de pago',
  `MontoPagado` decimal(16,2) DEFAULT NULL COMMENT 'Monto del pago realizado al periodo entre la fecha de corte y la fecha de pago',
  `MontoBaseCom` decimal(16,2) DEFAULT NULL COMMENT 'Monto Base para el Calculo de Comisiones',
  `TipoPagMin` char(1) DEFAULT NULL COMMENT 'P: Porcentaje, F: Formula',
  `FactorPagMin` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje de cobro cuando el tipo de pago minimo es "P"',
  `MontoLinea` decimal(16,2) DEFAULT NULL COMMENT 'Monto Limite de la linea de credito',
  `MontoDisponible` decimal(16,2) DEFAULT NULL COMMENT 'Monto Disponible en la Linea de Credito',
  `MontoBloqueado` decimal(16,2) DEFAULT NULL COMMENT 'Monto bloqueado de la linea',
  `SaldoAFavor` decimal(16,2) DEFAULT NULL COMMENT 'Saldo a Favor por pagos',
  `SaldoCapVigente` decimal(16,2) DEFAULT NULL COMMENT 'Saldo acumulado de los cargos',
  `SaldoCapVencido` decimal(16,2) DEFAULT NULL COMMENT 'Saldo acumulado que no fue pagado en tiempo',
  `SaldoInteres` decimal(16,2) DEFAULT NULL COMMENT 'Saldo de  intereses',
  `SaldoIVAInteres` decimal(16,2) DEFAULT NULL COMMENT 'Iva del interes',
  `SaldoMoratorios` decimal(16,2) DEFAULT NULL COMMENT 'Saldo de interes moratorio',
  `SaldoIVAMoratorios` decimal(16,2) DEFAULT NULL COMMENT 'Saldo iva de moratorios',
  `SalComFaltaPag` decimal(16,2) DEFAULT NULL COMMENT 'Saldo de comision por falta ed pago',
  `SalIVAComFaltaPag` decimal(16,2) DEFAULT NULL COMMENT 'Saldo iva de comision por falta de pago',
  `SalOrtrasComis` decimal(16,2) DEFAULT NULL COMMENT 'Saldo de otras comisiones',
  `SalIVAOrtrasComis` decimal(16,2) DEFAULT NULL COMMENT 'Saldo IVA de otras comisiones',
  `MesesPagMin` INT(11) NOT NULL DEFAULT 0	COMMENT 'Numero de Meses para pagar el credito actual, solo con el pago minimo',
  `PagoDoceMeses` DECIMAL(16,2) NOT NULL DEFAULT 0.00 COMMENT 'Monto para liquidar el credito en 12 meses',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'auditoria',
  PRIMARY KEY (`FechaCorte`,`LineaTarCredID`),
  KEY `TC_PERIODOSLINEA_ibfk_1` (`LineaTarCredID`),
  CONSTRAINT `TC_PERIODOSLINEA_ibfk_1` FOREIGN KEY (`LineaTarCredID`) REFERENCES `LINEATARJETACRED` (`LineaTarCredID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Guarda los saldos a la fecha de corte de las tarjetas'$$