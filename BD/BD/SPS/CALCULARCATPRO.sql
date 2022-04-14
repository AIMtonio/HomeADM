-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULARCATPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULARCATPRO`;
DELIMITER $$


CREATE PROCEDURE `CALCULARCATPRO`(
-- ---------------------------------------------------------------- --
-- SP QUE CALCULA EL CAT PARA PAGOS DE CAPITAL IGUALES Y CRECIENTES --
-- ---------------------------------------------------------------- --
	Par_MontoCredito    DECIMAL(20,2),
    Par_ValorCuotas     VARCHAR(15000),
    Par_FrecuPago       INT(11),
    Par_Salida          CHAR(1),
	Par_ProdCredID		INT,	         -- ID del proucto de credito, para revisar si pide garantia liquida
	Par_ClienteID		INT,			 -- ID del Cliente, para obtener su calificacion en credito
	Par_ComAper         DECIMAL(14,4),
    Par_ComAnualLin		DECIMAL(14,4), 		-- Comisión Anual Linea de crédito

	inout    Var_CAT 	DECIMAL(14,4),
    NumTransaccion      BIGINT(20)

	)

TerminaStore: BEGIN


DECLARE	Var_precision		DOUBLE;
DECLARE	Var_Cre_NumPag		INT;
DECLARE	Var_separa			CHAR(1);
DECLARE	Var_cuota			double;
DECLARE	Var_Xn				DOUBLE;
DECLARE	Var_Xn1				DOUBLE;
DECLARE	Var_control			DOUBLE;
DECLARE	Var_Xn_1			DOUBLE;
DECLARE	Var_sumXn			FLOAT;
DECLARE	Var_sumXn_1			FLOAT;
DECLARE	Var_Fxn				FLOAT;
DECLARE	Var_Fxn_1			FLOAT;
DECLARE	Var_Cre_Period		INT;
DECLARE	Var_TamanioCadena	INT;
DECLARE Var_CadenaPaso		VARCHAR(8000);
declare numero				INT(11);
DECLARE Var_SalidaCiclo 	BIGINT;

DECLARE No_Asignada			CHAR(1);
DECLARE Cons_No				CHAR(1);
DECLARE Cons_Si				CHAR(1);
DECLARE Var_RequiereGL		CHAR(1);
DECLARE Var_PorcGarLiq		DECIMAL(12,2);
DECLARE Var_AportaCliente   DECIMAL(14,2);
DECLARE Var_CalificaCredito	CHAR(1);
DECLARE Decimal_Cero  		DECIMAL(14,2);
DECLARE Var_MontoComi       DECIMAL(14,2);
DECLARE Var_InteresGL       DECIMAL(14,2);
DECLARE Var_TasaGarantia    DECIMAL(12,2);
DECLARE Var_TipoPersona     CHAR(1);

DECLARE	Con_Cadena_Vacia	VARCHAR(1);
DECLARE	Con_Fecha_Vacia		DATE;
DECLARE	Con_Entero_Cero		INT(11);
DECLARE	Con_Moneda_Cero		INT(11);
DECLARE	Salida_SI			CHAR(1);
DECLARE Entero_Cero         INT;
DECLARE FormaFinanciado		CHAR(1);					-- valida forma de pago Financiado
DECLARE FormaApertura		CHAR(1);					-- valida forma de pago Apertura
DECLARE FormaDeducciones	CHAR(1);					-- valida forma de pago Deducciones
DECLARE Var_MontoApertu		DECIMAL(12,2);				-- monto acesorios apertura 
DECLARE Var_MontoIvaApertu	DECIMAL(12,2);				-- monto acesorios IVA apertura
DECLARE Var_MontoDeducci	DECIMAL(12,2);				-- monto acesorios Deduccion
DECLARE Var_MontoIvaDeducci	DECIMAL(12,2);				-- monto acesorios IVA Deduccion
DECLARE Var_CreditoID       BIGINT(12);                 -- Numero de Credito
DECLARE Var_MontoAccesorioF	DECIMAL(12,2);				-- monto acesorios Financiado
DECLARE Var_MontoIvaAccesoF	DECIMAL(12,2);			    -- monto acesorios IVA Financiado

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
       SET Var_CAT				:= 0.0;
    END;


SET Con_Cadena_Vacia	:= '';
SET Con_Fecha_Vacia		:= '1900-01-01';
SET Con_Entero_Cero		:= 0;
SET Con_Moneda_Cero		:= 0.00;
SET Salida_SI			:= 'S';

SET No_Asignada			:= 'N';				-- calificacion NO asignada al cliente
SET Cons_No				:= 'N';
SET Cons_Si				:= 'S';	
SET Decimal_Cero        := 0.0;             -- DECIMAL Cero
SET Var_MontoComi       := 0.0;             -- Declaramos el monto de comisiones en 0
SET Var_InteresGL       := 0.0;
SET Var_TasaGarantia    := 0.0;

SET Var_precision		:= 0.0000001;
SET Var_separa			:= ',';
SET Var_Cre_NumPag		:= 0;
SET Var_Xn				:= 0.5;
SET Var_Xn_1			:= 1;
SET Var_Fxn 			:= 0;
SET Var_CAT				:= 0.0;
SET Entero_Cero         := 0;
SET FormaFinanciado     := 'F';     -- Forma de cobro Financiado
SET FormaApertura     	:= 'A';     -- Forma de cobro Financiado
SET FormaDeducciones    := 'D';     -- Forma de cobro Financiado

SET SQL_SAFE_UPDATES := 0;

SET Par_ValorCuotas := trim(Par_ValorCuotas);

IF right(Par_ValorCuotas, 1) <> Var_separa THEN
	SET Par_ValorCuotas := CONCAT(Par_ValorCuotas, Var_separa);
END IF;

DELETE FROM TMPCUOTASCALCAT WHERE TmpNumTransaccion = NumTransaccion;

WHILE CHARACTER_LENGTH(Par_ValorCuotas) > Entero_Cero DO
	SET Var_Cre_NumPag := Var_Cre_NumPag + 1;
	SET Var_cuota = CAST(ifnull(substring(Par_ValorCuotas, 1, LOCATE(Var_separa, Par_ValorCuotas) -1), '') AS DECIMAL(20,6));
	INSERT INTO TMPCUOTASCALCAT VALUES (NumTransaccion, Var_Cre_NumPag, ifnull(Var_cuota, Entero_Cero),Entero_Cero,Entero_Cero);
	SET Par_ValorCuotas = substring(Par_ValorCuotas, LOCATE( Var_separa, Par_ValorCuotas ) +1,  LENGTH(Par_ValorCuotas));
END WHILE;

IF ((Par_ClienteID = Entero_Cero) OR (Par_ProdCredID = Entero_Cero)) THEN
	SET	Var_PorcGarLiq	:= Decimal_Cero;
	SET Var_AportaCliente := Decimal_Cero;
ELSE
		/* Obtenemos el monto de la garantia liquida, si lo requiere el producto de credito */
		SELECT IFNULL(Garantizado,No_Asignada) INTO Var_RequiereGL FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProdCredID;
		# si el producto de credito no requiere GL, guardara ceros
		IF(Var_RequiereGL = No_Asignada)THEN
			SET	Var_PorcGarLiq		:= Decimal_Cero;
			SET Var_AportaCliente 	:= Decimal_Cero;
		ELSE
			SET Var_CalificaCredito  :=(SELECT IFNULL(CalificaCredito,No_Asignada)
									 FROM CLIENTES WHERE ClienteID = Par_ClienteID);
			SELECT Porcentaje
				FROM ESQUEMAGARANTIALIQ
				WHERE Clasificacion = Var_CalificaCredito
					AND ProducCreditoID = Par_ProdCredID
					AND Par_MontoCredito BETWEEN LimiteInferior AND LimiteSuperior
				LIMIT 1
			INTO Var_PorcGarLiq;
			SET Var_AportaCliente 	:= round((Par_MontoCredito * Var_PorcGarLiq) / 100,2);
			SET Var_AportaCliente 	:= ifnull(Var_AportaCliente,Decimal_Cero);
		END IF;
END IF;

SELECT TipoPersona INTO Var_TipoPersona  FROM CLIENTES WHERE ClienteID = Par_ClienteID;
-- Obtenemos la Tasa de Interes sobre la garantia liquida
SELECT 	        TA.Tasa         INTO Var_TasaGarantia
	FROM		CUENTASAHO 		CA,
				TIPOSCUENTAS 	TC,
				TASASAHORRO     TA
	WHERE		CA.TipoCuentaID	 =	 TC.TipoCuentaID
	and			TC.TipoCuentaID  =   TA.TipoCuentaID
	and			CA.ClienteID	 =	 Par_ClienteID
	and			CA.Estatus		 <>	 'C'
	and         TC.GeneraInteres =   'S'
    and         CA.EsPrincipal   =   'S'
	and         TA.MonedaID      =    1
    and         TA.TipoPersona   =   Var_TipoPersona
	limit       1;

SET Var_TasaGarantia := ifnull(Var_TasaGarantia,Decimal_cero);

IF Var_TasaGarantia > 0 THEN
	SET Var_InteresGL := (Var_AportaCliente * Var_TasaGarantia * (Var_Cre_NumPag * Par_FrecuPago )) / 36000;
    SET Var_MontoComi := Var_MontoComi + Var_AportaCliente + Var_InteresGL;
END IF;





-- Actualizamos la primera amortizacion sumandole el monto obtenido de comisiones ( Garantia liquida + intereses )
UPDATE TMPCUOTASCALCAT SET TmpCuoMonto = (TmpCuoMonto + case when Var_MontoComi > Par_MontoCredito then Entero_Cero else Var_MontoComi end ) WHERE TmpNumTransaccion = NumTransaccion and  TmpCuoNumero = 1 ;
UPDATE TMPCUOTASCALCAT SET TmpCuoMonto = (TmpCuoMonto +  case when Var_MontoComi > Par_MontoCredito then Entero_Cero else (Var_MontoComi * -1) end ) WHERE TmpNumTransaccion = NumTransaccion and TmpCuoNumero = Var_Cre_NumPag;

##VALIDAMOS  SI ES DE ALTA DE CREDITO

SELECT  CreditoID 
    INTO Var_CreditoID
FROM DETALLEACCESORIOS DETALLE
  INNER JOIN CREDITOS USING (CreditoID)  
WHERE ClienteID = Par_ClienteID 
    AND DETALLE.NumTransaccion=NumTransaccion
LIMIT 1;


            
SET Var_CreditoID  := IFNULL(Var_CreditoID, Entero_Cero);
           
IF Var_CreditoID  !=  Entero_Cero THEN
# OBTENEMOS EL CALCULO DEL MONTO ACCESORIOS PARA CALCULAR EL CAT  FINANCIAMIENTO  POR AMORTIZACIONES 	

	SELECT	SUM(MontoCuota)AS MontoCuota,SUM(MontoIVACuota) AS MontoIVACuota
		INTO Var_MontoAccesorioF,		Var_MontoIvaAccesoF
	FROM   DETALLEACCESORIOS DETALLE
		INNER JOIN ACCESORIOSCRED Acc ON DETALLE.AccesorioID=Acc.AccesorioID 
	WHERE DETALLE.NumTransaccion=NumTransaccion
	AND DETALLE.CreditoID = Var_CreditoID
	AND  Acc.CAT = Cons_Si
	AND TipoFormaCobro = FormaFinanciado
	AND AmortizacionID = 1
	GROUP BY DETALLE.NumTransaccion,AmortizacionID;

	SET Var_MontoAccesorioF  := IFNULL(Var_MontoAccesorioF, Entero_Cero);
	SET Var_MontoIvaAccesoF  := IFNULL(Var_MontoIvaAccesoF, Entero_Cero);
	 
	#ACTUALIZAMOS MONTOS
	UPDATE  TMPCUOTASCALCAT  CAT
		SET CAT.TmpCuoMonto = IFNULL(CAT.TmpCuoMonto,Entero_Cero)+ IFNULL(Var_MontoAccesorioF,Entero_Cero)
	WHERE TmpNumTransaccion = NumTransaccion
	 ;   

ELSE
	# OBTENEMOS EL CALCULO DEL MONTO ACCESORIOS PARA CALCULAR EL CAT  FINANCIAMIENTO  POR AMORTIZACIONES 	
    
	SELECT	SUM(MontoCuota)AS MontoCuota,SUM(MontoIVACuota) AS MontoIVACuota
		INTO Var_MontoAccesorioF,		Var_MontoIvaAccesoF
	FROM   DETALLEACCESORIOS DETALLE
		INNER JOIN ACCESORIOSCRED Acc ON DETALLE.AccesorioID=Acc.AccesorioID 
	WHERE DETALLE.NumTransaccion=NumTransaccion
	AND  Acc.CAT = Cons_Si
	AND TipoFormaCobro = FormaFinanciado
	AND AmortizacionID = 1
	GROUP BY DETALLE.NumTransaccion,AmortizacionID;

	 SET Var_MontoAccesorioF  := IFNULL(Var_MontoAccesorioF, Entero_Cero);
	 SET Var_MontoIvaAccesoF  := IFNULL(Var_MontoIvaAccesoF, Entero_Cero);
	 
	 #ACTUALIZAMOS MONTOS
	UPDATE  TMPCUOTASCALCAT  CAT
		SET CAT.TmpCuoMonto = IFNULL(CAT.TmpCuoMonto,Entero_Cero)+ IFNULL(Var_MontoAccesorioF,Entero_Cero)
	WHERE TmpNumTransaccion = NumTransaccion
	 ; 
	
END IF; 

-- Restamos el monto de comision por apertura al monto de credito
SET Par_MontoCredito := round(Par_MontoCredito - Par_ComAper - Par_ComAnualLin, Entero_Cero);

IF Par_FrecuPago = 7 THEN
	SET Var_Cre_Period := 52;
ELSEIF Par_FrecuPago = 14 THEN
		SET Var_Cre_Period := 26;
ELSEIF Par_FrecuPago = 15 THEN
		SET Var_Cre_Period := 24;
ELSEIF (Par_FrecuPago = 28 or Par_FrecuPago = 29 or Par_FrecuPago = 30 or Par_FrecuPago = 31)	THEN
		SET Var_Cre_Period := 12;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag = 1 THEN
		SET Var_Cre_Period := 1;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag >= 51 THEN
		SET Var_Cre_Period := 52;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag >= 25 and Var_Cre_NumPag <= 27 THEN
		SET Var_Cre_Period := 26;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag >= 23 and Var_Cre_NumPag <= 25 THEN
		SET Var_Cre_Period := 24;
ELSEIF Par_FrecuPago = 360 and Var_Cre_NumPag >= 11 and Var_Cre_NumPag <= 13 THEN
		SET Var_Cre_Period := 12;
ELSE
		SET Var_Cre_Period := 360/Par_FrecuPago;
		IF ifnull(Var_Cre_Period , 0) < 1 then
			SET Var_Cre_Period 	:= 1;
		END IF;
END IF;

  UPDATE TMPCUOTASCALCAT
	SET TmpCuo_Xn = TmpCuoMonto /( power( (1.00 + Var_Xn),(TmpCuoNumero / Var_Cre_Period  )))
    WHERE TmpNumTransaccion = NumTransaccion;

  UPDATE TMPCUOTASCALCAT
	SET TmpCuo_Xn_1 = TmpCuoMonto /( power( (1.00 + Var_Xn_1),(TmpCuoNumero / Var_Cre_Period  )))
    WHERE TmpNumTransaccion = NumTransaccion;


  SET Var_sumXn := (SELECT sum(TmpCuo_Xn) FROM TMPCUOTASCALCAT WHERE TmpNumTransaccion = NumTransaccion);
  SET Var_sumXn_1 := (SELECT sum(TmpCuo_Xn_1) FROM TMPCUOTASCALCAT WHERE TmpNumTransaccion = NumTransaccion);
  SET Var_Fxn := Par_MontoCredito - Var_sumXn;
  SET Var_Fxn_1 := Par_MontoCredito - Var_sumXn_1;


SET Var_SalidaCiclo := Entero_Cero;

CICLOWHILE: LOOP
	WHILE abs(Var_Fxn) > Var_precision  DO
		SET Var_SalidaCiclo := Var_SalidaCiclo + 1;

		SET Var_Xn1		:= Var_Xn - ( ( (Var_Xn - Var_Xn_1) * Var_Fxn ) / ( Var_Fxn - Var_Fxn_1 ) );
		SET Var_Xn_1	:= Var_Xn;
		SET Var_Xn		:= Var_Xn1;

		UPDATE TMPCUOTASCALCAT
		SET TmpCuo_Xn = TmpCuoMonto /( power( (1.00 + Var_Xn),(TmpCuoNumero / Var_Cre_Period  )))
		WHERE TmpNumTransaccion = NumTransaccion;

		UPDATE TMPCUOTASCALCAT
		SET TmpCuo_Xn_1 = TmpCuoMonto /( power( (1.00 + Var_Xn_1),(TmpCuoNumero / Var_Cre_Period  )))
		WHERE TmpNumTransaccion = NumTransaccion;

		SET Var_sumXn := (SELECT sum(TmpCuo_Xn) FROM TMPCUOTASCALCAT WHERE TmpNumTransaccion = NumTransaccion);
		SET Var_sumXn_1 := (SELECT sum(TmpCuo_Xn_1) FROM TMPCUOTASCALCAT WHERE TmpNumTransaccion = NumTransaccion);
		SET Var_Fxn := Par_MontoCredito - Var_sumXn;
		SET Var_Fxn_1 := Par_MontoCredito - Var_sumXn_1;

		IF(Var_SalidaCiclo = 50000) then
		   SET Var_Fxn := Var_precision + 10;
		END IF;

		SET Var_control:= ( Var_Fxn - Var_Fxn_1 ) ;
		IF(ifnull(Var_control,Entero_Cero) = Entero_Cero) then
			LEAVE CICLOWHILE;
		END IF ;
	END WHILE;
End LOOP CICLOWHILE;

SET Var_CAT := (SELECT round(Var_Xn1 * 100,1));

END;

IF (Par_Salida = Salida_SI) then
    SELECT Var_CAT;
END IF;

DELETE FROM TMPCUOTASCALCAT WHERE TmpNumTransaccion = NumTransaccion;

END TerminaStore$$
