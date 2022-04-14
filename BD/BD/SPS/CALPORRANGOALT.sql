-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALPORRANGOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALPORRANGOALT`;DELIMITER $$

CREATE PROCEDURE `CALPORRANGOALT`(
	Par_LimInferior			decimal(10,4),
	Par_LimSuperior			decimal(10,4),
	Par_TipoInstit 			char(2),
	Par_Calificacion		char(2),
	Par_Tipo				   char(2),
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
DECLARE  VarPlantillaID	int;
DECLARE  VarEstatusA		char(1);

Set	Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';
Set	Cadena_Vacia	:= '';
Set VarEstatusA		:= 'A';

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
		set  Par_ErrMen := 'El Tipo Institucion esta Vacio.';
	end if;
end if;

if(ifnull(Par_Calificacion, Cadena_Vacia))= Cadena_Vacia then
	if(Par_Salida = SalidaSI)then
		select '004' as NumErr,
			'La Calificacion esta Vacio.' as ErrMen,
			'calificacion' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 4;
		set  Par_ErrMen := 'La Calificacion esta Vacio.';
	end if;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();
Set Par_Estatus := ifnull(Par_Estatus, VarEstatusA);

	INSERT INTO `CALPORRANGO`(
			`LimInferior`,	`LimSuperior`,	`TipoInstitucion`,	`Calificacion`,	`Tipo`,
			`Estatus`,`Clasificacion`,		`EmpresaID`,	`Usuario`,			`FechaActual`,	`DireccionIP`,
			`ProgramaID`,	`Sucursal`,		`NumTransaccion`)
	VALUES(
			Par_LimInferior, 	Par_LimSuperior, 	Par_TipoInstit, 	Par_Calificacion, 	Par_Tipo,
			Par_Estatus,		Par_Clasificacion, Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	if(Par_Salida = SalidaSI)then
		select	'000' as NumErr ,
			concat("Rangos Registrados")  as ErrMen,
			'tipoInstitucion' as control,
			Entero_Cero as consecutivo;
	end if;

	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 0;
		set  Par_ErrMen :=  concat("Rangos Registrados");
	end if;

END TerminaStore$$