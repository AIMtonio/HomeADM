-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTPROVISIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTPROVISIONPRO`;
DELIMITER $$

CREATE PROCEDURE `APORTPROVISIONPRO`(
# ==================================================================
# ---- SP QUE GENERA EL DEVENGAMIENTO DIARIO EN LAS APORTACIONES----
# ==================================================================
	Par_Fecha           DATE,				-- Fecha
	Par_EmpresaID       INT(11),			-- Numero de empresa
	Par_Salida          CHAR(1),			-- Indica si espera un SELECT de salida
	INOUT Par_NumErr    INT(11),			-- Numero de error
	INOUT Par_ErrMen    VARCHAR(400),		-- Descripcion de error

	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),

	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_AportacionID		BIGINT(12);
	DECLARE Var_Monto               DECIMAL(12,2);
	DECLARE Var_TasaNeta            DECIMAL(8,4);
	DECLARE Var_Tasa                DECIMAL(8,4);
	DECLARE Var_FechaInicio         DATE;
	DECLARE Var_FechaVencimiento    DATE;
	DECLARE Var_MonedaID            INT(11);
	DECLARE Var_MonedaBase          INT(11);
	DECLARE Var_TipoCambio          DECIMAL(14,6);
	DECLARE Var_Empresa             INT(11);
	DECLARE Var_SaldoProvision      DECIMAL(12,2);
	DECLARE Var_InteresGenerado		DECIMAL(12,2);
	DECLARE Var_TasaISR             DECIMAL(8,4);
	DECLARE Var_Dias                INT(11);
	DECLARE Var_DiasBase            INT(11);
	DECLARE Var_Provision           DECIMAL(12,2);
	DECLARE Var_Instrumento         VARCHAR(20);
	DECLARE Var_Poliza              BIGINT(12);
	DECLARE Var_ProvMN              DECIMAL(12,2);
	DECLARE Con_Egreso              INT(11);
	DECLARE Error_Key               INT DEFAULT 0;
	DECLARE Var_InverStr            VARCHAR(15);
	DECLARE Var_ContadorInv         INT(11);
	DECLARE Var_SucCliente          INT(11);
	DECLARE Var_ClienteID           INT(11);
	DECLARE Var_CalculoInteres      INT(1);
	DECLARE Var_TasaBase            INT(2);
	DECLARE Var_SobreTasa           DECIMAL(12,4);
	DECLARE Var_PisoTasa            DECIMAL(12,4);
	DECLARE Var_TechoTasa           DECIMAL(12,4);
	DECLARE VarFecPago              DATE;
	DECLARE VarFecPagoAmo           DATE;
	DECLARE Var_FechaInicioAmo		DATE;
	DECLARE Var_FechaVencimAmo      DATE;
	DECLARE Var_ISRTotalCambio		decimal(18,2);
	DECLARE Var_Dias1erPer			int(11);
	DECLARE Var_FechaFin1erPer		date;
	DECLARE Var_FechaCambioTasa		date;
	DECLARE Var_ISR1erPer			decimal(18,2);
	DECLARE Var_Dias2doPer			int(11);
	DECLARE Var_FechaFin2doPer		date;
	DECLARE Var_ISR2doPer			decimal(18,2);
	DECLARE Var_SigFecha            DATE;
	DECLARE Var_InteresAmo          DECIMAL(18,2);
	DECLARE Var_UltimoDia           CHAR(1);
	DECLARE Var_SaldoProvAmo        DECIMAL(12,2);
	DECLARE Var_SaldoISR            DECIMAL(12,2);
	DECLARE Var_SaldoISRCambio		DECIMAL(12,2);
	DECLARE Var_AmortizacionID      INT(11);
	DECLARE Var_TasaFV      		CHAR(1);
	DECLARE Fre_DiasAnio    		INT(3);
	DECLARE Var_SalMinDF    		DECIMAL(18,2);
	DECLARE Var_SalMinAn    		DECIMAL(18,2);
	DECLARE Var_ISR_pSocio			CHAR(1);				-- variable que guarda el valor si se
	DECLARE Var_FechaISR			DATE;					-- variable fecha de inicio cobro isr por socio
	DECLARE Var_TipoPagoInt 		CHAR(1); 				-- Indica si es a FIN DE MES (F) o al VENCIMIENTO (V) o por PERIODO(P)
	DECLARE Var_PagoIntCal			CHAR(2);				-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
	DECLARE Var_IntRetenerAmo		DECIMAL(18,2);			-- Variable que guarda el interes a retener por amortizacion
	DECLARE Var_TipoPeriodo			CHAR(1);
    DECLARE Var_CapitalizaInt		CHAR(1);				-- Capitaliza interes. S:Si, N:No, I:Indistinto
    DECLARE Var_InteresCuota		DECIMAL(18,2);			-- Almacena el interes de cada cuota
    DECLARE Var_SaldoCap			DECIMAL(18,2);			-- Saldo capital para aportaciones que capitalizan interes
    DECLARE Var_ISRCuota			DECIMAL(18,2);			-- Almacena el ISR de cada cuota
    DECLARE Var_BaseIsrIrre			INT(11);				-- Almacena el valor de los días base para el calculo de ISR en periodo irregular
    DECLARE Var_BaseIsrRegu			INT(11);				-- Almacena el valor de los días base para el calculo de ISR en periodo regular
    DECLARE Var_IsrDia				DECIMAL(18,2);			-- Almacena el ISR para el devengo diario
    DECLARE Var_NuevaTasaISR		DECIMAL(14,2);			-- Valor de tasa ISR configurada en la pantalla Tesoreria>Taller de Productos>Tasas Impuesto ISR
    DECLARE Var_DiasCalcIsr			INT(11);				-- Numero de días para el calculo de ISR
    DECLARE Var_DiasAmo				INT(11);				-- Numero de días de la amortización
    DECLARE Var_PlazoAmo			INT(11);				-- Plazo en días para el cálculo de ISR
    DECLARE Var_MontoAmo			DECIMAL(18,2);			-- Monto de capital para el cálculo de ISR
	DECLARE Var_PaisIDBase			INT(11);				-- ID del Pais Base (PAISES).
	DECLARE Var_HayCambioISR		INT(11);				-- Indica si existe cambio de tasa en la cuota.
	DECLARE Var_ActRetencion		CHAR(1);				-- Indica si se actualiza la retencion total por cuota.
	DECLARE Var_ExisteCambioAport	CHAR(1);				-- Indica si existe cambio de tasa en la aportacion.
	DECLARE Var_ExisteCambioAmort	CHAR(1);				-- Indica si existe cambio de tasa en la amortización.

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Est_Vigente     		CHAR(1);
	DECLARE Salida_NO       		CHAR(1);
	DECLARE Salida_SI       		CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Tipo_Provision  		CHAR(4);
	DECLARE Decimal_Cero   			DECIMAL(12,2);
	DECLARE DECIMAL_Cien    		DECIMAL(12,2);
	DECLARE Nat_Cargo       		CHAR(1);
	DECLARE Nat_Abono       		CHAR(1);
	DECLARE Tip_Venta       		CHAR(1);
	DECLARE Ref_Provision   		VARCHAR(50);
	DECLARE Ope_Interna     		CHAR(1);
	DECLARE Pol_Automatica  		CHAR(1);
	DECLARE AltaPoliza_NO   		CHAR(1);
	DECLARE Mov_AhorroNO    		CHAR(1);
	DECLARE Con_ProCed      		INT(3);
	DECLARE Pro_Interes     		INT(3);
	DECLARE Con_EgresoGra   		INT(3);
	DECLARE Con_EgresoExe   		INT(3);
	DECLARE Var_Descripcion 		VARCHAR(50);
	DECLARE Var_Referencia  		VARCHAR(50);
	DECLARE Pro_CieDiaInv   		INT(11);
	DECLARE InicioMes       		DATE;
	DECLARE DiaOperacion    		INT(11);
	DECLARE TasaFija        		CHAR(1);
	DECLARE TasaVariable    		CHAR(1);
	DECLARE IniPs           		INT(1);
	DECLARE IniPsPiTe       		INT(1);
	DECLARE AperPs          		INT(1);
	DECLARE AperPsPiTe      		INT(1);
	DECLARE PromPs          		INT(1);
	DECLARE PromPsPiTe      		INT(1);
	DECLARE NO_UltimoDia    		CHAR(1);
	DECLARE SI_UltimoDia    		CHAR(1);
	DECLARE ErrorSQL        		VARCHAR(100);
	DECLARE ErrorAlta       		VARCHAR(100);
	DECLARE ErrorLlamada    		VARCHAR(100);
	DECLARE ErrorValorNulo  		VARCHAR(100);
	DECLARE Entero_Cero     		INT(3);
	DECLARE DecimalCero     		DECIMAL(1,1);
	DECLARE ConsCien        		INT(3);
	DECLARE Cons360         		INT(3);
	DECLARE Const_NO        		CHAR(1);
	DECLARE ISRpSocio				VARCHAR(10);
	DECLARE SI_Isr_Socio  			CHAR(1);
	DECLARE ValorUMA				VARCHAR(15);
	DECLARE FinMes					CHAR(1);
	DECLARE IntDevengado			CHAR(1);
	DECLARE IntIguales				CHAR(1);
    DECLARE Cons_PagoProg			CHAR(1);			-- Constante para pago de interes programado
    DECLARE Cons_PagoVenc			CHAR(1);			-- Constante para pago de interes al vencimiento
    DECLARE Cons_PeriodoIrre		CHAR(1);			-- Constante preiodo irregular
    DECLARE Cons_PeriodoRegu		CHAR(1);			-- Constante periodo irregular
    DECLARE Cons_SI					CHAR(1);			-- Constante si
    DECLARE TipoISRRecalculo		INT(11);			-- Tipo de Recálculo en ISR

	DECLARE CURSORINVER CURSOR FOR
		SELECT  AportacionID,		Monto,                  tasaFV,         Tasa,           TasaNeta,
				TipoPagoInt,		PagoIntCal,				CalculoInteres, TasaBase,		SobreTasa,
				PisoTasa,       	TechoTasa,				FechaInicio,    FechaVencimiento,MonedaID,
				SaldoProvision, 	InteresGenerado,		TasaISR,        EmpresaID,		SucursalOrigen,
				ClienteID,      	FechaPago,				FechaPagoAmo,   FechaInicioAmo,	FechaVencimAmo,
				InteresAmo,     	IntRetenerAmo,			SaldoProvAmo,   SaldoISR,		AmortizacionID,
                TipoPeriodo,		PagoIntCapitaliza, 		SaldoCap,		DiasAmo
			FROM	TMPRENDIMIENTOAPORT
			WHERE 	FechaCalculo	= Par_Fecha;

	-- Asignacion de Constantes
	SET Cadena_Vacia    			:= '';                  			-- Constante Cadena Vacia
	SET Est_Vigente    				:= 'N';                 			-- Estatus Vigente
	SET Salida_NO       			:= 'N';                				-- Constante Salida No
	SET Salida_SI       			:= 'S';                 			-- Constante Salida No
	SET Fecha_Vacia     			:= '1900-01-01';       				-- Constante Fecha Vacia
	SET Tipo_Provision  			:= '100';              				-- Tipo de Provision
	SET Decimal_Cero   				:= 0.00;               				-- Constante DECIMAL Cero
	SET DECIMAL_Cien   				:= 100.00;              			-- Constante DECIMAL Cien
	SET Nat_Cargo       			:= 'C';                 			-- Constante Cargo
	SET Nat_Abono       			:= 'A';                 			-- Constante Abono
	SET Tip_Venta       			:= 'V';                 			-- Tipo de Venta
	SET Ref_Provision   			:= 'PROVISION DE APORTACIONES';			-- Descripcion Provision de aportaciones
	SET Ope_Interna     			:= 'I';                				-- Operacion Interna
	SET Pol_Automatica  			:= 'A';                 			-- Constante Poliza Automatica
	SET AltaPoliza_NO   			:= Est_Vigente;         			-- Constante Alta Poliza No
	SET Mov_AhorroNO    			:= Est_Vigente;         			-- Movimiento de Ahorro No
	SET Con_ProCed      			:= 901;                 			-- Provision TABLA CONCEPTOSCONTA
	SET Pro_Interes     			:= 5;                  				-- Movimiento Provision de Interes
	SET Con_EgresoGra   			:= 2;                   			-- Constante Gravado
	SET Con_EgresoExe   			:= 3;                   			-- Constante Excento
	SET Var_Descripcion 			:= 'PROVISION APORTACION. VENTA DIVISA';  -- descripcion Provision
	SET Var_Referencia  			:= 'PROVISION APORTACION. CIERRE DIA';    -- Descripcion Cierre Dia
	SET Pro_CieDiaInv   			:= 1500;                            -- Proceso Batch
	SET InicioMes       			:=  CONVERT(CONCAT(EXTRACT(YEAR_MONTH FROM Par_Fecha),'01'),DATE);
	SET DiaOperacion    			:= DAY(Par_Fecha);                  -- Dia de la Opeacion.
	SET TasaFija        			:= 'F';                             -- Tasa Fija.
	SET TasaVariable    			:= 'V';                             -- Tasa Variable.
	SET IniPs           			:= 2;                               -- Tasa Inicio de Mes + Puntos.
	SET IniPsPiTe       			:= 5;                               -- Tasa Inicio de Mes + Puntos con Piso y Techo.
	SET AperPs          			:= 3;                               -- Tasa Apertura + Puntos.
	SET AperPsPiTe      			:= 6;                               -- Tasa Apertura + Puntos con Piso y Techo.
	SET PromPs          			:= 4;                               -- Tasa Promedio del Mes + Puntos.
	SET PromPsPiTe      			:= 7;                               -- Tasa Promedio del Mes + Puntos con Piso y Techo.
	SET NO_UltimoDia    			:= 'N';
	SET SI_UltimoDia    			:= 'S';                             -- Un Dia Habil.
	SET ErrorSQL        			:= 'ERROR DE SQL GENERAL';          -- Manejo de errores
	SET ErrorAlta       			:= 'ERROR EN ALTA, LLAVE DUPLICADA';-- Manejo de errores
	SET ErrorLlamada    			:= 'ERROR AL LLAMAR A STORE PROCEDURE'; -- Manejo de errores
	SET ErrorValorNulo  			:= 'ERROR VALORES NULOS';           -- Manejo de errores
	SET Entero_Cero     			:= 0;                               -- Entero en Cero
	SET DecimalCero     			:= 0.0;
	SET ConsCien        			:= 100;
	SET Cons360         			:= 360;
	SET Const_NO        			:= 'N';
	SET Var_SigFecha    			:= DATE_ADD(Par_Fecha, INTERVAL 1 DAY);
	SET ISRpSocio					:= 'ISR_pSocio';					-- constante para isr por socio de PARAMGENERALES
	SET SI_Isr_Socio				:= 'S';								-- constante para saber si se calcula el isr por socio
	SET ValorUMA					:='ValorUMABase';
	SET FinMes 						:= 'F';								-- Indica que se trata de pagos al fin de mes
	SET IntDevengado				:= 'D';								-- Tipo de pago de interes DEVENGADO
	SET IntIguales	 				:= 'I';
	SET Cons_PagoProg				:= 'E';
	SET Cons_PagoVenc				:= 'V';
	SET Cons_PeriodoIrre			:= 'I';
	SET Cons_PeriodoRegu			:= 'R';
	SET Cons_SI						:= 'S';
	SET TipoISRRecalculo			:= 2;

	ManejoErrores:BEGIN
	   DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-APORTPROVISIONPRO');
			END;

		TRUNCATE TABLE TMPTASASPROMEDIO;
		TRUNCATE TABLE TMPRENDIMIENTOAPORT;

		# SE ELIMINAN LOS RENDIMIENTOS CON LA FECHA DEL SISTEMA.
		DELETE FROM RENDIMIENTOAPORT WHERE FechaCalculo = Par_Fecha;

		SELECT        SalMinDF,		FechaISR
			INTO       Var_SalMinDF,	Var_FechaISR
				FROM    PARAMETROSSIS;

		SET Var_ISR_pSocio	:= (SELECT FNPARAMGENERALES(ISRpSocio));
		SET Fre_DiasAnio	:= (SELECT FNPARAMGENERALES(ValorUMA));
		SET Var_PaisIDBase	:= FNPARAMGENERALES('PaisIDBase');

		/* Salario minimo General Anualizado*/
		SET Var_SalMinAn    := Var_SalMinDF * 5 * Fre_DiasAnio;
		SET Var_ISR_pSocio	:= IFNULL(Var_ISR_pSocio , Const_NO);
		SET Var_FechaISR	:= IFNULL(Var_FechaISR , Par_Fecha);

		INSERT INTO TMPTASASPROMEDIO (TasaBaseID, ValorProm)
		SELECT TasaBaseID,(SUM(Valor)/DiaOperacion)
			FROM CALHISTASASBASE
			WHERE Fecha>=InicioMes AND Fecha <=Par_Fecha
			GROUP BY TasaBaseID;

		UPDATE TMPTASASPROMEDIO
			SET EmpresaID       =   Par_EmpresaID,
				Usuario         =   Aud_Usuario,
				FechaActual     =   Aud_FechaActual,
				DireccionIP     =   Aud_DireccionIP,
				ProgramaID      =   Aud_ProgramaID,
				Sucursal        =   Aud_Sucursal,
				NumTransaccion  =   Aud_NumTransaccion;


		INSERT INTO TMPRENDIMIENTOAPORT(
			AportacionID,			FechaCalculo,			Monto,					TipoAportacionID,		TipoPagoInt,
			DiasPeriodo,			PagoIntCal,				TasaFV,					Tasa,					TasaNeta,
			CalculoInteres,			TasaBase,				SobreTasa,				PisoTasa,				TechoTasa,
			FechaInicio,			FechaVencimiento,		MonedaID,				SaldoProvision,			InteresGenerado,
			SaldoISR,				TasaISR,				PagaISR,				EmpresaID,				SucursalOrigen,
			ClienteID,				FechaPago,				FechaPagoAmo,			FechaInicioAmo,			FechaVencimAmo,
			InteresAmo,				IntRetenerAmo,			SaldoProvAmo,			AmortizacionID,			TipoPersona,
			TipoPeriodo,			PagoIntCapitaliza,		SaldoCap,				DiasAmo)
		SELECT      ap.AportacionID,		Par_Fecha,              ap.Monto,				ap.TipoAportacionID,	ap.TipoPagoInt,
					ap.DiasPeriodo,			ap.PagoIntCal,			tipo.tasaFV,        	ap.TasaFija,			ap.TasaNeta,
					ap.CalculoInteres,		ap.TasaBase,			ap.SobreTasa,			ap.PisoTasa,			ap.TechoTasa,
					ap.FechaInicio,			ap.FechaVencimiento,	ap.MonedaID,			ap.SaldoProvision,		ap.InteresGenerado,
					amo.SaldoISR,			Suc.TasaISR,            cte.PagaISR,        	ap.EmpresaID,			cte.SucursalOrigen,
					cte.ClienteID,          ap.FechaPago,			amo.FechaPago,          amo.FechaInicio,		amo.FechaVencimiento,
					amo.Interes,            amo.InteresRetener,		amo.SaldoProvision,     amo.AmortizacionID,		cte.TipoPersona,
                    amo.TipoPeriodo,		ap.PagoIntCapitaliza,	amo.SaldoCap,			amo.Dias
			FROM 	APORTACIONES ap INNER JOIN AMORTIZAAPORT amo ON ap.AportacionID = amo.AportacionID
					INNER JOIN TIPOSAPORTACIONES tipo ON ap.TipoAportacionID=tipo.TipoAportacionID
					INNER JOIN CLIENTES cte ON ap.ClienteID=cte.ClienteID
					INNER JOIN SUCURSALES   Suc ON  Suc.SucursalID =cte.SucursalOrigen
			WHERE 	ap.Estatus      		= Est_Vigente
			AND 	amo.Estatus				= Est_Vigente
			AND 	ap.ClienteID    		= ap.ClienteID
			AND 	ap.FechaInicio  		<= Par_Fecha
			AND 	ap.FechaVencimiento	> Par_Fecha
			AND 	amo.FechaInicio       	<= Par_Fecha
			AND 	amo.FechaVencimiento  	> Par_Fecha
			AND 	cte.PaisResidencia = Var_PaisIDBase;

		-- -------------------------------------------------------------------------------------------
		-- Se Actualiza el Valor de la la Tasa para el Tipo de Calculo
		-- Tasa Inicio de Mes + Puntos y Tasa Inicio de Mes + Puntos con Piso y Techo
		-- -------------------------------------------------------------------------------------------
		UPDATE TMPRENDIMIENTOAPORT inver
			INNER JOIN CALHISTASASBASE tasa ON inver.TasaBase=tasa.TasaBaseID
			SET inver.Tasa		= tasa.Valor
		WHERE 	inver.TasaFV	= TasaVariable
		AND 	(inver.CalculoInteres=IniPs OR inver.CalculoInteres = IniPsPiTe)
		AND 	tasa.Fecha		= InicioMes
		AND 	FechaCalculo	= Par_Fecha;
		-- -------------------------------------------------------------------------------------------
		-- Se Actualiza el Valor de la Tasa para el el Tipo de Calculo
		-- Tasa de Apertuta + Puntos y Tasa de Apertura + Puntos con Piso y Techo
		-- -------------------------------------------------------------------------------------------
		UPDATE TMPRENDIMIENTOAPORT inver
			INNER JOIN CALHISTASASBASE tasa ON inver.TasaBase=tasa.TasaBaseID
				SET inver.Tasa		= tasa.Valor
			WHERE 	inver.TasaFV	= TasaVariable
			AND 	(inver.CalculoInteres = AperPs OR inver.CalculoInteres = AperPsPiTe)
			AND 	tasa.Fecha		= inver.FechaInicio
			AND 	FechaCalculo	= Par_Fecha;
		-- -------------------------------------------------------------------------------------------
		-- Se Actualiza el Valor de la Tasa para el Tipo de Calculo
		-- Tasa Promedio  del Mes + Puntos y Tasa Promedio del Mes + Puntos con Piso y Techo
		-- -------------------------------------------------------------------------------------------
		UPDATE TMPRENDIMIENTOAPORT inver
			INNER JOIN TMPTASASPROMEDIO prom ON inver.TasaBase=prom.TasaBaseID
				SET inver.Tasa		= prom.ValorProm
			WHERE 	inver.TasaFV	= TasaVariable
			AND 	(inver.CalculoInteres = PromPs OR inver.CalculoInteres = PromPsPiTe)
			AND 	FechaCalculo	= Par_Fecha;

		TRUNCATE TABLE TMPTASASPROMEDIO;
		SELECT DiasInversion, MonedaBaseID INTO Var_DiasBase, Var_MonedaBase
			FROM PARAMETROSSIS;

        -- SE OBTIENE LA TASA ISR VIGENTE PARA EL CALCULO DEL DEVENGO DIARIO DE ISR
        SELECT IF(Fecha <= Par_Fecha,Valor,ValorAnterior) INTO Var_NuevaTasaISR
			FROM `HIS-TASASIMPUESTOS`
            ORDER BY Fecha DESC
            LIMIT 1;
		SET Var_NuevaTasaISR := IFNULL(Var_NuevaTasaISR,DecimalCero);

        -- consulta para obtener los dias base para periodo regular e irregular de ISR
        SELECT ValorParametro INTO Var_BaseIsrIrre
        FROM PARAMGENERALES
		WHERE LlaveParametro='BaseISRIrregular';

        SELECT ValorParametro INTO Var_BaseIsrRegu
        FROM PARAMGENERALES
		WHERE LlaveParametro='BaseISRRegular';

		# TOTAL DE APORTACIONES A GENERAR EL RENDIEMINTO.
		SELECT COUNT(AportacionID) INTO Var_ContadorInv
			FROM 	TMPRENDIMIENTOAPORT
			WHERE 	FechaCalculo	= Par_Fecha;

		SET Var_ContadorInv := IFNULL(Var_ContadorInv, Entero_Cero);

		-- -------------------------------------------------------------------------------------------
		-- Se registra la poliza contable
		-- -------------------------------------------------------------------------------------------

		IF (Var_ContadorInv > Entero_Cero) THEN
			CALL MAESTROPOLIZASALT(
				Var_Poliza,         Par_EmpresaID,      Par_Fecha,          Pol_Automatica,     Con_ProCed,
				Var_Referencia,     Salida_NO,       	Par_NumErr,         Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;
		SET Var_HayCambioISR := 0;
		OPEN CURSORINVER;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOCURSORINVER:LOOP

					FETCH CURSORINVER INTO
						Var_AportacionID,		Var_Monto,              Var_TasaFV,         Var_Tasa,           Var_TasaNeta,
						Var_TipoPagoInt,		Var_PagoIntCal,			Var_CalculoInteres, Var_TasaBase,		Var_SobreTasa,
						Var_PisoTasa,       	Var_TechoTasa,			Var_FechaInicio,	Var_FechaVencimiento,Var_MonedaID,
						Var_SaldoProvision, 	Var_InteresGenerado,	Var_TasaISR,		Var_Empresa,		Var_SucCliente,
						Var_ClienteID,      	VarFecPago,				VarFecPagoAmo,		Var_FechaInicioAmo,	Var_FechaVencimAmo,
						Var_InteresAmo,     	Var_IntRetenerAmo,		Var_SaldoProvAmo,   Var_SaldoISR,		Var_AmortizacionID,
                        Var_TipoPeriodo, 		Var_CapitalizaInt,		Var_SaldoCap,		Var_DiasAmo;
					START TRANSACTION;
					Transaccion:BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
						DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
						DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
						DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
						DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;

						SET Error_Key       := Entero_Cero;
						SET Var_Provision   := Entero_Cero;
						SET Var_Dias        := Entero_Cero;
						SET Var_ProvMN      := Entero_Cero;
						SET Var_TipoCambio  := Entero_Cero;
						SET Var_InverStr    := Cadena_Vacia;
						SET Con_Egreso      := Entero_Cero;
						SET Var_UltimoDia   := NO_UltimoDia;

						SET Var_FechaInicio := (SELECT DATE(ap.FechaInicio) FROM APORTACIONES ap
													WHERE ap.AportacionID = Var_AportacionID);

						SET Var_FechaVencimiento := (SELECT DATE(ap.FechaVencimiento) FROM APORTACIONES ap
													WHERE ap.AportacionID = Var_AportacionID);

						SET VarFecPago := (SELECT DATE(ap.FechaPago) FROM APORTACIONES ap
													WHERE ap.AportacionID = Var_AportacionID);

						SET Var_FechaInicioAmo := (SELECT DATE(amo.FechaInicio) FROM AMORTIZAAPORT amo
													WHERE amo.AportacionID = Var_AportacionID AND amo.AmortizacionID = Var_AmortizacionID);

						SET VarFecPagoAmo := (SELECT DATE(amo.FechaPago) FROM AMORTIZAAPORT amo
													WHERE amo.AportacionID = Var_AportacionID AND amo.AmortizacionID = Var_AmortizacionID);

						SET Var_FechaVencimAmo := (SELECT DATE(amo.FechaVencimiento) FROM AMORTIZAAPORT amo
													WHERE amo.AportacionID = Var_AportacionID AND amo.AmortizacionID = Var_AmortizacionID);

						SET Var_ExisteCambioAport	:=FNEXISTECAMBIOISR(Par_Fecha, Par_Fecha);
						SET Var_ExisteCambioAmort	:=FNEXISTECAMBIOISR(Var_FechaInicioAmo, VarFecPagoAmo);
						SET Var_ActRetencion		:=IFNULL(Var_ExisteCambioAport,Const_NO);
						SET Var_FechaCambioTasa		:=FNFECHACAMBIOTASA(1,Var_FechaInicioAmo, VarFecPagoAmo);

						/* SI HUBO CAMBIO DE TASA EN LA APORTACION PERO NO EN LA AMORTIZACION ACTUAL
						 * SE RECALCULA EL INTERES DE LA AMORTIZACION ACTUAL CON LA NUEVA TASA.
						 */
						IF(Var_ActRetencion = Cons_SI) THEN
							SET Var_FechaFin1erPer	:= (SELECT FechaFin1erPer FROM TMP_AMORTIAPORTISR WHERE NumTransaccion = Aud_NumTransaccion AND AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
							SET Var_FechaFin2doPer	:= (SELECT FechaFin2doPer FROM TMP_AMORTIAPORTISR WHERE NumTransaccion = Aud_NumTransaccion AND AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
							SET Var_Dias1erPer		:= (SELECT Dias1erPer FROM TMP_AMORTIAPORTISR WHERE NumTransaccion = Aud_NumTransaccion AND AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
							SET Var_ISR1erPer		:= (SELECT ISR1erPer FROM TMP_AMORTIAPORTISR WHERE NumTransaccion = Aud_NumTransaccion AND AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
							SET Var_Dias2doPer		:= (SELECT Dias2doPer FROM TMP_AMORTIAPORTISR WHERE NumTransaccion = Aud_NumTransaccion AND AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
							SET Var_ISR2doPer		:= (SELECT ISR2doPer FROM TMP_AMORTIAPORTISR WHERE NumTransaccion = Aud_NumTransaccion AND AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);

							UPDATE AMORTIZAAPORT
							SET
								InteresRetenerRec = (Var_ISR1erPer + Var_ISR2doPer)
							WHERE AportacionID = Var_AportacionID
								AND AmortizacionID =  Var_AmortizacionID;

							SET Var_IntRetenerAmo := (Var_ISR1erPer + Var_ISR2doPer);
							SET Var_IntRetenerAmo := IFNULL(Var_IntRetenerAmo, Entero_Cero);
						END IF;


						-- -------------------------------------------------------------------------------------------
						-- valida si es la ultima fecha de pago de la amortizacion
						-- -------------------------------------------------------------------------------------------

						IF ((VarFecPagoAmo > Var_FechaVencimAmo AND (DATEDIFF(Var_FechaVencimAmo, Var_SigFecha) = 0)) OR
							 (Var_FechaVencimAmo >= VarFecPagoAmo AND (DATEDIFF(VarFecPagoAmo, Var_SigFecha) = 0)) ) THEN
								SET Var_UltimoDia := SI_UltimoDia;
						END IF;

						-- DEVENGO DE INTERES E ISR
                        IF (Var_TipoPagoInt IN (Cons_PagoProg,Cons_PagoVenc)) THEN
							SET Var_Dias			:= DATEDIFF(VarFecPagoAmo, Var_FechaInicioAmo);
							SET Var_InteresCuota 	:= Var_InteresAmo;
                            SET Var_DiasCalcIsr		:= Var_Dias;
							SET Var_ISRCuota 		:= Var_IntRetenerAmo;

                            -- Si existe cambio de tasa ISR, se obtienen los dias restantes de esta amortizacion
                            SET Var_DiasCalcIsr	:= DATEDIFF(VarFecPagoAmo, Par_Fecha);

							SET Var_MontoAmo := IF(Var_CapitalizaInt=Cons_SI,Var_SaldoCap,Var_Monto);
							IF(Var_ActRetencion = Cons_SI)THEN
	                            /* se actualiza el valor del isr acumulado hasta el dia de cambio de tasa ISR
								 * y el saldo isr generado diariamente se reinicia a 0.00
	                            */
	                            UPDATE AMORTIZAAPORT SET
									SaldoIsrAcum	= Var_ISR1erPer,
	                                SaldoISR		= DecimalCero
								WHERE   AportacionID = Var_AportacionID
								AND     AmortizacionID 	= Var_AmortizacionID;
							ELSE
								-- PERIODOS REGULARES
								IF(Var_TipoPeriodo = Cons_PeriodoRegu)THEN
									-- Se setean los días en base a 30 días por ser un periodo regular (base a 360 días).
									SET Var_DiasAmo := 30;
									SET Var_PlazoAmo := Var_DiasAmo;
									SET Var_DiasCalcIsr	:= Var_PlazoAmo;
								END IF;
								-- PERIODOS IRREGULARES
								IF(Var_TipoPeriodo = Cons_PeriodoIrre)THEN
									-- Si capitaliza interes se toma el saldo capital, de lo contrario se toma el monto original
									SET Var_PlazoAmo := Var_DiasAmo;
									SET Var_DiasCalcIsr	:= Var_PlazoAmo;
								END IF;
							END IF;
						END IF;
						-- -------------------------------------------------------------------------------------------
						-- si no es el ultimo dia de pago de la amortizacion
						-- el saldo provision se calcula por un dia
						-- -------------------------------------------------------------------------------------------
						IF(Var_UltimoDia = NO_UltimoDia) THEN
							IF(Var_TipoPagoInt = FinMes AND	Var_PagoIntCal = IntIguales)THEN
								SET Var_Dias		:= DATEDIFF(Var_FechaVencimAmo, Var_FechaInicioAmo);
								SET Var_Provision	:= ROUND((Var_InteresAmo/Var_Dias),2);
							ELSE
								SET Var_Dias 		:= 1;
								SET Var_Provision   := ROUND(Var_Monto * Var_Tasa * Var_Dias / (Var_DiasBase * DECIMAL_Cien), 2);
                                IF (Var_TipoPagoInt IN (Cons_PagoProg,Cons_PagoVenc) ) THEN
									SET Var_Dias		:= DATEDIFF(VarFecPagoAmo, Var_FechaInicioAmo);
									SET Var_Provision	:= ROUND((Var_InteresCuota / Var_Dias),2);

									# Si hay cambio de tasa en el día.
									IF(Var_ActRetencion = Cons_SI)THEN
										# Se obtiene el saldo por día del segundo corte.
										SET Var_IsrDia		:= ROUND((Var_ISR2doPer/Var_Dias2doPer),2);
									ELSE
										IF(Var_ExisteCambioAmort = Cons_SI AND Par_Fecha > Var_FechaCambioTasa)THEN
											SET Var_Dias2doPer	:= (SELECT Dias2doPer FROM TMP_AMORTIAPORTISR WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
											SET Var_ISR2doPer	:= (SELECT ISR2doPer FROM TMP_AMORTIAPORTISR WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
											SET Var_IsrDia		:= ROUND((Var_ISR2doPer / Var_Dias2doPer),2);
										ELSE
											SET Var_IsrDia		:= ROUND((Var_ISRCuota / Var_DiasCalcIsr),2);
										END IF;
	                                END IF;
                                END IF;
							END IF;
						ELSE
						-- -------------------------------------------------------------------------------------------
						-- si es tasa fija y es el ultimo dia de pago
						-- ajusta la ultima provision
						-- -------------------------------------------------------------------------------------------
							IF(Var_TasaFV = TasaFija) THEN
								SET Var_Provision := ROUND(Var_InteresAmo - IFNULL(Var_SaldoProvAmo, Entero_Cero),2);
                                IF (Var_TipoPagoInt IN (Cons_PagoProg,Cons_PagoVenc)) THEN
									-- Se calcula el interes e isr para el ultimo dia de ese periodo.
									SET Var_Provision := ROUND(Var_InteresCuota - IFNULL(Var_SaldoProvAmo, Entero_Cero),2);

									SET Var_SaldoISR := (SELECT (SaldoIsrAcum+SaldoISR) FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
									SET Var_IsrDia := ROUND((Var_IntRetenerAmo - IFNULL(Var_SaldoISR, Entero_Cero)),2);
                                END IF;
							ELSE
								SET Var_Dias := DATEDIFF(VarFecPagoAmo, Par_Fecha);
							END IF;

						END IF;

						IF(Var_TasaFV = TasaVariable) THEN

							SET Var_Provision := FNRENINVERSION(Var_CalculoInteres, Var_Monto,
																Var_Dias,           Var_DiasBase,
																Var_Tasa,           Var_SobreTasa,
																Var_PisoTasa,       Var_TechoTasa);
						END IF;


						IF (Var_Provision > Entero_Cero) THEN
				-- -------------------------------------------------------------------------------------------
				-- Proceso para dar de alta el movimiento de la aportacion
				-- -------------------------------------------------------------------------------------------
							CALL APORTMOVALT(
								Var_AportacionID,   Par_Fecha,      Tipo_Provision,     Var_Provision,      Nat_Cargo,
								Ref_Provision,      Var_MonedaID,   Salida_NO,          Par_NumErr,         Par_ErrMen,
								Var_Empresa,        Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
								Aud_Sucursal,       Aud_NumTransaccion);

							IF (Par_NumErr <> Entero_Cero)THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;
				-- -------------------------------------------------------------------------------------------
				-- Se realiza la contabilidad de la aportacion
				-- -------------------------------------------------------------------------------------------
							CALL CONTAAPORTPRO (
								Var_AportacionID,   Var_Empresa,    Par_Fecha,          Var_Provision,      Cadena_Vacia,
								Con_ProCed,         Pro_Interes,    Entero_Cero,        Nat_Abono,          AltaPoliza_NO,
								Mov_AhorroNO,       Salida_NO,      Var_Poliza,         Par_NumErr,         Par_ErrMen,
								Entero_Cero,        Var_ClienteID,  Var_MonedaID,       Aud_Usuario,        Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID, Var_SucCliente,     Aud_NumTransaccion);

							IF (Par_NumErr <> Entero_Cero)THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							IF (Var_MonedaID != Var_MonedaBase) THEN
								SELECT  TipCamVenInt INTO Var_TipoCambio
									FROM MONEDAS
									WHERE MonedaId = Var_MonedaID;

								SET Var_ProvMN := ROUND((Var_Provision * Var_TipoCambio), 2);

							ELSE
								SET Var_ProvMN := Var_Provision;

							END IF;
							IF (Var_TasaISR = Decimal_Cero) THEN
								SET Con_Egreso := Con_EgresoExe;
							ELSE
								SET Con_Egreso := Con_EgresoGra;
							END IF;
				-- -------------------------------------------------------------------------------------------
				-- Se realiza la contabilidad de la aportacion
				-- -------------------------------------------------------------------------------------------
							CALL CONTAAPORTPRO (
								Var_AportacionID,	Var_Empresa,    Par_Fecha,          Var_ProvMN,         Cadena_Vacia,
								Con_ProCed,         Con_Egreso,     Entero_Cero,        Nat_Cargo,          AltaPoliza_NO,
								Mov_AhorroNO,       Salida_NO,      Var_Poliza,         Par_NumErr,         Par_ErrMen,
								Entero_Cero,        Var_ClienteID,  Var_MonedaBase,     Aud_Usuario,        Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID, Var_SucCliente,     Aud_NumTransaccion);

						   IF (Par_NumErr <> Entero_Cero)THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							IF (Var_MonedaID != Var_MonedaBase) THEN
								SELECT  TipCamVenInt INTO Var_TipoCambio
									FROM MONEDAS
									WHERE MonedaId = Var_MonedaID;

								SET Var_Instrumento := CONVERT(Var_AportacionID, CHAR);

								CALL COMVENDIVISAALT(
									Var_MonedaID,       Aud_NumTransaccion, Par_Fecha,          Var_Provision,      ROUND(Var_TipoCambio,2),
									Ope_Interna,        Tip_Venta,          Var_Instrumento,    Var_Referencia,     Var_Descripcion,
									Var_Poliza,        	Var_Empresa,       	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
									Aud_ProgramaID,     Var_SucCliente,    	Aud_NumTransaccion);

							END IF;

				-- -------------------------------------------------------------------------------------------
				-- Se actualiza el saldo provision
				-- -------------------------------------------------------------------------------------------
							UPDATE APORTACIONES SET
									SaldoProvision	= SaldoProvision + Var_Provision
							WHERE   AportacionID = Var_AportacionID;

							UPDATE AMORTIZAAPORT SET
									SaldoProvision	= SaldoProvision + Var_Provision
							WHERE   AportacionID = Var_AportacionID
							AND     AmortizacionID 	= Var_AmortizacionID;

							UPDATE TMPRENDIMIENTOAPORT
								SET SaldoProvision  = Var_Provision
							WHERE 	AportacionID = Var_AportacionID
							AND 	FechaCalculo	= Par_Fecha;

						END IF;

	                    -- ----------------------------------------------------------------------------------------
						-- Se actualiza el saldo ISR
						-- ----------------------------------------------------------------------------------------
						UPDATE APORTACIONES SET
								SaldoISR	= SaldoISR + Var_IsrDia
						WHERE   AportacionID = Var_AportacionID;

                        UPDATE AMORTIZAAPORT SET
								SaldoISR	= SaldoISR + Var_IsrDia
						WHERE   AportacionID = Var_AportacionID
						AND     AmortizacionID 	= Var_AmortizacionID;

						UPDATE TMPRENDIMIENTOAPORT
							SET SaldoISR  = Var_IsrDia
						WHERE 	AportacionID = Var_AportacionID
						AND 	FechaCalculo	= Par_Fecha;
					END Transaccion;

					SET Var_InverStr := CONVERT(Var_AportacionID, CHAR);
					IF Error_Key = 0 THEN
						COMMIT;
					END IF;
					IF Error_Key = 1 THEN
						ROLLBACK;
						START TRANSACTION;

							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,  Par_Fecha,          Var_InverStr,       ErrorSQL,
								Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 2 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,  Par_Fecha,          Var_InverStr,       ErrorAlta,
								Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 3 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,      Par_Fecha,          Var_InverStr,       ErrorLlamada,
								Var_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 4 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,  Par_Fecha,          Var_InverStr,       ErrorValorNulo,
								Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF Error_Key = 99 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaInv,  Par_Fecha,          Var_InverStr,       CONCAT(Par_NumErr,' - ',Par_ErrMen),
								Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
						COMMIT;
					END IF;
				END LOOP;
			END;
		CLOSE CURSORINVER;

		INSERT INTO RENDIMIENTOAPORT(
			AportacionID,		FechaCalculo,		Monto,			TipoAportacionID,	TipoPagoInt,
			DiasPeriodo,		PagoIntCal,			TasaFV,			Tasa,				TasaNeta,
			CalculoInteres,		TasaBase,			SobreTasa,		PisoTasa,			TechoTasa,
			FechaInicio,		FechaVencimiento,	MonedaID,		SaldoProvision,		InteresGenerado,
			ISRDiario,			TasaISR,			PagaISR,		EmpresaID,			SucursalOrigen,
			ClienteID,			FechaPago,			FechaPagoAmo,	FechaInicioAmo,		FechaVencimAmo,
			InteresAmo,			IntRetenerAmo,		SaldoProvAmo,	AmortizacionID)
		SELECT
			AportacionID,		FechaCalculo, 		Monto, 			TipoAportacionID,	TipoPagoInt,
			DiasPeriodo, 		PagoIntCal, 		TasaFV, 		Tasa, 				TasaNeta,
			CalculoInteres, 	TasaBase, 			SobreTasa, 		PisoTasa, 			TechoTasa,
			FechaInicio, 		FechaVencimiento, 	MonedaID, 		SaldoProvision, 	InteresGenerado,
			SaldoISR, 			TasaISR, 			PagaISR, 		EmpresaID, 			SucursalOrigen,
			ClienteID, 			FechaPago, 			FechaPagoAmo, 	FechaInicioAmo, 	FechaVencimAmo,
			InteresAmo, 		IntRetenerAmo, 		SaldoProvAmo, 	AmortizacionID
		FROM TMPRENDIMIENTOAPORT;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Proceso Realizado Exitosamente: APORTPROVISIONPRO';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$