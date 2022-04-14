-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUPSUCURCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUPSUCURCON`;DELIMITER $$

CREATE PROCEDURE `PRESUPSUCURCON`(

	Par_FolioID			int(11),
	Par_MesPresupuesto	int(2),
	Par_AnioPresupuesto	int(4),
	Par_SucursalOrigen  int(11),
	Par_NumCon			int,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN
DECLARE		Var_Folio		int;
DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Con_Principal	int;
DECLARE		Con_Foranea		int;
DECLARE		Con_Folio		int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero 	:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;
Set	Con_Folio		:= 3;



if(Par_NumCon = Con_Principal) then

	select PRE.FolioID , 		PRE.MesPresupuesto ,	PRE.AnioPresupuesto,		PRE.UsuarioElaboro,
            PRE.SucursalOrigen, PRE.Fecha,  			PRE.Estatus, 				USU.Nombre
	from 	PRESUCURENC PRE, USUARIOS USU
    where  PRE.MesPresupuesto	=	Par_MesPresupuesto 	 and
		    PRE.AnioPresupuesto = 	Par_AnioPresupuesto  and
			PRE.SucursalOrigen=Par_SucursalOrigen 		 and
			PRE.UsuarioElaboro= USU.UsuarioID;
end if;

if(Par_NumCon = Con_Folio) then

	select	PRE.FolioID , 		PRE.MesPresupuesto ,	PRE.AnioPresupuesto,	PRE.UsuarioElaboro,
            PRE.SucursalOrigen, PRE.Fecha,  			PRE.Estatus, 			USU.Nombre
	from	PRESUCURENC PRE, USUARIOS USU
    where  PRE.FolioID		  =	Par_FolioID
    and		PRE.UsuarioElaboro= USU.UsuarioID;


end if;


END TerminaStore$$