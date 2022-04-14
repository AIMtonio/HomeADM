-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONOCIMIENTOCTA
DELIMITER ;
DROP TABLE IF EXISTS `CONOCIMIENTOCTA`;DELIMITER $$

CREATE TABLE `CONOCIMIENTOCTA` (
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0',
  `DepositoCred` decimal(12,2) DEFAULT NULL,
  `RetirosCargo` decimal(12,2) DEFAULT NULL,
  `ProcRecursos` varchar(80) DEFAULT NULL COMMENT 'Procedencia de los recursos para la Apertura	',
  `ConcentFondo` char(1) DEFAULT NULL COMMENT 'Su cuenta la utilizara para concentracion de Fondos? Si=S No=N',
  `AdmonGtosIng` char(1) DEFAULT NULL COMMENT 'Su cuenta la utilizara para Administracion de Gastos e Ingresos? Si=S No=N',
  `PagoNomina` char(1) DEFAULT NULL COMMENT 'Su cuenta la utilizara para Pago de Nomina? Si=S No=N',
  `CtaInversion` char(1) DEFAULT NULL COMMENT 'Su cuenta la utilizara para cuenta para inversion? Si=S No=N',
  `PagoCreditos` char(1) DEFAULT NULL COMMENT 'Su cuenta la utilizara para cuenta para Pagos de Credios? Si=S No=N',
  `OtroUso` char(1) DEFAULT NULL COMMENT 'Su cuenta la utilizara para cuenta para otro uso? Si=S No=N',
  `DefineUso` varchar(40) DEFAULT NULL COMMENT 'Definir otro uso en caso de que OtroUso = S	',
  `RecursoProvProp` char(2) DEFAULT NULL COMMENT 'Los \r\nrecursos que manejara en su cuenta provienen de Recursos Propios = P ',
  `RecursoProvTer` char(2) DEFAULT NULL COMMENT 'Los recursos que manejara en su cuenta provienen de Recursos de Terceros = T',
  `NumDepositos` int(11) DEFAULT NULL COMMENT 'Numero de Depositos permitidos para la Cuenta.',
  `FrecDepositos` int(11) DEFAULT NULL COMMENT 'Frecuencia (en días) de Depositos permitidos para la Cuenta.',
  `NumDepoApli` int(11) DEFAULT NULL COMMENT 'Numero de Depositos Aplicados, Incrementa con Cada Deposito a la Cuenta.\nInicia en Cero',
  `NumRetiros` int(11) DEFAULT NULL COMMENT 'Numero de Retiros permitidos para la Cuenta.',
  `FrecRetiros` int(11) DEFAULT NULL COMMENT 'Frecuencia (en días) de Retiros permitidos para la Cuenta.',
  `NumRetiApli` int(11) DEFAULT NULL COMMENT 'Numero de Retiros Aplicados, Incrementa con Cada Retiro a la Cuenta.\nInicia en Cero',
  `MediosElectronicos` char(1) DEFAULT 'N' COMMENT 'Su cuenta la utilizara para cuenta para Medios Electronicos? Si=S No=N',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CuentaAhoID`),
  KEY `fk_CONOCIMIENTOCTA_1` (`CuentaAhoID`),
  CONSTRAINT `fk_CONOCIMIENTOCTA_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Firmas Autorizadas de la Cuenta de Ahorro'$$