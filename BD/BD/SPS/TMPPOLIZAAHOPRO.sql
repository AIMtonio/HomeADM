-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPOLIZAAHOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPPOLIZAAHOPRO`;DELIMITER $$

CREATE PROCEDURE `TMPPOLIZAAHOPRO`(
	Par_Poliza			bigint,
	Par_Empresa			int,
	Par_Fecha			Date,
	Par_Cliente			int,
	Par_ConceptoOpera	int,
	Par_CuentaID		bigint(12),
	Par_Moneda			int,
	Par_Cargos			Decimal(12,2),
	Par_Abonos			Decimal(12,2),
	Par_Descripcion		varchar(100),
	Par_Referencia		varchar(50),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

DECLARE	Var_TipoPersona		char(1);
DECLARE	Var_TipoCuenta		int;
DECLARE	Var_GeneraInteres	char(1);
DECLARE	Var_NomComple		varchar(100);
DECLARE	Var_Instrumento		varchar(20);
DECLARE Var_Cuenta			varchar(50);
DECLARE Var_CenCosto		int;
DECLARE Var_CuentaComple	char(25);
DECLARE Var_Nomenclatura	varchar(30);
DECLARE Var_NomenclaturaCR	varchar(3);
DECLARE Var_CuentaMayor		varchar(4);
DECLARE	Var_SubCuentaTP		char(6);
DECLARE	Var_SubCuentaTC		char(2);
DECLARE	Var_SubCuentaTR		char(2);
DECLARE	Var_SubCuentaTM		char(2);
DECLARE	Var_NomenclaturaSO	char(2);
DECLARE	Var_NomenclaturaSC	char(2);

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Cuenta_Vacia		char(25);
DECLARE	Per_Fisica			char(1);
DECLARE	Per_Moral			char(1);
DECLARE	Ren_Si				char(1);
DECLARE	Ren_No				char(1);
DECLARE	Procedimiento		varchar(20);
DECLARE	For_CueMayor		char(3);
DECLARE	For_TipProduc		char(3);
DECLARE	For_TipRend			char(3);
DECLARE	For_TipCliente		char(3);
DECLARE	For_Moneda			char(3);
DECLARE	For_SucOrigen		char(3);
DECLARE	For_SucCliente		char(3);
DECLARE	Salida_NO			char(1);

Set	Salida_NO			:= 'N';
Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Cuenta_Vacia		:= '0000000000000000000000000';
Set	Entero_Cero			:= 0;
Set	Per_Fisica			:= 'F';
Set	Per_Moral			:= 'M';
Set	Ren_Si				:= 'S';
Set	Ren_No				:= 'N';
SET	For_CueMayor		:= '&CM';
SET	For_TipProduc		:= '&TP';
SET	For_TipRend			:= '&TR';
SET	For_TipCliente		:= '&TC';
SET	For_Moneda			:= '&TM';
SET	For_SucOrigen		:= '&SO';
SET	For_SucCliente		:= '&SC';
set	Procedimiento		:= 'POLIZAAHORROPRO';
set	Var_Instrumento 	:= convert(Par_CuentaID, CHAR);
set Var_CenCosto		:= 0;


select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
	from  CUENTASMAYORAHO Ctm
	where Ctm.ConceptoAhoID	= Par_ConceptoOpera;

set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);

if(Var_Nomenclatura = Cadena_Vacia) then
	set Var_Cuenta := Cuenta_Vacia;
else

	set Var_Cuenta	:= Var_Nomenclatura;

	select	Tip.TipoCuentaID, Tip.GeneraInteres into Var_TipoCuenta, Var_GeneraInteres
		from  CUENTASAHO Cue,
				TIPOSCUENTAS Tip
		where Cue.CuentaAhoID 	= Par_CuentaID
		  and	Cue.TipoCuentaID	= Tip.TipoCuentaID;

	if LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0 then
		set Var_NomenclaturaSO := (select	SucursalOrigen
						from  CLIENTES
						where	ClienteID 	=	Par_Cliente);
		if (Var_NomenclaturaSO != Cadena_Vacia) then
			set Var_CenCosto := Var_NomenclaturaSO;
		end if;
	else


	if LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0 then
		set Var_NomenclaturaSC := Aud_Sucursal;
		if (Var_NomenclaturaSC != Cadena_Vacia) then
			set Var_CenCosto := Var_NomenclaturaSC;
		end if;

	else
		set Var_CenCosto:=Var_NomenclaturaCR;
	end if;
	end if;


	if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
		set Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
	end if;


	if LOCATE(For_TipProduc, Var_Cuenta) > 0 then
		select	SubCuenta into Var_SubCuentaTP
			from  SUBCTATIPROAHO Sub
			where	Sub.TipoProductoID	= Var_TipoCuenta
			  and	Sub.ConceptoAhoId	= Par_ConceptoOpera;

		set Var_SubCuentaTP := ifnull(Var_SubCuentaTP, Cadena_Vacia);

		if (Var_SubCuentaTP != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_TipProduc, Var_SubCuentaTP);
		end if;

	end if;


	if LOCATE(For_Moneda, Var_Cuenta) > 0 then
		select	SubCuenta into Var_SubCuentaTM
			from  SUBCTAMONEDAAHO Sub
			where	Sub.MonedaID		= Par_Moneda
			  and	Sub.ConceptoAhoId	= Par_ConceptoOpera;

		set Var_SubCuentaTM := ifnull(Var_SubCuentaTM, Cadena_Vacia);

		if (Var_SubCuentaTM != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
		end if;

	end if;


	if LOCATE(For_TipRend, Var_Cuenta) > 0 then

		if Var_GeneraInteres = Ren_Si then
			select	Paga into Var_SubCuentaTR
				from  SUBCTARENDIAHO Sub
				where Sub.ConceptoAhoId	= Par_ConceptoOpera;
		else
			select	NoPaga into Var_SubCuentaTR
				from  SUBCTARENDIAHO Sub
				where Sub.ConceptoAhoId	= Par_ConceptoOpera;
		end if;

		set Var_SubCuentaTR := ifnull(Var_SubCuentaTR, Cadena_Vacia);

		if (Var_SubCuentaTR != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_TipRend, Var_SubCuentaTR);
		end if;

	end if;


	if LOCATE(For_TipCliente, Var_Cuenta) > 0 then

		select	TipoPersona into Var_TipoPersona
			from CLIENTES
			where ClienteID = Par_Cliente;

		if Var_TipoPersona = Per_Fisica then
			select	Fisica into Var_SubCuentaTC
				from  SUBCTATIPERAHO Sub
				where Sub.ConceptoAhoId	= Par_ConceptoOpera;
		else
			select	Moral into Var_SubCuentaTC
				from  SUBCTATIPERAHO Sub
				where Sub.ConceptoAhoId	= Par_ConceptoOpera;
		end if;

		set Var_SubCuentaTC := ifnull(Var_SubCuentaTC, Cadena_Vacia);

		if (Var_SubCuentaTC != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_TipCliente, Var_SubCuentaTC);
		end if;

	end if;


end if;
set Var_Cuenta = REPLACE(Var_Cuenta, '-', Cadena_Vacia);


CALL TMPDETALLEPOLALT (
	Par_Empresa,		Par_Poliza,		Par_Fecha, 			Var_CenCosto,		Var_Cuenta,
	Var_Instrumento,	Par_Moneda,		Par_Cargos,			Par_Abonos,			Par_Descripcion,
	Par_Referencia,		Procedimiento,		Salida_NO, 			Aud_Usuario	,		Aud_FechaActual,		Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

END TerminaStore$$