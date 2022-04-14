-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVTESO
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVTESO`;DELIMITER $$

CREATE TABLE `TIPOSMOVTESO` (
  `TipoMovTesoID` char(4) NOT NULL COMMENT 'Numero o ID de Movimiento, consecutivo\n',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion o Proceso',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Movimiento',
  `TipoMovimiento` char(1) DEFAULT NULL COMMENT 'Tipo de Movimiento\\nI .- Inversiones Bancarias\\nC .- Conciliacion\\nR .- Dep. Referenciados\\nD .- Dispersion de Recursos\\nP .- Pago a Proveedores\\nV .- Caja o Boveda',
  `CuentaContable` char(25) DEFAULT NULL COMMENT 'Cuenta Contable que afecta. Usado en Tipo de movimiento de conciliacion',
  `CuentaMayor` varchar(4) DEFAULT NULL COMMENT 'Cuenta Contable de Mayor. Usado en Tipo de movimiento de conciliacion',
  `CuentaEditable` char(1) DEFAULT NULL COMMENT 'Indica si la Cuenta es Editable o NO. Usado en Tipo de movimiento de conciliacion\nS .- Si es editables o Capturable\nN .- No es Editable',
  `NaturaContable` char(1) DEFAULT NULL COMMENT 'Naturaleza de la Cuenta Contable. Usado en Tipo de movimiento de conciliacion\nC .- Cargo\nA .- Abono',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoMovTesoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Movimientos del Modulo de  Inversiones'$$