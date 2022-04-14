DELIMITER ;
DROP TABLE IF EXISTS `TMPCRECASTIGO`;

DELIMITER $$
CREATE TABLE `TMPCRECASTIGO` (
    `TMPCRECASTIGOID` BIGINT(12) UNSIGNED  NOT NULL    AUTO_INCREMENT  COMMENT 'Identificador de la Tabla TMPCRECACASTIGO',

    `CreditoID`         BIGINT(12)         NOT NULL  COMMENT 'Credito a Castigar',

    `AmortizacionID`    INT(11)         NOT NULL  COMMENT 'Amortizacion del Credito',
    `MontoPago`         DECIMAL(14,2)   NOT NULL  COMMENT 'Monto pago del Credito',
    `FechaPago`         DATE            NOT NULL  COMMENT 'Fechas pago del Credito',
    `Exigible`          DECIMAL(14,2)   NOT NULL  COMMENT 'Exigible',
    `FecUltPagCompleto` DATE            NOT NULL  COMMENT 'Fecha Ultimo de Pago',
    `TransaccionID`     BIGINT(20)      NOT NULL  COMMENT 'Transaccion de credito',

    `EmpresaID`         VARCHAR(50)     NOT NULL  COMMENT 'Parametro de auditoria',
    `Usuario`           INT(11)         NOT NULL  COMMENT 'Parametro de auditoria',
    `FechaActual`       DATETIME        NOT NULL  COMMENT 'Parametro de auditoria',
    `DireccionIP`       VARCHAR(15)     NOT NULL  COMMENT 'Parametro de auditoria',
    `ProgramaID`        VARCHAR(50)     NOT NULL  COMMENT 'Parametro de auditoria',
    `Sucursal`          INT(11)         NOT NULL  COMMENT 'Parametro de auditoria',
    `NumTransaccion`    BIGINT(20)      NOT NULL  COMMENT 'Parametro de auditoria',

    PRIMARY KEY (`TMPCRECASTIGOID` ),
    INDEX `INDEX_TMPCRECASTIGO_1` (`CreditoID`, `NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tmp: Tabla temporal para los castigos'$$
