-- Creacion de tabla TMPCONSTANCIARETCTE

DELIMITER ;

DROP TABLE IF EXISTS TMPCONSTANCIARETCTE;

DELIMITER $$

CREATE TABLE `TMPCONSTANCIARETCTE` (
  `ConsecutivoID`       INT(11)         NOT NULL COMMENT 'ID Consecutivo',
  `Anio` 				INT(11) 		NOT NULL COMMENT 'Anio proceso',
  `ClienteID` 			INT(11) 		NOT NULL COMMENT 'Numero de Cliente',
  `TipoPersona` 		CHAR(1) 		NOT NULL COMMENT 'Tipo de Personalidad del Cliente\nM = Persona Moral\nA = Persona Fisica Con Actividad Empresarial\nF = Persona Fisica Sin Actividad Empresarial',
  `RFC` 				VARCHAR(13) 	NOT NULL COMMENT 'Registro Federal de Contribuyentes',
  `RegHacienda` 		CHAR(1) 		NOT NULL COMMENT 'Especifica si el cliente esta registrado en Hacienda\nS.- Si\nN.- No',
  `NombreCompleto` 		VARCHAR(200) 	NOT NULL COMMENT 'Nombre Completo del Cliente o Razon Social',
  `EmpresaID`           INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario`             INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual`         DATETIME        NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP`         VARCHAR(15)     NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID`          VARCHAR(50)     NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal`            INT(11)         NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion`      BIGINT(20)      NOT NULL COMMENT 'Parametro de Auditoria',
   PRIMARY KEY (`ConsecutivoID`),
  KEY `INDEX_TMPCONSTANCIARETCTE_1` (`Anio`),
  KEY `INDEX_TMPCONSTANCIARETCTE_2` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para el Registro de Informacion la Constancia de Retencion'$$
