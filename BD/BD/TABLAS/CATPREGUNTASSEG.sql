-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPREGUNTASSEG
DELIMITER ;
DROP TABLE IF EXISTS `CATPREGUNTASSEG`;DELIMITER $$

CREATE TABLE `CATPREGUNTASSEG` (
  `PreguntaID` int(11) NOT NULL COMMENT 'Numero de Pregunta de Seguridad',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion de la Pregunta de Seguridad',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`PreguntaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Preguntas de Seguridad'$$