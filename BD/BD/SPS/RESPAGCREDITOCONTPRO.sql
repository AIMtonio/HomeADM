-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPAGCREDITOCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESPAGCREDITOCONTPRO`;
DELIMITER $$

CREATE PROCEDURE `RESPAGCREDITOCONTPRO`(
/*SP para el Respaldo de los Creditos*/
    Par_CreditoID           BIGINT(12),             -- Numero de Credito

    Par_Salida              CHAR(1),                -- indica una salida
    INOUT   Par_NumErr      INT(11),                -- parametro numero de error
    INOUT   Par_ErrMen      VARCHAR(400),           -- mensaje de error

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore:BEGIN
    -- Declaracion de Variables
    DECLARE Var_Prorrateo       CHAR(2);
    DECLARE Var_InverEnGar      INT;
    -- Declaracion de Constantes
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(12,2);
    DECLARE Estatus_Vigente     CHAR(1);
    DECLARE Salida_SI           CHAR(1);
    -- Asignacion de constantes
    SET Cadena_Vacia    := '';          -- Cadena Vacia
    SET Entero_Cero     := 0;           -- Entero en Cero
    SET Decimal_Cero    := 0;           -- DECIMAL en Cero
    SET Estatus_Vigente := 'N';         -- Estatus Inversion: VIGENTE
    SET Salida_SI       := 'S';

    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
                concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-RESPAGCREDITOCONTPRO');
        END;

        -- Respaldo de la informacion  de la tabla  CREDITOSCONT antes del proceso de pago de credito
        INSERT INTO RESCREDITOSCONT (
                `TranRespaldo`,         `CreditoID`,                `LineaCreditoID`,       `ClienteID`,            `CuentaID`,
                `MonedaID`,             `ProductoCreditoID`,        `DestinoCreID`,         `MontoCredito`,         `Relacionado`,
                `SolicitudCreditoID`,   `TipoFondeo`,               `InstitFondeoID`,       `LineaFondeo`,          `FechaInicio`,
                `FechaVencimien`,       `CalcInteresID`,            `TasaBase`,             `TasaFija`,             `SobreTasa`,
                `PisoTasa`,             `TechoTasa`,                `FactorMora`,           `FrecuenciaCap`,        `PeriodicidadCap`,
                `FrecuenciaInt`,        `PeriodicidadInt`,          `TipoPagoCapital`,      `NumAmortizacion`,      `MontoCuota`,
                `FechTraspasVenc`,      `FechTerminacion`,          `IVAInteres`,           `IVAComisiones`,        `Estatus`,
                `FechaAutoriza`,        `UsuarioAutoriza`,          `SaldoCapVigent`,       `SaldoCapAtrasad`,      `SaldoCapVencido`,
                `SaldCapVenNoExi`,      `SaldoInterOrdin`,          `SaldoInterAtras`,      `SaldoInterVenc`,       `SaldoInterProvi`,
                `SaldoIntNoConta`,      `SaldoIVAInteres`,          `SaldoMoratorios`,      `SaldoIVAMorator`,      `SaldComFaltPago`,
                `SalIVAComFalPag`,      `SaldoOtrasComis`,          `SaldoIVAComisi`,       `ProvisionAcum`,
                `FechaInhabil`,         `CalendIrregular`,
                `AjusFecUlVenAmo`,      `AjusFecExiVen`,            `NumTransacSim`,        `FechaMinistrado`,
                `SucursalID`,           `ValorCAT`,                 `ClasifRegID`,          `MontoComApert`,
                `IVAComApertura`,       `PlazoID`,                  `TipoDispersion`,       `TipoCalInteres`,
                `MontoPorDesemb`,       `NumAmortInteres`,
                `ComAperPagado`,        `ForCobroComAper`,          `ClasiDestinCred`,      `CicloGrupo`,
                `GrupoID`,              `SaldoMoraVencido`,         `SaldoMoraCarVen`,
                `SaldoComAnual`,        `ComAperCont`,              `IVAComAperCont`,       `ComAperReest`,         `IVAComAperReest`,
                `FechaAtrasoCapital`,   `FechaAtrasoInteres`,
                `ManejaComAdmon`,       `ComAdmonLinPrevLiq`,       `ForCobComAdmon`,       `ForPagComAdmon`,       `PorcentajeComAdmon`,
                `ManejaComGarantia`,    `ComGarLinPrevLiq`,         `ForCobComGarantia`,    `ForPagComGarantia`,    `PorcentajeComGarantia`,
                `MontoPagComAdmon`,     `MontoCobComAdmon`,         `MontoPagComGarantia`,  `MontoCobComGarantia`,  `SaldoComServGar`,
                `SaldoIVAComSerGar`,    `MontoPagComGarantiaSim`,   `SalCapitalOriginal`,   `SalInteresOriginal`,   `SalMoraOriginal`,
                `SalComOriginal`,
                `EmpresaID`,            `Usuario`,                  `FechaActual`,          `DireccionIP`,          `ProgramaID`,
                `Sucursal`,             `NumTransaccion` )

        SELECT  Aud_NumTransaccion,     `CreditoID`,                `LineaCreditoID`,       `ClienteID`,            `CuentaID`,
                `MonedaID`,             `ProductoCreditoID`,        `DestinoCreID`,         `MontoCredito`,         `Relacionado`,
                `SolicitudCreditoID`,   `TipoFondeo`,               `InstitFondeoID`,       `LineaFondeo`,          `FechaInicio`,
                `FechaVencimien`,       `CalcInteresID`,            `TasaBase`,             `TasaFija`,             `SobreTasa`,
                `PisoTasa`,             `TechoTasa`,                `FactorMora`,           `FrecuenciaCap`,        `PeriodicidadCap`,
                `FrecuenciaInt`,        `PeriodicidadInt`,          `TipoPagoCapital`,      `NumAmortizacion`,      `MontoCuota`,
                `FechTraspasVenc`,      `FechTerminacion`,          `IVAInteres`,           `IVAComisiones`,        `Estatus`,
                `FechaAutoriza`,        `UsuarioAutoriza`,          `SaldoCapVigent`,       `SaldoCapAtrasad`,      `SaldoCapVencido`,
                `SaldCapVenNoExi`,      `SaldoInterOrdin`,          `SaldoInterAtras`,      `SaldoInterVenc`,       `SaldoInterProvi`,
                `SaldoIntNoConta`,      `SaldoIVAInteres`,          `SaldoMoratorios`,      `SaldoIVAMorator`,      `SaldComFaltPago`,
                `SalIVAComFalPag`,      `SaldoOtrasComis`,          `SaldoIVAComisi`,       `ProvisionAcum`,
                `FechaInhabil`,         `CalendIrregular`,
                `AjusFecUlVenAmo`,      `AjusFecExiVen`,            `NumTransacSim`,        `FechaMinistrado`,
                `SucursalID`,           `ValorCAT`,                 `ClasifRegID`,          `MontoComApert`,
                `IVAComApertura`,       `PlazoID`,                  `TipoDispersion`,       `TipoCalInteres`,
                `MontoPorDesemb`,       `NumAmortInteres`,
                `ComAperPagado`,        `ForCobroComAper`,          `ClasiDestinCred`,      `CicloGrupo`,
                `GrupoID`,              `SaldoMoraVencido`,         `SaldoMoraCarVen`,
                `SaldoComAnual`,        `ComAperCont`,              `IVAComAperCont`,       `ComAperReest`,         `IVAComAperReest`,
                `FechaAtrasoCapital`,   `FechaAtrasoInteres`,
                `ManejaComAdmon`,       `ComAdmonLinPrevLiq`,       `ForCobComAdmon`,       `ForPagComAdmon`,       `PorcentajeComAdmon`,
                `ManejaComGarantia`,    `ComGarLinPrevLiq`,         `ForCobComGarantia`,    `ForPagComGarantia`,    `PorcentajeComGarantia`,
                `MontoPagComAdmon`,     `MontoCobComAdmon`,         `MontoPagComGarantia`,  `MontoCobComGarantia`,  `SaldoComServGar`,
                `SaldoIVAComSerGar`,    `MontoPagComGarantiaSim`,   `SalCapitalOriginal`,   `SalInteresOriginal`,   `SalMoraOriginal`,
                `SalComOriginal`,
                `EmpresaID`,            `Usuario`,                  `FechaActual`,          `DireccionIP`,          `ProgramaID`,
                `Sucursal`,             `NumTransaccion`
        FROM CREDITOSCONT
        WHERE CreditoID = Par_CreditoID;


        -- Respaldo de la informacion  de la tabla AMORTICREDITOCONT antes del pago de Credito
        INSERT INTO RESAMORTICONT (
                `TranRespaldo`,         `AmortizacionID`,       `CreditoID`,            `ClienteID`,            `CuentaID`,
                `FechaInicio`,          `FechaVencim`,          `FechaExigible`,        `Estatus`,              `FechaLiquida`,
                `Capital`,              `Interes`,              `IVAInteres`,           `SaldoCapVigente`,      `SaldoCapAtrasa`,
                `SaldoCapVencido`,      `SaldoCapVenNExi`,      `SaldoInteresOrd`,      `SaldoInteresAtr`,      `SaldoInteresVen`,
                `SaldoInteresPro`,      `SaldoIntNoConta`,      `SaldoIVAInteres`,      `SaldoMoratorios`,      `SaldoIVAMorato`,
                `SaldoComFaltaPa`,      `SaldoIVAComFalP`,      `SaldoOtrasComis`,      `SaldoIVAComisi`,       `ProvisionAcum`,
                `SaldoCapital`,         `NumProyInteres`,       `SaldoMoraVencido`,     `SaldoMoraCarVen`,      `MontoSeguroCuota`,
                `IVASeguroCuota`,       `SaldoSeguroCuota`,     `SaldoIVASeguroCuota`,  `SaldoComisionAnual`,   `SaldoComisionAnualIVA`,
                `SalCapitalOriginal`,   `SalInteresOriginal`,   `SalMoraOriginal`,      `SalComOriginal`,       `SaldoCapitalAnt`,
                `EmpresaID`,            `Usuario`,              `FechaActual`,          `DireccionIP`,          `ProgramaID`,
                `Sucursal`,             `NumTransaccion`)

        SELECT  Aud_NumTransaccion,     `AmortizacionID`,       `CreditoID`,            `ClienteID`,            `CuentaID`,
                `FechaInicio`,          `FechaVencim`,          `FechaExigible`,        `Estatus`,              `FechaLiquida`,
                `Capital`,              `Interes`,              `IVAInteres`,           `SaldoCapVigente`,      `SaldoCapAtrasa`,
                `SaldoCapVencido`,      `SaldoCapVenNExi`,      `SaldoInteresOrd`,      `SaldoInteresAtr`,      `SaldoInteresVen`,
                `SaldoInteresPro`,      `SaldoIntNoConta`,      `SaldoIVAInteres`,      `SaldoMoratorios`,      `SaldoIVAMorato`,
                `SaldoComFaltaPa`,      `SaldoIVAComFalP`,      `SaldoOtrasComis`,      `SaldoIVAComisi`,       `ProvisionAcum`,
                `SaldoCapital`,         `NumProyInteres`,       `SaldoMoraVencido`,     `SaldoMoraCarVen`,      `MontoSeguroCuota`,
                `IVASeguroCuota`,       `SaldoSeguroCuota`,     `SaldoIVASeguroCuota`,  `SaldoComisionAnual`,   `SaldoComisionAnualIVA`,
                `SalCapitalOriginal`,   `SalInteresOriginal`,   `SalMoraOriginal`,      `SalComOriginal`,       `SaldoCapitalAnt`,
                `EmpresaID`,            `Usuario`,              `FechaActual`,          `DireccionIP`,          `ProgramaID`,
                `Sucursal`,             `NumTransaccion`
        FROM AMORTICREDITOCONT
        WHERE CreditoID = Par_CreditoID;

            -- Respalda la informacion de la tabla CREDITOSCONTMOVS antes del proceso de pago del credito
        INSERT INTO RESCREDITOSCONTMOVS (
                `TranRespaldo`,     `CreditoID`,        `AmortiCreID`,      `Transaccion`,      `FechaOperacion`,
                `FechaAplicacion`,  `TipoMovCreID`,     `NatMovimiento`,    `MonedaID`,         `Cantidad`,
                `Descripcion`,      `Referencia`,       `EmpresaID`,        `Usuario`,          `FechaActual`,
                `DireccionIP`,      `ProgramaID`,       `Sucursal`,         `NumTransaccion`)

        SELECT Aud_NumTransaccion,  `CreditoID`,        `AmortiCreID`,      `Transaccion`,      `FechaOperacion`,
                `FechaAplicacion`,  `TipoMovCreID`,     `NatMovimiento`,    `MonedaID`,         `Cantidad`,
                `Descripcion`,      `Referencia`,       `EmpresaID`,        `Usuario`,          `FechaActual`,
                `DireccionIP`,      `ProgramaID`,       `Sucursal`,         `NumTransaccion`
        FROM CREDITOSCONTMOVS
        WHERE CreditoID = Par_CreditoID;

        SET Par_NumErr      := Entero_Cero;
        SET Par_ErrMen      := 'Respaldo de Credito Contingente Realizado Exitosamente.';

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen;

    END IF;

END TerminaStore$$