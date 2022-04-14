-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAFILIACUENTASCLABE
DELIMITER ;
DROP TABLE IF EXISTS TMPAFILIACUENTASCLABE;
DELIMITER $$

CREATE TABLE `TMPAFILIACUENTASCLABE` (
  `FolioAfiliacionID` 	INT(11) 		NOT NULL 		COMMENT 'ID Folio de Afiliacion',
  `NumAfiliacionID` 	INT(11) 		DEFAULT NULL 	COMMENT 'Numero de Afiliacion',
  `ClienteID` 			INT(11) 		DEFAULT NULL 	COMMENT 'ID del Cliente',
  `InstitucionID` 		INT(11) 		DEFAULT NULL 	COMMENT 'ID Institucion',
  `CuentaClabe` 		VARCHAR(18) 	DEFAULT NULL 	COMMENT 'Cuenta Clabe',
  `ClaveAfiliacion` 	CHAR(2) 		DEFAULT NULL 	COMMENT 'Clave Afiliacion\n00 = Exitosa',
  `Tipo` 				CHAR(1) 		DEFAULT NULL 	COMMENT 'Tipo\nA = Alta\nB = Baja',
  `EmpresaID` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Usuario` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `FechaActual` 		DATETIME 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `DireccionIP` 		VARCHAR(20) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `ProgramaID` 			VARCHAR(50) 	DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `Sucursal` 			INT(11) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  `NumTransaccion` 		BIGINT(20) 		DEFAULT NULL 	COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`FolioAfiliacionID`),
  KEY `INDEX_TMPAFILIACUENTASCLABE_1` (`NumAfiliacionID`),
  KEY `INDEX_TMPAFILIACUENTASCLABE_2` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el registro de Afiliaciones de Cuentas Clabes para Procesar.'$$
