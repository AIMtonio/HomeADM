
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREVENTACARDIAATR`;
DELIMITER $$

CREATE TABLE `TMPCREVENTACARDIAATR` (
  `CreditoID`       BIGINT(12) ,
  `DiasAtraso`      int(11),
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  INDEX (CreditoID)
);$$