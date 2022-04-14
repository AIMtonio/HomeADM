-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINCREDFOMUR
DELIMITER ;
DROP TABLE IF EXISTS `DESTINCREDFOMUR`;DELIMITER $$

CREATE TABLE `DESTINCREDFOMUR` (
  `DestinCredFOMURID` varchar(20) NOT NULL,
  `Descripcion` varchar(200) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DestinCredFOMURID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Destinos de Credito FOMUR'$$