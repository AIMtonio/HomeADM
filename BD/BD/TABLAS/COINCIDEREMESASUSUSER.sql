-- Creacion de la tabla COINCIDEREMESASUSUSER

DELIMITER ;

DROP TABLE IF EXISTS `COINCIDEREMESASUSUSER`;

DELIMITER $$

CREATE TABLE `COINCIDEREMESASUSUSER` (
  `CoincideRemesaID`    BIGINT(20)      NOT NULL COMMENT 'Identificador de la tabla COINCIDEREMESASUSUSER',
  `Fecha`               DATE            NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha en la que se realizo la Concidencia',
  `TipoCoincidencia`    CHAR(4)         NOT NULL DEFAULT '' COMMENT 'TipoConcidencia\nRFC (Para Tipo de Persona Moral)\nCURP (Para Tipo de Persona Fisica o Fisica con Actividad Empresarial)',
  `UsuarioServicioID`   INT(11)         NOT NULL COMMENT 'Identificador del Usuario de Servicio que busca Coincidencia',
  `RFC`                 CHAR(13)        NOT NULL DEFAULT '' COMMENT 'Registro Federal de Contribuyente del Usuario de Servicio que busca Coincidencia',
  `CURP`                CHAR(18)        NOT NULL DEFAULT '' COMMENT 'Clave Unica de Registro de Poblacion del Usuario de Servicio que busca Coincidencia',
  `NombreCompleto`      VARCHAR(200)    NOT NULL DEFAULT '' COMMENT 'Nombre Completo del del Usuario de Servicio que busca Coincidencia',
  `UsuarioServCoinID`   INT(11)         NOT NULL COMMENT 'Identificador del Usuario de Servicio con el que hizo Coincidencia',
  `RFCCoin`             CHAR(13)        NOT NULL DEFAULT '' COMMENT 'Registro Federal de Contribuyente del Usuario con el que hizo Coincidencia',
  `CURPCoin`            CHAR(18)        NOT NULL DEFAULT '' COMMENT 'Clave Unica de Registro de Poblacion del Usuario de Servicio con el que hizo Coincidencia',
  `NombreCompletoCoin`  VARCHAR(200)    NOT NULL DEFAULT '' COMMENT 'Nombre Completo del del Usuario de Servicio con el que hizo Coincidencia',
  `PorcConcidencia`     DECIMAL(14,2)   NOT NULL DEFAULT '0.00' COMMENT 'Porcentaje de Coincidencia',
  `Unificado`           CHAR(1)         NOT NULL DEFAULT 'N' COMMENT 'Indica si ya fue Unificado\nS = SI\nN = NO',
  `EmpresaID`           INT(11)         NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria ID de la Empresa',
  `Usuario`             INT(11)         NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria ID del Usuario',
  `FechaActual`         DATETIME        NOT NULL DEFAULT '1900-01-01' COMMENT 'Parametro de Auditoria Fecha Actual',
  `DireccionIP`         VARCHAR(15)     NOT NULL DEFAULT '' COMMENT 'Parametro de Auditoria Direccion IP ',
  `ProgramaID`          VARCHAR(50)     NOT NULL DEFAULT '' COMMENT 'Parametro de Auditoria Programa ',
  `Sucursal`            INT(11)         NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria ID de la Sucursal',
  `NumTransaccion`      BIGINT(20)      NOT NULL DEFAULT '0' COMMENT 'Parametro de Auditoria Numero de la Transaccion',
  PRIMARY KEY (`CoincideRemesaID`),
  KEY `INDEX_COINCIDEREMESASUSUSER_1` (`Fecha`),
  KEY `INDEX_COINCIDEREMESASUSUSER_2` (`TipoCoincidencia`),
  KEY `INDEX_COINCIDEREMESASUSUSER_3` (`UsuarioServicioID`),
  KEY `INDEX_COINCIDEREMESASUSUSER_4` (`UsuarioServCoinID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Concidencias de Remesas de Usuarios de Servicios'$$