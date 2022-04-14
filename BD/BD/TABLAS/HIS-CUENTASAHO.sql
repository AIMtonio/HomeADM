-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-CUENTASAHO
DELIMITER ;
DROP TABLE IF EXISTS `HIS-CUENTASAHO`;
DELIMITER $$


CREATE TABLE `HIS-CUENTASAHO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha` date NOT NULL COMMENT 'Fecha de paso a historico',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de Sucursal',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `MonedaID` int(11) NOT NULL COMMENT 'Numero de Moneda',
  `TipoCuentaID` int(11) NOT NULL COMMENT 'Numero de Tipo de Cuenta',
  `FechaApertura` datetime DEFAULT NULL COMMENT 'Fecha de apertura de cuenta',
  `Saldo` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Real\n',
  `SaldoDispon` decimal(12,2) DEFAULT NULL,
  `SaldoBloq` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Bloqueado',
  `SaldoSBC` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Buen Cobro\n',
  `SaldoIniMes` decimal(12,2) DEFAULT NULL,
  `CargosMes` decimal(12,2) DEFAULT NULL,
  `AbonosMes` decimal(12,2) DEFAULT NULL,
  `Comisiones` decimal(12,2) DEFAULT NULL,
  `SaldoProm` decimal(12,2) DEFAULT NULL,
  `TasaInteres` decimal(12,2) DEFAULT NULL,
  `InteresesGen` decimal(12,2) DEFAULT NULL,
  `ISR` decimal(12,2) DEFAULT NULL,
  `TasaISR` decimal(12,2) DEFAULT NULL,
  `SaldoIniDia` decimal(12,2) DEFAULT NULL,
  `CargosDia` decimal(12,2) DEFAULT NULL,
  `AbonosDia` decimal(12,2) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la cta; A - Activa	B - Bloqueada	C - Cancelada I – Inactiva R .- Registrada',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `ComApertura` decimal(12,2) DEFAULT NULL,
  `IvaComApertura` decimal(12,2) DEFAULT NULL,
  `ComManejoCta` decimal(12,2) DEFAULT NULL,
  `IvaComManejoCta` decimal(12,2) DEFAULT NULL,
  `ComAniversario` decimal(12,2) DEFAULT NULL,
  `IvaComAniv` decimal(12,2) DEFAULT NULL,
  `ComFalsoCobro` decimal(12,2) DEFAULT NULL,
  `IvaComFalsoCob` decimal(12,2) DEFAULT NULL,
  `ExPrimDispSeg` char(1) DEFAULT NULL COMMENT 'Exenta de Cobro de Comisión el Primer Dispositivo Seguridad\r\nS - Si lo exenta, No cobra comisión el primer token\r\nN - No lo exenta, Si cobra comisión        ',
  `ComDispSeg` decimal(12,2) DEFAULT NULL,
  `IvaComDispSeg` decimal(12,2) DEFAULT NULL,
  `Gat` decimal(12,2) DEFAULT NULL COMMENT 'Valor Gat',
  `GatReal` decimal(12,2) DEFAULT NULL,
  `ISRReal` decimal(12,2) DEFAULT '0.00' COMMENT 'La columna sirver paara acumular el sr Diario por socio solo cuando estee activa esta opcion en  PARAMGENERALES',
  `Clabe`				VARCHAR(18)		DEFAULT NULL COMMENT 'Numero de Clabe Interbancaria que tiene asignada la cuenta de ahorro al cierre de Mes',
  KEY `Fecha_index` (`Fecha`),
  KEY `CuentaAhoID_index` (`CuentaAhoID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico de Cuentas de Ahorro'$$
