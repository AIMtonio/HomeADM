-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTALIQUIDACIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS CARTALIQUIDACIONALT;

DELIMITER $$
CREATE PROCEDURE CARTALIQUIDACIONALT(
-- ========== SP PARA ALTA DE CARTA LIQUIDACIÓN =============================================
    Par_CreditoID           BIGINT(12),         -- CreditoID para la carta de liquidación
    Par_ClienteID           INT(11),            -- ClienteID del cliente que tiene el credito
    Par_FechaVencimien      DATE,               -- Fecha introducida por el usuario
    Par_InstitucionID       INT(11),            -- Institucion ID para liquidar
    Par_Convenio            BIGINT(12),         -- Convenio para realizar el pago

    Par_Salida              CHAR(1),            -- Salida
    INOUT Par_NumErr        INT(11),            -- Numero de error
    INOUT Par_ErrMen        VARCHAR(400),       -- Mensaje de error

    -- Parametros de Auditoria
    Aud_EmpresaID           INT(11),            -- Empresa ID
    Aud_Usuario             INT(11),            -- Campo Auditoria
    Aud_FechaActual         DATETIME,           -- Campo Auditoria

    Aud_DireccionIP         VARCHAR(15),        -- Campo Auditoria
    Aud_ProgramaID          VARCHAR(50),        -- Campo Auditoria
    Aud_Sucursal            INT(11),            -- Campo Auditoria
    Aud_NumTransaccion      BIGINT(20)          -- Campo Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_Control             VARCHAR(100);       -- Variable de Control
    DECLARE Var_FechaSis            DATE;               -- Variable para validar fecha de vencimiento del credito
    DECLARE Var_CartaLiqID          BIGINT(12);         -- Variable para obtener el consecutivo
    DECLARE Var_ConvenioNominaID    BIGINT UNSIGNED;    -- Variable para obtener el ConvenioNomina
    DECLARE Var_InstitNominaID      INT(11);            -- Variable para obtener la institucion de nomina
    DECLARE Var_ManejaCalendario    CHAR(1);            -- Variable para obtener si maneja candario
    DECLARE Var_FechaLimiteCal      DATE;               -- Variable para obtener la sig fecha de limite de envio
    DECLARE Var_SaldoCapital        DECIMAL(14,2);      -- Variable para obtener el SaldoCapital
    DECLARE Var_UltimoAbono         DECIMAL(14,2);      -- Variable para obtener el UltimoAbono Cap e Int

    DECLARE Var_PorcenCuoPag        DECIMAL(14,2);      -- Variable
    DECLARE Var_ProcenCuoNoPag      DECIMAL(14,2);      -- Variable
    DECLARE Var_MontoPagado         DECIMAL(14,2);      -- Variable
    DECLARE Var_SaldoAtrasado       DECIMAL(14,2);      -- Variable
    DECLARE Var_CuotasGeneradas     INT(11);            -- Variable
    DECLARE Var_MontoTotalAdeu      DECIMAL(14,2);      -- Variable
    DECLARE Var_MontoPendiente      DECIMAL(14,2);      -- Variable
    DECLARE Var_CuotasPagadas       DECIMAL(14,2);      -- Variable
    DECLARE Var_MontoPagaFec        DECIMAL(14,2);      -- Variable
    DECLARE Var_CuotasPendientes    INT(11);            -- Variable
    DECLARE Var_MontoLiquidar       DECIMAL(14,2);      -- Variable
    DECLARE Var_DescuentoPen        DECIMAL(14,2);      -- Variable
    DECLARE Var_FechaPrimerDesc     DATE;               -- De acuerdo al calendario cual es la fecha del primer descuento
    DECLARE Var_FechaUltDescuento   DATE;               -- Fecha de Ultimo Descuento
    DECLARE Var_NotCargoSinIva      DECIMAL(14,2);      -- Monto exigible de las notas de cargo a las que no se les aplica iva
    DECLARE Var_NotCargoConIva      DECIMAL(14,2);      -- Monto exigible de las notas de cargo a las que si se les aplica iva
    DECLARE Var_IvaNotasCargo       DECIMAL(14,2);      -- Monto de iva de notas de cargo
    DECLARE Var_CliPagIVA           CHAR(1);            -- Indica si el cliente paga IVA
    DECLARE Var_IVA                 DECIMAL(12,2);      -- Valor IVA Sucursal
    DECLARE Var_DevengaInteres      CHAR(1);
    DECLARE Var_CalendarioID        BIGINT(12);
    DECLARE Var_MontoOtorgado       DECIMAL(14,2);
    DECLARE Var_ProductoCreditoID   INT(11);

    -- Declaracion de constantes.
    DECLARE Var_EstAct      CHAR(1);            -- Constante Estatus Activo
    DECLARE Var_EstIn       CHAR(1);            -- Cosntante Estatus Inactivo
    DECLARE Cadena_Vacia    CHAR(1);            -- Cosntante Cadena Vacia
    DECLARE Entero_Cero     INT;                -- Cosntante Cero
    DECLARE Var_EstVig      CHAR(1);            -- Constante Credito Vigente
    DECLARE Var_EstVen      CHAR(1);            -- Cosbtante Vencido
    DECLARE Salida_SI       CHAR(1);            -- Parametro de salida SI
    DECLARE Fecha_Vacia     DATE;               -- Fecha Vacia
    DECLARE EnteroUno       INT;                -- Entero Uno
    DECLARE Con_SI          CHAR(1);            -- Contante S- Si
    DECLARE Con_EstAut      CHAR(1);            -- Constante Estatus Autorizado
    DECLARE DecimalCero     DECIMAL(14,2);      -- Decinal Cero
    DECLARE EstatusPagado   CHAR(1);
    DECLARE Salida_NO       CHAR(1);
    DECLARE Var_DxN         VARCHAR(10);

    -- Asiganacion de constantes
    SET Var_EstAct          := 'A';             -- Estatus activo
    SET Var_EstIn           := 'I';             -- Estatius Inactivo
    SET Cadena_Vacia        := '';              -- Cadena vacia
    SET Entero_Cero         := 0;               -- Valor 0
    SET Var_EstVig          := 'V';             -- Vigente
    SET Var_EstVen          := 'B';             -- Vencido
    SET Salida_SI           := 'S';             -- Constante salida Si
    SET Fecha_Vacia         := '1900-01-01';    -- Fecha vacia
    SET EnteroUno           := 1;               -- Valor 1
    SET Con_SI              := 'S';             -- Constante S - Si
    SET Con_EstAut          := 'A';             -- Estatus Autorizado
    SET DecimalCero         := 0.0;             -- Decimal Cero
    SET EstatusPagado       := 'P';             -- Estatus Pagado
    SET Salida_NO           := 'N';
    SET Var_DevengaInteres  := 'N';
    SET Var_DxN             := 1000;

    -- Asignacion de Variables
    SET Var_Control         := Cadena_Vacia;
    SET Var_FechaSis        := Fecha_Vacia;

    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr  := 999;
            SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                            'Disculpe las molestias que esto le ocaciona. Ref: SP-CARTALIQUIDACIONALT');
            SET Var_Control :='SQLEXCEPTION';
        END;

        SELECT  FechaSistema INTO Var_FechaSis
            FROM PARAMETROSSIS LIMIT 1;

        IF(IFNULL(Par_CreditoID, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr := 001;
            SET Par_ErrMen := 'El Credito esta vacio.';
            SET Var_Control := 'creditoID';
            LEAVE ManejoErrores;
        END IF;

        IF NOT EXISTS(SELECT CreditoID
                        FROM CREDITOS
                        WHERE   CreditoID   = Par_CreditoID
                          AND   Estatus IN (Var_EstVig,Var_EstVen)) THEN
            SET Par_NumErr := 002;
            SET Par_ErrMen := 'El crédito no existe o no es valido';
            SET Var_Control := 'creditoID';
            LEAVE ManejoErrores;
        END IF;

        IF (IFNULL(Par_FechaVencimien,Fecha_Vacia)) = Fecha_Vacia THEN
            SET Par_NumErr := 003;
            SET Par_ErrMen := 'Fecha vencimiento esta vacia.';
            SET Var_Control := 'fechaVencimiento';
            LEAVE ManejoErrores;
        END IF;

        SELECT      Cre.ConvenioNominaID,   Cre.InstitNominaID,     Cli.PagaIVA,    Suc.IVA,    Cre.ProductoCreditoID
            INTO    Var_ConvenioNominaID,   Var_InstitNominaID,     Var_CliPagIVA,  Var_IVA,    Var_ProductoCreditoID
            FROM    CREDITOS Cre,
                    CLIENTES Cli,
                    SUCURSALES Suc
            WHERE   Cre.CreditoID   = Par_CreditoID
              AND   Cre.ClienteID   = Cli.ClienteID
              AND   Cre.SucursalID  = Suc.SucursalID;

        SET Var_InstitNominaID      := IFNULL(Var_InstitNominaID, Entero_Cero);
        SET Var_ConvenioNominaID    := IFNULL(Var_ConvenioNominaID, Entero_Cero);
        SET Var_CliPagIVA           := IFNULL(Var_CliPagIVA, Cadena_Vacia);
        SET Var_IVA                 := IFNULL(Var_IVA, Entero_Cero);
        SET Var_ProductoCreditoID   := IFNULL(Var_ProductoCreditoID, Entero_Cero);

        IF (Var_InstitNominaID != Entero_Cero) THEN
            SET Var_ManejaCalendario    := (SELECT ManejaCalendario FROM CONVENIOSNOMINA
                                                WHERE ConvenioNominaID = Var_ConvenioNominaID);

            IF (Var_ManejaCalendario = Con_SI) THEN

                SELECT  IFNULL(MIN(FechaLimiteEnvio),Fecha_Vacia), IFNULL(MIN(FechaPrimerDesc),Fecha_Vacia)
                        INTO Var_FechaLimiteCal, Var_FechaPrimerDesc
                    FROM  CALENDARIOINGRESOS
                    WHERE ConvenioNominaID  = Var_ConvenioNominaID
                      AND InstitNominaID    = Var_InstitNominaID
                      AND Anio              >= YEAR(Var_FechaSis)
                      AND Estatus           = Con_EstAut
                      AND FechaLimiteEnvio  >= Var_FechaSis;

                IF (Var_FechaLimiteCal = Fecha_Vacia) THEN
                    SET Par_NumErr  := 004;
                    SET Par_ErrMen  := 'No hay un calendario activo para el convenio.';
                    SET Var_Control := 'fechaVencimiento';
                    LEAVE ManejoErrores;
                END IF;

            END IF;
        END IF;

        IF (Par_FechaVencimien < Var_FechaSis) THEN
            SET Par_NumErr  := 006;
            SET Par_ErrMen  := 'Fecha vencimiento no puede ser menor a la fecha del sistema';
            SET Var_Control := 'fechaVencimiento';
            LEAVE ManejoErrores;
        END IF;

        IF NOT EXISTS(SELECT InstitucionID
                        FROM INSTITUCIONES
                        WHERE InstitucionID = Par_InstitucionID) THEN
            SET Par_NumErr  := 007;
            SET Par_ErrMen  := 'La institución no existe.';
            SET Var_Control := 'institucionID';
            LEAVE ManejoErrores;
        END IF;

        IF (IFNULL(Par_Convenio,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 008;
            SET Par_ErrMen  := 'Convenio esta vacio.';
            SET Var_Control := 'convenio';
            LEAVE ManejoErrores;
        END IF;

        -- Cambia el estatus a la carta activa asociada al credito
        UPDATE CARTALIQUIDACION SET
            FechaBaja   = Var_FechaSis,
            Estatus     = Var_EstIn
        WHERE   CreditoID   = Par_CreditoID
          AND   Estatus     = Var_EstAct;

        CALL FOLIOSAPLICAACT('CARTALIQUIDACION', Var_CartaLiqID);
        SET Aud_FechaActual := CURRENT_TIMESTAMP();

        INSERT INTO CARTALIQUIDACION(
            CartaLiquidaID, CreditoID,      ClienteID,      FechaVencimiento,   InstitucionID,
            Convenio,       Estatus,        FechaRegistro,  EmpresaID,          Usuario,
            FechaActual,    DireccionIP,    ProgramaID,     Sucursal,           NumTransaccion)
        VALUES (
            Var_CartaLiqID,     Par_CreditoID,      Par_ClienteID,  Par_FechaVencimien, Par_InstitucionID,
            Par_Convenio,       Var_EstAct,         Var_FechaSis,   Aud_EmpresaID,      Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

/* ======= Calculos para Almacenar la informacion para la Carta de Liquidacion ===== */

        SELECT  SUM(IFNULL(Capital,DecimalCero))
        INTO    Var_SaldoCapital
        FROM AMORTICREDITO
        WHERE CreditoID = Par_CreditoID;

        SET Var_SaldoCapital = IFNULL(Var_SaldoCapital,DecimalCero);

        -- UltimoAbono hace referencia al Monto de Cuota de la Amortizacion en Curso
        SELECT  IFNULL(MontoCuota,DecimalCero)
            INTO Var_UltimoAbono
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoID;

        SET Var_UltimoAbono = IFNULL(Var_UltimoAbono,DecimalCero);

        -- MontoPagado hace referencia al Monto Total que se ha Pagado
        SELECT IFNULL(SUM(MontoTotPago),0.00)
        INTO Var_MontoPagado
        FROM DETALLEPAGCRE
        WHERE CreditoID  = Par_CreditoID;

        SET Var_MontoPagaFec    := IFNULL(Var_MontoPagado,Entero_Cero);
        SET Var_SaldoAtrasado   := IFNULL(FUNCIONEXIGIBLE(Par_CreditoID),DecimalCero);

        -- Var_MontoOtorgado hace referencia al Monto del Credito Otorgado
        SELECT (SUM(Capital)+SUM(Interes)+SUM(IVAInteres)+ SUM(MontoSeguroCuota)+SUM(IVASeguroCuota))
        INTO Var_MontoOtorgado
        FROM AMORTICREDITO
        WHERE CreditoID = Par_CreditoID;

        SET Var_MontoOtorgado := IFNULL(Var_MontoOtorgado, Entero_Cero);

        SET Var_MontoPendiente := (Var_MontoOtorgado - Var_MontoPagaFec);
        SET Var_MontoPendiente := IFNULL(Var_MontoPendiente, Entero_Cero);


        SELECT
                IFNULL(COUNT(AmortizacionID),0) AS CuotasGeneradas,
                IFNULL(ROUND(SUM(Capital+Interes+IVAInteres),2),DecimalCero) AS MontoTotalAdeu,
                IFNULL(ROUND(SUM(SaldoCapAtrasa+SaldoCapVencido
                    +SaldoInteresAtr+SaldoInteresVen),2),DecimalCero) AS SaldoAtrasado,
                SUM(CASE WHEN Estatus <> EstatusPagado THEN -- Dif a EstatusPagado
                    1 ELSE 0 END) AS CuotasPendientes,
                IFNULL(ROUND(SUM(CASE WHEN Estatus <> EstatusPagado THEN
                                    Capital+Interes
                                    ELSE DecimalCero
                                END),2),DecimalCero) AS MontoDescuentoPen
            INTO Var_CuotasGeneradas,
                 Var_MontoTotalAdeu,
                 Var_SaldoAtrasado,
                 Var_CuotasPendientes,
                 Var_DescuentoPen
            FROM AMORTICREDITO
            WHERE CreditoID     = Par_CreditoID
              AND FechaInicio   <= Var_FechaSis;

        SELECT
            COUNT(AmortizacionID) AS CuotasPagadas
            INTO Var_CuotasPagadas
            FROM AMORTICREDITO
            WHERE CreditoID     = Par_CreditoID
              AND Estatus       = EstatusPagado;
        SET Var_CuotasPagadas := IFNULL(Var_CuotasPagadas,DecimalCero);

        IF (Var_ProductoCreditoID = Var_DxN) THEN
            SELECT  FechaPrimerDesc
                    INTO    Var_FechaUltDescuento
            FROM CALENDARIOINGRESOS
            WHERE InstitNominaID = Var_InstitNominaID
                AND ConvenioNominaID = Var_ConvenioNominaID
                AND FechaLimiteEnvio < Par_FechaVencimien
                ORDER BY FechaLimiteEnvio DESC
                LIMIT 1
            ;
        ELSE
            SELECT  FechaExigible
                    INTO    Var_FechaUltDescuento
            FROM AMORTICREDITO
            WHERE CreditoID = Par_CreditoID
                AND FechaExigible < Par_FechaVencimien
                ORDER BY FechaExigible DESC
                LIMIT 1
            ;
        END IF;
        SET Var_FechaUltDescuento   := IFNULL(Var_FechaUltDescuento, Fecha_Vacia);
        -- Var_PorcenCuoPag hace referencia a Cuotas Generadas
        SET Var_PorcenCuoPag    := Var_CuotasPagadas;
        SET Var_PorcenCuoPag    := IFNULL(Var_PorcenCuoPag, Entero_Cero);

        -- ProcenCuoNoPag hace referencia de Cuotas No Pagadas
        SELECT COUNT(*)
        INTO Var_ProcenCuoNoPag
        FROM AMORTICREDITO a
        WHERE CreditoID = Par_CreditoID
            AND Estatus IN('B','A');
        SET Var_ProcenCuoNoPag  := IFNULL(Var_ProcenCuoNoPag, Entero_Cero);

        SET Var_MontoLiquidar := (SELECT  ROUND(sum(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                                          ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2)),  2)
                            FROM AMORTICREDITO
                            WHERE Estatus       IN ('V','A','B')
                              AND CreditoID     =  Par_CreditoID);

        SET Var_MontoLiquidar   := IFNULL(Var_MontoLiquidar,Entero_Cero);

        SET Var_DescuentoPen    := Var_SaldoAtrasado;

        SET Var_CuotasPendientes := IFNULL(Var_CuotasPendientes, Entero_Cero);

        SELECT      SUM(ROUND(SaldoNotCargoRev, 2) + ROUND(SaldoNotCargoSinIVA, 2))
            INTO    Var_NotCargoSinIva
            FROM    AMORTICREDITO
            WHERE   CreditoID = Par_CreditoID
              AND   Estatus <> EstatusPagado;

        SELECT      SUM(ROUND(SaldoNotCargoConIVA, 2))
            INTO    Var_NotCargoConIva
            FROM    AMORTICREDITO
            WHERE   CreditoID = Par_CreditoID
              AND   Estatus <> EstatusPagado;

        SET Var_NotCargoSinIva  := IFNULL(Var_NotCargoSinIva, Entero_Cero);
        SET Var_NotCargoConIva  := IFNULL(Var_NotCargoConIva, Entero_Cero);

        IF (Var_CliPagIVA = Con_SI) THEN

            SET Var_IvaNotasCargo   := Var_NotCargoConIva * Var_IVA;
            SET Var_NotCargoConIva  := Var_NotCargoConIva + Var_IvaNotasCargo;
            SET Var_NotCargoConIva  := IFNULL(Var_NotCargoConIva, Entero_Cero);

        END IF;

        SET Var_MontoLiquidar   := Var_MontoLiquidar + Var_NotCargoSinIva + Var_NotCargoConIva;

        SET Var_MontoLiquidar   := IFNULL(Var_MontoLiquidar, Entero_Cero);
        IF(Var_MontoLiquidar = Entero_Cero) THEN
            SET Par_NumErr := 009;
            SET Par_ErrMen := 'El Monto a Liquidar esta Vacio.';
            SET Var_Control := 'creditoID';
            LEAVE ManejoErrores;
        END IF;

        INSERT INTO CARTALIQUIDACIONDET(
            CartaLiquidaID,     SaldoCapital,   UltAbono,           PorcenCuoPag,       ProcenCuoNoPag,
            MontoPagado,        SaldoAtrasado,  CuotasGeneradas,    MontoTotalAdeu,     MontoPendiente,
            CuotasPagadas,      MontoPagaFec,   CuotasPendientes,   MontoLiquidar,      DescuentoPen,
            FechaUltDescuento,  CodigoQR,       EmpresaID,          Usuario,            FechaActual,
            DireccionIP,        ProgramaID,     Sucursal,           NumTransaccion)
        VALUES (
            Var_CartaLiqID,         Var_SaldoCapital,   Var_UltimoAbono,        Var_PorcenCuoPag,   Var_ProcenCuoNoPag,
            Var_MontoPagado,        Var_SaldoAtrasado,  Var_CuotasGeneradas,    Var_MontoTotalAdeu, Var_MontoPendiente,
            Var_CuotasPagadas,      Var_MontoPagaFec,   Var_CuotasPendientes,   Var_MontoLiquidar,  Var_DescuentoPen,
            Var_FechaUltDescuento,  Cadena_Vacia,       Aud_EmpresaID,          Aud_Usuario,        Aud_FechaActual,
            Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);


        SET Par_NumErr      := 000;
        SET Par_ErrMen      := CONCAT("Carta de Liquidación Agregada Exitosamente: ", CONVERT(Par_CreditoID, CHAR));
        SET Var_Control     := 'creditoID';

    END ManejoErrores;

    IF(Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr      AS NumErr,
                Par_ErrMen      AS ErrMen,
                Var_Control     AS Control,
                Par_CreditoID   AS Consecutivo,
                Var_CartaLiqID  AS CampoGenerico;
    END IF;

END TerminaStore$$