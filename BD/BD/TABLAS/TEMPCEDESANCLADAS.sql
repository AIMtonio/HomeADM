-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMPCEDESANCLADAS
DELIMITER ;
DROP TABLE IF EXISTS `TEMPCEDESANCLADAS`;DELIMITER $$

CREATE TABLE `TEMPCEDESANCLADAS` (
  `CedeID` int(11) NOT NULL DEFAULT '0' COMMENT 'Cede ID',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto',
  `InteresRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Interes Neto a Recibir',
  PRIMARY KEY (`CedeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Ajuste de Cedes Ancladas'$$