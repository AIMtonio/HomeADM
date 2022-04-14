-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCREMEN
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCREMEN`;DELIMITER $$

CREATE TABLE `CIRCULOCREMEN` (
  `fk_SolicitudID` varchar(10) NOT NULL COMMENT 'Es el numero de \nconsecutivo \nobtenido del \nprograma de \ncirculo de credito \nde la tabla de \nCIRCULOCRESOL',
  `Consecutivo` int(11) NOT NULL COMMENT 'Es el consecutivo\ndel numero de \nobjetos que se \nencuentran \nrelacionados a la\ntabla correspondiente\nen este caso son \nlas cuentas que \ntiene con el/los otorgante(s) \nla persona consultada',
  `TipoMensaje` varchar(5) DEFAULT NULL COMMENT 'Es el tipo de mensaje\ndefinido en el manual\nesquema consulta y \nrespuesta en la seccion\nElemento mensaje',
  `Leyenda` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`fk_SolicitudID`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los comentarios realizados por el otorgante y/o la '$$