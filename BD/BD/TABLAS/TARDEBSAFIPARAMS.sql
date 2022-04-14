-- TARDEBSAFIPARAMS
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBSAFIPARAMS`;
DELIMITER $$

CREATE TABLE `TARDEBSAFIPARAMS` (
  `TarDebSAFIParamsId`    INT(11)       NOT NULL COMMENT 'LLave primaria de la tabla',
  `NombreBD`              VARCHAR(60)   NOT NULL COMMENT 'Nombre de la base de datos copayment',
  `NombreTabla`           VARCHAR(60)   NOT NULL DEFAULT '' COMMENT 'Nombre de la tabla de Copayment donde se almacena la informacion de tablas.',
  `IpServer`              VARCHAR(15)   NOT NULL COMMENT 'Ip del servidor copayment',
  `Puerto`                VARCHAR(4)    NOT NULL COMMENT 'Puerto BD copayment',
  `UsuarioBD`             VARCHAR(50)   NOT NULL COMMENT 'Usuario a base de datos copayment',
  `ContaseniaBD`          VARCHAR(80)   NOT NULL COMMENT 'Contraseña de base de datos copayment',
  `SourceId`              CHAR(1)       NOT NULL COMMENT 'Entidad que manipulara los datos',
  `FIID`                  CHAR(4)       NOT NULL COMMENT 'Institución financiera',
  `HSMId`                 INT(11)       NOT NULL COMMENT 'Identificador del HSM',
  `URLWSTarjetas` varchar(300) NOT NULL DEFAULT '' COMMENT 'URL del Web Service para consulta de numero de tarjetas.',
  `URLWSConfTar` varchar(300) NOT NULL DEFAULT '' COMMENT 'URL del Web Service para confirmar los numeros de tarjetas.',
  `CredencialWSTarjetas` varchar(300) NOT NULL DEFAULT '' COMMENT 'Credenciales codificadas en Base64 para el acceso al WS de Tarjetas.',
  `URLWSGenera`			  VARCHAR(300)	NOT NULL COMMENT 'URL del Web Service para para generar los datos de maquila',
  `EmpresaID`             INT(11)       DEFAULT NULL COMMENT 'Parametro auditoria',
  `Usuario`               INT(11)       DEFAULT NULL COMMENT 'Parametro auditoria',
  `FechaActual`           DATETIME      DEFAULT NULL COMMENT 'Parametro auditoria',
  `DireccionIP`           VARCHAR(15)   DEFAULT NULL COMMENT 'Parametro auditoria',
  `ProgramaID`            VARCHAR(50)   DEFAULT NULL COMMENT 'Parametro auditoria',
  `Sucursal`              INT(11)       DEFAULT NULL COMMENT 'Parametro auditoria',
  `NumTransaccion`        BIGINT(20)    DEFAULT NULL COMMENT 'Parametro auditoria',
  PRIMARY KEY (`TarDebSAFIParamsId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Parámetros de Tarjeta de Débito en SAFI'$$
