-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPR04C0452PAVALES
DELIMITER ;
DROP TABLE IF EXISTS `TMPR04C0452PAVALES`;DELIMITER $$

CREATE TABLE `TMPR04C0452PAVALES` (
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'ID de la Solicitud de Credito',
  `NumAvales` int(11) DEFAULT NULL COMMENT 'Numero de Avales',
  `AvalID` bigint(20) DEFAULT NULL COMMENT 'ID del Aval',
  `ProspectoID` bigint(20) DEFAULT NULL COMMENT 'ID del Prospecto',
  `ClienteID` bigint(20) DEFAULT NULL COMMENT 'ID del Cliente	',
  `NombreGarante` varchar(250) DEFAULT NULL COMMENT 'Nombre del Garante',
  `RFCGarante` varchar(13) DEFAULT NULL COMMENT 'RFC del Garante',
  PRIMARY KEY (`NumTransaccion`,`SolicitudCreditoID`),
  KEY `TMPR04C0452PAVALES_IDX1` (`NumTransaccion`),
  KEY `TMPR04C0452PAVALES_IDX2` (`NumTransaccion`,`AvalID`),
  KEY `TMPR04C0452PAVALES_IDX3` (`NumTransaccion`,`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para el Regulatorio 452 seguimiento de cartera, seccion Avales'$$