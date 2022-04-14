-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESPROFUNALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESPROFUNALT`;DELIMITER $$

CREATE PROCEDURE `CLIENTESPROFUNALT`(

    Par_ClienteID			int(11),
    Par_FechaRegistro   	date,
    Par_SucursalReg		   	int(11),
    Par_UsuarioReg        	int(11),
    Par_Salida				char(1),

    inout	Par_NumErr 		int,
    inout	Par_ErrMen  	varchar(350),
    Par_EmpresaID			int,
    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,

    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
)
TerminaStore: BEGIN


DECLARE Var_ClienteID		int(11);
DECLARE Var_ClientePROFUN	int(11);
DECLARE VarControl			char(15);
DECLARE Var_EstatusCli		char(1);
DECLARE Var_FechaSistema   	date;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Salida_SI       	char(1);
DECLARE	Est_Registrado	char(1);
DECLARE	Estatus_Activo		char(1);
DECLARE Estatus_Cancelado	char(1);
DECLARE AreaCancelaPro			char(3);



Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
set Est_Registrado			:= 'R';
set Estatus_Activo			:= 'A';
set Salida_SI				:='S';
set Estatus_Cancelado		:= 'C';
set AreaCancelaPro			:= 'Pro';


set Par_NumErr  		:= Entero_Cero;
set Par_ErrMen  		:= Cadena_Vacia;
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


	if(ifnull(Par_FechaRegistro, Fecha_Vacia) = Fecha_Vacia) then
		set Par_NumErr   := 02;
		set Par_ErrMen   := 'La Fecha de Registro esta Vacia';
		set VarControl   := 'cuentaAhoID';
		LEAVE ManejoErrores;
	end if;


	if(ifnull(Par_UsuarioReg, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 03;
		set Par_ErrMen   := 'El Usuario que Registra esta Vacio';
		set VarControl   := 'usuario';
		LEAVE ManejoErrores;
	end if;

	set Var_ClienteID := (select ClienteID from CLIENTES where ClienteID = Par_ClienteID);
    if(ifnull(Var_ClienteID, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 04;
		set Par_ErrMen   := 'El safilocale.cliente No Existe';
		set VarControl   := 'clienteID';
		LEAVE ManejoErrores;
    end if;

	set Var_EstatusCli := (select Estatus from CLIENTES where ClienteID = Par_ClienteID);
    if(ifnull(Var_EstatusCli, Cadena_Vacia) != Estatus_Activo) then
		set Par_NumErr   := 04;
		set Par_ErrMen   := 'El safilocale.cliente No esta Activo.';
		set VarControl   := 'clienteID';
		LEAVE ManejoErrores;
    end if;



	IF EXISTS (SELECT ClienteID
					FROM CLIENTESPROFUN
						WHERE ClienteID = Par_ClienteID
							AND Estatus != Estatus_Cancelado) THEN
			SET Par_NumErr   := 01;
			SET Par_ErrMen   := 'El safilocale.cliente ya esta Registrado en Proteccion Funeraria (PROFUN)';
			SET VarControl   := 'clienteID';
			LEAVE ManejoErrores;
	END IF;


	IF EXISTS (SELECT Pro.ClienteID
				FROM CLIENTESPROFUN Pro,
					 CLIENTESCANCELA Can
				WHERE Pro.ClienteID = Can.ClienteID
					AND Pro.ClienteID = Par_ClienteID
					AND Can.AreaCancela = AreaCancelaPro
				LIMIT 1)THEN
					SET Par_NumErr   := 01;
					SET Par_ErrMen   := 'El safilocale.cliente Tiene un Registro de Cancelacion';
					SET VarControl   := 'clienteID';
			LEAVE ManejoErrores;
	END IF;

select 	FechaSistema into 	Var_FechaSistema
	from PARAMETROSSIS;


IF NOT EXISTS  (SELECT ClienteID FROM CLIENTESPROFUN WHERE ClienteID = Par_ClienteID) THEN
	insert into CLIENTESPROFUN (
		ClienteID,			FechaRegistro,		SucursalReg,		UsuarioReg,         UsuarioCan,
		FechaCancela,		Estatus,			FechaReactivacion,	EmpresaID,          Usuario,            FechaActual,
		DireccionIP,		ProgramaID,			Sucursal,           NumTransaccion)
	values (
		Par_ClienteID,		Par_FechaRegistro,  Par_SucursalReg,	Par_UsuarioReg,     Entero_Cero,
		Fecha_Vacia,		Est_Registrado,		Fecha_Vacia,		Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);
ELSE
	update CLIENTESPROFUN set
							Estatus 		= Est_Registrado,
							FechaReactivacion = Var_FechaSistema,
							SucursalReg		= Par_SucursalReg,
							UsuarioReg		= Par_UsuarioReg,
							EmpresaID		= Par_EmpresaID,
							Usuario			= Aud_Usuario,
							FechaActual		= Aud_FechaActual,
							DireccionIP		= Aud_DireccionIP,
							ProgramaID		= Aud_ProgramaID,
							Sucursal		= Aud_Sucursal,
							NumTransaccion	= Aud_NumTransaccion
	where ClienteID = Par_ClienteID;


	update CLICOBROSPROFUN set
							FechaBaja 		= Fecha_Vacia,
							EmpresaID		= Par_EmpresaID,
							Usuario			= Aud_Usuario,
							FechaActual		= Aud_FechaActual,
							DireccionIP		= Aud_DireccionIP,
							ProgramaID		= Aud_ProgramaID,
							Sucursal		= Aud_Sucursal,
							NumTransaccion	= Aud_NumTransaccion
	where ClienteID = Par_ClienteID;


END IF;


	set Par_NumErr  := 000;
	set Par_ErrMen  := concat('El safilocale.cliente : ', convert(Par_ClienteID,char) ,' Fue Registrado Exitosamente.');
	set varControl	:= 'clienteID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
end IF;

END TerminaStore$$