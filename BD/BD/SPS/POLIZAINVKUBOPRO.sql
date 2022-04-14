-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAINVKUBOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAINVKUBOPRO`;
DELIMITER $$


CREATE PROCEDURE `POLIZAINVKUBOPRO`(
	Par_Poliza			bigint,
	Par_Empresa			int,
	Par_Fecha			date,
	Par_FondeoKuboID	bigint,
	Par_NumRetMes		int,
	Par_SucCliente		int,
	Par_ConceptoOpera	int,
	Par_Cargos			decimal(14,4),
	Par_Abonos			decimal(14,4),
	Par_Moneda			int,

	Par_Descripcion		varchar(100),
	Par_Referencia		varchar(50),

out	Par_NumErr			int(11),
out	Par_ErrMen			varchar(400),
out	Par_Consecutivo		bigint,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN


DECLARE	Var_Cuenta			varchar(50);
DECLARE	Var_Instrumento		varchar(20);
DECLARE	Var_CenCosto		int;
DECLARE	Var_Nomenclatura	varchar(30);
DECLARE	Var_NomenclaturaCR	varchar(3);
DECLARE	Var_CuentaMayor		varchar(4);
DECLARE	Var_NomenclaturaSO	int;
DECLARE	Var_NomenclaturaSC	int;
DECLARE	Var_SubCuentaTM		char(2);
DECLARE	Var_SubCuentaTD		char(2);



DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Cuenta_Vacia		char(25);
DECLARE	For_CueMayor		char(3);
DECLARE	For_NumRetMes		char(3);
DECLARE	For_Moneda			char(3);
DECLARE	For_SucOrigen		char(3);
DECLARE	For_SucCliente		char(3);
DECLARE	Salida_NO			char(1);
DECLARE	Procedimiento		varchar(20);
DECLARE TipoInstrumentoID	int(11);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Cuenta_Vacia		:= '0000000000000000000000000';
Set	Entero_Cero			:= 0;

SET	For_CueMayor		:= '&CM';
SET	For_NumRetMes		:= '&TD';
SET	For_Moneda			:= '&TM';

SET	For_SucOrigen		:= '&SO';
SET	For_SucCliente		:= '&SC';

Set	Salida_NO			:= 'N';
set	Procedimiento		:= 'POLIZAINVKUBOPRO';
Set TipoInstrumentoID	:= 13;

set	Var_Cuenta			:= '0000000000000000000000000';
set Var_Instrumento 	:= convert(Par_FondeoKuboID, CHAR);

set Var_CenCosto		:= 0;


select	Nomenclatura, Cuenta, NomenclaturaCR  into
			Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
	from  CUENTASMAYORKUBO Ctm
	where Ctm.ConceptoKuboID	= Par_ConceptoOpera;

set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);

if(Var_Nomenclatura = Cadena_Vacia) then
	set Var_Cuenta := Cuenta_Vacia;
else

	set Var_Cuenta	:= Var_Nomenclatura;


	if LOCATE(For_SucCliente, Var_NomenclaturaCR) > 0 then

		set Var_NomenclaturaSC := Par_SucCliente;
		set Var_NomenclaturaSC = ifnull(Var_NomenclaturaSC, Entero_Cero);

		if (Var_NomenclaturaSC != Entero_Cero) then
			set Var_CenCosto := Var_NomenclaturaSC;
		end if;
	else

		if LOCATE(For_SucOrigen, Var_NomenclaturaCR) > 0 then
			set Var_NomenclaturaSO := Aud_Sucursal;
			if (Var_NomenclaturaSO != Entero_Cero) then
				set Var_CenCosto := Var_NomenclaturaSO;
			end if;

		else
			set Var_CenCosto:=Var_NomenclaturaCR;
		end if;
	end if;



	if LOCATE(For_CueMayor, Var_Cuenta) > 0 then
		set Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
	end if;


	if LOCATE(For_NumRetMes, Var_Cuenta) > 0 then
		select SubCuenta into Var_SubCuentaTD
			from SUBCTAPLAZOKUBO
			where NumRetiros		= Par_NumRetMes
			  and ConceptoKuboID	= Par_ConceptoOpera;

		set Var_SubCuentaTD := ifnull(Var_SubCuentaTD, Cadena_Vacia);

		if (Var_SubCuentaTD != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_NumRetMes, Var_SubCuentaTD);
		end if;

	end if;


	if LOCATE(For_Moneda, Var_Cuenta) > 0 then
		select	SubCuenta into Var_SubCuentaTM
			from  SUBCTAMONEDAKUBO Sub
			where Sub.MonedaID		= Par_Moneda
			  and Sub.ConceptoKuboID	= Par_ConceptoOpera;

		set Var_SubCuentaTM := ifnull(Var_SubCuentaTM, Cadena_Vacia);

		if (Var_SubCuentaTM != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
		end if;

	end if;

end if;

set Var_Cuenta := REPLACE(Var_Cuenta, '-', Cadena_Vacia);

CALL DETALLEPOLIZAALT(
	Par_Empresa,			Par_Poliza,				Par_Fecha, 			Var_CenCosto,		Var_Cuenta,
	Var_Instrumento,		Par_Moneda,				Par_Cargos,			Par_Abonos,			Par_Descripcion,
	Par_Referencia,			Procedimiento,			TipoInstrumentoID,	Cadena_Vacia,		Cadena_Vacia,
	Cadena_Vacia,			Salida_NO, 				Par_NumErr,			Par_ErrMen, 		Aud_Usuario	,
	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

END TerminaStore$$