-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDEVALUAPROCESODET
DELIMITER ;
DROP TABLE IF EXISTS `PLDEVALUAPROCESODET`;DELIMITER $$

CREATE TABLE `PLDEVALUAPROCESODET` (
  `OperacionID` bigint(20) NOT NULL COMMENT 'ID de la operacion evaluada',
  `ConceptoMatrizID` tinyint(4) NOT NULL COMMENT 'ID del concepto de la matriz de riesgo',
  `Cumple` char(1) NOT NULL COMMENT 'Determina si una condicion de la Matriz se cumple\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `indx_PLD_1` (`OperacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de la evaluacion por cada uno de los conceptos que aplican de la matriz de riesgos para la operacion evaluada'$$