-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISRPENDIENTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ISRPENDIENTEPRO`;DELIMITER $$

CREATE PROCEDURE `ISRPENDIENTEPRO`(
# ====================================================================
# -------SP ENCARGADO DE CALCULAR EL ISR--------
# ====================================================================
	Par_Fecha			DATE,				-- Fecha De Registro
    INOUT Par_NumErr	INT(11),			-- Numero de Error.
    INOUT Par_ErrMen	VARCHAR(400),		-- Mensaje de Error.
    Par_Salida			CHAR(1),			-- Tipo de Salida.

    Par_Empresa			INT(11),    		-- Parametro de Auditoria
    Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria

					)
TerminaStored : BEGIN

-- Declaracion de variables
DECLARE Entero_Cero			INT(11);
DECLARE EnteroUno			INT(11);
DECLARE DecimalCero			DECIMAL(12,2);
DECLARE Var_EstatusISR		CHAR(1);			-- Estatus del parámetro de ISR


DECLARE InicioMes			DATE;
DECLARE FinMes				DATE;
DECLARE InstInversion		INT(11);
DECLARE DiasInversion		INT(11);
DECLARE Con360				INT(11);
DECLARE SalMinAnuDF			DECIMAL(12,2);
DECLARE SalMinDF			DECIMAL(12,2);
DECLARE Est_Aplicado		CHAR(1);
DECLARE Est_NoAplicado		CHAR(1);
DECLARE InstCede			INT(11);
DECLARE Est_Vigente			CHAR(1);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE ProcesoCierre		CHAR(1);
DECLARE EstatusPendiente	CHAR(1);
DECLARE EstatusCalculado	CHAR(1);
DECLARE PagaISRSI			CHAR(1);
DECLARE Const_NO			CHAR(1);
DECLARE Const_SI			CHAR(1);
DECLARE VarTasaIsrGen		DECIMAL(12,2);
DECLARE ProCalculoISRMes	INT(11);
DECLARE Var_FechaBatch  	DATE;			 -- Fecha en la que se realiza el proceso
DECLARE Var_EsCritico  		CHAR(1);		 -- S = si el proceso es critico y N= no es critico
DECLARE Fecha_Vacia     	DATE;
DECLARE Var_Control			VARCHAR(50);	 -- Control ID
DECLARE Persona_Moral	    CHAR(1);
DECLARE ValorUMA			VARCHAR(12);	-- Constante para el valor de UMA
DECLARE Salida_NO			CHAR(1);
DECLARE EstatusActivo			CHAR(1);

-- Asignacion de constantes
SET Entero_Cero			:= 0;
SET EnteroUno			:= 1;
SET DecimalCero			:= 0.0;
SET Con360				:= 360;
SET Est_Aplicado		:= 'A';
SET Est_NoAplicado		:= 'N';
SET InstInversion		:= 13;
SET InstCede			:= 28;
SET Est_Vigente			:= 'N';
SET InicioMes			:= CONVERT(CONCAT(extract(YEAR_MONTH FROM Par_Fecha),'01'),DATE);		-- Fecha de Inicio del Mes a Trabajar.
SET FinMes				:= last_day(Par_Fecha);
SET Cadena_Vacia		:= '';
SET Const_NO			:= 'N';
SET Const_SI			:= 'S';
SET ProcesoCierre		:= 'S';
SET EstatusPendiente	:= 'P';
SET EstatusCalculado	:= 'C';
SET PagaISRSI			:= 'S';
SET ProCalculoISRMes	:= 1102;	-- Proceso Batch para el Calculo de ISR a fin de Mes
SET Fecha_Vacia     	:= '1900-01-01';	-- Fecha Vacia
SET Persona_Moral		:= 'M';
SET ValorUMA			:= 'ValorUMABase';		-- Valor UMA Base
SET Salida_NO			:= 'N';
SET EstatusActivo		:= 'A';

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al
			concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-ISRPENDIENTEPRO');
            SET Var_Control := 'sqlException';
		END;

-- Asignacion de constantes

SET DiasInversion		:=	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro=ValorUMA);
SET SalMinDF			:=  (SELECT param.SalMinDF FROM PARAMETROSSIS param);
SET SalMinAnuDF 		:=  SalMinDF * 5 * DiasInversion;
SET VarTasaIsrGen		:=	(SELECT param.TasaISR FROM PARAMETROSSIS param);
SET VarTasaIsrGen		:=	IFNULL(VarTasaIsrGen,DecimalCero);

SET Var_EstatusISR		:= (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
SET Var_EstatusISR		:= IFNULL(Var_EstatusISR, Cadena_Vacia);


			TRUNCATE TABLE TMPFACTORES;
			TRUNCATE TABLE CALCULOPERIODO;

			INSERT INTO CALCULOPERIODO(
					Fecha,				ClienteID,		TotalCaptacion,			FechaInicio,	FechaFin,
					EmpresaID,			Usuario,		FechaActual,			DireccionIP,	ProgramaID,
					Sucursal,			NumTransaccion)
			SELECT 	FinMes,				tc.ClienteID,	SUM(tc.TotalCaptacion),	MIN(tc.Fecha),	FinMes,
					Par_Empresa,      	Aud_Usuario,    Aud_FechaActual,		Aud_DireccionIP,Aud_ProgramaID,
					Aud_Sucursal,   	Aud_NumTransaccion
				FROM TOTALCAPTACION tc
					WHERE tc.Fecha >= InicioMes AND tc.Fecha <= FinMes AND tc.Estatus = EstatusPendiente
						GROUP BY tc.ClienteID;

			INSERT INTO COBROISR(
					Fecha,			ClienteID,				InstrumentoID,	ProductoID,			PagaISR,
					TasaISR,		SumSaldos,				SaldoProm,		InicioPeriodo,		FinPeriodo,
					ISRTotal,		ISR,					Factor,	        Estatus,			TipoRegistro,EmpresaID,
					Usuario,		FechaActual,			DireccionIP,	ProgramaID,     	Sucursal,
					NumTransaccion)
			SELECT 	FinMes,			fac.ClienteID,			InstInversion,		fac.InversionID,		Cadena_Vacia,
					Entero_Cero,	MAX(cal.TotalCaptacion),Entero_Cero,		MIN(cal.FechaInicio),	MAX(cal.FechaFin),
					Entero_Cero,    Entero_Cero,			SUM(fac.Factor),    Est_NoAplicado,			ProcesoCierre,Par_Empresa,
					Aud_Usuario,    Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion
				FROM FACTORINVERSION fac
					INNER JOIN CALCULOPERIODO cal ON fac.ClienteID = cal.ClienteID AND cal.Fecha = FinMes
					INNER JOIN INVERSIONES inv ON fac.InversionID = inv.InversionID AND inv.Estatus = Est_NoAplicado
						WHERE fac.Fecha >= InicioMes AND fac.Fecha <= FinMes
							AND fac.Estatus = EstatusPendiente
							GROUP BY fac.ClienteID,fac.InversionID;



			INSERT INTO COBROISR(
					Fecha,			ClienteID,				InstrumentoID,	ProductoID,			PagaISR,
					TasaISR,		SumSaldos,				SaldoProm,		InicioPeriodo,		FinPeriodo,
					ISRTotal,		ISR,					Factor,	        Estatus,			TipoRegistro,
                    EmpresaID,		Usuario,				FechaActual,	DireccionIP,		ProgramaID,
                    Sucursal,		NumTransaccion)
			SELECT 	FinMes,			fac.ClienteID,			InstCede,			fac.CedeID,				Cadena_Vacia,
					Entero_Cero,	MAX(cal.TotalCaptacion),Entero_Cero,		MIN(cal.FechaInicio),	MAX(cal.FechaFin),
					Entero_Cero,    Entero_Cero,			SUM(fac.Factor),    Est_NoAplicado,			ProcesoCierre,
                    Par_Empresa,	Aud_Usuario,   			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
                    Aud_Sucursal,   Aud_NumTransaccion
				FROM FACTORCEDES fac
					INNER JOIN CALCULOPERIODO cal ON fac.ClienteID = cal.ClienteID AND cal.Fecha = FinMes
					INNER JOIN CEDES cede ON fac.CedeID = cede.CedeID AND cede.Estatus = Est_NoAplicado
					WHERE fac.Fecha >= InicioMes AND fac.Fecha <= FinMes
                    AND fac.Estatus = EstatusPendiente
						GROUP BY fac.ClienteID,fac.CedeID;

	   UPDATE COBROISR ci
		INNER JOIN CLIENTES cte ON ci.ClienteID = cte.ClienteID
			SET ci.SaldoProm = ci.SumSaldos/(DATEDIFF(ci.FinPeriodo,ci.InicioPeriodo)+1),
				ci.PagaISR	 = cte.PagaISR,
				ci.TasaISR	 = CALCULATASAISR(ci.FinPeriodo,VarTasaIsrGen)
		WHERE ci.Fecha = FinMes AND ci.Estatus = Est_NoAplicado;

			-- SE HACE EL CALCULO DEL ISR SOBRE LA DIFERENCIA DEL SALDO PROMEDIO Y LOS 5 SALARIOS MIN ANUALIZADOS
			UPDATE COBROISR ci
				INNER JOIN CLIENTES cli
						ON ci.ClienteID = cli.ClienteID
				SET	ci.ISRTotal = CASE WHEN(ci.SaldoProm >= SalMinAnuDF OR cli.TipoPersona = Persona_Moral) THEN
									((ci.SaldoProm-CASE WHEN cli.TipoPersona = Persona_Moral THEN Entero_Cero ELSE SalMinAnuDF END)*ci.TasaISR*(DATEDIFF(ci.FinPeriodo,ci.InicioPeriodo)+1)/36000)
									-FNCALCULAISRREST(ci.FinPeriodo,ci.InicioPeriodo,(ci.SaldoProm- CASE WHEN cli.TipoPersona = Persona_Moral THEN Entero_Cero ELSE  SalMinAnuDF END))
								ELSE Entero_Cero END
				WHERE ci.Fecha = FinMes
					AND ci.Estatus = Est_NoAplicado;
		# SE ACTUALIZA EL FACTOR DE CAPTACIÓN EN FUNCIÓN AL SALDO PROMEDIO DE CADA INSTRUMENTO DE CAPTACIÓN.
		IF(Var_EstatusISR = EstatusActivo)THEN
			CALL FACTORCAPISRPRO(
				FinMes,				Par_Fecha,			1,				ValorUMA,			Const_NO,		Salida_NO,
				Par_NumErr,			Par_ErrMen,			Par_Empresa,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			/* Se actualiza la tabla COBROISR el ISR */
			UPDATE COBROISR ci
				SET ci.ISR	=  (ci.ISRTotal*ci.Factor)
				WHERE ci.Fecha = FinMes
					AND ci.Estatus = Est_NoAplicado
					AND ci.PagaISR = PagaISRSI;
		ELSE
			-- Actualizacion normal de ISR
			UPDATE COBROISR
				SET ISR	= (ISRTotal/(DATEDIFF(FinPeriodo,InicioPeriodo)+1))*Factor
				WHERE Fecha = FinMes
					AND Estatus = Est_NoAplicado
                    AND PagaISR = PagaISRSI;
		END IF;

			UPDATE TOTALCAPTACION tc
				INNER JOIN COBROISR isr ON tc.ClienteID = isr.ClienteID AND isr.Fecha = FinMes
				SET	tc.Estatus = EstatusCalculado
			WHERE tc.Fecha >= InicioMes AND tc.Fecha <= FinMes AND tc.Estatus = EstatusPendiente;

			UPDATE FACTORINVERSION fac
				INNER JOIN COBROISR isr ON fac.ClienteID = isr.ClienteID AND isr.Fecha = FinMes
				SET fac.Estatus = EstatusCalculado
			WHERE fac.Fecha >= InicioMes AND fac.Fecha <= FinMes AND fac.Estatus = EstatusPendiente;

			UPDATE FACTORCEDES fac
				INNER JOIN COBROISR isr ON fac.ClienteID = isr.ClienteID AND isr.Fecha = FinMes
				SET fac.Estatus = EstatusCalculado
			WHERE fac.Fecha >= InicioMes AND fac.Fecha <= FinMes AND fac.Estatus = EstatusPendiente;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Calculo de ISR  Pendiente Exitoso';

	END ManejoErrores;

	IF (Par_Salida = Const_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStored$$