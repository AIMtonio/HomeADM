-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENINTERESFONDEOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENINTERESFONDEOPRO`;

DELIMITER $$
CREATE PROCEDURE `GENINTERESFONDEOPRO`(
	/* SP para la generacion de Interes Provisionado a la Fecha del Sistema */
	Par_CreditoID		BIGINT(12),		-- ID DEL CREDITO PASIVO

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
	DECLARE Var_CreditoFondeoID	BIGINT(12);
	DECLARE Var_AmortizacionID	INT;
	DECLARE Var_FechaInicio		DATE;
	DECLARE Var_FechaInicioCred	DATE;
	DECLARE Var_FechaVencim		DATE;
	DECLARE Var_FechaExigible	DATE;
	DECLARE Var_CreCapVig       DECIMAL(14,2);
	DECLARE Var_FormulaID       INT(11);
	DECLARE Var_TasaFija        DECIMAL(12,4);
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_TipoFondeador   CHAR(1);
	DECLARE Var_CreditoStr		VARCHAR(30);
	DECLARE Var_ValorTasa		DECIMAL(12,4);
	DECLARE Var_DiasCredito		DECIMAL(10,2);
	DECLARE Var_Interes			DECIMAL(12,4);
	DECLARE Var_FecApl			DATE;
	DECLARE Var_EsHabil			CHAR(1);
	DECLARE Var_CapAju			DECIMAL(14,2);
	DECLARE Var_ContadorCre		INT;
	DECLARE Var_SigFecha		DATE;
	DECLARE Var_InstitutFondID	INT(11);
	DECLARE Var_PlazoContable	CHAR(1);
	DECLARE Var_TipoInstitID	INT(11);
	DECLARE Var_NacionalidadIns	CHAR(1);
	DECLARE Var_CobraISR        CHAR(1);
	DECLARE Var_Poliza			BIGINT;
	DECLARE Var_FechaSistema	DATE;
	DECLARE SalCapital			DECIMAL(14,2);
	DECLARE DiasInteres			DECIMAL(10,2);
	DECLARE Error_Key			INT;
	DECLARE Par_NumErr			INT(11);
	DECLARE Par_ErrMen			VARCHAR(100);
	DECLARE Par_Consecutivo		BIGINT;
	DECLARE Con_Egreso			INT;

	/* Declaracion de Constantes */
	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_Pagada			CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE Dec_Cien			DECIMAL(14,2);
	DECLARE Pro_GenIntere		INT;
	DECLARE Mov_IntPro			INT;
	DECLARE Con_IntDeven		INT;
	DECLARE Con_EgrIntExc   	INT;
	DECLARE Con_EgrIntGra   	INT;
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE Con_GenIntere		INT;
	DECLARE Var_SalidaNO		CHAR(1);
	DECLARE AltaPoliza_NO		CHAR(1);
	DECLARE AltaPolCre_SI		CHAR(1);
	DECLARE AltaMovCre_SI		CHAR(1);
	DECLARE AltaMovCre_NO		CHAR(1);
	DECLARE AltaMovTes_NO		CHAR(1);
	DECLARE NO_CobraISR     	CHAR(1);
	DECLARE SI_CobraISR     	CHAR(1);
	DECLARE Ref_GenInt			VARCHAR(50);
	DECLARE Enc_PolGenInt   	VARCHAR(50);
	DECLARE Des_CieDia			VARCHAR(100);
	DECLARE Decimal_Cero		DECIMAL(12,2);

	DECLARE CURSORINTER CURSOR FOR
	SELECT  Cre.CreditoFondeoID,    AmortizacionID,         Amo.FechaInicio,    Amo.FechaVencimiento,
			Amo.FechaExigible,      Cre.SaldoCapVigente,    Cre.CalcInteresID,  Cre.TasaFija,
			Cre.MonedaID,           Cre.InstitutFondID,     Cre.PlazoContable,  Cre.TipoInstitID,
			Cre.NacionalidadIns,    Cre.CobraISR,           Cre.TipoFondeador
	FROM AMORTIZAFONDEO Amo
	INNER JOIN CREDITOFONDEO Cre ON Amo.CreditoFondeoID	= Cre.CreditoFondeoID
	WHERE Amo.FechaInicio <= Var_FechaSistema
	  AND Amo.Estatus = Est_Vigente
	  AND Cre.Estatus = Est_Vigente
	  AND Cre.CreditoFondeoID = Par_CreditoID;

	/* Asignacion de Constantes */
	SET Est_Vigente		:= 'N';										-- Estatus Amortizacion: Vigente
	SET Est_Pagada		:= 'P';										-- Estatus Amortizacion: Pagada
	SET Cadena_Vacia	:= '';										-- Cadena Vacia
	SET Fecha_Vacia		:= '1900-01-01';							-- Fecha Vacia
	SET Entero_Cero		:= 0;										-- Entero en Cero
	SET Nat_Cargo		:= 'C';										-- Naturaleza de Cargo
	SET Nat_Abono		:= 'A';										-- Naturaleza de Abono
	SET Dec_Cien		:= 100.00;									-- Decimal Cien
	SET Pro_GenIntere	:= 301;										-- Numero de Proceso Batch: Generacion de Interes
	SET Mov_IntPro		:= 10;										-- Tipo de Movimiento de Credito Pasivo: Interes Provisionado, Ordinario - TIPOSMOVSFONDEO
	SET Con_IntDeven	:= 8;										-- Concepto Contable: Interes Devengado .- CONCEPTOSFONDEO
	SET Con_EgrIntExc	:= 3;										-- Concepto Contable: Resultados. Egresos por Interes Excento
	SET Con_EgrIntGra	:= 4;										-- Concepto Contable: Resultados. Egresos por Interes Gravado
	SET Pol_Automatica  := 'A';										-- Tipo de Poliza: Automatica
	SET Con_GenIntere	:= 20;										-- Concepto Contable: Generacion de Interes Cartera Pasiva	tabla. CONCEPTOSCONTA
	SET Var_SalidaNO	:= 'N';										-- El store no Arroja una Salida
	SET AltaPoliza_NO	:= 'N';										-- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI	:= 'S';										-- Alta de la Poliza de Credito: SI
	SET AltaMovCre_NO	:= 'N';										-- Alta del Movimiento de Credito: NO
	SET AltaMovCre_SI	:= 'S';										-- Alta del Movimiento de Credito: SI
	SET AltaMovTes_NO	:= 'N';										-- Alta del Movimiento de Ahorro: NO
	SET NO_CobraISR     := 'N';         							-- No Cobra ISR
	SET SI_CobraISR     := 'S';         							-- Si Cobra ISR
	SET Decimal_Cero	:= 0.00;									-- Decimal Cero
	SET Des_CieDia      := 'CIERRE DIARIO CARTERA PASIVA';			-- Descripcion de Cierre diario de cartera --
	SET Ref_GenInt      := 'GENERACION INTERES';					-- Descripcion Generacion de interes --
	SET Enc_PolGenInt   := 'GEN.INTERES CARTERA PASIVA';			-- Descripcion generacion de interes cartera vencida --
	SET Aud_ProgramaID  := 'GENINTPROCREPASPRO';					-- Nombre de store para auditoria --

	SELECT DiasCredito, FechaSistema INTO Var_DiasCredito, Var_FechaSistema
	FROM PARAMETROSSIS;

	CALL DIASFESTIVOSCAL(
		Var_FechaSistema,	Entero_Cero,		Var_FecApl,			Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	SET Var_FechaInicioCred := (SELECT Cre.FechaInicio
								FROM CREDITOFONDEO Cre
								 WHERE Cre.CreditoFondeoID = Par_CreditoID);

	SET Var_FechaInicioCred := IFNULL(Var_FechaInicioCred, Fecha_Vacia);

	/* SI LA FECHA DE INICIO DEL CRÉDITO ES MENOR A LA DEL SISTEMA
	 * ENTONCES SE GENERAN LOS INTERESES DE LAS AMORTIZACIONES. */
	IF (Var_FechaInicioCred < Var_FechaSistema) THEN
		CALL MAESTROPOLIZAALT(	/*se da de alta el encabezado de la poliza */
			Var_Poliza,     Par_EmpresaID,      Var_FecApl,     Pol_Automatica,     Con_GenIntere,
			Enc_PolGenInt,  Var_SalidaNO,       Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion  );

		OPEN CURSORINTER;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH CURSORINTER INTO
						Var_CreditoFondeoID,    Var_AmortizacionID,     Var_FechaInicio,    Var_FechaVencim,
						Var_FechaExigible,      Var_CreCapVig,          Var_FormulaID,      Var_TasaFija,
						Var_MonedaID,           Var_InstitutFondID,     Var_PlazoContable,  Var_TipoInstitID,
						Var_NacionalidadIns,    Var_CobraISR,           Var_TipoFondeador;

					START TRANSACTION;
					BEGIN
						-- Inicalizacion
						SET Error_Key		:= Entero_Cero;
						SET DiasInteres		:= Entero_Cero;
						SET SalCapital		:= Entero_Cero;
						SET Var_CapAju		:= Entero_Cero;
						SET Var_Interes		:= Entero_Cero;
						SET Var_ValorTasa	:= Entero_Cero;
						SET Var_CobraISR    := IFNULL(Var_CobraISR, NO_CobraISR);
						SET Con_Egreso		:= Entero_Cero;

						-- Dias de Interes --
						IF (Var_FechaVencim <=  Var_FechaSistema)THEN
							SET DiasInteres	:= DATEDIFF(Var_FechaVencim, Var_FechaInicio);
						ELSE
							SET DiasInteres	:= DATEDIFF(Var_FechaSistema, Var_FechaInicio);
						END IF;

						SET SalCapital 	:= IFNULL(Var_CreCapVig,Entero_Cero);
						SET Var_CapAju	:= (SELECT IFNULL(SUM(SaldoCapVigente), Decimal_Cero)
											FROM AMORTIZAFONDEO
											WHERE CreditoFondeoID	= Var_CreditoFondeoID
											  AND AmortizacionID	< Var_AmortizacionID
											  AND Estatus	 		!= Est_Pagada
											GROUP BY CreditoFondeoID );

						SET Var_CapAju 	:= IFNULL(Var_CapAju, Entero_Cero);

						SET SalCapital 	:= SalCapital - Var_CapAju;

						/* Se calcula el valor de la tasa */
						CALL CREPASCALCULATASAPRO(
							Var_CreditoFondeoID,Var_FormulaID,		Var_TasaFija,		Var_FechaInicio, 	Var_ValorTasa,
							Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
							Aud_Sucursal,		Aud_NumTransaccion);

						SET Var_Interes = ROUND(SalCapital * Var_ValorTasa * DiasInteres / (Var_DiasCredito * Dec_Cien), 2);
						IF (Var_Interes > Entero_Cero) THEN	 /* Si el interes es mayor que cero se generan registros operativos y contables*/

							IF (Var_CobraISR = No_CobraISR) THEN
								SET Con_Egreso := Con_EgrIntExc;
							ELSE
								SET Con_Egreso := Con_EgrIntGra;
							END IF;

							CALL CONTAFONDEOPRO( -- se generan los movimientos contables para egresos
								Var_MonedaID,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
								Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
								Var_NacionalidadIns,    Con_Egreso,             Des_CieDia,         Var_FechaSistema,
								Var_FecApl,             Var_FecApl,             Var_Interes,        Ref_GenInt,
								Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Cargo,
								Cadena_Vacia,           Nat_Cargo,              Cadena_Vacia,       AltaMovTes_NO,
								Cadena_Vacia,           AltaMovCre_SI,          Var_AmortizacionID, Mov_IntPro,
								AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
								Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
								Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
								Aud_Sucursal,           Aud_NumTransaccion  );

							CALL CONTAFONDEOPRO( -- se generan los movimientos contables para Interes Devengado
								Var_MonedaID,           Entero_Cero,            Var_InstitutFondID, Entero_Cero,
								Cadena_Vacia,           Var_CreditoFondeoID,    Var_PlazoContable,  Var_TipoInstitID,
								Var_NacionalidadIns,    Con_IntDeven,           Des_CieDia,         Var_FechaSistema,
								Var_FecApl,             Var_FecApl,             Var_Interes,        Ref_GenInt,
								Var_CreditoFondeoID,    AltaPoliza_NO,          Entero_Cero,        Nat_Abono,
								Cadena_Vacia,           Nat_Abono,              Cadena_Vacia,       AltaMovTes_NO,
								Cadena_Vacia,           AltaMovCre_NO,          Var_AmortizacionID, Mov_IntPro,
								AltaPolCre_SI,          Var_TipoFondeador,      Var_SalidaNO,       Var_Poliza,
								Par_Consecutivo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
								Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
								Aud_Sucursal,           Aud_NumTransaccion  );

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
								Pro_GenIntere, 		Var_FechaSistema, 	Var_CreditoStr, 	'ERROR DE SQL GENERAL', 	Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF Error_Key = 2 THEN
						ROLLBACK;
						START TRANSACTION;
					  	CALL EXCEPCIONBATCHALT(
							Pro_GenIntere, 		Var_FechaSistema, 	Var_CreditoStr, 	'ERROR EN ALTA, LLAVE DUPLICADA',	Par_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,						Aud_Sucursal,
							Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF Error_Key = 3 THEN
						ROLLBACK;
						START TRANSACTION;
					  	CALL EXCEPCIONBATCHALT(
							Pro_GenIntere, 		Var_FechaSistema, 	Var_CreditoStr, 	'ERROR AL LLAMAR A STORE PROCEDURE', 	Par_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,							Aud_Sucursal,
							Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF Error_Key = 4 THEN
						ROLLBACK;
						START TRANSACTION;
					  	CALL EXCEPCIONBATCHALT(
							Pro_GenIntere, 		Var_FechaSistema, 	Var_CreditoStr, 	'ERROR VALORES NULOS', 		Par_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	 Aud_ProgramaID,			Aud_Sucursal,
							Aud_NumTransaccion);
						COMMIT;
					END IF;

		 		END LOOP;
			END;
		CLOSE CURSORINTER;
	END IF;

END TerminaStore$$