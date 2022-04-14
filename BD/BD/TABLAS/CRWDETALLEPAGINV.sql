-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWDETALLEPAGINV
DELIMITER ;
DROP TABLE IF EXISTS `CRWDETALLEPAGINV`;
DELIMITER $$


CREATE TABLE `CRWDETALLEPAGINV` (
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'ID del fondeo',
  `AmortizacionID` int(11) NOT NULL COMMENT 'ID de la amortizacion',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del credito',
  `Fecha` date NOT NULL COMMENT 'Fecha',
  `MontoTotal` decimal(14,6) NOT NULL COMMENT 'Monto total',
  `CapitalVigente` decimal(14,6) NOT NULL COMMENT 'Capital vigente',
  `CapitalExigible` decimal(14,6) NOT NULL COMMENT 'Capital exigible',
  `CapitalCO` decimal(14,6) NOT NULL COMMENT 'Capital contable',
  `Interes` decimal(14,6) NOT NULL COMMENT 'Interes',
  `InteresCO` decimal(14,6) NOT NULL COMMENT 'Interes contable',
  `InteresMoratorio` decimal(14,6) NOT NULL COMMENT 'Interes Moratorio',
  `ComFaltaPago` decimal(14,6) NOT NULL COMMENT 'Comision por falta de pago',
  `ISRInt` decimal(14,6) NOT NULL COMMENT 'ISR interes',
  `ISRMoratorio` decimal(14,6) NOT NULL COMMENT 'ISR moratorio',
  `ISRComision` decimal(14,6) NOT NULL COMMENT 'ISR Comision',
  `TipoPago` int(11) NOT NULL COMMENT '1.- Pago de Credito\n2.- Prepago de Credito ultimas cuotas\n3.- Prepago de Credito cuotas siguientes inmediatas\n4.- Liquidacion Anticipada',
  `NumInversiones` int(11) NOT NULL COMMENT 'Numero total de inversiones correspondientes al credito',
  `NumInvPagadas` int(11) NOT NULL COMMENT 'Numero de inversiones Pagadas realmente en la transaccion',
  `NumInvAPagar` int(11) NOT NULL COMMENT 'Indica el Numero de inversiones que se debieron Pagar',
  `EmpresaID` int(11) NOT NULL COMMENT 'Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(20) NOT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`SolFondeoID`,`AmortizacionID`,`Transaccion`,`Fecha`),
  KEY `idx_Fecha` (`Fecha`,`SolFondeoID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de pago de Inversiones de crw'$$
