-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCALIFCLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `TMPCALIFCLIENTE`;DELIMITER $$

CREATE TABLE `TMPCALIFCLIENTE` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente',
  `PuntosA1` decimal(12,2) DEFAULT NULL COMMENT 'AÃ±os como cliente en la institucion',
  `PuntosA2` decimal(12,2) DEFAULT NULL COMMENT 'Numero de creditos liquidados',
  `PuntosA3` decimal(12,2) DEFAULT NULL COMMENT 'Morosidad promedio creditos',
  `PuntosA4` decimal(12,2) DEFAULT NULL COMMENT 'Forma de pagar(liquidar) de sus creditos',
  `PuntosM1` decimal(12,2) DEFAULT NULL COMMENT 'AÃ±os como cliente en la institucion',
  `PuntosM2` decimal(12,2) DEFAULT NULL COMMENT 'Numero de creditos liquidados',
  `PuntosB1` decimal(12,2) DEFAULT NULL COMMENT 'Morosidad promedio creditos',
  `PuntosB2` decimal(12,2) DEFAULT NULL COMMENT 'Forma de pagar(liquidar) de sus creditos',
  `PuntosB3` decimal(12,2) DEFAULT NULL COMMENT 'Forma de pagar(liquidar) de sus creditos',
  `PagoCredAntes` int(11) DEFAULT NULL COMMENT 'Numero de creditos pagados antes de la fecha de vencimiento',
  `PagoCredEn` int(11) DEFAULT NULL COMMENT 'Numero de creditos pagados en la fecha de vencimiento',
  `PagoCredDesp` int(11) DEFAULT NULL COMMENT 'Numero de creditos pagados despues de la fecha de vencimiento',
  `TotalPuntos` decimal(12,2) DEFAULT NULL COMMENT 'Sumatoria de puntos obtenidos por todos los conceptos ',
  `NumReestruc` int(11) DEFAULT NULL COMMENT 'Numero de creditos Reestrcuturados',
  `NumRenova` int(11) DEFAULT NULL COMMENT 'Numero de creditos Renovados',
  `AsistenciaAsam` int(11) DEFAULT NULL COMMENT 'Valor de la Asistencia a Asamblea',
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena datos temporales para calcular calificacion de los '$$