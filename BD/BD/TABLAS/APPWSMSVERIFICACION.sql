-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWSMSVERIFICACION
DELIMITER ;
DROP TABLE IF EXISTS `APPWSMSVERIFICACION`;
DELIMITER $$

CREATE TABLE `APPWSMSVERIFICACION` (
  `EnvioID` int(11) NOT NULL COMMENT 'ID de Envio ',
  `Receptor` varchar(45) NOT NULL COMMENT 'Receptor',
  `FechaRealEnvio` datetime NOT NULL COMMENT 'Fecha Real de Envio',
  `Codigo` varchar(160) NOT NULL COMMENT 'Codigo de verificacion',
  `EmpresaID` int(11) NOT NULL,
  `Usuario` int(11) NOT NULL,
  `FechaActual` datetime NOT NULL,
  `DireccionIP` varchar(15) NOT NULL,
  `ProgramaID` varchar(50) NOT NULL,
  `Sucursal` int(11) NOT NULL,
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Cat: Codigos de verificacion SMS',
  PRIMARY KEY (`EnvioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de envios de SMS'$$