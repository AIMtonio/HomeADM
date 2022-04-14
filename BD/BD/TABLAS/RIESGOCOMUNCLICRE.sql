-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOCOMUNCLICRE
DELIMITER ;
DROP TABLE IF EXISTS `RIESGOCOMUNCLICRE`;DELIMITER $$

CREATE TABLE `RIESGOCOMUNCLICRE` (
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'ID de la solicitud de credito solicitante',
  `ConsecutivoID` int(11) NOT NULL COMMENT 'Consecutivo por solicitud',
  `ClienteIDSolicitud` int(11) NOT NULL COMMENT 'ID cliente realiza la solicitud de credito',
  `ProspectoID` bigint(20) NOT NULL COMMENT 'ID prospecto  realiza la solicitud de credito',
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID Credito que representa un riesgo en comun',
  `ClienteID` int(11) NOT NULL COMMENT 'ID Cliente que representa un riesgo en comun',
  `NombreCompleto` varchar(200) NOT NULL COMMENT 'Nombre Completo Cliente que representa un riesgo en comun',
  `ParentescoID` int(11) DEFAULT '0' COMMENT 'Relacion del Solicitante con el Relacionado.',
  `Estatus` char(1) DEFAULT 'P' COMMENT 'Estatus del proceso de la Solicitud P = Pendiente, R = Revisado',
  `Clave` int(11) DEFAULT '0' COMMENT 'Clave proporcionada por el analista de riesgos.\n 1 = No Relacionado\n 2 = Persona Fisica o moral con el uno porcieto de acciones \n 3 = Miembros de consejo \n 4 = Funcionarios o Epleados \n 5 = Conyugues \n 6 = Personas morales con el 10 por cieto de acciones \n 7 = Personas Morales con familiar con el 10 porciento de acciones \n 8 = Personas morales con familiar en los tres primeros puestos de la empresa \n 9 = Personas o Fideicomisos que depende de un emlpleado de la Empresa',
  `Motivo` varchar(100) NOT NULL COMMENT 'Indica la razon por la que se podrian considerar de riesgo comun, la coincidencia que encontro el sistema',
  `Comentario` varchar(1050) NOT NULL,
  `RiesgoComun` char(1) NOT NULL COMMENT 'Indica si representan riesgo comun(S=si o N=no). Este debe indicar por defecto que si representan riesgo comun',
  `Procesado` char(1) NOT NULL COMMENT 'Indica si ya ha sido procesado el registro(S=si o N=no). Todo registro debe nacer como NO procesado',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`SolicitudCreditoID`,`ConsecutivoID`),
  KEY `idx_RIESGOCOMUNCLICRE_1` (`SolicitudCreditoID`),
  KEY `idx_RIESGOCOMUNCLICRE_2` (`ClienteIDSolicitud`),
  KEY `idx_RIESGOCOMUNCLICRE_3` (`CreditoID`),
  KEY `idx_RIESGOCOMUNCLICRE_4` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacacena datos de clientes y sus creditos que posiblemente representen un riesgo comun'$$