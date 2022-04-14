-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPOSCON`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPOSCON`(
	Par_SolicCredID		int,
	Par_NumCon			tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE	Con_Foranea		int;
DECLARE	Con_TipoInteg	int;
DECLARE Con_CuentaPrin   int;
DECLARE Con_SolGrupal    int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;
Set	Con_TipoInteg	:= 3;
Set   Con_CuentaPrin  := 4;
Set   Con_SolGrupal   := 5;

if(Par_NumCon = Con_TipoInteg) then
select Cargo
	from INTEGRAGRUPOSCRE
		where SolicitudCreditoID=Par_SolicCredID;
end if;
if(Par_NumCon = Con_SolGrupal) then
    SELECT SolicitudCreditoID
        FROM INTEGRAGRUPOSCRE
        where GrupoID = Par_SolicCredID;
end if;

END TerminaStore$$