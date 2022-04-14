-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRMAREPLEGAL
DELIMITER ;
DROP TABLE IF EXISTS `FIRMAREPLEGAL`;DELIMITER $$

CREATE TABLE `FIRMAREPLEGAL` (
  `FirmaID` int(11) NOT NULL COMMENT 'ID de la firma del representante legal',
  `Consecutivo` int(11) NOT NULL COMMENT 'Consecutivo del numero de firmas ingresadas por Representante Legal',
  `RepresentLegal` char(70) NOT NULL COMMENT 'Nombre del Representante Legal',
  `Observacion` varchar(100) NOT NULL,
  `Recurso` varchar(100) NOT NULL COMMENT 'Direccion de la firma del Representante Legal',
  `FechaRegistro` date DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(11) DEFAULT NULL,
  PRIMARY KEY (`FirmaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$