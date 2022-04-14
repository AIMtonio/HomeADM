-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ANALISTASASIGNACION
DELIMITER ;
DROP TABLE IF EXISTS ANALISTASASIGNACION;
DELIMITER $$
CREATE TABLE `ANALISTASASIGNACION` (
  `AnalistasAsigID` bigint(20) NOT NULL COMMENT 'Id Consecutivo de la tabla',
  `UsuarioID` int(11) NOT NULL COMMENT 'Id del usuario analista de solicitud de credito',
  `TipoAsignacionID` int(11) NOT NULL COMMENT 'Id Tipo de asignacion de solicitud de credito  /',
  `FechaAsignacion` datetime DEFAULT NULL COMMENT 'Fecha en que se agrega el tipo de asignacion de solicitud al analista',
  `ProductoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id Producto Credito',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`AnalistasAsigID`),
  KEY `INDEX_ANALISTASASIGNACION_1` (`UsuarioID`),
  KEY `INDEX_ANALISTASASIGNACION_2` (`ProductoID`),
  KEY `INDEX_ANALISTASASIGNACION_3` (`UsuarioID`,`TipoAsignacionID`,`ProductoID`),
  KEY `INDEX_ANALISTASASIGNACION_4` (`TipoAsignacionID`,`ProductoID`),
  KEY `INDEX_ANALISTASASIGNACION_5` (`TipoAsignacionID`,`ProductoID`,`UsuarioID`),
  CONSTRAINT `fk_ANALISTASASIGNACION_1` FOREIGN KEY (`TipoAsignacionID`) REFERENCES `CATASIGNASOLICITUD` (`TipoAsignacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar asignaciones de analistas para solicitudes de credito'$$


