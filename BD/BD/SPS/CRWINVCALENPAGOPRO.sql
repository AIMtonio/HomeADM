-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWINVCALENPAGOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWINVCALENPAGOPRO`;
DELIMITER $$


CREATE PROCEDURE `CRWINVCALENPAGOPRO`(
    Par_CreditoID   	BIGINT(12),
    Par_Monto       	DECIMAL(14,2),     		-- Monto a prestar.
    Par_Tasa        	DECIMAL(14,2),      	-- Tasa Anualizada
    Par_FechaInicio 	DATE	,              	-- Fecha en que comienzan las cuotas
    Par_PagaISR     	CHAR(1),            	-- Indica si el inversionista paga o no ISR

    Par_Salida			CHAR(1), 				-- Tipo salida S: SI N: NO
    INOUT Par_NumErr 	INT,					-- Numero de error
    INOUT Par_ErrMen  	VARCHAR(350),			-- Mensaje de error

    Aud_EmpresaID       INT,				-- Auditoria
    Aud_Usuario         INT,				-- Auditoria
    Aud_FechaActual     DATETIME,			-- Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Auditoria
    Aud_Sucursal        INT,				-- Auditoria
    Aud_NumTransaccion  BIGINT				-- Auditoria
	)

TerminaStore: BEGIN

	-- Declaración de constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Entero_Cero			INT;
	DECLARE Entero_Cien			INT;
	DECLARE Entero_Uno			INT;
	DECLARE Entero_Negativo		INT;
	DECLARE Fecha_Vacia   		DATE;
	DECLARE Var_SI				CHAR(1);
	DECLARE Var_No				CHAR(1);

	DECLARE NumIteraciones		INT;
	DECLARE Ret_Porcenta    	CHAR(1);
	DECLARE Var_Estatus			CHAR(1);
	DECLARE Var_CuotasPrep		INT;
	DECLARE Var_Consecutivo		INT;
	DECLARE	Var_NumAmorti		INT;
	DECLARE	Var_FechaFin		DATE;
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_TmpConsecutivo	INT(11);
	DECLARE Var_Tmp_FecIni		DATE;
	DECLARE Var_Tmp_FecFin		DATE;
	DECLARE Var_Tmp_FecVig		DATE;
	DECLARE Var_Tmp_Capital		DECIMAL(12,2);
	DECLARE Var_Tmp_Interes		DECIMAL(12,2);
	DECLARE Var_Tmp_ISR			DECIMAL(12,2);
	DECLARE Var_Tmp_SubTotal	DECIMAL(12,2);
	DECLARE Var_Tmp_Insoluto	DECIMAL(12,2);
	DECLARE Var_Tmp_TotalRec    DECIMAL(14,2);
	DECLARE Var_ProductoCredito	INT(11);
	DECLARE Var_Tmp_Dias		INT(11);

	-- declaracion de variables
	DECLARE Var_UltDia			INT;
	DECLARE Var_CadCuotas		VARCHAR(8000);
	DECLARE Contador			INT;
	DECLARE ContadorInv			INT;
	DECLARE NumeroCuota			INT;
	DECLARE ContadorMargen		INT;
	DECLARE VarFechaInicio		DATE;
	DECLARE FechaFinal			DATE;
	DECLARE FechaVig			DATE;
	DECLARE Var_Cuotas			INT;
	DECLARE Var_CuotasInv		INT;
	DECLARE Tas_Periodo			DECIMAL(14,6);
	DECLARE Pag_Calculado		DECIMAL(14,2);
	DECLARE VarCapital			DECIMAL(14,2);
	DECLARE VarCapitalAmor		DECIMAL(14,2);
	DECLARE VarInteres			DECIMAL(14,2);
	DECLARE Subtotal			DECIMAL(14,2);
	DECLARE Insoluto			DECIMAL(14,2);
	DECLARE Var_PorcentajeFondeo	DECIMAL(14,6);
	DECLARE SaldoCredito		DECIMAL(14,2);
	DECLARE Fre_DiasAnio		INT;				-- dias del año
	DECLARE Fre_Dias			INT;				-- numero de dias
	DECLARE Fre_DiasTab			INT;				-- numero de dias para pagos
	DECLARE Var_MarPagIgual		INT;				-- numero de dias para pagos de capital
	DECLARE Var_Diferencia		DECIMAL(14,2);		-- margen para pagos iguales
	DECLARE Var_Ajuste			DECIMAL(14,2);
	DECLARE Par_FechaVenc		DATE	;			-- Fecha Vencimiento en que terminan los pagos
	DECLARE Var_CoutasAmor		VARCHAR(8000);
	DECLARE Var_CAT 	     	DECIMAL(14,4);
	DECLARE Var_MontoCuota    	DECIMAL(14,2);
	DECLARE Var_TotalPagar    	DECIMAL(14,2);
	DECLARE Var_FrecuPago		INT;
	DECLARE Par_NumErr 			INT;
	DECLARE Par_ErrMen  		VARCHAR(350);
	DECLARE VarTasaISR			DECIMAL(12,4);
	DECLARE Isr					DECIMAL(14,4);
	DECLARE TotalRecibir		DECIMAL(14,2);
	DECLARE Var_FormReten   	CHAR(1);
	DECLARE EstatusPagado		CHAR(1);
	DECLARE Var_SumFondeaAmorti	DECIMAL(14,2);
	DECLARE	Var_CompletaFondeo	CHAR(1);
	DECLARE	Var_TotalFondeado	DECIMAL(14,2);

	-- asignación de constantes
	SET Cadena_Vacia	:= '';
	SET Decimal_Cero	:= 0.00;
	SET Entero_Cero		:= 0;
	SET Entero_Cien		:= 100;
	SET Entero_Uno		:= 1;
	SET Entero_Negativo	:= -1;
	SET Fecha_Vacia		:= '1900-01-01';
	SET Var_SI			:= 'S';
	SET Var_No			:= 'N';
	SET Var_MarPagIgual	:= 5;

	SET NumIteraciones	:= 100;
	SET Ret_Porcenta    := 'P';

	-- asignacion de variables
	SET Contador		:= 1;
	SET ContadorMargen	:= 1;
	SET Fre_DiasAnio	:= (SELECT DiasCredito FROM PARAMETROSSIS);
	SET Var_CoutasAmor	:= '';
	SET Var_CAT			:= 0.0000;
	SET Var_MontoCuota	:= 0.00;
	SET Var_TotalPagar	:= 0.00;
	SET Var_FrecuPago 	:= 0;
	SET Par_NumErr		:= Entero_Cero;
	SET Par_ErrMen		:= Cadena_Vacia;
	SET EstatusPagado	:='P';
	SET	Var_SI			:='S';

	ManejoErrores: BEGIN
		BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
										"estamos trabajando para resolverla. Disculpe las molestias que ",
										"esto le ocasiona. Ref: SP-CRWINVCALENPAGOPRO");
				 SET Var_Control := 'sqlException';
			END;


			IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'Especificar Numero de Credito';
				SET Var_Control := 'creditoID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL((SELECT CreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID), Entero_Cero)) = Entero_Cero THEN

				SET Par_NumErr  := 002;
				SET Par_ErrMen  := 'El Numero de Credito Especificado No Existe.';
				SET Var_Control := 'creditoID' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Monto, Decimal_Cero))= Decimal_Cero THEN
				SET Par_NumErr  := 003;
				SET Par_ErrMen  := 'El monto solicitado esta Vacio.';
				SET Var_Control := 'monto' ;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Monto < Entero_Cero)THEN
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := 'El monto no puede ser negativo.';
				SET Var_Control := 'monto' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Tasa, Decimal_Cero))= Decimal_Cero THEN
				SET Par_NumErr  := 005;
				SET Par_ErrMen  := 'La Tasa Anualizada esta Vacia.';
				SET Var_Control := 'tasa' ;
				LEAVE ManejoErrores;
			END IF;

			SELECT  ProductoCreditoID
			INTO	Var_ProductoCredito
			FROM CREDITOS WHERE CreditoID = Par_CreditoID;


			SELECT	TasaISR, 		FormulaRetencion
			INTO	VarTasaISR, 	Var_FormReten
			FROM PARAMETROSCRW WHERE ProductoCreditoID = Var_ProductoCredito;

			IF(IFNULL(VarTasaISR, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr  := 006;
				SET Par_ErrMen  := 'La tasa ISR del productor de credito, no se encuentra parametrizada.';
				SET Var_Control := 'tasaISR' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_FormReten, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 007;
				SET Par_ErrMen  := 'La formula de calculo de retencion, no se encuentra parametrizada.';
				SET Var_Control := 'formulaRetencion' ;
				LEAVE ManejoErrores;
			END IF;


			DELETE FROM CRWTMPPAGAMORSIM WHERE  NumTransaccion = Aud_NumTransaccion;
			DELETE FROM CRWTMPBACKAMORSIM WHERE  NumTransaccion = Aud_NumTransaccion;

			SELECT COUNT(AmortizacionID), -- numero de cuotas del credito

					-- se obtiene el numero de cuotas apartir de la tabla de amortización del credito
			SUM( CASE WHEN FechaVencim > Par_FechaInicio THEN 1
						ELSE Entero_Cero
					END ) AS Var_CuotasInv,

				-- numero de cuotas prepagadas
			SUM( CASE WHEN FechaVencim > Par_FechaInicio AND Estatus = EstatusPagado THEN 1
						ELSE Entero_Cero
					END ) AS Var_CuotasPrep

			INTO Var_Cuotas, Var_CuotasInv, Var_CuotasPrep
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID;

			-- se obtiene el numero de cuota en el que va el credito
			SET  NumeroCuota := Var_Cuotas - Var_CuotasInv + 1 ;

			-- se asigna el numero de cuota a un contador
			SET ContadorInv := NumeroCuota;

			-- se obtiene el saldo del credito
			SET SaldoCredito := (SELECT ( 	IFNULL(Cre.SaldoCapVigent, Decimal_Cero)  +
										IFNULL(Cre.SaldoCapAtrasad, Decimal_Cero)   +
										IFNULL(Cre.SaldoCapVencido, Decimal_Cero)   +
										IFNULL(Cre.SaldCapVenNoExi, Decimal_Cero)   )
								FROM CREDITOS Cre
								WHERE CreditoID = Par_CreditoID);

			-- se obtiene el saldo Fondeado
			SET Var_CompletaFondeo := Var_No;

			SELECT SUM(SaldoCapVigente + SaldoCapExigible)
			INTO Var_TotalFondeado
			FROM CRWFONDEO Fon
			WHERE CreditoID = Par_CreditoID
			AND Fon.Estatus IN ("N", "V");

			SET Var_TotalFondeado := IFNULL(Var_TotalFondeado, Decimal_Cero);

			-- Revisa si con este Fondeo se Completa el 100%
			IF (Var_TotalFondeado = SaldoCredito ) THEN
				SET Var_CompletaFondeo = Var_SI;
			END IF;

			SET Contador		:= 1;
			SET Var_Consecutivo	:= 1;

			--  se inicial el ciclo del calendario para insertarse en la tabla
			WHILE (Contador <= Var_CuotasInv) do

				SELECT 	FechaInicio,		FechaVencim,	FechaExigible, 	Estatus
				INTO 	VarFechaInicio,		FechaFinal, 	FechaVig, 		Var_Estatus
				FROM AMORTICREDITO
				WHERE  AmortizacionID = ContadorInv
				AND CreditoID = Par_CreditoID;

				SET Fre_DiasTab := (DATEDIFF(FechaFinal,VarFechaInicio));

				IF (Var_Estatus <> EstatusPagado)THEN
					IF(Var_Consecutivo = 1)THEN

						SET Fre_DiasTab := (DATEDIFF(FechaFinal,Par_FechaInicio));

						INSERT INTO CRWTMPPAGAMORSIM(
									Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,			Tmp_FecFin,			Tmp_FecVig,
									Tmp_Capital,		Tmp_Interes,	Tmp_Iva,			Tmp_SubTotal,		Tmp_Insoluto,
									Tmp_CapInt,			Tmp_CuotasCap,	Tmp_CuotasInt,		NumTransaccion,		Tmp_InteresAco,
									Tmp_FrecuPago,		Tmp_ISR,		Tmp_TotalRec	)

						VALUES(		Contador,			Fre_DiasTab,	Par_FechaInicio,	FechaFinal,			FechaVig,
									Decimal_Cero,		Decimal_Cero,	Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
									Cadena_Vacia,		Entero_Cero,	Entero_Cero,		Aud_NumTransaccion,	Decimal_Cero,
									Entero_Cero,		Decimal_Cero,	Decimal_Cero);


					ELSE

						INSERT INTO CRWTMPPAGAMORSIM(
									Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,			Tmp_FecFin,			Tmp_FecVig,
									Tmp_Capital,		Tmp_Interes,	Tmp_Iva,			Tmp_SubTotal,		Tmp_Insoluto,
									Tmp_CapInt,			Tmp_CuotasCap,	Tmp_CuotasInt,		NumTransaccion,		Tmp_InteresAco,
									Tmp_FrecuPago,		Tmp_ISR,		Tmp_TotalRec	)

						VALUES(		Contador,			Fre_DiasTab,	Par_FechaInicio,	FechaFinal,			FechaVig,
									Decimal_Cero,		Decimal_Cero,	Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
									Cadena_Vacia,		Entero_Cero,	Entero_Cero,		Aud_NumTransaccion,	Decimal_Cero,
									Entero_Cero,		Decimal_Cero,	Decimal_Cero);

					END IF;
					SET Var_Consecutivo := Var_Consecutivo + 1;

				END IF;
				SET Contador = Contador + 1;
				SET ContadorInv = ContadorInv + 1;

			END WHILE;

			-- Inicializaciones
			SET Contador		:= 1;
			SET ContadorMargen	:= 1;

			SET Fre_Dias := (SELECT PeriodicidadCap
							FROM CREDITOS
							WHERE CreditoID = Par_CreditoID);


			SET Tas_Periodo	:= ((Par_Tasa / Entero_Cien) * Fre_Dias) / Fre_DiasAnio ;

			SET Insoluto := Par_Monto;

			SELECT COUNT(Tmp_Consecutivo) INTO Var_NumAmorti
				FROM CRWTMPPAGAMORSIM
				WHERE NumTransaccion = Aud_NumTransaccion;

			-- Respaldamos el Calendario Antes de Afectarlo
			INSERT INTO CRWTMPBACKAMORSIM(
					Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,		Tmp_FecFin,		Tmp_FecVig,
					Tmp_Capital,		Tmp_Interes,	Tmp_Iva,		Tmp_SubTotal,	Tmp_Insoluto,
					Tmp_CapInt,			Tmp_CuotasCap,	Tmp_CuotasInt,	NumTransaccion,	Tmp_InteresAco,
					Tmp_FrecuPago,		Tmp_ISR,		Tmp_TotalRec	)

			SELECT	Tmp_Consecutivo,						Tmp_Dias,							Tmp_FecIni,		Tmp_FecFin,		Tmp_FecVig,
					IFNULL(Tmp_Capital, Decimal_Cero),		IFNULL(Tmp_Interes,Decimal_Cero),	Tmp_Iva,		Tmp_SubTotal,	Tmp_Insoluto,
					Tmp_CapInt,								Tmp_CuotasCap,						Tmp_CuotasInt,	NumTransaccion,	Tmp_InteresAco,
					Tmp_FrecuPago,							Tmp_ISR,							Tmp_TotalRec
			FROM CRWTMPPAGAMORSIM
			WHERE NumTransaccion = Aud_NumTransaccion;

			-- Genera los montos de Capital y calcula el Interes e ISR
			WHILE (Contador <= Var_NumAmorti) do

				SELECT 	Tmp_Dias, 		Tmp_FecFin
				INTO 	Fre_DiasTab, 	Var_FechaFin
				FROM CRWTMPPAGAMORSIM
				WHERE NumTransaccion = Aud_NumTransaccion
				AND Tmp_Consecutivo = Contador;

				SET VarInteres	:= ((Insoluto * Par_Tasa * Fre_DiasTab ) / (Fre_DiasAnio * Entero_Cien));
				SET Var_SumFondeaAmorti := Entero_Cero;

				-- Obtiene el valor del capital para hacer el Porcentaje
				SELECT 	IFNULL(SaldoCapAtrasa, 0) + IFNULL(SaldoCapVigente, 0) + IFNULL(SaldoCapVencido, 0) + IFNULL(SaldoCapVenNExi, 0)
				INTO VarCapitalAmor
				FROM AMORTICREDITO
				WHERE CreditoID 	 = Par_CreditoID
				AND FechaVencim	 = Var_FechaFin;

				-- Obtiene el valor Fondeado
				SELECT SUM(Amo.SaldoCapVigente + Amo.SaldoCapExigible)
				INTO Var_SumFondeaAmorti
				FROM CRWFONDEO Fon,
					AMORTICRWFONDEO Amo
				WHERE Fon.CreditoID = Par_CreditoID
				AND Fon.SolFondeoID = Amo.SolFondeoID
				AND Amo.Estatus IN ("N", "A")
				AND Fon.Estatus IN ("N", "V")
				AND Amo.FechaVencimiento = Var_FechaFin;

				SET Var_SumFondeaAmorti	:= IFNULL(Var_SumFondeaAmorti, Entero_Cero);
				SET Var_PorcentajeFondeo := ROUND(Par_Monto / SaldoCredito,6);
				SET VarCapital := VarCapitalAmor * Var_PorcentajeFondeo;

				-- Si la suma de lo ya Fondeado por Amortizacion + Nuevo Monto de esta Amortizacion
				-- Excede la Amortizacion del Credito, entonces hacemos el ajuste hacia abajo
				IF( (Var_SumFondeaAmorti + VarCapital) > VarCapitalAmor) THEN
					SET VarCapital := VarCapitalAmor - Var_SumFondeaAmorti;
				END IF;

				-- Verifica si con este Fondeo se Completa el 100% para hacer el Ajuste hacia arriba
				IF(Var_CompletaFondeo = Var_SI) THEN
					SET VarCapital := VarCapitalAmor - Var_SumFondeaAmorti;
				END IF;

				IF(VarCapital < Entero_Cero) THEN
					SET VarCapital := Entero_Cero;
				END IF;

				IF(VarInteres < Entero_Cero) THEN
					SET VarInteres := Entero_Cero;
				END IF;

				IF(Par_PagaISR = Var_SI) THEN
					IF(Var_FormReten = Ret_Porcenta) THEN
						SET Isr := ROUND(VarInteres * VarTasaISR / Entero_Cien, 2);
					ELSE
						SET Isr := ROUND((Insoluto * Fre_DiasTab * VarTasaISR )/ (Fre_DiasAnio * Entero_Cien),2);
					END IF;
				ELSE
					SET Isr := Entero_Cero;
				END IF;

				IF(Contador = Var_NumAmorti) THEN
					SET  VarCapital	:= Insoluto;
				END IF;

				SET Insoluto		:= Insoluto - VarCapital;
				SET Subtotal		:= VarCapital + VarInteres;
				SET TotalRecibir	:= VarCapital + VarInteres - Isr;

				UPDATE CRWTMPPAGAMORSIM  SET
					Tmp_Capital		= VarCapital,
					Tmp_Interes		= VarInteres,
					Tmp_SubTotal	= Subtotal,
					Tmp_ISR			= Isr,
					Tmp_TotalRec	= TotalRecibir,
					Tmp_Insoluto	= Insoluto
				WHERE NumTransaccion = Aud_NumTransaccion
				AND Tmp_Consecutivo = Contador;

				SET Contador := Contador + 1;

			END WHILE;

			-- Eliminamos registro con saldos cero
			DELETE FROM CRWTMPPAGAMORSIM
				WHERE NumTransaccion=Aud_NumTransaccion
				AND IFNULL(Tmp_Capital, Entero_Cero) + IFNULL(Tmp_Interes, Entero_Cero)  = Entero_Cero;


			SELECT	Tmp_Consecutivo,		Tmp_FecIni,		Tmp_FecFin,				Tmp_FecVig,				ROUND(Tmp_Capital,2),
					ROUND(Tmp_Interes,2),	Tmp_ISR,		ROUND(Tmp_SubTotal,2),	ROUND(Tmp_Insoluto,2),	ROUND(Tmp_TotalRec,2),
					Tmp_Dias
			INTO 	Var_TmpConsecutivo, 	Var_Tmp_FecIni,	Var_Tmp_FecFin,			Var_Tmp_FecVig,			Var_Tmp_Capital,
					Var_Tmp_Interes,		Var_Tmp_ISR,	Var_Tmp_SubTotal,		Var_Tmp_Insoluto,		Var_Tmp_TotalRec,
					Var_Tmp_Dias
			FROM CRWTMPPAGAMORSIM
			WHERE NumTransaccion = Aud_NumTransaccion;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT("Agregado correctamente: ", CONVERT(Var_TmpConsecutivo, CHAR));
			SET Var_Control := 'Tmp_Consecutivo';

		END;

		-- Borrado de la Temporal de Respaldo
		DELETE FROM CRWTMPBACKAMORSIM
			WHERE  NumTransaccion = Aud_NumTransaccion;

	END ManejoErrores;
		IF(Par_Salida = Var_Si) THEN
			SELECT	Var_TmpConsecutivo AS Tmp_Consecutivo,
					Var_Tmp_FecIni AS Tmp_FecIni,
					Var_Tmp_FecFin AS Tmp_FecFin,
					Var_Tmp_FecVig AS Tmp_FecVig,
					ROUND(Var_Tmp_Capital,2) AS Tmp_Capital,
					ROUND(Var_Tmp_Interes,2) AS Tmp_Interes,
					Var_Tmp_ISR AS Tmp_ISR,
					ROUND(Var_Tmp_SubTotal,2) AS Tmp_SubTotal,
					ROUND(Var_Tmp_Insoluto,2) AS Tmp_Insoluto,
					ROUND(Var_Tmp_TotalRec,2)AS Tmp_TotalRec,
					Var_Tmp_Dias AS Tmp_Dias,
					Par_NumErr,	Par_ErrMen;

			DELETE FROM CRWTMPPAGAMORSIM WHERE  NumTransaccion = Aud_NumTransaccion;
		END IF;
END TerminaStore$$
