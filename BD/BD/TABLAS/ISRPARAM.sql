-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISRPARAM
DELIMITER ;
DROP TABLE IF EXISTS `ISRPARAM`;DELIMITER $$

CREATE TABLE `ISRPARAM` (
  `ISRParamID` bigint(12) NOT NULL COMMENT 'Número identificador.',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Indica si el Cálculo del ISR Informativo se encuentra activo.\nA.- Activo\nI.- Inactivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ISRParamID`),
  KEY `ISRPARAM_IDX_1` (`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='PAR: Tabla en la que se parametriza si se activa el cálculo del ISR Informativo en Inversiones y CEDES.'$$