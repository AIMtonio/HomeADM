-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCANCELAALT`;DELIMITER $$

CREATE PROCEDURE `CLIENTESCANCELAALT`(

    Par_ClienteID				int,
    Par_AreaCancela				char(3),
    Par_UsuarioRegistra 		int(11),
    Par_MotivoActivaID			int(11),
    Par_Comentarios				varchar(500),

	Par_AplicaSeguro			char(1),
	Par_ActaDefuncion			varchar(100),
	Par_FechaDefuncion			date,
    Par_Salida					char(1),
    inout Par_NumErr 			int,

    inout Par_ErrMen  			varchar(350),
    inout Par_ClienteCancelaID  int(11),
    Par_EmpresaID				int,
	Aud_Usuario         		int,
    Aud_FechaActual     		DateTime,

    Aud_DireccionIP     		varchar(15),
    Aud_ProgramaID      		varchar(50),
    Aud_Sucursal        		int,
    Aud_NumTransaccion  		bigint
)
TerminaStore: BEGIN


DECLARE Var_ClienteID		int(11);
DECLARE Var_ClienteCancel	int(11);
DECLARE VarClienteCancelaID	int(11);
DECLARE VarControl			varchar(100);
DECLARE	VarFechaRegistro	date;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Salida_SI       	char(1);
DECLARE	Salida_NO       	char(1);
DECLARE	Est_Registrado		char(1);
DECLARE	Var_AtencioSoc		char(3);
DECLARE	Var_Proteccion		char(3);
DECLARE	Var_Cobranza		char(3);
DECLARE Var_NO				char(1);


Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
set Est_Registrado			:= 'R';
set Salida_SI				:='S';
set Salida_NO				:='N';
set Var_AtencioSoc			:= 'Soc';
set Var_Proteccion			:= 'Pro';
set Var_Cobranza			:= 'Cob';
set Var_NO					:= 'N';


set Par_NumErr  		:= Entero_Cero;
set Par_ErrMen  		:= Cadena_Vacia;
set Aud_FechaActual 	:= now();
set VarFechaRegistro	:= (select FechaSistema from PARAMETROSSIS);

ManejoErrores:BEGIN


	if(Par_NumErr != Entero_Cero) then
		leave ManejoErrores;
	end if;

	if(ifnull(Par_UsuarioRegistra, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 03;
		set Par_ErrMen   := 'El Usuario que Registra esta Vacio';
		set VarControl   := 'usuario';
		LEAVE ManejoErrores;
	end if;

	set Var_ClienteID := (select ClienteID from CLIENTES where ClienteID = Par_ClienteID);
    if(ifnull(Var_ClienteID, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 04;
		set Par_ErrMen   := 'El safilocale.cliente No Existe ';
		set VarControl   := 'clienteID';
		LEAVE ManejoErrores;
    end if;


	set Var_ClienteCancel :=(select ClienteCancelaID
	from CLIENTESCANCELA Can,
		MOTIVACTIVACION Mot
	where ClienteID = Par_ClienteID
	and Can.MotivoActivaID = Mot.MotivoActivaID
		and PermiteReactivacion = Var_NO limit 1);
	if(ifnull(Var_ClienteCancel,Entero_Cero) != Entero_Cero) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := concat('El safilocale.cliente ya Cuenta con una Solicitud de Cancelacion con folio: ', convert(Var_ClienteCancel,char));
		set VarControl   := 'clienteID';
		LEAVE ManejoErrores;
	end if;

	if(Par_AreaCancela) then
		if(ifnull(Par_ActaDefuncion, Cadena_Vacia) = Cadena_Vacia) then
			set Par_NumErr   := 03;
			set Par_ErrMen   := 'El Folio del Acta de defuncion esta Vacio';
			set VarControl   := 'actaDefuncion';
			LEAVE ManejoErrores;
		end if;

		if(ifnull(Par_FechaDefuncion, Fecha_Vacia) = Fecha_Vacia) then
			set Par_NumErr   := 03;
			set Par_ErrMen   := 'La Fecha de Defuncion esta Vacia';
			set VarControl   := 'fechaDefuncion';
			LEAVE ManejoErrores;
		end if;
	end if;

	call FOLIOSAPLICAACT('CLIENTESCANCELA', VarClienteCancelaID);


	insert into CLIENTESCANCELA (
		ClienteCancelaID,		ClienteID,			AreaCancela,		UsuarioRegistra,		FechaRegistro,
		SucursalRegistro,		Estatus,			MotivoActivaID,		Comentarios,			UsuarioAutoriza,
		FechaAutoriza,			SucursalAutoriza,	AplicaSeguro,		ActaDefuncion,			FechaDefuncion,
		EmpresaID,				Usuario,	        FechaActual,		DireccionIP,			ProgramaID,
		Sucursal,				NumTransaccion)
	values (
		VarClienteCancelaID,	Par_ClienteID,		Par_AreaCancela,	Par_UsuarioRegistra,	VarFechaRegistro,
		Aud_Sucursal,			Est_Registrado,		Par_MotivoActivaID,	Par_Comentarios,		Entero_Cero,
		Fecha_Vacia,			Entero_Cero,		Par_AplicaSeguro,	Par_ActaDefuncion,		Par_FechaDefuncion,
		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);


	set Par_ClienteCancelaID := VarClienteCancelaID;
	set Par_NumErr  := 000;
	set Par_ErrMen  := concat('Solicitud de Cancelacion Agregada Exitosamente: ',convert(VarClienteCancelaID,char));
	set varControl	:= 'clienteCancelaID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			VarClienteCancelaID	 AS consecutivo;
end IF;

END TerminaStore$$