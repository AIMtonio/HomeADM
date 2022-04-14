-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINOSCREDITOTMP
DELIMITER ;
DROP TABLE IF EXISTS `DESTINOSCREDITOTMP`;DELIMITER $$

CREATE TABLE `DESTINOSCREDITOTMP` (
  `DestinoCreID` int(11) NOT NULL,
  `Descripcion` varchar(300) DEFAULT NULL,
  `DestinCredFRID` varchar(20) DEFAULT NULL,
  `DestinCredFOMURID` varchar(20) DEFAULT NULL,
  `Clasificacion` char(1) DEFAULT NULL,
  `SubClasifID` int(11) DEFAULT NULL,
  `ClaveCirculoCredito` char(2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`DestinoCreID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$