-- Creacion de tabla TMPCTERELFISCALPDF

DELIMITER ;

DROP TABLE IF EXISTS TMPCTERELFISCALPDF;

DELIMITER $$

CREATE TABLE `TMPCTERELFISCALPDF` (
  `ConsecutivoID`       INT(11)         NOT NULL COMMENT 'ID Consecutivo',
  `ConstanciaRetID` 	BIGINT(12)		NOT NULL COMMENT 'Numero Consecutivo Constancia de Retencion',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `SucursalID` 			INT(11) 		NOT NULL COMMENT 'Anio proceso',
  `Tipo` 				CHAR(2) 		NOT NULL COMMENT 'Tipo Relacionados Fiscales\nA = Aportante\nC = Cliente\nR = Relacionado\nAC = Aportante Cliente',
  `CteRelacionadoID` 	INT(11) 		NOT NULL COMMENT 'Numero del Cliente relacionado o 0 si el relacionado no es Cliente',
  `NombrePDF` 			VARCHAR(100) 	NOT NULL COMMENT 'Nombre del Archivo PDF',
  `RutaCBB` 			VARCHAR(100) 	NOT NULL COMMENT 'Ruta del Archivo CBB',
   PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPCTERELFISCALPDF_1` (`ConstanciaRetID`),
  KEY `INDEX_TMPCTERELFISCALPDF_2` (`ClienteID`),
  KEY `INDEX_TMPCTERELFISCALPDF_3` (`SucursalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para obtener informacion de clientes relacionados fiscales para generar el PDF'$$
