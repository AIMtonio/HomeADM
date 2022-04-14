-- BITPAGOCONCILIADO
DELIMITER ;
DROP TABLE IF EXISTS `BITPAGOCONCILIADO`;
DELIMITER $$

CREATE TABLE `BITPAGOCONCILIADO` (
	`RegistroID` bigint UNSIGNED AUTO_INCREMENT,
	`CreditoID`             BIGINT(12)         NOT NULL       COMMENT 'Numero del Credito',
	`NumTransaccionBit`     BIGINT(20)         NOT NULL       COMMENT 'Numero de transaccion de la bitacora',
	`Monto`                 DECIMAL(12,2)      NOT NULL       COMMENT 'Monto cobrado',
	`FechaHoraOper`         DATETIME           NOT NULL       COMMENT 'Fecha y hora de la operacion',
	`ClaveProm`             VARCHAR(45)        NOT NULL       COMMENT 'Numero del promotor',
	`ClienteID`             INT(11)            NOT NULL       COMMENT 'Numero de cliente',
	`DispositivoID`         VARCHAR(32)        NOT NULL       COMMENT 'Identificador del dispositivo',
	`CuentaAhoID`           BIGINT(12)         NOT NULL       COMMENT 'Numero de cuenta de ahorro',
	`FechaConciliado`       DATETIME           NOT NULL       COMMENT 'Fecha que se realiza la conciliacion',
	`UsuarioConcil`         INT(11)            NOT NULL       COMMENT 'Usuario que realiza la conciliacion',
	`EmpresaID`             INT(11)            NOT NULL       COMMENT 'Parametro de auditoria',
	`Usuario`               INT(11)            NOT NULL       COMMENT 'Parametro de auditoria',
	`FechaActual`           DATETIME           NOT NULL       COMMENT 'Parametro de auditoria',
	`DireccionIP`           VARCHAR(15)        NOT NULL       COMMENT 'Parametro de auditoria',
	`ProgramaID`            VARCHAR(50)        NOT NULL       COMMENT 'Parametro de auditoria',
	`Sucursal`              INT(11)            NOT NULL       COMMENT 'Parametro de auditoria',
	`NumTransaccion`        BIGINT(20)         NOT NULL       COMMENT 'Parametro de auditoria',
	PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Guarda la bitacora de pagos de la App Movil'$$
