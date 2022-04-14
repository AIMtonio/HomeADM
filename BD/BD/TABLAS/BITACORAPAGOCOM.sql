-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAPAGOCOM
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAPAGOCOM`;DELIMITER $$

CREATE TABLE `BITACORAPAGOCOM` (
  `TipoTarjetaDebID` int(11) DEFAULT NULL COMMENT 'ID del tipo de tarjeta a la cual se le cobró la comisión anual',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID del usuario que ejecuta el proceso',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en la que ejecuto el proceso',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  KEY `FK_TipoTarjetaDebID_1` (`TipoTarjetaDebID`),
  KEY `FK_UsuarioID_11` (`UsuarioID`),
  CONSTRAINT `FK_TipoTarjetaDebID_1` FOREIGN KEY (`TipoTarjetaDebID`) REFERENCES `TIPOTARJETADEB` (`TipoTarjetaDebID`),
  CONSTRAINT `FK_UsuarioID_11` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los datos de la última ejecución del proceso de pago '$$