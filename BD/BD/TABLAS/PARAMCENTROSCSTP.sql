-- PARAMCENTROSCSTP

DELIMITER ;
DROP TABLE IF EXISTS `PARAMCENTROSCSTP`;
DELIMITER $$

CREATE TABLE  PARAMCENTROSCSTP (
  `ParametroID`           INT(11)      NOT NULL  COMMENT 'Consecutivo de la Tabla',
  `ClienteEspecifico`     INT(11)      NOT NULL  COMMENT 'Cliente Especifico SAFI',
  `CentroCostoSPEISTP`    CHAR(3)      NULL      COMMENT 'Centro de Costo',
  `Estatus`               CHAR(1)      NULL      COMMENT 'Estatus del Centro de Costo A = Activo I= Inactivo T=Terminado',
  `EmpresaID`             INT(11)      NULL      COMMENT 'AUDITORIA',
  `Usuario`               INT(11)      NULL      COMMENT 'AUDITORIA',
  `FechaActual`           DATETIME     NULL      COMMENT 'AUDITORIA',
  `DireccionIP`           VARCHAR(15)  NULL      COMMENT 'AUDITORIA',
  `ProgramaID`            VARCHAR(50)  NULL      COMMENT 'AUDITORIA',
  `Sucursal`              INT(11)      NULL      COMMENT 'AUDITORIA',
  `NumTransaccion`        BIGINT(20)   NULL      COMMENT 'AUDITORIA',
  PRIMARY KEY (`ParametroID`))  
COMMENT = 'Parametros para generar cuentas clabes para deposito por SPEI '$$