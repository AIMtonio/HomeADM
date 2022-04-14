-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINTERPREOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINTERPREOACT`;DELIMITER $$

CREATE PROCEDURE `PLDOPEINTERPREOACT`(
	Par_OpeInterPreoID	int,
	Par_Estatus			char(1),
	Par_ComentarioOC		varchar(1500)
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
Declare	Estatus_C		int;
Declare	Estatus_R		int;
Declare	Estatus_S		int;
Declare	Estatus_N		int;
Declare	Fecha_cierre		Date;


Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set Estatus_C				:= 1;
Set Estatus_R				:= 3;
Set Estatus_S				:= 2;
Set Estatus_N				:= 4;



if(not exists(select OpeInterPreoID
			from PLDOPEINTERPREO
			where OpeInterPreoID = Par_OpeInterPreoID)) then
	select '001' as NumErr,
		 'El Numero Operacion no existe.' as ErrMen,
		 'opeInterPreoID' as control;
	LEAVE TerminaStore;
end if;




update PLDOPEINTERPREO set

	Estatus 			= Par_Estatus,
	ComentarioOC 		= Par_ComentarioOC

where OpeInterPreoID= Par_OpeInterPreoID;

Set Fecha_Cierre := (Select FechaSistema from PARAMETROSSIS);
if (Par_Estatus= Estatus_R or Par_Estatus=Estatus_N	)then
	update PLDOPEINTERPREO set FechaCierre= Fecha_Cierre
	WHERE OpeInterPreoID=Par_OpeInterPreoID;
end if;

if (Par_Estatus=Estatus_C or Par_Estatus=Estatus_S) then
	update PLDOPEINTERPREO set FechaCierre= Fecha_Vacia
	WHERE OpeInterPreoID=Par_OpeInterPreoID;
end if;
	select '0' as NumErr,
		  concat('Operacion Interna Preocupante ',Par_OpeInterPreoID, ', Actualizada Exitosamente' ) as ErrMen,
		   'opeInterPreoID' as control;

END TerminaStore$$