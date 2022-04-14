-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATASIGNASOLICITUD
DELIMITER ;
DROP TABLE IF EXISTS `CATASIGNASOLICITUD`;
DELIMITER $$

CREATE TABLE `CATASIGNASOLICITUD` (
  `TipoAsignacionID` int(11) NOT NULL COMMENT 'ID de la la tabla ',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion de tipo de asignacion de solicitud de credito',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`TipoAsignacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catalogo de tipos de asignacion de solicitud de credito'$$