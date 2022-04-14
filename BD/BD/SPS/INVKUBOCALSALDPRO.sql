-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVKUBOCALSALDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVKUBOCALSALDPRO`;DELIMITER $$

CREATE PROCEDURE `INVKUBOCALSALDPRO`(

	Par_Salida			char(1),
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE Var_SalCapVig		decimal(12,4);
DECLARE Var_SalCapExi		decimal(12,4);
DECLARE Var_SalInteres	decimal(12,4);
DECLARE Var_ProvAcum		decimal(12,4);
DECLARE Var_MoraPagado	decimal(12,4);
DECLARE Var_ComFPPag		decimal(12,4);
DECLARE Var_IntOrdReten	decimal(12,4);
DECLARE Var_IntMorReten	decimal(12,4);
DECLARE Var_ComFPReten	decimal(12,4);

DECLARE MinFecExig 		date;
DECLARE NumFondeoKubo		int(11);
DECLARE DiasAtraso		int;
DECLARE VarSalAtras1A15	decimal(12,4);
DECLARE VarNumAtras1A15	int;
DECLARE VarSalAtras16A30	decimal(12,4);
DECLARE VarNumAtras16A30	int;
DECLARE VarSalAtras31A90	decimal(12,4);
DECLARE VarNumAtras31A90	int;
DECLARE VarSalVen91A120	decimal(12,4);
DECLARE VarNumVen91A120	int;
DECLARE VarSalVen121A180	decimal(12,4);
DECLARE VarNumVen121A180	int;
DECLARE VarNumFondeo		int;
DECLARE VarGAT			decimal(12,4);
DECLARE Var_ClienteID		bigint;
DECLARE Var_CreditoID		bigint;

DECLARE Var_FecActual		date;
DECLARE NumTotalAmort		int;
DECLARE NumError			int;
DECLARE ErrorMen			varchar(200);
DECLARE amorti		int;



DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero 		decimal(12,4);
DECLARE	EstatPagada		char(1);
DECLARE	SalidaSi			char(1);
DECLARE	SalidaNo			char(1);


DECLARE CURSORSALINVK CURSOR FOR
	select	FondeoKuboID,		SaldoCapVigente,	SaldoCapExigible,	SaldoInteres,		ProvisionAcum,
			MoratorioPagado,	ComFalPagPagada,	IntOrdRetenido,	IntMorRetenido,	ComFalPagRetenido,
			ClienteID,		CreditoID
		from FONDEOKUBO
		where Estatus = 'N'
		  or  Estatus = 'V';


Set	Cadena_Vacia		= '';
Set	Fecha_Vacia		= '1900-01-01';
Set	Entero_Cero		= 0;
Set	Decimal_Cero 		= 0.00;
Set	EstatPagada		:= 'P';

Set	VarGAT			:= 0.0;
Set VarSalAtras1A15	:= 0.0;
Set VarNumAtras1A15	:= 0;
Set VarSalAtras16A30	:= 0.0;
Set VarNumAtras16A30	:= 0;
Set VarSalAtras31A90	:= 0.0;
Set VarNumAtras31A90	:= 0;
Set VarSalVen91A120	:= 0.0;
Set VarNumVen91A120	:= 0;
Set VarSalVen121A180	:= 0.0;
Set VarNumVen121A180	:= 0;
Set SalidaSi			:= 'S';
Set SalidaNo			:= 'N';

select FechaSistema into Var_FecActual
	from PARAMETROSSIS;

OPEN CURSORSALINVK;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;

	LOOP

	FETCH CURSORSALINVK 	into
		NumFondeoKubo,	Var_SalCapVig,	Var_SalCapExi,	Var_SalInteres,	Var_ProvAcum,
		Var_MoraPagado,	Var_ComFPPag,		Var_IntOrdReten,	Var_IntMorReten,	Var_ComFPReten,
		Var_ClienteID,	Var_CreditoID;


		set	MinFecExig		:= Fecha_Vacia;
		set	DiasAtraso		:= Entero_Cero;
		Set VarSalAtras1A15	:= Decimal_Cero;
		Set VarNumAtras1A15	:= Entero_Cero;
		Set VarSalAtras16A30	:= Decimal_Cero;
		Set VarNumAtras16A30	:= Entero_Cero;
		Set VarSalAtras31A90	:= Decimal_Cero;
		Set VarNumAtras31A90	:= Entero_Cero;
		Set VarSalVen91A120	:= Decimal_Cero;
		Set VarNumVen91A120	:= Entero_Cero;
		Set VarSalVen121A180	:= Decimal_Cero;
		Set VarNumVen121A180	:= Entero_Cero;

		set	MinFecExig	:= (select ifnull(min(FechaExigible), Fecha_Vacia)
							from AMORTIZAFONDEO
							where FondeoKuboID	= 	NumFondeoKubo
							  and Estatus 		!= 	EstatPagada
							  and FechaExigible	<=  Var_FecActual
							group by FondeoKuboID );

		set MinFecExig := ifnull(MinFecExig, Fecha_Vacia);

		if (MinFecExig = Fecha_Vacia) then
			set DiasAtraso := 0;
		else
			set DiasAtraso := (select datediff(Var_FecActual, MinFecExig));
			if (DiasAtraso < 0) then
				set DiasAtraso := 0;
			end if;
		end if;

	if (DiasAtraso > 0 and DiasAtraso <= 15) then
			select 	ifnull(SaldoCapVigente, Entero_Cero) +
					ifnull(SaldoCapExigible, Entero_Cero)
					into
					VarSalAtras1A15
			   from FONDEOKUBO
			   where FondeoKuboID	= NumFondeoKubo;

			set VarNumAtras1A15	:= 1;

		end if;

		if (DiasAtraso >=16 and DiasAtraso <= 30) then
			select 	ifnull(SaldoCapVigente, Entero_Cero)+
					ifnull(SaldoCapExigible, Entero_Cero)
					into
					VarSalAtras16A30
			   from FONDEOKUBO
			   where FondeoKuboID	= NumFondeoKubo;

			set	VarNumAtras16A30	:= 1;
		end if;

		if (DiasAtraso >= 31 and DiasAtraso <= 90) then
			select	ifnull(SaldoCapVigente, Entero_Cero) +
					ifnull(SaldoCapExigible, Entero_Cero)
					into
					VarSalAtras31A90
			   from FONDEOKUBO
			   where FondeoKuboID	= NumFondeoKubo;

			set	VarNumAtras31A90	:= 1;
		end if;

		if (DiasAtraso >= 91 and DiasAtraso <= 120) then
			select	ifnull(SaldoCapVigente, Entero_Cero) +
					ifnull(SaldoCapExigible, Entero_Cero)
					into
					VarSalVen91A120
			   from 	FONDEOKUBO
			   where FondeoKuboID	= NumFondeoKubo;

			set	VarNumVen91A120	:= 1;
		end if;

		if (DiasAtraso >= 121) then
			select	ifnull(SaldoCapVigente, Entero_Cero) +
					ifnull(SaldoCapExigible, Entero_Cero)
				   into
					VarSalVen121A180
			   from FONDEOKUBO
			   where FondeoKuboID	= NumFondeoKubo;

			set	VarNumVen121A180	:= 1;
		end if;





		set VarNumAtras1A15 	:= ifnull(VarNumAtras1A15, Entero_Cero);
		set VarSalAtras1A15 	:= ifnull(VarSalAtras1A15, Entero_Cero);
		set VarNumAtras16A30	:= ifnull(VarNumAtras16A30, Entero_Cero);
		set VarSalAtras16A30	:= ifnull(VarSalAtras16A30, Entero_Cero);
		set VarNumAtras31A90	:= ifnull(VarNumAtras31A90, Entero_Cero);
		set VarSalAtras31A90	:= ifnull(VarSalAtras31A90, Entero_Cero);
		set VarNumVen91A120	:= ifnull(VarNumVen91A120, Entero_Cero);
		set VarSalVen91A120	:= ifnull(VarSalVen91A120, Entero_Cero);
		set VarNumVen121A180	:= ifnull(VarNumVen121A180, Entero_Cero);
		set VarSalVen121A180	:= ifnull(VarSalVen121A180, Entero_Cero);


		insert into SALDOSINVKUBO (
			FondeoKuboID,		FechaCorte,		ClienteID,			CreditoID,		SalCapVigente,
			SalCapExigible,	SaldoInteres,		ProvisionAcum,		MoratorioPagado,	ComFalPagPagada,
			IntOrdRetenido,	IntMorRetenido,	ComFalPagRetenido,	GAT,				NumAtras1A15,
			SalAtras1A15,		NumAtras16a30,	SaldoAtras16a30,		NumAtras31a90,	SalAtras31a90,
			NumVenc91a120,	SalVenc91a120,	NumVenc120a180,		SalVenc120a180
			) values (
			NumFondeoKubo,	Var_FecActual,	Var_ClienteID,		Var_CreditoID,	Var_SalCapVig,
			Var_SalCapExi,	Var_SalInteres,	Var_ProvAcum,			Var_MoraPagado,	Var_ComFPPag,
			Var_IntOrdReten,	Var_IntMorReten,	Var_ComFPReten,		VarGAT,			VarNumAtras1A15,
			VarSalAtras1A15,	VarNumAtras16A30,	VarSalAtras16A30,		VarNumAtras31A90,	VarSalAtras31A90,
			VarNumVen91A120,	VarSalVen91A120,	VarNumVen121A180,		VarSalVen121A180);


	End LOOP;

END;
CLOSE CURSORSALINVK;

if(Par_Salida = SalidaSi) then
	select '000' as NumErr,
	"Saldos Diarios de Kubo Generados" as ErrMen,
	'' as control;
end if;

if(Par_Salida = SalidaNo) then
	Set NumError = 0;
	Set ErrorMen = "Saldos Diarios de Kubo Generados";
end if;

END TerminaStore$$