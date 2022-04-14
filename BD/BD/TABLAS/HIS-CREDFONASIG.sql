-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-CREDFONASIG
DELIMITER ;
DROP TABLE IF EXISTS `HIS-CREDFONASIG`;DELIMITER $$

CREATE TABLE `HIS-CREDFONASIG` (
  `InstitutFondeoID` int(11) DEFAULT NULL,
  `LineaFondeoID` int(11) DEFAULT NULL,
  `CreditoFondeoID` bigint(20) DEFAULT NULL,
  `SaldoCapFon` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de capital del credito en la fecha indicada',
  `PorcenExtra` decimal(12,4) DEFAULT NULL,
  `CantIntegra` decimal(14,2) DEFAULT NULL,
  `CreditoID` int(11) DEFAULT NULL COMMENT 'Credito que se asigna',
  `MontoCredito` decimal(12,2) DEFAULT NULL COMMENT 'Monto de credito que se asigna',
  `SaldoCapCre` decimal(14,2) DEFAULT NULL COMMENT 'Saldo del capital en la fecha indicada',
  `FechaAsignacion` date DEFAULT NULL COMMENT 'fecha en que se asigna el creditoal credito fondeo',
  `UsuarioAsigna` int(11) DEFAULT NULL COMMENT 'Usuario que autoriza',
  `FormaSeleccion` char(1) DEFAULT NULL COMMENT 'Indica si el credito es manual = "M" o si es automatico = "A"',
  `CondicionesCum` varchar(400) DEFAULT NULL COMMENT 'Indica las condiciones que se cumplieron si fue manual = "MANUAL"\nsi es automatico "TipoCte;TipoProducto;Edo;Municipio"',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `index6` (`FechaAsignacion`,`InstitutFondeoID`,`LineaFondeoID`,`CreditoFondeoID`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='HISTORICO TABLA DE ASIGNACION DE CREDITOS DE FONDEO'$$