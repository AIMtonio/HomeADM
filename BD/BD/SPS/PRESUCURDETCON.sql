-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUCURDETCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUCURDETCON`;DELIMITER $$

CREATE PROCEDURE `PRESUCURDETCON`(

	Par_EncabezadoID		int,
	Par_Concepto 			int,
	Par_SucursalID			int(11),
	Par_FechaRequisicion 	date,
	Par_NumCon				int,

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Con_Principal	int;
DECLARE		Con_Foranea		int;

DECLARE      	Var_Eliminado   char(1);
DECLARE		Var_FolioID		int(11);
DECLARE		Var_Aprobado  	char(1);

Set	 Cadena_Vacia	:= '';
Set  Fecha_Vacia	:= '1900-01-01';
Set  Entero_Cero 	:= 0;
Set	 Con_Principal	:= 1;
Set	 Con_Foranea	:= 2;
Set  Var_Eliminado	:= 'E';
Set  Var_Aprobado 	:= 'A';




if(ifnull(Par_NumCon, Entero_Cero) = Con_Principal) then
	select FolioID, Concepto, Descripcion, Estatus,
			Monto ,	 MontoDispon, Observaciones
	from   PRESUCURDET
    where EncabezadoID = Par_EncabezadoID and
           Estatus     <> Var_Eliminado;

end if;

if(Par_NumCon = Con_Foranea) then

Set Var_FolioID := (select FolioID from PRESUCURENC where MesPresupuesto=(month(Par_FechaRequisicion))
					and AnioPresupuesto=(year(Par_FechaRequisicion))
					and SucursalOrigen=Par_SucursalID);


	select FolioID, Descripcion, Monto ,MontoDispon
      from PRESUCURDET
    where  Estatus  = Var_Aprobado and
            Concepto = Par_Concepto and
            EncabezadoID = Var_FolioID ;


end if;



END TerminaStore$$