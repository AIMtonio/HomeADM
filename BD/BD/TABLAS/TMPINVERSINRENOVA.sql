-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPINVERSINRENOVA
DELIMITER ;
DROP TABLE IF EXISTS `TMPINVERSINRENOVA`;DELIMITER $$

CREATE TABLE `TMPINVERSINRENOVA` (
  `InversionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Llave primaria de la tabla',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `TipoInversionID` int(11) DEFAULT NULL COMMENT 'Tipo de Inversion ',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Tipo de Moneda',
  `Monto` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la inversión',
  `InteresGenerado` decimal(12,2) DEFAULT NULL COMMENT 'interes generado de la inversión',
  `InteresRetener` decimal(12,2) DEFAULT NULL COMMENT 'interes retenido de la inversión',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente',
  `SaldoProvision` decimal(12,2) DEFAULT NULL COMMENT 'Saldo provision',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'Sucursal de origen del Cliente',
  `CreditoInvGarID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la inversión en garantía tabla CREDITOINVGAR',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Id del Crédito relacionado con la inversión en garantía ',
  `MontoEnGar` decimal(14,2) DEFAULT NULL COMMENT 'Monto en Garantía',
  PRIMARY KEY (`CreditoInvGarID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal de Inversiones en garantía de un crédito pagadas en el cierre de día.'$$