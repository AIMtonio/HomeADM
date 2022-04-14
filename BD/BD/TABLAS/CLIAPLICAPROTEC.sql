-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPLICAPROTEC
DELIMITER ;
DROP TABLE IF EXISTS `CLIAPLICAPROTEC`;DELIMITER $$

CREATE TABLE `CLIAPLICAPROTEC` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha  en que se da de alta el registro ',
  `UsuarioReg` int(11) DEFAULT NULL COMMENT 'ID del usuario que registra corresponde con la tabla USUARIOS',
  `UsuarioAut` int(11) DEFAULT NULL COMMENT 'Id del usuario que autoriza, corresponde con USUARIOS',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha en que se autoriza el Registro',
  `UsuarioRechaza` int(11) DEFAULT NULL COMMENT 'Id del usuario que rechaza la solicitud',
  `FechaRechaza` date DEFAULT NULL COMMENT 'Fecha en que se rechazo la solicitud',
  `Estatus` char(1) DEFAULT NULL COMMENT 'R = Registrado (Al dar de alta una solicitud)\nA = Autorizado (Cuando el Usuario Autoriza)\nP = Pagado (Cuando el Beneficiario paga en ventanilla)\nC = Cancelado(Al Rechazar la Solicitud)',
  `Comentario` varchar(300) DEFAULT NULL COMMENT 'Comentario texto libre, se captura al autorizar o rechazar ',
  `MonAplicaCuenta` decimal(12,2) DEFAULT NULL COMMENT 'Monto que se Aplicara por proteccion de todas las cuentas  del cliente',
  `MonAplicaCredito` decimal(14,2) DEFAULT NULL COMMENT 'Monto que se aplicara a la proteccion de todos los creditos del cliente',
  `ActaDefuncion` varchar(100) DEFAULT NULL COMMENT 'Indica el Número de Acta Defunción',
  `FechaDefuncion` date DEFAULT NULL COMMENT 'Indica la Fecha de Fallecimiento del Socio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`),
  KEY `fk_CLIAPLICAPROTEC_2_idx` (`UsuarioReg`),
  CONSTRAINT `fk_CLIAPLICAPROTEC_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CLIAPLICAPROTEC_2` FOREIGN KEY (`UsuarioReg`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda las solicitudes de proteccion al ahorro y credito'$$