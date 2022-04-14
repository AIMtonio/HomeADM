-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMCOBRADO
DELIMITER ;
DROP TABLE IF EXISTS `COMSALDOPROMCOBRADO`;

DELIMITER $$
CREATE TABLE COMSALDOPROMCOBRADO(
    `CobroID`             INT(11) NOT NULL COMMENT 'ID Condonacion de la tabla',
    `ComisionID`          INT(11) NOT NULL COMMENT 'Identificador del ID de la comision pendiente de cobro, en el caso de cierre de mes sera 0',
    `CuentaAhoID`         BIGINT(12) NOT NULL COMMENT 'Cuenta de Ahorro',
    `SaldoDispon`         DECIMAL(16,2) NOT NULL COMMENT 'Monto del Saldo disponible en la cuenta antes del cobro',
    `FechaCobro`          DATE NOT NULL COMMENT 'Fecha en que se realiza el cobro a la cuenta',
    `ComSaldoPromPend`    DECIMAL(14,2) NOT NULL COMMENT 'Monto de comision que aun no ha sido cubierta antes del cobro',
    `IVAComSalPromPend`   DECIMAL(14,2) NOT NULL COMMENT 'IVA del monto de comision pendiente de pago antes del cobro',
    `ComSaldoPromCob`     DECIMAL(14,2) NOT NULL COMMENT 'Monto de la comision cobrada',
    `IVAComSalPromCob`    DECIMAL(14,2) NOT NULL COMMENT 'IVA del monto de la comision',
    `TotalCobrado`        DECIMAL(14,2) NOT NULL COMMENT 'Monto total del cobro',
    `OrigenCobro`         CHAR(1) NOT NULL COMMENT 'C - Cierre de Mes, A - Abono a cuenta',
    `EmpresaID`           INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `Usuario`             INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `FechaActual`         DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `DireccionIP`         VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `ProgramaID`          VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `Sucursal`            INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `NumTransaccion`      BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    PRIMARY KEY (`CobroID`),
    KEY `INDEX_COMSALDOPROMCOBRADO_1` (`CuentaAhoID`),
    KEY `INDEX_COMSALDOPROMCOBRADO_2` (`CuentaAhoID`,`FechaCobro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1  COMMENT='TAB: Tabla de Condonaciones para las Comisiones de Saldo Promedio'$$