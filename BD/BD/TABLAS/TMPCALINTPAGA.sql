-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCALINTPAGA
DELIMITER ;
DROP TABLE IF EXISTS `TMPCALINTPAGA`;DELIMITER $$

CREATE TABLE `TMPCALINTPAGA` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente',
  `InteresPagado` decimal(12,2) DEFAULT NULL COMMENT 'Monto de Interes Pagado',
  `InteresPonderado` decimal(12,2) DEFAULT NULL COMMENT 'Monto de Interes Pagado Ponderado',
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena datos temporales para calcular el interes pagado po'$$