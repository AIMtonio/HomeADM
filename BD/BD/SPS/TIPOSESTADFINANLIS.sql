-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSESTADFINANLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSESTADFINANLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSESTADFINANLIS`(

	Par_NombreEstFinan	varchar(50),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES


-- DECLARACION DE CONSTANTES
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal 	int;
DECLARE	Lis_Combo	 	int;

-- ASIGNACION DE CONSTANTES
Set	Cadena_Vacia	:= ''; 				-- Cadena Vacia
Set	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
Set	Entero_Cero		:= 0;				-- Entero Cero
Set	Lis_Principal	:= 1;				-- Lista principal
Set	Lis_Combo		:= 2;				-- Lista para el combo

-- Lista principal de los tipos de estados financieros
if(Par_NumLis = Lis_Principal) then
	select EstadoFinanID, Descripcion
		from TIPOSESTADOSFINAN
		where  Descripcion like concat("%", Par_NombreEstFinan, "%")
	limit 0, 15;
end if;

-- Combo de los estados financieros
if(Par_NumLis = Lis_Combo) then
	select EstadoFinanID, Descripcion
		from TIPOSESTADOSFINAN
		where MostrarPantalla = 'S';
end if;

END TerminaStore$$