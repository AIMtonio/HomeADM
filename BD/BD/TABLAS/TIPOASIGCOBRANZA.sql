-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOASIGCOBRANZA
DELIMITER ;
DROP TABLE IF EXISTS `TIPOASIGCOBRANZA`;DELIMITER $$

CREATE TABLE `TIPOASIGCOBRANZA` (
  `TipoAsigCobranzaID` int(11) NOT NULL COMMENT 'Identificador consecutivo de la tabla',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion del tipo de asignacion',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoAsigCobranzaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacenara los tipos de Asignacion de Cobranza'$$