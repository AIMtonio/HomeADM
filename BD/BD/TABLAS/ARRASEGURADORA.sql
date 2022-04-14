-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRASEGURADORA
DELIMITER ;
DROP TABLE IF EXISTS `ARRASEGURADORA`;DELIMITER $$

CREATE TABLE `ARRASEGURADORA` (
  `AseguradoraID` int(11) NOT NULL COMMENT 'ID de la Aseguradora',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Nombre de la Aseguradora',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus en el que se encuentra la categoria:A=Activo, I=Inactivo',
  `TipoSeguro` int(11) NOT NULL COMMENT 'Tipo de seguro: 1=seguro para mueble, 2=seguro para autos, 3=seguro para ambos',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`AseguradoraID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar los seguro que puede tener un activo.'$$