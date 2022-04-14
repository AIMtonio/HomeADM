-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPGRUPOPAGO
DELIMITER ;
DROP TABLE IF EXISTS `TMPGRUPOPAGO`;DELIMITER $$

CREATE TABLE `TMPGRUPOPAGO` (
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Id Consecutivo por registros',
  `CreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de credito',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'Numero de la amortizacion',
  `MontoExigible` decimal(14,2) DEFAULT NULL COMMENT 'Monto Exigible por amortizacion grupal',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `IDX_TMPGRUPOPAGO_1` (`Consecutivo`,`CreditoID`,`AmortizacionID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Guarda las amortizaciones grupales con su respectivo exigible para el pago de crédito'$$