-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPLICAPROFUN
DELIMITER ;
DROP TABLE IF EXISTS `CLIAPLICAPROFUN`;DELIMITER $$

CREATE TABLE `CLIAPLICAPROFUN` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero del Cliente',
  `Monto` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad que se le autorizo como  pago al cliente',
  `Comentario` varchar(300) NOT NULL COMMENT 'Comentario (texto libre) que el usuario captura al dar de alta el registro de la solicitud.',
  `ActaDefuncion` varchar(100) DEFAULT NULL COMMENT 'Numero de Acta de defuncion del socio',
  `FechaDefuncion` date DEFAULT NULL COMMENT 'Fecha de defuncion del Socio',
  `UsuarioReg` int(11) DEFAULT NULL COMMENT 'ID del usuario que registra, debe de existir en tabla USUARIOS',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en que se registra',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha en que se autoriza el registro',
  `UsuarioAuto` int(11) DEFAULT NULL COMMENT 'ID del usuario que autoriza, debe de existir en tabla USUARIOS',
  `UsuarioRechaza` int(11) DEFAULT NULL COMMENT 'Usuario que realiza el rechazo',
  `FechaRechaza` date DEFAULT NULL COMMENT 'Fecha de que se realiza el rechazo',
  `MotivoRechazo` varchar(400) DEFAULT NULL COMMENT 'Motivo por el cual la solicitud fue rechazada \n',
  `AplicadoSocios` char(1) DEFAULT NULL COMMENT 'Indica si ya se aplico el cargo alos socios que partipan en el programa. Su valor por default sera N\nS â Si\nN â No',
  `Estatus` char(1) DEFAULT NULL COMMENT 'R â Registrado _ Al dar de alta la solicitud del beneficio PROFUN\nA â Autorizado_Cuando se autoriza la solicitud del beneficio PROFUN\nE â Rechazado_Cuando se rechaza la solicitud del beneficio PROFUN',
  `EmpresaID` varchar(50) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'R â Registrado\nA â Autorizado\nP-  PAGADO ',
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`),
  KEY `fk_CLIAPLICAPROFUN_1` (`ClienteID`),
  KEY `fk_CLIAPLICAPROFUN_2_idx` (`UsuarioReg`),
  CONSTRAINT `fk_CLIAPLICAPROFUN_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTESPROFUN` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIAPLICAPROFUN_2` FOREIGN KEY (`UsuarioReg`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda las solicitudes que se hacen para cobrar el beneficio'$$