-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURACFDIACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FACTURACFDIACT`;DELIMITER $$

CREATE PROCEDURE `FACTURACFDIACT`(
	Par_FolioFiscal			char(40),
	Par_MotivoCancelacion	char(200),

	Par_Salida				char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(500),

	Par_EmpresaID			int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint
	)
TerminaStore:BEGIN

	DECLARE Cadena_Vacia	char;
	DECLARE Entero_Cero		int;
	DECLARE SalidaSI		char(1);
	DECLARE Con_Estatus		char(1);


	DECLARE	VarControl			varchar(50);
	DECLARE Var_Control			varchar(50);



	SET Cadena_Vacia	:='';
	SET Entero_Cero		:=0;
	SET SalidaSI		:='S';
	SET Con_Estatus		:='C';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN	SET Par_NumErr = 999;
		SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ',
						'estamos trabajando para resolverla. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-FACTURACFDIACT');
		SET VarControl = 'sqlException' ;
		END;

		if(Par_FolioFiscal = Cadena_Vacia) then
			set Par_NumErr  := 001;
			set Par_ErrMen  := 'Registro no Actualizado, Folio Fiscal Requerido';
			set Var_Control := 'folioFiscal';
			LEAVE ManejoErrores;
		end if;
		if(Par_MotivoCancelacion = Cadena_Vacia) then
			set Par_NumErr  := 002;
			set Par_ErrMen  := 'Registro no Actualizado, Motivo requerido';
			set Var_Control := 'folioFiscal';
			LEAVE ManejoErrores;
		end if;
Set Aud_FechaActual := CURRENT_TIMESTAMP();
		UPDATE FACTURACFDI set
			Estatus			=Con_Estatus,
			MotivoCancelacion=Par_MotivoCancelacion,
			FechaCancelacion=Aud_FechaActual,
			UsuarioCancelacion = Aud_Usuario,
			EmpresaID		= Par_EmpresaID,

			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE FolioFiscal=Par_FolioFiscal;

		set Par_NumErr  := 000;
        set Par_ErrMen  := 'Registro Actualizado';
        set Var_Control := '';

	END ManejoErrores;
	if (Par_Salida = SalidaSI) then
			select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
	end if;
END TerminaStore$$