-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDITOPAGOGRUPO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOPAGOGRUPO`;DELIMITER $$

CREATE TABLE `TMPCREDITOPAGOGRUPO` (
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `AmortizacionID` int(11) NOT NULL COMMENT 'Credito',
  `MontoExigible` decimal(14,2) DEFAULT NULL COMMENT 'Monto Exigible',
  `ComisionFaltaPago` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de la Comision por Falta de Pago',
  KEY `IDX_TMPCREDITOPAGOGRUPO_1` (`NumTransaccion`),
  KEY `IDX_TMPCREDITOPAGOGRUPO_2` (`NumTransaccion`,`AmortizacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal de Credito para Pago Grupal'$$