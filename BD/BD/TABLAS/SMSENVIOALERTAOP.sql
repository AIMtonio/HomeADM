-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSENVIOMENSAJE
DELIMITER ;
DROP TABLE IF EXISTS `SMSENVIOALERTAOP`;
DELIMITER $$

CREATE TABLE `SMSENVIOALERTAOP` (
  `SMSEnvioAlertaOpID` int(11) NOT NULL COMMENT 'Número de alerta ',
  `PlantillaID` int(11) NOT NULL COMMENT 'ID de la Plantilla',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Tabla de envios de SMS',
  PRIMARY KEY (`SMSEnvioAlertaOpID`),
  CONSTRAINT `fk_SMSENVIOALERTAOP_PLANTILLA` FOREIGN KEY (`PlantillaID`) REFERENCES `SMSPLANTILLA` (`PlantillaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de configuración de alertas para envios de SMS'$$