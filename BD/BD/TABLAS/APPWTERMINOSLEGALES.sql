-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWTERMINOSLEGALES
DELIMITER ;
DROP TABLE IF EXISTS `APPWTERMINOSLEGALES`;
DELIMITER $$

CREATE TABLE `APPWTERMINOSLEGALES` (
  `TerminoLegalID` int(11) NOT NULL COMMENT 'ID de los terminos y condiciones legales. Llave primaria.',
  `TermLegalDescri` varchar(800) NOT NULL COMMENT 'Descripcion de las condiciones.',
  `TermLegalEstatus` char(1) NOT NULL COMMENT 'Estatus del termino: A= Activo, I=Inactivo',
  `TermLegalContenido` text NOT NULL COMMENT 'Descripcion de los terminos y condiciones.',
  `EmpresaID` int(11) NOT NULL COMMENT 'Auditoria.',
  `Usuario` int(11) NOT NULL COMMENT 'Auditoria.',
  `FechaActual` datetime NOT NULL COMMENT 'Auditoria.',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Auditoria.',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Auditoria.',
  `Sucursal` int(11) NOT NULL COMMENT 'Auditoria.',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Auditoria.',
  PRIMARY KEY (`TerminoLegalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Tablas de terminos legales y condiciones.'$$