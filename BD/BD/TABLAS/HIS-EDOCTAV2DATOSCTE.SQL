DELIMITER ;
DROP TABLE IF EXISTS `HIS-EDOCTAV2DATOSCTE`;
DELIMITER $$


CREATE TABLE `HIS-EDOCTAV2DATOSCTE` (
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	SucursalID	 			INT(11) 		NOT NULL COMMENT 'Numero de surcusal del cliente',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	NombreCompleto			VARCHAR(200)	NOT NULL COMMENT 'Nombre completo del cliente',
	NombreSucursalCte		VARCHAR(60)		NOT NULL COMMENT 'nombre de la surcusal del cliente',
	TipoPer					CHAR(1)			NOT NULL COMMENT 'Tipo Persona:\nF = Fisica\nM = Moral\nA = Fisica con Actividad Empresarial',
	TipoPersona				VARCHAR(50)		NOT NULL COMMENT 'Descripcion Tipo Persona',
	Calle					VARCHAR(50)		NOT NULL COMMENT 'Descripcion de la calle',
	NumInt					CHAR(15)		NOT NULL COMMENT 'Numero Interior',
	NumExt					CHAR(15)		NOT NULL COMMENT 'Numero Exterior',
	Colonia					VARCHAR(200)	NOT NULL COMMENT 'Nombre de la Colonia',
	MunicipioDelegacion		VARCHAR(50)		NOT NULL COMMENT 'Nombre del Municipio',
	Localidad				VARCHAR(50)		NOT NULL COMMENT 'Nombre de la Localidad',
	Estado					VARCHAR(50)		NOT NULL COMMENT 'Nombre del Estado',
	CodigoPostal			CHAR(5)			NOT NULL COMMENT 'Codigo Postal',
	RFC						VARCHAR(13)		NOT NULL COMMENT 'RFC del Cliente',
	DireccionCompleta		VARCHAR(500)	NOT NULL COMMENT 'Direccion Completa del Cliente',
	FechaGeneracion			DATE			NOT NULL COMMENT 'Fecha Generacion de Registros',
	RegHacienda				CHAR(1)			NOT NULL COMMENT 'Especifica si el cliente esta registrado en Hacienda\nS.- Si\nN.- No',
	ComisionTotalAhorro		DECIMAL(12,2)	NOT NULL COMMENT 'Total de Comisiones por Cuenta de Ahorro',
	ComisionTotalCredito	DECIMAL(12,2)	NOT NULL COMMENT 'Total de Comision por Creditos',
	PDFGenerado				CHAR(1)			NOT NULL COMMENT 'N=PDF no Generado\nS= PDF Generado Antes de timbrado\nD= PDF Generado despues del timbrado',
	FolioProceso			BIGINT(12)		NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
	EmpresaID 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria',
PRIMARY KEY(AnioMes, SucursalID, ClienteID, FolioProceso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='historico Datos del cliente de estado de cuenta'$$
