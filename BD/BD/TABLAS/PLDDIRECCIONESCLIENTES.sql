-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDIRECCIONESCLIENTES
DELIMITER ;
DROP TABLE IF EXISTS `PLDDIRECCIONESCLIENTES`;
DELIMITER $$

CREATE TABLE `PLDDIRECCIONESCLIENTES` (
  `RegistroID`         BIGINT(20)         NOT NULL AUTO_INCREMENT COMMENT 'Llave primaria del registro',
  `ClienteIDExt`       VARCHAR(20)        NOT NULL                COMMENT 'Identificador del cliente externo',
  `ClienteID`          INT(11)            NOT NULL                COMMENT 'Identificador del cliente en el SAFI',
  `DireccionID`        INT(11)            NOT NULL                COMMENT 'Identificador de la Direccion',
  `EmpresaID`          INT(11)            NOT NULL                COMMENT 'Parametro de Auditoria',
  `Usuario`            INT(11)            NOT NULL                COMMENT 'Parametro de Auditoria',
  `FechaActual`        DATETIME           NOT NULL                COMMENT 'Parametro de Auditoria',
  `DireccionIP`        VARCHAR(15)        NOT NULL                COMMENT 'Parametro de Auditoria',
  `ProgramaID`         VARCHAR(50)        NOT NULL                COMMENT 'Parametro de Auditoria',
  `Sucursal`           INT(11)            NOT NULL                COMMENT 'Parametro de Auditoria',
  `NumTransaccion`     BIGINT(20)         NOT NULL                COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`RegistroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla alterna a DIRECCLIENTE para referencias a los clientes externos al SAFI'$$
