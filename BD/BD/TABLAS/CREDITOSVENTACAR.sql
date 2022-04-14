DELIMITER ;
DROP TABLE IF EXISTS `CREDITOSVENTACAR`;
DELIMITER $$

CREATE TABLE `CREDITOSVENTACAR` (
  `CreditoID` BIGINT(12) NOT NULL COMMENT 'Identificador del Accesorio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoID`)
)COMMENT='se almacenará el ID de los créditos que se venderán.';$$