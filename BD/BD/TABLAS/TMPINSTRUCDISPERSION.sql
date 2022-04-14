DELIMITER ;
DROP TABLE IF EXISTS TMPINSTRUCDISPERSION;

DELIMITER $$
CREATE TABLE TMPINSTRUCDISPERSION (
	ConsecutivoID		INT(11)			NOT NULL			COMMENT 'Consecutivo de Instrucciones',
	CreditoID			BIGINT(12)		NOT NULL			COMMENT 'Número de Solicitud de crédito',
	BenefiDisperID		INT(11)			NOT NULL			COMMENT 'Consecutivo del beneficiario de acuerdo con la solicitud de credito',
	TipoDispersionID	CHAR(1)			NULL				COMMENT 'Tipo de Dispersion: S .- SPEI, C .- Cheque O .- Orden de Pago 	E.- Efectivo, T.- TRAN. SANTANDER',
	TipoCuentaDisper	INT(11)			NULL	DEFAULT 1	COMMENT 'Tipo Cuenta Dispersion 1.- Instruccion Nueva , 2.- Instruc. de Carta Liq. Externas, 3.- Instruc. de Carta Liq. Interna',
	MontoDispersion		DECIMAL(12,2)	NULL				COMMENT 'Monto a Dispersar para el Beneficiario',
	EstatusDispersion	CHAR(1)			DEFAULT NULL		COMMENT 'Estatus con respecto a la Dispersion .\nD: Dispersada \n N: No Dispersada',
	EstatusImportacion	CHAR(1)			DEFAULT NULL		COMMENT 'Estatus con respecto a la Importacion de Dispersion .\nS: si Importada \n N: No Importada',
	FolioOperacion      INT(11)     	DEFAULT NULL          COMMENT 'ID o referencia de la operación de la dispersion',
	ClaveDispMov        INT(11)    	NOT NULL DEFAULT '0'  COMMENT 'Consecutivo de la tabla de movimientos',

	EmpresaID			INT(11)			NULL				COMMENT 'Campo de Auditoria',
	Usuario				INT(11)			NULL				COMMENT 'Campo de Auditoria',
	FechaActual			DATETIME		NULL				COMMENT 'Campo de Auditoria',
	DireccionIP			VARCHAR(15)		NULL				COMMENT 'Campo de Auditoria',
	ProgramaID			VARCHAR(50)		NULL				COMMENT 'Campo de Auditoria',
	Sucursal			INT(11)			NULL				COMMENT 'Campo de Auditoria',
	NumTransaccion		BIGINT(20)		NULL DEFAULT NULL	COMMENT 'Campo de Auditoria',
	PRIMARY KEY (ConsecutivoID, BenefiDisperID, CreditoID)
)ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Almacena la informacion de las intrucciones de dispersion de un crédito'$$