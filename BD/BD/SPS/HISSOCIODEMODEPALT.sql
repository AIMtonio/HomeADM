-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSOCIODEMODEPALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISSOCIODEMODEPALT`;DELIMITER $$

CREATE PROCEDURE `HISSOCIODEMODEPALT`(
	Par_ProspectoID			int(11),
	Par_ClienteID			int(11),

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Aud_EmpresaID           int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_DescriProd          char(150);
DECLARE Var_DescriPues          char(150);
DECLARE Var_ProspectoID         int(11);
DECLARE Var_ClienteID           int(11);
DECLARE Var_TipoRelacionID      INT(11);
DECLARE Var_DependienteID       int(11);
DECLARE Var_FechaHistorico      DATE;
DECLARE Var_Consecutivo         int(11);

-- Declaracion de constantes
DECLARE Cadena_Vacia            char(1);
DECLARE Entero_Cero             int;
DECLARE SalidaNO                char(1);
DECLARE SalidaSI                char(1);
DECLARE Tipo_BajaCliPro         int(11);

-- Asignacion  de constantes
Set Cadena_Vacia            := '';
Set Entero_Cero             := 0;           -- Entero en Cero
Set SalidaNO                :='N';          -- El store NO arroja una SALIDA
Set SalidaSI                :='S';          -- El store SI arroja una SALIDA
Set Tipo_BajaCliPro         := 2;           -- Baja por Numero de Cliente o Prospecto

-- Fecha de Base de Datos
Set Aud_FechaActual         := CURRENT_TIMESTAMP();

/* Inicializar parametros de salida */
Set Par_NumErr              := 1;
set Par_ErrMen              := Cadena_Vacia;

Set Var_FechaHistorico      :=	(select FechaSistema from PARAMETROSSIS);

if(ifnull(Par_ProspectoID, Entero_Cero)) = Entero_Cero then
	Set Par_ProspectoID := Entero_Cero;
end if;


if(ifnull(Par_ClienteID, Entero_Cero)) = Entero_Cero then
	Set Par_ClienteID := Entero_Cero;
end if;


if (Par_ProspectoID = Entero_Cero and Par_ClienteID = Entero_Cero) then
    Set Par_ErrMen  := 'Debe seleccionar un Cliente o Prospecto.';
    if(Par_Salida = SalidaSI) then
			select '001' as NumErr,
				Par_ErrMen as ErrMen,
				'clienteID' as control,
             Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;

-- valida que cliente o Prospecto exista
if Par_ClienteID > Entero_Cero then
    if not exists(select ClienteID from CLIENTES where ClienteID = Par_ClienteID) then
        Set Par_ErrMen  := 'El Numero de Cliente no Existe';
        if(Par_Salida = SalidaSI) then
                select '002' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;

    /* valida que exitan datos que pasar a Historico de lo contrario solo se sale del store*/
    if not exists(select ClienteID from SOCIODEMODEPEND where ClienteID = Par_ClienteID) then
        Set Par_NumErr  := Entero_Cero;
        Set Par_ErrMen  := 'El Numero de Cliente no tiene datos capturados para mandar a Historico';
        if(Par_Salida = SalidaSI) then
                select '000' as NumErr,
                        Par_ErrMen as ErrMen,
                        'clienteID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;

else
    if not exists(select ProspectoID from PROSPECTOS where ProspectoID = Par_ProspectoID) then
        Set Par_ErrMen  := 'El Numero de Prospecto no Existe';
        if(Par_Salida = SalidaSI) then
                select '003' as NumErr,
                        Par_ErrMen as ErrMen,
                        'prospectoID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;

    /* valida que exitan datos que pasar a Historico de lo contrario solo se sale del store*/
    if not exists(select ClienteID from SOCIODEMODEPEND where ProspectoID = Par_ProspectoID) then
        Set Par_NumErr  := Entero_Cero;
        Set Par_ErrMen  := 'El Numero de Prospecto no tiene datos capturados para mandar a Historico';
        if(Par_Salida = SalidaSI) then
                select '000' as NumErr,
                        Par_ErrMen as ErrMen,
                        'prospectoID' as control,
                        Entero_Cero as consecutivo;
        end if;
        LEAVE TerminaStore;
    end If;
end if;


-- Calculamos el Consecutivo para todo el bloque de datos
Set Var_Consecutivo := (select ifnull(max(Consecutivo),Entero_Cero)  from  HISSOCIODEMODEP);

set Var_Consecutivo := ifnull(Var_Consecutivo, Entero_Cero) + 1;


if Par_ClienteID > Entero_Cero then
    insert into HISSOCIODEMODEP
    select  ProspectoID
            ,ClienteID
            ,Var_Consecutivo
            ,FechaRegistro
            ,Var_FechaHistorico
            ,TipoRelacionID
            ,PrimerNombre
            ,SegundoNombre
            ,TercerNombre
            ,ApellidoPaterno
            ,ApellidoMaterno
            ,Edad
            ,OcupacionID
            ,Aud_EmpresaID
            ,Aud_Usuario
            ,Aud_FechaActual
            ,Aud_DireccionIP
            ,Aud_ProgramaID
            ,Aud_Sucursal
            ,Aud_NumTransaccion
    from SOCIODEMODEPEND
    where ClienteID = Par_ClienteID;
else
    insert into HISSOCIODEMODEP
    select  ProspectoID
            ,ClienteID
            ,Var_Consecutivo
            ,FechaRegistro
            ,Var_FechaHistorico
            ,TipoRelacionID
            ,PrimerNombre
            ,SegundoNombre
            ,TercerNombre
            ,ApellidoPaterno
            ,ApellidoMaterno
            ,Edad
            ,OcupacionID
            ,Aud_EmpresaID
            ,Aud_Usuario
            ,Aud_FechaActual
            ,Aud_DireccionIP
            ,Aud_ProgramaID
            ,Aud_Sucursal
            ,Aud_NumTransaccion
    from SOCIODEMODEPEND
    where ProspectoID = Par_ProspectoID;
end if;



CALL SOCIODEMODEPENDBAJ(Entero_Cero,        Par_ProspectoID,    Par_ClienteID,      Tipo_BajaCliPro,        SalidaNO,
                        Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,      Aud_Usuario,            Aud_FechaActual,
                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


if Par_NumErr > Entero_Cero then
	if(Par_Salida = SalidaSI) then
        select  '004' as NumErr,
                Par_ErrMen as ErrMen,
                'prospectoID' as control,
                Entero_Cero as consecutivo;
	end if;
    LEAVE TerminaStore;
end if;


set	Par_NumErr	:= Entero_Cero;
set	Par_ErrMen	:= 'Datos Sociodemograficos se pasaron a Historico con Exito.' ;

if(Par_Salida = SalidaSI) then
    select '000' as NumErr,
            Par_ErrMen as ErrMen,
            'prospectoID' as control,
            Entero_Cero as consecutivo;
end if;



END TerminaStore$$