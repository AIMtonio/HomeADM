-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCILIAMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCONCILIAMOVS`;
DELIMITER $$


CREATE TABLE `TARDEBCONCILIAMOVS` (
  `TarDebMovID` int(11) NOT NULL COMMENT 'Numero de Movimiento Interno',
  `TipoOperacionID` char(2) DEFAULT NULL COMMENT 'Tipo de Operacion Interno\n00 .- Compra Normal\n01 .- Retiro de Efectivo\n30 .- Cosulta de Saldo\n09 .- Compra + Retiro',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'NumTarjetaDebito',
  `MontoOperacion` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Transaccion',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha de la Operacion',
  `NumReferencia` char(20) DEFAULT NULL COMMENT 'Numero de Transaccion PROSA',
  `ConciliaID` int(11) NOT NULL COMMENT 'ID conciliacion',
  `DetalleID` int(11) NOT NULL COMMENT 'ID del detalle de conciliacion',
  `NumCuenta` varchar(19) DEFAULT NULL COMMENT 'Numero de Tarjeta con la que se hizo la transaccion',
  `FechaConsumo` date DEFAULT NULL,
  `FechaProceso` date DEFAULT NULL COMMENT 'Fecha de Proceso de la Transaccion',
  `TipoTransaccion` char(2) DEFAULT NULL COMMENT 'Tipo de transacción  01.- Ventas  20 pagos 18.-Cash-back 21.-Devoluciones',
  `ImporteOrigenTrans` decimal(12,2) DEFAULT NULL,
  `NumAutorizacion` char(6) DEFAULT NULL COMMENT 'Numero de Transaccion PROSA',
  `EstatusConci` char(1) DEFAULT NULL COMMENT 'Estatus del Registro'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$