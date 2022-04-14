-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOPORTUNIDAESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOPORTUNIDAESPRO`;DELIMITER $$

CREATE PROCEDURE `PAGOPORTUNIDAESPRO`(
	Par_Referencia        	varchar(45),
    Par_Monto               decimal(14,2),
	Par_ClienteID			int(11),
	Par_NombreCompleto		varchar(200),
	Par_Direccion			varchar(500),
	Par_NumTelefono			varchar(20),

	Par_TipoIdentiID		int(11),
	Par_FolioIdentific		varchar(45)	,
	Par_FormaPago			char(1),
	Par_NumeroCuenta		bigint(12),

	Par_SucursalID			int(11),
    Par_CajaID              int(11),
    Par_MonedaID            int(11),
	Par_UsuarioID           int(11),

	Par_NumeroMov			bigint,
	Par_AltaEncPoliza		char(1),
	inout Par_Poliza		bigint,
	Par_AltaDetPol			char(1),

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Par_EmpresaID           int(11),
    Aud_Usuario             int(11),
    Aud_FechaActual         datetime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int(11),
    Aud_NumTransaccion      bigint(20)

		)
TerminaStore:BEGIN


DECLARE Var_ReferDetPol			varchar(20);
DECLARE Var_FechaApl			date;
DECLARE Var_FechaOper			date;
DECLARE Var_EsHabil				char(1);
DECLARE Var_SucCliente			int(5);
DECLARE Var_EsMEnorEdad			char(1);



DECLARE SalidaSI			char(1);
DECLARE Entero_Cero			int;
DECLARE Cadena_Vacia		char;
DECLARE NatCargo			char(1);
DECLARE descrpcionMov		varchar(100);
DECLARE ConContaPagoOport 	int(11);
DECLARE ConceptosCaja		int;
DECLARE SalidaNO			char(1);
DECLARE TipoInstrumentoID	int(11);
DECLARE Decimal_Cero		decimal;


set SalidaSI			:='S';
set Entero_Cero			:=0;
set Cadena_Vacia		:='';
set NatCargo			:='C';
set descrpcionMov		:='PAGO DE PROGRAMA OPORTUNIDADES';
set ConContaPagoOport	:=405;
set ConceptosCaja		:=4;
set SalidaNO			:='N';
set TipoInstrumentoID	:=23;
set Decimal_Cero		:=0;

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			set Par_NumErr = 999;
			set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
									 "estamos trabajando para resolverla. Disculpe las molestias que ",
									 "esto le ocasiona. Ref: SP-PAGOPORTUNIDAESPRO");
		END;

set Par_NumErr  := Entero_Cero;
set Par_ErrMen  := Cadena_Vacia;
set Par_NumErr  		:= Entero_Cero;
set Par_ErrMen  		:= Cadena_Vacia;
set Par_ClienteID		:=ifnull(Par_ClienteID,Entero_Cero);
set Par_Referencia		:=ifnull(Par_Referencia, Cadena_Vacia);
set Par_Monto			:=ifnull(Par_Monto,Decimal_Cero );
set Par_NombreCompleto	:= ifnull(Par_NombreCompleto, Cadena_Vacia);
set Par_Direccion		:=ifnull(Par_Direccion, Cadena_Vacia);
set Par_NumTelefono		:=ifnull(Par_NumTelefono, Cadena_Vacia);
set Par_TipoIdentiID	:=ifnull(Par_TipoIdentiID,Entero_Cero );
set Par_FolioIdentific	:=ifnull(Par_FolioIdentific,Cadena_Vacia );
set Par_FormaPago		:=ifnull(Par_FormaPago, Cadena_Vacia);
set Par_NumeroCuenta	:=ifnull(Par_NumeroCuenta, Entero_Cero);
set Par_SucursalID		:=ifnull(Par_SucursalID, Entero_Cero);
set Par_CajaID			:=ifnull(Par_CajaID, Entero_Cero);
set Par_MonedaID		:=ifnull(Par_MonedaID,Entero_Cero );
set Par_UsuarioID		:=ifnull(Par_UsuarioID,Entero_Cero );
set Par_NumeroMov		:=ifnull(Par_NumeroMov,Entero_Cero );
set Par_AltaEncPoliza	:=ifnull(Par_AltaEncPoliza,Cadena_Vacia );
set Par_Poliza			:=ifnull(Par_Poliza,Entero_Cero );
set Par_Salida			:=ifnull(Par_Salida, Cadena_Vacia);

Set Var_FechaOper  := (select FechaSistema
                            from PARAMETROSSIS);


call DIASFESTIVOSCAL(
	Var_FechaOper,		Entero_Cero,		 Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);


	if(Par_ClienteID > Entero_Cero)then
		select  Cli.SucursalOrigen,Cli.EsMenorEdad  into Var_SucCliente, Var_EsMEnorEdad
			from  CLIENTES Cli
			where Cli.ClienteID   = Par_ClienteID;
	end if;
	set Var_SucCliente :=ifnull(Var_SucCliente,Entero_Cero);
	set Var_EsMEnorEdad	:= ifnull(Var_EsMEnorEdad, Cadena_Vacia);

	call PAGOPORTUNIDADESALT(
		Par_Referencia,		Par_Monto,			Par_ClienteID,	Par_NombreCompleto,	Par_Direccion,
		Par_NumTelefono,	Par_TipoIdentiID,	Par_FolioIdentific,	Par_FormaPago,	Par_NumeroCuenta,
		Var_FechaOper,		Par_SucursalID,		Par_CajaID,			Par_MonedaID,	Par_UsuarioID,
		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	if (Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	end if;
	set Var_ReferDetPol	:=ifnull(Par_Referencia,Cadena_Vacia);

	call CONTACAJAPRO(
		Par_NumeroMov,		Var_FechaApl,		Par_Monto,			descrpcionMov,		Par_MonedaID,
		Var_SucCliente,		Par_AltaEncPoliza,	ConContaPagoOport,	Par_Poliza,			Par_AltaDetPol,
		ConceptosCaja,		NatCargo,			Var_ReferDetPol,	Var_ReferDetPol,	Entero_Cero,
		TipoInstrumentoID,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);


	set Par_NumErr := Entero_Cero;
	set Par_ErrMen := "Pago realizado exitosamente.";
END ManejoErrores;
 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'operacionID' as control,
			Par_Poliza as consecutivo;
end if;

END TerminaStore$$