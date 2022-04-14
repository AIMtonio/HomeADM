-- Creacion de tabla TMP_CARFONDEOMASIVO

DELIMITER ;

DROP TABLE IF EXISTS TMP_CARFONDEOMASIVO;

DELIMITER $$

CREATE TABLE TMP_CARFONDEOMASIVO(
	CarFondeoMavisoID	BIGINT(20)	UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador Auto incremental',
	FilaArchivo			INT(11)		NOT NULL COMMENT 'Fila del archivo cargado',
	FechaCargaArchivo	DATE		NOT NULL COMMENT 'Fecha de carga del archivo',
	NombreArchivo		VARCHAR(50)	NOT NULL COMMENT 'Nombre del archivo cargado',
	CreditoID			BIGINT(12)	NOT NULL COMMENT 'ID del Credito a fodear (Une con tabla CREDITOS)',
	InstitutFondID		INT(11)		NOT NULL COMMENT 'ID de la institucion de Fondeo (Une con tabla INSTITUTFONDEO)',
	LineaFondeoID		INT(11)		NOT NULL COMMENT 'ID de la linea de fondeo (Une con tabla LINEAFONDEADOR)',
	CreditoFondeoID		BIGINT(20)	NOT NULL COMMENT 'ID del Credito a de pasivo para el Fondeo (Une con tabla CREDITOFONDEO)',
	TransaccionCargaID	BIGINT(20)	NOT NULL COMMENT 'ID de la transaccion del Proceso de Carga\n',
	Estatus				CHAR(1)		NOT NULL COMMENT 'Estatus del Cambio de Fondeo, nace como Registrado.\nR = Registrado\nE = Error\nA = Advertencia\nV = Valido',
	DescripcionEstatus	VARCHAR(100)NULL COMMENT 'Descripcion del Error o Advertencia en caso de haber\n',
	EmpresaID			INT(11)		NULL COMMENT 'Parametro de Auditoria',
	Usuario				INT(11)		NULL COMMENT 'Parametro de Auditoria',
	FechaActual			DATE		NULL COMMENT 'Parametro de Auditoria',
	DireccionIP			VARCHAR(15)	NULL COMMENT 'Parametro de Auditoria',
	ProgramaID			VARCHAR(50)	NULL COMMENT 'Parametro de Auditoria',
	Sucursal			INT(11)		NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion		BIGINT(20)	NULL COMMENT 'Parametro de Auditoria',
	INDEX(CreditoID),
	INDEX(TransaccionCargaID),
	INDEX(Estatus)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal para Guardar Informacion del Creditos A fondear al Momento de Cargar el Achivo.'$$
