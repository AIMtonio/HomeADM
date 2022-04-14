-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAINVBANPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAINVBANPRO`;
DELIMITER $$

CREATE PROCEDURE `CONTAINVBANPRO`(

    Par_InversionID             int(11),
    Par_CentroCosto             int(11),
    Par_TipoInversion           varchar(150),
    Par_MonedaID                int,
    Par_InstitucionID           int,

    Par_FechaAplicacion         Date,
    Par_Monto                   decimal(14,4),
    Par_MontoInvCC              decimal(14,4),
    Par_NumCtaInstit            varchar(20),
    Par_AltaEncPoliza           char(1),

    Par_ConceptoCon             int,
    Par_ConceptoInvBan          int,
    Par_TipoMovTeso             char(4),
    Par_DescContable            varchar(100),
    Par_DescMovimiento          varchar(100),
    Par_NatConta                char(1),

    Par_PolizaID                bigint(11),
    Par_AltaMovOperativo        char(1),
    Par_AltaContaTesoreria      char(1),
    Par_Salida                  char(1),
    inout   Par_NumErr          int,

    inout   Par_ErrMen          varchar(400),
    Par_Empresa                 int,
    Aud_Usuario                 int,
    Aud_FechaActual             DateTime,
    Aud_DireccionIP             varchar(15),

    Aud_ProgramaID              varchar(50),
    Aud_Sucursal                int,
    Aud_NumTransaccion          bigint
)
TerminaStore: BEGIN

    DECLARE Var_Cargos          decimal(14,4);
    DECLARE Var_Abonos          decimal(14,4);
    DECLARE Var_Poliza          bigint;
    DECLARE Var_CentroCostoID   int(11);
    DECLARE Var_Control         varchar(20);
    DECLARE Err_Consecutivo     bigint;
    DECLARE Var_NatContaTeso    char(1);
    DECLARE Var_CuentaAhoID     bigint(12);
    DECLARE Var_Consecutivo     int;


    DECLARE Cadena_Vacia        char(1);
    DECLARE Fecha_Vacia         date;
    DECLARE Entero_Cero         int;
    DECLARE Decimal_Cero        decimal(12, 2);
    DECLARE AltaPoliza_SI       char(1);
    DECLARE Nat_Cargo           char(1);
    DECLARE Nat_Abono           char(1);
    DECLARE Pol_Automatica      char(1);
    DECLARE Salida_NO           char(1);
    DECLARE Salida_SI           char(1);
    DECLARE Con_AhoCapital      int;
    DECLARE Tipo_CapInversion   char(3);
    DECLARE Int_SinError        int;
    DECLARE AltaMovAho_NO       char(1);
    DECLARE Conciliado_NO       char(1);
    DECLARE Tip_RegPantalla     char(1);
    DECLARE Str_SinError        char(3);
    DECLARE AltaMov_SI          char(1);
    DECLARE AltaPoliza_NO       char(1);


    Set Cadena_Vacia            := '';
    Set Fecha_Vacia             := '1900-01-01';
    Set Entero_Cero             := 0;
    Set Decimal_Cero            := 0.00;
    Set AltaPoliza_SI           := 'S';
    Set Nat_Cargo               := 'C';
    Set Nat_Abono               := 'A';
    Set Pol_Automatica          := 'A';
    Set Salida_NO               := 'N';
    Set Salida_SI               := 'S';
    Set Con_AhoCapital          := 1;
    Set Tipo_CapInversion       := '001';
    Set Int_SinError            := 0;
    Set AltaMovAho_NO           := 'N';
    SET Conciliado_NO           := 'N';
    SET Tip_RegPantalla         := 'P';
    SET Str_SinError            := '000';
    SET AltaMov_SI              := 'S';
    SET AltaPoliza_NO           :='N';
    Set Aud_FechaActual := CURRENT_TIMESTAMP();

    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr = 999;
            set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                     "estamos trabajando para resolverla. Disculpe las molestias que ",
                                     "esto le ocasiona. Ref: SP-CONTAINVBANPRO");
        END;
        set Var_Poliza = Par_PolizaID;

        if (Par_AltaEncPoliza = AltaPoliza_SI) then
            CALL MAESTROPOLIZAALT(
                Var_Poliza,     Par_Empresa,    Par_FechaAplicacion,    Pol_Automatica,     Par_ConceptoCon,
                Par_DescMovimiento, Salida_NO,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
        end if;

        if (Par_AltaContaTesoreria = 'S')then
            select CuentaAhoID, CentroCostoID
                            into Var_CuentaAhoID, Var_CentroCostoID
                        from CUENTASAHOTESO
                        where InstitucionID = Par_InstitucionID
                          and NumCtaInstit  = Par_NumCtaInstit;

                set Var_CentroCostoID :=ifnull(Var_CentroCostoID,Entero_Cero );


                if(Par_AltaMovOperativo = AltaMov_SI) then



                    call INVBANCARIAMOVSALT(
                        Par_InversionID,        Aud_NumTransaccion,         Par_FechaAplicacion,    Par_NatConta,           Par_Monto,
                        Par_DescContable,       Tipo_CapInversion,          Par_MonedaID,           Salida_NO,              Par_NumErr,
                        Par_ErrMen,             Par_Empresa,                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion);

                    call SALDOSCTATESOACT(
                        Par_NumCtaInstit,   Par_InstitucionID,  Par_Monto,          Par_NatConta,       Salida_NO,
                        Par_NumErr,         Par_ErrMen,         Err_Consecutivo,    Par_Empresa,        Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    if (Par_NumErr != Int_SinError) then
                            SET Var_Control:= 'institucionID';
                            SET Var_Consecutivo := Entero_Cero;
                            LEAVE ManejoErrores;
                    end if;

                    call TESORERIAMOVSALT(
                        Var_CuentaAhoID,    Par_FechaAplicacion,    Par_Monto,        Par_DescMovimiento,        Par_TipoInversion,
                        Conciliado_NO,      Par_NatConta,               Tip_RegPantalla,    Par_TipoMovTeso,        Entero_Cero,
                        Salida_NO,          Par_NumErr,         Par_ErrMen,      Err_Consecutivo,   Par_Empresa,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,  Aud_Sucursal,
                        Aud_NumTransaccion  );

                    if (Par_NumErr != Int_SinError) then
                        if (Par_Salida = Salida_SI) then
                            select  Par_NumErr as NumErr,
                                    Par_ErrMen  as ErrMen,
                                    'Institucion' as control,
                                    Entero_Cero as consecutivo;
                        end if;
                        LEAVE TerminaStore;
                    end if;
                end if;

            if(Par_NatConta = 'A')then
                set Var_NatContaTeso = Nat_Cargo;
            else
                set Var_NatContaTeso = 'A';
            end if;


            call CONTATESORERIAPRO(
                    Aud_Sucursal,           Par_MonedaID,           Par_InstitucionID,      Par_NumCtaInstit,       Entero_Cero,
                    Entero_Cero,            Entero_Cero,            Par_FechaAplicacion,    Par_FechaAplicacion,    Par_MontoInvCC,
                    Par_DescContable,       Par_NumCtaInstit,       Par_NumCtaInstit,       AltaPoliza_NO,          Var_Poliza,
                    Par_ConceptoCon,        Entero_Cero,            Var_NatContaTeso,       AltaMovAho_NO,          Entero_Cero,
                    Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,           Par_NumErr,             Par_ErrMen,
                    Err_Consecutivo,        Par_Empresa,            Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                    if (Par_NumErr != Int_SinError) then
                        SET Var_Control:= 'institucionID';
                        SET Var_Consecutivo := Entero_Cero;
                        LEAVE ManejoErrores;
                    end if;

            end if;

        if(Par_NatConta = Nat_Cargo) then
            set Var_Cargos  := Par_MontoInvCC;
            set Var_Abonos  := Decimal_Cero;
        else
            set Var_Cargos  := Decimal_Cero;
            set Var_Abonos  := Par_MontoInvCC;
        end if;

        call POLIZAINVBANPRO(
                Par_InversionID,        Par_CentroCosto,        Var_Poliza,         Par_FechaAplicacion,    Par_ConceptoInvBan,
                Par_DescMovimiento,     Par_NumCtaInstit,       Par_MonedaID,       Var_Cargos,             Var_Abonos,
                Par_InstitucionID,      Salida_NO,              Par_NumErr,         Par_ErrMen,             Par_Empresa,
                Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
                Aud_NumTransaccion);

            if (Par_NumErr != Int_SinError) then
                SET Var_Control:= 'institucionID';
                SET Var_Consecutivo := Entero_Cero;
                LEAVE ManejoErrores;
            end if;


            set  Par_NumErr := 0;
            set  Par_ErrMen := concat(" Inversion Agregada Exitosamente: ",  convert(Par_InversionID, CHAR));
            set  Var_Control:= 'inversionID';
            SET Var_Consecutivo := Par_InversionID;
        END ManejoErrores;


    if(Par_Salida = Salida_SI) then
        select  convert(Par_NumErr, char(3)) as NumErr,
                Par_ErrMen as ErrMen,
                Var_Control as control,
                Var_Consecutivo as consecutivo;
    end if;
END TerminaStore$$