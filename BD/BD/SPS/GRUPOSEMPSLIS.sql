-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSEMPSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSEMPSLIS`;
DELIMITER $$


CREATE PROCEDURE `GRUPOSEMPSLIS`(
	Par_NombreCompl	varchar(100),
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

DECLARE Cadena_Vacia	char(1);
DECLARE Fecha_Vacia	date;
DECLARE Entero_Cero	int;
DECLARE Lis_Principal	int;
DECLARE Lis_Todos		INT;			-- Consulta devuelve todos los grupos empresariales


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
SET Lis_Todos		:= 2; 				-- Asignacion Lis_Todos

if(Par_NumLis = Lis_Principal) then
	select GrupoEmpID, NombreGrupo, Observacion
	from GRUPOSEMP
	where  NombreGrupo like concat("%", Par_NombreCompl, "%")
	limit 0, 15;
end if;

IF(Par_NumLis = Lis_Todos) THEN
	SELECT GrupoEmpID, NombreGrupo, Observacion
	FROM GRUPOSEMP;
END IF;

END TerminaStore$$
