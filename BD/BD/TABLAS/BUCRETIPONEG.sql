-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUCRETIPONEG
DELIMITER ;
DROP TABLE IF EXISTS `BUCRETIPONEG`;DELIMITER $$

CREATE TABLE `BUCRETIPONEG` (
  `TipoNegocioID` varchar(5) NOT NULL COMMENT 'ID del tipo de Negocio',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion del tipo de Negocio',
  `NombreGenerico` varchar(100) DEFAULT NULL COMMENT 'Nombre Generico Corto',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoNegocioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Claves para el Tipo de Negocio Buro de Credito'$$