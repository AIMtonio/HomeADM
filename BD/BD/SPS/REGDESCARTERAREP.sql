-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGDESCARTERAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGDESCARTERAREP`;DELIMITER $$

CREATE PROCEDURE `REGDESCARTERAREP`(
# ============================================================================================================
# ------------------ SP PARA OBTENER DATOS PARA EL REPORTE DE DESAGREGADO DE CARTERA (C-0451) ----------------
#------------------- VERSION ANTERIOR 2015 ----------------
# ============================================================================================================
    Par_Fecha           DATETIME,			#Fecha del reporte
	Par_NumReporte      TINYINT UNSIGNED,	#Tipo de reporte 1: Excel 2: CVS
    /* Parametros de Auditoria */
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,

    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaCon		DATE;			-- Fecha de ultima estimacion
	DECLARE Var_ClaveEntidad 	VARCHAR(300);   -- Clave de la entidad


	-- Declaracion de Constantes
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT(3);
	DECLARE Decimal_Cero    DECIMAL(12,2);
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Est_Vigente     CHAR(1);
	DECLARE Est_Vencido     CHAR(1);
	DECLARE Est_Castigado   CHAR(1);
	DECLARE Per_Moral       CHAR(1);
	DECLARE Per_Fisica      CHAR(1);
	DECLARE SIManejaLinea   CHAR(1);
	DECLARE NOManejaLinea   CHAR(1);
	DECLARE SIEsRevolvente  CHAR(1);

	DECLARE TipDirectivo 	CHAR(1);
	DECLARE TipFamiliarDir  CHAR(1);
	DECLARE TipFuncionario  CHAR(1);

	DECLARE Amorti_FueraBal INT;
	DECLARE Amorti_PagUnico INT;
	DECLARE Amorti_PagPerio INT;
	DECLARE Amorti_Revolven INT;
	DECLARE Sit_Vigente     INT;
	DECLARE Sit_VigPagAtra  INT;
	DECLARE Sit_Vencido     INT;
	DECLARE Cli_NoRelaci    INT;
	DECLARE Cli_SiRelaci    INT;
	DECLARE Cla_NoRelaci    INT;
	DECLARE Rep_Excel       INT;
	DECLARE Rep_Csv			INT;
	DECLARE Valor_Fijo1		VARCHAR(5);
	DECLARE Clave_Reporte	VARCHAR(5);

	/* Asignacion de Constantes */
	SET Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     := 0;               -- Entero en Cero
	SET Decimal_Cero    := 0.00;            -- Decimal Cero
	SET Cadena_Vacia    := '';              -- String o Cadena Vacia
	SET Est_Vigente     := 'V';             -- Estatus del Credito: Vigente
	SET Est_Vencido     := 'B';             -- Estatus del Credito: Vencido
	SET Est_Castigado   := 'K';             -- Estatus del Credito: Castigado
	SET Per_Fisica      := 'F';             -- Tipo de Persona: Fisica
	SET Per_Moral       := 'M';             -- Tipo de Persona: Moral
	SET SIManejaLinea   := 'S';             -- El producto de Credito SI Maneja Linea
	SET NOManejaLinea   := 'N';             -- El producto de Credito NO Maneja Linea
	SET SIEsRevolvente  := 'S';             -- El producto de Credito es Revolvente

	SET Amorti_FueraBal := 0;               -- Tipo de Amortizacion: No aplica (operaciones fuera de balance)
	SET Amorti_PagUnico := 1;               -- Tipo de Amortizacion: Pago unico de principal e intereses
	SET Amorti_PagPerio := 3;               -- Tipo de Amortizacion: Pagos periodicos de principal e intereses
	SET Amorti_Revolven := 4;               -- Tipo de Amortizacion: Creditos Revolventes

	SET Sit_Vigente     := 1;               -- Situacion del Credito: Vigente sin pagos vencidos
	SET Sit_VigPagAtra  := 2;               -- Situacion del Credito: Vigente con pagos vencidos
	SET Sit_Vencido     := 3;               -- Situacion del Credito: Vencido en tramite administrativo

	SET Cli_NoRelaci    := 2;               -- Cliente no Relacionado
	SET Cli_SiRelaci    := 1;               -- Clientes que tienen relacion con directivos y empleados
	SET Cla_NoRelaci    := 0;               -- Clave de Cliente no Relacionado

	SET Rep_Excel       := 1;           	-- Tipo Reporte Excel
	SET Rep_Csv			:= 2;  				-- Tipo Reporte CSV
	SET Valor_Fijo1		:= '303';
	SET Clave_Reporte	:= '451';
	SET TipDirectivo 	:= '2';				-- Tipo Directivo
	SET TipFamiliarDir	:= '3';				-- Tipo Familiar de Directivo
	SET TipFuncionario	:= '4';				-- Tipo Funcionario y Familiar de Funcionario

	/* se crea tabla temporal */
	DROP TABLE IF EXISTS TMPREGDESCAR451;
	CREATE TEMPORARY TABLE TMPREGDESCAR451(
		NombreCompleto		VARCHAR(200),
		ClienteID			INT(11),
		CreditoID			BIGINT(12),
		TipoPersona			INT(11),
		RFCOficial			VARCHAR(30),
		ClasifConta			VARCHAR(100),
		MontoCredito		DECIMAL(14,2),
		Responsabilidad		DECIMAL(14,2),
		FechaDisp			DATE,
		FechaVencim			DATE,
		TipoAmorti			INT(11),
		Tasa				DECIMAL(12,2),

		IntDevNoCob			DECIMAL(14,2),
		IntVencido			DECIMAL(14,2),
		IntCapitalizado		INT(11),
		SituacionCred		INT(11),
		NumReest			INT(11),
		CalifCubierta		DECIMAL(14,2),
		CalifExpuesta		DECIMAL(14,2),

		EstimCubierta		DECIMAL(14,2),
		EstimExpuesta		DECIMAL(14,2),
		EstimTotales		DECIMAL(14,2),
		PorcGarAval			INT(11),
		ValorEnGarantia		DECIMAL(14,2),
		FechaValuac			VARCHAR(12),
		GradoPrela			INT(11),
		CteRelacio			INT(11),
		TipoRelaci			INT(11),
		NumDiasMora			INT(11),
		Reciproc			INT(11),
		ProductoCreditoID	INT(11),
		ManejaLinea			CHAR(1),
		EsRevolvente		CHAR(1),
		Estatus				CHAR(10),
		DestinoCreID		INT(11),
		ClasifRegID			INT(11),
        Formula				VARCHAR(100),
		PRIMARY KEY (CreditoID)
	);

	/* se obtienela ultima fecha en la que se haya realizado la estimacion */
	SELECT  MAX(Fecha) INTO Var_FechaCon
		FROM CALRESCREDITOS
		WHERE Fecha <= Par_Fecha;
	SET Var_FechaCon    := IFNULL(Var_FechaCon, Fecha_Vacia);


	INSERT INTO TMPREGDESCAR451 (
		NombreCompleto,		ClienteID,		CreditoID,			TipoPersona,		RFCOficial,
		ClasifConta,		MontoCredito,	Responsabilidad,	FechaDisp,			FechaVencim,
		TipoAmorti,			Tasa,			IntDevNoCob,		IntVencido,			IntCapitalizado,
		SituacionCred,		NumReest,		CalifCubierta,		CalifExpuesta,		EstimCubierta,
		EstimExpuesta,		EstimTotales,	PorcGarAval,		ValorEnGarantia,	FechaValuac,
		GradoPrela,			CteRelacio,		TipoRelaci,			NumDiasMora,		Reciproc,
		ProductoCreditoID,	ManejaLinea,	EsRevolvente,		DestinoCreID,		ClasifRegID,
        Formula
	)
	SELECT
		CASE	WHEN Cli.TipoPersona = Per_Fisica  OR  Cli.TipoPersona = "A" THEN
					UPPER(Cli.NombreCompleto)
				ELSE UPPER(CONCAT( REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(Cli.RazonSocial, 'S.A DE C.V.', ''),
						'SA DE CV', ''), 'S. A. de CV.', ''), 'sa de cv', ''), 's.a. de c.v.', ''),IFNULL(AbreviCNBV, Cadena_Vacia)))
		END AS NombreCompleto,
		Cli.ClienteID,	Cre.CreditoID,
		CASE WHEN Cli.TipoPersona = Per_Moral THEN '2' ELSE '1' END AS TipoPersona,
		Cli.RFCOficial,	'',	ROUND(Cre.MontoCredito, 2) AS MontoCredito,	0.00 AS Responsabilidad,
		DATE_FORMAT(Cre.FechaInicio, '%Y%m%d') AS FechaDisp,
		DATE_FORMAT(Cre.FechaVencimien, '%Y%m%d') AS FechaVencim,
		Entero_Cero AS TipoAmorti,
		ROUND(Cre.TasaFija, 2) AS Tasa,		0.0 AS IntDevNoCob,		0.0 AS IntVencido,
		Entero_Cero AS IntCapitalizado,		Entero_Cero AS SituacionCred,	IFNULL(MAX(NumeroReest), Entero_Cero) AS NumReest,
		Decimal_Cero AS CalifCubierta,		Decimal_Cero AS CalifExpuesta,
		ROUND(IFNULL(MAX(ReservaTotCubierto),Decimal_Cero),Entero_Cero) AS EstimCubierta,
		ROUND(IFNULL(MAX(ReservaTotExpuesto),Decimal_Cero),Entero_Cero) AS EstimExpuesta,
		SUM(ROUND(IFNULL(ReservaTotCubierto,Entero_Cero),Entero_Cero)+ROUND(IFNULL(ReservaTotExpuesto,Entero_Cero),Entero_Cero))  AS EstimTotales,
		Entero_Cero AS PorcGarAval,		Entero_Cero AS ValorEnGarantia,			Cadena_Vacia AS FechaValuac,
		Entero_Cero AS GradoPrela,		Cli_NoRelaci AS CteRelacio,				Cla_NoRelaci AS TipoRelaci,
		Entero_Cero AS NumDiasMora,		ROUND(IFNULL(MAX(Cal.MontoGarantia),Decimal_Cero),Entero_Cero) AS Reciproc,	Cre.ProductoCreditoID,
		Pro.ManejaLinea,	Pro.EsRevolvente,	Cre.DestinoCreID,	 Entero_Cero,F.Formula
	FROM  CREDITOS Cre
		INNER JOIN CLIENTES Cli			ON  Cre.ClienteID	= Cli.ClienteID
		INNER JOIN SALDOSCREDITOS Sal	ON Sal.CreditoID = Cre.CreditoID
										AND Cli.ClienteID = Sal.ClienteID
		LEFT OUTER JOIN CALRESCREDITOS Cal	ON 	Cal.CreditoID	= Cre.CreditoID
										AND  Cal.Fecha		= Par_Fecha
		INNER JOIN PRODUCTOSCREDITO	Pro	ON 	Pro.ProducCreditoID = Cre.ProductoCreditoID
		LEFT OUTER JOIN TIPOSOCIEDAD Tic ON Tic.TipoSociedadID = Cli.TipoSociedadID
		LEFT OUTER JOIN REESTRUCCREDITO Res ON Res.CreditoDestinoID = Cal.CreditoID
        LEFT JOIN FORMTIPOCALINT AS F ON Cre.CalcInteresID=F.FormInteresID
		WHERE	Sal.FechaCorte = Par_Fecha
		AND		Sal.EstatusCredito IN ('V', 'B')
        GROUP BY Cre.CreditoID;

	/* se obtienen los valores que se ocupan de saldos de credito */
	UPDATE	TMPREGDESCAR451 tmp INNER JOIN
			SALDOSCREDITOS	Sal ON Sal.CreditoID	= tmp.CreditoID
		SET
		Responsabilidad	= 	ROUND(Sal.SalCapVigente	+	Sal.SalCapAtrasado	+	Sal.SalCapVencido	+	Sal.SalCapVenNoExi	+
							Sal.SalIntOrdinario	+	SalIntProvision		+	SalIntAtrasado		+	Sal.SalMoratorios	+
							Sal.SalIntVencido	+	SaldoMoraVencido	+	Sal.SalIntNoConta	+	SaldoMoraCarVen,Entero_Cero),
		IntDevNoCob		= 	ROUND(Sal.SalIntOrdinario	+	SalIntProvision		+	SalIntAtrasado		+	Sal.SalMoratorios,Entero_Cero)	,
		IntVencido		= 	ROUND(Sal.SalIntVencido	+	SaldoMoraVencido,Entero_Cero),
		SituacionCred	= 	CASE
								WHEN Sal.EstatusCredito  = Est_Vencido OR Sal.EstatusCredito  = Est_Castigado THEN
									Sit_Vencido
								WHEN Sal.EstatusCredito  = Est_Vigente AND Sal.DiasAtraso <= Entero_Cero THEN
									Sit_Vigente
								WHEN Sal.EstatusCredito  = Est_Vigente AND Sal.DiasAtraso > Entero_Cero THEN
									Sit_Vencido
								ELSE
									Entero_Cero	END ,
		TipoAmorti		= CASE 	WHEN tmp.ManejaLinea = SIManejaLinea AND tmp.EsRevolvente = EsRevolvente THEN Amorti_Revolven
								WHEN tmp.ManejaLinea = NOManejaLinea AND Sal.NumAmortizacion > 1 THEN Amorti_PagPerio
								WHEN tmp.ManejaLinea = NOManejaLinea AND Sal.NumAmortizacion <= 1 THEN Amorti_PagUnico	END ,
		NumDiasMora		= Sal.DiasAtraso,
		Estatus			= (CASE  Sal.EstatusCredito WHEN 'V' THEN 'VIGENTE' WHEN 'B' THEN 'VENCIDO' ELSE '' END)
	WHERE	Sal.CreditoID	= tmp.CreditoID
		AND 	Sal.FechaCorte	= Par_Fecha;


	# SE ELIMINAN LOS QUE NO SON NI VIGENTES NI VENCIDOS
	DELETE FROM TMPREGDESCAR451 WHERE IFNULL(Estatus,"") = "";

	/*se obtiene El valor de las garantias que no fueron migradas */
	UPDATE	TMPREGDESCAR451 tmp INNER JOIN
			CREGARPRENHIPO	hip	ON tmp.CreditoID	= hip.CreditoID
		SET	ValorEnGarantia	= ValorEnGarantia+GarPrendaria+ GarHipotecaria,
			FechaValuac		= CASE WHEN FechaAvaluo	= '1900-01-01' THEN '' ELSE FechaAvaluo END
	WHERE	tmp.CreditoID	= hip.CreditoID;

	/* se suman las garatias que esten en safi */
	DROP TABLE IF EXISTS TMPMONTOGARDESACARTERA;
	CREATE TEMPORARY TABLE TMPMONTOGARDESACARTERA
	SELECT	SUM(Asi.MontoAsignado) AS Monto,	Sol.CreditoID
		FROM	ASIGNAGARANTIAS		Asi,
				GARANTIAS			Gar,
				SOLICITUDCREDITO	Sol
		WHERE	Gar.GarantiaID	= Asi.GarantiaID
			AND	Gar.TipoGarantiaID IN (2,3,4)
			AND Sol.SolicitudCreditoID = Asi.SolicitudCreditoID
	GROUP BY Sol.CreditoID;

	CREATE INDEX id_indexCreditoID ON TMPMONTOGARDESACARTERA (CreditoID);

	UPDATE	TMPREGDESCAR451 tmp INNER JOIN
			TMPMONTOGARDESACARTERA	hip	ON tmp.CreditoID	= hip.CreditoID
		SET	ValorEnGarantia	= ValorEnGarantia+Monto
	WHERE	tmp.CreditoID	= hip.CreditoID;


	/*se obtiene la clasificacion por destino de credito */
	UPDATE	TMPREGDESCAR451 tmp INNER JOIN
			DESTINOSCREDITO	Des	ON tmp.DestinoCreID	= Des.DestinoCreID
		SET	tmp.ClasifRegID		= Des.ClasifRegID
	WHERE	tmp.DestinoCreID	= Des.DestinoCreID;

	UPDATE	TMPREGDESCAR451	Car	INNER JOIN
			CATCLASIFREPREG		Cat	 ON Car.ClasifRegID	= Cat.ClasifRegID
		SET Car.ClasifConta	= Cat.ClasifConta
	WHERE 	Car.ClasifRegID	= Cat.ClasifRegID;

	# sandra
	# Se obtienen los valores para llenar la columna de "Acreditado Relacionado"
	# se crea tabla temporar para obtener una lista de los clientes
	DROP TEMPORARY TABLE IF EXISTS  TMPCLIENTES451;
	CREATE TEMPORARY TABLE TMPCLIENTES451
	SELECT ClienteID
		FROM TMPREGDESCAR451
	GROUP BY ClienteID;


	# se crea tabla temporal para guardar los relacionados de los clientes considerados en este reporte
	DROP TEMPORARY TABLE IF EXISTS TMPRELACIONCLI451;
	CREATE TEMPORARY TABLE TMPRELACIONCLI451
	SELECT	Rel.ClienteID,	Rel.RelacionadoID,	Rel.TipoRelacion,	Tip.Grado,	'N' AS TienePoder
		FROM	RELACIONCLIEMPLEADO	Rel,
				TMPCLIENTES451		Car,
				TIPORELACIONES		Tip
		WHERE 	Rel.ClienteID		=	Car.ClienteID
		AND		Rel.ParentescoID	=	Tip.TipoRelacionID;
	CREATE INDEX id_indexClienteID ON TMPRELACIONCLI451 (ClienteID);
	CREATE INDEX id_indexTipoRelacion ON TMPRELACIONCLI451 (TipoRelacion);

	#Se actualiza en la tabla temporal a todos los que su firma compromentan a la institucion
	UPDATE	TMPRELACIONCLI451	Tmp INNER JOIN
			CLIEMPRELACIONADO	Rel	ON Tmp.RelacionadoID	= Rel.EmpleadoID
		SET	Tmp.TienePoder		= Rel.TienePoder
	WHERE	Tmp.TipoRelacion	= 2
		AND Rel.EmpleadoID		> Entero_Cero
		AND	Tmp.RelacionadoID	= Rel.EmpleadoID;

	UPDATE	TMPRELACIONCLI451	Tmp INNER JOIN
			CLIEMPRELACIONADO	Rel	ON Tmp.RelacionadoID	= Rel.ClienteID
		SET	Tmp.TienePoder		= Rel.TienePoder
	WHERE	Tmp.TipoRelacion	= 1
		AND Rel.ClienteID		> Entero_Cero
		AND	Tmp.RelacionadoID	= Rel.ClienteID;

	#Se actualiza en la tabla temporal a todos los que su firma compromentan a la institucion
	UPDATE	TMPRELACIONCLI451	Tmp INNER JOIN
			CLIEMPRELACIONADO	Rel	ON Tmp.ClienteID	= Rel.ClienteID
		SET	Tmp.TienePoder	= 'S'
	WHERE	Rel.EmpleadoID	= Entero_Cero
	AND		Tmp.ClienteID	= Rel.ClienteID;


	DELETE FROM TMPRELACIONCLI451 WHERE TienePoder = 'N';


	/*se ponen como relacionados con empleados a todos los que esten capturados en safi*/
	UPDATE	TMPREGDESCAR451		Car	INNER JOIN
			TMPRELACIONCLI451	Rel ON Car.ClienteID		= Rel.ClienteID
		SET Car.CteRelacio		= 	Cli_SiRelaci
	WHERE	Rel.TipoRelacion	= 2	-- Tipo de Relacion cuando es empleado
		AND Car.ClienteID		= Rel.ClienteID;

	UPDATE	TMPREGDESCAR451		Car	INNER JOIN
			CLIEMPRELACIONADO	Rel	ON Car.ClienteID	= Rel.ClienteID
		SET Car.CteRelacio	= 	Cli_SiRelaci
	WHERE	Car.ClienteID	= Rel.ClienteID;


	UPDATE	TMPREGDESCAR451		Car	INNER JOIN
			TMPRELACIONCLI451	Rel ON Car.ClienteID	= Rel.ClienteID
		SET TipoRelaci	= 	TipFamiliarDir
	WHERE	Rel.TipoRelacion	= 1 -- Tipo de Relacion cuando es cliente
		AND  Car.ClienteID		= Rel.ClienteID
		AND  TienePoder			= 'S'
		AND  Grado IN 	(1, 2);


	UPDATE	TMPREGDESCAR451		Car	INNER JOIN
			TMPRELACIONCLI451	Rel	ON Car.ClienteID		= Rel.ClienteID
		SET TipoRelaci	= 	TipFuncionario
	WHERE	Rel.TipoRelacion	= 2 -- Tipo de Relacion cuando es empleado
		AND  Car.ClienteID		= Rel.ClienteID
		AND  TienePoder			= 'S'
		AND  Grado IN 	(1, 2);


	-- Se obtiene el valor de Tipo de Relacion
	UPDATE	TMPREGDESCAR451		Car	INNER JOIN
			CLIEMPRELACIONADO	Rel	ON Car.ClienteID	= Rel.ClienteID
		SET TipoRelaci	= 	TipDirectivo
	WHERE	Car.ClienteID	= Rel.ClienteID
		AND  TienePoder		= 'S';

	-- Se obtiene el valor de Tipo de Relacion
	UPDATE	TMPREGDESCAR451		Car	INNER JOIN
			CLIEMPRELACIONADO	Rel	ON Car.ClienteID	= Rel.ClienteID
		SET	 TipoRelaci		= TipFuncionario
	WHERE	 Car.ClienteID	= Rel.ClienteID
		AND  Rel.EmpleadoID > Entero_Cero
		AND  TienePoder		= 'S';


	/*se ponen como relacionados con directivos a los familiares */
	UPDATE	TMPREGDESCAR451		Car	INNER JOIN
			TMPRELACIONCLI451	Rel ON Car.ClienteID	= Rel.ClienteID
            INNER JOIN	CLIEMPRELACIONADO Emp ON Rel.RelacionadoID	= Emp.ClienteID
		SET Car.CteRelacio		= Cli_SiRelaci
	WHERE	Rel.TipoRelacion	= 1	-- Tipo de Relacion cuando es empleado
		AND Car.ClienteID		= Rel.ClienteID
		AND Rel.RelacionadoID	= Emp.ClienteID;



	/* Reporte Desagregado de Cartera 0451 Excel */
	IF(Par_NumReporte = Rep_Excel) THEN
		SELECT	NombreCompleto,									ClienteID,											CreditoID,												TipoPersona,
				RFCOficial,										ClasifConta,										IFNULL(MontoCredito,Decimal_Cero)AS MontoCredito,		IFNULL(Responsabilidad,Decimal_Cero)AS Responsabilidad,
                REPLACE(FechaDisp,'-','') AS FechaDisp,			REPLACE(FechaVencim,'-','') AS FechaVencim,			IFNULL(TipoAmorti,Entero_Cero)AS TipoAmorti,			ROUND(Tasa,2) AS Tasa,
                IFNULL(IntDevNoCob,Decimal_Cero) AS	IntDevNoCob,IFNULL(IntVencido,Decimal_Cero) AS IntVencido,		IFNULL(IntCapitalizado,Decimal_Cero)AS IntCapitalizado,	IFNULL(SituacionCred,Entero_Cero)AS SituacionCred,
                IFNULL(NumReest,Entero_Cero) AS NumReest, 		Decimal_Cero AS CalifCubierta,						Decimal_Cero AS CalifExpuesta,							IFNULL(EstimCubierta,Decimal_Cero) AS EstimCubierta,
				IFNULL(EstimExpuesta,Decimal_Cero) AS EstimExpuesta,CASE WHEN 	 EstimTotales > Entero_Cero THEN EstimTotales * -1
																			ELSE EstimTotales END AS EstimTotales,	IFNULL(PorcGarAval,Entero_Cero) AS PorcGarAval,			IFNULL(ValorEnGarantia,Decimal_Cero) AS ValorEnGarantia,
				REPLACE(FechaValuac,'-','') AS FechaValuac,		IFNULL(GradoPrela,Entero_Cero) AS GradoPrela,		IFNULL(CteRelacio,Entero_Cero) AS CteRelacio,			IFNULL(TipoRelaci,Entero_Cero)AS TipoRelaci,
                IFNULL(NumDiasMora,Entero_Cero) AS NumDiasMora,	IFNULL(Reciproc,Entero_Cero) AS Reciproc, 			Formula
		FROM	TMPREGDESCAR451;
	END IF;

	# Reporte Desagregado de Cartera 0451 CSV
	IF(Par_NumReporte = Rep_Csv) THEN
		SET Var_ClaveEntidad	:= IFNULL((SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Par, INSTITUCIONES Ins WHERE Par.InstitucionID = Ins.InstitucionID), Cadena_Vacia);
		SET @Var_Consecutivo 	:= Entero_Cero;

		SELECT   CONCAT(
				Var_ClaveEntidad, ';',Valor_Fijo1, ';', Clave_Reporte, ';',  @Var_Consecutivo :=  @Var_Consecutivo + 1 ,
				 ';',NombreCompleto,	 ';',ClienteID,		 ';',CreditoID,			 ';',TipoPersona,		 ';',RFCOficial,
				 ';',ClasifConta,	 ';',MontoCredito,	 ';',Responsabilidad,	 ';',REPLACE(FechaDisp,'-',''),			 ';',REPLACE(FechaVencim,'-',''),
				 ';',TipoAmorti,		 ';',Formula,';',Tasa,			 ';',IntDevNoCob,		 ';',IntVencido,		 ';',IntCapitalizado,
				 ';',SituacionCred,	 ';',NumReest,		 ';',CalifCubierta,		 ';',CalifExpuesta,		 ';',EstimCubierta,
				 ';',EstimExpuesta,	 ';',EstimTotales,	 ';',PorcGarAval,		 ';',ValorEnGarantia,	 ';',REPLACE(FechaValuac,'-',''),
				 ';',GradoPrela,		 ';',CteRelacio,	 ';',TipoRelaci,		 ';',NumDiasMora,		 ';',Reciproc)
		FROM	TMPREGDESCAR451;

	END IF;


END TerminaStore$$