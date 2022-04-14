-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADOSENVIOSPEIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTADOSENVIOSPEIALT`;DELIMITER $$

CREATE PROCEDURE `ESTADOSENVIOSPEIALT`(



	Par_EstadoEnvioID		int(3),
	Par_Descripcion 		varchar(40),

    Par_Salida          	char(1),
	inout Par_NumErr    	int,
	inout Par_ErrMen    	varchar(400),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(20),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
		)
TerminaStore: BEGIN


DECLARE Var_Control 	   char(15);


DECLARE  NumEstadoEnvioID  	int;
DECLARE	 Cadena_Vacia		char(1);
DECLARE	 Fecha_Vacia		date;
DECLARE	 Entero_Cero		int;
DECLARE	 Decimal_Cero		decimal(12,2);
DECLARE  SalidaNO        	char(1);
DECLARE  SalidaSI        	char(1);
DECLARE	 ActRegistro		int;


Set	NumEstadoEnvioID	    := 0;
Set	Cadena_Vacia		    := '';
Set	Fecha_Vacia			    := '1900-01-01';
Set	Entero_Cero			    := 0;
Set	Decimal_Cero		    := 0.0;
Set SalidaSI        	    := 'S';
Set SalidaNO        	    := 'N';
Set Par_NumErr  		    := 0;
Set Par_ErrMen  		    := '';
Set ActRegistro   	        := 1;

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
                                 'estamos trabajando para resolverla. Disculpe las molestias que ',
                                 'esto le ocasiona. Ref: SP-ESTADOSENVIOSPEIALT');
                                  set Var_Control = 'sqlException' ;
    END;

if isnull(Par_EstadoEnvioID)then
	set Par_NumErr := 001;
	set Par_ErrMen := 'La clave del estado de envio esta Vacia.';
	set Var_Control:= 'estadoEnvioID';
	LEAVE ManejoErrores;
end if;


if(ifnull(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia then
	set Par_NumErr := 002;
	set Par_ErrMen := 'La Descripcion del estado de envio esta Vacia.';
	set Var_Control:= 'descripcion';
	LEAVE ManejoErrores;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();



 if exists (select EstadoEnvioID
			from ESTADOSENVIOSPEI
            where EstadoEnvioID = Par_EstadoEnvioID)then

   call ESTADOSENVIOSPEIACT(
		Par_EstadoEnvioID,  Par_Descripcion,   ActRegistro,    SalidaNO,        Par_NumErr,
		Par_ErrMen,         Par_EmpresaID,     Aud_Usuario,    Aud_FechaActual, Aud_DireccionIP,
		Aud_ProgramaID,     Aud_Sucursal,      Aud_NumTransaccion
		);

	if(Par_NumErr != Entero_Cero)then
	set Par_ErrMen := 'Error en la actualizacion';
	set Var_Control:= 'estadoEnvioID';
	LEAVE ManejoErrores;
   end if;
else

	insert into ESTADOSENVIOSPEI(
		EstadoEnvioID,		Descripcion,	 EmpresaID,		Usuario,		FechaActual,
		DireccionIP,		ProgramaID,	     Sucursal,	    NumTransaccion)

	values (
		Par_EstadoEnvioID,  Par_Descripcion,  Par_EmpresaID, Aud_Usuario,	Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,	  Aud_Sucursal,  Aud_NumTransaccion);


        set Par_NumErr := 000;
		set Par_ErrMen := concat('Registro agregado exitosamente: ', convert(Par_EstadoEnvioID, char));
		set Var_Control:= 'estadoEnvioID';

end if;

END ManejoErrores;

   IF (Par_Salida = SalidaSI) THEN
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Par_EstadoEnvioID as consecutivo;
	end if;

END TerminaStore$$