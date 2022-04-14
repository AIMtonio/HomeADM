-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEUSUARIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEUSUARIOSALT`;DELIMITER $$

CREATE PROCEDURE `BEUSUARIOSALT`(
	Par_Clave				varchar(20),
	Par_Perfil              int(11),
	Par_ClienteNominaID     int(11),
	Par_NegocioAfiliadoID   int(11),
	Par_ClienteID			int(11),

	Par_CostoMensual        decimal(14,2),
	Par_Salida          	char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),
	Par_EmpresaID			int,

	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,

	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE VarEsUsuarioNom      char(1);


DECLARE Cadena_Vacia        char(20);
DECLARE Entero_Cero         int;
DECLARE Fecha_Vacia         date;
DECLARE Estatus_Activo      char(1);
DECLARE SalidaSI            char(1);
DECLARE SalidaNO            char(1);
DECLARE EsUsuarioNominaSI   char(1);
DECLARE EsUsuarioNominaNO   char(1);
DECLARE Con_PerfilNomina    int;
DECLARE Con_NegAfil         char(30);
DECLARE Var_Control         varchar(100);


Set Cadena_Vacia        := '';
Set Entero_Cero         := 0;
Set Fecha_Vacia         := '1900-01-01';
Set Estatus_Activo      := 'A';
Set SalidaSI            := 'S';
Set SalidaNO            := 'N';


set EsUsuarioNominaSI   :='S';
set EsUsuarioNominaNO   :='N';


ManejoErrores: BEGIN


DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SPWS-BEUSUARIOSALT');
				SET Var_Control = 'sqlException' ;
			END;

if(ifnull(Par_Clave, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 001;
        set Par_ErrMen  := 'Clave Requerida';
        set Var_Control := 'clave';
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_ClienteNominaID, Cadena_Vacia)) != Cadena_Vacia then
	set VarEsUsuarioNom := EsUsuarioNominaSI;
else
	set VarEsUsuarioNom := EsUsuarioNominaNO;
end if;

set Par_ClienteNominaID     := ifnull(Par_ClienteNominaID, Cadena_Vacia);
set Par_NegocioAfiliadoID   := ifnull(Par_NegocioAfiliadoID, Cadena_Vacia);

set Aud_FechaActual := now();


INSERT INTO BEUSUARIOS (
    Clave,				Estatus,            PerfilID,           ClienteNominaID,		NegocioAfiliadoID,
    ClienteID,			CostoMensual,       EsUsuarioNomina,    EmpresaID,				Usuario,
    FechaActual,		DireccionIP,        ProgramaID,         Sucursal,				NumTransaccion
)VALUES(
	Par_Clave,			Estatus_Activo,		Par_Perfil,         Par_ClienteNominaID,	Par_NegocioAfiliadoID,
	Par_ClienteID,		Par_CostoMensual,	VarEsUsuarioNom,    Par_EmpresaID,			Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,			Aud_NumTransaccion
);


set Par_NumErr  := 000;
set Par_ErrMen  := concat('Usuario Agregado Exitosamente: ',Par_Clave);
set Var_Control := 'clave';
set Cadena_Vacia :=  Par_Clave;

END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Cadena_Vacia as consecutivo;
end if;

END TerminaStore$$