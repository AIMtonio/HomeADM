-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELCREDPASIVOAGRO
DELIMITER ;
DROP TABLE IF EXISTS `RELCREDPASIVOAGRO`;
DELIMITER $$


CREATE TABLE `RELCREDPASIVOAGRO` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito de la Tabla de CREDITOS',
  `CreditoFondeoID` bigint(20) NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `EstatusRelacion` char(1) DEFAULT NULL COMMENT 'Esatus de la relacion entre el credito Activo y pasivo. \nA= Activa\nV= Vigente\n F= Finalizada.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoID`,`CreditoFondeoID`),
  KEY `fk_RELCREDPASIVOAGRO_1_idx` (`CreditoFondeoID`),
  CONSTRAINT `FK_RELCREDPASIVOAGRO_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_RELCREDPASIVOAGRO_2` FOREIGN KEY (`CreditoFondeoID`) REFERENCES `CREDITOFONDEO` (`CreditoFondeoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Relacion de un Crédito Pasivo (CREDITOFONDEO) con un Crédito Activo (CREDITOS)'$$