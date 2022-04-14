DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOCTAV2RESUMCREDITOS`;
DELIMITER $$

CREATE TABLE `TMPEDOCTAV2RESUMCREDITOS` (
  `AnioMes`            INT(11)    NOT NULL COMMENT 'Periodo de anio y mes de la extraccion',
  `SucursalID`         INT(11)    NOT NULL COMMENT 'Identificador de la sucursal del cliente',
  `ClienteID`          INT(11)    NOT NULL COMMENT 'Identificador del cliente',
  `CreditoID`          BIGINT(12) NOT NULL COMMENT 'Identificador del credito',
  `FechaCorte`         DATE       NOT NULL COMMENT 'Es la ultima Fecha de Corte de SALDOSCREDITOS de cada uno de los creditos',
  `MonedaID`           INT(11)    NOT NULL COMMENT 'Identificador de la moneda',
  `ProductoCreditoID`  INT(11)    NOT NULL COMMENT 'Identificador del producto de credito',
  `ValorIVAInt`        DECIMAL(14,2) NOT NULL COMMENT 'Valor del iva que se aplicara sobrea el interes',
  `Producto`           VARCHAR(50)   NOT NULL COMMENT 'Nombre del producto de credito',
  `SaldoInsoluto`      DECIMAL(14,2) NOT NULL COMMENT 'Saldo insoluto del credito',
  `FechaProxPago`      DATE          NOT NULL COMMENT 'Fecha del proximo pago del credito',
  `FechaLeyenda`       VARCHAR(25)   NOT NULL COMMENT 'Leyenda que se muestra en el campo Fecha proximo pago del reporte',
  `MontoProximoPago`   DECIMAL(12,2) NOT NULL COMMENT 'Monto del proximo pago',
  `FechTerminacion`    DATE          NOT NULL COMMENT 'Fecha de liquidacion del credito',
  `ValorIVAMora`       DECIMAL(14,2) NOT NULL COMMENT 'Valor del iva que se aplicara sobre la mora',
  `ValorIVAAccesorios` DECIMAL(14,2) NOT NULL COMMENT 'Valor del iva que se aplicara sobre los accesorios',
  PRIMARY KEY (`AnioMes`,`CreditoID`),
  KEY `INDEX_TMPEDOCTAV2RESUMCREDITOS_1` (`CreditoID`),
  KEY `INDEX_TMPEDOCTAV2RESUMCREDITOS_2` (`AnioMes`),
  KEY `INDEX_TMPEDOCTAV2RESUMCREDITOS_3` (`SucursalID`),
  KEY `INDEX_TMPEDOCTAV2RESUMCREDITOS_4` (`ClienteID`),
  KEY `INDEX_TMPEDOCTAV2RESUMCREDITOS_5` (`ProductoCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para obtener el resumen de creditos y que sirve para llenar la tabla principal EDOCTAV2RESUMCREDITOS'$$
