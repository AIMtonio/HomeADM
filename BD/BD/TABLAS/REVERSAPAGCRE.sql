-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSAPAGCRE
DELIMITER ;
DROP TABLE IF EXISTS `REVERSAPAGCRE`;

DELIMITER $$
CREATE TABLE `REVERSAPAGCRE` (
  `TransaccionID` bigint(20) NOT NULL DEFAULT '0',
  `Fecha` date DEFAULT NULL,
  `CreditoID` bigint(12) NOT NULL DEFAULT '0',
  `Motivo` varchar(400) DEFAULT NULL COMMENT 'Motivo de la reversa del pago de crédito',
  `UsuarioAut` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CreditoID`,`TransaccionID`),
  KEY `fk_REVERSAPAGCRE_1_idx` (`CreditoID`),
  KEY `fk_REVERSAPAGCRE_2_idx` (`ClienteID`),
  CONSTRAINT `fk_REVERSAPAGCRE_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REVERSAPAGCRE_2` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='REVERSA PAGO DE CREDITOS'$$