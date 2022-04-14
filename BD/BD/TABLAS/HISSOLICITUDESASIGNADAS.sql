-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSOLICITUDESASIGNADAS
DELIMITER ;
DROP TABLE IF EXISTS HISSOLICITUDESASIGNADAS;
DELIMITER $$
CREATE TABLE `HISSOLICITUDESASIGNADAS` (
  `HisSolicitudAsignaID` bigint(20) NOT NULL COMMENT 'Consecutivo de la tabla',
  `SolicitudAsignaID` bigint(20) NOT NULL COMMENT 'LLave foranea de la tabla SOLICITUDESASIGNADAS',
  `UsuarioID` int(11) NOT NULL COMMENT 'Id del usuario analista asignado para revision de la solicitud de credito',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Id de la solicitud de credito',
  `TipoAsignacionID` int(11) NOT NULL COMMENT 'Id Tipo de asignacion analista /',
  `ProductoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id Producto de credito',
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
  PRIMARY KEY (`HisSolicitudAsignaID`),
  KEY `INDEX_HISSOLICITUDESASIGNADAS_1` (`UsuarioID`),
  KEY `INDEX_HISSOLICITUDESASIGNADAS_2` (`ProductoID`),
  KEY `fk_HISSOLICITUDESASIGNADAS_1_idx` (`SolicitudCreditoID`),
  KEY `fk_HISSOLICITUDESASIGNADAS_2_idx` (`TipoAsignacionID`),
  KEY `INDEX_HISSOLICITUDESASIGNADAS_3` (`FechaAsignacion`,`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT=' Tabla para almacenar el historial de los registros de solicitudes asignados a cada analista '$$

