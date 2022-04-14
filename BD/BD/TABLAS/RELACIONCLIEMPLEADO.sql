-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONCLIEMPLEADO
DELIMITER ;
DROP TABLE IF EXISTS `RELACIONCLIEMPLEADO`;DELIMITER $$

CREATE TABLE `RELACIONCLIEMPLEADO` (
  `RelacionID` int(11) NOT NULL COMMENT 'Identificador de la Relacion\n',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'FK del Cliente relacionado',
  `RelacionadoID` bigint(20) DEFAULT NULL COMMENT 'Id del Cliente o Empleado relacionado con el cliente',
  `ParentescoID` int(11) DEFAULT NULL COMMENT 'FK del identificador del parentesco ',
  `TipoRelacion` int(11) DEFAULT NULL COMMENT 'Parametro para identificar el tipo de relacion\n1.- Relacion de un cliente con otro cliente \n2.- Relacion de un cliente con un empleado de la institucion',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`RelacionID`),
  KEY `fk_RELACIONCLIENTEEMPLEADO_1` (`ClienteID`),
  KEY `fk_RELACIONCLIENTEEMPLEADO_3` (`ParentescoID`),
  KEY `fk_RELACIONCLIENTEEMPLEADO_4` (`RelacionadoID`,`TipoRelacion`,`ParentescoID`),
  CONSTRAINT `fk_RELACIONCLIENTEEMPLEADO_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_RELACIONCLIENTEEMPLEADO_3` FOREIGN KEY (`ParentescoID`) REFERENCES `TIPORELACIONES` (`TipoRelacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar las relaciones existentes entre cliente'$$