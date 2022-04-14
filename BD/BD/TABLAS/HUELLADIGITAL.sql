-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HUELLADIGITAL
DELIMITER ;
DROP TABLE IF EXISTS `HUELLADIGITAL`;
DELIMITER $$

CREATE TABLE `HUELLADIGITAL` (
  `AutHuellaDigitalID`  BIGINT UNSIGNED AUTO_INCREMENT        COMMENT 'Identificador auto incremental',
  `TipoPersona`         CHAR(1)         NOT NULL DEFAULT 'C'  COMMENT 'C .- Cliente, U .- Usuario, F .- Firmante',
  `PersonaID`           BIGINT(11)      NOT NULL              COMMENT 'ID de la Persona (Cliente, Usuario, Etc)',
  `HuellaUno`           VARBINARY(4000) DEFAULT NULL,
  `FmdHuellaUno`        VARBINARY(4000) DEFAULT NULL          COMMENT 'Fmd para validar duplicidad de huella',
  `DedoHuellaUno`       CHAR(1)         DEFAULT NULL          COMMENT 'Dedo capturado. I .- Indice, M .- Medio, A .- Anular, N .- Menique, P .- Pulgar',
  `HuellaDos`           VARBINARY(4000) DEFAULT NULL,
  `FmdHuellaDos`        VARBINARY(4000) DEFAULT NULL          COMMENT 'Fmd para validar duplicidad de huella',
  `DedoHuellaDos`       CHAR(1)         DEFAULT NULL          COMMENT 'Dedo capturado. I .- Indice, M .- Medio, A .- Anular, N .- Menique, P .- Pulgar',
  `Estatus`             CHAR(1)         NOT NULL              COMMENT 'V - Registrado, P - Validando Huella, A - Huella Autorizada, R - Huella Repetida',
  `PIDTarea`            VARCHAR(50)     NOT NULL              COMMENT 'Numero referente a la Tarea',
  `EmpresaID`           INT(11)         DEFAULT NULL          COMMENT 'Paramteros de Auditoria',
  `Usuario`             INT(11)         DEFAULT NULL          COMMENT 'Paramteros de Auditoria',
  `FechaActual`         DATETIME        DEFAULT NULL          COMMENT 'Paramteros de Auditoria',
  `DireccionIP`         VARCHAR(15)     DEFAULT NULL          COMMENT 'Paramteros de Auditoria',
  `ProgramaID`          VARCHAR(50)     DEFAULT NULL          COMMENT 'Paramteros de Auditoria',
  `Sucursal`            VARCHAR(45)     DEFAULT NULL          COMMENT 'Paramteros de Auditoria',
  `NumTransaccion`      BIGINT(20)      DEFAULT NULL          COMMENT 'Paramteros de Auditoria',
  PRIMARY KEY (`AutHuellaDigitalID`),
  INDEX `IDX_HUELLADIGITAL_1` (`TipoPersona`),
  INDEX `IDX_HUELLADIGITAL_2` (`PersonaID`),
  INDEX `IDX_HUELLADIGITAL_3` (`Estatus`,`PIDTarea`),
  INDEX `IDX_HUELLADIGITAL_4` (`PersonaID`,`TipoPersona`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el registro de huellas digitales'$$