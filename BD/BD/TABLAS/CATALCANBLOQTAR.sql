-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALCANBLOQTAR
DELIMITER ;
DROP TABLE IF EXISTS `CATALCANBLOQTAR`;DELIMITER $$

CREATE TABLE `CATALCANBLOQTAR` (
  `MotCanBloID` int(11) NOT NULL COMMENT 'Identificador del Tipo de Cancelacion o Bloqueo.',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion detallada del Tipo de Cancelacion o Bloqueo.',
  `Tipo` char(1) DEFAULT NULL COMMENT 'B = Bloqueos, C= Cancelaciones T=Todos, D= Desbloqueo, A=Procesos Automaticos',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus \\nA= Activo\\nI= Inactivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria\\n',
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MotCanBloID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Motivos de Bloqueo y Cancelacion de Tarjetas Deb'$$