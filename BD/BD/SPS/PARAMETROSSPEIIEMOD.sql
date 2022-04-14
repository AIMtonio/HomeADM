-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSPEIIEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSPEIIEMOD`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSSPEIIEMOD`(
	Par_EmpresaID			int(11),
	Par_CtaDDIESpei         varchar(20),
    Par_CtaDDIETrans        varchar(20),

	Par_Salida				char(1),

	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Aud_Usuario				int,
	Aud_FechaActual			datetime,
	Aud_DireccionIP			varchar(20),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
)
TerminaStore:BEGIN


DECLARE Var_Control 	    char(15);


DECLARE	 Cadena_Vacia		char(1);
DECLARE	 Fecha_Vacia		date;
DECLARE	 Hora_Vacia 		time;
DECLARE	 Entero_Cero		int;
DECLARE	 Decimal_Cero		decimal(12,2);
DECLARE  SalidaNO        	char(1);
DECLARE  SalidaSI        	char(1);


Set	Cadena_Vacia		    := '';
Set	Fecha_Vacia			    := '1900-01-01';
Set	Hora_Vacia			    := '00:00:00';
Set	Entero_Cero			    := 0;
Set	Decimal_Cero		    := 0.0;
Set SalidaSI        	    := 'S';
Set SalidaNO        	    := 'N';
Set Par_NumErr  		    := 0;
Set Par_ErrMen  		    := '';

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, ' ,
                                 'estamos trabajando para resolverla. Disculpe las molestias que ',
                                 'esto le ocasiona. Ref: SP-PARAMETROSSPEIIEMOD');
                                  set Var_Control = 'sqlException' ;
    END;


if(ifnull(Par_EmpresaID,Entero_Cero))= Entero_Cero then
	set Par_NumErr  := 001;
	set Par_ErrMen  := 'El numero de empresa esta vacio.';
	set Var_Control  := 'empresaID' ;
	LEAVE ManejoErrores;
end if;


if(ifnull(Par_CtaDDIESpei,Cadena_Vacia))= Cadena_Vacia then
	set Par_NumErr  := 002;
	set Par_ErrMen  := 'La Cuenta contable para transferencias SPEI esta vacia';
	set Var_Control  := 'ctaDDIESpei' ;
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_CtaDDIETrans,Cadena_Vacia))= Cadena_Vacia then
	set Par_NumErr  := 003;
	set Par_ErrMen  := 'Cuenta contable para Transferencias esta vacia.';
	set Var_Control  := ' ctaDDIETrans' ;
	LEAVE ManejoErrores;
end if;

if not exists(select EmpresaID
			from PARAMETROSSPEIIE
			where EmpresaID = Par_EmpresaID)then
		set Par_NumErr  := 004;
		set Par_ErrMen  := 'El ID de la empresa no se ecuentra registrado.';
		set Var_Control  := 'empresaID' ;
		LEAVE ManejoErrores;
end if;


	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	 UPDATE PARAMETROSSPEIIE SET
					CtaDDIESpei	        = Par_CtaDDIESpei,
					CtaDDIETrans        = Par_CtaDDIETrans,

                    Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
		WHERE EmpresaID = Par_EmpresaID;

	SET Par_NumErr  := 000;
	SET Par_ErrMen  := 'Parametros 	SPEI IE Modificados Exitosamente.';
	SET Var_Control  := 'empresaID' ;
	LEAVE ManejoErrores;


END ManejoErrores;

	if (Par_Salida = SalidaSI) then
		select  convert(Par_NumErr, char(3)) as NumErr,
				Par_ErrMen		 as ErrMen,
				Var_Control		 as control,
				Par_EmpresaID	 as consecutivo;
	end if;

END TerminaStore$$