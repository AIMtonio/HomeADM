-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSREVERSA
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSREVERSA`;

DELIMITER $$
CREATE TABLE TIPOSREVERSA(
    `TipoReversaID`     INT(11) NOT NULL COMMENT 'ID Consecutivo de la tabla',
    `Descripcion`           VARCHAR(100) DEFAULT NULL COMMENT 'Descripcion del Motivo de Condonacion ',
    `Estatus`               CHAR(1) DEFAULT NULL COMMENT 'Estatus del Motivo de Condonacion A-Activo I-Inactivo',
    `EmpresaID`             INT(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
    `Usuario`               INT(11) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `FechaActual`           DATETIME DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `DireccionIP`           VARCHAR(15) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `ProgramaID`            VARCHAR(50) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `Sucursal`              INT(11) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    `NumTransaccion`        BIGINT(20) DEFAULT NULL  COMMENT 'Parametro de Auditoria',
    PRIMARY KEY (`TipoReversaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1  COMMENT='CAT: Catalogo que contiene los Motivos de Reversa para las Comisiones de Saldo Promedio'$$