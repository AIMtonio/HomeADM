-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSINVKUBO
DELIMITER ;
DROP TABLE IF EXISTS `SALDOSINVKUBO`;DELIMITER $$

CREATE TABLE `SALDOSINVKUBO` (
  `FondeoKuboID` int(11) NOT NULL COMMENT 'numero de fondeokuboID',
  `FechaCorte` datetime DEFAULT NULL COMMENT 'Fecha',
  `ClienteID` int(12) DEFAULT NULL COMMENT 'Numero o ID\nDel Cliente\n',
  `CreditoID` int(12) DEFAULT NULL COMMENT 'Numero o ID\nDel Credito\nFondedo\n',
  `SalCapVigente` decimal(12,2) DEFAULT NULL,
  `SalCapExigible` decimal(12,2) DEFAULT NULL,
  `SaldoInteres` decimal(12,4) DEFAULT NULL,
  `ProvisionAcum` decimal(12,4) DEFAULT NULL,
  `MoratorioPagado` decimal(12,2) DEFAULT NULL,
  `ComFalPagPagada` decimal(12,4) DEFAULT NULL,
  `IntOrdRetenido` decimal(12,4) DEFAULT NULL,
  `IntMorRetenido` decimal(12,4) DEFAULT NULL,
  `ComFalPagRetenido` decimal(12,4) DEFAULT NULL,
  `GAT` decimal(12,4) DEFAULT NULL COMMENT 'Ganancia anual\ntotal\n',
  `NumAtras1A15` int(11) DEFAULT NULL COMMENT 'numero inv atrasado de \n1 a 15 dias',
  `SalAtras1A15` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv atrasado de \n1 a 15 dias',
  `NumAtras16a30` int(11) DEFAULT NULL COMMENT 'numero inv atrasado de \n16 a 30 dias',
  `SaldoAtras16a30` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv atrasado de \n16 a 30 dias',
  `NumAtras31a90` int(11) DEFAULT NULL COMMENT 'num inv atrasado de \n31 a 90 dias',
  `SalAtras31a90` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv atrasado de \n31 a 90 dias',
  `NumVenc91a120` int(11) DEFAULT NULL COMMENT 'num inv vencido \nde 91 a 120 dias',
  `SalVenc91a120` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv vencido de 91 a 120 dias',
  `NumVenc120a180` int(11) DEFAULT NULL COMMENT 'numero inv vencido  de 120 a 180 dias',
  `SalVenc120a180` decimal(12,4) DEFAULT NULL COMMENT 'saldo inv vencido  de 120 a 180 dias vencido  de 120 a 180 dias',
  KEY `index1` (`FondeoKuboID`),
  KEY `index2` (`FechaCorte`),
  KEY `fk_SALDOSINVKUBO_1` (`ClienteID`),
  CONSTRAINT `fk_SALDOSINVKUBO_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='SALDOS INVERSION KUBO'$$