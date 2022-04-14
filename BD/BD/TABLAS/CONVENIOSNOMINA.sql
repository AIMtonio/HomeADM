-- Creacion de tabla CONVENIOSNOMINA

DELIMITER ;

DROP TABLE IF EXISTS `CONVENIOSNOMINA`;

DELIMITER $$

CREATE TABLE `CONVENIOSNOMINA` (
	`ConvenioNominaID` 		BIGINT UNSIGNED	NOT NULL COMMENT 'Identificador del convenio',
	`InstitNominaID` 		INT(11) 		NOT NULL COMMENT 'Empresa de nomina a la cual pertenece el convenio',
	`Descripcion` 			VARCHAR(150) 	NOT NULL COMMENT 'Descripcion del convenio de Nomina',
	`FechaRegistro` 		DATE 			NOT NULL COMMENT 'Fecha de registro del convenio',
	`ManejaVencimiento` 	CHAR(1) 		NOT NULL COMMENT 'Indica si se manejara o no una fecha de vencimiento para el convenio S = "S" , N= "NO"',
	`FechaVencimiento` 		DATE 			NOT NULL COMMENT 'Fecha de vencimiento del convenio si el campo ManejaVencimiento tiene el valor S',
	`DomiciliacionPagos` 	CHAR(1) 		NOT NULL COMMENT 'Forma de cobro para la aplicacion de pagos a facturas de un credito.\nS - Los creditos otorgados a este convenio se les cobrara comision por falta de pago si el producto de credito tiene parametrizado un esquema de comision por falta de pago\nN - No se cobrara comision por falta de pago',
	`ClaveConvenio` 		VARCHAR(20) 	NOT NULL COMMENT 'Clave o numero de convenio contratado',
	`Estatus` 				CHAR(1) 		NOT NULL COMMENT 'A - Activo, S - Suspendido, V - Vencido',
	`Resguardo`         	DECIMAL(12,2) 	NOT NULL COMMENT 'campo utilizado para la capacidad de pago',
	`RequiereFolio` 		CHAR(1) 		NOT NULL COMMENT 'Requiere Folio de la solicitud de Credito',
	`ManejaQuinquenios` 	CHAR(1) 		NOT NULL COMMENT 'Se validan los quinquenios que lleva trabajado el cliente, S="SI", N="NO"',
	`NumActualizaciones` 	INT(11) 	   	NOT NULL COMMENT 'Consecutivo de Actualizaciones a la configuracion del convenio ',
	`UsuarioID`           	INT(11) 		NOT NULL COMMENT 'ID de Usuario del Ejecutivo encargado del convenio',
	`CorreoEjecutivo`     	TEXT      		NOT NULL COMMENT 'Correo del Ejecutivo',
	`Comentario`          	TEXT(150)     	NOT NULL COMMENT 'Comentarios adicionales al convenio',
	`ManejaCapPago`       	CHAR(1)  		NOT NULL COMMENT 'Considera la capacidad de pago para el convenio que se esté parametrizando, S= "SI", N="NO',
	`FormCapPago`			VARCHAR(200)	NOT NULL COMMENT 'Formula para las solictudes del flujo individual',
	`DesFormCapPago`		VARCHAR(500)	NOT NULL COMMENT 'Descripcion del Formula para las solictudes del flujo individual',
	`FormCapPagoRes`		VARCHAR(200)	NOT NULL COMMENT 'Formula para las solictudes del flujo renovacion, restructura o consolidacion',
	`DesFormCapPagoRes`		VARCHAR(500)	NOT NULL COMMENT 'Descripcion del Formula para las solictudes del flujo renovacion, restructura o consolidacion',
	`ManejaCalendario`    	CHAR(1)  		NOT NULL COMMENT 'Indica si maneja calendario  S = "SI", N = "NO"',
	`ReportaIncidencia`		CHAR(1)			NOT NULL DEFAULT 'N' COMMENT 'Indica si el convenio de la nomina puede reportar incidencias. Se puede marcar como N: No reporta incidencias. S: Si reporta incidencias.',
	`ManejaFechaIniCal`   	CHAR(1)  		NOT NULL COMMENT 'Indica si maneja fecha inicial S="SI", N = "NO"',
	`NoCuotasCobrar` 		INT(11) 		DEFAULT NULL COMMENT 'Indica hasta cuantas cuotas puede cobrar cuando un credito tenga amortizaciones (facturas) atrasadas',
    `Referencia` 			VARCHAR(20) 	NOT NULL COMMENT 'Numero Referencia para la recepcion de los depositos del convenio',
    `CobraComisionApert` 	CHAR(1)			NOT NULL COMMENT 'Cobra comisión por apertura',
    `CobraMora`				CHAR(1) 		NOT NULL COMMENT 'Cobra interés moratorio',
	`EmpresaID` 			INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
	`Usuario` 				INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
	`FechaActual` 			DATETIME 		NOT NULL COMMENT 'Campo de Auditoria',
	`DireccionIP` 			VARCHAR(15)	 	NOT NULL COMMENT 'Campo de Auditoria',
	`ProgramaID` 			VARCHAR(50) 	NOT NULL COMMENT 'Campo de Auditoria',
	`Sucursal` 				INT(11) 		NOT NULL COMMENT 'Campo de Auditoria',
	`NumTransaccion` 		BIGINT(20) 		NOT NULL COMMENT 'Campo de Auditoria',
	PRIMARY KEY (`ConvenioNominaID`),
	KEY `INDEX_CONVENIOSNOMINA_1` (`InstitNominaID`),
	CONSTRAINT `FK_CONVENIOSNOMINA_1` FOREIGN KEY (`InstitNominaID`) REFERENCES `INSTITNOMINA` (`InstitNominaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar el los convenios de las empresas de nomina'$$