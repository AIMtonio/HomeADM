-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMOTCANCELCHEQUE
DELIMITER ;
DROP TABLE IF EXISTS `CATMOTCANCELCHEQUE`;DELIMITER $$

CREATE TABLE `CATMOTCANCELCHEQUE` (
  `MotivoID` int(11) NOT NULL COMMENT 'ID del motivo de cancelacion',
  `Descripcion` varchar(200) NOT NULL COMMENT 'Descripcion de motivo',
  `Estatus` char(1) NOT NULL DEFAULT '' COMMENT 'Estatus del motivo A (Activo) I (Inactivo)',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`MotivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los motivos de cancelacion de cheques.'$$