-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDULACONTROLPAGOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDULACONTROLPAGOREP`;DELIMITER $$

CREATE PROCEDURE `CEDULACONTROLPAGOREP`(
/* SP DE REPORTE PARA LA SEGUNDA HOJA DEL PLAN DE PAGOS PARA SANA TUS FINANZAS*/
    Par_GrupoID			INT(11),					-- Numero del grupo
    Par_NumRep			INT(11),					-- Tipo de Reporte

    /* Parametros de Auditoria */
	Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

	)
TerminaStore:BEGIN

DECLARE	Var_Principal	INT;
DECLARE	Var_Tabla		INT;
DECLARE	Var_Bancos		INT;
DECLARE	Var_NomInsti	VARCHAR(100);
DECLARE	Var_NombGrupo	VARCHAR(50);
DECLARE	Var_Promotor	VARCHAR(50);
DECLARE	Var_Ciclo		INT;
DECLARE	Var_DomReunion	VARCHAR(500);
DECLARE	Var_FecDesem	DATE;
DECLARE	Var_CuentaUno	BIGINT;
DECLARE	Var_CuentaDos	BIGINT;
DECLARE	Var_NomCompleto	VARCHAR(50);
DECLARE	Var_MontoTot	DECIMAL(14,2);
DECLARE	Var_PagSeman	DECIMAL(14,2);
DECLARE	Var_NomPresi	VARCHAR(200);
DECLARE	Var_NomSecre	VARCHAR(200);
DECLARE	Var_NomTesore	VARCHAR(200);
DECLARE	Var_SumMontos	DECIMAL(14,2);
DECLARE	Var_SumSeman	DECIMAL(14,2);
DECLARE	Var_Increma		INT;
DECLARE Var_CreditoID	BIGINT(12);
DECLARE Var_NumRECA		VARCHAR(100);
DECLARE	TasaMora		DECIMAL(12,4);
DECLARE CargoPresi		INT;
DECLARE CargoSecre		INT;
DECLARE CargoTeso		INT;


DECLARE	Fecha_Vacia		DATE;
DECLARE	Decimal_Cero	DECIMAL(14,2);
DECLARE	Entero_Cero		INT;
DECLARE EmpresaID		INT;

SET Fecha_Vacia     := '1900-01-01';            -- Fecha Vacia
SET Decimal_Cero    := 0.0;                     -- Decimal en Cero
SET Entero_Cero     := 0;
SET	Var_Principal	:= 1;
SET	Var_Tabla		:= 2;
SET	Var_Bancos		:= 3;
SET	@Var_Increm		:= 0;
SET EmpresaID     	:=1;

-- REPORTE PLAN DE PAGOS  2DA HOJA
IF (Par_NumRep = Var_Principal) THEN

	SELECT Inst.Nombre
	INTO	Var_NomInsti
		FROM INSTITUCIONES Inst, PARAMETROSSIS Param
		WHERE Param.EmpresaID =EmpresaID
		AND Inst.InstitucionID = Param.InstitucionID
		LIMIT 1;

	SELECT GRUPOSCREDITO.NombreGrupo,GRUPOSCREDITO.CicloActual
	INTO	Var_NombGrupo,Var_Ciclo
		FROM GRUPOSCREDITO
		WHERE GRUPOSCREDITO.GrupoID= Par_GrupoID
		LIMIT 1;

	SELECT PROMOTORES.NombrePromotor
	INTO	Var_Promotor
		FROM	SOLICITUDCREDITO, PROMOTORES
		WHERE	SOLICITUDCREDITO.GrupoID = Par_GrupoID
		AND		SOLICITUDCREDITO.PromotorID = PROMOTORES.PromotorID
		LIMIT 1;

	SELECT	DirCli.DireccionCompleta
	INTO	Var_DomReunion
		FROM	DIRECCLIENTE DirCli, INTEGRAGRUPOSCRE	InteGrup,
			SOLICITUDCREDITO	SolCre
		WHERE	SolCre.GrupoID = Par_GrupoID
		AND	 SolCre.ClienteID = InteGrup.ClienteID
		AND	InteGrup.Cargo = 1
		AND DirCli.ClienteID = InteGrup.ClienteID
		AND	DirCli.Oficial='S'
		LIMIT 1;


	SELECT	ROUND(SUM(AMO.Capital+AMO.Interes+AMO.IVAInteres),2)  AS MontoCuota, SUM(CRE.MontoCredito)
	INTO	Var_SumSeman,						Var_SumMontos
		FROM  CREDITOS CRE, INTEGRAGRUPOSCRE,AMORTICREDITO AMO
		WHERE	INTEGRAGRUPOSCRE.GrupoID = Par_GrupoID
		AND	CRE.SolicitudCreditoID = INTEGRAGRUPOSCRE.SolicitudCreditoID
		AND AMO.CreditoID = CRE.CreditoID AND AMO.AmortizacionID = 1;

	SELECT IF(TipCobComMorato = 'N',(SOLICITUDCREDITO.TasaFija*PRODUCTOSCREDITO.FactorMora)/100 ,PRODUCTOSCREDITO.FactorMora)
      INTO TasaMora
		FROM PRODUCTOSCREDITO, SOLICITUDCREDITO,INTEGRAGRUPOSCRE
			WHERE SOLICITUDCREDITO.GrupoID = Par_GrupoID
				AND	SOLICITUDCREDITO.ProductoCreditoID=PRODUCTOSCREDITO.ProducCreditoID
				AND	SOLICITUDCREDITO.SolicitudCreditoID = INTEGRAGRUPOSCRE.SolicitudCreditoID
		LIMIT 1;

	SET TasaMora := ROUND(TasaMora,4);

	SELECT	Cli.NombreCompleto,	Cre.FechaMinistrado,	Cre.CreditoID
	INTO	Var_NomPresi,		Var_FecDesem,			Var_CreditoID
		FROM	CLIENTES Cli, INTEGRAGRUPOSCRE G, SOLICITUDCREDITO Sol, CREDITOS Cre
		WHERE	Sol.GrupoID = Par_GrupoID
		AND	 Sol.SolicitudCreditoID = G.SolicitudCreditoID
		AND	G.Cargo = 1
		AND Cli.ClienteID = G.ClienteID
		AND Sol.CreditoID	=	Cre.CreditoID
        AND G.GrupoID=Sol.GrupoID;

	SELECT	ProdCre.RegistroRECA
    INTO	Var_NumRECA
 	FROM	PRODUCTOSCREDITO	ProdCre,
			CREDITOS			Cred
    WHERE	Cred.CreditoID 			=	Var_CreditoID
    AND		Cred.ProductoCreditoID	=	ProdCre.ProducCreditoID
    LIMIT 1;

	SELECT	CLIENTES.NombreCompleto
	INTO	Var_NomSecre
		FROM	CLIENTES, INTEGRAGRUPOSCRE, SOLICITUDCREDITO,
				CREDITOS
		WHERE	SOLICITUDCREDITO.GrupoID = Par_GrupoID
		AND	 SOLICITUDCREDITO.SolicitudCreditoID = SOLICITUDCREDITO.SolicitudCreditoID
		AND	INTEGRAGRUPOSCRE.Cargo = 2
		AND CLIENTES.ClienteID = INTEGRAGRUPOSCRE.ClienteID
        AND INTEGRAGRUPOSCRE.SolicitudCreditoID=SOLICITUDCREDITO.SolicitudCreditoID
        AND	 SOLICITUDCREDITO.CreditoID = CREDITOS.CreditoID;

	SELECT	CLIENTES.NombreCompleto
	INTO	Var_NomTesore
		FROM	CLIENTES, INTEGRAGRUPOSCRE, SOLICITUDCREDITO,
				CREDITOS
		WHERE	SOLICITUDCREDITO.GrupoID = Par_GrupoID
		AND	 SOLICITUDCREDITO.SolicitudCreditoID = INTEGRAGRUPOSCRE.SolicitudCreditoID
		AND	INTEGRAGRUPOSCRE.Cargo = 3
		AND CLIENTES.ClienteID = INTEGRAGRUPOSCRE.ClienteID
        AND INTEGRAGRUPOSCRE.SolicitudCreditoID=SOLICITUDCREDITO.SolicitudCreditoID
        AND	 SOLICITUDCREDITO.CreditoID = CREDITOS.CreditoID;

    SET Var_NumRECA := UPPER(Var_NumRECA);

	# ================== OBTENEMOS LOS DATOS PARA IMPRIMIR EN EL REPORTE ====================
	SELECT	Var_NomInsti,	Var_NombGrupo,	Var_Ciclo,		Var_SumSeman,	Var_SumMontos,
			Var_NomPresi,	Var_NomSecre,	Var_NomTesore,	Var_Promotor,	Var_DomReunion,
			Var_FecDesem,	TasaMora, 		Var_NumRECA;

END IF;

-- Lista los montos por integrantes del grupo
IF	(Par_NumRep = Var_Tabla) THEN

	SELECT	@Var_Increm := @Var_Increm+1 AS Var_Increm,
    ROUND(SUM(AMO.Capital+AMO.Interes+AMO.IVAInteres),2) AS MontoCuota, Cred.MontoCredito  AS MontoAutorizado, Cli.NombreCompleto
		FROM CREDITOS	Cred, CLIENTES	Cli, INTEGRAGRUPOSCRE Ing, AMORTICREDITO AMO
		WHERE	Cred.GrupoID =Par_GrupoID
		AND	Cred.ClienteID = Cli.ClienteID
		AND Cred.SolicitudCreditoID = Ing.SolicitudCreditoID
		AND AMO.CreditoID = Cred.CreditoID AND AMO.AmortizacionID = 1
		GROUP BY AMO.CreditoID, Cred.MontoCredito, Cli.NombreCompleto;

END IF;

-- Lista los bancos en el plan de pagos
IF	(Par_NumRep = Var_Bancos) THEN

	SELECT	CuenTeso.NumCtaInstit,	Inst.NombreCorto
		FROM	CUENTASAHOTESO	CuenTeso, INSTITUCIONES	Inst
			WHERE CuenTeso.InstitucionID = Inst.InstitucionID;

END IF;
END TerminaStore$$