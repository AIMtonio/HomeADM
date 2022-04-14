-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSEGOPER
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSEGOPER`;DELIMITER $$

CREATE TABLE `PARAMETROSEGOPER` (
  `TipoPersona` char(1) NOT NULL,
  `TipoInstrumento` int(11) NOT NULL,
  `NacCliente` char(1) NOT NULL,
  `MontoInferior` decimal(12,2) DEFAULT NULL,
  `MonedaComp` int(11) DEFAULT NULL,
  `FechaInicioVigencia` datetime DEFAULT NULL,
  `NivelSeguimien` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoPersona`,`TipoInstrumento`,`NacCliente`,`NivelSeguimien`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$