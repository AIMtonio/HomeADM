-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_INVERSIONESRETENER
DELIMITER ;
DROP TABLE IF EXISTS `TMP_INVERSIONESRETENER`;DELIMITER $$

CREATE TABLE `TMP_INVERSIONESRETENER` (
  `InversionMigrada` int(11) NOT NULL COMMENT 'Llave primaria de Inversion Migrada',
  `InversionID` int(11) NOT NULL COMMENT 'Inversion actual',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Identificador del Cliente',
  `InteresRet` decimal(12,2) DEFAULT NULL COMMENT 'Interes a Retener de la Inversion',
  PRIMARY KEY (`InversionMigrada`),
  KEY `id_index1` (`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de retenciones pendientes'$$