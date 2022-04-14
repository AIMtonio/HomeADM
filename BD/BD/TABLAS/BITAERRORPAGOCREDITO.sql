-- BITAERRORPAGOCREDITO

DELIMITER ;

DROP TABLE IF EXISTS `BITAERRORPAGOCREDITO`;

DELIMITER $$

CREATE TABLE `BITAERRORPAGOCREDITO` (
  `AutBitacoraID`   BIGINT(12)      UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la bitacora',
  `Procedimiento`   VARCHAR(50)     NOT NULL COMMENT 'Nombre del Procedimiento',
  `NumErr`          INT(11)         NOT NULL COMMENT 'Numero de Error',
  `ErrMen`          VARCHAR(400)    NOT NULL COMMENT 'Mensaje de Error',
  `CreditoID`       BIGINT(12)      NOT NULL COMMENT 'Numero de Credito',
  `FechaSistema`    DATE            NOT NULL COMMENT 'Fecha de Sistema',
  `Monto`           DECIMAL(18,2)   NOT NULL COMMENT 'Monto Pago',
  `EmpresaID`       INT(11)         NOT NULL COMMENT 'Parametro de Auditoria ID de la Empresa',
  `Usuario`         INT(11)         NOT NULL COMMENT 'Parametro de Auditoria ID del Usuario',
  `FechaActual`     DATETIME        NOT NULL COMMENT 'Parametro de Auditoria Fecha Actual',
  `DireccionIP`     VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria Direccion IP ',
  `ProgramaID`      VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria Programa ',
  `Sucursal`        INT(11)         NOT NULL COMMENT 'Parametro de Auditoria ID de la Sucursal',
  `NumTransaccion`  BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria Numero de la Transaccion',
  PRIMARY KEY (`AutBitacoraID`),
  INDEX `INDEX_BITAERRORPAGOCREDITO_1` (`CreditoID`),
  INDEX `INDEX_BITAERRORPAGOCREDITO_2` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Bitacora de error al realizar pago de credito'$$
