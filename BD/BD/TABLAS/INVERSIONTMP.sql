-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONTMP
DELIMITER ;
DROP TABLE IF EXISTS `INVERSIONTMP`;DELIMITER $$

CREATE TABLE `INVERSIONTMP` (
  `InversionID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID de la inversión',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente',
  `MontoTotal` decimal(14,2) DEFAULT NULL COMMENT 'El Monto total de la inversión',
  `SaldoProvision` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Provisión',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `MontoAmparado` decimal(14,2) DEFAULT NULL COMMENT 'El monto que se encuentra amparado ah algún crédito',
  `MontoDispon` decimal(14,2) DEFAULT NULL COMMENT 'Monto Disponible',
  PRIMARY KEY (`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que se usa como temporal física para sacar informacion de inversiones de un cliente, esto se usa para cambio sucursal de cliente'$$