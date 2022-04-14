-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCEDEINDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCEDEINDPRO`;DELIMITER $$

CREATE PROCEDURE `PAGOCEDEINDPRO`(
/*PAGO DE LA CEDE SE UTLIZA EN EL EL PAGO CEDE PRO, SE SEPARO PARA DETECTAR LOS ERRORES QUE SUCEDAN EN EL CURSOR*/
	Par_CedeID				INT(11),		-- Id de la CEDE a Pagar.
	Par_Fecha				DATE,			-- Fecha en la que Vence la CEDE.
    Par_Reinversion			CHAR(1),
	Par_Reinvertir			CHAR(2),		-- Indica si despues de Pagar se Reinvertira la CEDE. S.-Si N.-No
    Par_EsReinversion		CHAR(1),
	Par_TipoCedeID			INT(11),		-- Indica el Tipo de CEDE.
	Par_CuentaAhoID			BIGINT(20),		-- Cuenta de Ahorro relacionada a la CEDE.

	Par_ClienteID			INT(11),		-- ClienteID relacionado a la CEDE.
	Par_FechaInicio			DATE,			-- Fecha de Inicio de la CEDE.
	Par_FechaVencimiento	DATE,			-- Fecha de Vencimiento de la CEDE.
	Par_Monto				DECIMAL(18,2),	-- Monto de la CEDE.
	Par_Plazo				INT(11),		-- Plazo de la CEDE.

	Par_TasaFija			DECIMAL(12,4),	-- Tasa de la CEDE.
	Par_TasaISR				DECIMAL(12,4),	-- Tasa ISR.
	Par_TasaNeta			DECIMAL(12,4),	-- Tasa Neta.
	Par_CalculoInteres		INT(11),		-- Tipo de Formula Aplicada a la CEDE.
	Par_TasaBaseID			INT(11),		-- Tasa Base Aplicada a la CEDE.

	Par_SobreTasa			DECIMAL(12,4),	-- Sobre Tasa Aplicada a la CEDE.
	Par_PisoTasa			DECIMAL(12,4),	-- Piso Tasa Aplicada a la CEDE.
	Par_TechoTasa			DECIMAL(12,4),	-- Techo Tasa Aplicado a la CEDE.
	Par_InteresGenerado		DECIMAL(18,2),	-- Interes Genereado de la CEDE.
	Par_InteresRecibir		DECIMAL(18,2),	-- Interes Neto a Recibir de la CEDE.

	Par_InteresRetener		DECIMAL(18,2),	-- Interes a Retener de la CEDE.
	Par_CalGATReal			DECIMAL(18,2),	-- Gat REAL.
    Par_ValorGat			DECIMAL(18,2),	-- Gat Nominal
	Par_TipoPagoInt			VARCHAR(4),		-- Tipo de Pago de la CEDE(Fin de Mes o al Vencimiento).
	Par_PlazoOriginal		INT(11),		-- Plazo Original de la CEDE.
	Par_AltaEnPoliza		CHAR(1),		-- Indica si se dara de Alta la Poliza.
    Par_CedeMadreID			INT(11),		-- S:Es Cede Madre Origen N: No es madre Es CEDE Anclada
    Par_Salida				CHAR(1),		-- Indica si espera un SELECT de salida
	INOUT Par_Poliza		BIGINT(20),		-- INOUT Par_Poliza.
	INOUT Par_NumErr		INT(11),		-- INOUT Par_NumErr.
    INOUT Par_ErrMen		VARCHAR(400),	-- INOUT Par_ErrMen.

	Par_Empresa				INT(11),		-- Parametro de Auditoria Par_Empresa.
	Aud_Usuario				INT(11),		-- Parametro de Auditoria Aud_Usuario.
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria Aud_FechaActual.
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria Aud_DireccionIP.
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria Aud_ProgramaID.
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria Aud_Sucursal.
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria Aud_Numtransaccion.
)
TerminaStore:BEGIN

	-- Declaracion de Constantes.
	DECLARE Entero_Cero				INT(1);
	DECLARE Entero_Uno				INT(1);
	DECLARE CadenaVacia				CHAR(1);
	DECLARE FechaVacia				DATE;
	DECLARE DecimalCero				DECIMAL(18,2);
	DECLARE SalidaNO				CHAR(1);
	DECLARE SalidaSI                CHAR(1);
	DECLARE EstatusVigente			CHAR(1);
	DECLARE Mov_PagIntExe			VARCHAR(3);
	DECLARE TasaFija				INT(1);
	DECLARE Pol_Automatica			CHAR(1);
	DECLARE Mov_PagCedCap       	VARCHAR(4);
	DECLARE Var_RefPagoCed			VARCHAR(100);
	DECLARE Var_PagoCeder			INT(3);
	DECLARE Var_ConCedCapi			INT(1);
	DECLARE Con_Capital				INT(1);
	DECLARE Nat_Abono				CHAR(1);
	DECLARE AltPoliza_NO			CHAR(1);
	DECLARE Mov_AhorroSI			CHAR(1);
	DECLARE Var_ConCedProv			INT(1);
	DECLARE Tipo_Provision  		VARCHAR(4);
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Ope_Interna				CHAR(1);
	DECLARE Tip_Compra				CHAR(1);
	DECLARE ProcesoDesdePant		CHAR(1);
	DECLARE NombreProceso			VARCHAR(10);
	DECLARE Var_ConCedISR			INT(1);
	DECLARE Mov_AhorroNO			CHAR(1);
	DECLARE Mov_PagIntGra			VARCHAR(4);
	DECLARE Cue_PagIntGra			VARCHAR(100);
	DECLARE StringSI				CHAR(1);
	DECLARE Var_Reinvertir			VARCHAR(3);
	DECLARE EstPagado				CHAR(1);
	DECLARE Impreso					CHAR(1);
	DECLARE SabDom					CHAR(2);			/*Dia Inhabil: Sabado y Domingo */
	DECLARE No_DiaHabil				CHAR(1);        	/* No es dia habil */
	DECLARE EstVigente              CHAR(1);
	DECLARE Est_Aplicado           	CHAR(1);
	DECLARE ISRpSocio				VARCHAR(10);	-- ISR del socio
	DECLARE Con360					INT(11);
	DECLARE ConCien					INT(11);
	DECLARE SalMinAnuDF				DECIMAL(12,2);
	DECLARE ConCinco				INT(11);
	DECLARE InsCede					INT(11);
	DECLARE Par_TipoRegisPantalla	CHAR(1);
	DECLARE ValorUMA				VARCHAR(15);

	-- Declaracion de Variables.
	DECLARE Var_CedeID				INT(11);
	DECLARE Var_CuentaAhoID			BIGINT(20);
	DECLARE Var_TipoCedeID			INT(11);
	DECLARE Var_MonedaID			INT(11);
	DECLARE Var_Capital				DECIMAL(18,2);
	DECLARE Var_Interes				DECIMAL(18,2);
	DECLARE Var_InteresRetener		DECIMAL(18,2);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_SaldoProvision		DECIMAL(18,2);
	DECLARE Var_SucursalOrigen		INT(11);
	DECLARE Var_AmotizacionID		INT(11);
	DECLARE Var_CedeFecVencimiento	DATE;
	DECLARE Var_AmoFecVecimiento	DATE;
	DECLARE Var_FecVenciAmo			DATE;
	DECLARE Var_FecIniciaAmo		DATE;
	DECLARE Var_CalculoInteres		INT(11);
	DECLARE Cue_PagIntExe			VARCHAR(100);
	DECLARE Var_InteresPagar  		DECIMAL(18,2);
	DECLARE	Var_MonedaBase			INT(11);
	DECLARE Var_NumVenAmor			INT(11);
	DECLARE Var_MovIntere			VARCHAR(4);
	DECLARE Cue_PagIntere			VARCHAR(50);
	DECLARE Var_Instrumento			VARCHAR(15);
	DECLARE Var_CuentaStr			VARCHAR(15);
	DECLARE Cue_RetCeder			VARCHAR(50);
	DECLARE Mov_PagCedRet			VARCHAR(4);
	DECLARE Var_TipCamCom			DECIMAL(14,6);
	DECLARE Var_IntRetMN			DECIMAL(12,2);
	DECLARE Var_CliPaISR  			CHAR(1);
	DECLARE CalculoISRxCli  		CHAR(1);
	DECLARE Var_NuevaCedeID			INT(11);
	DECLARE Var_TasaISR				DECIMAL(12,4);
	DECLARE Var_PagaISR				CHAR(1);
	DECLARE Var_ConConReinv			INT(11);
	DECLARE Var_ConInvCapi			INT(11);
	DECLARE Var_ConAhoCapi			INT(11);
	DECLARE Mov_ApeCede				VARCHAR(4);
	DECLARE Var_ConAltCed			INT(3);
	DECLARE Var_ConCedeCapi			INT(1);
	DECLARE Var_Relaciones			VARCHAR(750);
	DECLARE Var_CalGAT				DECIMAL(12,4);
	DECLARE Var_DiaInhabil			CHAR(2);			/*Almacena el Dia Inhabil */
	DECLARE Var_FecSal				DATE;				/*Almacena la Fecha de Salida*/
	DECLARE Var_EsHabil				CHAR(1);			/*Almacena si el dia es habil o no*/
	DECLARE Var_FechaSistema		DATE;				/*Almacena la Fecha del Sistema */
	DECLARE Var_Control             VARCHAR(200);
	DECLARE Var_CajaRetiro          INT(11);				-- Caja Retiro de la CEDE Original
	DECLARE Var_CedeAnclajeID       INT;
	DECLARE Var_ISRReal 			DECIMAL(14,2); 		-- variable que guarda el ISR REAL
	DECLARE Var_ISR_pSocio			CHAR(1);			-- si se calcula por socio el ISR
	DECLARE Var_CedeFecIni			DATE;				-- variable de la inversion inicial
	DECLARE Var_SalMinDF			DECIMAL(12,2);
	DECLARE Var_FechaISR			DATE;				-- variable fecha de inicio cobro isr por socio
	DECLARE InstCede      			INT;
    DECLARE EnteroUno				INT;
    DECLARE Var_Consecutivo			BIGINT;
    DECLARE Var_DiasInversion		INT(11);
    DECLARE Var_MontoCede           DECIMAL(14,2);
	DECLARE Var_Tasa				DECIMAL(14,4);

	-- Asignacion de Constantes.
	SET	Entero_Cero		:=	0;								-- Constante '0' Entero Cero.
	SET	Entero_Uno		:=	1;								-- Constante '0' Entero Cero.
	SET DecimalCero		:=	0.0;							-- Contante '0.0' DECIMAL Cero.
	SET	CadenaVacia		:=	'';								-- Constante '' Cadena Vacia.
	SET FechaVacia		:=	'1900-01-01';					-- Constante '1900-01-01' Fecha Vacia.
	SET SalidaNO		:=	'N';							-- Constante Salida NO 'N'.
	SET SalidaSI        :=  'S';                            -- Constante Salida SI 'S'
	SET	EstatusVigente	:=	'N';							-- Constante Estatus Vigente 'N'.
	SET Mov_PagIntExe   := 	'504';        					-- INTERESES GENERADOS
	SET Cue_PagIntExe   := 	'INTERESES GENERADOS';			-- Descripcion Pago CEDE Interes Excento.
	SET Mov_PagIntGra   := 	'503';        					-- INTERESES GENERADOS
	SET Cue_PagIntGra   := 	'INTERESES GENERADOS';			-- Descripcion Pago CEDE Interes Gravado.
	SET TasaFija		:=	1;								-- Indica que la CEDE es de TASA FIJA.
	SET Pol_Automatica  := 	'A'; 		  					-- Constante Poliza Automatica.
	SET Mov_PagCedCap   := 	'502';        					-- VENCIMIENTO DE INVERSION.
	SET Var_RefPagoCed  := 	'VENCIMIENTO DE INVERSION';		-- Descripcion Pago de CEDE.
	SET Var_PagoCeder   := 	902;							-- Concepto Contable: Pago de CEDE
	SET Var_ConCedCapi  := 	1;           					-- Concepto Contable de CEDE: Capital
	SET Con_Capital     := 	1;           					-- Concepto Contable de Ahorro: Capital
	SET Nat_Abono       := 	'A';         					-- Naturaleza de Abono
	SET Nat_Cargo       := 	'C';        					-- Naturaleza de Cargo
	SET AltPoliza_NO    := 	'N';         					-- Alta de la Poliza NO
	SET Mov_AhorroSI    := 	'S';         					-- Movimiento de Ahorro: SI
	SET Var_ConCedProv  := 	5;           					-- Concepto Contable de CEDE: Provision
	SET Tipo_Provision  := 	'100';       					-- Tipo de Movimiento de CEDE: Provision
	SET Cue_RetCeder    := 	'RETENCION ISR';				-- Descripcion Retencion ISR.
	SET Mov_PagCedRet   := 	'505';        					-- RETENCION ISR
	SET Ope_Interna     := 	'I';         					-- Tipo de Operacion: Interna
	SET Tip_Compra      := 	'C';        					-- Tipo de Operacion: Compra de Divisa
	SET NombreProceso   := 	'CEDE'; 						-- Descripcion Proceso CEDE.
	SET Var_ConCedISR   := 	4;           					-- Concepto Contable de CEDE: Retencion
	SET Mov_AhorroNO    := 	'N';         					-- Movimiento de Ahorro: NO
	SET Var_ConConReinv	:= 11;								-- Descripcion reinversion
	SET Var_ConInvCapi	:= 1;								-- Movimiento Inversion Capital
	SET Var_ConAhoCapi 	:= 1;								-- Movimieto Ahorro
	SET Mov_ApeCede		:= '501';   						-- Apertura de CEDE Tabla TIPOSMOVSAHO.
	SET Var_ConAltCed   := 900;								-- Movimiento Cede
	SET Var_ConCedeCapi	:= 1;								-- ConceptosAhorro.
	SET StringSI		:='S';								-- Contante SI.
	SET EstPagado		:= 'P';								-- Constante Estatus Pagado
	SET ProcesoDesdePant:= 'P';								-- Constante Estatus Pagado
	SET Impreso			:= 'I';								-- Constante Estatus Impreso
	SET SabDom			:= 'SD';				            -- Dia Inhabil: Sabado y Domingo
	SET No_DiaHabil		:= 'N';					            -- No es dia habil
	SET EstVigente      := 'N';                             -- Valor Estatus Vigente
	SET Est_Aplicado    := 'A';                             -- Valor Estatus Vigente
	SET CalculoISRxCli  := 'C';         					-- Tipo de Calculo ISR por cliente
	SET InstCede  		:= 28;         						-- Tipo de Calculo ISR por cliente
	SET ISRpSocio		:= 'ISR_pSocio';					-- constante para isr por socio de PARAMGENERALES
    SET Con360			:=	360;
	SET ConCien			:=	100;
	SET ConCinco		:=	5;
	SET EnteroUno		:= 1;
	SET Aud_FechaActual	:= NOW();
	SET InsCede						:= 28;					-- Tipo de instrumento cedes.
    SET Par_TipoRegisPantalla		:= 'P'; 				-- Proceso en pantalla
	SET ValorUMA					:='ValorUMABase';

	-- Asignacion de Variable.
	SET Var_CedeID				:=	Entero_Cero;			-- CEDE a Pagar.
	SET Var_CuentaAhoID			:=	Entero_Cero;			-- CuentaAho relacionada a la CEDE.
	SET Var_TipoCedeID			:=	Entero_Cero;			-- Tipo de CEDE.
	SET Var_MonedaID			:=	Entero_Cero;			-- MonedaID.
	SET Var_Capital				:=	DecimalCero;			-- Capital a Pagar.
	SET Var_Interes				:=	DecimalCero;			-- Interes a Pagar.
	SET Var_InteresRetener		:=	DecimalCero;			-- Interes a Reterner.
	SET Var_ClienteID			:=	Entero_Cero;			-- Cliente al que Pertenece la CEDE.
	SET Var_SaldoProvision		:=	DecimalCero;			-- Provision a Pagar.
	SET Var_SucursalOrigen		:=	Entero_Cero;			-- Sucursal Origen del Cliente.
	SET Var_AmotizacionID		:=	Entero_Cero;			-- Numero de Amortizacion a Pagar.
	SET Var_CedeFecVencimiento	:=	FechaVacia;				-- Fecha de Vencimiento de la CEDE.
	SET Var_AmoFecVecimiento	:=	FechaVacia;				-- Fecha de Vencimiento de la Amortizacion.
	SET Var_FecIniciaAmo		:=	FechaVacia;				-- Fecha de Vencimiento de la Amortizacion.
	SET Var_FecVenciAmo			:=	FechaVacia;				-- Fecha de Vencimiento de la Amortizacion.

	SET Var_CalculoInteres		:=	Entero_Cero;			-- Tipo de Calculo a Aplicar para el Interes.
	SET Var_InteresPagar		:=	DecimalCero;			-- Interes a Pagar.
	SET Var_MonedaBase			:=	Entero_Cero;			-- Moneda Base.
	SET Var_NumVenAmor			:=	Entero_Cero;			-- Numero de Amortiaciones que Vencen.
	SET Var_MovIntere			:=	CadenaVacia;			-- Inicializacion de Variables
	SET Cue_PagIntere			:=	CadenaVacia;			-- Inicializacion de Variables

	SET Var_NuevaCedeID			:=	Entero_Cero;			-- Inicializacion de Variables
	SET Var_TasaISR				:=	DecimalCero;			-- Inicializacion de Variables

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-PAGOCEDEINDPRO');
				SET Var_Control := 'SQLEXCEPTION' ;
		END;

		-- Inicia Proceso de Pago de CEDE.
		-- Obtenemos la Fecha del Sistema y la Moneda Base
		SELECT		FechaSistema,       MonedaBaseID,	SalMinDF,		FechaISR
			INTO 	Var_FechaSistema,   Var_MonedaBase,	Var_SalMinDF, 	Var_FechaISR
		FROM PARAMETROSSIS;

		SELECT ValorParametro
			INTO Var_DiasInversion
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;

		SELECT ValorParametro INTO Var_ISR_pSocio
			FROM 	PARAMGENERALES
				WHERE 	LlaveParametro	= ISRpSocio;

		SET Var_ISR_pSocio	:= IFNULL(Var_ISR_pSocio , SalidaNO);


        SELECT 	Suc.TasaISR, 	Cli.PagaISR
				INTO 	Var_TasaISR, 	Var_PagaISR
				FROM	CLIENTES Cli,
						SUCURSALES Suc
				WHERE 	Cli.ClienteID	= Par_ClienteID
                AND 	Suc.SucursalID	= Cli.SucursalOrigen;

		SET SalMinAnuDF :=	Var_SalMinDF*ConCinco*Var_DiasInversion;


		-- Obtenemos las Amortizaciones con Fecha de Vencimiento Menor o Igual a la Actual.
		SELECT	MIN(cede.CedeID),		MIN(cede.CuentaAhoID),		MIN(cede.TipoCedeID),		MIN(cede.MonedaID),   		SUM(amo.Capital),
				SUM(amo.Interes),		SUM(amo.ISRCal), 			MIN(cede.ClienteID),		MIN(cede.SaldoProvision),	MIN(cte.SucursalOrigen),
				MAX(amo.AmortizacionID),MAX(cede.FechaVencimiento),	MAX(amo.FechaPago),			MIN(cede.CalculoInteres),	COUNT(cede.CedeID),
				MIN(cede.CajaRetiro),	MIN(amo.FechaInicio),		MAX(amo.FechaVencimiento),	MIN(cte.PagaISR),			MIN(cede.FechaInicio)

		INTO	Var_CedeID,				Var_CuentaAhoID,			Var_TipoCedeID,				Var_MonedaID,				Var_Capital,
				Var_Interes,			Var_InteresRetener,			Var_ClienteID,				Var_SaldoProvision,			Var_SucursalOrigen,
				Var_AmotizacionID,		Var_CedeFecVencimiento,		Var_AmoFecVecimiento,		Var_CalculoInteres,			Var_NumVenAmor,
				Var_CajaRetiro,			Var_FecIniciaAmo,			Var_FecVenciAmo,			Var_CliPaISR,				Var_CedeFecIni
			FROM CEDES			cede
					INNER JOIN AMORTIZACEDES amo ON cede.CedeID = amo.CedeID AND amo.FechaPago <= Par_Fecha
													AND amo.Estatus = EstatusVigente
					INNER JOIN CLIENTES cte ON cede.ClienteID = cte.ClienteID
			  WHERE cede.Estatus = EstatusVigente
				AND cede.CedeID =Par_CedeID ;

		SET Var_NumVenAmor		:=	IFNULL(Var_NumVenAmor,Entero_Cero);

		-- Obtenemos el Dia Inhabil del Tipo de CEDE
		SELECT DiaInhabil INTO	Var_DiaInhabil FROM TIPOSCEDES WHERE TipoCedeID = Var_TipoCedeID;
		/*VALIDA QUE EL EVENTO SE ESTE REALIZANDO EN UN DIA HABIL Y QUE NO SE TRATE DE LA IMPRESION DEL PAGARE*/
		IF(Var_DiaInhabil = SabDom)THEN
			CALL DIASFESTIVOSABDOMCAL(
				Par_Fecha,			Entero_Cero, 		Var_FecSal, 		Var_EsHabil,		Par_Empresa,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion	);

			IF(Var_EsHabil = No_DiaHabil)THEN
				SET Par_NumErr	:=	06;
				SET Par_ErrMen	:=	CONCAT('El Tipo de CEDE ', Par_TipoCedeID,' Tiene Parametrizado Dia Inhabil: Sabado y Domingo
									por tal Motivo No se Puede Registrar el CEDE.');
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Obtenemos si la fecha es habil o no del Tipo de CEDE Dia Inhabil: Sabado y Domingo
		IF(Var_DiaInhabil = SabDom)THEN
			CALL DIASFESTIVOSABDOMCAL(
				Var_FechaSistema,	Entero_Cero, 		Var_FecSal, 		Var_EsHabil,		Par_Empresa,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion	);
		END IF;

		-- Si hay Amorizaciones que Vencen en la Fecha Indicada se da de Alta una Poliza.
		IF(Var_NumVenAmor > Entero_Cero) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Par_Empresa,    	Par_Fecha,      Pol_Automatica,     Var_PagoCeder,
				Var_RefPagoCed, 	SalidaNO,       	Par_NumErr,		Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Aud_FechaActual	:= NOW();
		SET Var_InteresPagar := Entero_Cero;

		IF(Var_Capital > Entero_Cero) THEN
			-- Se Genera el Movimiento Contable para el Pago de Capital de la CEDE.
			CALL CONTACEDESPRO(
				Var_CedeID,			Par_Empresa,        Par_Fecha,          Var_Capital,   		Mov_PagCedCap,
				Var_PagoCeder,      Var_ConCedCapi,     Con_Capital,        Nat_Abono,      	AltPoliza_NO,
				Mov_AhorroSI,       SalidaNO,			Par_Poliza,         Par_NumErr,			Par_ErrMen,
				Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,    Aud_ProgramaID,		Var_SucursalOrigen, Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- ============================== ISR POR CLIENTE ======================================================

        	CALL CALCULOISRINSTPRO(
				Var_FechaSistema,	Par_ClienteID,		Par_TipoRegisPantalla,	SalidaNO,			Par_NumErr,
				Par_ErrMen,			Par_Empresa,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					SET Var_InteresRetener	:= 	FNTOTALISRCTE(Par_ClienteID,InstCede,Par_CedeID);


 		-- ==============================FIN ISR POR CLIENTE======================================================


		-- Se Verifica si el Pago sera Excento o Gravado para la Descripciones de los Movimientos.
		IF (Var_InteresRetener = Entero_Cero) THEN
			SET Var_MovIntere := Mov_PagIntExe;
			SET Cue_PagIntere := Cue_PagIntExe;
		ELSE
			SET Var_MovIntere := Mov_PagIntGra;
			SET Cue_PagIntere := Cue_PagIntGra;
		END IF;


		IF(Var_CalculoInteres = TasaFija) THEN
			 SET Var_InteresPagar := Var_Interes;
		ELSE
			SET Var_InteresPagar := Var_SaldoProvision;
		END IF;

		IF (Var_InteresPagar > Entero_Cero) THEN
			-- Se Genera la Contable del Pago de Interes de la CEDE.
			CALL CONTACEDESPRO(
				Var_CedeID,			Par_Empresa,        Par_Fecha,          Var_InteresPagar,		Var_MovIntere,
				Var_PagoCeder,      Var_ConCedProv,     Con_Capital,        Nat_Abono,				AltPoliza_NO,
				Mov_AhorroSI,       SalidaNO,			Par_Poliza,         Par_NumErr,				Par_ErrMen,
				Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaID,		Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,    Aud_ProgramaID,		Var_SucursalOrigen, Aud_NumTransaccion  );

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Se Genera el Movimiento Operativo para el Pago de Interes de la CEDE.
			CALL CEDESMOVALT(
				Var_CedeID,			Par_Fecha,      	Tipo_Provision,		Var_InteresPagar,		Nat_Abono,
				Cue_PagIntere,		Var_MonedaID,   	SalidaNO,			Par_NumErr,				Par_ErrMen,
				Par_Empresa,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion  );

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			 SET Var_Instrumento := CONVERT(Var_CedeID, CHAR);

			SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);

            -- Se obtiene el Monto de la CEDE
			SET Var_MontoCede 	:= (SELECT Monto FROM CEDES WHERE CedeID = Var_CedeID);
			SET Var_MontoCede	:= IFNULL(Var_MontoCede,DecimalCero);

			SET Var_Tasa	:=(SELECT TasaFija FROM CEDES WHERE CedeID = Var_CedeID);
			SET Var_Tasa	:=IFNULL(Var_Tasa,Entero_Cero);

            -- Registro de informacion para el Calculo del Interes Real para Cedes
			CALL CALCULOINTERESREALALT (
				 Var_ClienteID,			Par_Fecha,				InstCede,				Var_CedeID,				Var_MontoCede,
				 Var_InteresPagar,		Var_InteresRetener,		Var_Tasa,				Var_FecIniciaAmo,		Var_FecVenciAmo,
				 Par_Empresa,			Aud_Usuario,			Aud_FechaActual,   		Aud_DireccionIP,		Aud_ProgramaID,
				 Aud_Sucursal,			Aud_NumTransaccion);
		END IF;

		IF (Var_InteresRetener > DecimalCero) THEN
			-- Se Genera el Movimiento Operativo para el Cobro del Interes a Retener.
			IF(IFNULL(Var_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr	:= 2;
				SET Par_ErrMen  := 'El Numero de Cuenta esta Vacio.';
				SET Var_Control := 'cedeID';
				LEAVE ManejoErrores;
			ELSE
				-- STORE PARA REALIZAR EL CARGO O EL ABONO A UNA CUENTA
				CALL CARGOABONOCUENTAPRO(
					Var_CuentaAhoID,	Var_ClienteID,		Aud_NumTransaccion,	Par_Fecha,			Par_Fecha,
					Nat_Cargo,			Var_InteresRetener,	Cue_RetCeder,		Var_CuentaStr,		Mov_PagCedRet,
					Var_MonedaID,		Var_SucursalOrigen,	AltPoliza_NO,		Entero_Cero,		Par_Poliza,
					Mov_AhorroSI,		Con_Capital,		Nat_Cargo,			Var_Consecutivo,	SalidaNO,
                    Par_NumErr,			Par_ErrMen,			Par_Empresa,		Aud_Usuario,        Aud_FechaActual,
                    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			IF (Var_MonedaBase != Var_MonedaID) THEN

				SELECT TipCamComInt INTO Var_TipCamCom
					FROM MONEDAS
					WHERE MonedaId = Var_MonedaID;

				SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, 2);

				CALL COMVENDIVISAALT(
					Var_MonedaID,   	Aud_NumTransaccion,     Par_Fecha,          Var_InteresRetener,		Var_TipCamCom,
					Ope_Interna,        Tip_Compra,         	Var_Instrumento,	Var_RefPagoCed, 		NombreProceso,
					Par_Poliza,       	Par_Empresa, 			Aud_Usuario,  		Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,		Var_SucursalOrigen,
					Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			ELSE
				SET Var_IntRetMN = Var_InteresRetener;
			END IF;

				/* SE GENERA LA CONTABILIDAD DEL PAGO DE LA CEDE */
			CALL CONTACEDESPRO(
				Var_CedeID,			Par_Empresa,		Par_Fecha,				Var_IntRetMN,			CadenaVacia,
				Var_PagoCeder,		Var_ConCedISR,		Entero_Cero,			Nat_Abono,				AltPoliza_NO,
				Mov_AhorroNO,		SalidaNO,			Par_Poliza,				Par_NumErr,				Par_ErrMen,
				Var_CuentaAhoID,	Var_ClienteID,		Var_MonedaBase,			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Var_SucursalOrigen,		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		UPDATE AMORTIZACEDES Amo SET
			Amo.Estatus		= EstPagado,
			EmpresaID 		= Par_Empresa,
			Usuario 		= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID 		= Aud_ProgramaID,
			Sucursal 		= Aud_Sucursal,
			NumTransaccion 	= Aud_NumTransaccion
		WHERE Amo.CedeID	=	Par_CedeID
		  AND Amo.Estatus	=	EstVigente
		  AND Amo.FechaPago <= Par_Fecha;

		UPDATE CEDES SET
			Estatus 		= EstPagado,
			ISRReal			= ISRReal  + Var_InteresRetener,
			EmpresaID 		= Par_Empresa,
			UsuarioID 		= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID 		= Aud_ProgramaID,
			Sucursal 		= Aud_Sucursal,
			NumTransaccion 	= Aud_NumTransaccion
		WHERE CedeID		= Par_CedeID;

		-- ============================== ACTUALIZA EL COBROISR ======================================================
				UPDATE COBROISR isr
						SET Estatus = Est_Aplicado
					WHERE ClienteID 	= Var_ClienteID
					AND ProductoID		= Par_CedeID
					AND InstrumentoID	= InstCede;
		-- ==============================          FIN           ======================================================

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen  := 'CEDE Abonada Correctamente.';
		SET Var_Control := 'cedeID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr		 AS NumErr,
				Par_ErrMen		 AS ErrMen,
				Var_Control      AS control,
				Var_NuevaCedeID	 AS consecutivo;
	END IF;
END TerminaStore$$