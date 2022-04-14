-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_SALDOSLINEA
DELIMITER ;
DROP TABLE IF EXISTS `TC_SALDOSLINEA`;DELIMITER $$

CREATE TABLE `TC_SALDOSLINEA` (
  `FechaCorte` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Corte de Mes',
  `LineaTarCredID` int(20) NOT NULL DEFAULT '0' COMMENT 'Identificador de la Linea de Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Identificador del Cliente',
  `TarjetaPrincipal` char(16) DEFAULT '' COMMENT 'Numero de tarjeta titular, actual',
  `MontoDisponible` decimal(16,2) DEFAULT NULL COMMENT 'Monto Disponible en la Linea de Credito',
  `MontoLinea` decimal(16,2) DEFAULT NULL COMMENT 'Monto Limite de la linea de credito',
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
  `SaldoCorte` decimal(16,2) DEFAULT NULL COMMENT 'Saldo de la Linea a la Fecha de Corte',
  `PagoNoGenInteres` decimal(16,2) DEFAULT NULL COMMENT 'Monto del Pago para no generar interes',
  `PagoMinimo` decimal(16,2) DEFAULT NULL COMMENT 'Monto del Pago Minimo',
  `SaldoInicial` decimal(16,2) DEFAULT NULL COMMENT 'Monto del Pago Minimo',
  `TipoTarjetaDeb` int(11) DEFAULT NULL COMMENT 'Identificador del tipo de Tarjeta',
  `ProductoCredID` int(11) DEFAULT NULL COMMENT 'Identificador del Producto de Credito',
  `TasaFija` decimal(8,4) DEFAULT NULL COMMENT 'Tasa Fija de la Linea',
  `TipoCorte` char(1) DEFAULT NULL COMMENT 'F: Fin de Mes, D: Dia es especifico',
  `DiaCorte` int(11) DEFAULT NULL COMMENT 'Dia en que se realiza el corte de la tarjeta, aplica si el Tipo de Corte es "D" dia en especifico',
  `TipoPago` char(1) DEFAULT NULL COMMENT 'Tipo de Pago de la tarjeta:  D: Dia en especifico, V: 20 dias Naturales, M: Un Mes natural (30 dias)',
  `DiaPago` int(11) DEFAULT NULL COMMENT 'Dia en que se realiza el pago de la tarjeta, aplica si el Tipo de Pago es "D" dia en especifico',
  `CobraMora` char(1) DEFAULT NULL COMMENT 'Indica si la Linea cobra Moratorios',
  `TipoCobMora` char(1) DEFAULT NULL COMMENT 'Indica la forma de cobro de moratorios, N: N veces la tasa, T: Tasa fija anualizada',
  `FactorMora` decimal(8,4) DEFAULT NULL COMMENT 'Indica el factor a utilizar para el cobro de moratorios',
  `TipoPagMin` char(1) DEFAULT NULL COMMENT 'P: Porcentaje, F: Formula',
  `FactorPagMin` decimal(8,4) DEFAULT NULL COMMENT 'Porcentaje de cobro cuando el tipo de pago minimo es "P"',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la linea R: Registrada, V: Vigente, B: Bloqueada, C: Cancelada',
  `FechaUltCorte` date DEFAULT '1900-01-01' COMMENT 'Fecha del ultimo corte',
  `FechaProxCorte` date DEFAULT '1900-01-01' COMMENT 'Indica na Fecha del Proximo corte de la linea\\n',
  `CapitalVigente` decimal(16,2) DEFAULT NULL COMMENT 'Capital de Compras Diarias',
  `CapitalVencido` decimal(16,2) DEFAULT NULL COMMENT 'Capital que pasa a vencido',
  `InteresOrdinario` decimal(16,2) DEFAULT NULL COMMENT 'Intereses generados en el dia',
  `IVAInteresOrd` decimal(16,2) DEFAULT NULL COMMENT 'Iva de interes generado',
  `InteresMoratorio` decimal(16,2) DEFAULT NULL COMMENT 'Intereses moratorios del dia',
  `IVAInteresMora` decimal(16,2) DEFAULT NULL COMMENT 'iva de interes moratorio',
  `ComisionFaltaPag` decimal(16,2) DEFAULT NULL COMMENT 'Comision por falta de pago del dia',
  `IVAComFaltaPag` decimal(16,2) DEFAULT NULL COMMENT 'iva de comision por falta de pago',
  `ComisionApertura` decimal(16,2) DEFAULT NULL COMMENT 'Comision por apertura del dia',
  `IVAComApertura` decimal(16,2) DEFAULT NULL COMMENT 'IVA de comision por apertura',
  `ComisionAnual` decimal(16,2) DEFAULT NULL COMMENT 'Comision anual cargado en el dia',
  `IVAComAnual` decimal(16,2) DEFAULT NULL COMMENT 'Iva de comision anual',
  `PagoCapVigente` decimal(16,2) DEFAULT NULL COMMENT 'Pago realizado a capital',
  `PagoCapVencido` decimal(16,2) DEFAULT NULL COMMENT 'Pago a capital vencido',
  `PagoIntOrdinario` decimal(16,2) DEFAULT NULL COMMENT 'Pago a interes ordinario',
  `PagoIVAIntOrd` decimal(16,2) DEFAULT NULL COMMENT 'Pago de Iva de interes',
  `PagoIntMoratorio` decimal(16,2) DEFAULT NULL COMMENT 'Pago a Interes Moratorio',
  `PagoIVAIntMora` decimal(16,2) DEFAULT NULL COMMENT 'Pago IVA Int Moratorio',
  `PagoComFaltaPag` decimal(16,2) DEFAULT NULL COMMENT 'Pago Comision por falta de pago',
  `PagoIVAComFaltaPag` decimal(16,2) DEFAULT NULL COMMENT 'Pago de iva comision falta pago',
  `PagoComApertura` decimal(16,2) DEFAULT NULL COMMENT 'Pago Comision por Apertura',
  `PagoIVAComApertura` decimal(16,2) DEFAULT NULL COMMENT 'Pago Iva de comision por apertura',
  `PagoComAnual` decimal(16,2) DEFAULT NULL COMMENT 'Pago comision anual',
  `PagoIVAComAnual` decimal(16,2) DEFAULT NULL COMMENT 'Pago iva comision anual',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`FechaCorte`,`LineaTarCredID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: LLeva el control de los saldos mensuales de las lineas de tarjeta de credito'$$