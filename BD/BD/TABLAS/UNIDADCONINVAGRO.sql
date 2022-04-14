-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- UNIDADCONINVAGRO
DELIMITER ;
DROP TABLE IF EXISTS `UNIDADCONINVAGRO`;DELIMITER $$

CREATE TABLE `UNIDADCONINVAGRO` (
  `UniConceptoInvID` int(11) NOT NULL DEFAULT '0' COMMENT 'Campo con el Identificador de la Unidad de Inversion',
  `Unidad` varchar(100) NOT NULL COMMENT 'Nombre de la Unidad de Inversion',
  `Clave` varchar(45) NOT NULL COMMENT 'Clave de la Unidad de Inversion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria Fecha',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria DireccionIP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria NumTrasaccion',
  PRIMARY KEY (`UniConceptoInvID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA DONDE SE CAPTURAN LAS UNIDADES DE LOS CONCEPTOS DE INVERSION DEL MODULO FIRA '$$