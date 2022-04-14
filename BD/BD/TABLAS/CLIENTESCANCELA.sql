-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELA
DELIMITER ;
DROP TABLE IF EXISTS `CLIENTESCANCELA`;DELIMITER $$

CREATE TABLE `CLIENTESCANCELA` (
  `ClienteCancelaID` int(11) NOT NULL COMMENT 'Folio o Consecutivo de la tabla CLIENTESCANCELA',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente que se esta cancelando',
  `AreaCancela` char(3) DEFAULT NULL COMMENT 'Ãrea que realiza la cancelaciÃ³n del cliente\nAtencion a Socio = âSocâ\nProtecciones = âProâ\nCobranza = âCobâ',
  `UsuarioRegistra` int(11) DEFAULT NULL COMMENT 'Usuario que esta realizando el registro',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en que se da de alta el registro',
  `SucursalRegistro` int(11) DEFAULT NULL COMMENT 'Sucursal en la que se realiza el registro de la solicitud de cancelacion',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Registro\nRegistrado = âRâ\nAutorizado = âAâ\nPagado = "P"',
  `MotivoActivaID` int(11) DEFAULT NULL COMMENT 'Motivo de cancelacion del cliente',
  `Comentarios` varchar(500) DEFAULT NULL COMMENT 'Comentario de porque se esta solicitando la cancelaciÃ³n del cliente',
  `UsuarioAutoriza` int(11) DEFAULT NULL COMMENT 'Usuario que autoriza la solicitud de cancelacion',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha en que se realizo la autorizacion de la solicitud',
  `SucursalAutoriza` int(11) DEFAULT NULL COMMENT 'Sucursal En la que se realizo la autorizacion de la solicitud ',
  `AplicaSeguro` char(1) DEFAULT NULL COMMENT 'Aplica Seguro Si = "S" NO = "N"',
  `ActaDefuncion` varchar(100) DEFAULT NULL COMMENT 'Numero de Acta de defuncion del socio',
  `FechaDefuncion` date DEFAULT NULL COMMENT 'Fecha de defuncion del Socio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteCancelaID`),
  KEY `fk_CLIENTESCANCELA_1_idx` (`ClienteID`),
  KEY `index3` (`FechaRegistro`),
  KEY `index4` (`Estatus`),
  KEY `fk_CLIENTESCANCELA_2_idx` (`UsuarioRegistra`),
  KEY `fk_CLIENTESCANCELA_3_idx` (`MotivoActivaID`),
  CONSTRAINT `fk_CLIENTESCANCELA_2` FOREIGN KEY (`UsuarioRegistra`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIENTESCANCELA_3` FOREIGN KEY (`MotivoActivaID`) REFERENCES `MOTIVACTIVACION` (`MotivoActivaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar el registro de los clientes que se cancel'$$