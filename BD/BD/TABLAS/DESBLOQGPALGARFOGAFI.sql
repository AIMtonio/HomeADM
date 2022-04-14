-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESBLOQGPALGARFOGAFI
DELIMITER ;
DROP TABLE IF EXISTS `DESBLOQGPALGARFOGAFI`;DELIMITER $$

CREATE TABLE `DESBLOQGPALGARFOGAFI` (
  `Consecutivo` int(11) NOT NULL COMMENT 'Identificador Consecutivo',
  `CreditoID` bigint(20) DEFAULT NULL COMMENT 'Indica el Número de Crédito',
  `CuentaID` bigint(20) DEFAULT NULL COMMENT 'Identificador de la Cuenta del Cliente',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Indica el Número de Cliente',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Identificador del número de Moneda',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Indica el número de Sucursal del Cliente',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Indica el Numero de Transacción',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `IDX_BLOQGPALGARFOGAFI_1` (`Consecutivo`),
  KEY `IDX_BLOQGPALGARFOGAFI_2` (`CreditoID`),
  KEY `IDX_BLOQGPALGARFOGAFI_3` (`CuentaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para almacenar los desbloqueos correspondientes a la garantía FOGAFI'$$