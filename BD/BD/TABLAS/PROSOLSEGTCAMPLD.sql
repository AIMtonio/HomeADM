-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROSOLSEGTCAMPLD
DELIMITER ;
DROP TABLE IF EXISTS `PROSOLSEGTCAMPLD`;DELIMITER $$

CREATE TABLE `PROSOLSEGTCAMPLD` (
  `SegmentoID` int(11) NOT NULL COMMENT 'procesos/motivos que generan solicitudes de seguimiento en campo',
  `DiasProgIni` int(2) DEFAULT NULL COMMENT 'numero de días naturales posterior a la deteccion de la operación que \nSería ideal realizar la visita de campo',
  `DiasProgFin` int(2) DEFAULT NULL COMMENT 'numero de días naturales máximos posterior a la deteccion de la ',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'N. Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SegmentoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de procesos que generan solicitudes de seguimiento '$$