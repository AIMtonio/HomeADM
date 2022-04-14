-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULARCATPAGUNIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULARCATPAGUNIPRO`;
DELIMITER $$

CREATE PROCEDURE `CALCULARCATPAGUNIPRO`(
-- SP QUE CALCULA EL CAT PARA PAGOS DE CAPITAL UNICOS    ---

	Par_MontoCredito    DECIMAL(20,2),
	Par_ValorCuota    	DECIMAL(20,2),
	Par_FrecuPago       INT(11),
	Par_Salida        	CHAR(1),
	Par_ProdCredID		INT,			-- ID del proucto de credito, para revisar si pide garantia liquida

	Par_ClienteID		INT,		 	-- ID del Cliente, para obtener su calificacion en credito
	Par_Tasa        	DECIMAL(14,2),
    Par_ComAnualLin		DECIMAL(14,2), 		-- Comisión Anualidad Linea de Crédito
	INOUT Var_CAT 		DECIMAL(14,4),
	NumTransaccion     	BIGINT(20)
)
TerminaStore: BEGIN

	DECLARE Var_Centesima 		DOUBLE;
    DECLARE Var_Milesima 		DOUBLE;
    DECLARE Var_CenDos			DOUBLE;
	DECLARE	Var_Cre_NumPag		INT;
	DECLARE	Var_cuota			DOUBLE;
	DECLARE Var_Xn				DOUBLE;
    DECLARE Var_CuotaMax		FLOAT;
	DECLARE	Var_control			FLOAT;
	DECLARE	Var_control1		FLOAT;
	DECLARE	Var_sumXn			FLOAT;
	DECLARE Var_ValorGaranAct	FLOAT;
    DECLARE Var_RendGaran		FLOAT;
	DECLARE	Var_Cre_Period		FLOAT;
	declare numero				INT(11);
	DECLARE Var_SalidaCiclo 	BIGINT;
	DECLARE Var_SI          	CHAR(1);
	DECLARE Est_Cancelada   	CHAR(1);
	DECLARE No_Asignada			CHAR(1);
	DECLARE Var_RequiereGL		CHAR(1);
	DECLARE Var_PorcGarLiq		DECIMAL(12,2);
	DECLARE Var_ValorGaran   	DECIMAL(14,2);
	DECLARE Var_CalificaCredito CHAR(1);
	DECLARE Decimal_Cero 		DECIMAL(14,2);
	DECLARE Decimal_Uno 		DECIMAL(14,2);
	DECLARE Var_AbonoAcumulado  DECIMAL(14,2);
	DECLARE Var_InteresNormal   DECIMAL(14,2);
	DECLARE Var_TasaGarantia    DECIMAL(12,2);
	DECLARE Var_TipoPersona     CHAR(1);
	DECLARE PagosLibres         CHAR(1);
	DECLARE Var_NumPagos       INT;
	DECLARE DiasAnio       		INT;
	DECLARE DiasAnioCom       	INT;
	DEClARE DiasCred	        INT;
	DECLARE Con_Cadena_Vacia    VARCHAR(1);
	DECLARE Con_Fecha_Vacia		DATE;
	DECLARE Con_Entero_Cero		INT(11);
	DECLARE Var_ValCien			INT(11);
	DECLARE	Salida_SI			CHAR(1);
	DECLARE Entero_Cero         INT;

	DECLARE Var_ConCat			INT;
	DECLARE Var_ConAjusCat		INT;
	
	DECLARE FormaFinanciado		CHAR(1);					-- valida forma de pago Financiado
    DECLARE Var_Xn_1            DOUBLE;
    DECLARE Var_sumXn_1         FLOAT;
    DECLARE Var_Fxn             FLOAT;
    DECLARE Var_Fxn_1           FLOAT;
    DECLARE Var_Xn1             DOUBLE;
    DECLARE Var_precision       DOUBLE;
    DECLARE Cons_No             CHAR(1);
	DECLARE Var_CreditoID       BIGINT(12);                 -- Numero de Credito
	DECLARE Var_MontoAccesorioF	DECIMAL(12,2);				-- monto acesorios Financiado
    DECLARE Var_MontoIvaAccesoF	DECIMAL(12,2);			    -- monto acesorios IVA Financiado

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
       SET Var_CAT		:= 0.0;
    END;

	SET Con_Cadena_Vacia	:= '';
	SET Con_Fecha_Vacia		:= '1900-01-01';
	SET Var_ValCien			:= 100;
	SET Salida_SI			:= 'S';

	SET No_Asignada			:= 'N';				-- calificacion NO asignada al cliente
	SET Decimal_Cero        := 0.0;             -- DECIMAL Cero
    SET Decimal_Uno			:= 1.00;
	SET Var_InteresNormal   := 0.0;
	SET Var_TasaGarantia    := 0.0;
	SET Var_SI              := 'S';
    SET Var_NumPagos		:=	1;
	SET Est_Cancelada       := 'C';
	SET Var_Centesima		:= 0.01;
    SET Var_Milesima		:= 0.001;
	SET Var_CenDos			:= 0.02;
	SET Var_Cre_NumPag		:= 1;
	SET Var_CAT				:= 0.0;
	SET Entero_Cero         := 0;
	SET DiasAnio			:= 360;
    SET DiasAnioCom			:= 360;
	SET SQL_SAFE_UPDATES 	:= 0;

    SET FormaFinanciado     := 'F';     	-- Forma de cobro Financiado
    SET Var_Xn_1            := 1;			-- variables calculo de CAT
    SET Var_precision       := 0.0000001;	-- variables calculo de CAT
    SET Cons_No             := 'N'; 		-- contante NO


	DELETE FROM TMPCUOTASCALCAT WHERE TmpNumTransaccion = NumTransaccion;
	SET Var_cuota:=Par_ValorCuota;

	-- Llena la tabla TMPCUOTASCALCAT con los montos del credito

	INSERT INTO TMPCUOTASCALCAT VALUES (NumTransaccion, Var_Cre_NumPag,ifnull(Var_cuota, Entero_Cero),Entero_Cero,Entero_Cero);

      IF( (Par_ClienteID = Entero_Cero) OR (Par_ProdCredID = Entero_Cero) ) THEN
			SET Var_PorcGarLiq := Decimal_Cero;
			SET Var_ValorGaran := Decimal_Cero;
        ELSE
        -- Obtenemos el monto de la garantia liquida, si lo requiere el producto de credito
        SET Var_RequiereGL:= (SELECT IFNULL(Garantizado,No_Asignada) FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProdCredID);
            -- si el producto de credito no requiere GL, guardara ceros
            IF(Var_RequiereGL = No_Asignada)THEN
					SET	Var_PorcGarLiq:= Decimal_Cero;
					SET Var_ValorGaran := Decimal_Cero;
                    SET Var_RendGaran  := Decimal_Cero;
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

				SET Var_ValorGaran :=  round((Par_MontoCredito * Var_PorcGarLiq) / Var_ValCien,2);
				SET Var_ValorGaran := ifnull(Var_ValorGaran,Decimal_Cero);
                SET Var_RendGaran  := (Var_ValorGaran *Var_CenDos * DiasAnioCom) /DiasAnio;

          END IF;
		END IF;

            SELECT TipoPersona INTO Var_TipoPersona  FROM CLIENTES WHERE ClienteID = Par_ClienteID;
            -- Obtenemos la Tasa de Interes sobre la garantia liquida

			SET Var_TasaGarantia := Par_Tasa/Var_ValCien;
			SET DiasCred	:= (SELECT sum(TC.Tmp_Dias) FROM TMPPAGAMORSIM TC WHERE TC.NumTransaccion = NumTransaccion);
			SET Var_Cre_Period :=  DiasCred/ DiasAnioCom;

            IF Var_TasaGarantia > Entero_Cero THEN
					SET Var_InteresNormal := (Par_MontoCredito * Var_TasaGarantia * DiasCred) / DiasAnio;
					SET Var_AbonoAcumulado :=  Var_cuota + Var_InteresNormal;
			END IF;

        -- Actualizamos la primera amortizacion sumandole el monto obtenido de comisiones ( Garantia liquida + intereses + Comisión Anual Linea Crédito)
        UPDATE TMPCUOTASCALCAT SET TmpCuoMonto = (Var_AbonoAcumulado+Par_ComAnualLin) WHERE TmpNumTransaccion = NumTransaccion and  TmpCuoNumero = 1 ;
        
        
        ##VALIDAMOS  SI ES DE ALTA DE CREDITO

        SELECT  CreditoID 
            INTO Var_CreditoID
        FROM DETALLEACCESORIOS DETALLE
            INNER JOIN CREDITOS USING (CreditoID)  
        WHERE ClienteID = Par_ClienteID 
            AND DETALLE.NumTransaccion=NumTransaccion LIMIT 1;

        SET Var_CreditoID  := IFNULL(Var_CreditoID, Entero_Cero);
                
        IF Var_CreditoID  !=  Entero_Cero THEN
        # OBTENEMOS EL CALCULO DEL MONTO ACCESORIOS PARA CALCULAR EL CAT  FINANCIAMIENTO  POR AMORTIZACIONES  	

            SELECT	SUM(MontoCuota)AS MontoCuota,SUM(MontoIVACuota) AS MontoIVACuota
                INTO Var_MontoAccesorioF,		Var_MontoIvaAccesoF
            FROM   DETALLEACCESORIOS DETALLE
                INNER JOIN ACCESORIOSCRED Acc ON DETALLE.AccesorioID=Acc.AccesorioID 
            WHERE DETALLE.NumTransaccion=NumTransaccion
                AND DETALLE.CreditoID = Var_CreditoID
                AND  Acc.CAT = Var_SI
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
                AND  Acc.CAT = Var_SI
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
			-- Asignamos valor al cat para las iteraciones
			SET Var_Xn:= 0.5;
		   
       
            -- REALIZAMOS LA PRIMER ITERACION

            UPDATE TMPCUOTASCALCAT  SET TmpCuo_Xn = TmpCuoMonto /( power( (Decimal_Uno + Var_Xn),(Var_Cre_Period )))
            WHERE TmpNumTransaccion = NumTransaccion;

            UPDATE TMPCUOTASCALCAT  SET TmpCuo_Xn_1 = TmpCuoMonto /( power( (Decimal_Uno + Var_Xn_1),(Var_Cre_Period )))
            WHERE TmpNumTransaccion = NumTransaccion;

            SET Var_ValorGaranAct := Var_ValorGaran /( power( (Decimal_Uno + Var_Xn),(Var_Cre_Period )));


            SET Var_sumXn := (SELECT TmpCuo_Xn FROM TMPCUOTASCALCAT WHERE TmpNumTransaccion = NumTransaccion)+Var_ValorGaran-Var_ValorGaranAct;
            SET Var_sumXn_1 := (SELECT sum(TmpCuo_Xn_1) FROM TMPCUOTASCALCAT WHERE TmpNumTransaccion = NumTransaccion)+Var_ValorGaran-Var_ValorGaranAct;
            SET Var_Fxn := Par_MontoCredito - Var_sumXn;
            SET Var_Fxn_1 := Par_MontoCredito - Var_sumXn_1;

            SET Var_SalidaCiclo := Entero_Cero;


            CICLOWHILE: LOOP
                WHILE abs(Var_Fxn) > Var_precision  DO
                    SET Var_SalidaCiclo := Var_SalidaCiclo + 1;

                    SET Var_Xn1     := Var_Xn - ( ( (Var_Xn - Var_Xn_1) * Var_Fxn ) / ( Var_Fxn - Var_Fxn_1 ) );
                    SET Var_Xn_1    := Var_Xn;
                    SET Var_Xn      := Var_Xn1;

                    UPDATE TMPCUOTASCALCAT
                    SET TmpCuo_Xn = TmpCuoMonto /( power( (1.00 + Var_Xn),(Var_Cre_Period  )))
                    WHERE TmpNumTransaccion = NumTransaccion;

                    UPDATE TMPCUOTASCALCAT
                    SET TmpCuo_Xn_1 = TmpCuoMonto /( power( (1.00 + Var_Xn_1),( Var_Cre_Period  )))
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
