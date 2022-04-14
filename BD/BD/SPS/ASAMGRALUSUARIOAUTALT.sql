-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASAMGRALUSUARIOAUTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASAMGRALUSUARIOAUTALT`;DELIMITER $$

CREATE PROCEDURE `ASAMGRALUSUARIOAUTALT`(
	Par_UsuarioID  		    int(11),
    Par_NombreCompleto  	varchar(150),
	Par_RolID	  		    int(11),

    Par_Salida          	char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID		 	int(11),
    Aud_Usuario				int(11),
	Aud_FechaActual			datetime,
	Aud_DireccionIP			varchar(20),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint(20)
)
TerminaStore: BEGIN


DECLARE Var_Control  	 varchar(200);
DECLARE Var_AsamGralID	 bigint(20);


DECLARE Entero_Cero     int(11);
DECLARE Decimal_Cero    decimal(12,2);
DECLARE Cadena_Vacia    char(1);
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);


Set Entero_Cero  		:= 0;
Set SalidaSI     		:= 'S';
Set SalidaNO     		:= 'N';
Set Cadena_Vacia 		:='';
Set Decimal_Cero        := 0.0;


ManejoErrores: BEGIN



	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
								 'estamos trabajando para resolverla. Disculpe las molestias que ',
								 'esto le ocasiona. Ref: SP-ASAMGRALUSUARIOAUTALT');
		SET Var_Control = 'sqlException' ;
	END;


if(ifnull(Par_UsuarioID,Entero_Cero)) = Entero_Cero then
	      set Par_NumErr := 001;
		  set Par_ErrMen := 'El numero de usuario esta Vacio.';
	LEAVE TerminaStore;
end if;


	Set Var_AsamGralID   := (select ifnull(Max(AsamGralID),Entero_Cero) + 1
	from ASAMGRALUSUARIOAUT);


	Set Aud_FechaActual = NOW();



	INSERT INTO ASAMGRALUSUARIOAUT (
			AsamGralID,			UsuarioID,			NombreCompleto,		RolID,			EmpresaID,
			Usuario,			FechaActual,		DireccionIP,		ProgramaID,		Sucursal,
			NumTransaccion)

	VALUES (Var_AsamGralID,		Par_UsuarioID,		Par_NombreCompleto,	Par_RolID,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

			set Par_NumErr := 000;
			set Par_ErrMen :='Usuario autorizado Registrado Exitosamente';
			set Var_Control := 'asamGralID';
			set Entero_Cero := Var_AsamGralID;

END ManejoErrores;

if (Par_Salida = SalidaSI) then
select  Par_NumErr as NumErr,
		Par_ErrMen as ErrMen,
		Var_Control as control,
		Entero_Cero as consecutivo;
end if;

END TerminaStore$$