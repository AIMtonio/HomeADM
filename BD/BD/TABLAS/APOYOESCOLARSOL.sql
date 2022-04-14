-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APOYOESCOLARSOL
DELIMITER ;
DROP TABLE IF EXISTS `APOYOESCOLARSOL`;DELIMITER $$

CREATE TABLE `APOYOESCOLARSOL` (
  `ApoyoEscSolID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero del cliente',
  `EdadCliente` int(11) DEFAULT NULL COMMENT 'Edad actual del cliente',
  `ApoyoEscCicloID` int(11) DEFAULT NULL COMMENT 'ID del nivel escolar del cliente',
  `GradoEscolar` int(11) DEFAULT NULL COMMENT 'Numero de grado escolar',
  `PromedioEscolar` decimal(12,2) DEFAULT NULL COMMENT 'Promedio escolar actual',
  `CicloEscolar` varchar(50) DEFAULT NULL COMMENT 'Ciclo escolar al que pertenece el promedio escolar',
  `NombreEscuela` varchar(200) DEFAULT NULL COMMENT 'Nombre de la escuela',
  `DireccionEscuela` varchar(500) DEFAULT NULL COMMENT 'Direccion de la escuela',
  `UsuarioRegistra` int(11) DEFAULT NULL COMMENT 'ID de usuario que registra la solicitud, debe existir en tabla USUARIOS',
  `UsuarioAutoriza` int(11) DEFAULT NULL COMMENT 'ID de usuario que autoriza la solicitud, debe existir en tabla USUARIOS',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la solicitud de apoyo escolar, R – Registrada:  Al dar de alta la solicitud\n												A – Autorizada: Cuando el usuario autoriza ó  X – Rechazada: Cuando se rechaza la solicitud\n												P- Pagada: Cuando se paga el Beneficio en ventanilla',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en la que se da de alta la solictud',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha en la que se autoriza la solicitud',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha en la que se recibe el beneficio del apoyo escolar',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto recibido por apoyo escolar',
  `TransaccionPago` bigint(20) DEFAULT NULL COMMENT 'Transaccion con la que sale el efectivo en ventanilla',
  `RecibePago` varchar(200) DEFAULT NULL COMMENT 'Nombre de la Persona que recibe el Pago del Apoyo Escolar en ventanilla. Puede ser el Cliente o una persona diferente.',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de poliza generada',
  `CajaID` int(11) DEFAULT NULL COMMENT 'ID de caja en la que se recibe el beneficio',
  `SucursalCajaID` int(11) DEFAULT NULL COMMENT 'Sucursal en la que se hace entrega del beneficio, debe existir en tabla SUCURSALES',
  `SucursalRegistroID` int(11) DEFAULT NULL COMMENT 'Sucursal en la que se hace el registro de la solicitud de apoyo escolar',
  `Comentario` varchar(300) DEFAULT NULL COMMENT 'Texto libre (motivo de autorizacion o rechazo)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ApoyoEscSolID`),
  KEY `FK_ClienteID_1` (`ClienteID`),
  KEY `FK_ApoyoEscCicloID_2` (`ApoyoEscCicloID`),
  KEY `FK_UsuarioID_1` (`UsuarioRegistra`),
  KEY `FK_SucursalID_1` (`SucursalRegistroID`),
  CONSTRAINT `FK_ApoyoEscCicloID_2` FOREIGN KEY (`ApoyoEscCicloID`) REFERENCES `APOYOESCCICLO` (`ApoyoEscCicloID`),
  CONSTRAINT `FK_ClienteID_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `FK_SucursalID_1` FOREIGN KEY (`SucursalRegistroID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_UsuarioID_1` FOREIGN KEY (`UsuarioRegistra`) REFERENCES `USUARIOS` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar las solicitudes de apoyo escolar de los c'$$