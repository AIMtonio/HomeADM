-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPINVCASTIGOCRW
DELIMITER ;
DROP TABLE IF EXISTS `TMPINVCASTIGOCRW`;
DELIMITER $$

CREATE TABLE `TMPINVCASTIGOCRW`(
  `TmpID`                     BIGINT(20)        NOT NULL COMMENT 'Numero consecutivo.',
  `FondeoID`                  BIGINT(20)        NOT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `ClienteID`                 INT(11)           NOT NULL COMMENT 'Numero o ID del Cliente',
  `CuentaAhoID`               BIGINT(12)        NOT NULL COMMENT 'Cuenta de \nAhorro del \nCliente o \nInversionista',
  `AmortizacionID`            INT(11)           NOT NULL COMMENT 'Id de la Amortizacion o Calendario',
  `PorcentajeCapital`         DECIMAL(9,6)      NOT NULL COMMENT 'Porcentaje de Capital Respecto a la parte activa (AMORTICREDITO)',
  `PorcentajeInteres`         DECIMAL(9,6)      NOT NULL COMMENT 'Porcentaje Interés Respecto al Interés En la Parte Activa',
  `PorcentajeComisi`          DECIMAL(8,4)      NOT NULL COMMENT 'Porcentaje de Participacion en Comisiones',
  `PorcentajeFondeo`          DECIMAL(10,6)     NOT NULL COMMENT 'Porcentaje del Fondeo',
  `SaldoCapVigente`           DECIMAL(12,2)     NOT NULL COMMENT 'Saldo\nde Capital\nVigente',
  `SaldoCapExigible`          DECIMAL(12,2)     NOT NULL COMMENT 'Saldo\nde Capital\nExigible o\nen Atraso',
  `SaldoCapCtaOrden`          DECIMAL(14,4)     NOT NULL COMMENT 'Capital que se encuentra en las cuentas de orden(capital que se uso para aplicar la garantia del credito)',
  `SaldoInteres`              DECIMAL(14,4)     NOT NULL COMMENT 'Saldo\nde Interes',
  `SaldoIntCtaOrden`          DECIMAL(14,4)     NOT NULL COMMENT 'interes que se encuentra en cuentas de Orden(interes que se uso para aplicar la garantia al credito)',
  `SaldoIntMoratorio`         DECIMAL(14,4)     NOT NULL COMMENT 'Saldo de Interes Moratorio calculado en el cierre',
  `ProvisionAcum`             DECIMAL(14,4)     NOT NULL COMMENT 'Provision\nAcumulada ',
  `RetencionIntAcum`          DECIMAL(14,4)     NOT NULL COMMENT 'Monto\nde la Retencion\nde Interes\nAcumulada\nDiaria',
  `NumRetirosMes`             INT(11)           NOT NULL COMMENT 'Numero de \nRetiros en el\nMes',
  `SucursalOrigen`            INT(5)            NOT NULL COMMENT 'No de Sucursal a la que pertenece el cliente, Llave Foranea Hacia Tabla SUCURSALES\n',
  `PagaISR`                   CHAR(1)           NOT NULL COMMENT 'Paga ISR en Inversiones\nEspecifica si el cliente paga o no ISR por los \nIntereses de Inversión\n  ''S''.- Si Paga\n ''N''.- No Paga',
  `MonedaID`                  INT(11)           NOT NULL COMMENT 'Moneda',
  `EmpresaID`                 INT(11)           NOT NULL COMMENT 'Parametro Auditoria',
  `Usuario`                   INT(11)           NOT NULL COMMENT 'Parametro Auditoria',
  `FechaActual`               DATE              NOT NULL COMMENT 'Parametro Auditoria',
  `DireccionIP`               VARCHAR(15)       NOT NULL COMMENT 'Parametro Auditoria',
  `ProgramaID`                VARCHAR(50)       NOT NULL COMMENT 'Parametro Auditoria',
  `Sucursal`                  INT(11)           NOT NULL COMMENT 'Parametro Auditoria',
  `NumTransaccion`            BIGINT(20)        NOT NULL COMMENT 'Parametro Auditoria',
  PRIMARY KEY (`FondeoID`),
  KEY `INDEX_TMPINVCASTIGOCRW_1` (`NumTransaccion`),
  KEY `INDEX_TMPINVCASTIGOCRW_2` (`TmpID`,`NumTransaccion`),
  KEY `INDEX_TMPINVCASTIGOCRW_3` (`FondeoID`,`TmpID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal usada en el sp CRWINVCASTIGOPRO.'$$