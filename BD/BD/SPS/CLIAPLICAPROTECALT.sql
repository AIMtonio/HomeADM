-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPLICAPROTECALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPLICAPROTECALT`;DELIMITER $$

CREATE PROCEDURE `CLIAPLICAPROTECALT`(

	Par_ClienteID			int(11),
	Par_UsuarioReg			int(11),
	Par_ActaDefuncion		varchar(100),
	Par_FechaDefuncion		date,
	Par_Salida				char(1),

	inout	Par_NumErr 		int,
	inout	Par_ErrMen  	varchar(350),
	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,

	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
	)
TerminaStore:BEGIN


DECLARE Var_FechaSistema	date;
DECLARE Var_MontoMaxProtec	decimal(14,2);
DECLARE Var_MontoTotal		decimal(14,2);
DECLARE Var_CliCancel		int(11);
DECLARE Var_Control			varchar(30);


DECLARE Cadena_Vacia		char;
DECLARE Decimal_Cero		decimal;
DECLARE Entero_Cero			int;
DECLARE SalidaSI			char(1);
DECLARE FechaVacia			date;
DECLARE Est_Registrado		char(1);
DECLARE AreaCancelaPro		char(3);


set Cadena_Vacia		:='';
set Decimal_Cero		:=0.0;
set Entero_Cero			:=0;
set FechaVacia			:= '1900-01-01';
set SalidaSI			:='S';
set Est_Registrado		:='R';
set AreaCancelaPro		:= 'Pro';

ManejoErrores:Begin
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN	SET Par_NumErr = 999;
	SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ',
					'estamos trabajando para resolverla. Disculpe las molestias que ',
					'esto le ocasiona. Ref: SP-CLIAPLICAPROTECALT');
	END;

if not exists(select ClienteID
				from CLIENTES
				 where ClienteID = Par_ClienteID)then
	set Par_NumErr	:=1;
	set Par_ErrMen	:='El safilocale.cliente indicado no existe';
	LEAVE ManejoErrores;
end if;

if exists(select ClienteID
				from CLIAPLICAPROTEC
				where ClienteID = Par_ClienteID)then
	set Par_NumErr	:=2;
	set Par_ErrMen	:=Concat('La Solicitud de Proteccion del safilocale.cliente ',Par_ClienteID, ' ya se encuentra registrada');
	LEAVE ManejoErrores;
end if;

set Var_FechaSistema	:= (select FechaSistema From PARAMETROSSIS limit 1);
set Var_MontoMaxProtec	:= ifnull((select MontoMaxProtec from PARAMETROSCAJA limit 1),Entero_Cero);

set Var_CliCancel := (select ClienteID from CLIENTESCANCELA where ClienteID = Par_ClienteID and AreaCancela = AreaCancelaPro);
if(ifnull(Var_CliCancel, Entero_Cero) = Entero_Cero) then
	set Par_NumErr  := 06;
	set Par_ErrMen  := 'El safilocale.cliente No Tiene una Solicitud de Cancelación.';
	set Var_Control	:= 'clienteID';
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_ActaDefuncion,Cadena_Vacia))=Cadena_Vacia then
	set Par_NumErr	:=6;
	set Par_ErrMen	:='El Número de Acta de Defuncion se encuentra vacio';
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_FechaDefuncion,FechaVacia))=FechaVacia then
	set Par_NumErr	:=7;
	set Par_ErrMen	:='La Fecha de Defunción se encuentra vacia';
	LEAVE ManejoErrores;
end if;

set Aud_FechaActual := now();

insert into CLIAPLICAPROTEC(
	ClienteID,				FechaRegistro,		UsuarioReg,			UsuarioAut,			FechaAutoriza,
	UsuarioRechaza, 		FechaRechaza,		Estatus, 			Comentario,			MonAplicaCuenta,
	MonAplicaCredito,		ActaDefuncion,		FechaDefuncion,		EmpresaID,			Usuario,
	FechaActual,			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
values (
	Par_ClienteID,			Var_FechaSistema,	Par_UsuarioReg,		Entero_Cero,			FechaVacia,
	Entero_Cero,				FechaVacia,			Est_Registrado,		Cadena_Vacia,		Decimal_Cero,
	Decimal_Cero,			Par_ActaDefuncion,	Par_FechaDefuncion,	Par_EmpresaID,		Aud_Usuario,
	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	set Par_NumErr	:=0;
	set Par_ErrMen	:=concat('Seguro de Proteccion al Ahorro y Credito del safilocale.cliente : ',
						convert(Par_ClienteID,char),', Agregado Exitosamente');
	set Var_Control	:= 'clienteID';
END ManejoErrores;


if (Par_Salida = SalidaSI) then
    select  Par_NumErr	as NumErr,
            Par_ErrMen	as ErrMen,
            Var_Control	as control,
            Entero_Cero as consecutivo;
end if;
END TerminaStore$$