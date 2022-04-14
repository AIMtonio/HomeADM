-- Creacion de tabla EDOCTAV2RESUMCREDITOS

DELIMITER ;

DROP TABLE IF EXISTS `EDOCTAV2RESUMCREDITOS`;

DELIMITER $$

CREATE TABLE `EDOCTAV2RESUMCREDITOS` (
  `AnioMes`           INT(11)        NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
  `SucursalID`        INT(11)        NOT NULL COMMENT 'Numero de surcusal del cliente',
  `ClienteID`         INT(11)        NOT NULL COMMENT 'Numero de cliente',
  `CreditoID`         BIGINT(12)     NOT NULL COMMENT 'Numero de Credito',
  `ProductoCreditoID` INT(11)        NOT NULL COMMENT 'ID del producto de credito',
  `Producto`          VARCHAR(50)    NOT NULL COMMENT 'Descripcion del producto de credito',
  `SaldoInsoluto`     DECIMAL(14,2)  NOT NULL COMMENT 'Cantidad que resta una vez que se descuenta cada uno de los pagos',
  `FechaProxPago`     DATE           NOT NULL COMMENT 'Fecha limite para realizar el proximo pago',
  `FechaLeyenda`      VARCHAR(50)    NOT NULL COMMENT 'Leyenda que se muestra en el campo Fecha proximo pago del reporte',
  `MontoProximoPago`  DECIMAL(12,2)  NOT NULL COMMENT 'Cantidad que se debe pagar en el proximo pago',
  `FolioProcesoID`    BIGINT(12)     NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
  `EmpresaID`         INT(11)        NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`           INT(11)        NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` 	  DATETIME       NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`       VARCHAR(15)    NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`        VARCHAR(50)    NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`          INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`    BIGINT(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioMes`,`CreditoID`),
  KEY `INDEX_EDOCTAV2RESUMCREDITOS_1` (`ClienteID`),
  KEY `INDEX_EDOCTAV2RESUMCREDITOS_2` (`CreditoID`),
  KEY `INDEX_EDOCTAV2RESUMCREDITOS_3` (`FolioProcesoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la informacion de las extracciones del resumen de creditos.'$$
