-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINOSCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `DESTINOSCREDITO`;DELIMITER $$

CREATE TABLE `DESTINOSCREDITO` (
  `DestinoCreID` int(11) NOT NULL,
  `Descripcion` varchar(300) NOT NULL,
  `DestinCredFRID` varchar(20) DEFAULT NULL,
  `DestinCredFOMURID` varchar(20) DEFAULT NULL,
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'C : Comercial\nO : Consumo\nH : Hipotecario',
  `SubClasifID` int(11) DEFAULT NULL COMMENT 'ID de Sub Clasificacion de Cartera',
  `ClaveCirculoCredito` char(2) DEFAULT NULL COMMENT 'Clave del Tipo de Credito Segun Circulo de Credito',
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'ID o Numero de la Clasificación de Rep Regulatorios',
  `ClaveRiesgo` char(1) DEFAULT NULL COMMENT 'Campo para matriz de riesgos PLD - valores A.- Alto , B.-Bajo',
  `ActividadDestino` varchar(8) DEFAULT NULL COMMENT ' Clave de Actividad Economica SCIAN a la destinara el credito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `DestinoRegCar` int(11) DEFAULT NULL COMMENT 'Destino para el regulatorio C451 SOFIPOS',
  PRIMARY KEY (`DestinoCreID`),
  KEY `fk_DESTINOSCREDITO_1` (`SubClasifID`),
  KEY `fk_DESTINOSCREDITO_2` (`DestinCredFRID`),
  KEY `fk_DESTINOSCREDITO_3` (`DestinCredFOMURID`),
  CONSTRAINT `fk_DESTINOSCREDITO_1` FOREIGN KEY (`SubClasifID`) REFERENCES `CLASIFICCREDITO` (`ClasificacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Destinos del Credito'$$