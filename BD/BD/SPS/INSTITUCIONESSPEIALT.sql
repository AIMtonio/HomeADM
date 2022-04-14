-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUCIONESSPEIALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUCIONESSPEIALT`;DELIMITER $$

CREATE PROCEDURE `INSTITUCIONESSPEIALT`(



	Par_InstitucionID		int(5),
	Par_Descripcion 		varchar(100),
	Par_NumCertificado      int(11),
    Par_Estatus             char(1),
	Par_EstatusRecep        char(1),
	Par_FechaUltAct         datetime,

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
DECLARE	Var_EstatusBloque  char(1);


DECLARE  NumInstitucionID   	int;
DECLARE	 Cadena_Vacia		char(1);
DECLARE	 Fecha_Vacia		date;
DECLARE	 Entero_Cero		int;
DECLARE	 Decimal_Cero		decimal(12,2);
DECLARE  SalidaNO        	char(1);
DECLARE  SalidaSI        	char(1);
DECLARE	 ActRegistro		int;
DECLARE  Est_Act            char(1);


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
Set Est_Act                 := 'A';

ManejoErrores: BEGIN

   DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
                                 'estamos trabajando para resolverla. Disculpe las molestias que ',
                                 'esto le ocasiona. Ref: SP-INSTITUCIONESSPEIALT');
                                  set Var_Control = 'sqlException' ;
    END;


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


if isnull(Par_NumCertificado)then
	set Par_NumErr := 003;
	set Par_ErrMen := 'El numero de certificado esta vacio.';
	set Var_Control:= 'numCertificado';
	LEAVE ManejoErrores;
end if;


if(ifnull(Par_Estatus,Cadena_Vacia)) = Cadena_Vacia then
	set Par_NumErr := 004;
	set Par_ErrMen := 'El estatus de la institucion esta Vacio.';
	set Var_Control:= 'estatus';
	LEAVE TerminaStore;
end if;

if(ifnull(Par_EstatusRecep,Cadena_Vacia)) = Cadena_Vacia then
	set Par_NumErr := 005;
	set Par_ErrMen := 'El estatus recepcion de la institucion esta Vacio.';
	set Var_Control:= 'estatusRecep';
	LEAVE ManejoErrores;
end if;


if(ifnull(Par_FechaUltAct,Fecha_Vacia)) = Fecha_Vacia then
	 set Par_NumErr :=006;
	 set Par_ErrMen := 'La fecha de ultima actualizacion esta Vacia.';
	 set Var_Control:= 'fechaUltAct';
	 LEAVE ManejoErrores;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();



if exists (select InstitucionID
			from INSTITUCIONESSPEI
            where InstitucionID = Par_InstitucionID)then

	call INSTITUCIONESSPEIACT(
		Par_InstitucionID,  Par_Descripcion,   Par_NumCertificado,	Par_Estatus,		Par_EstatusRecep,
		Par_FechaUltAct,   	ActRegistro,       SalidaNO,        	Par_NumErr,  		Par_ErrMen,
		Par_EmpresaID,    	Aud_Usuario,       Aud_FechaActual, 	Aud_DireccionIP,
		Aud_ProgramaID, 	Aud_Sucursal,      Aud_NumTransaccion
		);

        if(Par_NumErr != Entero_Cero)then
			    set Par_ErrMen := 'Error en la actualizacion';
				set Var_Control:= 'institucionID';
				LEAVE ManejoErrores;
			end if;

else
	insert into INSTITUCIONESSPEI (
		InstitucionID,	    Descripcion,	NumCertificado,	   Estatus,    	EstatusRecep,
		EstatusBloque,  	FechaUltAct,    EmpresaID,  	   Usuario,	    FechaActual,
		DireccionIP,	    ProgramaID,     Sucursal,          NumTransaccion)

	values (
		Par_InstitucionID,	Par_Descripcion,   Par_NumCertificado,	    Par_Estatus,     Par_EstatusRecep,
		Est_Act,  			Par_FechaUltAct,   Par_EmpresaID,           Aud_Usuario,     Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,	   Aud_Sucursal,            Aud_NumTransaccion);


        set Par_NumErr := 000;
		set Par_ErrMen := concat('Registro agregado exitosamente: ', convert(Par_InstitucionID, char));
		set Var_Control:= 'institucionID' ;


end if;

END ManejoErrores;

     IF (Par_Salida = SalidaSI) THEN
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Par_InstitucionID as consecutivo;
	end if;

END TerminaStore$$