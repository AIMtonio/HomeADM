-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSPAGOSPEIACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSPAGOSPEIACT`;DELIMITER $$

CREATE PROCEDURE `TIPOSPAGOSPEIACT`(



	Par_TipoPagoID			int(2),
	Par_Descripcion 		varchar(100),
	Par_Aceptacion          char(1),
	Par_Estatus             int,
    Par_NumAct       		int,

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


DECLARE Var_TipoPagoID   	int(2);
DECLARE Var_Control 	   char(15);
DECLARE Var_Estatus        char(1);


DECLARE  NumTipoPagoID   	int;
DECLARE	 Cadena_Vacia		char(1);
DECLARE	 Fecha_Vacia		date;
DECLARE	 Entero_Cero		int;
DECLARE	 Decimal_Cero		decimal(12,2);
DECLARE  SalidaNO        	char(1);
DECLARE  SalidaSI        	char(1);
DECLARE  ActRegistro   	    int;
DECLARE  ActEstatus         int;
DECLARE  Est_Act            char(1);
DECLARE  Est_Ina            char(1);
DECLARE  Activo             int;
DECLARE  Inactivo           int;


Set	NumTipoPagoID		    := 0;
Set	Cadena_Vacia		    := '';
Set	Fecha_Vacia			    := '1900-01-01';
Set	Entero_Cero			    := 0;
Set	Decimal_Cero		    := 0.0;
Set SalidaSI        	    := 'S';
Set SalidaNO        	    := 'N';
Set Par_NumErr  		    := 0;
Set Par_ErrMen  		    := '';
Set ActRegistro   	        := 1;
Set ActEstatus              := 2;
Set Est_Act                 := 'A';
Set Est_Ina                 := 'I';
Set Activo                  := 1;
Set Inactivo                := 0;

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
                                 'estamos trabajando para resolverla. Disculpe las molestias que ',
                                 'esto le ocasiona. Ref: SP-TIPOSPAGOSPEIACT');
                                  set Var_Control = 'sqlException' ;
    END;

if(Par_Estatus = Activo)then
	Set Var_Estatus := Est_Act;

else if(Par_Estatus = Inactivo)then
		Set Var_Estatus := Est_Ina;
	end if;
end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

if (Par_NumAct = ActRegistro)then

	if isnull(Par_TipoPagoID)then
			  set Par_NumErr := 001;
			  set Par_ErrMen := 'La clave del Tipo de pago esta Vacia.';
			  set Var_Control:='tipoPagoID';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia then
			  set Par_NumErr := 002;
			  set Par_ErrMen :='La Descripcion de tipo de pago esta Vacia.';
			  set Var_Control:='descripcion';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_Aceptacion,Cadena_Vacia)) = Cadena_Vacia then
			  set Par_NumErr :=003;
			  set Par_ErrMen :='La Aceptacion del tipo de pago esta Vacia.';
			  set Var_Control:='aceptacion';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_Estatus,Cadena_Vacia)) = Cadena_Vacia then
			  set Par_NumErr := 004;
			  set Par_ErrMen :='El estatus del tipo de pago esta Vacio.';
			  set Var_Control:='estatus';
		LEAVE ManejoErrores;
	end if;

	UPDATE TIPOSPAGOSPEI
		SET Descripcion    = Par_Descripcion,
			Aceptacion     = Par_Aceptacion,
			Estatus   	   = Var_Estatus,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion

	WHERE TipoPagoID    = Par_TipoPagoID;

	set Par_NumErr := 000;
	set Par_ErrMen := concat('Registro Actualizado exitosamente: ',convert(Par_TipoPagoID, char));



end if;

if (Par_NumAct = ActEstatus)then

	UPDATE TIPOSPAGOSPEI
		SET Estatus   	    = Est_Ina,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion;

	set Par_NumErr := 000;
	set Par_ErrMen := concat('Registro Actualizado exitosamente: ',convert(Par_TipoPagoID, char));

end if;


END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Par_TipoPagoID as consecutivo;
	end if;

END TerminaStore$$