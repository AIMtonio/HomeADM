-- EDOCTAV2HEADERCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2HEADERCREDPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2HEADERCREDPRO`(
	-- SP PARA OBTENER EL HEADER O ENCABEZADO DE CREDITOS PARA LA SECCION DE DETALLE DE CREDITO
	Par_Salida              CHAR(1),		-- Indica si el error lo regresa en un select o no
    INOUT   Par_NumErr      INT(11),        -- parametros de control de errores indica el numero de Error
    INOUT   Par_ErrMen		VARCHAR(400),   -- parametros de control de errores manda el mesnaje del error

    /* paramtros de auditoria */
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;						-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);					-- Entero Cero
	DECLARE	Moneda_Cero					INT(11);					-- Decimal Cero
	DECLARE NoProcesado					INT(11);					-- Numero Proceso: 1
	DECLARE Entero_Uno					SMALLINT;					-- Entero 1
	DECLARE NoEsInversion				CHAR(1);					-- Cuenta no es inversion: N
	DECLARE EsInversion					CHAR(1);					-- Cuenta es inversion: S
	DECLARE EstatusActiva				CHAR(1);					-- Estatus de la cuenta: ACTIVA
	DECLARE EstatusCancelado			CHAR(1);					-- Estatus de la cuenta: CANCELADA
	DECLARE EstatusBloqueado			CHAR(1);					-- Estatus de la cuenta: BLOQUEADA
	DECLARE EstatusInactiva				CHAR(1);					-- Estatus de la cuenta: INACTIVA
	DECLARE EstatusAtrasado				CHAR(1);					-- Estatus Atrasado
	DECLARE EstatusRegistrada			CHAR(1);					-- Estatus de la cuenta: REGISTRADA
	DECLARE Con_StaVigente				CHAR(1);					-- Estatus de la inversion: VIGENTE
	DECLARE Con_StaVencido				CHAR(1);					-- Estatus de la inversion: VENCIDO
	DECLARE Con_StaPagado				CHAR(1);					-- Estatus de la inversion: PAGADO
	DECLARE Con_StaCancelado			CHAR(1);					-- Estatus de la inversion: CANCELADO
	DECLARE EstatusVigente				CHAR(1);					-- Estatus del Credito Vigente
	DECLARE EstatusVencido				CHAR(1);					-- Estatus del Credito Vencido
	DECLARE EstatusCastigado 			CHAR(1);					-- Estatus del Credito Castigado
	DECLARE EstatusPagado 				CHAR(1);					-- Estatus del Credito Pagado
	DECLARE EstatusEliminado			CHAR(1);					-- Estatus del Credito Eliminado
	DECLARE LeyendaPagado				VARCHAR(50);				-- Leyenda Pagado

		-- DECLARACION DE VARIABLES
	DECLARE Var_FecIniMes				DATE;						-- Fecha inicial del Periodo a procesar
	DECLARE Var_FecFinMes				DATE;						-- Fecha final del Periodo a Procear
	DECLARE Var_FechaSaldosIni			DATE;						-- Fecha corte para obtener los registros de saldo inicial de SALDOSCREDITOS
	DECLARE Var_FechaSaldosFin			DATE;						-- Fecha corte para obtener los registros de saldo Final de SALDOSCREDITOS
	DECLARE Var_FolioProceso			BIGINT(20);					-- Folio de procesamiento
	DECLARE Var_AnioMes					INT(11);					-- Año Mes a procesar
	DECLARE Var_TipCobTasaFija			CHAR(1);					-- Tipo de cobro de comision de mora - Tasa Fija
	DECLARE Var_TipCobFacMora			CHAR(1);					-- Tipo de cobro de comision de mora - N veces factor mora
	DECLARE Var_SI						CHAR(1);					-- Constante S : Si
	DECLARE Var_NO						CHAR(1);					-- Constante N : No
	DECLARE Var_UltimoDiaMes			DATE;

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';						-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';			-- Fecha Vacia
	SET Entero_Cero						:= 0;						-- Entero Cero
	SET Moneda_Cero						:= 0.00;					-- Decimal Cero
	SET NoProcesado						:= 1; 						-- Numero Proceso: 1
	SET Entero_Uno						:= 1;						-- Entero 1
	SET NoEsInversion					:= 'N';						-- No es cuenta de inversion
	SET EsInversion						:= 'S';						-- Es una cuenta de inversion
	SET EstatusActiva					:= 'A';						-- Estatus de la cuenta: ACTIVA
	SET EstatusCancelado				:= 'C';						-- Estatus de la cuenta: CANCELADA
	SET EstatusBloqueado				:= 'B';						-- Estatus de la cuenta: BLOQUEADA
	SET EstatusInactiva					:= 'I';						-- Estatus de la cuenta: INACTIVA
	SET EstatusRegistrada				:= 'R';						-- Estatus de la cuenta: REGISTRADA
	SET Con_StaVigente					:= 'N';						-- Estatus de la inversion: VIGENTE
	SET Con_StaVencido    				:= 'V';						-- Estatus de la inversion: VENCIDO
	SET Con_StaPagado					:= 'P';						-- Estatus de la inversion: PAGADO
	SET Con_StaCancelado				:= 'C';						-- Estatus de la inversion: CANCELADO
	SET EstatusVigente					:= 'V';						-- Estatus Credito: VIGENTE
	SET EstatusVencido					:= 'B';						-- Estatus Credito: VENCIDO
	SET EstatusCastigado 				:= 'K';						-- Estatus Credito: CASTIGADO
	SET EstatusPagado 					:= 'P';						-- Estatus Credito: PAGADO
	SET EstatusAtrasado					:= 'A';						-- Estatus Credito: ATRASADO
	SET EstatusEliminado				:= 'E';						-- Estatus Credito: ATRASADO
	SET LeyendaPagado					:= 'PAGADO';				-- Leyenda Pagado
	SET Var_TipCobTasaFija				:= 'T';						-- Tipo de cobro de comision de mora - Tasa Fija
	SET Var_TipCobFacMora				:= 'N';						-- Tipo de cobro de comision de mora - N veces factor mora
	SET Var_SI							:= 'S';						-- Constante S : Si
	SET Var_NO							:= 'N';						-- Constante N : No

ManejoErrores:BEGIN     -- bloque para manejar los posibles errores
				DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
					SET Par_NumErr      = 999;
					SET Par_ErrMen      = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
												 'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2HEADERCREDPRO');

				END;

				SET Par_Salida	:=		IFNULL(Par_Salida, Var_NO);
				SET Par_NumErr	:=		IFNULL(Par_NumErr, Entero_Cero);



				SELECT	MesProceso, FechaInicio, FechaFin,  FolioProceso
				INTO	Var_AnioMes, Var_FecIniMes, Var_FecFinMes, Var_FolioProceso
				FROM	EDOCTAV2PARAMS
				LIMIT	Entero_Uno;

				SET Var_FolioProceso 	:= IFNULL(Var_FolioProceso, Entero_Cero);

				DROP TABLE IF EXISTS TMP_MEM_SALDOSCREDITOS;
				CREATE TABLE `TMP_MEM_SALDOSCREDITOS` (	  	`CreditoID`				BIGINT(12)		NOT NULL DEFAULT '0'	COMMENT 'ID del Credito',
															`FechaCorte`			DATE 			NOT NULL				COMMENT 'Fecha de Corte',
															`SalCapVigente`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Capital Vigente',
															`SalCapAtrasado`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Capital Atrasado',
															`SalCapVencido`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Capital Vencido',
															`SalCapVenNoExi`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Capital Vencido no Exigible',
															`SalIntOrdinario`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Interes Ordinario',
															`SalIntAtrasado`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Interes Atrasado',
															`SalIntVencido`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Interes Vencido',
															`SalIntProvision`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Provision',
															`SalIntNoConta`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Interes no Contabilizado',
															`SalMoratorios`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Moratorios',
															`SaldoMoraVencido`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
															`SaldoMoraCarVen`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
															`SalComFaltaPago`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Comision Falta Pago',
															`SalOtrasComisi`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Comision Otras Comisiones',
															`SaldoComisionAnual`	DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Comision por Anualidad',
															`SaldoSeguroCuota`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Saldo Seguro Cuota',
															`SalIVAInteres`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Iva Interes',
															`SalIVAMoratorios`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Iva Moratorios',
															`SalIVAComFalPago`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Iva Comision Falta Pago',
															`SalIVAComisi`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Iva Otras Comisiones',
															`SaldoComisionAnualIVA`	DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Iva Comision por Anualidad',
															`SaldoIVASeguroCuota`	DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo Iva Seguro Cuota',
															`PasoCapAtraDia`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto Capital que paso a Atrasado dia de hoy',
															`PasoCapVenDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto Capital que paso a Vencido dia de hoy',
															`PasoCapVNEDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto Capital que paso a VNE dia de hoy',
															`PasoIntAtraDia`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto Interes que paso a Atrasado dia de hoy',
															`PasoIntVenDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto Interes que paso a Vencido dia de hoy',
															`CapRegularizado`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto del Capital Regularizado al dia',
															`IntOrdDevengado`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de interes Ordinario Devengado',
															`IntMorDevengado`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de interes Moratorio Devengado',
															`ComisiDevengado`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de Comision por Falta de Pago',
															`PagoCapVigDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de Capital Vigente del Dia',
															`PagoCapAtrDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de Capital Atrasado del Dia',
															`PagoCapVenDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de Capital Vencido del Dia',
															`PagoCapVenNexDia`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de Capital VNE del Dia',
															`PagoIntOrdDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de Interes Ordinario del Dia',
															`PagoIntVenDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de Interes  Vencido del Dia',
															`PagoIntAtrDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de Interes  Atrasado del Dia',
															`PagoIntCalNoCon`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de Interes No Contabilizado del Dia',
															`PagoComisiDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de Interes No Comisiones del Dia',
															`PagoMoratorios`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de\nMoratorio del Dia',
															`PagoIvaDia`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Pagos de IVAS del Dia',
															`IntCondonadoDia`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Interes Codonado\nDel Dia',
															`MorCondonadoDia`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Moratorios\nCodonados\nDel Dia',
															`DiasAtraso`			INT(11)			DEFAULT '0'				COMMENT 'Numero de Dias de Atraso Al Dia',
															`NoCuotasAtraso`		INT(11)			DEFAULT '0'				COMMENT 'Numero de Cuotas en Atraso al Dia',
															`MaximoDiasAtraso`		INT(11)			DEFAULT NULL			COMMENT 'Numero de Maximo Dias de atraso, historico',
															`LineaCreditoID`		BIGINT(20)		DEFAULT NULL			COMMENT 'Id de linea de Credito',
															`ClienteID`				INT(11)			DEFAULT NULL			COMMENT 'Id de cliente',
															`MonedaID`				INT(11)			DEFAULT NULL			COMMENT 'Id de moneda',
															`FechaInicio`			DATE			DEFAULT NULL			COMMENT 'Fecha de Inicio',
															`FechaVencimiento`		DATE			DEFAULT NULL			COMMENT 'Fecha Vencimiento',
															`FechaExigible`			DATE			DEFAULT NULL			COMMENT 'Fecha Exigibilidad',
															`FechaLiquida`			DATE			DEFAULT NULL			COMMENT 'Fecha Liquidación',
															`ProductoCreditoID`		INT(11)			DEFAULT NULL			COMMENT 'id de producto',
															`SolicitudCreditoID`	BIGINT(12) 		DEFAULT '0'				COMMENT 'ID de la solicitud de Credito Asociado al Credito',
															`TipoCredito`			CHAR(1) 		DEFAULT ''				COMMENT 'Indica el tratamiento al credito \nN=nuevo, \nR=reestructura, \nO=renovacion',
															`PlazoID`				VARCHAR(20) 	DEFAULT ''				COMMENT 'Plazo del credito',
															`TasaFija`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Tasa fija anual que fue pactada con el credito.',
															`TasaBase`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Tasa Base anualizada, esto solo aplica en caso que el credito maneje tasa variable',
															`SobreTasa`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Sobre tasa que le aplica a la tasa base, esto solo si fue pactada una sobre tasa en el credito.',
															`PisoTasa`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Piso tasa que le aplica a la tasa base, esto solo si fue pactada una sobre tasa en el credito.',
															`TechoTasa`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Techo tasa que le aplica a la tasa base, esto solo si fue pactada una sobre tasa en el credito.',
															`TipoCartera`			VARCHAR(2) 		DEFAULT ''				COMMENT 'Se refiere el tipo de cartera que corresponde el crédito conforme a su origen (reestructurada, renovada, normal):\nNO = Normal \nRE = Reestructura \nRN = Renovada.',
															`TipCobComMorato`		CHAR(1) 		DEFAULT ''				COMMENT 'Campo que indica como se generan los moratorios:\nN = Indica que la mora se calcula con N veces la tasa ordinaria \nT = Indica que es una tasa fija para el calculo de moratorios.',
															`FactorMora`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Factor de Moratorio',
															`CreditoOrigen`			VARCHAR(200) 	DEFAULT ''				COMMENT 'Numero de credito de acuerdo a SAFI. Es el credito a reestructurar o a renovar según sea el caso, es decir, credito que se va a liquidar con la renovación o la reestrutura.',
															`ConGarPrenda`			CHAR(1) 		DEFAULT ''				COMMENT 'Requiere Garantia Prendaria(mobiliaria)',
															`ConGarLiq`				CHAR(1) 		DEFAULT ''				COMMENT 'Requiere Garantia liquida',
															`TotalParticipantes`	INT(11) 		DEFAULT '0'				COMMENT 'Total Participantes del Credito o Solicitud Credito',
															`FechaProximoPago`		DATE			DEFAULT '1900-01-01'	COMMENT 'Fecha de Proximo Pago inmediato',
															`MontoProximoPago`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de Proximo Pago inmediato',
															`EstatusCredito`		CHAR(1)			DEFAULT NULL			COMMENT 'Estatus credito al cierre de mes',
															`SaldoPromedio`			DECIMAL(14,2)	DEFAULT NULL			COMMENT 'Monto Original Credito',
															`MontoCredito`			DECIMAL(14,2)	DEFAULT NULL,
															`FrecuenciaCap`			CHAR(1)			DEFAULT NULL,
															`PeriodicidadCap`		INT(11)			DEFAULT NULL			COMMENT 'Periodicidad',
															`FrecuenciaInt`			CHAR(1)			DEFAULT NULL			COMMENT 'Frecuencia de Pago de las Amortizaciones de Interes\\\nS .- Semanal, C .- Catorcenal Q .- Quincenal M .- Mensual P .- Periodo\\\nB.-Bimestral  T.-Trimestral  R.-TetraMestral E.-Semestral  A.-Anual',
															`PeriodicidadInt`		INT(11)			DEFAULT NULL,
															`NumAmortizacion`		INT(11)			DEFAULT NULL			COMMENT 'Numero de Amortizaciones o Cuotas',
															`FechTraspasVenc`		DATE			DEFAULT NULL			COMMENT 'Fecha de Traspaso a Vencido',
															`FechAutoriza`			DATE			DEFAULT NULL,
															`ClasifRegID`			INT(11)			DEFAULT NULL			COMMENT 'Clasificacion Segun Reportes Regulatorios',
															`DestinoCreID`			INT(11)			DEFAULT NULL,
															`Calificacion`			CHAR(2)			DEFAULT NULL			COMMENT 'Calificacion de Cartera',
															`PorcReserva`			DECIMAL(14,2)	DEFAULT NULL			COMMENT 'Porcentaje de Reserva',
															`TipoFondeo`			CHAR(1)			DEFAULT NULL			COMMENT 'Tipo de Fondeo:\nP .- Recursos Propios\nF .- Institucion de Fondeo',
															`InstitFondeoID`		INT(11)			DEFAULT NULL			COMMENT 'Insitucion de Fondeo, puede no escoger linea de fondeo',
															`IntDevCtaOrden`		DECIMAL(14,2)	DEFAULT NULL			COMMENT 'Interes Devengado de Cartera Vencida, \nCuentas de Orden',
															`CapCondonadoDia`		DECIMAL(14,2)	DEFAULT NULL			COMMENT 'Capital Condonado del Dia',
															`ComAdmonPagDia`		DECIMAL(14,2)	DEFAULT NULL			COMMENT 'Comision por Admon, Pagad en el Dia',
															`ComCondonadoDia`		DECIMAL(14,2)	DEFAULT NULL			COMMENT 'Comision Condonado en el Dia',
															`DesembolsosDia`		DECIMAL(14,2)	DEFAULT NULL			COMMENT 'Comision Condonado en el Dia',
															`CapVigenteExi`			DECIMAL(14,2)	DEFAULT NULL			COMMENT 'Capital vigente exigible',
															`MontoTotalExi`			DECIMAL(14,2)	DEFAULT NULL			COMMENT 'Monto total exigible',
															`SaldoParaFiniq` 		DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Monto para Finiquitar el Credito',
															`CuotasPagadas`			INT(11)			DEFAULT '0.00'			COMMENT 'Numero de cuotas pagadas del credito',
															`ValorCAT`				DECIMAL(12,4)	DEFAULT '0.00'			COMMENT 'Valor de CAT que tiene el credito',
															`CapitalProxPago`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Capital a Pagar en el Proximo Pago',
															`InteresProxPago`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Interes Ordinario a pagar en el Proximo Pago',
															`IvaProxPago`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'IVA nominal de Intereses a pagar en el Proximo Pago',
															`SalInteresExigible`	DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Interes Exigible, Tendra valor cuando el credito tiene al menos una cuota de atraso',
															`IVAInteresExigible`	DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'IVA nominal de Interes Exigible, Tendra valor cuando el credito tiene al menos una cuota de atraso',
															`PagoIntOrdMes`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de Intereses Ordinarios pagadas en el Mes',
															`PagoIVAIntOrdMes`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de IVA de Intereses Ordinarios pagadas en el Mes',
															`PagoMoraMes`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de Interes Moratorio pagado en el Mes',
															`PagoIVAMoraMes`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de IVA de Interes Moratorio pagado en el Mes',
															`PagoComisiMes`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de Comisiones pagadas en el Mes',
															`PagoIVAComisiMes`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de IVA de Comisiones pagadas en el Mes',
															`OtrosCargosApagar`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto que suma Moratorios y Comisiones',
															`IVAOtrosCargosApagar`	DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de IVA de la suma de Moratorios y Comisiones',
														  PRIMARY KEY (FechaCorte, CreditoID),
														  KEY `IDX_TMP_MEM_SALDOSCREDITOS_1` (`FechaCorte`) USING BTREE,
														  KEY `IDX_TMP_MEM_SALDOSCREDITOS_2_CredFechaAplica` (`CreditoID`,`FechaCorte`),
														  KEY `IDX_TMP_MEM_SALDOSCREDITOS_3_Credito` (`CreditoID`),
														  KEY `IDX_TMP_MEM_SALDOSCREDITOS_4_EstatCred` (`EstatusCredito`),
														  KEY `TMP_MEM_SALDOSCREDITOS_5_FechaEstat` (`FechaCorte`,`EstatusCredito`)
														) ENGINE=MEMORY DEFAULT CHARSET=latin1 COMMENT='TMP en Memoria de Saldos Diarios de Credito';


				TRUNCATE TABLE TMPEDOCTAV2HEADERCRED;

				-- Se insertan los mismos registros que se tienen en el Resumen del credito
				INSERT INTO TMPEDOCTAV2HEADERCRED	(	AnioMes,				CreditoID,				SucursalID,				ClienteID,				ProductoCreditoID,
														NombreProducto,			ImporteCredito,			FechaVencimiento,		SaldoInsoluto,			SaldoInicial,
														PagoAmortizaciones,		CAT,					TasaOrdinaria,			TasaMoratoria,			PagoIntOrdMes,
														PagoIVAIntOrdMes,		PagoMoraMes,			PagoIVAMoraMes,			PagoComisiMes,			PagoIVAComisiMes,
														FechaProxPag,			FechaProxPagLey,		CapitalProxpago,		InteresProxPago,		IvaProxPago,
														OtrCargosProxPago,		IVAOtrCargosProxPago)
				SELECT									AnioMes,				CreditoID,				SucursalID,				ClienteID,				ProductoCreditoID,
														Producto,				Entero_Cero,			Fecha_Vacia,			SaldoInsoluto,			Entero_Cero,
														Entero_Cero,			Entero_Cero,			Entero_Cero,			Entero_Cero,			Entero_Cero,
														Entero_Cero,			Entero_Cero,			Entero_Cero,			Entero_Cero,			Entero_Cero,
														FechaProxPago,			FechaLeyenda,			Entero_Cero,			Entero_Cero,			Entero_Cero,
														Entero_Cero,			Entero_Cero
				FROM	EDOCTAV2RESUMCREDITOS
				WHERE 	FolioProcesoID  = Var_FolioProceso;

				-- Se obtiene la fecha para consultar los saldos iniciales del periodo
				SELECT		MAX(FechaCorte)
				INTO	Var_FechaSaldosIni
				FROM	SALDOSCREDITOS
				WHERE	FechaCorte < Var_FecIniMes;

				-- Se obtiene la ultima fecha corte registrada en los saldos de credito en el rango de fechas de corte
				SELECT		MAX(FechaCorte)
				INTO	Var_FechaSaldosFin
				FROM	SALDOSCREDITOS
				WHERE	FechaCorte >= Var_FecIniMes
				  AND	FechaCorte <= Var_FecFinMes;

				SET Var_UltimoDiaMes := (select DATE_SUB(Var_FecIniMes,INTERVAL 1 day));
				SET Var_FechaSaldosIni :=IFNULL(Var_FechaSaldosIni, Var_UltimoDiaMes);

				-- se inserta el universo de registros de Saldos creditos en la tabla de Memoria para agilizar las consultas
				INSERT INTO TMP_MEM_SALDOSCREDITOS
				SELECT 	CreditoID,				FechaCorte,				SalCapVigente,				SalCapAtrasado,			SalCapVencido,
						SalCapVenNoExi,			SalIntOrdinario,		SalIntAtrasado,				SalIntVencido,			SalIntProvision,
						SalIntNoConta,			SalMoratorios,			SaldoMoraVencido,			SaldoMoraCarVen,		SalComFaltaPago,
						SalOtrasComisi,			SaldoComisionAnual,		SaldoSeguroCuota,			SalIVAInteres,			SalIVAMoratorios,
						SalIVAComFalPago,		SalIVAComisi,			SaldoComisionAnualIVA,		SaldoIVASeguroCuota,	PasoCapAtraDia,
						PasoCapVenDia,			PasoCapVNEDia,			PasoIntAtraDia,				PasoIntVenDia,			CapRegularizado,
						IntOrdDevengado,		IntMorDevengado,		ComisiDevengado,			PagoCapVigDia,			PagoCapAtrDia,
						PagoCapVenDia,			PagoCapVenNexDia,		PagoIntOrdDia,				PagoIntVenDia,			PagoIntAtrDia,
						PagoIntCalNoCon,		PagoComisiDia,			PagoMoratorios,				PagoIvaDia,				IntCondonadoDia,
						MorCondonadoDia,		DiasAtraso,				NoCuotasAtraso,				MaximoDiasAtraso,		LineaCreditoID,
						ClienteID,				MonedaID,				FechaInicio,				FechaVencimiento,		FechaExigible,
						FechaLiquida,			ProductoCreditoID,		SolicitudCreditoID,			TipoCredito,			PlazoID,
						TasaFija,				TasaBase,				SobreTasa,					PisoTasa,				TechoTasa,
						TipoCartera,			TipCobComMorato,		FactorMora,					CreditoOrigen,			ConGarPrenda,
						ConGarLiq,				TotalParticipantes,		FechaProximoPago,			MontoProximoPago,		EstatusCredito,
						SaldoPromedio,			MontoCredito,			FrecuenciaCap,				PeriodicidadCap,		FrecuenciaInt,
						PeriodicidadInt,		NumAmortizacion,		FechTraspasVenc,			FechAutoriza,			ClasifRegID,
						DestinoCreID,			Calificacion,			PorcReserva,				TipoFondeo,				InstitFondeoID,
						IntDevCtaOrden,			CapCondonadoDia,		ComAdmonPagDia,				ComCondonadoDia,		DesembolsosDia,
						CapVigenteExi,			MontoTotalExi,			SaldoParaFiniq,				CuotasPagadas,			ValorCAT,
						CapitalProxPago,		InteresProxPago,		IvaProxPago,				SalInteresExigible,		IVAInteresExigible,
						PagoIntOrdMes,			PagoIVAIntOrdMes,		PagoMoraMes,				PagoIVAMoraMes,			PagoComisiMes,
						PagoIVAComisiMes,		OtrosCargosApagar,		IVAOtrosCargosApagar
				FROM 	SALDOSCREDITOS
				WHERE 	FechaCorte >= Var_FechaSaldosIni
				  AND 	FechaCorte <= Var_FechaSaldosFin;

				-- Actualizacion de saldo inicial del credito sin IVA
				UPDATE TMPEDOCTAV2HEADERCRED Edo
					INNER JOIN TMP_MEM_SALDOSCREDITOS Scred	ON Scred.CreditoID = Edo.CreditoID AND Scred.FechaCorte = Var_FechaSaldosIni
                SET Edo.SaldoInicial		=  IF(Scred.FechaInicio >= Var_FecIniMes AND Scred.FechaInicio <= Var_FecFinMes,
                                                    -- Si el credito nacio en el mes, el monto inical es el monto otorgado
                                                    Scred.MontoCredito,
                                                    -- si el mes no nacio en el mes, se calcula el monto inical en base a las isguietes columnas
                                                    IFNULL(Scred.SalCapVigente , Entero_Cero)   + IFNULL(Scred.SalCapAtrasado, Entero_Cero)     + IFNULL(Scred.SalCapVencido, Entero_Cero)   + IFNULL(Scred.SalCapVenNoExi, Entero_Cero)
                                                    + IFNULL(Scred.SalIntOrdinario , Entero_Cero) + IFNULL(Scred.SalIntAtrasado , Entero_Cero)  + IFNULL(Scred.SalIntVencido, Entero_Cero)      + IFNULL(Scred.SalIntProvision, Entero_Cero) + IFNULL(Scred.SalIntNoConta, Entero_Cero)
                                                    + IFNULL(Scred.SalMoratorios   , Entero_Cero) + IFNULL(Scred.SaldoMoraVencido, Entero_Cero) + IFNULL(Scred.SaldoMoraCarVen, Entero_Cero)
                                                    + IFNULL(Scred.SalComFaltaPago , Entero_Cero) + IFNULL(Scred.SalOtrasComisi, Entero_Cero)   + IFNULL(Scred.SaldoComisionAnual, Entero_Cero)
                                                    + IFNULL(Scred.SaldoSeguroCuota, Entero_Cero)
                                                );

			-- Se obtiene la ultima fecha corte registrada en los saldos de credito en el rango de fechas de corte para cada uno de los creditos
				DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2FECHACORTE;

				CREATE TEMPORARY TABLE TMPEDOCTAV2FECHACORTE
				SELECT	CreditoID, MAX(FechaCorte) AS FechaCorte
				FROM TMP_MEM_SALDOSCREDITOS
				WHERE FechaCorte >= Var_FecIniMes
				  AND FechaCorte <= Var_FecFinMes
				GROUP BY CreditoID;

				CREATE INDEX IDX_TMPEDOCTAV2FECHACORTE_1 ON TMPEDOCTAV2FECHACORTE(CreditoID, FechaCorte);

				UPDATE TMPEDOCTAV2HEADERCRED Edo
					INNER JOIN TMPEDOCTAV2FECHACORTE Corte ON Edo.CreditoID = Corte.CreditoID
					INNER JOIN TMP_MEM_SALDOSCREDITOS Scred	ON Scred.CreditoID = Edo.CreditoID AND Scred.FechaCorte = Corte.FechaCorte
				SET	Edo.ImporteCredito		= IFNULL(Scred.MontoCredito, Entero_Cero),
					Edo.FechaVencimiento	= IFNULL(Scred.FechaVencimiento, Entero_Cero),
					Edo.PagoAmortizaciones	= CONCAT(CAST(IFNULL(Scred.CuotasPagadas, Entero_Cero) AS CHAR), ' de ', CAST(IFNULL(Scred.NumAmortizacion, Entero_Cero) AS CHAR)),
					Edo.CAT					= IFNULL(Scred.ValorCAT, Entero_Cero),
					Edo.TasaOrdinaria		= IFNULL(Scred.TasaFija, Entero_Cero),
					Edo.TasaMoratoria		= CASE	Scred.TipCobComMorato
													WHEN Var_TipCobTasaFija THEN IFNULL(Scred.FactorMora, Entero_Cero)
													ELSE IFNULL(Scred.TasaFija, Entero_Cero) * IFNULL(Scred.FactorMora, Entero_Cero)
											  END,
					Edo.PagoIntOrdMes		= IFNULL( Scred.PagoIntOrdMes	, Entero_Cero),
					Edo.PagoIVAIntOrdMes	= IFNULL( Scred.PagoIVAIntOrdMes, Entero_Cero),
					Edo.PagoMoraMes			= IFNULL( Scred.PagoMoraMes, Entero_Cero),
					Edo.PagoIVAMoraMes		= IFNULL( Scred.PagoIVAMoraMes, Entero_Cero),
					Edo.PagoComisiMes		= IFNULL( Scred.PagoComisiMes	, Entero_Cero),
					Edo.PagoIVAComisiMes	= IFNULL( Scred.PagoIVAComisiMes, Entero_Cero),

					Edo.CapitalProxpago		= IF (	IFNULL(Scred.NoCuotasAtraso, Entero_Cero) > Entero_Cero,
													   IFNULL(Scred.SalCapAtrasado, Entero_Cero)
													 + IFNULL(Scred.SalCapVencido, Entero_Cero)
													 + IFNULL(Scred.SalCapVenNoExi, Entero_Cero),
													IFNULL(Scred.CapitalProxPago, Entero_Cero) ),
					Edo.InteresProxPago		= IF (IFNULL(Scred.NoCuotasAtraso, Entero_Cero) > Entero_Cero,
													IFNULL(Scred.SalInteresExigible, Entero_Cero),
													IFNULL(Scred.InteresProxPago, Entero_Cero) ),
					Edo.IvaProxPago			 = IF(IFNULL(Scred.NoCuotasAtraso, Entero_Cero) > Entero_Cero,
													IFNULL(Scred.IVAInteresExigible, Entero_Cero),
													IFNULL(Scred.IvaProxPago, Entero_Cero) ),
					Edo.OtrCargosProxPago	 = IFNULL(Scred.OtrosCargosApagar, Entero_Cero),
					Edo.IVAOtrCargosProxPago = IFNULL(Scred.IVAOtrosCargosApagar, Entero_Cero);

					-- INSERTAMOS EN LA TABLA FINAL
					INSERT INTO EDOCTAV2HEADERCRED( FolioProceso,			AnioMes,					CreditoID,				SucursalID,				ClienteID,
													ProductoCreditoID,		NombreProducto,				CuentaClabe, 			ImporteCredito,			FechaMinistrado,
													FechaVencimiento,		SaldoInsoluto,				SaldoInicial,			PagoAmortizaciones,		CAT,
													TasaOrdinaria,			TasaMoratoria,				PagoIntOrdMes,			PagoIVAIntOrdMes, 		PagoMoraMes,
													PagoIVAMoraMes, 		PagoComisiMes, 				PagoIVAComisiMes,		FechaProxPag,			FechaProxPagLey,
													CapitalProxpago,		InteresProxPago,			IvaProxPago,			OtrCargosProxPago,		IVAOtrCargosProxPago,
													PlazoID,				DiasDelPlazo,				FrecPlazo,				PlazoEnMes,				EmpresaID,
													Usuario,				FechaActual,				DireccionIP,			ProgramaID,				Sucursal,
													NumTransaccion)
					SELECT
													Var_FolioProceso,		Tmp.AnioMes,				Tmp.CreditoID,			Tmp.SucursalID,			Tmp.ClienteID,
													Tmp.ProductoCreditoID,	Tmp.NombreProducto,			Cre.CuentaCLABE,		Tmp.ImporteCredito,		Cre.FechaMinistrado,
													Tmp.FechaVencimiento,	Tmp.SaldoInsoluto,			Tmp.SaldoInicial,		Tmp.PagoAmortizaciones,	Tmp.CAT,
													Tmp.TasaOrdinaria,		Tmp.TasaMoratoria,			Tmp.PagoIntOrdMes,		Tmp.PagoIVAIntOrdMes, 	Tmp.PagoMoraMes,
													Tmp.PagoIVAMoraMes, 	Tmp.PagoComisiMes, 			Tmp.PagoIVAComisiMes,	Tmp.FechaProxPag,		Tmp.FechaProxPagLey,
													Tmp.CapitalProxpago,	Tmp.InteresProxPago,		Tmp.IvaProxPago,		Tmp.OtrCargosProxPago,	Tmp.IVAOtrCargosProxPago,
													Cre.PlazoID,			Entero_Cero,			 	Cadena_Vacia, 			Entero_Cero, 			Par_EmpresaID,
													Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
													Aud_NumTransaccion
					FROM TMPEDOCTAV2HEADERCRED Tmp
						INNER JOIN CREDITOS Cre ON Tmp.CreditoID = Cre.CreditoID;


					UPDATE EDOCTAV2HEADERCRED Cre
						INNER JOIN CREDITOSPLAZOS Pla ON Cre.PlazoID = CAST(Pla.PlazoID AS DECIMAL)
					SET Cre.DiasDelPlazo = Pla.Dias,
						Cre.FrecPlazo 	 = Pla.Frecuencia,
						Cre.PlazoEnMes	 = CASE Pla.Frecuencia 	WHEN 'M' THEN  ROUND(Pla.Dias /30)
																WHEN 'S' THEN  ROUND(Pla.Dias /7 / 4)
																WHEN 'P' THEN  ROUND(Pla.Dias /30)
																WHEN 'C' THEN  ROUND(Pla.Dias /14 / 2)
																WHEN 'Q' THEN  ROUND(Pla.Dias /15 / 2)
																ELSE ROUND(Pla.Dias /30)
											END
					WHERE FolioProceso = Var_FolioProceso;

					DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2FECHACORTE;
					DROP TABLE IF EXISTS TMP_MEM_SALDOSCREDITOS;

					SET Par_NumErr	:= Entero_Cero;
					SET Par_ErrMen	:= CONCAT('Encabezado de Creditos Terminado con Exito con Folio: ', Var_FolioProceso);

END ManejoErrores; -- fin del manejador de errores

	IF (Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$
