-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAINTERECRECONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERAINTERECRECONTPRO`;
DELIMITER $$


CREATE PROCEDURE `GENERAINTERECRECONTPRO`(
# =======================================================================
# -- STORE DE GENERACION DE INTERESES  CREDITOSCONT CONTINGENTES-
# =======================================================================
    Par_Fecha           DATE,
    Par_EmpresaID       INT(11),

    Par_Salida          CHAR(1),            -- indica una salida
    INOUT   Par_NumErr  INT(11),            -- parametro numero de error
    INOUT   Par_ErrMen  VARCHAR(400),       -- mensaje de error

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN
    -- Declaracion de Variables
    DECLARE Var_CreditoID       BIGINT(12);           -- Variables para el Cursor
    DECLARE Var_AmortizacionID  INT;
    DECLARE Var_FechaInicio     DATE;
    DECLARE Var_FechaVencim     DATE;
    DECLARE Var_FechaExigible   DATE;
    DECLARE Var_EmpresaID       INT;
    DECLARE Var_CreCapVig       DECIMAL(14,2);
    DECLARE Var_CreCapVNE       DECIMAL(14,2);
    DECLARE Var_FormulaID       INT(11);
    DECLARE Var_TasaFija        DECIMAL(12,4);
    DECLARE Var_MonedaID        INT(11);
    DECLARE Var_Estatus         CHAR(1);
    DECLARE Var_SucCliente      INT;
    DECLARE Var_ProdCreID       INT;
    DECLARE Var_ClasifCre       CHAR(1);
    DECLARE Var_TipoCalInt      INT;
    DECLARE Var_Interes         DECIMAL(14,4);
    DECLARE Var_SucursalCred    INT;
    DECLARE Var_SalIntNoC       DECIMAL(14,4);
    DECLARE Var_SalIntPro       DECIMAL(14,4);
    DECLARE Var_SalIntVen       DECIMAL(14,4);

    DECLARE Var_UltimoDia       CHAR(1);
    DECLARE Var_CreditoStr      VARCHAR(30);
    DECLARE Var_ValorTasa       DECIMAL(12,4);
    DECLARE Var_DiasCredito     DECIMAL(10,2);
    DECLARE Var_Intere          DECIMAL(12,4);
    DECLARE Var_FecApl          DATE;
    DECLARE Var_EsHabil         CHAR(1);
    DECLARE SalCapital          DECIMAL(14,2);
    DECLARE Var_CapAju          DECIMAL(14,2);
    DECLARE Ref_GenInt          VARCHAR(50);
    DECLARE Error_Key           INT;
    DECLARE Mov_AboConta        INT;
    DECLARE Mov_CarConta        INT;
    DECLARE Mov_CarOpera        INT;
    DECLARE Var_Poliza          BIGINT;
    DECLARE Par_Consecutivo     BIGINT;
    DECLARE Es_DiaHabil         CHAR(1);
    DECLARE Var_ContadorCre     INT;
    DECLARE Var_SigFecha        DATE;
    DECLARE Var_SubClasifID     INT;
    DECLARE Var_Consecutivo     BIGINT;
    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_Refinancia      CHAR(1);          -- Indica si el credito refinancia el interes
    DECLARE Var_FechaFinMes     DATE;             -- Indica el fin de mes de acuerdo a la fecha de inicio de la amortizacion
    DECLARE Var_FechaInicioMes  DATE;             -- Indica la fecha de inicio de mes de acuerdo a la fecha de fin de mes
    DECLARE Var_InteresRef      DECIMAL(14,2);

    -- Declaracion de Constantes
    DECLARE Estatus_Vigente     CHAR(1);
    DECLARE Estatus_Vencida     CHAR(1);
    DECLARE Estatus_Pagada      CHAR(1);
    DECLARE Cre_Vencido         CHAR(1);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(12, 2);
    DECLARE Nat_Cargo           CHAR(1);
    DECLARE Nat_Abono           CHAR(1);
    DECLARE Dec_Cien            DECIMAL(10,2);
    DECLARE Pro_GenIntere       INT;
    DECLARE Mov_IntPro          INT;
    DECLARE Mov_IntNoConta      INT;
    DECLARE Con_CueOrdInt       INT;
    DECLARE Con_CorOrdInt       INT;
    DECLARE Pol_Automatica      CHAR(1);
    DECLARE Con_GenIntere       INT;
    DECLARE Par_SalidaNO        CHAR(1);
    DECLARE AltaPoliza_NO       CHAR(1);
    DECLARE AltaPolCre_SI       CHAR(1);
    DECLARE AltaMovCre_SI       CHAR(1);
    DECLARE AltaMovCre_NO       CHAR(1);
    DECLARE AltaMovAho_NO       CHAR(1);
    DECLARE Int_SalInsol        INT;
    DECLARE Int_SalGlobal       INT;
    DECLARE For_TasaFija        INT;
    DECLARE SI_UltimoDia        CHAR(1);
    DECLARE NO_UltimoDia        CHAR(1);
    DECLARE DiasInteres         DECIMAL(10,2);

    DECLARE Si_Regulariza       CHAR(1);
    DECLARE No_Regulariza       CHAR(1);
    DECLARE Des_CieDia          VARCHAR(100);
    DECLARE Des_ErrorGral       VARCHAR(100);
    DECLARE Des_ErrorLlavDup    VARCHAR(100);
    DECLARE Des_ErrorCallSP     VARCHAR(100);
    DECLARE Des_ErrorValNulos   VARCHAR(100);
    DECLARE Cons_SI             CHAR(1);
    DECLARE Salida_SI           CHAR(1);
    DECLARE Salida_No           CHAR(1);

    DECLARE CURSORINTER CURSOR FOR
        SELECT  Cre.CreditoID,          AmortizacionID,         Amo.FechaInicio,        Amo.FechaVencim,
                Amo.FechaExigible,      Cre.EmpresaID,          Cre.SaldoCapVigent,     Cre.SaldCapVenNoExi,
                CalcInteresID,          TasaFija,               Cre.MonedaID,           Cre.Estatus,
                Cli.SucursalOrigen,     Cre.ProductoCreditoID,  Des.Clasificacion,      Cre.TipoCalInteres,
                Amo.Interes,            Des.SubClasifID,        Cre.SucursalID,         Amo.SaldoInteresPro,
                Amo.SaldoIntNoConta,    Amo.SaldoInteresVen,    Cre.Refinancia,         Cre.InteresRefinanciar
            FROM AMORTICREDITOCONT Amo,
                CLIENTES Cli,
                DESTINOSCREDITO Des,
                CREDITOSCONT Cre
            WHERE Amo.CreditoID     = Cre.CreditoID
              AND Cre.ClienteID     = Cli.ClienteID
              AND Cre.DestinoCreID  = Des.DestinoCreID
              AND Amo.FechaInicio   <= Par_Fecha
              AND Amo.FechaVencim   >  Par_Fecha
              AND Amo.FechaExigible >  Par_Fecha
            AND IFNULL(Amo.NumProyInteres, Entero_Cero) = Entero_Cero
              AND ( Amo.Estatus         =  Estatus_Vigente
               OR   Amo.Estatus         =  Estatus_Vencida)
              AND ( Cre.Estatus         =  Estatus_Vigente
               OR   Cre.Estatus         =  Estatus_Vencida);
    -- Asignacion de Constantes
    SET Estatus_Vigente := 'V';                 -- Estatus Amortizacion: Vigente
    SET Estatus_Vencida := 'B';                 -- Estatus Amortizacion: Vencido
    SET Estatus_Pagada  := 'P';                 -- Estatus Amortizacion: Pagada
    SET Cre_Vencido     := 'B';                 -- Estatus Credito: Vencido
    SET Cadena_Vacia    := '';                  -- Cadena Vacia
    SET Fecha_Vacia     := '1900-01-01';        -- Fecha Vacia
    SET Entero_Cero     := 0;                   -- Entero en Cero
    SET Decimal_Cero    := 0.00;                -- Decimal Cero
    SET Nat_Cargo       := 'C';                 -- Naturaleza de Cargo
    SET Nat_Abono       := 'A';                 -- Naturaleza de Abono
    SET Dec_Cien        := 100.00;              -- Decimal Cien
    SET Pro_GenIntere   := 1401;                -- Numero de Proceso Batch: Generacion de Interes
    SET Mov_IntPro      := 14;                  -- Tipo de Movimiento de Credito: Interes Provisionado
    SET Mov_IntNoConta  := 13;                  -- Tipo de Movimiento de Credito: Interes Provisionado
    SET Con_CueOrdInt   := 72;                  -- Concepto Contable: Orden Intereses Cartera Contingente
    SET Con_CorOrdInt   := 73;                  -- Concepto Contable: Correlativa Intereses de Cartera Contingente
    SET Pol_Automatica  := 'A';                 -- Tipo de Poliza: Automatica
    SET Con_GenIntere   := 51;                  -- Tipo de Proceso Contable: Generacion de Interes Ordinario
    SET Par_SalidaNO    := 'N';                 -- El store no Arroja una Salida
    SET AltaPoliza_NO   := 'N';                 -- Alta del Encabezado de la Poliza: NO
    SET AltaPolCre_SI   := 'S';                 -- Alta de la Poliza de Credito: SI
    SET AltaMovCre_NO   := 'N';                 -- Alta del Movimiento de Credito: NO
    SET AltaMovCre_SI   := 'S';                 -- Alta del Movimiento de Credito: SI
    SET AltaMovAho_NO   := 'N';                 -- Alta del Movimiento de Ahorro: NO
    SET Int_SalInsol    := 1;                   -- Calculo de Interes Sobre Saldos Insolutos
    SET Int_SalGlobal   := 2;                   -- Calculo de Interes Sobre Saldos Globales
    SET For_TasaFija    := 1;                   -- Formula de Calculo de Interes: Tasa Fija
    SET SI_UltimoDia    := 'S';                 -- Ultimo Dia del calculo de Interes: SI
    SET NO_UltimoDia    := 'N';                 -- Ultimo Dia del calculo de Interes: NO
    SET DiasInteres     := 1;                   -- Dias para el Calculo de Interes: Un Dia
    SET Cons_SI         := 'S';                 -- Constante: SI
    SET Salida_SI       := 'S';
    SET Salida_No       := 'N';
    SET Des_CieDia          := 'CIERRE DIARO CREDITOS CONTINGENTES';
    SET Ref_GenInt          := 'GENERACION INTERES CONTINGENTES';
    SET Aud_ProgramaID      := 'GENERAINTERECRECONTPRO';
    SET Des_ErrorGral       := 'ERROR DE SQL GENERAL';
    SET Des_ErrorLlavDup    := 'ERROR EN ALTA, LLAVE DUPLICADA';
    SET Des_ErrorCallSP     := 'ERROR AL LLAMAR A STORE PROCEDURE';
    SET Des_ErrorValNulos   := 'ERROR VALORES NULOS';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
            concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-GENERAINTERECRECONTPRO');
        SET Var_Control := 'sqlexception';
    END;

    SELECT DiasCredito INTO Var_DiasCredito
        FROM PARAMETROSSIS LIMIT 1;

    SET Var_SigFecha    := DATE_ADD(Par_Fecha, INTERVAL 1 DAY);
    SET Var_FecApl      := Par_Fecha;

    SELECT  COUNT(Cre.CreditoID) INTO Var_ContadorCre
        FROM AMORTICREDITOCONT Amo,
             CREDITOSCONT    Cre,
             CLIENTES Cli,
             PRODUCTOSCREDITO Pro
        WHERE Amo.CreditoID         = Cre.CreditoID
          AND Cre.ClienteID         = Cli.ClienteID
          AND Cre.ProductoCreditoID = Pro.ProducCreditoID
          AND Amo.FechaInicio       <= Par_Fecha
          AND Amo.FechaVencim       >  Par_Fecha
          AND Amo.FechaExigible >  Par_Fecha
          AND IFNULL(Amo.NumProyInteres, Entero_Cero) = Entero_Cero
          AND (Amo.Estatus          =  Estatus_Vigente
           OR   Amo.Estatus         =  Estatus_Vencida)
          AND (Cre.Estatus          =  Estatus_Vigente
           OR   Cre.Estatus         =  Estatus_Vencida);

    SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);

    IF (Var_ContadorCre > Entero_Cero) THEN

        CALL MAESTROPOLIZASALT(
            Var_Poliza,         Par_EmpresaID,      Var_FecApl,             Pol_Automatica,         Con_GenIntere,
            Ref_GenInt,         Salida_No,          Par_NumErr,             Par_ErrMen,             Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;

    OPEN CURSORINTER;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP

        FETCH CURSORINTER INTO
        Var_CreditoID,  Var_AmortizacionID, Var_FechaInicio,    Var_FechaVencim,    Var_FechaExigible,
        Var_EmpresaID,  Var_CreCapVig,      Var_CreCapVNE,      Var_FormulaID,      Var_TasaFija,
        Var_MonedaID,   Var_Estatus,        Var_SucCliente,     Var_ProdCreID,      Var_ClasifCre,
        Var_TipoCalInt, Var_Interes,        Var_SubClasifID,    Var_SucursalCred,   Var_SalIntPro,
        Var_SalIntNoC,  Var_SalIntVen,      Var_Refinancia,     Var_InteresRef;

        START TRANSACTION;
        BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
        DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
        DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
        DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

        -- Inicalizacion
        SET Error_Key         := Entero_Cero;
        SET SalCapital        := Entero_Cero;
        SET Var_CapAju        := Entero_Cero;
        SET Var_Intere        := Entero_Cero;
        SET Var_ValorTasa     := Entero_Cero;
        SET Var_SubClasifID   := IFNULL(Var_SubClasifID, Entero_Cero);
        SET Var_SucursalCred  := IFNULL(Var_SucursalCred, Aud_Sucursal);
        SET Var_SalIntPro     := IFNULL(Var_SalIntPro, Entero_Cero);
        SET Var_SalIntNoC     := IFNULL(Var_SalIntNoC, Entero_Cero);
        SET Var_UltimoDia     := NO_UltimoDia;

        -- Si Hoy es la Fecha del ultimo calculo de Interes, y es Tasa Fija, entonces el interes
        -- Ya no lo calculamos lo tomamos de la tabla de amortizacion, esto para poder ajustarnos
        -- A calendarios arbitrarios en las migraciones y evitar errores en calculos de centavos
        IF ( (Var_FechaVencim > Var_FechaExigible AND (DATEDIFF(Var_FechaExigible, Var_SigFecha) = Entero_Cero)) OR
            (Var_FechaExigible >= Var_FechaVencim AND (DATEDIFF(Var_FechaVencim, Var_SigFecha) = Entero_Cero)) ) THEN

            IF(Var_FormulaID = For_TasaFija) THEN
                SET Var_UltimoDia := SI_UltimoDia;
            END IF;

        END IF;

        -- Hacemos el Calculo del Interes
        IF(Var_UltimoDia = NO_UltimoDia) THEN
            # Se verifica si la fecha es Inicio de Mes para aumentar al monto base(Saldo de Capital) el interes acumulado)
            SET Var_FechaFinMes := (SELECT LAST_DAY(Par_Fecha));
            SET Var_FechaFinMes := IFNULL(Var_FechaFinMes, Fecha_Vacia);

            SET SalCapital := Var_CreCapVig + Var_CreCapVNE;

            SET Var_CapAju:=(SELECT IFNULL(SUM(SaldoCapVigente + SaldoCapVenNExi), Decimal_Cero)
                        FROM AMORTICREDITOCONT
                        WHERE CreditoID = Var_CreditoID
                          AND AmortizacionID< Var_AmortizacionID
                          AND Estatus!= Estatus_Pagada
                        GROUP BY CreditoID );


            SET Var_CapAju := IFNULL(Var_CapAju, Entero_Cero);

            SET SalCapital := SalCapital- Var_CapAju;

            CALL CRECALCULOTASACONTPRO(
                Var_CreditoID,  Var_FormulaID,      Var_TasaFija,       Par_Fecha,          Var_FechaInicio,
                Var_EmpresaID,  Var_ValorTasa,      Salida_No,          Par_NumErr,         Par_ErrMen,
                Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

            IF(Var_Refinancia = Cons_SI)THEN
                # Si es inicio de una amortizacion, el interes acumulado de inicializa en cero.
                IF(Par_Fecha = Var_FechaInicio) THEN
                    # Se inicializa en cero el valor del interes Acumulado e Interes Refinanciar
                    UPDATE CREDITOSCONT
                        SET InteresAcumulado = Decimal_Cero,
                            InteresRefinanciar = Decimal_Cero
                    WHERE CreditoID = Var_CreditoID;

                    SET Var_InteresRef := Decimal_Cero;

                END IF;

                # Como el credito refinancia al saldo de capital se le suma el interes acumulado de meses anteriores
                 SET SalCapital := SalCapital + Var_InteresRef;
            END IF;

            IF (Var_TipoCalInt = Int_SalInsol)THEN  -- Calculo Sobre Saldos Insolutos
                SET Var_Intere :=  ROUND(SalCapital * Var_ValorTasa * DiasInteres / (Var_DiasCredito * Dec_Cien), 2);
            ELSE -- Calculo sobre Saldos Globales
                SET Var_Intere :=  ROUND((Var_Interes/DATEDIFF(Var_FechaVencim, Var_FechaInicio)) * DiasInteres, 2);
            END IF;
           
            -- Ajuste condonaciones contingentes
            IF(Var_Interes <
                (IFNULL(Var_Intere, Entero_Cero) +
                IFNULL(Var_SalIntPro, Entero_Cero) +
                IFNULL(Var_SalIntVen,Entero_Cero) +
                IFNULL(Var_SalIntNoC, Entero_Cero))
            )THEN
                SET Var_Intere := ROUND(Var_Interes - IFNULL(Var_SalIntPro, Entero_Cero) -
                                          IFNULL(Var_SalIntVen,Entero_Cero) -
                                          IFNULL(Var_SalIntNoC, Entero_Cero), 2);

                SET Var_Intere := CASE WHEN Var_Intere < Entero_Cero THEN Entero_Cero ELSE Var_Intere END;

            END IF;
	       
            -- Ajuste condonaciones contingentes
            IF(Var_Interes <
                (IFNULL(Var_Intere, Entero_Cero) +
                IFNULL(Var_SalIntPro, Entero_Cero) +
                IFNULL(Var_SalIntVen,Entero_Cero) +
                IFNULL(Var_SalIntNoC, Entero_Cero))
            )THEN
                SET Var_Intere := ROUND(Var_Interes - IFNULL(Var_SalIntPro, Entero_Cero) -
                                          IFNULL(Var_SalIntVen,Entero_Cero) -
                                          IFNULL(Var_SalIntNoC, Entero_Cero), 2);

                SET Var_Intere := CASE WHEN Var_Intere < Entero_Cero THEN Entero_Cero ELSE Var_Intere END;

            END IF;

        ELSE-- else del que es el ultimo dia del calculo del Interes

            -- Var_Interes Es el Interes Original Calculado de la Amortizacion
            SET Var_Intere := ROUND(Var_Interes - IFNULL(Var_SalIntPro, Entero_Cero) -
                                     IFNULL(Var_SalIntVen,Entero_Cero) -
                                     IFNULL(Var_SalIntNoC, Entero_Cero), 2);
        END IF;

        IF (Var_Intere > Entero_Cero) THEN
            -- Verifica si el Credito esta Vencido diferenciar Los Asientos Contables del Interes
            /* vmartinez:  no es necesario modificar este SP toma en automatico las cuentas de orden , elimine la validación
                            de Vencido, para mandar el movimiento como cuentas de orden */
            SET Mov_AboConta    := Con_CorOrdInt;
            SET Mov_CarConta    := Con_CueOrdInt;
            SET Mov_CarOpera    := Mov_IntPro;

            CALL CONTACREDITOSCONTPRO (
                Var_CreditoID,          Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,             Var_Intere,             Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,        Var_SucCliente,         Des_CieDia,         Ref_GenInt,             AltaPoliza_NO,
                Entero_Cero,            Var_Poliza,             AltaPolCre_SI,      AltaMovCre_SI,          Mov_CarConta,
                Mov_CarOpera,           Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Salida_NO,              Par_NumErr,             Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,
                Cadena_Vacia,           Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
                Var_SucursalCred,       Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

            CALL CONTACREDITOSCONTPRO (
                Var_CreditoID,          Var_AmortizacionID,     Entero_Cero,        Entero_Cero,            Par_Fecha,
                Var_FecApl,             Var_Intere,             Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,
                Var_SubClasifID,        Var_SucCliente,         Des_CieDia,         Ref_GenInt,             AltaPoliza_NO,
                Entero_Cero,            Var_Poliza,             AltaPolCre_SI,      AltaMovCre_NO,          Mov_AboConta,
                Entero_Cero,            Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                Salida_NO,              Par_NumErr,             Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,
                Cadena_Vacia,           Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
                Var_SucursalCred,       Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

             IF(Var_Refinancia = Cons_SI) THEN
                # Se actualiza el campo Interes Acumulado de la tabla de CREDITOS esto con el fin de mantener el interes que se va acumulando diariamente
                UPDATE CREDITOSCONT
                SET InteresAcumulado = InteresAcumulado + Var_Intere
                WHERE CreditoID = Var_CreditoID;

                IF(Par_Fecha = Var_FechaFinMes) THEN
                    # Si la fecha es un fin de mes, se actualiza el campo InteresRefinanciar con el valor de InteresAcumulado(lo que se ha ido acumulando hasta el fin de mes
                    UPDATE CREDITOSCONT
                    SET InteresRefinanciar  = InteresAcumulado
                    WHERE CreditoID         = Var_CreditoID;

                END IF;

            END IF;
        END IF;
        END;

        SET Var_CreditoStr := CONCAT(CONVERT(Var_CreditoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR)) ;

        IF Error_Key = 0 THEN
            COMMIT;
        END IF;

        IF Error_Key = 1 THEN
            ROLLBACK;
            START TRANSACTION;
                CALL EXCEPCIONBATCHALT(
                    Pro_GenIntere,      Par_Fecha,          Var_CreditoStr,         Des_ErrorGral,
                    Var_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
            COMMIT;
        END IF;

        IF Error_Key = 2 THEN
            ROLLBACK;
            START TRANSACTION;
                CALL EXCEPCIONBATCHALT(
                    Pro_GenIntere,      Par_Fecha,          Var_CreditoStr,         Des_ErrorLlavDup,
                    Var_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
            COMMIT;
        END IF;

        IF Error_Key = 3 THEN
            ROLLBACK;
            START TRANSACTION;
                CALL EXCEPCIONBATCHALT(
                    Pro_GenIntere,      Par_Fecha,          Var_CreditoStr,         Des_ErrorCallSP,
                    Var_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
            COMMIT;
        END IF;

        IF Error_Key = 4 THEN
            ROLLBACK;
            START TRANSACTION;
                CALL EXCEPCIONBATCHALT(
                    Pro_GenIntere,      Par_Fecha,          Var_CreditoStr,         Des_ErrorValNulos,
                    Var_EmpresaID,      Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
            COMMIT;
        END IF;
    END LOOP;
    END;
    CLOSE CURSORINTER;

    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := 'Informacion Procesada Exitosamente.';
    SET Var_Control := 'creditoID' ;
    SET Var_Consecutivo := IFNULL(Par_Consecutivo, Entero_Cero);

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr  AS NumErr,
            Par_ErrMen  AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
END IF;

END TerminaStore$$