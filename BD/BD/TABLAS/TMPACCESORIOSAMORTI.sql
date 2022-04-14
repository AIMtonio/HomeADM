-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPACCESORIOSAMORTI
DELIMITER ;
DROP TABLE IF EXISTS `TMPACCESORIOSAMORTI`;
DELIMITER $$

CREATE TABLE `TMPACCESORIOSAMORTI` (
  `Consecutivo` 		INT(11) NOT NULL COMMENT 'Indice concecutivo para la tabla Temporal',
  `AccesorioID` 		INT(11) NOT NULL COMMENT 'ID del accesorio',
  `CreditoID` 			BIGINT(11) NOT NULL COMMENT 'ID del credito',
  `NumeroTransaccion` 	BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Consecutivo`)
  ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal para recorrer los accesorios de los creditos.'$$
