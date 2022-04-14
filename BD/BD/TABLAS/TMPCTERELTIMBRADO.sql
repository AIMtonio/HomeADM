-- Creacion de tabla TMPCTERELTIMBRADO

DELIMITER ;

DROP TABLE IF EXISTS TMPCTERELTIMBRADO;

DELIMITER $$

CREATE TABLE `TMPCTERELTIMBRADO` (
  `ConsecutivoID`       INT(11)         NOT NULL COMMENT 'ID Consecutivo',
  `ConstanciaRetID` 	BIGINT(12)		NOT NULL COMMENT 'Numero Consecutivo Constancia de Retencion',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `SucursalID` 			INT(11) 		NOT NULL COMMENT 'Anio proceso',
  `CadenaCFDI` 			VARCHAR(5000) 	NOT NULL COMMENT 'Cadena para archivo de timbrado CFDI',
  `Estatus` 			INT(11) 		NOT NULL COMMENT 'Estatus Timbrado\n1 = No Procesado\n2 = Exitoso\n3 = Erroneo',
  `Tipo` 				CHAR(2) 		NOT NULL COMMENT 'Tipo Relacionados Fiscales\nA = Aportante\nC = Cliente\nR = Relacionado\nAC = Aportante Cliente',
  `CteRelacionadoID` 	INT(11) 		NOT NULL COMMENT 'Numero del Cliente relacionado o 0 si el relacionado no es Cliente',
  `RutaXML` 			VARCHAR(100) 	NOT NULL COMMENT 'Ruta del Archivo XML',
  `RutaCBB` 			VARCHAR(100) 	NOT NULL COMMENT 'Ruta del Archivo CBB',
  `EmpresaID`           INT(11)         NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NULL COMMENT 'Parametro de Auditoria',
   PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPCTERELTIMBRADO_1` (`ConstanciaRetID`),
  KEY `INDEX_TMPCTERELTIMBRADO_2` (`ClienteID`),
  KEY `INDEX_TMPCTERELTIMBRADO_3` (`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para obtener informacion de clientes relacionados fiscales para el timbrado'$$
