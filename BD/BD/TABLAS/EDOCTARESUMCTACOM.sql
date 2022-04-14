-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCTACOM
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTARESUMCTACOM`;
DELIMITER $$


CREATE TABLE `EDOCTARESUMCTACOM` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente',
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'Identificador de la cuenta de ahorro',
  `IVAComisones` decimal(12,2) DEFAULT NULL COMMENT 'Monto del IVA de las comisiones',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  INDEX INDEX_EDOCTARESUMCTACOM_1 (CuentaAhoID),
  INDEX INDEX_EDOCTARESUMCTACOM_2 (ClienteID),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla complementaria a la tabla de resumen de cuentas de ahorro para generacion de estado de cuenta'$$
