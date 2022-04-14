-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_LINEACREDITOMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TC_LINEACREDITOMOVS`;
DELIMITER $$


CREATE TABLE `TC_LINEACREDITOMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `LineaTarCredID` bigint(20) DEFAULT NULL COMMENT 'Identificador de la Linea de Credito',
  `TarjetaCredID` varchar(16) DEFAULT NULL COMMENT 'Numero de la tarjeta de Credito',
  `NumeroMov` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion que proviene del Archivo de Operaciones',
  `FechaConsumo` date DEFAULT NULL COMMENT 'Fecha de Consumo de la operacion',
  `FechaAplicacion` date DEFAULT NULL COMMENT 'Fecha de aplicacion del cargo o abono',
  `TipoMovLinID` int(11) DEFAULT NULL COMMENT 'Tipo de movimiento',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del movimiento C: Cargos, A: Abonos',
  `CantidadMov` decimal(16,2) DEFAULT NULL COMMENT 'Cantidad del Movimiento',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Descripcion del Movimiento',
  `ReferenciaMov` varchar(50) DEFAULT NULL COMMENT 'Referencia del Movimiento',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Tipo de Moneda',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de poliza',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  KEY `TC_LINEACREDITOMOVS_1` (`LineaTarCredID`),
  KEY `TC_LINEACREDITOMOVS_2` (`TarjetaCredID`),
  KEY `TC_LINEACREDITOMOVS_3` (`FechaConsumo`),
  KEY `TC_LINEACREDITOMOVS_4` (`LineaTarCredID`,`FechaConsumo`),
  KEY `TC_LINEACREDITOMOVS_5` (`TarjetaCredID`,`FechaConsumo`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Movimientos de la linea de credito'$$
