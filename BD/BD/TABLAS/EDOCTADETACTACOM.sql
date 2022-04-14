-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETACTACOM
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTADETACTACOM`;
DELIMITER $$


CREATE TABLE `EDOCTADETACTACOM` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AnioMes` int(11) DEFAULT NULL COMMENT 'Anio en el que se genero el estado de cuenta',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal de la que se origino el cliente',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Identificador del cliente',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Identificador de la cuenta de ahorro del cliente',
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Identificador del movimiento en cuenta de ahorro',
  `LugarExp` varchar(50) NOT NULL DEFAULT '' COMMENT 'Nombre del lugar de expedición del movimiento de la cuenta de ahorro',
  `DescMon` VARCHAR(45) NOT NULL DEFAULT '' COMMENT 'Descripcion Corta de la Moneda del movimiento',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  INDEX INDEX_EDOCTADETACTACOM_1 (ClienteID),
  INDEX INDEX_EDOCTADETACTACOM_2 (CuentaAhoID),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla complementaria para el detalle de los movimientos de cada cuenta mostrada en el reporte.'$$
