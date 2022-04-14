-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDSEGTOOPER
DELIMITER ;
DROP TABLE IF EXISTS `PLDSEGTOOPER`;
DELIMITER $$


CREATE TABLE `PLDSEGTOOPER` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `FechaDetec` date NOT NULL COMMENT 'Fecha Deteccion',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `Fecha` date NOT NULL COMMENT 'fecha del movimiento',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `CantidadMov` decimal(12,2) DEFAULT NULL,
  `DescripcionMov` varchar(150) NOT NULL COMMENT 'Descripcion del movimiento en estado de cuenta',
  `ReferenciaMov` varchar(50) NOT NULL COMMENT 'Origen del Movimiento, referencia',
  `TipoMovAhoID` char(4) NOT NULL COMMENT 'Tipo de\nMovimiento',
  `MonedaID` int(11) NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `TipoPersona` char(1) NOT NULL COMMENT 'Tipo de\nPersona corresponde con el cliente',
  `NacionCliente` char(1) NOT NULL COMMENT 'Nacionalidad del Cliente',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Transaccion operacion si es sumarizado se inserta un cero',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  KEY `INDEX_PLDSEGTOOPER_1` (`FechaDetec`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los registros de las operaciones que requieren un seg'$$
