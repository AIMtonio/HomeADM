-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
--  RESCONSOLIDACIONCARTALIQ
DELIMITER ;
DROP TABLE IF EXISTS RESCONSOLIDACIONCARTALIQ;

DELIMITER $$

CREATE TABLE RESCONSOLIDACIONCARTALIQ (
	TranRespaldo		BIGINT(20) 		NOT NULL 				COMMENT 'Numero de Transaccion',
	ConsolidaCartaID	INT(11) 		NOT NULL				COMMENT 'Consecutivo de consolidación de acuerdo con la solicitud de crédito',
	ClienteID			INT(11)			NOT NULL				COMMENT 'Identificador del cliente',
	SolicitudCreditoID	BIGINT(20)		NOT NULL DEFAULT 0		COMMENT 'Número de Solicitud de Crédito',
	Estatus				CHAR(1)			NOT NULL 				COMMENT 'Estatus para indicar si la consolidación asociada a la solicitud de crédito esta activa o inactiva: A = Activa, I = Inactiva.',
	EsConsolidado		CHAR(1)			NOT NULL DEFAULT 'S'	COMMENT	'Indica si la solicitud proviene de una consolidación. S.- Si, N.- No',
	FlujoOrigen			CHAR(1)			NOT NULL DEFAULT 'C'	COMMENT	'Indica el flujo por el que nace la solicitu de crédito C.- Flujo Consolidación',
	TipoCredito			CHAR(1)			NOT NULL DEFAULT 'N'	COMMENT 'Indica el tratamiento al credito N=nuevo, O=renovacion',
	Relacionado			BIGINT(20)		NOT NULL DEFAULT 0		COMMENT 'Crédito Origen si la consolidación es renovación',
	MontoConsolida		decimal(14,2)	NOT NULL DEFAULT 0		COMMENT 'Monto acumulado de las cartas consolidadas',

	CreditoID					BIGINT(12)		NOT NULL DEFAULT 0 			COMMENT 'ID del Credito Consolidado',
	FechaRegistro				DATE 			NULL DEFAULT '1900-01-01' 	COMMENT 'Fecha de Registro.',
	EstatusCredito				CHAR(1)			NULL DEFAULT ''				COMMENT 'Estatus del Credito anterior al momento de hacer la Consolidacion',
	EstatusCreacion				CHAR(1)			NULL DEFAULT '' 			COMMENT 'Estatus contable con que nace el Crédito. \nV.-Vigente \nB.-Vencido',
	NumDiasAtraso				INT(11)			NULL DEFAULT 0 				COMMENT 'Numero de Dias de Atraso del Credito a Consolidar',
	NumPagoSoste				INT(11)			NULL DEFAULT 0 				COMMENT 'Numero de Pagos Sostenidos para Regularizacion',
	NumPagoActual				INT(11)			NULL DEFAULT 0 				COMMENT 'Numero de Pagos Sostenidos Realizados Actualmente',
	Regularizado				CHAR(1)			NULL DEFAULT '' 			COMMENT 'Indica si ya se Regularizo o No de acuerdo a los pagos Sostenidos. ,\nN.- NO \n\SI',
	FechaRegularizacion			DATE 			NULL DEFAULT '1900-01-01' 	COMMENT 'Fecha de Regularizacion de acuerdo a los pagos sostenidos',
	ReservaInteres				DECIMAL(14,2) 	NULL DEFAULT 0.0 			COMMENT 'Monto de la Estimaciones Preventivas por el Saldo del Interés en Cuentas de Orden',
	FechaLimiteReporte			DATE 			NULL DEFAULT '1900-01-01' 	COMMENT 'Fecha de Repor te de Dias de Atraso',

	EmpresaID			INT(11)			NOT NULL 				COMMENT 'Campo de Auditoria',
	Usuario				INT(11)			NOT NULL 				COMMENT 'Campo de Auditoria',
	FechaActual			DATETIME		NOT NULL 				COMMENT 'Campo de Auditoria',
	DireccionIP			VARCHAR(15)		NOT NULL 				COMMENT 'Campo de Auditoria',
	ProgramaID			VARCHAR(50)		NOT NULL 				COMMENT 'Campo de Auditoria',
	Sucursal			INT(11)			NOT NULL 				COMMENT 'Campo de Auditoria',
	NumTransaccion		BIGINT(20)		NOT NULL 				COMMENT 'Campo de Auditoria',
	PRIMARY KEY ( TranRespaldo, CreditoID ),
	KEY IDX_RESREGCRECONSOLIDADOS_01 (FechaRegistro),
	KEY IDX_RESREGCRECONSOLIDADOS_02 (FechaRegularizacion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de respaldo para los pagos consolidados'
$$