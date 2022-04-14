-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMREV
DELIMITER ;
DROP TABLE IF EXISTS `COMSALDOPROMREV`;

DELIMITER $$
CREATE TABLE COMSALDOPROMREV(
    `ReversaID`           INT(11)  NOT NULL COMMENT 'ID Reversa de la tabla',
    `CuentaAhoID`         BIGINT(12) NOT NULL COMMENT 'Cuenta de Ahorro',
    `FechaReversa`        DATE NOT NULL COMMENT 'Fecha en que se realiza la reversa',
    `FechaCobro`          DATE NOT NULL COMMENT 'Fecha del cobro original de la comision',
    `ComSaldoPromRev`     DECIMAL(14,2) NOT NULL COMMENT 'Monto de la reversa',
    `IVAComSalPromRev`    DECIMAL(14,2) NOT NULL COMMENT 'IVA del monto de reversa',
    `TotalReversa`        DECIMAL(14,2) NOT NULL COMMENT 'Monto total de la reversa',
    `UsuarioReversa`      INT NOT NULL COMMENT 'Usuario que autorizo la reversa',
    `MotivoReversa`       VARCHAR(200) NOT NULL COMMENT 'Motivo de la Reversa',
    `TipoReversaID`       INT(11) NOT NULL COMMENT 'Tipo de Reversa Realizada - TIPOSREVERSA',
    `EmpresaID`           INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `Usuario`             INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `FechaActual`         DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `DireccionIP`         VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `ProgramaID`          VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `Sucursal`            INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `NumTransaccion`      BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    PRIMARY KEY (`ReversaID`),
    KEY `INDEX_COMSALDOPROMREV_1` (`CuentaAhoID`),
    CONSTRAINT `FK_COMSALDOPROMREV_1` FOREIGN KEY (`TipoReversaID`) REFERENCES `TIPOSREVERSA` (`TipoReversaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1  COMMENT='TAB: Tabla de Reversa para las Comisiones de Saldo Promedio'$$