DELIMITER ;
DROP TABLE IF EXISTS TMPBENEFIDISPER;

DELIMITER $$
CREATE TABLE TMPBENEFIDISPER (
	ConsecutivoID		INT(11)			NOT NULL			COMMENT 'Consecutivo de Instrucciones',
	SolicitudCreditoID	BIGINT(12) 		NOT NULL			COMMENT 'Número de Solicitud de crédito',
	BenefiDisperID		INT(11)			NULL				COMMENT 'Consecutivo del beneficiario de acuerdo con la solicitud de credito',
	TipoDispersionID	CHAR(1)			NULL				COMMENT 'Tipo de Dispersion: S .- SPEI, C .- Cheque O .- Orden de Pago 	E.- Efectivo, T.- TRAN. SANTANDER',
	Beneficiario		VARCHAR(250)	NULL				COMMENT 'Nombre del Beneficiario',
	Cuenta				VARCHAR(20)		NULL				COMMENT 'Cuenta del Beneficiario para la Dispersion',
	MontoDispersion		DECIMAL(12,2) 	NULL				COMMENT 'Monto a Dispersar para el Beneficiario',
	TipoCuentaDisper	INT(11)			NULL	DEFAULT 1	COMMENT 'Tipo Cuenta Dispersion 1.- Instruccion Nueva , 2.- Instruc. de Carta Liq. Externas, 3.- Instruc. de Carta Liq. Interna',

	InstitucionID		INT(11) 		NULL 				COMMENT 'Institucion',
	TipoCuentaSpei 		INT(2) 			NULL 				COMMENT 'Tipo de Cuenta de Envio para SPEI ',
	RFC 				CHAR(13)  		NULL 				COMMENT 'Registro Federal de Contribuyentes',

	EmpresaID			INT(11)			NULL				COMMENT 'Campo de Auditoria',
	Usuario				INT(11)			NULL				COMMENT 'Campo de Auditoria',
	FechaActual			DATETIME		NULL				COMMENT 'Campo de Auditoria',
	DireccionIP			VARCHAR(15)		NULL				COMMENT 'Campo de Auditoria',
	ProgramaID			VARCHAR(50)		NULL				COMMENT 'Campo de Auditoria',
	Sucursal			INT(11)			NULL				COMMENT 'Campo de Auditoria',
	NumTransaccion		BIGINT(20)		NOT NULL			COMMENT 'Campo de Auditoria',
	PRIMARY KEY (ConsecutivoID, SolicitudCreditoID, NumTransaccion)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Almacena la informacion de las intrucciones de dispersion de un crédito'$$