-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTATUSTD
DELIMITER ;
DROP TABLE IF EXISTS `ESTATUSTD`;DELIMITER $$

CREATE TABLE `ESTATUSTD` (
  `EstatusID` int(11) NOT NULL COMMENT 'ID del Estatus ',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del Estatus de la tarjeta',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EstatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Estatus de la tarjeta de debito	'$$