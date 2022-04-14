-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDCARGAMOVSDET
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDCARGAMOVSDET`;DELIMITER $$

CREATE TABLE `TMPPLDCARGAMOVSDET` (
  `CargaID` bigint(20) NOT NULL COMMENT 'Identificador de la carga realizada',
  `NumRegistros` int(11) NOT NULL COMMENT 'Numero de registro por carga realizada',
  `CuentaAhoIDClie` varchar(20) DEFAULT NULL COMMENT 'Identificador del cliente externo',
  `ClienteID` bigint(20) DEFAULT NULL COMMENT 'Identificador del cliente en el SAFI',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en la que se genera el movimiento',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del movimiento Operativo: Cargo = C, Abono = A',
  `CantidadMov` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad del movimiento',
  `DescripMov` varchar(150) DEFAULT NULL COMMENT 'Descripcion del movimiento',
  `ReferenciaMov` varchar(50) DEFAULT NULL COMMENT 'Referencia del movimiento',
  `TipoMovAhoID` char(4) DEFAULT NULL COMMENT 'Identificador del tipo de movimiento: TIPOSMOVSAHO',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  KEY `INDEX_TMPPLDCARGAMOVSDET_1` (`CargaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla temporal para realizar el procesamiento de la informacion sobre los movimientos.'$$