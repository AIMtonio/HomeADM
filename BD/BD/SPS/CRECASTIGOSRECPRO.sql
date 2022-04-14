-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOSRECPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOSRECPRO`;
DELIMITER $$


CREATE PROCEDURE `CRECASTIGOSRECPRO`(
    Par_CreditoID       BIGINT(12),
    Par_Monto           DECIMAL(14,2),
    Par_CajaID          INT(11),
    Par_PolizaID        BIGINT(20),
    Par_DescripcionMov  VARCHAR(100),

    Par_Salida          CHAR(1),
    OUT Par_NumErr      INT,
    OUT Par_ErrMen      VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore:BEGIN


DECLARE Var_MonedaID        INT(11);
DECLARE Var_ProductoCred    INT(11);
DECLARE Var_ClasifCre       CHAR(1);
DECLARE Var_SubClasifID     INT(11);
DECLARE Var_SucursalCliente INT(11);
DECLARE Var_Poliza          BIGINT;
DECLARE Var_Control         VARCHAR(100);
DECLARE Var_FechaAplicacion DATE;
DECLARE Var_MontoRecuperado DECIMAL(14,2);
DECLARE Var_TotalCastigo    DECIMAL(14,2);
DECLARE SumaMonRecuperado   DECIMAL(14,2);
DECLARE Var_PorRecuperar    DECIMAL(14,2);

DECLARE Var_SaldoCapital    DECIMAL(14,2);
DECLARE Var_SaldoInteres    DECIMAL(14,2);
DECLARE Var_SaldoMoratorio  DECIMAL(14,2);
DECLARE Var_SaldoAccesorios DECIMAL(14,2);
DECLARE Var_SaldoRecupera   DECIMAL(14,2);
DECLARE Var_MontoAplicar    DECIMAL(14,2);
DECLARE Var_DivideCastigo   CHAR(1);
DECLARE Var_AplicaIVA       CHAR(1);
DECLARE Var_TasaIVA         DECIMAL(12,2);
DECLARE Var_IVAConcepto     DECIMAL(12,2);


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



SET Entero_Cero         := 0;
SET Fecha_Vacia         := '1900-01-01';
SET Descripcion         := 'RECUPERACION DE CARTERA CASTIGADA';
SET Cadena_Vacia        := '';
SET AltaEncPolisaSI     := 'S';
SET AltaEncPolisaNO     := 'N';
SET ConceptoContable    := 63;
SET AltaPolizaSI        := 'S';
SET AltaPolizaNO        := 'N';

SET AltaMovCredNO       := 'N';
SET Con_RecuCapita      := 31;
SET Con_RecuInteres     := 46;
SET Con_RecuMoratorio   := 47;
SET Con_RecuAccesorio   := 48;
SET Con_IVARecupera     := 52;

SET Con_OrdCastigo      := 29;
SET Con_CorCastigo      := 30;
SET Con_OrdCasInt       := 40;
SET Con_CorCasInt       := 41;
SET Con_OrdCasMora      := 42;
SET Con_CorCasMora      := 43;
SET Con_OrdCasComi      := 44;
SET Con_CorCasComi      := 45;

SET No_DivideCastigo    := 'N';
SET Pol_Automatica      := 'A';
SET AltaMovAhorroNO     := 'N';
SET Salida_SI           := 'S';
SET Salida_NO           := 'N';
SET SI_AplicaIVA        := 'S';
SET Nat_Abono           := 'A';
SET Nat_Cargo           := 'C';


ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                        'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECASTIGOSRECPRO');
    END;
SET Par_EmpresaID := IFNULL(Par_EmpresaID, 1);

SET Var_FechaAplicacion :=(SELECT FechaSistema
                            FROM PARAMETROSSIS
                            WHERE EmpresaID = Par_EmpresaID);

SET Aud_FechaActual     := CURRENT_TIMESTAMP();

SELECT DivideCastigo, IVARecuperacion INTO Var_DivideCastigo, Var_AplicaIVA
    FROM PARAMSRESERVCASTIG
    WHERE EmpresaID = Par_EmpresaID;

SET Var_DivideCastigo   := IFNULL(Var_DivideCastigo, No_DivideCastigo);

SELECT  MonRecuperado, TotalCastigo, SaldoCapital, SaldoInteres,    SaldoMoratorio,
        SaldoAccesorios
        INTO Var_MontoRecuperado, Var_TotalCastigo, Var_SaldoCapital, Var_SaldoInteres, Var_SaldoMoratorio,
        Var_SaldoAccesorios
    FROM CRECASTIGOS
    WHERE CreditoID = Par_CreditoID;

SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := 'Monto Aplicado Correctamente';
SET Var_Control := 'creditoID';


SET Var_MontoRecuperado := IFNULL(Var_MontoRecuperado, Entero_Cero);
SET Var_TotalCastigo    := IFNULL(Var_TotalCastigo, Entero_Cero );
SET Var_SaldoCapital := IFNULL(Var_SaldoCapital, Entero_Cero );
SET Var_SaldoInteres := IFNULL(Var_SaldoInteres, Entero_Cero );
SET Var_SaldoMoratorio := IFNULL(Var_SaldoMoratorio, Entero_Cero );
SET Var_SaldoAccesorios := IFNULL(Var_SaldoAccesorios, Entero_Cero );
SET Var_MontoAplicar    := Entero_Cero;

SET SumaMonRecuperado := Var_MontoRecuperado + Par_Monto;


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

IF NOT EXISTS(SELECT CreditoID
                FROM  CRECASTIGOS
                    WHERE CreditoID = Par_CreditoID)THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  :=CONCAT('El Credito ',Par_CreditoID,' no se Encuentra Castigado');
        SET Var_Control :='creditoID';
        LEAVE ManejoErrores;
END IF;

SET Var_PorRecuperar :=  ROUND(Var_SaldoCapital * (1+Var_TasaIVA),2) +
                         ROUND(Var_SaldoInteres * (1+Var_TasaIVA),2) +
                         ROUND(Var_SaldoMoratorio * (1+Var_TasaIVA),2) +
                         ROUND(Var_SaldoAccesorios * (1+Var_TasaIVA),2);

IF (Par_Monto > Var_PorRecuperar)THEN
        SET Par_NumErr  := 2;
        SET Par_ErrMen  :='El Monto del Deposito Excede el Total del Monto por Recuperar';
        SET Var_Control :='montoRecuperar';
        LEAVE ManejoErrores;

END IF;

SELECT  MonedaID,ProductoCreditoID, Des.Clasificacion,  Des.SubClasifID,  Cli.SucursalOrigen
        INTO Var_MonedaID, Var_ProductoCred , Var_ClasifCre, Var_SubClasifID, Var_SucursalCliente
    FROM CREDITOS Cre,
          CLIENTES Cli,
        DESTINOSCREDITO Des
    WHERE CreditoID          = Par_CreditoID
      AND Cre.ClienteID      = Cli.ClienteID
     AND Cre.DestinoCreID   = Des.DestinoCreID;

SET Var_SaldoRecupera   := Par_Monto;


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


SET Var_IVAConcepto := Entero_Cero;



IF(Var_SaldoAccesorios > Entero_Cero AND Var_SaldoRecupera > Entero_Cero) THEN

    IF(Var_SaldoRecupera >= ROUND(Var_SaldoAccesorios * (1+Var_TasaIVA), 2)) THEN
        SET Var_MontoAplicar := Var_SaldoAccesorios;
        SET Var_SaldoAccesorios := Entero_Cero;
        SET Var_IVAConcepto = ROUND(Var_MontoAplicar * Var_TasaIVA, 2);
    ELSE
        SET Var_MontoAplicar := ROUND(Var_SaldoRecupera / (1 + Var_TasaIVA), 2);
        SET Var_IVAConcepto := Var_SaldoRecupera - Var_MontoAplicar;
        SET Var_SaldoAccesorios := Var_SaldoAccesorios - Var_MontoAplicar;
    END IF;


    CALL CONTACREDITOSPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_RecuAccesorio,
        Entero_Cero,			Nat_Abono,				AltaMovAhorroNO,	Cadena_Vacia,		Cadena_Vacia,
        Cadena_Vacia,           Salida_NO,
        Par_NumErr,             Par_ErrMen,             Entero_Cero,        Par_EmpresaID,      Cadena_Vacia,       Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


    CALL  CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Var_FechaAplicacion,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_CorCasComi,
        Entero_Cero,            Nat_Cargo,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    CALL  CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Var_FechaAplicacion,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_OrdCasComi,
        Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);


    IF(Var_IVAConcepto > Entero_Cero) THEN
        CALL CONTACREDITOPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
            Var_FechaAplicacion,    Var_IVAConcepto,        Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
            Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_IVARecupera,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
    END IF;


    SET Var_SaldoRecupera := Var_SaldoRecupera - Var_MontoAplicar - Var_IVAConcepto;

END IF;

SET Var_IVAConcepto := Entero_Cero;


IF(Var_SaldoMoratorio > Entero_Cero AND Var_SaldoRecupera > Entero_Cero) THEN



    IF(Var_SaldoRecupera >= ROUND(Var_SaldoMoratorio * (1+Var_TasaIVA), 2)) THEN
        SET Var_MontoAplicar := Var_SaldoMoratorio;
        SET Var_SaldoMoratorio := Entero_Cero;
        SET Var_IVAConcepto = ROUND(Var_MontoAplicar * Var_TasaIVA, 2);
    ELSE
        SET Var_MontoAplicar := ROUND(Var_SaldoRecupera / (1 + Var_TasaIVA), 2);
        SET Var_IVAConcepto := Var_SaldoRecupera - Var_MontoAplicar;
        SET Var_SaldoMoratorio := Var_SaldoMoratorio - Var_MontoAplicar;
    END IF;


    CALL CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_RecuMoratorio,
        Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);


    CALL  CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Var_FechaAplicacion,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_CorCasMora,
        Entero_Cero,            Nat_Cargo,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    CALL  CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Var_FechaAplicacion,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_OrdCasMora,
        Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    SET Var_SaldoRecupera := Var_SaldoRecupera - Var_MontoAplicar - Var_IVAConcepto;




    IF(Var_IVAConcepto > Entero_Cero) THEN
        CALL CONTACREDITOPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
            Var_FechaAplicacion,    Var_IVAConcepto,        Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
            Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_IVARecupera,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
    END IF;

END IF;

SET Var_IVAConcepto := Entero_Cero;




IF(Var_SaldoInteres > Entero_Cero AND Var_SaldoRecupera > Entero_Cero) THEN

    IF(Var_SaldoRecupera >= ROUND(Var_SaldoInteres * (1+Var_TasaIVA), 2)) THEN
        SET Var_MontoAplicar := Var_SaldoInteres;
        SET Var_SaldoInteres := Entero_Cero;
        SET Var_IVAConcepto = ROUND(Var_MontoAplicar * Var_TasaIVA, 2);
    ELSE
        SET Var_MontoAplicar := ROUND(Var_SaldoRecupera / (1 + Var_TasaIVA), 2);
        SET Var_IVAConcepto := Var_SaldoRecupera - Var_MontoAplicar;
        SET Var_SaldoInteres := Var_SaldoInteres - Var_MontoAplicar;
    END IF;

    CALL CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_RecuInteres,
        Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);


    CALL  CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Var_FechaAplicacion,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_CorCasInt,
        Entero_Cero,            Nat_Cargo,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    CALL  CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Var_FechaAplicacion,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_OrdCasInt,
        Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);



    IF(Var_IVAConcepto > Entero_Cero) THEN
        CALL CONTACREDITOPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
            Var_FechaAplicacion,    Var_IVAConcepto,        Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
            Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_IVARecupera,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
    END IF;

    SET Var_SaldoRecupera := Var_SaldoRecupera - Var_MontoAplicar - Var_IVAConcepto;

END IF;

SET Var_IVAConcepto := Entero_Cero;



IF(Var_SaldoCapital > Entero_Cero AND Var_SaldoRecupera > Entero_Cero) THEN

    IF(Var_SaldoRecupera >= ROUND(Var_SaldoCapital * (1+Var_TasaIVA), 2)) THEN
        SET Var_MontoAplicar := Var_SaldoCapital;
        SET Var_SaldoCapital := Entero_Cero;
        SET Var_IVAConcepto = ROUND(Var_MontoAplicar * Var_TasaIVA, 2);
    ELSE
        SET Var_MontoAplicar := ROUND(Var_SaldoRecupera / (1 + Var_TasaIVA), 2);
        SET Var_IVAConcepto := Var_SaldoRecupera - Var_MontoAplicar;
        SET Var_SaldoCapital := Var_SaldoCapital - Var_MontoAplicar;
    END IF;

    CALL CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_RecuCapita,
        Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);


    CALL  CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Var_FechaAplicacion,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_CorCastigo,
        Entero_Cero,            Nat_Cargo,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    CALL  CONTACREDITOPRO (
        Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Var_FechaAplicacion,
        Var_FechaAplicacion,    Var_MontoAplicar,       Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
        Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
        ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_OrdCastigo,
        Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
        Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);


    IF(Var_IVAConcepto > Entero_Cero) THEN
        CALL CONTACREDITOPRO (
            Par_CreditoID,          Entero_Cero,            Entero_Cero,        Entero_Cero,        Fecha_Vacia,
            Var_FechaAplicacion,    Var_IVAConcepto,        Var_MonedaID,       Var_ProductoCred,   Var_ClasifCre,
            Var_SubClasifID,        Var_SucursalCliente,    Par_DescripcionMov, Cadena_Vacia,       AltaEncPolisaNO,
            ConceptoContable,       Par_PolizaID,           AltaPolizaSI,       AltaMovCredNO,      Con_IVARecupera,
            Entero_Cero,            Nat_Abono,              AltaMovAhorroNO,    Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,           /*Salida_NO,*/              Par_NumErr,         Par_ErrMen,         Entero_Cero,
            Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);
    END IF;

    SET Var_SaldoRecupera := Var_SaldoRecupera - Var_MontoAplicar - Var_IVAConcepto;

END IF;

INSERT  INTO CRECASTIGOSREC (
    CreditoID,  NumMovimiento,  Fecha,          Monto,          CajaID,
    EmpresaID,  Usuario,        FechaActual,    DireccionIP,    ProgramaID,
    Sucursal,   NumTransaccion) VALUES(

    Par_CreditoID,  Aud_NumTransaccion, Var_FechaAplicacion,    Par_Monto,          Par_CajaID,
    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,
    Aud_Sucursal,   Aud_NumTransaccion);


UPDATE CRECASTIGOS SET
    MonRecuperado  = MonRecuperado + Par_Monto,
    SaldoCapital =  Var_SaldoCapital,
    SaldoInteres =  Var_SaldoInteres,
    SaldoMoratorio =    Var_SaldoMoratorio,
    SaldoAccesorios =   Var_SaldoAccesorios

    WHERE CreditoID = Par_CreditoID;

SET Par_NumErr  := 0;
SET Par_ErrMen  := 'Monto Aplicado Correctamente.';
SET Var_Control := 'creditoID';


END ManejoErrores;

 IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_PolizaID AS consecutivo;
END IF;


END TerminaStore$$