-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA041100003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA041100003REP`;
DELIMITER $$


CREATE PROCEDURE `REGA041100003REP`(
-- ========================================================================================
-- SP PARA GENERAR  REPORTE REGULATORIO DE CARTERA POR TIPO DE CREDITO VERSION 2017 SOFIPOS
-- =========================================================================================
	Par_Fecha           	DATETIME,				-- Fecha de reporte
	Par_NumReporte      	TINYINT UNSIGNED,		-- Numero d ereporte

	Par_EmpresaID       	INT(11),				-- EmpresaID
	Aud_Usuario         	INT(11),				-- UsarioID
	Aud_FechaActual     	DATETIME,				-- Fecha Actual
	Aud_DireccionIP     	VARCHAR(15),			-- Direccion IP
	Aud_ProgramaID      	VARCHAR(50),			-- ProgramaID
	Aud_Sucursal        	INT(11), 				-- Sucursal
	Aud_NumTransaccion  	BIGINT(20)				-- Numero de transaccion
)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_ReporteID		VARCHAR(20);		-- ID del reporte
	DECLARE Var_ClaveEntidad	VARCHAR(300);		-- clave de la entidad
	DECLARE Var_RepRegID    	INT;				-- Version reporte
	DECLARE Var_TipoIntPro		INT(4);				-- Tipo d einteres
	DECLARE Var_InicioPeriodo	DATE;				-- Inicio del periodo
	DECLARE Var_NivelInst		VARCHAR(5);			-- Nivel institucional

    -- Declaracion de cosntantes
	DECLARE Entero_Cero     	INT; 				-- Entero cero
    DECLARE Rep_Excel2017	  	INT;				-- Reporte excel
	DECLARE Rep_Csv2017			INT;  				-- reporte csv
	DECLARE Decimal_Cero    	DECIMAL(21,2);		-- Decimal cero
	DECLARE Cadena_Vacia    	CHAR(1);			-- cadena vacia

    DECLARE Var_SI				CHAR(1);			-- variable si
	DECLARE Var_NO				CHAR(1);			-- variable no
	DECLARE Nat_Cargo			CHAR(1);			-- Naturaleza cargo
    DECLARE Version2017			INT(11);			-- verison del reporte
    DECLARE EstatusVigente		CHAR(1);			-- estatus vigente

    DECLARE EstatusVencido		CHAR(1);			-- estatus vencido
    DECLARE ConceptoVivienda	VARCHAR(20);		-- concepto destino vivienda
    DECLARE ClasificaVivienda	VARCHAR(20);		-- clasificacion vivienda
    DECLARE ClasificaVivMed		VARCHAR(20);		-- clasificacion vivienda
    DECLARE ConceptoReg08		VARCHAR(20);		-- COncepto0408

    DECLARE Concepto0302		VARCHAR(20);		-- Conceptos rg00302
    DECLARE ConceptoReg411		VARCHAR(20);		-- Conceptos 41101
    DECLARE Concepto41103		VARCHAR(20);		-- Conceptos 41103
    DECLARE Concepto1127		VARCHAR(20);		-- Concepto 1127
	DECLARE Concepto1128		VARCHAR(20);		-- Concepto 1128

	DECLARE Concepto1104		VARCHAR(20);		-- Concepto 1104
	DECLARE Concepto110402		VARCHAR(20);		-- Concepto 110402
	DECLARE Concepto110403		VARCHAR(20);		-- Concepto 110403
    DECLARE Concepto1105		VARCHAR(20);		-- Concepto 1105
    DECLARE Concepto11270201	VARCHAR(20);		-- Concepto 11270201

    DECLARE Concepto11280201	VARCHAR(20);		-- Concepto 11280201
    DECLARE IDRegulatorio411	VARCHAR(20);		-- ID para csv 411
    DECLARE Entero_Catorce		INT(11);			-- Entero 14
    DECLARE Entero_Dos			INT(11);			-- Entero dos
    DECLARE Valor_Uno			CHAR(10);			-- Cadena uno

    DECLARE Valor_Dos			CHAR(10);			-- Cadena dos
    DECLARE Valor_Tres			CHAR(10);			-- Cadena tres
    DECLARE Valor_Cuatro		CHAR(10);			-- Cadena 4
    DECLARE Valor_Cinco			CHAR(10);			-- Cadena 5
    DECLARE Var_SumaInteresVencidos	CHAR(1);

	-- INICIA Variables para ajuste de saldo -- > SOFIEXPRESS
    DECLARE Var_AjustaSaldo		CHAR(1);
	DECLARE Var_Redondeo		INT;
	DECLARE Var_Saldo	    	INT;
	-- FINALIZA Variables para ajuste de saldo -- > SOFIEXPRESS

	-- Asignacion de constantes
	SET Entero_Cero     	:= 0;
	SET Rep_Excel2017  		:= 1;
	SET Rep_Csv2017			:= 2;
	SET Var_TipoIntPro		:= 14;
	SET Decimal_Cero		:= 0.00;
	SET Cadena_Vacia  		:= '';
	SET Nat_Cargo			:= 'C';
	SET Var_SI				:= 'S';
	SET Var_NO				:= 'N';
	SET Var_ReporteID		:= 'A0411';
    SET Version2017			:= 2017;
    SET EstatusVigente		:= 'V';
    SET EstatusVencido		:= 'B';
    SET ConceptoVivienda	:= '10003';
    SET ClasificaVivienda	:= '411270101';
    SET ClasificaVivMed		:= '411280101';
    SET ConceptoReg08		:= '41108';
    SET Concepto0302		:= '4110302';
    SET ConceptoReg411 		:= '41102';
    SET Concepto41103		:= '41103';
    SET Concepto1127 		:= '41127';
    SET Concepto1128		:= '41128';
    SET Concepto1104		:= '41104';
	SET Concepto110402		:= '4110502';
    SET Concepto110403		:= '4110403';
	SET Concepto11270201	:= '411270201';
    SET Concepto11280201	:='411280201';
    SET Concepto1105		:= '41105';
    SET IDRegulatorio411	:= '411';
    SET Entero_Catorce		:= 14;
    SET Entero_Dos			:= 2;
    SET Valor_Uno			:= "1";
    SET Valor_Dos			:= "2";
    SET Valor_Tres			:= "3";
    SET Valor_Cuatro		:= "4";
    SET Valor_Cinco			:= "5";
	SET Var_InicioPeriodo	:= DATE_FORMAT(Par_Fecha, '%Y-%m-01');
	SET Var_ClaveEntidad	:= (SELECT Ins.ClaveEntidad FROM PARAMETROSSIS Par, INSTITUCIONES Ins WHERE Par.InstitucionID = Ins.InstitucionID);
	SET Var_NivelInst		:= (SELECT Ins.ClaveNivInstitucion FROM PARAMETROSSIS  Ins WHERE Ins.EmpresaID = Par_EmpresaID);
	SET Var_SumaInteresVencidos := IFNULL((SELECT IntCredVencidos FROM PARAMREGULATORIOS), Var_NO);
	SELECT AjusteSaldo INTO Var_AjustaSaldo FROM PARAMREGULATORIOS LIMIT 1;
	SET Var_AjustaSaldo := IFNULL(Var_AjustaSaldo , Var_NO);

	DROP TABLE IF EXISTS CarteraTipoCredito;

		CREATE TEMPORARY TABLE CarteraTipoCredito (
			SalCapVigente     			DECIMAL(14,2),
			ClaveConcepto     			VARCHAR(12),
			Descripcion       			VARCHAR(50),
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


	SET Par_Fecha 		:= (SELECT MAX(Fecha) FROM CALRESCREDITOS WHERE Fecha <= Par_Fecha);
	SET Var_ReporteID  	:=  Var_ReporteID;

	-- ===== Llenar los conceptos del regulatorio ===============
	DROP TABLE IF EXISTS TMPREG411SOFIPO;
		CREATE TEMPORARY TABLE TMPREG411SOFIPO(

		ClasifRegID 	VARCHAR(10),
		Concepto		VARCHAR(10),
		ClaveConcepto 	VARCHAR(20),
		Descripcion 	VARCHAR(250),
		ClasifConta 	VARCHAR(20),

		CarTotal		DECIMAL(21,2),
		ToTalVigente	DECIMAL(21,2),
		PrincipalVigen	DECIMAL(21,2),
		InteresesVigen	DECIMAL(21,2),
		CredSinPagVen	DECIMAL(21,2),

		SinPagVenPrin	DECIMAL(21,2),
		SinPagVenInt	DECIMAL(21,2),
		CredConPagVen	DECIMAL(21,2),
		ConPagVenPrin	DECIMAL(21,2),
		ConPagVenInt	DECIMAL(21,2),

		CartVencida		DECIMAL(21,2),
		VenPrincipal	DECIMAL(21,2),
		VenInteres		DECIMAL(21,2));

	INSERT INTO TMPREG411SOFIPO
		SELECT
			ClasifRegID,	Concepto, 		ClaveConcepto, 	Descripcion, 	 ClaveConceptoCap,
	        Decimal_Cero,	Decimal_Cero,	Decimal_Cero,	Decimal_Cero,	Decimal_Cero,
	        Decimal_Cero,	Decimal_Cero,	Decimal_Cero,	Decimal_Cero,	Decimal_Cero,
	        Decimal_Cero,	Decimal_Cero,	Decimal_Cero
		FROM CONCEPTOSREGREP
			WHERE ReporteID   = Var_ReporteID
        		AND Version = Version2017;

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
	CREATE TEMPORARY TABLE TMPCARTERAMES411 (

		ClaveConcepto     			VARCHAR(12),
		Descripcion       			VARCHAR(50),
		SalCapVigente     			DECIMAL(21,2),
		SalCapAtrasado				DECIMAL(21,2),
		SalCapVencido 				DECIMAL(21,2),

		SalCapVenNoExi 				DECIMAL(21,2),
		SalIntOrdinario	 			DECIMAL(21,2),
		SalIntAtrasado 				DECIMAL(21,2),
		SalIntVencido 				DECIMAL(21,2),
		SalIntProvision 			DECIMAL(21,2),

        SalIntNoConta				DECIMAL(21,2),
		SalMoratorios				DECIMAL(21,2),
		IntMes						DECIMAL(21,2),
		IntMesAtr					DECIMAL(21,2),
		IntMesVen					DECIMAL(21,2),

		SalComFaltaPago				DECIMAL(21,2),
		SalOtrasComisi				DECIMAL(21,2),
		PagoCapVenDia				DECIMAL(21,2),
		PagoIntVenDia				DECIMAL(21,2),
		SaldoMoraVencido			DECIMAL(21,2),

		DestinoCreID 				INT(11),
		CreditoID					BIGINT(11),
        ClasifRegID 				INT(11),
		DiasAtraso					INT(11),
		EstatusCredito				CHAR(1),

		SaldoMoraCarVen				DECIMAL(14,2),
        ComAperPagado				DECIMAL(14,2));


	INSERT INTO TMPCARTERAMES411
		SELECT
			Cadena_Vacia,     				Cadena_Vacia,						Sal.SalCapVigente,					Sal.SalCapAtrasado,				Sal.SalCapVencido,
			Sal.SalCapVenNoExi,				Sal.SalIntOrdinario,				Sal.SalIntAtrasado,					Sal.SalIntVencido,				Sal.SalIntProvision,
            Sal.SalIntNoConta,				Sal.SalMoratorios,					Decimal_Cero AS IntMes,				Decimal_Cero AS IntMesAtr,		Decimal_Cero AS IntMesVen,
            Sal.SalComFaltaPago,			Sal.SalOtrasComisi,					Sal.PagoCapVenDia,					Sal.PagoIntVenDia,				Sal.SaldoMoraVencido,
            Sal.DestinoCreID, 				Sal.CreditoID,						Entero_Cero AS ClasifRegID,	 		Cal.DiasAtraso,					Sal.EstatusCredito,
            Sal.SaldoMoraCarVen,			Cre.ComAperPagado
		FROM	SALDOSCREDITOS Sal,	CALRESCREDITOS Cal, CREDITOS Cre
			WHERE 	Sal.FechaCorte	= Par_Fecha
				AND Sal.FechaCorte  = Cal.Fecha
				AND Sal.CreditoID	=Cal.CreditoID
				AND Sal.CreditoID	=Cre.CreditoID
				AND (EstatusCredito	= EstatusVigente OR EstatusCredito = EstatusVencido );
	CREATE INDEX id_CreditoID ON TMPCARTERAMES411 (CreditoID);


	UPDATE	TMPCARTERAMES411	Car
		INNER JOIN	DESTINOSCREDITO	Des	ON Car.DestinoCreID	= Des.DestinoCreID
			SET Car.ClasifRegID	= Des.ClasifRegID;

	UPDATE	TMPCARTERAMES411 Car,
		TMPREG411SOFIPO	Cat	SET
			Car.ClaveConcepto	=	Cat.Concepto,
			Car.Descripcion		=	Cat.Descripcion
	WHERE	Car.ClasifRegID	= Cat.ClasifRegID;


	DROP TABLE IF EXISTS TMP411SALDOSCREDITO;
	CREATE TABLE IF NOT EXISTS TMP411SALDOSCREDITO(
		SaldoCapital		DECIMAL(21,2),
		SaldoInteres		DECIMAL(21,2),
		InteresMes			DECIMAL(21,2),
		ComisionMes			DECIMAL(21,2),
		ClasifRegID     	DECIMAL(21,2));

	CREATE INDEX id_indexClasifRegID ON TMP411SALDOSCREDITO (ClasifRegID);

	-- Creditos Vivienda  Media Residencial
	UPDATE TMPCARTERAMES411 Tem, CREGARPRENHIPO Hip SET
		Tem.ClasifRegID = CASE Tem.ClasifRegID WHEN Concepto1127  THEN ClasificaVivienda
											   WHEN Concepto1128  THEN ClasificaVivMed
                                               END
	WHERE Tem.CreditoID = Hip.CreditoID
		AND Hip.GarHipotecaria > Entero_Cero
        AND Tem.ClasifRegID IN (Concepto1127,Concepto1128);


    -- Actualizar Creditos tipo Quirografarios, Prendarios, Puente y Comerciales
    -- Se actualiza tambien los creditos a la vivienda sin garantia hipotecaria
    UPDATE TMPCARTERAMES411 tem
	SET tem.ClasifRegID =  CASE tem.ClasifRegID WHEN Concepto41103 THEN Concepto0302
												WHEN Concepto1104 THEN Concepto110403
												WHEN Concepto1105 THEN Concepto110402
												WHEN ConceptoReg411 THEN ConceptoReg08
                                                WHEN Concepto1127 THEN Concepto11270201
                                                WHEN Concepto1128 THEN Concepto11280201
							END
	WHERE tem.ClasifRegID IN (Concepto41103, Concepto1104, Concepto1105,ConceptoReg411, Concepto1127, Concepto1128);

	-- cartera vigente sin dias de atraso
	DELETE FROM TMP411SALDOSCREDITO;

	INSERT INTO TMP411SALDOSCREDITO
	SELECT	SUM(Car.SalCapVigente)+SUM(Car.SalCapAtrasado) AS	SaldoCapital ,
			SUM(Car.SalIntOrdinario)  +  SUM(Car.SalIntProvision) +SUM(Car.SalIntAtrasado)	 AS SaldoInteres,
			SUM(Car.IntMes)	AS	InteresMes,
			SUM(Car.ComAperPagado)  AS ComisionMes,
			Tmp.ClasifRegID
	FROM	TMPCARTERAMES411 Car ,	TMPREG411SOFIPO Tmp
		WHERE  Car.ClasifRegID =Tmp.ClasifRegID
			AND	DiasAtraso = Entero_Cero
			GROUP BY Tmp.ClasifRegID;


	UPDATE TMPREG411SOFIPO Tmp,TMP411SALDOSCREDITO	Sal	SET
		Tmp.CredSinPagVen 	= CASE WHEN Var_AjustaSaldo = Var_SI THEN (ROUND(Sal.SaldoCapital,0) + ROUND(Sal.SaldoInteres,0)) ELSE  (Sal.SaldoCapital + Sal.SaldoInteres ) END ,
		Tmp.SinPagVenPrin 	=  CASE WHEN Var_AjustaSaldo = Var_SI THEN ROUND(Sal.SaldoCapital,0) ELSE Sal.SaldoCapital END,
		Tmp.SinPagVenInt	=  CASE WHEN Var_AjustaSaldo = Var_SI THEN ROUND(Sal.SaldoInteres,0) ELSE Sal.SaldoInteres END
	WHERE Tmp.ClasifRegID 	= Sal.ClasifRegID;

	UPDATE TMPREG411SOFIPO Tmp,TMP411SALDOSCREDITO	Sal	SET
		Tmp.CredSinPagVen 	= CASE WHEN Var_AjustaSaldo = Var_SI then (ROUND(Sal.SaldoCapital,0) + ROUND(Sal.SaldoInteres,0)) ELSE  (Sal.SaldoCapital + Sal.SaldoInteres ) END ,
		Tmp.SinPagVenPrin 	=  CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoCapital,0) ELSE Sal.SaldoCapital END,
		Tmp.SinPagVenInt	=  CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoInteres,0) ELSE Sal.SaldoInteres END
	WHERE Tmp.ClasifRegID 	= ConceptoReg08
		AND  Sal.ClasifRegID 	= ConceptoReg411;

	-- cartera vigente con dias de atraso
	DELETE FROM TMP411SALDOSCREDITO;

	INSERT INTO TMP411SALDOSCREDITO
		SELECT	SUM(Car.SalCapVigente)+SUM(Car.SalCapAtrasado) AS	SaldoCapital ,
				SUM(Car.SalIntOrdinario)  +  SUM(Car.SalIntProvision) +SUM(Car.SalIntAtrasado)	 AS SaldoInteres,
				SUM(Car.IntMesAtr)	AS	InteresMes,
				SUM(Car.ComAperPagado)  AS ComisionMes,
				Tmp.ClasifRegID
		FROM	TMPCARTERAMES411 Car,	TMPREG411SOFIPO Tmp
	 		WHERE Car.ClasifRegID=Tmp.ClasifRegID
				AND	DiasAtraso > Entero_Cero
				AND EstatusCredito = EstatusVigente
				GROUP BY Tmp.ClasifRegID;

	UPDATE TMPREG411SOFIPO Tmp,TMP411SALDOSCREDITO	Sal	SET
		Tmp.CredConPagVen 	= CASE WHEN Var_AjustaSaldo = Var_SI then (ROUND(Sal.SaldoCapital,0) + ROUND(Sal.SaldoInteres,0)) ELSE  (Sal.SaldoCapital + Sal.SaldoInteres ) END ,
		Tmp.ConPagVenPrin 	=  CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoCapital,0) ELSE Sal.SaldoCapital END,
		Tmp.ConPagVenInt	=  CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoInteres,0) ELSE Sal.SaldoInteres END
	WHERE Tmp.ClasifRegID = Sal.ClasifRegID;

	UPDATE TMPREG411SOFIPO Tmp,TMP411SALDOSCREDITO	Sal	SET
		Tmp.CredConPagVen = CASE WHEN Var_AjustaSaldo = Var_SI then (ROUND(Sal.SaldoCapital,0) + ROUND(Sal.SaldoInteres,0)) ELSE  (Sal.SaldoCapital + Sal.SaldoInteres ) END ,
		Tmp.ConPagVenPrin = CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoCapital,0) ELSE Sal.SaldoCapital END,
		Tmp.ConPagVenInt =  CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoInteres,0) ELSE Sal.SaldoInteres END
	WHERE Tmp.ClasifRegID = ConceptoReg08
		AND  Sal.ClasifRegID = ConceptoReg411;

	-- cartera vencida
	DELETE FROM TMP411SALDOSCREDITO;

	INSERT INTO TMP411SALDOSCREDITO
		SELECT	SUM(Car.SalCapVencido) + SUM(Car.SalCapVenNoExi)	AS	SaldoCapital ,
				SUM(SaldoMoraVencido) +	SUM(SalIntVencido) AS	SaldoInteres,
				SUM(Car.SalIntOrdinario)  +  SUM(Car.SalIntProvision) +SUM(Car.SalIntAtrasado)
	            +SUM(Car.IntMesVen)	AS	InteresMes,
				SUM(Car.ComAperPagado)  AS ComisionMes,
				Tmp.ClasifRegID
		FROM	TMPCARTERAMES411 Car,	TMPREG411SOFIPO Tmp
            WHERE Car.ClasifRegID=Tmp.ClasifRegID
	            AND EstatusCredito = EstatusVencido
				GROUP BY Car.ClasifRegID;


	UPDATE TMPREG411SOFIPO Tmp,TMP411SALDOSCREDITO	Sal	SET
		Tmp.CartVencida = CASE WHEN Var_AjustaSaldo = Var_SI then (ROUND(Sal.SaldoCapital,0) + ROUND(Sal.SaldoInteres,0)) ELSE  (Sal.SaldoCapital + Sal.SaldoInteres ) END ,
		Tmp.VenPrincipal = CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoCapital,0) ELSE Sal.SaldoCapital END,
		Tmp.VenInteres = CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoInteres,0) ELSE Sal.SaldoInteres END
	WHERE Tmp.ClasifRegID = Sal.ClasifRegID;

	UPDATE TMPREG411SOFIPO Tmp,TMP411SALDOSCREDITO	Sal	SET
		Tmp.CartVencida = CASE WHEN Var_AjustaSaldo = Var_SI then (ROUND(Sal.SaldoCapital,0) + ROUND(Sal.SaldoInteres,0)) ELSE  (Sal.SaldoCapital + Sal.SaldoInteres ) END ,
		Tmp.VenPrincipal = CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoCapital,0) ELSE Sal.SaldoCapital END,
		Tmp.VenInteres = CASE WHEN Var_AjustaSaldo = Var_SI then ROUND(Sal.SaldoInteres,0) ELSE Sal.SaldoInteres END
	WHERE Tmp.ClasifRegID = ConceptoReg08
		AND  Sal.ClasifRegID = ConceptoReg411;

	UPDATE TMPREG411SOFIPO Tmp	SET
		Tmp.CredSinPagVen = Entero_Cero,
		Tmp.SinPagVenPrin = Entero_Cero,
		Tmp.SinPagVenInt  = Entero_Cero,
		Tmp.CredConPagVen =	Entero_Cero,
		Tmp.ConPagVenPrin =	Entero_Cero,
		Tmp.ConPagVenInt  = Entero_Cero,
		Tmp.CartVencida   = Entero_Cero,
		Tmp.VenPrincipal  = Entero_Cero,
		Tmp.VenInteres    = Entero_Cero
	WHERE Tmp.ClasifRegID = ConceptoReg411;

    DROP TABLE IF EXISTS tmpCatReg;
    	CREATE TEMPORARY TABLE tmpCatReg
    SELECT ClasifRegID,Concepto,ClaveConcepto FROM TMPREG411SOFIPO;

	DROP TABLE IF EXISTS TMPSUMATORIAS;
    	CREATE TEMPORARY TABLE TMPSUMATORIAS
			SELECT 	tmp.ClasifRegID,						SUM(sof.CredSinPagVen) AS VigenteTotal, 	SUM(SinPagVenPrin) AS VigentePrincipal,
					SUM(SinPagVenInt) AS VigenteInteres,	SUM(CredConPagVen) AS AtrasadoTotal, 		SUM(ConPagVenPrin) AS AtrasadoPrincipal,
					SUM(ConPagVenInt) AS AtrasadoInteres, 	SUM(CartVencida) AS VencidaTotal , 			SUM(VenPrincipal) AS VencidaPrincipal,
					SUM(VenInteres) AS VencidaInteres
			FROM tmpCatReg tmp, TMPREG411SOFIPO sof
				WHERE sof.ClaveConcepto LIKE CONCAT(tmp.Concepto,'%')
    				AND tmp.ClasifRegID <> Entero_Cero
					GROUP BY tmp.ClasifRegID;

	-- Actualizar Montos - Sumatoria
	UPDATE TMPREG411SOFIPO reg,TMPSUMATORIAS tmp SET
		reg.CredSinPagVen	= tmp.VigenteTotal,
		reg.SinPagVenPrin	= tmp.VigentePrincipal,
		reg.SinPagVenInt 	= tmp.VigenteInteres,
		reg.CredConPagVen	= tmp.AtrasadoTotal,
		reg.ConPagVenPrin 	= tmp.AtrasadoPrincipal,
		reg.ConPagVenInt 	= tmp.AtrasadoInteres,
		reg.CartVencida 	= tmp.VencidaTotal,
		reg.VenPrincipal 	= tmp.VencidaPrincipal,
		reg.VenInteres 		= tmp.VencidaInteres
	WHERE reg.ClasifRegID 	= tmp.ClasifRegID;

	-- Actualizar Total de Cartera
	UPDATE TMPREG411SOFIPO SET
    	ClasifConta		= REPLACE(ClasifConta,' ',Cadena_Vacia),
		CarTotal		= (CredSinPagVen+CredConPagVen+CartVencida),
		ToTalVigente 	= (CredSinPagVen+CredConPagVen),
		PrincipalVigen 	= (SinPagVenPrin+ConPagVenPrin),
		InteresesVigen 	= (SinPagVenInt+ConPagVenInt);

    IF(Var_AjustaSaldo = Var_SI AND
    	EXISTS(
    		SELECT Monto FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = YEAR(Par_Fecha) AND
					  Mes  = MONTH(Par_Fecha)
    		)
    	) THEN

        SET Var_Redondeo 	:= Entero_Cero;
		UPDATE TMPREG411SOFIPO SET
			CarTotal		= ROUND(IFNULL(CarTotal,Entero_Cero),Var_Redondeo),
			ToTalVigente	= ROUND(IFNULL(ToTalVigente,Entero_Cero),Var_Redondeo),
			PrincipalVigen	= ROUND(IFNULL(PrincipalVigen,Entero_Cero),Var_Redondeo),
			InteresesVigen	= ROUND(IFNULL(InteresesVigen,Entero_Cero),Var_Redondeo),
			CredSinPagVen	= ROUND(IFNULL(CredSinPagVen,Entero_Cero),Var_Redondeo),
			SinPagVenPrin	= ROUND(IFNULL(SinPagVenPrin,Entero_Cero),Var_Redondeo),
			SinPagVenInt	= ROUND(IFNULL(SinPagVenInt,Entero_Cero),Var_Redondeo),
			CredConPagVen	= ROUND(IFNULL(CredConPagVen,Entero_Cero),Var_Redondeo),
			ConPagVenPrin	= ROUND(IFNULL(ConPagVenPrin,Entero_Cero),Var_Redondeo),
			ConPagVenInt	= ROUND(IFNULL(ConPagVenInt,Entero_Cero),Var_Redondeo),
			CartVencida		= ROUND(IFNULL(CartVencida,Entero_Cero),Var_Redondeo),
			VenPrincipal	= ROUND(IFNULL(VenPrincipal,Entero_Cero),Var_Redondeo),
			VenInteres		= ROUND(IFNULL(VenInteres,Entero_Cero),Var_Redondeo);

        DROP TABLE IF EXISTS TMPCONCEPTOSREGA0411;
		CREATE TEMPORARY TABLE TMPCONCEPTOSREGA0411
			SELECT REPLACE(ClaveConceptoCap,' ','')  AS ClaveConceptoCap FROM CONCEPTOSREGREP
				WHERE ReporteID = Var_ReporteID AND
					  Version 	= Version2017;

		CREATE INDEX INDEX_TMPCONCEPTOSREGA0411 ON TMPCONCEPTOSREGA0411(ClaveConceptoCap);

        DROP TABLE IF EXISTS TMPCATALOGOMINIMO;
		CREATE TEMPORARY TABLE TMPCATALOGOMINIMO
			SELECT ConceptoFinanID, CuentaContable, Monto, MonedaExt,
            Entero_Cero AS ToTalVigente,	Entero_Cero AS PrincipalVigen,  Entero_Cero AS InteresesVigen,
            Entero_Cero AS CredSinPagVen,	Entero_Cero AS SinPagVenPrin, 	Entero_Cero AS SinPagVenInt,
            Entero_Cero AS CartVencida,		Entero_Cero AS CartVenPrincipal
				FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = YEAR(Par_Fecha) AND
					  Mes  = MONTH(Par_Fecha) AND
					  CuentaContable IN (SELECT ClaveConceptoCap FROM TMPCONCEPTOSREGA0411 );

		CREATE INDEX INDEX_TMPCATALOGOMINIMO_1 ON TMPCATALOGOMINIMO(ConceptoFinanID);
        CREATE INDEX INDEX_TMPCATALOGOMINIMO_2 ON TMPCATALOGOMINIMO(CuentaContable);

        -- SE ACTUALIZA LAS DIREFENCIAS PARA EL TOTAL VIGENTES
        UPDATE TMPCATALOGOMINIMO Cat, TMPREG411SOFIPO Tmp SET
			Cat.ToTalVigente 	 = Tmp.ToTalVigente,
			Cat.InteresesVigen 	 = Tmp.ToTalVigente - (Tmp.PrincipalVigen + Tmp.InteresesVigen)
		WHERE Cat.CuentaContable = Tmp.ClasifConta;

        UPDATE TMPCATALOGOMINIMO Cat SET
			Cat.PrincipalVigen = Cat.Monto - Cat.ToTalVigente;

        UPDATE TMPREG411SOFIPO Tmp, TMPCATALOGOMINIMO Cat SET
			Tmp.ToTalVigente 	 = Tmp.ToTalVigente + Cat.PrincipalVigen,
			Tmp.PrincipalVigen 	 = Tmp.PrincipalVigen + Cat.InteresesVigen + Cat.PrincipalVigen
		WHERE Cat.CuentaContable = Tmp.ClasifConta;

        UPDATE TMPREG411SOFIPO Tmp, TMPCATALOGOMINIMO Cat SET
            Cat.PrincipalVigen 	 = Tmp.PrincipalVigen,
            Cat.InteresesVigen   = Tmp.InteresesVigen
		WHERE Cat.CuentaContable = Tmp.ClasifConta;

        -- SE ACTUALIZA LAS DIREFENCIAS PARA EL TOTAL VIGENTES
        UPDATE TMPREG411SOFIPO Tmp, TMPCATALOGOMINIMO Cat SET
            Cat.CredSinPagVen 	 = Cat.Monto - (Tmp.CredSinPagVen + Tmp.CredConPagVen),
            Cat.SinPagVenPrin 	 = Cat.PrincipalVigen - (Tmp.SinPagVenPrin + Tmp.ConPagVenPrin),
            Cat.SinPagVenInt 	 = Cat.InteresesVigen - (Tmp.SinPagVenInt + Tmp.ConPagVenInt)
		WHERE Cat.CuentaContable = Tmp.ClasifConta;

        UPDATE TMPREG411SOFIPO Tmp, TMPCATALOGOMINIMO Cat SET
			Tmp.CredSinPagVen 	 = Tmp.CredSinPagVen + Cat.CredSinPagVen,
			Tmp.SinPagVenPrin 	 = Tmp.SinPagVenPrin + Cat.SinPagVenPrin,
			Tmp.SinPagVenInt 	 = Tmp.SinPagVenInt + Cat.SinPagVenInt
		WHERE Cat.CuentaContable = Tmp.ClasifConta;

		-- SECCION CARTERA VENCIDA
        DROP TABLE IF EXISTS TMPCATMINREGULA;
        CREATE TEMPORARY TABLE TMPCATMINREGULA(
			CuentaFija	 	VARCHAR(25),
			CuentaContable	VARCHAR(25),
			SaldoCatMin 	DECIMAL(16,2),
			CartVencida  	DECIMAL(16,2),
			VenPrincipal  	DECIMAL(16,2),
			VenInteres  	DECIMAL(16,2),
			Diferencia  	DECIMAL(16,2),
            SaldoCatMinVig 	DECIMAL(16,2),
            SaldoCarVig 	DECIMAL(16,2),
            DiferVigente	DECIMAL(16,2));

		CREATE INDEX INDEX_TMPCATMINREGULA1 on TMPCATMINREGULA(CuentaFija);
		CREATE INDEX INDEX_TMPCATMINREGULA2 on TMPCATMINREGULA(CuentaContable);

		-- Se realiza el mapeo de las cuentas de la cartera vencida contra las cuentas del regulatorio
		INSERT INTO TMPCATMINREGULA VALUES
			(130000000000, 135000000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130100000000, 135100000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105000000, 135105000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105010000, 135105010000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105010100, 135105010100, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105019000, 135105019000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105020000, 135105020000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105020100, 135105020100, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105020200, 135105020102, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105029000, 135105029000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105030000, 135105030000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105030100, 135105030100, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105030200, 135105030200, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105040000, 135105040000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105050000, 135105050000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105070000, 135105070000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130105060000, 135105060000, 0, 0, 0, 0, 0, 0, 0, 0),
			(130122000000, 135122000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131100000000, 136100000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131101000000, 136101000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131103000000, 136103000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131113000000, 136113000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131105000000, 136105000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131106000000, 136106000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131104000000, 136104000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131190000000, 136119000000, 0, 0, 0, 0, 0, 0, 0, 0),

			(131600000000, 136600000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131601000000, 136601000000, 0, 0, 0, 0, 0, 0, 0, 0),
			(131602000000, 136602000000, 0, 0, 0, 0, 0, 0, 0, 0);

        DROP TABLE IF EXISTS TMPCATALOGOMINIMOAUX;
		CREATE TEMPORARY TABLE TMPCATALOGOMINIMOAUX
			SELECT * FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = YEAR(Par_Fecha) AND
					  Mes  = MONTH(Par_Fecha) AND
                      CuentaContable LIKE '135%';

		INSERT INTO TMPCATALOGOMINIMOAUX
			SELECT * FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = YEAR(Par_Fecha) AND
					  Mes  = MONTH(Par_Fecha) AND
                      CuentaContable LIKE '136%';

        SELECT SUM(IFNULL(SaldoCatMin,Entero_Cero)) INTO Var_Saldo
			FROM TMPCATMINREGULA WHERE CuentaContable IN('130100000000','136100000000');

        UPDATE TMPCATMINREGULA Cat SET
			Cat.SaldoCatMin = Var_Saldo
			WHERE Cat.CuentaContable = '135000000000';

        UPDATE TMPCATMINREGULA Cat, TMPCATALOGOMINIMOAUX Tmp SET
			Cat.SaldoCatMin = Tmp.Monto
			WHERE Cat.CuentaContable = Tmp.CuentaContable;

		 DROP TABLE IF EXISTS TMPCATALOGOMINIMOAUX;
		CREATE TEMPORARY TABLE TMPCATALOGOMINIMOAUX
			SELECT * FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = YEAR(Par_Fecha) AND
					  Mes  = MONTH(Par_Fecha) AND
                      CuentaContable LIKE '1301%';

        INSERT INTO TMPCATALOGOMINIMOAUX
			SELECT * FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = YEAR(Par_Fecha) AND
					  Mes  = MONTH(Par_Fecha) AND
                      CuentaContable LIKE '1311%';

        INSERT INTO TMPCATALOGOMINIMOAUX
			SELECT * FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = YEAR(Par_Fecha) AND
					  Mes  = MONTH(Par_Fecha) AND
                      CuentaContable LIKE '1316%';

        UPDATE TMPCATMINREGULA Cat, TMPCATALOGOMINIMOAUX Tmp SET
			Cat.SaldoCatMinVig = Tmp.Monto
			WHERE Cat.CuentaFija = Tmp.CuentaContable;

        SET @VivMediaVigCatMin :=( SELECT SUM(Monto) FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = YEAR(Par_Fecha) AND
					  Mes  = MONTH(Par_Fecha) AND
                      CuentaContable in ('131601000000','136601000000'));

        SET @VivMediaVigRegu :=(SELECT SUM(ConPagVenInt + ConPagVenPrin + SinPagVenInt + SinPagVenPrin) FROM TMPREG411SOFIPO
								WHERE ClasifConta = '131601020200');


        SET @ViviInteresVigCatMin :=( SELECT SUM(Monto) FROM `HIS-CATALOGOMINIMO`
				WHERE Anio = YEAR(Par_Fecha) AND
					  Mes  = MONTH(Par_Fecha) AND
                      CuentaContable in ('131602000000','136602000000'));

		SET @VivInteresVigRegu :=(SELECT SUM(ConPagVenInt + ConPagVenPrin + SinPagVenInt + SinPagVenPrin) FROM TMPREG411SOFIPO
								WHERE ClasifConta = '131602020200');



		UPDATE TMPCATMINREGULA Cat, TMPREG411SOFIPO Tmp SET
			Cat.CartVencida  = Tmp.VenPrincipal + Tmp.VenInteres,
			Cat.VenPrincipal = Tmp.VenPrincipal,
			Cat.VenInteres   = Tmp.VenInteres,
            Cat.SaldoCarVig  = Tmp.ConPagVenInt + Tmp.ConPagVenPrin + Tmp.SinPagVenInt + Tmp.SinPagVenPrin
			WHERE Cat.CuentaFija = Tmp.ClasifConta;

		UPDATE TMPCATMINREGULA SET Diferencia = SaldoCatMin - CartVencida;
		UPDATE TMPCATMINREGULA SET DiferVigente = SaldoCatMinVig - SaldoCarVig;
		UPDATE TMPCATMINREGULA SET VenPrincipal = VenPrincipal + Diferencia;

        UPDATE TMPREG411SOFIPO Tmp, TMPCATMINREGULA Cat SET
			Tmp.CartVencida  = Cat.SaldoCatMin,
			Tmp.VenPrincipal = Cat.VenPrincipal,
			Tmp.VenInteres   = Cat.VenInteres,
            Tmp.SinPagVenPrin = Tmp.SinPagVenPrin + Cat.DiferVigente
			WHERE Tmp.ClasifConta = Cat.CuentaFija;

		UPDATE TMPREG411SOFIPO
			SET SinPagVenInt = SinPagVenInt + (@VivMediaVigCatMin - @VivMediaVigRegu)
			WHERE ClasifConta = '131601020200';

        UPDATE TMPREG411SOFIPO
			SET SinPagVenInt = SinPagVenInt + (@ViviInteresVigCatMin - @VivInteresVigRegu)
			WHERE ClasifConta = '131602020200';

        UPDATE TMPREG411SOFIPO SET
			CarTotal = ToTalVigente + CartVencida;
        DELETE FROM TMPREG411SOFIPO WHERE ClasifConta = Cadena_Vacia;

        UPDATE TMPREG411SOFIPO
        set  CarTotal	    = 0,
			ToTalVigente   	= 0,
			PrincipalVigen	= 0,
			InteresesVigen	= 0,
			CredSinPagVen	= 0,
			SinPagVenPrin	= 0,
			SinPagVenInt	= 0,
			CredConPagVen	= 0,
			ConPagVenPrin   = 0,
			ConPagVenInt	= 0,
			CartVencida	    = 0,
			VenPrincipal	= 0,
			VenInteres      = 0
		where  ClasifConta in (
				'130000000000','130100000000','130105000000','130105010000','130105020000','130105030000',
				'131100000000','131600000000','131601000000','131601010000','131601020000','131602000000',
				'131602010000','131602020000');


        UPDATE TMPREG411SOFIPO SET
			CartVencida		= ( VenPrincipal+ VenInteres),
			CredConPagVen 	= ( ConPagVenPrin+ ConPagVenInt),
			CredSinPagVen 	= ( SinPagVenPrin+SinPagVenInt);

		DROP TABLE IF EXISTS tmpCatReg;
    	CREATE TEMPORARY TABLE tmpCatReg
		SELECT ClasifRegID,Concepto,ClaveConcepto FROM TMPREG411SOFIPO;

		DROP TABLE IF EXISTS TMPSUMATORIAS;
			CREATE TEMPORARY TABLE TMPSUMATORIAS
				SELECT 	tmp.ClasifRegID,						SUM(sof.CredSinPagVen) AS VigenteTotal, 	SUM(SinPagVenPrin) AS VigentePrincipal,
						SUM(SinPagVenInt) AS VigenteInteres,	SUM(CredConPagVen) AS AtrasadoTotal, 		SUM(ConPagVenPrin) AS AtrasadoPrincipal,
						SUM(ConPagVenInt) AS AtrasadoInteres, 	SUM(CartVencida) AS VencidaTotal , 			SUM(VenPrincipal) AS VencidaPrincipal,
						SUM(VenInteres) AS VencidaInteres
				FROM tmpCatReg tmp, TMPREG411SOFIPO sof
					WHERE sof.ClaveConcepto LIKE CONCAT(tmp.Concepto,'%')
						AND tmp.ClasifRegID <> Entero_Cero
						GROUP BY tmp.ClasifRegID;


		UPDATE TMPREG411SOFIPO reg,TMPSUMATORIAS tmp SET
			reg.CredSinPagVen	= tmp.VigenteTotal,
			reg.SinPagVenPrin	= tmp.VigentePrincipal,
			reg.SinPagVenInt 	= tmp.VigenteInteres,
			reg.CredConPagVen	= tmp.AtrasadoTotal,
			reg.ConPagVenPrin 	= tmp.AtrasadoPrincipal,
			reg.ConPagVenInt 	= tmp.AtrasadoInteres,
			reg.CartVencida 	= tmp.VencidaTotal,
			reg.VenPrincipal 	= tmp.VencidaPrincipal,
			reg.VenInteres 		= tmp.VencidaInteres
		WHERE reg.ClasifRegID 	= tmp.ClasifRegID;


		UPDATE TMPREG411SOFIPO SET
			CarTotal		= (CredSinPagVen+CredConPagVen+CartVencida),
			ToTalVigente 	= (CredSinPagVen+CredConPagVen),
			PrincipalVigen 	= (SinPagVenPrin+ConPagVenPrin),
			InteresesVigen 	= (SinPagVenInt+ConPagVenInt);
    END IF;

	IF(Par_NumReporte = Rep_Excel2017)THEN
		SELECT 	ClasifConta AS ClaveConcepto, 	Descripcion, 	ClasifConta, 	CarTotal, 		ToTalVigente,
				PrincipalVigen, 				InteresesVigen, CredSinPagVen, 	SinPagVenPrin, 	SinPagVenInt,
				CredConPagVen, 					ConPagVenPrin, 	ConPagVenInt, 	CartVencida, 	VenPrincipal,
				VenInteres
		FROM TMPREG411SOFIPO;
	END IF;

	IF(Par_NumReporte = Rep_Csv2017)THEN

        DELETE FROM TMPREG411SOFIPO WHERE ClasifRegID = Entero_Cero;

       	DROP TABLE IF EXISTS TMP_CSV411;

        CREATE TEMPORARY TABLE TMP_CSV411(
			Valor VARCHAR(500)
        );

        INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia),';',IDRegulatorio411,';',Entero_Catorce,
						';',Valor_Uno	,';',Valor_Uno,';',	ROUND(IFNULL(CarTotal,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

        INSERT INTO TMP_CSV411
        	SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia),';',IDRegulatorio411,';',Entero_Catorce,
						';',Valor_Uno	,';',Valor_Dos,';',	ROUND(IFNULL(VenPrincipal+PrincipalVigen,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

		INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia),';',IDRegulatorio411,';',Entero_Catorce,
						';',Valor_Uno	,';',Valor_Tres,';',	ROUND(IFNULL(VenInteres+InteresesVigen,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

        INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                	';',Valor_Dos	,';',Valor_Uno,';',	ROUND(IFNULL(ToTalVigente,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

        INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Dos	,';',Valor_Dos,';',	ROUND(IFNULL(PrincipalVigen,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

		INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Dos	,';',Valor_Tres,';',	ROUND(IFNULL(InteresesVigen,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

        INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Tres	,';',Valor_Uno,';',	ROUND(IFNULL(CredSinPagVen,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

		INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Tres	,';',Valor_Dos,';',	ROUND(IFNULL(SinPagVenPrin,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

        INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Tres	,';',Valor_Tres,';',	ROUND(IFNULL(SinPagVenInt,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

        INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Cuatro	,';',Valor_Uno,';',	ROUND(IFNULL(CredConPagVen,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

		INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
				';',Valor_Cuatro	,';',Valor_Dos,';',	ROUND(IFNULL(ConPagVenPrin,Entero_Cero),Entero_Dos)) AS Valor
		FROM TMPREG411SOFIPO;

		INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Cuatro	,';',Valor_Tres,';',	ROUND(IFNULL(ConPagVenInt,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

       	INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Cinco	,';',Valor_Uno,';',	ROUND(IFNULL(CartVencida,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

        INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Cinco	,';',Valor_Dos,';',	ROUND(IFNULL(VenPrincipal,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

        INSERT INTO TMP_CSV411
			SELECT CONCAT(IFNULL(REPLACE(ClasifConta,' ',''),Cadena_Vacia) ,';',IDRegulatorio411,';',Entero_Catorce,
                ';',Valor_Cinco	,';',Valor_Tres,';',	ROUND(IFNULL(VenInteres,Entero_Cero),Entero_Dos)) AS Valor
			FROM TMPREG411SOFIPO;

		SELECT * FROM TMP_CSV411;

	END IF;

	DROP TEMPORARY TABLE IF EXISTS CarteraTipoCredito;

END TerminaStore$$