-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORTICRE
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMORTICRE`;
DELIMITER $$


CREATE TABLE `TMPAMORTICRE` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Tranasaccion',
  `AmortizacionID` int(4) NOT NULL COMMENT 'No Amortizacion',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito',
  KEY `TMPAMORTICRE_1` (`Transaccion`,`CreditoID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal de Amortizaciones de los Creditos'$$
