-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZADIVISAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZADIVISAPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZADIVISAPRO`(
    Par_Poliza          bigint,
    Par_SucursalID      int,
    Par_CajaID          int,
    Par_Empresa         int,
    Par_Fecha           date,
    Par_TipoOpe         char(1),
    Par_ConceptoOpera   int,
    Par_MonedaID        int,
    Par_Cargos          decimal(12,2),
    Par_Abonos          decimal(12,2),
    Par_Instrumento     varchar(20),
    Par_Descripcion     varchar(150),
    Par_Referencia      varchar(200),
	Par_SucursalCte		int(11),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Procedimiento       varchar(20);
DECLARE Var_Cuenta          char(50);
DECLARE Var_CentroCostosID  int(11);
DECLARE Var_Nomenclatura    varchar(30);
DECLARE Var_NomenclaturaCR  varchar(3);
DECLARE Var_NomenclaturaSO	int;
DECLARE Var_CuentaMayor		varchar(10);
DECLARE Var_SubCuentaTM		varchar(15);
DECLARE Var_SubCuentaTP		varchar(15);
DECLARE Var_SubBillete		varchar(15);
DECLARE Var_SubMoneda       varchar(15);
DECLARE Var_SubCuentaSuc    varchar(15);
DECLARE Var_SubCuentaCaja   varchar(15);
DECLARE Var_SubCuentaTipo   varchar(15);
DECLARE Var_TipoCaja        char(2);
DECLARE Var_TipoInstrumentoID	int(11);
DECLARE Var_NomenclaturaSC	int(11);


DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Tipo_Moneda     char(1);
DECLARE Tipo_Billete    char(1);
DECLARE For_CueMayor    char(3);
DECLARE For_Moneda      char(3);
DECLARE For_Tipo        char(3);
DECLARE For_TipoCaja    char(3);
DECLARE For_Cajero      char(3);
DECLARE For_Sucursal    char(3);
DECLARE For_SucOrigen   char(3);
DECLARE	For_SucCliente		char(3);
DECLARE Salida_NO       char(1);
DECLARE Cuenta_Vacia    char(25);

DECLARE Caja_Principal  char(2);
DECLARE Caja_Atencion   char(2);
DECLARE Caja_Boveda     char(2);
DECLARE	Par_NumErr 		int;
DECLARE Par_ErrMen  	varchar(400);
DECLARE Decimal_Cero	decimal(18,2);


set Cadena_Vacia    := '';
set Fecha_Vacia     := '1900-01-01';
set Entero_Cero     := 0;
set Tipo_Moneda     := 'M';
set Tipo_Billete    := 'B';
set For_CueMayor    := '&CM';
set For_Moneda      := '&TM';
set For_Tipo        := '&TP';
set For_TipoCaja    := '&TC';
set For_Cajero      := '&CA';
set For_Sucursal    := '&SU';
set For_SucOrigen   := '&SO';
set	For_SucCliente	:= '&SC';
set Caja_Principal  := 'CP';
set Caja_Atencion   := 'CA';
set Caja_Boveda     := 'BG';

set Salida_NO       := 'N';
set Cuenta_Vacia    := '0000000000000000000000000';
set Decimal_Cero	:= 0.0;

set	Procedimiento	:= 'POLIZADIVISAPRO';
set	Var_Cuenta		:= Cuenta_Vacia;
set Var_TipoInstrumentoID	:=15;


select	Nomenclatura, Cuenta, NomenclaturaCR  into Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
	from  CUENTASMAYORMON Ctm
	where Ctm.ConceptoMonID	= Par_ConceptoOpera;

set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);

if(Var_Nomenclatura = Cadena_Vacia) then
	set Var_Cuenta := Cuenta_Vacia;
else
	set Var_Cuenta	:= Var_Nomenclatura;

	if LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero then
		set Var_NomenclaturaSO := Aud_Sucursal;
		if (Var_NomenclaturaSO != Entero_Cero) then
			set Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
		end if;
	else
		if LOCATE(For_SucCliente, Var_NomenclaturaCR) > Entero_Cero then
					 set Var_NomenclaturaSC := Par_SucursalCte;
					if (Var_NomenclaturaSC != Entero_Cero ) then
						set Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSC);
					else
						set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
					end if;
		else
			set Var_CentroCostosID:= FNCENTROCOSTOS(Aud_Sucursal);
		end if;
	 end if;


	if LOCATE(For_CueMayor, Var_Cuenta) > Entero_Cero then
		set Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
	end if;



	if LOCATE(For_Moneda, Var_Cuenta) > Entero_Cero then
		select	SubCuenta into Var_SubCuentaTM
			from  SUBCTAMONEDADIV Sub
			where	Sub.MonedaID		= Par_MonedaID
			  and	Sub.ConceptoMonID	= Par_ConceptoOpera;

		set Var_SubCuentaTM := ifnull(Var_SubCuentaTM, Cadena_Vacia);

		if (Var_SubCuentaTM != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
		end if;

	end if;


	if LOCATE(For_Tipo, Var_Cuenta) > Entero_Cero then
		select	Billetes, Monedas into Var_SubBillete, Var_SubMoneda
			from  SUBCTATIPODIV Sub
			where	Sub.ConceptoMonID	= Par_ConceptoOpera;

		if(Par_TipoOpe = Tipo_Moneda) then
			set	Var_SubCuentaTP := Var_SubMoneda;
		elseif (Par_TipoOpe = Tipo_Billete) then
			set	Var_SubCuentaTP := Var_SubBillete;
		else
			set	Var_SubCuentaTP := Cadena_Vacia;
		end if;

		set Var_SubCuentaTP := ifnull(Var_SubCuentaTP, Cadena_Vacia);

		if (Var_SubCuentaTP != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_Tipo, Var_SubCuentaTP);
		end if;

	end if;


    if LOCATE(For_Sucursal, Var_Cuenta) > Entero_Cero then
        select	SubCuenta into Var_SubCuentaSuc
            from  SUBCTASUCURSDIV Sub
            where	Sub.SucursalID		= Par_SucursalID
              and	Sub.ConceptoMonID	= Par_ConceptoOpera;

		set Var_SubCuentaSuc := ifnull(Var_SubCuentaSuc, Cadena_Vacia);

		if (Var_SubCuentaSuc != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_Sucursal, Var_SubCuentaSuc);
		end if;

	end if;


    if LOCATE(For_Cajero, Var_Cuenta) > Entero_Cero then
        select	SubCuenta into Var_SubCuentaCaja
            from  SUBCTACAJERODIV Sub
            where Sub.CajaID        = Par_CajaID
              and Sub.ConceptoMonID = Par_ConceptoOpera;

		set Var_SubCuentaCaja := ifnull(Var_SubCuentaCaja, Cadena_Vacia);

		if (Var_SubCuentaCaja != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_Cajero, Var_SubCuentaCaja);
		end if;

	end if;


    if LOCATE(For_TipoCaja, Var_Cuenta) > Entero_Cero then

        select	TipoCaja into Var_TipoCaja
            from  CAJASVENTANILLA Sub
            where Sub.CajaID        = Par_CajaID
              and Sub.SucursalID    = Par_SucursalID;

        set Var_TipoCaja    := ifnull(Var_TipoCaja, Cadena_Vacia);

        select	SubCuenta into Var_SubCuentaTipo
            from  SUBCTATIPCAJADIV Sub
            where Sub.TipoCaja      = Var_TipoCaja
              and Sub.ConceptoMonID = Par_ConceptoOpera;

        set Var_SubCuentaTipo := ifnull(Var_SubCuentaTipo, Cadena_Vacia);

		if (Var_SubCuentaTipo != Cadena_Vacia) then
			set Var_Cuenta := REPLACE(Var_Cuenta, For_TipoCaja, Var_SubCuentaTipo);
		end if;

	end if;

end if;

set Var_Cuenta = REPLACE(Var_Cuenta, '-', Cadena_Vacia);

CALL DETALLEPOLIZAALT(
	Par_Empresa,			Par_Poliza,			Par_Fecha, 				Var_CentroCostosID,	Var_Cuenta,
	Par_Instrumento,		Par_MonedaID,		Par_Cargos,				Par_Abonos,			Par_Descripcion,
	Par_Referencia,			Procedimiento,		Var_TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
	Cadena_Vacia,			Salida_NO, 			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


END TerminaStore$$