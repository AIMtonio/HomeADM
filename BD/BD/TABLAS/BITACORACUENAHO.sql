-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACUENAHO
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACUENAHO`;DELIMITER $$

CREATE TABLE `BITACORACUENAHO` (
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de Sucursal',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `Clabe` varchar(18) NOT NULL COMMENT 'Cuenta Clabe',
  `MonedaID` int(11) NOT NULL COMMENT 'Numero de Moneda',
  `TipoCuentaID` int(11) NOT NULL COMMENT 'Numero de Tipo de Cuenta',
  `FechaReg` datetime NOT NULL COMMENT 'Fecha de registro de cuenta',
  `FechaApertura` datetime DEFAULT NULL COMMENT 'Fecha de apertura de cuenta',
  `UsuarioApeID` int(11) DEFAULT NULL COMMENT 'usuario que autoriza la apertura de cuenta',
  `Etiqueta` varchar(60) DEFAULT NULL COMMENT 'motivo por el que abrio la cuenta',
  `SaldoDispon` decimal(12,2) DEFAULT NULL,
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
  `EstadoCta` char(1) DEFAULT NULL COMMENT 'Indica a donde sera mandado el estado de cuenta\n“D” Domicilio\n“I” Internet\n“S” Sucursal\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `NumError` int(11) DEFAULT NULL,
  `ErrorMen` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cuentas de Ahorro'$$