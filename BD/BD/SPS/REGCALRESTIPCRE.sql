-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGCALRESTIPCRE
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGCALRESTIPCRE`;DELIMITER $$

CREATE PROCEDURE `REGCALRESTIPCRE`(
    Par_Fecha           DATETIME,
	Par_NumReporte      TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Tot_General     DECIMAL(14,2);
	DECLARE Tot_ResGene     DECIMAL(14,2);
	DECLARE Tot_Consumo     DECIMAL(14,2);
	DECLARE Tot_ResCons     DECIMAL(14,2);
	DECLARE Tot_Comercial   DECIMAL(14,2);
	DECLARE Tot_ResComer    DECIMAL(14,2);
	DECLARE Tot_Vivienda    DECIMAL(14,2);
	DECLARE Tot_ResVivie    DECIMAL(14,2);
	DECLARE Var_MontoGarantias DECIMAL(14,2);
	DECLARE Reg_Concepto    VARCHAR(200);
	DECLARE Reg_Orden       INT;
	DECLARE Var_Trimestre   DATE;
	DECLARE Var_FecResTrim  DATE;
	DECLARE Var_MonResTrim  DECIMAL(14,2);
	DECLARE Var_ExceEstima  DECIMAL(14,2);
	DECLARE Var_ClaveEntidad VARCHAR(300);


	/* Declaracion de Constantes */
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT;
	DECLARE Decimal_Cero    DECIMAL(12,2);
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE EstatusActiva   CHAR(1);
	DECLARE var_ID411       INT;
	DECLARE var_ID417       INT;
	DECLARE Cre_Consumo     CHAR(1);
	DECLARE Cre_Comercial   CHAR(1);
	DECLARE Cre_Vivienda    CHAR(1);
	DECLARE Pri_Trimestre   INT;
	DECLARE Seg_Trimestre   INT;
	DECLARE Ter_Trimestre   INT;
	DECLARE Cua_Trimestre   INT;
	DECLARE Est_Negrita     VARCHAR(20);
	DECLARE Str_Tabulador   VARCHAR(5);
	DECLARE ColorCelda      CHAR(1);
	DECLARE Rep_Excel       INT;
	DECLARE Rep_Csv			INT;
	DECLARE Valor_Fijo1		VARCHAR(5);
	DECLARE Clave_Reporte	VARCHAR(5);


	/* Asignacion de Constantes */
	SET Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     := 0;               -- Entero en Cero
	SET Decimal_Cero    := 0.00;            -- Decimal Cero
	SET Cadena_Vacia    := '';              -- String o Cadena Vacia
	SET EstatusActiva   := 'A';             -- Estatus: Activo
	SET var_ID411       := 1;               -- ID del Reporte R0411
	SET var_ID417       := 2;               -- ID del Reporte R0417
	SET Cre_Consumo     := 'O';             -- Tipo de Cartera: Consumo
	SET Cre_Comercial   := 'C';             -- Tipo de Cartera: Comercial
	SET Cre_Vivienda    := 'H';             -- Tipo de Cartera: Vivienda
	SET Pri_Trimestre   := 3;               -- 1er Trimestre
	SET Seg_Trimestre   := 6;               -- 2o Trimestre
	SET Ter_Trimestre   := 9;               -- 3er Trimestre
	SET Cua_Trimestre   := 12;              -- 4to Trimestre
	SET Est_Negrita     := 'negrita';       -- Estilo de la Columna: Negrita
	SET Str_Tabulador   := '       ';       -- Espacios que Contiene el Tabulador
	SET ColorCelda      := 'S';
	SET Rep_Excel       := 1;           	-- Tipo Reporte Excel
	SET Rep_Csv			:= 2;           	-- Tipo Reporte CSV
	SET Valor_Fijo1		:= '303';
	SET Clave_Reporte	:= '417';



	# ============================= CREACION DE TABLAS TEMPORALES ===============================
	DROP TABLE IF EXISTS TMPREGULATORIOR0417;
	CREATE TEMPORARY TABLE TMPREGULATORIOR0417(
		Reg_TmpID			INT(11) AUTO_INCREMENT PRIMARY KEY,
		Reg_Concepto        VARCHAR(200),
		Reg_CarteraBase     DECIMAL(14,2),
		Reg_Estimacion      DECIMAL(14,2),
		Reg_Orden           INT,
		Reg_Estilo          VARCHAR(20),
		Reg_ColorCelda      CHAR(1),
		Reg_ClaveConcepto   VARCHAR(200),
		Reg_CuentaCNBV		VARCHAR(20)
	);

	DROP TABLE IF EXISTS TMPCONCEPTOSR0417;
	CREATE TEMPORARY TABLE TMPCONCEPTOSR0417(
		Det_ClaveConcepto   VARCHAR(200),
		Det_DesConcepto     VARCHAR(200),
		Det_DesDias         VARCHAR(200),
		Det_Responsab       DECIMAL(14,2),
		Det_Reservas        DECIMAL(14,2),
		Det_Segmento        CHAR(1),
		Det_Orden           INT     );


	DROP TABLE IF EXISTS TMPSALDOS0417;
	CREATE TEMPORARY TABLE TMPSALDOS0417(
		Reserva			DECIMAL(12,2),
		DiasAtraso		INT(11),
		Total			DECIMAL(12,2),
		ClaveConcepto 	VARCHAR(20),
		Clasificacion	CHAR(1),
		DestinoCreID 	INT(11),
		ClasifRegID		INT(11),
		CreditoID		BIGINT(12),
		RenReesNor		CHAR(1));




	# ===============================  POBLAR LA TABLA TEMPORAL ===============================
	INSERT INTO TMPSALDOS0417 (
			Reserva,					DiasAtraso,			Total,			ClaveConcepto,		DestinoCreID,
			Clasificacion,				RenReesNor,			CreditoID)
	SELECT	res.Reserva,				sal.DiasAtraso,   	res.Capital+res.Interes, 		'',					sal.DestinoCreID,
			'',							'N',				sal.CreditoID
	FROM	CALRESCREDITOS res,
			SALDOSCREDITOS sal
	WHERE	res.Fecha = Par_Fecha
	 AND 	res.Fecha = sal.FechaCorte
	 AND	res.CreditoID = sal.CreditoID ;


	/*se actualiza la tabla temporal en el campo Emproblemado
		si el credito es reestructurado */
	UPDATE	TMPSALDOS0417		F ,
			REESTRUCCREDITO T
	SET  F.RenReesNor	=  'R'
	WHERE T.CreditoDestinoID = F.CreditoID
	 AND	T.Origen	= 'R' -- REESTRUCTURADOS
	;

	/*se actualiza la tabla temporal en el campo Emproblemado
		si el credito es RENOVADO */
	UPDATE	TMPSALDOS0417		F ,
			REESTRUCCREDITO T
	SET  F.RenReesNor	=  'O'
	WHERE T.CreditoDestinoID = F.CreditoID
	 AND	T.Origen	= 'O' -- RENOVADOSS
	;

	UPDATE	TMPSALDOS0417	Tmp,
			DESTINOSCREDITO	Des	SET
		Tmp.ClasifRegID		= Des.ClasifRegID,
		Tmp.Clasificacion	= Des.Clasificacion
	WHERE Tmp.DestinoCreID	= Des.DestinoCreID;

	UPDATE	TMPSALDOS0417	Tmp,
			CATCLASIFREPREG	Des	SET
		Tmp.ClaveConcepto	= Des.ClaveConcepto
	WHERE	Tmp.Clasificacion	= Des.Segmento
	AND		Des.ReporteID = var_ID417;

	UPDATE	TMPSALDOS0417	Tmp,
			CATCLASIFREPREG	Des	SET
		Tmp.ClaveConcepto	= Des.ClaveConcepto
	WHERE	Des.ReporteID = var_ID417
	AND		Des.ClaveConcepto LIKE CONCAT(Tmp.ClaveConcepto, '%');


	# -----------------------------------------------------------------------------------------------

	INSERT INTO TMPCONCEPTOSR0417  (
			Det_ClaveConcepto,		Det_DesConcepto,		Det_DesDias,		Det_Responsab,		Det_Reservas,
			Det_Segmento,			Det_Orden)
	SELECT  caa.CuentaCNBV, 		caa.Descripcion,		caa.Descripcion,	Entero_Cero,		Entero_Cero,
			caa.Clasificacion,		caa.Orden
	 FROM CRECATDIASATRA caa
	WHERE   caa.ProcesoID LIKE CONCAT('R0417', "%")
	ORDER BY caa.Orden;


	-- PARA CONCEPTO 9 ***************************************************
	DROP TABLE IF EXISTS	TMPSALDODETALLE417;
	CREATE TEMPORARY TABLE TMPSALDODETALLE417
	SELECT	ROUND(SUM(sal.Total),0) AS Total,	ROUND(SUM(sal.Reserva),0) AS Reserva,	sal.Clasificacion	,caa.CuentaCNBV,
			IFNULL(caa.LimInferior, Entero_Cero),					IFNULL(caa.LimSuperior, Entero_Cero)
	FROM	TMPSALDOS0417 	sal,
			CRECATDIASATRA	caa
	WHERE	sal.Clasificacion	= caa.Clasificacion
		AND caa.Orden			= 9
		AND sal.DiasAtraso 		<= caa.LimSuperior
		AND RenReesNor			= "N";


	/*se actualizan los valores */
	UPDATE TMPCONCEPTOSR0417	caa,
			TMPSALDODETALLE417	tmp	SET
		Det_Responsab	=	tmp.Total,
		Det_Reservas	=	tmp.Reserva
	WHERE caa.Det_Orden	= 9;


	-- PARA CONCEPTO 10 al 16  *************************************************** sandra
	DROP TABLE IF EXISTS	TMPSALDODETALLE417;
	CREATE TEMPORARY TABLE TMPSALDODETALLE417
	SELECT	ROUND(SUM(sal.Total),0) AS Total,	ROUND(SUM(sal.Reserva),0) AS Reserva,	sal.Clasificacion	,caa.CuentaCNBV,
			caa.LimInferior,					caa.LimSuperior,		caa.Orden
	FROM	TMPSALDOS0417 	sal,
			CRECATDIASATRA	caa
	WHERE	sal.Clasificacion	= caa.Clasificacion
		AND caa.Orden			>= 10
		AND caa.Orden			<= 16
		AND sal.DiasAtraso 		<= caa.LimSuperior
		AND sal.DiasAtraso 		>= caa.LimInferior
		AND RenReesNor			= "N"
	GROUP BY caa.Orden, sal.Clasificacion, caa.CuentaCNBV, caa.LimInferior, caa.LimSuperior;

	/*se actualizan los valores */
	UPDATE TMPCONCEPTOSR0417	caa,
			TMPSALDODETALLE417	tmp	SET
		Det_Responsab	=	tmp.Total,
		Det_Reservas	=	tmp.Reserva
	WHERE caa.Det_Orden	>= 10
	AND caa.Det_Orden	<= 16
	AND caa.Det_Orden	= tmp.Orden ;


	-- PARA CONCEPTO 19 ***************************************************
	DROP TABLE IF EXISTS	TMPSALDODETALLE417;
	CREATE TEMPORARY TABLE TMPSALDODETALLE417
	SELECT	ROUND(SUM(sal.Total),0) AS Total,	ROUND(SUM(sal.Reserva),0) AS Reserva,	sal.Clasificacion	,caa.CuentaCNBV,
			IFNULL(caa.LimInferior, Entero_Cero),					IFNULL(caa.LimSuperior, Entero_Cero)
	FROM	TMPSALDOS0417 	sal,
			CRECATDIASATRA	caa
	WHERE	sal.Clasificacion	= caa.Clasificacion
		AND caa.Orden			= 19
		AND sal.DiasAtraso 		<= caa.LimSuperior
		AND RenReesNor			!= "N";

	/*se actualizan los valores */
	UPDATE TMPCONCEPTOSR0417	caa,
			TMPSALDODETALLE417	tmp	SET
		Det_Responsab	=	tmp.Total,
		Det_Reservas	=	tmp.Reserva
	WHERE caa.Det_Orden	= 19;



	-- PARA CONCEPTO 10 ***************************************************
	DROP TABLE IF EXISTS	TMPSALDODETALLE417;
	CREATE TEMPORARY TABLE TMPSALDODETALLE417
	SELECT	ROUND(SUM(sal.Total),0) AS Total,	ROUND(SUM(sal.Reserva),0) AS Reserva,	sal.Clasificacion	,caa.CuentaCNBV,
			IFNULL(caa.LimInferior,Entero_Cero),					IFNULL(caa.LimSuperior, Entero_Cero)
	FROM	TMPSALDOS0417 	sal,
			CRECATDIASATRA	caa
	WHERE	sal.Clasificacion	= caa.Clasificacion
		AND caa.Orden			= 10
		AND sal.DiasAtraso 		<= caa.LimSuperior
		AND sal.DiasAtraso 		>= caa.LimInferior;

	/*se actualizan los valores */
	UPDATE TMPCONCEPTOSR0417	caa,
			TMPSALDODETALLE417	tmp	SET
		Det_Responsab	=	tmp.Total,
		Det_Reservas	=	tmp.Reserva
	WHERE caa.Det_Orden	= 10;




	SET Var_MontoGarantias := (SELECT	SUM(MontoGarantia)
									FROM	CALRESCREDITOS res,
											SALDOSCREDITOS sal
									WHERE	res.Fecha = Par_Fecha
									 AND 	res.Fecha = sal.FechaCorte
									 AND	res.CreditoID = sal.CreditoID
									AND	(EstatusCredito = 'V' OR EstatusCredito = "B"));

		SELECT SUM(Det_Responsab), SUM(Det_Reservas) INTO Tot_General, Tot_ResGene FROM TMPCONCEPTOSR0417;

		SELECT SUM(Det_Responsab), SUM(Det_Reservas) INTO Tot_Consumo, Tot_ResCons FROM TMPCONCEPTOSR0417 WHERE Det_Segmento  = Cre_Consumo;

		SELECT SUM(Det_Responsab), SUM(Det_Reservas) INTO Tot_Comercial, Tot_ResComer FROM TMPCONCEPTOSR0417 WHERE Det_Segmento  = Cre_Comercial;

		SELECT SUM(Det_Responsab), SUM(Det_Reservas) INTO Tot_Vivienda, Tot_ResVivie FROM TMPCONCEPTOSR0417 WHERE Det_Segmento  = Cre_Vivienda;

		-- Inicalizacion
		SET Tot_General     := IFNULL(Tot_General, Decimal_Cero);
		SET Tot_ResGene     := IFNULL(Tot_ResGene, Decimal_Cero);
		SET Tot_Consumo     := IFNULL(Tot_Consumo, Decimal_Cero);
		SET Tot_ResCons     := IFNULL(Tot_ResCons, Decimal_Cero);
		SET Tot_Comercial   := IFNULL(Tot_Comercial, Decimal_Cero);
		SET Tot_ResComer    := IFNULL(Tot_ResComer, Decimal_Cero);
		SET Tot_Vivienda    := IFNULL(Tot_Vivienda, Decimal_Cero);
		SET Tot_ResVivie    := IFNULL(Tot_ResVivie, Decimal_Cero);



		-- Monto de la Reserva del Trimestre Anterior
		SET Var_Trimestre := CASE
			WHEN MONTH(Par_Fecha) >= 1 AND MONTH(Par_Fecha) <= 3 THEN
							STR_TO_DATE(CONCAT(YEAR(Par_Fecha), '-', '03', '-', '31'), '%Y-%m-%d')
			WHEN MONTH(Par_Fecha) >= 4 AND MONTH(Par_Fecha) <= 6 THEN
							STR_TO_DATE(CONCAT(YEAR(Par_Fecha), '-', '06', '-', '30'), '%Y-%m-%d')
			WHEN MONTH(Par_Fecha) >= 7 AND MONTH(Par_Fecha) <= 9 THEN
							STR_TO_DATE(CONCAT(YEAR(Par_Fecha), '-', '09', '-', '30'), '%Y-%m-%d')
			ELSE STR_TO_DATE(CONCAT(YEAR(Par_Fecha), '-', '12', '-', '31'), '%Y-%m-%d')
			END;
		SET Var_Trimestre   := DATE_ADD(Var_Trimestre, INTERVAL -3 MONTH);

		SELECT  MAX(res.Fecha) INTO Var_FecResTrim FROM CALRESCREDITOS res WHERE res.Fecha <= Var_Trimestre;
		SET  Var_FecResTrim  := IFNULL(Var_FecResTrim, Fecha_Vacia);

		SELECT  SUM(res.Reserva) INTO Var_MonResTrim FROM CALRESCREDITOS res WHERE res.Fecha = Var_FecResTrim;
		SET  Var_MonResTrim  := IFNULL(Var_MonResTrim, Entero_Cero);

		SET Var_ExceEstima  :=   ROUND(Tot_ResGene - Var_MonResTrim, 2);




		INSERT INTO TMPREGULATORIOR0417 (
				Reg_Concepto,		Reg_CarteraBase,		Reg_Orden,			Reg_Estilo,				Reg_ColorCelda,
				Reg_ClaveConcepto,	Reg_CuentaCNBV,			Reg_Estimacion)
		SELECT 	Det_DesDias, 		Det_Responsab,			Det_Orden, 			Cadena_Vacia,			Cadena_Vacia,
				Det_ClaveConcepto,	Det_ClaveConcepto,		CASE WHEN Det_Reservas > 0 THEN Det_Reservas *-1 ELSE Det_Reservas END AS Det_Reservas
		FROM TMPCONCEPTOSR0417;


		UPDATE TMPREGULATORIOR0417  SET Reg_Estimacion  =  Var_ExceEstima WHERE  Reg_TmpID = 1; -- A) Exceso o (Insuficiencia) en Estimaciones (C - B)
		UPDATE TMPREGULATORIOR0417  SET Reg_Estimacion  =  Var_MonResTrim WHERE  Reg_TmpID = 2; -- B) Otras Estimaciones
		UPDATE TMPREGULATORIOR0417  SET Reg_Estimacion  =  Var_MontoGarantias WHERE  Reg_TmpID = 3; --        Depositos en GarantÃ­a
		UPDATE TMPREGULATORIOR0417  SET Reg_Estimacion  =  Var_MonResTrim WHERE  Reg_TmpID = 4; -- Estimaciones Constituidas en el Periodo Anterior
		UPDATE TMPREGULATORIOR0417  SET Reg_CarteraBase =  Tot_General,
										Reg_Estimacion  =  Tot_ResGene 	 WHERE  Reg_TmpID = 5; -- C) Cartera de Credito Total
		UPDATE TMPREGULATORIOR0417  SET Reg_CarteraBase =  Tot_Consumo,
										Reg_Estimacion  =  Tot_ResCons	 WHERE  Reg_TmpID = 6; -- Cartera Crediticia de Consumo
		UPDATE TMPREGULATORIOR0417  SET Reg_CarteraBase =  Tot_Consumo,
										Reg_Estimacion  =  Tot_ResCons WHERE  Reg_TmpID = 7; -- Tipo I
		UPDATE TMPREGULATORIOR0417  SET Reg_CarteraBase =  Tot_Comercial,
										Reg_Estimacion  =  Tot_ResComer WHERE  Reg_TmpID = 27; -- Cartera Crediticia Comercial
		UPDATE TMPREGULATORIOR0417  SET Reg_CarteraBase =  Tot_Comercial,
										Reg_Estimacion  =  Tot_ResComer WHERE  Reg_TmpID = 28; -- Cartera 1
		UPDATE TMPREGULATORIOR0417  SET Reg_CarteraBase =  Tot_Vivienda,
										Reg_Estimacion  =  Tot_ResVivie WHERE  Reg_TmpID = 68; -- Creditos a la Vivienda





	# ================ SE OBTIENEN LOS VALORES QUE SE MUESTRAN EN LOS REPORTES ===================

	/* --------------- Reporte Regulatorio Calificacion y Estimaciones 0417 Excel ------------- */
	IF(Par_NumReporte = Rep_Excel) THEN

		UPDATE TMPREGULATORIOR0417 SET Reg_Estilo = Est_Negrita WHERE Reg_TmpID IN (1,2,3,4,5,6,7,8,17,18,27,28,29,40,41,52,53,60,61,68,69);
		UPDATE TMPREGULATORIOR0417 SET Reg_ColorCelda = ColorCelda WHERE Reg_TmpID IN (3,8,16,18,29,39,41,51,53,59,61,67,69);

		SELECT Reg.Reg_Concepto,   	ROUND(Reg.Reg_CarteraBase,0) AS Reg_CarteraBase,   	 ROUND(Reg.Reg_Estimacion,0) AS Reg_Estimacion, 	 	Reg_Estilo, Reg_Estilo,
				Reg_ColorCelda
		FROM TMPREGULATORIOR0417 Reg
		ORDER BY Reg.Reg_Orden;
	END IF;



	/* --------------- Reporte Regulatorio Calificacion y Estimaciones 0417 CSV --------------- */
	IF(Par_NumReporte = Rep_Csv) THEN
		SET Var_ClaveEntidad	:= IFNULL((SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Par, INSTITUCIONES Ins WHERE Par.InstitucionID = Ins.InstitucionID), Cadena_Vacia);

		DROP TEMPORARY TABLE IF EXISTS TMPB0417CSV;
		CREATE TEMPORARY TABLE TMPB0417CSV
		SELECT  CONCAT(Var_ClaveEntidad,';',Valor_Fijo1,';',IFNULL(Reg.Reg_CuentaCNBV, Cadena_Vacia),';',Clave_Reporte,';','9',';',ROUND(IFNULL(Reg.Reg_CarteraBase,Entero_Cero),Entero_Cero)) AS Valor
			FROM TMPREGULATORIOR0417 Reg
		WHERE Reg.Reg_TmpID NOT IN(1,2,3,4,8,18,29,41,53,61,69)
		ORDER BY Reg.Reg_Orden;

		INSERT INTO TMPB0417CSV
			SELECT  CONCAT(Var_ClaveEntidad,';',Valor_Fijo1,';',IFNULL(Reg2.Reg_CuentaCNBV, Cadena_Vacia),';',Clave_Reporte,';','10',';',ROUND(IFNULL(Reg2.Reg_Estimacion,Entero_Cero),Entero_Cero)) AS Valor
			FROM TMPREGULATORIOR0417 Reg2
		WHERE Reg2.Reg_TmpID NOT IN(8,18,29,41,53,61,69)
		ORDER BY Reg2.Reg_Orden;

		SELECT Valor FROM TMPB0417CSV;
		DROP TEMPORARY TABLE IF EXISTS TMPB0417CSV;

	END IF;



END TerminaStore$$