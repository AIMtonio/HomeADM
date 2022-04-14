-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCATCOMISIONES
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCATCOMISIONES`;DELIMITER $$

CREATE TABLE `TARDEBCATCOMISIONES` (
  `TarDebComisionID` int(11) NOT NULL COMMENT 'Id de la Comision',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion de la Comision ',
  `Estatus` varchar(20) DEFAULT NULL COMMENT 'Estatus del Registro, A.-Activo, C.-Cancelado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TarDebComisionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Esquema de Comisiones de la Tarjeta de Debito'$$