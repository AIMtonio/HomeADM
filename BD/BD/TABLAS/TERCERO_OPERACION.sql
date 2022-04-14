-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TERCERO_OPERACION
DELIMITER ;
DROP TABLE IF EXISTS `TERCERO_OPERACION`;DELIMITER $$

CREATE TABLE `TERCERO_OPERACION` (
  `TipoTercero` varchar(2) NOT NULL,
  `TipoOperacion` varchar(2) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoTercero`,`TipoOperacion`),
  KEY `fk_TipoOperacion_idx` (`TipoOperacion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Relacion de tabla CATTIPOTERCERODIOT - CATTIPOOPERACIONDIOT'$$