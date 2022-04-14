-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FORMULASEGTOPLD
DELIMITER ;
DROP TABLE IF EXISTS `FORMULASEGTOPLD`;DELIMITER $$

CREATE TABLE `FORMULASEGTOPLD` (
  `FormularioID` int(11) NOT NULL COMMENT 'clave de formulario en levantamiento de información de segto',
  `Descripcion` varchar(30) DEFAULT NULL COMMENT 'descripcion del formulario en levantamiento de información',
  `RefDocumento` varchar(10) DEFAULT NULL COMMENT 'numero o cve de referencia interna del formulario ',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FormularioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de formularios requeridos en levantamiento de infor'$$