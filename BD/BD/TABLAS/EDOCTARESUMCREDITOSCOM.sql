-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCREDITOSCOM
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTARESUMCREDITOSCOM`;
DELIMITER $$


CREATE TABLE `EDOCTARESUMCREDITOSCOM` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Identificador del cliente',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Identificador del credito correspondiente al cliente',
  `NumeroPago` text NOT NULL COMMENT 'Cantidad de pago realizados',
  `TotalPagos` int(4) NOT NULL DEFAULT '0' COMMENT 'Numero de pagos realizados',
  `NumPagoPlazo` varchar(50) NOT NULL DEFAULT '' COMMENT 'Numero del pago sobre el total',
  `SaldoInsolutoPrin` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo insoluto de principal utilizado para el calculo del interés ordinario',
  `MontoProxPago` DECIMAL(12,2) NOT NULL COMMENT 'Valor del Monto total del proximo pago',
  `CapitalProxPago` DECIMAL(12,2) NOT NULL COMMENT 'Valor del capital del proximo pago',
  `IntOrdProxPago` DECIMAL(12,2) NOT NULL COMMENT 'Valor del interes ordinario del proximo pago',
  `IVAIntOrdProxPago` DECIMAL(12,2) NOT NULL COMMENT 'Valor del IVA de interes ordinario del proximo pago',
  `IntMoraProxPago` DECIMAL(12,2) NOT NULL COMMENT 'Valor del interes moratorio del proximo pago',
  `IVAIntMoraProxPago` DECIMAL(12,2) NOT NULL COMMENT 'Valor del IVA de interes moratorio del proximo pago',
  `SaldoInicial` DECIMAL(12,2) NOT NULL COMMENT 'Saldo del credito al inicio del periodo',
  `InteresesCargados` DECIMAL(18,2) NOT NULL COMMENT 'Intereses cargados en el periodo',
  `ComisionesCobradas` DECIMAL(18,2) NOT NULL COMMENT 'Comisiones cobradas en el periodo',
  `IVAComisiCobradas` DECIMAL(18,2) NOT NULL COMMENT 'IVA de las comisiones cobradas en el periodo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  INDEX INDEX_EDOCTARESUMCREDITOSCOM_1 (CreditoID),
  INDEX INDEX_EDOCTARESUMCREDITOSCOM_2 (CreditoID, ClienteID),
  INDEX INDEX_EDOCTARESUMCREDITOSCOM_3 (ClienteID),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla complementaria para el resumen de los movimientos de cada credito mostrado en el reporte'$$
