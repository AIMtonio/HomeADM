-- Creacion de tabla CATCODIGOSAFILIADOM

DELIMITER ;

DROP TABLE IF EXISTS CATCODIGOSAFILIADOM;

DELIMITER $$

CREATE TABLE `CATCODIGOSAFILIADOM` (
  `CatCodigoID`     INT(11)         NOT NULL COMMENT 'ID consecutivo del catalogo',
  `TipoCodigo`      CHAR(1)         NOT NULL COMMENT 'Tipo de Codigo\nF = AFILIACION\nD = DOMICILIACION\nA = AMBAS',
  `ClaveCodigo`     CHAR(2)         NOT NULL COMMENT 'Clave del Codigo',
  `Descripcion`     VARCHAR(200)    NOT NULL COMMENT 'Descripcion de la Clave de Codigo',
  `EmpresaID`       INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`         INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`     DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`     VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`      VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`        INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`  BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`CatCodigoID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1
COMMENT = 'Cat: Catalogo de Codigos de Afiliacion y Domiciliacion'$$
