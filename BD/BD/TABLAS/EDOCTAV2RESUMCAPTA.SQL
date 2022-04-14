DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2RESUMCAPTA;
DELIMITER $$

CREATE TABLE `EDOCTAV2RESUMCAPTA` (
  `AnioMes`          INT(11)        COMMENT 'Anio y mes para generar Estado de cuenta',
  `SucursalID`       INT(11)        DEFAULT NULL COMMENT 'Numero de surcusal dnode se dio de alta el Instrumento',
  `ClienteID`        INT(11)        COMMENT 'Numero ID del cliente',
  `InstrumentoID`    BIGINT(20)     COMMENT 'Es el ID del instrumento que puede ser Ahorro, Inversion o Cede',
  `MonedaID`         INT(11)        DEFAULT NULL COMMENT 'Identificador de la moneda',
  `MonedaDescri`     VARCHAR(45)    DEFAULT NULL COMMENT 'Descripcion de la moneda',
  `Etiqueta`         VARCHAR(60)    DEFAULT NULL COMMENT 'Proviene de tipos TIPOSCUENTAS',
  `SaldoPromedio`    DECIMAL(14,2)  DEFAULT NULL COMMENT 'se tomará del campo SaldoProm de la tabla HIS-CUENTASAHO del mes sobre el cual se hace la extracción.',
  `SaldoAnterior`    DECIMAL(14,2)  DEFAULT NULL COMMENT 'Saldo Inicial del Mes que es lo mismo a el que finalizo el mes anterior',
  `SaldoActual`      DECIMAL(14,2)  DEFAULT NULL COMMENT 'Saldo que tiene actualmente',
  `TipoInstrumento`  CHAR(2)        DEFAULT NULL COMMENT 'IN - Inversion , CA - CuentaAhorro, CE - CEDE',
  `FolioProceso`     BIGINT(12)     DEFAULT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
  `EmpresaID`        INT(11)        DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`          INT(11)        DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`      DATETIME       DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`      VARCHAR(15)    DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`       VARCHAR(50)    DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`         INT(11)        DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`   BIGINT(20)     DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioMes`,`ClienteID`, `InstrumentoID`),
  KEY `IDX_EDOCTAV2RESUMCAPTA_01` (`ClienteID`),
  KEY `IDX_EDOCTAV2RESUMCAPTA_02` (`InstrumentoID`),
  KEY `IDX_EDOCTAV2RESUMCAPTA_03` (`TipoInstrumento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para los Datos de resumen captacion de estado de cuenta'$$
