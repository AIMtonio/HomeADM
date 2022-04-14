-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPOLIZASDESCUADRADAS
DELIMITER ;
DROP TABLE IF EXISTS `TMPPOLIZASDESCUADRADAS`;DELIMITER $$

CREATE TABLE `TMPPOLIZASDESCUADRADAS` (
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la \nPoliza',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion del\nMovimiento',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de la \nPoliza',
  `CentroCostoID` int(11) DEFAULT NULL COMMENT 'Centro de \nCostos',
  `Cargos` decimal(36,4) DEFAULT NULL,
  `Abonos` decimal(36,4) DEFAULT NULL,
  `Diferencia` decimal(37,4) DEFAULT NULL,
  `TransaccionID` bigint(20) DEFAULT NULL,
  `NCargos` decimal(23,0) DEFAULT NULL,
  `NAbonos` decimal(23,0) DEFAULT NULL,
  `NCargosCart` decimal(23,0) DEFAULT NULL,
  `NAbonosCart` decimal(23,0) DEFAULT NULL,
  `NCargosCartRed` decimal(23,0) DEFAULT NULL,
  `NAbonosCartRed` decimal(23,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$