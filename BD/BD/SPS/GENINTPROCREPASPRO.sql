-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENINTPROCREPASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENINTPROCREPASPRO`;

DELIMITER $$
CREATE PROCEDURE `GENINTPROCREPASPRO`(
	-- SP para la generacion de Interes Provisionado en el cierre de dia
	Par_Fecha			DATE,			-- Fecha del Cierre del dia

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_CreditoFondeoID	INT(11);		-- Variables para el CURSOR
	DECLARE Var_AmortizacionID	INT(11);
	DECLARE Var_FechaInicio		DATE;
	DECLARE Var_FechaVencim		DATE;
	DECLARE Var_FechaExigible	DATE;
	DECLARE Var_CreCapVig       DECIMAL(14,2);
	DECLARE Var_FormulaID       INT(11);
	DECLARE Var_TasaFija        DECIMAL(12,4);
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_TipoFondeador   CHAR(1);
	DECLARE Var_InteresMN 		DECIMAL(14,4);

	DECLARE Var_CreditoStr		VARCHAR(30);

	DECLARE Var_ValorTasa		DECIMAL(12,4);
	DECLARE Var_DiasCredito		DECIMAL(10,2);
	DECLARE Var_Interes			DECIMAL(12,4);
	DECLARE Var_FecApl			DATE;
	DECLARE Var_EsHabil			CHAR(1);
	DECLARE SalCapital			DECIMAL(14,2);
	DECLARE DiasInteres			DECIMAL(10,2);
	DECLARE Var_CapAju			DECIMAL(14,2);
	DECLARE Error_Key			INT(11);
	DECLARE Var_Poliza			BIGINT;
	DECLARE Par_NumErr			INT(11);
	DECLARE Par_ErrMen			VARCHAR(400);
	DECLARE Sig_DiaHab			DATE;
	DECLARE Par_Consecutivo		BIGINT;
	DECLARE Es_DiaHabil			CHAR(1);
	DECLARE Var_ContadorCre		INT(11);
	DECLARE Var_SigFecha		DATE;
	DECLARE Var_InstitutFondID	INT(11);		/* Institucion de Fondeo */
	DECLARE Var_PlazoContable	CHAR(1);		/* plazo contable C.- Corto plazo L.- Largo Plazo*/
	DECLARE Var_TipoInstitID	INT(11);		/* Corresponde con el campo TipoInstitID deL Credito Pasivo */
	DECLARE Var_NacionalidadIns	CHAR(1);		/* Especifica la nacionalidad de la institucion */
	DECLARE Var_CobraISR        CHAR(1);
	DECLARE Con_Egreso          INT(11);
	DECLARE Var_Refinancia		CHAR(1);		# Indica si el credito refinancia el interes
	DECLARE Var_FechaFinMes		DATE;			# Indica el fin de mes de acuerdo a la fecha de inicio de la amortizacion
	DECLARE Var_FechaInicioMes	DATE;			# Indica la fecha de inicio de mes de acuerdo a la fecha de fin de mes
	DECLARE Var_SalIntPro		DECIMAL(14,4);	# Interes provisionado
	DECLARE Var_InteresRef		DECIMAL(14,2);
	DECLARE Var_TipoCamDof		DECIMAL(14,6);	-- Se ocupa para guardar el valor del tipo cambio en DOF
	DECLARE Var_FechaSis		DATE;


	/* Declaracion de Constantes */
	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_Pagada			CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE Dec_Cien			DECIMAL(14,2);
	DECLARE Pro_GenIntere		INT(11);
	DECLARE Mov_IntPro			INT(11);			-- Tipo de Movimiento de Credito Pasivo: Interes Provisionado, Ordinario - TIPOSMOVSFONDEO
	DECLARE Con_IntDeven		INT(11);			-- Concepto Contable: Interes Devengado .- CONCEPTOSFONDEO
	DECLARE Con_EgrIntExc   	INT(11);			-- Concepto Contable: Resultados. Egresos por  Interes .- CONCEPTOSFONDEO
	DECLARE Con_EgrIntGra   	INT(11);
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE Con_GenIntere		INT(11);
	DECLARE Var_SalidaNO		CHAR(1);
	DECLARE AltaPoliza_NO		CHAR(1);
	DECLARE AltaPolCre_SI		CHAR(1);
	DECLARE AltaMovCre_SI		CHAR(1);
	DECLARE AltaMovCre_NO		CHAR(1);
	DECLARE AltaMovTes_NO		CHAR(1);
	DECLARE NO_CobraISR     	CHAR(1);
	DECLARE SI_CobraISR     	CHAR(1);
	DECLARE Ref_GenInt			VARCHAR(50);
	DECLARE Enc_PolGenInt  		VARCHAR(50);
	DECLARE Des_CieDia			VARCHAR(100);
	DECLARE Cons_SI				CHAR(1);
	DECLARE Cons_MonedaNID		INT(11);			-- Identificador de moneda nacional
	DECLARE Var_CreditoMigrado	BIGINT(20);

	DECLARE CURSORINTER CURSOR FOR
	SELECT  Cre.CreditoFondeoID,    AmortizacionID,         Amo.FechaInicio,    Amo.FechaVencimiento,
			Amo.FechaExigible,      Cre.SaldoCapVigente,    Cre.CalcInteresID,  Cre.TasaFija,
			Cre.MonedaID,           Cre.InstitutFondID,     Cre.PlazoContable,  Cre.TipoInstitID,
			Cre.NacionalidadIns,    Cre.CobraISR,           Cre.TipoFondeador,	Cre.Refinancia,
			Amo.SaldoInteresPro,	Cre.InteresRefinanciar
	FROM AMORTIZAFONDEO Amo
	INNER JOIN CREDITOFONDEO Cre ON Amo.CreditoFondeoID	= Cre.CreditoFondeoID
	WHERE Amo.FechaInicio <= Par_Fecha
	  AND Amo.FechaVencimiento > Par_Fecha
	  AND Amo.FechaExigible	> Par_Fecha
	  AND Amo.Estatus = Est_Vigente
	  AND Cre.Estatus = Est_Vigente;

	/* Asignacion de Constantes */
	SET Est_Vigente		:= 'N';				-- Estatus Amortizacion: Vigente
	SET Est_Pagada		:= 'P';				-- Estatus Amortizacion: Pagada
	SET Cadena_Vacia	:= '';				-- Cadena Vacia
	SET Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero		:= 0;				-- Entero en Cero
	SET Decimal_Cero	:= 0.00;			-- Decimal Cero
	SET Nat_Cargo		:= 'C';				-- Naturaleza de Cargo
	SET Nat_Abono		:= 'A';				-- Naturaleza de Abono
	SET Dec_Cien		:= 100.00;			-- Decimal Cien
	SET Pro_GenIntere	:= 301;				-- Numero de Proceso Batch: Generacion de Interes
	SET Mov_IntPro		:= 10;				-- Tipo de Movimiento de Credito Pasivo: Interes Provisionado, Ordinario - TIPOSMOVSFONDEO
	SET Con_IntDeven	:= 8;				-- Concepto Contable: Interes Devengado .- CONCEPTOSFONDEO
	SET Con_EgrIntExc	:= 3;				-- Concepto Contable: Resultados. Egresos por Interes Excento
	SET Con_EgrIntGra	:= 4;				-- Concepto Contable: Resultados. Egresos por Interes Gravado
	SET Pol_Automatica  := 'A';				-- Tipo de Poliza: Automatica
	SET Con_GenIntere	:= 20;				-- Concepto Contable: Generacion de Interes Cartera Pasiva	tabla. CONCEPTOSCONTA
	SET Var_SalidaNO	:= 'N';				-- El store no Arroja una Salida
	SET AltaPoliza_NO	:= 'N';				-- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI	:= 'S';				-- Alta de la Poliza de Credito: SI
	SET AltaMovCre_NO	:= 'N';				-- Alta del Movimiento de Credito: NO
	SET AltaMovCre_SI	:= 'S';				-- Alta del Movimiento de Credito: SI
	SET AltaMovTes_NO	:= 'N';				-- Alta del Movimiento de Ahorro: NO
	SET NO_CobraISR     := 'N';         -- No Cobra ISR
	SET SI_CobraISR     := 'S';         -- Si Cobra ISR
	SET Cons_SI			:= 'S';			-- Constante SI
	SET Cons_MonedaNID	:= 1;			-- Constante Identificación de moneda nacional

	SET Des_CieDia      := 'CIERRE DIARIO CARTERA PASIVA';
	SET Ref_GenInt      := 'GENERACION INTERES';
	SET Enc_PolGenInt   := 'GEN.INTERES CARTERA PASIVA';
	SET Aud_ProgramaID  := 'GENINTPROCREPASPRO';

	SELECT DiasCredito INTO Var_DiasCredito
	FROM PARAMETROSSIS;

	SET Var_SigFecha := DATE_ADD(FUNCIONDIAHABIL(Par_Fecha, 1, Par_EmpresaID), INTERVAL -1 DAY);

	CALL DIASFESTIVOSCAL(
		Par_Fecha,			Entero_Cero,		Var_FecApl,			Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	SET Sig_DiaHab := DATE_ADD(Par_Fecha,INTERVAL 1 DAY);

	SELECT	COUNT(Cre.CreditoFondeoID) INTO Var_ContadorCre
	FROM	AMORTIZAFONDEO Amo
	INNER JOIN CREDITOFONDEO Cre ON Amo.CreditoFondeoID	= Cre.CreditoFondeoID
	WHERE Amo.FechaInicio <= Par_Fecha
	  AND Amo.FechaVencimiento > Par_Fecha
	  AND Amo.FechaExigible	> Par_Fecha
	  AND Amo.Estatus = Est_Vigente
	  AND Cre.Estatus = Est_Vigente;

	SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);

	IF (Var_ContadorCre > Entero_Cero) THEN

		/* Si hay creditos que entren en las condiciones*/
		CALL MAESTROPOLIZAALT(
			/*se da de alta el encabezado de la poliza */
			Var_Poliza,		Par_EmpresaID,	Var_FecApl,			Pol_Automatica,		Con_GenIntere,
			Enc_PolGenInt,	Var_SalidaNO,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
	END IF;

	OPEN CURSORINTER;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
				FETCH CURSORINTER INTO
					Var_CreditoFondeoID,	Var_AmortizacionID,		Var_FechaInicio,	Var_FechaVencim,
					Var_FechaExigible,		Var_CreCapVig,			Var_FormulaID,		Var_TasaFija,
					Var_MonedaID,			Var_InstitutFondID,		Var_PlazoContable,	Var_TipoInstitID,
					Var_NacionalidadIns,	Var_CobraISR,			Var_TipoFondeador,	Var_Refinancia,
					Var_SalIntPro,			Var_InteresRef;

				START TRANSACTION;
				BEGIN

					-- Inicalizacion
					SET Error_Key		:= Entero_Cero;
					SET DiasInteres		:= Entero_Cero;
					SET SalCapital		:= Entero_Cero;
					SET Var_CapAju		:= Entero_Cero;
					SET Var_Interes		:= Entero_Cero;
					SET Var_ValorTasa	:= Entero_Cero;
					SET Var_CobraISR	:= IFNULL(Var_CobraISR, NO_CobraISR);
					SET Con_Egreso		:= Entero_Cero;


					IF (Var_FechaVencim > Var_FechaExigible AND (DATEDIFF(Var_FechaExigible, Sig_DiaHab) = 0)) THEN
						SET	DiasInteres	:= DATEDIFF(Var_FechaVencim, Par_Fecha);
					ELSE
						IF(Sig_DiaHab > Var_FechaVencim) THEN
							SET DiasInteres := DATEDIFF(Var_FechaVencim, Par_Fecha);
						ELSEIF(Var_FechaInicio > Par_Fecha) THEN
							SET DiasInteres := DATEDIFF(Sig_DiaHab, Var_FechaInicio);
						ELSE
							SET DiasInteres := DATEDIFF(Sig_DiaHab, Par_Fecha);
						END IF;
					END IF;

					# Se verifica si la fecha es Inicio de Mes para aumentar al monto base(Saldo de Capital) el interes acumulado)
					SET Var_FechaFinMes := (SELECT LAST_DAY(Par_Fecha));
					SET Var_FechaFinMes := IFNULL(Var_FechaFinMes, Fecha_Vacia);

					SET SalCapital := IFNULL(Var_CreCapVig,0);

					SET Var_CapAju	:= (SELECT IFNULL(SUM(SaldoCapVigente), 0.00)
										FROM AMORTIZAFONDEO
										WHERE CreditoFondeoID	= Var_CreditoFondeoID
										  AND AmortizacionID	< Var_AmortizacionID
										  AND Estatus	 		!= Est_Pagada
										GROUP BY CreditoFondeoID );

					SET Var_CapAju := IFNULL(Var_CapAju, Entero_Cero);

					SET SalCapital := SalCapital - Var_CapAju;

					/* se calcula el valor de la tasa */
					CALL CREPASCALCTASAPRO(
						Var_CreditoFondeoID,Var_FormulaID,		Var_TasaFija,		Par_EmpresaID,		Var_ValorTasa,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					SET Var_ValorTasa := IFNULL(Var_ValorTasa, Entero_Cero);

					IF(Var_Refinancia = Cons_SI) THEN
						# Si es inicio de una amortizacion, el interes acumulado de inicializa en cero.
						IF(Var_FechaInicio >= Par_Fecha AND Var_FechaInicio < Sig_DiaHab) THEN
							# Se inicializa en cero el valor del interes Acumulado e Interes Refinanciar
							UPDATE CREDITOFONDEO SET
								InteresAcumulado = Decimal_Cero,
								InteresRefinanciar = Decimal_Cero
							WHERE CreditoFondeoID = Var_CreditoFondeoID;

							SET Var_InteresRef := Decimal_Cero;

						END IF;

						# Como el credito refinancia al saldo de capital se le suma el interes acumulado de meses anteriores
						SET SalCapital := SalCapital + Var_InteresRef;
					END IF;

					SET Var_CreditoMigrado := (SELECT CreditoFondeoIDSAFI FROM PASIVOCAMBIOBASE WHERE CreditoFondeoIDSAFI = Var_CreditoFondeoID);

					IF ( IFNULL(Var_CreditoMigrado, Entero_Cero ) = Entero_Cero ) THEN
						SET Var_DiasCredito := 360;
					ELSE
						SET Var_DiasCredito := 365;
					END IF;

					SET Var_Interes := ROUND(SalCapital * Var_ValorTasa * DiasInteres / (Var_DiasCredito * Dec_Cien), 2);
					SET Var_Interes := IFNULL(Var_Interes, Entero_Cero);

					IF (Var_Interes > Entero_Cero) THEN	 /* Si el interes es mayor que cero se generan registros operativos y contables*/

						IF (Var_CobraISR = No_CobraISR) THEN
							SET Con_Egreso := Con_EgrIntExc;
						ELSE
							SET Con_Egreso := Con_EgrIntGra;
						END IF;

						CALL CONTAFONDEOPRO( /* se generan los movimientos contables para egresos */
							Var_MonedaID,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
							Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
							Var_NacionalidadIns,    Con_Egreso,             Des_CieDia,         Par_Fecha,
							Var_FecApl,             Var_FecApl,             Var_Interes,        Ref_GenInt,
							Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Cargo,
							Cadena_Vacia,           Nat_Cargo,              Cadena_Vacia,       AltaMovTes_NO,
							Cadena_Vacia,           AltaMovCre_SI,          Var_AmortizacionID, Mov_IntPro,
							AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
							Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
							Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
							Aud_Sucursal,           Aud_NumTransaccion  );

						CALL CONTAFONDEOPRO( /* se generan los movimientos contables para Interes Devengado */
							Var_MonedaID,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
							Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
							Var_NacionalidadIns,    Con_IntDeven,           Des_CieDia,         Par_Fecha,
							Var_FecApl,             Var_FecApl,             Var_Interes,        Ref_GenInt,
							Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Abono,
							Cadena_Vacia,           Nat_Abono,              Cadena_Vacia,       AltaMovTes_NO,
							Cadena_Vacia,           AltaMovCre_NO,          Var_AmortizacionID, Mov_IntPro,
							AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
							Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
							Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
							Aud_Sucursal,           Aud_NumTransaccion  );

						IF(Var_MonedaID <> Cons_MonedaNID) THEN
							SELECT 	TipCamDof
							INTO 	Var_TipoCamDof
							FROM MONEDAS
							WHERE MonedaID = Var_MonedaID;

							SET Var_TipoCamDof := IFNULL(Var_TipoCamDof, Entero_Cero);
							SET Var_InteresMN  := ROUND((Var_Interes * Var_TipoCamDof), 2);

							IF(Var_InteresMN > Entero_Cero) THEN
								CALL CONTAFONDEOPRO( /* se generan los movimientos contables para egresos */
									Cons_MonedaNID,			Entero_Cero,            Var_InstitutFondID, Entero_Cero,
									Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
									Var_NacionalidadIns,    Con_Egreso,             Des_CieDia,         Par_Fecha,
									Var_FecApl,             Var_FecApl,             Var_InteresMN,      Ref_GenInt,
									Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Cargo,
									Cadena_Vacia,           Nat_Cargo,              Cadena_Vacia,       AltaMovTes_NO,
									Cadena_Vacia,           AltaMovCre_NO,          Var_AmortizacionID, Mov_IntPro,
									AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
									Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
									Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
									Aud_Sucursal,           Aud_NumTransaccion);

								CALL CONTAFONDEOPRO( /* se generan los movimientos contables para Interes Devengado */
									Cons_MonedaNID,			Entero_Cero,            Var_InstitutFondID, Entero_Cero,
									Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
									Var_NacionalidadIns,    Con_IntDeven,           Des_CieDia,         Par_Fecha,
									Var_FecApl,             Var_FecApl,             Var_InteresMN,      Ref_GenInt,
									Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Abono,
									Cadena_Vacia,           Nat_Abono,              Cadena_Vacia,       AltaMovTes_NO,
									Cadena_Vacia,           AltaMovCre_NO,          Var_AmortizacionID, Mov_IntPro,
									AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
									Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
									Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
									Aud_Sucursal,           Aud_NumTransaccion);
							END IF;
						END IF;


						IF(Var_Refinancia = Cons_SI) THEN
							# Se actualiza el campo Interes Acumulado de la tabla de CREDITOS esto con el fin de mantener el interes que se va acumulando diariamente
							UPDATE CREDITOFONDEO SET
								InteresAcumulado = InteresAcumulado + Var_Interes
							WHERE CreditoFondeoID = Var_CreditoFondeoID;

							IF(Var_FechaFinMes >= Par_Fecha AND Var_FechaFinMes < Sig_DiaHab) THEN
								# Si la fecha es un fin de mes, se actualiza el campo InteresRefinanciar con el valor de InteresAcumulado(lo que se ha ido acumulando hasta el fin de mes
								UPDATE CREDITOFONDEO SET
									InteresRefinanciar = InteresAcumulado
								WHERE CreditoFondeoID = Var_CreditoFondeoID;
							END IF;
						END IF;
				 	END IF;
				END;

				SET Var_CreditoStr := CONCAT(CONVERT(Var_CreditoFondeoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR)) ;

				IF Error_Key = 0 THEN
					COMMIT;
				END IF;

				IF Error_Key = 1 THEN
					ROLLBACK;
					START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenIntere, 		Par_Fecha, 			Var_CreditoStr, 	'ERROR DE SQL GENERAL',		Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
						Aud_NumTransaccion);
					COMMIT;
				END IF;

				IF Error_Key = 2 THEN
					ROLLBACK;
					START TRANSACTION;
				  	CALL EXCEPCIONBATCHALT(
						Pro_GenIntere, 		Par_Fecha, 			Var_CreditoStr, 	'ERROR EN ALTA, LLAVE DUPLICADA',	Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,						Aud_Sucursal,
						Aud_NumTransaccion);
					COMMIT;
				END IF;

				IF Error_Key = 3 THEN
					ROLLBACK;
					START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenIntere, 		Par_Fecha, 			Var_CreditoStr, 	'ERROR AL LLAMAR A STORE PROCEDURE', 	Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,							Aud_Sucursal,
						Aud_NumTransaccion);
					COMMIT;
				END IF;

				IF Error_Key = 4 THEN
					ROLLBACK;
					START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenIntere, 		Par_Fecha, 			Var_CreditoStr, 	'ERROR VALORES NULOS', 		Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	 Aud_ProgramaID,			Aud_Sucursal,
						Aud_NumTransaccion);
					COMMIT;
				END IF;

			END LOOP;
		END;
	CLOSE CURSORINTER;

END TerminaStore$$