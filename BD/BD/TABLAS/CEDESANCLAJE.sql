-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESANCLAJE
DELIMITER ;
DROP TABLE IF EXISTS `CEDESANCLAJE`;DELIMITER $$

CREATE TABLE `CEDESANCLAJE` (
  `CedeAnclajeID` int(11) DEFAULT NULL COMMENT 'consecutivo',
  `CedeOriID` int(11) NOT NULL COMMENT 'Cede Original PK',
  `CedeAncID` int(11) NOT NULL COMMENT 'Cede Anclada PK',
  `MontoConjunto` decimal(18,2) DEFAULT NULL COMMENT 'Monto que sumariza la CEDE original con la inversion anclada.',
  `TotalRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Suma total de Capital e Intereses de CEDES Madre e Hijas.',
  `NuevaTasa` decimal(18,4) DEFAULT NULL COMMENT 'Nueva tasa Neta de la CEDE',
  `NuevoInteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'Interes ajustado a la CEDE Madre',
  `NuevoInteresRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Nuevo Interes Ajustado a la CEDE Madre.',
  `InteresGeneradoOriginal` decimal(18,2) DEFAULT NULL COMMENT 'Interes Generado Original de la CEDE Madre.',
  `InteresRecibirOriginal` decimal(18,2) DEFAULT NULL COMMENT 'Interes Recibir Original de la CEDE Madre.',
  `TasaOriginal` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Original de la CEDE Madre.',
  `TasaBaseIDOriginal` int(11) DEFAULT NULL COMMENT 'Tasa Base Original de la CEDE Madre',
  `SobreTasaOriginal` decimal(12,4) DEFAULT NULL COMMENT 'Sobre Tasa original de la CEDE Madre.',
  `PisoTasaOriginal` decimal(12,4) DEFAULT NULL COMMENT 'Piso Tasa original de la CEDE Madre.',
  `TechoTasaOriginal` decimal(12,4) DEFAULT NULL COMMENT 'Techo Tasa Original de la CEDE Madre.',
  `CalculoIntOriginal` int(11) DEFAULT NULL COMMENT 'Calculo Interes Original de la CEDE Madre.',
  `ValorGatOriginal` decimal(14,2) DEFAULT NULL COMMENT 'Valor del Gat Original de la CEDE Madre antes de Anclaje Mejorado',
  `ValorGatRealOriginal` decimal(14,2) DEFAULT NULL COMMENT 'Valor del Gat Real de la CEDE Madre antes de Anclaje Mejorado',
  `TasaNetaOriginal` decimal(14,4) DEFAULT NULL COMMENT 'Tasa Neta Original de la CEDE Madre antes de Anclaje Mejorado',
  `FechaAnclaje` date DEFAULT NULL COMMENT 'Fecha en la que se realizo el anclaje',
  `UsuarioAncID` int(11) DEFAULT NULL COMMENT 'Usuario que realiza el anclaje',
  `SucursalAncID` int(11) DEFAULT NULL COMMENT 'sucursal en la cual se realizo el anclaje',
  `SaldoProvision` decimal(18,2) DEFAULT NULL COMMENT 'saldo provision o Acumulado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`CedeOriID`,`CedeAncID`),
  KEY `fk_CEDESANCLAJE_2_idx` (`CedeAncID`),
  CONSTRAINT `fk_CEDESANCLAJE_1` FOREIGN KEY (`CedeOriID`) REFERENCES `CEDES` (`CedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CEDESANCLAJE_2` FOREIGN KEY (`CedeAncID`) REFERENCES `CEDES` (`CedeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de anclaje de cedes'$$