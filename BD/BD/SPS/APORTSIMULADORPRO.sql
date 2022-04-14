-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTSIMULADORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTSIMULADORPRO`;
DELIMITER $$


CREATE PROCEDURE `APORTSIMULADORPRO`(
# ================================================================
# ------ SP PARA GENERAR LA SIMULACION DE LAS AMORTIZACIONES------
# ================================================================
	Par_AportacionID		INT(11),            -- ID de la Aportacion
	Par_FechaInicio         DATE,               -- Fecha de Inicio del calendario a simular
	Par_FechaVencimiento    DATE,               -- Fecha de Vencimiento del calendario a simular
	Par_Monto               DECIMAL(18,2),      -- Monto con el que se simulara
	Par_ClienteID           INT(11),            -- Valor del Cliente

	Par_TipoAportacionID	INT(11),            -- Valor de Tipo de Aportacion
	Par_TasaFija            DECIMAL(18,4),      -- Valor de Tasa Fija
	Par_TipoPagoInt         CHAR(1),            -- Indica si es a FIN DE MES (F) o al VENCIMIENTO (V) o por PERIODO(P)
	Par_DiasPeriodo			INT(11),			-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	Par_PagoIntCal			CHAR(2),			-- Especifica el tipo de pago de interes D - Devengado, I - Iguales

	Par_DiaPago				INT(11),			-- Especifica el dia de pago de la aportacion
    Par_PlazoOriginal		INT(11),			-- Especifica el plazo original de la aportacion
    Par_IntCapitaliza		CHAR(1),			-- Especifica si capitaliza interes. S:Si / N:No
	Par_Salida              CHAR(1),            -- Indica si espera un SELECT de salida
	INOUT   Par_NumErr      INT(11),

	INOUT   Par_ErrMen      VARCHAR(400),
	Aud_EmpresaID           INT(11),            -- Parametro de Auditoria
	Aud_Usuario             INT(11),            -- Parametro de Auditoria
	Aud_FechaActual         DATETIME,           -- Parametro de Auditoria
	Aud_DireccionIP         VARCHAR(15),        -- Parametro de Auditoria

	Aud_ProgramaID          VARCHAR(50),        -- Parametro de Auditoria
	Aud_Sucursal            INT(11),            -- Parametro de Auditoria
	Aud_NumTransaccion      BIGINT(20)          -- Parametro de Auditoria
)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Entero_Cien     	INT(11);
	DECLARE Decimal_Cero    	DECIMAL(18,2);
	DECLARE VarSi           	CHAR(1);
	DECLARE VarTasaFija     	CHAR(1);
	DECLARE VarTasaVariable 	CHAR(1);
	DECLARE Dia_SD          	CHAR(2);
	DECLARE Dia_D           	CHAR(2);
	DECLARE VarViernes      	INT(11);
	DECLARE VarVencimiento  	CHAR(1);
	DECLARE VarFinMes			CHAR(1);
	DECLARE VarPeriodo			CHAR(1);
	DECLARE Factor_Porcen   	DECIMAL(12,2);
	DECLARE IntDevengado		CHAR(1);
	DECLARE IntIguales			CHAR(1);
	DECLARE ValorUMA			VARCHAR(15);
    DECLARE Cons_PagoProg		CHAR(1);
    DECLARE CalculoInteres		INT(11);
    DECLARE CalculoISR			INT(11);
    DECLARE CalculoISRExt		INT(11);
    DECLARE PeriodoIrreg		CHAR(1);
    DECLARE Estatus_Vig			CHAR(1);
    DECLARE Estatus_Aut			CHAR(1);
    DECLARE Estatus_Reg			CHAR(1);

	-- Declaracion de variables
	DECLARE VarDiaGenerado  	DATE;
	DECLARE VarFechaPago    	DATE;
	DECLARE VarFechaInicio  	DATE;
	DECLARE VarConsecutivo  	INT(11);
	DECLARE VarDias         	INT(11);
	DECLARE VarDiasInver    	INT(11);
	DECLARE VarTipoTasa     	CHAR(1);
	DECLARE Var_PagaISR     	CHAR(1);
	DECLARE Var_TasaISR     	DECIMAL(18,2);
	DECLARE VarInteres      	DECIMAL(18,2);
	DECLARE VarInteresTotal 	DECIMAL(18,2);  -- INTERES TOTAL EL CUAL SE USARA PARA SACAR LA ULTIMA CUOTA
	DECLARE VarInteresAcum  	DECIMAL(18,2);  -- INTERES ACUMULADO SIN LA ULTIMA CUOTA
	DECLARE VarISR          	DECIMAL(18,2);
	DECLARE VarISRTotal     	DECIMAL(18,2);  -- ISR TOTAL EL CUAL SE USARA PARA SACAR LA ULTIMA CUOTA
	DECLARE VarISRAcum      	DECIMAL(18,2);  -- ISR ACUMULADO SIN LA ULTIMA CUOTA
	DECLARE VarTotal        	DECIMAL(18,2);
	DECLARE VarCapital      	DECIMAL(18,2);
	DECLARE VarTotalCapital 	DECIMAL(18,2);
	DECLARE VarTotalInteres 	DECIMAL(18,2);
	DECLARE VarTotalISR     	DECIMAL(18,2);
	DECLARE VarTotalFinal   	DECIMAL(18,2);
	DECLARE Var_SalMinDF    	DECIMAL(12,2);  -- Salario minimo segun el df
	DECLARE Var_SalMinAn    	DECIMAL(12,2);  -- Salario minimo anualizado segun el df
	DECLARE Var_DiaInhabil  	CHAR(2);
	DECLARE Var_TipoPersona 	CHAR(1);
	DECLARE Var_Control	    	VARCHAR(100);  	-- Variable de control
	DECLARE FechaVig        	DATE;
	DECLARE FechaVenOri     	DATE;
	DECLARE Var_NumCuotas		INT(11);		-- Numero de cuotas de la aportacion.
	DECLARE Var_IntCuota		DECIMAL(18,2);	-- Interes por cuota
	DECLARE Var_ValorUMA		DECIMAL(12,4);
	DECLARE Per_Moral			CHAR(1);
	DECLARE Var_EstatusISR		CHAR(1);
	DECLARE EstatusActivo		CHAR(1);
    DECLARE Var_FechaDiaPago	DATE;	-- Fecha de pago de la aportacion
    DECLARE Var_SaldoCap		DECIMAL(14,2);	-- Fecha de pago de la aportacion
    DECLARE Var_TipoPeriodo		CHAR(1);		-- Tipo de Cálculo para Interés e ISR.
    DECLARE Var_MontoInv		DECIMAL(18,2);	-- Monto a Invertir
	DECLARE Var_PaisIDBase		INT(11);
	DECLARE Var_PaisResidencia	INT(11);
    DECLARE Var_Estatus			CHAR(1);		-- Estatus de la aportacion

	-- Asignacion de constantes
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Entero_Cien         := 100;
	SET Decimal_Cero        := 0.00;
	SET VarSi               := 'S';
	SET VarTasaFija         := 'F';
	SET VarTasaVariable     := 'V';
	SET Dia_SD              := 'SD';		-- Dia sabado y domingo
	SET Dia_D               := 'D';       	-- Dia domingo
	SET VarViernes          := 6;
	SET VarVencimiento      := 'V';			-- Indica que se trata de pagos al vencimiento
	SET VarFinMes     		:= 'F';			-- Indica que se trata de pagos al fin de mes
	SET VarPeriodo     		:= 'P';			-- Indica que se trata de pagos por periodo
	SET Factor_Porcen       := 100.00;
	SET IntDevengado		:= 'D';			-- Tipo de pago de interes DEVENGADO
	SET IntIguales			:= 'I';			-- Tipo de pago de interes IGUALES
	SET ValorUMA			:='ValorUMABase';
	SET Per_Moral			:= 'M';
	SET EstatusActivo		:= 'A';			-- ESTATUS ACTIVO
    SET Cons_PagoProg		:= 'E';			-- Indica que se trata de pagos programados
    SET CalculoInteres		:= 1;			-- Tipo de Calculo para Interes.
    SET CalculoISR			:= 0;			-- Tipo de Calculo para ISR.
    SET CalculoISRExt		:= 3;			-- Tipo de Calculo para ISR Residentes en el Extranjero.
    SET PeriodoIrreg		:= 'I'; 		-- Periodo Irregular
    SET Estatus_Vig			:= 'N';			-- Estatus vigente
    SET Estatus_Aut 		:= 'L';			-- Estatus Autorizado
	SET Estatus_Reg			:= 'A';			-- Estatus registrada

	ManejoErrores:BEGIN     #bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTSIMULADORPRO');
				SET Var_Control := 'SQLEXCEPTION';
			END;

		/* SE OBTIENEN LOS VALORES DE PARAMETROS DE SISTEMA*/
		SELECT  	DiasInversion,  SalMinDF
			INTO 	VarDiasInver ,  Var_SalMinDF
			FROM 	PARAMETROSSIS
			WHERE 	EmpresaID = 1;

		SET Var_ValorUMA := FNPARAMGENERALES(ValorUMA);
		SET Var_PaisIDBase := FNPARAMGENERALES('PaisIDBase');

		/* Se consulta para saber si el cliente paga o no ISR y se obtiene el valor de TasaISR*/
		SELECT
			Cli.PagaISR,	Cli.TipoPersona,	Cli.PaisResidencia,
			IF(Cli.PaisResidencia = Var_PaisIDBase,Suc.TasaISR,FNTASAISREXT(Cli.PaisResidencia,1,Fecha_Vacia,Entero_Cero))
		INTO
			Var_PagaISR,	Var_TipoPersona,	Var_PaisResidencia,
			Var_TasaISR
			FROM    CLIENTES   Cli,
					SUCURSALES Suc
			WHERE   Cli.ClienteID	= Par_ClienteID
			AND 	Suc.SucursalID	= Cli.SucursalOrigen;

		/*se obtienen los valores de tipos de aportaciones*/
		SELECT  DiaInhabil,     TasaFV
			INTO   	Var_DiaInhabil, VarTipoTasa
			FROM 	TIPOSAPORTACIONES
			WHERE 	TipoAportacionID = Par_TipoAportacionID;
		
        -- CONSULTA PARA OBTENER EL ESTATUS DE LA OPERACION
        SELECT Estatus
			INTO Var_Estatus
			FROM APORTACIONES
            WHERE AportacionID=Par_AportacionID;
		SET Var_Estatus := IFNULL(Var_Estatus,Cadena_Vacia);

		IF(Var_Estatus=Cadena_Vacia)THEN
			SET Var_Estatus := Estatus_Reg;
        END IF;
		
		-- Inicializacion de variables
		SET VarTipoTasa     := IFNULL(VarTipoTasa, Cadena_Vacia );
		SET VarDiasInver    := IFNULL(VarDiasInver , Entero_Cero);
		SET Var_SalMinDF    := IFNULL(Var_SalMinDF , Decimal_Cero);
		SET Var_TasaISR     := IFNULL(Var_TasaISR , Decimal_Cero);
		SET VarConsecutivo  := Entero_Cero;
		SET FechaVenOri     := Par_FechaVencimiento;
		SET VarDiaGenerado  := Par_FechaInicio;
		SET VarFechaInicio  := Par_FechaInicio;
		SET VarDias         := DATEDIFF(Par_FechaVencimiento, Par_FechaInicio);
		SET Var_SalMinAn    := Var_SalMinDF * 5 * Var_ValorUMA;/* Salario minimo General Anualizado*/
        SET Par_DiaPago		:= IFNULL(Par_DiaPago,Entero_Cero);
        SET Par_PlazoOriginal	:= IFNULL(Par_PlazoOriginal,Entero_Cero);
        SET Par_IntCapitaliza	:= IFNULL(Par_IntCapitaliza,Cadena_Vacia);
        SET Var_TipoPeriodo		:= FNTIPOPERIODOAPORT(Par_FechaInicio, Par_FechaVencimiento);

		/* se limpia la tabla de paso*/
		DELETE FROM TMPSIMULADORAPORT WHERE NumTransaccion = Aud_NumTransaccion;

		/** ******************************************
		 ** ******** SE CALCULA INTERES E ISR ********
		 ** ****************************************** */
		SET VarCapital      := Par_Monto;

		-- SE OBTIENE LA DIFERENCIA DE LA FECHA VENCIMIENTO CON LA FECHA DE INICIO EN DIAS
		SET VarDias:= (DATEDIFF(Par_FechaVencimiento,VarFechaInicio));
        
        -- SI EL TIPO DE PAGO DE INTERES ES AL VENCIMIENTO TODOS LOS PERIODOS SON IRREGULARES
        IF(Par_TipoPagoInt = VarVencimiento)THEN
			SET Var_TipoPeriodo := PeriodoIrreg;
        END IF;

		/* valida de que tipo de tasa se trata */
		CASE VarTipoTasa
			WHEN VarTasaFija        THEN    SET VarInteresTotal := FNINTERESCAL(Var_TipoPeriodo,CalculoInteres,Par_Monto,VarDias,Par_TasaFija,Entero_Cero,Entero_Cero,Entero_Cero);
			WHEN VarTasaVariable    THEN    SET VarInteresTotal := Decimal_Cero;
		END CASE;

		SET VarInteresTotal := IFNULL(VarInteresTotal, Decimal_Cero);

		/* Si el cliente paga ISR entonces se calcula el interes a Retener, sino su valor sera cero*/
		IF (VarInteresTotal > Decimal_Cero) THEN
			IF (Var_PagaISR = VarSi) THEN
				# Si el cliente reside en México se calcula conforma a la formula actual.
				IF(Var_PaisResidencia = Var_PaisIDBase)THEN
					SET VarISRTotal := FNINTERESCAL(Var_TipoPeriodo,CalculoISR,Par_Monto,VarDias,Var_TasaISR,Entero_Cero,Entero_Cero,Entero_Cero);
				ELSE
				# Sino, el cliente reside en el extranjero tomando como monto el interés total
					SET VarISRTotal := FNINTERESCAL(Var_TipoPeriodo,CalculoISRExt,VarInteresTotal,VarDias,Var_TasaISR,Entero_Cero,Entero_Cero,Entero_Cero);
				END IF;
			ELSE
				SET VarISRTotal := Decimal_Cero;
			END IF;
		ELSE
			SET VarISRTotal := Decimal_Cero;
		END IF;

		SET VarISRTotal     := IFNULL(VarISRTotal, Decimal_Cero);

		/** ******************************************************************
		 ** ******************* Tipo de Pago: AL VENCIMIENTO ***************** */
		IF(Par_TipoPagoInt = VarVencimiento)THEN
			SET VarTotal        := Par_Monto + VarInteresTotal - VarISRTotal;
			SET VarConsecutivo  := VarConsecutivo + 1;

			-- SE INSERTA EN LA TABLA DE SIMULACION
			INSERT INTO TMPSIMULADORAPORT (
				NumTransaccion,		Consecutivo,	Fecha,					FechaPago,				Capital,
				Interes,			ISR,			Total,					Dias,					FechaInicio,
				TipoPeriodo)
			VALUES(
				Aud_NumTransaccion,	VarConsecutivo, Par_FechaVencimiento,	Par_FechaVencimiento,	VarCapital,
				VarInteresTotal,	VarISRTotal,    VarTotal,				VarDias,				VarFechaInicio,
				Var_TipoPeriodo);

		-- Seccion para pagos de aportaciones programadas, con día de pago especifico
		ELSEIF(Par_TipoPagoInt = Cons_PagoProg)THEN
			--  SE CREA CICLO PARA GENERAR EL CALENDARIO DE FECHAS
			SET Var_FechaDiaPago	:= VarDiaGenerado;
			SET @saldoC				:= Entero_Cero;
			SET VarConsecutivo		:= Entero_Cero;
			SET Var_MontoInv		:= Par_Monto;

			WHILE (Var_FechaDiaPago < Par_FechaVencimiento) DO
                SET Var_FechaDiaPago    := DATE(CONCAT(YEAR(VarDiaGenerado), '-',MONTH(VarDiaGenerado),'-',Par_DiaPago));
                SET Var_FechaDiaPago	:= DATE_ADD(Var_FechaDiaPago, INTERVAL 1 MONTH);

				IF(Var_FechaDiaPago != Par_FechaVencimiento)THEN
                    SET VarFechaPago:=Var_FechaDiaPago;
				ELSE
					SET VarFechaPago:=Par_FechaVencimiento;
				END IF;

				-- SI EL DIA CALCULADO DE VENCIMIENTO ES MAYOR A LA FECHA DE VENCIMIENTO
				IF(Var_FechaDiaPago >= Par_FechaVencimiento)THEN
					SET VarFechaPago		:= Var_FechaDiaPago;
					SET VarCapital			:= Par_Monto;
				ELSE
					SET VarCapital			:= Decimal_Cero;
				END IF;

				-- SE OBTIENE LA DIFERENCIA DE LA FECHA VENCIMIENTO CON LA FECHA DE INICIO EN DIAS
				SET VarDias	:= DATEDIFF(VarFechaPago,VarFechaInicio);

				IF(VarDias>Entero_Cero) THEN
					SET VarConsecutivo	:= VarConsecutivo + 1;
					SET Var_TipoPeriodo	:= FNTIPOPERIODOAPORT(VarDiaGenerado, VarFechaPago);
					SET Var_MontoInv	:= (IFNULL(Var_MontoInv,Entero_Cero) + IF(Par_IntCapitaliza = VarSi,IFNULL(VarTotal,Entero_Cero),Entero_Cero));
					/*valida de que tipo de tasa se trata */
					CASE VarTipoTasa
						WHEN VarTasaFija		THEN SET VarInteres := FNINTERESCAL(Var_TipoPeriodo,CalculoInteres,Var_MontoInv,VarDias,Par_TasaFija,Entero_Cero,Entero_Cero,Entero_Cero);
						WHEN VarTasaVariable	THEN SET VarInteres := Decimal_Cero;
					END CASE;
					SET VarInteres := IFNULL(VarInteres, Decimal_Cero);
					/* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
					IF (VarInteres > Decimal_Cero) THEN
						IF (Var_PagaISR = VarSi) THEN
							# Si el cliente reside en México se calcula conforma a la formula actual.
							IF(Var_PaisResidencia = Var_PaisIDBase)THEN
								SET VarISR := FNINTERESCAL(Var_TipoPeriodo,CalculoISR,Var_MontoInv,VarDias,Var_TasaISR,Entero_Cero,Entero_Cero,Entero_Cero);
							ELSE
							# Sino, el cliente reside en el extranjero tomando como monto el interés total
								SET VarISR := FNINTERESCAL(Var_TipoPeriodo,CalculoISRExt,VarInteres,VarDias,Var_TasaISR,Entero_Cero,Entero_Cero,Entero_Cero);
							END IF;
						ELSE
							SET VarISR := Decimal_Cero;
						END IF;
					ELSE
						SET VarISR := Decimal_Cero;
					END IF;

					SET VarISR		:= IFNULL(VarISR, Decimal_Cero);
					SET VarTotal	:= VarInteres - VarISR;

					SET @saldoC := (SELECT SUM(Total) FROM TMPSIMULADORAPORT WHERE NumTransaccion = Aud_NumTransaccion);
                    SET @saldoC := IFNULL(@saldoC,Decimal_Cero);

                    IF(Par_IntCapitaliza = VarSi)THEN
						SET @saldoC := Par_Monto + @saldoC;
                        IF(Var_FechaDiaPago >= Par_FechaVencimiento)THEN
							SET VarCapital := VarCapital+(SELECT IFNULL(SUM(Total),Decimal_Cero) FROM TMPSIMULADORAPORT WHERE   NumTransaccion = Aud_NumTransaccion);
						END IF;
                        SET VarTotal := VarCapital+VarInteres-VarISR;
                    ELSE
						SET @saldoC := Par_Monto;
                        SET VarTotal := VarCapital+VarInteres-VarISR;
                    END IF;

					-- SE INSERTA EN LA TABLA DE SIMULACION
					INSERT INTO TMPSIMULADORAPORT (
						NumTransaccion,     Consecutivo,    Fecha,          FechaPago,      Capital,
						Interes,            ISR,            Total,          Dias,           FechaInicio,
                        SaldoCap,			TipoPeriodo)
					VALUES(
						Aud_NumTransaccion, VarConsecutivo, VarDiaGenerado, VarFechaPago,   VarCapital,
						VarInteres,         VarISR,         VarTotal,       VarDias,        VarFechaInicio,
                        @saldoC,			Var_TipoPeriodo);
				END IF;

                SET VarDiaGenerado	:= Var_FechaDiaPago;
				SET VarFechaInicio  := Var_FechaDiaPago;
            END WHILE; -- FIN WHILE
		END IF; -- Fin IF tipos pagos

		SET Par_NumErr  := 0;
		SET Par_ErrMen  := 'Simulacion Realizada Exitosamente.';

	END ManejoErrores; #fin del manejador de errores

	-- SE CALCULA EL ISR INFORMATIVO SÓLO SI ESTA ACTIVO
	SET Var_EstatusISR	:= (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
	SET Var_EstatusISR	:= IFNULL(Var_EstatusISR, Cadena_Vacia);
	SET VarDias			:= (SELECT SUM(Dias) FROM TMPSIMULADORAPORT WHERE NumTransaccion = Aud_NumTransaccion);

    IF(Var_Estatus IN (Estatus_Aut,Estatus_Reg))THEN
		/*SE SUMARIZAN LAS COLUMNAS PARA LOS TOTALES */
		SELECT      SUM(Capital) AS Capital,    SUM(Interes) AS Interes,    SUM(ISR) AS ISR,    SUM(Total) AS Total
			INTO    VarTotalCapital,            VarTotalInteres,            VarTotalISR,        VarTotalFinal
			FROM    TMPSIMULADORAPORT
			WHERE   NumTransaccion = Aud_NumTransaccion;
	ELSE
		SELECT      SUM(Capital) AS Capital,    SUM(Interes) AS Interes,    SUM(InteresRetener) AS ISR,    SUM(Total) AS Total
			INTO    VarTotalCapital,            VarTotalInteres,            VarTotalISR,        VarTotalFinal
			FROM    AMORTIZAAPORT
			WHERE   AportacionID = Par_AportacionID;
	END IF;

	/* se realiza el SELECT para obtener el calendario */
	IF(Par_Salida=VarSi) THEN
		IF(Var_Estatus IN (Estatus_Aut,Estatus_Reg))THEN
			SELECT
				NumTransaccion,		Consecutivo,		FechaPago,			Capital,		Interes,
				ISR,				VarTotalCapital,	VarTotalInteres,	VarTotalISR,	VarTotalFinal,
				IF(Par_TipoPagoInt = Cons_PagoProg,Fecha,FechaInicio) AS Fecha,
				IF(Par_TipoPagoInt = Cons_PagoProg,Total,VarTotalFinal) AS Total,
				IF(Par_TipoPagoInt = Cons_PagoProg,SaldoCap,Par_Monto) AS SaldoCap
			FROM TMPSIMULADORAPORT
				WHERE NumTransaccion = Aud_NumTransaccion;
		ELSE
			SELECT
				NumTransaccion,			AmortizacionID AS Consecutivo,	FechaPago,			Capital,		Interes,
				InteresRetener AS ISR,	VarTotalCapital,				VarTotalInteres,	VarTotalISR,	VarTotalFinal,
				FechaInicio AS Fecha,
				IF(Par_TipoPagoInt = Cons_PagoProg,Total,VarTotalFinal) AS Total,
				IF(Par_TipoPagoInt = Cons_PagoProg,SaldoCap,Par_Monto) AS SaldoCap
			FROM AMORTIZAAPORT
				WHERE AportacionID = Par_AportacionID;
		END IF;
	END IF;

END TerminaStore$$
