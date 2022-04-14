-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRORRATEOCONTABLE
DELIMITER ;
DROP TABLE IF EXISTS `PRORRATEOCONTABLE`;DELIMITER $$

CREATE TABLE `PRORRATEOCONTABLE` (
  `ProrrateoID` int(11) NOT NULL COMMENT 'ID del metodo de prorrateo\n',
  `NombreProrrateo` varchar(50) NOT NULL COMMENT 'Nombre del metodo de prorrateo',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del metodo de prorrateo',
  `Estatus` char(1) NOT NULL COMMENT 'estatus del metodo de prorrateo contable :\nA - Activo\nI  - Inactivo',
  `FechaAct` datetime DEFAULT NULL COMMENT 'Fecha de Actualizacion del metodo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ProrrateoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$