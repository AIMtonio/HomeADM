-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTANCLAJE
DELIMITER ;
DROP TABLE IF EXISTS `APORTANCLAJE`;DELIMITER $$

CREATE TABLE `APORTANCLAJE` (
  `AportAnclajeID` int(11) DEFAULT NULL COMMENT 'consecutivo',
  `AportacionOriID` int(11) NOT NULL COMMENT 'Aportacion Original PK',
  `AportacionAncID` int(11) NOT NULL COMMENT 'Aportacion Anclada PK',
  `MontoConjunto` decimal(18,2) DEFAULT NULL COMMENT 'Monto que sumariza la Aportación original con la inversion anclada.',
  `TotalRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Suma total de Capital e Intereses de APORTACIONES Madre e Hijas.',
  `NuevaTasa` decimal(18,4) DEFAULT NULL COMMENT 'Nueva tasa Neta de la Aportación',
  `NuevoInteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'Interes ajustado a la Aportación Madre',
  `NuevoInteresRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Nuevo Interes Ajustado a la Aportación Madre.',
  `InteresGeneradoOriginal` decimal(18,2) DEFAULT NULL COMMENT 'Interes Generado Original de la Aportación Madre.',
  `InteresRecibirOriginal` decimal(18,2) DEFAULT NULL COMMENT 'Interes Recibir Original de la Aportación Madre.',
  `TasaOriginal` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Original de la Aportación Madre.',
  `TasaBaseIDOriginal` int(11) DEFAULT NULL COMMENT 'Tasa Base Original de la Aportación Madre',
  `SobreTasaOriginal` decimal(12,4) DEFAULT NULL COMMENT 'Sobre Tasa original de la Aportación Madre.',
  `PisoTasaOriginal` decimal(12,4) DEFAULT NULL COMMENT 'Piso Tasa original de la Aportación Madre.',
  `TechoTasaOriginal` decimal(12,4) DEFAULT NULL COMMENT 'Techo Tasa Original de la Aportación Madre.',
  `CalculoIntOriginal` int(11) DEFAULT NULL COMMENT 'Calculo Interes Original de la Aportación Madre.',
  `ValorGatOriginal` decimal(14,2) DEFAULT NULL COMMENT 'Valor del Gat Original de la Aportación Madre antes de Anclaje Mejorado',
  `ValorGatRealOriginal` decimal(14,2) DEFAULT NULL COMMENT 'Valor del Gat Real de la Aportación Madre antes de Anclaje Mejorado',
  `TasaNetaOriginal` decimal(14,4) DEFAULT NULL COMMENT 'Tasa Neta Original de la Aportación Madre antes de Anclaje Mejorado',
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
  PRIMARY KEY (`AportacionOriID`,`AportacionAncID`),
  KEY `fk_APORTANCLAJE_2_idx` (`AportacionAncID`),
  CONSTRAINT `fk_APORTANCLAJE_1` FOREIGN KEY (`AportacionOriID`) REFERENCES `APORTACIONES` (`AportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_APORTANCLAJE_2` FOREIGN KEY (`AportacionAncID`) REFERENCES `APORTACIONES` (`AportacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Anclajes de Aportaciones.'$$