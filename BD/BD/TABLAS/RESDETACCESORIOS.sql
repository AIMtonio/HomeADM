-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESDETACCESORIOS
DELIMITER ;
DROP TABLE IF EXISTS `RESDETACCESORIOS`;
DELIMITER $$


CREATE TABLE `RESDETACCESORIOS` (
  `TranRespaldo` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion del Respaldo de Credito',
  `Consecutivo` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo para el Control de Accesorios',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Numero de Solicitud',
  `NumTransacSim` bigint(20) NOT NULL COMMENT 'Numero de Transaccion de la Solicitud',
  `AccesorioID` int(11) NOT NULL COMMENT 'Identificador del accesorio',
  `PlazoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Plazo del Credito',
  `CobraIVA` char(1) DEFAULT 'N' COMMENT 'Indica si el accesorio cobra IVA\nS: SI\nN: NO',
  `GeneraInteres` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si el accesorio genera intereses. Se puede marcar como N: No genera intereses. S: Si genera intereses.',
  `CobraIVAInteres` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si el accesorio cobra intereses del IVA. Se puede marcar como N: No cobra IVA intereses. S: Si cobra IVA intereses.',
  `TipoFormaCobro` char(1) DEFAULT NULL COMMENT 'Indica la forma de Cobro del Accesorio\nA: Anticipado\nD: Deduccion\nF: Financiamiento',
  `TipoPago` char(1) DEFAULT NULL COMMENT 'Tipo de Pago cuando la forma de cobro sea FINANCIAMIENTO\nM: Monto Fijo\nP: Porcentaje',
  `BaseCalculo` char(1) DEFAULT NULL COMMENT 'Base de Calculo cuando la forma de cobro sea FINANCIAMIENTO y el tipo de pago sea PORCENTAJE\n1: Indica que es sobre el monto original del credito',
  `Porcentaje` decimal(12,2) DEFAULT '0.00' COMMENT 'Porcentaje para Cobro del Accesorio',
  `AmortizacionID` int(11) NOT NULL COMMENT 'Numero de Amortizacion',
  `MontoAccesorio` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Total a Cobrar del Accesorio',
  `MontoIVAAccesorio` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto total de IVA a cobrar por accesorio\n',
  `MontoCuota` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto a cobrar del accesorio por cuota',
  `MontoIVACuota` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de IVA de accesorio a cobrar por cuota',
  `MontoIntCuota` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Monto de Interes del accesorio por cuota',
  `MontoIVAIntCuota` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Monto de IVA de Interes del accesorio por cuota',
  `MontoInteres` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Monto de Interes del accesorio',
  `MontoIVAInteres` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Monto de IVA de Interes del accesorio',
  `SaldoVigente` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Vigente del Accesorio',
  `SaldoAtrasado` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Atrasado del Accesorio',
  `SaldoIVAAccesorio` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de IVA de Accesorio generado',
  `SaldoInteres` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes del accesorio',
  `SaldoIVAInteres` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Saldo de IVA de Interes del accesorio',
  `NumProyInteres` INT(11) DEFAULT '0' COMMENT 'Numero de Veces que se ha Realizado la Proyeccion de Intereses\nen un Pago Anticipado',
  `MontoPagado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Pagado del Accesorio',
  `MontoIntPagado` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Monto Pagago del Interes del Accesorio',
  `FechaLiquida` date DEFAULT '1900-01-01' COMMENT 'Fecha de Liquidacion de Accesorios',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoID`,`SolicitudCreditoID`,`NumTransacSim`,`AccesorioID`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Control de saldos a cobrar por Credito y Amortizacion'$$