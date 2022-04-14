-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS TMPACTIVOS;

DELIMITER $$
CREATE TABLE TMPACTIVOS (
	RegistroID				BIGINT(20)		NOT NULL COMMENT 'ID de Registro',
	TransaccionID			BIGINT(20)		NOT NULL COMMENT 'Número de Transacción',
	ConsecutivoCliente 		INT(11)			NOT NULL COMMENT 'ID de Consecutivo del Cliente',
	TipoActivoID			INT(11)			NOT NULL COMMENT 'ID de TIPOSACTIVOS',
	Descripcion				VARCHAR(350)	NOT NULL COMMENT 'Descripcion larga del tipo de activo',

	FechaAdquisicion		DATE			NOT NULL COMMENT 'Fecha de Adquisición del Activo',
	NumFactura				VARCHAR(50)		NOT NULL COMMENT 'Numero de factura',
	NumSerie				VARCHAR(100)	NOT NULL COMMENT 'Numero de serie',
	Moi						DECIMAL(16,2)	NOT NULL COMMENT 'Monto Original Inversion(MOI)',
	DepreciadoAcumulado		DECIMAL(16,2)	NOT NULL COMMENT 'Depreciado Acumulado',

	TotalDepreciar			DECIMAL(16,2)	NOT NULL COMMENT 'Total por Depreciar',
	MesesUsos				INT(11)			NOT NULL COMMENT 'Meses a amortizar del activo',
	PolizaFactura			BIGINT(12)		NOT NULL COMMENT 'Poliza Factura',
	CentroCostoID			INT(11)			NOT NULL COMMENT 'Centro de Costo',
	CuentaContable			CHAR(25)		NOT NULL COMMENT 'Cuenta Contable',

	CuentaContableRegistro	CHAR(50)		NOT NULL COMMENT 'Cuenta Contable Registro',
	PorDepFiscal			DECIMAL(16,2)	NOT NULL COMMENT 'Porcentaje de depreciación fiscal para el activo.',
	DepFiscalSaldoInicio	DECIMAL(16,2)	NOT NULL COMMENT 'Saldo inicial de acuerdo a la depreciación fiscal.',
	DepFiscalSaldoFin		DECIMAL(16,2)	NOT NULL COMMENT 'Saldo final de acuerdo a la depreciación fiscal.',

	EmpresaID				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID del Usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoria Direccion IP ',
	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoria Programa ID',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoria Número de la transacción',
	PRIMARY KEY (RegistroID, TransaccionID),
	KEY IDX_TMPACTIVOS_1 (TransaccionID),
	KEY IDX_TMPACTIVOS_2 (ConsecutivoCliente),
	KEY IDX_TMPACTIVOS_3 (TipoActivoID),
	KEY IDX_TMPACTIVOS_4 (CentroCostoID),
	KEY IDX_TMPACTIVOS_5 (CuentaContable)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los Registros a ser evaluados previo al proceso de alta de Activos'$$
