-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPFOCOOPCAP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REPFOCOOPCAP`;DELIMITER $$

CREATE PROCEDURE `REPFOCOOPCAP`(
	Par_TipoReporte		int,
	Par_FechaCorte 		date,
	IN Aud_EmpresaID 	int,
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
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE Salida_SI 		char(1);
DECLARE Salida_NO 		char(1);
DECLARE FactorPorcentaje	decimal(14,2);
DECLARE Vencimiento_Cap		varchar(50);
DECLARE PlazoDeposito_Cap	varchar(50);
DECLARE Sin_Rendimiento		varchar(50);
DECLARE Inversion_Vigente	char(1);
DECLARE Cliente_Inst        	int;
DECLARE Estado_Cancelada	char(1);
DECLARE Estado_AltaNA		char(1);
DECLARE Concepto_Capital	int;
DECLARE Con_ReporteCap		int;
DECLARE Con_ReporteCre		int;
DECLARE Con_FechaNula		char(20);
DECLARE Con_ReporteApo		int;
DECLARE EsEmproblemado		varchar(50);
DECLARE EsAhorro		    varchar(50);
DECLARE EsInversion		    varchar(50);
DECLARE EsAhorroInversion   varchar(50);


DECLARE Var_DiasInversion	decimal(14,2);
DECLARE Var_InicioPeriodo	date;
DECLARE Par_FechaCorteAho	date;
DECLARE Var_FechaCorteInv	date;
DECLARE Par_NumErr  		char(20);
DECLARE Par_ErrMen			char(250);

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
set	Salida_SI 	   		:= 'S';
set	Salida_NO 	   		:= 'N';
set FactorPorcentaje	:=100;
set Var_InicioPeriodo	:=Fecha_Vacia;
Set Vencimiento_Cap		:='A LA VISTA.';
set PlazoDeposito_Cap	:='1';
Set Sin_Rendimiento		:='0';

set Decimal_Cero		:=0.0;
set Inversion_Vigente	:='N';
set Cliente_Inst		:=1;
set Estado_Cancelada	:='C';
set Estado_AltaNA		:='A';
set Concepto_Capital	:=1;
set Con_ReporteCre		:=1;
set Con_ReporteCap		:=2;
set Con_ReporteApo		:=3;
set Con_FechaNula		:='0000-00-00 00:00:00';
Set EsEmproblemado		:='EMPROBLEMADO';
Set EsAhorro		    :='AHORRO';
Set EsInversion		    :='INVERSION';
Set EsAhorroInversion	:='AHORRO-INVERSION';

ManejoErrores: BEGIN


if(Par_TipoReporte = Con_ReporteCap) then
	select DiasInversion into Var_DiasInversion from PARAMETROSSIS;
	set Var_InicioPeriodo:=DATE_FORMAT(Par_FechaCorte, '%Y-%m-01');
	drop table IF EXISTS FoCoopCap;
	CREATE  TABLE FoCoopCap (
		Num_Socio			INT(11),
		Nombre_Socio		VARCHAR(200),
		Num_Cuenta			bigint(12),
		Sucursal			INT(11),
		FechaApertura		date,
		Tipo_Cuenta			VARCHAR(300),
		Fecha_Ult_Deposito	VARCHAR(25),
		FechaVencimiento	VARCHAR(25),
		PlazoDeposito		INT(11),
		FormaPagRendimientos INT(11),
		DiasCalculoInt		INT(11),
		TasaNominal			DECIMAL(14,2),
		SaldoPromedio		DECIMAL(14,2),
		Capital				DECIMAL(14,2),
		IntDevenNoPagados	DECIMAL(14,2),
		SaldoTotalCieMes	DECIMAL(14,2),
		InteresGeneradoMes	DECIMAL(14,2),
		Tipo				CHAR(1),
		NumTransaccion		BIGINT(20),
		PRIMARY KEY (Num_Socio,Num_Cuenta)
	);
	CREATE INDEX id_indexTipo ON FoCoopCap (Tipo);
	CREATE INDEX id_indexNum_Cuenta ON FoCoopCap (Num_Cuenta);




	if (Par_FechaCorte <'2014-12-31') then
		insert into FoCoopCap (
			Num_Socio,				Nombre_Socio,		Num_Cuenta,
			Sucursal,				FechaApertura,		Tipo_Cuenta,
			Fecha_Ult_Deposito,		FechaVencimiento,	PlazoDeposito,
			FormaPagRendimientos,	DiasCalculoInt,		TasaNominal,
			SaldoPromedio,			Capital,			IntDevenNoPagados,
			SaldoTotalCieMes,		InteresGeneradoMes,	Tipo,		NumTransaccion)
		select	Inv.ClienteID as Num_Socio,				Cli.NombreCompleto as Nombre_Socio,	Inv.InversionID as Num_Cuenta,
				SucursalOrigen as Sucursal,
				convert((case when Inv.FechaInicio = Con_FechaNula then Fecha_Vacia else Inv.FechaInicio end),date) as FechaApertura,
				convert(concat('Inversion a Plazo Fijo',' A ',(case when Dia.PlazoInferior in (181,366) then Var_DiasInversion
								else Dia.PlazoSuperior end), ' DIAS'),char) as Tipo_Cuenta,
				Inv.FechaInicio as Fecha_Ult_Deposito,
				convert(Inv.FechaVencimiento,char) as FechaVencimiento,
				convert(Plazo,char) as PlazoDeposito,
				convert('30',char) as FormaPagRendimientos,
				(DATEDIFF( (case when FechaVencimiento< Par_FechaCorte  then FechaVencimiento
					else Par_FechaCorte end )  ,  FechaInicio) ) as DiasCalculoInt,
				convert(Inv.Tasa,char) as TasaNominal,	0.0 as SaldoPromedio,					Inv.Monto as Capital,
				case	when FechaVencimiento< Par_FechaCorte then
					round( ( ( (DATEDIFF(FechaVencimiento,FechaInicio) +
										case when InversionIDSAFI is null then 0 else 1 end
						) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
					else round(((
						(DATEDIFF(Par_FechaCorte,FechaInicio) +
							case when InversionIDSAFI is null  then 0 else 1 end
						) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
					end as IntDevenNoPagados,
				Inv.Monto +(case	when FechaVencimiento< Par_FechaCorte then
					round( ( ( (DATEDIFF(FechaVencimiento,FechaInicio) +
										case when InversionIDSAFI is null then 0 else 1 end
						) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
					else round(((
						(DATEDIFF(Par_FechaCorte,FechaInicio) +
							case when InversionIDSAFI is null  then 0 else 1 end
						) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
					end ) as SaldoTotalCieMes,
				case	when FechaVencimiento< Par_FechaCorte then
					round( ( ( (DATEDIFF(FechaVencimiento,FechaInicio) +
										case when InversionIDSAFI is null then 0 else 1 end
						) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
					else round(((
						(DATEDIFF(Par_FechaCorte,FechaInicio) +
							case when InversionIDSAFI is null  then 0 else 1 end
						) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
					end as InteresGeneradoMes,
				'I', Aud_NumTransaccion
				from INVERSIONES Inv
					INNER JOIN	CLIENTES Cli ON Cli.ClienteID	= Inv.ClienteID
					INNER JOIN	CATINVERSION Cat ON  Cat.TipoInversionID	= Inv.TipoInversionID
					INNER JOIN	DIASINVERSION Dia on  Dia.TipoInversionID = Cat.TipoInversionID
							and (case when Inv.Plazo>365 then 365 else Inv.Plazo end)
								between PlazoInferior and PlazoSuperior
					LEFT JOIN	EQU_INVERSIONES Eq ON  Inv.InversionID = Eq.InversionIDSAFI
					where Inv.ClienteID<>Cliente_Inst
						and	Inv.FechaInicio <= Par_FechaCorte
						  and (Inv.Estatus = 'N'
						   or   ( Inv.Estatus = 'P'
									and Inv.FechaVencimiento != '1900-01-01'
									and Inv.FechaVencimiento > Par_FechaCorte)
						  or   ( Inv.Estatus = 'C'
							and Inv.FechaVenAnt != '1900-01-01'
							and Inv.FechaVenAnt > Par_FechaCorte) );

	else

		set Var_FechaCorteInv:= (select max(FechaCorte) from  HISINVERSIONES where FechaCorte <= Par_FechaCorte);
		insert into FoCoopCap (
			Num_Socio,				Nombre_Socio,				Num_Cuenta,			Sucursal,				FechaApertura,
			Tipo_Cuenta,
			Fecha_Ult_Deposito,		FechaVencimiento,			PlazoDeposito,		FormaPagRendimientos,
			DiasCalculoInt,
			TasaNominal,			SaldoPromedio,				Capital,
			IntDevenNoPagados,		SaldoTotalCieMes,			InteresGeneradoMes,	Tipo,		NumTransaccion)
		select
			Inv.ClienteID,			Cli.NombreCompleto,	Inv.InversionID,	SucursalOrigen,	ifnull(Inv.FechaInicio,Fecha_Vacia),
			convert(concat('Inversion a Plazo Fijo',' A ',(case when Dia.PlazoInferior in (181,366) then Var_DiasInversion else Dia.PlazoSuperior end), ' DIAS'),char) as Tipo_Cuenta,
			Inv.FechaInicio,		Inv.FechaVencimiento,	Plazo,				'30',
			(DATEDIFF( (case when FechaVencimiento< Var_FechaCorteInv  then FechaVencimiento
				else Var_FechaCorteInv end )  ,  FechaInicio) + 1) as DiasCalculoInt,
			Inv.Tasa,				0.0,					Inv.Monto,
			SaldoProvision,			round(Inv.Monto,2)+ round(SaldoProvision,2),	SaldoProvision,		'I',		Aud_NumTransaccion
				from HISINVERSIONES Inv
					INNER JOIN	CLIENTES Cli ON Cli.ClienteID	= Inv.ClienteID
					INNER JOIN	CATINVERSION Cat ON  Cat.TipoInversionID	= Inv.TipoInversionID
					INNER JOIN	DIASINVERSION Dia on  Dia.TipoInversionID = Cat.TipoInversionID
							and (case when Inv.Plazo>365 then 365 else Inv.Plazo end)
								between PlazoInferior and PlazoSuperior
					where Inv.ClienteID<>Cliente_Inst
						and	Inv.FechaCorte = Var_FechaCorteInv
						  and Inv.Estatus = 'N'
						   ;
	end if;


	set Par_FechaCorteAho := (select max(Fecha) from  `HIS-CUENTASAHO` where Fecha <= Par_FechaCorte);


	insert into FoCoopCap (
		Num_Socio,				Nombre_Socio,		Num_Cuenta,
		Sucursal,				FechaApertura,		Tipo_Cuenta,
		Fecha_Ult_Deposito,		FechaVencimiento,	PlazoDeposito,
		FormaPagRendimientos,	DiasCalculoInt,		TasaNominal,
		SaldoPromedio,			Capital,			IntDevenNoPagados,
		SaldoTotalCieMes,		InteresGeneradoMes,	Tipo)
	select	His.ClienteID as Num_Socio,		Cli.NombreCompleto as Nombre_Socio,					His.CuentaAhoID as Num_Cuenta,
			SucursalOrigen as Sucursal,		convert(His.FechaApertura,date) as Fecha_Apertura,	Tip.Descripcion as Tipo_Cuenta,
			'' as Fecha_Ult_Deposito,
			convert(Fecha,char) as FechaVencimiento,
			convert(PlazoDeposito_Cap,char) as PlazoDeposito,
			convert((case when GeneraInteres='S' then  30 				else Sin_Rendimiento end),char) as FormaPagRendimientos,Entero_Cero as DiasCalculoInt,
			convert((case when GeneraInteres='S' then His.TasaInteres	else Sin_Rendimiento end),char) as TasaNominal,
			His.SaldoProm as SaldoPromedio,
			His.SaldoIniMes   as Capital,
			Decimal_Cero as IntDevenNoPagados,
			His.SaldoIniMes as SaldoTotalCieMes,
			His.InteresesGen as InteresGeneradoMes,	'A'
		from TIPOSCUENTAS  Tip,
			`HIS-CUENTASAHO` His,
			CLIENTES Cli,
			SUCURSALES Suc
				where	His.ClienteID	<>Cliente_Inst
					and Tip.TipoCuentaID= His.TipoCuentaID
					and His.ClienteID	= Cli.ClienteID
					and Suc.SucursalID	= His.SucursalID
					and His.Fecha		= Par_FechaCorteAho
                    and His.Estatus in ('A','B');

	drop table if exists TMPMOVAHORROHIS;
	create temporary table TMPMOVAHORROHIS (
	select Mov.CuentaAhoID, sum(case Mov.NatMovimiento when 'C' then Mov.CantidadMov * -1 else Mov.CantidadMov end) AS Saldo
		from `HIS-CUENAHOMOV` Mov
		where Mov.Fecha >= Var_InicioPeriodo
		  and Mov.Fecha <= Par_FechaCorte
		group by Mov.CuentaAhoID);
	CREATE INDEX id_indexCuentaAhoID ON TMPMOVAHORROHIS (CuentaAhoID);

	UPDATE	FoCoopCap			F,
			TMPMOVAHORROHIS		H	SET
		F.Capital			= F.Capital	+	H.Saldo,
		F.SaldoTotalCieMes	= F.SaldoTotalCieMes	+	H.Saldo
	where	F.Num_Cuenta	= H.CuentaAhoID;
	drop table if exists TMPMOVAHORROHIS;


	drop table if exists TMPMOVAHORROHIS;
	create temporary table TMPMOVAHORROHIS (
		select Mov.CuentaAhoID, sum(case Mov.NatMovimiento when 'C' then Mov.CantidadMov * -1 else Mov.CantidadMov end) AS Saldo
			from CUENTASAHOMOV Mov
			where Mov.Fecha <= Par_FechaCorte
			group by Mov.CuentaAhoID);
	CREATE INDEX id_indexCuentaAhoID ON TMPMOVAHORROHIS (CuentaAhoID);

	UPDATE	FoCoopCap			F,
			TMPMOVAHORROHIS		H	SET
		F.Capital			= F.Capital	+	H.Saldo,
		F.SaldoTotalCieMes	= F.SaldoTotalCieMes	+	H.Saldo
	where	F.Num_Cuenta	= H.CuentaAhoID;
	drop table if exists TMPMOVAHORROHIS;



	drop table if exists TMPFECHADEPOSITO;
	create temporary table TMPFECHADEPOSITO (
		Select MAX(Fecha) as Fecha,	CuentaAhoID
			from 	`HIS-CUENAHOMOV` H,
					FoCoopCap		 F
			where	H.CuentaAhoID	= F.Num_Cuenta
			and 	H.NatMovimiento	= 'A'
			and		H.TipoMovAhoID in (10,102,14,16,12,23)
			and		H.Fecha			<=Par_FechaCorte
			group by CuentaAhoID	);

	CREATE INDEX id_indexCuentaAhoID ON TMPFECHADEPOSITO (CuentaAhoID);

	UPDATE	FoCoopCap			F,
			TMPFECHADEPOSITO	H	SET
		F.Fecha_Ult_Deposito	= H.Fecha
	where	F.Num_Cuenta	= H.CuentaAhoID
	 and	F.Tipo			= 'A';



	drop table if exists TMPFECHADEPOSITO;
	create temporary table TMPFECHADEPOSITO (
		Select MAX(Fecha) as Fecha,	CuentaAhoID
			from 	`HIS-CUENAHOMOV` H,
					FoCoopCap		 F
			where	H.CuentaAhoID	= F.Num_Cuenta
			and 	H.NatMovimiento	= 'A'
			and		H.TipoMovAhoID in (200)
			and		H.Fecha				<=Par_FechaCorte
			and		ifnull(F.Fecha_Ult_Deposito,'1900-01-01')='1900-01-01'
			group by CuentaAhoID	);

	CREATE INDEX id_indexCuentaAhoID ON TMPFECHADEPOSITO (CuentaAhoID);




	select	Num_Socio,			Nombre_Socio,		Num_Cuenta,			Sucursal,		FechaApertura,
			Tipo_Cuenta,		case when Fecha_Ult_Deposito = '1900-01-01' then '' else Fecha_Ult_Deposito end as Fecha_Ult_Deposito,
													FechaVencimiento,	PlazoDeposito,	FormaPagRendimientos,
			DiasCalculoInt,		TasaNominal/100 as TasaNominal,		SaldoPromedio,
			round(Capital,2) as Capital,
			round(IntDevenNoPagados,2) as IntDevenNoPagados,
			round(ifnull(Capital,0),2)+round(ifnull(IntDevenNoPagados,0),2) as SaldoTotalCieMes,
			round(InteresGeneradoMes,0) as InteresGeneradoMes, time(now()) as HoraEmision
	from FoCoopCap
	order by Num_Socio, Num_Cuenta ;

	drop table IF EXISTS FoCoopCap;

end if;


if(Par_TipoReporte=Con_ReporteCre) then

	drop table IF EXISTS FoCoopCre;
	CREATE TEMPORARY TABLE FoCoopCre (
		NombreCompleto		VARCHAR(200),
		Numero_Socio		INT(11),
		Contrato			INT(11),
		Sucursal			INT(11),
		Clasificacion		VARCHAR(30),
		Producto			VARCHAR(100),
		PlazoCredito		int(11),
		MODALIDAD_PAGO		VARCHAR(50),
		Fecha_Otorgamiento	DATE,
		Fecha_Vencimien		DATE,
		Monto_Original		DECIMAL(14,2),
		Tasa_Ordinaria		DECIMAL(14,4),
		Tasa_Moratoria		DECIMAL(14,4),
		PeriodicidadCap		INT(11),
		PeriodicidadInt		INT(11),
		Dias_Mora			INT(11),
		SalCapVigente		DECIMAL(14,2),
		SalCapVencido		DECIMAL(14,2),
		SalIntOrdinario		DECIMAL(14,2),
		SalIntVencido		DECIMAL(14,2),
		SalIntNoConta		DECIMAL(14,2),
		SalMoratorios		DECIMAL(14,2),
		FechaUltPagoCap		DATE,
		MontoUltPagCap		DECIMAL(14,2),
		FechaUltPagoInteres	DATE,
		MontoUltPagInteres	DECIMAL(14,2),
		Vigente_Vencido		VARCHAR(30),
		Emproblemado        VARCHAR(50),
		MontoGL				DECIMAL(14,2),
		CuentaGL			VARCHAR(50),
		EPR_Cubierta		DECIMAL(14,2),
		EPR_EXPUESTA		DECIMAL(14,2),
		EPR_InteresesCaVe	DECIMAL(14,2),
		RenReesNor			VARCHAR(50),
		CargoAcreditado		VARCHAR(50),
		EstatusCredito		CHAR(1),
		PRIMARY KEY (Contrato)
	);


	set Par_FechaCorte := (select max(Fecha) from  CALRESCREDITOS where Fecha <= Par_FechaCorte);

	INSERT INTO FoCoopCre (
			NombreCompleto,	Numero_Socio,	Contrato,		Sucursal,			Clasificacion,
			Producto,		Tasa_Ordinaria,	Tasa_Moratoria,	Vigente_Vencido,	EPR_Cubierta,
			EPR_EXPUESTA,	Emproblemado,	RenReesNor,		MODALIDAD_PAGO)
	select	C.NombreCompleto,		C.ClienteID as Numero_Socio,      CR.CreditoID as Contrato,		CR.SucursalID as Sucursal,
				(case  RES.Clasificacion	when 'O' then 'CONSUMO'
								when 'C' then 'COMERCIAL'
								when 'H' then 'VIVIENDA' end) as Clasificacion,
			replace(P.Descripcion,",","") as Producto,
			TasaFija/100 as Tasa_Ordinaria,
			CASE TipCobComMorato WHEN 'N' THEN (TasaFija*CR.FactorMora)/100
								 WHEN 'T' THEN CR.FactorMora/100 END as Tasa_Moratoria,
			(case  CR.Estatus when 'V' then 'VIGENTE' when 'B' then 'VENCIDO' else '' end) as Vigente_Vencido,
			ReservaTotCubierto,	ReservaTotExpuesto, Cadena_Vacia, 'NORMAL',
			(case CR.FrecuenciaCap
				when 'S'	then 'PAGO SEMANAL DE CAPITAL E INTERESES'
				when 'C'	then 'PAGO CATORCENAL DE CAPITAL E INTERESES'
				when 'Q'	then 'PAGO QUINCENAL DE CAPITAL E INTERESES'
				when 'M'	then 'PAGO MENSUAL DE CAPITAL E INTERESES'
				when 'P'	then 'PAGO POR PERIODO DE CAPITAL E INTERESES'
				when 'B'	then 'PAGO BIMESTRAL DE CAPITAL E INTERESES'
				when 'T'	then 'PAGO TRIMESTRAL DE CAPITAL E INTERESES'
				when 'R'	then 'PAGO TETRAMESTRAL DE CAPITAL E INTERESES'
				when 'E'	then 'PAGO SEMESTRAL DE CAPITAL E INTERESES'
				when 'A'	then 'PAGO ANUAL DE CAPITAL E INTERESES'
				when 'L'	then 'PAGOS DE CAPITAL E INTERESES LIBRES'
				when 'U'	then 'PAGO UNICO DE CAPITAL E INTERESES'
				when 'P'	then 'PAGO PERIODICO DE CAPITAL E INTERESES'
				else 'PAGOS DE CAPITAL E INTERESES LIBRES' end )
		from		CALRESCREDITOS RES,
					CREDITOS CR,
					CLIENTES C,
					PRODUCTOSCREDITO	P
			where	RES.Fecha			= Par_FechaCorte
				and RES.CreditoID		= CR.CreditoID
				and CR.ClienteID		= C.ClienteID
				and CR.ProductoCreditoID= P.ProducCreditoID ;

	drop table if exists TMPCREDITOINVGARFOC;
	CREATE TEMPORARY TABLE TMPCREDITOINVGARFOC
	SELECT sum(T.MontoEnGar) AS MontoEnGar , T.CreditoID
		FROM FoCoopCre		F,
             CREDITOINVGAR	T
		where	F.Contrato		=	T.CreditoID
			and FechaAsignaGar <= Par_FechaCorte
		GROUP BY T.CreditoID;


	update	FoCoopCre			F,
			TMPCREDITOINVGARFOC	T	set
		F.MontoGL			=	T.MontoEnGar,
		F.CuentaGL			=	EsInversion
	where F.Contrato		=	T.CreditoID;



	drop table if exists TMPHISCREDITOINVGAR;
	CREATE TEMPORARY TABLE TMPHISCREDITOINVGAR
	SELECT sum(Gar.MontoEnGar) AS MontoEnGar , Gar.CreditoID
		FROM FoCoopCre		Tmp,
             HISCREDITOINVGAR	Gar
		WHERE	Gar.Fecha > Par_FechaCorte
		  and	Gar.FechaAsignaGar <= Par_FechaCorte
		  and	Gar.ProgramaID not in ('CIERREGENERALPRO')
		  and	Gar.CreditoID = Tmp.Contrato
		GROUP BY Gar.CreditoID;

	UPDATE	FoCoopCre			Tmp,
			TMPHISCREDITOINVGAR	Gar	SET
		Tmp.MontoGL		= IFNULL(Tmp.MontoGL, Decimal_Cero) + Gar.MontoEnGar,
		Tmp.CuentaGL	=	EsInversion
		WHERE	Gar.CreditoID = Tmp.Contrato;


	DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;
	create temporary table TMPMONTOGARCUENTAS (
	SELECT Blo.Referencia,	SUM(CASE WHEN Blo.NatMovimiento = 'B'
					THEN IFNULL(Blo.MontoBloq,Decimal_Cero)
				 ELSE IFNULL(Blo.MontoBloq,Decimal_Cero)  * -1
			END) AS MontoEnGar
		FROM	BLOQUEOS 		Blo,
				FoCoopCre		Tmp
			WHERE DATE(Blo.FechaMov) <= Par_FechaCorte
				AND Blo.TiposBloqID = 8
				AND Blo.Referencia  = Tmp.Contrato
		 GROUP BY Blo.Referencia);

	UPDATE	FoCoopCre 		Tmp,
			TMPMONTOGARCUENTAS 	Blo
		SET Tmp.MontoGL 	= IFNULL(Tmp.MontoGL, Decimal_Cero) +MontoEnGar,
			Tmp.CuentaGL	=	EsAhorro
	WHERE Blo.Referencia  = Tmp.Contrato
	 AND IFNULL(MontoGL,0) = 0;

	UPDATE	FoCoopCre 		Tmp,
			TMPMONTOGARCUENTAS 	Blo
		SET Tmp.MontoGL	= IFNULL(Tmp.MontoGL, Decimal_Cero) +MontoEnGar,
			Tmp.CuentaGL =	EsAhorroInversion
	WHERE Blo.Referencia  = Tmp.Contrato
	 AND IFNULL(MontoGL,0) > 0
	 AND CuentaGL	<>	EsAhorro
	 AND MontoEnGar >0;
	DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;



	drop table IF EXISTS TMPMONTOFECPAGCAP;
	create TEMPORARY table TMPMONTOFECPAGCAP as (
		select	F.Contrato,	max(FechaPago) as Var_FechaPago,	ifnull(sum(MontoCapOrd+MontoCapAtr+MontoCapVen),0.0) as Var_Monto
			from 	DETALLEPAGCRE 	D,
					FoCoopCre		F
			where	D.CreditoID	=	F.Contrato
				and	FechaPago	<=	Par_FechaCorte
				group by D.CreditoID having sum(MontoCapOrd+MontoCapAtr+MontoCapVen)>0.0
				order by FechaPago desc);


	update	FoCoopCre		F,
			TMPMONTOFECPAGCAP	T	set
		F.FechaUltPagoCap		=	Var_FechaPago,
		F.MontoUltPagCap		=	ifnull(T.Var_Monto,0)
	where F.Contrato		=	T.Contrato;


	drop table IF EXISTS TMPMONTOPAGOCAPI;
	create TEMPORARY table TMPMONTOPAGOCAPI as (
	select F.Contrato, 	max(FechaPago) as Var_FechaPago, ifnull(sum(Det.MontoIntOrd+Det.MontoIntAtr+Det.MontoIntVen),0.0) as Var_Interes
			from DETALLEPAGCRE Det,
			   FoCoopCre F
			where F.Contrato=Det.CreditoID
			and Det.FechaPago<=Par_FechaCorte
	group by Det.CreditoID having sum(Det.MontoIntOrd+Det.MontoIntAtr+Det.MontoIntVen)>0.0
	  order by Det.FechaPago);


	update	FoCoopCre		F,
			TMPMONTOPAGOCAPI	T	set
		F.FechaUltPagoInteres	=	Var_FechaPago,
		F.MontoUltPagInteres 	=	ifnull(T.Var_Interes,0)
	where F.Contrato	=	T.Contrato;




	update	FoCoopCre		F ,
			REESTRUCCREDITO T
	set  F.Emproblemado	=  EsEmproblemado
	where T.CreditoDestinoID = F.Contrato
	 AND	T.Origen	= 'R'
	;

	update	FoCoopCre		F ,
			REESTRUCCREDITO T
	set  F.Emproblemado	:=  EsEmproblemado
	where T.CreditoDestinoID = F.Contrato
	 AND	T.Origen	= 'O'
	;


	update	FoCoopCre		F ,
			REESTRUCCREDITO T
	set  F.RenReesNor	=  'REESTRUCTURADO'
	where T.CreditoDestinoID = F.Contrato
	 AND	T.Origen	= 'R'
	;


	update	FoCoopCre		F ,
			REESTRUCCREDITO T
	set  F.RenReesNor	=  'RENOVADO'
	where T.CreditoDestinoID = F.Contrato
	 AND	T.Origen	= 'O'
	;




	drop table if exists TMPAMORTIZAFREFOCO;
	create temporary table TMPAMORTIZAFREFOCO
	SELECT F.AmortizacionID, F.CreditoID,
		CASE IFNULL(F.Capital,0) WHEN 0	then 0
										else DATEDIFF(F.FechaVencim, F.FechaInicio) end as FrecuenciaCap,
		CASE IFNULL(F.Interes,0) WHEN 0	then 0
										else DATEDIFF(F.FechaVencim, F.FechaInicio) end as FrecuenciaInt
		from	AMORTICREDITO	F,
				FoCoopCre		A
		where F.CreditoID = A.Contrato ;
	CREATE INDEX id_indexCreditoID ON TMPAMORTIZAFREFOCO (CreditoID);

	drop table if exists TMPAMORTIZAFREFOCOFREC;
	create temporary table TMPAMORTIZAFREFOCOFREC
		SELECT AVG(FrecuenciaCap) AS FrecuenciaCap ,AVG(FrecuenciaInt) AS FrecuenciaInt,CreditoID
			FROM TMPAMORTIZAFREFOCO
			group by CreditoID;
	CREATE INDEX id_indexCreditoFID ON TMPAMORTIZAFREFOCOFREC (CreditoID);

	update	FoCoopCre				F,
			TMPAMORTIZAFREFOCOFREC	S	set
		PeriodicidadCap	=	FrecuenciaCap,
		PeriodicidadInt	=	FrecuenciaInt
	where S.CreditoID		=	F.Contrato;

	drop table if exists TMPAMORTIZAFREFOCO;
	drop table if exists TMPAMORTIZAFREFOCOFREC;


	update	FoCoopCre		F,
			SALDOSCREDITOS	S	set
		PlazoCredito		=	(case S.FrecuenciaCap	when 'M' then S.NumAmortizacion
										when 'Q' then S.NumAmortizacion/2
										when 'C' then S.NumAmortizacion/2
										when 'S' then S.NumAmortizacion/4
										when 'B' then S.NumAmortizacion*2
										when 'T' then S.NumAmortizacion*3
										when 'R' then S.NumAmortizacion*4
										when 'E' then S.NumAmortizacion*6
										when 'A' then S.NumAmortizacion*12
										when 'U' then ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio)/30.5,0)
										when 'P' then ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio)/30.5,0)
										when 'L' then ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio)/30.5,0) end),
		F.PeriodicidadCap		=	(case S.FrecuenciaCap
										when 'M' then S.PeriodicidadCap
										when 'Q' then S.PeriodicidadCap
										when 'C' then S.PeriodicidadCap
										when 'S' then S.PeriodicidadCap
										when 'B' then S.PeriodicidadCap
										when 'T' then S.PeriodicidadCap
										when 'R' then S.PeriodicidadCap
										when 'E' then S.PeriodicidadCap
										when 'A' then S.PeriodicidadCap
										when 'U' then ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio),0)
										when 'P' then S.PeriodicidadCap
										else F.PeriodicidadCap*1	end),
		F.PeriodicidadInt		=	(case S.FrecuenciaInt
										when 'M' then S.PeriodicidadInt
										when 'Q' then S.PeriodicidadInt
										when 'C' then S.PeriodicidadInt
										when 'S' then S.PeriodicidadInt
										when 'B' then S.PeriodicidadInt
										when 'T' then S.PeriodicidadInt
										when 'R' then S.PeriodicidadInt
										when 'E' then S.PeriodicidadInt
										when 'A' then S.PeriodicidadInt
										when 'U' then ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio),0)
										when 'P' then S.PeriodicidadInt
										else F.PeriodicidadCap*1 end),
		F.Fecha_Otorgamiento	=	S.FechaInicio,
		F.Fecha_Vencimien		=	S.FechaVencimiento,
		F.Monto_Original		=	S.MontoCredito,
		F.Dias_Mora				=	S.DiasAtraso,
		F.SalCapVigente			=	round(S.SalCapVigente,2)+round(S.SalCapAtrasado,2),
		F.SalCapVencido			=	round(S.SalCapVencido,2)+round(S.SalCapVenNoExi,2),
		F.SalIntOrdinario		=	S.SalIntOrdinario+SalIntProvision+SalIntAtrasado+S.SalMoratorios,
		F.SalIntVencido			=	S.SalIntVencido+SaldoMoraVencido,
		F.SalIntNoConta			=	S.SalIntNoConta+SaldoMoraCarVen,
		F.SalMoratorios			=	(ifnull(S.SalMoratorios,0)+ ifnull(S.SaldoMoraVencido,0)+ ifnull(S.SaldoMoraCarVen,0)),

		F.EPR_InteresesCaVe		=	 case when S.EstatusCredito = "B" then round(S.SaldoMoraVencido,2) +
											round(S.SalIntProvision,2) +	round(S.SalIntVencido,2)  end ,
		F.Vigente_Vencido		= (case  S.EstatusCredito when 'V' then 'VIGENTE' when 'B' then 'VENCIDO' else "" end),
		F.EstatusCredito		= S.EstatusCredito
	where S.CreditoID		=	F.Contrato
		and S.FechaCorte	=	Par_FechaCorte;






	update	FoCoopCre			Car	,
			RELACIONCLIEMPLEADO	Rel		,
			TIPORELACIONES		Tip	set
		CargoAcreditado	= 	4
	where	Rel.TipoRelacion	= 2
		and Car.Numero_Socio	= Rel.ClienteID
			and TipoRelacionID		= Rel.ParentescoID
		and Grado in 	(1, 2);


	update	FoCoopCre			Car	,
			CLIEMPRELACIONADO	Rel		set
		CargoAcreditado	= 	4
	where	Car.Numero_Socio	= Rel.ClienteID
		and Rel.EmpleadoID 		> 0
		and TienePoder		= 'S';


	update	FoCoopCre		Car	,
			CLIEMPRELACIONADO	Rel		set
		CargoAcreditado	= 	2
	where	Car.Numero_Socio	= Rel.ClienteID
		and TienePoder		= 'S';



	update	FoCoopCre		Car	,
			CLIEMPRELACIONADO	Emp	,
			RELACIONCLIEMPLEADO	Rel	,
			TIPORELACIONES		Tip set
		CargoAcreditado	= 	3
	where	Rel.TipoRelacion	= 1
		and Car.Numero_Socio	= Rel.ClienteID
			and Rel.RelacionadoID = Emp.ClienteID
			and TienePoder			= 'S'
			and TipoRelacionID		= Rel.ParentescoID
			and Grado in 	(1, 2);





	select	F.NombreCompleto,		Numero_Socio,						Contrato,			Sucursal,		Clasificacion,
			Producto,			MODALIDAD_PAGO as MODALIDAD_PAGO,	Fecha_Otorgamiento,	F.Monto_Original,	Fecha_Vencimien,
			Tasa_Ordinaria,		Tasa_Moratoria,						PlazoCredito,
			PeriodicidadCap as FrecuenciaPagoCapital,
			PeriodicidadInt as FrecuenciaPagoInt,
			Dias_Mora,			F.SalCapVigente as Saldo_Capital_Vigente,	F.SalCapVencido as SaldoCapitalVencido,
			F.SalIntOrdinario as Interes_Dev_NoCob_Vig,
			SalIntVencido as Interes_Dev_NoCob_Ven,	SalIntNoConta as INTERES_DEVEN_NOCOB_CuentasOrden,
			SalMoratorios as InteresMoratorio,
			FechaUltPagoCap,	MontoUltPagCap,		F.FechaUltPagoInteres,	MontoUltPagInteres,
			RenReesNor as RenReesNor,
			Emproblemado,	Vigente_Vencido,	ifnull(CargoAcreditado,'') as CargoDelAcreditado, 	MontoGL as MontoGarantiaLiquida,	CuentaGL as GarantiaLiquida,
			ifnull(GarPrendaria,0.0) as MontoGarantiaPrendaria,	ifnull(GarHipotecaria,0.0) as MontoGarantiaHipoteca,	EPR_Cubierta,	EPR_EXPUESTA,
			EPR_InteresesCaVe, time(now()) as HoraEmision
			from	FoCoopCre F
				left outer join TMPGARPRENHIPO	T on F.Contrato = T.CreditoID;





	drop table IF EXISTS FoCoopCre;
end if;


if(Par_TipoReporte=Con_ReporteApo) then

 drop table IF EXISTS FocoopCapSoc;
	CREATE TEMPORARY TABLE FocoopCapSoc (
		ClienteID				INT(11),
		Nombre					VARCHAR(200),
		ApellidoPaterno			VARCHAR(200),
		ApellidoMaterno			VARCHAR(200),
		CURP					VARCHAR(18),
		TipoAportacion			VARCHAR(300),
		FechaAlta				DATE,
		Sexo					VARCHAR(10),
		ParteSocial				DECIMAL(14,2),
		Fecha                   DATE,
		HoraEmision             TIME,
		PRIMARY KEY (ClienteID)
	);


	insert into FocoopCapSoc (ClienteID, ParteSocial, Fecha,HoraEmision)

	select	Apo.ClienteID,coalesce((case when (sum(case when Tipo="D" then Monto*-1 else Monto end)<0) then 0 else
				sum(case when Tipo="D" then Monto*-1 else Monto end) end),Saldo)as ParteSocial,Fecha, time(now()) as HoraEmision
		from APORTACIONSOCIO Apo
		left outer join APORTASOCIOMOV Apm
			on Apo.ClienteID=Apm.ClienteID
			group by Apo.ClienteID;


	update	FocoopCapSoc F,
			CLIENTES C
		set
			F.Nombre   =	concat(C.PrimerNombre,'',ifnull(C.SegundoNombre,''),ifnull(C.TercerNombre,'')),
			F.ApellidoPaterno = (C.ApellidoPaterno),
			F.ApellidoMaterno = C.ApellidoMaterno,
			F.CURP = C.CURP,
			F.TipoAportacion = "Certificado de Aportación",
			F.FechaAlta = C.FechaAlta,
			F.Sexo  = case when C.Sexo ="M" then "MASCULINO" else "FEMENINO" end
		where 	coalesce(F.Fecha,date(C.FechaAlta))<=Par_FechaCorte
				and F.ClienteID=C.ClienteID;


	select	F.ClienteID,			F.Nombre,		F.ApellidoPaterno,
			F.ApellidoMaterno,		F.CURP,			F.TipoAportacion,
			F.FechaAlta,			F.Sexo, 		F.ParteSocial,
			F.HoraEmision
	from FocoopCapSoc F,
		 CLIENTES C
	where coalesce(F.Fecha,date(C.FechaAlta))<=Par_FechaCorte
				and F.ClienteID=C.ClienteID
				and F.ParteSocial>0
				group by F.ClienteID;

end if;

END ManejoErrores;

END TerminaStore$$