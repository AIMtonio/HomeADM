-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCOMSALDOPROMPEND
DELIMITER ;
DROP TABLE IF EXISTS `TMPCOMSALDOPROMPEND`;

DELIMITER $$
CREATE TABLE TMPCOMSALDOPROMPEND(
    `RegComision`           INT(11) NOT NULL COMMENT 'ID de Registro de Comision de la tabla',
    `ComisionPendienteID`   INT(11) NOT NULL COMMENT 'ID Comision de la tabla',
    `CuentaAhoID`			BIGINT(12) NOT NULL	COMMENT 'Cuenta de Ahorro',
    `EmpresaID`             INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `Usuario`               INT(11) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `FechaActual`           DATETIME DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `DireccionIP`           VARCHAR(15) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `ProgramaID`            VARCHAR(50) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `Sucursal`              INT(11) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `NumTransaccion`        BIGINT(20) NOT NULL  COMMENT 'Parametro de Auditoria',
    PRIMARY KEY (`RegComision`,`NumTransaccion`),
    KEY `INDEX_COMSALDOPROMPEND_1` (`ComisionPendienteID`),
    KEY `INDEX_COMSALDOPROMPEND_2` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1  COMMENT='Tmp: Tabla Temporal de Comisiones Pendientes por Cobrar de Saldo Promedio'$$