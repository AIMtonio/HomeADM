-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVTESOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSMOVTESOMOD`;
DELIMITER $$


CREATE PROCEDURE `TIPOSMOVTESOMOD`(
    Par_TipMovTesID varchar(4),
    Par_Descripcion varchar(150),
    Par_TipoMovimi  char(1),
    Par_CtaContable varchar(25),
    Par_CtaMayor    varchar(4),
    Par_CtaEditable char(1),
    Par_NaturaConta char(1),

      Par_Salida         char(1),
out	Par_NumErr			int(11),
out	Par_ErrMen			varchar(100),
out	Par_Consecutivo		bigint,

    Aud_EmpresaID        int,
    Aud_Usuario          int,
    Aud_FechaActual      Datetime,
    Aud_DireccionIP      varchar(20),
    Aud_ProgramaID       varchar(50),
    Aud_Sucursal         int,
    Aud_NumTransaccion   bigint(20)
	)

TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_Descri          varchar(200);
DECLARE Var_Descricuenta    varchar(200);

-- Declaracion de constantes
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE EstatusActivo   char(1);
DECLARE Salida_SI       char(1);
DECLARE Salida_NO       char(1);
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

-- Asignacion de constantes
SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET EstatusActivo       := 'A';
SET Salida_SI           := 'S';
SET Salida_NO           := 'N';
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';
SET Editable_SI         := 'S';
SET Editable_NO         := 'N';
SET Tipo_Concilia       := 'C';
SET Tipo_DepRefere      := 'R';
SET Tipo_Dispersion     := 'D';
SET Tipo_PagoProve      := 'P';
SET Tipo_InverBan      	:= 'I';
SET Tipo_Caja     		:= 'V';
SET Tipo_Fondeador      := 'F';

if(ifnull(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia then
    if (Par_Salida = Salida_SI) then
        select 1 as NumErr,
             'La Descripción está vacia.' as ErrMen,
             'Descripcion' as control,
	        Entero_Cero as consecutivo;
    else
        SET Par_NumErr      := 1;
        SET Par_ErrMen      := 'La Descripción está vacia.';
        SET Par_Consecutivo := Entero_Cero;
    end if;

    LEAVE TerminaStore;
end if;

SET Par_TipoMovimi := ifnull(Par_TipoMovimi, Cadena_Vacia);

if (Par_TipoMovimi != Tipo_Concilia and
    Par_TipoMovimi != Tipo_DepRefere and
    Par_TipoMovimi != Tipo_Dispersion and
    Par_TipoMovimi != Tipo_PagoProve and
    Par_TipoMovimi != Tipo_InverBan and
    Par_TipoMovimi != Tipo_Caja 	and
    Par_TipoMovimi != Tipo_Fondeador) then

    if (Par_Salida = Salida_SI) then
        select 2 as NumErr,
             'Tipo de Movimiento Incorrecto.' as ErrMen,
             'TipoMovimiento' as control,
	        Entero_Cero as consecutivo;
    else
        SET Par_NumErr      := 2;
        SET Par_ErrMen      := 'Tipo de Movimiento Incorrecto.';
        SET Par_Consecutivo := Entero_Cero;
    end if;

    LEAVE TerminaStore;
end if;


if (Par_TipoMovimi = Tipo_Concilia) then

    SET Par_CtaEditable = ifnull(Par_CtaEditable, Cadena_Vacia);

    if(Par_CtaEditable != Editable_SI  and
       Par_CtaEditable != Editable_NO) then

        if (Par_Salida = Salida_SI) then
            select 3 as NumErr,
                 'Cuenta Editable Incorrecta.' as ErrMen,
                 'CuentaEditable' as control,
		      Entero_Cero as consecutivo;
        else
            SET Par_NumErr      := 3;
            SET Par_ErrMen      := 'Cuenta Editable Incorrecta.';
            SET Par_Consecutivo := Entero_Cero;
        end if;

        LEAVE TerminaStore;
    end if;

    SET Par_CtaEditable = ifnull(Par_CtaEditable, Cadena_Vacia);

    -- valida la Cuenta Constable EspecIFicada
    CALL CUENTASCONTABLESVAL(	Par_CtaContable,	Editable_NO,		Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
                                Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                                Aud_NumTransaccion);
    -- Validamos la respuesta
    IF(Par_NumErr <> Entero_Cero) THEN
        IF (Par_Salida = Salida_SI) THEN
            SELECT 4 AS NumErr,
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

    IF(Par_CtaEditable != Editable_NO ) THEN
        SET Par_CtaMayor := ifnull(Par_CtaMayor, Cadena_Vacia);

        if (Par_CtaMayor = Cadena_Vacia) then

            if (Par_Salida = Salida_SI) then
                select 5 as NumErr,
                     'Cuenta de Mayor Incorrecta.' as ErrMen,
                     'CuentaMayor' as control,
				Entero_Cero as consecutivo;
            else
                SET Par_NumErr      := 5;
                SET Par_ErrMen      := 'Cuenta de Mayor Incorrecta';
                SET Par_Consecutivo := Entero_Cero;
            end if;
            LEAVE TerminaStore;
        end if;
    end if;


end if;

select Descripcion into Var_Descri
    from TIPOSMOVTESO
    where TipoMovTesoID = Par_TipMovTesID;

SET Var_Descri := ifnull(Var_Descri, Cadena_Vacia);

if (Var_Descri = Cadena_Vacia) then

    if (Par_Salida = Salida_SI) then
        select 6 as NumErr,
             'El Tipo de Movimiento No Existe.' as ErrMen,
             'El Tipo de Movimiento No Existe.' as control,
		  Entero_Cero as consecutivo;
    else
        SET Par_NumErr      := 6;
        SET Par_ErrMen      := 'El Tipo de Movimiento No Existe.';
        SET Par_Consecutivo := Entero_Cero;
    end if;
    LEAVE TerminaStore;
end if;

 -- valida la Cuenta Constable
CALL CUENTASCONTABLESVAL(	Par_CtaContable,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
						    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						    Aud_NumTransaccion);
-- Validamos la respuesta
IF(Par_NumErr <> Entero_Cero) THEN
    SET Par_Consecutivo := Entero_Cero;
    LEAVE TerminaStore;
END IF;

SET Aud_FechaActual := CURRENT_TIMESTAMP();

update TIPOSMOVTESO SET

    Descripcion     = Par_Descripcion,
    TipoMovimiento  = Par_TipoMovimi,
    CuentaContable  = Par_CtaContable,
    CuentaMayor     = Par_CtaMayor,
    CuentaEditable  = Par_CtaEditable,
    NaturaContable  = Par_NaturaConta,

    EmpresaID       = Aud_EmpresaID,
    Usuario         = Aud_Usuario,
    FechaActual     = Aud_FechaActual,
    DireccionIP     = Aud_DireccionIP,
    ProgramaID      = Aud_ProgramaID,
    Sucursal        = Aud_Sucursal,
    NumTransaccion  = Aud_NumTransaccion

    where TipoMovTesoID = Par_TipMovTesID;


if (Par_Salida = Salida_SI) then
    select 0 as NumErr,
            "Tipo Movimiento Modificado: " as ErrMen,
            'tipoMovTesoID' as control,
            Par_TipMovTesID as consecutivo;
else
    SET Par_NumErr      := 0;
    SET Par_ErrMen      := "Tipo Movimiento Modificado: ";
    SET Par_Consecutivo := Par_TipMovTesID;
end if;

END TerminaStore$$
