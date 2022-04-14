-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPROTECCRED
DELIMITER ;
DROP TABLE IF EXISTS `CLIAPROTECCRED`;DELIMITER $$

CREATE TABLE `CLIAPROTECCRED` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente, debe de tener una solicitud de proteccion capturada',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito que pertenece al cliente ',
  `MontoAdeudo` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Adeuto Total del credito',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Credito ',
  `MontoAplicaCred` decimal(14,2) DEFAULT NULL COMMENT 'Monto que fue aprobado como beneficio de proteccion al ahorro y credito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`CreditoID`),
  KEY `fk_CLIAPROTECCRED_1_idx` (`ClienteID`),
  KEY `fk_CLIAPROTECCRED_2_idx` (`CreditoID`),
  CONSTRAINT `fk_CLIAPROTECCRED_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIAPLICAPROTEC` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIAPROTECCRED_2` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los creditos vigente que tenga el cliente en el momen'$$