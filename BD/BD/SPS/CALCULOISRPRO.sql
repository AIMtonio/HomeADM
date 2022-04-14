-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOISRPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULOISRPRO`;DELIMITER $$

CREATE PROCEDURE `CALCULOISRPRO`(
# ====================================================================
# -------SP ENCARGADO DE GENERAR LOS CALCULOS DEL ISR--------
# ====================================================================
	Par_Fecha			DATE,				-- Fecha De Registro
    Par_FechaOperacion	DATE,				-- Fecha de Operacion
    Par_Dias			INT(11),			-- Numero de Dias a Sumar para el Saldo Promedio puede se 1 o 0
    Par_TipoRegistro	CHAR(1),			-- Nombre del Proceso
    Par_Salida			CHAR(1),			-- Tipo de Salida.
    INOUT Par_NumErr	INT(11),			-- Numero de Error.
    INOUT Par_ErrMen	VARCHAR(400),    	-- Mensaje de Error.

    Par_EmpresaID		INT(11),			-- Parametro de Auditoria
    Aud_Usuario			INT(11),			-- Parametro de Auditoria
    Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP		VARCHAR(20),		-- Parametro de Auditoria
    Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal		INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
						)
TerminaStored : BEGIN

-- Declaracion de Constantes
DECLARE	CadenaVacia			CHAR(1);
DECLARE EnteroCero			INT(1);
DECLARE DecimalCero			DECIMAL(12,2);
DECLARE FechaVacia			DATE;
DECLARE SalidaSI			CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE Const_NO			CHAR(1);
DECLARE Const_SI			CHAR(1);
DECLARE PagaISRSI			CHAR(1);
DECLARE InstAhorro			INT(1);
DECLARE InstInversion		INT(1);
DECLARE InstCedes			INT(1);
DECLARE EstatusPENDiente	CHAR(1);
DECLARE EstatusActivo		CHAR(1);
DECLARE Est_NoAplicado		CHAR(1);
DECLARE Est_Calculado		CHAR(1);
DECLARE EnteroUno			INT(1);
DECLARE ValorUMA			VARCHAR(12);		-- Constante para el valor de UMA
	-- Declaracion de Variables
DECLARE InicioMes			DATE;				-- Inicio de Mes
DECLARE	Fre_DiasAnio		INT(11);			-- Dias de PARAMETROSSIS
DECLARE Var_SalMinDF		DECIMAL(14,2);		-- Salario del DF
DECLARE Var_SalMinAn		DECIMAL(14,2);		-- Salario Minimo Anualizado
DECLARE VarTasaIsrGen		DECIMAL(12,2);		-- Tasa ISR de PARAMETROSSIS
DECLARE Var_Control			VARCHAR(50);		-- Control ID
DECLARE Var_EstatusISR		CHAR(1);			-- Estatus del parámetro de ISR


	-- Asignacion de Constantes
SET	CadenaVacia			:= '';					-- Cadena Vacia
SET	EnteroCero			:= 0;					-- Entero en cero
SET	DecimalCero			:= 0.00;				-- Decimal en cero
SET	FechaVacia			:= '1900-01-01';		-- Fecha Vacia
SET	SalidaSI			:= 'S';					-- El Store si regresa una Salida
SET SalidaNO			:= 'N';					-- El Store no regresa una Salida
SET Const_NO			:= 'N';					-- Constante NO
SET Const_SI			:= 'S';					-- Constante SI
SET	InstAhorro			:= 2;					-- Instrumento de CUENTA AHORRO
SET	InstInversion		:= 13;					-- Instrumento de INVERSION PLAZO
SET	InstCedes			:= 28;					-- Instrumento de CEDE
SET EstatusPENDiente	:= 'P';					-- Estatus Pendiente
SET EstatusActivo		:= 'A';					-- Estatus Activo
SET Est_NoAplicado		:= 'N';					-- Estatus No Aplicado
SET Est_Calculado		:= 'C';					-- Estatus Calculado
SET PagaISRSI			:= 'S';					-- Paga ISR Si
SET EnteroUno   	    := 1;					-- Entero en Uno
SET Aud_FechaActual		:= NOW();				-- Fecha Actual
SET ValorUMA			:= 'ValorUMABase';		-- Valor UMA Base
ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr  := 999;
					SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-CALCULOISRPRO');
					SET Var_Control := 'sqlException';
		END;

		SET InicioMes			:=	CONVERT(CONCAT(EXTRACT(YEAR_MONTH FROM Par_Fecha),'01'),DATE); 	-- Fecha Inicial del Mes.
		SET Fre_DiasAnio		:=	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro=ValorUMA);
		SET Var_SalMinDF		:=	(SELECT param.SalMinDF FROM PARAMETROSSIS param);
		SET Var_SalMinAn		:=	Var_SalMinDF * 5 * Fre_DiasAnio;
        SET VarTasaIsrGen		:=	(SELECT param.TasaISR FROM PARAMETROSSIS param);
		SET VarTasaIsrGen		:=	IFNULL(VarTasaIsrGen,DecimalCero);

		SET Var_EstatusISR		:= (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
		SET Var_EstatusISR		:= IFNULL(Var_EstatusISR, CadenaVacia);

		-- ==========================================================================================================
		-- ==============================Calculo de Periodo===========================================================
		-- ==========================================================================================================
			INSERT INTO CALCULOPERIODO(
					Fecha,				ClienteID,		TotalCaptacion,			FechaInicio,	FechaFin,
					EmpresaID,			Usuario,		FechaActual,			DireccionIP,	ProgramaID,
					Sucursal,			NumTransaccion)
			SELECT 	MAX(tc.Fecha),		tc.ClienteID,	SUM(tc.TotalCaptacion),	MIN(tc.Fecha),	MAX(tc.Fecha),
					Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,		Aud_DireccionIP,Aud_ProgramaID,
					Aud_Sucursal,   	Aud_NumTransaccion
				FROM TOTALCAPTACION tc
					INNER JOIN CTESVENCIMIENTOS tmp ON tc.ClienteID = tmp.ClienteID
						AND tmp.Fecha = Par_Fecha
						AND tmp.NumTransaccion = Aud_NumTransaccion
					WHERE tc.Fecha >= InicioMes
						AND tc.Fecha <= Par_FechaOperacion
						AND tc.Estatus = EstatusPENDiente
							GROUP BY tc.ClienteID;


		-- ==========================================================================================================
		-- ==============================Corte para Ahorro===========================================================
		-- ==========================================================================================================

			INSERT INTO COBROISR(
					Fecha,				ClienteID,				InstrumentoID,		ProductoID,			PagaISR,
					TasaISR,			SumSaldos,				SaldoProm,			InicioPeriodo,		FinPeriodo,
					ISRTotal,			ISR,					Factor,	        	Estatus,			TipoRegistro,EmpresaID,
					Usuario,			FechaActual,			DireccionIP,		ProgramaID,     	Sucursal,
					NumTransaccion)
			SELECT 	Par_Fecha,			fac.ClienteID,			InstAhorro,			fac.CuentaAhoID,	CadenaVacia,
					EnteroCero,			MAX(tc.TotalCaptacion),	EnteroCero,			MIN(tc.FechaInicio),MAX(tc.FechaFin),
					EnteroCero,    		EnteroCero,				SUM(fac.Factor),    Est_NoAplicado,		Par_TipoRegistro,
					Par_EmpresaID,		Aud_Usuario,    		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,   	Aud_NumTransaccion
				FROM FACTORAHORRO fac
					INNER JOIN CALCULOPERIODO tc ON fac.ClienteID = tc.ClienteID AND tc.NumTransaccion = Aud_NumTransaccion
					WHERE fac.Fecha >= InicioMes AND fac.Fecha <= Par_FechaOperacion
						AND fac.Estatus = EstatusPENDiente
							GROUP BY tc.ClienteID, fac.CuentaAhoID;
		-- ==========================================================================================================
		-- ==============================Corte para Inversiones======================================================
		-- ==========================================================================================================

			INSERT INTO COBROISR(
					Fecha,			ClienteID,			InstrumentoID,		ProductoID,			PagaISR,
					TasaISR,		SumSaldos,			SaldoProm,			InicioPeriodo,		FinPeriodo,
					ISRTotal,		ISR,				Factor,	        	Estatus,			TipoRegistro,EmpresaID,
					Usuario,		FechaActual,		DireccionIP,		ProgramaID,     	Sucursal,
					NumTransaccion)
			SELECT 	Par_Fecha,		fac.ClienteID,				InstInversion,		fac.InversionID,	CadenaVacia,
					EnteroCero,		MAX(tc.TotalCaptacion),		EnteroCero,			MIN(tc.FechaInicio),MAX(tc.FechaFin),
					EnteroCero,    	EnteroCero,					SUM(fac.Factor),    Est_NoAplicado,		Par_TipoRegistro,
					Par_EmpresaID,	Aud_Usuario,    			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,   Aud_NumTransaccion
				FROM FACTORINVERSION fac
					INNER JOIN CALCULOPERIODO tc ON tc.ClienteID = fac.ClienteID AND tc.NumTransaccion = Aud_NumTransaccion
					WHERE fac.Fecha >= InicioMes AND fac.Fecha <= Par_Fecha AND fac.Estatus = EstatusPENDiente
						GROUP BY tc.ClienteID, fac.InversionID;



		-- ==========================================================================================================
		-- ==============================Corte para CEDES============================================================
		-- ==========================================================================================================

			INSERT INTO COBROISR(
					Fecha,			ClienteID,			InstrumentoID,		ProductoID,		PagaISR,
					TasaISR,		SumSaldos,			SaldoProm,			InicioPeriodo,	FinPeriodo,
					ISRTotal,		ISR,				Factor,	       		Estatus,		TipoRegistro,EmpresaID,
					Usuario,		FechaActual,		DireccionIP,		ProgramaID,     Sucursal,
					NumTransaccion)
			SELECT 	Par_Fecha,		fac.ClienteID,				InstCedes,			fac.CedeID,			CadenaVacia,
					EnteroCero,		MAX(tc.TotalCaptacion),		EnteroCero,			MIN(tc.FechaInicio),MAX(tc.FechaFin),
					EnteroCero,    	EnteroCero,					SUM(fac.Factor),    Est_NoAplicado,		Par_TipoRegistro,
					Par_EmpresaID,	Aud_Usuario,   				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,   Aud_NumTransaccion
				FROM FACTORCEDES fac
					INNER JOIN CALCULOPERIODO tc ON fac.ClienteID = tc.ClienteID AND tc.NumTransaccion = Aud_NumTransaccion
						WHERE fac.Fecha >= InicioMes AND fac.Fecha <= Par_Fecha AND fac.Estatus = EstatusPENDiente
							GROUP BY tc.ClienteID, fac.CedeID;
		-- ==========================================================================================================
		-- ==============================Inicia Calculo del ISR======================================================
		-- ==========================================================================================================

	/* Se actualiza en la tabla COBROISR el Saldo Promedio, Si Paga ISR, la Tasa ISR */
        UPDATE COBROISR ci
			INNER JOIN CLIENTES cte ON ci.ClienteID = cte.ClienteID
			INNER JOIN SUCURSALES suc ON cte.SucursalOrigen = suc.SucursalID
				SET ci.SaldoProm = ci.SumSaldos/CASE WHEN (DATEDIFF(ci.FinPeriodo,ci.InicioPeriodo)+Par_Dias) = EnteroCero
																	THEN EnteroUno ELSE (DATEDIFF(ci.FinPeriodo,ci.InicioPeriodo)+Par_Dias)  END,
					ci.PagaISR	 = cte.PagaISR,
					ci.TasaISR	 = CALCULATASAISR(ci.FinPeriodo,VarTasaIsrGen)
			WHERE ci.Fecha = Par_Fecha AND ci.Estatus = Est_NoAplicado;

    /* Se actualiza en la tabla COBROISR el ISR Total */
    /* Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna. */
		UPDATE COBROISR ci
			INNER JOIN CLIENTES cli
				ON ci.ClienteID = cli.ClienteID
			SET	ci.ISRTotal = CASE WHEN(ci.SaldoProm >= Var_SalMinAn OR cli.TipoPersona = 'M') THEN
										CASE WHEN cli.TipoPersona = 'M' THEN
												(ci.SaldoProm*ci.TasaISR*(DATEDIFF(ci.FinPeriodo,ci.InicioPeriodo)+Par_Dias)/36000)
												-FNCALCULAISRREST(ci.FinPeriodo,ci.InicioPeriodo,(ci.SaldoProm))
											ELSE
												((ci.SaldoProm-Var_SalMinAn)*ci.TasaISR*(DATEDIFF(ci.FinPeriodo,ci.InicioPeriodo)+Par_Dias)/36000)
												-FNCALCULAISRREST(ci.FinPeriodo,ci.InicioPeriodo,(ci.SaldoProm-Var_SalMinAn))
                                            END
									ELSE EnteroCero	END
			WHERE ci.Fecha = Par_Fecha AND ci.Estatus = Est_NoAplicado;

		# SE ACTUALIZA EL FACTOR DE CAPTACIÓN EN FUNCIÓN AL SALDO PROMEDIO DE CADA INSTRUMENTO DE CAPTACIÓN.
		IF(Var_EstatusISR = EstatusActivo)THEN
			CALL FACTORCAPISRPRO(
				Par_Fecha,			Par_FechaOperacion,	Par_Dias,		Par_TipoRegistro,	Const_SI,
                SalidaNO,
				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != EnteroCero)THEN
				LEAVE ManejoErrores;
			END IF;
			/* Se actualiza la tabla COBROISR el ISR */
			UPDATE COBROISR ci
				SET ci.ISR	=  (ci.ISRTotal*ci.Factor)
				WHERE ci.Fecha = Par_Fecha
					AND ci.Estatus = Est_NoAplicado
					AND ci.PagaISR = PagaISRSI;
		ELSE
			/* Se actualiza la tabla COBROISR el ISR */
			UPDATE COBROISR ci
				SET ci.ISR	=  (ci.ISRTotal/CASE WHEN (DATEDIFF(ci.FinPeriodo,ci.InicioPeriodo)+Par_Dias) = EnteroCero
																		THEN EnteroUno ELSE (DATEDIFF(ci.FinPeriodo,ci.InicioPeriodo)+Par_Dias)  END)*ci.Factor
				WHERE ci.Fecha = Par_Fecha
					AND ci.Estatus = Est_NoAplicado
					AND ci.PagaISR = PagaISRSI;
		END IF;

		-- ==========================================================================================================
		-- ==============================Se Actualizan los Registros a Calculados==================================
		-- ==========================================================================================================

	/* Se actualiza la tabla TOTAL CAPTACION el Estatus a Calculado */
			UPDATE	TOTALCAPTACION tc
				INNER JOIN CTESVENCIMIENTOS isr ON tc.ClienteID = isr.ClienteID AND isr.Fecha = Par_Fecha
				AND isr.NumTransaccion = Aud_NumTransaccion
				SET tc.Estatus = Est_Calculado
			WHERE tc.Estatus = EstatusPENDiente AND tc.Fecha >= InicioMes AND tc.Fecha<= Par_FechaOperacion;

	/* Se actualiza la tabla FACTORAHORRO el Estatus a Calculado */
			UPDATE FACTORAHORRO fac
				INNER JOIN CTESVENCIMIENTOS isr ON fac.ClienteID = isr.ClienteID AND isr.Fecha = Par_Fecha
				AND isr.NumTransaccion = Aud_NumTransaccion
				SET fac.Estatus = Est_Calculado
			WHERE fac.Fecha >= InicioMes AND fac.Fecha <= Par_FechaOperacion
					AND fac.Estatus = EstatusPENDiente;

	/* Se actualiza la tabla FACTORINVERSION el Estatus a Calculado*/
			UPDATE FACTORINVERSION fac
				INNER JOIN CTESVENCIMIENTOS isr ON fac.ClienteID = isr.ClienteID AND isr.Fecha = Par_Fecha
				AND isr.NumTransaccion = Aud_NumTransaccion
				SET fac.Estatus = Est_Calculado
			WHERE fac.Fecha >= InicioMes AND fac.Fecha <= Par_FechaOperacion AND fac.Estatus = EstatusPENDiente;

	/* Se actualiza la tabla FACTORCEDES el Estatus a Calculado*/
			UPDATE FACTORCEDES fac
				INNER JOIN CTESVENCIMIENTOS cte ON fac.ClienteID = cte.ClienteID AND cte.Fecha= Par_Fecha
				AND cte.NumTransaccion = Aud_NumTransaccion
				SET fac.Estatus = Est_Calculado
			WHERE fac.Fecha >= InicioMes AND fac.Fecha <= Par_FechaOperacion
									AND fac.Estatus = EstatusPENDiente;
		-- ==========================================================================================================
		-- ==============================Fin de Calculo del ISR======================================================
		-- ==========================================================================================================

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Calculo de ISR Exitoso';

END ManejoErrores;

  /*Se eliminan registros de las tablas */
	DELETE FROM CALCULOPERIODO 	WHERE NumTransaccion 	= Aud_NumTransaccion;
	DELETE FROM TMPFACTORES 	WHERE NumTransaccion 	= Aud_NumTransaccion;

IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
						Par_ErrMen	 		 AS ErrMen,
						Var_Control 		 AS Control;
END IF;

END TerminaStored$$