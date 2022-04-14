-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ABONOCHEQUESBCALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ABONOCHEQUESBCALT`;DELIMITER $$

CREATE PROCEDURE `ABONOCHEQUESBCALT`(
	Par_CuentaAhoID 		bigint(12),
	Par_ClienteID			int(11),
	Par_NombreReceptor		varchar(200),
	Par_Estatus				char(1),
	Par_Monto				decimal(14,2),

	Par_BancoEmisor			int(11),
	Par_CuentaEmisor		varchar(20),
	Par_NumCheque			bigint(10),
	Par_NombreEmisor		varchar(200),
	Par_SucursalID			int(11),

	Par_CajaID				int(11),
	Par_FechaCobro			date,
	Par_FechaAplicacion		date,
	Par_UsuarioID			int(11),

	Par_NumInstAplica		int(11),
	Par_FormaAplica			char(1),
	Par_CuentaAplica		varchar(20),

	Par_TipoCuentaCheque	char(1),
	Par_FormaCobro			char(1),

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

DECLARE Var_ChequeSBCMovID		int(11);


DECLARE Cadena_Vacia		char(1);
DECLARE Entero_Cero			int;
DECLARE Decimal_Cero		decimal;
DECLARE SalidaSI			char(1);

set Cadena_Vacia		:='';
set Entero_Cero			:=0;
set Decimal_Cero		:=0.0;
set SalidaSI			:='S';

ManejoErrores:BEGIN



DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-ABONOCHEQUESBCALT");
    END;


if(Par_Monto = Decimal_Cero)then
		set	Par_NumErr 	:= 3;
		set	Par_ErrMen	:= "El Monto del Deposito esta Vacio";
		LEAVE ManejoErrores;
end if;

if(Par_BancoEmisor = Entero_Cero)then
		set	Par_NumErr 	:= 4;
		set	Par_ErrMen	:= "El Banco Emisor esta Vacio";
		LEAVE ManejoErrores;
end if;

if(Par_CuentaEmisor = Entero_Cero)then
		set	Par_NumErr 	:= 5;
		set	Par_ErrMen	:= "El Numero de Cuenta del Emisor esta Vacio";
		LEAVE ManejoErrores;
end if;

if(Par_NumCheque = Entero_Cero)then
		set	Par_NumErr 	:= 6;
		set	Par_ErrMen	:= "El Numero de Cheque del Emisor esta Vacio";
		LEAVE ManejoErrores;
end if;
if(Par_FechaCobro = Cadena_Vacia)then
		set	Par_NumErr 	:= 7;
		set	Par_ErrMen	:= "La Fecha del Movimiento esta Vacia";
		LEAVE ManejoErrores;
end if;


if not exists(select CajaID,SucursalID
				from CAJASVENTANILLA
				where SucursalID=Par_SucursalID
				and CajaID= Par_CajaID)then
		set Par_NumErr  := 8;
        set Par_ErrMen  := 'La Caja especificada no existe o pertenece a otra Sucursal';
        LEAVE ManejoErrores;
end if;

if(ifnull(Par_TipoCuentaCheque,Cadena_Vacia ) = Cadena_Vacia )then
		set Par_NumErr  := 9;
        set Par_ErrMen  := 'El Tipo de Cuenta del Cheque se encuentra Vacio';
        LEAVE ManejoErrores;
end if;
if(ifnull(Par_FormaCobro,Cadena_Vacia ) = Cadena_Vacia )then
		set Par_NumErr  := 10;
        set Par_ErrMen  := 'La Forma de Cobro del Cheque se encuentra Vacia';
        LEAVE ManejoErrores;
end if;


call FOLIOSAPLICAACT('ABONOCHEQUESBC', Var_ChequeSBCMovID);
set Aud_FechaActual := CURRENT_TIMESTAMP();

 insert into ABONOCHEQUESBC(
				ChequeSBCID,	CuentaAhoID,	ClienteID,			NombreReceptor,		Estatus,
				Monto,			BancoEmisor,	CuentaEmisor,		NumCheque,			NombreEmisor,
				SucursalID,		CajaID,			FechaCobro,			FechaAplicacion,	UsuarioID,
				NumMovimiento,	NumInstAplica,	FormaAplica,		CuentaAplica,		TipoCtaCheque,
				FormaCobro,		EmpresaID,		Usuario,			FechaActual,		DireccionIP,
				ProgramaID,		Sucursal,		NumTransaccion)
			values(
				Var_ChequeSBCMovID, Par_CuentaAhoID,	Par_ClienteID,		Par_NombreReceptor,	Par_Estatus,
				Par_Monto,			Par_BancoEmisor,	Par_CuentaEmisor,	Par_NumCheque,		Par_NombreEmisor,
				Par_SucursalID,		Par_CajaID,			Par_FechaCobro,		Par_FechaAplicacion,Par_UsuarioID,
				Aud_NumTransaccion,	Par_NumInstAplica,	Par_FormaAplica,	Par_CuentaAplica,	Par_TipoCuentaCheque,
				Par_FormaCobro,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		set	Par_NumErr 	:= 0;
		set	Par_ErrMen	:= "Cheque SBC cobrado exitosamente";

END ManejoErrores;
if (Par_Salida = SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'cuentaAhoID' as control,
			Entero_Cero as consecutivo;
end if;
END  TerminaStore$$