-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCOORPCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCOORPCON`;DELIMITER $$

CREATE PROCEDURE `CLIENTESCOORPCON`(
	Par_ClienteID   	int(11),
	Par_ClienteCorpID   int(11),
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
DECLARE ClasCorp		char(1);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
set ClasCorp		:='R';



if(Par_NumCon = Con_Principal) then
	Select ClienteID,NombreCompleto
		from CLIENTES
		where CorpRelacionado = Par_ClienteCorpID
		and ClienteID= Par_ClienteID limit 0,15;
end if;

END TerminaStore$$