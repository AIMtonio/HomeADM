-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWINVCONDONA
DELIMITER ;
DROP TABLE IF EXISTS `CRWINVCONDONA`;
DELIMITER $$

CREATE TABLE `CRWINVCONDONA` (
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Solicitud de fondeo',
  `AmortizacionID` int(11) NOT NULL COMMENT 'Id de Amortizacion',
  `ClienteID` int(12) DEFAULT NULL COMMENT 'Id de Cliente',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Id de la Cuenta',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Id del Credito',
  `FechaCondona` date NOT NULL COMMENT 'Fecha de condonación',
  `SaldoCapVigente` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Cap Vigente',
  `SaldoCapExigible` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Cap Exigible',
  `SaldoInteres` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Interes',
  `SaldoCapitalCO` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Capital Cuenta de Orden',
  `SaldoInteresCO` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Interes Cuenta de Orden',
  `SaldoIntMoratorio` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Int Moratorio',
  `EmpresaID` int(12) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`SolFondeoID`,`AmortizacionID`,`FechaCondona`,`FechaActual`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: CONDONACIONES DE INVERSIONES CROWDFUNDING'$$