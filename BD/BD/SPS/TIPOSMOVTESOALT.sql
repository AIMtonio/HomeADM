-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVTESOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSMOVTESOALT`;
DELIMITER $$


CREATE PROCEDURE `TIPOSMOVTESOALT`(
    Par_Descripcion 	varchar(150),
    Par_TipoMovimi  	char(1),
    Par_CtaContable 	varchar(25),
    Par_CtaMayor    	varchar(4),
    Par_CtaEditable 	char(1),
    Par_NaturaConta 	char(1),

      Par_Salida        char(1),
inout	Par_NumErr		int(11),
inout	Par_ErrMen		varchar(400),
inout	Par_Consecutivo	bigint,

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     Datetime,
    Aud_DireccionIP     varchar(20),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint(20)
	)

TerminaStore: BEGIN


DECLARE Var_MovTesoID       char(4);
DECLARE Num_MovTesoID       int;
DECLARE Var_DescriCuenta    varchar(250);


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE EstatusActivo   char(1);
DECLARE Salida_SI       char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);
DECLARE Editable_SI     char(1);
DECLARE Editable_NO     char(1);
DECLARE Tipo_Concilia   char(1);
DECLARE Tipo_DepRefere  char(1);
DECLARE Tipo_Dispersion char(1);
DECLARE Tipo_PagoProve  char(1);
DECLARE Tipo_InverBan  	char(1);
DECLARE Tipo_Caja  		char(1);
DECLARE Tipo_Fondeador  char(1);


Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set EstatusActivo       := 'A';
Set Salida_SI           := 'S';
Set Nat_Cargo           := 'C';
Set Nat_Abono           := 'A';
Set Editable_SI         := 'S';
Set Editable_NO         := 'N';

Set Tipo_Concilia       := 'C';
Set Tipo_DepRefere      := 'R';
Set Tipo_Dispersion     := 'D';
Set Tipo_PagoProve      := 'P';
Set Tipo_InverBan      	:= 'I';
Set Tipo_Caja     		:= 'V';
Set Tipo_Fondeador      := 'F';

if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
    if (Par_Salida = Salida_SI) then
        select '001' as NumErr,
             'La Descripción está vacia.' as ErrMen,
             'Descripcion' as control,
		  Entero_Cero as consecutivo;
    else
        set Par_NumErr      := 1;
        set Par_ErrMen      := 'La Descripción está vacia.';
        set Par_Consecutivo := Entero_Cero;
    end if;

    LEAVE TerminaStore;
end if;

set Par_TipoMovimi := ifnull(Par_TipoMovimi, Cadena_Vacia);

if (Par_TipoMovimi != Tipo_Concilia and
    Par_TipoMovimi != Tipo_DepRefere and
    Par_TipoMovimi != Tipo_Dispersion and
    Par_TipoMovimi != Tipo_PagoProve and
    Par_TipoMovimi != Tipo_InverBan and
    Par_TipoMovimi != Tipo_Caja 	and
    Par_TipoMovimi != Tipo_Fondeador) then

    if (Par_Salida = Salida_SI) then
        select '002' as NumErr,
             'Tipo de Movimiento Incorrecto.' as ErrMen,
             'TipoMovimiento' as control,
		  Entero_Cero as consecutivo;
    else
        set Par_NumErr      := 2;
        set Par_ErrMen      := 'Tipo de Movimiento Incorrecto.';
        set Par_Consecutivo := Entero_Cero;
    end if;

    LEAVE TerminaStore;
end if;


if (Par_TipoMovimi = Tipo_Concilia) then

    set Par_CtaEditable = ifnull(Par_CtaEditable, Cadena_Vacia);

    if(Par_CtaEditable != Editable_SI  and
       Par_CtaEditable != Editable_NO) then

        if (Par_Salida = Salida_SI) then
            select '003' as NumErr,
                 'Cuenta Editable Incorrecta.' as ErrMen,
                 'CuentaEditable' as control,
			Entero_Cero as consecutivo;
        else
            set Par_NumErr      := 3;
            set Par_ErrMen      := 'Cuenta Editable Incorrecta.';
            set Par_Consecutivo := Entero_Cero;
        end if;

        LEAVE TerminaStore;
    end if;

    set Par_CtaEditable = ifnull(Par_CtaEditable, Cadena_Vacia);

    -- valida la Cuenta Constable EspecIFicada
    CALL CUENTASCONTABLESVAL(	Par_CtaContable,	Editable_NO,		Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
                                Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                                Aud_NumTransaccion);
    -- Validamos la respuesta
    IF(Par_NumErr <> Entero_Cero) THEN
        IF (Par_Salida = Salida_SI) THEN
            SELECT '004' AS NumErr,
                Par_ErrMen AS ErrMen,
                'cuentaContable' AS control,
                Entero_Cero AS consecutivo;
        ELSE
            SET Par_NumErr      := 4;
            SET Par_ErrMen      := Par_NumErr;
            SET Par_Consecutivo := Entero_Cero;
        END IF;
        LEAVE TerminaStore;
    END IF;

    if(Par_CtaEditable != Editable_NO ) then

        set Par_CtaMayor := ifnull(Par_CtaMayor, Cadena_Vacia);

        if (Par_CtaMayor = Cadena_Vacia) then

            if (Par_Salida = Salida_SI) then
                select '005' as NumErr,
                     'Cuenta de Mayor Incorrecta.' as ErrMen,
                     'CuentaMayor' as control,
			    Entero_Cero as consecutivo;

            else
                set Par_NumErr      := 5;
                set Par_ErrMen      := 'Cuenta de Mayor Incorrecta';
                set Par_Consecutivo := Entero_Cero;
            end if;
            LEAVE TerminaStore;
        end if;
    end if;


end if;

select max(convert(TipoMovTesoID, UNSIGNED)) into Num_MovTesoID
    from TIPOSMOVTESO;

set Num_MovTesoID = ifnull(Num_MovTesoID, Entero_Cero) + 1;

set Var_MovTesoID   = convert(Num_MovTesoID, char(4));
Set Aud_FechaActual := CURRENT_TIMESTAMP();
insert into TIPOSMOVTESO values(
    Var_MovTesoID,      Par_Descripcion,    EstatusActivo,      Par_TipoMovimi, Par_CtaContable,
    Par_CtaMayor,       Par_CtaEditable,    Par_NaturaConta,    Aud_EmpresaID,  Aud_Usuario,
    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion  );

if (Par_Salida = Salida_SI) then
    select '000' as NumErr,
            concat("Tipo Movimiento Agregado: ", Var_MovTesoID)  as ErrMen,
            'tipoMovTesoID' as control,
            Num_MovTesoID as consecutivo;
else
    set Par_NumErr      := 0;
    set Par_ErrMen      := concat("Tipo Movimiento Agregado: ", Var_MovTesoID);
    set Par_Consecutivo := Num_MovTesoID;
end if;

END TerminaStore$$
