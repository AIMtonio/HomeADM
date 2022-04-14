-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWCTAEXCEMARGENPAGOS
DELIMITER ;
DROP TABLE IF EXISTS `CRWCTAEXCEMARGENPAGOS`;
DELIMITER $$

CREATE TABLE `CRWCTAEXCEMARGENPAGOS` (
    `CuentaAhoID`       BIGINT(12)      NOT NULL    COMMENT 'Cuenta de Ahorro',
    `EmpresaID`         INT(11)         NOT NULL    COMMENT 'Parametro de auditoria',
    `Usuario`           INT(11)         NOT NULL    COMMENT 'Parametro de auditoria',
    `FechaActual`       DATETIME        NOT NULL    COMMENT 'Parametro de auditoria',
    `DireccionIP`       VARCHAR(15)     NOT NULL    COMMENT 'Parametro de auditoria',
    `ProgramaID`        VARCHAR(50)     NOT NULL    COMMENT 'Parametro de auditoria',
    `Sucursal`          INT(11)         NOT NULL    COMMENT 'Parametro de auditoria',
    `NumTransaccion`    BIGINT(20)      NOT NULL    COMMENT 'Parametro de auditoria',
    PRIMARY KEY (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Cuentas de Ahorro Excentas de la Validacion en Inversionista'$$
