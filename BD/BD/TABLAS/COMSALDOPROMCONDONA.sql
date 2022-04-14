-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMCONDONA
DELIMITER ;
DROP TABLE IF EXISTS `COMSALDOPROMCONDONA`;

DELIMITER $$
CREATE TABLE COMSALDOPROMCONDONA(
    `CondonacionID`       INT(11) NOT NULL COMMENT 'ID Condonacion de la tabla',
    `ComisionID`          INT(11) NOT NULL COMMENT 'ID de la Comision Pendiente que se Condono',
    `CuentaAhoID`         BIGINT(12) NOT NULL COMMENT 'Cuenta de Ahorro',
    `FechaCondonacion`    DATE NOT NULL COMMENT 'Fecha en que se realiza la condonacion',
    `ComSaldoPromCond`    DECIMAL(14,2) NOT NULL COMMENT 'Monto de la condonacion',
    `IVAComSalPromCond`   DECIMAL(14,2) NOT NULL COMMENT 'IVA del monto de condonacion',
    `TotalCondonacion`    DECIMAL(14,2) NOT NULL COMMENT 'Monto total de la condonacion',
    `UsuarioCondona`      INT NOT NULL COMMENT 'Usuario que autorizo la condonacion',
    `MotivoCondonacion`   VARCHAR(200) NOT NULL COMMENT 'Motivo de la condonacion',
    `TipoCondonacionID`   INT(11) NOT NULL COMMENT 'Tipo de Condonacion Realizada - TIPOSCONDONACION',
    `EmpresaID`           INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `Usuario`             INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `FechaActual`         DATETIME DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `DireccionIP`         VARCHAR(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `ProgramaID`          VARCHAR(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `Sucursal`            INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `NumTransaccion`      BIGINT(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    PRIMARY KEY (`CondonacionID`),
    KEY `INDEX_COMSALDOPROMCONDONA_1` (`CuentaAhoID`),
    CONSTRAINT `FK_COMSALDOPROMCONDONA_1` FOREIGN KEY (`TipoCondonacionID`) REFERENCES `TIPOSCONDONACION` (`TipoCondonacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1  COMMENT='TAB: Tabla de Condonaciones para las Comisiones de Saldo Promedio'$$