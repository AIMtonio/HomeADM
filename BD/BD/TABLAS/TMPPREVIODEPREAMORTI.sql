-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPPREVIODEPREAMORTI`;

DELIMITER $$
CREATE TABLE TMPPREVIODEPREAMORTI(
	ConsecutivoID			INT(11)			NOT NULL COMMENT 'Número de Consecutico',
	ActivoID				INT(11)			NOT NULL COMMENT 'Número de Activo',
	TipoActivoID			INT(11)			NOT NULL COMMENT 'Número de Tipo de Activo',
	DescTipoActivo			VARCHAR(350)	NOT NULL COMMENT 'Descripción del Tipo de Activo',
	DescActivo				VARCHAR(350)	NOT NULL COMMENT 'Descripción del Activo',

	FechaAdquisicion		DATE			NOT NULL COMMENT 'Fecha de Adquisición del Activo',
	NumFactura				VARCHAR(50)		NOT NULL COMMENT 'Número de Factura',
	Poliza					BIGINT(12)		NOT NULL COMMENT 'Número de Póliza',
	CentroCostoID			INT(11)			NOT NULL COMMENT 'Número del Centro de Costos',
	CentroCosto 			VARCHAR(350)	NOT NULL COMMENT 'Descripción del Centro de Costos',

	Moi						DECIMAL(16,2)	NOT NULL COMMENT 'Monto Origen de la Inversión',
	InpcInicial				DECIMAL(16,3)	NOT NULL COMMENT 'INPC Inicial del Activo',
	InpcActual				DECIMAL(16,3)	NOT NULL COMMENT 'INPC al Mes Fin de la fecha corte del Reporte',
	FactorActualizacion		DECIMAL(16,3)	NOT NULL COMMENT 'Factor de Actualización',
	DepreciaContaAnual		DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación Contable Anual del Activo',

	PorDepreContaAnual		DECIMAL(16,2)	NOT NULL COMMENT 'Porcentaje de Depreciación Contable Anual del Activo',
	DepreciaFiscalAnual		DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación Fiscal Anual del Activo',
	PorDepreFiscalAnual		DECIMAL(16,2)	NOT NULL COMMENT 'Porcentaje de Depreciación Fiscal Anual del Activo',
	TiempoAmortiMeses		INT(11)			NOT NULL COMMENT 'Tiempo de Depreciación del Activo',
	MontoAnio				TEXT			NOT NULL COMMENT 'Monto Anual',

	Enero					DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Enero',
	Febrero					DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Febrero',
	Marzo					DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Marzo',
	Abril					DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Abril',
	Mayo					DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Mayo',

	Junio					DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Junio',
	Julio					DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Julio',
	Agosto					DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Agosto',
	Septiembre				DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Septiembre',
	Octubre					DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Octubre',

	Noviembre				DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Noviembre',
	Diciembre				DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación al Mes de Diciembre',
	DepreciadoAcumulado		DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación Acumulado',
	SaldoPorDepreciar		DECIMAL(16,2)	NOT NULL COMMENT 'Saldo por Depreciar',
	TipoReg					CHAR(1)			NOT NULL COMMENT 'Tipo de Registro. \nT: Total \nN:Normal',

	Monto 					DECIMAL(16,2)	NOT NULL COMMENT 'Monto de Validación',
	DepFiscalSaldoInicial	DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación Fiscal Saldo Inicial',
	DepFiscalSaldoFinal		DECIMAL(16,2)	NOT NULL COMMENT 'Depreciación Fiscal Saldo Final',

	EmpresaID				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Empresa',
	Usuario					INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID del Usuario',
	FechaActual				DATETIME		NOT NULL COMMENT 'Parámetro de auditoria Fecha actual',
	DireccionIP				VARCHAR(15)		NOT NULL COMMENT 'Parámetro de auditoria Direccion IP ',

	ProgramaID				VARCHAR(50)		NOT NULL COMMENT 'Parámetro de auditoria Programa ID',
	Sucursal				INT(11)			NOT NULL COMMENT 'Parámetro de auditoria ID de la Sucursal',
	NumTransaccion			BIGINT(20)		NOT NULL COMMENT 'Parámetro de auditoria Número de la transacción',
	PRIMARY KEY (`NumTransaccion`,`ConsecutivoID`,`ActivoID`),
	KEY `IDX_TMPPREVIODEPREAMORTI_1` (`NumTransaccion`),
	KEY `IDX_TMPPREVIODEPREAMORTI_2` (`ActivoID`),
	KEY `IDX_TMPPREVIODEPREAMORTI_3` (`TipoActivoID`),
	KEY `IDX_TMPPREVIODEPREAMORTI_4` (`CentroCostoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla Temporal Física para generar los reportes Contables, Fiscales de depreciación de activos.'$$