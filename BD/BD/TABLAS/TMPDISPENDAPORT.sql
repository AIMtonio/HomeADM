
-- TMPDISPENDAPORT --

DELIMITER  ;
DROP TABLE IF EXISTS `TMPDISPENDAPORT`;

DELIMITER  $$
CREATE TABLE `TMPDISPENDAPORT` (
  `ConsecutivoID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID consecutivo de los registros',
  `AportacionID` int(11) NOT NULL COMMENT 'ID de la Aportacion',
  `AmortizacionID` int(11) NOT NULL COMMENT 'ID de la amortizacion',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del cliente',
  `CuentaAhoID` bigint(20) DEFAULT NULL COMMENT 'Numero de cuenta',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Capital de la aportacion',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes de la aportacion',
  `IntRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a retener de la aportacion',
  `Total` decimal(18,2) DEFAULT NULL COMMENT 'Total de la aportacion',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Nueva Fecha de Vencimiento para la Aportación Renovada',
  `TipoPagoInt` char(1) DEFAULT NULL COMMENT 'Indica la forma de pago de interes.\nV - Vencimiento\nF - Fin del Mes\nP - Por Periodo.\nE - Programado.',
  `PagoIntCapitaliza` char(1) DEFAULT 'I' COMMENT 'Indica si capitaliza interes S:Si, N:No, I:Indistinto',
  `OpcionAport` int(11) DEFAULT '1' COMMENT 'Opcion de la aportacion referencia a la tabla APORTACIONOPCIONES',
  `Reinversion` char(1) DEFAULT 'N' COMMENT 'N: No Reinvierte \n S: Reinversion automatica \n F:Posterior',
  `Reinvertir` char(2) DEFAULT 'C' COMMENT 'C: Capital \n CI:Capital mas intereses\n E:Especificacion Posterior',
  `CantidadReno` decimal(14,2) DEFAULT '0.00' COMMENT 'Cantidad para aportaciones que tienen renovacion con mas o con menos',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ConsecutivoID`,`AportacionID`,`AmortizacionID`),
  KEY `INDEX_TMPDISPENDAPORT_1` (`ConsecutivoID`),
  KEY `INDEX_TMPDISPENDAPORT_2` (`AportacionID`),
  KEY `INDEX_TMPDISPENDAPORT_3` (`AmortizacionID`),
  KEY `INDEX_TMPDISPENDAPORT_4` (`NumTransaccion`),
  KEY `INDEX_TMPDISPENDAPORT_5` (`ConsecutivoID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla para dispersiones de aportaciones.'$$