-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQCOBROACCESORIOS
DELIMITER ;
DROP TABLE IF EXISTS `ESQCOBROACCESORIOS`;
DELIMITER $$


CREATE TABLE `ESQCOBROACCESORIOS` (
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'Producto de Credito',
  `ConvenioID` int(11) NOT NULL COMMENT 'Identificador del Convenio',
  `PlazoID` int(11) NOT NULL COMMENT 'Plazo del Producto de Credito',
  `CicloIni` int(11) NOT NULL COMMENT 'Ciclo Inicial del Cliente',
  `CicloFin` int(11) NOT NULL COMMENT 'Ciclo Final del Cliente',
  `MontoMin` decimal(12,2) NOT NULL COMMENT 'Monto Minimo del Cliente',
  `MontoMax` decimal(12,2) NOT NULL COMMENT 'Monto Maximo del Cliente',
  `AccesorioID` int(11) NOT NULL COMMENT 'Identificador del accesorio',
  `Porcentaje` decimal(12,2) DEFAULT '0.00' COMMENT 'Porcentaje del Accesorio',
  `NivelID` int(11) DEFAULT '0' COMMENT 'Indica el nivel de Credito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ProductoCreditoID`,`ConvenioID`,`PlazoID`,`AccesorioID`,`CicloIni`,`CicloFin`,`MontoMin`,`MontoMax`,`Porcentaje`),
  KEY `FK_ESQCOBROACCESORIOS_1_idx` (`ProductoCreditoID`),
  KEY `FK_ESQCOBROACCESORIOS_2_idx` (`PlazoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Esquema de Accesorios porcentaje que cobra por Producto y Plazo'$$