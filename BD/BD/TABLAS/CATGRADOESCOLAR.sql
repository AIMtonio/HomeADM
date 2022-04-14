-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATGRADOESCOLAR
DELIMITER ;
DROP TABLE IF EXISTS `CATGRADOESCOLAR`;DELIMITER $$

CREATE TABLE `CATGRADOESCOLAR` (
  `GradoEscolarID` int(11) NOT NULL COMMENT 'Llave Primaria para Catalogo de Grados Escolares',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion  del Grado Escolar',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`GradoEscolarID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Grado de Escolaridad'$$