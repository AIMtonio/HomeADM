-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCARGAMOVSDET
DELIMITER ;
DROP TABLE IF EXISTS `PLDCARGAMOVSDET`;DELIMITER $$

CREATE TABLE `PLDCARGAMOVSDET` (
  `CargaID` bigint(20) NOT NULL COMMENT 'Identificador de la carga realizada',
  `CuentaAhoIDClie` varchar(20) NOT NULL COMMENT 'Identificador del cliente externo',
  `ClienteID` bigint(20) NOT NULL COMMENT 'Identificador del cliente en el SAFI',
  `Fecha` date NOT NULL COMMENT 'Fecha en la que se genera el movimiento',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del movimiento Operativo: Cargo = C, Abono = A',
  `CantidadMov` decimal(12,2) NOT NULL COMMENT 'Cantidad del movimiento',
  `DescripMov` varchar(150) NOT NULL COMMENT 'Descripcion del movimiento',
  `ReferenciaMov` varchar(50) NOT NULL COMMENT 'Referencia del movimiento',
  `TipoMovAhoID` char(4) NOT NULL COMMENT 'Identificador del tipo de movimiento: TIPOSMOVSAHO',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  KEY `INDEX_PLDCARGAMOVSDET_1` (`CargaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla contenedora de los datos referentes a los movimientos del cliente.'$$