DELIMITER ;
DROP TABLE IF EXISTS TMP_CREDITOSDIFERIDX;

DELIMITER ;
CREATE TABLE `TMP_CREDITOSDIFERIDX` (
  `Consecutivo` INT(11) NOT NULL COMMENT 'Número consecutivo para el ciclo',
  `CreditoID` BIGINT(12) NOT NULL COMMENT 'Número de crédito que será diferido',
  `NumRepetido` INT(11) NOT NULL COMMENT 'Número de amortizaciones que estan dentro del rango de diferimiento',
  `MotivoError` VARCHAR(400) NOT NULL COMMENT 'Motivo del Error por el que no se va a diferir',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria con Numero de Empresa ID',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria con ID del usuario de SAFI que genero la transaccion',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria con Fecha  y hora Real de la transaccion',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria con la direccion IP del equipo que generó la transacción',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria con el nombre del Programa o proceso que genera la transacción',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria con el Numero de Sucursal del usuario que genero la transacción',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria con el Numero de transacción generado',
  PRIMARY KEY (`Consecutivo`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1 COMMENT='TMP: Tabla que almacena temporalmente el consecutivo de Credito a Diferir';
