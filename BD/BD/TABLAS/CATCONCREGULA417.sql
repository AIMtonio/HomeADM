-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCONCREGULA417
DELIMITER ;
DROP TABLE IF EXISTS `CATCONCREGULA417`;DELIMITER $$

CREATE TABLE `CATCONCREGULA417` (
  `ConceptoID` int(11) NOT NULL COMMENT 'ID o Consecutivo del Concepto',
  `ClaveConcepto` varchar(45) NOT NULL COMMENT 'Clave del Concepto',
  `Descripcion` varchar(400) NOT NULL COMMENT 'Descripcion',
  `TipoCartera` int(11) NOT NULL COMMENT 'Tipo de Cartera. 9.- Cartera Base, 10 .- Monto de EPRC',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden para el Select en los Resultados',
  `Clasificacion` char(2) DEFAULT NULL COMMENT 'Clasificacion: C .- Comercial, O .- Consumo, H.- Hipotecario Vivienda',
  `TipoCredito` char(1) DEFAULT NULL COMMENT 'N .- Nuevo, R .- Renovado o Reestructurado',
  `MinDiasAtraso` int(11) DEFAULT NULL COMMENT 'Minimo de Dias de Atraso',
  `MaxDiasAtraso` int(11) DEFAULT NULL COMMENT 'Maximo de Dias de Atraso',
  `Nivel` char(1) DEFAULT NULL COMMENT 'Nivel, E .- Encabezado, D .- Detalle',
  `TipoEPRC` varchar(5) DEFAULT NULL COMMENT 'Tipo de EPRC.- CAL .- De Calificacion, ADI .- ADICIONAL',
  `CuentaMayor` varchar(45) DEFAULT NULL COMMENT 'Cuenta de Mayor, para Agrupaciones',
  `OrdenExcell` int(11) DEFAULT NULL COMMENT 'Indica el orden en que se mostrara el campo en el reporte excel.',
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'Clasificacion del Concepto para Regulatorios',
  `TipoInstitID` int(11) NOT NULL,
  PRIMARY KEY (`ConceptoID`,`TipoInstitID`),
  KEY `CATCONCREGULA417_1` (`Clasificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Conceptos para el Reporte Regulatorio 417'$$