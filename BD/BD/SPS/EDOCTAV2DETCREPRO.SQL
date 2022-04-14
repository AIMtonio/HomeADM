-- EDOCTAV2DETCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2DETCREPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2DETCREPRO`(
	Par_Salida              CHAR(1),		-- Indica si el error lo regresa en un select o no
    INOUT   Par_NumErr      INT(11),        -- parametros de control de errores indica el numero de Error
    INOUT   Par_ErrMen		VARCHAR(400),   -- parametros de control de errores manda el mesnaje del error

    /* paramtros de auditoria */
	Par_EmpresaID           INT(11),        -- Parametro de Auditoria
	Aud_Usuario             INT(11),        -- Parametro de Auditoria
	Aud_FechaActual         DATETIME,       -- Parametro de Auditoria
	Aud_DireccionIP         VARCHAR(15),    -- Parametro de Auditoria
	Aud_ProgramaID          VARCHAR(50),    -- Parametro de Auditoria
	Aud_Sucursal            INT(11),        -- Parametro de Auditoria
	Aud_NumTransaccion      BIGINT(20)      -- Parametro de Auditoria
		)
TerminaStore: BEGIN

			-- DECLARACION DE VARIABLES
	DECLARE Var_FecIniMes					DATE;						-- Fecha inicial del Periodo a procesar
	DECLARE Var_FecFinMes					DATE;						-- Fecha final del Periodo a Procear
	DECLARE Var_FechaSaldosIni				DATE;						-- Fecha corte para obtener los registros de saldo inicial de SALDOSCREDITOS
	DECLARE Var_FechaSaldosFin				DATE;						-- Fecha corte para obtener los registros de saldo Final de SALDOSCREDITOS
	DECLARE Var_FolioProceso				BIGINT(20);					-- Folio de procesamiento
	DECLARE Var_AnioMes						INT(11);					-- Año Mes a procesar
	DECLARE Var_SI							CHAR(1);					-- Constante S : Si
	DECLARE Var_NO							CHAR(1);					-- Constante N : No
	DECLARE Var_FechaCorte        			DATE;
	DECLARE Var_TipoCapital         		INT(11);
	DECLARE Var_TipoInteres         		INT(11);
	DECLARE Var_TipoMoratorio       		INT(11);
	DECLARE Var_TipoComFaltaPago    		INT(11);
	DECLARE Var_TipoOtrasComisiones 		INT(11);
	DECLARE Var_TipoIVAs            		INT(11);
	DECLARE Var_Orden_SalIni				INT(11);
	DECLARE Var_Orden_VtoCapital			INT(11);
	DECLARE Var_Orden_VtoInteres			INT(11);
	DECLARE Var_Orden_DevengueInt			INT(11);
	DECLARE Var_Orden_VtoMoratorio			INT(11);
	DECLARE Var_Orden_Comisiones			INT(11);
	DECLARE Var_Orden_IVAComisiones			INT(11);
	DECLARE Var_Orden_PagoCapital			INT(11);
	DECLARE Var_Orden_CargoIvaInteres		INT(11);
	DECLARE Var_Orden_CargoIvaMora			INT(11);
	DECLARE Var_Orden_CargoIvaComFalPag		INT(11);
	DECLARE Var_Orden_CargoIvaComApertura	INT(11);
	DECLARE Var_Orden_CargoIvaComGasAdmon	INT(11);
	DECLARE Var_Orden_CargoIvaAnualidad		INT(11);
	DECLARE Var_Orden_PagoInteres			INT(11);
	DECLARE Var_Orden_PagoIVAInt			INT(11);
	DECLARE Var_Orden_PagoMora				INT(11);
	DECLARE Var_Orden_PagoComFalPag			INT(11);
	DECLARE Var_Orden_PagoComApertura		INT(11);
	DECLARE Var_Orden_PagoComGasAdmon		INT(11);
	DECLARE Var_Orden_PagoAnualidad			INT(11);
	DECLARE Var_Orden_PagoIVAInteres		INT(11);
	DECLARE Var_Orden_PagoIVAMora			INT(11);
	DECLARE Var_Orden_PagoIVAComFalPag		INT(11);
	DECLARE Var_Orden_PagoIVAComApertura	INT(11);
	DECLARE Var_Orden_PagoIVAComGasAdmon	INT(11);
	DECLARE Var_Orden_PagoIVAAnualidad		INT(11);
	DECLARE Cadena_Vacia    				VARCHAR(1);
	DECLARE Fecha_Vacia     				DATE;
	DECLARE Entero_Cero     				INT(11);
	DECLARE Moneda_Cero     				DECIMAL(14,2);
	DECLARE PolizaCero						INT(1);
	DECLARE Est_Vigente						CHAR(1);
    DECLARE Est_Atrasado					CHAR(1);
    DECLARE Est_Vencido						CHAR(1);
    DECLARE Est_Castigado					CHAR(1);
    DECLARE Est_Eliminado					CHAR(1);
    DECLARE Est_Pagado						CHAR(1);
    DECLARE NatCargo						CHAR(1);
	DECLARE NatAbono						CHAR(1);
	DECLARE Entero_Uno						SMALLINT;					-- Entero 1
	DECLARE Var_UltimoDiaMes				DATE;
	SET Cadena_Vacia  						:= '';
	SET Fecha_Vacia 						:= '1900-01-01';
	SET Entero_Cero 						:= 0;
	SET Moneda_Cero 						:= 0.00;
	SET PolizaCero							:= 0;
	SET Est_Vigente							:= 'V';
    SET Est_Atrasado						:= 'A';
    SET Est_Vencido							:= 'B';
    SET Est_Castigado						:= 'K';
    SET Est_Eliminado						:= 'E';
    SET Est_Pagado							:= 'P';
    SET NatCargo							:= 'C';
	SET NatAbono							:= 'A';
	SET Var_SI								:= 'S';						-- Constante S : Si
	SET Var_NO								:= 'N';						-- Constante N : No
	SET Entero_Uno							:= 1;						-- Entero 1
	SET Var_TipoCapital 					:= 1;
	SET Var_TipoInteres 					:= 2;
	SET Var_TipoMoratorio 					:= 3;
	SET Var_TipoComFaltaPago 				:= 4;
	SET Var_TipoOtrasComisiones 			:= 5;
	SET Var_TipoIVAs 						:= 6;
	SET Var_Orden_SalIni					:= 0;
	SET Var_Orden_VtoCapital				:= 1;
	SET Var_Orden_VtoInteres				:= 4;
	SET Var_Orden_DevengueInt				:= 6;
	SET Var_Orden_VtoMoratorio				:= 8;
	SET Var_Orden_Comisiones				:= 10;
	SET Var_Orden_IVAComisiones				:= 11;
	SET Var_Orden_CargoIvaInteres			:= 16;
	SET Var_Orden_CargoIvaMora				:= 20;
	SET Var_Orden_CargoIvaComFalPag			:= 22;
	SET Var_Orden_CargoIvaComApertura		:= 24;
	SET Var_Orden_CargoIvaComGasAdmon		:= 26;
	SET Var_Orden_CargoIvaAnualidad			:= 28;
	SET Var_Orden_PagoCapital				:= 30;
	SET Var_Orden_PagoInteres				:= 32;
	SET Var_Orden_PagoIVAInteres			:= 34;
	SET Var_Orden_PagoMora					:= 36;
	SET Var_Orden_PagoIVAMora				:= 38;
	SET Var_Orden_PagoComFalPag				:= 40;
	SET Var_Orden_PagoIVAComFalPag			:= 42;
	SET Var_Orden_PagoComApertura			:= 44;
	SET Var_Orden_PagoIVAComApertura		:= 46;
	SET Var_Orden_PagoComGasAdmon			:= 48;
	SET Var_Orden_PagoIVAComGasAdmon		:= 50;
	SET Var_Orden_PagoAnualidad				:= 52;
	SET Var_Orden_PagoIVAAnualidad			:= 54;

ManejoErrores:BEGIN     -- bloque para manejar los posibles errores
				DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
					SET Par_NumErr      = 999;
					SET Par_ErrMen      = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
												 'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2DETCREPRO');
				END;

	SET Par_Salida	:=		IFNULL(Par_Salida, Var_NO);
	SET Par_NumErr	:=		IFNULL(Par_NumErr, Entero_Cero);

	SELECT	MesProceso, FechaInicio, FechaFin,  FolioProceso
	INTO	Var_AnioMes, Var_FecIniMes, Var_FecFinMes, Var_FolioProceso
	FROM	EDOCTAV2PARAMS
	LIMIT	Entero_Uno;

	SET Var_FolioProceso 	:= IFNULL(Var_FolioProceso, Entero_Cero);

	-- Se obtiene la fecha para consultar los saldos iniciales del periodo
	SELECT		MAX(FechaCorte)
	INTO	Var_FechaSaldosIni
	FROM	SALDOSCREDITOS
	WHERE	FechaCorte < Var_FecIniMes;

	SET Var_UltimoDiaMes := (select DATE_SUB(Var_FecIniMes,INTERVAL 1 day));
	SET Var_FechaSaldosIni :=IFNULL(Var_FechaSaldosIni, Var_UltimoDiaMes);

	-- Se obtiene la ultima fecha corte registrada en los saldos de credito en el rango de fechas de corte
	SELECT		MAX(FechaCorte)
	INTO	Var_FechaSaldosFin
	FROM	SALDOSCREDITOS
	WHERE	FechaCorte >= Var_FecIniMes
	  AND	FechaCorte <= Var_FecFinMes;

	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTACREDITOSMOVSMES;
	CREATE TEMPORARY TABLE TMPEDOCTACREDITOSMOVSMES (	CreditoID		BIGINT(12) NOT NULL,
														AmortiCreID		INT(5)	NOT NULL,
														FechaOperacion	DATE	NOT NULL,
														TipoMovCreID	INT(4)  NOT NULL,
														NatMovimiento	CHAR(1) NOT NULL,
														MonedaID		INT(11) NOT NULL,
														Cantidad		DECIMAL(14,4) NOT NULL,
														Descripcion		VARCHAR(100) NOT NULL,
														Referencia		VARCHAR(50) NOT NULL,
														Transaccion		BIGINT(20),
														KEY(CreditoID),
														KEY(AmortiCreID),
														KEY(FechaOperacion),
														KEY(TipoMovCreID)
													);


	INSERT INTO TMPEDOCTACREDITOSMOVSMES
	SELECT 	CreditoID, 	AmortiCreID,		FechaOperacion, 	TipoMovCreID, 	NatMovimiento,
			MonedaID, 	Cantidad, 			Descripcion, 		Referencia,		Transaccion
	FROM CREDITOSMOVS
	WHERE FechaOperacion >= Var_FecIniMes
	  AND FechaOperacion <= Var_FecFinMes;

	DROP TEMPORARY TABLE IF EXISTS TMP_SALDOINICIAL;
    CREATE TEMPORARY TABLE TMP_SALDOINICIAL(	CreditoID     BIGINT(12),
										        Mov_Saldo     DECIMAL(14,2),
												FechaInicio   DATE,
												PRIMARY KEY (CreditoID)
											);

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
												`IvaProxPago`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'IVA de Intereses a pagar en el Proximo Pago',
												`SalInteresExigible`	DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Saldo de Interes Exigible, Tendra valor cuando el credito tiene al menos una cuota de atraso',
												`IVAInteresExigible`	DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'IVA de Interes Exigible, Tendra valor cuando el credito tiene al menos una cuota de atraso',
												`PagoIntOrdMes`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de Intereses Ordinarios pagadas en el Mes',
												`PagoIVAIntOrdMes`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de IVA de Intereses Ordinarios pagadas en el Mes',
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
			PagoIntOrdMes,			PagoIVAIntOrdMes,		PagoComisiMes,				PagoIVAComisiMes,		OtrosCargosApagar,
			IVAOtrosCargosApagar
	FROM 	SALDOSCREDITOS
	WHERE 	FechaCorte >= Var_FechaSaldosIni
	  AND 	FechaCorte <= Var_FechaSaldosFin;

    INSERT INTO TMP_SALDOINICIAL
	SELECT Edo.CreditoID, 	  IFNULL(Scred.SalCapVigente, Entero_Cero)    + IFNULL(Scred.SalCapAtrasado, Entero_Cero)   + IFNULL(Scred.SalCapVencido, Entero_Cero)   + IFNULL(Scred.SalCapVenNoExi, Entero_Cero)
							+ IFNULL(Scred.SalIntOrdinario , Entero_Cero) + IFNULL(Scred.SalIntAtrasado , Entero_Cero)  + IFNULL(Scred.SalIntVencido, Entero_Cero)   + IFNULL(Scred.SalIntProvision, Entero_Cero) + IFNULL(Scred.SalIntNoConta, Entero_Cero)
							+ IFNULL(Scred.SalMoratorios   , Entero_Cero) + IFNULL(Scred.SaldoMoraVencido, Entero_Cero) + IFNULL(Scred.SaldoMoraCarVen, Entero_Cero)
							+ IFNULL(Scred.SalComFaltaPago , Entero_Cero) + IFNULL(Scred.SalOtrasComisi, Entero_Cero)   + IFNULL(Scred.SaldoComisionAnual, Entero_Cero)
							+ IFNULL(Scred.SaldoSeguroCuota, Entero_Cero),
			cre.FechaInicio
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN CREDITOS AS cre ON Edo.CreditoID = cre.CreditoID
	LEFT JOIN TMP_MEM_SALDOSCREDITOS Scred ON Edo.CreditoID = Scred.CreditoID AND Scred.FechaCorte = Var_FechaSaldosIni
	WHERE 	Edo.FolioProcesoID  = Var_FolioProceso;

	UPDATE TMP_SALDOINICIAL AS tmp
		INNER JOIN EDOCTAV2RESUMCREDITOS AS edo ON edo.CreditoID = tmp.CreditoID AND tmp.FechaInicio > Var_FechaSaldosIni
		LEFT JOIN TMP_MEM_SALDOSCREDITOS Scred ON tmp.CreditoID = Scred.CreditoID AND Scred.FechaCorte = tmp.FechaInicio SET
		Mov_Saldo =   IF(tmp.FechaInicio >= Var_FecIniMes AND tmp.FechaInicio <= Var_FecFinMes,
                        -- Si el credito nacio en el mes, el monto inical es el monto otorgado
                            Scred.MontoCredito,
                            -- si el credito no nacio en el mes, se calcula el monto inical en base a las isguietes columnas
                            IFNULL(Scred.SalCapVigente, Entero_Cero) + IFNULL(Scred.SalCapAtrasado, Entero_Cero) + IFNULL(Scred.SalCapVencido, Entero_Cero) +
                            IFNULL(Scred.SalCapVenNoExi, Entero_Cero) + IFNULL(Scred.SalIntOrdinario, Entero_Cero) + IFNULL(Scred.SalIntAtrasado , Entero_Cero) +
                            IFNULL(Scred.SalIntVencido, Entero_Cero) + IFNULL(Scred.SalIntProvision, Entero_Cero) + IFNULL(Scred.SalIntNoConta, Entero_Cero) +
                            IFNULL(Scred.SalMoratorios, Entero_Cero) + IFNULL(Scred.SaldoMoraVencido, Entero_Cero) + IFNULL(Scred.SaldoMoraCarVen, Entero_Cero) +
                            IFNULL(Scred.SalComFaltaPago , Entero_Cero) + IFNULL(Scred.SalOtrasComisi, Entero_Cero) + IFNULL(Scred.SaldoComisionAnual, Entero_Cero) +
                            IFNULL(Scred.SaldoSeguroCuota, Entero_Cero)
                        )
		WHERE	edo.FolioProcesoID	= Var_FolioProceso;

	-- Se Eliminan los registros que puedan existir del folio que se esta procesando
	DELETE FROM EDOCTAV2DETCRE
	WHERE FolioProceso  = Var_FolioProceso;

	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,		Entero_Cero, 			Edo.SucursalID,
    		Edo.ClienteID,
    		IF(Sal.FechaInicio >= Var_FecIniMes, Sal.FechaInicio, Var_FecIniMes),	'SALDO INICIAL',		'SALDO INICIAL',	IFNULL(Sal.Mov_Saldo, Entero_Cero), Entero_Cero,
    		Var_Orden_SalIni, 		Entero_Cero,
    		Par_EmpresaID,			Aud_Usuario, 		Aud_FechaActual, 					Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	LEFT JOIN TMP_SALDOINICIAL Sal ON Edo.CreditoID = Sal.CreditoID
	WHERE Edo.FolioProcesoID  = Var_FolioProceso;

	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,		Amo.AmortizacionID,
    		Edo.SucursalID,										Edo.ClienteID,
    		MAX(Amo.FechaExigible),	'VTO.CREDITO.INTERES',	CONCAT('VTO.CREDITO.INTERES CUOTA ', Amo.AmortizacionID),	SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ), 	Entero_Cero,
    		Var_Orden_VtoInteres, 	MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 												Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN AMORTICREDITO Amo ON Edo.CreditoID = Amo.CreditoID AND Amo.FechaExigible <= Var_FecFinMes
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON Mov.CreditoID = Amo.CreditoID AND Amo.AmortizacionID = Mov.AmortiCreID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (10,13, 14) AND Mov.NatMovimiento = NatCargo
									AND (Mov.Descripcion IN ('CIERRE DIARIO CARTERA' ,'CIERRE DIARO CARTERA'))
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Amo.AmortizacionID;

	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		 Edo.AnioMes,					Edo.CreditoID,				Amo.AmortizacionID,
    		Edo.SucursalID,										Edo.ClienteID,
    		MAX(Mov.FechaOperacion), 'DEVENGUE.CREDITO.INTERES',	CONCAT('DEVENGUE.CREDITO.INTERES CUOTA ', Amo.AmortizacionID),	SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ), 	Entero_Cero,
    		Var_Orden_DevengueInt, 	 MAX(Mov.Transaccion),
    		Par_EmpresaID,			 Aud_Usuario, 													Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		 Aud_Sucursal, 					Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
		INNER JOIN AMORTICREDITO Amo ON Edo.CreditoID = Amo.CreditoID AND Amo.FechaInicio <= Var_FecFinMes  AND Amo.FechaExigible > Var_FecFinMes
		INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON Mov.CreditoID = Amo.CreditoID AND Amo.AmortizacionID = Mov.AmortiCreID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
										AND Mov.TipoMovCreID IN (10,13, 14) AND Mov.NatMovimiento = NatCargo
										AND (Mov.Descripcion IN ('CIERRE DIARIO CARTERA' ,'CIERRE DIARO CARTERA'))
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Amo.AmortizacionID;

INSERT INTO EDOCTAV2DETCRE
	SELECT  NULL,
    		Var_FolioProceso,		 Edo.AnioMes,				Edo.CreditoID,					MAX(Mov.AmortiCreID),
    		Edo.SucursalID,										Edo.ClienteID,
			MAX(Mov.FechaOperacion), 'INTERES MORATORIO',		CONCAT('INTERES MORATORIO'),	SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ), 	Entero_Cero,
			Var_Orden_VtoMoratorio,  MAX(Mov.Transaccion),
			Par_EmpresaID,			 Aud_Usuario, 												Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		 Aud_Sucursal, 				Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON		Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
	  								AND Mov.TipoMovCreID IN (15, 16, 17) AND Mov.NatMovimiento = NatCargo
	  								AND (Mov.Descripcion IN ('CIERRE DIARIO CARTERA', 'CIERRE DIARO CARTERA') AND Mov.Referencia ='GENERACION INTERES MORATORIO')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;

	INSERT INTO EDOCTAV2DETCRE
	SELECT  NULL,
    		Var_FolioProceso,		 Edo.AnioMes,				Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,										Edo.ClienteID,
			MAX(Mov.FechaOperacion), 'COM.FAL.PAGO',				'COM.FAL.PAGO',				SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ), 	Entero_Cero,
			Var_Orden_Comisiones, 	 MAX(Mov.Transaccion),
			Par_EmpresaID,			 Aud_Usuario, 				Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		 Aud_Sucursal, 				Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON	Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
	  								AND Mov.TipoMovCreID = 40 AND Mov.NatMovimiento = NatCargo AND (Mov.Descripcion IN ('CIERRE DIARIO CARTERA','CIERRE DIARO CARTERA'))
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;

	INSERT INTO EDOCTAV2DETCRE
	SELECT  NULL,
    		Var_FolioProceso,		  Edo.AnioMes,				Edo.CreditoID,				MAX(Mov.AmortiCreID),
    		Edo.SucursalID,										Edo.ClienteID,
			MAX(Mov.FechaOperacion),  'COM.APERTURA',			'COM.APERTURA',				SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ), 	Entero_Cero,
			Var_Orden_Comisiones, 	  MAX(Mov.Transaccion),
			Par_EmpresaID,			  Aud_Usuario, 				Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		  Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON	Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
	  								AND Mov.TipoMovCreID = 41 AND Mov.NatMovimiento = NatCargo AND (Mov.Descripcion IN ('CIERRE DIARIO CARTERA','CIERRE DIARO CARTERA'))
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;

	INSERT INTO EDOCTAV2DETCRE
	SELECT  NULL,
    		Var_FolioProceso,			Edo.AnioMes,				Edo.CreditoID,				MAX(Mov.AmortiCreID),
    		Edo.SucursalID,				Edo.ClienteID,
			MAX(Mov.FechaOperacion), 	'COM.GAST.ADMINISTRACION',	'COM.GAST.ADMINISTRACION',	SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ), 	Entero_Cero,
			Var_Orden_Comisiones, 		MAX(Mov.Transaccion),
			Par_EmpresaID,				Aud_Usuario, 				Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 			Aud_Sucursal, 				Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON	Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
	  								AND Mov.TipoMovCreID = 42 AND Mov.NatMovimiento = NatCargo AND (Mov.Descripcion IN ('CIERRE DIARIO CARTERA','CIERRE DIARO CARTERA'))
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;


	INSERT INTO EDOCTAV2DETCRE
	SELECT  NULL,
    		Var_FolioProceso,			Edo.AnioMes,				Edo.CreditoID,				MAX(Mov.AmortiCreID),
    		Edo.SucursalID,				Edo.ClienteID,
			MAX(Mov.FechaOperacion), 	'COM.ANUALIDAD',			'COM.ANUALIDAD',			SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ), 	Entero_Cero,
			Var_Orden_Comisiones, 		MAX(Mov.Transaccion),
			Par_EmpresaID,				Aud_Usuario, 				Aud_FechaActual, 			Aud_DireccionIP,
    		Aud_ProgramaID, 			Aud_Sucursal, 				Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON	Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
	  								AND Mov.TipoMovCreID = 51 AND Mov.NatMovimiento = NatCargo AND (Mov.Descripcion IN ('CIERRE DIARIO CARTERA','CIERRE DIARO CARTERA'))
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;

	DELETE FROM EDOCTAV2DETCRE
	WHERE Cargo = 0
	  AND Abono = 0
	  AND Orden <> Var_Orden_SalIni;


	-- MOVIMIENTOS DE Pago
	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,		MAX(Amo.AmortizacionID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('PAGO.CAPITAL.CUOTA ',Amo.AmortizacionID),
    		CONCAT('PAGO.CAPITAL.CUOTA ',Amo.AmortizacionID),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoCapital,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN AMORTICREDITO Amo ON Edo.CreditoID = Amo.CreditoID AND Amo.FechaExigible <= Var_FecFinMes
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON Mov.CreditoID = Amo.CreditoID AND Amo.AmortizacionID = Mov.AmortiCreID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (1,2,3,4) AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Amo.AmortizacionID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		Mov.FechaOperacion,
    		CONCAT('PRE-PAGO.CAPITAL.CUOTA ',Mov.AmortiCreID),
    		CONCAT('PRE-PAGO.CAPITAL.CUOTA ',Mov.AmortiCreID),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoCapital,
    		Mov.Transaccion,
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN AMORTICREDITO Amo ON Edo.CreditoID = Amo.CreditoID AND Amo.FechaExigible > Var_FecFinMes
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON Mov.CreditoID = Amo.CreditoID AND Amo.AmortizacionID = Mov.AmortiCreID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (1, 4) AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID, Mov.FechaOperacion, Mov.Transaccion;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('CONDONACION.CAPITAL '),
    		CONCAT('CONDONACION.CAPITAL '),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoCapital,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (1,2,3,4) AND Mov.NatMovimiento = NatAbono
									AND Mov.Descripcion LIKE '%CONDONACION%'
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('PAGO.INTERES.CUOTA ',Mov.AmortiCreID),
    		CONCAT('PAGO.INTERES.CUOTA ',Mov.AmortiCreID),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoInteres,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (10,11,12,13,14) AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('CONDONACION.INTERES'),
    		CONCAT('CONDONACION.INTERES'),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoInteres,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (10,11,12,13,14) AND Mov.NatMovimiento = NatAbono
									AND Mov.Descripcion LIKE '%CONDONACION%'
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,				MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('PAGO.MORATORIOS.CUOTA ',Mov.AmortiCreID),
    		CONCAT('PAGO.MORATORIOS.CUOTA ',Mov.AmortiCreID),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoMora,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (15, 16, 17) AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('CONDONACION.MORATORIOS '),
    		CONCAT('CONDONACION.MORATORIOS '),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoMora,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (15, 16, 17) AND Mov.NatMovimiento = NatAbono
									AND Mov.Descripcion LIKE '%CONDONACION%'
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;

	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,			Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,				Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('PAGO.COM.FAL.PAGO.CUOTA ',Mov.AmortiCreID),
    		CONCAT('PAGO.COM.FAL.PAGO.CUOTA ',Mov.AmortiCreID),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoComFalPag,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 			Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID = 40 AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID;



	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,			Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,				Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('CONDONACION.COM.FAL.PAGO '),
    		CONCAT('CONDONACION.COM.FAL.PAGO '),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoComFalPag,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 									Aud_DireccionIP,
    		Aud_ProgramaID, 			Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID = 40 AND Mov.NatMovimiento = NatAbono
									AND Mov.Descripcion LIKE '%CONDONACION%'
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;

	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,			Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('PAGO.COM.APERTURA.CUOTA ',Mov.AmortiCreID),
    		CONCAT('PAGO.COM.APERTURA.CUOTA ',Mov.AmortiCreID),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoComApertura,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,
    		Aud_ProgramaID, 			Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID = 41 AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,			Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,				Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('CONDONACION.COM.APERTURA '),
    		CONCAT('CONDONACION.COM.APERTURA '),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoComApertura,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,
    		Aud_ProgramaID, 			Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID = 41 AND Mov.NatMovimiento = NatAbono
									AND Mov.Descripcion LIKE '%CONDONACION%'
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('PAGO.GAST.ADMINISTRACION.CUOTA ',Mov.AmortiCreID),
    		CONCAT('PAGO.GAST.ADMINISTRACION.CUOTA ',Mov.AmortiCreID),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoComGasAdmon,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID = 42 AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,			Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,				Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('CONDONACION.GAST.ADMINISTRACION '),
    		CONCAT('CONDONACION.GAST.ADMINISTRACION '),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoComGasAdmon,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID = 42 AND Mov.NatMovimiento = NatAbono
									AND Mov.Descripcion LIKE '%CONDONACION%'
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('PAGO.COM.ANUALIDAD.CUOTA ',Mov.AmortiCreID),
    		CONCAT('PAGO.COM.ANUALIDAD.CUOTA ',Mov.AmortiCreID),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoAnualidad,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,
    		Aud_ProgramaID, 			Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID = 51 AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID;


	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('CONDONACION.COM.ANUALIDAD '),
    		CONCAT('CONDONACION.COM.ANUALIDAD '),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Var_Orden_PagoAnualidad,
    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,
    		Aud_ProgramaID, 			Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID = 51 AND Mov.NatMovimiento = NatAbono
									AND Mov.Descripcion LIKE '%CONDONACION%'
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID;

-- IVAs
-- LOS MISMOS REGISTROS DE PAGO SE INSERTAN COMO ABONO YA QUE EL IVA NO SE DEVENGA
	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('CARGO.IVA ', CASE Mov.TipoMovCreID 	WHEN 20 THEN '.INTERES'
    													WHEN 21 THEN '.MORATORIO'
    													WHEN 22 THEN '.COM.FALTA.PAGO'
    													WHEN 23 THEN '.COM.APERTURA'
    													WHEN 24 THEN '.GAST.ADMINISTRACION'
    													WHEN 52 THEN '.COM.ANUALIDAD'
    													ELSE ' '
    							END, '.CUOTA ', Mov.AmortiCreID),
    		CONCAT('CARGO.IVA ', CASE Mov.TipoMovCreID 	WHEN 20 THEN '.INTERES'
    													WHEN 21 THEN '.MORATORIO'
    													WHEN 22 THEN '.COM.FALTA.PAGO'
    													WHEN 23 THEN '.COM.APERTURA'
    													WHEN 24 THEN '.GAST.ADMINISTRACION'
    													WHEN 52 THEN '.COM.ANUALIDAD'
    													ELSE ' '
    							END, '.CUOTA ', Mov.AmortiCreID),
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),
    		Entero_Cero,

    		CASE Mov.TipoMovCreID 	WHEN 20 THEN Var_Orden_CargoIvaInteres
									WHEN 21 THEN Var_Orden_CargoIvaMora
									WHEN 22 THEN Var_Orden_CargoIvaComFalPag
									WHEN 23 THEN Var_Orden_CargoIvaComApertura
									WHEN 24 THEN Var_Orden_CargoIvaComGasAdmon
									WHEN 52 THEN Var_Orden_CargoIvaAnualidad
									ELSE ' '
    							END,

			MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (20,21,22,23,24,25) AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID, Mov.TipoMovCreID;

	INSERT INTO EDOCTAV2DETCRE
    SELECT  NULL,
    		Var_FolioProceso,		Edo.AnioMes,			Edo.CreditoID,			MAX(Mov.AmortiCreID),
    		Edo.SucursalID,			Edo.ClienteID,
    		MAX(Mov.FechaOperacion),
    		CONCAT('PAGO.IVA ', CASE Mov.TipoMovCreID 	WHEN 20 THEN '.INTERES'
    													WHEN 21 THEN '.MORATORIO'
    													WHEN 22 THEN '.COM.FALTA.PAGO'
    													WHEN 23 THEN '.COM.APERTURA'
    													WHEN 24 THEN '.GAST.ADMINISTRACION'
    													WHEN 52 THEN '.COM.ANUALIDAD'
    													ELSE ' '
    							END, '.CUOTA ', Mov.AmortiCreID),
    		CONCAT('PAGO.IVA ', CASE Mov.TipoMovCreID 	WHEN 20 THEN '.INTERES'
    													WHEN 21 THEN '.MORATORIO'
    													WHEN 22 THEN '.COM.FALTA.PAGO'
    													WHEN 23 THEN '.COM.APERTURA'
    													WHEN 24 THEN '.GAST.ADMINISTRACION'
    													WHEN 52 THEN '.COM.ANUALIDAD'
    													ELSE ' '
    							END, '.CUOTA ', Mov.AmortiCreID),
    		Entero_Cero,
    		SUM(ROUND(IFNULL(Mov.Cantidad, Entero_Cero), 2) ),

    		CASE Mov.TipoMovCreID 	WHEN 20 THEN Var_Orden_PagoIVAInteres
									WHEN 21 THEN Var_Orden_PagoIVAMora
									WHEN 22 THEN Var_Orden_PagoIVAComFalPag
									WHEN 23 THEN Var_Orden_PagoIVAComApertura
									WHEN 24 THEN Var_Orden_PagoIVAComGasAdmon
									WHEN 52 THEN Var_Orden_PagoIVAAnualidad
									ELSE ' '
    							END,

    		MAX(Mov.Transaccion),
    		Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual, 		Aud_DireccionIP,
    		Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion
	FROM EDOCTAV2RESUMCREDITOS Edo
	INNER JOIN TMPEDOCTACREDITOSMOVSMES Mov ON  Edo.CreditoID = Mov.CreditoID AND Mov.FechaOperacion >= Var_FecIniMes AND Mov.FechaOperacion <= Var_FecFinMes
									AND Mov.TipoMovCreID IN (20,21,22,23,24,25) AND Mov.NatMovimiento = NatAbono
									AND (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION')
	WHERE Edo.FolioProcesoID  = Var_FolioProceso
	GROUP BY Edo.AnioMes, Edo.CreditoID, Edo.SucursalID, Edo.ClienteID, Mov.AmortiCreID, Mov.TipoMovCreID;

	DROP TABLE IF EXISTS TMP_MEM_SALDOSCREDITOS;
	DROP TEMPORARY TABLE IF EXISTS TMP_SALDOINICIAL;
	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTACREDITOSMOVSMES;

	 SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Detalle de Credito Terminado exitosamente con Folio: ', CAST(Var_FolioProceso AS CHAR));

END ManejoErrores; -- fin del manejador de errores

	IF (Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$
