-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRCSUBTIPOACTIVO
DELIMITER ;
DROP TABLE IF EXISTS `ARRCSUBTIPOACTIVO`;DELIMITER $$

CREATE TABLE `ARRCSUBTIPOACTIVO` (
  `SubtipoActivoID` int(11) NOT NULL COMMENT 'ID de la categoria del Activo',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Nombre de la categoria',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus en el que se encuentra la categoria:A=Activo, I=Inactivo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`SubtipoActivoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar las distintas categorias a las que pertenece un activo.'$$