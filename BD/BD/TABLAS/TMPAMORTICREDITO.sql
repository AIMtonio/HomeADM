-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORTICREDITO
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMORTICREDITO`;DELIMITER $$

CREATE TABLE `TMPAMORTICREDITO` (
  `AmorticreID` char(40) NOT NULL COMMENT 'ID de la tabla',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Tranasaccion',
  `AmortizacionID` int(4) NOT NULL COMMENT 'No Amortizacion',
  `CreditoID` int(11) NOT NULL COMMENT 'Credito',
  PRIMARY KEY (`AmorticreID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal de paso en pago de Creditos'$$