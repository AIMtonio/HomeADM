-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDEVALUAPROCESOENC
DELIMITER ;
DROP TABLE IF EXISTS `PLDEVALUAPROCESOENC`;DELIMITER $$

CREATE TABLE `PLDEVALUAPROCESOENC` (
  `OperacionID` bigint(20) NOT NULL COMMENT 'ID de la operacion evaluada\n- Numero de Transaccion',
  `OperProcID` bigint(12) NOT NULL COMMENT 'Instrumento',
  `ClienteID` bigint(20) NOT NULL,
  `TipoProceso` varchar(16) NOT NULL COMMENT 'Tipo de Operacion \nCREDITO\nCTAAHO\nINVERSION',
  `PuntajeTotal` int(11) DEFAULT NULL,
  `PuntajeObtenido` int(12) NOT NULL COMMENT 'Suma del puntaje total de la matriz',
  `Porcentaje` tinyint(4) NOT NULL COMMENT 'Porcentaje Obtenido',
  `NivelRiesgo` char(1) NOT NULL COMMENT 'Nivel de riesgo de acuerdo al porcentaje\nB - Bajo\nM - Medio\nA - Alto',
  `FechaEvaluacion` datetime NOT NULL COMMENT 'Fecha de evaluacion',
  `CodigoNiveles` int(11) NOT NULL COMMENT 'Codigo de los valores que se usaron para evaluar el nivel de riesgo',
  `CodigoMatriz` int(11) NOT NULL COMMENT 'Codigo de los valores que se usaron para sumar el puntaje de la matriz de riesgo',
  `PorcentajeAnterior` decimal(6,2) DEFAULT '0.00' COMMENT 'Porcentaje Anterior.',
  `NivelRiesgoAnterior` char(1) NOT NULL DEFAULT 'B' COMMENT 'Nivel de riesgo anterior, sólo aplica para evaluación periódica por cliente.\nB - Bajo\nM - Medio\nA - Alto',
  `TipoPersona` char(1) NOT NULL DEFAULT 'F' COMMENT 'Tipo de Persona\nF: Fisica\nA: Fisica con Actividad Empresarial\nM: Moral',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`OperacionID`,`OperProcID`,`ClienteID`),
  KEY `INDEX_PLDEVALUAPROCESOENC_1` (`ClienteID`,`TipoProceso`),
  KEY `INDEX_PLDEVALUAPROCESOENC_2` (`FechaEvaluacion`),
  KEY `INDEX_PLDEVALUAPROCESOENC_3` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Encabezado de la Evaluacion de riesgo de una operacion, guarda los totales y el nivel de riesgo obtenido'$$