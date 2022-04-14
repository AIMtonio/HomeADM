-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSPORSUCAPLIC
DELIMITER ;
DROP TABLE IF EXISTS `FOLIOSPORSUCAPLIC`;DELIMITER $$

CREATE TABLE `FOLIOSPORSUCAPLIC` (
  `FolioID` bigint(20) NOT NULL COMMENT 'Folio o \nConsecutivo\n',
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal',
  `Tabla` varchar(100) NOT NULL COMMENT 'Nombre de\nla Tabla',
  PRIMARY KEY (`SucursalID`,`Tabla`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Control de Folios por Sucursal de la Aplicacion'$$