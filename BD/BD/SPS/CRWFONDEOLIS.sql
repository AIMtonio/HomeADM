-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONDEOLIS`;

DELIMITER $$
CREATE PROCEDURE `CRWFONDEOLIS`(
/* LISTA DE FONDEOS CROWDFUNDING. */
	Par_NumLis			TINYINT UNSIGNED,	-- Número de Lista.
	Par_SolFondeoID		BIGINT(20),			-- Solicitud de Fondeo.
	Par_ClienteID		INT(11),			-- ID del Cliente.
	Par_CreditoID		BIGINT(12),			-- ID del Crédito.
	Par_SolicitudID		BIGINT(20),			-- ID de la Solicitud de Crédito.

	/* Parámetros de Auditoría. */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_FechaExi			DATE;
DECLARE Var_ClienteID			INT;
DECLARE Var_CreditoID			BIGINT(12);
DECLARE Var_Solicitud			BIGINT(20);
DECLARE Var_DiasFaltaPago			INT;
DECLARE Var_TotalSaldos				DECIMAL(12,2);
DECLARE Var_TotalRecibido			DECIMAL(12,2);
DECLARE Var_TotalRetenido			DECIMAL(12,2);

DECLARE Var_SaldoCapVigente     DECIMAL(12,2);
DECLARE Var_SaldoCapExigible    DECIMAL(12,2);
DECLARE Var_SaldoInteres        DECIMAL(12,2);
DECLARE Var_MoratorioPagado     DECIMAL(12,2);
DECLARE Var_ComFalPagPagada     DECIMAL(12,2);
DECLARE Var_ProvisionAcum       DECIMAL(12,2);
DECLARE Var_MontoFondeo         DECIMAL(12,2);
DECLARE Var_IntOrdRetenido      DECIMAL(12,2);
DECLARE Var_IntMorRetenido      DECIMAL(12,2);
DECLARE Var_ComFalPagRetenido   DECIMAL(12,2);
DECLARE Var_SaldoIntMora   		DECIMAL(12,2);
DECLARE Var_CapCtaOrden			DECIMAL(14,2);
DECLARE	Var_IntCtaOrden			DECIMAL(14,2);

/* Declaracion de Constantes */
DECLARE Entero_Cero			INT;
DECLARE Lis_Cliente			INT;
DECLARE Lis_Credito  		INT;
DECLARE Lis_Solicitud		INT;
DECLARE Lis_SalyPagos		INT;
DECLARE Lis_Castigo			INT;
DECLARE Lis_XInvCliente		INT;

DECLARE EstatusVigente		CHAR(1);
DECLARE EstatusAtras		CHAR(1);
DECLARE EstatusVencido		CHAR(1);
DECLARE EstatusPagado		CHAR(1);

/* Asignacion de Constantes */
SET Entero_Cero     := 0;					-- Entero cero
SET Lis_Cliente     := 1;					-- Lista Cliente
SET Lis_Credito     := 2;					-- Lista Credito
SET Lis_Solicitud   := 3;					-- Lista Solicitud
SET Lis_SalyPagos	:= 4; 					-- Lista usada en la pantalla de consulta de sados
SET Lis_Castigo		:= 5;					-- Lista Castigo
SET Lis_XInvCliente		:= 6; 				-- Lista en pantalla de Seguimiento de Op Inusuales
SET EstatusVigente  := 'V'; 				-- Estatus Vigente
SET EstatusAtras    := 'A';					-- Estatus Atrasado
SET EstatusPagado   := 'P'; 				-- Estatus Pagado
SET EstatusVencido  := 'B';					-- Estatus Vencido


IF(Par_NumLis = Lis_Cliente) THEN
	SET Var_ClienteID:=(SELECT DISTINCT(ClienteID) FROM CRWFONDEO WHERE SolFondeoID=Par_SolFondeoID);
	SELECT
		F.ClienteID,		C.NombreCompleto,	F.CreditoID,	F.SolicitudCreditoID,	F.Consecutivo,
		F.Folio,			F.CalcInteresID,	F.TasaBaseID,	F.SobreTasa,			F.TasaFija,
		F.PisoTasa,			F.TechoTasa,		F.MontoFondeo,	F.PorcentajeFondeo,		F.MonedaID,
		F.FechaInicio,		F.FechaVencimiento,	F.TipoFondeo,	F.NumCuotas,			F.PorcentajeMora,
		F.PorcentajeComisi,	F.Estatus,			F.EmpresaID,	F.Usuario,				F.FechaActual,
		F.DireccionIP,		F.ProgramaID,		F.Sucursal,		F.NumTransaccion
	FROM CRWFONDEO F
		INNER JOIN CLIENTES C ON F.ClienteID=C.ClienteID
	WHERE F.ClienteID=Var_ClienteID
	LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_Credito) THEN
	SELECT
		Fon.SolFondeoID,	Fon.ClienteID,			Cli.NombreCompleto,
		Fon.MontoFondeo,	Fon.PorcentajeFondeo
	FROM CRWFONDEO Fon
		INNER JOIN CLIENTES Cli ON Fon.ClienteID = Cli.ClienteID
	WHERE Fon.CreditoID=Par_CreditoID
		LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_Solicitud) THEN
	SELECT
		Fon.SolFondeoID,	Fon.ClienteID,			Cli.NombreCompleto,
		Fon.MontoFondeo,	Fon.PorcentajeFondeo
	FROM CRWFONDEO Fon
		INNER JOIN CLIENTES Cli ON Fon.ClienteID = Cli.ClienteID
	WHERE Fon.SolicitudCreditoID=Par_SolicitudID
		LIMIT 0, 15;
END IF;

-- 4. Consulta para la consulta de saldos del inversionista.
IF(Par_NumLis = Lis_SalyPagos) THEN

	SET Aud_FechaActual := (SELECT FechaSistema FROM PARAMETROSSIS);

	SET Var_FechaExi := (SELECT MIN(FechaExigible) FROM AMORTIZAFONDEO
						WHERE SolFondeoID  = Par_SolFondeoID
						  AND FechaExigible <= Aud_FechaActual
						  AND Estatus       != EstatusPagado);

	SET Var_FechaExi		:= IFNULL(Var_FechaExi, Aud_FechaActual);
	SET Var_DiasFaltaPago	:= DATEDIFF(Aud_FechaActual,Var_FechaExi);
	SET Var_DiasFaltaPago	:= IFNULL(Var_DiasFaltaPago,Entero_Cero);

	SELECT
		ROUND(SaldoCapVigente,2),	ROUND(SaldoCapExigible,2),
		ROUND(SaldoInteres, 2),		ROUND(MoratorioPagado, 2),
		ROUND(ComFalPagPagada, 2),	ROUND(ProvisionAcum, 2),
		ROUND(MontoFondeo, 2),		ROUND(IntOrdRetenido, 2),
		ROUND(IntMorRetenido, 2),	ROUND(ComFalPagRetenido, 2),
		ROUND(IFNULL(SaldoIntMoratorio,Entero_Cero),2),
		ROUND(IFNULL(SaldoCapCtaOrden, Entero_Cero),2),
		ROUND(IFNULL(SaldoIntCtaOrden, Entero_Cero),2)
	INTO
		Var_SaldoCapVigente,		Var_SaldoCapExigible,
		Var_SaldoInteres,			Var_MoratorioPagado,
		Var_ComFalPagPagada,		Var_ProvisionAcum,
		Var_MontoFondeo,			Var_IntOrdRetenido,
		Var_IntMorRetenido,			Var_ComFalPagRetenido,
		Var_SaldoIntMora,
		Var_CapCtaOrden,
		Var_IntCtaOrden
	FROM CRWFONDEO
		WHERE SolFondeoID = Par_SolFondeoID;

	SET Var_SaldoCapVigente     := IFNULL(Var_SaldoCapVigente, Entero_Cero);
	SET Var_SaldoCapExigible    := IFNULL(Var_SaldoCapExigible, Entero_Cero);
	SET Var_SaldoInteres        := IFNULL(Var_SaldoInteres, Entero_Cero);
	SET Var_MoratorioPagado     := IFNULL(Var_MoratorioPagado, Entero_Cero);
	SET Var_ComFalPagPagada     := IFNULL(Var_ComFalPagPagada, Entero_Cero);
	SET Var_ProvisionAcum       := IFNULL(Var_ProvisionAcum, Entero_Cero);
	SET Var_MontoFondeo         := IFNULL(Var_MontoFondeo, Entero_Cero);
	SET Var_IntOrdRetenido      := IFNULL(Var_IntOrdRetenido, Entero_Cero);
	SET Var_IntMorRetenido      := IFNULL(Var_IntMorRetenido, Entero_Cero);
	SET Var_ComFalPagRetenido   := IFNULL(Var_ComFalPagRetenido, Entero_Cero);
	SET Var_SaldoIntMora   		:= IFNULL(Var_SaldoIntMora, Entero_Cero);
	SET Var_CapCtaOrden			:= IFNULL(Var_CapCtaOrden, Entero_Cero);
	SET Var_IntCtaOrden			:= IFNULL(Var_IntCtaOrden,Entero_Cero);

	SET Var_TotalSaldos := (Var_SaldoCapVigente + Var_SaldoCapExigible + Var_SaldoInteres + Var_SaldoIntMora+
							Var_CapCtaOrden + Var_IntCtaOrden);

	SET Var_TotalRecibido := (Var_MontoFondeo - (Var_SaldoCapVigente + Var_SaldoCapExigible) +
							(Var_ProvisionAcum - Var_SaldoInteres) + Var_MoratorioPagado +
							Var_ComFalPagPagada);

	SET Var_TotalRetenido := Var_IntOrdRetenido + Var_IntMorRetenido + Var_ComFalPagRetenido;

	SELECT
		Var_DiasFaltaPago,		Var_SaldoCapVigente,	Var_SaldoCapExigible,	Var_SaldoInteres,	Var_TotalSaldos,
		(Var_MontoFondeo - (Var_SaldoCapVigente + Var_SaldoCapExigible)) AS CapRecibido,
		(Var_ProvisionAcum-Var_SaldoInteres) AS InteresRecibido,
		Var_MoratorioPagado,	Var_ComFalPagPagada,	Var_TotalRecibido,		Var_IntOrdRetenido,	Var_IntMorRetenido,
		Var_ComFalPagRetenido,	Var_TotalRetenido,		Var_SaldoIntMora,		Var_CapCtaOrden,	Var_IntCtaOrden;
END IF;

-- Lista para grid de pantalla de Castigo de Credito
IF(Par_NumLis = Lis_Castigo) THEN
	SELECT
		SolFondeoID, Cli.ClienteID,Cli.NombreCompleto,
		FORMAT(Fon.MontoFondeo,2) AS MontoFondeo,
		FORMAT(Fon.PorcentajeFondeo,6) AS Porcentaje,
		ROUND(SaldoCapVigente,2) AS SaldoCapVigente,
		ROUND(SaldoCapExigible,2) AS SaldoCapExigible ,
		ROUND(SaldoInteres, 2) AS SaldoInteres,
		ROUND(IFNULL(SaldoIntMoratorio,Entero_Cero),2) AS SaldoIntMoratorio,
		ROUND(IFNULL(SaldoCapCtaOrden, Entero_Cero),2) AS CapitalCtaOrden,
		ROUND(IFNULL(SaldoIntCtaOrden, Entero_Cero),2) AS InteresCtaOrden,
		ROUND(ProvisionAcum, 2) AS ProvisionAcum,
		ROUND(MontoFondeo, 2) AS MontoFondeo
	FROM CRWFONDEO Fon
		INNER JOIN CLIENTES Cli ON Fon.ClienteID = Cli.ClienteID
	WHERE CreditoID = Par_CreditoID;
END IF;

IF(Par_NumLis = Lis_XInvCliente) THEN
	SELECT
		CreditoID,		SolicitudCreditoID,		CuentaAhoID,	FechaInicio,	FechaVencimiento,
		FORMAT(MontoFondeo,2) AS MontoFondeo,	FORMAT(PorcentajeFondeo,4) AS PorcentajeFondeo,
		CASE Estatus
			WHEN 'N' THEN 'Vigente o en Proceso'
			WHEN 'P' THEN 'Pagada'
			WHEN 'V' THEN 'Vencida'
			ELSE ''
		END AS Estatus
	FROM CRWFONDEO AS Fond
	WHERE Fond.ClienteID = Par_ClienteID;
END IF;

END TerminaStore$$