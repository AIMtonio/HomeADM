-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCAMPANIAS
DELIMITER ;
DROP TABLE IF EXISTS `SMSCAMPANIAS`;DELIMITER $$

CREATE TABLE `SMSCAMPANIAS` (
  `CampaniaID` int(11) NOT NULL COMMENT 'id de la campaña',
  `Nombre` varchar(50) DEFAULT NULL COMMENT 'Nombre de la campaña',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'Clasificacion de la Campaña\\nE: Entrada\\nS: Salida\\nI: Interactiva',
  `Categoria` char(1) DEFAULT NULL COMMENT 'Categoria de la campaña\\\\nA Automatica\\\\nE: Por Evento\\\\nC: Campaña',
  `Tipo` int(11) DEFAULT NULL COMMENT 'Tipo de Campaña',
  `FechaLimiteRes` date DEFAULT NULL COMMENT 'Fecha Limite de Respuesta\\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la campania\\nV: Vigente\\\\nC: Cancelado\\\\nF: Finalizada',
  `MsgRecepcion` varchar(50) DEFAULT NULL COMMENT 'Mensaje de recepción',
  `PlantillaID` int(11) DEFAULT NULL COMMENT 'Número de la plantilla',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CampaniaID`),
  KEY `fk_SMSCAMPANIAS_1_idx` (`Tipo`),
  CONSTRAINT `fk_SMSCAMPANIAS_Tipo` FOREIGN KEY (`Tipo`) REFERENCES `SMSTIPOSCAMPANIAS` (`TipoCampaniaID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Campañas para modulo de SMS'$$