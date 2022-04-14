-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCTASAHOMOV
DELIMITER ;
DROP TABLE IF EXISTS `TMPCTASAHOMOV`;
DELIMITER $$


CREATE TABLE `TMPCTASAHOMOV` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NumeroMov` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion',
  `Fecha` date DEFAULT NULL COMMENT 'fecha del movimiento',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `CantidadMov` decimal(14,2) DEFAULT NULL,
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Descripcion del movimiento en estado de cuenta',
  `ReferenciaMov` varchar(35) DEFAULT NULL COMMENT 'Origen del Movimiento, referencia',
  `TipoMovAhoID` varchar(4) DEFAULT NULL COMMENT 'Tipo de\nMovimiento',
  `MonedaID` int(11) DEFAULT NULL,
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de Poliza para el movimiento',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal de Movimientos de la Cuenta de Ahorro'$$
