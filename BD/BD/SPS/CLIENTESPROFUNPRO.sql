-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESPROFUNPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESPROFUNPRO`;
DELIMITER $$

CREATE PROCEDURE `CLIENTESPROFUNPRO`(




	Par_FechaOperacion	date,
	Par_FechaAplicacion	date,
	Par_Salida          char(1),
    inout	Par_NumErr	int,
    inout	Par_ErrMen  varchar(350),

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
DECLARE	Var_NoAplicado		char(1);

DECLARE	Pol_Automatica		char(1);
DECLARE	Nat_Cargo			char(1);
DECLARE	Nat_Abono			char(1);
DECLARE	Est_Registrado		char(1);
DECLARE	Salida_NO			char(1);

DECLARE	Salida_SI			char(1);
DECLARE	Est_Pagado			char(1);
DECLARE	AltaEncPolizaSi		char(1);
DECLARE	AltaEncPolizaNo		char(1);
DECLARE	AltaPolizaAhoSi		char(1);

DECLARE	Var_TipMovProfun	char(4);
DECLARE	DesConcepConta		varchar(150);
DECLARE Act_MutualSoc		INT;
DECLARE Act_RegistroCob		int(11);


DECLARE Var_ApoMaxPROFUN	decimal(14,2);
DECLARE Var_MontoPROFUN		decimal(14,2);
DECLARE VarMontoApl			decimal(14,2);
DECLARE VarMontoMutual		decimal(14,2);

DECLARE VarCantidadMov		decimal(14,2);
DECLARE VarCargoPend		decimal(14,2);
DECLARE VarMontoAplicaTot	decimal(14,2);
DECLARE VarMontoRecibir		decimal(14,2);
DECLARE Var_Cargos			decimal(12,2);

DECLARE Var_Abonos			decimal(12,2);
DECLARE VarCliSolApl		int(11);
DECLARE VarCliProfun		int(11);
DECLARE VarCliente			int(11);

DECLARE	VarNumSocios		int(11);
DECLARE	VarNumAplicaPro		int(11);
DECLARE VarSucursalCte		int(11);
DECLARE VarContador			int(11);

DECLARE Var_CenCosto		int(11);
DECLARE	VarConcepConta		int;
DECLARE Var_MonedaID		int(11);
DECLARE	Pro_Profun			int;
DECLARE Var_Consecutivo		bigint;

DECLARE Var_Poliza			bigint;
DECLARE varControl 			varchar(20);
DECLARE VarDescripMovAho	varchar(150);
DECLARE	VarProcedimiento	varchar(20);
DECLARE VarDescripMov		varchar(150);

DECLARE VarHaberExSocios	varchar(25);
DECLARE Var_Instrumento		varchar(20);
DECLARE VarCtaContaPROFUN	char(25);
DECLARE VarAltaEncPoliza	char(1);
DECLARE Var_FechaBatch		date;
DECLARE TipoInstrumento		int(11);
DECLARE Var_CentroCostosID	int(11);


DECLARE CURSORCLIAPLICAPROFUN CURSOR FOR
	SELECT	ClienteID
		FROM CLIAPLICAPROFUN
		where	Estatus			= 'A'
		and 	AplicadoSocios	= 'N';



DECLARE CURSORCLIENTESPROFUN CURSOR FOR
	SELECT	CP.ClienteID,		CL.SucursalOrigen
		FROM	CLIENTESPROFUN	CP,
				CLIENTES		CL
		where	CP.Estatus		= 'R'
		and		CP.ClienteID	= CL.ClienteID
		and 	CP.ClienteID	not in (select  ClienteID from CLIENTESCANCELA WHERE AreaCancela = 'Pro');



Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Decimal_Cero		:= 0.0;
Set	Fecha_Vacia			:= '1900-01-01';
Set	Salida_NO			:= 'N';
Set	Salida_SI			:= 'S';

Set	Var_NoAplicado		:= 'N';
Set	Pol_Automatica		:= 'A';
Set	Nat_Cargo			:= 'C';
Set	Nat_Abono			:= 'A';
Set	AltaEncPolizaSi		:= 'S';

Set	AltaEncPolizaNo		:= 'N';
Set	AltaPolizaAhoSi		:= 'S';
Set	Est_Registrado		:= 'R';
Set	Est_Pagado			:= 'P';
Set Aud_ProgramaID		:= 'CLIENTESPROFUNPRO';

Set	VarProcedimiento	:= 'CLIENTESPROFUNPRO';
Set VarDescripMovAho	:= 'APORTACION PROFUN';
Set Var_TipMovProfun	:= '26' ;
Set VarConcepConta		:= '804';


SET Act_MutualSoc		:= 1;



Set	varControl			:= '';
Set VarContador			:= 0;
set Var_Consecutivo		:= 0;
Set Var_CenCosto		:= Aud_Usuario;
Set VarNumSocios		:= 0;
Set VarNumAplicaPro		:= 0;
Set Var_ApoMaxPROFUN	:= 0;
Set Var_MontoPROFUN		:= 0;
Set VarMontoAplicaTot	:= 0;
Set VarMontoMutual		:= 0;
Set VarCtaContaPROFUN	:= '';
Set Par_NumErr			:= 0;
Set Par_ErrMen			:= '';
Set Act_RegistroCob		:= 1;
set	Pro_Profun			:= 407;
set TipoInstrumento		:=4;
set Var_CentroCostosID	:=0;

select Fecha into Var_FechaBatch
	from BITACORABATCH
	where Fecha 			= Par_FechaOperacion
	  and ProcesoBatchID	= Pro_Profun;

set Var_FechaBatch := ifnull(Var_FechaBatch, Fecha_Vacia);


if Var_FechaBatch != Fecha_Vacia then
	LEAVE TerminaStore;
end if;


drop table if exists tmp_CLIENTESMUTALPROFUN;
create table tmp_CLIENTESMUTALPROFUN (	ClienteID		int,
										SucursalCte		int,
										Estatus			char(1),
										Primary Key (ClienteID),
										INDEX `idxEstatus` (`Estatus` ASC));



insert into tmp_CLIENTESMUTALPROFUN
	SELECT	Mut.ClienteID,		Cli.SucursalOrigen, Mut.Estatus
		FROM	CLIENTESPROFUN	Mut
		inner join CLIENTES	Cli on Cli.ClienteID = Mut.ClienteID
		left join CLIAPLICAPROFUN Fall on Mut.ClienteID =  Fall.ClienteID
		where	Fall.ClienteID is null
		and 	Mut.ClienteID	not in (select  ClienteID from CLIENTESCANCELA WHERE AreaCancela = 'Pro')
		and 	Mut.Estatus		= 'R';

set VarNumSocios		:= (SELECT	 ifnull(count(ClienteID),Entero_Cero) FROM tmp_CLIENTESMUTALPROFUN );


Set VarNumAplicaPro		:= (SELECT	count(ClienteID)
								FROM CLIAPLICAPROFUN
								where	Estatus			= 'A'
								and 	AplicadoSocios	= Var_NoAplicado);


SELECT	ifnull(AporteMaxPROFUN,Decimal_Cero),	ifnull(MontoPROFUN,Decimal_Cero),	CtaContaPROFUN,		HaberExSocios
into	Var_ApoMaxPROFUN,						Var_MontoPROFUN,					VarCtaContaPROFUN,	VarHaberExSocios
	FROM PARAMETROSCAJA;

set Var_MontoPROFUN		:= ifnull(Var_MontoPROFUN , Decimal_Cero);
set VarNumAplicaPro		:= ifnull(VarNumAplicaPro , Entero_Cero);
Set VarMontoAplicaTot	:= Var_MontoPROFUN * VarNumAplicaPro;

Set VarMontoApl			:= VarMontoAplicaTot / NULLIF(VarNumSocios,0);
Set VarMontoApl         := IFNULL(VarMontoApl,Decimal_Cero);
Set VarMontoMutual		:= Var_MontoPROFUN / NULLIF(VarNumSocios,0);
Set VarMontoMutual      := IFNULL(VarMontoMutual,Decimal_Cero);
Set VarMontoMutual		:= round(VarMontoMutual,2);
set VarMontoRecibir		:= Var_MontoPROFUN;


if(VarMontoMutual>Var_ApoMaxPROFUN)then
	set VarMontoMutual		:= Var_ApoMaxPROFUN;
	set VarMontoRecibir		:= VarNumSocios* VarMontoMutual;

	set	VarMontoAplicaTot	:=	 VarMontoRecibir * VarNumAplicaPro;
else
	set VarMontoRecibir	:= Var_MontoPROFUN;
end if;


set	VarMontoApl			:=	 round(VarMontoMutual * VarNumAplicaPro,2);

ManejoErrores:BEGIN

	if(VarNumSocios >Entero_Cero and VarNumAplicaPro > Entero_Cero)then
		set VarDescripMov	:= (Select Descripcion from CONCEPTOSCONTA WHERE ConceptoContaID = VarConcepConta)  ;


		CALL MAESTROPOLIZAALT(
			Var_Poliza,			Par_EmpresaID,		Par_FechaOperacion,	Pol_Automatica,		VarConcepConta,
			VarDescripMov,		Salida_NO, 			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


			insert into CLICOBROSPROFUN
			SELECT	Mut.ClienteID,			Par_FechaOperacion,	Fecha_Vacia,		Decimal_Cero,	Decimal_Cero,
					Decimal_Cero,			Fecha_Vacia,		Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			FROM tmp_CLIENTESMUTALPROFUN Mut
			left join CLICOBROSPROFUN Cob on Mut.ClienteID = Cob.ClienteID
			where Cob.ClienteID is null
			and 	Mut.Estatus		= 'R';



			update	CLICOBROSPROFUN CP,
					tmp_CLIENTESMUTALPROFUN TM Set
					CP.Monto			= CP.Monto + VarMontoApl,
					CP.MontoPendiente	= CP.MontoPendiente + VarMontoApl,
					CP.Fecha			= Par_FechaOperacion,
					CP.EmpresaID		= Par_EmpresaID,
					CP.Usuario			= Aud_Usuario,
					CP.FechaActual		= Aud_FechaActual,
					CP.DireccionIP		= Aud_DireccionIP,
					CP.ProgramaID		= Aud_ProgramaID,
					CP.Sucursal			= Aud_Sucursal,
					CP.NumTransaccion	= Aud_NumTransaccion
			where	CP.ClienteID = TM.ClienteID ;



		OPEN CURSORCLIAPLICAPROFUN;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLO: LOOP

			FETCH CURSORCLIAPLICAPROFUN into
				VarCliSolApl;



			call CLIAPLICAPROFUNACT(
					VarCliSolApl,	  	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,		VarMontoRecibir,
					Act_MutualSoc,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);


				if(Par_NumErr <> Entero_Cero)then
					SET Par_NumErr  := '1';
					SET Par_ErrMen  := concat('Error al procesar al socio fallecido ', cast(VarCliSolApl as char));
					LEAVE CICLO;
				end if;

			set VarSucursalCte	:= (select SucursalOrigen from CLIENTES where ClienteID = VarCliSolApl);
			set Var_Instrumento := VarCliSolApl;

			set Var_MonedaID	:= (select MonedaBaseID from PARAMETROSSIS);
			set Var_Cargos		:= VarMontoRecibir;
			set Var_Abonos		:= VarMontoRecibir;
			set Var_CentroCostosID := FNCENTROCOSTOS(VarSucursalCte);


			CALL DETALLEPOLIZAALT (
				Par_EmpresaID,		Var_Poliza,			Par_FechaOperacion,		Var_CentroCostosID,	VarCtaContaProfun,
				Var_Instrumento,	Var_MonedaID,		Var_Cargos,				Decimal_Cero,		VarDescripMov,
				Var_Instrumento,	VarProcedimiento,	TipoInstrumento,		Cadena_Vacia,		Decimal_Cero,
				Cadena_Vacia,		Salida_NO, 			Par_NumErr,				Par_ErrMen,			Aud_Usuario	,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			CALL DETALLEPOLIZAALT (
				Par_EmpresaID,		Var_Poliza,			Par_FechaOperacion,		Var_CentroCostosID,	VarHaberExSocios,
				Var_Instrumento,	Var_MonedaID,		Decimal_Cero,			Var_Abonos,			VarDescripMov,
				Var_Instrumento,	VarProcedimiento,	TipoInstrumento,		Cadena_Vacia,		Decimal_Cero,
				Cadena_Vacia,		Salida_NO, 			Par_NumErr,				Par_ErrMen,			Aud_Usuario	,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);



			if(Par_NumErr <> Entero_Cero)then
				LEAVE CICLO;
			end if;

			End LOOP CICLO;
		END;
		CLOSE CURSORCLIAPLICAPROFUN;
	end if;


	if(Par_NumErr <> Entero_Cero)then
		LEAVE ManejoErrores;
	else
		SET Par_NumErr  := '000';
		SET Par_ErrMen  := 'Proceso Cobro Programa PROFUN realizado con exito.';
		SET varControl  := 'clienteID' ;
		LEAVE ManejoErrores;
	end if;



END ManejoErrores;

drop table if exists tmp_CLIENTESMUTALPROFUN;

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen		 AS ErrMen,
			varControl		 AS control,
			Entero_Cero		 AS consecutivo;
end IF;

END TerminaStore$$