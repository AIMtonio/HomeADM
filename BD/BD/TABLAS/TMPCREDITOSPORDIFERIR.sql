DELIMITER ;
DROP TABLE IF EXISTS TMPCREDITOSPORDIFERIR;

DELIMITER ;
CREATE TABLE `TMPCREDITOSPORDIFERIR` (
  `CreditoID` BIGINT(12) NOT NULL COMMENT 'Numero de ID de Credito en SAFI que se quiere Diferir',
  `CantMesesDif` TINYINT(4) DEFAULT NULL COMMENT 'Cantidad Numerica de Meses a Diferir, debe ser valor mayor a cero',
  `TipoDiferimiento` CHAR(1) DEFAULT NULL COMMENT 'Indica que tipo de proceso se aplico al diferir\nC = Diferimiento completo, es decir, mueve todas las cuotas incluyendo fecha de inicio y vencimiento de todas las cuotas que su fecha de vencimiento es despues del 28 de Feb. incluye cuotas que tengan estatus atrasado.\nU = Diferimiento en la que se mueve a partir de la cuota en transito, mueve la fecha de vencimiento de la cuota en transito y las fechas de inicio y vencimiento de las cuotas que todavia no inician. quedando la cuota en transito como una cuota muy grande sin recalcular el interes de manera que se respeta el interes pactado original.\nT = mueve todas las cuotas incluyendo fecha de inicio y vencimiento de todas las cuotas que su fecha de vencimiento es despues del 28 de Feb. incluye cuotas que tengan estatus atrasado y  se Calcula el Interes con Tasa Preferencial del periodo diferido',
  `TasaPreferencial` DECIMAL(12,4) DEFAULT NULL COMMENT 'Indica la tasa preferencial para creditos diferidos por el tipo de diferimiento T =  Calculo de Interes con Tasa Preferencial',
  `CondonaAccesorios` CHAR(1) DEFAULT NULL COMMENT 'Indica si se van a condonar Moratorios y Comisiones',
  `CreditoOrigenID` BIGINT(12) NOT NULL COMMENT 'Numero de ID de Credito en SAFI que se quiere Diferir',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria con Numero de Empresa ID',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria con ID del usuario de SAFI que genero la transaccion',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Campo de Auditoria con Fecha  y hora Real de la transaccion',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Campo de Auditoria con la direccion IP del equipo que generó la transacción',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Campo de Auditoria con el nombre del Programa o proceso que genera la transacción',
  `Sucursal` INT(11) DEFAULT NULL COMMENT 'Campo de Auditoria con el Numero de Sucursal del usuario que genero la transacción',
  `NumTransaccion` BIGINT(20) DEFAULT NULL COMMENT 'Campo de Auditoria con el Numero de transacción generado',
  PRIMARY KEY (`CreditoID`)
) ENGINE=INNODB DEFAULT CHARSET=LATIN1 COMMENT='Guarda los registros temporales para aplicar diferimiento';
