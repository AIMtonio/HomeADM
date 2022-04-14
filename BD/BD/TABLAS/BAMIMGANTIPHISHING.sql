-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMIMGANTIPHISHING
DELIMITER ;
DROP TABLE IF EXISTS `BAMIMGANTIPHISHING`;DELIMITER $$

CREATE TABLE `BAMIMGANTIPHISHING` (
  `ImagenPhishingID` bigint(20) NOT NULL COMMENT 'Folio consecutivo para el control de las Imagenes usadas en el antifishing.',
  `ImagenBinaria` mediumblob NOT NULL,
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion de la imagen.\n',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Imagen, es decir si es vigente o no.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ImagenPhishingID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla donde se almacenan los catalogos de imagenes para el Antifishing.'$$