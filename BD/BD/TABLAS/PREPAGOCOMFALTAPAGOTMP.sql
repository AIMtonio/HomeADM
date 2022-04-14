-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGOCOMFALTAPAGOTMP
DELIMITER ;
DROP TABLE IF EXISTS `PREPAGOCOMFALTAPAGOTMP`;
DELIMITER $$

CREATE TABLE `PREPAGOCOMFALTAPAGOTMP` (
    `IDTmp` int(11) NOT NULL COMMENT 'ID de Tabla Temporal',
    `CreditoID` bigint(12) NOT NULL COMMENT 'Credito ID',
    `SaldoComFaltaPa` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Comision Falta Pago',
    `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
    `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicion',
    `FechaVencim` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
    `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigible de Pago',
    `Estatus` varchar(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nA.- Atrasado\n',
    `EmpresaID` int(11) DEFAULT NULL,
    `Usuario` int(11) DEFAULT NULL,
    `FechaActual` datetime DEFAULT NULL,
    `DireccionIP` varchar(20) DEFAULT NULL,
    `ProgramaID` varchar(50) DEFAULT NULL,
    `Sucursal` int(11) DEFAULT NULL,
    `NumTransaccion` bigint(20) DEFAULT NULL,
    PRIMARY KEY (`IDTmp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla del Proceso de PrePago para Comisiones de Falta de Pago'$$
