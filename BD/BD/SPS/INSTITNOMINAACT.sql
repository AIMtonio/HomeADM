-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITNOMINAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITNOMINAACT`;DELIMITER $$

CREATE PROCEDURE `INSTITNOMINAACT`(
	Par_InstitNominaID		int,
	Par_ClienteID			bigint,
	Par_NumAct				tinyint unsigned,
	Par_Salida				char(1),
	inout Par_NumErr    	int,
	inout Par_ErrMen    	varchar(200),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE Var_Control         varchar(100);


DECLARE	EstatusBaja			char(1);
DECLARE	EstatusAlta			char(1);
DECLARE	SalidaSI			char(1);
DECLARE	Act_EstBaja			int;
DECLARE Entero_Cero     	int;
DECLARE Act_Cte				int(11);

Set	EstatusBaja				:= 'B';
Set	EstatusAlta				:= 'A';
Set	SalidaSI				:= 'S';
Set	Act_EstBaja	    		:=1;
Set Entero_cero     		:=0;
Set Act_Cte					:=2;

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-INSTITNOMINAACT');
				SET Var_Control = 'sqlException' ;
			END;

if(Par_NumAct = Act_EstBaja)then
		update INSTITNOMINA set
		Estatus	= EstatusBaja,

		EmpresaID        = Par_EmpresaID,
        Usuario          = Aud_Usuario,
        FechaActual      = Aud_FechaActual,
        DireccionIP      = Aud_DireccionIP,
        ProgramaID       = Aud_ProgramaID,
        Sucursal         = Aud_Sucursal,
        NumTransaccion   = Aud_NumTransaccion
	where InstitNominaID = Par_InstitNominaID;

set Par_NumErr  := 000;
        set Par_ErrMen  := concat("Institucion de Nomina Cancelada Exitosamente: ", convert(Par_InstitNominaID, CHAR));
        set Var_Control := 'institNominaID';
		set Entero_Cero := Par_InstitNominaID;
       LEAVE ManejoErrores;

end if;

if(Par_NumAct = Act_Cte)then
		update INSTITNOMINA set
		ClienteID		 = Par_CLienteID,
		EmpresaID        = Par_EmpresaID,
        Usuario          = Aud_Usuario,
        FechaActual      = Aud_FechaActual,
        DireccionIP      = Aud_DireccionIP,
        ProgramaID       = Aud_ProgramaID,
        Sucursal         = Aud_Sucursal,
        NumTransaccion   = Aud_NumTransaccion
	where InstitNominaID = Par_InstitNominaID;
end if;
END ManejoErrores;
if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$