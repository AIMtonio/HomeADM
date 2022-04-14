-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCASTIGOSAGRO
DELIMITER ;
DROP TABLE IF EXISTS TMPCASTIGOSAGRO;

DELIMITER $$
CREATE TABLE TMPCASTIGOSAGRO (
	RegistroID			INT(11) NOT NULL COMMENT 'No de Registro',
	TransaccionID		BIGINT(20) NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	CreditoID			BIGINT(12) NOT NULL COMMENT 'No Crédito',
	AmortizacionID		INT(4) NOT NULL COMMENT 'No Amortización',
	SaldoCapVigente		DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros',
	SaldoCapAtrasa		DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Atrasado, en el alta nace con ceros',
	SaldoCapVencido		DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido, en el alta nace con ceros',
	SaldoCapVenNExi		DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible, en al alta nace con ceros',
	SaldoInteresOrd		DECIMAL(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Ordinario, en el alta nace con ceros',
	SaldoInteresAtr		DECIMAL(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado, en el alta nace con ceros',
	SaldoInteresVen		DECIMAL(14,4) DEFAULT NULL COMMENT 'Saldos de Interes Vencido, en el alta nace con ceros',
	SaldoInteresPro		DECIMAL(14,4) DEFAULT NULL COMMENT 'Saldo de Provision, en el alta nace con ceros',
	SaldoIntNoConta		DECIMAL(12,4) DEFAULT NULL COMMENT 'Saldo de Interes No Contabilizado',
	SaldoMoratorios		DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo Moratorios, en el alta nace con ceros',
	SaldoComFaltaPa		DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo Comision Falta Pago, en el alta nace con ceros',
	SaldoComServGar		DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision por Servicio de Garantia Agro',
	SaldoOtrasComis		DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo Otras Comisiones, en el alta nace con ceros',
	MonedaID			INT(11) DEFAULT NULL COMMENT 'Numero de Moneda',
	FechaInicio			DATE DEFAULT NULL COMMENT 'Fecha de Inicio de la Amortización',
	FechaVencim			DATE DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Amortización',
	FechaExigible		DATE DEFAULT NULL COMMENT 'Moneda',
	Estatus				CHAR(1) DEFAULT NULL COMMENT 'Estatus del Crédito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nA.- Autorizado\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nK.- Castigado',
	SaldoMoraVencido	DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
	SaldoMoraCarVen		DECIMAL(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
	EmpresaID			INT(11) NOT NULL COMMENT 'ID de la empresa',
	Usuario				INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID del usuario',
	FechaActual			DATETIME NOT NULL COMMENT 'Parámetro de auditoría Fecha actual',
	DireccionIP			VARCHAR(15) NOT NULL COMMENT 'Parámetro de auditoría Dirección IP',
	ProgramaID			VARCHAR(50) NOT NULL COMMENT 'Parámetro de auditoría Programa',
	Sucursal			INT(11) NOT NULL COMMENT 'Parámetro de auditoría ID de la Sucursal',
	NumTransaccion		BIGINT(20) NOT NULL COMMENT 'Parámetro de auditoría Número de la Transacción',
	PRIMARY KEY (`RegistroID`,`TransaccionID`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp. Tabla Temporal para el proceso de castigo de Crédito Agropecuario'$$