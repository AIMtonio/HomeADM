-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRORRATEOCONTABLEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRORRATEOCONTABLEMOD`;DELIMITER $$

CREATE PROCEDURE `PRORRATEOCONTABLEMOD`(
	Par_ProrrateoID		int(11),
	Par_NombreProrrateo	char(50),
	Par_Estatus			char(1),
	Par_Descripcion		char(100),
	Par_CentroCostoID	int(11),
	Par_Porcentaje		float,

	Par_Encabezado		char(1),
	Par_Salida		char(1),

	inout	Par_NumErr 	int,
	inout	Par_ErrMen  	varchar(350),

	Par_EmpresaID		int,
	Aud_Usuario		int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE 	FechaVacia	    datetime;
DECLARE		Cadena_Vacia	char(1);
DECLARE 	Entero_Cero		int(1);
DECLARE 	Salida_Si		char(1);
DECLARE 	Var_Encabezado	char(1);
DECLARE 	Var_NoEncabezado	char(1);


DECLARE 	Var_FechaActualiz	datetime;
DECLARE 	Var_Consecutivo		int(11);


Set 		FechaVacia		:= '1900-01-01';
Set 		Cadena_Vacia	:= '';
Set 		Entero_Cero		:= 0;
Set 		Salida_Si		:= 'S';
Set 		Var_Encabezado	:= 'S';
Set 		Var_NoEncabezado:= 'N';


Set 		Var_FechaActualiz	:= '1900-01-01';
Set			Var_Consecutivo		:= 0;

ManejoErrores:BEGIN
	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			set Par_NumErr = 999;
			set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
									 "estamos trabajando para resolverla. Disculpe las molestias que ",
									 "esto le ocasiona. Ref: SP-PRORRATEOCONTABLEALT");
		END;
	Set Par_NombreProrrateo := ifnull(Par_NombreProrrateo,'');
	if(Par_NombreProrrateo=Cadena_Vacia) then
			select '001' as NumErr,
			 'El Nombre del Metodo de Prorrateo esta Vacío.' as ErrMen,
			 'nombreProrrateo' as control,
			0 as consecutivo;
		LEAVE TerminaStore;
	end if;

	if(Par_Estatus=Cadena_Vacia) then
		select '002' as NumErr,
			 'El Estatus Viene Vacio.' as ErrMen,
			 'nombreProrrateo' as control,
			0 as consecutivo;
		LEAVE TerminaStore;
	end if;

	Set Par_CentroCostoID := ifnull(Par_CentroCostoID,Entero_Cero);
	if(Par_CentroCostoID=Entero_Cero)then
		select '003' as NumErr,
			 'El Centro de Costo Viene Vacio.' as ErrMen,
			 'nombreProrrateo' as control,
			0 as consecutivo;
		LEAVE TerminaStore;
	end if;

	Set	Par_Porcentaje 	:= ifnull(Par_Porcentaje,Entero_Cero);
	if(Par_Porcentaje = Entero_Cero) then
			select '003' as NumErr,
			 'El Porcentaje del Centro de Costo Viene Vacio.' as ErrMen,
			 'nombreProrrateo' as control,
			0 as consecutivo;
		LEAVE TerminaStore;
	end if;
	Set Aud_FechaActual := CURRENT_TIMESTAMP();
	Set Var_FechaActualiz := (SELECT convert(concat(FechaSistema,' ',CURTIME()), datetime) FROM PARAMETROSSIS);

if(Par_Encabezado=Var_Encabezado) then
	delete from CENTROSPRORRATEO where ProrrateoID	=	Par_ProrrateoID;
	update PRORRATEOCONTABLE set
		NombreProrrateo	= Par_NombreProrrateo,
		Descripcion		= Par_Descripcion,
		Estatus			= Par_Estatus,
		FechaAct		= Var_FechaActualiz,
		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
				where ProrrateoID = Par_ProrrateoID;

end if;
	insert into CENTROSPRORRATEO(
		ProrrateoID,	CentroCostoID,	Descripcion,	Porcentaje,		EmpresaID,
		Usuario,		FechaActual,	DireccionIP,	ProgramaID,		Sucursal,
		NumTransaccion
	)values(
		Par_ProrrateoID,	Par_CentroCostoID,		Par_Descripcion,		Par_Porcentaje,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion
	);

end ManejoErrores;

if (Par_Salida = Salida_SI) then
	select '000' as NumErr,
				 'Metodo Prorrateo Modificado Exitosamente.' as ErrMen,
				 'ProrrateoID' as control,
				  Par_ProrrateoID as consecutivo;
		LEAVE TerminaStore;
end if;
END TerminaStore$$