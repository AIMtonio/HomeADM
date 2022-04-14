-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINCREDFR
DELIMITER ;
DROP TABLE IF EXISTS `DESTINCREDFR`;DELIMITER $$

CREATE TABLE `DESTINCREDFR` (
  `DestinCredFRID` varchar(20) CHARACTER SET utf8 NOT NULL,
  `Descripcion` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
  `ProgramaID` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DestinCredFRID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Destinos de Credito FR'$$