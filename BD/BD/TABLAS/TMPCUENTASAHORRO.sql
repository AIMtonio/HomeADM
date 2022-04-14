-- Creacion de tabla TMPCUENTASAHORRO

DELIMITER ;

DROP TABLE IF EXISTS TMPCUENTASAHORRO;

DELIMITER $$

CREATE TABLE `TMPCUENTASAHORRO` (
  `ConsecutivoID`       BIGINT(12) 		UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Numero Consecutivo',
  `Fecha` 				DATE			NOT NULL COMMENT 'Fecha de Registro',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `TipoInstrumentoID` 	INT(11) 		NOT NULL COMMENT 'Tipo de Instrumento:\n2 = Cuentas',
  `CuentaAhoID` 		BIGINT(12) 		NOT NULL COMMENT 'Numero de Cuenta',
  `Monto` 				DECIMAL(18,2) 	NOT NULL COMMENT 'Monto del Instrumento',
  `FechaInicio`			DATE 			NOT NULL COMMENT 'Fecha de Inicio Cuenta de Ahorro',
  `FechaFin`			DATE 			NOT NULL COMMENT 'Fecha de Fin Cuenta de Ahorro',
  `InteresGravado`   	DECIMAL(18,2) 	NOT NULL COMMENT 'Interes Gravado',
  `InteresExento`     	DECIMAL(18,2) 	NOT NULL COMMENT 'Interes Exento',
  `InteresRetener`    	DECIMAL(18,2) 	NOT NULL COMMENT 'Interes Retenido',
  `TasaInteres`       	DECIMAL(14,4) 	NOT NULL DEFAULT '0.0000' COMMENT 'Tasa de Interes',
  `EmpresaID`           INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
   PRIMARY KEY (`ConsecutivoID`),
   KEY `INDEX_TMPCUENTASAHORRO_1` (`ConsecutivoID`,`Fecha`,`ClienteID`,`TipoInstrumentoID`,`CuentaAhoID`),
   KEY `INDEX_TMPCUENTASAHORRO_2` (`Fecha`),
   KEY `INDEX_TMPCUENTASAHORRO_3` (`ClienteID`),
   KEY `INDEX_TMPCUENTASAHORRO_4` (`TipoInstrumentoID`),
   KEY `INDEX_TMPCUENTASAHORRO_5` (`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal de Cuentas que generaron intereses en el Anio'$$
