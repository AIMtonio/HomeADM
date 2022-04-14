-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACLIEMPLEADOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACLIEMPLEADOALT`;DELIMITER $$

CREATE PROCEDURE `RELACLIEMPLEADOALT`(
	Par_ClienteID         int,
	Par_RelacionadoID     int,
	Par_TipoRelacion      int,
	Par_Parentesco        int,

	Par_Salida		char(1),
	inout Par_NumErr    	int,
	inout Par_ErrMen    	varchar(400),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

	)
TerminaStore: BEGIN


DECLARE  Entero_Cero		int;
DECLARE  SalidaSI		char(1);
DECLARE  SalidaNO		char(1);
DECLARE  Cadena_Vacia		char(1);
DECLARE  Var_Relacion		int;


Set Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';
Set Cadena_Vacia	:= '';

if(ifnull(Par_ClienteID, Cadena_Vacia))= Cadena_Vacia then
	if(Par_Salida = SalidaSI)then
		select '003' as NumErr,
			'El Cliente esta Vacio.' as ErrMen,
			'clienteID' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 1;
		set  Par_ErrMen := 'El Cliente esta Vacio.';
	end if;
end if;


if(ifnull(Par_RelacionadoID, Cadena_Vacia))= Cadena_Vacia then
	if(Par_Salida = SalidaSI)then
		select '003' as NumErr,
			'El Empleado esta Vacio.' as ErrMen,
			'empleadoID' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 2;
		set  Par_ErrMen := 'El Empleado esta Vacio.';
	end if;
end if;

if(ifnull(Par_Parentesco, Cadena_Vacia))= Cadena_Vacia then
	if(Par_Salida = SalidaSI)then
		select '004' as NumErr,
			'El Parentesco esta Vacio.' as ErrMen,
			'parentescoID' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 3;
		set  Par_ErrMen := 'El Parentesco esta Vacio.';
	end if;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();
call FOLIOSAPLICAACT('RELACIONCLIEMPLEADO', Var_Relacion);

	INSERT INTO `RELACIONCLIEMPLEADO`
        (`RelacionID`,  `ClienteID`,    `RelacionadoID`,   `ParentescoID`,  `TipoRelacion`,
        `EmpresaID`,    `Usuario`,      `FechaActual`,      `DireccionIP`,  `ProgramaID`,
        `Sucursal`,     `NumTransaccion`)
    VALUES(
         Var_Relacion, 	Par_ClienteID, 	Par_RelacionadoID,     Par_Parentesco, Par_TipoRelacion,
         Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	    Aud_DireccionIP, Aud_ProgramaID,
         Aud_Sucursal,	Aud_NumTransaccion);

	if(Par_Salida = SalidaSI)then
		select	'000' as NumErr ,
			concat("Informacion Actualizada")  as ErrMen,
			'clienteID' as control,
			Par_ClienteID as consecutivo;
	end if;

	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 0;
		set  Par_ErrMen :=  concat("Informacion Actualizada");
	end if;

END TerminaStore$$