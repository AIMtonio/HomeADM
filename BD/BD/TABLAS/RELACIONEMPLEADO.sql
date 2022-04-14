-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONEMPLEADO
DELIMITER ;
DROP TABLE IF EXISTS `RELACIONEMPLEADO`;
DELIMITER $$


CREATE TABLE `RELACIONEMPLEADO` (
  `RelacionEmpID` int(11) NOT NULL COMMENT 'Identificador de la Relacion\n',
  `EmpleadoID` bigint(20) DEFAULT NULL COMMENT 'FK del Empleado relacionado',
  `RelacionadoID` bigint(20) DEFAULT NULL COMMENT 'Id del Cliente relacionado con el empleado',
  `NombreRelacionado` varchar(200) DEFAULT NULL COMMENT 'Nombre del Relacionado/Nombre del Cliente',
  `CURP` char(18) DEFAULT NULL COMMENT 'CURP de la persona relacionada',
  `RFC` varchar(45) DEFAULT NULL COMMENT 'RFC de la persona relacionada',
  `PuestoID` int(11) DEFAULT '0' COMMENT 'Puesto de la persona relacionada',
  `ParentescoID` int(11) DEFAULT NULL COMMENT 'FK del identificador del parentesco ',
  `TipoRelacion` int(11) DEFAULT NULL COMMENT 'Parametro para identificar el tipo de relacion\n1.- Relacion de un empleado con otro cliente \n2.- Relacion de un empleado con una persona que no es cliente de la institucion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`RelacionEmpID`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_1` (`EmpleadoID`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_2` (`RelacionadoID`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_3` (`ParentescoID`),
  KEY `IDX_RELACIONEMPLEADOCLIENTE_4` (`RelacionadoID`,`TipoRelacion`,`ParentescoID`),
  CONSTRAINT `FK_RELACIONEMPLEADOCLIENTE_3` FOREIGN KEY (`ParentescoID`) REFERENCES `TIPORELACIONES` (`TipoRelacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar las relaciones existentes entre cliente'$$