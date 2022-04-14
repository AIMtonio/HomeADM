-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPORELACIONES
DELIMITER ;
DROP TABLE IF EXISTS `TIPORELACIONES`;DELIMITER $$

CREATE TABLE `TIPORELACIONES` (
  `TipoRelacionID` int(11) NOT NULL COMMENT 'Llave primaria para Catalogo de Tipos de Relaciones',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion del Tipo de Relacion',
  `EsParentesco` char(1) DEFAULT NULL COMMENT 'Identifica si la descripcion puede ser clasificada como un parentesco del cliente, en las relaciones entre clientes y empleados\\nS .- Si\\nN.- No',
  `Tipo` char(2) DEFAULT NULL COMMENT 'Tipo de Parentesco, C.- Consanguinidad  A.-Afinidad',
  `Grado` int(11) DEFAULT NULL COMMENT 'Grado del parentesco 1 .- Primer Grado, 2.- Segundo Grado , 3.- Tercer Grado',
  `Linea` char(5) DEFAULT NULL COMMENT 'Linea del parentesco puede ser DES.- Descendente  o ASC .- Ascendente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`TipoRelacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Relaciones '$$