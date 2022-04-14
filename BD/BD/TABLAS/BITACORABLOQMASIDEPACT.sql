DELIMITER ;
DROP TABLE IF EXISTS `BITACORABLOQMASIDEPACT`;
DELIMITER $$

CREATE TABLE `BITACORABLOQMASIDEPACT` (
  `NumTransacProceso` bigint(20) NOT NULL COMMENT 'Numero de la transaccion para procesar las cuentas',
  `BitacoraBloqID` int(11) NOT NULL COMMENT 'Identificador consecutivo de la cuenta por transaccion',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Identificador de la cuenta de ahorro',
  `EstatusCta` char(1) NOT NULL COMMENT 'Estatus de la cta; A - Activa	B - Bloqueada	C - Cancelada I – Inactiva R .- Registrada',
  `EstatusDepAct` int(1) NOT NULL COMMENT 'Indica el estatus del deposito: 1-Registrado, 2-Depositado, 3-Bloqueado, 4-Desbloqueado',
  `SaldoDispon` decimal(12,2) NOT NULL COMMENT 'Saldo Disponible en la cuenta',
  `MontoDepositoActiva` decimal(18,2) NOT NULL COMMENT 'Monto del deposito para activar la cuenta de ahorro',
  `NumErr` int(1) NOT NULL COMMENT 'Numero de error al realizar el bloqueo',
  `ErrMen` varchar(400) NOT NULL DEFAULT 'Mensaje de errror al realizar el bloqueo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`NumTransaccion`,`BitacoraBloqID`),
  KEY `idx_BITACORABLOQMASIDEPACT_1` (`CuentaAhoID`),
  KEY `idx_BITACORABLOQMASIDEPACT_2` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB:Bitacora de las cuentas existentes, que requieren un bloqueo por deposito de activacion'$$