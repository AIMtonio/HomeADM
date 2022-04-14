-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSOCIODEMOVIVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISSOCIODEMOVIVALT`;DELIMITER $$

CREATE PROCEDURE `HISSOCIODEMOVIVALT`(
     Par_Prospecto              INT(11)
    ,Par_Cliente                INT(11)

    ,Par_Salida                 char(1)
    ,inout Par_NumErr           int(11)
    ,inout Par_ErrMen           varchar(400)

    ,Aud_EmpresaID              int(11)
    ,Aud_Usuario                int(11)
    ,Aud_FechaActual            DateTime
    ,Aud_DireccionIP            varchar(15)
    ,Aud_ProgramaID             varchar(50)
    ,Aud_Sucursal               int(11)
    ,Aud_NumTransaccion         bigint(20)
	)
TerminaStore: BEGIN


DECLARE Var_FechaHistorico      DATE;
DECLARE Var_Consecutivo         INT(11);


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

Set Var_FechaHistorico      :=	(select FechaSistema from PARAMETROSSIS);



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
    if not exists(select ClienteID from SOCIODEMOVIVIEN where ClienteID = Par_Cliente) then
        Set Par_NumErr  := Entero_Cero;
        Set Par_ErrMen  := 'No hay datos para enviar a Historico';
        if(Par_Salida = Str_SI) then
                select '000' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
else
    if not exists(select ProspectoID from SOCIODEMOVIVIEN where ProspectoID = Par_Prospecto) then
        Set Par_NumErr  := Entero_Cero;
        Set Par_ErrMen  := 'No hay datos para enviar a Historico';
        if(Par_Salida = Str_SI) then
                select '000' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
end if;

Set Var_Consecutivo := (select max(Consecutivo) from HISSOCIODEMOVIV);
Set Var_Consecutivo := ifnull(Var_Consecutivo, Entero_Cero) + 1;


if Par_Cliente > Entero_Cero then
    insert into HISSOCIODEMOVIV
    select  ProspectoID         ,ClienteID          ,FechaRegistro          ,Var_FechaHistorico     ,Var_Consecutivo
            ,TipoViviendaID     ,ConDrenaje         ,ConElectricidad        ,ConAgua                ,ConGas
            ,ConPavimento       ,TipoMaterialID     ,ValorVivienda          ,Descripcion            ,Aud_EmpresaID
            ,Aud_Usuario        ,Aud_FechaActual    ,Aud_DireccionIP        ,Aud_ProgramaID         ,Aud_Sucursal
            ,Aud_NumTransaccion
    from SOCIODEMOVIVIEN
    where ClienteID = Par_Cliente;
else
    insert into HISSOCIODEMOVIV
     select  ProspectoID         ,ClienteID          ,FechaRegistro          ,Var_FechaHistorico     ,Var_Consecutivo
            ,TipoViviendaID     ,ConDrenaje         ,ConElectricidad        ,ConAgua                ,ConGas
            ,ConPavimento       ,TipoMaterialID     ,ValorVivienda          ,Descripcion            ,Aud_EmpresaID
            ,Aud_Usuario        ,Aud_FechaActual    ,Aud_DireccionIP        ,Aud_ProgramaID         ,Aud_Sucursal
            ,Aud_NumTransaccion
    from SOCIODEMOVIVIEN
    where ProspectoID = Par_Prospecto;
end if;

call SOCIODEMOVIVIENBAJ(Par_Prospecto   ,Par_Cliente        ,Baj_PorCliProspe       ,Str_NO             ,Par_NumErr
                        ,Par_ErrMen     ,Aud_EmpresaID      ,Aud_Usuario            ,Aud_FechaActual    ,Aud_DireccionIP
                        ,Aud_ProgramaID ,Aud_Sucursal       ,Aud_NumTransaccion);

if(Par_NumErr <> Entero_Cero) then
    if(Par_Salida = Str_SI) then
            select '006' as NumErr,
                    Par_ErrMen as ErrMen,
                    'clienteID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

Set Par_NumErr  := Entero_Cero;
Set Par_ErrMen  := 'Datos de la vivienda Grabados con Exito';

if(Par_Salida = Str_SI) then
        select '000' as NumErr,
                Par_ErrMen as ErrMen,
                'clienteID' as control,
                Entero_Cero as consecutivo;
end if;



END TerminaStore$$