DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2GRAFICA;
DELIMITER $$

CREATE TABLE `EDOCTAV2GRAFICA` (
  `EdoCtaV2GraficaID`     BIGINT(20)    NOT NULL AUTO_INCREMENT COMMENT 'Numero consecutivo de la tabla',
  `AnioMes`               INT(11)       NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
  `ClienteID`             INT(11)       NOT NULL COMMENT 'Numero de cliente',
  `CuentaAhoID`           BIGINT(12)    NOT NULL COMMENT 'ID de la cuenta de Ahorro',
  `Descripcion`           VARCHAR(100)  NOT NULL COMMENT 'Descripcion del movimiento',
  `Monto`                 DECIMAL(18,2) NOT NULL COMMENT 'Monto a mostrar',
  `Orden`                 INT(11)       NOT NULL COMMENT 'Orden de presentancion en los registros',
  PRIMARY KEY (`EdoCtaV2GraficaID`),
  KEY `IDX_EDOCTAV2GRAFICA_01` (ClienteID),
  KEY `IDX_EDOCTAV2GRAFICA_02` (CuentaAhoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT 'Tab: Tabla que se usara para mostrar graficas en el PDF del estado de cuenta'$$
