-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPARAMETROSESCALA
DELIMITER ;
DROP TABLE IF EXISTS `HISPARAMETROSESCALA`;DELIMITER $$

CREATE TABLE `HISPARAMETROSESCALA` (
  `FolioID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de Folio',
  `TipoPersona` char(1) NOT NULL DEFAULT '' COMMENT 'Tipo de Persona F.- Fisica M.- Moral',
  `TipoInstrumento` int(11) NOT NULL DEFAULT '0' COMMENT 'Tipo de Instrumento TIPOINSTRUMMONE',
  `NacMoneda` char(1) NOT NULL DEFAULT '' COMMENT 'Nacionalidad de la Moneda',
  `LimiteInferior` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Limite Inferior',
  `MonedaComp` int(11) NOT NULL DEFAULT '0' COMMENT 'ID de la Moneda de Comparacion MONEDAS',
  `RolTitular` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del Rol para Titular ROLES',
  `RolSuplente` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del Rol para Suplente ROLES',
  `FechaModificacion` date DEFAULT NULL COMMENT 'Fecha en que se modifico el parametro',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`FolioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA HISTORICA DE PARAMETROS DE ESCALAMIENTO'$$