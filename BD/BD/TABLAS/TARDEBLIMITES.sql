-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBLIMITES
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBLIMITES`;DELIMITER $$

CREATE TABLE `TARDEBLIMITES` (
  `TarjetaDebID` char(16) NOT NULL DEFAULT '0' COMMENT 'ID del Tipo de Tarjeta de Debito',
  `NoDisposiDia` int(11) DEFAULT NULL COMMENT 'Numero de Disposiciones por Dia',
  `NumConsultaMes` int(11) DEFAULT NULL COMMENT 'Numero de Consultas al Mes',
  `DisposiDiaNac` decimal(12,4) DEFAULT NULL COMMENT 'MontoDiario Maximo de Disposiciones en ATM.',
  `DisposiMesNac` decimal(12,4) DEFAULT NULL COMMENT 'MontoMensual Maximo de Disposiciones en ATM',
  `ComprasDiaNac` decimal(12,4) DEFAULT NULL COMMENT 'MontoDiario Maximo de Compras y Operaciones POS.',
  `ComprasMesNac` decimal(12,4) DEFAULT NULL COMMENT 'MontoMensual Maximo de Compras y Operaciones POS.',
  `BloquearATM` char(1) DEFAULT NULL COMMENT 'No permite ningun tipo de Operaciones en ATM.',
  `BloquearPOS` char(1) DEFAULT NULL COMMENT 'No permite ningun tipo de Operaciones en POS',
  `BloquearCashBack` char(1) DEFAULT NULL COMMENT 'No permite ningun tipo de Operaciones de CashBack',
  `Vigencia` date DEFAULT NULL COMMENT 'Fecha de Vigencia Maxima  de Limite en esta Tarjeta.',
  `AceptaOpeMoto` char(1) DEFAULT NULL COMMENT 'Indica si se Acepta Operaciones MOTO\nS.- Si\nN.- No',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TarjetaDebID`),
  KEY `fk_TARDEBLIMITES_1` (`TarjetaDebID`),
  CONSTRAINT `fk_TARDEBLIMITES_1` FOREIGN KEY (`TarjetaDebID`) REFERENCES `TARJETADEBITO` (`TarjetaDebID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Limites de Operacion de una Tarjeta de Debito en Particular.'$$