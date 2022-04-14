-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AJUSTEFALTANTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `AJUSTEFALTANTEPRO`;
DELIMITER $$

CREATE PROCEDURE `AJUSTEFALTANTEPRO`(
	Par_Monto				decimal(14,2),
	Par_CajaID				int(11),
	Par_Sucursal			int(11),
	Par_MonedaID			int(11),
	Par_Clave				varchar(45),
	Par_Contrasenia			varchar(45),
	Par_PolizaID			bigint(20),

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

DECLARE Var_Poliza 				bigint(20);
DECLARE Var_FechaSistema		date;
DECLARE Var_Control				varchar(100);
DECLARE Var_CtaContaFaltante	varchar(50);
DECLARE Var_UsuarioID			int(11);
DECLARE Var_Contrasenia			varchar(45);
DECLARE Var_UsuarioLogueado		int(11);
DECLARE Var_MontoMaximoFalta	decimal(12,2);
DECLARE VarControl	   	  		VARCHAR(200);


DECLARE Pol_Automatica		char(1);
DECLARE ConceptoCon			int;
DECLARE DescripcionMov		varchar(100);
DECLARE SalidaNO			char(1);
DECLARE DescripcionMovDet	varchar(100);
DECLARE Programa			varchar(100);
DECLARE SalidaSI			char(1);
DECLARE Entero_Cero			int;
DECLARE Cadena_Vacia		char;
DECLARE Decimal_Cero		decimal;
DECLARE TipoInstrumentoID	int(11);
DECLARE Var_CentroCostosID	int(11);


set Pol_Automatica			:='A';
set ConceptoCon				:= 411;
set DescripcionMov			:='AJUSTE POR FALTANTE';
set SalidaNO				:='N';
set DescripcionMovDet		:='FALTANTES DE EMPLEADOS';
set Programa				:='AJUSTEFALTANTEPRO';
set SalidaSI				:='S';
set Entero_Cero				:=0;
set Cadena_Vacia			:='';
set Decimal_Cero			:=0.0;
Set TipoInstrumentoID		:= 7;
set Var_CentroCostosID		:= 0;


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-AJUSTEFALTANTEPRO');
			SET VarControl = 'sqlException';
		END;



	select  MontoMaximoFalta into Var_MontoMaximoFalta
		from PARAMFALTASOBRA
			where SucursalID = Par_Sucursal;

	select  FechaSistema, CtaContaFaltante
		into Var_FechaSistema, Var_CtaContaFaltante
		from PARAMETROSSIS
			where EmpresaID = Par_EmpresaID;

	select UsuarioID, Contrasenia into Var_UsuarioID, Var_Contrasenia
		from USUARIOS
			where Clave = Par_Clave;

	select UsuarioID into Var_UsuarioLogueado
		from CAJASVENTANILLA
			where CajaID	= Par_CajaID
			and SucursalID  = Par_Sucursal;

	set Var_CtaContaFaltante	:=ifnull(Var_CtaContaFaltante,Cadena_Vacia);
	set Var_Contrasenia			:=ifnull(Var_Contrasenia,Cadena_Vacia);
	set Var_UsuarioID			:=ifnull(Var_UsuarioID,Entero_Cero);
	set Var_UsuarioLogueado		:=ifnull(Var_UsuarioLogueado,Entero_Cero);


	if(ifnull(Par_Clave, Cadena_Vacia) = Cadena_Vacia)then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= concat("La Clave del Usuario que Autoriza se encuentra Vacia ");
		set Var_Control  := 'claveUsuarioAut' ;
		LEAVE ManejoErrores;
	end if;
	if(Var_Contrasenia != Par_Contrasenia)then
		set	Par_NumErr 	:= 2;
		set	Par_ErrMen	:= concat("La Constraseña no Coincide con el Usuario Indicado ");
		set Var_Control  := 'contraseniaAut' ;
		LEAVE ManejoErrores;
	end if;

	if(Var_UsuarioLogueado = Var_UsuarioID)then
		set	Par_NumErr 	:= 3;
		set	Par_ErrMen	:= concat("El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza");
        set Var_Control := 'claveUsuarioAut' ;
        LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_Monto, Decimal_Cero) > ifnull(Var_MontoMaximoFalta, Decimal_Cero) )then
		set	Par_NumErr 	:= 4;
		set	Par_ErrMen	:= concat("Se Excede el Monto Maximo  por Faltante");
        set Var_Control := 'montoFaltante' ;
        LEAVE ManejoErrores;
	end if;

	set Var_CentroCostosID := FNCENTROCOSTOS(Par_Sucursal);

	CALL DETALLEPOLIZAALT(
		Par_EmpresaID,			Par_PolizaID,		Var_FechaSistema,		Var_CentroCostosID,		Var_CtaContaFaltante,
		Var_UsuarioLogueado,	Par_MonedaID,		Par_Monto,				Entero_Cero,			DescripcionMovDet,
		Par_CajaID,				Programa,			TipoInstrumentoID,		Cadena_Vacia,			Decimal_Cero,
		Cadena_Vacia,			SalidaNO,			Par_NumErr,				Par_ErrMen,				Aud_Usuario,
		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		set	Par_NumErr 	:= 0;
		set	Par_ErrMen	:= concat("Ajuste Realizado Correctamente");
        set Var_Control := 'tipoOperacion' ;

END ManejoErrores;
if (Par_Salida = SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			Var_Control as control,
			Par_PolizaID as consecutivo;
end if;


END TerminaStore$$