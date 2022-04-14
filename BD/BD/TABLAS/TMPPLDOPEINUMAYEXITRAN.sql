
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDOPEINUMAYEXITRAN`;

DELIMITER $$
CREATE TABLE `TMPPLDOPEINUMAYEXITRAN` (
	`RegistroID` bigint(12) unsigned NOT NULL AUTO_INCREMENT,
	`Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del pago',
	`CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
	`ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente\n',
	`CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Cuenta',
	`AmortizacionID` int(4) NOT NULL COMMENT 'No. de Amortizacion',
	`MontoCuota` decimal(18,2) DEFAULT NULL,
	`VarPagos` decimal(14,2) DEFAULT NULL COMMENT '% de variacion maxima  positiva antes de reportar pagos del cliente vs cuotas exigibles (OPI3b)',
	`MontoHolgura` decimal(31,2) DEFAULT NULL,
	`MontoTotPago` decimal(12,2) DEFAULT NULL COMMENT 'Monto Total del Pago APLICADO',
	`TotalPagado` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Pagado',
	`Estatus` varchar(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nA.- Atrasado\n',
	`FormaPago` char(1) DEFAULT NULL COMMENT 'Guarda forma de pago \nE = Efectivo\nC = Cargo a cuenta',
	`PorcAmoAnt` decimal(14,2) DEFAULT '0.00' COMMENT '% de variacion maxima  positiva antes de reportar pagos del cliente vs cuotas exigibles (OPI3b)',
	`MontoHolguraPA` decimal(31,2) DEFAULT '0.00' COMMENT 'Monto de la Cuota + Porcentaje de holgura (PorcAmoAnt).',
	`AlertaXCuota1` char(1) DEFAULT 'N' COMMENT 'Indica si genera Alerta por Pago Mayor al Exigible.\nS.- Sí.\nN.- No.',
	`AlertaXCuota2` char(1) DEFAULT 'N' COMMENT 'Indica si genera Alerta por Pago Sup. al Exigible. Nva Alerta.\nS.- Sí.\nN.- No.',
 	`NumTransaccion` bigint(20) NOT NULL,
	PRIMARY KEY (`RegistroID`),
	KEY `IDX_TMPPLDOPEINUMAYEXITRAN_1` (`NumTransaccion`),
	KEY `IDX_TMPPLDOPEINUMAYEXITRAN_2` (`Transaccion`),
	KEY `IDX_TMPPLDOPEINUMAYEXITRAN_3` (`CreditoID`),
	KEY `IDX_TMPPLDOPEINUMAYEXITRAN_4` (`NumTransaccion`,`AlertaXCuota1`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP:Tabla temporal operaciones mayores al exigible en deteccion de  operaciones inusuales-PLDOPEINUSALERTTRANSPRO'$$

