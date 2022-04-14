-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETINVER
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTADETINVER`;
DELIMITER $$


CREATE TABLE `EDOCTADETINVER` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AnioMes` int(11) NOT NULL COMMENT 'Anio mes',
  `SucursalID` int(11) NOT NULL COMMENT 'Identificador de la sucursal',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador de cliente',
  `InversionID` bigint(12) NOT NULL COMMENT 'Identificador de inversion',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion',
  `FechanMov` date NOT NULL COMMENT 'Fecha de movimiento',
  `Cargo` decimal(14,2) NOT NULL COMMENT 'Cargo',
  `Abono` decimal(14,2) NOT NULL COMMENT 'Abono',
  `Orden` int(11) NOT NULL COMMENT 'Orden',
  `Referencia` bigint(20) NOT NULL COMMENT 'Numero del movimiento utilizado como referencia del mismo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  KEY `INDEX_EDOCTADETINVER_1` (`ClienteID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar informacion para el detalle de las inversiones en el reporte de estado de cuenta'$$
