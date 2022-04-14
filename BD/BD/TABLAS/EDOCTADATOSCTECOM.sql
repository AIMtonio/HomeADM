-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADATOSCTECOM
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTADATOSCTECOM`;
DELIMITER $$


CREATE TABLE `EDOCTADATOSCTECOM` (
  `AnioMes` int(11) NOT NULL COMMENT 'Anio y Mes para generar Estado de Cuenta',
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de Sucursal del Cliente',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero identificador cliente',
  `EsPrincipal` char(1) DEFAULT NULL COMMENT 'Indica si es cuenta Principal \nS - Si\nN - No',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Identificador de la cuenta de ahorro del cliente',
  `Clabe` varchar(18) DEFAULT NULL COMMENT 'Cuenta Clabe',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Identificador del credito del cliente',
  `FechaProxPago` varchar(20) DEFAULT NULL COMMENT 'Fecha del proximo pago del credito',
  `EsSuperTasas` CHAR(1) NOT NULL COMMENT 'Indica si es cliente de SuperTasas. S - Si, N - No',
  `MonedaID` INT(11) NOT NULL COMMENT 'Numero de moneda para la cuenta de ahorro del cliente',
  `ProductoCredID` int(4) NOT NULL,
  `CreditoCliID` bigint(12) NOT NULL,
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioMes`,`SucursalID`,`ClienteID`,`ProductoCredID`,`CreditoCliID`),
  KEY `INDEX_EDOCTADATOSCTECOM_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Datos complementarios de la tabla EDOCTADATOSCTE'$$