-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FABLOCALIDADESREPUB
DELIMITER ;
DROP TABLE IF EXISTS `FABLOCALIDADESREPUB`;

DELIMITER $$
CREATE TABLE `FABLOCALIDADESREPUB` (
	`ID`					INT(11)		 NOT NULL AUTO_INCREMENT COMMENT 'ID de Tabla',
	`PaisID`				INT(11)		 NOT NULL COMMENT 'ID de Pais',
	`PaisDescripcion`		VARCHAR(20)	 NOT NULL COMMENT 'Descripción de Pais',
	`EstadoID`				INT(11)		 NOT NULL COMMENT 'ID de Estado',
	`EstadoDescripcion`		VARCHAR(50)	 NOT NULL COMMENT 'Descripción de Estado',
	`MunicipioID`			INT(11)		 NOT NULL COMMENT 'ID de Municipio',
	`MunicipioDescripcion`	VARCHAR(150) NOT NULL COMMENT 'Descripción de Municipio',
	`LocalidadID`			INT(11)		 NOT NULL COMMENT 'ID de Localidad',
	`LocalidadDescripcion`	VARCHAR(200) NOT NULL COMMENT 'Descripción de Localidad',
	`LocalidadCNBV`			VARCHAR(30)	 NOT NULL COMMENT 'ID de Localidad CNBV',
	`EmpresaID`				INT(11)		 NOT NULL COMMENT 'campo de auditoria',
	`Usuario`				INT(11)		 NOT NULL COMMENT 'campo de auditoria',
	`FechaActual`			DATETIME	 NOT NULL COMMENT 'campo de auditoria',
	`DireccionIP`			VARCHAR(15)	 NOT NULL COMMENT 'campo de auditoria',
	`ProgramaID`			VARCHAR(50)	 NOT NULL COMMENT 'campo de auditoria',
	`Sucursal`				INT(11)		 NOT NULL COMMENT 'campo de auditoria',
	`NumTransaccion`		BIGINT(20)	 NOT NULL COMMENT 'campo de auditoria',
	PRIMARY KEY (`ID`),
	KEY `INDEX_FABLOCALIDADESREPUB_1` (`LocalidadCNBV`),
	KEY `INDEX_FABLOCALIDADESREPUB_2` (`PaisID`,`EstadoID`,`MunicipioID`,`LocalidadID`,`LocalidadCNBV`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab.- Tabla de Localidades validadas por el SITI'$$