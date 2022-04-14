
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWPAGOPENINV
DELIMITER ;
DROP TABLE IF EXISTS `CRWPAGOPENINV`;

DELIMITER $$
CREATE TABLE `CRWPAGOPENINV` (
  `SolFondeoID` int(11) NOT NULL COMMENT 'Numero de inversionista',
  `AmortizacionID` int(11) NOT NULL COMMENT 'Numero de amortizacion',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion\n',
  `CuentaAhoID` int(11) DEFAULT NULL COMMENT 'Cuenta de ahorro a depositar/retener',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente inversionista',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la operacion',
  `Monto` decimal(14,6) DEFAULT NULL COMMENT 'Monto',
  `TipoMovAhoID` int(11) DEFAULT NULL COMMENT 'Tipo de movimiento de ahorro',
  `Naturaleza` char(1) DEFAULT NULL COMMENT 'Naturaleza\nA: Abono\nC: Cargo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'P : Pendiente\nA: aplicado\n',
  `Retencion` decimal(14,6) DEFAULT NULL COMMENT 'Monto de Retencion',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de poliza',
  `CreditoID` int(11) DEFAULT NULL COMMENT 'Numero de Credito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`SolFondeoID`,`AmortizacionID`,`Transaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena los montos que tenemos pendientes de abonar al inve.'$$