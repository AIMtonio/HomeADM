-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOINFORMACION
DELIMITER ;
DROP TABLE IF EXISTS `TIPOINFORMACION`;DELIMITER $$

CREATE TABLE `TIPOINFORMACION` (
  `TipoInforID` int(11) NOT NULL COMMENT 'ID Tipo de Informacion para el Regulatorio R-24',
  `Descripcion` varchar(250) NOT NULL COMMENT 'Descripcion',
  `TipoInstitID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id del tipo de Institucion (TIPOSINSTITUCION) para el regulatorio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'campo de auditoria',
  PRIMARY KEY (`TipoInforID`,`TipoInstitID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Informacion Regulatorio R24 - D2441'$$