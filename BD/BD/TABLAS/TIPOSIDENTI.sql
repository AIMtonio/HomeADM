-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSIDENTI
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSIDENTI`;DELIMITER $$

CREATE TABLE `TIPOSIDENTI` (
  `TipoIdentiID` int(11) NOT NULL COMMENT 'Numero de\nIdentificacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Nombre` varchar(45) NOT NULL COMMENT 'Nombre o\nDescripcion\n',
  `NumeroCaracteres` int(11) DEFAULT NULL COMMENT 'Numero de \nDigitos',
  `Oficial` varchar(1) NOT NULL COMMENT 'La Identificacion\nes oficial \n\nS .- Si\nN .- No',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoIdentiID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo Base de Tipos de Identificacion'$$