-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTACIERREEJERCICIO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTACIERREEJERCICIO`;

DELIMITER $$
CREATE PROCEDURE `CONTACIERREEJERCICIO`(
	Par_Fecha           		DATE,		  	-- Fecha de Cierre
	Par_EjercicioID				INT(11),		-- Numero de Ejercicio
	Par_PeriodoID				INT(11),		-- Numero de Periodo
	Par_CuentaContable			VARCHAR(30),	-- Numero de Cuenta Contable
	Par_Salida    				CHAR(1),		-- Parametro de salida S= si, N= no

	INOUT Par_NumErr 			INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen  			VARCHAR(400),	-- Parametro de salida mensaje de error
	INOUT Par_Poliza  			BIGINT,			-- Numero de Poliza
	INOUT Par_SaldoEjercicio  		DECIMAL(18,2),	-- Saldo del Ejercicio

	Par_EmpresaID       	INT(11),		-- Parametro de Auditoria
	Aud_Usuario         	INT(11),		-- Parametro de Auditoria
	Aud_FechaActual     	DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP     	VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID      	VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal        	INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion  	BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaSaldos		DATE;
	DECLARE Var_PerEstatus		CHAR(1);
	DECLARE	Var_FecAnio			INT;
	DECLARE	Var_FechaFinPer		DATE;
	DECLARE	Var_FechaIniPer		DATE;

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT;
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Var_SalidaNO	CHAR(1);
	DECLARE Var_SalidaSI	CHAR(1);
	DECLARE VarDeudora		CHAR(1);
	DECLARE VarAcreedora	CHAR(1);
	DECLARE Tip_Detalle		CHAR(1);
	DECLARE Pol_Automatica	CHAR(1);
	DECLARE Coc_CierreEjer	INT;
	DECLARE Ins_Usuario		INT;
	DECLARE	Des_CierreEjer	VARCHAR(50);

	-- Asignacion de Constantes
	SET Entero_Cero     := 0;				-- Entero Cero
	SET Cadena_Vacia    := '';				-- Cadena Vacia
	SET Fecha_Vacia     := '1900-01-01';	-- Fecha Vacia
	SET Var_SalidaNO    := 'N';      		-- Salida: NO
	SET Var_SalidaSI    := 'S';             -- Salida: SI
	SET VarDeudora      := 'D';				-- Naturaleza: Deudora
	SET VarAcreedora    := 'A';				-- Naturaleza: Acreedora
	SET Tip_Detalle 	:= 'D';				-- Tipo: Detalle

	SET Pol_Automatica  := 'A';  			-- Poliza Automatica
	SET	Coc_CierreEjer	:= 1;				-- Cierre de Ejercicio
	SET Ins_Usuario  	:= 7;  				-- Numero Usuario
	SET	Des_CierreEjer	:= 'CIERRE DE EJERCICIO';		-- Descripcion de cierre

	 ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTACIERREEJERCICIO');
			END;

		SET Par_Fecha   := IFNULL(Par_Fecha, Fecha_Vacia);

		CALL TRANSACCIONESPRO(Aud_NumTransaccion);

		SET Var_FecAnio := CONVERT(YEAR(Par_Fecha), UNSIGNED);

		DELETE FROM TMPCUENTACONTABLE
			WHERE NumTransaccion = Aud_NumTransaccion;

		DELETE FROM SALDOCONTACIERREJER WHERE Anio = Var_FecAnio AND EjercicioID = Par_EjercicioID and PeriodoID = Par_PeriodoID;

		SELECT MAX(FechaCorte) INTO Var_FechaSaldos
			FROM  SALDOSCONTABLES
			WHERE FechaCorte = Par_Fecha;

		SET Var_FechaSaldos	:= IFNULL(Var_FechaSaldos, Fecha_Vacia);

		INSERT INTO TMPCUENTACONTABLE
		SELECT	Aud_NumTransaccion, Cue.CuentaCompleta, Cen.CentroCostoID,	Cadena_Vacia,	Cadena_Vacia,
				Cue.Naturaleza,		Cadena_Vacia,		Entero_Cero
			FROM CUENTASCONTABLES Cue,
				 CENTROCOSTOS Cen;

		SELECT Fin, Inicio INTO Var_FechaFinPer, Var_FechaIniPer
			FROM PERIODOCONTABLE
			WHERE EjercicioID = Par_EjercicioID
			  AND PeriodoID = Par_PeriodoID;

		SET Var_FechaFinPer := IFNULL(Var_FechaFinPer, Fecha_Vacia);

		INSERT INTO TMPCONTABLE
		SELECT	Aud_NumTransaccion,			Par_Fecha,				MAX(Sal.CuentaCompleta),	MAX(Sal.CentroCosto),	SUM(IFNULL(Pol.Cargos,0)),
				SUM(IFNULL(Pol.Abonos,0)),	MAX(Sal.Naturaleza), 	Entero_Cero,				Entero_Cero,			Entero_Cero,
				Entero_Cero
		FROM 	DETALLEPOLIZA Pol,
				TMPCUENTACONTABLE Sal
		WHERE Pol.CuentaCompleta =	Sal.CuentaCompleta
		  AND Pol.CentroCostoID = Sal.CentroCosto
		  AND Sal.NumTransaccion = Aud_NumTransaccion
		  AND Pol.Fecha >= 	Var_FechaIniPer
		  AND Pol.Fecha <= 	Var_FechaFinPer
		GROUP BY Pol.CuentaCompleta, Pol.CentroCostoID;

		INSERT INTO SALDOCONTACIERREJER
		SELECT 	Var_FecAnio,	Par_EjercicioID,	Par_PeriodoID,	Cue.CuentaCompleta, Cue.CentroCosto,
				Sal.FechaCorte,	IFNULL(Sal.SaldoInicial, Entero_Cero),
				IFNULL(Tmp.Cargos, Entero_Cero),	IFNULL(Tmp.Abonos, Entero_Cero),
				CASE WHEN 	Tmp.Naturaleza = VarDeudora
					THEN		IFNULL((IFNULL(Tmp.Cargos, Entero_Cero)+IFNULL(Sal.SaldoInicial, Entero_Cero))- IFNULL(Tmp.Abonos, Entero_Cero), Entero_Cero)
					ELSE		IFNULL((IFNULL(Tmp.Abonos, Entero_Cero)+IFNULL(Sal.SaldoInicial, Entero_Cero))- IFNULL(Tmp.Cargos, Entero_Cero), Entero_Cero) END,
				Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			FROM TMPCUENTACONTABLE Cue
			LEFT OUTER JOIN TMPCONTABLE AS Tmp ON ( Cue.CuentaCompleta = Tmp.CuentaContable
												AND Cue.CentroCosto = Tmp.CentroCosto
												AND NumeroTransaccion = Aud_NumTransaccion )
			LEFT OUTER JOIN SALDOSCONTABLES AS Sal ON (Sal.FechaCorte = Var_FechaSaldos
												 AND Cue.CuentaCompleta = Sal.CuentaCompleta
												AND Cue.CentroCosto = Sal.CentroCosto)
			WHERE Cue.NumTransaccion = Aud_NumTransaccion;



		SET Des_CierreEjer := CONCAT(Des_CierreEjer, ' ', CONVERT(Par_Fecha, CHAR));

		CALL MAESTROPOLIZASALT(
			Par_Poliza,			Par_EmpresaID,		Par_Fecha,		Pol_Automatica,		Coc_CierreEjer,
			Des_CierreEjer,		Var_SalidaNO,		Par_NumErr,		Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO DETALLEPOLIZA(
			EmpresaID,		PolizaID,			Fecha,				CentroCostoID,	CuentaCompleta,
			Instrumento,	MonedaID,			Cargos,				Abonos,			Descripcion,
			Referencia,		ProcedimientoCont,	TipoInstrumentoID,	Usuario,		FechaActual,
			DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)

		SELECT 	Par_EmpresaID,	Par_Poliza, 	Par_Fecha,	Sal.CentroCosto,	Sal.CuentaCompleta,
				Aud_Usuario,	Cue.MonedaID,
				CASE WHEN Cue.Naturaleza = VarAcreedora THEN Sal.SaldoFinal ELSE Entero_Cero END,
				CASE WHEN Cue.Naturaleza = VarDeudora THEN Sal.SaldoFinal ELSE Entero_Cero END,
				Cue.Descripcion,	Des_CierreEjer, 'CONTACIERREEJERCICIO',
				Ins_Usuario,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion

			FROM CUENTASCONTABLES Cue,
				 SALDOCONTACIERREJER Sal
			WHERE Cue.CuentaCompleta = Sal.CuentaCompleta
			AND Sal.FechaCorte= Par_Fecha
			  AND Cue.Grupo = VarDeudora
			  AND SaldoFinal != Entero_Cero
			  AND Cue.TipoCuenta IN (5,6);

		SET Par_SaldoEjercicio := IFNULL(Par_SaldoEjercicio, Entero_Cero);

		INSERT INTO DETALLEPOLIZA(
			EmpresaID,		PolizaID,			Fecha,				CentroCostoID,	CuentaCompleta,
			Instrumento,	MonedaID,			Cargos,				Abonos,			Descripcion,
			Referencia,		ProcedimientoCont,	TipoInstrumentoID,	Usuario,		FechaActual,
			DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)

		SELECT 	Par_EmpresaID,	Par_Poliza,			Par_Fecha,		Sal.CentroCosto,	Par_CuentaContable,
				Aud_Usuario,	Cue.MonedaID,
				IF((SUM(CASE WHEN Cue.Naturaleza = VarDeudora THEN Sal.SaldoFinal ELSE 0 END) -SUM(CASE WHEN Cue.Naturaleza = VarAcreedora THEN Sal.SaldoFinal ELSE 0 END))>0, SUM(CASE WHEN Cue.Naturaleza = VarDeudora THEN Sal.SaldoFinal ELSE 0 END) - SUM(CASE WHEN Cue.Naturaleza = VarAcreedora THEN Sal.SaldoFinal ELSE 0 END),0)Cargos,
				IF((SUM(CASE WHEN Cue.Naturaleza = VarAcreedora THEN Sal.SaldoFinal ELSE 0 END) -SUM(CASE WHEN Cue.Naturaleza = VarDeudora THEN Sal.SaldoFinal ELSE 0 END))>0, SUM(CASE WHEN Cue.Naturaleza = VarAcreedora THEN Sal.SaldoFinal ELSE 0 END) - SUM(CASE WHEN Cue.Naturaleza = VarDeudora THEN Sal.SaldoFinal ELSE 0 END),0)Abonos,
				'RESULTADO DEL EJERCICIO',
				Des_CierreEjer, 'CONTACIERREEJERCICIO',
				Ins_Usuario,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion

			FROM CUENTASCONTABLES Cue,
				 SALDOCONTACIERREJER Sal
			WHERE Cue.CuentaCompleta = Sal.CuentaCompleta
			  AND Cue.Grupo = Tip_Detalle
			  AND Sal.FechaCorte= Par_Fecha
			  AND SaldoFinal != Entero_Cero
			  AND Cue.TipoCuenta IN (5,6)
			GROUP BY Sal.CentroCosto, Cue.MonedaID;

		-- Se recalcula el saldo a la fecha de consulta
		CALL SALDOSDETALLEPOLIZADIAPRO(
			Par_Fecha,
			Var_SalidaNO,		Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM TMPCUENTACONTABLE
			WHERE NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMPCONTABLE
			WHERE NumeroTransaccion = Aud_NumTransaccion;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Cierre del Ejercicio Realizado Correctamente';

	END ManejoErrores;

		IF(Par_Salida = Var_SalidaSI)THEN
			SELECT 	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Par_Poliza AS consecutivo,
					Par_SaldoEjercicio;
		END IF;

END TerminaStore$$