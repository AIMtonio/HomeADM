-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOVERINTMORACREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOVERINTMORACREPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOVERINTMORACREPRO`(



    Par_CreditoID           BIGINT(12),
    Par_MontoPagar          DECIMAL(12,2),
    Par_ModoPago            CHAR(1),
    Par_CuentaAhoID         BIGINT(12),
    Par_Poliza              BIGINT,
    Par_OrigenPago          CHAR(1),        -- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida              CHAR(1),

    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    INOUT Par_MontoSaldo    DECIMAL(12,2),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )
TerminaStore: BEGIN


    DECLARE VarControl              CHAR(20);
    DECLARE Var_FechaSistema        DATE;
    DECLARE Var_FecAplicacion       DATE;
    DECLARE Var_MontoSaldo          DECIMAL(12,2);
    DECLARE Var_MontoPagar          DECIMAL(14, 4);

    DECLARE Var_MontoIVAPagar       DECIMAL(12, 2);
    DECLARE Var_IVA                 DECIMAL(12,2);
    DECLARE Var_IVAInteresOrdi      DECIMAL(12,2);
    DECLARE Var_IVAInteresMora      DECIMAL(12,2);
    DECLARE Var_PagaIVA             CHAR(1);

    DECLARE Var_CobraIVAInteres     CHAR(1);
    DECLARE Var_CobraIVAMora        CHAR(1);
    DECLARE Var_SucursalID          INT;
    DECLARE Var_ClienteID           INT(11);
    DECLARE Var_MonedaID            INT(11);

    DECLARE Var_ProducCreditoID     INT(11);
    DECLARE Var_ClasificaCredito    CHAR(1);
    DECLARE Var_SubClasifCredito    INT;
    DECLARE Var_Consecutivo         BIGINT;
    DECLARE Var_EstatusCredito      CHAR(1);

    DECLARE Var_CueClienteID        BIGINT;
    DECLARE Var_CueSaldo            DECIMAL(12,2);
    DECLARE Var_CueMoneda           INT;
    DECLARE Var_CueEstatus          CHAR(1);
    DECLARE Var_EsGrupal            CHAR(1);

    DECLARE Var_SolicitudCreditoID  BIGINT;
    DECLARE Var_GrupoID             INT;
    DECLARE Var_CicloActual         INT;
    DECLARE Var_GrupoCtaID          BIGINT(12);
    DECLARE Var_CicloGrupo          INT;

    DECLARE Var_AmortizacionID      INT(4);

    DECLARE Var_FechaInicio         DATE;
    DECLARE Var_FechaVencim         DATE;
    DECLARE Var_SaldoMoraVenci      DECIMAL(12, 2);
    DECLARE Var_SaldoMoratorios     DECIMAL(12, 2);



    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(4,2);
    DECLARE SalidaNO            CHAR(1);
    DECLARE SalidaSI            CHAR(1);

    DECLARE Estatus_Inactivo    CHAR(1);
    DECLARE Estatus_Vigente     CHAR(1);
    DECLARE Estatus_Atrasado    CHAR(1);
    DECLARE Estatus_Vencido     CHAR(1);
    DECLARE Estatus_Activo      CHAR(1);

    DECLARE Monto_MinimoPago    DECIMAL(12,2);
    DECLARE SiPagaIVA           CHAR(1);
    DECLARE Des_PagoCredito     VARCHAR(50);
    DECLARE EsGrupal_NO         CHAR(1);
    DECLARE Mov_Referencia      VARCHAR(50);



    DECLARE CURSORAMORTIZACIONES CURSOR FOR
        SELECT  AmortizacionID,         Amo.SaldoMoraVencido,   Amo.SaldoMoratorios,    Amo.FechaInicio,
                Amo.FechaVencim
        FROM AMORTICREDITO Amo
             INNER JOIN CREDITOS Cre ON (Amo.CreditoID = Cre.CreditoID)
             INNER JOIN CLIENTES Cli ON (Cre.ClienteID = Cli.ClienteID)
        WHERE Cre.CreditoID      =  Par_CreditoID
            AND (Amo.Estatus     =  Estatus_Vigente
                    OR Amo.Estatus =  Estatus_Atrasado
                    OR Amo.Estatus =  Estatus_Vencido)
            AND (Cre.Estatus       =  Estatus_Vigente
                    OR Cre.Estatus =  Estatus_Vencido)
        ORDER BY Amo.FechaInicio;



    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET SalidaNO            := 'N';
    SET SalidaSI            := 'S';
    SET Estatus_Inactivo    := 'P';
    SET Estatus_Vigente     := 'V';
    SET Estatus_Atrasado    := 'A';
    SET Estatus_Vencido     := 'B';
    SET Estatus_Activo      := 'A';
    SET Monto_MinimoPago    := 0.01;
    SET SiPagaIVA           := 'S';
    SET Des_PagoCredito     := 'PAGO DE CREDITO';
    SET EsGrupal_NO         := 'N';
    SET Mov_Referencia      := 'PAGO DE INTERES CON CARGO A CTA';
    SET Aud_ProgramaID      := 'PAGOCREDITOPRO';



    SET Var_MontoSaldo      := Par_MontoPagar;

    SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

    SET Var_FecAplicacion       := Var_FechaSistema;


    SELECT  Cli.ClienteID,      Cli.SucursalOrigen,     Cli.PagaIVA,            Pro.CobraIVAInteres,    Pro.CobraIVAMora,
            Cre.MonedaID,       Pro.ProducCreditoID,    Des.Clasificacion,      Des.SubClasifID,        Cre.Estatus,
            Pro.EsGrupal,       Cre.GrupoID,            Cre.SolicitudCreditoID, Cre.CicloGrupo
    INTO    Var_ClienteID,      Var_SucursalID,         Var_PagaIVA,            Var_CobraIVAInteres,    Var_CobraIVAMora,
            Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_EstatusCredito,
            Var_EsGrupal,       Var_GrupoID,            Var_SolicitudCreditoID, Var_CicloGrupo
    FROM CLIENTES Cli
        INNER JOIN CREDITOS Cre ON (Cli.ClienteID = Cre.ClienteID)
        INNER JOIN PRODUCTOSCREDITO Pro ON (Cre.ProductoCreditoID = Pro.ProducCreditoID)
        INNER JOIN DESTINOSCREDITO Des ON (Cre.DestinoCreID = Des.DestinoCreID)
        LEFT  JOIN REESTRUCCREDITO Res ON (Res.CreditoDestinoID = Cre.CreditoID)
    WHERE Cre.CreditoID = Par_CreditoID;



    IF (Var_PagaIVA = SiPagaIVA) THEN
        SET Var_IVA  := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucursalID);

        IF (Var_CobraIVAInteres = SiPagaIVA) THEN
            SET Var_IVAInteresOrdi  := Var_IVA;
        ELSE
            SET Var_IVAInteresOrdi  := Decimal_Cero;
        END IF;

        IF (Var_CobraIVAMora = SiPagaIVA) THEN
            SET Var_IVAInteresMora  := Var_IVA;
        ELSE
            SET Var_IVAInteresMora  := Decimal_Cero;
        END IF;
    END IF;
    SET Var_IVA             := IFNULL(Var_IVA,  Decimal_Cero);
    SET Var_IVAInteresOrdi  := IFNULL(Var_IVAInteresOrdi,  Decimal_Cero);
    SET Var_IVAInteresMora  := IFNULL(Var_IVAInteresMora,  Decimal_Cero);




    ManejoErrores: BEGIN


        IF(IFNULL(Par_CreditoID,  Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  := 'El Numero de Credito esta Vacio.';
            SET VarControl  := 'creditoID' ;
            LEAVE ManejoErrores;

        ELSE IF(Var_EstatusCredito != Estatus_Vigente AND Var_EstatusCredito != Estatus_Vencido ) THEN
                SET Par_NumErr  := 2;
                SET Par_ErrMen  := 'El Credito debe estar Vigente o Vencido.';
                SET VarControl  := 'creditoID' ;
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(IFNULL(Par_MontoPagar,  Decimal_Cero) = Decimal_Cero) THEN
            SET Par_NumErr  := 3;
            SET Par_ErrMen  := 'El Monto a Pagar esta Vacio.';
            SET VarControl  := 'montoPagar' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_ModoPago,  Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'Indique el Modo de Pago.';
            SET VarControl  := 'modoPago' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Poliza,  Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  := 'El Numero de Poliza esta Vacio.';
            SET VarControl  := 'polizaID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CuentaAhoID,  Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  := 6;
            SET Par_ErrMen  := 'El Numero de Cuenta esta Vacio.';
            SET VarControl  := 'cuentaAhoID' ;
            LEAVE ManejoErrores;
        END IF;

        CALL SALDOSAHORROCON(Var_CueClienteID,  Var_CueSaldo,    Var_CueMoneda,     Var_CueEstatus,  Par_CuentaAhoID);
        IF(IFNULL(Par_CuentaAhoID,  Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr      := 7;
            SET Par_ErrMen      := 'La Cuenta no Existe.';
            SET VarControl      := 'cuentaAhoID';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Var_CueClienteID, Entero_Cero) != Var_ClienteID) THEN

            IF (Var_EsGrupal = EsGrupal_NO) THEN
                SET Par_NumErr      := 8;
                SET Par_ErrMen      := CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),
                                        ' No Pertenece al Socio ', CONVERT(Var_ClienteID, CHAR), '.');
                SET VarControl      := 'cuentaAhoID';
                LEAVE ManejoErrores;
            ELSE

                    SET Var_SolicitudCreditoID  := IFNULL(Var_SolCreditoID, Entero_Cero);
                    SET Var_GrupoID             := IFNULL(Var_GrupoID, Entero_Cero);

                    SELECT CicloActual INTO Var_CicloActual
                        FROM    GRUPOSCREDITO
                        WHERE GrupoID = Var_GrupoID;


                    IF(Var_CicloGrupo = Var_CicloActual) THEN
                        SELECT GrupoID INTO Var_GrupoCtaID
                        FROM INTEGRAGRUPOSCRE
                        WHERE GrupoID = Var_GrupoID
                            AND Estatus = Estatus_Activo
                            AND ClienteID = Var_CueClienteID
                        LIMIT 1;
                    ELSE
                        SELECT GrupoID INTO Var_GrupoCtaID
                        FROM `HIS-INTEGRAGRUPOSCRE` Ing
                        WHERE GrupoID = Var_GrupoID
                            AND Estatus = Estatus_Activo
                            AND ClienteID = Var_CueClienteID
                            AND Ing.Ciclo = Var_CicloGrupo
                        LIMIT 1;
                    END IF;

                    IF (Var_GrupoCtaID = Entero_Cero) THEN
                        SET Par_NumErr      := 9;
                        SET Par_ErrMen      := CONCAT('La Cuenta ', CONVERT(Par_CuentaAhoID, CHAR),
                                            ' No Pertenece al Socio ', CONVERT(Var_ClienteID, CHAR), '.');
                        SET VarControl      := 'cuentaAhoID';
                        LEAVE ManejoErrores;
                    END IF;
            END IF;

        END IF;



        IF(IFNULL(Var_CueMoneda, Entero_Cero) != Var_MonedaID) THEN
            SET Par_NumErr      := 10;
            SET Par_ErrMen      := 'La Moneda no corresponde con la Cuenta.';
            SET VarControl      := 'cuentaAhoID';
            LEAVE ManejoErrores;
        END IF;





        OPEN CURSORAMORTIZACIONES;
            BEGIN
                DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                CICLOFETCH: LOOP

                FETCH CURSORAMORTIZACIONES INTO
                    Var_AmortizacionID,     Var_SaldoMoraVenci,     Var_SaldoMoratorios,    Var_FechaInicio,
                    Var_FechaVencim;



                        IF (Var_SaldoMoraVenci >= Monto_MinimoPago) THEN
                            SET Var_MontoIVAPagar = ROUND((ROUND(Var_SaldoMoraVenci, 2) *  Var_IVAInteresOrdi), 2);

                            IF(ROUND(Var_MontoSaldo,2)  >= (ROUND(Var_SaldoMoraVenci, 2) + Var_MontoIVAPagar)) THEN
                                SET Var_MontoPagar      :=  Var_SaldoMoraVenci;
                            ELSE

                                SET Var_MontoPagar      := Var_MontoSaldo -
                                                           ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
                                SET Var_MontoIVAPagar   := ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
                            END IF;


                            CALL PAGCREMORATOVENCPRO (
                                Par_CreditoID,      Var_AmortizacionID,     Var_FechaInicio,        Var_FechaVencim,        Par_CuentaAhoID,
                                Var_ClienteID,      Var_FechaSistema,       Var_FecAplicacion,      Var_MontoPagar,         Var_MontoIVAPagar,
                                Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_SucursalID,
                                Des_PagoCredito,    Mov_Referencia,         Par_Poliza,             Par_OrigenPago,         Par_NumErr,
                                Par_ErrMen,         Var_Consecutivo,        Par_EmpresaID,          Par_ModoPago,           Aud_Usuario,
                                Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);



                                SET Var_MontoSaldo  := Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);
                                IF(ROUND(Var_MontoSaldo,2)  <= Decimal_Cero) THEN
                                    LEAVE CICLOFETCH;
                                END IF;

                        END IF;


                        IF (Var_SaldoMoratorios >= Monto_MinimoPago) THEN
                            SET Var_MontoIVAPagar = ROUND((ROUND(Var_SaldoMoratorios, 2) *  Var_IVAInteresOrdi), 2);

                            IF(ROUND(Var_MontoSaldo,2)  >= (ROUND(Var_SaldoMoratorios, 2) + Var_MontoIVAPagar)) THEN
                                SET Var_MontoPagar      :=  Var_SaldoMoratorios;
                            ELSE

                                SET Var_MontoPagar      := Var_MontoSaldo -
                                                           ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
                                SET Var_MontoIVAPagar   := ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
                            END IF;


                            CALL  PAGCREMORAPRO (
                                Par_CreditoID,      Var_AmortizacionID,     Var_FechaInicio,        Var_FechaVencim,        Par_CuentaAhoID,
                                Var_ClienteID,      Var_FechaSistema,       Var_FecAplicacion,      Var_MontoPagar,         Var_MontoIVAPagar,
                                Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_SucursalID,
                                Des_PagoCredito,    Mov_Referencia,         Var_SaldoMoratorios,    Par_Poliza,             Par_OrigenPago,
                                Par_NumErr,         Par_ErrMen,             Var_Consecutivo,        Par_EmpresaID,          Par_ModoPago,
                                Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,
                                Aud_NumTransaccion);


                                SET Var_MontoSaldo  := Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);
                                IF(ROUND(Var_MontoSaldo,2)  <= Decimal_Cero) THEN
                                    LEAVE CICLOFETCH;
                                END IF;

                        END IF;

                END LOOP;
            END;
        CLOSE CURSORAMORTIZACIONES;


        SET Par_MontoSaldo  := Var_MontoSaldo;


    END ManejoErrores;


    IF(Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
                Par_ErrMen      AS ErrMen,
                VarControl      AS control,
                Par_CreditoID   AS consecutivo;
    END IF;


END TerminaStore$$