-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASAAPORTSUCURSALES
DELIMITER ;
DROP TABLE IF EXISTS `TASAAPORTSUCURSALES`;DELIMITER $$

CREATE TABLE `TASAAPORTSUCURSALES` (
  `TasaAportSucID` int(11) NOT NULL COMMENT 'ID consecutivo de la tabla',
  `TipoAportacionID` int(11) DEFAULT NULL COMMENT 'ID del tipo de APORTACION tabla TIPOSAPORTACIONES ',
  `TasaAportacionID` int(11) DEFAULT NULL COMMENT 'Corresponde al id de la tabla TASASAPORTACIONES',
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
  PRIMARY KEY (`TasaAportSucID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo De Tasas por sucursales'$$