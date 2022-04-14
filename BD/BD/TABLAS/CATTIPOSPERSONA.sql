-- Creacion de la tabla CATTIPOSPERSONA
DELIMITER ;

DROP TABLE IF EXISTS `CATTIPOSPERSONA`;

DELIMITER $$

CREATE TABLE `CATTIPOSPERSONA` (
	`CatTipoPersonaID`		INT(11)			NOT NULL COMMENT 'Numero del Usuario de Servicio',
	`TipoPersona`			CHAR(2)			NOT NULL DEFAULT '' COMMENT 'Tipo de Persona del Remitente',
	`Descripcion`			VARCHAR(200)	NOT NULL DEFAULT '' COMMENT 'Descripcion del Tipo de Persona',
	`EmpresaID`             INT(11)         NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria ID de la Empresa',
	`Usuario`               INT(11)         NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria ID del Usuario',
	`FechaActual`           DATETIME        NOT NULL DEFAULT '1900-01-01' COMMENT 'Parametro de Auditoria Fecha Actual',
	`DireccionIP`           VARCHAR(15)     NOT NULL DEFAULT '' COMMENT 'Parametro de Auditoria Direccion IP ',
	`ProgramaID`            VARCHAR(50)     NOT NULL DEFAULT '' COMMENT 'Parametro de Auditoria Programa ',
	`Sucursal`              INT(11)         NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria ID de la Sucursal',
	`NumTransaccion`        BIGINT(20)      NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria Numero de la Transaccion',
  PRIMARY KEY (`CatTipoPersonaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catalogo de Tipos de Persona.'$$