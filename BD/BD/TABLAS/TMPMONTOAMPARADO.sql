-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPMONTOAMPARADO
DELIMITER ;
DROP TABLE IF EXISTS `TMPMONTOAMPARADO`;DELIMITER $$

CREATE TABLE `TMPMONTOAMPARADO` (
  `InversionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la inversion',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto Amparado',
  PRIMARY KEY (`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal fisica que se usa para guardar información del monto que esta amparado un cliente de una inversion hacia un credito, se usa en cambio de sucursal'$$