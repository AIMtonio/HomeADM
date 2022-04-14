-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOINVGAR
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOINVGAR`;DELIMITER $$

CREATE TABLE `CREDITOINVGAR` (
  `CreditoInvGarID` int(11) NOT NULL COMMENT 'Consecutivo de la tabla CREDITOINVGAR',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Credito relacionado',
  `InversionID` int(11) DEFAULT NULL COMMENT 'Inversion usada como Garantia para el credito',
  `MontoEnGar` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la inversion que se esta dejando como garantia',
  `FechaAsignaGar` date DEFAULT NULL COMMENT 'Fecha en que se asigna la Garantia',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CreditoInvGarID`),
  KEY `fk_CREDITOINVGAR_1_idx` (`InversionID`),
  KEY `fk_CREDITOINVGAR_2_idx2` (`CreditoID`),
  CONSTRAINT `fk_CREDITOINVGAR_1` FOREIGN KEY (`InversionID`) REFERENCES `INVERSIONES` (`InversionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CREDITOINVGAR_2` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Asignar inversiones a un credito'$$