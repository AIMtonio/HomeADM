-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOASENTAMIENTO
DELIMITER ;
DROP TABLE IF EXISTS `TIPOASENTAMIENTO`;DELIMITER $$

CREATE TABLE `TIPOASENTAMIENTO` (
  `TipoAsentamientoID` varchar(100) NOT NULL,
  `ClaveCirculoCre` char(2) NOT NULL COMMENT 'Clave del Asentamiento Segun Circulo de Credito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoAsentamientoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Asentamiento para las Direcciones'$$