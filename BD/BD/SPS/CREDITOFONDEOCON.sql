-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOCON`;

DELIMITER $$
CREATE PROCEDURE `CREDITOFONDEOCON`(
	-- Store Procedure para la consulta de creditos de fondeo
	-- Modulo: Fondeo --> Registro --> Alta Credito Fondeo

	Par_CreditoFonID	BIGINT(20),			-- Numero de Credito de Fondeo
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID		INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Par_NumErr          	INT(11);		-- Numero de Error
DECLARE Par_ErrMen          	VARCHAR(350);	-- Mensaje de Error
DECLARE Var_PagaIva         	CHAR(1);		-- Si el cliente paga IVA
DECLARE Var_PagaISR         	CHAR(1);		-- SI el cliente paga ISR
DECLARE Var_IVA             	DECIMAL(12,2);	-- IVA
DECLARE Var_ISR             	DECIMAL(12,2);	-- ISR
DECLARE Var_CapIntere       	CHAR(1);		-- Capital e Interes
DECLARE Var_NumTotAmorti    	INT(11);		-- Numero de Total de Amortizaciones
DECLARE Var_NumAmortAtrasadas	INT(11);		-- Numero de Amortizaciones Atrasadas
DECLARE Var_AmortizacionID		INT(11);		-- Numero de Amortizacion

DECLARE Var_Tasa            	DECIMAL(12,4);	-- Variable de Tasa
DECLARE Var_FechaIni        	DATE;			-- Variable de Fecha Inicial
DECLARE Var_FechaVenc       	DATE;			-- Variable de Fecha de Vencimiento
DECLARE Var_MonDescri       	VARCHAR(100);	-- Variable Monto en Descripcion

-- Declaracion de Constantes
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT(11);
DECLARE Decimal_Cero     	DECIMAL(12,4);
DECLARE Con_Principal   	INT(11);
DECLARE Con_Foranea     	INT(11);
DECLARE Con_Ajuste        	INT(11);
DECLARE Con_PagCreExi		INT(11);
DECLARE Con_BancaLinea  	INT;
DECLARE Con_Prepago			INT(11);
DECLARE Con_Relacion		INT(11);
DECLARE Var_SI				CHAR(1);
DECLARE Var_NO				CHAR(1);
DECLARE Est_Pagado			CHAR(1);
DECLARE Est_Vigente			CHAR(1);
DECLARE Est_Atrasado		CHAR(1);
DECLARE Var_FecActual       DATE;
DECLARE NO_Capitaliza   	CHAR(1);
DECLARE SI_Capitaliza   	CHAR(1);


-- Asignacion de constantes
SET Cadena_Vacia    := '';                  -- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';        -- Fecha Vacia
SET Entero_Cero     := 0;                   -- Entero en Cero
SET Decimal_Cero    := 0.0;                 -- Decimal Cero
SET Con_Principal   := 1;                   -- Consulta Principal
SET Con_Foranea     := 2;                   -- Consulta Foranea
SET Con_Ajuste      := 3;                   -- Consulta Ajuste de Movimientos
SET Con_PagCreExi   := 4;                   -- Consulta del Pago Exigible del Credito Pasivo
SET Con_BancaLinea  := 5;                   -- Consulta Banca en Linea
SET Con_Prepago		:= 6;                   -- Consulta del Prepago del Crédito Pasivo
SET Con_Relacion	:= 7;					-- Consulta a la tabla RELCREDPASIVOAGRO
SET Var_NO          := 'N';                 -- Valor NO
SET Var_SI          := 'S';                 -- Valor SI
SET Est_Pagado      := 'P';                 -- Estatus Pagado
SET Est_Vigente     := 'N';                 -- Estatus Vigente
SET Est_Atrasado    := 'A';                 -- Estatus Atrasado
SET NO_Capitaliza   := 'N';                 -- El Credito-Fondeo SI Capitaliza Interes
SET SI_Capitaliza   := 'S';                 -- El Credito-Fondeo NO Capitaliza Interes

SELECT FechaSistema INTO Var_FecActual
	FROM PARAMETROSSIS;

IF(Par_NumCon = Con_Principal) THEN
	SELECT 	CreditoFondeoID,		LineaFondeoID,			InstitutFondID,			Folio,				TipoCalInteres,
			CalcInteresID,			TasaBase,				SobreTasa,				TasaFija,			PisoTasa,
			TechoTasa,				FactorMora,				Monto,					MonedaID,			PlazoContable,
			FechaContable,			FechaInicio,			FechaVencimien,			FechaTerminaci,		Estatus,
			TipoPagoCapital,		FrecuenciaCap,			PeriodicidadCap,		NumAmortizacion,	FrecuenciaInt,
			PeriodicidadInt,		NumAmortInteres,		MontoCuota,				FechaInhabil,		CalendIrregular,
			DiaPagoInteres,			DiaPagoCapital,			DiaMesInteres,			DiaMesCapital,		AjusFecUlVenAmo,
			AjusFecExiVen,			NumTransacSim,			PlazoID,				PagaIva,			PorcentanjeIVA,
			MargenPagIgual,			InstitucionID,			CuentaClabe,			NumCtaInstit,		TipoInstitID,
			NacionalidadIns,		ComDispos,				IvaComDispos,			CapitalizaInteres,	TipoFondeador,
			PagosParciales,			EsAgropecuario,			TipoCancelacion,		Refinancia
	FROM CREDITOFONDEO
	WHERE CreditoFondeoID = Par_CreditoFonID;
END IF;

IF(Par_NumCon = Con_Foranea) THEN
	SELECT CreditoFondeoID,					Estatus, 		LineaFondeoID,			InstitutFondID, 		Monto,
			(SaldoCapVigente+SaldoCapAtrasad) AS SaldoCredito,	FechaInicio
	FROM CREDITOFONDEO
	WHERE CreditoFondeoID = Par_CreditoFonID;
END IF;

/*consulta generica para las consultas*/
IF(Par_NumCon = Con_Ajuste OR Par_NumCon = Con_PagCreExi OR Par_NumCon = Con_BancaLinea OR Par_NumCon = Con_Prepago) THEN
	/*se valida si el credito pasivo paga iva .*/
    SELECT
           IFNULL(PagaIVA, Var_NO),
           IFNULL(PorcentanjeIVA/100, 0),
           IFNULL(CobraISR, Var_NO),
           IFNULL(TasaISR, Entero_Cero),
           IFNULL(CapitalizaInteres, NO_Capitaliza),
           IFNULL(NumAmortInteres, NumAmortInteres),
           TasaFija, FechaInicio, FechaVencimien, Mon.Descripcion
            INTO
           Var_PagaIva,         Var_IVA,    Var_PagaISR,    Var_ISR,        Var_CapIntere,
           Var_NumTotAmorti,    Var_Tasa,   Var_FechaIni,   Var_FechaVenc,  Var_MonDescri
		FROM CREDITOFONDEO Cre,
           MONEDAS Mon
		WHERE Cre.CreditoFondeoID = Par_CreditoFonID
        AND Cre.MonedaID = Mon.MonedaId;

    IF(Var_PagaIva = Var_SI) THEN
        SET Var_IVA := Var_IVA;
    ELSE
        SET Var_IVA := Entero_Cero;
    END IF;

    IF(Var_PagaISR = Var_SI) THEN
        SET Var_ISR := Var_ISR;
    ELSE
        SET Var_ISR := Entero_Cero;
    END IF;

END IF;

IF(Par_NumCon = Con_Ajuste) THEN
	 SELECT MIN(AmortizacionID) INTO Var_AmortizacionID
                FROM AMORTIZAFONDEO
                WHERE CreditoFondeoID  	 = Par_CreditoFonID
                  AND Estatus			!= Est_Pagado;

	SELECT 	Cre.CreditoFondeoID,    	MAX(Cre.LineaFondeoID) AS LineaFondeoID,     MAX(Cre.InstitutFondID) AS InstitutFondID,
			MAX(Cre.Monto) AS Monto,	MAX(Cre.MonedaID) AS MonedaID,
            MAX(Cre.FechaInicio) AS FechaInicio,        MAX(Cre.FechaVencimien) AS FechaVencimien,    MAX(Cre.Estatus) AS Estatus,
			FORMAT(SUM(IFNULL(ROUND(Amor.SaldoCapVigente,2),Entero_Cero)),2) AS SaldoCapVigente,
            FORMAT(SUM(IFNULL(ROUND(Amor.SaldoCapAtrasad,2),Entero_Cero)),2)AS SaldoCapAtrasad,
			FORMAT(SUM(IFNULL(ROUND(Amor.SaldoInteresAtra,2),Entero_Cero)),2) AS SaldoInteresAtra,
            FORMAT(SUM(IFNULL(ROUND(Amor.SaldoInteresPro,2),Entero_Cero)),2) AS SaldoInteresPro,
            FORMAT(SUM(IFNULL(ROUND(Amor.ProvisionAcum,2),Entero_Cero)),2) AS ProvisionAcum,
            FORMAT(SUM(IFNULL(((ROUND(Amor.SaldoInteresAtra,2) +
            					ROUND(Amor.SaldoInteresPro,2))* (Var_IVA)),Entero_Cero)),2) AS SaldoIVAInteres,
            FORMAT(SUM(IFNULL(ROUND(Amor.SaldoMoratorios,2),Entero_Cero)),2) AS SaldoMoratorios,
            FORMAT(SUM(IFNULL((ROUND(Amor.SaldoMoratorios,2) * (Var_IVA)),Entero_Cero)),2) AS SaldoIVAMora,
            FORMAT(SUM(IFNULL(ROUND(Amor.SaldoComFaltaPa,2),Entero_Cero)),2) AS SaldoComFaltaPa,
            FORMAT(SUM(IFNULL((ROUND(Amor.SaldoComFaltaPa,2) * (Var_IVA)),Entero_Cero)),2) AS SaldoIVAComFalP,
            FORMAT(SUM(IFNULL(ROUND(Amor.SaldoOtrasComis,2),Entero_Cero)),2) AS SaldoOtrasComis,
            FORMAT(SUM(IFNULL((ROUND(Amor.SaldoOtrasComis,2)* (Var_IVA)),Entero_Cero)),2) AS SaldoIVAComisi,
            FORMAT(SUM(IFNULL(( ROUND(Amor.SaldoCapVigente,2) +
            					ROUND(Amor.SaldoCapAtrasad,2)),Entero_Cero)),2) AS totalCapital,
            FORMAT(SUM(IFNULL(( ROUND(Amor.SaldoInteresAtra,2) +
            					ROUND(Amor.SaldoInteresPro,2)),Entero_Cero)),2) AS totalInteres,
            FORMAT(SUM(IFNULL(( ROUND(Amor.SaldoComFaltaPa,2) +
            					ROUND(Amor.SaldoOtrasComis,2)),Entero_Cero)),2) AS totalComisi,
            FORMAT(SUM(IFNULL(( ROUND((Amor.SaldoComFaltaPa * Var_IVA), 2) +
            					ROUND((Amor.SaldoOtrasComis * Var_IVA), 2)),Entero_Cero)),2) AS totalIVACom,
            MAX(Cre.PagaIva) AS PagaIva,
            MAX(Cre.PorcentanjeIVA) AS PorcentanjeIVA,
            MAX(IFNULL(CobraISR,Var_NO)) AS CobraISR,
            MAX(IFNULL(TasaISR,Entero_Cero) )AS TasaISR,
            FORMAT(SUM(IFNULL((
								ROUND(Amor.SaldoCapVigente,2)  + ROUND(Amor.SaldoCapAtrasad,2) +
								ROUND(Amor.SaldoInteresAtra,2) + ROUND(Amor.SaldoInteresPro,2) +
								ROUND(Amor.SaldoMoratorios,2)  + ROUND(Amor.SaldoComFaltaPa,2) + ROUND(Amor.SaldoOtrasComis,2)) +

								ROUND((
										ROUND(Amor.SaldoInteresAtra,2) + ROUND(Amor.SaldoInteresPro,2) +
										ROUND(Amor.SaldoMoratorios,2)  + ROUND(Amor.SaldoComFaltaPa,2) + ROUND(Amor.SaldoOtrasComis,2))* Var_IVA,2)
					,Entero_Cero)),2) AS AdeudoTotal,
			IFNULL(ROUND((SUM(ROUND(Amor.SaldoInteresPro,2))/SUM(ROUND(Amor.Interes,2)) )* SUM(ROUND(Amor.Retencion,2)),2),Entero_Cero) AS SaldoRetencion
    FROM CREDITOFONDEO	Cre
	LEFT OUTER JOIN AMORTIZAFONDEO Amor ON (Cre.CreditoFondeoID = Amor.CreditoFondeoID AND Amor.Estatus <> Est_Pagado)
	WHERE Cre.CreditoFondeoID	= Par_CreditoFonID
	GROUP BY Cre.CreditoFondeoID;
END IF;


/* Consulta del Pago Exigible del Credito Pasivo*/
IF(Par_NumCon = Con_PagCreExi) THEN
	-- Nota: El Format lo convierte a texto
	-- Para las sumas y obtencion de los ivas de redondea individualmente con el round
	-- Para que coincida con los procesos de Pago y Consultas en Pantalla
	SELECT	FORMAT(IFNULL(SUM(SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigente,
			FORMAT(IFNULL(SUM(SaldoCapAtrasad),Entero_Cero),2) AS SaldoCapAtrasad,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero),2) AS SaldoInteresPro,
         FORMAT(IFNULL(SUM(ROUND(SaldoInteresAtra,2)),Entero_Cero),2) AS SaldoInteresAtra,
			FORMAT(IFNULL(SUM((SaldoInteresPro + SaldoInteresAtra) * Var_IVA), 0), 2) AS SaldoIVAInteres,
			FORMAT(IFNULL(SUM(SaldoMoratorios),Entero_Cero),2) AS SaldoMoratorios,
			FORMAT(IFNULL(SUM(ROUND(SaldoMoratorios,2) * Var_IVA),Entero_Cero),2) AS SaldoIVAMora,
			FORMAT(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) AS SaldoComFaltaPa,
			FORMAT(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) * Var_IVA),Entero_Cero),2) AS SaldoIVAComFalP,
			FORMAT(IFNULL(SUM(SaldoOtrasComis),Entero_Cero),2) AS SaldoOtrasComis,
			FORMAT(IFNULL(SUM(ROUND(SaldoOtrasComis,2) * Var_IVA),Entero_Cero),2) AS SaldoIVAComisi,
			FORMAT(IFNULL(SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasad,2)),Entero_Cero),2) AS TotalCapital,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro,2) + ROUND(SaldoInteresAtra,2)),Entero_Cero),2) AS TotalInteres,
			FORMAT(IFNULL(SUM(ROUND(SaldoComFaltaPa,2)+ROUND(SaldoOtrasComis,2)),Entero_Cero),2) AS TotalComisi,
			FORMAT(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) * Var_IVA)+ SUM(ROUND(SaldoOtrasComis,2) * Var_IVA),Entero_Cero),2) AS TotalIVACom,
			FORMAT(-- Saldo Total Exigible
				IFNULL(SUM(SaldoCapVigente),Entero_Cero) + IFNULL(SUM(SaldoCapAtrasad),Entero_Cero) + -- Capitales
				IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero) + IFNULL(SUM(ROUND(SaldoInteresAtra,2)),Entero_Cero) +
				ROUND(IFNULL(SUM(SaldoInteresPro + SaldoInteresAtra) * Var_IVA, 0) +
				ROUND(IFNULL(SUM(SaldoMoratorios),Entero_Cero),2)  +
				ROUND(IFNULL(SUM(ROUND(SaldoMoratorios,2) * Var_IVA),Entero_Cero),2) +
				ROUND(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) +
				ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) * Var_IVA),Entero_Cero),2) +
				ROUND(IFNULL(SUM(SaldoOtrasComis),Entero_Cero),2)  +
				ROUND(IFNULL(SUM(ROUND(SaldoOtrasComis,2) * Var_IVA),Entero_Cero),2)
			, 2),2) AS TotalExigible,
			 IFNULL(ROUND( (SUM(ROUND(SaldoInteresPro,2))/SUM(ROUND(Interes,2)))* SUM(ROUND(Retencion,2)),2),Entero_Cero) AS SaldoRetencion
	FROM AMORTIZAFONDEO
	WHERE CreditoFondeoID = Par_CreditoFonID
		AND Estatus <> Est_Pagado
		AND FechaExigible <= Var_FecActual
      AND ( Var_CapIntere = NO_Capitaliza                       -- En un Credito con Capitalizacion de Interes, solo es exigible hasta la ultima cuota
      OR    (   Var_CapIntere = SI_Capitaliza
      AND       AmortizacionID  = Var_NumTotAmorti )    )
	GROUP BY CreditoFondeoID;

END IF;


/* Consulta para Pantalla de Banca en Linea */
IF(Par_NumCon = Con_BancaLinea) THEN
	-- Nota: El Format lo convierte a texto
	-- Para las sumas y obtencion de los ivas de redondea individualmente con el round
	-- Para que coincida con los procesos de Pago y Consultas en Pantalla
	SELECT AF.CreditoFondeoID,
          FORMAT(Var_Tasa, 4) AS Tasa,
          Var_MonDescri AS Moneda,
          CONVERT(Var_FechaIni, CHAR(10)) AS FecInicio,
          CONVERT(Var_FechaVenc, CHAR(10)) AS FecVencimiento,
         FORMAT(IFNULL(SUM(AF.SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigente,
			FORMAT(IFNULL(SUM(AF.SaldoCapAtrasad),Entero_Cero),2) AS SaldoCapAtrasad,
			FORMAT(IFNULL(SUM(ROUND(AF.SaldoInteresPro,2)),Entero_Cero),2) AS SaldoInteresPro,
         FORMAT(IFNULL(SUM(ROUND(AF.SaldoInteresAtra,2)),Entero_Cero),2) AS SaldoInteresAtra,
			FORMAT(IFNULL(SUM((AF.SaldoInteresPro + AF.SaldoInteresAtra) * Var_IVA), 0), 2) AS SaldoIVAInteres,
			FORMAT(IFNULL(SUM(AF.SaldoMoratorios),Entero_Cero),2) AS SaldoMoratorios,
			FORMAT(IFNULL(SUM(ROUND(AF.SaldoMoratorios,2) * Var_IVA),Entero_Cero),2) AS SaldoIVAMora,
			FORMAT(IFNULL(SUM(AF.SaldoComFaltaPa),Entero_Cero),2) AS SaldoComFaltaPa,
			FORMAT(IFNULL(SUM(ROUND(AF.SaldoComFaltaPa,2) * Var_IVA),Entero_Cero),2) AS SaldoIVAComFalP,
			FORMAT(IFNULL(SUM(AF.SaldoOtrasComis),Entero_Cero),2) AS SaldoOtrasComis,
			FORMAT(IFNULL(SUM(ROUND(AF.SaldoOtrasComis,2) * Var_IVA),Entero_Cero),2) AS SaldoIVAComisi,
			IFNULL(ROUND( (SUM(ROUND(AF.SaldoInteresPro,2))/SUM(ROUND(AF.Interes,2)))* SUM(ROUND(AF.Retencion,2)),2),Entero_Cero) AS SaldoRetencion,
			CF.InstitutFondID, CF.LineaFondeoID
	FROM AMORTIZAFONDEO AF
		 INNER JOIN CREDITOFONDEO CF ON AF.CreditoFondeoID = CF.CreditoFondeoID
	WHERE AF.CreditoFondeoID = Par_CreditoFonID
		AND AF.Estatus <> Est_Pagado
	GROUP BY CreditoFondeoID;

END IF;

/* No. 6: Consulta del Prepago del Crédito Pasivo. */
IF(Par_NumCon = Con_Prepago) THEN
	/* Se obtienen las amortizaciones atrasadas para validar que no realice prepago
	 * si el crédito se encuentra con atraso. */
	SET Var_NumAmortAtrasadas := (SELECT COUNT(*) FROM AMORTIZAFONDEO WHERE CreditoFondeoID = Par_CreditoFonID AND Estatus = Est_Atrasado);
	SET Var_NumAmortAtrasadas := IFNULL(Var_NumAmortAtrasadas, Entero_Cero);

	/* Nota: El Format lo convierte a texto.
	 * Para las sumas y obtencion de los ivas de redondea individualmente con el round.
	 * Para que coincida con los procesos de Pago y Consultas en Pantalla. */
	SELECT	FORMAT(IFNULL(SUM(SaldoCapVigente),Entero_Cero),2) AS SaldoCapVigente,
			FORMAT(IFNULL(SUM(SaldoCapAtrasad),Entero_Cero),2) AS SaldoCapAtrasad,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero),2) AS SaldoInteresPro,
        	FORMAT(IFNULL(SUM(ROUND(SaldoInteresAtra,2)),Entero_Cero),2) AS SaldoInteresAtra,
			FORMAT(IFNULL(SUM((SaldoInteresPro + SaldoInteresAtra) * Var_IVA), 0), 2) AS SaldoIVAInteres,
			FORMAT(IFNULL(SUM(SaldoMoratorios),Entero_Cero),2) AS SaldoMoratorios,
			FORMAT(IFNULL(SUM(ROUND(SaldoMoratorios,2) * Var_IVA),Entero_Cero),2) AS SaldoIVAMora,
			FORMAT(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) AS SaldoComFaltaPa,
			FORMAT(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) * Var_IVA),Entero_Cero),2) AS SaldoIVAComFalP,
			FORMAT(IFNULL(SUM(SaldoOtrasComis),Entero_Cero),2) AS SaldoOtrasComis,
			FORMAT(IFNULL(SUM(ROUND(SaldoOtrasComis,2) * Var_IVA),Entero_Cero),2) AS SaldoIVAComisi,
			FORMAT(IFNULL(SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasad,2)),Entero_Cero),2) AS TotalCapital,
			FORMAT(IFNULL(SUM(ROUND(SaldoInteresPro,2) + ROUND(SaldoInteresAtra,2)),Entero_Cero),2) AS TotalInteres,
			FORMAT(IFNULL(SUM(ROUND(SaldoComFaltaPa,2)+ROUND(SaldoOtrasComis,2)),Entero_Cero),2) AS TotalComisi,
			FORMAT(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) * Var_IVA)+ SUM(ROUND(SaldoOtrasComis,2) * Var_IVA),Entero_Cero),2) AS TotalIVACom,
			FORMAT(-- Saldo Total Exigible
				IFNULL(SUM(SaldoCapVigente),Entero_Cero) + IFNULL(SUM(SaldoCapAtrasad),Entero_Cero) + -- Capitales
				IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero) + IFNULL(SUM(ROUND(SaldoInteresAtra,2)),Entero_Cero) +
				ROUND(IFNULL(SUM(SaldoInteresPro + SaldoInteresAtra) * Var_IVA, 0) +
				ROUND(IFNULL(SUM(SaldoMoratorios),Entero_Cero),2)  +
				ROUND(IFNULL(SUM(ROUND(SaldoMoratorios,2) * Var_IVA),Entero_Cero),2) +
				ROUND(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) +
				ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) * Var_IVA),Entero_Cero),2) +
				ROUND(IFNULL(SUM(SaldoOtrasComis),Entero_Cero),2)  +
				ROUND(IFNULL(SUM(ROUND(SaldoOtrasComis,2) * Var_IVA),Entero_Cero),2)
			, 2),2) AS TotalExigible,
			 IFNULL(ROUND( (SUM(ROUND(SaldoInteresPro,2))/SUM(ROUND(Interes,2)))* SUM(ROUND(Retencion,2)),2),Entero_Cero) AS SaldoRetencion,
			 IF(Var_NumAmortAtrasadas > Entero_Cero, Var_SI, Var_NO) AS ExisteAtraso
	FROM AMORTIZAFONDEO
	WHERE CreditoFondeoID = Par_CreditoFonID
		AND Estatus = Est_Vigente
		AND (Var_CapIntere = NO_Capitaliza  -- En un Credito con Capitalizacion de Interes, solo es exigible hasta la ultima cuota
			OR (Var_CapIntere = SI_Capitaliza AND AmortizacionID  = Var_NumTotAmorti))
	GROUP BY CreditoFondeoID;
END IF;

IF(Par_NumCon = Con_Relacion) THEN
	IF NOT EXISTS((SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO WHERE CreditoFondeoID = Par_CreditoFonID))THEN
		(SELECT CreditoFondeoID FROM CREDITOFONDEO WHERE CreditoFondeoID = Par_CreditoFonID AND  EsContingente = Var_SI);
    ELSE
		(SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO WHERE CreditoFondeoID = Par_CreditoFonID);
    END IF;
END IF;

END TerminaStore$$
