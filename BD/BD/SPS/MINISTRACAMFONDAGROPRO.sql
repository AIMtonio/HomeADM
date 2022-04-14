-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACAMFONDAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACAMFONDAGROPRO`;
DELIMITER $$

CREATE PROCEDURE `MINISTRACAMFONDAGROPRO`(
# =====================================================================================
# ----- STORE PARA ALTA DE UN CREDITO PASIVO ORIGINADO POR CAMBIO DE FUENTE DE FONDEO---
# =====================================================================================
    Par_CreditoFondeoID                         BIGINT(20),                     --  Numero de Fondeo de Crédito
    Par_CreditoID                               BIGINT(12),                     --  Numero de Crédito
    Par_Monto                                   DECIMAL(14,2),                  --  Monto de desembolsado
    Par_TipoCalculoInteres                      CHAR(1),                        --  Tipo de Calculo de interes fechaPactada : P, fechaReal: R
    Par_FechaInicio                             DATE,                           --  Fecha de Inicio
    Par_PolizaID                                BIGINT(12),                     --  ID de la poliza en caso de generar nuevo credito pasivo

    Par_Salida                                  CHAR(1),                        --  Salida S:Si N:No
    INOUT Par_NumErr                            INT(11),                        --  Numero de Error
    INOUT Par_ErrMen                            VARCHAR(400),                   --  Mensaje de Error

    INOUT Par_Consecutivo                       BIGINT(20),
    /*Parametros de Auditoria*/
    Par_EmpresaID                               INT(11),
    Aud_Usuario                                 INT(11),
    Aud_FechaActual                             DATETIME,
    Aud_DireccionIP                             VARCHAR(15),
    Aud_ProgramaID                              VARCHAR(50),
    Aud_Sucursal                                INT(11),
    Aud_NumTransaccion                          BIGINT(20)
)
TerminaStore: BEGIN
    -- DECLARACION DE VARIABLES
    DECLARE Var_AcfectacioConta                 CHAR(1);                        --  VARIA DE AFECTACION CONTABLE SI='S',NO='N'
    DECLARE Var_AmortizacionID                  INT(11);                        --  Variables para el CURSOR
    DECLARE Var_AmortizID                       INT(11);                        --  Variables para el CURSOR
    DECLARE Var_Cantidad                        DECIMAL(14,2);                  --  Variable para el CURSOR
    DECLARE Var_CapitalizaInteres               CHAR(1);                        --  Capitaliza Interes
    DECLARE Var_CobraISR                        CHAR(1);                        --  Indica si cobra o no ISR Si = S No = N
    DECLARE Var_ComDis                          INT(11);                        --  Cta. comision por disposicion  con la tabla CONCEPTOSFONDEO
    DECLARE Var_ComDispos                       DECIMAL(12,2);                  --  Comision por disposicion.
    DECLARE Var_ConcepConDes                    INT(11);                        --  concepto de contable  de DESEMBOLSO DE CREDITO CREDITO PASIVO tabla CONCEPTOSCONTA
    DECLARE Var_ConcepFonCap                    INT(11);                        --  concepto de capital que corresponde con la tabla CONCEPTOSFONDEO
    DECLARE Var_Control                         VARCHAR(100);
    DECLARE Var_Crecientes                      CHAR(1);                        --  Indica el tipo de pago de capital Creciente
    DECLARE Var_CreditoFondeoID                 BIGINT(12);                     --  Variables para el CURSOR
    DECLARE Var_CreditoID                       BIGINT(12);                     --  Variables para el CURSOR
    DECLARE Var_CtaOrdAbo                       INT(11);                        --  Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO
    DECLARE Var_CtaOrdCar                       INT(11);                        --  Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO
    DECLARE Var_CuentaClabe                     VARCHAR(18);                    --  Cuenta Clabe de la institucion
    DECLARE Var_CuotasCap                       INT(11);                        --  numero de cuotas de capital que devuelve el simulador*/
    DECLARE Var_CuotasInt                       INT(11);                        --  numero de cuotas de Interes que devuelve el simulador*/
    DECLARE Var_Descripcion                     VARCHAR(100);                   --  descripcion para los movimientos de credito pasivo
    DECLARE Var_EsHabil                         CHAR(1);
    DECLARE Var_EstatusDesembolso               CHAR(1);
    DECLARE Var_EstatusPeriodo                  CHAR(1);                        --  Almecena el Estatus del Periodo Contable
    DECLARE Var_FechaApl                        DATE;                           --  Si la fecha de operacion no es un dia habil, se guarda en esta variable el valor de dia habil*/
    DECLARE Var_FechaFinLinea                   DATE;                           --  Fecha de fin de la linea de  fondeo
    DECLARE Var_FechaMaxVenci                   DATE;                           --  Fecha de vencimiento maximo de la linea de  fondeo
    DECLARE Var_FechaSiguienteMinistracion      DATE;                           --  Fecha de la siguiente Ministracion
    DECLARE Var_FechInicLinea                   DATE;                           --  Fecha de inicio de la linea de  fondeo
    DECLARE Var_Iguales                         CHAR(1);                        --  Indica el tipo de pago de capital Igual
    DECLARE Var_InstitucionID                   INT(11);                        --  Numero de Institucion (INSTITUCIONES)
    DECLARE Var_InstitutFondID                  INT(11);                        --  id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO
    DECLARE Var_IVA                             DECIMAL(12,4);                  --  indica el valor del iva si es que Paga IVA = si
    DECLARE Var_IvaComDis                       INT(11);                        --  Cta. iva comisiÃ³n por disposicion  con la tabla CONCEPTOSFONDEO
    DECLARE Var_IvaComDispos                    DECIMAL(12,2);                  --  IVA Comision por disposicion.
    DECLARE Var_Libres                          CHAR(1);                        --  Indica el tipo de pago de capital Libre
    DECLARE Var_LineaFondeoID                   INT(11);                        --  Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR
    DECLARE Var_MonedaID                        INT(11);                        --  moneda
    DECLARE Var_MontoCancelado                  DECIMAL(14,2);                  --  Monto Cancelado de cada ministracion
    DECLARE Var_MontoComDis                     DECIMAL(12,2);                  --  monto de credito mas comision mas iva
    DECLARE Var_MontoMinistrado                 DECIMAL(14,2);                  --  Monto Ministrado se usa en el cursor
    DECLARE Var_MontoMinistradoAgro             DECIMAL(14,2);                  --  Monto ministrado hasta el momento
    DECLARE Var_MontoPendAmortAnterior          DECIMAL(14,2);
    DECLARE Var_MontoPendDesembolso             DECIMAL(14,2);                  --  Monto Saldo capital Vigente del credito
    DECLARE Var_MontoPendDesembolsoAgro         DECIMAL(14,2);
    DECLARE Var_NacionalidadIns                 CHAR(1);                        --  Especifica la nacionalidad de la institucion, corresponde con la tabla SUBCTANACINSFON
    DECLARE Var_NO                              CHAR(1);                        --  valor no
    DECLARE Var_NumCtaInstit                    VARCHAR(20);                    --  Numero de Cuenta Bancaria.
    DECLARE Var_NumTransaccion                  BIGINT(20);                     --  Variable para el Cursor
    DECLARE Var_NumTranSim                      BIGINT(20);
    DECLARE Var_PagaIVA                         CHAR(1);                        --  Indica si paga IVA valores :  Si = "S" / No = "N")
    DECLARE Var_PlazoContable                   CHAR(1);                        --  plazo contable C.- Corto plazo L.- Largo Plazo
    DECLARE Var_PolizaID                        BIGINT;
    DECLARE Var_PrimerDiaMes                    DATE;                           --  Almacena el primer dia del mes --
    DECLARE Var_SaldoCapVigent                  DECIMAL(14,2);                  --  Monto Saldo capital Vigente del credito
    DECLARE Var_SaldosInso                      INT(11);                        --  Tipo de calculo de interes Saldos Insolutos
    DECLARE Var_SI                              CHAR(1);                        --  valor si
    DECLARE Var_TasaFija                        INT(11);                        --  Indica el valor para la formula de tasa fija
    DECLARE Var_TasaISR                         DECIMAL(12,2);                  --  Tasa del ISR
    DECLARE Var_TasaPasiva                      DECIMAL(14,4);                  --  Tasa del Credito Pasivo esta tasa viene desde la LINEAFONDEADOR
    DECLARE Var_TipoFondeador                   CHAR(1);
    DECLARE Var_TipoInstitID                    INT(11);                        --  Corresponde con el campo TipoInstitID de la tabla TIPOSINSTITUCION
    DECLARE Var_EncabezadoPoliza                CHAR(1);                        --  indica si requiere encabezado de poliza
    DECLARE Var_AmortiActual                    INT(11);                        --  Amortizacion en curso
    DECLARE Var_FechaSis                        DATE;                           --  Fecha del sistema
    DECLARE Var_PrimerAmorID                    INT(11);
    DECLARE Var_FerchaAmoVen                    DATE;
    -- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia                        CHAR(1);                        --  Cadena Vacia
    DECLARE Decimal_Cero                        DECIMAL(12,2);                  --  Decimal en Cero
    DECLARE Entero_Cero                         INT;                            --  Entero en Cero
    DECLARE Entero_Uno                          INT;                            --  Entero Uno
    DECLARE Est_Vigente                         CHAR(1);                        --  Estatus Vigente corresponde con tabla CREDITOFONDEO
    DECLARE Fecha_Vacia                         DATE;                           --  Fecha Vacia
    DECLARE Nat_Abono                           CHAR(1);                        --  Naturaleza de Abono
    DECLARE Nat_Cargo                           CHAR(1);                        --  Naturaleza de Cargo
    DECLARE Salida_NO                           CHAR(1);                        --  Valor para no devolver una Salida
    DECLARE Salida_SI                           CHAR(1);                        --  Valor para devolver una Salida
    DECLARE Constante_NO                        CHAR(1);
    DECLARE EstatusAbierto                      CHAR(1);
    DECLARE Mov_CapVigente                      INT(4);                         --  Tipo del Movimiento de Credito Pasivo: Capital Vigente (TIPOSMOVSFONDEO)
    DECLARE OtorgaCrePasID                      CHAR(4);                        --  ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO
    DECLARE Estatus_NoDesembolsada              CHAR(1);
    DECLARE EstatusDesembolsada                 CHAR(1);
    DECLARE ProcesoMinistra                     CHAR(1);                        --  proceso desembolso pantalla
    DECLARE ProcesoCambioFondeo                 CHAR(1);                        --  proceso cambio de fuente de fondeo
    DECLARE EstatusPagado                       CHAR(1);                        -- estatus pagado
    DECLARE EstatusCancelado                    CHAR(1);
    DECLARE Act_TipoActInteres                  INT(11);

    DECLARE CURSORFONDEOMOVS CURSOR FOR
    SELECT AMO.CreditoFondeoID,  AMO.AmortizacionID, Aud_NumTransaccion, AMO.SaldoCapVigente
        FROM
            AMORTIZAFONDEO AS AMO INNER JOIN
            CREDITOFONDEO AS CRED ON AMO.CreditoFondeoID = CRED.CreditoFondeoID
        WHERE
            CRED.CreditoFondeoID = Par_CreditoFondeoID
            AND CRED.Estatus =Var_NO
            AND AMO.Capital> Entero_Cero
            AND AMO.Estatus = Var_NO;
    -- ASIGNACION DE VARIABLES
    SET Var_ComDis                              := 17;                          --  Cta. comision por disposicion  con la tabla CONCEPTOSFONDEO
    SET Var_ConcepConDes                        := 23;                          --  concepto de contable  de DESEMBOLSO DE CREDITO CREDITO PASIVO tabla CONCEPTOSCONTA
    SET Var_ConcepFonCap                        := 1;                           --  concepto de capital que corresponde con la tabla CONCEPTOSFONDEO
    SET Var_CtaOrdAbo                           := 12;                          --  Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO
    SET Var_CtaOrdCar                           := 11;                          --  Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO
    SET Var_Iguales                             := 'I';                         --  Indica el tipo de pago de capital Igual
    SET Var_IvaComDis                           := 18;                          --  Cta. Iva comisiÃ³n por disposicion  con la tabla CONCEPTOSFONDEO
    SET Var_Libres                              := 'L';                         --  Indica el tipo de pago de capital Libre
    SET Var_NO                                  := 'N';                         --  Valor SI
    SET Var_SaldosInso                          := 1;                           --  Tipo de calculo de interes Saldos Insolutos
    SET Var_SI                                  := 'S';                         --  Valor SI
    SET Var_TasaFija                            := 1;                           --  Indica el valor para la formula de tasa fija
    SET Var_Descripcion                         := 'OTORGAMIENTO DE CREDITO PASIVO';  --  descripcion para los movimientos de credito pasivo
    -- ASIGNACION DE CONSTANTES
    SET Aud_FechaActual                         := NOW();                       --  Toma fecha actual
    SET Cadena_Vacia                            := '';                          --  Cadena Vacia
    SET Constante_NO                            := 'N';
    SET Decimal_Cero                            := 0.00;                        --  Valor para devolver una Salida
    SET Entero_Cero                             := 0;                           --  Entero en Cero
    SET Entero_Uno                              := 1;                           --  Entero Uno
    SET Est_Vigente                             := 'N';                         --  Estatus Vigente corresponde con tabla CREDITOFONDEO/AMORTIZAFONDEO
    SET EstatusAbierto                          := 'N';                         --  Estatus Abierto del periodo contable, N significa No cerrado
    SET Fecha_Vacia                             := '1900-01-01';                --  Fecha Vacia
    SET Mov_CapVigente                          := 1;                           --  Tipo del Movimiento de Credito Pasivo: Capital Vigente (TIPOSMOVSFONDEO)
    SET Nat_Abono                               := 'A';                         --  Naturaleza de Abono
    SET Nat_Cargo                               := 'C';                         --  Naturaleza de Cargo
    SET Salida_NO                               := 'N';                         --  Valor para no devolver una Salida
    SET Salida_SI                               := 'S';                         --  Valor para devolver una Salida
    SET OtorgaCrePasID                          := 30;                          --  ID del TIPOSMOVTESO - OTORGAMIENTO CREDITO PASIVO
    SET EstatusDesembolsada                     := 'D';                         --  Estatus de la Solicitud: Desembolsada
    SET ProcesoMinistra                         := 'M';
    SET ProcesoCambioFondeo                     := 'F';
    SET EstatusPagado                           := 'P';
    SET Estatus_NoDesembolsada                  := 'N';
    SET EstatusCancelado                        := 'C';
    SET Act_TipoActInteres                      := 1;                          --  Fondeo por Financiamiento

    ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  := 999;
            SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-MINISTRACAMFONDAGROPRO');
            SET Var_Control := 'sqlException';
        END;

        SET Var_FechaSis := (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
                                    WHERE EmpresaID = Par_EmpresaID);

        SELECT
            LineaFondeoID,          PagaIva,            ComDispos,              IvaComDispos,       PorcentanjeIVA,
            TipoFondeador,          MonedaID,           NumCtaInstit,           PlazoContable,      CobraISR,
            TasaISR,                TipoInstitID,       NacionalidadIns,        CuentaClabe,        InstitutFondID,
            CapitalizaInteres
        INTO
            Var_LineaFondeoID,      Var_PagaIVA,        Var_ComDispos,          Var_IvaComDispos,   Var_IVA,
            Var_TipoFondeador,      Var_MonedaID,       Var_NumCtaInstit,       Var_PlazoContable,  Var_CobraISR,
            Var_TasaISR,            Var_TipoInstitID,   Var_NacionalidadIns,    Var_CuentaClabe,    Var_InstitutFondID,
            Var_CapitalizaInteres
        FROM CREDITOFONDEO
            WHERE CreditoFondeoID = Par_CreditoFondeoID;

        SELECT
            lin.TasaPasiva,             lin.InstitucionID
            INTO
            Var_TasaPasiva,         Var_InstitucionID
            FROM LINEAFONDEADOR lin,
                INSTITUTFONDEO ins
                WHERE LineaFondeoID = Var_LineaFondeoID
                    AND ins.InstitutFondID = lin.InstitutFondID
                    LIMIT 1;

        SET @Var_ConsecutivoID= Entero_Cero;

        -- INSERTAR LAS AMORTIZACIONES DEL CALENDARIO IDEAL DEAGRO EN EL CALENDARIO IDEAL
        INSERT INTO AMORTIZAFONDEOAGRO(
            CreditoFondeoID,            AmortizacionID,         FechaInicio,            FechaVencimiento,           FechaExigible,
            FechaLiquida,               Estatus,                Capital,                Interes,                    IVAInteres,
            SaldoCapVigente,            SaldoCapAtrasad,        SaldoInteresAtra,       SaldoInteresPro,            SaldoIVAInteres,
            SaldoMoratorios,            SaldoIVAMora,           SaldoComFaltaPa,        SaldoIVAComFalP,            SaldoOtrasComis,
            SaldoIVAComisi,             ProvisionAcum,          SaldoCapital,           SaldoRetencion,             Retencion,
            EstatusDesembolso,          MontoPendDesembolso,    TipoCalculoInteres,     EmpresaID,                  Usuario,
            FechaActual,                DireccionIP,            ProgramaID,             Sucursal,                   NumTransaccion)
        SELECT
            Par_CreditoFondeoID,        (@Var_ConsecutivoID:=@Var_ConsecutivoID+Entero_Uno),                        FechaInicio,
            FechaVencim,                FechaExigible,          Fecha_Vacia,            Est_Vigente,                Capital,
            Entero_Cero,                Entero_Cero,            SaldoCapVigente,        Entero_Cero,                Entero_Cero,
            Entero_Cero,                Entero_Cero,            Entero_Cero,            Entero_Cero,                Entero_Cero,
            Entero_Cero,                Entero_Cero,            Entero_Cero,            Entero_Cero,                SaldoCapVigente,
            Entero_Cero,                Entero_Cero,            EstatusDesembolso,      Capital,                    TipoCalculoInteres,
            EmpresaID,                  Usuario,                FechaActual,            DireccionIP,                ProgramaID,
            Sucursal,                   NumTransaccion
        FROM AMORTICREDITOAGRO
            WHERE CreditoID = Par_CreditoID
                AND FechaVencim >=Var_FechaSis
                    AND Estatus <> EstatusPagado;

        UPDATE AMORTIZAFONDEOAGRO AS FOND INNER JOIN AMORTICREDITOAGRO AS AMO ON FOND.CreditoFondeoID = Par_CreditoFondeoID AND AMO.CreditoID = Par_CreditoID AND FOND.AmortizacionID = AMO.AmortizacionID SET
            FOND.TipoCalculoInteres = AMO.TipoCalculoInteres
            WHERE CreditoFondeoID = Par_CreditoFondeoID;

        SET @Var_ConsecutivoID= Entero_Cero;


        INSERT INTO AMORTIZAFONDEO(
            CreditoFondeoID,                    AmortizacionID,             FechaInicio,                FechaVencimiento,           FechaExigible,
            FechaLiquida,                       Estatus,                    Capital,                    Interes,                    IVAInteres,
            SaldoCapVigente,                    SaldoCapAtrasad,            SaldoInteresAtra,           SaldoInteresPro,            SaldoIVAInteres,
            SaldoMoratorios,                    SaldoIVAMora,               SaldoComFaltaPa,            SaldoIVAComFalP,            SaldoOtrasComis,
            SaldoIVAComisi,                     ProvisionAcum,              SaldoCapital,               SaldoRetencion,             Retencion,
            EmpresaID,                          Usuario,                    FechaActual,                DireccionIP,                ProgramaID,
            Sucursal,                           NumTransaccion)
        SELECT
            Par_CreditoFondeoID,                (@Var_ConsecutivoID:=@Var_ConsecutivoID+Entero_Uno),    AMO.FechaInicio,            AMO.FechaVencim,
            AMO.FechaExigible,                  Fecha_Vacia,                Var_NO,                     AMO.Capital,                Decimal_Cero,
            Decimal_Cero,                       AMO.SaldoCapVigente,        Decimal_Cero,               Decimal_Cero,               Decimal_Cero,
            Decimal_Cero,                       Decimal_Cero,               Decimal_Cero,               Decimal_Cero,               Decimal_Cero,
            Decimal_Cero,                       Decimal_Cero,               Decimal_Cero,               AMO.SaldoCapital,           Decimal_Cero,
            Decimal_Cero,                       Par_EmpresaID,              Aud_Usuario,                Aud_FechaActual,            Aud_DireccionIP,
            Aud_ProgramaID,                     Aud_Sucursal,               AMO.NumTransaccion
        FROM AMORTICREDITO AS AMO
            WHERE AMO.CreditoID = Par_CreditoID
                AND AMO.Estatus<>EstatusPagado;

        SET Var_FerchaAmoVen :=(SELECT FechaVencimiento FROM AMORTIZAFONDEO WHERE CreditoFondeoID= Par_CreditoFondeoID
                                    AND AmortizacionID= Entero_Uno);

        -- Actualizamos la fecha de la primer amortizacion al dia actual
        IF(Var_FerchaAmoVen<Var_FechaSis)THEN
            UPDATE AMORTIZAFONDEO SET
                FechaInicio = Var_FerchaAmoVen
            WHERE CreditoFondeoID = Par_CreditoFondeoID
                AND AmortizacionID = Entero_Uno;
        ELSE
            UPDATE AMORTIZAFONDEO SET
                FechaInicio = Var_FechaSis
            WHERE CreditoFondeoID = Par_CreditoFondeoID
                AND AmortizacionID = Entero_Uno;
        END IF;

        -- Actualizar intereses
        CALL AMORTIZAFONDEOACT(
            Par_CreditoFondeoID,    Act_TipoActInteres,     Par_TipoCalculoInteres,     Var_NO,             Par_NumErr,
            Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,                Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero) THEN
            LEAVE ManejoErrores;
        END IF;

        UPDATE AMORTIZAFONDEOAGRO AMO  INNER JOIN AMORTIZAFONDEO  AM ON AMO.CreditoFondeoID = AM.CreditoFondeoID SET
            AMO.FechaInicio     = AM.FechaInicio,
            AMO.Interes         = AM.Interes,
            AMO.IVAInteres      = AMO.IVAInteres,
            AMO.SaldoCapVigente = AM.SaldoCapVigente
        WHERE AMO.CreditoFondeoID= Par_CreditoFondeoID
        AND AMO.AmortizacionID=AM.AmortizacionID;

        UPDATE AMORTIZAFONDEOAGRO AMO INNER JOIN RELCREDPASIVOAGRO REL ON AMO.CreditoFondeoID=REL.CreditoFondeoID AND REL.EstatusRelacion='V'
        INNER JOIN AMORTICREDITOAGRO  AM ON AM.CreditoID=REL.CreditoID SET
            AMO.MontoPendDesembolso     = AM.MontoPendDesembolso
        WHERE AMO.CreditoFondeoID= Par_CreditoFondeoID
            AND AMO.AmortizacionID=AM.AmortizacionID;
        SELECT
            FechInicLinea,      FechaFinLinea,      FechaMaxVenci,      CobraISR    ,AfectacionConta
            INTO
            Var_FechInicLinea,  Var_FechaFinLinea,  Var_FechaMaxVenci,  Var_CobraISR, Var_AcfectacioConta
            FROM LINEAFONDEADOR lin,
                INSTITUTFONDEO ins
                WHERE LineaFondeoID     = Var_LineaFondeoID
                    AND ins.InstitutFondID = lin.InstitutFondID LIMIT Entero_Uno;

        SET Var_FechInicLinea   := IFNULL(Var_FechInicLinea,Fecha_Vacia);
        SET Var_FechaFinLinea   := IFNULL(Var_FechaFinLinea,Fecha_Vacia);
        SET Var_FechaMaxVenci   := IFNULL(Var_FechaMaxVenci,Fecha_Vacia);


        CALL DIASFESTIVOSCAL(
            Par_FechaInicio,    Entero_Cero,        Var_FechaApl,       Var_EsHabil,        Par_EmpresaID,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);
        -- se verifica si se paga o no ISR
        IF( IFNULL(Var_CobraISR,Cadena_Vacia) = Var_SI) THEN
            SET Var_TasaISR:= Var_TasaISR;
        ELSE
            SET Var_TasaISR:= Entero_Cero;
        END IF;

        -- Se actualiza la linea de fondeo de credito
        CALL SALDOSLINEAFONACT(
            Var_LineaFondeoID,  Nat_Cargo,          Par_Monto,          Salida_NO,              Par_NumErr,
            Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,                    Aud_FechaActual,        Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


        IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
            LEAVE ManejoErrores;
        END IF;

        SET Var_EncabezadoPoliza    := Var_NO;
        SET Var_PolizaID            := Par_PolizaID;


        -- Se manda a llamar sp para hacer la parte contable por el monto total desembolsado.
        CALL CONTAFONDEOPRO(
            Var_MonedaID,                           Var_LineaFondeoID,                      Var_InstitutFondID,     Var_InstitucionID,      Var_NumCtaInstit,
            Par_CreditoFondeoID,                    Var_PlazoContable,                      Var_TipoInstitID,       Var_NacionalidadIns,    Var_ConcepFonCap,
            Var_Descripcion,                        Par_FechaInicio,                        Par_FechaInicio,        Par_FechaInicio,        Par_Monto,
            CONVERT(Par_CreditoFondeoID,CHAR),      CONVERT(Par_CreditoFondeoID,CHAR),      Var_EncabezadoPoliza,   Var_ConcepConDes,       Nat_Abono,
            Nat_Cargo,                              Nat_Cargo,                              Nat_Abono,              Var_NO,                 OtorgaCrePasID,
            Var_NO,                                 Entero_Cero,                            Mov_CapVigente,         Var_SI,                 Var_TipoFondeador,
            Salida_NO,                              Var_PolizaID,                           Par_Consecutivo,        Par_NumErr,             Par_ErrMen,
            Par_EmpresaID,                          Aud_Usuario,                            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
            Aud_Sucursal,                           Aud_NumTransaccion);

        IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
            LEAVE ManejoErrores;
        END IF;

        -- CUENTA ORDEN LINEA DE FONDEO --
        IF(Var_AcfectacioConta = Var_SI)THEN
            -- --------------------------------------------------------------------------------------
            -- Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
            -- contingente (Cargo)
            -- --------------------------------------------------------------------------------------
            CALL CONTAFONDEOPRO(
                Var_MonedaID,                           Var_LineaFondeoID,                      Var_InstitutFondID,     Var_InstitucionID,      Var_NumCtaInstit,
                Par_CreditoFondeoID,                    Var_PlazoContable,                      Var_TipoInstitID,       Var_NacionalidadIns,    Var_CtaOrdCar,
                Var_Descripcion,                        Par_FechaInicio,                        Par_FechaInicio,        Par_FechaInicio,        Par_Monto,
                CONVERT(Par_CreditoFondeoID,CHAR),      CONVERT(Par_CreditoFondeoID,CHAR),      Var_NO,                 Var_ConcepConDes,       Nat_Abono,
                Nat_Abono,                              Nat_Abono,                              Nat_Abono,              Var_NO,                 OtorgaCrePasID,
                Var_NO,                                 Entero_Cero,                            Mov_CapVigente,         Var_SI,                 Var_TipoFondeador,
                Salida_NO,                              Var_PolizaID,                           Par_Consecutivo,        Par_NumErr,             Par_ErrMen,
                Par_EmpresaID,                          Aud_Usuario,                            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
                Aud_Sucursal,                           Aud_NumTransaccion  );

            IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
                LEAVE ManejoErrores;
            END IF;

            -- --------------------------------------------------------------------------------------
            -- Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
            -- contingente (Abono)
            -- --------------------------------------------------------------------------------------
            CALL CONTAFONDEOPRO(
                Var_MonedaID,                           Var_LineaFondeoID,                      Var_InstitutFondID,     Var_InstitucionID,      Var_NumCtaInstit,
                Par_CreditoFondeoID,                    Var_PlazoContable,                      Var_TipoInstitID,       Var_NacionalidadIns,    Var_CtaOrdAbo,
                Var_Descripcion,                        Par_FechaInicio,                        Par_FechaInicio,        Par_FechaInicio,        Par_Monto,
                CONVERT(Par_CreditoFondeoID,CHAR),      CONVERT(Par_CreditoFondeoID,CHAR),      Var_NO,                 Var_ConcepConDes,       Nat_Cargo,
                Nat_Cargo,                              Nat_Cargo,                              Nat_Cargo,              Var_NO,                 OtorgaCrePasID,
                Var_NO,                                 Entero_Cero,                            Mov_CapVigente,         Var_SI,                 Var_TipoFondeador,
                Salida_NO,                              Var_PolizaID,                           Par_Consecutivo,        Par_NumErr,             Par_ErrMen,
                Par_EmpresaID,                          Aud_Usuario,                            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
                Aud_Sucursal,                           Aud_NumTransaccion  );

            IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
            LEAVE ManejoErrores;
            END IF;
        END IF; -- Afectacion contable Linea
        -- FIN CUENTA ORDEN LINEA DE FONDEO

        -- SI HAY COMISION POR DISPOSICION (AUNQUE EN CREDITOS PASIVOS AGROPECUARIOS NO APLICARIA)
        IF(IFNULL(Var_ComDispos, Decimal_Cero)) >Decimal_Cero THEN -- si hay una comision por disposicion
            -- Se manda a llamar sp para hacer la parte contable
            CALL CONTAFONDEOPRO(
                Var_MonedaID,                           Var_LineaFondeoID,                      Var_InstitutFondID,     Var_InstitucionID,      Var_NumCtaInstit,
                Par_CreditoFondeoID,                    Var_PlazoContable,                      Var_TipoInstitID,       Var_NacionalidadIns,    Var_ComDis,
                Var_Descripcion,                        Par_FechaInicio,                        Par_FechaInicio,        Par_FechaInicio,        Var_ComDispos,
                CONVERT(Par_CreditoFondeoID,CHAR),      CONVERT(Par_CreditoFondeoID,CHAR),      Var_NO,                 Var_ConcepConDes,       Nat_Cargo,
                Nat_Cargo,                              Nat_Cargo,                              Nat_Abono,              Var_NO,                 OtorgaCrePasID,
                Var_NO,                                 Entero_Cero,                            Mov_CapVigente,         Var_SI,                 Var_TipoFondeador,
                Salida_NO,                              Var_PolizaID,                           Par_Consecutivo,        Par_NumErr,             Par_ErrMen,
                Par_EmpresaID,                          Aud_Usuario,                            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
                Aud_Sucursal,                           Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
                LEAVE ManejoErrores;
            END IF;

            IF(IFNULL(Var_IvaComDispos, Decimal_Cero)) >Decimal_Cero THEN -- si hay un iva de comision por disposicion
                -- Se manda a llamar sp para hacer la parte contable
                CALL CONTAFONDEOPRO(
                Var_MonedaID,                               Var_LineaFondeoID,                      Var_InstitutFondID,     Var_InstitucionID,          Var_NumCtaInstit,
                Par_CreditoFondeoID,                        Var_PlazoContable,                      Var_TipoInstitID,       Var_NacionalidadIns,        Var_IvaComDis,
                Var_Descripcion,                            Par_FechaInicio,                        Par_FechaInicio,        Par_FechaInicio,            Var_IvaComDispos,
                CONVERT(Par_CreditoFondeoID,CHAR),          CONVERT(Par_CreditoFondeoID,CHAR),      Var_NO,                 Var_ConcepConDes,           Nat_Cargo,
                Nat_Cargo,                                  Nat_Cargo,                              Nat_Abono,              Var_NO,                     OtorgaCrePasID,
                Var_NO,                                     Entero_Cero,                            Mov_CapVigente,         Var_SI,                     Var_TipoFondeador,
                Salida_NO,                                  Var_PolizaID,                           Par_Consecutivo,        Par_NumErr,                 Par_ErrMen,
                Par_EmpresaID,                              Aud_Usuario,                            Aud_FechaActual,        Aud_DireccionIP,            Aud_ProgramaID,
                Aud_Sucursal,                               Aud_NumTransaccion);

                IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
                    LEAVE ManejoErrores;
                END IF;
            END IF; -- iva comision por disposicion
        END IF; -- Comision por disposicion

        -- Se insertan los movimientos de tesoreria
        SET Var_MontoComDis := Par_Monto -IFNULL(Var_IvaComDispos, Decimal_Cero)-IFNULL(Var_ComDispos, Decimal_Cero);
        -- Se manda a llamar sp para hacer la parte contable
        CALL CONTAFONDEOPRO(
            Var_MonedaID,                           Var_LineaFondeoID,                  Var_InstitutFondID,     Var_InstitucionID,          Var_NumCtaInstit,
            Par_CreditoFondeoID,                    Var_PlazoContable,                  Var_TipoInstitID,       Var_NacionalidadIns,        Var_ConcepFonCap,
            Var_Descripcion,                        Par_FechaInicio,                    Par_FechaInicio,        Par_FechaInicio,            Var_MontoComDis,
            CONVERT(Par_CreditoFondeoID,CHAR),      CONVERT(Par_CreditoFondeoID,CHAR),  Var_NO,                 Var_ConcepConDes,           Nat_Abono,
            Nat_Cargo,                              Nat_Cargo,                          Nat_Abono,              Var_SI,                     OtorgaCrePasID,
            Var_NO,                                 Entero_Cero,                        Mov_CapVigente,         Var_NO,                     Var_TipoFondeador,
            Salida_NO,                              Var_PolizaID,                       Par_Consecutivo,        Par_NumErr,                 Par_ErrMen,
            Par_EmpresaID,                          Aud_Usuario,                        Aud_FechaActual,        Aud_DireccionIP,            Aud_ProgramaID,
            Aud_Sucursal,                           Aud_NumTransaccion);

        IF(Par_NumErr <> Entero_Cero) THEN
            SET Par_CreditoFondeoID := Entero_Cero;
            LEAVE ManejoErrores;
        END IF;

        OPEN CURSORFONDEOMOVS;
            BEGIN
                DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                CICLO:LOOP
                FETCH CURSORFONDEOMOVS INTO
                    Var_CreditoID,  Var_AmortizID,  Var_NumTransaccion, Var_Cantidad;

                    -- Actualiza el saldo cap. a ceros
                    UPDATE AMORTIZAFONDEO
                        SET SaldoCapVigente=Decimal_Cero
                    WHERE CreditoFondeoID = Par_CreditoFondeoID
                    AND AmortizacionID=Var_AmortizID;


                    CALL CREDITOFONDMOVSALT(
                        Var_CreditoID,                      Var_AmortizID,                  Var_NumTransaccion,             Var_FechaApl,                   Var_FechaApl,
                        Mov_CapVigente,                     Nat_Cargo,                      Var_MonedaID,                   Var_Cantidad,                   'DESEMBOLSO',
                        Par_CreditoID,                      Var_NO,                         Par_NumErr,                     Par_ErrMen,                     Par_Consecutivo,
                        Par_EmpresaID,                      Aud_Usuario,                    Aud_FechaActual,                Aud_DireccionIP,                Aud_ProgramaID,
                        Aud_Sucursal,                       Aud_NumTransaccion);

                    IF(Par_NumErr != Entero_Cero) THEN
                        LEAVE CICLO;
                    END IF;

                    UPDATE AMORTIZAFONDEOAGRO SET
                        TmpMontoDesembolso = Entero_Cero
                    WHERE CreditoFondeoID = Var_CreditoID
                        AND AmortizacionID = Var_AmortizID;

                END LOOP CICLO;
            END;
        CLOSE CURSORFONDEOMOVS;

        IF(Par_NumErr != Entero_Cero) THEN
            LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr      := Entero_Cero;
        SET Par_ErrMen      := CONCAT('Credito Pasivo Agregado Exitosamente: ',CONVERT(Par_CreditoFondeoID,CHAR));
        SET Par_Consecutivo := Par_CreditoFondeoID;
        SET Var_Control     := 'creditoFondeoID';

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr  AS NumErr,
            Par_ErrMen      AS ErrMen,
            Var_Control     AS control,
            Par_CreditoID   AS consecutivo,
            Var_PolizaID    AS CampoGenerico;
    END IF;
END TerminaStore$$