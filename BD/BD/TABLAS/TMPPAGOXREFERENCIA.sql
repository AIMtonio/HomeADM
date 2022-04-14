-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPAGOXREFERENCIA
DELIMITER ;
DROP TABLE IF EXISTS `TMPPAGOXREFERENCIA`;
DELIMITER $$


CREATE TABLE `TMPPAGOXREFERENCIA` (
  `NReg` bigint(21) NOT NULL COMMENT 'Numero de Registro',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito, sigue la misma nomenclatura que usa las cuentas de ahorro\n',
  `CuentaID` bigint(12) DEFAULT NULL COMMENT 'Número de Cuenta',
  `MontoExigible` decimal(18,2) DEFAULT NULL COMMENT 'Monto exigible del credito',
  `MontoBloq` decimal(18,2) DEFAULT NULL COMMENT 'Monto total de bloqueo para el pago por referencia',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'id del tipo de moneda del credito',
  `EmpresaID` bigint(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` bigint(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` bigint(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`CreditoID`),
  KEY `IDX_TMPPAGOXREFERENCIA_1` (`NReg`),
  KEY `IDX_TMPPAGOXREFERENCIA_2` (`MontoExigible`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para el pago por referencia'$$