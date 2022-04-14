-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEUSUARIOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEUSUARIOSMOD`;DELIMITER $$

CREATE PROCEDURE `BEUSUARIOSMOD`(
	Par_Clave               varchar(20),
	Par_Perfil              int (11),
	Par_ClienteNominaID     int(11),
	Par_NegocioAfiliadoID   int(11),
	Par_ClienteID			int(11),
	Par_CostoMensual        decimal(14,2),


	Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(200),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE EsUsuarioNomina   char(1);
DECLARE Var_Control        varchar(100);


DECLARE	Cadena_Vacia	char(20);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);
DECLARE EsUsuarioNominaSI   char(1);
DECLARE EsUsuarioNominaNO   char(1);



Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set SalidaSI			:= 'S';
Set SalidaNO			:= 'N';
set EsUsuarioNominaSI   :='S';
set EsUsuarioNominaNO   :='N';

ManejoErrores: BEGIN


DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SPWS-BEUSUARIOSMOD');
				SET Var_Control = 'sqlException' ;
			END;

if(not exists(select Clave
			from BEUSUARIOS
			where Clave = Par_Clave)) then
          set Par_NumErr  := 001;
        set Par_ErrMen  := 'el usuario no Existe';
        set Var_Control := 'clave';
        LEAVE ManejoErrores;
end if;



if(Par_ClienteNominaID != Cadena_Vacia ) then
set EsUsuarioNomina := EsUsuarioNominaSI;
else
set EsUsuarioNomina := EsUsuarioNominaNO;
end if;

Set Aud_FechaActual := now();


update BEUSUARIOS set
	Clave				= Par_Clave,
	PerfilID			=Par_Perfil,
	ClienteNominaID		=Par_ClienteNominaID,
	NegocioAfiliadoID	=Par_NegocioAfiliadoID,
	ClienteID			= Par_ClienteID,
	CostoMensual		= Par_CostoMensual,
	EsUsuarioNomina		=EsUsuarioNomina,

	EmpresaID			= Par_EmpresaID,
	Usuario				= Aud_Usuario,
	FechaActual 		= Aud_FechaActual,
	DireccionIP 		= Aud_DireccionIP,
	ProgramaID  		= Aud_ProgramaID,
	Sucursal			= Aud_Sucursal,
	NumTransaccion		= Aud_NumTransaccion
where Clave	= Par_Clave;


set Par_NumErr  := 000;
set Par_ErrMen  := concat('Usuario Modificado Exitosamente: ',Par_Clave);
set Var_Control := 'clave';
set Cadena_Vacia := Par_Clave;

END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Cadena_Vacia as consecutivo;
end if;
END TerminaStore$$