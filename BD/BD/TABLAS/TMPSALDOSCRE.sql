-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSCRE
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOSCRE`;DELIMITER $$

CREATE TABLE `TMPSALDOSCRE` (
  `CreditoID` bigint(12) NOT NULL,
  `PasoCapAtraDia` decimal(12,2) DEFAULT NULL COMMENT 'Monto Capital\nque paso a\nAtrasado dia de\nhoy',
  `PasoCapVenDia` decimal(12,2) DEFAULT NULL COMMENT 'Monto Capital\nque paso a\nVencido dia de\nhoy',
  `PasoCapVNEDia` decimal(12,2) DEFAULT NULL COMMENT 'Monto Capital\nque paso a\nVencido no \nExigible dia de\nhoy',
  `PasoIntAtraDia` decimal(12,2) DEFAULT NULL COMMENT 'Monto Interes\nque paso a\nAtrasado dia de\nhoy',
  `PasoIntVenDia` decimal(12,2) DEFAULT NULL COMMENT 'Monto Interes\nque paso a\nVencido dia de\nhoy',
  `CapRegularizado` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Capital\nQue se Regulariza\nel dia de Hoy',
  `IntOrdDevengado` decimal(12,2) DEFAULT NULL COMMENT 'Monto de interes\nOrdinario\nDevengado',
  `IntMorDevengado` decimal(12,2) DEFAULT NULL COMMENT 'Monto de interes\nMoratorio\nDevengado',
  `ComisiDevengado` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la\nComision\nDevengado Hoy',
  `PagoCapVigDia` decimal(12,2) DEFAULT NULL COMMENT 'Pago Realizado de\nCapital Vigente',
  `PagoCapAtrDia` decimal(12,2) DEFAULT NULL COMMENT 'Pago Realizado de\nCapital Atrasado',
  `PagoCapVenDia` decimal(12,2) DEFAULT NULL COMMENT 'Pago Realizado de\nCapital Vencido',
  `PagoCapVenNexDia` decimal(12,2) DEFAULT NULL COMMENT 'Pago Realizado de\nCapital Vencido\nNo Exigible\nel dia de Hoy',
  `PagoIntOrdDia` decimal(12,2) DEFAULT NULL COMMENT 'Pago Realizado de\nInteres Vigente',
  `PagoIntVenDia` decimal(12,2) DEFAULT NULL COMMENT 'Pago Realizado de\nInteres Vencido',
  `PagoIntAtrDia` decimal(12,2) DEFAULT NULL COMMENT 'Pago Realizado de\nInteres Atrasado',
  `PagoIntCalNoCon` decimal(12,2) DEFAULT NULL COMMENT 'Pago Realizado de\nInteres Calculado\nNo Contabilizado',
  `PagoComisiDia` decimal(12,2) DEFAULT NULL COMMENT 'Pago Realizado de\nInteres Comision\nPor Falta Pago',
  `PagoIvaDia` decimal(12,2) DEFAULT NULL COMMENT 'IVA Pagado\nRealizado el dia\nde Hoy',
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal para el Calculo Diario de los Saldos de Credi'$$