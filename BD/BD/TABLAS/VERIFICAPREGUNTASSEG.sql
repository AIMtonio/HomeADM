-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VERIFICAPREGUNTASSEG
DELIMITER ;
DROP TABLE IF EXISTS `VERIFICAPREGUNTASSEG`;DELIMITER $$

CREATE TABLE `VERIFICAPREGUNTASSEG` (
  `VerificaPreguntaID` int(11) NOT NULL COMMENT 'Consecutivo Verificacion de Preguntas',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `Telefono` varchar(20) DEFAULT NULL COMMENT 'Numero de Telefono',
  `TipoSoporteID` int(11) DEFAULT NULL COMMENT 'Tipo de Soporte',
  `PreguntaID` int(11) DEFAULT NULL COMMENT 'ID Pregunta Seguridad ',
  `ResultadoPregunta` varchar(45) DEFAULT NULL COMMENT 'Resultado por Preguntas',
  `FechaVerifica` datetime DEFAULT NULL COMMENT 'Fecha Verificacion de Preguntas',
  `Comentarios` varchar(200) DEFAULT NULL COMMENT 'Comentarios',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario que realiza la Verificacion de Preguntas',
  `ResultadoVerifica` varchar(45) DEFAULT NULL COMMENT 'Resultado Verificacion: X/Y donde:\nX = Respuestas correctas\nY = Parametro Respuestas Correctas',
  `ResultadoFinal` varchar(45) DEFAULT NULL COMMENT 'Resultado Final\nAPROBADO\nRECHAZADO\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`VerificaPreguntaID`),
  KEY `fk_VERIFICAPREGUNTASSEG_1_idx` (`ClienteID`),
  KEY `fk_VERIFICAPREGUNTASSEG_2_idx` (`TipoSoporteID`),
  KEY `fk_VERIFICAPREGUNTASSEG_3_idx` (`PreguntaID`),
  CONSTRAINT `fk_VERIFICAPREGUNTASSEG_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_VERIFICAPREGUNTASSEG_2` FOREIGN KEY (`TipoSoporteID`) REFERENCES `CATTIPOSOPORTE` (`TipoSoporteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_VERIFICAPREGUNTASSEG_3` FOREIGN KEY (`PreguntaID`) REFERENCES `CATPREGUNTASSEG` (`PreguntaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registro Verificacion de Preguntas de Seguridad.'$$