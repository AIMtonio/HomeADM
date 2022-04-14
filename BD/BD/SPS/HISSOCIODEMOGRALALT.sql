-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSOCIODEMOGRALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISSOCIODEMOGRALALT`;DELIMITER $$

CREATE PROCEDURE `HISSOCIODEMOGRALALT`(
	 Par_ProspectoID			int(11),
	 Par_ClienteID           int(11),

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


DECLARE Var_DescriProd          char(150);
DECLARE Var_DescriPues          char(150);
DECLARE Var_ProspectoID         int(11);
DECLARE Var_ClienteID           int(11);
DECLARE Var_GradoEscolarID      INT(11);
DECLARE Var_PivoteID            int(11);
DECLARE Var_FechaHistorico      date;



DECLARE Cadena_Vacia        char(1);
DECLARE Entero_Cero         int;
DECLARE SalidaNO            char(1);
DECLARE SalidaSI            char(1);
DECLARE Var_Consecutivo     INT(11);
DECLARE Tipo_BajaCliPro     int(11);




Set Cadena_Vacia            := '';
Set Entero_Cero             := 0;
Set SalidaNO                :='N';
Set SalidaSI                :='S';
Set Tipo_BajaCliPro         := 1;



Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set Par_NumErr              := 1;
set Par_ErrMen              := '';

Set Var_FechaHistorico       :=	(select FechaSistema from PARAMETROSSIS);

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


if Par_ClienteID > Entero_Cero then
    set Var_PivoteID    := Par_ClienteID;
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


    if not exists(select ClienteID from SOCIODEMOGRAL where ClienteID = Par_ClienteID) then
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
    set Var_PivoteID    := Par_ProspectoID;
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


    if not exists(select ClienteID from SOCIODEMOGRAL where ProspectoID = Par_ProspectoID) then
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



Set Var_Consecutivo := (select ifnull(max(Consecutivo),Entero_Cero)   from  HISSOCIODEMOGRAL);

Set Var_Consecutivo := ifnull(Var_Consecutivo, Entero_Cero) + 1;


if Par_ClienteID > Entero_Cero then
    insert into HISSOCIODEMOGRAL
    select  ProspectoID
            ,ClienteID
            ,FechaRegistro
            ,Var_FechaHistorico
            ,Var_Consecutivo
            ,GradoEscolarID
            ,NumDepenEconomi
			,AntiguedadLab
			,FechaIniTrabajo
            ,Aud_EmpresaID
            ,Aud_Usuario
            ,Aud_FechaActual
            ,Aud_DireccionIP
            ,Aud_ProgramaID
            ,Aud_Sucursal
            ,Aud_NumTransaccion
    from SOCIODEMOGRAL
    where ClienteID = Par_ClienteID;
else
    insert into HISSOCIODEMOGRAL
    select  ProspectoID
            ,ClienteID
            ,FechaRegistro
            ,Var_FechaHistorico
            ,Var_Consecutivo
            ,GradoEscolarID
            ,NumDepenEconomi
			,AntiguedadLab
			,FechaIniTrabajo
            ,Aud_EmpresaID
            ,Aud_Usuario
            ,Aud_FechaActual
            ,Aud_DireccionIP
            ,Aud_ProgramaID
            ,Aud_Sucursal
            ,Aud_NumTransaccion
    from SOCIODEMOGRAL
    where ProspectoID = Par_ProspectoID;
end if;



CALL SOCIODEMOGRALBAJ(  Par_ProspectoID,    Par_ClienteID,  Tipo_BajaCliPro,        SalidaNO,           Par_NumErr,
                        Par_ErrMen,         Aud_EmpresaID,  Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                        Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);


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