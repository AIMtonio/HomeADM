-- Creacion de la tabla TMPCOINCREMESASUSUSER

DELIMITER ;

DROP TABLE IF EXISTS `TMPCOINCREMESASUSUSER`;

DELIMITER $$

CREATE TABLE `TMPCOINCREMESASUSUSER` (
  `ConsecutivoID`       BIGINT(20)      NOT NULL COMMENT 'ID Consecutivo',
  `UsuarioServCoinID`   INT(11)         NOT NULL COMMENT 'Identificador del Usuario de Servicio con el que hizo Coincidencia',
  `RFCCoin`             CHAR(13)        NOT NULL DEFAULT '' COMMENT 'Registro Federal de Contribuyente del Usuario con el que hizo Coincidencia',
  `CURPCoin`            CHAR(18)        NOT NULL DEFAULT '' COMMENT 'Clave Unica de Registro de Poblacion del Usuario de Servicio con el que hizo Coincidencia',
  `NombreCompletoCoin`  VARCHAR(200)    NOT NULL DEFAULT '' COMMENT 'Nombre Completo del del Usuario de Servicio con el que hizo Coincidencia',
  `EmpresaID`           INT(11)         NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria ID de la Empresa',
  `Usuario`             INT(11)         NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria ID del Usuario',
  `FechaActual`         DATETIME        NOT NULL DEFAULT '1900-01-01' COMMENT 'Parametro de Auditoria Fecha Actual',
  `DireccionIP`         VARCHAR(15)     NOT NULL DEFAULT '' COMMENT 'Parametro de Auditoria Direccion IP ',
  `ProgramaID`          VARCHAR(50)     NOT NULL DEFAULT '' COMMENT 'Parametro de Auditoria Programa ',
  `Sucursal`            INT(11)         NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria ID de la Sucursal',
  `NumTransaccion`      BIGINT(20)      NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria Numero de la Transaccion',
  PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPCOINCREMESASUSUSER_1` (`RFCCoin`),
  KEY `INDEX_TMPCOINCREMESASUSUSER_2` (`CURPCoin`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el registro de Concidencias de Remesas de Usuarios de Servicios'$$