-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRMARCAACTIVO
DELIMITER ;
DROP TABLE IF EXISTS `ARRMARCAACTIVO`;DELIMITER $$

CREATE TABLE `ARRMARCAACTIVO` (
  `MarcaID` int(11) NOT NULL COMMENT 'ID de la marca',
  `TipoActivo` int(11) NOT NULL COMMENT 'Tipo de Activos: 1=Autos, 2=Muebles',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Nombre de la marca',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus en el que se encuentra la marca: A=Activo, I=Inactivo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`MarcaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar las distintas marcas de un activo.'$$