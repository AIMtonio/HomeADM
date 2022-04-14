-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOVIVIENCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMOVIVIENCON`;DELIMITER $$

CREATE PROCEDURE `SOCIODEMOVIVIENCON`(
	Par_ProspectoID			    int(11),
	Par_ClienteID			    int(11),
	Par_TipoCon				    tinyint unsigned,

    Aud_Empresa             int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN





DECLARE Cadena_Vacia            char(1);
DECLARE Fecha_Vacia             datetime;
DECLARE Entero_Cero             int(11);
DECLARE Str_SI                  char(1);
DECLARE Str_NO                  char(1);

DECLARE Con_Principal           int(11);


Set Cadena_Vacia            := '';
Set Fecha_Vacia             := '1900-01-01';
Set Entero_Cero             := 0;
Set Str_SI                  := 'S';
Set Str_NO                  := 'N';




Set Con_Principal           := 1;


if(Par_TipoCon = Con_Principal) then
     if Par_ClienteID > Entero_Cero then
        select   Soc.ProspectoID        ,Soc.ClienteID          ,Soc.FechaRegistro          ,Soc.TipoViviendaID         ,Viv.Descripcion as TipoViviendaDesc
                ,Soc.ConDrenaje         ,Soc.ConElectricidad    ,Soc.ConAgua                ,Soc.ConGas                 ,Soc.ConPavimento
                ,Soc.TipoMaterialID
                ,Mat.Descripcion as TipoMaterialDesc
                ,Soc.ValorVivienda
                ,Soc.Descripcion as ViviendaDesc
                ,Soc.TiempoHabitarDom
        from 	 SOCIODEMOVIVIEN Soc
        left join TIPOVIVIENDA Viv on Viv.TipoViviendaID = Soc.TipoViviendaID
        left join TIPOMATERIALVIV Mat on Mat.TipoMaterialID = Soc.TipoMaterialID
        where	 ClienteID = Par_ClienteID;

    else
        select   Soc.ProspectoID        ,Soc.ClienteID          ,Soc.FechaRegistro          ,Soc.TipoViviendaID         ,Viv.Descripcion as TipoViviendaDesc
                ,Soc.ConDrenaje         ,Soc.ConElectricidad    ,Soc.ConAgua                ,Soc.ConGas                 ,Soc.ConPavimento
                ,Soc.TipoMaterialID
                ,Mat.Descripcion as TipoMaterialDesc
                ,Soc.ValorVivienda
                ,Soc.Descripcion as ViviendaDesc
                 ,Soc.TiempoHabitarDom
        from 	 SOCIODEMOVIVIEN Soc
        left join TIPOVIVIENDA Viv on Viv.TipoViviendaID = Soc.TipoViviendaID
        left join TIPOMATERIALVIV Mat on Mat.TipoMaterialID = Soc.TipoMaterialID
        where	 ProspectoID	= 	Par_ProspectoID;
    end if;

 end if;

END TerminaStore$$