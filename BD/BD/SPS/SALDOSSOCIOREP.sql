-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSSOCIOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSSOCIOREP`;DELIMITER $$

CREATE PROCEDURE `SALDOSSOCIOREP`(
	-- sp que se usara para el reporte de saldos por socio
	Par_ClienteID				INT(11),
	Par_SeccionRep				INT(11),
	Par_CreditoID				BIGINT(12),

	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT (11),
	Aud_NumTransaccion			BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero 		INT(11);
	DECLARE Decimal_Cero 		DECIMAL(16,2);
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE Est_Inactivo		CHAR(1);
	DECLARE Est_InactivoDes		CHAR(15);

	DECLARE Est_Autorizado		CHAR(1);
	DECLARE Est_AutorizadoDes	CHAR(15);
	DECLARE Est_Pagado			CHAR(1);
	DECLARE Est_PagadoDes		CHAR(15);
	DECLARE Est_Castigado		CHAR(1);

	DECLARE Var_Si				CHAR(1);
 	DECLARE Est_CastigadoDes	CHAR(15);
	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_VigenteDes		CHAR(15);
	DECLARE Est_Vencido			CHAR(1);

	DECLARE Est_VencidoDes		CHAR(15);
	DECLARE SiPagaIVA 			CHAR(1);
	DECLARE	FechaSist			DATE;
    DECLARE Est_CreN			CHAR(15);
    DECLARE NatMov				CHAR(15);

    DECLARE Tipo_Blo			INT(11);
    DECLARE Nat_Mov				CHAR(15);
    DECLARE TipoCob_N			CHAR(15);
    DECLARE TipoCob_T			CHAR(15);

    DECLARE Var_FechaUltDepo	DATE;
    DECLARE Var_FechaUltPagoCap	DATE;
    DECLARE Var_MontoUltPagCap	DECIMAL(16,2);


 -- Declaracion de Secciones
	DECLARE SecEncabezado 		INT(11);
	DECLARE SecDetalleCreds 	INT(11);
	DECLARE SecAvales		 	INT(11);
    DECLARE SecDetalleCuent		INT(11);

    -- Declacion de Variables
	DECLARE Var_DiasMora		INT(11);
	DECLARE	Var_FechaDesembolso	DATE;
	DECLARE	Var_FechaVencimien	DATE;
	DECLARE Var_CliPagIVA 		CHAR(1);
	DECLARE Var_IVAIntOrd 		CHAR(1);

	DECLARE Var_IVAIntMor 		CHAR(1);
	DECLARE Var_ValIVAIntOr 	DECIMAL(12,2);
	DECLARE Var_ValIVAIntMo 	DECIMAL(12,2);
	DECLARE Var_IVASucurs 		DECIMAL(12,2);
	DECLARE Var_SaldoInteresOrd	DECIMAL(16,2);

	DECLARE Var_SaldoInteresAtr	DECIMAL(16,2);
	DECLARE Var_SaldoInteresVen	DECIMAL(16,2);
	DECLARE Var_SaldoInteresPro	DECIMAL(16,2);
	DECLARE Var_SaldoIntNoConta	DECIMAL(16,2);
	DECLARE Var_SaldoIVAInteres	DECIMAL(16,2);

	DECLARE Var_SaldoMoratorios	DECIMAL(16,2);
	DECLARE Var_SaldoIVAMorato	DECIMAL(16,2);
	DECLARE Var_TotalCapital	DECIMAL(16,2);
 	DECLARE Var_SucCredito		VARCHAR(100);
	DECLARE Var_Descripcion		VARCHAR(100);

	DECLARE Var_EstatusCred		VARCHAR(100);
    DECLARE	Var_AhoOrdDisp		DECIMAL(16,2);
	DECLARE	Var_AhoOrdPren		DECIMAL(16,2);
	DECLARE	Var_AhoVisDisp		DECIMAL(16,2);
	DECLARE	Var_AhoVisPren		DECIMAL(16,2);

	DECLARE	Var_AhoPlaDisp		DECIMAL(16,2);
	DECLARE	Var_AhoPlaPren		DECIMAL(16,2);
	DECLARE	Var_TotalHaberes	DECIMAL(16,2);
	DECLARE	Var_Profun			DECIMAL(16,2);
    DECLARE Var_AhoOrd			INT(11);

    DECLARE Var_AhoVis			INT(11);
    DECLARE Var_IDPro			INT(11);
    DECLARE Var_TasaOr			DECIMAL(16,2);
    DECLARE Var_TasaMor			DECIMAL(16,2);
    DECLARE	Var_TotalIva		DECIMAL(16,2);
    DECLARE	Var_ClienteID		INT(11);
	DECLARE Var_HaberCre		DECIMAL(16,2);


	DECLARE CursorCreditos CURSOR FOR
		SELECT		cre.CreditoID, cre.ProductoCreditoID,	pro.Descripcion AS ProductoCredito,
					CASE	WHEN cre.Estatus=Est_Inactivo 	THEN	Est_InactivoDes
							WHEN cre.Estatus=Est_Autorizado THEN	Est_AutorizadoDes
							WHEN cre.Estatus=Est_Pagado 	THEN	Est_PagadoDes
							WHEN cre.Estatus=Est_Vencido 	THEN 	Est_VencidoDes
							WHEN cre.Estatus=Est_Vigente 	THEN 	Est_VigenteDes
					 END AS EstatusCredito,
					 cre.FechaMinistrado AS FechaDesembolso, cre.FechaVencimien,
					 FUNCIONDIASATRASO(cre.CreditoID,	FechaSist) AS DiasMora, cre.TasaFija AS TasaOr,
					CASE	WHEN pro.TipCobComMorato=TipoCob_N		THEN	cre.FactorMora*cre.TasaFija
							WHEN pro.TipCobComMorato=TipoCob_T		THEN	cre.FactorMora
					END AS TasaMor,
					 Cli.PagaIVA,	cre.SucursalID,		pro.CobraIVAInteres,	pro.CobraIVAMora
			FROM CREDITOS cre
					INNER JOIN PRODUCTOSCREDITO pro
						ON cre.ProductoCreditoID	= pro.ProducCreditoID
					INNER JOIN CLIENTES	Cli
						ON cre.ClienteID		= Cli.ClienteID
				WHERE	cre.ClienteID			= Par_ClienteID
				AND (cre.Estatus=Est_Vigente OR cre.Estatus=Est_Vencido);

 -- Asignación de constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero 			:= 0;
	SET Cadena_Vacia 			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET Est_Inactivo			:= 'I';
	SET Est_InactivoDes			:= 'INACTIVO';

	SET Est_Autorizado			:= 'A';
	SET Est_AutorizadoDes		:= 'AUTORIZADO';
	SET Var_Si					:= 'S';
	SET Est_Pagado				:= 'P';
	SET Est_PagadoDes			:= 'PAGADO';

	SET Est_Castigado			:= 'K';
 	SET Est_CastigadoDes		:= 'CASTIGADO';
	SET Est_Vigente				:= 'V';
	SET Est_VigenteDes			:= 'VIGENTE';
	SET Est_Vencido				:= 'B';

	SET Est_VencidoDes			:= 'VENCIDO';
	SET SiPagaIVA 				:= 'S';
    SET Est_CreN				:= 'N';
	SET NatMov					:= 'B';
    SET Tipo_Blo				:=  8;
    SET Nat_Mov					:= 'A';
    SET TipoCob_N				:= 'N';
    SET TipoCob_T				:= 'T';

 -- Asignacion de las secciones
	SET SecEncabezado 		:= 1; -- Seccion de Encabezado donde van los datos generales del Cliente
	SET SecDetalleCreds 	:= 2; -- Seccion de Detalle donde van los diferentes Creditos del cliente
	SET SecAvales			:= 3; -- Seccion donde van los diferentes avales
    SET SecDetalleCuent 	:= 4; -- Seccion de detalle de saldo de las cuentas

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);


 -- 1.- Seccion de Encabezado donde van los Datos Generales del Cliente
	IF Par_SeccionRep = SecEncabezado THEN
		SELECT	Cli.ClienteID,	Cli.NombreCompleto, Dir.DireccionCompleta, Dir.Descripcion, Cli.TelefonoCelular,
					Apor.Saldo as PartSocial
				FROM CLIENTES Cli
					LEFT JOIN DIRECCLIENTE Dir
						ON	Cli.ClienteID	= Dir.ClienteID
						AND	Dir.Oficial		= Var_Si
					LEFT JOIN APORTACIONSOCIO Apor
						ON Cli.ClienteID	= Apor.ClienteID
				WHERE Cli.ClienteID	= Par_ClienteID
				LIMIT 1;
	 END IF;

 -- 2.- Seccion de Detalle donde van los Diferentes Creditos del Cliente
	IF Par_SeccionRep = SecDetalleCreds THEN

		/*TABLA TEMPORAL DE DETALLECUENTAS */
		DROP TABLE IF EXISTS TMPDATOSCUENTASPS;
		CREATE TEMPORARY TABLE TMPDATOSCUENTASPS(
			ClienteID			BIGINT,
			AhoOrdDisp			DECIMAL(16,2),
			AhoOrdPren			DECIMAL(16,2),
			AhoVisDisp			DECIMAL(16,2),
			AhoVisPren			DECIMAL(16,2),

			AhoPlaDisp			DECIMAL(16,2),
			AhoPlaPren			DECIMAL(16,2),
			TotalHaberes		DECIMAL(16,2),
			Profun				DECIMAL(16,2),
			FechaUltDeposito	DATE);

		/*TABLA TEMPORAL DE CREDITOS */
		DROP TABLE IF EXISTS TMPSALDOSSOCIOSPS;
		CREATE TEMPORARY TABLE TMPSALDOSSOCIOSPS(
			CreditoID			BIGINT,
			ClienteID			BIGINT,
			ProductoID			INT(11),
			Descripcion			VARCHAR(100),
			EstatusCred			VARCHAR(100),
			FechaDesembolso		DATE,
			FechaVencimien		DATE,
			DiasMora			INT(11),
            TasaOr				DECIMAL(16,2),
            TasaMor				DECIMAL(16,2),
			CliPagIVA			CHAR(1),
			SucCredito			INT(11),
			IVAIntOrd			CHAR(1),
			IVAIntMor			CHAR(1),
			SaldoInteresOrd		DECIMAL(16,2),
			SaldoInteresAtr		DECIMAL(16,2),
			SaldoInteresVen		DECIMAL(16,2),
			SaldoInteresPro		DECIMAL(16,2),
			SaldoIntNoConta		DECIMAL(16,2),
			SaldoIVAInteres		DECIMAL(16,2),
			SaldoMoratorios		DECIMAL(16,2),
			SaldoIVAMorato		DECIMAL(16,2),
			TotalCapital		DECIMAL(16,2),
            TotalIVA			DECIMAL(16,2),
			FechaUltPagoCap		DATE,
			MontoUltPagCap		DECIMAL(16,2),
			AhoOrdDisp			DECIMAL(16,2),
			AhoOrdPren			DECIMAL(16,2),
			AhoVisDisp			DECIMAL(16,2),
			AhoVisPren			DECIMAL(16,2),
			AhoPlaDisp			DECIMAL(16,2),
			AhoPlaPren			DECIMAL(16,2),
			TotalHaberes		DECIMAL(16,2),
            HaberCre			DECIMAL(16,2),
			Profun				DECIMAL(16,2),
			FechaUltDeposito	DATE
            );

        -- SE OBTIENEN LOS VALORES DE LAS CUENTAS DEL CLIENTE
        -- CONSULTAR DE PARAMETROS CAJA LOS TIPOS DE CUENTA
		SELECT	CtaOrdinaria,	CuentaVista
		 INTO	Var_AhoOrd,		Var_AhoVis
			FROM	PARAMETROSCAJA;

		-- Profun
		SELECT	IFNULL(MontoPendiente,Entero_Cero)	INTO	Var_Profun
			FROM	CLICOBROSPROFUN
			WHERE	ClienteID=Par_ClienteID;

		-- --------------------------------------------------------Ahorro a plazo
		SELECT	SUM(IFNULL( I.Monto,Entero_Cero)) AS DISPONIBLE
		 INTO	Var_AhoPlaDisp
			FROM  INVERSIONES I
				WHERE	ClienteID	= Par_ClienteID
					AND Estatus		= Est_CreN;

		-- MONTO PRENDADO POR INVERSIONES
		SELECT	SUM(IFNULL(CI.MontoEnGar,Entero_Cero)) AS Prendado
		 INTO	Var_AhoPlaPren
			FROM  INVERSIONES I
				INNER JOIN CREDITOINVGAR CI	ON I.InversionID	= CI.InversionID
			WHERE	ClienteID	= Par_ClienteID
				AND	Estatus		= Est_CreN;

		-- -------------------------------------------------Ahorro Ordinario
		SELECT	SUM(CASE WHEN C.TipoCuentaID = Var_AhoOrd	THEN	IFNULL(C.SaldoDispon,Decimal_Cero)
						ELSE	Decimal_Cero END),
				SUM(CASE WHEN C.TipoCuentaID = Var_AhoVis	THEN	IFNULL(C.SaldoDispon,Decimal_Cero)
						ELSE	Decimal_Cero END)
		 INTO	Var_AhoOrdDisp,				Var_AhoVisDisp
			FROM	CUENTASAHO C
			WHERE	C.ClienteID		= Par_ClienteID;

		SELECT	SUM(CASE WHEN C.TipoCuentaID = Var_AhoOrd	THEN	IFNULL( B.MontoBloq,Decimal_Cero)
						ELSE	Decimal_Cero END),
				SUM(CASE WHEN C.TipoCuentaID = Var_AhoVis	THEN	IFNULL( B.MontoBloq,Decimal_Cero)
						ELSE	Decimal_Cero END)
		 INTO	Var_AhoOrdPren,		Var_AhoVisPren
			FROM BLOQUEOS B
				INNER JOIN CUENTASAHO C
					ON	C.CuentaAhoID	= B.CuentaAhoID
					AND	C.ClienteID		= Par_ClienteID
			WHERE 	B.NatMovimiento	= NatMov
			 AND 	TiposBloqID		= Tipo_Blo
			 AND 	FolioBloq		= Decimal_Cero;


		-- SE OBTIENE LA FECHA DEL ULTIMO DEPOSITO
		DROP TABLE IF EXISTS TMPFECHADEPOSITO;
		CREATE TEMPORARY TABLE TMPFECHADEPOSITO (
			Fecha				DATE,
			CuentaAhoID			BIGINT(12));
		CREATE INDEX id_indexCuentaAhoID ON TMPFECHADEPOSITO (CuentaAhoID);

		INSERT INTO TMPFECHADEPOSITO
			SELECT MAX(Fecha) AS Fecha,	F.CuentaAhoID
				FROM 	`HIS-CUENAHOMOV` H
					INNER JOIN CUENTASAHO	F
						ON	H.CuentaAhoID	= F.CuentaAhoID
						AND	F.ClienteID		= Par_ClienteID
				WHERE	H.NatMovimiento	= Nat_Mov
				AND		H.TipoMovAhoID IN (10,102,14,16,12,23)
				AND		H.Fecha			<=FechaSist
				GROUP BY F.CuentaAhoID;

		INSERT INTO TMPFECHADEPOSITO
			SELECT	H.Fecha,	F.CuentaAhoID
				FROM 	CUENTASAHOMOV H
					INNER JOIN CUENTASAHO	F
						ON	H.CuentaAhoID	= F.CuentaAhoID
						AND	F.ClienteID		= Par_ClienteID
				WHERE	H.NatMovimiento	= Nat_Mov
				AND		H.TipoMovAhoID IN (10,102,14,16,12,23)
				GROUP BY F.CuentaAhoID, H.Fecha;

		SET Var_FechaUltDepo	:= (SELECT	MAX(Fecha) FROM 	TMPFECHADEPOSITO); -- FECHA DE ULTIMO DEPOSITO



		-- ASEGURAMOS NO TENER VALORES NULOS
		SET Var_AhoOrdDisp	:=	IFNULL(Var_AhoOrdDisp,Decimal_Cero);
		SET Var_AhoVisDisp	:=	IFNULL(Var_AhoVisDisp,Decimal_Cero);
		SET Var_AhoPlaDisp	:=	IFNULL(Var_AhoPlaDisp,Decimal_Cero);
		SET Var_AhoPlaPren	:=	IFNULL(Var_AhoPlaPren,Decimal_Cero);
		SET Var_TotalHaberes:=	IFNULL(Var_AhoOrdDisp +Var_AhoVisDisp+Var_AhoPlaDisp-Var_Profun,Entero_Cero);
		SET Var_FechaUltDepo	:= IFNULL(Var_FechaUltDepo,Fecha_Vacia);

        -- SE INSERTAN LOS VALORES EN LA TABLA DE AYUDA DE AHORRO
		INSERT INTO TMPDATOSCUENTASPS (
			ClienteID,		AhoOrdDisp,		AhoOrdPren,			AhoVisDisp,		AhoVisPren,
			AhoPlaDisp,		AhoPlaPren,		TotalHaberes,		Profun,			FechaUltDeposito
		)
		SELECT
			Par_ClienteID,	Var_AhoOrdDisp,	Var_AhoOrdPren,		Var_AhoVisDisp,	Var_AhoVisPren,
			Var_AhoPlaDisp, Var_AhoPlaPren,	Var_TotalHaberes,	Var_Profun,		Var_FechaUltDepo;


		/*SI EL SP RECIBE UN NUMERO DE CREDITO */ -- ******************************************************************
		IF (Par_CreditoID > Entero_Cero) THEN

			SELECT	cre.ProductoCreditoID,	pro.Descripcion AS ProductoCredito,
					CASE	WHEN cre.Estatus=Est_Inactivo 	THEN	Est_InactivoDes
							WHEN cre.Estatus=Est_Autorizado THEN	Est_AutorizadoDes
							WHEN cre.Estatus=Est_Pagado 	THEN	Est_PagadoDes
							WHEN cre.Estatus=Est_Vencido 	THEN 	Est_VencidoDes
							WHEN cre.Estatus=Est_Vigente 	THEN 	Est_VigenteDes
					 END AS EstatusCredito,
					cre.FechaMinistrado AS FechaDesembolso, cre.FechaVencimien,
					FUNCIONDIASATRASO(cre.CreditoID,	FechaSist) AS DiasMora, cre.TasaFija AS TasaOR,
                    CASE	WHEN pro.TipCobComMorato=TipoCob_N		THEN	cre.FactorMora*cre.TasaFija
							WHEN pro.TipCobComMorato=TipoCob_T		THEN	cre.FactorMora
					END AS TasaMor,
					Cli.PagaIVA,	cre.SucursalID,		pro.CobraIVAInteres,	pro.CobraIVAMora
			INTO	Var_IDPro,		Var_Descripcion,	Var_EstatusCred,		Var_FechaDesembolso,	Var_FechaVencimien,
					Var_DiasMora,	Var_TasaOr,			Var_TasaMor,			Var_CliPagIVA,			Var_SucCredito,			Var_IVAIntOrd,
                    Var_IVAIntMor
			FROM CREDITOS cre
					INNER JOIN PRODUCTOSCREDITO pro
						ON cre.ProductoCreditoID	= pro.ProducCreditoID
                  	INNER JOIN CLIENTES	Cli
						ON cre.ClienteID = Cli.ClienteID
				WHERE	cre.CreditoID	= Par_CreditoID
                AND (cre.Estatus=Est_Vigente OR cre.Estatus=Est_Vencido);

			-- SE VERIFICA SI EL CLIENTE PAGA IVA
			SET Var_CliPagIVA	:= IFNULL(Var_CliPagIVA, SiPagaIVA);
			IF (Var_CliPagIVA = SiPagaIVA) THEN
				SET	Var_IVASucurs	:= IFNULL((SELECT IVA
												FROM SUCURSALES
												 WHERE SucursalID = Var_SucCredito), Entero_Cero);

					-- Verificamos si Paga IVA de Interes Ordinario
				IF (Var_IVAIntOrd = SiPagaIVA) THEN
					SET Var_ValIVAIntOr := Var_IVASucurs;
				END IF;

				IF (Var_IVAIntMor = SiPagaIVA) THEN
					SET Var_ValIVAIntMo := Var_IVASucurs;
				END IF;
			END IF;

			SELECT
				IFNULL(SUM(ROUND(SaldoInteresOrd,2)+ROUND(SaldoInteresPro,2)),Decimal_Cero) AS SaldoInteresOrd,
				IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Decimal_Cero) AS SaldoInteresAtr,
				IFNULL(SUM(ROUND(SaldoInteresVen,2)),Decimal_Cero) AS SaldoInteresVen,
				IFNULL(SUM(ROUND(SaldoInteresPro,2)),Decimal_Cero) AS SaldoInteresPro,
				IFNULL(SUM(ROUND(SaldoIntNoConta,2)),Decimal_Cero) AS SaldoIntNoConta,

				SUM(ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr,2) +
								 ROUND(SaldoInteresAtr * Var_ValIVAIntOr,2) +
								 ROUND(SaldoInteresPro * Var_ValIVAIntOr,2) +
								 ROUND(SaldoIntNoConta * Var_ValIVAIntOr,2), 2)) AS SaldoIVAInteres,

				IFNULL(SUM(SaldoIntNoConta+SaldoInteresVen+SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero) AS SaldoMoratorios,

				IFNULL(SUM(ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(SaldoInteresVen * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo, 2),
										2)),Entero_Cero) AS SaldoIVAMorato,

				IFNULL(SUM(SaldoCapVigente	+ SaldoCapAtrasa + SaldoCapVencido	+ SaldoCapVenNExi),
							 Entero_Cero) AS totalCapital,

				IFNULL(SUM(ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(SaldoInteresVen * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo, 2),
										2)),Entero_Cero) + 				SUM(ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr,2) +
								 ROUND(SaldoInteresAtr * Var_ValIVAIntOr,2) +
								 ROUND(SaldoInteresPro * Var_ValIVAIntOr,2) +
								 ROUND(SaldoIntNoConta * Var_ValIVAIntOr,2), 2))
                                         AS totalIva,

    IFNULL(SUM(SaldoCapVigente	+ SaldoCapAtrasa + SaldoCapVencido	+ SaldoCapVenNExi+ SaldoInteresOrd
                             + SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen
                             + SaldoIVAInteres	+ SaldoIVAMorato ),Entero_Cero) as TotHaberCre

			INTO	Var_SaldoInteresOrd,	Var_SaldoInteresAtr,	Var_SaldoInteresVen,	Var_SaldoInteresPro,	Var_SaldoIntNoConta,
					Var_SaldoIVAInteres,	Var_SaldoMoratorios,	Var_SaldoIVAMorato,		Var_TotalCapital, Var_TotalIva, Var_HaberCre
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID;

			-- SE OBTIENE LA ULTIMA FECHA DE PAGO Y MONTO DE PAGO
			SELECT		MAX(FechaPago) AS Var_FechaPago,	IFNULL(SUM(MontoCapOrd+MontoCapAtr+MontoCapVen),0.0) AS Var_Monto
				INTO	Var_FechaUltPagoCap,				Var_MontoUltPagCap
				FROM 	DETALLEPAGCRE 	D
				WHERE	D.CreditoID	=	Par_CreditoID
					AND	FechaPago	<=	FechaSist
					GROUP BY D.CreditoID HAVING SUM(MontoCapOrd+MontoCapAtr+MontoCapVen)>0.0
					ORDER BY FechaPago DESC;

			-- SE GUARDAN LOS REGISTROS EN LA TABLA DE AYUDA
			INSERT INTO TMPSALDOSSOCIOSPS (
				CreditoID,				ProductoID,				Descripcion,			EstatusCred,			FechaDesembolso,
				FechaVencimien,			DiasMora,				TasaOr,					TasaMor,				CliPagIVA,
                SucCredito,				IVAIntOrd,
				IVAIntMor,				SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresVen,		SaldoInteresPro,
				SaldoIntNoConta,		SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorato,			TotalCapital,
								FechaUltPagoCap,		MontoUltPagCap,			ClienteID
			)
			SELECT
				Par_CreditoID,			Var_IDPro,				Var_Descripcion,		Var_EstatusCred,		Var_FechaDesembolso,
				Var_FechaVencimien,		Var_DiasMora,			Var_TasaOr,				Var_TasaMor,				Var_CliPagIVA,
                Var_SucCredito,			Var_IVAIntOrd,
				Var_IVAIntMor,			Var_SaldoInteresOrd,	Var_SaldoInteresAtr,	Var_SaldoInteresVen,	Var_SaldoInteresPro,
				Var_SaldoIntNoConta,	Var_SaldoIVAInteres,	Var_SaldoMoratorios,	Var_SaldoIVAMorato,		Var_TotalCapital,
                           Var_FechaUltPagoCap,	Var_MontoUltPagCap,		Par_ClienteID;

                           UPDATE	TMPSALDOSSOCIOSPS	T
					SET
                T.TotalIVA	=IFNULL(T.SaldoIVAMorato,Entero_Cero)	+ IFNULL(T.SaldoIVAInteres ,Entero_Cero),
                T.HaberCre	=IFNULL(T.SaldoIVAMorato,Entero_Cero)	+ IFNULL(T.SaldoIVAInteres,Entero_Cero) + IFNULL(T.TotalCapital,Entero_Cero) + IFNULL(T.SaldoInteresOrd,Entero_Cero) + IFNULL(T.SaldoMoratorios ,Entero_Cero)
                WHERE T.CreditoID = Par_CreditoID;
		 ELSE -- ******************************************************************************************* SI ES DE TODOS LOS CREDITOS
			/* CURSOR PAR LOS CREDITOS DEL CLIENTE */



			OPEN CursorCreditos;
			BEGIN
			   DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH CursorCreditos INTO
						Par_CreditoID,		Var_IDPro,			Var_Descripcion,	Var_EstatusCred,	Var_FechaDesembolso,
                        Var_FechaVencimien,	Var_DiasMora,		Var_TasaOr,			Var_TasaMor,		Var_CliPagIVA,
                        Var_SucCredito,		Var_IVAIntOrd,		Var_IVAIntMor;

					-- SE VERIFICA SI EL CLIENTE PAGA IVA
					SET Var_CliPagIVA	:= IFNULL(Var_CliPagIVA, SiPagaIVA);
					IF (Var_CliPagIVA = SiPagaIVA) THEN
						SET	Var_IVASucurs	:= IFNULL((SELECT IVA
														FROM SUCURSALES
														 WHERE SucursalID = Var_SucCredito), Entero_Cero);

							-- Verificamos si Paga IVA de Interes Ordinario
						IF (Var_IVAIntOrd = SiPagaIVA) THEN
							SET Var_ValIVAIntOr := Var_IVASucurs;
						END IF;

						IF (Var_IVAIntMor = SiPagaIVA) THEN
							SET Var_ValIVAIntMo := Var_IVASucurs;
						END IF;
					END IF;


					-- SE OBTIENE LA ULTIMA FECHA DE PAGO Y MONTO DE PAGO
					SET Var_FechaUltPagoCap	:=	(SELECT		MAX(FechaPago) AS Var_FechaPago
													FROM 	DETALLEPAGCRE 	D
													WHERE	D.CreditoID	=	Par_CreditoID
														AND	FechaPago	<=	FechaSist
														GROUP BY D.CreditoID HAVING SUM(MontoCapOrd+MontoCapAtr+MontoCapVen)>0.0
														ORDER BY FechaPago DESC);

					-- SE OBTIENE LA ULTIMA FECHA DE PAGO Y MONTO DE PAGO
					SET Var_MontoUltPagCap	:=	(SELECT		SUM(IFNULL(MontoCapOrd,0.0)+IFNULL(MontoCapAtr,0.0)+IFNULL(MontoCapVen,0.0)) AS Var_Monto
													FROM 	DETALLEPAGCRE 	D
													WHERE	D.CreditoID	=	Par_CreditoID
														AND	FechaPago	<=	FechaSist
														GROUP BY D.CreditoID HAVING SUM(MontoCapOrd+MontoCapAtr+MontoCapVen)>0.0
														ORDER BY FechaPago DESC);

					SET Var_FechaUltPagoCap := IFNULL(Var_FechaUltPagoCap,Fecha_Vacia);
					SET Var_MontoUltPagCap	:= IFNULL(Var_MontoUltPagCap,Decimal_Cero);


					-- SE LLENA LA TABLA DE AYUDA
					INSERT INTO TMPSALDOSSOCIOSPS (
						CreditoID,			ProductoID,				Descripcion,		EstatusCred,		FechaDesembolso,
                        FechaVencimien,		DiasMora,				TasaOr,				TasaMor,			CliPagIVA,
                        SucCredito,			IVAIntOrd,
                        IVAIntMor,			FechaUltPagoCap,		MontoUltPagCap,		ClienteID,			SaldoInteresOrd,
                        SaldoInteresAtr,	SaldoInteresVen,		SaldoInteresPro,	SaldoIntNoConta,	SaldoIVAInteres,
                        SaldoMoratorios,    SaldoIVAMorato,			TotalCapital
					)
					SELECT
						Par_CreditoID,		Var_IDPro,				Var_Descripcion,	Var_EstatusCred,	Var_FechaDesembolso,
                        Var_FechaVencimien,	Var_DiasMora,			Var_TasaOr,			Var_TasaMor,		Var_CliPagIVA,
                        Var_SucCredito,		Var_IVAIntOrd,
                        Var_IVAIntMor,		Var_FechaUltPagoCap,	Var_MontoUltPagCap,	Par_ClienteID,
						IFNULL(SUM(ROUND(SaldoInteresOrd,2)+ROUND(SaldoInteresPro,2)),Entero_Cero) AS SaldoInteresOrd,
						IFNULL(SUM(ROUND(SaldoInteresAtr,2)),Entero_Cero) AS SaldoInteresAtr,
						IFNULL(SUM(ROUND(SaldoInteresVen,2)),Entero_Cero) AS SaldoInteresVen,
						IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero) AS SaldoInteresPro,
						IFNULL(SUM(ROUND(SaldoIntNoConta,2)),Entero_Cero) AS SaldoIntNoConta,
						SUM(ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr,2) +
								 ROUND(SaldoInteresAtr * Var_ValIVAIntOr,2) +
								 ROUND(SaldoInteresPro * Var_ValIVAIntOr,2) +
								 ROUND(SaldoIntNoConta * Var_ValIVAIntOr,2), 2)) AS SaldoIVAInteres,

						IFNULL(SUM(SaldoIntNoConta+SaldoInteresVen+SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero) AS SaldoMoratorios,


						IFNULL(SUM(ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
										ROUND(SaldoInteresVen * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo, 2),
										2)),Entero_Cero) AS SaldoIVAMorato,

						IFNULL(SUM(SaldoCapVigente	+ SaldoCapAtrasa + SaldoCapVencido	+ SaldoCapVenNExi),Entero_Cero) AS totalCapital


					FROM AMORTICREDITO
					WHERE CreditoID = Par_CreditoID;


                     UPDATE	TMPSALDOSSOCIOSPS	T
					SET
                T.TotalIVA	=IFNULL(T.SaldoIVAMorato,Entero_Cero)	+ IFNULL(T.SaldoIVAInteres ,Entero_Cero),
                T.HaberCre	=IFNULL(T.SaldoIVAMorato,Entero_Cero)	+ IFNULL(T.SaldoIVAInteres,Entero_Cero) + IFNULL(T.TotalCapital,Entero_Cero) + IFNULL(T.SaldoInteresOrd,Entero_Cero) + IFNULL(T.SaldoMoratorios ,Entero_Cero)
                WHERE T.CreditoID = Par_CreditoID;

				END LOOP;
			END;
			CLOSE CursorCreditos;


		END IF;

        SET	Var_ClienteID := (SELECT ClienteID FROM TMPSALDOSSOCIOSPS WHERE	ClienteID = Par_ClienteID GROUP BY ClienteID);
        IF(IFNULL(Var_ClienteID,Entero_Cero) = Entero_Cero) THEN
			INSERT INTO TMPSALDOSSOCIOSPS (ClienteID) VALUES (Par_ClienteID);
        END IF;

        UPDATE	TMPSALDOSSOCIOSPS	T,
				TMPDATOSCUENTASPS	TD	SET
			T.AhoOrdDisp		= TD.AhoOrdDisp,
			T.AhoOrdPren		= TD.AhoOrdPren,
			T.AhoVisDisp		= TD.AhoVisDisp,
			T.AhoVisPren		= TD.AhoVisPren,
			T.AhoPlaDisp		= TD.AhoPlaDisp,
			T.AhoPlaPren		= TD.AhoPlaPren,
			T.TotalHaberes		= TD.TotalHaberes,
			T.Profun			= TD.Profun,
			T.FechaUltDeposito= TD.FechaUltDeposito
		WHERE	T.ClienteID = Par_ClienteID
			AND	T.ClienteID	= TD.ClienteID;



		SELECT	CreditoID,			ClienteID,			ProductoID,			Descripcion,		EstatusCred,
				FechaDesembolso,	FechaVencimien,		DiasMora,			TasaOr,				TasaMor,
				CliPagIVA,			SucCredito,			IVAIntOrd,			IVAIntMor,			FORMAT(IFNULL(SaldoInteresOrd,Entero_Cero),2) AS SaldoInteresOrd,
				FORMAT(IFNULL(SaldoInteresAtr,Entero_Cero),2) AS SaldoInteresAtr,	FORMAT(IFNULL(SaldoInteresVen,Entero_Cero),2) AS SaldoInteresVen,
                FORMAT(IFNULL(SaldoInteresPro,Entero_Cero),2) AS SaldoInteresPro,	FORMAT(IFNULL(SaldoIntNoConta,Entero_Cero),2) AS SaldoIntNoConta,
                FORMAT(IFNULL(SaldoIVAInteres,Entero_Cero),2) AS SaldoIVAInteres,	FORMAT(IFNULL(SaldoMoratorios,Entero_Cero),2) AS SaldoMoratorios,
                FORMAT(IFNULL(SaldoIVAMorato, Entero_Cero),2) AS SaldoIVAMorato,	FORMAT(IFNULL(TotalCapital,Entero_Cero),2) AS TotalCapital,
                FORMAT(IFNULL(TotalIVA,Entero_Cero),2) AS TotalIVA,			FechaUltPagoCap,
				MontoUltPagCap,		FORMAT(AhoOrdDisp,2) AS AhoOrdDisp,		FORMAT(AhoOrdPren,2) AS AhoOrdPren,		FORMAT(AhoVisDisp,2) AS AhoVisDisp,
									FORMAT(AhoVisPren,2) AS AhoVisPren,		FORMAT(AhoPlaDisp,2) AS AhoPlaDisp,		FORMAT(AhoPlaPren,2) AS AhoPlaPren,
                                    FORMAT(TotalHaberes,2) AS TotalHaberes,		IFNULL(Profun,Entero_Cero) AS Profun,
                FechaUltDeposito, 	FORMAT(HaberCre,2) AS HaberCre
		FROM TMPSALDOSSOCIOSPS;

	END IF; --  -- 2.- Seccion de Detalle donde van los Diferentes Creditos del Cliente

	-- 3.- Seccion de Detalle donde van Avales  ***********************************************************************************************
	IF Par_SeccionRep = SecAvales THEN
		DROP TABLE IF EXISTS TMPDATOSAVALESSPS;
		CREATE TEMPORARY TABLE TMPDATOSAVALESSPS(
			CreditoID			BIGINT,
			SolicitudCreditoID	BIGINT,
			AvalID				BIGINT,
			ClienteID			BIGINT,
			ProspectoID			BIGINT,
			NombreCompleto 		VARCHAR(500),
			DireccionCompleta	VARCHAR(500),
            DescDirec			VARCHAR(500),
			Telefono			VARCHAR(50),
			Num					INT(11));
		CREATE INDEX id_indexClienteID ON TMPDATOSAVALESSPS (ClienteID);

		SET @curRow := 0;
		INSERT INTO TMPDATOSAVALESSPS
		SELECT	cre.CreditoID,			aps.SolicitudCreditoID,		aps.AvalID,			aps.ClienteID, 	aps.ProspectoID,
				'' as NombreCompleto,	'' as DireccionCompleta,	'' as DescDirec,	'' AS Telefono,	@curRow := @curRow + 1 AS Num
			FROM AVALESPORSOLICI aps
					INNER JOIN CREDITOS cre
						ON cre.SolicitudCreditoID	= aps.SolicitudCreditoID
				WHERE cre.CreditoID= Par_CreditoID;

		UPDATE TMPDATOSAVALESSPS	T,
				CLIENTES			C	SET
			T.NombreCompleto= C.NombreCompleto,
			T.Telefono		= C.TelefonoCelular
		WHERE T.ClienteID = C.ClienteID;

		UPDATE	TMPDATOSAVALESSPS	T,
				DIRECCLIENTE		D	SET
			T.DireccionCompleta = D.DireccionCompleta,
            T.DescDirec=D.Descripcion
		WHERE T.ClienteID = D.ClienteID
		AND D.Oficial = Var_Si;

		UPDATE TMPDATOSAVALESSPS	T,
				PROSPECTOS			P	SET
			T.NombreCompleto= P.NombreCompleto,
			T.Telefono		= P.Telefono
		WHERE T.ProspectoID = P.ProspectoID
			AND T.NombreCompleto = Cadena_Vacia;

		UPDATE TMPDATOSAVALESSPS	T,
				PROSPECTOS			P,
				ESTADOSREPUB Est,
				MUNICIPIOSREPUB Mun 	SET
			T.DireccionCompleta	= CONCAT(IFNULL(Calle,Cadena_Vacia), ', ', IFNULL(NumExterior,Cadena_Vacia),', ', IFNULL(Colonia,Cadena_Vacia),' , ', IFNULL(Mun.Nombre,Cadena_Vacia),', ',IFNULL(Est.Nombre,Cadena_Vacia) )
		WHERE T.ProspectoID = P.ProspectoID
			AND P.EstadoID	= Est.EstadoID
			AND P.MunicipioID	= Mun.MunicipioID
			AND Mun.EstadoID	= Est.EstadoID
			AND T.DireccionCompleta = Cadena_Vacia;

		UPDATE TMPDATOSAVALESSPS	T,
				AVALES				A	SET
			T.NombreCompleto= A.NombreCompleto,
			T.Telefono		= A.TelefonoCel
		WHERE T.AvalID = A.AvalID
			AND T.NombreCompleto = Cadena_Vacia;

		UPDATE TMPDATOSAVALESSPS	T,
				AVALES				A	SET
			T.DireccionCompleta = A.DireccionCompleta
		WHERE T.AvalID = A.AvalID
			AND T.DireccionCompleta = Cadena_Vacia;

		SELECT CreditoID,		SolicitudCreditoID,		AvalID,		ClienteID,	ProspectoID,
			   NombreCompleto,	DireccionCompleta,		DescDirec,	Telefono,	Num
			FROM TMPDATOSAVALESSPS;
	END IF;


END TerminaStore$$