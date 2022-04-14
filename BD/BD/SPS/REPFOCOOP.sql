-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REPFOCOOP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REPFOCOOP`;DELIMITER $$

CREATE PROCEDURE `REPFOCOOP`(
/* SP DE REPORTE FOCOOP */
	Par_TipoReporte			INT(11),
	Par_FechaCorte 			DATE,
	IN Aud_EmpresaID 		INT(11),
    /* Parametros Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Salida_NO 			CHAR(1);
	DECLARE FactorPorcentaje	DECIMAL(14,2);
	DECLARE Vencimiento_Cap		VARCHAR(50);
	DECLARE PlazoDeposito_Cap	VARCHAR(50);
	DECLARE Sin_Rendimiento		VARCHAR(50);
	DECLARE Inversion_Vigente	CHAR(1);
	DECLARE Cliente_Inst        INT;
	DECLARE Estado_Cancelada	CHAR(1);
	DECLARE Estado_AltaNA		CHAR(1);
	DECLARE Concepto_Capital	INT;
	DECLARE Con_ReporteCap		INT;
	DECLARE Con_ReporteCre		INT;
	DECLARE Con_FechaNula		CHAR(20);
	DECLARE Con_ReporteApo		INT;
	DECLARE EsEmproblemado		VARCHAR(50);
	DECLARE EsAhorro		    VARCHAR(50);
	DECLARE EsInversion		    VARCHAR(50);
	DECLARE EsAhorroInversion   VARCHAR(50);
    DECLARE TipoIngresos		CHAR(1);


	DECLARE Var_DiasInversion	DECIMAL(14,2);
	DECLARE Var_InicioPeriodo	DATE;
	DECLARE Par_FechaCorteAho	DATE;
	DECLARE Var_FechaCorteInv	DATE;
	DECLARE Par_NumErr  		CHAR(20);
	DECLARE Par_ErrMen			CHAR(250);
	DECLARE Var_TipoContaMora 	CHAR(1);

	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Salida_SI 	   		:= 'S';
	SET	Salida_NO 	   		:= 'N';
	SET FactorPorcentaje	:=100;
	SET Var_InicioPeriodo	:=Fecha_Vacia;
	SET Vencimiento_Cap		:='A LA VISTA.';
	SET PlazoDeposito_Cap	:='1';
	SET Sin_Rendimiento		:='NO APLICA.';
	SET Decimal_Cero		:=0.0;
	SET Inversion_Vigente	:='N';
	SET Cliente_Inst		:=(SELECT ClienteInstitucion FROM PARAMETROSSIS);
	SET Estado_Cancelada	:='C';
	SET Estado_AltaNA		:='A';
	SET Concepto_Capital	:=1;
	SET Con_ReporteCre		:=1;
	SET Con_ReporteCap		:=2;
	SET Con_ReporteApo		:=3;
	SET Con_FechaNula		:='1900-01-01 00:00:00';
	SET EsEmproblemado		:='EMPROBLEMADO';
	SET EsAhorro		    :='AHORRO';
	SET EsInversion		    :='INVERSION';
	SET EsAhorroInversion	:='AHORRO-INVERSION';
    SET TipoIngresos		:= 'I';

ManejoErrores: BEGIN


	IF(Par_TipoReporte = Con_ReporteCap) THEN
		SELECT DiasInversion INTO Var_DiasInversion FROM PARAMETROSSIS;
		SET Var_InicioPeriodo:=DATE_FORMAT(Par_FechaCorte, '%Y-%m-01');
		DROP TABLE IF EXISTS FoCoopCap;
		CREATE  TABLE FoCoopCap (
			Num_Socio				INT(11),
			Nombre_Socio			VARCHAR(200),
			Num_Cuenta				BIGINT(12),
			Sucursal				INT(11),
			FechaApertura			DATE,
			Tipo_Cuenta				VARCHAR(300),
			Fecha_Ult_Deposito		VARCHAR(25),
			FechaVencimiento		VARCHAR(25),
			PlazoDeposito			INT(11),
			FormaPagRendimientos 	VARCHAR(20),
			DiasCalculoInt			VARCHAR(11),
			TasaNominal				VARCHAR(20),
			SaldoPromedio			DECIMAL(14,2),
			Capital					DECIMAL(14,2),
			IntDevenNoPagados		DECIMAL(14,2),
			SaldoTotalCieMes		DECIMAL(14,2),
			InteresGeneradoMes		DECIMAL(14,2),
			Tipo					CHAR(1),
			NumTransaccion			BIGINT(20),
			PRIMARY KEY (Num_Socio,Num_Cuenta)
		);
		CREATE INDEX id_indexTipo ON FoCoopCap (Tipo);
		CREATE INDEX id_indexNum_Cuenta ON FoCoopCap (Num_Cuenta);




		IF (Par_FechaCorte <'2014-12-31') THEN
			INSERT INTO FoCoopCap (
				Num_Socio,			Nombre_Socio,			Num_Cuenta,			Sucursal,			FechaApertura,
                Tipo_Cuenta,		Fecha_Ult_Deposito,		FechaVencimiento,	PlazoDeposito,		FormaPagRendimientos,
                DiasCalculoInt,		TasaNominal,			SaldoPromedio,		Capital,			IntDevenNoPagados,
                SaldoTotalCieMes,	InteresGeneradoMes,		Tipo,				NumTransaccion)
			SELECT	Inv.ClienteID AS Num_Socio,				Cli.NombreCompleto AS Nombre_Socio,	Inv.InversionID AS Num_Cuenta,
					SucursalOrigen AS Sucursal,
					CONVERT((CASE WHEN Inv.FechaInicio = Con_FechaNula THEN Fecha_Vacia ELSE Inv.FechaInicio END),DATE) AS FechaApertura,
					CONVERT(CONCAT('Inversion a Plazo Fijo',' A ',(CASE WHEN Dia.PlazoInferior IN (181,366) THEN Var_DiasInversion
									ELSE Dia.PlazoSuperior END), ' DIAS'),CHAR) AS Tipo_Cuenta,
					Inv.FechaInicio AS Fecha_Ult_Deposito,
					CONVERT(Inv.FechaVencimiento,CHAR) AS FechaVencimiento,
					CONVERT(Plazo,CHAR) AS PlazoDeposito,
					CONVERT('30',CHAR) AS FormaPagRendimientos,
					(DATEDIFF( (CASE WHEN FechaVencimiento< Par_FechaCorte  THEN FechaVencimiento
						ELSE Par_FechaCorte END )  ,  FechaInicio) ) AS DiasCalculoInt,
					CONVERT(Inv.Tasa,CHAR) AS TasaNominal,	CONVERT(0.0,CHAR) AS SaldoPromedio,					Inv.Monto AS Capital,
					CASE	WHEN FechaVencimiento< Par_FechaCorte THEN
						ROUND( ( ( (DATEDIFF(FechaVencimiento,FechaInicio) +
											CASE WHEN InversionIDSAFI IS NULL THEN 0 ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						ELSE ROUND(((
							(DATEDIFF(Par_FechaCorte,FechaInicio) +
								CASE WHEN InversionIDSAFI IS NULL  THEN 0 ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						END AS IntDevenNoPagados,
					Inv.Monto +(CASE	WHEN FechaVencimiento< Par_FechaCorte THEN
						ROUND( ( ( (DATEDIFF(FechaVencimiento,FechaInicio) +
											CASE WHEN InversionIDSAFI IS NULL THEN 0 ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						ELSE ROUND(((
							(DATEDIFF(Par_FechaCorte,FechaInicio) +
								CASE WHEN InversionIDSAFI IS NULL  THEN 0 ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						END ) AS SaldoTotalCieMes,
					CASE	WHEN FechaVencimiento< Par_FechaCorte THEN
						ROUND( ( ( (DATEDIFF(FechaVencimiento,FechaInicio) +
											CASE WHEN InversionIDSAFI IS NULL THEN 0 ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						ELSE ROUND(((
							(DATEDIFF(Par_FechaCorte,FechaInicio) +
								CASE WHEN InversionIDSAFI IS NULL  THEN 0 ELSE 1 END
							) * (Tasa)*Monto))/(FactorPorcentaje*Var_DiasInversion),2)
						END AS InteresGeneradoMes,
					'I', Aud_NumTransaccion
					FROM INVERSIONES Inv
						INNER JOIN	CLIENTES Cli ON Cli.ClienteID	= Inv.ClienteID
						INNER JOIN	CATINVERSION Cat ON  Cat.TipoInversionID	= Inv.TipoInversionID
						INNER JOIN	DIASINVERSION Dia ON  Dia.TipoInversionID = Cat.TipoInversionID
								AND (CASE WHEN Inv.Plazo>365 THEN 365 ELSE Inv.Plazo END)
									BETWEEN PlazoInferior AND PlazoSuperior
						LEFT JOIN	EQU_INVERSIONES Eq ON  Inv.InversionID = Eq.InversionIDSAFI
						WHERE Inv.ClienteID<>Cliente_Inst
							AND	Inv.FechaInicio <= Par_FechaCorte
							  AND (Inv.Estatus = 'N'
							   OR   ( Inv.Estatus = 'P'
										AND Inv.FechaVencimiento != '1900-01-01'
										AND Inv.FechaVencimiento > Par_FechaCorte)
							  OR   ( Inv.Estatus = 'C'
								AND Inv.FechaVenAnt != '1900-01-01'
								AND Inv.FechaVenAnt > Par_FechaCorte) );

		ELSE

			SET Var_FechaCorteInv:= (SELECT MAX(FechaCorte) FROM  HISINVERSIONES WHERE FechaCorte <= Par_FechaCorte);
			INSERT INTO FoCoopCap (
				Num_Socio,			Nombre_Socio,			Num_Cuenta,			Sucursal,		FechaApertura,
				Tipo_Cuenta,		Fecha_Ult_Deposito,		FechaVencimiento,	PlazoDeposito,	FormaPagRendimientos,
				DiasCalculoInt,		TasaNominal,			SaldoPromedio,		Capital,		IntDevenNoPagados,
                SaldoTotalCieMes,	InteresGeneradoMes,		Tipo,				NumTransaccion)
			SELECT
				Inv.ClienteID,			Cli.NombreCompleto,	Inv.InversionID,	SucursalOrigen,	IFNULL(Inv.FechaInicio,Fecha_Vacia),
				CONVERT(CONCAT('Inversion a Plazo Fijo',' A ',(CASE WHEN Dia.PlazoInferior IN (181,366) THEN Var_DiasInversion ELSE Dia.PlazoSuperior END), ' DIAS'),CHAR) AS Tipo_Cuenta,
				Inv.FechaInicio,		Inv.FechaVencimiento,	Plazo,				'30',
				(DATEDIFF( (CASE WHEN FechaVencimiento< Var_FechaCorteInv  THEN FechaVencimiento
					ELSE Var_FechaCorteInv END )  ,  FechaInicio) + 1) AS DiasCalculoInt,
				Inv.Tasa,				0.0,					Inv.Monto,
				SaldoProvision,			ROUND(Inv.Monto,2)+ ROUND(SaldoProvision,2),	SaldoProvision,		'I',		Aud_NumTransaccion
					FROM HISINVERSIONES Inv
						INNER JOIN	CLIENTES Cli ON Cli.ClienteID		= Inv.ClienteID
						INNER JOIN	CATINVERSION Cat ON  Cat.TipoInversionID	= Inv.TipoInversionID
						INNER JOIN	DIASINVERSION Dia ON  Dia.TipoInversionID = Cat.TipoInversionID
								AND (CASE WHEN Inv.Plazo>365 THEN 365 ELSE Inv.Plazo END)
									BETWEEN PlazoInferior AND PlazoSuperior
						WHERE Inv.ClienteID<>Cliente_Inst
							AND	Inv.FechaCorte = Var_FechaCorteInv
							  AND Inv.Estatus = 'N'
							   ;
		END IF;


		SET Par_FechaCorteAho := (SELECT MAX(Fecha) FROM  `HIS-CUENTASAHO` WHERE Fecha <= Par_FechaCorte);
		SET Var_InicioPeriodo:=DATE_FORMAT(Par_FechaCorteAho, '%Y-%m-01');

		INSERT INTO FoCoopCap (
			Num_Socio,			Nombre_Socio,		Num_Cuenta,			Sucursal,		FechaApertura,
            Tipo_Cuenta,		Fecha_Ult_Deposito,	FechaVencimiento,	PlazoDeposito,	FormaPagRendimientos,
            DiasCalculoInt,		TasaNominal,		SaldoPromedio,		Capital,		IntDevenNoPagados,
			SaldoTotalCieMes,	InteresGeneradoMes,	Tipo)
		SELECT	His.ClienteID AS Num_Socio,		Cli.NombreCompleto AS Nombre_Socio,					His.CuentaAhoID AS Num_Cuenta,
				SucursalOrigen AS Sucursal,		CONVERT(His.FechaApertura,DATE) AS Fecha_Apertura,	Tip.Descripcion AS Tipo_Cuenta,
				'' AS Fecha_Ult_Deposito,
				CONVERT(Fecha,CHAR) AS FechaVencimiento,
				CONVERT(PlazoDeposito_Cap,CHAR) AS PlazoDeposito,
				CONVERT((CASE WHEN GeneraInteres='S' THEN  CONVERT(30,CHAR) ELSE Sin_Rendimiento END),CHAR) AS FormaPagRendimientos,Cadena_Vacia AS DiasCalculoInt,
				CONVERT((CASE WHEN GeneraInteres='S' THEN CAST(His.TasaInteres AS CHAR)	ELSE Sin_Rendimiento END),CHAR) AS TasaNominal,
				His.SaldoProm AS SaldoPromedio,
				His.SaldoIniMes   AS Capital,
				Decimal_Cero AS IntDevenNoPagados,
				His.SaldoIniMes AS SaldoTotalCieMes,
				His.InteresesGen AS InteresGeneradoMes,	'A'
			FROM TIPOSCUENTAS  Tip,
				`HIS-CUENTASAHO` His,
				CLIENTES Cli,
				SUCURSALES Suc
					WHERE	His.ClienteID	<>Cliente_Inst
						AND Tip.TipoCuentaID= His.TipoCuentaID
						AND His.ClienteID	= Cli.ClienteID
						AND Suc.SucursalID	= His.SucursalID
						AND His.Fecha		= Par_FechaCorteAho;

		DROP TABLE IF EXISTS TMPMOVAHORROHIS;
		CREATE TEMPORARY TABLE TMPMOVAHORROHIS (
		SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN 'C' THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END) AS Saldo
			FROM `HIS-CUENAHOMOV` Mov
			WHERE Mov.Fecha >= Var_InicioPeriodo
			  AND Mov.Fecha <= Par_FechaCorte
			GROUP BY Mov.CuentaAhoID);
		CREATE INDEX id_indexCuentaAhoID ON TMPMOVAHORROHIS (CuentaAhoID);

		UPDATE	FoCoopCap			F,
				TMPMOVAHORROHIS		H	SET
			F.Capital			= F.Capital	+	H.Saldo,
			F.SaldoTotalCieMes	= F.SaldoTotalCieMes	+	H.Saldo
		WHERE	F.Num_Cuenta	= H.CuentaAhoID;
		DROP TABLE IF EXISTS TMPMOVAHORROHIS;


		DROP TABLE IF EXISTS TMPMOVAHORROHIS;
		CREATE TEMPORARY TABLE TMPMOVAHORROHIS (
			SELECT Mov.CuentaAhoID, SUM(CASE Mov.NatMovimiento WHEN 'C' THEN Mov.CantidadMov * -1 ELSE Mov.CantidadMov END) AS Saldo
				FROM CUENTASAHOMOV Mov
				WHERE Mov.Fecha <= Par_FechaCorte AND year(Mov.Fecha) = year(Par_FechaCorte)
				GROUP BY Mov.CuentaAhoID);
		CREATE INDEX id_indexCuentaAhoID ON TMPMOVAHORROHIS (CuentaAhoID);

		UPDATE	FoCoopCap			F,
				TMPMOVAHORROHIS		H	SET
			F.Capital			= F.Capital	+	H.Saldo,
			F.SaldoTotalCieMes	= F.SaldoTotalCieMes	+	H.Saldo
		WHERE	F.Num_Cuenta	= H.CuentaAhoID;
		DROP TABLE IF EXISTS TMPMOVAHORROHIS;



		DROP TABLE IF EXISTS TMPFECHADEPOSITO;
		CREATE TEMPORARY TABLE TMPFECHADEPOSITO (
			SELECT MAX(Fecha) AS Fecha,	CuentaAhoID
				FROM 	`HIS-CUENAHOMOV` H,
						FoCoopCap		 F
				WHERE	H.CuentaAhoID	= F.Num_Cuenta
				AND 	H.NatMovimiento	= 'A'
				AND		H.TipoMovAhoID IN (10,102,14,16,12,23)
				AND		H.Fecha			<=Par_FechaCorte
				GROUP BY CuentaAhoID	);

		CREATE INDEX id_indexCuentaAhoID ON TMPFECHADEPOSITO (CuentaAhoID);

		UPDATE	FoCoopCap			F,
				TMPFECHADEPOSITO	H	SET
			F.Fecha_Ult_Deposito	= H.Fecha
		WHERE	F.Num_Cuenta	= H.CuentaAhoID
		 AND	F.Tipo			= 'A';



		DROP TABLE IF EXISTS TMPFECHADEPOSITO;
		CREATE TEMPORARY TABLE TMPFECHADEPOSITO (
			SELECT MAX(Fecha) AS Fecha,	CuentaAhoID
				FROM 	`HIS-CUENAHOMOV` H,
						FoCoopCap		 F
				WHERE	H.CuentaAhoID	= F.Num_Cuenta
				AND 	H.NatMovimiento	= 'A'
				AND		H.TipoMovAhoID IN (200)
				AND		H.Fecha				<=Par_FechaCorte
				AND		IFNULL(F.Fecha_Ult_Deposito,'1900-01-01')='1900-01-01'
				GROUP BY CuentaAhoID	);

		CREATE INDEX id_indexCuentaAhoID ON TMPFECHADEPOSITO (CuentaAhoID);


		DELETE FROM FoCoopCap
			WHERE IFNULL(Fecha_Ult_Deposito,'1900-01-01') <= '1900-01-01'
				AND Capital = 0 ;

		DELETE FROM FoCoopCap WHERE Capital = 0 ;



		SELECT	Num_Socio,			Nombre_Socio,		Num_Cuenta,			Sucursal,		FechaApertura,
				Tipo_Cuenta,		CASE WHEN Fecha_Ult_Deposito = '1900-01-01' THEN '' ELSE Fecha_Ult_Deposito END AS Fecha_Ult_Deposito,
														FechaVencimiento,	PlazoDeposito,	FormaPagRendimientos,
				DiasCalculoInt,		TasaNominal/100 AS TasaNominal,		SaldoPromedio,
				ROUND(Capital,2) AS Capital,
				ROUND(IntDevenNoPagados,2) AS IntDevenNoPagados,
				ROUND(IFNULL(Capital,0),2)+ROUND(IFNULL(IntDevenNoPagados,0),2) AS SaldoTotalCieMes,
            ROUND(InteresGeneradoMes,2) AS InteresGeneradoMes, TIME(NOW()) AS HoraEmision
		FROM FoCoopCap
		ORDER BY Num_Socio, Num_Cuenta ;

		DROP TABLE IF EXISTS FoCoopCap;

	END IF;

	/* CARTERA */
	IF(Par_TipoReporte=Con_ReporteCre) THEN
		SELECT TipoContaMora
        INTO	Var_TipoContaMora
        FROM PARAMETROSSIS;

		DROP TABLE IF EXISTS FoCoopCre;
		CREATE TEMPORARY TABLE FoCoopCre (
			NombreCompleto		VARCHAR(200),
			Numero_Socio		INT(11),
			Contrato			BIGINT(12),
			Sucursal			INT(11),
			Clasificacion		VARCHAR(30),
			Producto			VARCHAR(100),
			PlazoCredito		INT(11),
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
			Formula				VARCHAR(100),
            NumeroRenov			INT(11),
            NumeroReest			INT(11),
			PRIMARY KEY (Contrato)
		);


		SET Par_FechaCorte := (SELECT MAX(Fecha) FROM  CALRESCREDITOS WHERE Fecha <= Par_FechaCorte);

		INSERT INTO FoCoopCre (
				NombreCompleto,	Numero_Socio,	Contrato,		Sucursal,			Clasificacion,
				Producto,		Tasa_Ordinaria,	Tasa_Moratoria,	Vigente_Vencido,	EPR_Cubierta,
				EPR_EXPUESTA,	Emproblemado,	RenReesNor,		MODALIDAD_PAGO,		Formula)
		SELECT	C.NombreCompleto,		C.ClienteID AS Numero_Socio,      CR.CreditoID AS Contrato,		CR.SucursalID AS Sucursal,
					(CASE  RES.Clasificacion	WHEN 'O' THEN 'CONSUMO'
									WHEN 'C' THEN 'COMERCIAL'
									WHEN 'H' THEN 'VIVIENDA' END) AS Clasificacion,
				REPLACE(P.Descripcion,",","") AS Producto,
				TasaFija/100 AS Tasa_Ordinaria,
				CASE CR.TipCobComMorato WHEN 'N' THEN (TasaFija*CR.FactorMora)/100
									 WHEN 'T' THEN CR.FactorMora/100 END AS Tasa_Moratoria,
				(CASE  CR.Estatus WHEN 'V' THEN 'VIGENTE' WHEN 'B' THEN 'VENCIDO' ELSE '' END) AS Vigente_Vencido,
				ReservaTotCubierto,	ReservaTotExpuesto, Cadena_Vacia, 'NORMAL',
				(CASE CR.FrecuenciaCap
					WHEN 'S'	THEN 'PAGO SEMANAL DE CAPITAL E INTERESES'
					WHEN 'C'	THEN 'PAGO CATORCENAL DE CAPITAL E INTERESES'
					WHEN 'Q'	THEN 'PAGO QUINCENAL DE CAPITAL E INTERESES'
					WHEN 'M'	THEN 'PAGO MENSUAL DE CAPITAL E INTERESES'
					WHEN 'P'	THEN 'PAGO POR PERIODO DE CAPITAL E INTERESES'
					WHEN 'B'	THEN 'PAGO BIMESTRAL DE CAPITAL E INTERESES'
					WHEN 'T'	THEN 'PAGO TRIMESTRAL DE CAPITAL E INTERESES'
					WHEN 'R'	THEN 'PAGO TETRAMESTRAL DE CAPITAL E INTERESES'
					WHEN 'E'	THEN 'PAGO SEMESTRAL DE CAPITAL E INTERESES'
					WHEN 'A'	THEN 'PAGO ANUAL DE CAPITAL E INTERESES'
					WHEN 'L'	THEN 'PAGOS DE CAPITAL E INTERESES LIBRES'
					WHEN 'U'	THEN 'PAGO UNICO DE CAPITAL E INTERESES'
					WHEN 'P'	THEN 'PAGO PERIODICO DE CAPITAL E INTERESES'
					ELSE 'PAGOS DE CAPITAL E INTERESES LIBRES' END ),
				F.Formula
			FROM		CALRESCREDITOS RES,
						CREDITOS CR LEFT JOIN FORMTIPOCALINT AS F ON CR.CalcInteresID=F.FormInteresID,
						CLIENTES C,
						PRODUCTOSCREDITO	P
				WHERE	RES.Fecha			= Par_FechaCorte
					AND RES.CreditoID		= CR.CreditoID
					AND CR.ClienteID		= C.ClienteID
					AND CR.ProductoCreditoID= P.ProducCreditoID ;

		DROP TABLE IF EXISTS TMPCREDITOINVGARFOC;
		CREATE TEMPORARY TABLE TMPCREDITOINVGARFOC
		SELECT SUM(T.MontoEnGar) AS MontoEnGar , T.CreditoID
			FROM FoCoopCre		F,
				 CREDITOINVGAR	T
			WHERE	F.Contrato		=	T.CreditoID
				AND FechaAsignaGar <= Par_FechaCorte
			GROUP BY T.CreditoID;


		UPDATE	FoCoopCre			F,
				TMPCREDITOINVGARFOC	T	SET
			F.MontoGL			=	T.MontoEnGar,
			F.CuentaGL			=	EsInversion
		WHERE F.Contrato		=	T.CreditoID;



		DROP TABLE IF EXISTS TMPHISCREDITOINVGAR;
		CREATE TEMPORARY TABLE TMPHISCREDITOINVGAR
		SELECT SUM(Gar.MontoEnGar) AS MontoEnGar , Gar.CreditoID
			FROM FoCoopCre		Tmp,
				 HISCREDITOINVGAR	Gar
			WHERE	Gar.Fecha > Par_FechaCorte
			  AND	Gar.FechaAsignaGar <= Par_FechaCorte
			  AND	Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
			  AND	Gar.CreditoID = Tmp.Contrato
			GROUP BY Gar.CreditoID;

		UPDATE	FoCoopCre			Tmp,
				TMPHISCREDITOINVGAR	Gar	SET
			Tmp.MontoGL		= IFNULL(Tmp.MontoGL, Decimal_Cero) + Gar.MontoEnGar,
			Tmp.CuentaGL	=	EsInversion
			WHERE	Gar.CreditoID = Tmp.Contrato;


		DROP TABLE IF EXISTS TMPMONTOGARCUENTAS;
		CREATE TEMPORARY TABLE TMPMONTOGARCUENTAS (
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

	-- ---------------------------------------------------
  -- Nueva sección para obtener Fecha ultimo pago de capital e intereses, el problema es la consulta, no se obtienen las fechas correctas y los montos,
  -- se corrigio con una tabla temporal para bucar las fechas y posteriormente los montos correspondientes al capital y los intereses
	-- Inicia sección para el Capital
	DROP TABLE IF EXISTS TMPCREDFECHAULTPAG;
	CREATE temporary TABLE TMPCREDFECHAULTPAG(
		CreditoID BIGINT(12),
		FechaPago DATE);

	INSERT INTO TMPCREDFECHAULTPAG (
		SELECT CreditoID,MAX(FechaPago)
			FROM DETALLEPAGCRE
			WHERE FechaPago<=Par_FechaCorte
			AND (MontoCapOrd+MontoCapAtr+MontoCapVen)>0.0
			GROUP BY CreditoID);

	DROP TABLE IF EXISTS TMPMONTOFECPAGCAP;
	CREATE temporary TABLE TMPMONTOFECPAGCAP AS(
		SELECT D.CreditoID,D.FechaPago,IFNULL((D.MontoCapOrd+D.MontoCapAtr+D.MontoCapVen),0.0) AS Monto
		FROM DETALLEPAGCRE D
			INNER JOIN TMPCREDFECHAULTPAG T
			ON D.CreditoID=T.CreditoID
			AND D.FechaPago=T.FechaPago);

	UPDATE FoCoopCre F,
		TMPMONTOFECPAGCAP T SET
		F.FechaUltPagoCap	= T.FechaPago,
		F.MontoUltPagCap	= T.Monto
	WHERE F.Contrato=T.CreditoID;
  -- Fin sección para el Capital
	-- Inicio sección para intereses
	TRUNCATE TMPCREDFECHAULTPAG;
	INSERT INTO TMPCREDFECHAULTPAG (
		SELECT CreditoID,MAX(FechaPago)
			FROM DETALLEPAGCRE
			WHERE FechaPago<=Par_FechaCorte
			AND (MontoIntOrd+MontoIntAtr+MontoIntVen+MontoIntMora)>0.0
			GROUP BY CreditoID);

	TRUNCATE TMPMONTOFECPAGCAP;
	INSERT INTO TMPMONTOFECPAGCAP (
		SELECT D.CreditoID,D.FechaPago,IFNULL((D.MontoIntOrd+D.MontoIntAtr+D.MontoIntVen+D.MontoIntMora),0.0) AS Monto
		FROM DETALLEPAGCRE D
			INNER JOIN TMPCREDFECHAULTPAG T
			ON D.CreditoID=T.CreditoID
			AND D.FechaPago=T.FechaPago);

	UPDATE FoCoopCre F,
		TMPMONTOFECPAGCAP T SET
		F.FechaUltPagoInteres	= T.FechaPago,
		F.MontoUltPagInteres	= T.Monto
	WHERE F.Contrato=T.CreditoID;

    DROP TABLE TMPMONTOFECPAGCAP;
    DROP TABLE TMPCREDFECHAULTPAG;
  -- Fin sección para intereses
	-- -----------------------------------------------------
		UPDATE	FoCoopCre		F ,
				REESTRUCCREDITO T
		SET  F.Emproblemado	=  EsEmproblemado
		WHERE T.CreditoDestinoID = F.Contrato
		 AND	T.Origen	= 'R';

		UPDATE	FoCoopCre		F ,
				REESTRUCCREDITO T
		SET  F.Emproblemado	=  EsEmproblemado
		WHERE T.CreditoDestinoID = F.Contrato
		 AND	T.Origen	= 'O';


		UPDATE	FoCoopCre		F ,
				REESTRUCCREDITO T
		SET  F.RenReesNor	=  'REESTRUCTURADO'
		WHERE T.CreditoDestinoID = F.Contrato
		 AND	T.Origen	= 'R';


		UPDATE	FoCoopCre		F ,
				REESTRUCCREDITO T
		SET  F.RenReesNor	=  'RENOVADO'
		WHERE T.CreditoDestinoID = F.Contrato
		 AND	T.Origen	= 'O';

		UPDATE FoCoopCre F
			INNER JOIN REESTRUCCREDITO T
		SET
			F.NumeroReest = IF(T.Origen='R',T.NumeroReest,NULL),
            F.NumeroRenov = IF(T.Origen='O',1,NULL)
		WHERE F.Contrato = T.CreditoOrigenID;


		DROP TABLE IF EXISTS TMPAMORTIZAFREFOCO;
		CREATE TEMPORARY TABLE TMPAMORTIZAFREFOCO
			SELECT F.AmortizacionID, F.CreditoID,
				CASE IFNULL(F.Capital,0) WHEN 0	THEN 0
												ELSE DATEDIFF(F.FechaVencim, F.FechaInicio) END AS FrecuenciaCap,
				CASE IFNULL(F.Interes,0) WHEN 0	THEN 0
												ELSE DATEDIFF(F.FechaVencim, F.FechaInicio) END AS FrecuenciaInt
				FROM	AMORTICREDITO	F,
						FoCoopCre		A
				WHERE F.CreditoID = A.Contrato ;
		CREATE INDEX id_indexCreditoID ON TMPAMORTIZAFREFOCO (CreditoID);

		DROP TABLE IF EXISTS TMPAMORTIZAFREFOCOFREC;
		CREATE TEMPORARY TABLE TMPAMORTIZAFREFOCOFREC
			SELECT AVG(FrecuenciaCap) AS FrecuenciaCap ,AVG(FrecuenciaInt) AS FrecuenciaInt,CreditoID
				FROM TMPAMORTIZAFREFOCO
				GROUP BY CreditoID;
		CREATE INDEX id_indexCreditoFID ON TMPAMORTIZAFREFOCOFREC (CreditoID);

		UPDATE	FoCoopCre				F,
				TMPAMORTIZAFREFOCOFREC	S	SET
			PeriodicidadCap	=	FrecuenciaCap,
			PeriodicidadInt	=	FrecuenciaInt
		WHERE S.CreditoID		=	F.Contrato;

		DROP TABLE IF EXISTS TMPAMORTIZAFREFOCO;
		DROP TABLE IF EXISTS TMPAMORTIZAFREFOCOFREC;


		UPDATE	FoCoopCre		F,
				SALDOSCREDITOS	S	SET
			PlazoCredito		=	(CASE S.FrecuenciaCap	WHEN 'M' THEN S.NumAmortizacion
											WHEN 'Q' THEN S.NumAmortizacion/2
											WHEN 'C' THEN S.NumAmortizacion/2
											WHEN 'S' THEN S.NumAmortizacion/4
											WHEN 'B' THEN S.NumAmortizacion*2
											WHEN 'T' THEN S.NumAmortizacion*3
											WHEN 'R' THEN S.NumAmortizacion*4
											WHEN 'E' THEN S.NumAmortizacion*6
											WHEN 'A' THEN S.NumAmortizacion*12
											WHEN 'U' THEN ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio)/30.5,0)
											WHEN 'P' THEN ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio)/30.5,0)
											WHEN 'L' THEN ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio)/30.5,0) END),
			F.PeriodicidadCap		=	(CASE S.FrecuenciaCap
											WHEN 'M' THEN S.PeriodicidadCap
											WHEN 'Q' THEN S.PeriodicidadCap
											WHEN 'C' THEN S.PeriodicidadCap
											WHEN 'S' THEN S.PeriodicidadCap
											WHEN 'B' THEN S.PeriodicidadCap
											WHEN 'T' THEN S.PeriodicidadCap
											WHEN 'R' THEN S.PeriodicidadCap
											WHEN 'E' THEN S.PeriodicidadCap
											WHEN 'A' THEN S.PeriodicidadCap
											WHEN 'U' THEN ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio),0)
											WHEN 'P' THEN S.PeriodicidadCap
											ELSE F.PeriodicidadCap*1	END),
			F.PeriodicidadInt		=	(CASE S.FrecuenciaInt
											WHEN 'M' THEN S.PeriodicidadInt
											WHEN 'Q' THEN S.PeriodicidadInt
											WHEN 'C' THEN S.PeriodicidadInt
											WHEN 'S' THEN S.PeriodicidadInt
											WHEN 'B' THEN S.PeriodicidadInt
											WHEN 'T' THEN S.PeriodicidadInt
											WHEN 'R' THEN S.PeriodicidadInt
											WHEN 'E' THEN S.PeriodicidadInt
											WHEN 'A' THEN S.PeriodicidadInt
											WHEN 'U' THEN ROUND(DATEDIFF(S.FechaVencimiento,S.FechaInicio),0)
											WHEN 'P' THEN S.PeriodicidadInt
											ELSE F.PeriodicidadCap*1 END),
			F.Fecha_Otorgamiento	=	S.FechaInicio,
			F.Fecha_Vencimien		=	S.FechaVencimiento,
			F.Monto_Original		=	S.MontoCredito,
			F.Dias_Mora				=	S.DiasAtraso,
			F.SalCapVigente			=	ROUND(S.SalCapVigente,2)+ROUND(S.SalCapAtrasado,2),
			F.SalCapVencido			=	ROUND(S.SalCapVencido,2)+ROUND(S.SalCapVenNoExi,2),
			F.SalIntOrdinario		= (CASE  Var_TipoContaMora
											WHEN TipoIngresos THEN S.SalIntOrdinario+SalIntProvision+SalIntAtrasado+S.SalMoratorios
											ELSE S.SalIntOrdinario+SalIntProvision+SalIntAtrasado
										END),
			F.SalIntVencido			=	S.SalIntVencido+SaldoMoraVencido,
			F.SalIntNoConta			=	S.SalIntNoConta+SaldoMoraCarVen,
			F.SalMoratorios			=	(IFNULL(S.SalMoratorios,0)+ IFNULL(S.SaldoMoraVencido,0)+ IFNULL(S.SaldoMoraCarVen,0)),
			F.EPR_InteresesCaVe		=	 CASE WHEN S.EstatusCredito = "B" THEN ROUND(S.SaldoMoraVencido,2) +
												ROUND(S.SalIntProvision,2) +	ROUND(S.SalIntVencido,2)  END ,
			F.Vigente_Vencido		= (CASE  S.EstatusCredito WHEN 'V' THEN 'VIGENTE' WHEN 'B' THEN 'VENCIDO' ELSE "" END),
			F.EstatusCredito		= S.EstatusCredito
		WHERE S.CreditoID		=	F.Contrato
			AND S.FechaCorte	=	Par_FechaCorte;



		DELETE FROM FoCoopCre WHERE IFNULL(Vigente_Vencido,"") = "";
		DELETE FROM FoCoopCre WHERE (EstatusCredito <> 'V' AND  EstatusCredito <> "B");

		UPDATE	FoCoopCre			Car	,
				RELACIONCLIEMPLEADO	Rel		,
				TIPORELACIONES		Tip	SET
			CargoAcreditado	= 	4
		WHERE	Rel.TipoRelacion	= 2
			AND Car.Numero_Socio	= Rel.ClienteID
				AND TipoRelacionID		= Rel.ParentescoID
			AND Grado IN 	(1, 2);


		UPDATE	FoCoopCre			Car	,
				CLIEMPRELACIONADO	Rel		SET
			CargoAcreditado	= 	4
		WHERE	Car.Numero_Socio	= Rel.ClienteID
			AND Rel.EmpleadoID 		> 0
			AND TienePoder		= 'S';


		UPDATE	FoCoopCre		Car	,
				CLIEMPRELACIONADO	Rel		SET
			CargoAcreditado	= 	2
		WHERE	Car.Numero_Socio	= Rel.ClienteID
			AND TienePoder		= 'S';



		UPDATE	FoCoopCre		Car	,
				CLIEMPRELACIONADO	Emp	,
				RELACIONCLIEMPLEADO	Rel	,
				TIPORELACIONES		Tip SET
			CargoAcreditado	= 	3
		WHERE	Rel.TipoRelacion	= 1
			AND Car.Numero_Socio	= Rel.ClienteID
				AND Rel.RelacionadoID = Emp.ClienteID
				AND TienePoder			= 'S'
				AND TipoRelacionID		= Rel.ParentescoID
				AND Grado IN 	(1, 2);





		SELECT	F.NombreCompleto,		Numero_Socio,						Contrato,			F.Sucursal,		Clasificacion,
				Producto,			MODALIDAD_PAGO AS MODALIDAD_PAGO,	Fecha_Otorgamiento,	F.Monto_Original,	Fecha_Vencimien,
				Tasa_Ordinaria,		Tasa_Moratoria,						PlazoCredito,
				PeriodicidadCap AS FrecuenciaPagoCapital,
				PeriodicidadInt AS FrecuenciaPagoInt,
				Dias_Mora,			F.SalCapVigente AS Saldo_Capital_Vigente,	F.SalCapVencido AS SaldoCapitalVencido,
				F.SalIntOrdinario AS Interes_Dev_NoCob_Vig,
				SalIntVencido AS Interes_Dev_NoCob_Ven,	SalIntNoConta AS INTERES_DEVEN_NOCOB_CuentasOrden,
				SalMoratorios AS InteresMoratorio,
				FechaUltPagoCap,	MontoUltPagCap,		F.FechaUltPagoInteres,	MontoUltPagInteres,
				RenReesNor AS RenReesNor,
				Emproblemado,	Vigente_Vencido,	IFNULL(CargoAcreditado,'') AS CargoDelAcreditado, 	MontoGL AS MontoGarantiaLiquida,	CuentaGL AS GarantiaLiquida,
				IFNULL(GarPrendaria,0.0) AS MontoGarantiaPrendaria,	IFNULL(GarHipotecaria,0.0) AS MontoGarantiaHipoteca,	EPR_Cubierta,	EPR_EXPUESTA,
				EPR_InteresesCaVe, TIME(NOW()) AS HoraEmision,
				Formula, NumeroRenov, NumeroReest
				FROM	FoCoopCre F
					LEFT OUTER JOIN CREGARPRENHIPO	T ON F.Contrato = T.CreditoID;


		DROP TABLE IF EXISTS FoCoopCre;
	END IF;


	IF(Par_TipoReporte=Con_ReporteApo) THEN

		DROP TABLE IF EXISTS FocoopCapSoc;
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


		INSERT INTO FocoopCapSoc (ClienteID, ParteSocial, Fecha,HoraEmision)

		SELECT	Apo.ClienteID,COALESCE((CASE WHEN (SUM(CASE WHEN Tipo="D" THEN Monto*-1 ELSE Monto END)<0) THEN 0 ELSE
					SUM(CASE WHEN Tipo="D" THEN Monto*-1 ELSE Monto END) END),Saldo)AS ParteSocial,MAX(Fecha) AS Fecha, TIME(NOW()) AS HoraEmision
			FROM APORTACIONSOCIO Apo
			LEFT OUTER JOIN APORTASOCIOMOV Apm
				ON Apo.ClienteID=Apm.ClienteID
				WHERE Apm.Fecha <=  Par_FechaCorte
				GROUP BY Apo.ClienteID;


		UPDATE	FocoopCapSoc F,
				CLIENTES C
			SET
				F.Nombre   =	CONCAT(C.PrimerNombre,'',IFNULL(C.SegundoNombre,''),IFNULL(C.TercerNombre,'')),
				F.ApellidoPaterno = (C.ApellidoPaterno),
				F.ApellidoMaterno = C.ApellidoMaterno,
				F.CURP = C.CURP,
				F.TipoAportacion = "Certificado de Aportacion",
				F.FechaAlta = C.FechaAlta,
				F.Sexo  = CASE WHEN C.Sexo ="M" THEN "MASCULINO" ELSE "FEMENINO" END
			WHERE 	COALESCE(F.Fecha,DATE(C.FechaAlta))<=Par_FechaCorte
					AND F.ClienteID=C.ClienteID;


		SELECT	F.ClienteID,								MAX(F.Nombre) AS Nombre,	MAX(F.ApellidoPaterno) AS ApellidoPaterno,
				MAX(F.ApellidoMaterno) AS ApellidoMaterno,	MAX(F.CURP) AS CURP,		MAX(F.TipoAportacion) AS TipoAportacion,
				MAX(F.FechaAlta) AS FechaAlta,				MAX(F.Sexo) AS Sexo, 		MAX(F.ParteSocial) AS ParteSocial,
				MAX(F.HoraEmision) AS HoraEmision
		FROM FocoopCapSoc F,
			 CLIENTES C
		WHERE COALESCE(F.Fecha,DATE(C.FechaAlta))<=Par_FechaCorte
					AND F.ClienteID=C.ClienteID
					AND F.ParteSocial>0
					GROUP BY F.ClienteID;

END IF;

END ManejoErrores;

END TerminaStore$$