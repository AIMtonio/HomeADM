-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOGESTION
DELIMITER ;
DROP TABLE IF EXISTS `TIPOGESTION`;DELIMITER $$

CREATE TABLE `TIPOGESTION` (
  `TipoGestionID` int(11) NOT NULL COMMENT 'ID tipo de gestion',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion del Tipo de Gestor',
  `TipoAsigna` char(1) DEFAULT NULL COMMENT 'C="Comercio"  T="Territorio"',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Tipo Gestor\nA .- Activo\nC .- Cancelado o Baja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoGestionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para los tipos de gestion'$$