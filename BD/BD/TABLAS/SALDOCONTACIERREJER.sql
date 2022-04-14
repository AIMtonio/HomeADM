-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOCONTACIERREJER
DELIMITER ;
DROP TABLE IF EXISTS `SALDOCONTACIERREJER`;DELIMITER $$

CREATE TABLE `SALDOCONTACIERREJER` (
  `Anio` int(11) NOT NULL COMMENT 'Numero de \nEjercicio\nContable',
  `EjercicioID` int(11) NOT NULL COMMENT 'Numero de \nEjercicio\nContable',
  `PeriodoID` int(11) NOT NULL COMMENT 'Numero de \nPeriodo\nContable',
  `CuentaCompleta` char(25) NOT NULL COMMENT 'Cuenta Contable\nCompleta',
  `CentroCosto` int(11) NOT NULL COMMENT 'Centro de costos',
  `FechaCorte` date DEFAULT NULL COMMENT 'Fecha de Corte',
  `SaldoInicial` decimal(16,4) DEFAULT NULL COMMENT 'Saldo Inicial',
  `Cargos` decimal(16,4) DEFAULT NULL COMMENT 'Cargos',
  `Abonos` decimal(16,4) DEFAULT NULL COMMENT 'Abonos',
  `SaldoFinal` decimal(16,4) DEFAULT NULL COMMENT 'Saldo Final',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`Anio`,`CuentaCompleta`,`CentroCosto`,`EjercicioID`,`PeriodoID`),
  KEY `fk_SALDOCONTACIERREJER_1` (`EjercicioID`),
  KEY `SaldosPorAnio` (`Anio`),
  KEY `fk_SALDOCONTACIERREJER_2` (`Anio`,`CuentaCompleta`),
  CONSTRAINT `fk_SALDOCONTACIERREJER_1` FOREIGN KEY (`EjercicioID`) REFERENCES `EJERCICIOCONTABLE` (`EjercicioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos de las Cuentas Conatables al Cierre del Ejercicio'$$