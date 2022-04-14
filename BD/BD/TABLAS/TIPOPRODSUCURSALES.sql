-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPRODSUCURSALES
DELIMITER ;
DROP TABLE IF EXISTS `TIPOPRODSUCURSALES`;DELIMITER $$

CREATE TABLE `TIPOPRODSUCURSALES` (
  `TipProdSucID` int(11) NOT NULL COMMENT 'ID consecutivo de la tabla',
  `InstrumentoID` int(11) DEFAULT NULL COMMENT 'ID del Tipo de Producto(TipoCedeID).',
  `TipoInstrumentoID` int(11) DEFAULT NULL COMMENT 'Corresponde al id de la tabla TIPOINSTRUMENTOS\n28.-	CEDES',
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de tipos de cedes por sucursal'$$