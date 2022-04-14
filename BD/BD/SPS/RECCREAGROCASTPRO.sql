-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RECCREAGROCASTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RECCREAGROCASTPRO`;
DELIMITER $$

CREATE PROCEDURE `RECCREAGROCASTPRO`(
/* SP PARA EL PROCESO CONTABLE DE LA RECUPERACION DE CARTERA CASTIGADA*/
    Par_CreditoID           BIGINT(12),     -- Indica el numero de Credito
    Par_FechaAplicacion     DATE,           -- Fecha de Aplicacion
    Par_SaldoRecupera       DECIMAL(14,4),  -- Monto
    Par_MonedaID            INT,            -- Moneda
    Par_ProductoCred        INT,            -- Producto del credito

    Par_ClasifCre           CHAR(1),        -- Clasificacion
    Par_SubClasifID         INT(11),        -- Sub Clasificacion
    Par_SucursalCliente     INT,            -- Sucursal del cliente
    Par_DescripcionMov      VARCHAR(100),
    Par_PolizaID            BIGINT,

    Par_Salida              CHAR(1),
    OUT Par_NumErr          INT,
    OUT Par_ErrMen          VARCHAR(400),

    OUT Par_Capital          DECIMAL(12,2),     -- CAPITAL PAGADO
    OUT Par_Interes          DECIMAL(12,2),     -- INTERES PAGADO
    OUT Par_Moratorios       DECIMAL(12,2),     -- MORATORIO PAGADO
    OUT Par_Comision         DECIMAL(12,2),     -- COMISION PAGADA
    OUT Par_IVA              DECIMAL(12,2),     -- IVA PAGADO

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
    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_TotalCastigo    DECIMAL(14,2);
    DECLARE SumaMonRecuperado   DECIMAL(14,2);

    DECLARE Var_SaldoCapital    DECIMAL(14,2);
    DECLARE Var_SaldoInteres    DECIMAL(14,2);
    DECLARE Var_SaldoMoratorio  DECIMAL(14,2);
    DECLARE Var_SaldoAccesorios DECIMAL(14,2);
    DECLARE Var_SaldoRecupera   DECIMAL(14,2);  -- SALDO PENDIENTE POR APLICAR
    DECLARE Var_MontoAplicar    DECIMAL(14,2);
    DECLARE Var_DivideCastigo   CHAR(1);
    DECLARE Var_AplicaIVA       CHAR(1);
    DECLARE Var_TasaIVA         DECIMAL(12,2);
    DECLARE Var_IVAConcepto     DECIMAL(12,2);

    -- Declaracion de Constantes
    DECLARE Entero_Cero         INT;
    DECLARE Fecha_Vacia         DATE;
    DECLARE Descripcion         VARCHAR(100);
    DECLARE Cadena_Vacia        CHAR;
    DECLARE AltaEncPolisaSI     CHAR(1);
    DECLARE AltaEncPolisaNO     CHAR(1);
    DECLARE Con_RecuCapita      INT;
    DECLARE Con_RecuInteres     INT;
    DECLARE Con_RecuMoratorio   INT;
    DECLARE Con_RecuAccesorio   INT;
    DECLARE ConceptoContable    INT;
    DECLARE Con_IVARecupera     INT;
    DECLARE Con_OrdCastigo      INT;
    DECLARE Con_CorCastigo      INT;
    DECLARE Con_OrdCasInt       INT;
    DECLARE Con_CorCasInt       INT;
    DECLARE Con_OrdCasMora      INT;
    DECLARE Con_CorCasMora      INT;
    DECLARE Con_OrdCasComi      INT;
    DECLARE Con_CorCasComi      INT;

    DECLARE AltaPolizaSI        CHAR(1);
    DECLARE AltaPolizaNO        CHAR(1);
    DECLARE AltaMovCredNO       CHAR(1);
    DECLARE Nat_Abono           CHAR(1);
    DECLARE Nat_Cargo           CHAR(1);

    DECLARE AltaMovAhorroNO     CHAR(1);
    DECLARE No_DivideCastigo    CHAR(1);
    DECLARE Pol_Automatica      CHAR(1);
    DECLARE Salida_SI           CHAR(1);
    DECLARE Salida_NO           CHAR(1);
    DECLARE SI_AplicaIVA        CHAR(1);
    DECLARE Var_TotalIVA        DECIMAL(12,2);

    DECLARE Var_CapitalApl           DECIMAL(12,2);     -- CAPITAL PAGADO
    DECLARE Var_InteresApl           DECIMAL(12,2);     -- INTERES PAGADO
    DECLARE Var_MoratoriosApl        DECIMAL(12,2);     -- MORATORIO PAGADO
    DECLARE Var_ComisionApl          DECIMAL(12,2);     -- COMISION PAGADA
    DECLARE Var_IVAApl               DECIMAL(12,2);     -- IVA PAGADO

    -- Asignacion de Constantes
    SET Entero_Cero         := 0;
    SET Fecha_Vacia         := '1900-01-01';
    SET Descripcion         := 'RECUPERACION DE CARTERA CASTIGADA';
    SET Cadena_Vacia        := '';
    SET AltaEncPolisaSI     := 'S';         -- Alta del Encabezado de la Poliza: SI
    SET AltaEncPolisaNO     := 'N';         -- Alta del Encabezado de la Poliza: NO
    SET ConceptoContable    := 63;
    SET AltaPolizaSI        := 'S';
    SET AltaPolizaNO        := 'N';

    SET AltaMovCredNO       := 'N';
    SET Con_RecuCapita      := 31;          -- Concepto Contable: Resultados. Recup. Capital Cartera Castigada
    SET Con_RecuInteres     := 46;          -- Concepto Contable: Resultados. Recup. Interes Cartera Castigada
    SET Con_RecuMoratorio   := 47;          -- Concepto Contable: Resultados. Recup. Moratorio Cartera Castigada
    SET Con_RecuAccesorio   := 48;          -- Concepto Contable: Resultados. Recup. Comisi Cartera Castigada
    SET Con_IVARecupera     := 52;          -- Concepto Contable: IVA Recuperacion C.Castigada

    SET Con_OrdCastigo      := 29;          -- Concepto Contable Cartera: Cta de Orden de Castigo
    SET Con_CorCastigo      := 30;          -- Concepto Contable Cartera: Correlativa de Orden de Castigo
    SET Con_OrdCasInt       := 40;          -- Cta. Orden Interes Cartera Castigada
    SET Con_CorCasInt       := 41;          -- Corr. Cta. Orden Interes Cartera Castigada
    SET Con_OrdCasMora      := 42;          -- Cta. Orden Moratorio Cartera Castigada
    SET Con_CorCasMora      := 43;          -- Corr. Cta. Orden Moratorio Cartera Castigada
    SET Con_OrdCasComi      := 44;          -- Cta. Orden Comisiones Cartera Castigada
    SET Con_CorCasComi      := 45;          -- Corr. Cta. Orden Comisiones Cartera Castigada

    SET No_DivideCastigo    := 'N';         -- NO Divide el Castigo de la Cartera en: Capital, Interes
    SET Pol_Automatica      := 'A';         -- Tipo de Poliza Contable: Automatica
    SET AltaMovAhorroNO     := 'N';
    SET Salida_SI           := 'S';
    SET Salida_NO           := 'N';
    SET SI_AplicaIVA        := 'S';         -- Si aplica IVA en la Recuperacion de Cartera Castigada.
    SET Nat_Abono           := 'A';         -- Naturaleza Contable: Abono
    SET Nat_Cargo           := 'C';         -- Naturaleza Contable: Cargo
    SET Var_TotalIVA        := 0.00;        -- Total del IVA Cobrado

    SET Var_CapitalApl      := 0.00;        -- Capital Aplicado
    SET Var_InteresApl      := 0.00;        -- INTERES Aplicado
    SET Var_MoratoriosApl   := 0.00;        -- MORATORIO Aplicado
    SET Var_ComisionApl     := 0.00;        -- COMISION Aplicado

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP-RECCREAGROCASTPRO');
            SET Var_Control = 'sqlException';
    END;

    SET SumaMonRecuperado = Par_SaldoRecupera;

    -- PARAMETROS PARA EL CASTIGO
    SELECT   DivideCastigo,     IVARecuperacion
        INTO Var_DivideCastigo, Var_AplicaIVA
        FROM PARAMSRESERVCASTIG
        WHERE EmpresaID = Par_EmpresaID;

    SET Var_DivideCastigo   := IFNULL(Var_DivideCastigo, No_DivideCastigo);


    -- Verifica Que todo vaya a una misma cuenta contable si no divide la contabilidad del Castigo
    IF(Var_DivideCastigo = No_DivideCastigo) THEN
        SET Con_RecuInteres := Con_RecuCapita;
        SET Con_RecuMoratorio := Con_RecuCapita;
        SET Con_RecuAccesorio := Con_RecuCapita;

        SET Con_CorCasComi  := Con_CorCastigo;
        SET Con_OrdCasComi  := Con_OrdCastigo;
        SET Con_CorCasMora  := Con_CorCastigo;
        SET Con_OrdCasMora  := Con_OrdCastigo;
        SET Con_CorCasInt   := Con_CorCastigo;
        SET Con_OrdCasInt   := Con_OrdCastigo;

    END IF;

    -- Consideraciones del IVA
    SET Var_TasaIVA := Entero_Cero;
    SET Var_AplicaIVA   := IFNULL(Var_AplicaIVA, SI_AplicaIVA);
    IF(Var_AplicaIVA = SI_AplicaIVA) THEN
        SELECT Suc.IVA INTO Var_TasaIVA
        FROM CREDITOS Cre,
             SUCURSALES Suc
        WHERE CreditoID = Par_CreditoID
          AND Cre.SucursalID = Suc.SucursalID;
    END IF;
    SET Var_TasaIVA     := IFNULL(Var_TasaIVA, Entero_Cero);
    SET Var_TotalCastigo := ROUND((Var_TotalCastigo * (1 + Var_TasaIVA)), 2 );


    -- DATOS GENERALES DEL CREDITO CASTIGADO
    SELECT  TotalCastigo,     SaldoCapital,     SaldoInteres,      SaldoMoratorio,
            SaldoAccesorios
       INTO Var_TotalCastigo, Var_SaldoCapital, Var_SaldoInteres,  Var_SaldoMoratorio,
            Var_SaldoAccesorios
    FROM CRECASTIGOS
    WHERE CreditoID = Par_CreditoID;

    -- Inicializaciones
    SET Par_SaldoRecupera   := IFNULL(Par_SaldoRecupera, Entero_Cero);
    SET Var_TotalCastigo    := IFNULL(Var_TotalCastigo, Entero_Cero );
    SET Var_SaldoCapital    := IFNULL(Var_SaldoCapital, Entero_Cero );
    SET Var_SaldoInteres    := IFNULL(Var_SaldoInteres, Entero_Cero );
    SET Var_SaldoMoratorio  := IFNULL(Var_SaldoMoratorio, Entero_Cero );
    SET Var_SaldoAccesorios := IFNULL(Var_SaldoAccesorios, Entero_Cero );
    SET Var_MontoAplicar    := Entero_Cero;

    -- SEPARAR EN DOS SP RECUPERACION AGRO Y RECUPERACIONCONT
    SET Var_IVAConcepto := Entero_Cero;
    -- Primero Recuperamos Accesorios
    IF(Var_SaldoAccesorios > Entero_Cero AND Par_SaldoRecupera > Entero_Cero) THEN

        IF(Par_SaldoRecupera >= ROUND(Var_SaldoAccesorios * (1+Var_TasaIVA), 2)) THEN
            SET Var_MontoAplicar    := Var_SaldoAccesorios;
            SET Var_SaldoAccesorios := Entero_Cero;
            SET Var_IVAConcepto      = ROUND(Var_MontoAplicar * Var_TasaIVA, 2);
        ELSE
            SET Var_MontoAplicar    := ROUND(Par_SaldoRecupera / (1 + Var_TasaIVA), 2);
            SET Var_SaldoAccesorios := Var_SaldoAccesorios - Var_MontoAplicar;
            SET Var_IVAConcepto     := Par_SaldoRecupera - Var_MontoAplicar;
        END IF;

        SET Var_TotalIVA := Var_TotalIVA + Var_IVAConcepto;
        SET Var_ComisionApl := Var_MontoAplicar;
        -- cambiar por CONTACREDITOSPRO PARA EL AGROPECUARIO
        -- CAMBIAR CONTACREDCONTACREDITOSCONTITOSCONT
        CALL CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_RecuAccesorio,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
            -- EVALUAR EL NUMERO DE ERROR QUE TE DEVUELVE
        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;
        -- Cuentas de Orden
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Par_FechaAplicacion,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_CorCasComi,
            Entero_Cero,            Nat_Cargo,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        CALL  CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Par_FechaAplicacion,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_OrdCasComi,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        -- IVA
        IF(Var_IVAConcepto > Entero_Cero) THEN
            CALL CONTACREDITOSPRO (
                Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
                Par_FechaAplicacion,    Var_IVAConcepto,        Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
                Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
                ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_IVARecupera,
                Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
                Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
        END IF;

        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        SET Par_SaldoRecupera := Par_SaldoRecupera - Var_MontoAplicar - Var_IVAConcepto;

    END IF;


    SET Var_IVAConcepto := Entero_Cero;
    -- Recuperamos Moratorios
    IF(Var_SaldoMoratorio > Entero_Cero AND Par_SaldoRecupera > Entero_Cero) THEN

        IF(Par_SaldoRecupera >= ROUND(Var_SaldoMoratorio * (1+Var_TasaIVA), 2)) THEN
            SET Var_MontoAplicar := Var_SaldoMoratorio;
            SET Var_SaldoMoratorio := Entero_Cero;
            SET Var_IVAConcepto = ROUND(Var_MontoAplicar * Var_TasaIVA, 2);
        ELSE
            SET Var_MontoAplicar := ROUND(Par_SaldoRecupera / (1 + Var_TasaIVA), 2);
            SET Var_IVAConcepto := Par_SaldoRecupera - Var_MontoAplicar;
            SET Var_SaldoMoratorio := Var_SaldoMoratorio - Var_MontoAplicar;
        END IF;

        SET Var_TotalIVA := Var_TotalIVA + Var_IVAConcepto;
        SET Var_MoratoriosApl :=  Var_MontoAplicar;

        CALL CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_RecuMoratorio,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        -- Cuentas de Orden
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Par_FechaAplicacion,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_CorCasMora,
            Entero_Cero,            Nat_Cargo,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        CALL  CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Par_FechaAplicacion,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_OrdCasMora,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        SET Par_SaldoRecupera := Par_SaldoRecupera - Var_MontoAplicar - Var_IVAConcepto;


        -- IVA

        IF(Var_IVAConcepto > Entero_Cero) THEN
            CALL CONTACREDITOSPRO (
                Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
                Par_FechaAplicacion,    Var_IVAConcepto,        Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
                Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
                ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_IVARecupera,
                Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
                Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
                IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
            END IF;

        END IF;

    END IF;


    SET Var_IVAConcepto := Entero_Cero;
    -- Recuperamos Intereses
    IF(Var_SaldoInteres > Entero_Cero AND Par_SaldoRecupera > Entero_Cero) THEN

        IF(Par_SaldoRecupera >= ROUND(Var_SaldoInteres * (1+Var_TasaIVA), 2)) THEN
            SET Var_MontoAplicar := Var_SaldoInteres;
            SET Var_SaldoInteres := Entero_Cero;
            SET Var_IVAConcepto = ROUND(Var_MontoAplicar * Var_TasaIVA, 2);
        ELSE
            SET Var_MontoAplicar := ROUND(Par_SaldoRecupera / (1 + Var_TasaIVA), 2);
            SET Var_IVAConcepto := Par_SaldoRecupera - Var_MontoAplicar;
            SET Var_SaldoInteres := Var_SaldoInteres - Var_MontoAplicar;
        END IF;

        SET Var_TotalIVA := Var_TotalIVA + Var_IVAConcepto;
        SET Var_InteresApl := Var_MontoAplicar;

        CALL CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_RecuInteres,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        -- Cuentas de Orden
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Par_FechaAplicacion,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_CorCasInt,
            Entero_Cero,            Nat_Cargo,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        CALL  CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Par_FechaAplicacion,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_OrdCasInt,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        -- IVA
        IF(Var_IVAConcepto > Entero_Cero) THEN
            CALL CONTACREDITOSPRO (
                Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
                Par_FechaAplicacion,    Var_IVAConcepto,        Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
                Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
                ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_IVARecupera,
                Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
                Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
            IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
            END IF;
        END IF;

        SET Par_SaldoRecupera := Par_SaldoRecupera - Var_MontoAplicar - Var_IVAConcepto;

    END IF;


    SET Var_IVAConcepto := Entero_Cero;
    -- Recuperamos Capital
    IF(Var_SaldoCapital > Entero_Cero AND Par_SaldoRecupera > Entero_Cero) THEN

        IF(Par_SaldoRecupera >= ROUND(Var_SaldoCapital * (1+Var_TasaIVA), 2)) THEN
            SET Var_MontoAplicar := Var_SaldoCapital;
            SET Var_SaldoCapital := Entero_Cero;
            SET Var_IVAConcepto = ROUND(Var_MontoAplicar * Var_TasaIVA, 2);
        ELSE
            SET Var_MontoAplicar := ROUND(Par_SaldoRecupera / (1 + Var_TasaIVA), 2);
            SET Var_IVAConcepto := Par_SaldoRecupera - Var_MontoAplicar;
            SET Var_SaldoCapital := Var_SaldoCapital - Var_MontoAplicar;
        END IF;

        SET Var_TotalIVA := Var_TotalIVA + Var_IVAConcepto;
        SET Var_CapitalApl := Var_MontoAplicar;

        CALL CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_RecuCapita,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;
        -- Cuentas de Orden
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Par_FechaAplicacion,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_CorCastigo,
            Entero_Cero,            Nat_Cargo,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Par_FechaAplicacion,
            Par_FechaAplicacion,    Var_MontoAplicar,       Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
            Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_OrdCastigo,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;
        -- IVA
        IF(Var_IVAConcepto > Entero_Cero) THEN
            CALL CONTACREDITOSPRO (
                Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
                Par_FechaAplicacion,    Var_IVAConcepto,        Par_MonedaID,       Par_ProductoCred,   Par_ClasifCre,
                Par_SubClasifID,        Par_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
                ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_IVARecupera,
                Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,           Salida_NO,              Par_NumErr,         Par_ErrMen,         Entero_Cero,
                Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
        IF(Par_NumErr != Entero_Cero)THEN
                    SET Var_Control     := 'creditoID';
                    LEAVE ManejoErrores;
        END IF;

        END IF;

        SET Par_SaldoRecupera := Par_SaldoRecupera - Var_MontoAplicar - Var_IVAConcepto;

    END IF;

    INSERT  INTO CRECASTIGOSREC (
        CreditoID,  NumMovimiento,  Fecha,          Monto,          CajaID,
        EmpresaID,  Usuario,        FechaActual,    DireccionIP,    ProgramaID,
        Sucursal,   NumTransaccion) VALUES(

        Par_CreditoID,  Aud_NumTransaccion, Par_FechaAplicacion,    SumaMonRecuperado,  Entero_Cero,
        Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,   Aud_NumTransaccion);

    UPDATE CRECASTIGOS SET
        MonRecuperado    =  MonRecuperado + SumaMonRecuperado,
        SaldoCapital     =  Var_SaldoCapital,
        SaldoInteres     =  Var_SaldoInteres,
        SaldoMoratorio   =  Var_SaldoMoratorio,
        SaldoAccesorios  =  Var_SaldoAccesorios
    WHERE CreditoID = Par_CreditoID;


    SET Par_NumErr  := 0;
    SET Par_ErrMen  := 'Monto Aplicado Correctamente.';
    SET Var_Control := 'creditoID';

    SET Par_Capital       := Var_CapitalApl;
    SET Par_Interes       := Var_InteresApl;
    SET Par_Moratorios    := Var_MoratoriosApl;
    SET Par_Comision      := Var_ComisionApl;
    SET Par_IVA           := Var_TotalIVA;

END ManejoErrores;

 IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_PolizaID AS consecutivo;
END IF;


END TerminaStore$$