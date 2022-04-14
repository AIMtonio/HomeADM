-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOCONTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOCONTALT`;

DELIMITER $$
CREATE PROCEDURE `AMORTICREDITOCONTALT`(
    # =====================================================================
    # -- SP PARA REGISTRAR LAS AMORTIZACIONES DE UN CREDITO CONTINGENTE--
    # =====================================================================
    Par_CreditoID           BIGINT(12),						-- credito ID
    Par_NumTransSim         BIGINT(20),						-- Numero de transaccion
    Par_ClienteID           INT(11),						-- Id del cliente
    Par_CuentaID            BIGINT(12),						-- ID de la cuenta
    Par_MontoCre            DECIMAL(14,2),					-- monto del credito

    Par_NumAlta             TINYINT UNSIGNED,				-- numero de alta

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(12)
)
TerminaStore: BEGIN
    -- Declaracion de Variables
    DECLARE Var_NumTotalAmor        INT;
    DECLARE Var_SumCapiAmort        DECIMAL(12,2);
    DECLARE Var_FechaVenAmort       DATE;
    DECLARE Var_Estatus             CHAR(1);
    DECLARE Var_Control             VARCHAR(50);
    -- Declaracion de constantes
    DECLARE Entero_Cero             INT;
    DECLARE SalidaNO                CHAR(1);
    DECLARE SalidaSI                CHAR(1);
    DECLARE Alta_CreNuevo           INT(11);
    DECLARE Alta_CrePasivo          INT(11);
    DECLARE Estatus_Inactivo        CHAR(1);
    DECLARE Estatus_Vigente         CHAR(1);
    DECLARE Decimal_Cero            DECIMAL(16,2);
    DECLARE Fecha_Vacia             DATE;
    -- Asignacion  de constantes
    SET Entero_Cero             := 0;           -- Constante Entero valor cero
    SET Estatus_Inactivo        := 'I';         --  Estatus Inactivo
    SET Estatus_Vigente         := 'V';         -- Estatus vigente
    SET SalidaNO                := 'N';         -- Constante Salida NO
    SET SalidaSI                := 'S';         -- Constante Salida SI
    SET Alta_CreNuevo           := 1;           -- Alta de amortizaciones para credito nuevo o renovacion
    SET Alta_CrePasivo          := 2;           -- Alta de amortizaciones para credito pasivo contingente
    SET Decimal_Cero            := 0.0;         -- DECIMAL cero
    SET Fecha_Vacia             := '1900-01-01';    -- Constante de Fecha de liquidacion

    ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTICREDITOCONTALT');
            SET Var_Control := 'SQLEXCEPTION';
        END;

        SELECT  SUM(Tmp_Capital),       MAX(Tmp_Consecutivo),   MAX(Tmp_FecFin)
            INTO    Var_SumCapiAmort,       Var_NumTotalAmor,           Var_FechaVenAmort
        FROM TMPPAGAMORSIM
            WHERE   NumTransaccion= Par_NumTransSim
                GROUP BY NumTransaccion;

        IF(Par_MontoCre != Var_SumCapiAmort) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'La Suma de Amortizaciones y el Monto de Credito No Coinciden.';
            LEAVE ManejoErrores;
        END IF;

        --  1.- Alta de amortizaciones para credito nuevo
        IF(Par_NumAlta = Alta_CreNuevo)THEN
            SET Var_Estatus := Estatus_Vigente;

            CALL AMORTICREDITOCONTBAJ(
                    Par_CreditoID,      SalidaNO,           Par_NumErr,         Par_ErrMen,     Par_EmpresaID,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
                    Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

            SET Aud_FechaActual := NOW();

            INSERT INTO AMORTICREDITOCONT(
                    AmortizacionID,         CreditoID,              ClienteID,              CuentaID,               FechaInicio,
                    FechaVencim,            FechaExigible,          Estatus,                FechaLiquida,           Capital,
                    Interes,                IVAInteres,             SaldoCapVigente,        SaldoCapAtrasa,         SaldoCapVencido,
                    SaldoCapVenNExi,        SaldoInteresOrd,        SaldoInteresAtr,        SaldoInteresVen,        SaldoInteresPro,
                    SaldoIntNoConta,        SaldoIVAInteres,        SaldoMoratorios,        SaldoIVAMorato,         SaldoComFaltaPa,
                    SaldoIVAComFalP,        SaldoOtrasComis,        SaldoIVAComisi,         ProvisionAcum,          SaldoCapital,
                    SaldoMoraVencido,       SaldoMoraCarVen,        MontoSeguroCuota,       IVASeguroCuota,         SaldoSeguroCuota,
                    SaldoIVASeguroCuota,    SaldoComisionAnual,
                    SalCapitalOriginal,     SalInteresOriginal,     SalMoraOriginal,        SalComOriginal,         SaldoCapitalAnt,
                    EmpresaID,              Usuario,                FechaActual,            DireccionIP,            ProgramaID,
                    Sucursal,               NumTransaccion)
            SELECT
                    Tmp_Consecutivo,        Par_CreditoID,          Par_ClienteID,          Par_CuentaID,           Tmp_FecIni,
                    Tmp_FecFin,             Tmp_FecVig,             Var_Estatus,            Fecha_Vacia,           	Tmp_Capital,
                    Tmp_Interes,            Tmp_Iva,                Tmp_Capital,        	Decimal_Cero,           Decimal_Cero,
                    Decimal_Cero,           Decimal_Cero,           Decimal_Cero,           Decimal_Cero,           Decimal_Cero,
                    Entero_Cero,            Decimal_Cero,           Decimal_Cero,           Decimal_Cero,           Decimal_Cero,
                    Decimal_Cero,           Decimal_Cero,           Decimal_Cero,           Entero_Cero,            Tmp_Insoluto,
                    Decimal_Cero,           Decimal_Cero,           Tmp_MontoSeguroCuota,   Tmp_IVASeguroCuota,     Decimal_Cero,
                    Decimal_Cero,           Decimal_Cero,
                    Tmp_SalCapitalOriginal, Tmp_SalInteresOriginal, Tmp_SalMoraOriginal,    Tmp_SalComOriginal,     Tmp_SalCapitalOriginal,
                    Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
                    Aud_Sucursal,           Par_NumTransSim
            FROM TMPPAGAMORSIM
                WHERE NumTransaccion    = Par_NumTransSim;
        END IF;

        --  2.- Alta de amortizaciones para credito nuevo pasivo
        IF(Par_NumAlta = Alta_CrePasivo)THEN

            SET Var_Estatus := SalidaNO;

            DELETE FROM AMORTIZAFONDEO WHERE CreditoFondeoID= Par_CreditoID;

            SET Aud_FechaActual := NOW();

            INSERT INTO AMORTIZAFONDEO(
                CreditoFondeoID,            AmortizacionID,             FechaInicio,                FechaVencimiento,           FechaExigible,
                FechaLiquida,               Estatus,                    Capital,                    Interes,                    IVAInteres,
                SaldoCapVigente,            SaldoCapAtrasad,            SaldoInteresAtra,           SaldoInteresPro,            SaldoIVAInteres,
                SaldoMoratorios,            SaldoIVAMora,               SaldoComFaltaPa,            SaldoIVAComFalP,            SaldoOtrasComis,
                SaldoIVAComisi,             ProvisionAcum,              SaldoCapital,               SaldoRetencion,             Retencion,
                EmpresaID,                  Usuario,                    FechaActual,                DireccionIP,                ProgramaID,
                Sucursal,                   NumTransaccion)

            SELECT
                Par_CreditoID,              AmortizacionID,            	FechaInicio,                FechaVencim,                FechaExigible,
                Fecha_Vacia,               	Var_Estatus,               	Capital,                    Interes,                    IVAInteres,
                SaldoCapVigente,            Decimal_Cero,               Decimal_Cero,               Decimal_Cero,               Decimal_Cero,
                Decimal_Cero,               Decimal_Cero,               Decimal_Cero,               Decimal_Cero,               Decimal_Cero,
                Decimal_Cero,               Entero_Cero,                SaldoCapital,              	Entero_Cero,				Decimal_Cero,
                Par_EmpresaID,              Aud_Usuario,                Aud_FechaActual,            Aud_DireccionIP,            Aud_ProgramaID,
                Aud_Sucursal,               Par_NumTransSim
            FROM AMORTICREDITOCONT
                WHERE NumTransaccion= Par_NumTransSim;
        END IF;

        SET Par_NumErr  := Entero_Cero;
        SET Par_ErrMen  := 'Amortizaciones Guardadas.';
        SET Var_Control := 'creditoID' ;

    END ManejoErrores;  -- END del Handler de Errores

     IF (Par_Salida = SalidaSI) THEN
        SELECT Par_NumErr       AS NumErr,
                Par_ErrMen      AS ErrMen,
                Var_Control     AS control,
                Par_CreditoID   AS consecutivo;
     END IF;

END TerminaStore$$