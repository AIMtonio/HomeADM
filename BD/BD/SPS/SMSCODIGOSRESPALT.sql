-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCODIGOSRESPALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCODIGOSRESPALT`;DELIMITER $$

CREATE PROCEDURE `SMSCODIGOSRESPALT`(
	Par_CodigoResID		varchar(10),
	Par_Descripcion		varchar(50),
	Par_Campania		int,

	Par_Salida			char(1),

	inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	var_Consecutivo		int;


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE  	SalidaSI			char(1);
DECLARE  	SalidaNO			char(1);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';



if(ifnull(Par_CodigoResID, Cadena_Vacia))= Cadena_Vacia then
	if(Par_Salida = SalidaSI)then
		select '001' as NumErr,
			'El Codigo de Respuesta esta Vacio.' as ErrMen,
			'codigoRespID' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 1;
		set  Par_ErrMen := 'El Codigo de Respuesta esta Vacio';
	end if;
end if;

if(ifnull(Par_Descripcion, Cadena_Vacia))= Cadena_Vacia then
	if(Par_Salida = SalidaSI)then
		select '002' as NumErr,
			'Respuesta Vacia.' as ErrMen,
			'descripcion' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 2;
		set  Par_ErrMen := 'Respuesta Vacia.';
	end if;
end if;

if exists(select CodigoRespID
				from SMSCODIGOSRESP
				where CodigoRespID= Par_CodigoResID)then
	if(Par_Salida = SalidaSI)then
		select '003' as NumErr,
			concat('El Codigo de Respuesta ya Existe.',Par_CodigoResID) as ErrMen,
			'codigoRespID' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 3;
		set  Par_ErrMen := 'El Codigo de Respuesta ya Existe';
	end if;
end if;


set Aud_FechaActual := CURRENT_TIMESTAMP();

Set var_Consecutivo := (select ifnull(Max(Consecutivo),Entero_Cero)
							 from SMSCODIGOSRESP where CampaniaID=Par_Campania);

   Set var_Consecutivo  := ifnull(var_Consecutivo, Entero_Cero) + 1;


	INSERT INTO SMSCODIGOSRESP (
								CodigoRespID,		Consecutivo,		Descripcion,		CampaniaID,		EmpresaID,		Usuario,
								FechaActual,		DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
						VALUES(
								Par_CodigoResID,	var_Consecutivo,	Par_Descripcion,	Par_Campania,	Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);


if(Par_Salida = SalidaSI)then
	select	'000' as NumErr ,
		  concat("Codigo de Respuesta Agregado para la Campaña: ", convert(Par_Campania, CHAR))  as ErrMen,
		'campaniaID' as control,
		 Par_Campania as consecutivo;
end if;

if(Par_Salida = SalidaNO)then
	set	 Par_NumErr := 0;
	set  Par_ErrMen :=  concat("Codigo de Respuesta Agregado para la Campaña: ", convert(Par_Campania, CHAR));
end if;

END TerminaStore$$