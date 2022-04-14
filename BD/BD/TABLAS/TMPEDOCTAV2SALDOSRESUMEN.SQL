DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOCTAV2SALDOSRESUMEN`;
DELIMITER $$

CREATE TABLE `TMPEDOCTAV2SALDOSRESUMEN` (
  `CreditoID`        BIGINT(12)    NOT NULL COMMENT 'Identificador del credito',
  `FechaCorte`       DATE          NOT NULL COMMENT 'Fecha de Corte de los saldos',
  `NoCuotasAtraso`   INT(11)       NOT NULL COMMENT 'Numero de Cuotas en Atraso al Dia',
  `MontoProximoPago` DECIMAL(14,2) NOT NULL COMMENT 'Monto de Proximo Pago inmediato',
  `FechaProximoPago` DATE          NOT NULL COMMENT 'Fecha de Proximo Pago inmediato',
  `SalCapVigente`    DECIMAL(14,2) NOT NULL COMMENT 'Saldo de Capital Vigente',
  `SalCapAtrasado`   DECIMAL(14,2) NOT NULL COMMENT 'Saldo de Capital Atrasado',
  `SalCapVencido`    DECIMAL(14,2) NOT NULL COMMENT 'Saldo de Capital Vencido',
  `SalCapVenNoExi`   DECIMAL(14,2) NOT NULL COMMENT 'Saldo de Capital Vencido no Exigible',
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para obtener la proxima fecha de pago de los creditos'$$
