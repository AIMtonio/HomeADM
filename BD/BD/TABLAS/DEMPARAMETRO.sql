-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMPARAMETRO
DELIMITER ;
DROP TABLE IF EXISTS `DEMPARAMETRO`;DELIMITER $$

CREATE TABLE `DEMPARAMETRO` (
  `TareaID` int(11) NOT NULL COMMENT 'Identificador de la tarea del demonio',
  `Parametro` varchar(20) NOT NULL COMMENT 'Parametro de la tarea',
  `Valor` varchar(200) NOT NULL COMMENT 'Valor del parametro',
  `Descripcion` varchar(800) NOT NULL COMMENT 'Descripcion del parametro',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Parametro`),
  KEY `INDEX_DEMPARAMETRO_1` (`Parametro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Registro de los diferentes parametros que utiliza cada tarea ejecutada por el demonio'$$