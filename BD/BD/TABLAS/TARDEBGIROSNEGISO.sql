-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROSNEGISO
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBGIROSNEGISO`;DELIMITER $$

CREATE TABLE `TARDEBGIROSNEGISO` (
  `GiroID` char(5) NOT NULL DEFAULT '' COMMENT 'Codigo MerchanType Segun ISO8583 Aceptado para este tipo de Tarjeta Debito.',
  `Descripcion` varchar(500) DEFAULT NULL COMMENT 'Descripcion del Giro de Negocio Segun ISO8583',
  `NombreCorto` varchar(30) DEFAULT NULL COMMENT 'Nombre Corto Asignado',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Registro  A.-Activo C.-Cancelado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GiroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Giros de Negocios.'$$