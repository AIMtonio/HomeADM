DELIMITER ;
DROP TABLE IF EXISTS CREDITOSSINDIFERIR;

DELIMITER ;
CREATE TABLE `CREDITOSSINDIFERIR` (
  `TransaccionID` BIGINT(20) NOT NULL COMMENT 'Numero de transaccion con la que se ejecuto el proceso para identificar todos los creditos que no pasaron al menos una de las validaciones para poder Diferir.',
  `FechaAplicacion` DATE NOT NULL COMMENT 'Fecha en la que se ejecuto el proceso de Diferimiento.',
  `CreditoID` BIGINT(12) NOT NULL COMMENT 'Numero de ID de Credito en SAFI que se quiere Diferir',
  `MesesDiferidos` TINYINT(4) DEFAULT NULL COMMENT 'Cantidad Numerica de Meses que intentaron diferir.',
  `TipoDiferimiento` CHAR(1) DEFAULT NULL COMMENT 'Indica que tipo de proceso se aplico al diferir \n C = Diferimiento completo, es decir, mueve todas las cuotas incluyendo fecha de inicio y vencimiento de todas las cuotas que su fecha d vencimiento es despues del 28 de Feb. incluye cuotas que tengan estatus atrasado.\nU = Diferimiento en la que se mueve a partir de la cuota en transito, mueve la fecha de vencimiento de la cuota en transito y las fechas de inicio y vencimiento de las cuotas que todavia no inician. quedando la cuota en transito como una cuota muy grande sin recalcular el interes de manera que se respeta el interes pactado original."',
  `MotivoRechazo` VARCHAR(400) DEFAULT NULL COMMENT 'Motivo de rechazo para el Diferimiento.',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria con Numero de Empresa ID',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria con ID del usuario de SAFI que genero la transaccion',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria con Fecha  y hora Real de la transaccion',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria con la direccion IP del equipo que generó la transacción',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria con el nombre del Programa o proceso que genera la transacción',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria con el Numero de Sucursal del usuario que genero la transacción',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria con el Numero de transacción generado',
  PRIMARY KEY (`TransaccionID`,`FechaAplicacion`,`CreditoID`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1 COMMENT='Guarda el registro de los creditos con error';
