-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALENDARIOMINISTRA
DELIMITER ;
DROP TABLE IF EXISTS `CALENDARIOMINISTRA`;DELIMITER $$

CREATE TABLE `CALENDARIOMINISTRA` (
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'ID del producto de Crédito.',
  `TomaFechaInhabil` char(1) DEFAULT NULL COMMENT 'Indica el tipo de dia habil toma cuando se trata de un día inhabil.\nS.- Dia Habil Siguiente.\nA.- Día Habil Anterior.',
  `PermiteCalIrregular` char(1) DEFAULT NULL COMMENT 'Indica si permite o no calendario irregular.\nS.- Si permite.\nN.- No permite.',
  `DiasCancelacion` int(11) DEFAULT NULL COMMENT 'Indica el número de días en el cual se hará la cancelación de la ministración.',
  `DiasMaxMinistraPosterior` int(11) DEFAULT NULL COMMENT 'Indica el número máximo de días de desembolso posterior a la fecha de ministración.',
  `Frecuencias` varchar(200) DEFAULT NULL COMMENT 'Guarda los ids de las frecuencias separadas por comas (,).\nCorresponde al ID de la tabla CATFRECUENCIAS.',
  `Plazos` varchar(750) DEFAULT NULL COMMENT 'Guarda los ids de los plazos separados por comas (,).\nCorresponde al ID de la tabla CALENDARIOPROD.',
  `TipoCancelacion` char(1) DEFAULT 'U' COMMENT 'Tipo de cancelación a aplicar.\nU.- Últimas cuotas.\nI.- Cuotas siguientes inmediatas.\nV.- Prorrateo en cuotas vivas.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`ProductoCreditoID`),
  KEY `INDEX_CALENDARIOMINISTRA_1` (`Frecuencias`),
  KEY `INDEX_CALENDARIOMINISTRA_2` (`Plazos`),
  CONSTRAINT `FK_CALENDARIOMINISTRA_1` FOREIGN KEY (`ProductoCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el calendario de ministraciones de creditos agropecuarios (FIRA) por producto de crédito.'$$