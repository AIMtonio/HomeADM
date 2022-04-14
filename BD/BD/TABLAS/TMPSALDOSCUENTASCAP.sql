-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPSALDOSCUENTASCAP
DELIMITER ;
DROP TABLE IF EXISTS `TMPSALDOSCUENTASCAP`;DELIMITER $$

CREATE TABLE `TMPSALDOSCUENTASCAP` (
  `CuentaAhoID` bigint(11) NOT NULL,
  `TipoCuentaID` int(11) DEFAULT NULL COMMENT 'Tipo de cuenta',
  `Descripcion` varchar(30) DEFAULT NULL COMMENT 'Descripcion de la cuenta',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numero de Sucursal',
  `NombreSucurs` varchar(50) DEFAULT NULL COMMENT 'Nombre de sucursal',
  `SaldoIniMes` decimal(18,2) DEFAULT NULL COMMENT 'Saldo inicial',
  `SaldoDispon` decimal(18,2) DEFAULT NULL COMMENT 'Saldo disponible',
  `SaldoGarLiq` decimal(18,2) DEFAULT NULL COMMENT 'Saldo garantia liquida',
  `SaldoTotal` decimal(18,2) DEFAULT NULL COMMENT 'Saldo total',
  `EsMenor` char(1) DEFAULT NULL COMMENT 'Es menor edad\nSI = S\nNO = N',
  `ClasiConta` char(1) DEFAULT NULL COMMENT 'Clasificacion Contable',
  PRIMARY KEY (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para el registro de saldos de captacion'$$