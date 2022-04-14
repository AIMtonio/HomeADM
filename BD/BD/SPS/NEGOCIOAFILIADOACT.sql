-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NEGOCIOAFILIADOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `NEGOCIOAFILIADOACT`;DELIMITER $$

CREATE PROCEDURE `NEGOCIOAFILIADOACT`(
	Par_NegocioAfiliadoID	int,
	Par_ClienteID		bigint,
    Par_NumAct          tinyint unsigned,

	Par_Salida			char(1),
	inout Par_NumErr	int,
	inout Par_ErrMen   	varchar(400),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Var_Control         varchar(100);
DECLARE Var_Estatus         char(1);



DECLARE	EstatusBaja		char(1);
DECLARE	EstatusAlta		char(1);
DECLARE	SalidaSI		char(1);
DECLARE	Act_EstBaja		int;
DECLARE	Act_Cliente		int;



Set	EstatusBaja		:= 'B';
Set	EstatusAlta		:= 'A';
Set	Act_EstBaja		:= 1;
Set	Act_Cliente		:= 2;
set	SalidaSI		:= 'S';


ManejoErrores: BEGIN



DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
								 'estamos trabajando para resolverla. Disculpe las molestias que ',
								 'esto le ocasiona. Ref: SP-NEGOCIOAFILIADOACT');
		SET Var_Control = 'negocioAfiliadoID' ;
	END;

Set Aud_FechaActual := now();


if(not exists(select NegocioAfiliadoID
			from NEGOCIOAFILIADO
			where NegocioAfiliadoID = Par_NegocioAfiliadoID)) then
	set Par_NumErr  := 001;
	set Par_ErrMen  := 'El Negocio Afiliado No Existe';
	set Var_Control := 'negocioAfiliadoID';
	LEAVE ManejoErrores;
end if;

if(Par_NumAct = Act_EstBaja ) then
	set Var_Estatus := (Select Estatus from NEGOCIOAFILIADO
						where NegocioAfiliadoID = Par_NegocioAfiliadoID);


	if(Var_Estatus = EstatusBaja ) then
		set Par_NumErr  := 002;
		set Par_ErrMen  := 'El Negocio Afiliado ya fue dado de Baja';
		set Var_Control := 'negocioAfiliadoID';
		LEAVE ManejoErrores;
	end if;

	update NEGOCIOAFILIADO set
		Estatus		 	= EstatusBaja,

		EmpresaID	 	= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion

	where NegocioAfiliadoID = Par_NegocioAfiliadoID;

	    set Par_NumErr  := 000;
        set Par_ErrMen  := concat('El Negocio Afiliado se ha dado de Baja Exitosamente:', convert(Par_NegocioAfiliadoID,char)) ;
        set Var_Control := 'negocioAfiliadoID';
end if;

if(Par_NumAct = Act_Cliente ) then

	update NEGOCIOAFILIADO set
		ClienteID		= Par_ClienteID,

		EmpresaID	 	= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion

	where NegocioAfiliadoID = Par_NegocioAfiliadoID;
end if;


END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
			Par_NegocioAfiliadoID as consecutivo;
end if;

END TerminaStore$$