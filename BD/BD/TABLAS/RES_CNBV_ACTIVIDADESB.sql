-- RES_CNBV_ACTIVIDADESB

DELIMITER ;

DROP TABLE IF EXISTS RES_CNBV_ACTIVIDADESB;

DELIMITER $$

CREATE TABLE `RES_CNBV_ACTIVIDADESB` (
	ActividadBMXID 		VARCHAR(15) 	NOT NULL 		COMMENT 'ID o Numero de Actividad BMX',
	EmpresaID 			INT(11) 		DEFAULT NULL 	COMMENT 'Empresa',
	Descripcion 		VARCHAR(200) 	NOT NULL 		COMMENT 'Descripción de la Actividad\n',
	ActividadINEGIID 	INT(11) 		DEFAULT NULL 	COMMENT 'Numero Segun INEGI\n',
	ActividadFR 		BIGINT(20) 		DEFAULT NULL 	COMMENT 'Clave de la Actividad Financiera Rural con respecto a la Actividad BMX\n',
	ActividadFOMUR 		INT(11) 		DEFAULT NULL 	COMMENT 'Se refiere a la Actividad FOMUR del Cliente\n',
	NumeroBuroCred 		INT(8) 			DEFAULT NULL 	COMMENT 'Numero Segun Buro de Credito\n',
	NumeroCNBV 			VARCHAR(8) 		DEFAULT NULL 	COMMENT 'Numero Segun Buro de CNBV\n',
	ActividadGuber 		CHAR(1) 		DEFAULT NULL 	COMMENT 'Actividad Gubernamental\n''S''  .- Si\n''N''  .- No',
	ClaveRiesgo 		CHAR(1) 		DEFAULT NULL 	COMMENT 'Clave Riesgo\n''A''  .- Alto\n''M''  .- Medio\n''B''  .- Bajo\n',
	Estatus 			CHAR(1) 		DEFAULT NULL 	COMMENT 'Estatus\n''A''  .- Activo\n''I''  .- Inactivo',
	ClasifRegID 		INT(11) 		DEFAULT NULL 	COMMENT 'Clasificacion Segun Reportes Regulatorios',
	ActividadSCIANID 	VARCHAR(8) 		DEFAULT NULL 	COMMENT 'Clave de Actividad SCIAN',
	Usuario 			INT(11) 		DEFAULT NULL 	COMMENT 'campo de auditoria',
	FechaActual 		DATETIME 		DEFAULT NULL 	COMMENT 'campo de auditoria',
	DireccionIP 		VARCHAR(15) 	DEFAULT NULL 	COMMENT 'campo de auditoria',
	ProgramaID 			VARCHAR(50) 	DEFAULT NULL 	COMMENT 'campo de auditoria',
	Sucursal 			INT(11) 		DEFAULT NULL 	COMMENT 'campo de auditoria',
	NumTransaccion 		BIGINT(20) 		DEFAULT NULL 	COMMENT 'campo de auditoria',
	PRIMARY KEY (ActividadBMXID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: respaldo de catalogo de Actividades Segun Banco de Mexico'$$