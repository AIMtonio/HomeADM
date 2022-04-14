-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLICOBROSPROFUNPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLICOBROSPROFUNPRO`;
DELIMITER $$

CREATE PROCEDURE `CLICOBROSPROFUNPRO`(

	Par_ClienteID		int(11),
	Par_FechaOperacion	date,
	Par_Monto			decimal(12,2),
	Par_AltaEncPol      char(1),
	Par_Salida          char(1),

    inout Par_NumErr	int,
    inout Par_ErrMen	varchar(350),
	inout Par_PolizaID	bigint,
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
DECLARE	Entero_Cero			int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE	Fecha_Vacia			date;

DECLARE	Pol_Automatica		char(1);
DECLARE	Nat_Cargo			char(1);
DECLARE	Nat_Abono			char(1);
DECLARE	Est_Registrado		char(1);
DECLARE	Salida_NO			char(1);
DECLARE	Salida_SI			char(1);

DECLARE	AltaEncPolizaNo		char(1);
DECLARE	AltaPolizaAhoSi		char(1);
DECLARE	VarProcedimiento	varchar(20);
DECLARE	VarConcepConta		int;
DECLARE	VarConcepContaAho	int;
DECLARE Act_AplicaCobro		int(11);
DECLARE EstatusActivo		char(1);
DECLARE EstatusInactivo		char(1);
DECLARE ProPROFUNMESPRO		varchar(20);


DECLARE VarSaldoDispon		decimal(12,2);
DECLARE VarMontoProfun		decimal(12,2);
DECLARE VarMonedaID			int(11);
DECLARE VarSucursalCte		int(11);
DECLARE VarSucursalCta		int(11);
DECLARE VarCuentaAhoID		bigint(12);
DECLARE varControl 			varchar(20);

DECLARE VarDescripMovAho	varchar(150);
DECLARE VarCtaContaPROFUN	char(25);
DECLARE VarTipoMovAhoProfun	char(4);
DECLARE TipoInstrumento		int(11);
DECLARE Var_CentroCostosID	int(11);



DECLARE CURSORCLICOBROSPROFUN CURSOR FOR
	SELECT	CA.CuentaAhoID,		CA.SaldoDispon,	CA.MonedaID,	CL.SucursalOrigen,	CA.SucursalID
		FROM	CLIENTESPROFUN	CP,
				CUENTASAHO		CA,
				CLIENTES		CL
		where		CA.ClienteID  		= CP.ClienteID
			and		CA.ClienteID 		= CL.ClienteID
			and		(CP.Estatus			= Est_Registrado
			or		CP.Estatus			= EstatusInactivo)
			and		CA.SaldoDispon	 	> Decimal_Cero
			and		CA.Estatus			= EstatusActivo
			and		CP.ClienteID 		= Par_ClienteID
   order by     CA.TipoCuentaID asc;


Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Decimal_Cero		:= 0.0;
Set	Fecha_Vacia			:= '1900-01-01';
Set	Salida_NO			:= 'N';

Set	Salida_SI			:= 'S';
Set	Pol_Automatica		:= 'A';
Set	Nat_Cargo			:= 'C';
Set	Nat_Abono			:= 'A';
Set	AltaEncPolizaNo		:= 'N';

Set	AltaPolizaAhoSi		:= 'S';
Set	Est_Registrado		:= 'R';
Set	VarProcedimiento	:= 'CLICOBROSPROFUNPRO';
Set ProPROFUNMESPRO	    := 'CLICOBPROFUNMESPRO';
Set VarDescripMovAho	:= 'PAGO MUTUAL PROFUN';

Set VarConcepConta		:= '802';
Set VarConcepContaAho	:= '1';
Set VarTipoMovAhoProfun	:= '26';
Set Act_AplicaCobro		:=  2;
Set EstatusActivo		:= 'A';
Set EstatusInactivo		:= 'I';


Set varControl 			:= 'clienteID' ;


Set VarCtaContaProfun	:= (select CtaContaPROFUN from PARAMETROSCAJA);
Set VarCtaContaProfun	:= ifnull(VarCtaContaProfun, Cadena_Vacia);
Set TipoInstrumento		:=4;
set Var_CentroCostosID	:=0;

ManejoErrores:BEGIN
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = '999';
		SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
								 'estamos trabajando para resolverla. Disculpe las molestias que ',
								 'esto le ocasiona. Ref: SP-CLICOBROSPROFUNPRO');
		SET varControl = 'sqlException' ;
	END;
	if( ifnull(Par_ClienteID,Entero_Cero) <= Entero_Cero)then
		SET Par_NumErr  := 1;
		SET Par_ErrMen  := 'El cliente esta Vacio.';
		SET varControl  := 'clienteID' ;
		LEAVE ManejoErrores;
	end if;

	set VarDescripMovAho	:= (Select Descripcion from CONCEPTOSCONTA WHERE ConceptoContaID = VarConcepConta)  ;

	if(Par_AltaEncPol = AltaPolizaAhoSi )then

		CALL MAESTROPOLIZAALT(
			Par_PolizaID,		Par_EmpresaID,		Par_FechaOperacion,	Pol_Automatica,		VarConcepConta,
			VarDescripMovAho,	Salida_NO, 			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	end if;

	OPEN CURSORCLICOBROSPROFUN;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLO: LOOP

		FETCH CURSORCLICOBROSPROFUN into
			VarCuentaAhoID,		VarSaldoDispon,		VarMonedaID,	VarSucursalCte,	VarSucursalCta;


			 set VarMontoProfun := (select ifnull(MontoPendiente, Decimal_Cero) from CLICOBROSPROFUN where ClienteID = Par_ClienteID);

				if(ifnull(VarMontoProfun,Decimal_Cero) > Decimal_Cero)then
						if (VarSaldoDispon >=  Par_Monto) then
							if( Aud_ProgramaID != ProPROFUNMESPRO)then

								set Aud_Sucursal :=VarSucursalCta;
							end if;

							call CONTAAHORROPRO(
								VarCuentaAhoID,		Par_ClienteID,		Aud_NumTransaccion,		Par_FechaOperacion,	Par_FechaOperacion,
								Nat_Cargo,			Par_Monto,			VarDescripMovAho,	VarCuentaAhoID,		VarTipoMovAhoProfun,
								VarMonedaID,		VarSucursalCte,		AltaEncPolizaNo,	Entero_Cero,		Par_PolizaID,
								AltaPolizaAhoSi,	VarConcepContaAho,	Nat_Cargo,			Par_NumErr,			Par_ErrMen,
								Entero_Cero,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							SET Var_CentroCostosID := FNCENTROCOSTOS(VarSucursalCte);

							call DETALLEPOLIZAALT (
								Par_EmpresaID,		Par_PolizaID,		Par_FechaOperacion,	Var_CentroCostosID,	VarCtaContaProfun,
								Par_ClienteID,		VarMonedaID,		Decimal_Cero,		Par_Monto,			VarDescripMovAho,
								VarCuentaAhoID,		VarProcedimiento,	TipoInstrumento,	Cadena_Vacia,	    Decimal_Cero,
								Cadena_Vacia,    	Salida_NO, 		    Par_NumErr,			Par_ErrMen, 		Aud_Usuario	,
								Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


							call CLICOBROSPROFUNACT(
								Par_ClienteID,		Par_FechaOperacion,	Par_Monto,			Act_AplicaCobro,	Salida_NO,
								Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario	,		Aud_FechaActual,
								Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


							if(Par_NumErr <> Entero_Cero)then
								LEAVE CICLO;
							end if;

							SET Par_NumErr  := 0;
							SET Par_ErrMen  := 'Cobro Realizado Exitosamente.';
							SET varControl  := 'clienteID' ;
							LEAVE CICLO;
						end if;
				end if;
		End LOOP CICLO;
	END;
	CLOSE CURSORCLICOBROSPROFUN;


	if(Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	else
		SET Par_NumErr  := 0;
		SET Par_ErrMen  := 'Cobro Realizado Exitosamente.';
		SET varControl  := 'clienteID' ;
		LEAVE ManejoErrores;
	end if;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen		 AS ErrMen,
			varControl		 AS control,
			Entero_Cero		 AS consecutivo;
end IF;

END TerminaStore$$