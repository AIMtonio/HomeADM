-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROYECCIONINDICABASE
DELIMITER ;
DROP TABLE IF EXISTS `PROYECCIONINDICABASE`;DELIMITER $$

CREATE TABLE `PROYECCIONINDICABASE` (
  `ConsecutivoID` bigint(20) NOT NULL COMMENT 'ID o Numero de Indice',
  `Anio` int(11) DEFAULT NULL COMMENT 'Anio en el que se genera la Proyeccion ',
  `Mes` varchar(50) DEFAULT NULL COMMENT 'Mes de la Proyeccion',
  `SaldoTotal` decimal(16,2) DEFAULT '0.00' COMMENT 'Saldo Total de Cartera ',
  `SaldoFira` decimal(16,2) DEFAULT '0.00' COMMENT 'Saldo de Cartera Fira',
  `GastosAdmin` decimal(16,2) DEFAULT '0.00' COMMENT 'Saldo de Gastos de Administracion Acumulados',
  `CapitalConta` decimal(16,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Cotable',
  `UtilidadNeta` decimal(16,2) DEFAULT '0.00' COMMENT 'Saldo de Utilidad Neta Acumulada',
  `ActivoTotal` decimal(16,2) DEFAULT '0.00' COMMENT 'Saldo Total de Activos',
  `SaldoVencido` decimal(16,2) DEFAULT '0.00' COMMENT 'Saldo Total de Cartera Vencida',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `fk_Fecha` (`Anio`,`Mes`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Base con valores defaul para la Proyeccion de Indicadores'$$