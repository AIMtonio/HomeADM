-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSEMPSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSEMPSMOD`;DELIMITER $$

CREATE PROCEDURE `GRUPOSEMPSMOD`(
	Par_GrupoEmpID int,
	Par_NombreGrupo varchar(200),
	Par_Observacion varchar(200),
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	v_Cadena_Vacia	char(1);
DECLARE	v_Fecha_Vacia	date;
DECLARE	v_Entero_Cero	int;
DECLARE	v_Observacion	varchar(200);


Set	v_Cadena_Vacia	:= '';
Set	v_Fecha_Vacia	:= '1900-01-01';
Set	v_Entero_Cero	:= 0;
Set	v_Observacion 	:= 'Sin Observacion';


if(not exists(select GrupoEmpID from GRUPOSEMP where GrupoEmpID = Par_GrupoEmpID)) then
	select '001' as NumErr,
		 'El Grupo de Empresa no existe.' as ErrMen,
		 'numero' as control;
	LEAVE TerminaStore;
end if;
Set Aud_FechaActual := CURRENT_TIMESTAMP();
update GRUPOSEMP set
		NombreGrupo = Par_NombreGrupo,
		Observacion = Par_Observacion,
		EmpresaID		= Par_EmpresaID,

		Usuario		= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
where GrupoEmpID = Par_GrupoEmpID;

select '000' as NumErr ,
	  'El Grupo de Empresa  Modificado' as ErrMen,
	  'numero' as control;

END TerminaStore$$