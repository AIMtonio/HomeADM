-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_TMPLINEAMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TC_TMPLINEAMOVS`;
DELIMITER $$


CREATE TABLE `TC_TMPLINEAMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  `LineaTarCredID` bigint(12) DEFAULT NULL COMMENT 'ID del Credito',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha',
  `SaldoDia` decimal(16,2) DEFAULT NULL COMMENT 'Saldo del Dia',
  KEY `TmpLineaMovs_LineaTarCredID` (`LineaTarCredID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Temporal para el Calculo de Saldo Promedio en Cierre de Periodo de Lineas de Credito'$$
