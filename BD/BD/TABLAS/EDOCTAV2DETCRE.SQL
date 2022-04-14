DELIMITER ;
DROP TABLE IF EXISTS EDOCTAV2DETCRE;

DELIMITER $$

CREATE TABLE EDOCTAV2DETCRE (
	EdoCtaDetalleCredID		BIGINT(12)		NOT NULL AUTO_INCREMENT,
	FolioProceso			BIGINT(12)		NOT NULL COMMENT 'ID de Procesamiento o de ejecucion del estado de cuenta, Se genera cuando se ejecuta el estado de cuenta',
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	CreditoID				BIGINT(12)		NOT NULL COMMENT 'Identificacion de credito',
	AmortiCreID				INT(5)			NOT NULL COMMENT 'Numero de Amortizacion a la que esta relacionada el movimiento',
	SucursalID	 			INT(11) 		NOT NULL COMMENT 'Numero de surcusal del cliente',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	FechaOperacion			DATE			NOT NULL COMMENT 'Fecha en la que se realizo la Operacion o Movimiento de Credito',
	Referencia				VARCHAR(50)		NOT NULL COMMENT 'Referencia de la Operacion ',
	Concepto				VARCHAR(150)	NOT NULL COMMENT 'Concepto de la Operacion Realizada',
	Cargo 					DECIMAL(14,2)   NOT NULL COMMENT 'Monto de Cargo del movimiento de la operacion',
	Abono 					DECIMAL(14,2)   NOT NULL COMMENT 'Monto de Abono del movimiento de la operacion',
	Orden					INT(11)			NOT NULL COMMENT 'Orden en el que se mostraran los movimientos en la seccion de Detalle de credito',
	Transaccion 			BIGINT(12)		NOT NULL COMMENT 'Numero de Transaccion Extraido de los movimientos, cuando se agrupan se toma el MAX',
	EmpresaID 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY (EdoCtaDetalleCredID),
	INDEX INDEX_EDOCTAV2DETCRE_1 (Orden),
	INDEX INDEX_EDOCTAV2DETCRE_2 (ClienteID),
	INDEX INDEX_EDOCTAV2DETCRE_3 (CreditoID),
	INDEX INDEX_EDOCTAV2DETCRE_4 (FolioProceso),
	INDEX INDEX_EDOCTAV2DETCRE_5 (Transaccion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Movimientos del credito corresponde a la seccion de Detalle de Creditos'$$
