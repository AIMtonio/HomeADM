-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRERECPAGLIBREFPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRERECPAGLIBREFPRO`;
DELIMITER $$


CREATE PROCEDURE `CRERECPAGLIBREFPRO`(
    /* SP PARA RECALCULAR LOS INTERESES CON REFINANCIAMIENTO DE LAS AMORTIZACIONES EN PAGOS LIBRES */
    Par_Monto                   DECIMAL(12,2),          /* Monto solicitado*/
    Par_Tasa                    DECIMAL(12,4),          /* Tasa fija*/
    Par_ProducCreditoID         INT(11),                /* Producto de Credito sirve para determinar si paga o no iva*/
    Par_ClienteID               INT(11),                /* Cliente sirve para determinar si paga o no iva*/
    Par_ComAper                 DECIMAL(12,2),          /* Monto de la comision por apertura*/

    Par_CobraSeguroCuota        CHAR(1),                -- Cobra Seguro por cuota
    Par_CobraIVASeguroCuota     CHAR(1),                -- Cobra IVA Seguro por cuota
    Par_MontoSeguroCuota        DECIMAL(12,2),         -- Monto Seguro por Cuota
    Par_ComAnualLin     DECIMAL(12,2),          -- Monto Comisión por Anualidad Línea de Crédito
    Par_Salida                  CHAR(1),                /* Indica si hay una salida o no */
    INOUT   Par_NumErr          INT(11),

    INOUT   Par_ErrMen          VARCHAR(400),
    Aud_EmpresaID               INT(11),                -- Parametros de auditoria
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),

    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(11)
    )

TerminaStore: BEGIN

    /* Declaracion de constantes */
    DECLARE Decimal_Cero            DECIMAL(12,2);
    DECLARE Entero_Cero             INT;
    DECLARE Fecha_Vacia             DATE;
    DECLARE Entero_Negativo         INT;
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Var_SI                  CHAR(1);
    DECLARE Var_No                  CHAR(1);
    DECLARE Var_Capital             CHAR(1);
    DECLARE Var_Interes             CHAR(1);
    DECLARE Var_CapInt              CHAR(1);
    DECLARE ComApDeduc              CHAR(1);
    DECLARE ComApFinan              CHAR(1);

    /* Declaracion de Variables */
    DECLARE Contador                INT(11);
    DECLARE Consecutivo             INT(11);
    DECLARE ContadorInt             INT(11);
    DECLARE ContadorCap             INT(11);
    DECLARE FechaInicio             DATE;
    DECLARE FechaFinal              DATE;
    DECLARE FechaInicioInt          DATE;
    DECLARE FechaFinalInt           DATE;
    DECLARE Var_Cuotas              INT(11);
    DECLARE Var_CuotasInt           INT(11);
    DECLARE Capital                 DECIMAL(12,2);
    DECLARE Interes                 DECIMAL(14,4);
    DECLARE IvaInt                  DECIMAL(12,4);
    DECLARE Subtotal                DECIMAL(12,2);
    DECLARE Insoluto                DECIMAL(14,2);
    DECLARE Var_IVA                 DECIMAL(12,4);
    DECLARE Fre_DiasAnio            INT(11);
    DECLARE Fre_Dias                INT(11);
    DECLARE Fre_DiasInt             INT(11);
    DECLARE Var_ProCobIva           CHAR(1);
    DECLARE Var_CtePagIva           CHAR(1);
    DECLARE Var_PagaIVA             CHAR(1);
    DECLARE CapInt                  CHAR(1);
    DECLARE Var_InteresAco          DECIMAL(12,4);
    DECLARE Var_CoutasAmor          VARCHAR(8000);
    DECLARE Var_CAT                 DECIMAL(18,4);
    DECLARE Var_FrecuPago           INT(11);
    DECLARE Par_FechaVenc           DATE;
    DECLARE MtoSinComAp             DECIMAL(12,2);
    DECLARE CuotaSinIva             DECIMAL(12,2);
    DECLARE NumPag                  INT(11);
    DECLARE Var_Control             VARCHAR(100);       # Variable de control
    DECLARE Var_TotalCap            DECIMAL(14,2);
    DECLARE Var_TotalInt            DECIMAL(14,2);
    DECLARE Var_TotalIva            DECIMAL(14,2);
    # SEGUROS
    DECLARE Var_SeguroCuota         DECIMAL(12,2);      # Monto que cobra por seguro por cuota
    DECLARE Var_IVASeguroCuota      DECIMAL(12,2);      # Monto que cobrara por IVA
    DECLARE Var_TotalSeguroCuota    DECIMAL(12,2);      # Total de seguro cuota
    DECLARE Var_TotalIVASeguroCuota DECIMAL(12,2);      # Total de iva seguro cuota

    DECLARE Var_MontoMinistra       DECIMAL(18,2);      # Monto Ministrar
    DECLARE Var_FechaMinistra       DATE;               # Fecha Ministracion
    DECLARE Var_FechaInicio         DATE;               # Fecha de Inicio de la Amortizacion
    DECLARE Var_FechaFin            DATE;               # Fecha de Fin de la Amortizacion
    DECLARE Var_FechaCorte          DATE;               # Fecha de Corte

    DECLARE Var_Dias                INT(11);
    DECLARE Var_InteresCalculado    DECIMAL(18,2);      # Interes Calculado
    DECLARE Var_InteresAcumulado    DECIMAL(18,2);      # Interes Acumulado
    DECLARE Var_InteresTotal        DECIMAL(18,2);      # Interes Total
    DECLARE Var_NumMinis            INT(11);

    DECLARE Var_MontoInsoluto       DECIMAL(18,2);      # Monto Insoluto
    DECLARE Var_MesFechaInicio      INT(11);            # Mes de la fecha de inicio
    DECLARE Var_MesFechaCorte       INT(11);            # Mes de la fecha de corte
    DECLARE Var_MesFechaMinistra    INT(11);            # Mes de la fecha de Ministracion
    DECLARE Var_NumeroAmorPend      INT(11);            # Numero pendiente de amortizaciones

    DECLARE Var_FinMesAmor          DATE;
    DECLARE Var_MinistAmor          DATE;           # Numero de Ministraciones
    DECLARE CuentaNegativos         INT(11);
    DECLARE AmortiFallida           INT(11);

    -- asignacion de constantes
    SET Decimal_Cero            := 0.00;
    SET Entero_Cero             := 0;
    SET Fecha_Vacia             := '1900-01-01';
    SET Entero_Negativo         := -1;
    SET Cadena_Vacia            := '';
    SET Var_SI                  := 'S';
    SET Var_No                  := 'N';
    SET Var_Capital             := 'C';
    SET Var_Interes             := 'I';
    SET Var_CapInt              := 'G';
    SET ComApDeduc              :='D';
    SET ComApFinan              :='F';

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
            'Disculpe las molestias que esto le ocasiona. Ref: SP-CRERECPAGLIBREFPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;


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
        SET Var_ProCobIva           := (SELECT CobraIVAInteres FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProducCreditoID);


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

        #  Al inicio, el saldo Insoluto será el monto ministrado de la primera ministracion
        SET Insoluto := IFNULL((SELECT  M.Capital
                                    FROM MINISTRACREDAGRO M
                                    WHERE  M.TransaccionID = Aud_NumTransaccion
                                     AND M.Numero = 1),Decimal_Cero);

        -- Se considera que no hay ministraciones en el caso de creditos contingentes
        IF(Insoluto <=Decimal_Cero)THEN
            SET Insoluto:=Par_Monto;
        END IF;

        SELECT Tmp_FrecuPago INTO Var_FrecuPago
                FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = 1
                    AND NumTransaccion = Aud_NumTransaccion;

        SET Var_FrecuPago := IFNULL(Var_FrecuPago,Entero_Cero);

        SET Contador := 1;
        SELECT MAX(Tmp_Consecutivo) INTO ContadorInt
            FROM TMPPAGAMORSIM
            WHERE NumTransaccion = Aud_NumTransaccion;

        SET Var_InteresCalculado := IFNULL(Var_InteresCalculado, Decimal_Cero);
        SET Var_InteresAcumulado := IFNULL(Var_InteresAcumulado, Decimal_Cero);
        SET Var_InteresTotal     := IFNULL(Var_InteresTotal, Decimal_Cero);
        SET Interes              := IFNULL(Interes, Decimal_Cero);
        SET Var_InteresAco       := IFNULL(Var_InteresAco, Decimal_Cero);
        SET Var_FechaMinistra    := IFNULL(Var_FechaMinistra, Fecha_Vacia);
        SET Var_MontoMinistra    := IFNULL(Var_MontoMinistra, Decimal_Cero);


        WHILE (Contador <= ContadorInt) DO
            SET Var_InteresCalculado := Decimal_Cero;
            SET Var_InteresAcumulado := Decimal_Cero;
            SET Var_InteresTotal     := Decimal_Cero;
            SET Interes              := Decimal_Cero;
            SET Var_InteresAco       := Decimal_Cero;
            SET Var_InteresAco       := Decimal_Cero;
            SET Var_FechaMinistra    := Fecha_Vacia;
            SET Var_MontoMinistra    := Decimal_Cero;

            SELECT  Tmp_Dias,   Tmp_Capital,    Tmp_CapInt, Tmp_FecIni,         Tmp_FecFin
            INTO    Fre_Dias,   Capital,        CapInt,     Var_FechaInicio,    Var_FechaFin
                FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador
                    AND NumTransaccion = Aud_NumTransaccion;

            # Si es la primera amortizacion el Monto base sera el monto de la primera ministracion
            IF(Contador = 1) THEN
                SET Insoluto := Insoluto;
                SET Var_MontoInsoluto = Insoluto;
                SET Var_NumMinis := 2;
            END IF;

            # Se obtiene la fecha de corte
            SET Var_FechaCorte  := Var_FechaFin;
            SET Var_FechaCorte  := (SELECT LAST_DAY(Var_FechaInicio));

            IF (Var_FechaCorte > Var_FechaFin) THEN
                SET Var_FechaCorte := Var_FechaFin;
            ELSE
                SET Var_FechaCorte := Var_FechaCorte;
            END IF;

            WHILE (Var_FechaInicio < Var_FechaFin) DO
            SET Var_FechaMinistra    := Fecha_Vacia;
            SET Var_MinistAmor   := Fecha_Vacia;
             SET Var_MontoMinistra   := Decimal_Cero;

                # Se consulta si existen ministraciones en el rango de fechas.
                SELECT IFNULL(M.Capital,Decimal_Cero), M.FechaPagoMinis
                        INTO Var_MontoMinistra , Var_FechaMinistra
                            FROM MINISTRACREDAGRO M
                            WHERE  M.TransaccionID = Aud_NumTransaccion
                            AND FechaPagoMinis>=Var_FechaInicio
                            AND FechaPagoMinis<= Var_FechaCorte
                            AND M.Numero = Var_NumMinis ;

                 SET Var_MinistAmor := (SELECT M.FechaPagoMinis
                                        FROM MINISTRACREDAGRO M
                                        WHERE  M.TransaccionID = Aud_NumTransaccion
                                        AND M.Numero > Var_NumMinis
                                        AND FechaPagoMinis>=Var_FechaInicio
                                        AND FechaPagoMinis<=Var_FechaCorte
                                        ORDER BY M.FechaPagoMinis ASC
                                        LIMIT 1);

                SET Var_MontoMinistra   := IFNULL(Var_MontoMinistra, Decimal_Cero);
                SET Var_FechaMinistra   := IFNULL(Var_FechaMinistra, Fecha_Vacia);
                SET Var_MinistAmor      := IFNULL(Var_MinistAmor, Fecha_Vacia);

                # Se valida que la fecha de ministracion sea diferente de fecha vacia(Ocurre una ministracion)
                IF(Var_FechaMinistra <> Fecha_Vacia) THEN
                    # Fecha de ministracion es igual a la fecha de inicio
                    IF(Var_FechaMinistra = Var_FechaInicio) THEN
                        /* La fecha de ministracion es diferente a fecha vacia
                        (Hay otra ministracion en el rango de fecha inicio y fecha de corte */
                        IF(Var_MinistAmor <> Fecha_Vacia) THEN
                            # La fecha de corte es la siguiente ministracion
                            SET Var_FechaCorte := Var_MinistAmor;
                        ELSE
                            # Si ya no existe otra ministracion, la fecha de corte no cambia.
                            SET Var_FechaCorte := Var_FechaCorte;
                        END IF;

                    ELSE
                        # Si la fecha de ministracion es diferente a la fecha de inicio, la fecha de corte es la fecha de ministracion
                        SET Var_FechaCorte := Var_FechaMinistra;
                    END IF;
                ELSE
                    # No ocurren ministraciones y la fecha de corte no cambia
                    SET Var_FechaCorte := Var_FechaCorte;
                END IF;

                   # Si la fecha de ministracion es igual a la fecha de inicio.
                    IF(Var_FechaMinistra = Var_FechaInicio) THEN

                        SET Insoluto := Insoluto + Var_MontoMinistra;

                        SET Var_MontoInsoluto := Var_MontoInsoluto + Var_MontoMinistra;

                        SET Var_NumMinis = Var_NumMinis +1;

                    ELSE
                        # Si la fecha de ministracion no es igual a la fecha de inicio.
                        SET Insoluto := Insoluto;
                        SET Var_MontoInsoluto := Var_MontoInsoluto;
                    END IF;

                SET Var_MesFechaCorte  := (SELECT MONTH (Var_FechaCorte));
                 SET Var_MesFechaMinistra := (SELECT MONTH (Var_FechaMinistra));

                # Fin de mes de la fecha de corte
                 SET Var_FinMesAmor := (SELECT LAST_DAY(Var_FechaCorte));

                # La fecha de corte es igual a la fecha de FIN
                IF(((Var_FechaCorte = Var_FechaFin) OR (Var_FechaCorte = Var_FechaMinistra) OR (Var_FechaCorte = Var_MinistAmor)) AND (Var_FechaInicio <> Var_FechaCorte) ) THEN

                     SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero);

                ELSE
                     SET Var_Dias := IFNULL((DATEDIFF(Var_FechaCorte,Var_FechaInicio)),Entero_Cero)+1;
                    -- Se le suma un dia a la fecha de corte
                    SET Var_FechaCorte := (SELECT DATE_ADD(Var_FechaCorte,INTERVAL 1 DAY));

                END IF;

                # Si en la fecha de inicio ocurre una ministracion
                IF(Var_FechaInicio = Var_FechaMinistra) THEN

                    SET Interes        := (((Var_MontoInsoluto+Var_InteresAcumulado) * Par_Tasa * Var_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
                    SET Var_InteresCalculado := Interes;

                    # Si la fecha de corte es un fin de mes
                    IF(Var_FechaCorte = Var_FinMesAmor AND Var_MinistAmor = Fecha_Vacia) THEN
                         SET Var_InteresAcumulado := Var_InteresTotal + Interes;
                    ELSE
                        # Si la fecha de corte es menor al fin de mes
                        IF(Var_FechaCorte<=Var_FinMesAmor) THEN
                            # Si la fecha de corte es el fin de la amortizacion
                            IF(Var_FechaCorte = Var_FechaFin )THEN
                                SET Var_InteresAcumulado := Var_InteresTotal + Interes;
                            ELSE
                                #La fecha de corte no es el fin de la amortizacion
                                SET Var_InteresAcumulado := Var_InteresAcumulado;
                            END IF;
                        # Si la fecha es mayor al fin de mes
                         ELSE
                             SET Var_InteresAcumulado := Var_InteresTotal + Interes;
                         END IF;
                    END IF;

                    SET Var_InteresTotal := (Var_InteresTotal + Interes);

                    # Si la fecha de corte es un dia antes de la ministracion y ocurre una ministracion entre la fecha de inicio y la fecha de corte. Y la fecha de corte no es la fecha de fin de amortizacion
                ELSEIF((Var_FechaCorte = Var_FechaMinistra) AND (Var_MesFechaCorte = Var_MesFechaMinistra) AND (Var_FechaCorte <> Var_FechaFin)) THEN

                        SET Interes        := (((Var_MontoInsoluto+Var_InteresAcumulado) * Par_Tasa * Var_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
                        SET Var_InteresCalculado := Interes;
                        SET Var_InteresTotal := (Var_InteresTotal + Interes);
                        SET Var_InteresAcumulado := Var_InteresAcumulado; # El interes acumulado sera el acumulado del mes anterior sin sumarle los intereses

                    # Si no hay ministraciones
                ELSE

                    SET Interes   := (((Var_MontoInsoluto+Var_InteresAcumulado) * Par_Tasa * Var_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
                    SET Var_InteresCalculado := Interes;
                    SET Var_InteresTotal := (Var_InteresAcumulado + Interes);
                    SET Var_InteresAcumulado := Var_InteresAcumulado + Interes;

                END IF;

                # La fecha de corte es igual al fin de mes y la fecha de corte es diferente a la fecha de ministracion
                IF (Var_FechaCorte = Var_FinMesAmor AND Var_FechaCorte != Var_FechaMinistra AND Var_MinistAmor = Fecha_Vacia) THEN
                    SET Var_FechaInicio     := (SELECT DATE_ADD(Var_FechaCorte,INTERVAL 1 DAY));
                ELSE
                    #La fecha de inicio no es igual al fin de mes
                    SET Var_FechaInicio := Var_FechaCorte;
                END IF;


                SET Var_FechaCorte  := (SELECT LAST_DAY(Var_FechaInicio));
                # Validacion de fechas
                IF (Var_FechaCorte > Var_FechaFin) THEN
                    SET Var_FechaCorte := Var_FechaFin;

                ELSE
                    SET Var_FechaCorte := Var_FechaCorte;

                END IF;

            END WHILE;

            SET Interes = Var_InteresAcumulado;
            IF (Var_PagaIVA = Var_Si) THEN
                SET IvaInt    := Interes * Var_IVA;
            ELSE
                SET IvaInt := Decimal_Cero;
            END IF;

            SET Subtotal    := Capital + Interes + IvaInt;
            SET Insoluto    := Insoluto - Capital;
            SET Var_MontoInsoluto    := Var_MontoInsoluto - Capital;

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
                Par_Monto,      Par_Monto,      Var_FrecuPago,      Var_No,     Par_ProducCreditoID,
                        Par_ClienteID,      Par_Tasa,       Par_ComAnualLin,    Var_CAT,    Aud_NumTransaccion);
             ELSE
                -- se ejecuta el sp que calcula el cat
                SET Var_FrecuPago := 0;
                CALL CALCULARCATPAGLIBPRO(
            Par_Monto,      Var_CoutasAmor,     Var_FrecuPago,      Var_No,     Par_ProducCreditoID,
                        Par_ClienteID,      Par_ComAper,        Par_ComAnualLin,    Var_CAT,    Aud_NumTransaccion);
            END IF;


        /* -- se determina cual es la fecha de vencimiento*/
        SET Par_FechaVenc := (SELECT MAX(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE     NumTransaccion = Aud_NumTransaccion);
        SET Var_Cuotas:= (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Capital OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);
        SET Var_CuotasInt:=(SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Interes OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);

        /*se actualiza el numero de cuotas de capital, de interes y el CAT generado*/
        UPDATE TMPPAGAMORSIM SET
            Tmp_CuotasCap           = Var_Cuotas,
            Tmp_CuotasInt           = Var_CuotasInt,
            Tmp_Cat                 = Var_CAT
        WHERE NumTransaccion = Aud_NumTransaccion;

        SELECT SUM(Tmp_Capital),SUM(Tmp_Interes),   SUM(Tmp_Iva), SUM(Tmp_MontoSeguroCuota), SUM(Tmp_IVASeguroCuota)
            INTO Var_TotalCap,  Var_TotalInt,       Var_TotalIva, Var_TotalSeguroCuota, Var_TotalIVASeguroCuota
            FROM TMPPAGAMORSIM
            WHERE   NumTransaccion = Aud_NumTransaccion;

        SET Var_TotalSeguroCuota := IFNULL(Var_TotalSeguroCuota,Decimal_Cero);
        SET Var_TotalIVASeguroCuota := IFNULL(Var_TotalIVASeguroCuota, Decimal_Cero);

        SELECT COUNT(*) INTO CuentaNegativos
        FROM TMPPAGAMORSIM
        WHERE NumTransaccion = Aud_NumTransaccion
        AND (Tmp_Interes <= Decimal_Cero
        OR Tmp_Insoluto < Decimal_Cero);

        SET CuentaNegativos := IFNULL(CuentaNegativos, Entero_Cero);

        IF (CuentaNegativos > Entero_Cero) THEN

            SELECT Tmp_Consecutivo INTO AmortiFallida FROM TMPPAGAMORSIM 
            WHERE NumTransaccion = Aud_NumTransaccion
            AND (Tmp_Interes <= Decimal_Cero
            OR Tmp_Insoluto < Decimal_Cero) LIMIT 1;

            SET AmortiFallida := IFNULL(AmortiFallida, Entero_Cero);

            IF (AmortiFallida <> Entero_Cero) THEN 
                SET Par_NumErr := 007;
                SET Par_ErrMen := CONCAT('LA Amortizacion ',AmortiFallida,' Se simulo Sin Capital. Ajuste las Fechas de Vencimiento o Modifique la Fecha de Ministracion.');
            ELSE 
                SET Par_NumErr := 007;
                SET Par_ErrMen := 'Existen Amortizaciones sin Capital. Ajuste las Fechas de Vencimiento o Modifique la Fecha de Ministracion.';
            END IF;
            LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr    := 0;
        SET Par_ErrMen    := 'Simulacion Exitosa';

    END ManejoErrores;

    IF (Par_Salida = Var_SI) THEN
        IF(Par_NumErr = Entero_Cero OR Par_NumErr = 007) THEN
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
               Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen;

        END IF;
    END IF;

END TerminaStore$$
