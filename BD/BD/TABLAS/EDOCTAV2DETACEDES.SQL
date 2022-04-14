DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2DETACEDES;
DELIMITER $$

CREATE TABLE `EDOCTAV2DETACEDES` (
  `EdoCtaV2DetaCedesID`     BIGINT(20)    NOT NULL AUTO_INCREMENT COMMENT 'Numero consecutivo',
  `AnioMes`                 INT(11)       NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
  `CedeID`                  INT(11)       NOT NULL COMMENT 'Numero de cliente',
  `Fecha`                   DATE          NOT NULL COMMENT 'Fecha de la CEDE',
  `Concepto`                VARCHAR(250)  NOT NULL COMMENT 'Concepto',
  `Depositos`               DECIMAL(18,2) NOT NULL COMMENT 'Total de depositos',
  `Retiros`                 DECIMAL(18,2) NOT NULL COMMENT 'Total de retiros',
  `Orden`                   INT(11)       NOT NULL COMMENT 'Orden en el que se mostrara el detalle, el saldo inicial es 0',
  `Transaccion`             BIGINT(20)    NOT NULL COMMENT 'Numero de transaccion del movimiento, en movimentos agrupados se ontiene el Max',
  `FolioProcesoID`          BIGINT(20)    NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
  `EmpresaID`               INT(11)       NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`                 INT(11)       NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`             DATEtime      NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`             VARCHAR(15)   NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`              VARCHAR(50)   NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`                INT(11)       NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`          BIGINT(20)    NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`EdoCtaV2DetaCedesID`),
  KEY `IDX_EDOCTAV2DETACEDES_01`(CedeID),
  KEY `IDX_EDOCTAV2DETACEDES_02`(CedeID, Fecha, Orden),
  KEY `IDX_EDOCTAV2DETACEDES_03`(FolioProcesoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detlle de Movimientos de las cedes del estado de cuenta'$$
