-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROYECTINTAGROCONSOLIDA
DELIMITER ;
DROP TABLE IF EXISTS `PROYECTINTAGROCONSOLIDA`;
DELIMITER $$

CREATE TABLE `PROYECTINTAGROCONSOLIDA` (
  `ProyeccionID` int(11) NOT NULL COMMENT 'ID de la Tabla',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito',
  `AmortizacionID` int(4) NOT NULL COMMENT 'No de Amortizacion',
  `SaldoCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros',
  `SaldoCapVenNExi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible, en al alta nace con ceros',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio\n',
  `FechaVencim` date DEFAULT NULL COMMENT 'Fecha de\nVencimiento',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigible\nde Pago\n',
  `SaldoInteresPro` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Provision, en el alta nace con ceros',
  `MontoPendDesembolso` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Pendiente a Desembolsar\n',
  `Interes` decimal(14,2) DEFAULT NULL COMMENT 'Interes',
  `Estatus` varchar(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nA.- Atrasado\n',
  `SaldoInteresAtr` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado, en el alta nace con ceros',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20)NOT NULL COMMENT 'Número de transacción',
  PRIMARY KEY (`ProyeccionID`,`CreditoID`,`AmortizacionID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Proyeccion de los Creditos Consolidados'$$