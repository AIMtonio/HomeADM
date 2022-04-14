-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PORCRESPERIODOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PORCRESPERIODOALT`;DELIMITER $$

CREATE PROCEDURE `PORCRESPERIODOALT`(
	Par_LimInferior			int,
	Par_LimSuperior			int,
	Par_TipoInstit 			char(2),
	Par_PorResCarSReest		decimal(10,2),
	Par_PorResCarReest		decimal(10,2),
	Par_TipoRango			char(1),
	Par_Estatus				char(1),
	Par_Clasificacion     char(1),

	Par_Salida				char(1),
	inout Par_NumErr    	int,
    inout Par_ErrMen    	varchar(400),

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

)
TerminaStore: BEGIN


DECLARE  Entero_Cero		int;
DECLARE  SalidaSI			char(1);
DECLARE  SalidaNO			char(1);
DECLARE  Cadena_Vacia		char(1);
DECLARE  VarPlantillaID		int;
DECLARE  VarEstatusE		char(1);


Set	Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';
Set	Cadena_Vacia	:= '';
Set VarEstatusE		:= 'A';

if(ifnull(Par_TipoInstit, Cadena_Vacia))= Cadena_Vacia then
	if(Par_Salida = SalidaSI)then
		select '003' as NumErr,
			'El Tipo Institucion esta Vacio.' as ErrMen,
			'tipoInstitucion' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 3;
		set  Par_ErrMen := 'El Nombre esta Vacio.';
	end if;
end if;

if(ifnull(Par_PorResCarSReest, Cadena_Vacia))= Cadena_Vacia then
	if(Par_Salida = SalidaSI)then
		select '004' as NumErr,
			'El Porcentaje Sin Reestructurar esta Vacio.' as ErrMen,
			'porResCarSReest' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 4;
		set  Par_ErrMen := 'El Porcentaje Sin Reestructurar esta Vacio.';
	end if;
end if;

if(ifnull(Par_PorResCarReest, Cadena_Vacia))= Cadena_Vacia then
	if(Par_Salida = SalidaSI)then
		select '005' as NumErr,
			'El Porcentaje Reestructurado esta Vacio.' as ErrMen,
			'porResCarReest' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 5;
		set  Par_ErrMen := 'El Porcentaje Reestructurado esta Vacio.';
	end if;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();
Set Par_Estatus := ifnull(Par_Estatus, VarEstatusE);

	INSERT INTO PORCRESPERIODO	(
				`LimInferior`,	`LimSuperior`,	`TipoInstitucion`,	`PorResCarSReest`,	`PorResCarReest`,
				`TipoRango`,	`Estatus`,`Clasificacion`,	`EmpresaID`,		`Usuario`,			`FechaActual`,
				`DireccionIP`,	`ProgramaID`,	`Sucursal`,			`NumTransaccion`)
			VALUES(
				Par_LimInferior,	Par_LimSuperior,	Par_TipoInstit,	Par_PorResCarSReest,	Par_PorResCarReest,
				Par_TipoRango,		Par_Estatus,      Par_Clasificacion,		Aud_EmpresaID,	Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

if(Par_Salida = SalidaSI)then
	select	'000' as NumErr ,
		concat("Rangos Registrados")  as ErrMen,
		'plantillaID' as control,
		 VarPlantillaID as consecutivo;
end if;

if(Par_Salida = SalidaNO)then
	set	 Par_NumErr := 0;
	set  Par_ErrMen :=  concat("Rangos Registrados");
end if;

END TerminaStore$$