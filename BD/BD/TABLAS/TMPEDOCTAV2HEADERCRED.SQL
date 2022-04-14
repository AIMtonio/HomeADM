DELIMITER ;
DROP TABLE IF EXISTS `TMPEDOCTAV2HEADERCRED`;
DELIMITER $$

CREATE TABLE `TMPEDOCTAV2HEADERCRED` (
	AnioMes 				INT(11) 		NOT NULL COMMENT 'Anio y mes para generar Estado de cuenta',
	CreditoID				BIGINT(12)		NOT NULL COMMENT 'Identificacion de credito',
	SucursalID	 			INT(11) 		NOT NULL COMMENT 'Numero de surcusal del cliente',
	ClienteID 				INT(11) 		NOT NULL COMMENT 'Numero de cliente',
	ProductoCreditoID		INT(11)			NOT NULL COMMENT 'Identificador del producto de credito de la tabla PRODUCTOSCREDITO',
	NombreProducto			VARCHAR(50)		NOT NULL COMMENT 'Nombre del producto, Descripcion de la tabla PRODUCTOSCREDITO',
	ImporteCredito			DECIMAL(18,2)	NOT NULL COMMENT 'importe del credito, MontoCredito de la tabla SALDOSCREDITOS',
	FechaVencimiento		DATE			NOT NULL COMMENT 'Fecha de vencimiento, FechaVencimiento de la tabla SALDOSCREDITOS',
	SaldoInsoluto			DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Insoluto, SALDOSCREDITOS (SalCapVigente + SalCapAtrasado + SalCapVencido + SalCapVenNoExi) DONDE FechaCorte = Cierre Mes',
	SaldoInicial			DECIMAL(14,2)	NOT NULL COMMENT 'Saldo Inicial, la suma de los campos: SalCapVigente\nSalCapAtrasado\nSalCapVencido\nSalCapVenNoExi\nSalIntOrdinario\nSalIntAtrasado\nSalIntVencido\nSalIntProvision\nSalIntNoConta\nSalMoratorios\nSaldoMoraVencido\nSaldoMoraCarVen\nSalComFaltaPago\nSalOtrasComisi\n de SALDOSCREDITO',
	PagoAmortizaciones		VARCHAR(25)		NOT NULL COMMENT 'Se obtiene de SALDOSCREDITO juntando CuotasPagadas y NumAmortizacion',
	CAT						DECIMAL(12,2)	NOT NULL COMMENT 'Valor del CAT,  Se obtiene de SALDOSCREDITO',
	TasaOrdinaria			DECIMAL(12,2)	NOT NULL COMMENT 'Tasa Ordinaria, TasaFija de SALDOSCREDITOS',
	TasaMoratoria			DECIMAL(12,2)	NOT NULL COMMENT 'Tasa Moratoria',
	PagoIntOrdMes			DECIMAL(18,2)	DEFAULT '0.00'	COMMENT 'Monto de Intereses Ordinarios pagadas en el Mes',
	PagoIVAIntOrdMes		DECIMAL(18,2)	DEFAULT '0.00'	COMMENT 'Monto de IVA de Intereses Ordinarios pagadas en el Mes',
	PagoMoraMes				DECIMAL(18,2)	DEFAULT '0.00'	COMMENT 'Monto de Interes Moratorio pagado en el Mes',
	PagoIVAMoraMes			DECIMAL(18,2)	DEFAULT '0.00'	COMMENT 'Monto de IVA de Interes Moratorio pagado en el Mes',
	PagoComisiMes			DECIMAL(18,2)	DEFAULT '0.00'	COMMENT 'Monto de Comisiones pagadas en el Mes',
	PagoIVAComisiMes		DECIMAL(18,2)	DEFAULT '0.00'	COMMENT 'Monto de IVA de Comisiones pagadas en el Mes',
	FechaProxPag			DATE			NOT NULL COMMENT 'Fecha a realizar el proximo pago, se obtienes de SALDOSCREDITOS',
	FechaProxPagLey			VARCHAR(30)		NOT NULL COMMENT 'Fecha a realizar el proximo pago, en formato de Texto, cuando el credito presenta atraso se muestra la leyenda INMEDIATO',
	CapitalProxpago			DECIMAL(14,2)	NOT NULL COMMENT 'capital proximo pago, se obtiene de SALDOSCREDITOS',
	InteresProxPago			DECIMAL(14,2)	NOT NULL COMMENT 'interes proximo pago, se obtiene de SALDOSCREDITOS',
	IvaProxPago				DECIMAL(14,2)	NOT NULL COMMENT 'iva proximo pago, se obtiene de SALDOSCREDITOS',
	OtrCargosProxPago		DECIMAL(14,2)	NOT NULL COMMENT 'Otros Cargos para Proximo Pago, solo tien valor cuando existen cuotas atrasadas con comisinoes y mora',
	IVAOtrCargosProxPago	DECIMAL(14,2)	NOT NULL COMMENT 'IVA de Otros Cargos para Proximo Pago, solo tien valor cuando existen cuotas atrasadas con comisinoes y mora',
	PRIMARY KEY (CreditoID),
	INDEX INDEX_TMPEDOCTAV2HEADERCRED_1 (AnioMes, CreditoID),
	INDEX INDEX_TMPEDOCTAV2HEADERCRED_2 (ClienteID),
	INDEX INDEX_TMPEDOCTAV2HEADERCRED_3 (CreditoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para obtener la cabecera de creditos y que sirve para llenar la tabla principal EDOCTAV2HEADERCRED'$$


