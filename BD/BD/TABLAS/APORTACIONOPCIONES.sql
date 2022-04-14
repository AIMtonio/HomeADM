-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONOPCIONES
DELIMITER ;
DROP TABLE IF EXISTS `APORTACIONOPCIONES`;DELIMITER $$

CREATE TABLE `APORTACIONOPCIONES` (
  `OpcionID` int(11) NOT NULL COMMENT 'ID de la opcion',
  `NombreCorto` varchar(50) NOT NULL COMMENT 'Nombre corto de la opcion para la aportacion',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion de la opcion para la aportacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`OpcionID`,`NombreCorto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Almacena las opciones mostradas en el combo aportacion de la pantalla alta aportacion.'$$