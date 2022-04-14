-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA041100006REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA041100006REP`;DELIMITER $$

CREATE PROCEDURE `REGA041100006REP`(
/*===========================================================================
# SP PARA GENERAR  REPORTE REGULATORIO DE CARTERA POR TIPO DE CREDITO SOCAPS
==============================================================================*/
    Par_Fecha           	DATETIME,				-- Fecha de reporte
	Par_NumReporte      	TINYINT UNSIGNED,       -- Numero d ereporte

    Par_EmpresaID       	INT,                    -- EmpresaID
    Aud_Usuario         	INT,                    -- UsarioID
    Aud_FechaActual     	DATETIME,               -- Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),            -- Direccion IP
    Aud_ProgramaID      	VARCHAR(50),            -- ProgramaID
    Aud_Sucursal        	INT,                    -- Sucursal
    Aud_NumTransaccion  	BIGINT                  -- Numero de transaccion
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_ReporteID		VARCHAR(20);			-- variable clave de reporte
	DECLARE Var_ClaveEntidad	VARCHAR(300);			-- clave de la entidad
	DECLARE Var_RepRegID    	INT;					-- Identificador del reporte
	DECLARE Var_SI				CHAR(1);				-- variable si
	DECLARE Var_NO				CHAR(1);				-- variable no
	DECLARE Var_TipoIntPro		INT(4);					-- interes provisional
	DECLARE Var_InicioPeriodo	DATE;					-- INicio del periodo
	DECLARE Var_NivelInst		VARCHAR(5);				-- nivel institucional
	DECLARE Var_PrimerDiaMes    DATE;					-- primer dia del mes
    -- DEclaracion de constantes
	DECLARE Entero_Cero     	INT; 					-- Entero cero
    DECLARE CarteraTip2014  	INT;					-- Reporte excel version 2014
	DECLARE CarteraTip2013  	INT;					-- Reporte excel version 2013
	DECLARE Rep_Csv				INT;  					-- Reporte csv version 2013
	DECLARE Decimal_Cero    	DECIMAL(12,2);			-- DECIMAL cero
	DECLARE Cadena_Vacia    	CHAR(1);				-- cadena vacia
	DECLARE Nat_Cargo			CHAR(1);				-- naturaleza cargo
	DECLARE Version2013			INT;					-- Version 2013
    DECLARE EstatusVigente		CHAR(1);				-- estatus vigente
    DECLARE EstatusVencido		CHAR(1);				-- estatus vencido
    DECLARE EstatusPagado		CHAR(1);				-- estatus pagado
    DECLARE IDRegulatorio411	VARCHAR(20);			-- ID para csv 411
	DECLARE Valor_Uno			CHAR(10);				-- Cadena uno
    DECLARE Valor_Dos			CHAR(10);				-- Cadena dos
    DECLARE Valor_Tres			CHAR(10);				-- Cadena tres
    DECLARE Valor_Cuatro		CHAR(10);				-- Cadena 4
    DECLARE Valor_Cinco			CHAR(10);				-- Cadena 5


    -- Asiganacion de Constantes
	SET Entero_Cero     	:= 0;
	SET CarteraTip2014 	 	:= 1;
	SET CarteraTip2013  	:= 2;
	SET Rep_Csv				:= 3;
	SET Var_TipoIntPro		:= 14;
	SET Decimal_Cero		:= 0.00;
	SET Cadena_Vacia  		:= '';
	SET Nat_Cargo			:= 'C';
	SET Var_SI				:= 'S';
	SET Var_NO				:= 'N';
	SET EstatusVigente		:= 'V';
    SET EstatusVencido		:= 'B';
    SET EstatusPagado		:= 'P';
    SET IDRegulatorio411	:= "411";
    SET Version2013			:= 2015;
	SET Valor_Uno			:= "1";
    SET Valor_Dos			:= "2";
    SET Valor_Tres			:= "3";
    SET Valor_Cuatro		:= "4";
    SET Valor_Cinco			:= "5";
	SET Var_ClaveEntidad	:= (SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Par, INSTITUCIONES Ins WHERE Par.InstitucionID = Ins.InstitucionID);
	SET Var_NivelInst		:= (SELECT Ins.ClaveNivInstitucion FROM PARAMETROSSIS  Ins WHERE Ins.EmpresaID = Par_EmpresaID);
	SET Var_ReporteID		:= 'A0411';
	SET Var_InicioPeriodo	:=DATE_FORMAT(Par_Fecha, '%Y-%m-01');

	DROP TABLE IF EXISTS CarteraTipoCredito;
	CREATE temporary TABLE CarteraTipoCredito (
		ClaveConcepto     			VARCHAR(12),
		Descripcion       			VARCHAR(50),
		SalCapVigente     			DECIMAL(14,2),
		SalCapAtrasado				DECIMAL(14,2),
		SalCapVencido 				DECIMAL(14,2),
		SalCapVenNoExi 				DECIMAL(14,2),
		SalIntOrdinario	 			DECIMAL(14,2),
		SalIntAtrasado 				DECIMAL(14,2),
		SalIntVencido 				DECIMAL(14,2),
		SalIntProvision 			DECIMAL(14,2),
		SalMoratorios				DECIMAL(14,2),
		PagoIntOrdDia 				DECIMAL(14,2),
		PagoIntAtrDia				DECIMAL(14,2),
		PagoIntVenDia				DECIMAL(14,2),
		SalComFaltaPago				DECIMAL(14,2),
		SalOtrasComisi				DECIMAL(14,2),
		PagoCapVenDia				DECIMAL(14,2),
		SaldoMoraVencido			DECIMAL(14,2),
		SaldoMoraCarVen				DECIMAL(14,2),
		TipoConcepto 				CHAR(1),
		DestinoCreID 				INT(11),
		ClasifRegID 				INT(11),
		DiasAtraso	 				INT(11),
		EstatusCredito	 			CHAR(1)
	);
	CREATE INDEX id_ClasifRegID ON CarteraTipoCredito (ClasifRegID);

	DROP TABLE IF EXISTS TMPCARTERA2013411;
	CREATE TABLE IF NOT EXISTS TMPCARTERA2013411(
		ConceptoID			INT(11)	PRIMARY KEY AUTO_INCREMENT,
		ClasifRegID			INT(11),
		ClaveConcepto		VARCHAR(12),
		ClaveCon			VARCHAR(22),
		Descripcion     	VARCHAR(200),
		SaldoCapital		INT(11),
		SaldoInteres		INT(11),
		SaldoTotal			INT(11),
		InteresMes			INT(11),
		ComisionMes			INT(11),
		IndicadorEsNegrita	CHAR(1)
	);



	IF(Par_NumReporte = CarteraTip2014) THEN
		SET Var_RepRegID    := 1;


		INSERT INTO CarteraTipoCredito (
								ClaveConcepto,     		Descripcion, 			SalCapVigente,     		SalCapAtrasado,
								SalCapVencido,     		SalCapVenNoExi,			SalIntOrdinario,   		SalIntAtrasado,
								SalIntVencido,     		SalIntProvision,      	TipoConcepto,			DestinoCreID)
		SELECT  				Cadena_Vacia, 			Cadena_Vacia,			Sal.SalCapVigente,		Sal.SalCapAtrasado,
								Sal.SalCapVencido,     	Sal.SalCapVenNoExi,		Sal.SalIntOrdinario,	Sal.SalIntAtrasado,
								Sal.SalIntVencido,     	Sal.SalIntProvision,    Cadena_Vacia,			DestinoCreID
			 FROM SALDOSCREDITOS Sal
			 WHERE Sal.FechaCorte  = Par_Fecha;

		UPDATE	CarteraTipoCredito	Car	,
				DESTINOSCREDITO		Des	SET
			Car.ClasifRegID		=	Des.ClasifRegID
		WHERE Car.DestinoCreID	=	Des.DestinoCreID;

		UPDATE	CarteraTipoCredito	Car	,
				CATCLASIFREPREG		Cat	SET
			Car.TipoConcepto	=	Cat.TipoConcepto,
			Car.Descripcion		=	Cat.Descripcion,
			Car.ClaveConcepto	=	Cat.ClaveConcepto
		WHERE	Car.ClasifRegID	= Cat.ClasifRegID
		 AND 	Cat.ReporteID   = Var_RepRegID;



		SELECT  Cat.ClaveConcepto, MAX(Cat.Descripcion) AS Descripcion,
					SUM(IFNULL(Car.SalCapVigente,Entero_Cero) + IFNULL(Car.SalCapAtrasado,Entero_Cero) +
						ROUND(IFNULL(Car.SalIntOrdinario,Entero_Cero),2) +
						ROUND(IFNULL(Car.SalIntProvision,Entero_Cero),2) +
						ROUND(IFNULL(Car.SalIntAtrasado,Entero_Cero),2)) AS Total_Vigente,

					SUM(IFNULL(Car.SalCapVigente,Entero_Cero) + IFNULL(Car.SalCapAtrasado,Entero_Cero)) AS Principal_Vigente,

					SUM(ROUND(IFNULL(Car.SalIntOrdinario,Entero_Cero), 2) +
						ROUND(IFNULL(Car.SalIntProvision,Entero_Cero),2) +
						ROUND(IFNULL(Car.SalIntAtrasado,Entero_Cero),2)) AS Interes_Vigente,

					SUM(IFNULL(Car.SalCapVigente,Entero_Cero) +
						ROUND(IFNULL(Car.SalIntOrdinario,Entero_Cero),2) +
						ROUND(IFNULL(Car.SalIntProvision,Entero_Cero),2) ) AS Total_Sin_Pago_Vencido,

					SUM(IFNULL(Car.SalCapVigente,Entero_Cero)) AS Principal_Sin_Pago_Vencido,

					SUM(ROUND(IFNULL(Car.SalIntOrdinario,Entero_Cero),2) +
						ROUND(IFNULL(Car.SalIntProvision,Entero_Cero),2)) AS Interes_Sin_Pago_Vencido,

					SUM(IFNULL(Car.SalCapAtrasado,Entero_Cero) +
						ROUND(IFNULL(Car.SalIntAtrasado,Entero_Cero),2)) AS Total_Con_Pago_Vencido,

					SUM(IFNULL(Car.SalCapAtrasado,Entero_Cero)) AS Principal_Con_Pago_Vencido,

					SUM(ROUND(IFNULL(Car.SalIntAtrasado,Entero_Cero),2)) AS Interes_Con_Pago_Vencido,

					SUM(IFNULL(Car.SalCapVencido, Entero_Cero) + IFNULL(SalCapVenNoExi, Entero_Cero)+
						ROUND(IFNULL(Car.SalIntVencido, Entero_Cero),2)) AS Total_Vencido,

					SUM(IFNULL(Car.SalCapVencido, Entero_Cero) + IFNULL(Car.SalCapVenNoExi, Entero_Cero)) AS Principal_Vencido,
					SUM(ROUND(IFNULL(Car.SalIntVencido, Entero_Cero),2)) AS Interes_Vencido,
					MAX(Cat.TipoConcepto) AS TipoConcepto
								FROM CATCLASIFREPREG Cat
								LEFT JOIN CarteraTipoCredito Car
								ON Car.ClaveConcepto LIKE CONCAT(Cat.Concepto, '%')
							GROUP BY Cat.ClaveConcepto;
	END IF;



	IF(Par_NumReporte != CarteraTip2014) THEN
		SET Par_Fecha := (SELECT MAX(Fecha) FROM CALRESCREDITOS WHERE Fecha <= Par_Fecha);

		SET Var_ReporteID  =  Var_ReporteID;


		INSERT INTO TMPCARTERA2013411 (Descripcion,		SaldoCapital,			SaldoInteres,			SaldoTotal,			InteresMes,
									ComisionMes,		IndicadorEsNegrita,		ClasifRegID,			ClaveConcepto,		ClaveCon)
		SELECT					    Cat.Descripcion,	Decimal_Cero,			Decimal_Cero,			Decimal_Cero,		Decimal_Cero,
									Decimal_Cero,		IndicadorEsNegrita,		ClasifRegID,			Concepto,			ClaveConceptoCap
			FROM CONCEPTOSREGREP Cat
			WHERE Cat.ReporteID   = Var_ReporteID
            AND Cat.Version = Version2013;





		DROP TABLE IF EXISTS TMPSALDOPROVMES411;
		CREATE TEMPORARY TABLE TMPSALDOPROVMES411
		SELECT CreditoID,	ROUND(SUM(Mov.Cantidad),2) AS Saldo
			FROM CREDITOSMOVS	Mov
			WHERE 	FechaOperacion	>= Var_InicioPeriodo
				AND	FechaOperacion	<= Par_Fecha
				AND NatMovimiento	= Nat_Cargo
			AND TipoMovCreID 	= Var_TipoIntPro
		GROUP BY Mov.CreditoID ;
		CREATE INDEX id_CreditoID ON TMPSALDOPROVMES411 (CreditoID);

		DROP TABLE IF EXISTS TMPCARTERAMES411;
		CREATE temporary TABLE TMPCARTERAMES411 (

			ClaveConcepto     			VARCHAR(12),
			Descripcion       			VARCHAR(50),
			SalCapVigente     			DECIMAL(14,2),
			SalCapAtrasado				DECIMAL(14,2),
			SalCapVencido 				DECIMAL(14,2),
			SalCapVenNoExi 				DECIMAL(14,2),
			SalIntOrdinario	 			DECIMAL(14,2),
			SalIntAtrasado 				DECIMAL(14,2),
			SalIntVencido 				DECIMAL(14,2),
			SalIntProvision 			DECIMAL(14,2),
	        SalIntNoConta				DECIMAL(14,2),
			SalMoratorios				DECIMAL(14,2),
			IntMes						DECIMAL(14,2),
			IntMesAtr					DECIMAL(14,2),
			IntMesVen					DECIMAL(14,2),
			SalComFaltaPago				DECIMAL(14,2),
			SalOtrasComisi				DECIMAL(14,2),
			PagoCapVenDia				DECIMAL(14,2),
			PagoIntVenDia				DECIMAL(14,2),
			SaldoMoraVencido			DECIMAL(14,2),
			DestinoCreID 				INT(11),
			CreditoID					BIGINT(12),
	        ClasifRegID 				INT(11),
			DiasAtraso					INT(11),
			EstatusCredito				CHAR(1),
			SaldoMoraCarVen				DECIMAL(14,2),
            ComAperPagado				DECIMAL(14,2)
		);


		INSERT INTO TMPCARTERAMES411
		SELECT	Cadena_Vacia,     				Cadena_Vacia,						Sal.SalCapVigente,					Sal.SalCapAtrasado,			Sal.SalCapVencido,Sal.SalCapVenNoExi,
				Sal.SalIntOrdinario,			Sal.SalIntAtrasado,					Sal.SalIntVencido,					Sal.SalIntProvision,		Sal.SalIntNoConta,
				Sal.SalMoratorios,				Decimal_Cero AS IntMes,				Decimal_Cero AS IntMesAtr,			Decimal_Cero AS IntMesVen,	Sal.SalComFaltaPago,
				Sal.SalOtrasComisi,				Sal.PagoCapVenDia,					Sal.PagoIntVenDia,					Sal.SaldoMoraVencido,		Sal.DestinoCreID,
				Sal.CreditoID,					Entero_Cero AS ClasifRegID,	 		Cal.DiasAtraso,						Sal.EstatusCredito,		Sal.SaldoMoraCarVen,
                Cre.ComAperPagado
			 FROM	SALDOSCREDITOS Sal,
	         CALRESCREDITOS Cal, CREDITOS Cre
			 WHERE 	Sal.FechaCorte	= Par_Fecha
				AND Sal.FechaCorte  = Cal.Fecha
	            AND Sal.CreditoID	=Cal.CreditoID
                AND Sal.CreditoID	=Cre.CreditoID
				AND (EstatusCredito	= EstatusVigente OR EstatusCredito = EstatusVencido);
		CREATE INDEX id_CreditoID ON TMPCARTERAMES411 (CreditoID);

-- CREDITOS PAGADOS EN EL MES

 SET Var_PrimerDiaMes := CONVERT(DATE_ADD(Par_Fecha, INTERVAL -1*(DAY(Par_Fecha))+1 DAY),DATE);

		INSERT INTO TMPCARTERAMES411
		SELECT	Cadena_Vacia,     				Cadena_Vacia,						Sal.SalCapVigente,					Sal.SalCapAtrasado,			Sal.SalCapVencido,	Sal.SalCapVenNoExi,
				Sal.SalIntOrdinario,			Sal.SalIntAtrasado,					Sal.SalIntVencido,					Sal.SalIntProvision,		Sal.SalIntNoConta,
				Sal.SalMoratorios,				Decimal_Cero AS IntMes,				Decimal_Cero AS IntMesAtr,			Decimal_Cero AS IntMesVen,	Sal.SalComFaltaPago,
				Sal.SalOtrasComisi,				Sal.PagoCapVenDia,					Sal.PagoIntVenDia,					Sal.SaldoMoraVencido,		Sal.DestinoCreID,
				Sal.CreditoID,					Entero_Cero AS ClasifRegID,	 		Entero_Cero,						Sal.EstatusCredito,			Sal.SaldoMoraCarVen,
                Cre.ComAperPagado
		 FROM	SALDOSCREDITOS Sal,
					CREDITOS Cre
			 WHERE 	Sal.FechaCorte	>= Var_PrimerDiaMes
				AND Sal.FechaCorte	<= Par_Fecha
                AND Sal.CreditoID	= Cre.CreditoID
				AND EstatusCredito	= EstatusPagado
				AND FechTerminacion >=  Var_PrimerDiaMes
				AND FechTerminacion <=  Par_Fecha;

		UPDATE	TMPCARTERAMES411	TMP	,
				TMPSALDOPROVMES411	SAL		SET
			IntMes	= Saldo
		WHERE	TMP.CreditoID = SAL.CreditoID
		AND 	DiasAtraso = Entero_Cero;

		UPDATE	TMPCARTERAMES411	TMP	,
				TMPSALDOPROVMES411	SAL		SET
			IntMesAtr	= Saldo
		WHERE	TMP.CreditoID = SAL.CreditoID

		AND 	(DiasAtraso > Entero_Cero
		AND 	DiasAtraso <= 90 );

		UPDATE	TMPCARTERAMES411	TMP	,
				TMPSALDOPROVMES411	SAL		SET
			IntMesVen	= Saldo
		WHERE	TMP.CreditoID = SAL.CreditoID

		AND 	DiasAtraso > 90;


		UPDATE	TMPCARTERAMES411	Car
			INNER JOIN	DESTINOSCREDITO		Des	ON Car.DestinoCreID	=	Des.DestinoCreID
	        SET Car.ClasifRegID		=	Des.ClasifRegID;

		UPDATE	TMPCARTERAMES411		Car	,
				TMPCARTERA2013411		Cat	SET
			Car.ClaveConcepto	=	Cat.ClaveConcepto,
			Car.Descripcion		=	Cat.Descripcion
		WHERE	Car.ClasifRegID	= Cat.ClasifRegID;



	DROP TABLE IF EXISTS TMP411SALDOSCREDITO;
	CREATE TABLE IF NOT EXISTS TMP411SALDOSCREDITO(
		SaldoCapital		INT(11),
		SaldoInteres		INT(11),
		InteresMes			INT(11),
		ComisionMes			INT(11),
		ClasifRegID     	INT(11)
	);

	CREATE INDEX id_indexClasifRegID ON TMP411SALDOSCREDITO (ClasifRegID);



	INSERT INTO TMP411SALDOSCREDITO
	SELECT	ROUND(SUM(Car.SalCapVigente)+SUM(Car.SalCapAtrasado),Entero_Cero) AS	SaldoCapital ,
			SUM(Car.SalIntOrdinario)  +  SUM(Car.SalIntProvision) +SUM(Car.SalIntAtrasado)	 AS SaldoInteres,
			ROUND(SUM(Car.IntMes))	AS	InteresMes,
			ROUND(SUM(Car.ComAperPagado))  AS ComisionMes,
			Tmp.ClasifRegID
		FROM	TMPCARTERAMES411 Car ,
				TMPCARTERA2013411 Tmp
		 WHERE  Car.ClasifRegID =Tmp.ClasifRegID
		AND  Tmp.ConceptoID < 23
		AND	DiasAtraso = Entero_Cero
		GROUP BY Tmp.ClasifRegID;


	UPDATE	TMPCARTERA2013411 Tmp,
			TMP411SALDOSCREDITO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital ,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes

	WHERE Tmp.ConceptoID < 23
		AND Tmp.ClasifRegID =Sal.ClasifRegID;

	    DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID = 4 OR Sal.ConceptoID = 11;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 3;



        DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID =3;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 10;

    	DELETE FROM TMP411SALDOSCREDITO;
	INSERT INTO TMP411SALDOSCREDITO


	 SELECT	 ROUND(SUM(Car.SalCapVigente)+SUM(Car.SalCapAtrasado),Entero_Cero) AS	SaldoCapital ,
			SUM(Car.SalIntOrdinario)  +  SUM(Car.SalIntProvision) +SUM(Car.SalIntAtrasado)	 AS SaldoInteres,
			ROUND(SUM(Car.IntMesAtr),Entero_Cero)	AS	InteresMes,
			ROUND(SUM(Car.ComAperPagado))  AS ComisionMes,
			Tmp.ClasifRegID
		FROM	TMPCARTERAMES411 Car  ,
				TMPCARTERA2013411 Tmp
		 WHERE Car.ClasifRegID=Tmp.ClasifRegID
		AND  Tmp.ConceptoID   BETWEEN 23 AND 43
		AND	(DiasAtraso > Entero_Cero
		AND	DiasAtraso <= 90)
		GROUP BY Tmp.ClasifRegID;



	UPDATE	TMPCARTERA2013411 Tmp,
			TMP411SALDOSCREDITO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID BETWEEN 23 AND 43
	AND Tmp.ClasifRegID =Sal.ClasifRegID;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID = 25 OR Sal.ConceptoID = 32;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 24;



        DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID =24;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 31;



	DELETE FROM TMP411SALDOSCREDITO;
	INSERT INTO TMP411SALDOSCREDITO
	SELECT	ROUND(SUM(Car.SalCapVencido) + SUM(Car.SalCapVenNoExi),Entero_Cero)	AS	SaldoCapital ,
			ROUND(SUM(SaldoMoraVencido),Entero_Cero)  +	ROUND(SUM(SalIntVencido),Entero_Cero) AS	SaldoInteres,
			ROUND(SUM(Car.SalIntOrdinario)  +  SUM(Car.SalIntProvision) +SUM(Car.SalIntAtrasado)
            +SUM(Car.IntMesVen),Entero_Cero)	AS	InteresMes,
			ROUND(SUM(Car.ComAperPagado))  AS ComisionMes,
			Tmp.ClasifRegID
		FROM	TMPCARTERAMES411 Car  ,
				TMPCARTERA2013411 Tmp
		WHERE Car.ClasifRegID=Tmp.ClasifRegID
		AND  Tmp.ConceptoID > 43
		AND EstatusCredito = EstatusVencido
		GROUP BY Car.ClasifRegID;

	    UPDATE	TMPCARTERA2013411 Tmp,
			TMP411SALDOSCREDITO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
		WHERE Tmp.ConceptoID	> 43
		AND Tmp.ClasifRegID =Sal.ClasifRegID;

	    DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID = 46 OR Sal.ConceptoID = 53;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 45;



        DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID =45;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 52;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID = 4 OR Sal.ConceptoID = 11;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 3;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID  BETWEEN 13 AND 19;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 12;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID  BETWEEN 21 AND 22;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 20;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) 	AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) 	AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero) 	AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE (Sal.ConceptoID = 3 OR Sal.ConceptoID = 12 OR Sal.ConceptoID = 20 );

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 2;



	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID = 25 OR Sal.ConceptoID = 32;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 24;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID  BETWEEN 34 AND 40;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 33;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID  BETWEEN 42 AND 43;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 41;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) 	AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) 	AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero) 	AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE (Sal.ConceptoID = 24 OR Sal.ConceptoID = 33 OR Sal.ConceptoID = 41 );

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 23;




     DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID = 46 OR Sal.ConceptoID = 53;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 45;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID  BETWEEN 55 AND 61;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 54;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE Sal.ConceptoID  BETWEEN 63 AND 64;

	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 62;


		DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
		CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
		SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) 	AS SaldoCapital,
				ROUND(SUM(Sal.SaldoInteres),Entero_Cero) 	AS SaldoInteres,
				ROUND(SUM(Sal.InteresMes),Entero_Cero)	AS InteresMes,
				ROUND(SUM(Sal.ComisionMes),Entero_Cero) 	AS ComisionMes
			FROM	TMPCARTERA2013411 Sal
		WHERE (Sal.ConceptoID = 45 OR Sal.ConceptoID = 54 OR Sal.ConceptoID = 62);

		UPDATE	TMPCARTERA2013411			Tmp,
				TMP411ACUMULADOPORTIPO	Sal	SET
			Tmp.SaldoCapital	= 	Sal.SaldoCapital,
			Tmp.SaldoInteres	= 	Sal.SaldoInteres,
			Tmp.InteresMes		= 	Sal.InteresMes,
			Tmp.ComisionMes		= 	Sal.ComisionMes
		WHERE Tmp.ConceptoID	= 44;



	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;
	CREATE TEMPORARY TABLE	TMP411ACUMULADOPORTIPO
	SELECT	ROUND(SUM(Sal.SaldoCapital),Entero_Cero) AS SaldoCapital,
			ROUND(SUM(Sal.SaldoInteres),Entero_Cero) AS SaldoInteres,
			ROUND(SUM(Sal.InteresMes),Entero_Cero)	  AS InteresMes,
			ROUND(SUM(Sal.ComisionMes),Entero_Cero)  AS ComisionMes
		FROM	TMPCARTERA2013411 Sal
	WHERE (Sal.ConceptoID = 2 OR Sal.ConceptoID = 23 OR Sal.ConceptoID = 44 );
	UPDATE	TMPCARTERA2013411			Tmp,
			TMP411ACUMULADOPORTIPO	Sal	SET
		Tmp.SaldoCapital	= 	Sal.SaldoCapital,
		Tmp.SaldoInteres	= 	Sal.SaldoInteres,
		Tmp.InteresMes		= 	Sal.InteresMes,
		Tmp.ComisionMes		= 	Sal.ComisionMes
	WHERE Tmp.ConceptoID	= 1;

	DROP TABLE IF EXISTS	TMP411ACUMULADOPORTIPO;


	UPDATE TMPCARTERA2013411 SET SaldoTotal = SaldoCapital + SaldoInteres;

	END IF;



	IF(Par_NumReporte = CarteraTip2013) THEN

		SELECT	Tmp.Descripcion,						(Tmp.SaldoCapital) AS SaldoCapital,	ROUND(Tmp.SaldoInteres,Entero_Cero) AS SaldoInteres,
				ROUND(Tmp.SaldoTotal,Entero_Cero) AS SaldoTotal,	ROUND(Tmp.InteresMes,Entero_Cero) AS InteresMes,		ROUND(Tmp.ComisionMes,Entero_Cero) AS ComisionMes,
				Tmp.IndicadorEsNegrita
		FROM TMPCARTERA2013411 Tmp;

	END IF;



	IF(Par_NumReporte = Rep_Csv) THEN

    (SELECT CONCAT(
        Var_NivelInst,    ';',    IFNULL(ClaveCon,'') ,
        ';',    IDRegulatorio411,   ';',  Valor_Uno,  ';',  ROUND(IFNULL(SaldoCapital,Entero_Cero),Entero_Cero) ) AS Valor
      FROM TMPCARTERA2013411)
    UNION ALL
    (SELECT CONCAT(
        Var_NivelInst,    ';',    IFNULL(ClaveCon,'') ,
        ';',    IDRegulatorio411,   ';',  Valor_Dos,  ';',  ROUND(SaldoInteres,Entero_Cero) ) AS Valor
      FROM TMPCARTERA2013411)
    UNION ALL
    (SELECT CONCAT(
        Var_NivelInst,    ';',    IFNULL(ClaveCon,'') ,
        ';',    IDRegulatorio411,   ';',  Valor_Tres, ';',  ROUND(SaldoTotal,Entero_Cero) ) AS Valor
      FROM TMPCARTERA2013411)
    UNION ALL
    (SELECT CONCAT(
        Var_NivelInst,    ';',    IFNULL(ClaveCon,'') ,
        ';',    IDRegulatorio411,   ';',  Valor_Cuatro, ';',  ROUND(InteresMes,Entero_Cero) ) AS Valor
      FROM TMPCARTERA2013411)
    UNION ALL
    (SELECT CONCAT(
        Var_NivelInst,    ';',    IFNULL(ClaveCon,'')  ,
        ';',    IDRegulatorio411,   ';',  Valor_Cinco,  ';',  ROUND(ComisionMes,Entero_Cero)  ) AS Valor
      FROM TMPCARTERA2013411);
	END IF;

	DROP TEMPORARY TABLE IF EXISTS CarteraTipoCredito;
	DROP TEMPORARY TABLE IF EXISTS TMPCARTERA2013411;

END TerminaStore$$