-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCATPROCEDINT
DELIMITER ;
DROP TABLE IF EXISTS `PLDCATPROCEDINT`;DELIMITER $$

CREATE TABLE `PLDCATPROCEDINT` (
  `CatProcedIntID` varchar(10) NOT NULL COMMENT 'Identificador del Procedimiento Interno',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Numero de Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CatProcedIntID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Procedimientos internos'$$