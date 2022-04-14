-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESPORCAJAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESPORCAJAALT`;DELIMITER $$

CREATE PROCEDURE `OPCIONESPORCAJAALT`(
	Par_OpcionCajaID		int(11),
	Par_TipoCaja			char(2),

	Par_Salida				char(1),
    inout	Par_NumErr		int,
    inout	Par_ErrMen		varchar(350),

    Par_EmpresaID			int,
    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),

    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
	)
TerminaStore: BEGIN


declare VarControl	varchar(45);


declare	Cadena_Vacia	char(1);
declare	Fecha_Vacia		date;
declare	Entero_Cero		int;
declare Salida_SI		char(1);


set Cadena_Vacia		:= '';
set Fecha_Vacia			:= '1900-01-01';
set Entero_Cero			:= 0;
set Salida_SI			:='S';


set Aud_FechaActual 	:= now();

ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-OPCIONESPORCAJAALT');
				SET VarControl = 'sqlException' ;
			END;


	if(ifnull(Par_OpcionCajaID, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := 'La Opcion por Caja esta Vacia';
		set VarControl   := 'tipoCaja';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_TipoCaja, Cadena_Vacia) = Cadena_Vacia) then
		set Par_NumErr   := 02;
		set Par_ErrMen   := 'La Tipo de Caja esta Vacia';
		set VarControl   := 'tipoCaja';
		LEAVE ManejoErrores;
	end if;

set Aud_FechaActual := now();

	insert into OPCIONESPORCAJA(
		OpcionCajaID,		TipoCaja,			EmpresaID,		Usuario,		FechaActual,
		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion)
	values (
		Par_OpcionCajaID,	Par_TipoCaja,		Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	set Par_NumErr  := 000;
	set Par_ErrMen  := concat('Opciones Agregadas Exitosamente.');
	set varControl	:= 'tipoCaja';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
end IF;

END TerminaStore$$