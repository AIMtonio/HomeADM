-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDHISPARALEOPINUS
DELIMITER ;
DROP TABLE IF EXISTS `PLDHISPARALEOPINUS`;
DELIMITER $$

CREATE TABLE `PLDHISPARALEOPINUS` (
  `Fecha` date NOT NULL COMMENT 'Fecha en la que se guarda en el historico',
  `FolioID` int(11) NOT NULL COMMENT 'Folio que corresponde al grupo de parametros para el sistema de Alertas PLD',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Persona F:Fisica, A:Fisica con Actividad Empresarial, y M:Moral',
  `NivelRiesgo` char(1) DEFAULT NULL COMMENT 'Nivel de Riesgo A: Alto, B:Bajo, y M: Medio',
  `FechaVigencia` date NOT NULL COMMENT 'Fecha de vigencia',
  `TipoInstruMonID` varchar(10) DEFAULT NULL COMMENT 'Tipo de instrumento, campo del catalogo de tipo de  instrumentos, no es la cve del instrumento si no la categoria de clasificacion',
  `VarPTrans` decimal(14,2) DEFAULT NULL COMMENT '% de variacion maxima positiva antes de reportar cambios en el perfil transaccional (OPI3a)',
  `VarPagos` decimal(14,2) DEFAULT NULL COMMENT '% de variacion maxima  positiva antes de reportar pagos del cliente vs cuotas exigibles (OPI3b)',
  `VarPlazo` int(11) DEFAULT NULL COMMENT 'numero de dias maximo antes de reportar pagos anticipados (OPI3c)',
  `LiquidAnticipad` char(1) DEFAULT NULL COMMENT 'Si reporta como inusuales las liquidaciones anticipadas\nS=Si\nN=No',
  `DiasMaxDeteccion` int(11) DEFAULT NULL COMMENT 'Dias Maximos para Poder reportar una Operacion Detectada a partir de la Fecha de Deteccion',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus\nV=Vigente\nB=Baja',
  `VarNumDep` decimal(14,2) DEFAULT NULL COMMENT '% de variacion maxima positiva antes de reportar cambios en el Numero de Depositos',
  `VarNumRet` decimal(14,2) DEFAULT NULL COMMENT '% de variacion maxima positiva antes de reportar cambios en el Numero de Retiros',
  `PorcDiasMax` decimal(14,2) DEFAULT '0.00' COMMENT 'Porcentaje de holgura para Dias de pago anticipado.',
  `PorcDiasLiqAnt` decimal(14,2) DEFAULT '0.00' COMMENT 'Porcentaje de Días que se tendrá permitido Liquidar un Crédito de manera Anticipada.\nEste Porcentaje es Calculado de acuerdo al Plazo del Crédito.',
  `PorcAmoAnt` decimal(14,2) DEFAULT '0.00' COMMENT 'Porcentaje de holgura para Pago Anticipado de Créditos sobre el Monto de la Cuota.',
  `PorcLiqAnt` decimal(14,2) DEFAULT '0.00' COMMENT 'Porcentaje de holgura Liquidación Anticipada de Créditos sobre el Monto Total del Crédito (Capital + Interés).\nSolo si LiquidAnticipad es S.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`FolioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parametros de  Operaciones Inusuales (Alertas automaticas)'$$