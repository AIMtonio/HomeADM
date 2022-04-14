-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOSERVICIOWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOSERVICIOWSPRO`;DELIMITER $$

CREATE PROCEDURE `PAGOSERVICIOWSPRO`(
Par_CatalogoServID	int(11),
Par_SucursalID		int(11),
Par_Referencia		varchar(200),
Par_SegundaRefe		varchar(200),
Par_MontoServicio	decimal(14,2),

Par_IvaServicio		decimal(14,2),
Par_Comision		decimal(14,2),
Par_IVAComision		decimal(14,2),
Par_Total			decimal(14,2),
Par_ClienteID		int(11),

Par_CuentaAhoID		bigint,

Par_Salida			char(1),
inout Par_NumErr	int,
inout Par_ErrMen	varchar(350),
Par_EmpresaID		int,
Aud_Usuario			int,

Aud_FechaActual		DateTime,
Aud_DireccionIP		varchar(15),
Aud_ProgramaID		varchar(50),
Aud_Sucursal		int,
Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia		char(1);
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE	Fecha_Vacia		date;
DECLARE Salida_SI 		char(1);
DECLARE Salida_NO 		char(1);
DECLARE Con_AltaPagoServ	char(1);
DECLARE Con_AltaEncPol 		char(1);
DECLARE Con_AltaDetPol		char(1);
DECLARE Con_NatDetPolAbono	char(1);
DECLARE Con_NatMovi		char(1);
DECLARE Con_AltaEncPolNO	char(1);
DECLARE Con_PagoServicio	int(11);
DECLARE Con_ReferenciaMov	int(11);
DECLARE Con_NatCargo		char(1);
DECLARE Con_ConceptoAho		int;
DECLARE Con_EsBancaElect	char(1);


DECLARE Var_FechaSistema	date;
DECLARE Var_MonedaID		int(11);
DECLARE Var_SucurCliente	int(11);
DECLARE Var_Poliza		char(100);
DECLARE Var_NombreServicio	char(100);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero		:= 0.0;
Set Salida_SI			:= 'S';
Set Salida_NO			:= 'N';
Set Con_AltaPagoServ		:= 'S';
Set Con_AltaEncPol 		:= 'S';
Set Con_AltaEncPolNO		:= 'N';
Set Con_AltaDetPol		:= 'S';
Set Con_NatDetPolAbono		:= 'A';
Set Con_NatMovi			:= 'C';
Set Con_PagoServicio		:= 223;
Set Con_ReferenciaMov		:= 1;
Set Con_NatCargo		:= 'C';
Set Con_ConceptoAho		:= 1;
set Con_EsBancaElect		:= 'B';


Set Var_FechaSistema		:= '';
Set Var_MonedaID		:= '';
Set Var_SucurCliente		:= 0;
Set Var_Poliza			:= '';
Set Var_NombreServicio		:= '';

if(ifnull(Par_CatalogoServID, Entero_Cero))= Entero_Cero then
	select '001' as NumErr,
		 'El Numero de Catalogo esta vacio.' as ErrMen,
		 'catalogoServID' as control,
			 0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_SucursalID, Entero_Cero))= Entero_Cero then
	select '002' as NumErr,
		 'La sucursal esta vacia.' as ErrMen,
		 'cuentaOrigen' as control,
			 0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Referencia, Cadena_Vacia))= Cadena_Vacia then
	select '003' as NumErr,
		 'La Referencia esta vacia.' as ErrMen,
		 'referenciaPagoServicio' as control,
			 0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_MontoServicio, Entero_Cero))= Entero_Cero then
	select '004' as NumErr,
		 'El Monto del Pago esta vacio.' as ErrMen,
		 'montoPagoServicio' as control,
			 0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_ClienteID, Entero_Cero))= Entero_Cero then
	select '005' as NumErr,
		 'El numero de Cliente no existe.' as ErrMen,
		 'cuentaOrigen' as control,
			 0 as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
	select '006' as NumErr,
		 'La Cuenta de Ahorro no existe.' as ErrMen,
		 'cuentaOrigen' as control,
			 0 as consecutivo;
	LEAVE TerminaStore;
end if;

select FechaSistema,MonedaBaseID into Var_FechaSistema,Var_MonedaID
	from PARAMETROSSIS;
Set Aud_FechaActual := CURRENT_TIMESTAMP();
CALL CONTAPAGOSERVPRO(
	Par_CatalogoServID,		Entero_Cero,		Par_SucursalID,		Entero_Cero,
	Var_FechaSistema,		Par_Referencia,		Par_SegundaRefe,	Var_MonedaID,
	Par_MontoServicio,		Par_IvaServicio,	Par_Comision,		Par_IVAComision,
	Par_Total,				Par_ClienteID,		Entero_Cero,		Entero_Cero,
	Con_AltaPagoServ,		Con_AltaEncPol,		Con_AltaDetPol,		Con_NatDetPolAbono,
	Con_EsBancaElect,			Salida_NO,			Var_Poliza,			Par_NumErr,
	Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
);

set Var_NombreServicio := (Select NombreServicio
							from CATALOGOSERV
							where CatalogoServID = Par_CatalogoServID);

set Var_NombreServicio := concat('PAGO DE SERVICIOS-',Var_NombreServicio);

set Var_SucurCliente   := (select Sucursal
							from CLIENTES
							where ClienteID = Par_ClienteID);
CALL CONTAAHORROPRO(
	Par_CuentaAhoID,		Par_ClienteID,		Aud_NumTransaccion,	Var_FechaSistema,
	Var_FechaSistema,		Con_NatMovi,		Par_Total,			Var_NombreServicio,
	Par_Referencia,			Con_PagoServicio,	Var_MonedaID,		Var_SucurCliente,
	Con_AltaEncPolNO,		Entero_Cero,		Var_Poliza,			Con_AltaDetPol,
	Con_ConceptoAho,		Con_NatCargo,		Par_NumErr,			Par_ErrMen,
	Entero_Cero,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
);
select 	'000' as NumErr,
	concat('Servicio Pagado Exitosamente') as ErrMen,
	'cuentaOrigen' as control,
	Var_Poliza as consecutivo;
LEAVE TerminaStore;
END TerminaStore$$