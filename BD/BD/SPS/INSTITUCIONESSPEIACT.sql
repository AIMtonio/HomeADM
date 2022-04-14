-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONESSPEIACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUCIONESSPEIACT`;DELIMITER $$

CREATE PROCEDURE `INSTITUCIONESSPEIACT`(



	Par_InstitucionID	    int(5),
	Par_Descripcion 		varchar(100),
	Par_NumCertificado      int(11),
    Par_Estatus             char(1),
	Par_EstatusRecep        char(1),
	Par_FechaUltAct         datetime,

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


DECLARE Var_InstitucionID  	int(5);
DECLARE Var_Control 	   char(15);
DECLARE	Var_EstatusBloque  char(1);


DECLARE  NumInstitucionID  	int;
DECLARE	 Cadena_Vacia		char(1);
DECLARE	 Fecha_Vacia		date;
DECLARE	 Entero_Cero		int;
DECLARE	 Decimal_Cero		decimal(12,2);
DECLARE  SalidaNO        	char(1);
DECLARE  SalidaSI        	char(1);
DECLARE  ActRegistro   	    int;
DECLARE  ActEstatus         int;
DECLARE  Est_Act            char(1);
DECLARE  Est_Inac           char(1);



Set	NumInstitucionID	    := 0;
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
Set Est_Inac                := 'I';

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
                                 'estamos trabajando para resolverla. Disculpe las molestias que ',
                                 'esto le ocasiona. Ref: SP-INSTITUCIONESSPEIACT');
                                  set Var_Control = 'sqlException' ;
    END;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

if (Par_NumAct = ActRegistro)then

	if(ifnull(Par_InstitucionID,Entero_Cero)) = Entero_Cero then
		set Par_NumErr := 001;
		set Par_ErrMen := 'La clave de la institucion esta Vacia.';
		set Var_Control:= 'institucionID';
		LEAVE ManejoErrores;
	end if;


	if(ifnull(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr := 002;
		set Par_ErrMen := 'La Descripcion de la institucion esta Vacia.';
		set Var_Control:= 'descripcion';
		LEAVE ManejoErrores;
	end if;


	if(ifnull(Par_Estatus,Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr := 003;
		set Par_ErrMen := 'El estatus de la institucion esta Vacio.';
		set Var_Control:= 'estatus';
		LEAVE ManejoErrores;
	end if;

	UPDATE INSTITUCIONESSPEI
		SET Descripcion      = Par_Descripcion,
			NumCertificado   = Par_NumCertificado,
			Estatus          = Par_Estatus,
			EstatusRecep     = Par_EstatusRecep,
			EstatusBloque    = Est_Act,
			FechaUltAct      = Par_FechaUltAct,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
	WHERE	InstitucionID	= Par_InstitucionID;

	set Par_NumErr := 000;
	set Par_ErrMen := concat('Registro actualizado exitosamente: ', convert(Par_InstitucionID, CHAR));

end if;

if (Par_NumAct = ActEstatus)then
	UPDATE INSTITUCIONESSPEI
		SET EstatusBloque   = Est_Inac,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion;

	set Par_NumErr := 000;
	set Par_ErrMen := concat('Registro actualizado exitosamente: ', convert(Par_InstitucionID, CHAR));

end if;


END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Par_InstitucionID as consecutivo;
	end if;

END TerminaStore$$