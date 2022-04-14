-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ANALITICOFONDEOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ANALITICOFONDEOREP`;

DELIMITER $$
CREATE PROCEDURE `ANALITICOFONDEOREP`(
	/*Reporte que genera el analitico de cartera de los creditos pasivos*/
	Par_Fecha			DATE,
	Par_InstitutFondID	INT(11),
	/*Parametros de Auditoria*/
	Aud_Empresa			INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TERMINASTORE: BEGIN

	-- Declaracion de Variables
	DECLARE FechaSist					DATE;
	DECLARE Var_Sentencia				VARCHAR(9000);
	DECLARE Var_ManejaCarteraAgro		CHAR(1);

	-- Declaracion de Constantes
	DECLARE Entero_Cero INT;
	DECLARE Cadena_Vacia VARCHAR(5);
	DECLARE MonedaPesos			INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero := 0;		-- Entero en Cero
	SET Cadena_Vacia := '';
	SET MonedaPesos := 1;

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
	TRUNCATE TMPANALITICOCARTFOND;
    IF(Par_Fecha < FechaSist) THEN
		SET Var_Sentencia ='INSERT INTO TMPANALITICOCARTFOND(
				HoraEmision,				CreditoFondeoID,		InstitutFondID,
				NombreInstitFon,			LineaFondeoID,			DescripLinea,
				MonedaID,					EstatusCredito,			MontoCredito,
				NumAmortizacion,			SaldoCapVigente,		SaldoCapAtrasad,
				SaldoInteresPro,			SaldoInteresAtra,		SaldoMoratorios,
				SaldoComFaltaPa,			SaldoOtrasComis,		SalIVAInteres,
				SalIVAMoratorios,			SalIVAComFalPago,		SalIVAComisi,
				SalRetencion,				PasoCapAtraDia,			PasoIntAtraDia,
				IntOrdDevengado,			IntMorDevengado,		ComisiDevengado,
				PagoCapVigDia,				PagoCapAtrDia,			PagoIntOrdDia,
				PagoIntAtrDia,				PagoComisiDia,			PagoMoratorios,
				PagoIvaDia,					ISRDelDia,				DiasAtraso)
			SELECT
			time(now()) as HoraEmision,	SAL.CreditoFondeoID,				SAL.InstitutFondID,
			FON.NombreInstitFon,		CRED.LineaFondeoID,					LIN.DescripLinea,
			SAL.MonedaID,				CASE when SAL.EstatusCredito="N" then "VIGENTE"
										when SAL.EstatusCredito="P" then "PAGADO"
										END as EstatusCredito,				CRED.Monto,
			CRED.NumAmortizacion,		SAL.SaldoCapVigente,	SAL.SaldoCapAtrasad,
			SAL.SaldoInteresPro,		SAL.SaldoInteresAtra,	SAL.SaldoMoratorios,
			SAL.SaldoComFaltaPa,		SAL.SaldoOtrasComis,	SAL.SalIVAInteres,
			SAL.SalIVAMoratorios,		SAL.SalIVAComFalPago,	SAL.SalIVAComisi,
			SAL.SalRetencion,			0,						0,
			0,							0,						0,
			0,							0,						0,
			0,							0,						0,
			0,							0,						SAL.DiasAtraso
			FROM CREDITOFONDEO  AS CRED
			INNER JOIN SALDOSCREDPASIVOS AS SAL ON CRED.CreditoFondeoID = SAL.CreditoFondeoID
			INNER JOIN INSTITUTFONDEO AS FON ON SAL.InstitutFondID = FON.InstitutFondID
            INNER JOIN LINEAFONDEADOR AS LIN  ON SAL.InstitutFondID = FON.InstitutFondID AND SAL.LineaFondeoID = LIN.LineaFondeoID';


		IF(Par_InstitutFondID != Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE FON.InstitutFondID = ',Par_InstitutFondID);
		END IF;


		IF(Par_InstitutFondID>Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND ');
		ELSE
			SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,' SAL.FechaCorte = "',Par_Fecha,'";');
		SET @Sentencia  = (Var_Sentencia);
		PREPARE STMANALITICOFONDEOREP FROM @Sentencia;
		EXECUTE STMANALITICOFONDEOREP;
		DEALLOCATE PREPARE STMANALITICOFONDEOREP;
    ELSE

		SET Var_Sentencia ='INSERT INTO TMPANALITICOCARTFOND(
				HoraEmision,				CreditoFondeoID,		InstitutFondID,
				NombreInstitFon,			LineaFondeoID,			DescripLinea,
				MonedaID,					EstatusCredito,			MontoCredito,
				NumAmortizacion,			SaldoCapVigente,		SaldoCapAtrasad,
				SaldoInteresPro,			SaldoInteresAtra,		SaldoMoratorios,
				SaldoComFaltaPa,			SaldoOtrasComis,		SalIVAInteres,
				SalIVAMoratorios,			SalIVAComFalPago,		SalIVAComisi,
				SalRetencion,				PasoCapAtraDia,			PasoIntAtraDia,
				IntOrdDevengado,			IntMorDevengado,		ComisiDevengado,
				PagoCapVigDia,				PagoCapAtrDia,			PagoIntOrdDia,
				PagoIntAtrDia,				PagoComisiDia,			PagoMoratorios,
				PagoIvaDia,					ISRDelDia,				DiasAtraso,
				TasaFija)
		  SELECT
			time(now()) as HoraEmision,		SAL.CreditoFondeoID,	SAL.InstitutFondID,
			FON.NombreInstitFon,			SAL.LineaFondeoID,		LIN.DescripLinea,
			SAL.MonedaID,					CASE when SAL.Estatus="N" then "VIGENTE"
												when SAL.Estatus="P" then "PAGADO"
											END as EstatusCredito,	SAL.Monto,
			SAL.NumAmortizacion,			SAL.SaldoCapVigente,	SAL.SaldoCapAtrasad,
			SAL.SaldoInteresPro,			SAL.SaldoInteresAtra,	SAL.SaldoMoratorios,
			SAL.SaldoComFaltaPa,		SAL.SaldoOtrasComis,		SAL.SaldoIVAInteres,
			SAL.SaldoIVAMora,			SAL.SaldoIVAComFalP,		SAL.SaldoIVAComisi,
			SAL.SaldoRetencion,			0,							0,
			0,							0,							0,
			0,							0,							0,
			0,							0,							0,
			0,							0,							0,
			SAL.TasaFija
			FROM CREDITOFONDEO AS SAL
            INNER JOIN INSTITUTFONDEO AS FON
            ON SAL.InstitutFondID = FON.InstitutFondID
            INNER JOIN LINEAFONDEADOR AS LIN  ON SAL.InstitutFondID = FON.InstitutFondID
												AND SAL.LineaFondeoID = LIN.LineaFondeoID
			WHERE SAL.Estatus!="P" ';

		IF(Par_InstitutFondID != Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND FON.InstitutFondID = ',Par_InstitutFondID,' ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,' ;');
		SET @Sentencia  = (Var_Sentencia);
		PREPARE STMANALITICOFONDEOREP FROM @Sentencia;
		EXECUTE STMANALITICOFONDEOREP;
		DEALLOCATE PREPARE STMANALITICOFONDEOREP;

  		DROP TABLE IF EXISTS TMPFECHAATRASOFONDEO;
		CREATE TEMPORARY TABLE `TMPFECHAATRASOFONDEO` (
		  `CreditoFondeoID` int(11) NOT NULL COMMENT 'ID del Credito',
		  `FechaCorte` date COMMENT 'Fecha de Corte',
		  PRIMARY KEY (CreditoFondeoID, FechaCorte),
		  KEY `IDX_TMPFECHAATRASOFONDEO_01` (`CreditoFondeoID`)
		) ENGINE=InnoDB DEFAULT CHARSET=latin1;

  		INSERT INTO TMPFECHAATRASOFONDEO
  		SELECT SAL.CreditoFondeoID, MAX(FechaCorte) AS FechaCorte
  		FROM SALDOSCREDPASIVOS AS SAL INNER JOIN TMPANALITICOCARTFOND AS TMP ON SAL.CreditoFondeoID = TMP.CreditoFondeoID
  		GROUP BY SAL.CreditoFondeoID;

		UPDATE TMPANALITICOCARTFOND AS TMP INNER JOIN TMPFECHAATRASOFONDEO AS FEC ON TMP.CreditoFondeoID = FEC.CreditoFondeoID
			INNER JOIN SALDOSCREDPASIVOS AS SAL ON FEC.CreditoFondeoID = SAL.CreditoFondeoID AND FEC.FechaCorte = SAL.FechaCorte SET
			TMP.DiasAtraso = SAL.DiasAtraso
			WHERE TMP.CreditoFondeoID = FEC.CreditoFondeoID;
    END IF;

	DROP TABLE IF EXISTS TMPANALITIVOMINCREDITO;
	CREATE TEMPORARY TABLE TMPANALITIVOMINCREDITO
	SELECT REL.CreditoFondeoID, MIN(REL.CreditoID) AS CreditoID
		FROM RELCREDPASIVOAGRO AS REL INNER JOIN TMPANALITICOCARTFOND AS TMP ON REL.CreditoFondeoID=TMP.CreditoFondeoID
		GROUP BY REL.CreditoFondeoID;


	UPDATE TMPANALITICOCARTFOND AS TMP
		INNER JOIN TMPANALITIVOMINCREDITO AS ANA ON TMP.CreditoFondeoID=ANA.CreditoFondeoID
		INNER JOIN CREDITOS AS CRED ON ANA.CreditoID = CRED.CreditoID SET
		TMP.ClienteID = CRED.ClienteID,
		TMP.CreditoID = ANA.CreditoID
		WHERE TMP.CreditoFondeoID = ANA.CreditoFondeoID;

	UPDATE TMPANALITICOCARTFOND AS TMP INNER JOIN CREDITOFONDEO AS CRED ON TMP.CreditoFondeoID = CRED.CreditoFondeoID SET
		TMP.FechaMinistrado = CRED.FechaInicio,
		TMP.FechaProxPag = FNFECHAPROXPAGPAS(TMP.CreditoFondeoID),
		TMP.FechaUltVenc = FNFECHAULTVENCPAS(TMP.CreditoFondeoID),
		TMP.MontoProx = FNEXIGIBLEPROXPAGPAS(TMP.CreditoFondeoID),
		TMP.TasaFija = CRED.TasaFija
		WHERE TMP.CreditoFondeoID = CRED.CreditoFondeoID;

	UPDATE TMPANALITICOCARTFOND AS TMP INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID SET
		TMP.NombreCompleto = CLI.NombreCompleto
	WHERE TMP.ClienteID = CLI.ClienteID;

	UPDATE TMPANALITICOCARTFOND AS TMP INNER JOIN (SELECT CreditoFondeoID,COUNT(*) AS NCreditos
													FROM RELCREDPASIVOAGRO AS RR GROUP BY RR.CreditoFondeoID) AS RELA
													ON TMP.CreditoFondeoID = RELA.CreditoFondeoID SET
		TMP.NumSocios = RELA.NCreditos
		WHERE TMP.CreditoFondeoID = RELA.CreditoFondeoID;
	SET Var_ManejaCarteraAgro :=(SELECT ManejaCarteraAgro FROM PARAMETROSSIS LIMIT 1);

	-- -------------------------------------------------------
	-- Tabla temporal con la informacion de la moneda.
	DROP TABLE IF EXISTS TMP_CREDITOMONEDA;
	CREATE TEMPORARY TABLE TMP_CREDITOMONEDA(
		CreditoFondeoID	BIGINT(20),
	    NumTransaccion BIGINT(20),
	    MonedaID INT(11),
	    DescMoneda VARCHAR(80),
	    FechaRegistro DATE,
	    TipCamDof DECIMAL(14,6),

	    INDEX(NumTransaccion),
	    INDEX(CreditoFondeoID),
	    INDEX(CreditoFondeoID, NumTransaccion)
	);


	INSERT INTO TMP_CREDITOMONEDA(
				CreditoFondeoID,		TipCamDof,			MonedaID,			DescMoneda,			FechaRegistro,
				NumTransaccion
		)
		SELECT 	CF.CreditoFondeoID, 	MON.TipCamDof,		CF.MonedaID,		MON.Descripcion,	MON.FechaRegistro,
				MON.NumTransaccion
			FROM TMPANALITICOCARTFOND FON
			INNER JOIN CREDITOFONDEO CF ON FON.CreditoFondeoID = CF.CreditoFondeoID
    			INNER JOIN MONEDAS MON ON CF.MonedaID = MON.MonedaID;

	INSERT INTO TMP_CREDITOMONEDA(
				CreditoFondeoID,		TipCamDof,			MonedaID,			DescMoneda,			FechaRegistro,
				NumTransaccion
		)
		SELECT 	CF.CreditoFondeoID,	 	Entero_Cero,		CF.MonedaID,		Cadena_Vacia,		HM.FechaRegistro,
				MAX(HM.NumTransaccion)
			FROM TMPANALITICOCARTFOND FON
			INNER JOIN CREDITOFONDEO CF ON FON.CreditoFondeoID = CF.CreditoFondeoID
			INNER JOIN `HIS-MONEDAS` HM ON CF.MonedaID = HM.MonedaID AND CF.FechaInicio = HM.FechaRegistro
			LEFT JOIN MONEDAS MON ON CF.MonedaID = MON.MonedaID AND CF.FechaInicio = MON.FechaRegistro
			WHERE MON.MonedaID IS NULL
			GROUP BY CF.CreditoFondeoID, CF.MonedaID, HM.FechaRegistro;

	UPDATE TMP_CREDITOMONEDA TMP
		INNER JOIN `HIS-MONEDAS` HIS ON HIS.MonedaID = TMP.MonedaID AND HIS.NumTransaccion = TMP.NumTransaccion
		SET TMP.DescMoneda = HIS.Descripcion, TMP.TipCamDof = HIS.TipCamDof;
	-- -------------------------------------------------------

	SELECT
		DISTINCT(TMP.CreditoFondeoID),
		TMP.HoraEmision,		TMP.CreditoID,				TMP.NombreCompleto,		TMP.FechaMinistrado,
		TMP.FechaProxPag,		TMP.MontoProx,				TMP.FechaUltVenc,		TMP.TasaFija,				TMP.InstitutFondID,
		TMP.NombreInstitFon,	TMP.LineaFondeoID,			TMP.DescripLinea,		TMP.MonedaID,				TMP.EstatusCredito,
		TMP.MontoCredito,		TMP.NumAmortizacion,		TMP.SaldoCapVigente,	TMP.SaldoCapAtrasad,		TMP.SaldoInteresPro,
		TMP.SaldoInteresAtra,	TMP.SaldoMoratorios,		TMP.SaldoComFaltaPa,	TMP.SaldoOtrasComis,		TMP.SalIVAInteres,
		TMP.SalIVAMoratorios,	TMP.SalIVAComFalPago,		TMP.SalIVAComisi,		TMP.SalRetencion,			TMP.PasoCapAtraDia,
		TMP.PasoIntAtraDia,		TMP.IntOrdDevengado,		TMP.IntMorDevengado,	TMP.ComisiDevengado,		TMP.PagoCapVigDia,
		TMP.PagoCapAtrDia,		TMP.PagoIntOrdDia,			TMP.PagoIntAtrDia,		TMP.PagoComisiDia,			TMP.PagoMoratorios,
		TMP.PagoIvaDia,			TMP.ISRDelDia,				TMP.DiasAtraso,			TMP.NumSocios,				Var_ManejaCarteraAgro AS ManejaCarteraAgro,
		IFNULL(TCM.TipCamDof, Entero_Cero) AS TipCamDof,
		IFNULL(TCM.DescMoneda, Cadena_Vacia) AS DesMoneda
		FROM TMPANALITICOCARTFOND TMP
		LEFT JOIN TMP_CREDITOMONEDA TCM ON TCM.CreditoFondeoID = TMP.CreditoFondeoID AND NumTransaccion IS NOT NULL
		ORDER BY TMP.CreditoFondeoID;

	DROP TABLE IF EXISTS TMP_CREDITOMONEDA;
END TERMINASTORE$$