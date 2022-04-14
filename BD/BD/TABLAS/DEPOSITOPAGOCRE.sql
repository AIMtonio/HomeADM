-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOPAGOCRE
DELIMITER ;
DROP TABLE IF EXISTS `DEPOSITOPAGOCRE`;DELIMITER $$

CREATE TABLE `DEPOSITOPAGOCRE` (
  `FechaRegistro` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Registro\n',
  `Transaccion` bigint(20) NOT NULL COMMENT 'No de \nTransaccion',
  `Consecutivo` bigint(20) NOT NULL COMMENT 'No \nConsecutivo',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Credito',
  `ClienteID` int(11) NOT NULL COMMENT 'Cliente',
  `MontoDeposito` decimal(12,2) NOT NULL COMMENT 'Monto del \nDesposito',
  `MontoAplicado` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Pago \nEfectivamente Aplicado',
  `FechaAplicacion` date DEFAULT NULL COMMENT 'Fecha de \nAplicacion \ndel Pago',
  `NumTraAplica` bigint(20) DEFAULT NULL COMMENT 'Numero de la \nTransaccion de la \nAplicacion del Pago',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FechaRegistro`,`Transaccion`,`Consecutivo`),
  KEY `fk_DEPOSITOPAGOCRE_1` (`ClienteID`),
  KEY `fk_DEPOSITOPAGOCRE_2_idx` (`CreditoID`),
  CONSTRAINT `fk_DEPOSITOPAGOCRE_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_DEPOSITOPAGOCRE_2` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Depositos Efectuados para Pago de Creditos'$$