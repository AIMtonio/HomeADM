DELIMITER ;
DROP TABLE IF EXISTS CREDITOSDIFERIDOS;

DELIMITER ;
CREATE TABLE `CREDITOSDIFERIDOS` (
  `CreditoID`           BIGINT(12)    NOT NULL COMMENT 'Numero de ID de Credito en SAFI que se quiere Diferir',
  `NumeroDiferimientos` INT(11)       NOT NULL COMMENT 'Numero de Diferimientos',
  `FechaAplicacion`     DATE          DEFAULT NULL COMMENT 'Fecha en la que se aplicó el diferimiento, Fecha del sistema',
  `FechaFinPeriodo`     DATE          DEFAULT NULL COMMENT 'Fecha calculada en la que termina el diferimiento, se obtiene de tomar la fecha de aplicacion de diferimiento y sumarle la cantidad de meses a diferir.',
  `MesesDiferidos`      TINYINT(4)    DEFAULT NULL COMMENT 'Cantidad Numerica de Meses que aplico el diferimiento, debe ser valor mayor a cero',
  `TipoDiferimiento`    CHAR(1)       DEFAULT NULL COMMENT 'Indica que tipo de proceso se aplico al diferir \n C = Diferimiento completo, es decir, mueve todas las cuotas incluyendo fecha de inicio y vencimiento de todas las cuotas que su fecha d vencimiento es despues del 28 de Feb. incluye cuotas que tengan estatus atrasado.\nU = Diferimiento en la que se mueve a partir de la cuota en transito, mueve la fecha de vencimiento de la cuota en transito y las fechas de inicio y vencimiento de las cuotas que todavia no inician. quedando la cuota en transito como una cuota muy grande sin recalcular el interes de manera que se respeta el interes pactado original."',
  `AmortizacionID`      INT(11)       DEFAULT NULL COMMENT 'Numero de Amortizacion a partir de la cual se aplico el diferimiento.',
  `DiasDiferidos`       INT(11)       DEFAULT NULL COMMENT 'Numero de dias que se aplazo el credito para considerarlo en el calculo de dias de atraso',
  `TasaPreferencial`    DECIMAL(12,4) DEFAULT NULL COMMENT 'Indica la tasa preferencial para creditos diferidos por el tipo de diferimiento T =  Calculo de Interes con Tasa Preferencial',
  `MontoPreferencial`   DECIMAL(16,2) DEFAULT NULL COMMENT 'Monto de interes calculado con la tasa preferencial',
  `CondonaAccesorios`   CHAR(1)       DEFAULT NULL COMMENT 'Indica si se van a condonar Moratorios y Comisiones',
  `CreditoOrigenID`     BIGINT(12)    NOT NULL COMMENT 'Numero de ID de Credito en SAFI que se quiere Diferir',
  `FechaCorte`          DATE          DEFAULT NULL COMMENT 'Fecha Corte del que se conservaran los dias de atraso, 2020-03-31',
  `EmpresaID`           INT(11)       DEFAULT NULL COMMENT 'Campo de Auditoria con Numero de Empresa ID',
  `Usuario`             INT(11)       DEFAULT NULL COMMENT 'Campo de Auditoria con ID del usuario de SAFI que genero la transaccion',
  `FechaActual`         DATEtime      DEFAULT NULL COMMENT 'Campo de Auditoria con Fecha  y hora Real de la transaccion',
  `DireccionIP`         VARCHAR(15)   DEFAULT NULL COMMENT 'Campo de Auditoria con la direccion IP del equipo que generó la transacción',
  `ProgramaID`          VARCHAR(50)   DEFAULT NULL COMMENT 'Campo de Auditoria con el nombre del Programa o proceso que genera la transacción',
  `Sucursal`            INT(11)       DEFAULT NULL COMMENT 'Campo de Auditoria con el Numero de Sucursal del usuario que genero la transacción',
  `NumTransaccion`      BIGINT(20)    DEFAULT NULL COMMENT 'Campo de Auditoria con el Numero de transacción generado',
  PRIMARY KEY (`CreditoID`,`NumeroDiferimientos`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Guarda los creditos que se difirieron de forma exitosa';
