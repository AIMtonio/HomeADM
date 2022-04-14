-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOVIVIENALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMOVIVIENALT`;DELIMITER $$

CREATE PROCEDURE `SOCIODEMOVIVIENALT`(
    Par_Prospecto               INT(11)
    ,Par_Cliente                INT(11)
    ,Par_TipoVivienda           INT(11)
    ,Par_ConDrenaje             Char(1)
    ,Par_ConElectricidad        char(1)
    ,Par_ConAgua                char(1)
    ,Par_ConGas                 char(1)
    ,Par_ConPavimento           char(1)
    ,Par_TipoMaterial           int(11)
    ,Par_ValorVivienda          decimal(18,2)
    ,Par_Descripcion            varchar(500)
    ,Par_TiempoHabitarDom       int

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



Set Cadena_Vacia            := '';
Set Fecha_Vacia             := '1900-01-01';
Set Entero_Cero             := 0;
Set Str_SI                  := 'S';
Set Str_NO                  := 'N';



Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set Par_NumErr              := 1;
set Par_ErrMen              := Cadena_Vacia;

Set Var_FechaRegistro       :=	(select FechaSistema from PARAMETROSSIS);


Set Par_Prospecto           := ifnull(Par_Prospecto, Entero_Cero);
Set Par_Cliente             := ifnull(Par_Cliente, Entero_Cero);
Set Par_Descripcion         := ifnull(Par_Descripcion, Cadena_Vacia);
Set Par_ValorVivienda       := ifnull(Par_ValorVivienda, Entero_Cero);
Set Par_TipoVivienda        := ifnull(Par_TipoVivienda, Entero_Cero);
set Par_TiempoHabitarDom    := ifnull(Par_TiempoHabitarDom,Entero_Cero);

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


if not exists(select TipoViviendaID from TIPOVIVIENDA where TipoViviendaID = Par_TipoVivienda)  then
    Set Par_ErrMen  := 'El Tipo de Vivienda no existe';
    if(Par_Salida = Str_SI) then
            select '005' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoViviendaID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if Par_ConDrenaje not in(Str_SI, Str_NO) then
    Set Par_ErrMen  := 'Valor Indicado en Cuenta con Drenaje no es valido.';
    if(Par_Salida = Str_SI) then
            select '006' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoViviendaID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


if Par_ConElectricidad not in(Str_SI, Str_NO) then
    Set Par_ErrMen  := 'Valor Indicado en Cuenta con Electricidad no es valido.';
    if(Par_Salida = Str_SI) then
            select '007' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoViviendaID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


if Par_ConAgua not in(Str_SI, Str_NO) then
    Set Par_ErrMen  := 'Valor Indicado en Cuenta con Drenaje no es valido.';
    if(Par_Salida = Str_SI) then
            select '008' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoViviendaID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;


if Par_ConGas not in(Str_SI, Str_NO) then
    Set Par_ErrMen  := 'Valor Indicado en Cuenta con Drenaje no es valido.';
    if(Par_Salida = Str_SI) then
            select '009' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoViviendaID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if Par_ConPavimento not in(Str_SI, Str_NO) then
    Set Par_ErrMen  := 'Valor Indicado en Cuenta con Drenaje no es valido.';
    if(Par_Salida = Str_SI) then
            select '010' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoViviendaID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if not exists(select TipoMaterialID from TIPOMATERIALVIV where TipoMaterialID = Par_TipoMaterial) then
    Set Par_ErrMen  := 'El tipo de Material de la vivienda no existe.';
    if(Par_Salida = Str_SI) then
            select '011' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoViviendaID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if Par_ValorVivienda <= Entero_Cero then
    Set Par_ErrMen  := 'El valor de la vivienda debe ser mayor a cero';
    if(Par_Salida = Str_SI) then
            select '012' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoViviendaID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

if CHAR_LENGTH(Par_Descripcion) <= 0 then
    Set Par_ErrMen  := 'La descripcion de la vivienda no puede estar vacio.';
    if(Par_Salida = Str_SI) then
            select '014' as NumErr,
                    Par_ErrMen as ErrMen,
                    'tipoViviendaID' as control,
                    Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;



insert SOCIODEMOVIVIEN (ProspectoID         ,ClienteID          ,FechaRegistro          ,TipoViviendaID         ,ConDrenaje
                        ,ConElectricidad    ,ConAgua            ,ConGas                 ,ConPavimento           ,TipoMaterialID
                        ,ValorVivienda      ,Descripcion        ,TiempoHabitarDom       ,EmpresaID              ,Usuario                ,FechaActual
                        ,DireccionIP        ,ProgramaID         ,Sucursal               ,NumTransaccion )

values( Par_Prospecto           ,Par_Cliente            ,Var_FechaRegistro          ,Par_TipoVivienda       ,Par_ConDrenaje
        ,Par_ConElectricidad    ,Par_ConAgua            ,Par_ConGas                 ,Par_ConPavimento       ,Par_TipoMaterial
        ,Par_ValorVivienda      ,Par_Descripcion        ,Par_TiempoHabitarDom       ,Aud_Empresa                ,Aud_Usuario            ,Aud_FechaActual
        ,Aud_DireccionIP        ,Aud_ProgramaID         ,Aud_Sucursal               ,Aud_NumTransaccion  );


Set Par_NumErr  := Entero_Cero;
Set Par_ErrMen  := 'Los Datos de la vivienda se Grabaron con Exito';

if(Par_Salida = Str_SI) then
        select '000' as NumErr,
                Par_ErrMen as ErrMen,
                'tipoViviendaID' as control,
                Entero_Cero as consecutivo;
end if;



END TerminaStore$$