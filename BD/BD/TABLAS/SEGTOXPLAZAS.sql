-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOXPLAZAS
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOXPLAZAS`;DELIMITER $$

CREATE TABLE `SEGTOXPLAZAS` (
  `SeguimientoID` int(11) NOT NULL COMMENT 'identificador de Seguimiento Fk dela tabla SEGUIMIENTOCAMPO',
  `PlazaID` int(11) NOT NULL COMMENT 'Identificador de la Plaza fk con la tabla PLAZAS',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguimientoID`,`PlazaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Plazas a las que se les aplica el seguimiento'$$