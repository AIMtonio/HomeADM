-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENINTMORCREPASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENINTMORCREPASPRO`;
DELIMITER $$


CREATE PROCEDURE `GENINTMORCREPASPRO`(
	/* Nuevo SP para la generacion de Interes Moratorios de la Cartera Pasiva en
		el cierre de dia */
		Par_Fecha			date,
		Par_EmpresaID		int,

		Aud_Usuario			int,
		Aud_FechaActual		DateTime,
		Aud_DireccionIP		varchar(15),
		Aud_ProgramaID		varchar(50),
		Aud_Sucursal		int,
		Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_CreditoFondeoID	int;				/* ID de credito pasivo*/
DECLARE Var_AmortizacionID	int;				/* ID de amortizacion*/
DECLARE Var_FechaInicio		date;				/* Fecha de inicio */
DECLARE Var_FechaVencim		date;				/* Fecha de Vencimiento */
DECLARE Var_FechaExigible	date;				/* Fecha exigible*/

DECLARE Var_FormulaID 		int(11);			/* guarda el tipo de interes */
DECLARE Var_TasaFija 		DECIMAL(12,4);		/* Tasa Fija*/
DECLARE Var_MonedaID		int(11);			/* ID de la Moneda*/
DECLARE Var_FactorMora		decimal(10,4);		/* Factor Mora*/
DECLARE Var_MontoComFalPag	decimal(14,4);		/* Monto de la comision por falta de pago*/

DECLARE Var_CreditoFonStr	varchar(30);		/* String del ID de credito pasivo*/
DECLARE Var_ValorTasa		DECIMAL(12,4);		/* valor de la tasa */
DECLARE Var_DiasCredito		DECIMAL(10,2);		/* Dias de credito */
DECLARE Var_IntereMor		DECIMAL(12,4);		/* Valor del interes moratorio generado */
DECLARE Var_MontoFalPag		DECIMAL(14,4);		/* Valor de la comision por falta de pago */

DECLARE Var_FecMorato		date;				/* Fecha a cobrar Moratorios*/
DECLARE Var_FecFalPago		date;				/* Fecha a cobrar Comision por falta de pago */
DECLARE Var_CobFaltaPago	char(1);			/* indica si cobra o no comision por falta de pago por cada cuota */
DECLARE Var_CobraMora		char(1);			/* indica si cobra o no mora  */
DECLARE Var_FecApl			date;				/* Fecha de Aplicacion */

DECLARE Var_EsHabil			char(1);			/* Fecha Habil*/
DECLARE SalCapital			decimal(14,2);		/* Saldo de capital */
DECLARE DiasInteres			decimal(10,2);		/* DIas de interes */
DECLARE Error_Key			int;				/* variable para llevar el control de los errores */
DECLARE Par_NumErr			int(11);			/* numero de error  */

DECLARE Par_ErrMen			varchar(400);		/* mensaje de error  */
DECLARE Var_Poliza			bigint;				/* numero de poliza */
DECLARE Sig_DiaHab			date;				/* Dia habil siguiente */
DECLARE Par_Consecutivo		bigint;				/* Consecutivo */

DECLARE Var_ContadorCre		int;				/* contador para saber cuantos creditos aplican en moratorios */
DECLARE Var_DifMorMov		decimal(14,2);		/* almacena el valor del abonos - cargos  de los movimientos cuando se cobra mora y los dias de gracia ya vencieron*/
DECLARE Var_AplFaltaPago	char(1);			/* variable para saber si aplica comision falta pago */
DECLARE Var_InstitutFondID	int(11);			/* Institucion de Fondeo */
DECLARE Var_PlazoContable	char(1);			/* plazo contable C.- Corto plazo L.- Largo Plazo*/

DECLARE Var_TipoInstitID	int(11);			/* Corresponde con el campo TipoInstitID deL Credito Pasivo */
DECLARE Var_NacionalidadIns	char(1);			/* Especifica la nacionalidad de la institucion */
DECLARE Var_EstAmortiza		char(1);			/* Estatus de la amortizacion  */
DECLARE Var_TipoFondeador   char(1);
DECLARE Var_TipCobComMora	char(1);			/* Tipo de cobro de la comision moratorio */
DECLARE Var_tipCambMon		DECIMAL(14,6);		/*Tipo de cambio para moneda*/
DECLARE Var_IntereMorMN		DECIMAL(16,4);		/*Valor del interes moratorio para moneda nacional */
DECLARE Var_MontoFalPagMN 	DECIMAL(14,4);		/*Comision por Falta de pago para moneda nacional */

/* Declaracion de Constantes */
DECLARE Cadena_Vacia		char(1);
DECLARE Fecha_Vacia			date;
DECLARE Entero_Cero			int;
DECLARE Decimal_Cero		decimal(12, 2);
DECLARE Decimal_Cien		decimal(10,2);

DECLARE Nat_Cargo			char(1);
DECLARE Nat_Abono			char(1);
DECLARE Pro_PasoAtras		int;
DECLARE Mov_IntMor			int;
DECLARE Mov_ComFalPago		int;

DECLARE Con_CueOrdMor		int;
DECLARE Con_CorOrdMor		int;
DECLARE Con_CueOrdComFP		int;
DECLARE Con_CorOrdComFP		int;
DECLARE Pol_Automatica		char(1);

DECLARE Con_GenIntere		int;			-- Concepto Contable: Generacion de Interes Cartera Pasiva	tabla. CONCEPTOSCONTA
DECLARE Par_SalidaNO		char(1);
DECLARE AltaPoliza_NO		char(1);
DECLARE AltaPolCre_SI		char(1);
DECLARE AltaMovCre_SI		char(1);

DECLARE AltaMovCre_NO		char(1);
DECLARE AltaMovTes_NO		char(1);
DECLARE Des_CieDia			varchar(100);
DECLARE TipoMovCapOrd		int;
DECLARE SI_CobraMora		char(1);

DECLARE SI_CobraFalPag		char(1);
DECLARE NO_CobraFalPag		char(1);
DECLARE Var_SalidaNO        char(1);
DECLARE Ref_GenInt          varchar(50);
DECLARE Enc_PolGenIntMor    varchar(50);


DECLARE Est_Atrasado		char(1);
DECLARE Est_Vigente			char(1);
DECLARE Mora_NVeces			char(1);
DECLARE Moneda_Pesos		INT(11);

-- Cursor para Obtener todas la cuotas que Presentan atrasado (Considerando Dias de Gracia)
DECLARE CURSORINTERMOR CURSOR FOR
		select	CreditoFondeoID,	AmortizacionID,		FechaInicio,		FechaVencimiento,	FechaExigible,
				CalcInteresID,		TasaFija,			MonedaID,			TipoInstitID,		NacionalidadIns,
				PlazoContable,		FactorMora,			SaldoCapital,		AmoFecGraMora,		AmoFecGraCom,
				CobraFaltaPago,		MontoComFalPag,		CobraMora,			InstitutFondID,		EstatusAmorti,
             TipoFondeo, TipCobComMorato
			from TMPCREPASCIEMOR
			where ( AmoFecGraMora	<= Par_Fecha
			 or   AmoFecGraCom	<= Par_Fecha);

truncate table TMPCREPASCIEMOR;

INSERT INTO TMPCREPASCIEMOR	(
			CreditoFondeoID,				AmortizacionID,					FechaInicio,				FechaVencimiento,				FechaExigible,
			CalcInteresID,					TasaFija,						MonedaID,					TipoInstitID,					NacionalidadIns,
			PlazoContable,					FactorMora,						SaldoCapital,				AmoFecGraMora,					AmoFecGraCom,
			CobraFaltaPago,					MontoComFalPag,					CobraMora,					InstitutFondID,					EstatusAmorti,
			TipoFondeo,						TipCobComMorato)
	select	Cre.CreditoFondeoID,	Amo.AmortizacionID,		Amo.FechaInicio,	Amo.FechaVencimiento,	Amo.FechaExigible,
			Cre.CalcInteresID,		Cre.TasaFija,			Cre.MonedaID,		Cre.TipoInstitID,		Cre.NacionalidadIns,
			Cre.PlazoContable,		Cre.FactorMora,			Amo.SaldoCapVigente,
			 -- Este Case se puso aqui, para discriminar y no evaluar aquellas amortizaciones
			 -- muy Viejas (Cuya Fecha de Exigibilidad tiene mas de los Dias de gracia
			 -- del producto mas 15 dias de "Colchon") para que no evalue la funcion FUNCIONDIAHABIL
			 -- Esto para ayudar a mejorar el preformance del cierre y hacer menos evaluaciones.
			case when Amo.FechaExigible < DATE_SUB(Par_Fecha, INTERVAL (DiasGraciaMora + 15 ) DAY) then
						Amo.FechaExigible
				  else
						FUNCIONDIAHABIL(Amo.FechaExigible, DiasGraciaMora, Par_EmpresaID)
			end,
				case when Amo.FechaExigible < DATE_SUB(Par_Fecha, INTERVAL (DiasGraFaltaPag + 15 ) DAY) then
						   Amo.FechaExigible
					  else
							FUNCIONDIAHABIL(Amo.FechaExigible, DiasGraFaltaPag, Par_EmpresaID)
				end,  		Lin.CobraFaltaPago,
            Lin.MontoComFalPag,		Lin.CobraMoratorios, 			Cre.InstitutFondID, 	Amo.Estatus,
            Cre.TipoFondeador, Lin.TipoCobroMora
				from	AMORTIZAFONDEO	Amo,
					CREDITOFONDEO	Cre,
					LINEAFONDEADOR	Lin
				where Amo.CreditoFondeoID	=	Cre.CreditoFondeoID
              and Lin.LineaFondeoID		= 	Cre.LineaFondeoID
				  and ( Amo.Estatus			=	'N'         -- Vigente
               or   Amo.Estatus			=	'A' )       -- En Atraso
				  and Cre.Estatus			=	'N'
				  and Amo.FechaExigible		<=	Par_Fecha;

/* Asignacion de Constantes */
Set Cadena_Vacia	:= '';					-- Cadena Vacia
Set Fecha_Vacia		:= '1900-01-01';		-- Fecha Vacia
Set Entero_Cero		:= 0;					-- Entero en Cero
Set Decimal_Cero	:= 0.00;				-- Decimal Cero
Set Nat_Cargo		:= 'C';					-- Naturaleza de Cargo
Set Nat_Abono		:= 'A';					-- Naturaleza de Cargo
Set Decimal_Cien	:= 100.00;				-- Decimal Cien
Set Pro_PasoAtras	:= 302;					-- Numero de Proceso Batch: Trapsaso a Atrasado
Set Mov_IntMor		:= 15;					-- Tipo de Movimiento de Credito Pasivo: Interes Moratorio .- TIPOSMOVSFONDEO
Set Mov_ComFalPago	:= 40;					-- Tipo de Movimiento de Credito Pasivo: Comision x Falta de Pago .- TIPOSMOVSFONDEO
Set Con_CueOrdMor	:= 13;					-- Concepto Contable: Cuentas de Orden de Moratorios.- CONCEPTOSFONDEO
Set Con_CorOrdMor	:= 14;					-- Concepto Contable: Correlativa de Orden de Moratorios .- CONCEPTOSFONDEO
Set Con_CueOrdComFP	:= 15;					-- Concepto Contable: Cuentas de Orden Comision Falta de Pago.- CONCEPTOSFONDEO
Set Con_CorOrdComFP	:= 16;					-- Concepto Contable: Correlativa de Orden Comision Falta de Pago.- CONCEPTOSFONDEO
Set Pol_Automatica	:= 'A';					-- Tipo de Poliza: Automatica
Set Con_GenIntere	:= 21;					-- Concepto Contable: Generacion de Interes Moratorio Cartera Pasiva	tabla. CONCEPTOSCONTA
Set Par_SalidaNO	:= 'N';					-- El store no Arroja una Salida
Set AltaPoliza_NO	:= 'N';					-- Alta del Encabezado de la Poliza: NO
Set AltaPolCre_SI	:= 'S';					-- Alta de la Poliza de Credito: SI
Set AltaMovCre_NO	:= 'N';					-- Alta del Movimiento de Credito: SI
Set AltaMovCre_SI	:= 'S';					-- Alta del Movimiento de Credito: NO
Set AltaMovTes_NO	:= 'N';					-- Alta del Movimiento de Ahorro: NO
Set Des_CieDia		:= 'CIERRE DIARO CARTERA';
Set Ref_GenInt		:= 'GENERACION INTERES MORATORIO';
Set Enc_PolGenIntMor    := 'GEN.INT.MORATORIO CARTERA PASIVA';
Set Var_SalidaNO	:= 'N';					-- El store no Arroja una Salida

Set TipoMovCapOrd   := 1;					-- Tipo de Movimiento de Credito Pasivo: Capital Ordinario .- TIPOSMOVSFONDEO
Set SI_CobraMora    := 'S';					-- Si Cobra Interes Moratorio
Set SI_CobraFalPag  := 'S';					-- Si Cobra Comisicion por Falta de Pago
Set NO_CobraFalPag  := 'N';					-- No Cobra Comisicion por Falta de Pago
Set Est_Atrasado    := 'A';					/* Estatus Atrasado */
Set Est_Vigente     := 'N';					/* Estatus Vigente */
Set Mora_NVeces		:= 'N';					-- N Veces moratorio --
SET Moneda_Pesos	:= 1;					-- ID DE PESOS 


select DiasCredito into Var_DiasCredito
	from PARAMETROSSIS;

call DIASFESTIVOSCAL(
		Par_Fecha,			Entero_Cero,			Var_FecApl,			Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

SET Sig_DiaHab := DATE_ADD(Par_Fecha,INTERVAL 1 DAY);

select   count(CreditoFondeoID) into Var_ContadorCre
		from TMPCREPASCIEMOR;

set Var_ContadorCre := ifnull(Var_ContadorCre, Entero_Cero);

if (Var_ContadorCre > Entero_Cero) then/* Si hay creditos que entren en las condiciones*/
		call MAESTROPOLIZAALT(/*se da de alta el encabezado de la poliza */
		  Var_Poliza,       Par_EmpresaID,  Var_FecApl, Pol_Automatica,         Con_GenIntere,
		  Enc_PolGenIntMor, Par_SalidaNO,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
		  Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
end if;


OPEN CURSORINTERMOR;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORINTERMOR into
        Var_CreditoFondeoID,    Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,
        Var_FormulaID,          Var_TasaFija,       Var_MonedaID,       Var_TipoInstitID,   Var_NacionalidadIns,
        Var_PlazoContable,      Var_FactorMora,     SalCapital,         Var_FecMorato,      Var_FecFalPago,
        Var_CobFaltaPago,       Var_MontoComFalPag, Var_CobraMora,      Var_InstitutFondID, Var_EstAmortiza,
        Var_TipoFondeador, 		Var_TipCobComMora;

		START TRANSACTION;
		BEGIN
		 /* DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		  DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		  DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		  DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4; */

		-- Inicializacion
		set Error_Key			:= Entero_Cero;
		set DiasInteres			:= Entero_Cero;
		set Var_IntereMor		:= Entero_Cero;
		set Var_ValorTasa		:= Entero_Cero;
		set Var_AplFaltaPago	:= Cadena_Vacia;


		-- Generacion de Intereses moratorios
		if(Var_FecMorato <= Par_Fecha and Var_CobraMora = SI_CobraMora) then
			set SalCapital		:= ifnull(SalCapital,Entero_Cero);

			/* se calcula el valor de la tasa */
			call CREPASCALCTASAPRO(
				Var_CreditoFondeoID,		Var_FormulaID,		Var_TasaFija,		Par_EmpresaID,		Var_ValorTasa,
				Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			/*se generan los intereses
			  desde el primer dia de no pago hasta el dia de hoy. */
			-- set Var_FactorMora  = Var_FactorMora * Var_ValorTasa;
			if (Var_TipCobComMora = Mora_NVeces) then
				set Var_FactorMora  = Var_FactorMora * Var_ValorTasa;
			end if;

			if (Var_FecMorato = Par_Fecha) then
				-- Calculo de la Mora Acumulada por los Pagos Realizados en el Transcurso de los
				-- Dias de Gracia para la Generacion de Moratorios
				set Var_DifMorMov := ifnull(
						  (select sum(datediff(FechaOperacion, Var_FechaExigible) * (Var_FactorMora) *
										(ifnull(LOCATE(Nat_Abono, Mov.NatMovimiento) * ifnull(Mov.Cantidad, Decimal_Cero), Decimal_Cero) -
										 ifnull(LOCATE(Nat_Cargo, Mov.NatMovimiento) * ifnull(Mov.Cantidad, Decimal_Cero), Decimal_Cero)) /
										(Var_DiasCredito * Decimal_Cien))
							  from CREDITOFONDMOVS Mov
								  where	CreditoFondeoID	= Var_CreditoFondeoID
								  and	FechaOperacion	> Var_FechaExigible
								  and	FechaOperacion	<= Par_Fecha
								  and	AmortizacionID	= Var_AmortizacionID
								  and	TipoMovFonID	= TipoMovCapOrd), Decimal_Cero);

				set	DiasInteres = (select datediff( Sig_DiaHab,Var_FechaExigible));

				set Var_IntereMor = (round(SalCapital *  Var_FactorMora /
										(Var_DiasCredito * Decimal_Cien) * DiasInteres, 2)  + Var_DifMorMov);
			else
				-- cuando ya pasaron sus dias de Gracia, se generan los intereses moratorios del dia
				set DiasInteres	= datediff(Sig_DiaHab, Par_Fecha);
				set SalCapital:=ifnull(SalCapital,Entero_Cero);
				set	Var_IntereMor = round(SalCapital * Var_FactorMora * DiasInteres /
									(Var_DiasCredito * Decimal_Cien), 2);
			end if; -- EndIF del Tipo de Calculo de los Moratorios

			-- se realizan los movimientos contables y operativos del cargo por interes moratorio
			if (Var_IntereMor > Decimal_Cero) then
				call CONTAFONDEOPRO( /* se generan los movimientos contables y operativos para Cuentas de Orden de Moratorio  */
                Var_MonedaID,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
                Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
                Var_NacionalidadIns,    Con_CueOrdMor,          Des_CieDia,         Par_Fecha,
                Var_FecApl,             Var_FecApl,             Var_IntereMor,      Ref_GenInt,
                Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Cargo,
                Cadena_Vacia,           Nat_Cargo,              Cadena_Vacia,       AltaMovTes_NO,
                Cadena_Vacia,           AltaMovCre_SI,          Var_AmortizacionID, Mov_IntMor,
                AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
                Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,           Aud_NumTransaccion);

				call CONTAFONDEOPRO( -- /* se generan los movimientos contables para  Correlativa Cuentas de Orden de Moratorios */
                Var_MonedaID,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
                Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
                Var_NacionalidadIns,    Con_CorOrdMor,          Des_CieDia,         Par_Fecha,
                Var_FecApl,             Var_FecApl,             Var_IntereMor,      Ref_GenInt,
                Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Abono,
                Cadena_Vacia,           Nat_Abono,              Cadena_Vacia,       AltaMovTes_NO,
                Cadena_Vacia,           AltaMovCre_NO,          Var_AmortizacionID, Mov_IntMor,
                AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
                Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,           Aud_NumTransaccion  );
                
                if(Var_MonedaID != Moneda_Pesos) then 
					SELECT 		TipCamDof 
						INTO 	Var_tipCambMon 
						FROM MONEDAS 
						WHERE MonedaId = Var_MonedaID;

					SET Var_tipCambMon := IFNULL(Var_tipCambMon, Entero_Cero);

					SET Var_IntereMorMN := Var_IntereMor * Var_tipCambMon;
					SET Var_IntereMorMN := IFNULL(Var_IntereMorMN, Entero_Cero);

					IF(Var_IntereMorMN > Entero_Cero) THEN
						/* Movimientos cantaples para moneda estrangea*/
		                call CONTAFONDEOPRO( /* se generan los movimientos contables y operativos para Cuentas de Orden de Moratorio  */
		                Moneda_Pesos,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
		                Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
		                Var_NacionalidadIns,    Con_CueOrdMor,          Des_CieDia,         Par_Fecha,
		                Var_FecApl,             Var_FecApl,             Var_IntereMorMN,      Ref_GenInt,
		                Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Cargo,
		                Cadena_Vacia,           Nat_Cargo,              Cadena_Vacia,       AltaMovTes_NO,
		                Cadena_Vacia,           AltaMovCre_NO,          Var_AmortizacionID, Mov_IntMor,
		                AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
		                Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
		                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
		                Aud_Sucursal,           Aud_NumTransaccion);

						call CONTAFONDEOPRO( -- /* se generan los movimientos contables para  Correlativa Cuentas de Orden de Moratorios */
		                Moneda_Pesos,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
		                Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
		                Var_NacionalidadIns,    Con_CorOrdMor,          Des_CieDia,         Par_Fecha,
		                Var_FecApl,             Var_FecApl,             Var_IntereMorMN,      Ref_GenInt,
		                Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Abono,
		                Cadena_Vacia,           Nat_Abono,              Cadena_Vacia,       AltaMovTes_NO,
		                Cadena_Vacia,           AltaMovCre_NO,          Var_AmortizacionID, Mov_IntMor,
		                AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
		                Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
		                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
		                Aud_Sucursal,           Aud_NumTransaccion  );
					END IF;
                end if;
			end if; -- Endif de Var_IntereMor (Moratorios) mayor que cero

		end if; -- EndIf Generacion de Intereses moratorios

      -- Marcamos la Amortizacion en Atraso
		if(Var_FechaExigible <= Par_Fecha and Var_EstAmortiza = Est_Vigente) then
			update AMORTIZAFONDEO set
				Estatus = Est_Atrasado
				where CreditoFondeoID	= Var_CreditoFondeoID
				 and AmortizacionID		= Var_AmortizacionID;
        end if;

		-- Comision por Falta de Pago
		if( Var_FecFalPago = Par_Fecha and Var_CobFaltaPago = SI_CobraFalPag ) then

			set Var_MontoFalPag := Var_MontoComFalPag;
			set Var_MontoFalPag := ifnull(Var_MontoFalPag, Decimal_Cero);

			if (Var_MontoFalPag > Decimal_Cero) then
				call CONTAFONDEOPRO( /* se generan los movimientos contables y operativos para Cuentas de Orden de Com. Falta Pago  */
                Var_MonedaID,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
                Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
                Var_NacionalidadIns,    Con_CueOrdComFP,        Des_CieDia,         Par_Fecha,
                Var_FecApl,             Var_FecApl,             Var_MontoFalPag,    Ref_GenInt,
                Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Cargo,
                Cadena_Vacia,           Nat_Cargo,              Cadena_Vacia,       AltaMovTes_NO,
                Cadena_Vacia,           AltaMovCre_SI,          Var_AmortizacionID, Mov_ComFalPago,
                AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
                Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,           Aud_NumTransaccion  );

				call CONTAFONDEOPRO( /* se generan los movimientos contables para  Correlativa Cuentas de Orden de Com. Falta Pago */
                Var_MonedaID,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
                Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
                Var_NacionalidadIns,    Con_CorOrdComFP,        Des_CieDia,         Par_Fecha,
                Var_FecApl,             Var_FecApl,             Var_MontoFalPag,    Ref_GenInt,
                Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Abono,
                Cadena_Vacia,           Nat_Abono,              Cadena_Vacia,       AltaMovTes_NO,
                Cadena_Vacia,           AltaMovCre_NO,          Var_AmortizacionID, Mov_ComFalPago,
                AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
                Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,           Aud_NumTransaccion  );

			end if; -- EndIf de la Comision por Falta de Pago mayor a Cero
		end if; -- End IF de si Aplica Falta de Pago
   end; -- End del Begin Handler

	set Var_CreditoFonStr = CONCAT(convert(Var_CreditoFondeoID, char), '-', convert(Var_AmortizacionID, char)) ;

	if Error_Key = 0 then
		  COMMIT;
	end if;

	if Error_Key = 1 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_PasoAtras,	Par_Fecha,			Var_CreditoFonStr,	'ERROR DE SQL GENERAL',					Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		 					Aud_Sucursal,
				Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 2 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_PasoAtras,	Par_Fecha,			Var_CreditoFonStr,	'ERROR EN ALTA, LLAVE DUPLICADA',		Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,							Aud_Sucursal,
				Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 3 then
		ROLLBACK;
		START TRANSACTION;
			call EXCEPCIONBATCHALT(
				Pro_PasoAtras,	Par_Fecha,			Var_CreditoFonStr,	'ERROR AL LLAMAR A STORE PROCEDURE',	Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,							Aud_Sucursal,
				Aud_NumTransaccion);
		COMMIT;
	end if;
	if Error_Key = 4 then
		ROLLBACK;
		START TRANSACTION;

			call EXCEPCIONBATCHALT(
				Pro_PasoAtras,	Par_Fecha,			Var_CreditoFonStr,	'ERROR VALORES NULOS.',					Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,							Aud_Sucursal,
				Aud_NumTransaccion);
		COMMIT;
	end if;

	 End LOOP;
END;
CLOSE CURSORINTERMOR;

truncate table TMPCREPASCIEMOR;

END TerminaStore$$
