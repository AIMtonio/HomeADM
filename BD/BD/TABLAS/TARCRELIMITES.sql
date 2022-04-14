-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCRELIMITES
DELIMITER ;
DROP TABLE IF EXISTS `TARCRELIMITES`;DELIMITER $$

CREATE TABLE `TARCRELIMITES` (
  `TarjetaCredID` char(16) NOT NULL DEFAULT '0' COMMENT 'ID del Tipo de Tarjeta de Credito',
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
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo Auditoria',
  KEY `TarjetaCredID` (`TarjetaCredID`),
  CONSTRAINT `TARCRELIMITES_ibfk_1` FOREIGN KEY (`TarjetaCredID`) REFERENCES `TARJETACREDITO` (`TarjetaCredID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Lleva el registro de Limites por Tarjeta de Credito'$$