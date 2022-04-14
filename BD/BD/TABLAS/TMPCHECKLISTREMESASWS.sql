-- Creacion de tabla TMPCHECKLISTREMESASWS

DELIMITER ;

DROP TABLE IF EXISTS `TMPCHECKLISTREMESASWS`;

DELIMITER $$

CREATE TABLE `TMPCHECKLISTREMESASWS` (
  `ConsecutivoID`         BIGINT(20)      NOT NULL  COMMENT 'ID Consecutivo',
  `UsuarioServicioID`     INT(11)         NOT NULL  COMMENT 'Numero de Usuario de Servicio',
  `TipoDocumentoID`       INT(11)         NOT NULL  COMMENT 'Identificador de Tipo de Documento',
  `Recurso`               VARCHAR(1000)   NOT NULL	COMMENT 'Indica el Documento a cargar',
  `Extension`             VARCHAR(50)     NOT NULL	COMMENT 'Extension del Archivo digitalizado',
  `EmpresaID`             INT(11)         NOT NULL 	COMMENT 'Parametro de Auditoria',
  `Usuario`               INT(11)         NOT NULL 	COMMENT 'Parametro de Auditoria',
  `FechaActual`           DATETIME        NOT NULL 	COMMENT 'Parametro de Auditoria',
  `DireccionIP`           VARCHAR(15)     NOT NULL 	COMMENT 'Parametro de Auditoria',
  `ProgramaID`            VARCHAR(50)     NOT NULL 	COMMENT 'Parametro de Auditoria',
  `Sucursal`              INT(11)         NOT NULL 	COMMENT 'Parametro de Auditoria',
  `NumTransaccion`        BIGINT(20)      NOT NULL 	COMMENT 'Parametro de Auditoria',
   PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPCHECKLISTREMESASWS1` (`UsuarioServicioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el registro de Check List de Remesas.'$$
