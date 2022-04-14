-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAENVIOCORREO
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAENVIOCORREO`;DELIMITER $$

CREATE TABLE `EDOCTAENVIOCORREO` (
  `AnioMes` int(11) NOT NULL COMMENT 'Fecha de generacion del estado de cuenta',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente',
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de sucursal del cliente',
  `CorreoEnvio` varchar(50) NOT NULL COMMENT 'Cuenta de Correo a la que se enviara el Estado de Cuenta',
  `EstatusEdoCta` varchar(50) NOT NULL COMMENT 'Estatus del Estado de Cuenta 1= Info Extraida, 2=Timbrado 3= No se Pudo timbrar',
  `EstatusEnvio` char(1) NOT NULL COMMENT 'Estatus de envio: S=Enviado, N=No enviado',
  `FechaEnvio` datetime NOT NULL COMMENT 'Fecha y hora del envio del correo',
  `UsuarioEnvia` int(11) NOT NULL COMMENT 'ID del usuario en el sistema que realizo el envío',
  `PDFGenerado` char(1) NOT NULL COMMENT 'Indica si el PDF ha sido generado S = Si, N = No',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`AnioMes`,`ClienteID`),
  KEY `FK_EDOCTAENVIOCORREO_2` (`ClienteID`),
  KEY `INDEX_EDOCTAENVIOCORREO_1` (`AnioMes`,`ClienteID`),
  KEY `INDEX_EDOCTAENVIOCORREO_2` (`AnioMes`),
  CONSTRAINT `FK_EDOCTAENVIOCORREO_2` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar el estatus de envio de los estados de cuenta'$$