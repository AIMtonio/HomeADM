-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSPERFILTRANS
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOSPERFILTRANS`;DELIMITER $$

CREATE TABLE `TMPSALDOSPERFILTRANS` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `Anio` int(4) NOT NULL COMMENT 'Año de los Saldos',
  `Mes` int(2) NOT NULL COMMENT 'Mes de los Saldos',
  `TotalAbonos` decimal(34,2) DEFAULT NULL COMMENT 'Total de Abonos',
  `TotalCargos` decimal(34,2) DEFAULT NULL COMMENT 'Total de Cargos',
  `TotalDepositos` int(11) DEFAULT NULL COMMENT 'Total Depositos',
  `TotalRetiros` int(11) DEFAULT NULL COMMENT 'Total Retiros',
  PRIMARY KEY (`ClienteID`,`Anio`,`Mes`,`TransaccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para registrar los saldos del perfil '$$