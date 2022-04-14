-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EVALUACIONCTEMATRIZ
DELIMITER ;
DROP TABLE IF EXISTS `EVALUACIONCTEMATRIZ`;DELIMITER $$

CREATE TABLE `EVALUACIONCTEMATRIZ` (
  `FechaEvaluacionMatriz` date NOT NULL COMMENT 'Fecha en la que se realizó la evaluación.',
  `ClienteID` bigint(20) NOT NULL COMMENT 'ID del Cliente.',
  `Nacionalidad` char(1) DEFAULT NULL COMMENT 'Nacionalidad del Cliente.\nN: Nacional\nE: Extranjero',
  `PepNacional` smallint(6) DEFAULT NULL COMMENT 'Valor para Pep Nacional.',
  `PepExtr` smallint(6) DEFAULT NULL COMMENT 'Valor para Pep Extranjero.',
  `Actividad` smallint(6) DEFAULT NULL COMMENT 'Valor para Actividad BMX.',
  `Localidad` smallint(6) DEFAULT NULL COMMENT 'Valor para Localidad.',
  `OperInusual` smallint(6) DEFAULT NULL COMMENT 'Valor para Operacion Inusual.',
  `OperRelevan` smallint(6) DEFAULT NULL COMMENT 'Valor para Operacion Relevante.',
  `PaisNacimiento` smallint(6) DEFAULT NULL COMMENT 'Valor para Pais de Nacimiento.',
  `PaisResidencia` smallint(6) DEFAULT NULL COMMENT 'Valor para Pais de Residencia.',
  `PuntajeObt` int(11) DEFAULT NULL COMMENT 'Puntaje Obtenido.',
  `Porcentaje` decimal(6,2) DEFAULT NULL COMMENT 'Porcentaje Obtenido.',
  `NivelRiesgo` char(1) DEFAULT NULL COMMENT 'Nivel de Riesgo Obtenido.',
  `PorcentajeAnterior` decimal(6,2) DEFAULT NULL COMMENT 'Porcentaje Anterior.',
  `NivelRiesgoAnterior` char(1) DEFAULT NULL COMMENT 'Nivel de Riesgo Anterior.',
  `PermiteReactivacion` char(1) DEFAULT NULL COMMENT 'Indica si permite reactivación en caso de Clientes Inactivos.',
  `TipoPersona` char(1) NOT NULL DEFAULT 'F' COMMENT 'Tipo de Persona\nF: Fisica\nA: Fisica con Actividad Empresarial\nM: Moral',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`FechaEvaluacionMatriz`,`ClienteID`),
  KEY `INDEX_EVALUACIONCTEMATRIZ_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar la Evaluación Periódica de Clientes de acuerdo a la Matriz de Riesgo Vigente.'$$