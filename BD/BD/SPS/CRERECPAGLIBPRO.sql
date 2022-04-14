-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRERECPAGLIBPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRERECPAGLIBPRO`;
DELIMITER $$


CREATE PROCEDURE `CRERECPAGLIBPRO`(
    /* sp para recalcular las amortizaciones en pagos libres */
    Par_Monto                   DECIMAL(12,2),          /* Monto solicitado*/
    Par_Tasa                    DECIMAL(12,4),          /* Tasa fija*/
    Par_ProducCreditoID         INT(11),                /* Producto de Credito sirve para determinar si paga o no iva*/
    Par_ClienteID               INT(11),                /* Cliente sirve para determinar si paga o no iva*/
    Par_ComAper                 DECIMAL(12,2),          /* Monto de la comision por apertura*/

    Par_CobraSeguroCuota        CHAR(1),                -- Cobra Seguro por cuota
    Par_CobraIVASeguroCuota     CHAR(1),                -- Cobra IVA Seguro por cuota
    Par_MontoSeguroCuota        DECIMAL(12,2),         -- Monto Seguro por Cuota
    Par_ComAnualLin				DECIMAL(12,2), -- Monto de la Comisión Anual de Línea de Crédito
    Par_Salida                  CHAR(1),                /* Indica si hay una salida o no */

    INOUT   Par_NumErr          INT(11),
    INOUT   Par_ErrMen          VARCHAR(400),
    Aud_EmpresaID               INT(11),
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,

    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(11)
	)

TerminaStore: BEGIN

    /* declaracion de constantes */
    DECLARE Decimal_Cero            DECIMAL(12,2);
    DECLARE Entero_Cero             INT;
    DECLARE Entero_Negativo         INT;
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Var_SI                  CHAR(1);
    DECLARE Var_No                  CHAR(1);
    DECLARE Var_Capital             CHAR(1);
    DECLARE Var_Interes             CHAR(1);
    DECLARE Var_CapInt              CHAR(1);
    DECLARE ComApDeduc              CHAR(1);
    DECLARE ComApFinan              CHAR(1);
	DECLARE Llave_CobraAccesorios	VARCHAR(100); 		-- Llave para consulta el valor de Cobro de Accesorios

    /* declaracion de Variables */
    DECLARE Contador                INT;
    DECLARE Consecutivo             INT;
    DECLARE ContadorInt             INT;
    DECLARE ContadorCap             INT;
    DECLARE FechaInicio             DATE;
    DECLARE FechaFinal              DATE;
    DECLARE FechaInicioInt          DATE;
    DECLARE FechaFinalInt           DATE;
    DECLARE Var_Cuotas              INT;
    DECLARE Var_CuotasInt           INT;
    DECLARE Capital                 DECIMAL(12,2);
    DECLARE Interes                 DECIMAL(12,4);
    DECLARE IvaInt                  DECIMAL(12,4);
    DECLARE Subtotal                DECIMAL(12,2);
    DECLARE Insoluto                DECIMAL(12,2);
    DECLARE Var_IVA                 DECIMAL(12,4);
    DECLARE Fre_DiasAnio            INT;
    DECLARE Fre_Dias                INT;
    DECLARE Fre_DiasInt             INT;
    DECLARE Var_ProCobIva           CHAR(1);
    DECLARE Var_CtePagIva           CHAR(1);
    DECLARE Var_PagaIVA             CHAR(1);
    DECLARE CapInt                  CHAR(1);
    DECLARE Var_InteresAco          DECIMAL(12,4);
    DECLARE Var_CoutasAmor          VARCHAR(8000);
    DECLARE Var_CAT                 DECIMAL(18,4);
    DECLARE Var_FrecuPago           INT;
    DECLARE Par_FechaVenc           DATE;
    DECLARE MtoSinComAp             DECIMAL(12,2);
    DECLARE CuotaSinIva             DECIMAL(12,2);
    DECLARE NumPag                  INT;
    DECLARE Var_Control                             VARCHAR(100);               -- Variable de control
    DECLARE Var_TotalCap                            DECIMAL(14,2);
    DECLARE Var_TotalInt                            DECIMAL(14,2);
    DECLARE Var_TotalIva                            DECIMAL(14,2);
    # SEGUROS
    DECLARE Var_SeguroCuota                         DECIMAL(12,2);              -- Monto que cobra por seguro por cuota
    DECLARE Var_IVASeguroCuota                      DECIMAL(12,2);              -- Monto que cobrara por IVA
    DECLARE Var_TotalSeguroCuota                    DECIMAL(12,2);              -- Total de seguro cuota
    DECLARE Var_TotalIVASeguroCuota                 DECIMAL(12,2);              -- Total de iva seguro cuota

    DECLARE Var_CobraAccesorios						CHAR(1);					-- Indica si la solicitud cobra accesorios
	DECLARE Var_SaldoOtrasComisiones				DECIMAL(14,2);				-- Saldo de Otras Comisiones
    DECLARE Var_SaldoIVAOtrasComisiones				DECIMAL(14,2);				-- Saldo IVA Otras Comisiones

	DECLARE Var_PlazoID								INT(11);					-- Plazo del credito
    DECLARE Var_SolicitudCreditoID					BIGINT(20);					-- Numero de Solicitud de Credito
    DECLARE Var_CreditoID							BIGINT(12);					-- Numero de Credito
	DECLARE Var_CobraAccesoriosGen					CHAR(1);					-- Valor del Cobro de Accesorios
    -- asignacion de constantes
    SET Decimal_Cero            := 0.00;
    SET Entero_Cero             := 0;
    SET Entero_Negativo         := -1;
    SET Cadena_Vacia            := '';
    SET Var_SI                  := 'S';
    SET Var_No                  := 'N';
    SET Var_Capital             := 'C';
    SET Var_Interes             := 'I';
    SET Var_CapInt              := 'G';
    SET ComApDeduc              :='D';
    SET ComApFinan              :='F';
    SET Llave_CobraAccesorios	:= 'CobraAccesorios'; 	-- Llave para Consultar Si Cobra Accesorios

    -- declaracion de variables
    SET Contador                := 1;
    SET ContadorInt             := 1;
    SET Var_CoutasAmor          := '';
    SET Var_CAT                 := 0.00;
    SET Var_FrecuPago           := 0;
    SET MtoSinComAp             := 0.00;
    SET CuotaSinIva             := 0;

    ManejoErrores:BEGIN     #bloque para manejar los posibles errores no controlados del codigo
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr    := 999;
            SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-CRERECPAGLIBPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;

		SELECT CobraIVAInteres
					INTO Var_ProCobIva
					FROM PRODUCTOSCREDITO
						WHERE ProducCreditoID = Par_ProducCreditoID;

		SET Var_ProCobIva := IFNULL(Var_ProCobIva, 'N');

		-- Se obtiene el valor de si se realiza o no el cobro de accesorios
		SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
		SET Var_CobraAccesoriosGen := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);


        SET Var_CobraAccesorios := (SELECT CobraAccesorios FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProducCreditoID);
        SET Var_CobraAccesorios := IFNULL(Var_CobraAccesorios, Cadena_Vacia);

        SET Par_CobraSeguroCuota := IFNULL(Par_CobraSeguroCuota, Var_No);

        IF(IFNULL(Par_CobraSeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 004;
            SET Par_ErrMen := 'El Producto de Credito no Especifica si Cobra Seguro por Cuota.';
            LEAVE ManejoErrores;
          ELSE
            IF(Par_CobraSeguroCuota = Var_SI) THEN
                IF(IFNULL(Par_CobraIVASeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
                    SET Par_NumErr := 005;
                    SET Par_ErrMen := 'El Producto de Credito no Especifica si Cobra IVA por Seguro por Cuota.';
                    LEAVE ManejoErrores;
                END IF;
                IF(IFNULL(Par_MontoSeguroCuota,Entero_Cero)= Entero_Cero) THEN
                    SET Par_NumErr := 006;
                    SET Par_ErrMen := 'El Monto para el Seguro por Cuota Esta Vacio.';
                    LEAVE ManejoErrores;
                END IF;
              ELSE
                SET Par_MontoSeguroCuota := Decimal_Cero;
                SET Var_TotalSeguroCuota := Decimal_Cero;
                SET Var_TotalIVASeguroCuota := Decimal_Cero;
            END IF;
        END IF;

        SET Var_IVA                 := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
        SET Fre_DiasAnio            := (SELECT DiasCredito FROM PARAMETROSSIS);

        SELECT PagaIVA INTO Var_CtePagIva
            FROM CLIENTES
            WHERE ClienteID = Par_ClienteID;


        IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Var_CtePagIva     := Var_Si;
        END IF;

        IF (Var_ProCobIva = Var_Si) THEN
            IF (Var_CtePagIva = Var_Si) THEN
                SET Var_PagaIVA        := Var_Si;
            END IF;
        ELSE
            SET Var_PagaIVA        := Var_No;
        END IF;
        /***CALCULANDO IVA PARA SEGURO POR CUOTA***/
        IF(Par_CobraIVASeguroCuota = Var_Si) THEN
            SET Var_IVASeguroCuota :=  ROUND(Par_MontoSeguroCuota * Var_IVA,2);
          ELSE
            SET Var_IVASeguroCuota := Decimal_Cero;
        END IF;
         /***CALCULANDO IVA PARA SEGURO POR CUOTA***/

        SET Insoluto    := Par_Monto;

        SELECT Tmp_FrecuPago INTO Var_FrecuPago
                FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = 1
                    AND NumTransaccion = Aud_NumTransaccion;

        SET Var_FrecuPago := IFNULL(Var_FrecuPago,Entero_Cero);

        SET Contador := 1;
        SELECT MAX(Tmp_Consecutivo) INTO ContadorInt
            FROM TMPPAGAMORSIM
            WHERE NumTransaccion = Aud_NumTransaccion;
        WHILE (Contador <= ContadorInt) DO
            SELECT Tmp_InteresAco INTO  Var_InteresAco FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador-1 AND NumTransaccion = Aud_NumTransaccion ;

            SELECT Tmp_Dias, Tmp_Capital, Tmp_CapInt INTO Fre_Dias, Capital, CapInt
                FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador
                    AND NumTransaccion = Aud_NumTransaccion;

            SET Var_InteresAco := IFNULL(Var_InteresAco, Entero_Cero);

            IF (CapInt= Var_Interes) THEN
                SET Interes        := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
                SET Capital        := Decimal_Cero;
                SET Var_InteresAco := Entero_Cero;
            ELSE
                IF (CapInt= Var_CapInt) THEN
                    SET Interes    := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
                    SET Var_InteresAco := Entero_Cero;
                ELSE
                    SET Interes        := Decimal_Cero;
                    SET Var_InteresAco := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
                END IF;
            END IF;


            IF (Var_PagaIVA = Var_Si) THEN
                SET IvaInt    := Interes * Var_IVA;
            ELSE
                SET IvaInt := Decimal_Cero;
            END IF;

            SET Subtotal    := Capital + Interes + IvaInt;
            SET Insoluto    := Insoluto - Capital;

            SET CuotaSinIva := Capital + Interes;
            SET Var_CoutasAmor := CONCAT(Var_CoutasAmor,CuotaSinIva,',');


            UPDATE TMPPAGAMORSIM SET
                Tmp_Capital    = Capital,
                Tmp_Interes    = Interes,
                Tmp_Iva        = IvaInt,
                Tmp_SubTotal    = Subtotal,
                Tmp_Insoluto    = Insoluto,
                Tmp_InteresAco    = Var_InteresAco
            WHERE Tmp_Consecutivo = Contador
            AND NumTransaccion = Aud_NumTransaccion;

            IF((Contador+1) = ContadorInt)THEN
                SELECT Tmp_Dias, Tmp_Capital,  Tmp_CapInt INTO Fre_Dias, Capital, CapInt
                    FROM TMPPAGAMORSIM
                    WHERE Tmp_Consecutivo = Contador +1
                    AND NumTransaccion = Aud_NumTransaccion;

                SELECT Tmp_Insoluto, Tmp_InteresAco
                    INTO Insoluto, Var_InteresAco
                    FROM TMPPAGAMORSIM
                    WHERE Tmp_Consecutivo = Contador AND NumTransaccion=Aud_NumTransaccion;

                SET Var_InteresAco := IFNULL(Var_InteresAco, Entero_Cero);

                IF (CapInt= Var_Interes) THEN
                	SET Var_Cuotas:= (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Capital OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);
                	SET Var_Cuotas:= IFNULL(Var_Cuotas, Entero_Cero);

                	IF(Var_Cuotas > Entero_Cero)THEN
                    	SET Capital    := Par_Monto / Var_Cuotas;
                    ELSE
                    	SET Capital    := Entero_Cero;
                    END IF;

                    SET Capital    := Insoluto + Capital;
                    SET Subtotal    := Insoluto + Subtotal;
                    UPDATE TMPPAGAMORSIM SET
                        Tmp_Capital    = Capital,
                        Tmp_SubTotal    = Subtotal,
                        Tmp_Insoluto    = Insoluto-Insoluto
                    WHERE Tmp_Consecutivo = Contador-1
                    AND NumTransaccion=Aud_NumTransaccion;


                    SET Interes        := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
                    SET Capital        := Decimal_Cero;
                    SET Var_InteresAco := Entero_Cero;
                ELSE
                    IF (CapInt= Var_CapInt) THEN
                        SET Interes    := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
                        SET Capital    := Insoluto;
                        SET Var_InteresAco := Entero_Cero;
                    ELSE
                        SET Interes    := Decimal_Cero;
                        SET Capital    := Insoluto;
                        SET Var_InteresAco := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
                    END IF;
                END IF;


                SET Insoluto    := Insoluto - Capital;

                IF (Var_PagaIVA = Var_Si) THEN
                    SET IvaInt    := Interes * Var_IVA;
                ELSE
                    SET IvaInt := Decimal_Cero;
                END IF;
                SET Subtotal    := Capital + Interes + IvaInt;

                SET CuotaSinIva := Capital + Interes;

                SET Var_CoutasAmor := CONCAT(Var_CoutasAmor,CuotaSinIva);
                UPDATE TMPPAGAMORSIM SET
                    Tmp_Capital    = Capital,
                    Tmp_Interes    = Interes,
                    Tmp_Iva        = IvaInt,
                    Tmp_SubTotal    = Subtotal,
                    Tmp_Insoluto    = Insoluto,
                    Tmp_InteresAco    = Var_InteresAco
                WHERE Tmp_Consecutivo = Contador+1
                    AND NumTransaccion = Aud_NumTransaccion;
                SET Contador = Contador+1;
            END IF;
            SET Contador = Contador+1;
        END WHILE;


        SELECT MAX(Tmp_Consecutivo) INTO Consecutivo FROM TMPPAGAMORSIM
                    WHERE NumTransaccion = Aud_NumTransaccion;
        SELECT Tmp_Capital,Tmp_Interes, Tmp_CapInt INTO Capital, Interes, CapInt   FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Consecutivo AND NumTransaccion=Aud_NumTransaccion;
        IF ( Capital = Decimal_Cero AND Interes = Decimal_Cero ) THEN
            DELETE FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Consecutivo AND NumTransaccion=Aud_NumTransaccion;
            IF (CapInt= Var_Capital) THEN
                SET Var_Cuotas:=Var_Cuotas-1;
            ELSE IF (CapInt= Var_Interes) THEN
                    SET Var_CuotasInt:=Var_CuotasInt-1;
                ELSE
                    SET Var_Cuotas:=Var_Cuotas-1;
                    SET Var_CuotasInt:=Var_CuotasInt-1;
                END IF;
            END IF;

        END IF;
        -- si es pago unico se ejecuta sp pago unico
            SET NumPag:= (SELECT COUNT(TC.NumTransaccion) FROM TMPPAGAMORSIM TC WHERE TC.NumTransaccion = Aud_NumTransaccion);

            IF ( NumPag = 1)THEN
                     CALL CALCULARCATPAGUNIPRO(
		     	Par_Monto,		Par_Monto,		Var_FrecuPago,		Var_No,		Par_ProducCreditoID,
                        Par_ClienteID,		Par_Tasa,		Par_ComAnualLin,	Var_CAT,	Aud_NumTransaccion);
             ELSE
                -- se ejecuta el sp que calcula el cat
                SET Var_FrecuPago := 0;
                CALL CALCULARCATPAGLIBPRO(
			Par_Monto,		Var_CoutasAmor,		Var_FrecuPago,		Var_No,		Par_ProducCreditoID,
                        Par_ClienteID,		Par_ComAper,		Par_ComAnualLin,	Var_CAT,	Aud_NumTransaccion);
            END IF;

        --
        /* -- se determina cual es la fecha de vencimiento*/
        SET Par_FechaVenc := (SELECT MAX(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE     NumTransaccion = Aud_NumTransaccion);
        SET Var_Cuotas:= (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Capital OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);
        SET Var_CuotasInt:=(SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Interes OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);

        /*se actualiza el numero de cuotas de capital, de interes y el CAT generado*/
        UPDATE TMPPAGAMORSIM SET
            Tmp_CuotasCap           = Var_Cuotas,
            Tmp_CuotasInt           = Var_CuotasInt,
            Tmp_Cat                 = Var_CAT,
			Tmp_MontoSeguroCuota    = Par_MontoSeguroCuota,
			Tmp_IVASeguroCuota      = Var_IVASeguroCuota
        WHERE NumTransaccion = Aud_NumTransaccion;


		IF(Var_CobraAccesoriosGen = Var_SI AND Var_CobraAccesorios = Var_SI) THEN

			# SE CALCULA EL VALOR DE LAS COMISIONES COBRADAS POR EL CREDITO
			CALL CALCOTRASCOMISIONESPRO(
				Aud_NumTransaccion,		Par_ClienteID,		Par_ProducCreditoID,	Par_Monto,			Par_Tasa,
				Var_No,					Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
        END IF;

        SELECT SUM(Tmp_Capital),			SUM(Tmp_Interes),   		SUM(Tmp_Iva), SUM(Tmp_MontoSeguroCuota), SUM(Tmp_IVASeguroCuota),
			  SUM(Tmp_OtrasComisiones),		SUM(Tmp_IVAOtrasComisiones)

            INTO Var_TotalCap,  			Var_TotalInt,       		Var_TotalIva, Var_TotalSeguroCuota, 		Var_TotalIVASeguroCuota,
				Var_SaldoOtrasComisiones,	Var_SaldoIVAOtrasComisiones
            FROM TMPPAGAMORSIM
            WHERE   NumTransaccion = Aud_NumTransaccion;

        SET Var_TotalSeguroCuota 			:= IFNULL(Var_TotalSeguroCuota,Decimal_Cero);
        SET Var_TotalIVASeguroCuota	 		:= IFNULL(Var_TotalIVASeguroCuota, Decimal_Cero);
        SET Var_SaldoOtrasComisiones 		:= IFNULL(Var_SaldoOtrasComisiones, Decimal_Cero);
        SET Var_SaldoIVAOtrasComisiones 	:= IFNULL(Var_SaldoIVAOtrasComisiones, Decimal_Cero);

        SET Par_NumErr    := 0;
        SET Par_ErrMen    := 'Simulacion Exitosa';

    END ManejoErrores;

    IF (Par_Salida = Var_SI) THEN
        IF(Par_NumErr = Entero_Cero) THEN
            SELECT  Tmp_Consecutivo AS Consecutivo,         Tmp_FecIni AS FechaInicio,          Tmp_FecFin AS FechaVencim,
                Tmp_FecVig AS FechaExigible,            FORMAT(Tmp_Capital,2) AS Capital,   FORMAT(Tmp_Interes,2)AS Interes,
                FORMAT(Tmp_Iva,2) AS Iva,               FORMAT(Tmp_SubTotal,2)AS SubTotal,  FORMAT(Tmp_Insoluto,2) AS Insoluto,
                Tmp_Dias AS Dias,                       Tmp_CapInt,                         Aud_NumTransaccion,
                Tmp_CuotasCap AS CuotaCapital,          Tmp_CuotasInt AS CuotaInteres,      Var_CAT,
                Par_FechaVenc,
                Par_CobraSeguroCuota AS CobraSeguroCuota,
                FORMAT(Tmp_MontoSeguroCuota,2) AS MontoSeguroCuota,
                FORMAT(Tmp_IVASeguroCuota,2) AS IVASeguroCuota,
                Var_TotalSeguroCuota AS TotalSeguroCuota,
                Var_TotalIVASeguroCuota AS TotalIVASeguroCuota,
                Tmp_OtrasComisiones	AS OtrasComisiones,
				Tmp_IVAOtrasComisiones	AS IVAOtrasComisiones,
                Var_SaldoOtrasComisiones AS TotalOtrasComisiones,
                Var_SaldoIVAOtrasComisiones AS TotalIVAOtrasComisiones,
                Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen
            FROM    TMPPAGAMORSIM
            WHERE NumTransaccion = Aud_NumTransaccion;
          ELSE
            SELECT
               Entero_Cero AS Consecutivo,
               Cadena_Vacia AS FechaInicio,
               Cadena_Vacia AS FechaVencim,
               Cadena_Vacia AS FechaExigible,
               Entero_Cero  AS Capital,
               Entero_Cero AS Interes,
               Entero_Cero AS Iva,
               Entero_Cero AS SubTotal,
               Entero_Cero AS Insoluto,
               Entero_Cero AS Dias,
               Entero_Cero AS Tmp_CapInt,
               Aud_NumTransaccion,
               Entero_Cero AS CuotaCapital,
               Entero_Cero AS CuotaInteres,
               Var_CAT,
               Cadena_Vacia AS Par_FechaVenc,
               Cadena_Vacia AS CobraSeguroCuota,
               Entero_Cero AS MontoSeguroCuota,
               Entero_Cero AS IVASeguroCuota,
               Entero_Cero AS TotalSeguroCuota,
               Entero_Cero AS TotalIVASeguroCuota,
               Entero_Cero	AS OtrasComisiones,
			   Entero_Cero AS IVAOtrasComisiones,
			   Entero_Cero AS TotalOtrasComisiones,
               Entero_Cero AS TotalIVAOtrasComisiones,
               Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen;

        END IF;
    END IF;

END TerminaStore$$