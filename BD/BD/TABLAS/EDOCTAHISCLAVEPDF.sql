-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHISCLAVEPDF
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAHISCLAVEPDF`;DELIMITER $$

CREATE TABLE `EDOCTAHISCLAVEPDF` (
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente',
  `FechaPaseHis` datetime NOT NULL COMMENT 'Fecha en que se pasa a historico esta clave',
  `UsuarioPaseHis` int(11) NOT NULL COMMENT 'ID del usuario del sistema que realizo la actualizacion con la cual se genero el pase a historico',
  `Contrasenia` varchar(100) NOT NULL COMMENT 'Contraseña encriptada del cliente para el estado de cuenta que se enviaran por correo',
  `CorreoEnvio` varchar(80) NOT NULL COMMENT 'Cuenta de Correo a la que se enviara el Estado de Cuenta',
  `FechaActualiza` datetime NOT NULL COMMENT 'Fecha en que el cliente Actualiza ya sea el correo o la clave',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  KEY `FK_EDOCTAHISCLAVEPDF_1` (`ClienteID`),
  CONSTRAINT `FK_EDOCTAHISCLAVEPDF_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar el estatus de envio de los estados de cuenta'$$