-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDITOSMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOSMOVS`;
DELIMITER $$


CREATE TABLE `TMPCREDITOSMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'ID del Credito',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha',
  `SaldoDia` decimal(14,2) DEFAULT NULL COMMENT 'Saldo del Dia',
  KEY `TmpCreditosMovs_CreditoID` (`CreditoID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para el Calculo de Saldo Promedio en Cierre de Cart'$$
