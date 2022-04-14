-- TARBINPARAMS
DELIMITER ;
DROP TABLE IF EXISTS `TARBINPARAMS`;
DELIMITER $$

CREATE TABLE `TARBINPARAMS` (
  `TarBinParamsID`      INT(11)       NOT NULL COMMENT 'Identificador de la tabla',
  `NumBIN`              CHAR(8)       NOT NULL COMMENT 'Número de BIN',
  `EsSubBin`            CHAR(1)       NOT NULL COMMENT 'Identifica el uso de subbin S-Si, N-No',
  `EsBinMulEmp`         CHAR(1)       NOT NULL COMMENT 'Identifica si el BIN es multiempresa',
  `CatMarcaTarjetaID`   INT(11)       NOT NULL COMMENT 'Identificador tabla CATMARCATARJETA',
  `EmpresaID`           INT(11)       NOT NULL COMMENT 'Parametros de Auditoria',
  `Usuario`             INT(11)       NOT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual`         DATETIME      NOT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP`         VARCHAR(15)   NOT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID`          VARCHAR(50)   NOT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal`            INT(11)       NOT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion`      BIGINT(20)    NOT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`TarBinParamsID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de taejetas para maquina en SAFI'$$