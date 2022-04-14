-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONDICIONESVENCIMAPORT
DELIMITER ;
DROP TABLE IF EXISTS `CONDICIONESVENCIMAPORT`;
DELIMITER $$

CREATE TABLE `CONDICIONESVENCIMAPORT` (
  `AportacionID` int(11) NOT NULL COMMENT 'ID de la aportacion, hace referencia a la tabla (APORTACIONES)',
  `ReinversionAutomatica` char(1) DEFAULT NULL COMMENT 'Indica Si/No reinvierte automaticamente\nS) Si\nN) No',
  `TipoReinversion` char(3) DEFAULT NULL COMMENT 'Indica el tipo de reinversion\nC) Capital\nCI) Capital mas interes\nN) Ninguna',
  `OpcionAportID` int(11) DEFAULT NULL COMMENT 'ID del Tipo de Aportacion, hace referencia a la tabla APORTACIONOPCIONES',
  `Cantidad` decimal(12,2) DEFAULT NULL COMMENT 'Indica cuando + o cuanto - se esta renovando (esto si el TipoAportacion es Renovacion con + o - )',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Indica el monto de la aportacion original',
  `MontoRenovacion` decimal(18,2) DEFAULT NULL COMMENT 'Indica la diferencia entre la renovacion + o - con el campo Monto',
  `MontoGlobal` decimal(18,2) DEFAULT NULL COMMENT 'Indica el Monto mas el capital de las inversiones vigentes del grupo familiar',
  `TipoPago` char(1) DEFAULT NULL COMMENT 'Indica Tipo de Pago\nV) Vencimiento\nE) Programado\n',
  `DiaPago` int(11) DEFAULT NULL COMMENT 'Indica el dia de Pago si se selecciono Tipo de pago Programado',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Plazo real en días que hay entre la fecha de Inicio y la fecha de Vencimiento.',
  `PlazoOriginal` int(11) DEFAULT NULL COMMENT 'Plazo en días capturado por el usuario desde pantalla.',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la aportacion',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la aportacion',
  `TasaBruta` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Bruta de la aportacion',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'Tasa ISR de la aportacion',
  `TasaNeta` decimal(12,4) DEFAULT NULL COMMENT 'Tasa Neta de la aportacion',
  `CapitalizaInteres` char(1) DEFAULT NULL COMMENT 'Indica Si/No capitaliza Interes\nS) Si\nN) No',
  `GatNominal` decimal(12,2) DEFAULT NULL COMMENT 'GAT nominal de la aportacion',
  `InteresGenerado` decimal(12,2) DEFAULT NULL COMMENT 'Interes generado de la aportacion',
  `ISRRetener` decimal(12,4) DEFAULT NULL COMMENT 'ISR a retener de la aaportacion',
  `InteresRecibir` decimal(12,2) DEFAULT NULL COMMENT 'Interes Recibir de la aportacion',
  `TotalRecibir` decimal(18,2) DEFAULT NULL COMMENT 'Monto total a recibir',
  `Notas` varchar(500) DEFAULT NULL COMMENT 'Notas ',
  `Especificaciones` varchar(700) DEFAULT NULL COMMENT 'Especificaciones especiales',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Indica el Estatus de las condiciones de vencimiento de la Aportacion\nP) Pendiente\nA) Autorizada\nR) Por Autorizar \n',
  `Reinversion` char(1) DEFAULT NULL COMMENT 'Indica si realiza reinversion automatica de las condiciones de la Nueva aportacion\nP) Posteriormente\nS) Si\nN) No',
  `GatReal` decimal(12,2) DEFAULT NULL COMMENT 'Indica el valor del GAT real',
  `EstatusRenovacion` char(1) DEFAULT 'P' COMMENT 'Estatus de la renovacion\nR) Renovada\nN) No Renovada\nP) Pendiente',
  `NuevaAportID` int(11) DEFAULT '0' COMMENT 'ID de la Aportación Renovada.',
  `MotivoRenovacion` varchar(500) DEFAULT '' COMMENT 'Motivo por el cual No se Renovó la Aportación.',
  `ConsolidarSaldos` char(1) DEFAULT 'N' COMMENT 'Indica si Consolida Aportaciones Vigentes que venzan\nel mismo día que la Aportación a Consolidar.\nAplica para Tipo de Reinversión con Más.\nS: SI\nN: No (default)',
  `Condiciones` varchar(700) DEFAULT '' COMMENT 'Indica las condiciones de la aportacion.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AportacionID`),
  KEY `INDEX_CONDICIONESVENCIMAPORT_1` (`ReinversionAutomatica`,`Estatus`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Condiciones de Vencimiento o Reinversión de Aportaciones.'$$