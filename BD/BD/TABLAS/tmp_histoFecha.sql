-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_histoFecha
DELIMITER ;
DROP TABLE IF EXISTS `tmp_histoFecha`;DELIMITER $$

CREATE TABLE `tmp_histoFecha` (
  `Consecutivo` int(11) NOT NULL,
  `FolioConsultaBC` varchar(45) DEFAULT NULL,
  `ValorHis` char(1) DEFAULT NULL,
  `Anio` char(4) DEFAULT NULL,
  `Mes` char(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$