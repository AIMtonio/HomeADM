-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBTMPMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBTMPMOVS`;DELIMITER $$

CREATE TABLE `TARDEBTMPMOVS` (
  `ConciliaID` int(11) NOT NULL COMMENT 'ID conciliacion externo',
  `DetalleID` int(11) NOT NULL COMMENT 'ID del detalle de conciliacion externo',
  `NumCuenta` varchar(19) DEFAULT NULL COMMENT 'Numero de Tarjeta con la que se hizo la transaccion',
  `FechaConsumo` date DEFAULT NULL,
  `FechaProceso` date DEFAULT NULL COMMENT 'Fecha de Proceso de la Transaccion',
  `TipoTransaccion` char(2) DEFAULT NULL COMMENT 'Tipo de transacción  01.- Ventas  20 pagos 18.-Cash-back 21.-Devoluciones',
  `ImporteOrigenTrans` decimal(12,2) DEFAULT NULL,
  `NumAutorizacion` char(6) DEFAULT NULL COMMENT 'Numero Transaccion PROSA',
  `EstatusConci` char(1) DEFAULT NULL COMMENT 'Estatus del Registro'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$