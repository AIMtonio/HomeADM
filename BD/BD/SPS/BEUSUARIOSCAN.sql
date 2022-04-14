-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEUSUARIOSCAN
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEUSUARIOSCAN`;DELIMITER $$

CREATE PROCEDURE `BEUSUARIOSCAN`(
	Par_Clave			        varchar(20),
   Par_MotivoCancelacion   varchar(200),

	Par_Salida				char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen   	 	varchar(400),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Var_NumLogInc   int;
DECLARE Var_Control     varchar(100);


DECLARE EstatusCancela char(1);
DECLARE SalidaSI        char(1);
DECLARE Entero_Cero     int(11);
DECLARE Cadena_Vacia    char(20);

Set EstatusCancela      := 'C';
set SalidaSI            := 'S';
set Entero_Cero         :=  0;
set Cadena_Vacia        :=  '';
set Aud_FechaActual	:= now();

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SPWS-BEUSUARIOSCAN');
				SET Var_Control = 'sqlException' ;
			END;

update BEUSUARIOS set
		Estatus		 		= EstatusCancela,


		EmpresaID	 		   = Par_EmpresaID,
		Usuario			   = Aud_Usuario,
		FechaActual 		   = Aud_FechaActual,
		DireccionIP 		   = Aud_DireccionIP,
		ProgramaID  		   = Aud_ProgramaID,
		Sucursal			   = Aud_Sucursal,
		NumTransaccion		= Aud_NumTransaccion
	where Clave = Par_Clave;

 set Par_NumErr  := 000;
        set Par_ErrMen  := 'Usuario Cancelado Exitosamente';
        set Var_Control := 'clave';
        set Cadena_Vacia := Par_Clave;
        LEAVE ManejoErrores;

END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;
END TerminaStore$$