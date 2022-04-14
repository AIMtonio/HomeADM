
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOSVENTACAR`;
DELIMITER $$
CREATE TABLE `TMPCREDITOSVENTACAR` (
  `CreditoID`       BIGINT(12) ,
  ProducCreditoID   int(11),
  `DiasAtraso`      int(11),
  `SaldoMoratorios` DECIMAL(14,2),
  `SalMoraVencido` DECIMAL(14,2) ,
  `SalMoraCarVen` DECIMAL(14,2),
  `SaldoComFaltaPa` DECIMAL(14,2) ,
  `SaldoOtrasComis` DECIMAL(14,2),
  `SaldoCapVenNExi` DECIMAL(14,2),
  `SaldoCapVencido` DECIMAL(14,2) ,
  `SaldoInteresVen` DECIMAL(14,2) ,
  `SaldoIntNoConta` DECIMAL(14,2) ,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  INDEX (CreditoID)
);$$