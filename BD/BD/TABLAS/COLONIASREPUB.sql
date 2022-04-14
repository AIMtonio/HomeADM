-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COLONIASREPUB
DELIMITER ;
DROP TABLE IF EXISTS `COLONIASREPUB`;DELIMITER $$

CREATE TABLE `COLONIASREPUB` (
  `EstadoID` int(11) NOT NULL,
  `MunicipioID` int(11) NOT NULL,
  `ColoniaID` int(11) NOT NULL,
  `TipoAsenta` varchar(200) DEFAULT NULL,
  `Asentamiento` varchar(200) DEFAULT NULL,
  `CodigoPostal` varchar(10) DEFAULT NULL,
  `ClaveINEGI` varchar(20) DEFAULT NULL,
  `ColoniaCNBV` varchar(9) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`EstadoID`,`MunicipioID`,`ColoniaID`),
  KEY `MunicipioIDX` (`MunicipioID`),
  KEY `ColoniaIDX` (`ColoniaID`),
  KEY `idx_COLONIASREPUB_1` (`CodigoPostal`,`ClaveINEGI`,`EstadoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de colonias de la republica'$$