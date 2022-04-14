-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDESASIGNADAS
DELIMITER ;
DROP TABLE IF EXISTS SOLICITUDESASIGNADAS;
DELIMITER $$
CREATE TABLE `SOLICITUDESASIGNADAS` (
  `SolicitudAsignaID` bigint(20) NOT NULL COMMENT 'Consecutivo de la tabla',
  `UsuarioID` int(11) NOT NULL COMMENT 'Id del usuario analista asignado para revisar la solicitd de credito',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Id de la solicitud de credito',
  `TipoAsignacionID` int(11) NOT NULL COMMENT 'Id Tipo de asignacion de la tabla cat: CATASIGNASOLICITUD; ',
  `ProductoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id del Producto ',
  `AsignacionAuto` char(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si el proceso de asignacion del analista fue de forma automatica N.- NO\nS.- SI\n',
  `FechaAsignacion` date NOT NULL COMMENT 'Fecha en que se asigna la solicitud de credito al usuario analista',
  `Estatus` char(1) NOT NULL DEFAULT 'A' COMMENT 'Estatus de solicitud de credito Nace Asignado\nA .- Asignado \nE.- EnRevision',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`SolicitudAsignaID`),
  KEY `INDEX_SOLICITUDESASIGNADAS_1` (`UsuarioID`),
  KEY `INDEX_SOLICITUDESASIGNADAS_2` (`ProductoID`),
  KEY `fk_SOLICITUDESASIGNADAS_1_idx` (`SolicitudCreditoID`),
  KEY `fk_SOLICITUDESASIGNADAS_2_idx` (`TipoAsignacionID`),
  KEY `INDEX_SOLICITUDESASIGNADAS_3` (`FechaAsignacion`,`UsuarioID`),
  CONSTRAINT `fk_SOLICITUDESASIGNADAS_1` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SOLICITUDESASIGNADAS_2` FOREIGN KEY (`TipoAsignacionID`) REFERENCES `CATASIGNASOLICITUD` (`TipoAsignacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar los registros de solicitudes asignadas a cada analista'$$
