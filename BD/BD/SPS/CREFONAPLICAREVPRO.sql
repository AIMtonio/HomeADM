-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREFONAPLICAREVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREFONAPLICAREVPRO`;
DELIMITER $$

CREATE PROCEDURE `CREFONAPLICAREVPRO`(
	/* SP para aplicar la revolvencia en el credito Pasivo*/

	Par_LineaFondeoID   int(11),		/* Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR */
	Par_Monto	    	decimal(12, 2)	/* Monto Pagado de capital */ ,
	Par_MonedaID		int,			/*Identificador de la moneda*/
	Par_InstitutFondID	int(11),		/* id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO*/
	Par_FechaOperacion	date,			/* Fecha de la operacion */

	Par_CreditoFonID	bigint(20),		/* ID del credito Pasivo*/
	Par_PolizaID		bigint(20),		/* ID de la poliza contable Pasivo*/
	Par_Salida			char(1),
	inout Var_Poliza	bigint,
	out	Par_NumErr		int,
	out	Par_ErrMen		varchar(400),

	out	Par_Consecutivo	bigint,
	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),

	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_TipoFondeador   char(1);

/* Declaracion de Constantes*/
DECLARE Cadena_Vacia    	char(1);
DECLARE Fecha_Vacia     	date;
DECLARE Entero_Cero     	int;
DECLARE Decimal_Cero    	decimal(12,2);
DECLARE Var_SI				char(1);

DECLARE Var_NO				char(1);
DECLARE Var_CtaOrdCar		int(11);		/* Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO*/
DECLARE Var_CtaOrdAbo		int(11);		/* Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO*/
DECLARE Nat_Cargo       	char(1);			/* Naturaleza de Cargo*/
DECLARE Nat_Abono     	 	char(1);			/* Naturaleza de Abono*/

DECLARE Par_SalidaNO    	char(1);
DECLARE Par_SalidaSI    	char(1);
DECLARE AltaPoliza_NO   	char(1);
DECLARE Var_Descripcion		varchar(100);	/* descripcion para los movimientos de credito pasivo*/
DECLARE Var_AfectacionConta char(1);


-- Asignacion de Constantes
Set Cadena_Vacia	:= '';				-- String Vacio
Set Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
Set Entero_Cero		:= 0;				-- Entero en Cero
Set Decimal_Cero	:= 0.00;			  -- Decimal Cero
Set Var_SI			:= 'S';				/* Valor SI */

Set Var_NO			:= 'N';				/* Valor NO */
set Var_CtaOrdCar	:= 11;		/* Cta. Orden Contingente (Cargo) con la tabla CONCEPTOSFONDEO*/
set Var_CtaOrdAbo	:= 12;		/* Cta. Orden Correlativa (Abono) con la tabla CONCEPTOSFONDEO*/
Set Nat_Cargo       := 'C';			   -- Naturaleza de Cargo
Set Nat_Abono       := 'A';			   -- Naturaleza de Abono.

Set Par_SalidaNO	:= 'N';				-- Ejecutar Store sin Regreso o Mensaje de Salida
Set Par_SalidaSI	:= 'S';				  -- Ejecutar Store Con Regreso o Mensaje de Salida
Set AltaPoliza_NO   := 'N';				-- Alta de la Poliza Contable: NO
Set Var_Descripcion	:= 'PAGO DE CREDITO PASIVO';  /* descripcion para los movimientos de credito pasivo*/


-- Inicializaciones
select  TipoFondeador into Var_TipoFondeador
    from CREDITOFONDEO
    where CreditoFondeoID = Par_CreditoFonID;

set Var_TipoFondeador   := ifnull(Var_TipoFondeador, Cadena_Vacia);


/*Se actualiza el saldo de la linea de fondeo*/
call SALDOSLINEAFONACT(
	Par_LineaFondeoID,	Nat_Abono,			Par_Monto,			Par_SalidaNO,			Par_NumErr,
	Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

if(Par_NumErr = Entero_Cero) then
	set Par_NumErr	:= 0;
else
	LEAVE TerminaStore;
end if;

select AfectacionConta into Var_AfectacionConta from LINEAFONDEADOR
     where  	LineaFondeoID = Par_LineaFondeoID and  InstitutFondID= Par_InstitutFondID;

/*se manda a llamar al sp para aplicar los movmientos contables de cuentas de orden*/
if(Var_AfectacionConta = Var_SI) then

/* Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
	contingente (Cargo)*/
call CONTAFONDEOPRO(
    Par_MonedaID,       Par_LineaFondeoID,  Par_InstitutFondID, Entero_Cero,    Cadena_Vacia,
    Entero_Cero,        Cadena_Vacia,       Entero_Cero,        Cadena_Vacia,   Var_CtaOrdCar,
    Var_Descripcion,    Fecha_Vacia,        Par_FechaOperacion, Fecha_Vacia,    Par_Monto,
    convert(Par_CreditoFonID,char), convert(Par_LineaFondeoID,char),
    AltaPoliza_NO,      Entero_Cero,        Nat_Abono,          Cadena_Vacia,   Cadena_Vacia,
    Cadena_Vacia,       Var_NO,             Cadena_Vacia,       Var_NO,         Entero_Cero,
    Entero_Cero,        Var_SI,             Var_TipoFondeador,  Par_SalidaNO,   Par_PolizaID,
    Par_Consecutivo,    Par_NumErr,         Par_ErrMen,         Par_EmpresaID,  Aud_Usuario,
    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion  );

if(Par_NumErr = Entero_Cero) then
	set Par_NumErr	:= 0;
else
	LEAVE TerminaStore;
end if;

/* Se manda a llamar sp para hacer la parte contable que corresponde con la cuenta de orden
	correlativa (Abono)*/
call CONTAFONDEOPRO(
    Par_MonedaID,       Par_LineaFondeoID,  Par_InstitutFondID, Entero_Cero,    Cadena_Vacia,
    Entero_Cero,        Cadena_Vacia,       Entero_Cero,        Cadena_Vacia,   Var_CtaOrdAbo,
    Var_Descripcion,    Fecha_Vacia,        Par_FechaOperacion, Fecha_Vacia,    Par_Monto,
    convert(Par_CreditoFonID,char), convert(Par_LineaFondeoID,char),
    AltaPoliza_NO,      Entero_Cero,        Nat_Cargo,          Cadena_Vacia,   Cadena_Vacia,
    Cadena_Vacia,       Var_NO,             Cadena_Vacia,       Var_NO,         Entero_Cero,
    Entero_Cero,        Var_SI,             Var_TipoFondeador,  Par_SalidaNO,   Par_PolizaID,
    Par_Consecutivo,    Par_NumErr,         Par_ErrMen,         Par_EmpresaID,  Aud_Usuario,
    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion  );

if(Par_NumErr = Entero_Cero) then
	set Par_NumErr	:= 0;
else
	LEAVE TerminaStore;
end if;

end if;

if (Par_Salida = Par_SalidaSI) then
	select 	Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'creditoFondeoID' as control,
			0 as consecutivo;
end if;

END TerminaStore$$