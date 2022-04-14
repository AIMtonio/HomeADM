-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORAOPERACION
DELIMITER ;
DROP TABLE IF EXISTS TC_BITACORAOPERACION;

DELIMITER $$
CREATE TABLE TC_BITACORAOPERACION (
	RespaldoID					BIGINT(20)		NOT NULL COMMENT 'ID de Tabla',
	TipoMensaje					CHAR(4)			NOT NULL COMMENT 'Tipo Mensaje de la Transaccion:\n1200 \n1210 Transacción Normal ATMs y POS\n1220\n1230  Transacción Forzada POS (se debe aplicar el cobro)\n1400\n1410 Transacción Reverso ATMs\n1420\n1430 Transacción Reverso ATMs y POS (Prosa)',
	NumberTransaction			CHAR(6)			NOT NULL COMMENT 'Tipo de Operacion de Tarjeta',
	ProdIndicator				CHAR(2)			NOT NULL COMMENT 'Indicador de Producto( limitado a 2 caracteres (01 - ATM, 02 - POS))',
	TranCode					CHAR(2)			NOT NULL COMMENT 'Codigo de transacción( limitado a 2 caracteres. ISO8583 - DE3 Field 1 (PROSA)',

	CardNumber					CHAR(16)		NOT NULL COMMENT 'Numero de Tarjeta de Credito',
	TransactionAmount			DECIMAL(12,2)	NOT NULL COMMENT 'Monto en pesos de la transaccion',
	CashbackAmount				DECIMAL(12,2)	NOT NULL COMMENT 'Montos de CashBack',
	AdditionalAmount			DECIMAL(12,2)	NOT NULL COMMENT 'Montos de Comisiones',
	SurchargeAmounts			DECIMAL(12,2)	NOT NULL COMMENT 'Monto de Recargos, para retiros de Efectivo',

	TransactionDate				DATETIME		NOT NULL COMMENT 'Fecha y Hora de la operacion',
	MerchantType				CHAR(4)			NOT NULL COMMENT 'Giro del comercio valores aceptados(Catalogo)',
	Reference					CHAR(12)		NOT NULL COMMENT 'Referencia de la operacion',
	TerminalID					CHAR(16)		NOT NULL COMMENT 'ID de la terminal - TPV o ATM(limitado a 16 caracteres. ISO8583 - DE37 (PROSA))',
	TerminalName				CHAR(50)		NOT NULL COMMENT 'Nombre del comercio donde se realizo la operacion(limitado a 50 caracteres.  ISO8583 - DE43.1 (PROSA))',

	TerminalLocation			CHAR(50)		NOT NULL COMMENT 'Datos de la localidad de la terminal(limitado a 50 caracteres.  ISO8583 - DE43.2 (PROSA))',
	AuthorizationNumber			CHAR(6)			NOT NULL COMMENT 'Numero de referencia de autorizacion(limitado a 6 caracteres.)',
	DraftCapture 				CHAR(1)			NOT NULL COMMENT 'Indicador de Captura de la transaccion',
	ReferenceTransaction		CHAR(12)		NOT NULL COMMENT 'Referencia de la operacion original',
	ApplicationDate				DATETIME		NOT NULL COMMENT 'Fecha de Aplicacion de la reversa',

	AmountDispensed				DECIMAL(12,2)	NOT NULL COMMENT 'Para reversar parciales de ATM',
	CodigoTransaccionID			CHAR(6)			NOT NULL COMMENT 'Numero de referencia de autorizacion(limitado a 6 caracteres.)',
	FechaHrRespuesta			DATETIME		NOT NULL COMMENT 'Fecha y Hora de Respuesta de Transaccion',
	NumTransResp				BIGINT(20)		NOT NULL COMMENT 'Numero de Transaccion generado por el core',
	Balance						DECIMAL(12,2)	NOT NULL COMMENT 'Saldo deudor de la Linea de Crédito',

	BalanceAvailable			DECIMAL(12,2)	NOT NULL COMMENT 'Saldo Disponible de la Linea de Crédito',
	FolioDevolucionID			BIGINT(20)		NOT NULL COMMENT 'Numero de Devolucion(ID de Tabla)',
	EsCheckIn					CHAR(1)			NOT NULL COMMENT 'Es una Operacion de Check In o ReCheck In\nS.-SI\N,.NO',
	EsReversa					CHAR(1)			NOT NULL COMMENT 'Es una Operacion de Reversa\nS.-SI\N,.NO',

	EmpresaID					INT(11)			NOT NULL COMMENT 'ID de la empresa',
	Usuario						INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual					DATETIME		NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP					VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID					VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal					INT(11)			NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion				BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (RespaldoID),
	KEY INDEX_TC_BITACORAOPERACION_1 (NumberTransaction),
	KEY INDEX_TC_BITACORAOPERACION_2 (ProdIndicator),
	KEY INDEX_TC_BITACORAOPERACION_3 (TranCode),
	KEY INDEX_TC_BITACORAOPERACION_4 (CardNumber),
	KEY INDEX_TC_BITACORAOPERACION_5 (MerchantType),
	KEY INDEX_TC_BITACORAOPERACION_6 (Reference),
	KEY INDEX_TC_BITACORAOPERACION_7 (DraftCapture),
	KEY INDEX_TC_BITACORAOPERACION_8 (CodigoTransaccionID),
	KEY INDEX_TC_BITACORAOPERACION_9 (FolioDevolucionID),
	KEY INDEX_TC_BITACORAOPERACION_10 (EsReversa)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla de Respaldo Para las Tarjetas de Crédito'$$