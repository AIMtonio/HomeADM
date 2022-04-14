DELIMITER ;
DROP TABLE IF EXISTS `DEPOSITOACTIVACTAAHO`;
DELIMITER $$

CREATE TABLE `DEPOSITOACTIVACTAAHO` (
  `DepositoActCtaID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador del deposito para activar la cuenta de ahorro',
  `FechaRegistro` date NOT NULL COMMENT 'Fecha de registro del deposito',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Identificador de la cuenta de ahorro',
  `MontoDepositoActiva` decimal(18,2) NOT NULL COMMENT 'Monto del deposito para activar la cuenta de ahorro',
  `FechaDeposito` date NOT NULL COMMENT 'Fecha en que realizo el deposito en ventanilla',
  `PolizaIDDeposito` bigint(12) NOT NULL COMMENT 'ID de Poliza del deposito en ventanilla',
  `NumTransaccionDep` bigint(20) NOT NULL COMMENT 'Numero de la transaccion del deposito en ventanilla',
  `FechaBloqueo` date NOT NULL COMMENT 'Fecha de activacion de la cuenta y bloqueo del deposito, para cuentas existentes solo fecha del bloqueo',
  `BloqueoID` int(11) NOT NULL COMMENT 'Id del bloqueo del monto de deposito para activar',
  `PolizaIDActiva` bigint(12) NOT NULL COMMENT 'ID de Poliza del abono a abono a la cuenta al activarla',
  `NumTransaccionAct` bigint(20) NOT NULL COMMENT 'Numero de la transaccion del abono y bloqueo al momento de activar la cuenta, para cuentas existentes solo del bloqueo',
  `Estatus` int(1) NOT NULL COMMENT 'Indica el estatus del deposito: 1-Registrado, 2-Depositado, 3-Bloqueado, 4-Desbloqueado',
  `TipoRegistroCta` char(1) NOT NULL COMMENT 'Indica el tipo de registro N= Nueva cuenta, E= Existente cuenta',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`DepositoActCtaID`),
  KEY `idx_DEPOSITOACTIVACTAAHO_1` (`CuentaAhoID`),
  KEY `idx_DEPOSITOACTIVACTAAHO_2` (`BloqueoID`),
  KEY `idx_DEPOSITOACTIVACTAAHO_3` (`PolizaIDDeposito`),
  KEY `idx_DEPOSITOACTIVACTAAHO_4` (`NumTransaccionDep`),
  KEY `idx_DEPOSITOACTIVACTAAHO_5` (`BloqueoID`),
  KEY `idx_DEPOSITOACTIVACTAAHO_6` (`PolizaIDActiva`),
  KEY `idx_DEPOSITOACTIVACTAAHO_7` (`NumTransaccionAct`),
  KEY `idx_DEPOSITOACTIVACTAAHO_8` (`Estatus`),
  KEY `idx_DEPOSITOACTIVACTAAHO_9` (`TipoRegistroCta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB:Almacacena las cuentas de ahorro que requieren un deposito para activacion'$$