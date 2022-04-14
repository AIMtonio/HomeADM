-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREGUNTASSEGURIDAD
DELIMITER ;
DROP TABLE IF EXISTS `PREGUNTASSEGURIDAD`;DELIMITER $$

CREATE TABLE `PREGUNTASSEGURIDAD` (
  `PreguntaSegID` int(11) NOT NULL COMMENT 'Numero Preguntas de Seguridad',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Cuenta',
  `PreguntaID` int(11) DEFAULT NULL COMMENT 'ID pregunta seguridad ',
  `Respuestas` varchar(50) DEFAULT NULL COMMENT 'Respuestas de Seguridad',
  `NumeroPreguntas` int(11) DEFAULT NULL COMMENT 'Numero de Preguntas de Seguridad',
  `NumeroRespuestas` int(11) DEFAULT NULL COMMENT 'Numero de Respuestas de Seguridad',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`PreguntaSegID`),
  KEY `fk_PREGUNTASSEGURIDAD_1_idx` (`PreguntaID`),
  CONSTRAINT `fk_PREGUNTASSEGURIDAD_1` FOREIGN KEY (`PreguntaID`) REFERENCES `CATPREGUNTASSEG` (`PreguntaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro de Preguntas de Seguridad.'$$