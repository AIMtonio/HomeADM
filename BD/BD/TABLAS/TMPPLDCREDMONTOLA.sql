
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDCREDMONTOLA`;

DELIMITER $$
CREATE TABLE `TMPPLDCREDMONTOLA` (
	`AutRegistroID` bigint(12) UNSIGNED NOT NULL AUTO_INCREMENT,
	`CreditoID` bigint(12) NOT NULL COMMENT 'Id del Credito',
	`MontoTotal` decimal(14,2) DEFAULT 0.00 COMMENT 'Monto Total del Crédito que es la sumatoria de Capital, Interés e IVA de AMORTICREDITO.',
	`NumTransaccion` bigint(20) NOT NULL COMMENT 'Número de Transacción.',
	PRIMARY KEY(`AutRegistroID`),
	KEY `IDX_TMPPLDCREDMONTOLA_3` (`NumTransaccion`),
	KEY `IDX_TMPPLDCREDMONTOLA_4` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'TMP: Tabla que Guarda el Monto Total para las Detecciones por Liq. Anticipada por Monto.'$$

