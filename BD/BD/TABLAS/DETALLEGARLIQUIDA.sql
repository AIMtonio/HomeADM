-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEGARLIQUIDA
DELIMITER ;
DROP TABLE IF EXISTS `DETALLEGARLIQUIDA`;DELIMITER $$

CREATE TABLE `DETALLEGARLIQUIDA` (
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Numero de Solicitud de Credito',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'Indica el numero de producto de credito',
  `RequiereGarantia` char(1) DEFAULT '' COMMENT 'Especifica si el Tipo de Credito Requiere Garantias\nS .- Si Requiere\nN .- No Requiere',
  `Bonificacion` char(1) DEFAULT '' COMMENT 'Especifica si se tendran bonificaciones por pagos puntuales del credito(Garantia FOGA)\nS .- Si\nN .- No',
  `PorcBonificacion` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Indica el porcentaje de bonificacion de garantia liquida',
  `DesbloqAut` char(1) DEFAULT '' COMMENT 'Especifica si se pueden realizar desbloqueos automaticos de la garantia FOGA al ejecutar la cobranza automatica\nS .- Si\nN .- No',
  `RequiereGarFOGAFI` char(1) DEFAULT '' COMMENT 'Especifica si el Tipo de Credito Requiere Garantia FOGAFI(Garantia Liquida Financiada)\nS .- Si Requiere\nN .- No Requiere',
  `PorcGarFOGAFI` decimal(12,2) DEFAULT '0.00' COMMENT 'Especifica el porcentaje de garantia FOGAFI solicitado.',
  `ModalidadFOGAFI` char(1) DEFAULT '' COMMENT 'Indica la modalidad de cobro de la garantia FOGAFI',
  `BonificacionFOGAFI` char(1) DEFAULT '' COMMENT 'Especifica si se tendran bonificaciones por pagos puntuales del credito(Garantia FOGAFI)\nS .- Si\nN .- No',
  `PorcBonificacionFOGAFI` decimal(12,2) DEFAULT '0.00' COMMENT 'Indica el porcentaje de bonificacion de garantia FOGAFI',
  `DesbloqAutFOGAFI` char(1) DEFAULT '' COMMENT 'Especifica si se pueden realizar desbloqueos automaticos de la garantia FOGAFI al ejecutar la cobranza automatica\nS .- Si\nN .- No',
  `LiberaGarLiq` char(1) DEFAULT '' COMMENT 'Indica si se libera la garantia liquida al liquidar el credito',
  `MontoGarLiq` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto a Cobrar de Garantia Liquida(FOGA)',
  `MontoGarFOGAFI` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto a Cobrar de Garantia Liquida(FOGAFI)',
  `FechaLiquidaGar` datetime DEFAULT '1900-01-01 00:00:00' COMMENT 'Fecha en que se liquida la garantia(FOGA)',
  `FechaLiquidaFOGAFI` datetime DEFAULT '1900-01-01 00:00:00' COMMENT 'Fecha en que se liquida la garantia(FOGAFI)',
  `MontoBloqueadoGar` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Bloquedo de Garantia Liquida(FOGA)',
  `MontoBloqueadoFOGAFI` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Bloqueado de Garantia FOGAFI',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoID`,`SolicitudCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Control de saldos y detalle de garantia liquida'$$