-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREPASOVENCIDO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREPASOVENCIDO`;DELIMITER $$

CREATE TABLE `TMPCREPASOVENCIDO` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del Credito',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `FechaTraspaso` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha en que se debio traspasar a vencido',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'Producto de Credito',
  `FrecuenciaCapital` char(1) DEFAULT NULL COMMENT 'Frecuencia de Capital del Credito',
  `FrecuenciaInteres` char(1) DEFAULT NULL COMMENT 'Frencuencia de Interes del Credito',
  `DiasCapital` int(11) DEFAULT '0' COMMENT 'Dias paso a vencido del Tipo de Frecuencia U',
  `DiasInteres` int(11) DEFAULT '0' COMMENT 'Dias paso a vencido del Tipo de Frecuencia I',
  `FechaAtrasoCapital` date DEFAULT NULL COMMENT 'Fecha de Atraso del Capital del Credito',
  `FechaAtrasoInteres` date DEFAULT NULL COMMENT 'Fecha de Atraso de Interes del Credito',
  `FechaVencCapital` date DEFAULT '1900-01-01' COMMENT 'Fecha de Paso a Vencido del Credito por Capital',
  `FechaVencInteres` date DEFAULT '1900-01-01' COMMENT 'Fecha de Paso a Vencido del Credito por Interes',
  `DiasPasoVencido` int(4) DEFAULT '0' COMMENT 'Número de Días de Paso a Vencido de acuerdo a DIASPASOVENCIDO.',
  `AmoFechaExigible` date DEFAULT '1900-01-01' COMMENT 'Fecha mínima de Exigible de acuerdo a AMORTICREDITO.',
  PRIMARY KEY (`CreditoID`,`Transaccion`),
  KEY `TMPCREPASOVENCIDO_IDX1` (`ProductoCreditoID`),
  KEY `TMPCREPASOVENCIDO_IDX2` (`FrecuenciaCapital`),
  KEY `TMPCREPASOVENCIDO_IDX3` (`FrecuenciaInteres`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Apoyo para el Paso a Vencido de Cartera'$$