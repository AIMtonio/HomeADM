-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEICUENTASCLABEPFISICAHIS
DELIMITER ;
DROP TABLE IF EXISTS `SPEICUENTASCLABEPFISICAHIS`;
DELIMITER $$


CREATE TABLE SPEICUENTASCLABEPFISICAHIS (
	CuentaClabePFisicaID			INT(11)				NOT NULL	COMMENT 'Identificador de la tabla.',
	ClienteID						INT(11)				NOT NULL	COMMENT 'ID del Cliente (UNE con tabla CLIENTES)',
	TipoInstrumento					CHAR(2)				NOT NULL	COMMENT 'Tipo de Instrumento (CH = Cuenta de Ahorro, CR = Credito)',
	Instrumento 					BIGINT(12)			NOT NULL	COMMENT 'ID del Instrumento dependiendo del TipoInstrumento',
	CuentaClabe						VARCHAR(18)			NOT NULL	COMMENT 'Cuenta Clabe a registrar ante STP',
	FechaCreacion					DATE				NOT NULL	COMMENT 'Fecha de creacion de la cuenta clabe.',
	Estatus							CHAR(1)				NOT NULL	COMMENT 'Estatus de autorizacion de la Cuenta Clabe (I = Inactiva, P = Pendiente de autorizacion, A = Autorizada, B = Baja)',
	Comentario						VARCHAR(300)		NOT NULL 	COMMENT 'Comentario de baja',
	PIDTarea						VARCHAR(50)			NOT NULL	COMMENT 'ID del Hilo de tarea para el Demonio.',
	Nombre							VARCHAR(150)			NOT NULL	COMMENT 'Nombre del Cliente',
	ApellidoPaterno					VARCHAR(50)			NOT NULL	COMMENT 'Apellido Paterno del Cliente',
	ApellidoMaterno					VARCHAR(50)			NOT NULL	COMMENT 'Apellido Materno del Cliente',
	EmpresaSTP						VARCHAR(15)			NOT NULL	COMMENT 'Nombre de la empresa con la que fue dada de alta la cuenta ante STP.',
	RFC								VARCHAR(18)			NOT NULL	COMMENT 'RFC del Cliente.',
	CURP							VARCHAR(18)			NOT NULL	COMMENT 'Clave Única de Registro de Población (CURP) del Cliente.',
	Genero							CHAR(1)				NOT NULL	COMMENT 'Determina el genero de la persona dueña de la cuenta, ya sea hombre o mujer (M = Mujer, H = Hombre).',
	FechaNacimiento					DATE 				NOT NULL	COMMENT 'Tiempo especificado por el día, el mes y el año en que nació la persona.',
	EstadoID						INT(11)				NOT NULL	COMMENT 'ID del estado de la republica (Une con ESTADOSREPUB).',
	Calle 							VARCHAR(60)			NOT NULL	COMMENT 'Calle de la direccion oficial del cliente',
	NumExterior 					VARCHAR(10)			NOT NULL	COMMENT 'Numero exterior de la direccion oficial del cliente',
	NumInterior						VARCHAR(15)			NOT NULL	COMMENT 'Numero interior de la direccion oficial del cliente',
	CodigoPostal					VARCHAR(5)			NOT NULL	COMMENT 'Codigo postal de la direccion oficial del cliente',
	ClavePaisNacSTP					INT(11)				NOT NULL	COMMENT 'Clave de Pais de nacimiento del Catalogo de STP',
	CorreoElectronico				VARCHAR(50)			NOT NULL	COMMENT 'Correo electronico del cliente',
	Identificacion					VARCHAR(20)			NOT NULL	COMMENT 'Numero de credencial para votar del Cliente (IFE/INE).',
	Telefono						VARCHAR(20)			NOT NULL	COMMENT 'Telefono fijo o celular perteneciente al cliente.',
	Firma							VARCHAR(1000)		NOT NULL	COMMENT 'Firma encriptada por la transferencia.',
	IDRespuesta						INT(11)				NOT NULL	COMMENT 'ID de la respuesta del WS de STP para registro de Cuenta Clabe persona fisica (0 = El proceso se ejecuto de manera correcta, > 0 Ocurrio un error durante el procesamiento)',
	DescripcionRespuesta			VARCHAR(256)		NOT NULL	COMMENT 'Descripcion de la respuesta del WS de STP para registro de Cuenta Clabe persona fisica',
	NumIntentos 					INT(11) 			NOT NULL 	COMMENT 'Numero de veces que se ha intentado realizar el alta de cuenta clabe a STP',
	
	EmpresaID						INT(11)				NOT NULL 	COMMENT 'Parametro de auditoria ID de la empresa',
	Usuario							INT(11)				NOT NULL 	COMMENT 'Parametro de auditoria ID del usuario',
	FechaActual						DATETIME			NOT NULL 	COMMENT 'Parametro de auditoria Fecha actual',
	DireccionIP						VARCHAR(15)			NOT NULL 	COMMENT 'Parametro de auditoria Dirección IP',
	ProgramaID						VARCHAR(50)			NOT NULL 	COMMENT 'Parametro de auditoria Programa',
	Sucursal						INT(11)				NOT NULL 	COMMENT 'Parametro de auditoria ID de la sucursal',
	NumTransaccion					BIGINT(20)			NOT NULL 	COMMENT 'Parametro de auditoria Número de la transacción',
	
	PRIMARY KEY (CuentaClabePFisicaID),
	CONSTRAINT `FK_SPEICUENTASCLABEPFISICAHIS_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
	CONSTRAINT `FK_SPEICUENTASCLABEPFISICAHIS_2` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='HIS: Tabla historica donde se almacenan las Cuentas Clabe para STP de personas fisicas.'$$
