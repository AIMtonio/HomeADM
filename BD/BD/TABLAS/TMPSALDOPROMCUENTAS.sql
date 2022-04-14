-- Creacion de tabla TMPSALDOPROMCUENTAS

DELIMITER ;

DROP TABLE IF EXISTS TMPSALDOPROMCUENTAS;

DELIMITER $$

CREATE TABLE `TMPSALDOPROMCUENTAS` (
  `ConsecutivoID`       BIGINT(12)    	UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Numero Consecutivo',
  `CuentaAhoID` 		BIGINT(12) 		NOT NULL COMMENT 'Numero de Cuenta',
  `SaldoPromedio` 		DECIMAL(18,2) 	NOT NULL COMMENT 'Saldo Promedio de la Cuenta',
  `EmpresaID`           INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
   PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPSALDOPROMCUENTAS_1` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el Registro de Saldo Promedio de las Cuentas'$$
