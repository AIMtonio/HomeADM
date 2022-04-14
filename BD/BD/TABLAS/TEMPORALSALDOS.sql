-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TEMPORALSALDOS
DELIMITER ;
DROP TABLE IF EXISTS `TEMPORALSALDOS`;DELIMITER $$

CREATE TABLE `TEMPORALSALDOS` (
  `GrupoID` int(11) DEFAULT NULL,
  `SaldoCapital` decimal(14,2) DEFAULT NULL,
  `SaldoCorriente` decimal(14,2) DEFAULT NULL,
  `SaldoMora` decimal(14,2) DEFAULT NULL,
  `SaldoVencida` decimal(14,2) DEFAULT NULL,
  `NombreSucurs` varchar(200) DEFAULT NULL,
  `Clave` varchar(20) DEFAULT NULL,
  `FechaInicio` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$