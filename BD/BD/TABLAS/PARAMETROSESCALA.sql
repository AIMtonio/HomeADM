-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSESCALA
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSESCALA`;DELIMITER $$

CREATE TABLE `PARAMETROSESCALA` (
  `FolioID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de Folio',
  `TipoPersona` char(1) NOT NULL,
  `TipoInstrumento` int(11) NOT NULL,
  `NacMoneda` char(1) NOT NULL,
  `LimiteInferior` decimal(14,2) DEFAULT NULL COMMENT 'Limite Inferior',
  `MonedaComp` int(11) DEFAULT NULL,
  `RolTitular` int(11) DEFAULT NULL,
  `RolSuplente` int(11) DEFAULT NULL,
  `FechaVigencia` date DEFAULT NULL COMMENT 'Fecha en que inicia la vigencia',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del parametro:\nV.- Vigente\nB.- Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`FolioID`,`TipoPersona`,`TipoInstrumento`,`NacMoneda`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA DE PARAMETROS DE ESCALAMIENTO'$$