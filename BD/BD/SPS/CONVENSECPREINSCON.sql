-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONVENSECPREINSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONVENSECPREINSCON`;


	Par_SucursalID		int(11),
    Par_Fecha          	date,
    Par_NumCon          tinyint unsigned,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint

)



DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Con_Principal	bigint;
DECLARE		Con_Dos			bigint;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set Con_Dos			:= 2;


if(Par_NumCon = Con_Principal) then
	select count(ConvenPreID)as CantPreins
    from CONVENSECPREINS
	where FechaAsamblea = Par_Fecha and SucursalID=Par_SucursalID;
end if;


END TerminaStore$$