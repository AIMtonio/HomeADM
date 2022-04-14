-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOVTEMP
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASAHOMOVTEMP`;DELIMITER $$

CREATE TABLE `CUENTASAHOMOVTEMP` (
  `CuentaAhoID` int(12) NOT NULL COMMENT 'Numero de cuenta de ahorro',
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `Fecha` date NOT NULL COMMENT 'fecha del movimiento',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `CantidadMov` decimal(12,2) DEFAULT NULL,
  `DescripcionMov` varchar(150) NOT NULL COMMENT 'Descripcion del movimiento en estado de cuenta',
  `ReferenciaMov` varchar(50) NOT NULL COMMENT 'Origen del Movimiento, referencia',
  `TipoMovAhoID` char(4) NOT NULL COMMENT 'Tipo de\nMovimiento',
  `MonedaID` int(11) NOT NULL,
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$