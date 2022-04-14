-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REGULATORIOI0391
DELIMITER ;
DROP TABLE IF EXISTS `HIS-REGULATORIOI0391`;DELIMITER $$

CREATE TABLE `HIS-REGULATORIOI0391` (
  `Anio` int(11) NOT NULL COMMENT 'Año del periodo',
  `Mes` int(11) NOT NULL COMMENT 'Mes del Periodo',
  `Periodo` varchar(6) NOT NULL COMMENT 'Perido Concatenado',
  `ClaveEntidad` varchar(6) NOT NULL COMMENT 'Clave de la Entidad',
  `Subreporte` varchar(4) NOT NULL COMMENT 'Número de Subreporte Regulatorio',
  `Entidad` varchar(8) NOT NULL COMMENT 'Clave de la Entidad Financiera',
  `Emisora` varchar(7) DEFAULT NULL,
  `Serie` varchar(10) DEFAULT NULL,
  `FormaAdqui` varchar(5) DEFAULT NULL COMMENT 'Clave Forma de Adquisición',
  `TipoInstru` varchar(5) DEFAULT NULL COMMENT 'Clave Tipo de Instrumento',
  `ClasfConta` varchar(12) DEFAULT NULL COMMENT 'Clave Clasificación Contable',
  `FechaContra` varchar(8) DEFAULT NULL COMMENT 'Fecha de Contratación',
  `FechaVencim` varchar(8) DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `NumeroTitu` varchar(21) DEFAULT NULL COMMENT 'Número de Titulos',
  `CostoAdqui` varchar(21) DEFAULT NULL COMMENT 'Costo de Adquisición',
  `TasaInteres` varchar(16) DEFAULT NULL COMMENT 'Tasa de Interes',
  `GrupoRiesgo` varchar(5) DEFAULT NULL COMMENT 'Clave Grupo de Riesgo',
  `Valuacion` varchar(21) DEFAULT NULL COMMENT 'Valuación',
  `ResValuacion` varchar(21) DEFAULT NULL COMMENT 'Resultado de la Valuación',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Consecutivo',
  `TipoValorID` varchar(4) DEFAULT NULL COMMENT 'Tipo de ValorID',
  `TipoInversion` varchar(3) DEFAULT NULL COMMENT 'ID del Tipo de Inversion',
  `TipoInstitucionID` int(11) DEFAULT NULL COMMENT 'ID del Tipo de Institucion (TIPOSINSITUCION)',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `INDEX_HIS-REGULATORIOI0391_1` (`Anio`,`Mes`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$