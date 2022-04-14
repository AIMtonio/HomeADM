-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSEMPALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSEMPALT`;DELIMITER $$

CREATE PROCEDURE `GRUPOSEMPALT`(

	Par_NombreGrupo varchar(100),
	Par_Observacion varchar(100)	,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

DECLARE	GrupoEmpresaID		int;
DECLARE	NombreGrupo		char(100);
DECLARE	Observacion		char(100);
DECLARE	Entero_Cero		int;
DECLARE	Cadena_Vacia char(100);

Set	Cadena_Vacia	:= '';
Set	Entero_Cero		:= 0;
set 	Observacion		:='';


if(ifnull(Par_NombreGrupo, Cadena_Vacia)) = Cadena_Vacia then
	select '001' as NumErr,
		 'El nombre del grupo empresarial esta Vacio.' as ErrMen,
		 'NombreGrupo' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Observacion, Cadena_Vacia)) = Cadena_Vacia then
	select '002' as NumErr,
		 'La observacion no puede ir Vacia.' as ErrMen,
		 'Observacion' as control;
	LEAVE TerminaStore;
end if;

set GrupoEmpresaID := (select ifnull(Max(GrupoEmpID), Entero_Cero) + 1 from GRUPOSEMP);
Set Aud_FechaActual := CURRENT_TIMESTAMP();

insert into GRUPOSEMP values (GrupoEmpresaID,		EmpresaID,		Par_NombreGrupo,
					 Par_Observacion,	Aud_Usuario,	Aud_FechaActual,
					 Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
					Aud_NumTransaccion);


select '000' as NumErr,
	  concat("Grupo de Empresa Agregado: ", convert(GrupoEmpresaID, CHAR))  as ErrMen,
	  'GrupoEmpID' as control;

END TerminaStore$$