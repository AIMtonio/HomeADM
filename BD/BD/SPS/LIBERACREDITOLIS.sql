-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIBERACREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIBERACREDITOLIS`;DELIMITER $$

CREATE PROCEDURE `LIBERACREDITOLIS`(
	/* SP PARA LA LISTA DE CREDITOS DE LA PANTALLA LIBERACION DE CARTERA   */
	Par_FolioAsigID		INT(11),				-- Id asignacion
    Par_NumLis			TINYINT UNSIGNED,		-- Numero de lista

	Par_EmpresaID		INT(11),				-- Parametros de auditoria --
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables

	DECLARE	FechaSist			DATE;
    DECLARE Var_EstAsignacion	CHAR(1);

	-- Declaracion de constantes
    DECLARE Lis_CreditoLib		INT(11);
    DECLARE Lis_CredLibGestor	INT(11);

	DECLARE Est_Inactivo		CHAR(1);
	DECLARE Est_InactivoDes		CHAR(15);
	DECLARE Est_Autorizado		CHAR(1);
	DECLARE Est_AutorizadoDes	CHAR(15);
	DECLARE Est_Pagado			CHAR(1);
	DECLARE Est_PagadoDes		CHAR(15);
	DECLARE Est_Vigente			CHAR(1);
	DECLARE Est_VigenteDes		CHAR(15);
	DECLARE Est_Vencido			CHAR(1);
	DECLARE Est_VencidoDes		CHAR(15);
	DECLARE Est_Castigado		CHAR(1);
 	DECLARE Est_CastigadoDes	CHAR(15);
    DECLARE Entero_Cero			INT(11);
    DECLARE Cadena_Vacia		CHAR(1);
    DECLARE CredAsig_Si			CHAR(1);
    DECLARE CredAsig_No			CHAR(1);
    DECLARE EstAsigna_Activa	CHAR(1);
    DECLARE EstAsigna_Baja		CHAR(1);

    -- Asignacion de constantes
    SET Lis_CreditoLib			:= 1;
    SET Lis_CredLibGestor		:= 2;
    SET Est_Inactivo			:= 'I';
	SET Est_InactivoDes			:= 'INACTIVO';
	SET Est_Autorizado			:= 'A';
	SET Est_AutorizadoDes		:= 'AUTORIZADO';
	SET Est_Pagado				:= 'P';
	SET Est_PagadoDes			:= 'PAGADO';
	SET Est_Vigente				:= 'V';
	SET Est_VigenteDes			:= 'VIGENTE';
	SET Est_Vencido				:= 'B';
	SET Est_VencidoDes			:= 'VENCIDO';
	SET Est_Castigado			:= 'K';
 	SET Est_CastigadoDes		:= 'CASTIGADO';
    SET Entero_Cero				:= 0;
    SET Cadena_Vacia			:= '';
    SET CredAsig_Si				:= 'S';
    SET CredAsig_No				:= 'N';
    SET EstAsigna_Activa		:= 'A';
    SET EstAsigna_Baja			:= 'B';

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);


    IF(Par_NumLis = Lis_CreditoLib) THEN

		SET Var_EstAsignacion := (SELECT EstatusAsig FROM COBCARTERAASIG WHERE FolioAsigID = Par_FolioAsigID );

		SELECT	detc.ClienteID,		detc.NombreCompleto,	detc.SucursalID,		CONCAT(detc.SucursalID,"-",suc.NombreSucurs) AS NombreSucursal,		detc.CreditoID,
				CASE	WHEN detc.EstatusCred=Est_Vencido 	THEN 	Est_VencidoDes
						WHEN detc.EstatusCred=Est_Vigente 	THEN 	Est_VigenteDes
						WHEN detc.EstatusCred=Est_Castigado THEN 	Est_CastigadoDes END
				AS EstatusCred,		detc.DiasAtraso,		detc.MontoCredito,		detc.FechaDesembolso,	detc.FechaVencimien,
				FNFECHAPROXPAG(cre.CreditoID) AS FechaProxVencim,	detc.SaldoCapital,	detc.SaldoInteres,		detc.SaldoMoratorio,
                CASE	WHEN cre.Estatus=Est_Inactivo 	THEN 	Est_InactivoDes
						WHEN cre.Estatus=Est_Autorizado THEN 	Est_AutorizadoDes
						WHEN cre.Estatus=Est_Pagado 	THEN 	Est_PagadoDes
                        WHEN cre.Estatus=Est_Vencido 	THEN 	Est_VencidoDes
						WHEN cre.Estatus=Est_Vigente 	THEN 	Est_VigenteDes
						WHEN cre.Estatus=Est_Castigado THEN 	Est_CastigadoDes END
				AS EstatusCredLib,
                FUNCIONDIASATRASO(detc.CreditoID,FechaSist) AS DiasAtrasoLib,
                IFNULL(SUM(amo.SaldoCapVigente	+ amo.SaldoCapAtrasa + amo.SaldoCapVencido	+ amo.SaldoCapVenNExi),Entero_Cero) AS SaldoCapitalLib,
                IFNULL(SUM(amo.SaldoInteresPro + amo.SaldoInteresAtr + amo.SaldoInteresVen + amo.SaldoIntNoConta),Entero_Cero) AS SaldoInteresLib,
                IFNULL(SUM(amo.SaldoMoratorios + amo.SaldoMoraVencido),Entero_Cero) AS SaldoMoratorioLib, detc.MotivoLiberacion,
				detc.CredAsignado AS Asignado
		FROM DETCOBCARTERAASIG detc
			LEFT JOIN AMORTICREDITO amo
				ON detc.CreditoID = amo.CreditoID
			LEFT JOIN CREDITOS cre
				ON detc.CreditoID = cre.CreditoID
			LEFT JOIN SUCURSALES suc
				ON detc.SucursalID = suc.SucursalID
		WHERE detc.FolioAsigID = Par_FolioAsigID
				AND detc.CredAsignado = CASE WHEN Var_EstAsignacion = EstAsigna_Activa THEN CredAsig_Si
												WHEN Var_EstAsignacion = EstAsigna_Baja THEN CredAsig_No END
        GROUP BY amo.CreditoID, 		detc.ClienteID,			detc.NombreCompleto,	detc.SucursalID, 		detc.CreditoID,
				 detc.EstatusCred,		detc.DiasAtraso,		detc.MontoCredito,		detc.FechaDesembolso,	detc.FechaVencimien,
				 detc.SaldoCapital,		detc.SaldoInteres,		detc.SaldoMoratorio, 	cre.Estatus, 			detc.MotivoLiberacion,
				 detc.CredAsignado;


    END IF;

    IF(Par_NumLis = Lis_CredLibGestor) THEN

		SELECT	detc.ClienteID,		detc.NombreCompleto,	detc.SucursalID,		CONCAT(detc.SucursalID,"-",suc.NombreSucurs) AS NombreSucursal,		detc.CreditoID,
				CASE	WHEN detc.EstatusCred=Est_Vencido 	THEN 	Est_VencidoDes
						WHEN detc.EstatusCred=Est_Vigente 	THEN 	Est_VigenteDes
						WHEN detc.EstatusCred=Est_Castigado THEN 	Est_CastigadoDes END
				AS EstatusCred,		detc.DiasAtraso,		detc.MontoCredito,		detc.FechaDesembolso,	detc.FechaVencimien,
				FNFECHAPROXPAG(cre.CreditoID) AS FechaProxVencim, detc.SaldoCapital,	detc.SaldoInteres,		detc.SaldoMoratorio,
                CASE	WHEN cre.Estatus=Est_Inactivo 	THEN 	Est_InactivoDes
						WHEN cre.Estatus=Est_Autorizado THEN 	Est_AutorizadoDes
						WHEN cre.Estatus=Est_Pagado 	THEN 	Est_PagadoDes
                        WHEN cre.Estatus=Est_Vencido 	THEN 	Est_VencidoDes
						WHEN cre.Estatus=Est_Vigente 	THEN 	Est_VigenteDes
						WHEN cre.Estatus=Est_Castigado THEN 	Est_CastigadoDes END
				AS EstatusCredLib,
                FUNCIONDIASATRASO(detc.CreditoID,FechaSist) AS DiasAtrasoLib,
                IFNULL(SUM(amo.SaldoCapVigente	+ amo.SaldoCapAtrasa + amo.SaldoCapVencido	+ amo.SaldoCapVenNExi),Entero_Cero) AS SaldoCapitalLib,
                IFNULL(SUM(amo.SaldoInteresPro + amo.SaldoInteresAtr + amo.SaldoInteresVen + amo.SaldoIntNoConta),Entero_Cero) AS SaldoInteresLib,
                IFNULL(SUM(amo.SaldoMoratorios + amo.SaldoMoraVencido),Entero_Cero) AS SaldoMoratorioLib, detc.MotivoLiberacion,
				detc.CredAsignado AS Asignado
		FROM DETCOBCARTERAASIG detc
			LEFT JOIN AMORTICREDITO amo
				ON detc.CreditoID = amo.CreditoID
			LEFT JOIN CREDITOS cre
				ON detc.CreditoID = cre.CreditoID
			LEFT JOIN SUCURSALES suc
				ON detc.SucursalID = suc.SucursalID
		WHERE detc.FolioAsigID = Par_FolioAsigID
			AND detc.CredAsignado = CredAsig_No
        GROUP BY amo.CreditoID, 		detc.ClienteID,			detc.NombreCompleto,	detc.SucursalID, 		detc.CreditoID,
				 detc.EstatusCred,		detc.DiasAtraso,		detc.MontoCredito,		detc.FechaDesembolso,	detc.FechaVencimien,
				 detc.SaldoCapital,		detc.SaldoInteres,		detc.SaldoMoratorio, 	cre.Estatus, 			detc.MotivoLiberacion,
				 detc.CredAsignado;


    END IF;
END TerminaStore$$