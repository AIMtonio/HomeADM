-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVCALENPAGOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVCALENPAGOPRO`;DELIMITER $$

CREATE PROCEDURE `INVCALENPAGOPRO`(
	Par_SolCredID 		BIGINT(20),			-- El numero de credito es requerido
	Par_CreditoID 		BIGINT(12),			-- El numero de credito es requerido
	Par_Monto			DECIMAL(14,2),	-- Monto a prestar
	Par_Tasa			DECIMAL(14,2),	-- Tasa Anualizada
	Par_FechaInicio		DATE,			-- fecha en que empiezan los pagos

	Par_Salida			CHAR(1), 		-- Si .- "S" o No .- "N" para los datos de salida
    INOUT Par_NumErr 	INT(11),
    INOUT Par_ErrMen  	VARCHAR(400),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE Entero_Cero		INT;
DECLARE Entero_Cien		INT;
DECLARE Entero_Uno		INT;
DECLARE Entero_Negativo	INT;
DECLARE Fecha_Vacia   	DATE;
DECLARE Var_Si			CHAR(1);	-- SI
DECLARE Var_No			CHAR(1);	-- NO
DECLARE PagoSemanal		CHAR(1);	-- Pago Semanal (S)
DECLARE PagoCatorcenal	CHAR(1);	-- Pago Catorcenal (C)
DECLARE PagoQuincenal		CHAR(1);	-- Pago Quincenal (Q)
DECLARE PagoMensual		CHAR(1);	-- Pago Mensual (M)
DECLARE PagoPeriodo		CHAR(1);	-- Pago por periodo (P)
DECLARE PagoBimestral		CHAR(1);	-- PagoBimestral (B)
DECLARE PagoTrimestral	CHAR(1);	-- PagoTrimestral (T)
DECLARE PagoTetrames		CHAR(1);	-- PagoTetraMestral (R)
DECLARE PagoSemestral		CHAR(1);	-- PagoSemestral (E)
DECLARE PagoAnual			CHAR(1);	-- PagoAnual (A)
DECLARE PagoFinMes		CHAR(1);	-- Pago al final del mes (F)
DECLARE PagoAniver		CHAR(1);	-- Pago por aniversario (A)
DECLARE Est_Inactivo		CHAR(1);	-- Estatus I .- Inactivo. Corresponde con AMORTICREDITO
DECLARE Est_Vigente		CHAR(1); -- Estatus V .-Vigente. Corresponde con AMORTICREDITO
DECLARE FrecSemanal		INT;		-- frecuencia semanal en dias
DECLARE FrecCator			INT;		-- frecuencia Catorcenal en dias
DECLARE FrecQuin			INT;		-- frecuencia en dias quincena
DECLARE FrecMensual		INT;		-- frecuencia mensual
DECLARE FrecBimestral		INT;		-- Frecuencia en dias Bimestral
DECLARE FrecTrimestral	INT;		-- Frecuencia en dias Trimestral
DECLARE FrecTetrames		INT;		-- Frecuencia en dias TetraMestral
DECLARE FrecSemestral		INT;		-- Frecuencia en dias Semestral
DECLARE FrecAnual			INT;		-- frecuencia en dias Anual

DECLARE NumIteraciones	INT;
DECLARE Par_Plazo			INT;
DECLARE Par_PagoCuota		CHAR(1);
DECLARE Par_AjustaFecAmo	CHAR(1);

--  Declaracion de Variables
DECLARE Var_UltDia		INT;
DECLARE Contador			INT;

DECLARE ContadorMargen	INT;
DECLARE Var_Cuotas		INT;
DECLARE Var_CuotasInv		INT;
DECLARE Fre_DiasAnio		INT;		-- dias del aÃ±o
DECLARE Fre_Dias			INT;		-- numero de dias
DECLARE Fre_DiasTab		INT;		-- numero de dias para pagos de capital
DECLARE Var_GraciaFaltaPago INT;		-- dias de gracia
DECLARE Var_MargenPagIgual	INT;		-- Margen para pagos iguales
DECLARE Var_FrecuPago		INT;
DECLARE VarFechaInicio	DATE;
DECLARE FechaInicio		DATE;
DECLARE FechaFinal		DATE;
DECLARE FechaVig			DATE;
DECLARE Par_FechaVenc		DATE	;		-- fecha vencimiento en que terminan los pagos
DECLARE Var_CadCuotas		VARCHAR(8000);
DECLARE Var_CoutasAmor	VARCHAR(8000);
DECLARE Tas_Periodo		DECIMAL(14,6);
DECLARE Pag_Calculado		DECIMAL(14,2);
DECLARE VarCapital		DECIMAL(14,2);
DECLARE VarCapitalAmor	DECIMAL(14,2);
DECLARE VarInteres		DECIMAL(14,2);
DECLARE IvaInt			DECIMAL(14,2);
DECLARE Subtotal			DECIMAL(14,2);
DECLARE Insoluto			DECIMAL(14,2);
DECLARE Var_IVA			DECIMAL(14,2);
DECLARE PorcentajeFondeo	DECIMAL(14,6);
DECLARE SaldoCredito		DECIMAL(14,2);
DECLARE Var_Diferencia	DECIMAL(14,2);
DECLARE Var_Ajuste		DECIMAL(14,2);
DECLARE Var_CAT 	     	DECIMAL(14,4);
DECLARE Var_MontoCuota    	DECIMAL(14,2);
DECLARE Var_TotalPagar    	DECIMAL(14,2);
DECLARE CuotaSinIva		DECIMAL(14,2);
DECLARE Isr				DECIMAL(14,4);
DECLARE TotalRecibir		DECIMAL(14,2);
DECLARE VarTasaISR		DECIMAL(12,2);
DECLARE Var_CtePagIva		CHAR(1);	-- Cliente Paga Iva S si N no
DECLARE Var_PagaIVA		CHAR(1);
DECLARE Var_EsHabil		CHAR(1);
DECLARE BandFecha			CHAR(1); -- bandera para identificar si coincide la fecha de inicio de parametro con alguna fecha de inicio de amortizacion
DECLARE Var_Credito 		INT(11);
DECLARE Var_SolCred		BIGINT(20);
DECLARE Par_PagoFinAni	CHAR(1);	-- solo si el Pago es Mensual indica si es fin de mes (F) o por aniversario (A)
DECLARE Par_DiaHabilSig	CHAR(1);	-- Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
DECLARE Par_DiaMes		INT(2);	-- Si escoge en pago por aniversario, puede especificar un dia del mes (1 -31) segun el mes en que se encuentre
DECLARE Par_AjusFecExiVen	CHAR(1);	-- Indica si se ajusta la fecha de exigibilidad a fecha de vencimiento (S- si se ajusta N- no se ajusta)

DECLARE Per_Semanal	 	CHAR(1);
DECLARE Per_Catorcenal	CHAR(1);
DECLARE Per_Quincenal	 	CHAR(1);
DECLARE Per_Mensual	 	CHAR(1);
DECLARE ContadorInv 		INT(4);

-- asignacion de constantes
SET Cadena_Vacia		:= '';
SET Decimal_Cero		:= 0.00;
SET Entero_Cero		:= 0;
SET Entero_Cien		:= 100;
SET Entero_Uno		:= 1;
SET Entero_Negativo	:= -1;
SET	Fecha_Vacia		:= '1900-01-01';
SET Var_Si			:= 'S';
SET Var_No			:= 'N';
SET PagoSemanal		:= 'S'; -- PagoSemanal
SET PagoCatorcenal	:= 'C'; -- PagoCatorcenal
SET PagoQuincenal		:= 'Q'; -- PagoQuincenal
SET PagoMensual		:= 'M'; -- PagoMensual
SET PagoPeriodo		:= 'P'; -- PagoPeriodo
SET PagoBimestral		:= 'B'; -- PagoBimestral
SET PagoTrimestral	:= 'T'; -- PagoTrimestral
SET PagoTetrames		:= 'R'; -- PagoTetraMestral
SET PagoSemestral		:= 'E'; -- PagoSemestral
SET PagoAnual			:= 'A'; -- PagoAnual
SET PagoFinMes		:= 'F'; -- PagoFinMes
SET PagoAniver		:= 'A'; -- Pago por aniversario
SET Est_Inactivo		:= 'I'; -- Estatus I .- Inactivo. Corresponde con AMORTICREDITO
SET Est_Vigente		:= 'V'; -- Estatus V .-Vigente. Corresponde con AMORTICREDITO
SET FrecSemanal		:= 7;	-- frecuencia semanal en dias
SET FrecCator			:= 14;	-- frecuencia Catorcenal en dias
SET FrecQuin			:= 15;	-- frecuencia en dias de quincena
SET FrecMensual		:= 30;	-- frecuencia mesual

SET FrecBimestral		:= 60;	-- Frecuencia en dias Bimestral
SET FrecTrimestral	:= 90;	-- Frecuencia en dias Trimestral
SET FrecTetrames		:= 120;	-- Frecuencia en dias TetraMestral
SET FrecSemestral		:= 180;	-- Frecuencia en dias Semestral
SET FrecAnual			:= 360;	-- frecuencia en dias Anual

SET Var_PagaIVA		:= Var_No;
SET Var_GraciaFaltaPago	:= 10;
SET Var_MargenPagIgual:= 10;

SET NumIteraciones		:= '100';
SET Per_Semanal		:='S';
SET 	Per_Catorcenal	:='C';
SET 	Per_Quincenal	:='Q';
SET 	Per_Mensual		:='M';

-- asignacion de variables
SET Par_NumErr  	:= Entero_Cero;
SET Var_IVA			:= Entero_Cero;
SET Par_ErrMen  	:= Cadena_Vacia;
SET Contador		:= 1;
SET ContadorMargen	:= 1;
SET Var_CAT			:= 0.0000;
SET Var_MontoCuota	:= 0.00;
SET Var_TotalPagar	:= 0.00;
SET Var_FrecuPago 	:= 0;
SET CuotaSinIva		:= 0.0;
SET Var_CoutasAmor	:= '';
SET BandFecha			:= '';
SET Var_CadCuotas		:= '';
SET Var_EsHabil		:= 'S';
SET VarTasaISR		:= (SELECT TasaISR FROM SUCURSALES  WHERE SucursalID = Aud_Sucursal);
SET Fre_DiasAnio		:= (SELECT DiasCredito FROM PARAMETROSSIS);
SET Par_PagoFinAni	:='F';
SET Par_DiaHabilSig	:= 'S';
SET ContadorInv 		:= 0;
SET VarCapitalAmor	:= 0;

-- Si la cotizacion fue por numero de credito


 SET ContadorInv := (SELECT 	AmortizacionID
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
					AND FechaInicio <= Par_FechaInicio
					AND FechaVencim > Par_FechaInicio
					AND (Estatus = Est_Inactivo OR Estatus = Est_Vigente));


 SET VarCapitalAmor := (SELECT 		Capital
		VarCapitalAmor
				FROM AMORTICREDITO
				WHERE CreditoID = Par_CreditoID
					AND FechaInicio <= Par_FechaInicio
					AND FechaVencim > Par_FechaInicio

					AND (Estatus = Est_Inactivo OR Estatus = Est_Vigente));

	-- se obtiene el numero de coutas
	SET Var_CuotasInv := (SELECT COUNT(AmortizacionID)
							FROM AMORTICREDITO
							WHERE CreditoID = Par_CreditoID
								AND (FechaInicio = Par_FechaInicio
								OR  FechaVencim > Par_FechaInicio)
								AND (Estatus = Est_Inactivo OR Estatus = Est_Vigente));


	-- se obtiene el valor del saldo del credito y se asigna a una variable
	SELECT (IFNULL(SaldoCapVigent, Entero_Cero) + IFNULL(SaldoCapAtrasad, Entero_Cero) +
		IFNULL(SaldoCapVencido, Entero_Cero) + IFNULL(SaldCapVenNoExi, Entero_Cero)) AS SaldoCredito
			INTO SaldoCredito
		FROM CREDITOS WHERE CreditoID = Par_CreditoID;
	SET SaldoCredito := IFNULL(SaldoCredito, Entero_Cero);

	-- Se inicializa el Contador
	SET Contador			:= 1;

	WHILE (Contador <= Var_CuotasInv) DO
		-- se inserta el calendario
		SELECT 	FechaInicio,		FechaVencim,	FechaExigible
			INTO
				VarFechaInicio,	FechaFinal, 	FechaVig
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
			AND AmortizacionID = ContadorInv+1
			AND (Estatus = Est_Inactivo OR Estatus = Est_Vigente);

		SET Fre_DiasTab := (DATEDIFF(FechaFinal,VarFechaInicio));

		IF(Contador = 1)THEN
			INSERT INTO TMPCOTIZADORINV
					(	Tmp_Consecutivo, 	Tmp_FecIni,		Tmp_FecFin,	Tmp_FecVig,		Tmp_Dias,
						NumTransaccion)
				VALUES(	Contador,		Par_FechaInicio,	FechaFinal,	FechaVig,		Fre_DiasTab,
						Aud_NumTransaccion);

			IF(VarFechaInicio = Par_FechaInicio )THEN
				SET BandFecha := Var_Si;
			ELSE
				SET BandFecha := Var_No;
			END IF;
		ELSE
			INSERT INTO TMPCOTIZADORINV
					(	Tmp_Consecutivo, 	Tmp_FecIni,		Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,
						NumTransaccion)
				VALUES(	Contador,		VarFechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab,
						Aud_NumTransaccion);

		END IF;
		SET Contador = Contador +1;
		SET ContadorInv = ContadorInv +1;

	END WHILE;


	-- Se inicializa el Contador
	SET Contador			:= 1;
	SET ContadorMargen	:= 1;

	-- Se obtiene el promedio de dias entre cada cuota para obtener la tasa del periodo
	SET Fre_Dias := (SELECT ROUND(AVG(DATEDIFF(FechaVencim,FechaInicio)),Entero_Cero)
							FROM AMORTICREDITO
							WHERE CreditoID = Par_CreditoID);

	SET Tas_Periodo	:= ((Par_Tasa / Entero_Cien) * Fre_Dias) / Fre_DiasAnio ;

	SET Insoluto := Par_Monto;

	-- select Pag_Calculado, Tas_Periodo;
	-- genera los montos y los inserta en la tabla TMPCOTIZADORINV
	WHILE (ContadorMargen <= NumIteraciones) DO
		WHILE (Contador <= Var_CuotasInv) DO
			SELECT Tmp_Dias INTO Fre_DiasTab
				FROM TMPCOTIZADORINV
				WHERE NumTransaccion = Aud_NumTransaccion
				AND Tmp_Consecutivo = Contador;

			IF(BandFecha = Var_Si) THEN

				SET VarInteres:= ((Insoluto * Par_Tasa * Fre_DiasTab ) / (Fre_DiasAnio*Entero_Cien));
				SET Isr 		:= ROUND((Insoluto * Fre_DiasTab * VarTasaISR )/ (Fre_DiasAnio*Entero_Cien),2);

				IF(Contador = 1)THEN
					SET Pag_Calculado	:= (Par_Monto * Tas_Periodo * (POWER((1 + Tas_Periodo), Var_CuotasInv))) / (POWER((1 + Tas_Periodo), Var_CuotasInv)-1);
					-- se redondea a cero el valor del pago calculado
					SET Pag_Calculado	:= ROUND(Pag_Calculado,Entero_Cero);
				END IF;

				IF(Contador = Var_CuotasInv)THEN
					SET  VarCapital	:= Insoluto;
				ELSE
					SET  VarCapital	:= Pag_Calculado -  VarInteres;
					IF (Insoluto<=VarCapital) THEN
						SET VarCapital := Insoluto;
					END IF;
				END IF;

				SET Insoluto	:= Insoluto - VarCapital;
				SET Subtotal	:= VarCapital + VarInteres;
				SET TotalRecibir := VarCapital + VarInteres - Isr;

			ELSE
				IF(Contador = 1)THEN
					SET PorcentajeFondeo := IF(SaldoCredito != Entero_Cero, ROUND(Par_Monto/SaldoCredito,6), Entero_Cero);
					SET VarCapital := CEILING(VarCapitalAmor *PorcentajeFondeo);

					SET VarInteres:= ((Insoluto * Par_Tasa * Fre_DiasTab ) / (Fre_DiasAnio*Entero_Cien));
					SET Isr 		:= ROUND((Insoluto * Fre_DiasTab * VarTasaISR )/ (Fre_DiasAnio*Entero_Cien),2);

					SET Insoluto	:= Insoluto - VarCapital;
					SET Subtotal	:= VarCapital + VarInteres;
					SET TotalRecibir := VarCapital + VarInteres - Isr;

					SET BandFecha := Var_Si;

					SET Pag_Calculado	:= (Insoluto * Tas_Periodo * (POWER((1 + Tas_Periodo), Var_CuotasInv-1))) / (POWER((1 + Tas_Periodo), Var_CuotasInv-1)-1);
					-- se redondea a cero el valor del pago calculado
					SET Pag_Calculado	:= ROUND(Pag_Calculado,Entero_Cero);
				END IF;
			END IF;

			UPDATE TMPCOTIZADORINV  SET
					Tmp_Capital	= VarCapital,
					Tmp_Interes	= VarInteres,
					Tmp_Iva		= IvaInt,
					Tmp_SubTotal	= Subtotal,
					Tmp_ISR		= Isr,
					Tmp_TotalRec	= TotalRecibir,
					Tmp_Insoluto	= Insoluto
				WHERE NumTransaccion = Aud_NumTransaccion
				AND Tmp_Consecutivo = Contador;

			SET Contador = Contador+1;

		END WHILE;
		SET Var_Diferencia := Pag_Calculado-Subtotal;
		-- Set ContadorB := ContadorMargen;
		SET ContadorMargen = ContadorMargen+1;

		IF (ContadorMargen<=NumIteraciones)THEN
			IF (ABS(Var_Diferencia) > Var_MargenPagIgual) THEN
					-- se redondea el ajuste al proximo entero
					IF(Var_Diferencia>Entero_Cero)THEN
						SET Pag_Calculado 	:= Pag_Calculado-Entero_Uno;
					ELSE
						SET Pag_Calculado 	:= Pag_Calculado+Entero_Uno;
					END IF;

					-- se redondea a cero el valor del pago calculado
					SET Pag_Calculado	:= ROUND(Pag_Calculado,Entero_Cero);
					SET Insoluto			:= Par_Monto;

					IF (SELECT Var_CadCuotas LIKE CONCAT('%',Pag_Calculado,'%'))THEN
						SET Contador := Var_CuotasInv+1;
						SET ContadorMargen := NumIteraciones+1;
					ELSE
						SET Var_CoutasAmor	:= '';
						SET Contador 		:=1;
						SET Var_TotalPagar	:= 0;
					END IF;

					SET Var_CadCuotas := CONCAT(Var_CadCuotas,',',Pag_Calculado);

			ELSE
				SET ContadorMargen := NumIteraciones+1;
				SET Contador = Var_CuotasInv+1;
			END IF;
		END IF;
	 END WHILE;



-- COMPARO SI EL ULTIMO REGISTRO DE LA TABLA TMPCOTIZADORINV ES CERO, ELIMINO EL REGISTRO.
SELECT Tmp_Capital,Tmp_Interes
	INTO VarCapital, VarInteres
	FROM TMPCOTIZADORINV
	WHERE NumTransaccion=Aud_NumTransaccion
	AND Tmp_Consecutivo= Var_CuotasInv;

IF ( VarCapital = Decimal_Cero AND VarInteres = Decimal_Cero ) THEN
	DELETE FROM TMPCOTIZADORINV WHERE Tmp_Consecutivo = Var_CuotasInv AND NumTransaccion=Aud_NumTransaccion;
	SET Var_CuotasInv:=Var_CuotasInv-1;
END IF;



-- Se muestran los datos
IF(Par_Salida = Var_Si) THEN
SELECT	Tmp_Consecutivo,						Tmp_FecIni,		Tmp_FecFin,							Tmp_FecVig,							FORMAT(Tmp_Capital,2)AS Tmp_Capital,
			FORMAT(Tmp_Interes,2)AS Tmp_Interes,	Tmp_ISR,			FORMAT(Tmp_SubTotal,2)AS Tmp_SubTotal,	FORMAT(Tmp_TotalRec,2)AS Tmp_TotalRec,	FORMAT(Tmp_Insoluto,2)  AS Tmp_Insoluto,
			Tmp_Dias,							Par_NumErr,		Par_ErrMen
	FROM		TMPCOTIZADORINV
	WHERE 	NumTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPCOTIZADORINV WHERE  NumTransaccion = Aud_NumTransaccion;
ELSE
	SET Par_NumErr := 0;
	SET Par_ErrMen := 'Exito.';
END IF;


END TerminaStore$$