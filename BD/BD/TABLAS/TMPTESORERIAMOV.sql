-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPTESORERIAMOV
DELIMITER ;
DROP TABLE IF EXISTS `TMPTESORERIAMOV`;DELIMITER $$

CREATE TABLE `TMPTESORERIAMOV` (
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `FolioMovimiento` int(11) NOT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NumeroMov` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion del Movimiento',
  `FechaMov` date DEFAULT NULL COMMENT 'Fecha del Movimiento',
  `NatMovimiento` varchar(10) DEFAULT NULL COMMENT 'Naturaleza del Movimiento \n C=Cargo, \nA=Abono',
  `MontoMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Movimiento',
  `TipoMov` char(4) DEFAULT NULL COMMENT 'Id de Los Tipos de Movimientos de la Cuenta',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Decripcion del Movimiento',
  `ReferenciaMov` varchar(150) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `Status` char(1) DEFAULT NULL COMMENT 'Estatus de Conciliacion \\nNacen como N=No Conciliado',
  `TipoRegistro` char(1) DEFAULT 'A' COMMENT 'Tipo de registros\nA: Automatico por carga de archivo\nP: Por pantalla',
  `EmpresaID` int(11) DEFAULT NULL,
  `Cargos` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Cargo',
  `Abonos` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Abono',
  `SaldoAcumulado` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Acumulado\nUsado en Reportes, de Edo Cta entre otros',
  KEY `NumTransacc` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$