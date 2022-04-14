-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOAPORTSUCURSALES
DELIMITER ;
DROP TABLE IF EXISTS `TIPOAPORTSUCURSALES`;DELIMITER $$

CREATE TABLE `TIPOAPORTSUCURSALES` (
  `TipProdSucID` int(11) NOT NULL COMMENT 'ID consecutivo de la tabla',
  `InstrumentoID` int(11) DEFAULT NULL COMMENT 'ID del Tipo de Producto(TipoAportacionID).',
  `TipoInstrumentoID` int(11) DEFAULT NULL COMMENT 'Corresponde al id de la tabla TIPOINSTRUMENTOS\n31.- Aportaciones',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'ID de la sucursal, fk SUCURSALES',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'ID del estado, fk ESTADOSREPUB',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus A=activa, I= inactiva',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipProdSucID`),
  KEY `Key_1` (`InstrumentoID`,`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de tipos de aportaciones por sucursal'$$