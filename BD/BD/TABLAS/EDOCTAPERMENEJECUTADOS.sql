-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAPERMENEJECUTADOS
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAPERMENEJECUTADOS`;DELIMITER $$

CREATE TABLE `EDOCTAPERMENEJECUTADOS` (
  `Anio` int(11) NOT NULL COMMENT 'Anio en el que se genero el estado de cuenta',
  `MesInicio` int(11) NOT NULL COMMENT 'Mes inicial en el que se genero el estado de cuenta',
  `MesFin` int(11) NOT NULL COMMENT 'Mes final en el que se genero el estado de cuenta',
  `Tipo` char(1) NOT NULL COMMENT 'Tipo de estado de cuenta generado. M = Mensual, S = Semestral',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`Anio`,`MesInicio`,`MesFin`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el historial de estados de cuenta mensuales generados.'$$