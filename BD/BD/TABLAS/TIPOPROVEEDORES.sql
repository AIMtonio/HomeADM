-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEEDORES
DELIMITER ;
DROP TABLE IF EXISTS `TIPOPROVEEDORES`;DELIMITER $$

CREATE TABLE `TIPOPROVEEDORES` (
  `TipoProveedorID` int(12) NOT NULL COMMENT 'Identificador tipo proveedor',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripción tipo proveedor',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo Persona\\nF=Fisica,M=Moral',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoProveedorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para definir los tipos de proveedores'$$