-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTATESOREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTATESOREPRO`;DELIMITER $$

CREATE PROCEDURE `CONTATESOREPRO`(
    Par_SucOperacion        INT,
    Par_MonedaID            INT,
    Par_InstitucionID       INT,
    Par_CuentaBancos        VARCHAR(20),
    Par_TipoGastoID         INT,

    Par_ProveedorID         INT,
    Par_TipImpuestoID       INT,
    Par_FechaOperacion      DATE,
    Par_FechaAplicacion     DATE,
    Par_Monto               DECIMAL(14,4),

    Par_Descripcion         VARCHAR(100),
    Par_Referencia          VARCHAR(50),
    Par_Instrumento         VARCHAR(20),
    Par_AltaEncPoliza       CHAR(1),
    INOUT Par_Poliza        BIGINT,

    Par_ConceptoCon         INT,
    Par_ConTesoreria        INT,
    Par_NatConta            CHAR(1),
    Par_AltaMovAho          CHAR(1),
    Par_CuentaAhoID         BIGINT(12),

    Par_ClienteID           INT,
    Par_TipoMovAho          VARCHAR(4),
    Par_NatAhorro           CHAR(1),
    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),

    INOUT Par_Consecutivo   BIGINT,

    Aud_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
    )
TerminaStore: BEGIN


DECLARE Var_Cargos      DECIMAL(14,4);
DECLARE Var_Abonos      DECIMAL(14,4);
DECLARE Var_Control     VARCHAR(50);


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    DECIMAL(12,2);

DECLARE AltaPoliza_SI   CHAR(1);
DECLARE AltaMovAho_SI   CHAR(1);
DECLARE Var_SI          CHAR(1);

DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);

DECLARE Pol_Automatica  CHAR(1);
DECLARE Salida_NO       CHAR(1);
DECLARE Con_AhoCapital  int;


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET AltaPoliza_SI   := 'S';
SET Var_SI          := 'S';

SET AltaMovAho_SI   := 'S';
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Pol_Automatica  := 'A';
SET Salida_NO       := 'N';

SET Con_AhoCapital  := 1;
SET Par_NumErr      := 999;
SET Par_ErrMen      := concat(  'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                    'esto le ocasiona. Ref: SP-CONTATESOREPRO');

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                'esto le ocasiona. Ref: SP-CONTATESOREPRO');
        SET Var_Control:= 'sqlException' ;
    END;

    IF(Par_AltaEncPoliza = AltaPoliza_SI) THEN

        CALL MAESTROPOLIZASALT(
            Par_Poliza,         Aud_EmpresaID,      Par_FechaAplicacion,    Pol_Automatica,     Par_ConceptoCon,
            Par_Descripcion,    Salida_NO,          Par_NumErr,             Par_ErrMen,         Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);


        IF (Par_NumErr != Entero_Cero) THEN
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

    IF (Par_AltaMovAho = AltaMovAho_SI  ) THEN
        IF(Par_NatAhorro = Nat_Cargo) THEN
            SET Var_Cargos  := Par_Monto;
            SET Var_Abonos  := Decimal_Cero;
        ELSE
            SET Var_Cargos  := Decimal_Cero;
            SET Var_Abonos  := Par_Monto;
        END IF;

        CALL CUENTASAHORROMOVALT(
            Par_CuentaAhoID,    Aud_NumTransaccion, Par_FechaAplicacion,    Par_NatAhorro,      Par_Monto,
            Par_Descripcion,    Par_Referencia,     Par_TipoMovAho,         Salida_NO,          Par_NumErr,
            Par_ErrMen,         Aud_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


        IF (Par_NumErr != Entero_Cero) THEN
            LEAVE ManejoErrores;
        END IF;

        CALL POLIZASAHORROPRO(
            Par_Poliza,         Aud_EmpresaID,      Par_FechaAplicacion,    Par_ClienteID,      Con_AhoCapital,
            Par_CuentaAhoID,    Par_MonedaID,       Var_Cargos,             Var_Abonos,         Par_Descripcion,
            Par_Referencia,     Salida_NO,          Par_NumErr,             Par_ErrMen,         Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

        IF (Par_NumErr != Entero_Cero) THEN
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


    CALL POLIZASTESOREPRO(
        Par_Poliza,         Aud_EmpresaID,      Par_FechaAplicacion,    Par_Instrumento,    Par_SucOperacion,
        Par_ConTesoreria,   Var_Cargos,         Var_Abonos,             Par_MonedaID,       Par_TipoGastoID,
        Par_ProveedorID,    Par_TipImpuestoID,  Par_InstitucionID,      Par_CuentaBancos,   Par_Descripcion,
        Par_Referencia,     Par_Consecutivo,    Salida_NO,              Par_NumErr,         Par_ErrMen,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion  );


    IF (Par_NumErr != Entero_Cero) THEN
        LEAVE ManejoErrores;
    END IF;



    SET Par_NumErr      := '000';
    SET Par_ErrMen      := concat("Movimientos Generados Exitosamente");
    SET Var_Control     := 'institucionID';

END ManejoErrores;


IF (Par_Salida = Var_SI) THEN
    SELECT  Par_NumErr,
            Par_ErrMen,
            Var_Control,
            Par_Consecutivo;
END IF;


END TerminaStore$$