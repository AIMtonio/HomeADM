-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGOCRECUOCOMTMP
DELIMITER ;
DROP TABLE IF EXISTS `PREPAGOCRECUOCOMTMP`;
DELIMITER $$

CREATE TABLE `PREPAGOCRECUOCOMTMP` (
    `IDTmp` int(11) NOT NULL COMMENT 'ID de Tabla Temporal',
    `CreditoID` bigint(12) NOT NULL COMMENT 'Credito ID',
    `AmortizacionID` int(4) NOT NULL COMMENT 'No de Amortizacion',
    `SaldoCapVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente',
    `SaldoCapAtrasa` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Atrasado',
    `SaldoCapVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido',
    `SaldoCapVenNExi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible',
    `SaldoInteresOrd` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Ordinario',
    `SaldoInteresAtr` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado',
    `SaldoInteresVen` decimal(14,4) DEFAULT NULL COMMENT 'Saldos de Interes Vencido',
    `SaldoInteresPro` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Provision',
    `SaldoIntNoConta` decimal(12,4) DEFAULT NULL COMMENT 'Saldo de Interes No Contabilizado',
    `SaldoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Moratorios',
    `SaldoComFaltaPa` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Comision Falta Pago',
    `SaldoOtrasComis` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Otras Comisiones',
    `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
    `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicion',
    `FechaVencim` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
    `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigible de Pago',
    `Estatus` varchar(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nA.- Atrasado\n',
    `SaldoMoraVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
    `SaldoMoraCarVen` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
    `SaldoSeguroCuota` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Monto Seguro Cuota',
    `CobraComAnual` varchar(1) DEFAULT NULL COMMENT 'Cobra Comision S:Si N:No',
    `SaldoComisionAnual` decimal(14,2) DEFAULT '0.00' COMMENT 'Comision Anual',
    `EmpresaID` int(11) DEFAULT NULL,
    `Usuario` int(11) DEFAULT NULL,
    `FechaActual` datetime DEFAULT NULL,
    `DireccionIP` varchar(20) DEFAULT NULL,
    `ProgramaID` varchar(50) DEFAULT NULL,
    `Sucursal` int(11) DEFAULT NULL,
    `NumTransaccion` bigint(20) DEFAULT NULL,
     PRIMARY KEY (`IDTmp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla del Proceso de Pre Pago de Cuotas Completas Creditos'$$
