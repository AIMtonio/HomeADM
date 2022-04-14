-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGINEGISOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGINEGISOCON`;DELIMITER $$

CREATE PROCEDURE `TARDEBGINEGISOCON`(
	Par_GiroID          varchar(150),

	Par_NumCon			 tinyint unsigned,

	Aud_EmpresaID		 int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE Var_TipoCuenta  int;

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE Con_Giros		int;
DECLARE Estatus_Activo	char(1);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set Con_Giros		:= 2;
Set Estatus_Activo	:= 'A';

if(Par_NumCon = Con_Principal) then
    SELECT GiroID,Descripcion,NombreCorto,Estatus
        FROM TARDEBGIROSNEGISO
            WHERE GiroID= Par_GiroID AND Estatus = Estatus_Activo;
end if;

if(Par_NumCon = Con_Giros) then
    SELECT GiroID,Descripcion,NombreCorto,Estatus
        FROM TARDEBGIROSNEGISO
            WHERE GiroID= Par_GiroID;
end if;


END TerminaStore$$