-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NEGAFILICLIENTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `NEGAFILICLIENTEALT`;DELIMITER $$

CREATE PROCEDURE `NEGAFILICLIENTEALT`(
	Par_NegocioAfiliadoID	int,
	Par_ClienteID			int,
	Par_ProspectoID			int,

	Par_Salida          char(1),
	inout Par_NumErr	int,
	inout Par_ErrMen	varchar(400),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Var_Control            varchar(100);
DECLARE Var_Consecutivo        int;


DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);
DECLARE	Fecha_Vacia		date;


Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set SalidaSI        := 'S';
Set SalidaNO        := 'N';
Set	Fecha_Vacia		:= '1900-01-01';


ManejoErrores: BEGIN

 DECLARE EXIT HANDLER FOR SQLEXCEPTION
 		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
									'estamos trabajando para resolverla. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-NEGAFILICLIENTEALT');
			SET Var_Control = 'sqlException' ;
		END;


 if(not exists(select NegocioAfiliadoID
                    from NEGOCIOAFILIADO
                        where NegocioAfiliadoID= Par_NegocioAfiliadoID)) then
        set Par_NumErr 		:= 001;
        set Par_ErrMen  	:= 'El Negocio Afiliado no existe';
        set Var_Control 	:= 'negocioAfiliadoID';
		LEAVE ManejoErrores;
	end if;


set Par_ClienteID   := ifnull(Par_ClienteID, Entero_Cero);
if(Par_ClienteID != Entero_Cero) then
 if(not exists(select ClienteID
                    from CLIENTES
                        where ClienteID = Par_ClienteID)) then
        set Par_NumErr 		:= 002;
        set Par_ErrMen  	:= 'El cliente especificado no existe';
        set Var_Control 	:= 'clienteID';
		LEAVE ManejoErrores;
	end if;

end if;

set Par_ProspectoID  := ifnull(Par_ProspectoID, Entero_Cero);
if(Par_ProspectoID != Entero_Cero) then
 if(not exists(select ProspectoID
                    from PROSPECTOS
                        where ProspectoID = Par_ProspectoID)) then
        set Par_NumErr 		:= 003;
        set Par_ErrMen  	:= 'El prospecto especificado no existe';
        set Var_Control 	:= 'prospectoID';
		LEAVE ManejoErrores;
	end if;
end if;

if(Par_ClienteID = Entero_Cero) then
	if(Par_ProspectoID = Entero_Cero) then
		set Par_NumErr 		:= 004;
        set Par_ErrMen  	:= 'Se Requiere un Cliente o un Prospecto';
        set Var_Control 	:= 'clienteID';
		LEAVE ManejoErrores;
	end if;
end if;


INSERT INTO NEGAFILICLIENTE (
	NegocioAfiliadoID,		ClienteID,		ProspectoID,		EmpresaID,		Usuario,
	FechaActual,			DireccionIP,    ProgramaID,     	Sucursal,		NumTransaccion)
	VALUES(
    Par_NegocioAfiliadoID,     Par_ClienteID,		Par_ProspectoID,	Par_EmpresaID,  	Aud_Usuario,
	Aud_FechaActual,		Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

		set Par_NumErr  := 000;
        set Par_ErrMen  := 'Negocio Agregado';
        set Var_Control := 'negocioAfiliado';
		set Entero_Cero := Par_NegocioAfiliadoID;


END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$