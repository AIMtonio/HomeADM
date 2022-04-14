-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICRWFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `AMORTICRWFONDEO`;

DELIMITER $$
CREATE TABLE `AMORTICRWFONDEO` (
  `SolFondeoID` bigint(20) NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `AmortizacionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Id de la Amortizacion o Calendario',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha de Exigibilidad de la Amortizacion, por si la de',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Capital',
  `InteresGenerado` decimal(14,2) DEFAULT NULL COMMENT 'Interes Generado o Calculado',
  `InteresRetener` decimal(14,2) DEFAULT NULL COMMENT 'Interes o ISR a Retener',
  `PorcentajeInteres` decimal(9,6) DEFAULT NULL COMMENT 'Porcentaje Interés Respecto al Interés En la Parte Activa',
  `PorcentajeCapital` decimal(9,6) DEFAULT NULL COMMENT 'Porcentaje de Capital Respecto a la parte activa (AMORTICREDITO)',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Amortizacion\nN .- Vigente o en Proceso\nP .- Pagada\nA .- Atrasado',
  `SaldoCapVigente` decimal(12,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nVigente',
  `SaldoCapExigible` decimal(12,2) DEFAULT NULL COMMENT 'Saldo\nde Capital\nExigible o\nen Atraso',
  `SaldoInteres` decimal(14,4) DEFAULT NULL COMMENT 'Saldo\nde Interes',
  `SaldoIntMoratorio` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio calculado en el cierre',
  `SaldoCapCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'Capital que se encuentra en las cuentas de orden(capital que se uso para aplicar la garantia del credito)',
  `SaldoIntCtaOrden` decimal(14,4) DEFAULT NULL COMMENT 'interes que se encuentra en cuentas de Orden(interes que se uso para aplicar la garantia al credito)',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada ',
  `RetencionIntAcum` decimal(14,4) DEFAULT NULL COMMENT 'Monto\nde la Retencion\nde Interes\nAcumulada\nDiaria',
  `MoratorioPagado` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de \nMoratorios\nPagados al\nInversionista',
  `ComFalPagPagada` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de \nComision por Falta de Pago\nPagados al\nInversionista',
  `IntOrdRetenido` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de \nInteres Ordinario\nRetenido\nal Inversionista',
  `IntMorRetenido` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de \nInteres Moratorio\nRetenido\nal Inversionista',
  `ComFalPagRetenido` decimal(12,2) DEFAULT NULL COMMENT 'Acumulado de \nComisio Falta Pago\nRetenido\nal Inversionista',
  `FechaLiquida` date DEFAULT NULL COMMENT 'Fecha real en la que se termina de pagar la amortizacion\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`SolFondeoID`,`AmortizacionID`),
  KEY `INDEX_AMORTICRWFONDEO_1` (`FechaExigible`,`Estatus`),
  KEY `INDEX_AMORTICRWFONDEO_2` (`Estatus`),
  KEY `INDEX_AMORTICRWFONDEO_3` (`SolFondeoID`,`FechaVencimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Calendario de Pagos o Amortizaciones de Crowdfunding.'
PARTITION BY RANGE (SolFondeoID)
(PARTITION part0 VALUES LESS THAN (300000) ENGINE = InnoDB,
 PARTITION part1 VALUES LESS THAN (600000) ENGINE = InnoDB,
 PARTITION part2 VALUES LESS THAN (900000) ENGINE = InnoDB,
 PARTITION part3 VALUES LESS THAN (1200000) ENGINE = InnoDB,
 PARTITION part4 VALUES LESS THAN (1500000) ENGINE = InnoDB,
 PARTITION part5 VALUES LESS THAN (1800000) ENGINE = InnoDB,
 PARTITION part6 VALUES LESS THAN (2100000) ENGINE = InnoDB,
 PARTITION part7 VALUES LESS THAN (2400000) ENGINE = InnoDB,
 PARTITION part8 VALUES LESS THAN (2700000) ENGINE = InnoDB,
 PARTITION part9 VALUES LESS THAN (3000000) ENGINE = InnoDB,
 PARTITION part10 VALUES LESS THAN (3300000) ENGINE = InnoDB,
 PARTITION part11 VALUES LESS THAN (3600000) ENGINE = InnoDB,
 PARTITION part12 VALUES LESS THAN (3900000) ENGINE = InnoDB,
 PARTITION part13 VALUES LESS THAN (4100000) ENGINE = InnoDB,
 PARTITION part14 VALUES LESS THAN (4400000) ENGINE = InnoDB,
 PARTITION part15 VALUES LESS THAN (4700000) ENGINE = InnoDB,
 PARTITION part16 VALUES LESS THAN (5000000) ENGINE = InnoDB,
 PARTITION part17 VALUES LESS THAN (5300000) ENGINE = InnoDB,
 PARTITION part18 VALUES LESS THAN (5600000) ENGINE = InnoDB,
 PARTITION part19 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) $$