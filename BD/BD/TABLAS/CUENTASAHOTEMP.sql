-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOTEMP
DELIMITER ;
DROP TABLE IF EXISTS `CUENTASAHOTEMP`;DELIMITER $$

CREATE TABLE `CUENTASAHOTEMP` (
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id del cliente',
  `MontoGL` decimal(14,2) DEFAULT NULL COMMENT 'Monto que se deja para GL (Garantia Liquida)',
  `MontoAhorro` decimal(14,2) DEFAULT NULL COMMENT 'Monto total Ahorro',
  PRIMARY KEY (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal fisica que se usa para guardar informacion de cuentas de ahorro de un cliente , se usa para cambio de sucursal'$$