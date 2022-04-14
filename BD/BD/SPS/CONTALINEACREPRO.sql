-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTALINEACREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTALINEACREPRO`;DELIMITER $$

CREATE PROCEDURE `CONTALINEACREPRO`(
	/* SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO*/
    Par_LineaCreditoID	bigint,			/* Indica el numero de Linea de Credito*/
    Par_ClienteID       bigint,			/* Cliente del credito*/
    Par_FechaOperacion  date,			/* Fecha de Operacion*/
    Par_FechaAplicacion date,			/* Fecha de Aplicacion */
    Par_Monto           decimal(14,4),	/* Monto	*/

	Par_MonedaID        int,			/* moneda */
    Par_ProdCreditoID   int,			/* producto del credito*/
    Par_SucursalID      int,			/* Sucursal de LA LINEA DE CREDITO*/
	Par_Descripcion     varchar(100),
    Par_Referencia      varchar(50),

	Par_AltaEncPoliza   char(1), 		/* Indica si da de alta el Encabezado de la poliza (POLIZACONTABLE) SI = S*/
    Par_ConceptoCon     int,			/* Indica el Concepto para el encabezado o detalle de la poliza tabla :CONCEPTOSCONTA */
    Par_AltaPoliza 		char(1), 		/* Indica si da de alta detalles de poliza de linea de credito  S= SI*/
    Par_AltaMovAho      char(1), 		/* Indica si da de alta movimientos de linea de credito  S= SI*/
    Par_ConcConta 		int,			/* Indica el concepto contable para la linea de crédito tabla: CUENTASMAYORCAR*/

    Par_TipoMovAho		VARCHAR(4),	/* Tipo Movimiento de Ahorro */
    Par_NatContable		char(1),		/* Indica si es CARGO (C) O ABONO (A) */
	Par_NatLinea		char(1),		/* Indica si es CARGO (C) O ABONO (A) */
inout	Par_NumErr		int,
inout	Par_ErrMen		varchar(400),

inout	Par_PolizaID	bigint,
	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),

	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_Cargos  decimal(14,4);
DECLARE Var_Abonos  decimal(14,4);
DECLARE Var_LineaCreStr  varchar(20);
DECLARE Var_CuentaAhoID	 BIGINT(20);		-- Identificador de la cuenta de ahorro
DECLARE Var_CuentaStr	VARCHAR(100); 		-- Cuenta de Ahorro en formato String
DECLARE Var_CreditoStr	VARCHAR(100);		-- Identificador de crédito en formato String

/* Declaracion de Constantes */
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(12, 2);
DECLARE AltaPoliza_SI   char(1);
DECLARE AltaPolLinSI   char(1);
DECLARE Nat_Cargo       char(1);
DECLARE Nat_Abono       char(1);
DECLARE Pol_Automatica  char(1);
DECLARE Salida_NO       char(1);
DECLARE AltaMovsAho	CHAR(1);		-- Contante Alta de Movimiento de Ahorro: S
DECLARE Con_AhoCapital  INT;			-- Número de Concepto de Ahorro

/* Asignacion de Constantes */
Set Cadena_Vacia	:= '';
Set Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero		:= 0;
Set Decimal_Cero	:= 0.00;
Set AltaPoliza_SI	:= 'S';
Set AltaPolLinSI	:= 'S';
Set Nat_Cargo		:= 'C';
Set Nat_Abono		:= 'A';
Set Pol_Automatica	:= 'A';
Set Salida_NO		:= 'N';
SET AltaMovsAho		:= 'S';			-- Si Alta de Mocimiento de Ahorro
SET Con_AhoCapital 	:= 1;			-- Número de Concepto de Ahorro

Set Var_LineaCreStr	:= concat("Lin.Cre",convert(Par_LineaCreditoID, char(20)));
Set Aud_FechaActual	:= now();

/*- Da de alta el encabezado de la poliza  */
if (Par_AltaEncPoliza = AltaPoliza_SI) then
	CALL MAESTROPOLIZAALT(
		Par_PolizaID,		Par_EmpresaID,	Par_FechaAplicacion, 	Pol_Automatica,		Par_ConceptoCon,
		Par_Descripcion,	Salida_NO,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
end if;


/* DA DE ALTA EL DETALLE DE POLIZA */
if (Par_AltaPoliza = AltaPolLinSI) then
	if(Par_NatContable	= Nat_Cargo) then
		set	Var_Cargos	:= Par_Monto;
		set	Var_Abonos	:= Decimal_Cero;
	else
		set	Var_Cargos	:= Decimal_Cero;
		set	Var_Abonos	:= Par_Monto;
	end if;

    call POLIZALINEACREPRO(
        Par_PolizaID,		Par_EmpresaID,		Par_FechaAplicacion,    Par_LineaCreditoID,	Par_ProdCreditoID,
        Par_ConcConta,		Var_Cargos,			Var_Abonos,         	Par_MonedaID,       Par_Descripcion,
		Var_LineaCreStr,	Par_SucursalID,		Par_NumErr,				Par_ErrMen,         Aud_Usuario,
        Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
end if;

IF(Par_AltaMovAho=AltaMovsAho)THEN

	SELECT CuentaID
		INTO Var_CuentaAhoID
    FROM LINEASCREDITO
    WHERE LineaCreditoID=Par_LineaCreditoID;

    SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);
    SET Var_CreditoStr := CONVERT(Par_LineaCreditoID,CHAR);

	IF(Par_NatLinea = Nat_Cargo) THEN
		SET	Var_Cargos	:= Par_Monto;
		SET	Var_Abonos	:= Decimal_Cero;
	ELSE
		SET	Var_Cargos	:= Decimal_Cero;
		SET	Var_Abonos	:= Par_Monto;
	END IF;

	CALL CUENTASAHOMOVALT(
		Var_CuentaAhoID, 	Aud_NumTransaccion, 	Par_FechaAplicacion, 		Par_NatLinea, 		Par_Monto,
		Par_Descripcion,	Var_CreditoStr,			Par_TipoMovAho,				Par_EmpresaID, 		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion);


	CALL POLIZAAHORROPRO(
		Par_PolizaID,		Par_EmpresaID,		Par_FechaAplicacion, 		Par_ClienteID,		Con_AhoCapital,
		Var_CuentaAhoID,	Par_MonedaID,		Var_Cargos,					Var_Abonos,			Par_Descripcion,
		Var_CuentaStr,		Aud_Usuario,		Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);
END IF;

END TerminaStore$$