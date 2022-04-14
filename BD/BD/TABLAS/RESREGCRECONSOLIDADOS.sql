-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESREGCRECONSOLIDADOS
DELIMITER ;
DROP TABLE IF EXISTS RESREGCRECONSOLIDADOS;

DELIMITER $$
CREATE TABLE RESREGCRECONSOLIDADOS (
	TranRespaldo			BIGINT(20) 	NOT NULL COMMENT 'Numero de Transaccion',
	CreditoID				BIGINT(12)	NOT NULL COMMENT 'ID del Credito Consolidado',
	FechaRegistro			DATE 		NOT NULL COMMENT 'Fecha de Registro.',
	EstatusCredito			CHAR(1)		NOT NULL COMMENT 'Estatus del Credito anterior al momento de hacer la Consolidacion',
	EstatusCreacion			CHAR(1)		NOT NULL COMMENT 'Estatus contable con que nace el Crédito. \nV.-Vigente \nB.-Vencido',

	NumDiasAtraso			INT(11)		NOT NULL COMMENT 'Numero de Dias de Atraso del Credito a Consolidar',
	NumPagoSoste			INT(11)		NOT NULL COMMENT 'Numero de Pagos Sostenidos para Regularizacion',
	NumPagoActual			INT(11)		NOT NULL COMMENT 'Numero de Pagos Sostenidos Realizados Actualmente',
	Regularizado			CHAR(1)		NOT NULL COMMENT 'Indica si ya se Regularizo o No de acuerdo a los pagos Sostenidos. \nN.- NO \n\SI',
	FechaRegularizacion		DATE 		NOT NULL COMMENT 'Fecha de Regularizacion de acuerdo a los pagos sostenidos',

	ReservaInteres			DECIMAL(14,2) NOT NULL COMMENT 'Monto de la Estimaciones Preventivas por el Saldo del Interés en Cuentas de Orden',
	FechaLimiteReporte		DATE 		NOT NULL COMMENT 'Fecha de Reporte de Dias de Atraso',

	EmpresaID				INT(11)		NOT NULL COMMENT 'Parámetro de auditoría ID de la Empresa',
	Usuario					INT(11)		NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual				DATETIME	NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP				VARCHAR(15)	NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID				VARCHAR(50)	NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal				INT(11)		NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion			BIGINT(20)	NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY ( TranRespaldo, CreditoID ),
	KEY IDX_RESREGCRECONSOLIDADOS_01 (CreditoID),
	KEY IDX_RESREGCRECONSOLIDADOS_02 (FechaRegistro),
	KEY IDX_RESREGCRECONSOLIDADOS_03 (FechaRegularizacion)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Respaldo de pago Creditos Consolidados.'$$
