-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECOBCOMMENSUAL
DELIMITER ;
DROP TABLE IF EXISTS `CRECOBCOMMENSUAL`;
DELIMITER $$


CREATE TABLE `CRECOBCOMMENSUAL` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CreditoID` bigint(20) NOT NULL COMMENT 'CreditoID ',
  `NumMes` int(11) NOT NULL COMMENT 'Numero de mes del credito.',
  `FechaCorte` date NOT NULL COMMENT 'Fecha de corte del credito',
  `TipoCredito` char(1) DEFAULT NULL COMMENT 'Tipo Credito (N: Nuevo, R: Reestructura)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  KEY `FK_CRECOBCOMMENSUAL_1_idx` (`CreditoID`),
  CONSTRAINT `FK_CRECOBCOMMENSUAL_1` FOREIGN KEY (`CreditoID`) REFERENCES `CREDITOS` (`CreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena el numero de meses que tiene un credito en todo el periodo hasta su fecha de vencimiento'$$
