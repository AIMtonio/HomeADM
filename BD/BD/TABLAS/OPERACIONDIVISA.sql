-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPERACIONDIVISA
DELIMITER ;
DROP TABLE IF EXISTS `OPERACIONDIVISA`;
DELIMITER $$


CREATE TABLE `OPERACIONDIVISA` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda',
  `NumeroMovimiento` bigint(20) NOT NULL,
  `Fecha` date NOT NULL COMMENT 'Fecha del\nMovimiento',
  `MontoMN` decimal(12,2) DEFAULT NULL,
  `MontoDivisa` decimal(12,2) DEFAULT NULL,
  `TipoCambio` double NOT NULL COMMENT 'Tipo de Cambio',
  `Origen` char(1) NOT NULL COMMENT 'Origen\nS .- Sucursal\nI .- Interna o de \n      Sistema',
  `TipoOperacion` char(1) NOT NULL COMMENT 'Tipo de Operacion:\nC .- Compra\nV .- Venta',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion\n',
  `Referencia` varchar(30) NOT NULL COMMENT 'Referencia',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_OPERACIONDIVISA_1` (`MonedaID`),
  CONSTRAINT `fk_OPERACIONDIVISA_1` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Operaciones de Compra Venta\ncon Divisas o Monedas E'$$
