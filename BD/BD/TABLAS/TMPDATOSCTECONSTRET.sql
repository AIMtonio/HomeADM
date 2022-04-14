-- Creacion de tabla TMPDATOSCTECONSTRET

DELIMITER ;

DROP TABLE IF EXISTS TMPDATOSCTECONSTRET;

DELIMITER $$

CREATE TABLE `TMPDATOSCTECONSTRET` (
  `ConsecutivoID`		BIGINT(12)		UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Numero Consecutivo',
  `Anio`                INT(11)       	NOT NULL COMMENT 'Anio proceso',
  `Mes`               	INT(11)       	NOT NULL COMMENT 'Mes de proceso',
  `SucursalID`          INT(11)       	NOT NULL COMMENT 'Numero de Sucursal del Cliente',
  `NombreSucursalCte`   VARCHAR(60)   	NOT NULL COMMENT 'Nombre de Sucursal del Cliente',
  `ClienteID`           INT(11)       	NOT NULL COMMENT 'Numero de Cliente',
  `PrimerNombre`        VARCHAR(50)   	NOT NULL COMMENT 'Primer Nombre del Cliente',
  `SegundoNombre`       VARCHAR(50)   	NOT NULL COMMENT 'Segundo Nombre del Cliente',
  `TercerNombre`        VARCHAR(50)   	NOT NULL COMMENT 'Tercer Nombre del Cliente',
  `ApellidoPaterno`     VARCHAR(50)   	NOT NULL COMMENT 'Apellido Paterno del Cliente',
  `ApellidoMaterno`     VARCHAR(50)   	NOT NULL COMMENT 'Apellido Materno del Cliente',
  `NombreCompleto`      VARCHAR(170)  	NOT NULL COMMENT 'Nombre Completo del Cliente',
  `RazonSocial`         VARCHAR(150)  	NOT NULL COMMENT 'Razon Social',
  `TipoPersona`         CHAR(1)       	NOT NULL COMMENT 'Tipo de Persona',
  `RFC`                 VARCHAR(13)   	NOT NULL COMMENT 'Registro Federal de Contribuyentes',
  `CURP`                CHAR(18)      	NOT NULL COMMENT 'CURP del Cliente',
  `DireccionCompleta`   VARCHAR(500)  	NOT NULL COMMENT 'Direccion Completa del Cliente',
  `RegHacienda`         CHAR(1)       	NOT NULL COMMENT 'Especifica si el Cliente esta registrado en Hacienda\nS.- Si\nN.- No',
  `EsMenorEdad`         CHAR(1)       	NOT NULL COMMENT 'Es Menor de Edad\nS.- Si\nN.- No',
  `EmpresaID`           INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
   PRIMARY KEY (`ConsecutivoID`),
   KEY `INDEX_TMPDATOSCTECONSTRET_1` (`ConsecutivoID`),
   KEY `INDEX_TMPDATOSCTECONSTRET_2` (`Anio`),
   KEY `INDEX_TMPDATOSCTECONSTRET_3` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el registro de Informacion de Clientes para la Constancia de Retencion'$$
