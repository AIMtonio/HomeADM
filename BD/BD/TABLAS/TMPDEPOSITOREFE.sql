-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDEPOSITOREFE
DELIMITER ;
DROP TABLE IF EXISTS `TMPDEPOSITOREFE`;DELIMITER $$

CREATE TABLE `TMPDEPOSITOREFE` (
  `FolioCargaID` bigint(17) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `FechaCarga` date DEFAULT NULL,
  `MontoMov` decimal(12,2) DEFAULT NULL,
  `MonedaId` int(11) DEFAULT NULL,
  `TipCamDof` double DEFAULT NULL,
  `TipoDeposito` char(1) DEFAULT NULL,
  `TipoCanal` int(11) DEFAULT NULL,
  `CambioPeso` double DEFAULT NULL,
  `CambioDolar` decimal(18,2) DEFAULT NULL,
  `ReferenciaMov` varchar(50) DEFAULT NULL COMMENT 'Referencia del Deposito\n',
  `FechaOpera` date DEFAULT NULL,
  `Hora` time DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `TipoMovAhoID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal DepositoRefere'$$