-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSCOBRAUT
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOSCOBRAUT`;DELIMITER $$

CREATE TABLE `CREDITOSCOBRAUT` (
  `Consecutivo` int(11) NOT NULL,
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito ID',
  `Ciclo` int(11) NOT NULL COMMENT 'Ciclo',
  `GrupoID` int(11) NOT NULL COMMENT 'Grupo ID',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'CuentaAho ID',
  `Exigible` decimal(18,2) NOT NULL COMMENT 'Exigible',
  `Moneda` int(11) NOT NULL COMMENT 'Moneda',
  `ProrrateaPago` char(1) NOT NULL COMMENT 'Prorratea SI o NO',
  PRIMARY KEY (`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Auxiliar Para la Cobranza'$$