DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAGATPORPRODAHO`;
DELIMITER $$

CREATE TABLE `EDOCTAGATPORPRODAHO` (
  `TipoCuentaID`    int(11)         NOT NULL    COMMENT 'Numero de Tipo de Cuentas',
  `GatReal`         decimal(14,2)   NOT NULL    COMMENT 'Ganancia Anual Total Real - compo llenado manualmente por el cliente para utilizarce en el apartado de detalle de Saldo y Movimientos del Periodo en el PRPT',
  `EmpresaID`       INT(11)         NOT NULL    COMMENT 'Parametro de auditoria',
  `Usuario`         INT(11)         NOT NULL    COMMENT 'Parametro de auditoria',
  `FechaActual`     DATE            NOT NULL    COMMENT 'Parametro de auditoria',
  `DireccionIP`     VARCHAR(15)     NOT NULL    COMMENT 'Parametro de auditoria',
  `ProgramaID`      VARCHAR(50)     NOT NULL    COMMENT 'Parametro de auditoria',
  `Sucursal`        INT(11)         NOT NULL    COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20)       NOT NULL    COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`TipoCuentaID` )
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT = 'Tab: Relacion de productos de ahorro con el GatReal a mostrar en los PDFs de estado de cuenta'$$