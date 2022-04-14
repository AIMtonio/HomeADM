-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTASPEIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTASPEIPRO`;DELIMITER $$

CREATE PROCEDURE `CONTASPEIPRO`(



    Par_FolioSpei       BIGINT,
    Par_SucOperacion    INT,
    Par_MonedaID        INT,
    Par_FechaOperacion  DATE,
    Par_FechaAplicacion DATE,
    Par_Monto           DECIMAL(14,4),

    Par_ComisionTrans   DECIMAL(16,2),
    Par_IVAComision     DECIMAL(16,2),
    Par_Descripcion     VARCHAR(150),
    Par_Referencia      VARCHAR(50),
    Par_Instrumento     VARCHAR(20),

    Par_AltaEncPoliza   CHAR(1),
INOUT   Par_Poliza      BIGINT,
    Par_ConceptoCon     INT,
    Par_NatConta        CHAR(1),
    Par_AltaMovAho      CHAR(1),

    Par_CuentaAhoID     BIGINT,
    Par_ClienteID       INT,

    Par_NatAhorro       CHAR(1),
    Par_ConceptoAho     INT,

INOUT   Par_NumErr      INT(11),
INOUT   Par_ErrMen      VARCHAR(400),
INOUT   Par_Consecutivo BIGINT,

    Par_Empresa         INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

    )
TerminaStore: BEGIN

DECLARE Var_Cargos      DECIMAL(14,4);
DECLARE Var_Abonos      DECIMAL(14,4);
DECLARE Var_DesMov      VARCHAR(150);
DECLARE Var_EsBloAuto   CHAR(1);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12, 2);
DECLARE AltaPoliza_SI       CHAR(1);
DECLARE AltaMovAho_SI       CHAR(1);
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE Pol_Automatica      CHAR(1);
DECLARE Salida_NO           CHAR(1);
DECLARE Salida_SI           CHAR(1);
DECLARE Con_AhoCapital      INT;
DECLARE EncPoliza_NO        CHAR(1);
DECLARE CtoCon_Spei         INT;
DECLARE TipoMovAho_Spei     INT;
DECLARE TipoMovAhoCom_Spei  INT;
DECLARE TipoMovAhoIva_Spei  INT;
DECLARE CtoAho_Spei         INT;
DECLARE CtoAhoComSpei       INT;
DECLARE CtoAhoComSpeiIva    INT;
DECLARE DesComision         VARCHAR(100);
DECLARE DesIvaCom           VARCHAR(100);
DECLARE Con_Si              CHAR(1);
DECLARE Nat_Mov             CHAR(1);
DECLARE TipoBloq            INT;
DECLARE Descip              VARCHAR(150);

DECLARE Var_Automatico      CHAR(1);
DECLARE Var_TipoMovID       INT;
DECLARE Par_Consecutivo     BIGINT;
DECLARE Cuenta_Vacia        CHAR(25);
DECLARE Var_Cuenta          VARCHAR(50);
DECLARE Var_ClabeInst       VARCHAR(18);
DECLARE Var_InstiIDS        INT(11);
DECLARE Var_NumCtaInstit    VARCHAR(20);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.00;
SET AltaPoliza_SI       := 'S';
SET AltaMovAho_SI       := 'S';
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';
SET Pol_Automatica      := 'A';
SET Salida_NO           := 'N';
SET Salida_SI           := 'S';
SET Con_AhoCapital      := 1;
SET EncPoliza_NO        := 'N';
SET CtoCon_Spei         := 808;
SET TipoMovAho_Spei     := 224;
SET TipoMovAhoCom_Spei  := 212;
SET TipoMovAhoIva_Spei  := 213;
SET CtoAho_Spei         := 1;
SET CtoAhoComSpei       := 24;
SET CtoAhoComSpeiIva    := 25;
SET DesComision         := "Comision SPEI";
SET DesIvaCom           := "Iva Comision SPEI";
SET DesComision         := CONCAT(DesComision,' - ',Par_Instrumento);
SET DesIvaCom           := CONCAT(DesIvaCom,' - ',Par_Instrumento);
SET Par_NumErr          := 0;
SET Par_ErrMen          := '';
SET Con_Si              := 'S';
SET Nat_Mov             := 'B';
SET TipoBloq            := 13;
SET Descip              := 'Bloqueo por abono a cuenta';

SET Var_Automatico      := 'P';
SET Var_Cuenta          := '0000000000000000000000000';
SET Var_ClabeInst       := Cadena_Vacia;


ManejoErrores:BEGIN

SELECT  PS.Clabe,   CO.CuentaAhoID,     CT.NumCtaInstit,    CT.InstitucionID
INTO    Var_ClabeInst,  Var_Cuenta,     Var_NumCtaInstit,   Var_InstiIDS
FROM PARAMETROSSPEI PS
    JOIN CUENTASAHOTESO CT ON  PS.Clabe=CT.CueClave
    JOIN CUENTASAHO CO ON CT.CuentaAhoID=CO.CuentaAhoID
    JOIN CLIENTES CTE ON CO.ClienteID=CTE.ClienteID
    WHERE   PS.EmpresaID = Par_Empresa;

SET Var_Cuenta      := IFNULL(Var_Cuenta, Cuenta_Vacia);

IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN

    CALL MAESTROPOLIZAALT(
        Par_Poliza,     Par_Empresa,    Par_FechaAplicacion,    Pol_Automatica,     Par_ConceptoCon,
        Par_Descripcion,    Salida_NO,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

END IF;

IF (Par_AltaMovAho = AltaMovAho_SI  ) THEN

    IF (Par_ComisionTrans != Decimal_Cero || Par_IVAComision != Decimal_Cero)THEN
        IF (Par_ComisionTrans != Decimal_Cero)THEN
            CALL CONTAAHORROPRO(
                        Par_CuentaAhoID,    Par_ClienteID,      Aud_NumTransaccion, Par_FechaOperacion, Par_FechaAplicacion,
                        Par_NatAhorro,      Par_ComisionTrans,  DesComision,        Par_CuentaAhoID,    TipoMovAhoCom_Spei,
                        Par_MonedaID,       Aud_Sucursal,       EncPoliza_NO,       CtoCon_Spei,        Par_Poliza,
                        AltaPoliza_SI,      Con_AhoCapital,     Par_NatAhorro,      Par_NumErr,         Par_ErrMen,
                        Entero_Cero,        Par_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

        END IF;
        IF (Par_IVAComision != Decimal_Cero)THEN
            CALL CONTAAHORROPRO(
                        Par_CuentaAhoID,    Par_ClienteID,      Aud_NumTransaccion, Par_FechaOperacion, Par_FechaAplicacion,
                        Par_NatAhorro,      Par_IVAComision,    DesIvaCom,          Par_CuentaAhoID,    TipoMovAhoIva_Spei,
                        Par_MonedaID,       Aud_Sucursal,       EncPoliza_NO,       CtoCon_Spei,        Par_Poliza,
                        AltaPoliza_SI,      Con_AhoCapital,     Par_NatAhorro,      Par_NumErr,         Par_ErrMen,
                        Entero_Cero,        Par_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
        END IF;


        IF(Par_NatConta = Nat_Cargo) THEN
            SET Var_Cargos  := Par_ComisionTrans;
            SET Var_Abonos  := Decimal_Cero;
        ELSE
            SET Var_Cargos  := Decimal_Cero;
            SET Var_Abonos  := Par_ComisionTrans;
        END IF;

        CALL POLIZAAHORROPRO(
                    Par_Poliza,         Par_Empresa,    Par_FechaOperacion, Par_ClienteID,      CtoAhoComSpei,
                    Par_CuentaAhoID,    Par_MonedaID,   Var_Cargos,         Var_Abonos,         DesComision,
                    Par_Instrumento,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

        IF(Par_NatConta = Nat_Cargo) THEN
            SET Var_Cargos  := Par_IVAComision;
            SET Var_Abonos  := Decimal_Cero;
        ELSE
            SET Var_Cargos  := Decimal_Cero;
            SET Var_Abonos  := Par_IVAComision;
        END IF;

        CALL POLIZAAHORROPRO(
                    Par_Poliza,         Par_Empresa,    Par_FechaOperacion, Par_ClienteID,      CtoAhoComSpeiIva,
                    Par_CuentaAhoID,    Par_MonedaID,   Var_Cargos,         Var_Abonos,         DesIvaCom,
                    Par_Instrumento,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);
    END IF;

    CALL CARGOABONOCTAPRO(
        Par_CuentaAhoID,    Par_ClienteID,      Aud_NumTransaccion, Par_FechaOperacion, Par_FechaAplicacion,
        Par_NatAhorro,      Par_Monto,          Par_Descripcion,    Par_Referencia,     TipoMovAho_Spei,
        Par_MonedaID,       Par_SucOperacion,   EncPoliza_NO,       Par_ConceptoCon,    Par_Poliza,
        AltaPoliza_SI,      Con_AhoCapital,     Par_NatAhorro,      'N', Par_NumErr,        Par_ErrMen,
        Par_Consecutivo,    Par_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

    IF(Par_NumErr != Entero_Cero)THEN
        SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
        Par_ErrMen AS ErrMen,
        'numero' AS control,
        Par_FolioSpei AS consecutivo;
        LEAVE ManejoErrores;
    END IF;



    SELECT  TC.EsBloqueoAuto INTO Var_EsBloAuto
    FROM TIPOSCUENTAS TC INNER JOIN CUENTASAHO CA ON CA.TipoCuentaID = TC.TipoCuentaID
    WHERE CA.CuentaAhoID = Par_CuentaAhoID;

    IF(Var_EsBloAuto = Con_Si)THEN

        CALL BLOQUEOSPRO(Entero_Cero,  Nat_Mov,         Par_CuentaAhoID, Par_FechaOperacion,   Par_Monto,
                        Cadena_Vacia,  TipoBloq,        Descip,          Par_FolioSpei,        Cadena_Vacia,
                        Cadena_Vacia,  Salida_SI,       Par_NumErr,      Par_ErrMen,           Par_Empresa,
                        Aud_Usuario,   Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID,       Aud_Sucursal,
                        Aud_NumTransaccion);
    END IF;

    IF(Par_NatAhorro = Nat_Cargo)THEN
        SET Var_TipoMovID   := 13;
    ELSE
        SET Var_TipoMovID   := 14;
    END IF;

    CALL TESORERIAMOVSALT(
        Var_Cuenta,         Par_FechaOperacion,     Par_Monto,          Par_Descripcion,    Par_Referencia,
        Cadena_Vacia,       Par_NatAhorro,          Var_Automatico,     Var_TipoMovID,      Entero_Cero,
        Salida_NO,          Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Par_Empresa,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

    IF(Par_NumErr != Entero_Cero)THEN
        SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
        Par_ErrMen AS ErrMen,
        'numero' AS control,
        Par_FolioSpei AS consecutivo;
        LEAVE ManejoErrores;
    END IF;

    CALL SALDOSCTATESOACT(
        Var_NumCtaInstit,   Var_InstiIDS,       Par_Monto,          Par_NatAhorro,      Salida_NO,
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_Empresa,        Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

    IF(Par_NumErr != Entero_Cero)THEN
        SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
        Par_ErrMen AS ErrMen,
        'numero' AS control,
        Par_FolioSpei AS consecutivo;
        LEAVE ManejoErrores;
    END IF;

END IF;

IF(Par_NatConta = Nat_Cargo) THEN
    SET Var_Cargos  := Par_Monto;
    SET Var_Abonos  := Decimal_Cero;
ELSE
    SET Var_Cargos  := Decimal_Cero;
    SET Var_Abonos  := Par_Monto;
END IF;

SET Par_NumErr := 0;

CALL POLIZASPEIPRO(
    Par_Poliza,         Par_Empresa,        Par_FechaOperacion, Par_FolioSpei,      Par_SucOperacion,
    Var_Cargos,         Var_Abonos,         Par_MonedaID,       Par_Descripcion,    Par_FolioSpei,
    Salida_NO,          Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Aud_Usuario,
    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

IF(Par_NumErr != Entero_Cero)THEN
       SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
       Par_ErrMen AS ErrMen,
       'numero' AS control,
       Par_FolioSpei AS consecutivo;
     LEAVE ManejoErrores;
    END IF;

END ManejoErrores;

END TerminaStore$$