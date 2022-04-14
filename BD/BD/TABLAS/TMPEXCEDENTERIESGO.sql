-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEXCEDENTERIESGO
DELIMITER ;
DROP TABLE IF EXISTS `TMPEXCEDENTERIESGO`;DELIMITER $$

CREATE TABLE `TMPEXCEDENTERIESGO` (
  `GrupoID` int(11) DEFAULT NULL,
  `RiesgoID` varchar(200) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `NombreIntegrante` varchar(200) DEFAULT NULL,
  `TipoPersona` varchar(20) DEFAULT NULL,
  `RFC` char(13) DEFAULT NULL,
  `CURP` char(18) DEFAULT NULL,
  `SaldoIntegrante` double(14,2) DEFAULT NULL,
  `SaldoGrupal` double(14,2) DEFAULT NULL,
  KEY `idx_TMPEXCEDENTERIESGO_1` (`GrupoID`),
  KEY `idx_TMPEXCEDENTERIESGO_2` (`ClienteID`),
  KEY `idx_TMPEXCEDENTERIESGO_3` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$