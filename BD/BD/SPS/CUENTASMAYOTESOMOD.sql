-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYOTESOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYOTESOMOD`;
DELIMITER $$


CREATE PROCEDURE `CUENTASMAYOTESOMOD`(
    Par_ConceptoTesoID  int(11),
    Par_EmpresaID       int(11),
    Par_Cuenta          char(4),
    Par_Nomenclatura    varchar(30),
    Par_NomenclaturaCR  varchar(30),

    Par_Salida            char(1),
inout	Par_NumErr          int(11),
inout	Par_ErrMen          varchar(100),
inout	Par_Consecutivo     bigint,

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint  	)

TerminaStore: BEGIN


DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE Float_Cero      float;
DECLARE Numero          int;
DECLARE Salida_SI       char(1);


Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set Float_Cero      := 0.0;
set Numero          := 0;
Set Salida_SI       := 'S';

if(ifnull(Par_ConceptoTesoID, Entero_Cero))= Entero_Cero then
    if (Par_Salida = Salida_SI) then
        select '001' as NumErr,
                'El Concepto esta Vacio.' as ErrMen,
                'ConceptoTesoID' as control;
    else
        set Par_NumErr      := 1;
        set Par_ErrMen      := 'El Concepto esta Vacio.';
        set Par_Consecutivo := Entero_Cero;
    end if;

	LEAVE TerminaStore;

end if;

if(ifnull(Par_EmpresaID, Entero_Cero))= Entero_Cero then
    if (Par_Salida = Salida_SI) then
        select 2 as NumErr,
             'El Numero de Empresa esta Vacio.' as ErrMen,
             'empresaID' as control;
    else
        set Par_NumErr      := 2;
        set Par_ErrMen      := 'El Numero de Empresa esta Vacio.';
        set Par_Consecutivo := Entero_Cero;
    end if;

	LEAVE TerminaStore;

end if;

if(ifnull(Par_Nomenclatura, Cadena_Vacia))= Cadena_Vacia then
    if (Par_Salida = Salida_SI) then
        select 3 as NumErr,
             'La Nomenclatura esta Vacia.' as ErrMen,
             'nomenclatura' as control;
    else
        set Par_NumErr      := 3;
        set Par_ErrMen      := 'La Nomenclatura esta Vacia.';
        set Par_Consecutivo := Entero_Cero;
    end if;

	LEAVE TerminaStore;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

update CUENTASMAYORTESO set
    ConceptoTesoID  = Par_ConceptoTesoID,
    EmpresaID       = Par_EmpresaID,
    Cuenta          = Par_Cuenta,
    Nomenclatura    = Par_Nomenclatura,
    NomenclaturaCR  = Par_NomenclaturaCR,

    EmpresaID       = Par_EmpresaID,
    Usuario         = Aud_Usuario,
    FechaActual     = Aud_FechaActual,
    DireccionIP     = Aud_DireccionIP,
    ProgramaID      = Aud_ProgramaID,
    Sucursal        = Aud_Sucursal,
    NumTransaccion  = Aud_NumTransaccion

	where ConceptoTesoID    = Par_ConceptoTesoID;


if (Par_Salida = Salida_SI) then
    select 0 as NumErr,
           'Información Actualizada' as ErrMen,
           'ConceptoTesoID' as control;
else
    set Par_NumErr      := 0;
    set Par_ErrMen      := 'Información Actualizada';
    set Par_Consecutivo := Entero_Cero;
end if;

END TerminaStore$$