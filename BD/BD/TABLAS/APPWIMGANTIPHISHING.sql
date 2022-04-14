-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWIMGANTIPHISHING
DELIMITER ;
DROP TABLE IF EXISTS `APPWIMGANTIPHISHING`;
DELIMITER $$
CREATE TABLE `APPWIMGANTIPHISHING` (
  `ImagenPhishingID` bigint(20) NOT NULL COMMENT 'Folio consecutivo para el control de las Imagenes usadas en el antifishing.',
  `ImagenBinaria` mediumblob NOT NULL COMMENT 'Almacena la imagen',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion de la imagen.\n',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Imagen, es decir si es vigente o no.',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`ImagenPhishingID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Tabla donde se almacenan los catalogos de imagenes para el Antifishing.'$$