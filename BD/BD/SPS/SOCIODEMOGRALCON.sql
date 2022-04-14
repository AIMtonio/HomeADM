-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOGRALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMOGRALCON`;DELIMITER $$

CREATE PROCEDURE `SOCIODEMOGRALCON`(
	Par_ProspectoID			int(11),
	Par_ClienteID			int(11),
	Par_TipoCon				tinyint unsigned,


    Aud_Empresa             int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN


 DECLARE Con_Principal int(11);


DECLARE Entero_Cero         int(11);


Set Entero_Cero             := 0;




Set Con_Principal    := 1;

if(Par_TipoCon = Con_Principal) then
     if Par_ClienteID > Entero_Cero then
        select   Soc.ProspectoID, Soc.ClienteID,    Soc.FechaRegistro,
					Soc.GradoEscolarID, Esc.Descripcion,
					ifnull(Soc.NumDepenEconomi, Entero_Cero)
as NumDepenEconomi,
					ifnull(Soc.AntiguedadLab,Entero_cero) as
AntiguedadLab,
					Soc.FechaIniTrabajo
        from 	 SOCIODEMOGRAL Soc,
                 CATGRADOESCOLAR Esc
        where	 ClienteID= Par_ClienteID
          and   Soc.GradoEscolarID = Esc.GradoEscolarID;
    else
        select   Soc.ProspectoID, Soc.ClienteID,    Soc.FechaRegistro,
Soc.GradoEscolarID, Esc.Descripcion,
                 ifnull(Soc.NumDepenEconomi, Entero_Cero) as NumDepenEconomi,
					Soc.AntiguedadLab,
Soc.FechaIniTrabajo

        from 	 SOCIODEMOGRAL Soc,
                 CATGRADOESCOLAR Esc
        where	 ProspectoID	= 	Par_ProspectoID
          and   Soc.GradoEscolarID = Esc.GradoEscolarID;
    end if;

 end if;

END TerminaStore$$