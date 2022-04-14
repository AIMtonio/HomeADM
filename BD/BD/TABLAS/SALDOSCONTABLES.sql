-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCONTABLES
DELIMITER ;
DROP TABLE IF EXISTS `SALDOSCONTABLES`;DELIMITER $$

CREATE TABLE `SALDOSCONTABLES` (
  `EjercicioID` int(11) NOT NULL COMMENT 'Numero de \nEjercicio\nContable',
  `PeriodoID` int(11) NOT NULL COMMENT 'Numero de \nPeriodo\nContable',
  `CuentaCompleta` char(25) NOT NULL COMMENT 'Cuenta Contable\nCompleta',
  `CentroCosto` int(11) NOT NULL,
  `FechaCorte` date DEFAULT NULL COMMENT 'Fecha de Corte\\no de Ultimo\\nCierre Contable',
  `SaldoInicial` decimal(16,4) DEFAULT NULL,
  `Cargos` decimal(16,4) DEFAULT NULL,
  `Abonos` decimal(16,4) DEFAULT NULL,
  `SaldoFinal` decimal(16,4) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EjercicioID`,`PeriodoID`,`CuentaCompleta`,`CentroCosto`),
  KEY `fk_SALDOSCONTABLES_1` (`EjercicioID`),
  KEY `SaldosPorFecha` (`FechaCorte`),
  KEY `fk_SALDOSCONTABLES_2` (`FechaCorte`,`CuentaCompleta`),
  CONSTRAINT `fk_SALDOSCONTABLES_1` FOREIGN KEY (`EjercicioID`) REFERENCES `EJERCICIOCONTABLE` (`EjercicioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos de las Cuentas Conatables\nPor Corte de Periodo'$$