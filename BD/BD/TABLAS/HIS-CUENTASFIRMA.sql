-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-CUENTASFIRMA
DELIMITER ;
DROP TABLE IF EXISTS `HIS-CUENTASFIRMA`;DELIMITER $$

CREATE TABLE `HIS-CUENTASFIRMA` (
  `Fecha` datetime NOT NULL COMMENT 'FECHA DEL SISTEMA EN QUE FUE BORRADO EL REGISTRO',
  `CuentaFirmaID` int(11) NOT NULL COMMENT 'Numero de Firma',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `PersonaID` int(12) NOT NULL COMMENT 'Numero de persona relacionada',
  `NombreCompleto` varchar(200) NOT NULL COMMENT 'Nombre de persona autorizada para firma',
  `Tipo` char(1) NOT NULL COMMENT 'Tipo de Firma: A .- Individual, B .-Mancumunada, C.-Especial',
  `InstrucEspecial` varchar(150) DEFAULT NULL COMMENT 'Deberá ser llenado al seleccionar el Tipo C',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`NumTransaccion`)
) ENGINE=InnoDB AUTO_INCREMENT=483 DEFAULT CHARSET=latin1 COMMENT='Historico de Firmas Autorizadas de la Cuenta de Ahorro'$$