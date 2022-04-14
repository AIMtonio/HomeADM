-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLICOBROSPROFUN
DELIMITER ;
DROP TABLE IF EXISTS `CLICOBROSPROFUN`;DELIMITER $$

CREATE TABLE `CLICOBROSPROFUN` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero del Cliente',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en que se genero el ultimo cargo',
  `FechaCobro` date DEFAULT NULL COMMENT 'Fecha en que se realizo el ultimo cargo',
  `Monto` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad que se le cobrara al cliente',
  `MontoCobrado` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad cobrada al cliente',
  `MontoPendiente` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad Pendiente de cobro',
  `FechaBaja` date DEFAULT NULL COMMENT 'Fecha en que se dio de baja al usuario',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`),
  KEY `fk_CLICOBROSPROFUN_1_idx` (`ClienteID`),
  KEY `index3` (`MontoPendiente`),
  KEY `index4` (`FechaBaja`),
  CONSTRAINT `fk_CLICOBROSPROFUN_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTESPROFUN` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda un acumulado de los cobros que se generan diarios por'$$