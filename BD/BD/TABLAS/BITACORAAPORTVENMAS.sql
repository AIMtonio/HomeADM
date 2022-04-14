-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAAPORTVENMAS
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAAPORTVENMAS`;DELIMITER $$

CREATE TABLE `BITACORAAPORTVENMAS` (
  `FechaProceso` datetime NOT NULL COMMENT 'Fecha en la que se realiza el proceso',
  `UsuarioProceso` int(11) NOT NULL COMMENT 'ID del usuario que realiza el proceso',
  `Tiempo` int(11) NOT NULL COMMENT 'Tiempo de ejecucion del proceso',
  `NumRegistros` int(11) NOT NULL COMMENT 'Numero de registros que se procesaron',
  `Exitos` int(11) NOT NULL COMMENT 'Total de registros que si se procesaron en el vencimiento masivo de Aportaciones',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(41) NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`FechaProceso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que registra el proceso de vencimiento masivo de Aportaciones'$$