-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOPALABINCONV
DELIMITER ;
DROP TABLE IF EXISTS `CATALOGOPALABINCONV`;DELIMITER $$

CREATE TABLE `CATALOGOPALABINCONV` (
  `PalabraInconvID` int(11) NOT NULL COMMENT 'Id de la Palabra',
  `PalabraInconv` char(4) NOT NULL COMMENT 'Palabra Inconveniente',
  `PalabraSustituida` char(4) NOT NULL COMMENT 'Palabra por la que se sustituye la palabra inconveniente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PalabraInconvID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Palabras Inconvenientes'$$