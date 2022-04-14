-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDHISPERFDETEC
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDHISPERFDETEC`;DELIMITER $$

CREATE TABLE `TMPPLDHISPERFDETEC` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente ID',
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de transaccion del Registro',
  PRIMARY KEY (`ClienteID`,`TransaccionID`),
  KEY `IDX_TMPPLDHISPERFDETEC_1` (`ClienteID`,`TransaccionID`),
  KEY `IDX_TMPPLDHISPERFDETEC_2` (`TransaccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena el historico del perfil transaccional'$$