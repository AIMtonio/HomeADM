-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESORERIAMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TESORERIAMOVS`;DELIMITER $$

CREATE TABLE `TESORERIAMOVS` (
  `FolioMovimiento` int(11) NOT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NumeroMov` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion del Movimiento',
  `FechaMov` date DEFAULT NULL COMMENT 'Fecha del Movimiento',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento \n C=Cargo, \nA=Abono',
  `MontoMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Movimiento',
  `TipoMov` char(4) DEFAULT NULL COMMENT 'Id de Los Tipos de Movimientos de la Cuenta',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Decripcion del Movimiento',
  `ReferenciaMov` varchar(150) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `Status` char(1) DEFAULT NULL COMMENT 'Estatus de Conciliacion \\nNacen como N=No Conciliado',
  `TipoRegristro` char(1) DEFAULT 'A' COMMENT 'Tipo de registros\nA: Automatico por carga de archivo\nP: Por pantalla',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioMovimiento`),
  KEY `FECHACUENTA` (`FechaMov`,`CuentaAhoID`),
  KEY `fk_TESORERIAMOVS_1` (`TipoMov`),
  CONSTRAINT `fk_TESORERIAMOVS_1` FOREIGN KEY (`TipoMov`) REFERENCES `TIPOSMOVTESO` (`TipoMovTesoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$