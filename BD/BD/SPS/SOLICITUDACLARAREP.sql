-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDACLARAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDACLARAREP`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDACLARAREP`(
	Par_ReporteID       varchar(22),
	Par_TarjetaDebID    char(16),
    Par_NumRep          tinyint unsigned,

    Par_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Rep_SoliAclara   int(11);
DECLARE Var_Comercio 	 int(11);
DECLARE Var_Cajero 	     int(11);


Set Rep_SoliAclara   := 1;
Set Var_Comercio     := 1;
Set Var_Cajero       := 2;

if(Par_NumRep = Rep_SoliAclara) then
select Tar.ReporteID, Tar.TarjetaDebID, Tar.FechaAclaracion,
		Tar.MontoOperacion, Tarj.NombreTarjeta,
		case when Tar.TipoAclaraID = Var_Comercio then
			Tar.Comercio
		else case when Tar.TipoAclaraID = Var_Cajero then
			concat(Tar.NoCajero,'-',Ins.Nombre)
end end as Comercio
    from TARDEBACLARACION as Tar
		inner join TARJETADEBITO as Tarj on Tar.TarjetaDebID=Tarj.TarjetaDebID
		inner join INSTITUCIONES Ins on Ins.InstitucionID=Tar.InstitucionID
		where Tar.TarjetaDebID = Par_TarjetaDebID
		and Tar.ReporteID = Par_ReporteID;
end if;

END TerminaStore$$