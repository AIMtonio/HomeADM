-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPOYOSEPELIO
DELIMITER ;
DROP TABLE IF EXISTS `CLIAPOYOSEPELIO`;DELIMITER $$

CREATE TABLE `CLIAPOYOSEPELIO` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero del cliente',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en que se da de alta el registro',
  `UsuarioReg` int(11) DEFAULT NULL COMMENT 'ID del usuario que registra, debe existir en la tabla USUARIOS',
  `UsuarioAut` int(11) DEFAULT NULL COMMENT 'ID del usuario que autoriza, debe existir en la tabla USUARIOS',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha en que se autoriza el registro',
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Transaccion con la que sale el efectivo en ventanilla',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto recibido por gastos de sepelio',
  `Comentario` varchar(300) DEFAULT NULL COMMENT 'Texto libre',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la solicitud de sepelio, R: registrado al dar de alta la solicitud',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Caja en la que se recibio el beneficio',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de poliza generada',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha en que se hace el pago',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`),
  CONSTRAINT `FK_ClienteID_3` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar las solicitudes de gastos sepelio'$$