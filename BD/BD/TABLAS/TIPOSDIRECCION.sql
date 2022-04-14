-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSDIRECCION
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSDIRECCION`;DELIMITER $$

CREATE TABLE `TIPOSDIRECCION` (
  `TipoDireccionID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del\nTipo de Indentificacion\n',
  `Oficial` char(1) NOT NULL COMMENT 'Si es una direccion\nOficial\nS .- Si\nN .- No\n',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoDireccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo Base de Tipos de Direccion'$$