DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAV2CFDIDATOS`;
DELIMITER $$

CREATE TABLE `EDOCTAV2CFDIDATOS` (
  `AnioMes`         INT(11)       NOT NULL COMMENT 'Periodo en el que se procesan los datos',
  `SucursalID`      INT(11)       NOT NULL COMMENT 'Identificador de la sucursal',
  `ClienteID`       INT(11)       NOT NULL COMMENT 'Identificador del cliente',
  `InstrumentoID`   bigint(20)    NOT NULL COMMENT 'Identificador del instrumento',
  `TipoInstrumento` CHAR(1)       NOT NULL COMMENT 'C: Credito, A: Cuenta de Ahorro',
  `Concepto`        VARCHAR(150)  NOT NULL COMMENT 'Descripcion del concepto a timbrar',
  `Monto`           DECIMAL(14,2) NOT NULL COMMENT 'Cantidad de dinero que se cargo',
  `ValorIVA`        DECIMAL(14,2) NOT NULL COMMENT 'TASA del IVA',
  `TipoConcepto`    INT NOT NULL COMMENT '1=INTERES DE CREDITO, 2=IVA INTERES DE CREDITO, 3=INTERES MORATORIO, 4=IVA INTERES MORATORIO, 5= COMISIONES, 6=IVA COMISIONES, 7=OTRAS COMISIONES, 8=IVA OTRAS COMISIONES',
  `EmpresaID`       INT(11)       NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`         INT(11)       NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime          NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`     VARCHAR(15)   NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`      VARCHAR(50)   NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`        INT(11)       NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`  bigint(20)    NOT NULL COMMENT 'Parametro de Auditoria',
  KEY `INDEX_EDOCTACFDIDATOS_1` (`ClienteID`),
  KEY `INDEX_EDOCTACFDIDATOS_2` (`InstrumentoID`),
  KEY `INDEX_EDOCTACFDIDATOS_3` (`Concepto`),
  KEY `INDEX_EDOCTACFDIDATOS_4` (`TipoConcepto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab:Tabla para almacenar informacion utilizada para timbrar la informacion del cliente'$$
