-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATRATIOS
DELIMITER ;
DROP TABLE IF EXISTS `CATRATIOS`;DELIMITER $$

CREATE TABLE `CATRATIOS` (
  `RatiosCatalogoID` int(11) NOT NULL COMMENT 'ID Del Catalogo de Ratios ',
  `Tipo` int(11) NOT NULL COMMENT 'Tipo de Catalogo, \n1: Concepto\n2: Clasificiacion\n3: SubClasificacion\n4: Puntos por Clasificacion',
  `ConceptoID` int(11) DEFAULT NULL,
  `ClasificacionID` varchar(45) DEFAULT NULL,
  `SubClasificacionID` varchar(45) DEFAULT NULL,
  `Descripcion` varchar(500) NOT NULL COMMENT 'Descripcion del Concepto',
  `PorcentajeDefault` decimal(14,2) DEFAULT NULL COMMENT 'Auditoria',
  `LimiteInferiorDef` decimal(14,2) DEFAULT NULL COMMENT 'Este campo aplica cuando es un rango, y solo para las que son Tipo:\n4: Puntos',
  `LimiteSuperiorDef` decimal(14,2) DEFAULT NULL COMMENT 'Este campo aplica cuando es un Rangoo, y solo para las que son Tipo:\n4: Puntos',
  `PuntosDef` decimal(14,2) DEFAULT NULL COMMENT 'Puntaje correspondiente a cada valor a ponderar, y solo para las que son Tipo:\n4: Puntos',
  `RatiosCatalogoOriID` int(11) DEFAULT NULL COMMENT 'ID Original',
  `Empresa` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`RatiosCatalogoID`),
  UNIQUE KEY `RatiosCatalogoID_UNIQUE` (`RatiosCatalogoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Catalogo de Ratios.'$$