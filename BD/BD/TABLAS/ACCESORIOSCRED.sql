-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACCESORIOSCRED
DELIMITER ;
DROP TABLE IF EXISTS `ACCESORIOSCRED`;
DELIMITER $$

CREATE TABLE `ACCESORIOSCRED` (
  `AccesorioID` int(11) NOT NULL COMMENT 'Identificador del Accesorio',
  `Descripcion` varchar(100) DEFAULT '' COMMENT 'Nombre del Accesorio',
  `NombreCorto` varchar(20) DEFAULT '' COMMENT 'Abreviatura del Accesorio',
  `Prelacion` int(11) DEFAULT '0' COMMENT 'Prelacion del Accesorio',
  `CAT`CHAR(1) DEFAULT 'S' COMMENT 'Almacena si se aplica o no el Cálculo cat',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`AccesorioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catalogo de Accesorios a cobrar de un credito'$$