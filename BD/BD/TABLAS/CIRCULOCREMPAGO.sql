-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCREMPAGO
DELIMITER ;
DROP TABLE IF EXISTS `CIRCULOCREMPAGO`;DELIMITER $$

CREATE TABLE `CIRCULOCREMPAGO` (
  `fk_SolicitudID` varchar(10) NOT NULL COMMENT 'Es el numero de \nconsecutivo \nobtenido del \nprograma de \ncirculo de credito\nde la tabla \nCIRCULOCRESOL',
  `Consecutivo` int(11) NOT NULL COMMENT 'Es el consecutivo\ndel numero de \nobjetos que se \nencuentran \nrelacionados a la\ntabla correspondiente\nen este caso son \nlas consultas que \nse le han hecho a la \npersona que se consulta.',
  `NumPagVencidos` int(11) DEFAULT NULL,
  `HistoricoPagos` varchar(168) DEFAULT NULL,
  `FechaRecHisPag` date DEFAULT NULL COMMENT 'Fecha del último histórico de esta cuenta que se\nintegro a la Base de Datos. Formato: AAAA-MM-DD\n',
  PRIMARY KEY (`fk_SolicitudID`,`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico de pagos proporcionada por los otorgantes con resp'$$