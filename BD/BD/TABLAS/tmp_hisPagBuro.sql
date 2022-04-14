-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- tmp_hisPagBuro
DELIMITER ;
DROP TABLE IF EXISTS `tmp_hisPagBuro`;DELIMITER $$

CREATE TABLE `tmp_hisPagBuro` (
  `Consecutivo` int(11) NOT NULL,
  `CadenaHistorico` varchar(180) DEFAULT NULL,
  `FolioConsultaBC` varchar(30) DEFAULT NULL,
  `FechaAntigua` date DEFAULT NULL,
  `TamCadenaHis` int(11) DEFAULT NULL COMMENT 'Tabla donde se guardan temporalmente los valores del Historico de pagos de una consulta realizada a \nBuro de Credito.',
  PRIMARY KEY (`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$