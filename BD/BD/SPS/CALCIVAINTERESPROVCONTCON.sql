-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCIVAINTERESPROVCONTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCIVAINTERESPROVCONTCON`;
DELIMITER $$

CREATE PROCEDURE `CALCIVAINTERESPROVCONTCON`(
-- --------------------------------------------------------------------------
-- SP para calcular el iva del los intereses de las amortizaciones de credito CONTINGENTE
-- --------------------------------------------------------------------------
	Par_CreditoID			BIGINT(12),
	Par_NumCon				TINYINT UNSIGNED,
	OUT Par_SaldoIVAInteres DECIMAL(14,2),

	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_PagaIVA       		CHAR(1);
	DECLARE Var_IVA           		DECIMAL(12,2);
	DECLARE Var_PagaIVAInt    		CHAR(1);
	DECLARE Var_PagaIVAMor    		CHAR(1);
	DECLARE Var_IVAMora       		DECIMAL(12,2);

    DECLARE Var_TotalCap    		DECIMAL(14,2);
	DECLARE Var_TotalInt    		DECIMAL(14,2);
	DECLARE Var_TotalIva    		DECIMAL(14,2);
	DECLARE Var_TipoCredito			CHAR(1);
	DECLARE Var_FechaRegistro   	DATE;

    DECLARE Var_FecActual			DATE;
	DECLARE Var_TipoCalInteres  	INT(11);
	DECLARE Var_PrductoCreID    	INT(11);
	DECLARE Var_Frecuencia      	CHAR(1);
	DECLARE Var_DiasPermPagAnt  	INT(11);

    DECLARE Var_ProxAmorti      	INT(11);
	DECLARE Var_NumProyInteres  	INT(11);
	DECLARE Var_CapitaAdela     	DECIMAL(14,2);
	DECLARE Var_IntProActual    	DECIMAL(14,4);
	DECLARE Var_TotPagAdela     	DECIMAL(14,2);

    DECLARE Var_FecDiasProPag   	DATE;
	DECLARE Var_SaldoInsoluto   	DECIMAL(14,2);
	DECLARE Var_Interes    			DECIMAL(14,4);
	DECLARE Var_IntAntici       	DECIMAL(14,4);
	DECLARE Var_FecProxPago     	DATE;

    DECLARE Var_DiasAntici      	INT(11);
	DECLARE Var_ProyInPagAde    	CHAR(1);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia      		CHAR(1);
	DECLARE Fecha_Vacia       		DATE;
	DECLARE Entero_Cero       		INT(11);
	DECLARE SIPagaIVA         		CHAR(1);
	DECLARE NOPagaIVA         		CHAR(1);

    DECLARE Con_InteresFiniquito 	INT(11);
	DECLARE Con_InteresExig			INT(11);
	DECLARE Reestructura			CHAR(1);
	DECLARE EstDesembolso			CHAR(1);
	DECLARE EstatusPagado			CHAR(1);

    DECLARE For_TasaFija			INT(11);
	DECLARE Int_SalInsol			INT(11);
	DECLARE Int_SalGlobal			INT(11);
	DECLARE SI_ProyectInt   		CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia        := '';		-- Cadena vacia
	SET Fecha_Vacia         := '1900-01-01'; -- Fecha vacia
	SET Entero_Cero         := 0;		-- Entero cero
	SET SIPagaIVA           := 'S';     -- SI paga iva
	SET NOPagaIVA           := 'N';     -- NO paga iva

    SET Con_InteresFiniquito:= 1;       -- Consulta para finiquito, usada en creditoscon no 17
	SET Con_InteresExig		:= 2;       -- Consulta para el exigible, usada en creditoscon no 8
	SET Reestructura      	:= 'R';     -- Reestructura
	SET EstDesembolso     	:= 'D'; 	-- Desembolso
	SET EstatusPagado     	:= 'P';     -- Estatus pagado

    SET SI_ProyectInt   	:= 'S';
	SET For_TasaFija      	:= 1;       -- Formula de Calculo de Interes: Tasa Fija
	SET Int_SalInsol        := 1;       -- Calculo de Interes Sobre Saldos Insolutos
	SET Int_SalGlobal       := 2;       -- Calculo de Interes Sobre Saldos Globales (Monto Original)

	SELECT FechaRegistro  INTO Var_FechaRegistro
	  FROM REESTRUCCREDITO Res,
	    CREDITOSCONT Cre
	  WHERE Res.CreditoOrigenID= Par_CreditoID
	    AND Res.CreditoDestinoID = Par_CreditoID
	    AND Cre.CreditoID = Res.CreditoDestinoID
	    AND Res.EstatusReest = EstDesembolso
	    AND Res.Origen= Reestructura;

	SELECT FechaSistema INTO Var_FecActual
		FROM PARAMETROSSIS;

	DELETE FROM TMPAMOTICREDITOSALDOS WHERE CreditoID = Par_CreditoID;

    SELECT  Cli.PagaIVA,		Suc.IVA,			Pro.CobraIVAInteres,	Pro.CobraIVAMora, Suc.IVA,
			Cre.TipoCredito,	Cre.TipoCalInteres,	Pro.ProducCreditoID,	Cre.FrecuenciaCap
      INTO  Var_PagaIVA,    	Var_IVA,			Var_PagaIVAInt,			Var_PagaIVAMor,   Var_IVAMora,
			Var_TipoCredito,	Var_TipoCalInteres,	Var_PrductoCreID,		Var_Frecuencia
        FROM CREDITOSCONT Cre,
			CLIENTES Cli,
			SUCURSALES Suc,
			PRODUCTOSCREDITO Pro
        WHERE Cre.CreditoID = Par_CreditoID
			AND Cre.ClienteID = Cli.ClienteID
			AND Cli.SucursalOrigen = Suc.SucursalID
			AND Pro.ProducCreditoID = Cre.ProductoCreditoID;

    SET Var_PagaIVA			:= IFNULL(Var_PagaIVA, SIPagaIVA);
    SET Var_PagaIVAInt  	:= IFNULL(Var_PagaIVAInt, SIPagaIVA);
    SET Var_PagaIVAMor  	:= IFNULL(Var_PagaIVAMor, SIPagaIVA);
    SET Var_TipoCalInteres	:= IFNULL(Var_TipoCalInteres, Int_SalInsol);
    SET Var_IVA				:= IFNULL(Var_IVA, Entero_Cero);
    SET Var_IVAMora			:= IFNULL(Var_IVAMora, Entero_Cero);

    IF(Var_PagaIVA = NOPagaIVA ) THEN

        SET Var_IVA		:= Entero_Cero;
        SET Var_IVAMora := Entero_Cero;

    ELSE
        IF (Var_PagaIVAInt = NOPagaIVA) THEN
            SET Var_IVA := Entero_Cero;
        END IF;

        IF (Var_PagaIVAMor = NOPagaIVA) THEN
            SET Var_IVAMora := Entero_Cero;
        END IF;

    END IF;

	IF(Var_TipoCredito != Reestructura) THEN
		SELECT SUM(Capital),	SUM(Interes),	SUM(IVAInteres)
			INTO Var_TotalCap,	Var_TotalInt,	Var_TotalIva
			FROM AMORTICREDITOCONT
			WHERE CreditoID = Par_CreditoID;
	ELSE
		SELECT SUM(Amo.Capital),	SUM(Amo.Interes), 	SUM(Amo.IVAInteres)
			INTO Var_TotalCap,		Var_TotalInt,		Var_TotalIva
			FROM SOLICITUDCREDITO Sol
		 	INNER JOIN CREDITOSCONT Cre
				ON Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Sol.Estatus= EstDesembolso
				AND Sol.TipoCredito= Reestructura
		  	INNER JOIN REESTRUCCREDITO Res
				ON Res.CreditoOrigenID = Cre.CreditoID
				AND Res.CreditoDestinoID = Cre.CreditoID
				AND Cre.TipoCredito = Reestructura
		  	INNER JOIN AMORTICREDITOCONT Amo
				ON Amo.CreditoID = Cre.CreditoID
		  	WHERE Amo.CreditoID = Par_CreditoID
				AND (Amo.FechaLiquida > Var_FechaRegistro
				OR Amo.FechaLiquida = Fecha_Vacia);
	END IF;

	INSERT INTO TMPAMOTICREDITOSALDOS(
		AmortizacionID,		CreditoID,			FechaInicio,		FechaVencim,		FechaExigible,
		Estatus,			Capital,			Interes,			IVAInteres,			SaldoCapital,
		SaldoCapVigente,	SaldoCapAtrasa,		SaldoCapVencido,	SaldoCapVenNExi,	SaldoInteresPro,
        SaldoInteresAtr,	SaldoInteresVen,	SaldoIntNoConta,	SaldoIVAInteres,	SaldoMoratorios,
        SaldoIVAMorato,		SaldoComFaltaPa,	SaldoIVAComFalP,	SaldoOtrasComis,	SaldoIVAComisi,
        SaldoInteresOrd,	TotalCuotaMasIVA,	TotalCuotaSinIVA,	MontoCuota,			TotalCapital,
        TotalInteres,		TotalIva)

	SELECT
		AmortizacionID,     Par_CreditoID,		FechaInicio,        FechaVencim,        FechaExigible,
		Estatus,            Capital,            Interes,            IVAInteres,			SaldoCapital,
		SaldoCapVigente,    SaldoCapAtrasa,     SaldoCapVencido,	SaldoCapVenNExi,
		ROUND(SaldoInteresPro,2) AS SaldoInteresPro,            	ROUND(SaldoInteresAtr,2) AS SaldoInteresAtr,
		ROUND(SaldoInteresVen,2) AS SaldoInteresVen,            	ROUND(SaldoIntNoConta,2) AS SaldoIntNoConta,

	CASE Var_TipoCalInteres
	WHEN Int_SalInsol THEN
		ROUND(SaldoInteresPro * Var_IVA, 2) +
		ROUND(SaldoInteresAtr * Var_IVA, 2) +
		ROUND(SaldoInteresVen * Var_IVA, 2) +
		ROUND(SaldoIntNoConta * Var_IVA, 2)
	WHEN Int_SalGlobal THEN
	  	ROUND(IF((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2))=Interes,
			IVAInteres,
			((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2)) * Var_IVA)), 2)
	END AS SaldoIVAInteres,

		(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) AS SaldoMoratorios,

		ROUND(SaldoMoratorios * Var_IVAMora, 2) +
		ROUND(SaldoMoraVencido * Var_IVAMora, 2) +
		ROUND(SaldoMoraCarVen * Var_IVAMora, 2) AS SaldoIVAMorato,

		SaldoComFaltaPa,
		ROUND(SaldoComFaltaPa * Var_IVA, 2) AS SaldoIVAComFalP,
		SaldoOtrasComis,
		ROUND(SaldoOtrasComis * Var_IVA, 2) AS SaldoIVAOtrCom,
		ROUND(SaldoInteresOrd,2) AS SaldoInteresOrd,
		ROUND(SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido +
		SaldoCapVenNExi + SaldoInteresPro + SaldoInteresAtr +
		SaldoInteresVen + SaldoIntNoConta +
		(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) + SaldoComFaltaPa +
		SaldoOtrasComis, 2)  +

		ROUND(SaldoInteresPro * Var_IVA, 2) +
		ROUND(SaldoInteresAtr * Var_IVA, 2) +
		ROUND(SaldoInteresVen * Var_IVA, 2) +
		ROUND(SaldoIntNoConta * Var_IVA, 2) +

		ROUND(SaldoMoratorios * Var_IVAMora, 2) +
		ROUND(SaldoMoraVencido * Var_IVAMora, 2) +
		ROUND(SaldoMoraCarVen * Var_IVAMora, 2) +

		ROUND(SaldoComFaltaPa * Var_IVA, 2) +
		ROUND(SaldoOtrasComis * Var_IVA, 2) AS TotalCuotaMasIVA,

		ROUND(SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido +
		SaldoCapVenNExi + SaldoInteresPro + SaldoInteresAtr +
		SaldoInteresVen + SaldoIntNoConta +
		(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen) + SaldoComFaltaPa +
		SaldoOtrasComis, 2) AS TotalCuotaSinIVA,

		ROUND(Capital + Interes + IVAInteres,2) AS MontoCuota,
		Var_TotalCap AS TotalCapital,	Var_TotalInt AS TotalInteres,	Var_TotalIva AS TotalIva

		FROM AMORTICREDITOCONT
			WHERE CreditoID = Par_CreditoID;

	IF(Con_InteresFiniquito = Par_NumCon) THEN
		SELECT SUM(SaldoIVAInteres) INTO Par_SaldoIVAInteres
			FROM TMPAMOTICREDITOSALDOS
				WHERE CreditoID = Par_CreditoID
				AND Estatus != EstatusPagado;
	END IF;

	IF(Con_InteresExig = Par_NumCon) THEN

		SET Var_DiasPermPagAnt  := Entero_Cero;
		SET Var_IntAntici       := Entero_Cero;
		SET Var_NumProyInteres  := Entero_Cero;
		SET Var_IntProActual    := Entero_Cero;
		SET Var_CapitaAdela     := Entero_Cero;
		SET Var_TotPagAdela     := Entero_Cero;

		SELECT Dpa.NumDias INTO Var_DiasPermPagAnt
			FROM CREDDIASPAGANT Dpa
			WHERE Dpa.ProducCreditoID = Var_PrductoCreID
			  AND Dpa.Frecuencia = Var_Frecuencia;

		SET Var_DiasPermPagAnt  := IFNULL(Var_DiasPermPagAnt, Entero_Cero);

		SET Var_ProyInPagAde := (SELECT ProyInteresPagAde FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_PrductoCreID );

		IF(Var_DiasPermPagAnt > Entero_Cero) THEN

			SELECT MIN(FechaExigible),	MIN(AmortizacionID)
	          INTO Var_FecProxPago,		Var_ProxAmorti
				FROM AMORTICREDITOCONT
				WHERE CreditoID   = Par_CreditoID
				  AND FechaVencim > Var_FecActual
				  AND Estatus     != EstatusPagado;

			SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);
			SET Var_ProxAmorti  := IFNULL(Var_ProxAmorti, Entero_Cero);

			IF(Var_FecProxPago != Fecha_Vacia) THEN
				SET Var_DiasAntici := DATEDIFF(Var_FecProxPago, Var_FecActual);
			ELSE
				SET Var_DiasAntici := Entero_Cero;
			END IF;

			SELECT Amo.NumProyInteres, Amo.Interes, IFNULL(Amo.SaldoInteresPro, Entero_Cero) + IFNULL(Amo.SaldoIntNoConta, Entero_Cero),
				IFNULL(SaldoCapVigente, Entero_Cero) + IFNULL(SaldoCapAtrasa, Entero_Cero) +
				IFNULL(SaldoCapVencido, Entero_Cero) + IFNULL(SaldoCapVenNExi, Entero_Cero)
			INTO Var_NumProyInteres, Var_Interes, Var_IntProActual,
				Var_CapitaAdela
				FROM AMORTICREDITOCONT Amo
				WHERE Amo.CreditoID     = Par_CreditoID
				  AND Amo.AmortizacionID = Var_ProxAmorti
				  AND Amo.Estatus     != EstatusPagado;

			SET Var_NumProyInteres  := IFNULL(Var_NumProyInteres, Entero_Cero);
			SET Var_IntProActual 	:= IFNULL(Var_IntProActual, Entero_Cero);
			SET Var_CapitaAdela 	:= IFNULL(Var_CapitaAdela, Entero_Cero);
			SET	Var_Interes			:= IFNULL(Var_Interes, Entero_Cero);

			IF(Var_NumProyInteres = Entero_Cero) THEN

				IF(Var_DiasAntici <= Var_DiasPermPagAnt AND Var_ProyInPagAde = SI_ProyectInt) THEN

					SET Var_IntAntici = ROUND(Var_Interes - Var_IntProActual,2);

					IF(Var_IntAntici < Entero_Cero) THEN
						SET Var_IntAntici := Entero_Cero;
					END IF;
				END IF;
			END IF;

			IF(Var_DiasAntici <= Var_DiasPermPagAnt) THEN
				SET Var_TotPagAdela := Var_CapitaAdela + ROUND(Var_IntAntici + Var_IntProActual,2) +
					ROUND(ROUND(Var_IntAntici + Var_IntProActual,2) * Var_IVA, 2);
			END IF;
		END IF;

		SET	Var_ProxAmorti		:= IFNULL(Var_ProxAmorti,Entero_Cero);

		SELECT
			CASE Var_TipoCalInteres
				WHEN Int_SalInsol THEN
					IFNULL(SUM(ROUND(ROUND(SaldoInteresOrd * Var_IVA,2) +
									ROUND(SaldoInteresAtr * Var_IVA,2) +
									ROUND(SaldoInteresVen * Var_IVA,2) +
									ROUND(SaldoIntNoConta * Var_IVA,2) +

									CASE WHEN AmortizacionID = Var_ProxAmorti THEN Entero_Cero
									ELSE
										ROUND(SaldoInteresPro * Var_IVA,2)
									END
									+
									CASE WHEN AmortizacionID = Var_ProxAmorti THEN
										ROUND(ROUND(SaldoInteresPro + Var_IntAntici,2) * Var_IVA,2)
									ELSE Entero_Cero END,2)),0)
				WHEN Int_SalGlobal THEN
					IFNULL(SUM(ROUND(SaldoIVAInteres,2)),0)

			END AS SaldoIVAInteres
		INTO Par_SaldoIVAInteres
			FROM TMPAMOTICREDITOSALDOS
			WHERE CreditoID = Par_CreditoID
				AND Estatus != EstatusPagado
				AND DATE_SUB(FechaExigible, INTERVAL Var_DiasPermPagAnt DAY)  <= Var_FecActual;
	END IF;

    SET Par_SaldoIVAInteres := IFNULL(Par_SaldoIVAInteres,Entero_Cero);

	DELETE FROM TMPAMOTICREDITOSALDOS WHERE CreditoID = Par_CreditoID;

END TerminaStore$$
