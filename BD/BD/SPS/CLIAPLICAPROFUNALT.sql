-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPLICAPROFUNALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPLICAPROFUNALT`;DELIMITER $$

CREATE PROCEDURE `CLIAPLICAPROFUNALT`(

    Par_ClienteID       int,
    Par_UsuarioReg      varchar(50),
    Par_FechaRegistro   date,
    Par_Estatus	        varchar(1),
    Par_Comentario      varchar(300),

    Par_ActaDefuncion   varchar(100),
    Par_FechaDefuncion  date,
    Par_Salida				char(1),
    inout	Par_NumErr		int,
    inout	Par_ErrMen		varchar(350),

    Par_EmpresaID			int,
    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),

    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
	)
TerminaStore: BEGIN


DECLARE Var_ClienteID   int(11);
DECLARE VarControl		char(15);


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Fecha_Alta		date;
DECLARE	Salida_SI       char(1);
DECLARE	Var_NO			char(1);
DECLARE	Est_Registrado	char(1);
DECLARE AreaCancelaPro	char(3);


Set Cadena_Vacia		:= '';
Set Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero			:= 0;
set Par_NumErr  		:= Entero_Cero;
set Par_ErrMen  		:= Cadena_Vacia;
set Salida_SI			:='S';
set Var_NO				:='N';
set Est_Registrado		:='R';
set AreaCancelaPro		:= 'Pro';


set Aud_FechaActual 	:= now();



ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-CLIENTESPROFUNALT');
				SET VarControl = 'sqlException' ;
			END;

	set Var_ClienteID := (select ClienteID from CLIAPLICAPROFUN where ClienteID = Par_ClienteID);
	if(ifnull(Var_ClienteID, Entero_Cero) > Entero_Cero) then
		set Par_NumErr   := 06;
		set Par_ErrMen   := 'El Cliente ya tiene una solicitud Registrada';
		set VarControl   := 'clienteID';
		LEAVE ManejoErrores;
	end if;

	set Var_ClienteID := (select ClienteID from CLIENTES where ClienteID = Par_ClienteID);
	if(ifnull(Var_ClienteID, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 05;
		set Par_ErrMen   := 'El Cliente no Existe';
		set VarControl   := 'clienteID';
		LEAVE ManejoErrores;
	end if;

	set Var_ClienteID := (select ClienteID from CLIENTESCANCELA where ClienteID = Par_ClienteID and AreaCancela = AreaCancelaPro);
	if(ifnull(Var_ClienteID, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 06;
		set Par_ErrMen   := 'El safilocale.cliente No Tiene una Solicitud de Cancelación.';
		set VarControl   := 'clienteID';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_UsuarioReg, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := 'El Usuario esta Vacio';
		set VarControl   := 'usuarioReg';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_FechaRegistro, Fecha_Vacia) = Fecha_Vacia) then
		set Par_NumErr   := 02;
		set Par_ErrMen   := 'La Fecha de Registro esta Vacia';
		set VarControl   := 'fechaRegistro';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_ActaDefuncion, Cadena_Vacia) = Cadena_Vacia) then
		set Par_NumErr   := 03;
		set Par_ErrMen   := 'El Acta de Defuncion esta Vacia';
		set VarControl   := 'actaDefuncion';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_FechaDefuncion, Fecha_Vacia) = Fecha_Vacia) then
		set Par_NumErr   := 04;
		set Par_ErrMen   := 'La Fecha de Defuncion esta  Vacia';
		set VarControl   := 'fechaDefuncion';
		LEAVE ManejoErrores;
	end if;

	insert into CLIAPLICAPROFUN(
		ClienteID,			Monto,				Comentario,			ActaDefuncion,		FechaDefuncion,
		UsuarioReg,			FechaRegistro,		FechaAutoriza,		UsuarioAuto,		UsuarioRechaza,
		FechaRechaza,		MotivoRechazo,		AplicadoSocios,		Estatus,			EmpresaID,
		Usuario,			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
		NumTransaccion)
	values (
		Par_ClienteID,		Entero_Cero,		Par_Comentario,		Par_ActaDefuncion,	Par_FechaDefuncion,
		Par_UsuarioReg,		Par_FechaRegistro,	Fecha_Vacia,		Entero_Cero,		Entero_Cero,
		Fecha_Vacia,		Cadena_Vacia,		Var_NO,				Est_Registrado,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	set Par_NumErr  := 000;
	set Par_ErrMen  := concat('La Solicitud del safilocale.cliente : ',Par_ClienteID ,', fue Agregada Exitosamente.');
	set varControl	:= 'clienteID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
end IF;

END TerminaStore$$