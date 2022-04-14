-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCILIAMOVSATM
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCONCILIAMOVSATM`;DELIMITER $$

CREATE TABLE `TARDEBCONCILIAMOVSATM` (
  `TarDebMovID` int(11) NOT NULL,
  `TarjetaDebID` char(16) NOT NULL COMMENT 'Numero de la tarjeta del Movimiento Interno.\n',
  `MontoOperacion` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Operacion del Movimiento Interno',
  `FechaTransaccion` date DEFAULT NULL COMMENT 'Fecha del Movimiento Interno\n',
  `HoraTransaccion` char(10) DEFAULT NULL COMMENT 'Hora del Movimiento Interno',
  `Referencia` char(6) DEFAULT NULL COMMENT 'Referencia interna por PROSA',
  `ConciliaID` int(11) NOT NULL,
  `DetalleID` int(11) NOT NULL,
  `NumCuenta` varchar(19) DEFAULT NULL COMMENT 'Num Cta reportado por PROSA',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha reportada por PROSA',
  `HoraOperacion` char(10) DEFAULT NULL COMMENT 'Hora reportada por PROSA',
  `ImporteOperacion` decimal(12,2) DEFAULT NULL COMMENT 'Importe reportado por PROSA',
  `Secuencia` char(6) DEFAULT NULL COMMENT 'Referencia de PROSA',
  `NumAutorizacion` char(6) DEFAULT NULL COMMENT 'Num de Autorizacion de PROSA',
  `EstatusConciliado` char(1) DEFAULT NULL COMMENT 'Estatus:\nC.- Conciliado\nN.- No Conciliado'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$