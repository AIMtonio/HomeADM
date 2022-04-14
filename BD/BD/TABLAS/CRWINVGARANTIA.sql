-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWINVGARANTIA
DELIMITER ;
DROP TABLE IF EXISTS `CRWINVGARANTIA`;

DELIMITER $$
CREATE TABLE `CRWINVGARANTIA` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Número de Transaccion',
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Numero de inversion\n',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Cuenta de ahorro',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Credito Relacionado a la inversion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de cliente(fondeador)',
  `MontoCapital` decimal(14,4) DEFAULT NULL COMMENT 'Monto a cargar pora la Garantia',
  `MontoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Tipo de aplicacion de Garantia C:Capital I:Interes',
  `ISR` decimal(14,4) DEFAULT NULL COMMENT 'ISR',
  `SucursalID` int(5) DEFAULT NULL COMMENT 'sucursal del Cliente (fondeador)',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda inversion',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoría.',
  PRIMARY KEY (`Transaccion`,`SolFondeoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena la cantidad a cargar a las  cuentas de ahorro de lo'$$
