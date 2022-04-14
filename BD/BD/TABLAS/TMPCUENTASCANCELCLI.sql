-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCUENTASCANCELCLI
DELIMITER ;
DROP TABLE IF EXISTS `TMPCUENTASCANCELCLI`;
DELIMITER $$


CREATE TABLE `TMPCUENTASCANCELCLI` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Numero de Sucursal del Cliente',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de persona del cliente',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Numero de Moneda',
  `TipoCuentaID` int(11) DEFAULT NULL COMMENT 'Numero de Tipo de Cuenta',
  `SaldoIniMes` decimal(14,2) DEFAULT NULL,
  `SaldoProm` decimal(14,2) DEFAULT NULL,
  `TasaInteres` decimal(14,2) DEFAULT NULL,
  `InteresesGen` decimal(14,2) DEFAULT NULL,
  `ISR` decimal(14,2) DEFAULT NULL,
  `TasaISR` decimal(14,2) DEFAULT NULL,
  `GeneraInteres` char(1) DEFAULT NULL COMMENT 'Si la cuenta genera o no interes. S Si genera, N no genera ',
  `TipoInteres` char(1) DEFAULT NULL COMMENT 'tipo de intereses que genera, ''D'' = diario; ''M'' = mensual',
  `PagaISR` char(1) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `Saldo` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de la cuenta de ahorro',
  KEY `index1` (`CuentaAhoID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal de Cuentas de Ahorro para la cancelacion de s'$$
