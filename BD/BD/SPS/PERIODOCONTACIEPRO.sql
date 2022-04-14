-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERIODOCONTACIEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERIODOCONTACIEPRO`;

DELIMITER $$
CREATE PROCEDURE `PERIODOCONTACIEPRO`(
	-- ---------------------------------------------------------------------------------
	-- ----------- CIERRE DEL PERIODO CONTABLE -----------------------------------------
	-- ---------------------------------------------------------------------------------
	Par_EjercicioID		INT(11),		-- Numero de Ejercicio a cerrar
	Par_PeriodoID		INT(11),		-- Numero de periodo del ejercicio

	Par_EmpresaID		INT(11), 		-- Auditoria
	Aud_Usuario			INT(11),		-- Auditoria
	Aud_FechaActual		DATETIME,		-- Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Auditoria
	Aud_Sucursal		INT(11),		-- Auditoria
	Aud_NumTransaccion	BIGINT(20)		-- Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE	Var_UltFecPer		DATE;			-- Fecha del ultimo periodo
	DECLARE	Var_FechaFinPer		DATE;			-- Fecha de fin del periodo seleccionado
	DECLARE	Var_FechaIniPer		DATE;			-- Fecha de inicio del periodo
	DECLARE	Var_FechaSistema	DATE; 			-- Fecha del sistema
	DECLARE UltimoPeriodo		INT(11);		-- Ultimo periodo del ejercicio vigente
	DECLARE Var_PerEstatus  	CHAR(1); 		-- Estatus del periodo
	DECLARE Var_Anio			INT(11); 		-- Anio
	DECLARE	Var_Mes				INT(11);		-- Mes
	DECLARE	Par_CuentaContable	VARCHAR(50);	-- Numero de cuenta contable
	DECLARE Var_FinEjercicio	CHAR(1); 		-- Fin del ejercicio
	DECLARE	Par_Poliza  		BIGINT; 		-- Numero de poliza
	DECLARE	Par_SaldoEjercicio  DECIMAL(18,2);  -- Saldo del Ejercicio vigente
	DECLARE Var_AnioDepreAmorti	INT(11); 		-- Anio de depreciaacion y amortiizacion
	DECLARE	Var_MesDepreAmorti	INT(11);		-- Mes de depreciaacion y amortiizacion
	DECLARE Var_FechaDepreAmorti DATE;
	DECLARE Var_Control			VARCHAR(100);
	DECLARE Var_PolActual       BIGINT(12);
	DECLARE Var_EjecDepreAmortiAut	CHAR(1);	-- habilitar o deshabilitar el proceso automático de la aplicación de Depreciación y Amortización.
	DECLARE CtaContaCierrePeriodo	VARCHAR(50);	-- Cuenta Contable de Cierre de Periodo
	DECLARE Var_horinicon       VARCHAR(100);      -- LlaveParametro para Hora de inicio para no hacer el CIERRE
	DECLARE Var_horfincon       VARCHAR(100);      -- LlaveParametro para  Hora fin para no hacer el CIERRE
	DECLARE Var_Horainicial     VARCHAR(100);      -- Hora de inicio para no hacer el CIERRE
	DECLARE Var_Horafinal       VARCHAR(100);      -- Hora para  Hora fin para no hacer el CIERRE

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Moneda_Cero		INT(11);
	DECLARE	Cerrado			CHAR(1);
	DECLARE PrimerPeriodo	INT(11);
	DECLARE	VarDeudora		CHAR(1);
	DECLARE	VarAcreedora	CHAR(1);
	DECLARE Salida_NO		CHAR(1);
	DECLARE	Par_NumErr 		INT(11);
	DECLARE	Par_ErrMen  	VARCHAR(400);
	DECLARE Con_SI			CHAR(1);
	DECLARE Con_NO			CHAR(1);
	DECLARE Est_Regitrado	CHAR(1);
	DECLARE TipoPoliza		CHAR(1);
	DECLARE ConContaDepre 	INT(11);
	DECLARE DescContaDepre 	VARCHAR(200);
	DECLARE Var_PolizaID	BIGINT(20);
	DECLARE Var_CliTresRey	INT(11);
	DECLARE CliProcEspecifico	INT(11);
	DECLARE Llave_CtaContaCierrePeriodo	VARCHAR(50);	-- Llave Cuenta Contable de Cierre de Periodo
	DECLARE CtaContable_Vacia		VARCHAR(25);	-- Cuenta Contable Vacia
	DECLARE Horactual       VARCHAR(100);  -- Hora actual en la que se ejecuta


	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Entero_Cero    	 	:= 0;
	SET Moneda_Cero     	:= 0.00;
	SET VarDeudora      	:= 'D';
	SET VarAcreedora    	:= 'A';
	SET Cerrado        	 	:= 'C';
	SET	PrimerPeriodo		:= 1;
	SET Salida_NO			:= 'N';
	SET Est_Regitrado		:= 'R';
	SET TipoPoliza			:= 'M';
	SET ConContaDepre		:= 1000;	-- CONCEPTO CONTABLE DEPRECIACION Y AMORTIZACION ACTIVOS
	SET DescContaDepre 		:= 'DEPRECIACION Y AMORTIZACION DE ACTIVOS'; 	-- DESCRIPCION CONCEPTO CONTABLE
	SET Var_FinEjercicio	:= 'N';
	SET Con_SI				:= 'S';
	SET Con_NO				:= 'N';
	SET Var_CliTresRey		:= 26;
	SET Llave_CtaContaCierrePeriodo	:= 'CtaContaCierrePeriodo';
	SET CtaContable_Vacia	:= '0000000000000000000000000';

	SET Var_horinicon       :='HoraCiePerContaIni' ;
	SET Var_horfincon       :='HoraCiePerContaFin' ;


	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PERIODOCONTACIEPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		CALL TRANSACCIONESPRO(Aud_NumTransaccion);

		SET Aud_FechaActual 	:= NOW();

		SET UltimoPeriodo := (SELECT MAX(PeriodoID) FROM PERIODOCONTABLE WHERE EjercicioID = Par_EjercicioID);

        SET Var_Horainicial :=(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Var_horinicon);

        SET Var_Horafinal   :=(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Var_horfincon);

        SET Horactual       :=(SELECT TIME(Aud_FechaActual) );

		IF(IFNULL( Aud_Usuario, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Usuario no Esta Logeado';
			SET Var_Control := 'inversionID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FechaSistema,	EjecDepreAmortiAut
		INTO Var_FechaSistema,	Var_EjecDepreAmortiAut
		FROM PARAMETROSSIS;

		SELECT Fin, Inicio, Estatus INTO Var_FechaFinPer, Var_FechaIniPer, Var_PerEstatus
		FROM PERIODOCONTABLE
		WHERE EjercicioID = Par_EjercicioID
		  AND PeriodoID = Par_PeriodoID;

		SET Var_FechaFinPer := IFNULL(Var_FechaFinPer, Fecha_Vacia);

		IF (Var_FechaFinPer = Fecha_Vacia) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Periodo a Cerrar no Existe';
			SET Var_Control := 'numeroPeriodo';
			LEAVE ManejoErrores;
		END IF;

		IF (Var_PerEstatus = Cerrado) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'El Periodo ya se Encuentra Cerrado';
			SET Var_Control := 'numeroPeriodo';
			LEAVE ManejoErrores;
		END IF;
		  IF(Horactual  >= Var_Horainicial  &&  Horactual <= Var_Horafinal) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:='No se puede realizar el Cierre de Periodo Contable, se encuentra en un horario no permitido. Intente más tarde';
			SET Var_Control := 'horario';
			LEAVE ManejoErrores;
		END IF;

		SET Var_EjecDepreAmortiAut := IFNULL(Var_EjecDepreAmortiAut, Con_NO);
		IF( Var_EjecDepreAmortiAut = Con_SI ) THEN
			-- INICIO APLICACION PROCESO DE DEPRECIACION Y AMORTIZACION DE ACTIVOS

			-- ANTES DE REALIZAR EL CIERRE DEL PERIODO CONTABLE SE APLICARA EL PROCESO DE DEPRECIACION
			-- A LOS MESES MENORES O IGUAL A LA FECHA DE FIN DEL PERIODO A CERRAR

			-- OBTIENE EL ANIO Y MES MENOR QUE NO SE HA DEPRECIADO
			SET Var_AnioDepreAmorti := (SELECT MIN(Anio)
										FROM BITACORADEPREAMORTI
										WHERE Estatus = Est_Regitrado);
			SET Var_MesDepreAmorti := (SELECT MIN(Mes)
										FROM BITACORADEPREAMORTI
										WHERE Anio = Var_AnioDepreAmorti
											AND Estatus = Est_Regitrado);

			-- VALIDA QUE EL ANIO EXISTA
			IF(IFNULL(Var_AnioDepreAmorti,Entero_Cero) > Entero_Cero)THEN
				-- VALIDA QUE EL MES EXISTA
				IF(IFNULL(Var_MesDepreAmorti,Entero_Cero) > Entero_Cero)THEN

					SET Var_FechaDepreAmorti := CONVERT(CONCAT(CONVERT(Var_AnioDepreAmorti, CHAR), '-',CONVERT(Var_MesDepreAmorti, CHAR),'-', '01'), DATE);
					SET Var_FechaDepreAmorti := IFNULL(Var_FechaDepreAmorti,Fecha_Vacia);

					-- DEPRECIA LOS MESES MENORES O IGUAL AL DEL MES DE CIERRE DE PERIODO CONTABLE
					WHILE Var_FechaDepreAmorti <= Var_FechaFinPer AND Var_FechaDepreAmorti <> Fecha_Vacia DO

						CALL MAESTROPOLIZASALT(
							Var_PolizaID,			Par_EmpresaID,			Var_FechaSistema,		TipoPoliza,				ConContaDepre,
							CONCAT(DescContaDepre,' ',Var_MesDepreAmorti,' ',Var_AnioDepreAmorti),
							Salida_NO, 				Par_NumErr, 			Par_ErrMen, 			Aud_Usuario, 			Aud_FechaActual,
							Aud_DireccionIP,    	Aud_ProgramaID, 		Aud_Sucursal,       	Aud_NumTransaccion);

						IF(Par_NumErr <> Entero_Cero)THEN
							LEAVE TerminaStore;
						END IF;

						CALL APLICADEPAMORTIZAACTIVOSPRO(
							Var_AnioDepreAmorti,	Var_MesDepreAmorti,		Aud_Usuario,			Aud_Sucursal,				Var_PolizaID,

							Salida_NO, 				Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID,      		Aud_Usuario,
							Aud_FechaActual,    	Aud_DireccionIP,    	Aud_ProgramaID, 		Aud_Sucursal,       		Aud_NumTransaccion);

						IF(Par_NumErr <> Entero_Cero)THEN
							LEAVE TerminaStore;
						END IF;

						-- OBTIENE EL ANIO Y MES MENOR QUE NO SE HA DEPRECIADO
						SET Var_AnioDepreAmorti := (SELECT MIN(Anio) FROM BITACORADEPREAMORTI WHERE Estatus = Est_Regitrado);
						SET Var_MesDepreAmorti  := (SELECT MIN(Mes) FROM BITACORADEPREAMORTI WHERE Anio = Var_AnioDepreAmorti AND Estatus = Est_Regitrado);
						SET Var_AnioDepreAmorti := IFNULL(Var_AnioDepreAmorti,1900);
						SET Var_MesDepreAmorti  := IFNULL(Var_MesDepreAmorti,01);

						SET Var_FechaDepreAmorti := CONVERT(CONCAT(CONVERT(Var_AnioDepreAmorti, CHAR), '-',CONVERT(Var_MesDepreAmorti, CHAR),'-', '01'), DATE);
						SET Var_FechaDepreAmorti := IFNULL(Var_FechaDepreAmorti,Fecha_Vacia);

					END WHILE;
				END IF;
			END IF;
			-- FIN APLICACION PROCESO DE DEPRECIACION Y AMORTIZACION DE ACTIVOS
		END IF;

		DELETE FROM TMPCUENTACONTABLE
		WHERE NumTransaccion = Aud_NumTransaccion;

		DELETE FROM TMPCONTABLE
			WHERE NumeroTransaccion = Aud_NumTransaccion;

		DELETE FROM SALDOSCONTABLES
		WHERE EjercicioID = Par_EjercicioID
		  AND PeriodoID = Par_PeriodoID;

		SELECT  MAX(FechaCorte) INTO Var_UltFecPer
		FROM SALDOSCONTABLES;

		SET Var_UltFecPer := IFNULL(Var_UltFecPer, Fecha_Vacia);
		INSERT INTO TMPCUENTACONTABLE
		SELECT	Aud_NumTransaccion, Cue.CuentaCompleta, Cen.CentroCostoID,	Cadena_Vacia,	Cadena_Vacia,
				Cue.Naturaleza,		Cadena_Vacia,		Entero_Cero
		FROM CUENTASCONTABLES Cue,
			 CENTROCOSTOS Cen;

		INSERT INTO TMPCONTABLE
		SELECT	Aud_NumTransaccion,		Var_FechaFinPer,		MAX(Sal.CuentaCompleta),	MAX(Sal.CentroCosto),	SUM(Pol.Cargos),
				SUM(Pol.Abonos),		MAX(Sal.Naturaleza),	Entero_Cero, 				Entero_Cero, 			Entero_Cero,
				Entero_Cero
		FROM 	DETALLEPOLIZA Pol,
				TMPCUENTACONTABLE Sal
		WHERE Pol.CuentaCompleta =	Sal.CuentaCompleta
		  AND Pol.CentroCostoID = Sal.CentroCosto
		  AND Sal.NumTransaccion = Aud_NumTransaccion
		  AND Pol.Fecha >= 	Var_FechaIniPer
		  AND Pol.Fecha <= 	Var_FechaFinPer
		GROUP BY Pol.CuentaCompleta, Pol.CentroCostoID;

		INSERT INTO SALDOSCONTABLES
		SELECT 	Par_EjercicioID,		Par_PeriodoID,		Cue.CuentaCompleta, 	Cue.CentroCosto,		Var_FechaFinPer,
				IFNULL(Sal.SaldoFinal, Entero_Cero),		IFNULL(Tmp.Cargos, Entero_Cero),				IFNULL(Tmp.Abonos, Entero_Cero),
				CASE WHEN 	Tmp.Naturaleza = VarDeudora
					THEN		IFNULL((IFNULL(Tmp.Cargos, Entero_Cero)+IFNULL(Sal.SaldoFinal, Entero_Cero))- IFNULL(Tmp.Abonos, Entero_Cero), Entero_Cero)
					ELSE		IFNULL((IFNULL(Tmp.Abonos, Entero_Cero)+IFNULL(Sal.SaldoFinal, Entero_Cero))- IFNULL(Tmp.Cargos, Entero_Cero), Entero_Cero) END,
				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion
		FROM TMPCUENTACONTABLE Cue
		LEFT OUTER JOIN TMPCONTABLE AS Tmp ON ( Cue.CuentaCompleta = Tmp.CuentaContable
										  AND Cue.CentroCosto = Tmp.CentroCosto
										  AND NumeroTransaccion = Aud_NumTransaccion )
		LEFT OUTER JOIN SALDOSCONTABLES AS Sal ON (Sal.FechaCorte = Var_UltFecPer
											  AND Cue.CuentaCompleta = Sal.CuentaCompleta
											  AND Cue.CentroCosto = Sal.CentroCosto)
		WHERE Cue.NumTransaccion = Aud_NumTransaccion;

		DELETE FROM SALDOSCONTABLES
		WHERE FechaCorte = Var_FechaFinPer
		  AND SaldoInicial = Entero_Cero
		  AND Cargos = Entero_Cero
		  AND Abonos = Entero_Cero;

		IF( Par_PeriodoID = UltimoPeriodo ) THEN

			SET CtaContaCierrePeriodo := IFNULL(FNPARAMGENERALES(Llave_CtaContaCierrePeriodo),CtaContable_Vacia);
			IF( CtaContaCierrePeriodo = CtaContable_Vacia OR CtaContaCierrePeriodo = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 3;
				SET Par_ErrMen	:= 'La cuenta contable asignada al cierre de ejercicio no esta configurada.';
				SET Var_Control := 'cuentaContable';
				LEAVE ManejoErrores;
			END IF;

			SET Par_CuentaContable := CtaContaCierrePeriodo;

			IF NOT EXISTS(SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CuentaContable ) THEN
				SET Par_NumErr	:= 4;
				SET Par_ErrMen	:= 'La cuenta Contable del Cierre de Ejercicio no Existe';
				SET Var_Control := 'cuentaContable';
				LEAVE ManejoErrores;
			END IF;

			CALL CONTACIERREEJERCICIO(
				Var_FechaFinPer,	Par_EjercicioID,	Par_PeriodoID,		   	Par_CuentaContable,		Salida_NO,
				Par_NumErr,			Par_ErrMen,			Par_Poliza,				Par_SaldoEjercicio,		Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

			SET Var_FinEjercicio := Con_SI;

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			DELETE FROM TMPCONTABLE
			WHERE NumeroTransaccion = Aud_NumTransaccion;

			DELETE FROM SALDOSCONTABLES
			WHERE FechaCorte 	= Var_FechaFinPer
			AND NumTransaccion	= Aud_NumTransaccion;

			INSERT INTO TMPCONTABLE
			SELECT	Aud_NumTransaccion,		Var_FechaFinPer,		MAX(Sal.CuentaCompleta),	MAX(Sal.CentroCosto),	SUM(Pol.Cargos),
					SUM(Pol.Abonos),		MAX(Sal.Naturaleza),	Entero_Cero, 				Entero_Cero, 			Entero_Cero,
					Entero_Cero
			FROM 	DETALLEPOLIZA Pol,
					TMPCUENTACONTABLE Sal
			WHERE Pol.CuentaCompleta =	Sal.CuentaCompleta
			  AND Pol.CentroCostoID = Sal.CentroCosto
			  AND Sal.NumTransaccion = Aud_NumTransaccion
			  AND Pol.Fecha >= 	Var_FechaIniPer
			  AND Pol.Fecha <= 	Var_FechaFinPer
			GROUP BY Pol.CuentaCompleta, Pol.CentroCostoID;

			INSERT INTO SALDOSCONTABLES
			SELECT 	Par_EjercicioID,	Par_PeriodoID,			Cue.CuentaCompleta, 		Cue.CentroCosto,	Var_FechaFinPer,
					IFNULL(Sal.SaldoFinal, Entero_Cero),		IFNULL(Tmp.Cargos, Entero_Cero),				IFNULL(Tmp.Abonos, Entero_Cero),
					CASE WHEN 	Tmp.Naturaleza = VarDeudora
						THEN		IFNULL((IFNULL(Tmp.Cargos, Entero_Cero)+IFNULL(Sal.SaldoFinal, Entero_Cero))- IFNULL(Tmp.Abonos, Entero_Cero), Entero_Cero)
						ELSE		IFNULL((IFNULL(Tmp.Abonos, Entero_Cero)+IFNULL(Sal.SaldoFinal, Entero_Cero))- IFNULL(Tmp.Cargos, Entero_Cero), Entero_Cero) END,
					Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion
			FROM TMPCUENTACONTABLE Cue
			LEFT OUTER JOIN TMPCONTABLE AS Tmp ON ( Cue.CuentaCompleta = Tmp.CuentaContable
												AND Cue.CentroCosto = Tmp.CentroCosto
												AND NumeroTransaccion = Aud_NumTransaccion )
			LEFT OUTER JOIN SALDOSCONTABLES AS Sal ON (Sal.FechaCorte = Var_UltFecPer
												 AND Cue.CuentaCompleta = Sal.CuentaCompleta
												AND Cue.CentroCosto = Sal.CentroCosto)
			WHERE Cue.NumTransaccion = Aud_NumTransaccion;

			DELETE FROM SALDOSCONTABLES
			WHERE FechaCorte = Var_FechaFinPer
			  AND SaldoInicial = Entero_Cero
			  AND Cargos = Entero_Cero
			  AND Abonos = Entero_Cero;

		END IF;

		DELETE FROM TMPCONTABLE
		WHERE NumeroTransaccion = Aud_NumTransaccion;


		DELETE FROM TMPCUENTACONTABLE
		WHERE NumTransaccion = Aud_NumTransaccion;

		IF (Par_PeriodoID = UltimoPeriodo) THEN

			UPDATE EJERCICIOCONTABLE SET
				FechaCierre 		= Aud_FechaActual,
				UsuarioCierre 		= Aud_Usuario,
				Estatus 			= Cerrado
			WHERE EjercicioID = Par_EjercicioID;

			UPDATE PERIODOCONTABLE Per, PARAMETROSSIS Param SET
				Per.FechaCierre 		= Aud_FechaActual,
				Per.UsuarioCierre 		= Aud_Usuario,
				Per.Estatus 			= Cerrado,
				Param.PeriodoVigente	= PrimerPeriodo,
				Param.EjercicioVigente	= Par_EjercicioID+1
			WHERE Per.PeriodoID = Par_PeriodoID
			  AND Per.EjercicioID = Par_EjercicioID;

		ELSE

			UPDATE PERIODOCONTABLE Per, PARAMETROSSIS Param SET
				Per.FechaCierre 		= Aud_FechaActual,
				Per.UsuarioCierre 		= Aud_Usuario,
				Per.Estatus 			= Cerrado,
				Param.PeriodoVigente	= Par_PeriodoID+1
			WHERE Per.PeriodoID = Par_PeriodoID
			  AND Per.EjercicioID = Par_EjercicioID;
		END IF;

		-- Actualiza la pololiza En PERIODOCONTABLE
		SET Var_PolActual := (SELECT MAX(PolizaID) FROM POLIZACONTABLE);

		UPDATE PERIODOCONTABLE SET
			PolizaFinal = Var_PolActual
		WHERE PeriodoID = Par_PeriodoID
		  AND Estatus = Cerrado
		  AND EjercicioID = Par_EjercicioID;

		CALL HISSALDOSDETPOLIZAALT(
			Par_EjercicioID,	Par_PeriodoID,		Salida_NO,			Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL `HIS-DETALLEPOLALT`(
			Par_EjercicioID,	Par_PeriodoID,		Salida_NO,			Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL `HIS-POLIZACONTAALT`(
			Par_EjercicioID,	Par_PeriodoID,		Salida_NO,			Par_NumErr,			Par_ErrMen,
			Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_Anio	:= YEAR(Var_FechaFinPer);
		SET Var_Mes		:= MONTH(Var_FechaFinPer);
		CALL `ESTADISTICOINDICAPRO`(
			Var_Anio,			Var_Mes,			Var_FinEjercicio,		Salida_NO,			Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,    		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Periodo Contable ', CONVERT(Par_PeriodoID, CHAR), ' Cerrado Exitosamente.');

	END ManejoErrores;

	SELECT	Par_NumErr 		AS NumErr,
			Par_ErrMen 		AS ErrMen,
			'numeroPeriodo'	AS Control,
			Par_PeriodoID	AS Consecutivo;

END TerminaStore$$
