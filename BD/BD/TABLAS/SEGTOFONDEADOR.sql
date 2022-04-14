-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOFONDEADOR
DELIMITER ;
DROP TABLE IF EXISTS `SEGTOFONDEADOR`;DELIMITER $$

CREATE TABLE `SEGTOFONDEADOR` (
  `SeguimientoID` int(11) NOT NULL COMMENT 'Identificador del Seguimiento',
  `FondeadorID` int(11) NOT NULL COMMENT 'Identificador del Fondeador FK con la tabla de INSTITUTFONDEO',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguimientoID`,`FondeadorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Fondeadores que aplican al Seguimiento'$$