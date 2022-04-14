DELIMITER ;
DROP TABLE IF EXISTS `HIS-EDOCTAV2HEADERCRE`;
DELIMITER $$


CREATE TABLE `HIS-EDOCTAV2HEADERCRE` (
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	SucursalID	 			INT(11) 		NOT NULL COMMENT 'Numero de surcusal del cliente',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	CreditoID				BIGINT(12)		NOT NULL COMMENT 'Identificacion de credito',
	ProducCreditoID			INT(11)			NOT NULL COMMENT 'Identificador del producto de credito de la tabla PRODUCTOSCREDITO',
	NombreProducto			VARCHAR(50)		NOT NULL COMMENT 'Nombre del producto, Descripcion de la tabla PRODUCTOSCREDITO',
	ImporteCredito			DECIMAL(18,2)	NOT NULL COMMENT 'importe del credito, MontoCredito de la tabla SALDOSCREDITOS',
	FechaVencimiento		DATE			NOT NULL COMMENT 'Fecha de vencimiento, FechaVencimiento de la tabla SALDOSCREDITOS',
	SaldoInsoluto			DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Insoluto, SALDOSCREDITOS (SalCapVigente + SalCapAtrasado + SalCapVencido + SalCapVenNoExi) DONDE FechaCorte = Cierre Mes',
	SaldoInicial			DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Inicial, la suma de los campos: SalCapVigente\nSalCapAtrasado\nSalCapVencido\nSalCapVenNoExi\nSalIntOrdinario\nSalIntAtrasado\nSalIntVencido\nSalIntProvision\nSalIntNoConta\nSalMoratorios\nSaldoMoraVencido\nSaldoMoraCarVen\nSalComFaltaPago\nSalOtrasComisi\n de SALDOSCREDITO',
	PagoAmortizaciones		VARCHAR(25)		NOT NULL COMMENT 'Se obtiene de SALDOSCREDITO juntando CuotasPagadas y  NumAmortizacion',
	CAT						DECIMAL(12,2)	NOT NULL COMMENT 'Valor del CAT,  Se obtiene de SALDOSCREDITO',
	TasaOrdinaria			DECIMAL(12,2)	NOT NULL COMMENT 'Tasa Ordinaria, TasaFija de SALDOSCREDITOS',
	TasaMoratoria			DECIMAL(12,2)	NOT NULL COMMENT 'Tasa Moratoria',
	InteresPagados			DECIMAL(12,2)	NOT NULL COMMENT 'Interes Pagados',
	MontTotalComPag			DECIMAL(12,2)	NOT NULL COMMENT 'Monto total de las comisiones pagadas',
	IVATotalComPag			DECIMAL(12,2)	NOT NULL COMMENT 'IVA total de las comisiones pagadas',
	FechaProxPag			DATE			NOT NULL COMMENT 'Fecha a realizar el proximo pago, se obtienes de SALDOSCREDITOS',
	CapitalProxpago			DECIMAL(12,2)	NOT NULL COMMENT 'capital proximo pago, se obtiene de SALDOSCREDITOS',
	InteresProxPago			DECIMAL(12,2)	NOT NULL COMMENT 'interes proximo pago, se obtiene de SALDOSCREDITOS',
	IvaProxPago				DECIMAL(12,2)	NOT NULL COMMENT 'iva proximo pago, se obtiene de SALDOSCREDITOS',
	FolioProceso			BIGINT(12)		NOT NULL COMMENT 'Se genera cuando se ejecuta el estado de cuenta',
	EmpresaID 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	Usuario 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	FechaActual 			DATETIME 		NOT NULL COMMENT 'Parametro de Auditoria',
	DireccionIP 			VARCHAR(15) 	NOT NULL COMMENT 'Parametro de Auditoria',
	ProgramaID 				VARCHAR(50) 	NOT NULL COMMENT 'Parametro de Auditoria',
	Sucursal 				INT(11) 		NOT NULL COMMENT 'Parametro de Auditoria',
	NumTransaccion 			BIGINT(20)		NOT NULL COMMENT 'Parametro de Auditoria',
PRIMARY KEY(AnioMes, ClienteID, SucursalID, CreditoID, FolioProceso)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='historico de la cabecera de credito'$$
