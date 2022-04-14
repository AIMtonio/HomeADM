-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORTIPAGOGRUPO
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMORTIPAGOGRUPO`;DELIMITER $$

CREATE TABLE `TMPAMORTIPAGOGRUPO` (
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del Credito',
  `AmortizacionID` int(4) NOT NULL COMMENT 'No o ID de la Amortizacion',
  `MontoExigible` decimal(14,2) DEFAULT NULL COMMENT 'Monto a Adeudo Exigible ',
  `MontoAPagar` decimal(14,2) DEFAULT NULL COMMENT 'Monto a Aplicar o Pagar',
  `ComisionFaltaPago` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de la Comision por Falta de Pago',
  `MontoEfecNeto` decimal(14,2) DEFAULT NULL,
  KEY `IDX_TMPAMORTIPAGOGRUP0_1` (`NumTransaccion`),
  KEY `IDX_TMPAMORTIPAGOGRUP0_2` (`NumTransaccion`,`CreditoID`,`AmortizacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Amortizaciones de los Creditos'$$