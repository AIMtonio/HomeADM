-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAPORTANCLADAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPAPORTANCLADAS`;DELIMITER $$

CREATE TABLE `TMPAPORTANCLADAS` (
  `AportacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Aportacion ID',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto',
  `InteresRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Interes Neto a Recibir',
  PRIMARY KEY (`AportacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: para Ajuste de Aportaciones Ancladas.'$$