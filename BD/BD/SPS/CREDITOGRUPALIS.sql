-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOGRUPALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOGRUPALIS`;
DELIMITER $$


CREATE PROCEDURE `CREDITOGRUPALIS`(
	Par_CreditoID			BIGINT(12),
	Par_NumCon				TINYINT UNSIGNED,

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
DECLARE Var_PagaIVA     	CHAR(1);
DECLARE Var_IVA         	DECIMAL(12,2);
DECLARE Var_PagaIVAInt  	CHAR(1);
DECLARE Var_PagaIVAMor  	CHAR(1);
DECLARE Var_IVAMora     	DECIMAL(12,2);
DECLARE Var_Grupo			INT(11);
-- Declaracion de Constantes
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE SIPagaIVA       	CHAR(1);
DECLARE NOPagaIVA       	CHAR(1);
DECLARE	EstCerrado			CHAR(1);
DECLARE EstatusAutorizado	CHAR(1);
DECLARE EstatusInactivo		CHAR(1);
DECLARE EstatusVigente		CHAR(1);
DECLARE EstatusPagado		CHAR(1);
DECLARE EstatusCancelado	CHAR(1);
DECLARE EstatusVencido		CHAR(1);
DECLARE EstatusCastigado	CHAR(1);
DECLARE ProrrateoPago       CHAR(1);
DECLARE Con_Saldos      	INT;


-- Asignacion de constantes
SET Cadena_Vacia    	:='';           -- Cadena vacia
SET Fecha_Vacia     	:='1900-01-01'; -- Fecha
SET Entero_Cero     	:= 0;           -- Entero cero
SET SIPagaIVA       	:='S';          -- Si paga IVA
SET NOPagaIVA       	:='N';          -- No paga IVA
SET	EstCerrado			:= 'C';
SET EstatusAutorizado	:='A';		-- Estatus de Credito Autorizado
SET EstatusInactivo		:='I';		-- Estatus de Credito Inactivo
SET EstatusVigente		:='V';		-- Estatus de Credito Vigente
SET EstatusPagado		:='P';		-- Estatus de Credito Pagado
SET EstatusCancelado	:='C';		-- Estatus de Credito Cancelada
SET EstatusVencido		:='B';		-- Estatus de Credito Vencido
SET EstatusCastigado	:='K';		-- Estatus de Credito Castigado
SET ProrrateoPago	    :='S';		-- Prorrateo Pago: SI
SET Con_Saldos          := 2;       -- Consulta de saldos de grupos de credito

IF(Par_NumCon = Con_Saldos) THEN
	/* se obtiene el numero de grupo*/
	SELECT GrupoID INTO Var_Grupo
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

	SELECT	Cli.PagaIVA,	Suc.IVA,	Pro.CobraIVAInteres,	Pro.CobraIVAMora,	Suc.IVA
	INTO	Var_PagaIVA,	Var_IVA,	Var_PagaIVAInt,			Var_PagaIVAMor,		Var_IVAMora
		FROM CREDITOS Cre,
			 CLIENTES Cli,
			 SUCURSALES Suc,
			 PRODUCTOSCREDITO Pro
		WHERE Cre.CreditoID			= Var_Grupo
		  AND Cre.ClienteID			= Cli.ClienteID
		  AND Cli.SucursalOrigen	= Suc.SucursalID
		  AND Pro.ProducCreditoID	= Cre.ProductoCreditoID;

    SET Var_PagaIVA		:= IFNULL(Var_PagaIVA, SIPagaIVA);
    SET Var_PagaIVAInt	:= IFNULL(Var_PagaIVAInt, SIPagaIVA);
    SET Var_PagaIVAMor	:= IFNULL(Var_PagaIVAMor, SIPagaIVA);

    SET Var_IVA			:= IFNULL(Var_IVA, Entero_Cero);
    SET Var_IVAMora		:= IFNULL(Var_IVAMora, Entero_Cero);

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

	IF EXISTS(SELECT Estatus FROM CREDITOS WHERE GrupoID = Var_Grupo
					AND Estatus IN(EstatusAutorizado,EstatusInactivo,EstatusVigente,EstatusPagado,EstatusCancelado,EstatusVencido,EstatusCastigado))THEN

		SELECT	Amo.AmortizacionID,		Amo.FechaInicio,	Amo.FechaVencim,		Amo.FechaExigible,	Amo.Estatus,
				SUM(Amo.Capital) AS Capital,
				SUM(Amo.Interes) AS Interes,
				SUM(Amo.IVAInteres) AS IVAinteres,
				SUM((Amo.Capital + Amo.Interes + Amo.IVAInteres)) AS MontoCuota,
				SUM(Amo.SaldoCapVigente) AS SaldoCapVigente,
				SUM(Amo.SaldoCapAtrasa) AS SaldoCapAtrasa,
				SUM(Amo.SaldoCapVencido) AS SaldoCapVencido,
				SUM(Amo.SaldoCapVenNExi) AS SaldoCapVenNExi,
				ROUND(SUM(Amo.SaldoInteresPro),2)AS SaldoInteresPro,
				ROUND(SUM(Amo.SaldoInteresAtr),2) AS SaldoInteresAtr,
				ROUND(SUM(Amo.SaldoInteresVen), 2)AS SaldoInteresVen,
				ROUND(SUM(Amo.SaldoIntNoConta), 2)AS SaldoIntNoConta,
				ROUND( SUM((Amo.SaldoInteresPro + Amo.SaldoInteresAtr +
					Amo.SaldoInteresVen + Amo.SaldoIntNoConta) * Var_IVA), 2) AS SaldoIVAInteres,
				SUM(Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen) AS SaldoMoratorios,
				ROUND(SUM((Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen) * Var_IVAMora), 2) AS SaldoIVAMora,
				SUM(Amo.SaldoComFaltaPa) AS SaldoComFaltaPa,
				ROUND(SUM(Amo.SaldoComFaltaPa * Var_IVA), 2) AS SaldoIVAComFalPag,
				SUM(Amo.SaldoOtrasComis) + SUM(Amo.SaldoComServGar)  AS SaldoOtrasComis,
				ROUND(SUM(Amo.SaldoOtrasComis * Var_IVA), 2) + ROUND(SUM(Amo.SaldoComServGar * Var_IVA), 2)  AS SaldoIVAOtrCom,
				SUM(ROUND(Amo.SaldoCapVigente + Amo.SaldoCapAtrasa + Amo.SaldoCapVencido +
					Amo.SaldoCapVenNExi + Amo.SaldoInteresPro + Amo.SaldoInteresAtr +
					Amo.SaldoInteresVen + Amo.SaldoIntNoConta +
					(Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen) + Amo.SaldoComFaltaPa + Amo.SaldoComServGar +
					Amo.SaldoOtrasComis, 2)  +
					ROUND(
						(Amo.SaldoInteresPro + Amo.SaldoInteresAtr +
						   Amo.SaldoInteresVen + Amo.SaldoIntNoConta) * Var_IVA, 2) +
					ROUND((Amo.SaldoMoratorios + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen) * Var_IVAMora, 2) +
					ROUND(Amo.SaldoComFaltaPa * Var_IVA, 2) +
					ROUND(Amo.SaldoComServGar * Var_IVA, 2) +
					ROUND(Amo.SaldoOtrasComis * Var_IVA, 2)) AS TotalCuota
			FROM	AMORTICREDITO		Amo,
					CREDITOS			Cre,
					SOLICITUDCREDITO 	Sol,
					INTEGRAGRUPOSCRE 	Igr,
					GRUPOSCREDITO		Gru,
					PRODUCTOSCREDITO    Pro
				WHERE Gru.GrupoID = Igr.GrupoID
				AND Igr.GrupoID = Var_Grupo
				AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
				AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Amo.CreditoID = Cre.CreditoID
				AND Gru.EstatusCiclo = EstCerrado
				AND Cre.ProductoCreditoID = Pro.ProducCreditoID
				AND Pro.ProrrateoPago = ProrrateoPago
				GROUP BY 	Amo.AmortizacionID,		Amo.FechaInicio,	Amo.FechaVencim,	Amo.FechaExigible,	Amo.Estatus;
	END IF;
END IF;
END TerminaStore$$