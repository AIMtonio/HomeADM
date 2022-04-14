-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EFECTIVOMOVS
DELIMITER ;
DROP TABLE IF EXISTS `EFECTIVOMOVS`;
DELIMITER $$


CREATE TABLE `EFECTIVOMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CuentasAhoID` bigint(12) DEFAULT NULL,
  `ClienteID` int(11) NOT NULL,
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `Fecha` date NOT NULL COMMENT 'fecha del movimiento',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `CantidadMov` decimal(12,2) NOT NULL,
  `DescripcionMov` varchar(150) NOT NULL COMMENT 'Descripcion del movimiento en estado de cuenta',
  `ReferenciaMov` varchar(50) NOT NULL COMMENT 'Origen del Movimiento, referencia',
  `TipoMovAhoID` char(4) NOT NULL COMMENT 'Tipo de\nMovimiento',
  `MonedaID` int(11) NOT NULL,
  `Estatus` char(1) NOT NULL COMMENT 'Si - ''S'' \nNo - ''N''\n\n',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  KEY `index_CuentasAhoID` (`CuentasAhoID`),
  KEY `index_ClienteID` (`ClienteID`),
  KEY `index_NumeroMov` (`NumeroMov`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Movimientos en Efectivo'$$
