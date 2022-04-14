-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXCEPCIONESINVERREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EXCEPCIONESINVERREP`;DELIMITER $$

CREATE PROCEDURE `EXCEPCIONESINVERREP`(

	Par_FechaInicial		date,
	Par_FechaFinal			date,
	Par_TipoReporte         tinyint unsigned,

    Par_EmpresaID       	int,
    Aud_Usuario         	int,
    Aud_FechaActual     	date,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint

)
TerminaStore: BEGIN



DECLARE Rep_Principal       int(11);


Set Rep_Principal       := 1;






if(Par_TipoReporte = Rep_Principal) then

SELECT	Exc.ProcesoBatchID as ProcesoID,
		Exc.Fecha,
		Exc.Descripcion,
		Exc.Instrumento as InversionID,
		Inv.ClienteID as ClienteID,
		Inv.FechaInicio as FechaInicioInver,
		Inv.FechaVencimiento as FechaVencimientoInver,
		case Inv.Reinvertir when "C"	THEN "CAPITAL"
							when "CI"	THEN "CAPITAL MAS INTERESES"
							when "N"	THEN "NINGUNA"
							else	"SIN TIPO DE REINVERSION ESPECIFICADA" end as TipoReinversion,
		concat(Cli.SucursalOrigen, " - ", Suc.NombreSucurs) as SucursalCliente,
		concat(Inv.TipoInversionID, " - ", Tip.Descripcion)   as TipoInversion
FROM 	EXCEPCIONBATCH	Exc,
		INVERSIONES		Inv,
		CLIENTES		Cli,
		SUCURSALES		Suc,
		CATINVERSION    Tip
where	Exc.Instrumento		= Inv.InversionID
 AND	Inv.ClienteID		= Cli.ClienteID
 and	Cli.SucursalOrigen	= Suc.SucursalID
  and	Inv.TipoInversionID	= Tip.TipoInversionID

and date(Exc.Fecha) >= DATE(Par_FechaInicial) and DATE(Exc.Fecha) <= DATE(Par_FechaFinal)
order by Exc.Fecha, Cli.SucursalOrigen,Inv.InversionID;

end if;

END TerminaStore$$