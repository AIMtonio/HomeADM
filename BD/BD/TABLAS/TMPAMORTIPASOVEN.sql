-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORTIPASOVEN
DELIMITER ;
DROP TABLE IF EXISTS `TMPAMORTIPASOVEN`;

DELIMITER $$
CREATE TABLE `TMPAMORTIPASOVEN` (
	CreditoID			BIGINT(12)		NOT NULL COMMENT 'Número de Crédito.',
	TMPID				INT(11)			NOT NULL COMMENT 'Número de Registro.',
	AmortizacionID		INT(11)			NOT NULL COMMENT 'Número de Amortización.',
	FechaInicio			DATE			NOT NULL COMMENT 'Fecha de Inicio de la Amortización.',
	FechaVencim			DATE			NOT NULL COMMENT 'Fecha de Vencimiento de la Amortización.',
	FechaExigible		DATE			NOT NULL COMMENT 'Fecha de Exigibilidad de la Amortización.',
	SaldoCapVigente		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Capital Vigente.',
	SaldoCapAtrasa		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Capital Atrasado.',
	SaldoCapVencido		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Capital Vencido.',
	SaldoCapVenNExi		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Capital Vencido No Exigible.',
	EmpresaID			INT(11)			NOT NULL COMMENT 'Número de Empresa.',
	SaldoCapVigent		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Capital Vigente.',
	SaldoCapAtrasad		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Capital Atrasado.',
	SaldoCapVencidoCre	DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Capital Vencido.',
	SaldCapVenNoExi		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Capital Vencido no Exigible.',
	SaldoInterOrdin		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Interés Ordinario.',
	MonedaID			INT(11)			NOT NULL COMMENT 'Número de Moneda.',
	EstatusCre			CHAR(1)			NOT NULL COMMENT 'Estatus de Crédito.',
	ProductoCreditoID	INT(11)			NOT NULL COMMENT 'Producto de Crédito.',
	EstatusAmo			CHAR(1)			NOT NULL COMMENT 'Estatus de la Amortización.',
	SucursalOrigen		INT(11)			NOT NULL COMMENT 'Sucursal Origen del Cliente.',
	Clasificacion		CHAR(1)			NOT NULL COMMENT 'Clasificación del Destino de Crédito.',
	SaldoInteresAtr		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Interés Atrasado.',
	EsReestructura		CHAR(1)			NOT NULL COMMENT 'Es Crédito Reestructurado',
	EstatusCreacion		CHAR(1)			NOT NULL COMMENT 'Estatus de Creación del Crédito Reestructurado.',
	Regularizado		CHAR(1)			NOT NULL COMMENT 'Es Crédito Regularizado',
	SaldoInteresPro		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Interes Provisionado del Crédito.',
	SubClasifID			INT(11)			NOT NULL COMMENT 'SubClasificacion ID del Crédito.',
	SucursalID			INT(11)			NOT NULL COMMENT 'Sucursal ID del Crédito.',
	SaldoMoratorios		DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Moratorio',
	Transaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
KEY `IDX_TMPAMORTIPASOVEN_1` (`CreditoID`, `TMPID`, `Transaccion`),
KEY `IDX_TMPAMORTIPASOVEN_2` (`TMPID`),
KEY `IDX_TMPAMORTIPASOVEN_3` (`Transaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla de Temporal de Apoyo para el Paso a Vencido de Cartera Agro'$$