-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOCONYUGBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMOCONYUGBAJ`;DELIMITER $$

CREATE PROCEDURE `SOCIODEMOCONYUGBAJ`(
    Par_Prospecto               INT(11)
    ,Par_Cliente                INT(11)
    ,Par_TipoBaja               INT(11)

    ,Par_Salida                 char(1)
    ,inout Par_NumErr           int(11)
    ,inout Par_ErrMen           varchar(400)

    ,Aud_Empresa                int(11)
    ,Aud_Usuario                int(11)
    ,Aud_FechaActual            DateTime
    ,Aud_DireccionIP            varchar(15)
    ,Aud_ProgramaID             varchar(50)
    ,Aud_Sucursal               int(11)
    ,Aud_NumTransaccion         bigint(20)
	)
TerminaStore: BEGIN


DECLARE Var_FechaRegistro       DATE;


DECLARE Cadena_Vacia            char(1);
DECLARE Fecha_Vacia             datetime;
DECLARE Entero_Cero             int(11);
DECLARE Str_SI                  char(1);
DECLARE Str_NO                  char(1);

DECLARE Baj_PorCliProspe        int(11);


Set Cadena_Vacia            := '';
Set Fecha_Vacia             := '1900-01-01';
Set Entero_Cero             := 0;
Set Str_SI                  := 'S';
Set Str_NO                  := 'N';

Set Baj_PorCliProspe        := 1;


Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set Par_NumErr              := 1;
set Par_ErrMen              := Cadena_Vacia;

Set Var_FechaRegistro       :=	(select FechaSistema from PARAMETROSSIS);


Set Par_Prospecto           := ifnull(Par_Prospecto, Entero_Cero);
Set Par_Cliente             := ifnull(Par_Cliente, Entero_Cero);


if Par_TipoBaja = Baj_PorCliProspe then

    if (Par_Prospecto = Entero_Cero and Par_Cliente = Entero_Cero) then
        Set Par_ErrMen  := 'Numero de Cliente y Prospecto no son validos.';
        if(Par_Salida = Str_SI) then
                select '001' as NumErr,
                    Par_ErrMen as ErrMen,
                    'clienteID' as control,
                 Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end if;


    if Par_Cliente > Entero_Cero then
        if not exists(select ClienteID from CLIENTES where ClienteID = Par_Cliente) then
            Set Par_ErrMen  := 'El Numero de Cliente no Existe';
            if(Par_Salida = Str_SI) then
                    select '002' as NumErr,
                            Par_ErrMen as ErrMen,
                            'clienteID' as control,
                            Entero_Cero as consecutivo;
            end if;
            LEAVE TerminaStore;
        end If;
    else
        if not exists(select ProspectoID from PROSPECTOS where ProspectoID = Par_Prospecto) then
            Set Par_ErrMen  := 'El Numero de Prospecto no Existe';
            if(Par_Salida = Str_SI) then
                    select '003' as NumErr,
                            Par_ErrMen as ErrMen,
                            'prospectoID' as control,
                            Entero_Cero as consecutivo;
            end if;
            LEAVE TerminaStore;
        end If;
    end if;


    if Par_Cliente > Entero_Cero then
        delete from SOCIODEMOCONYUG
        where ClienteID = Par_Cliente;
    else
        delete from SOCIODEMOCONYUG
        where ProspectoID = Par_Prospecto;
    end if;


    Set Par_NumErr  := Entero_Cero;
    Set Par_ErrMen  := 'Datos del Conyuge Eliminados con Exito';

    if(Par_Salida = Str_SI) then
            select '000' as NumErr,
                    Par_ErrMen as ErrMen,
                    'clienteID' as control,
                    Entero_Cero as consecutivo;
    end if;
end if;


END TerminaStore$$