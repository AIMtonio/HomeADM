-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBLIMITESXTIPO
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBLIMITESXTIPO`;DELIMITER $$

CREATE TABLE `TARDEBLIMITESXTIPO` (
  `TipoTarjetaDebID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del Tipo de Tarjeta de Debito',
  `NoDisposiDia` int(11) DEFAULT NULL COMMENT 'Numero de Disposiciones por Dia',
  `NumConsultaMes` int(11) DEFAULT NULL COMMENT 'Numero de Consultas al Mes',
  `DisposiDiaNac` decimal(12,4) DEFAULT NULL COMMENT 'MontoDiario Maximo de Disposiciones en ATM.',
  `DisposiMesNac` decimal(12,4) DEFAULT NULL COMMENT 'MontoMensual Maximo de Disposiciones en ATM',
  `ComprasDiaNac` decimal(12,4) DEFAULT NULL COMMENT 'MontoDiario Maximo de Compras y Operaciones POS.',
  `ComprasMesNac` decimal(12,4) DEFAULT NULL COMMENT 'MontoMensual Maximo de Compras y Operaciones POS.',
  `BloquearATM` char(1) DEFAULT NULL COMMENT 'No permite ningun tipo de Operaciones en ATM.',
  `BloquearPOS` char(1) DEFAULT NULL COMMENT 'No permite ningun tipo de Operaciones en POS',
  `BloquearCashBack` char(1) DEFAULT NULL COMMENT 'No permite ningun tipo de Operaciones de CashBack',
  `AceptaOpeMoto` char(1) DEFAULT NULL COMMENT 'Indica si se Acepta Operaciones MOTO\nS.- Si\nN.- No',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoTarjetaDebID`),
  KEY `fk_TARDEBLIMITESXTIPO_1` (`TipoTarjetaDebID`),
  CONSTRAINT `fk_TARDEBLIMITESXTIPO_1` FOREIGN KEY (`TipoTarjetaDebID`) REFERENCES `TIPOTARJETADEB` (`TipoTarjetaDebID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Limites de Operacion de la Tarjeta de Debito por Tipo de Tar'$$