-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSTIPOSCAMPANIAS
DELIMITER ;
DROP TABLE IF EXISTS `SMSTIPOSCAMPANIAS`;DELIMITER $$

CREATE TABLE `SMSTIPOSCAMPANIAS` (
  `TipoCampaniaID` int(11) NOT NULL COMMENT 'ID del Tipo de Campaña',
  `Nombre` varchar(50) DEFAULT NULL COMMENT 'Nombre del tipo de Campaña\\n',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'Clasificacion de la Campaña\\\\nE: Entrada\\\\nS: Salida\\\\nI: Interactiva\\n',
  `Categoria` char(1) DEFAULT NULL COMMENT 'Categoria de la campaña\\\\\\\\nA Automatica\\\\\\\\nE: Por Evento\\\\\\\\nC: Campaña',
  `Reservado` char(1) DEFAULT NULL COMMENT 'Determina si el tipo es reservado para SAFI o para el usuario\\nR: Reservado(SAFI)\\nU:Usuario',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoCampaniaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Campañas SMS'$$