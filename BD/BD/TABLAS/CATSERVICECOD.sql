-- CATSERVICECOD
DELIMITER ;
DROP TABLE IF EXISTS `CATSERVICECOD`;
DELIMITER $$

CREATE TABLE `CATSERVICECOD` (
  `CatServiceCodeID`  INT(11)       NOT NULL COMMENT 'Clave de Identificación de la Tabla',
  `NumeroServicio`    CHAR(3)       NOT NULL COMMENT 'Numero de la convinación del servicio Digito-1,Digito-2,Digito-3',
  `Descripcion`       VARCHAR(250)  NOT NULL COMMENT 'Descripcion de la causa de baja',
  `EmpresaID`         INT(11)       NOT NULL COMMENT 'Campo de auditoria',
  `Usuario`           INT(11)       NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual`       DATETIME      NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP`       VARCHAR(15)   NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID`        VARCHAR(50)   NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal`          INT(11)       NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion`    BIGINT(20)    NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`CatServiceCodeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catálogo de Código Servicio para Tarjetas'$$
