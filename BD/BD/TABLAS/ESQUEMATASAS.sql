-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMATASAS
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMATASAS`;DELIMITER $$

CREATE TABLE `ESQUEMATASAS` (
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal',
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'Producto de Credito\\n',
  `MinCredito` int(11) NOT NULL COMMENT 'Minimo des Creditos',
  `MaxCredito` int(11) NOT NULL COMMENT 'Maximo de Creditos',
  `Calificacion` char(1) NOT NULL COMMENT 'Calificacion del cliente\\n\\nN : NO ASIGNADA\\nA: EXCELENTE\\nB : BUENA\\nC : REGULAR',
  `MontoInferior` decimal(12,2) NOT NULL COMMENT 'Monto Inferior',
  `MontoSuperior` decimal(12,2) NOT NULL COMMENT 'Monto Superior',
  `PlazoID` varchar(20) NOT NULL COMMENT 'Su valor por default es "T"=TODOS los plazos, en caso de definirse un valor debe de existir en la tabla CREDITOSPLAZOS.',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Fija',
  `SobreTasa` decimal(12,4) DEFAULT NULL COMMENT 'Sobre Tasa',
  `InstitNominaID` int(11) NOT NULL DEFAULT '0' COMMENT 'Institución de Nómina',
  `NivelID` int(11) NOT NULL DEFAULT '0' COMMENT 'Valor que el analista de credito asigna al momento de realizar el registro, hace referecia a una tabla	',
  `Empresa` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SucursalID`,`ProductoCreditoID`,`MinCredito`,`MaxCredito`,`Calificacion`,`MontoInferior`,`MontoSuperior`,`PlazoID`,`InstitNominaID`,`NivelID`),
  KEY `idx_ESQUEMATASAS_1` (`NivelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Esquema de Tasas'$$