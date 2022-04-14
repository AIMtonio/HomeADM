-- TARLAYDEBSAFI
DELIMITER ;
DROP TABLE IF EXISTS `TARLAYDEBSAFI`;
DELIMITER $$

CREATE TABLE `TARLAYDEBSAFI` (
  `TarLayDebSAFIID`   BIGINT(12)    NOT NULL COMMENT 'ID del lote de tarjetas generadas',
  `LoteDebSAFIID`     INT(11)       NOT NULL COMMENT 'ID lote de la tabla LOTETARJETADEBSAFI',
  `LayoutTarDeb`      VARCHAR(500)  NOT NULL COMMENT 'Cadena layout',
  `FechaRegistro`     DATETIME      NOT NULL COMMENT 'Fecha de Registro de la Tarjeta',
  `EsGenerado`        CHAR(1)       NOT NULL COMMENT 'Indica si ya se genero el layout N-No Generado, S-Generado',
  `NumTarjeta`        CHAR(16)      NOT NULL COMMENT 'Numero de la tarjeta',
  `CVV`               CHAR(4)       NOT NULL COMMENT 'Campo ICVV emitido por HSM',
  `ICVV`              CHAR(4)       NOT NULL COMMENT 'Campo ICVV emitido por HSM',
  `CVV2`              CHAR(8)       NOT NULL COMMENT 'Campo CVV-2 emitido por HSM',
  `FechaVencimiento`  CHAR(5)       NOT NULL COMMENT 'Fecha de vencimiento de la tarjeta',
  `NIP`               VARCHAR(256)  NOT NULL COMMENT 'NIP de la Tarjeta',
  `EmpresaID`         INT(11)       NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario`           INT(11)       NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual`       DATETIME      NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP`       VARCHAR(15)   NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID`        VARCHAR(50)   NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal`          INT(11)       NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion`    BIGINT(20)    NOT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TarLayDebSAFIID`),
  CONSTRAINT `fk_TARLAYDEBSAFI_1` FOREIGN KEY (`LoteDebSAFIID`) REFERENCES `LOTETARJETADEBSAFI` (`LoteDebSAFIID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Registra la información que se va utilizar para generar el layout'$$