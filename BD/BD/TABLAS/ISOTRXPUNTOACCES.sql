-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISOTRXPUNTOACCES
DELIMITER ;
DROP TABLE IF EXISTS `ISOTRXPUNTOACCES`;
DELIMITER $$


CREATE TABLE `ISOTRXPUNTOACCES` (
  `PuntoAccesoID` int(11) NOT NULL COMMENT 'Id para el punto de acceso',
  `Descripcion` varchar(250) DEFAULT NULL COMMENT 'Descripcion para el punto de acceso',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`PuntoAccesoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo sobre los putos de acceso'$$