-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESCON`;DELIMITER $$

CREATE PROCEDURE `CEDESCON`(
# =======================================================
# ------ SP PARA CONSULTAR INFORMACION DE LOS CEDES------
# =======================================================
	Par_CedeID		    	INT(11),
	Par_ClienteID		    INT(11),
	Par_TipoConsulta	    INT(11),

	Par_EmpresaID		    INT(11),
	Par_UsuarioID		    INT(11),
	Par_Fecha				DATE,
	Par_DireccionIP		    VARCHAR(15),
	Par_ProgramaID		    VARCHAR(50),
	Par_Sucursal			INT(11),
	Par_NumeroTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CedeMadreID			INT(11);
	DECLARE Var_MontosAnclados		DECIMAL(18,2);
	DECLARE Var_InteresesAnclados	DECIMAL(18,2);
	DECLARE Var_CedeAncID			INT(11);
	DECLARE Var_NuevaTasa			DECIMAL(18,4);
	DECLARE Var_InteresRetener		DECIMAL(18,4);
	DECLARE Var_FechaAmorVig		DATE;
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_BancaPatrimonial	CHAR(1);
	DECLARE Var_TipoPagoInt			CHAR(1);
	DECLARE Var_EstatusISR			CHAR(1);

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(1);
	DECLARE Con_Principal			INT(1);
	DECLARE Con_NumCedes			INT(11);
	DECLARE Con_CheckList   		INT(11);
	DECLARE Con_Reinvertir			INT(1);
	DECLARE Con_Anclaje				INT(1);
	DECLARE Con_MontosAnclados		INT(1);
	DECLARE Con_CedeVenAnt			INT(1);
	DECLARE Esta_Vigente			CHAR(1);
	DECLARE Esta_Activo				CHAR(1);
	DECLARE	DesCapital				VARCHAR(50);
	DECLARE DesCapitalInteres		VARCHAR(50);
	DECLARE DesNoAplica				VARCHAR(50);
	DECLARE Capital					CHAR(2);
	DECLARE CapitalInteres			CHAR(2);
	DECLARE NoAplica				CHAR(2);
	DECLARE Str_SI					CHAR(1);
	DECLARE PagoIntAlVen			CHAR(1);
	DECLARE PagoIntFinMes			CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;				-- Constante cero
	SET Con_Principal		:= 1;				-- Consulta principal
	SET Con_NumCedes		:= 3;				-- Consulta el número total de cedes
	SET Con_CheckList       := 4;
	SET Con_Reinvertir		:= 5;				-- Consulta para Renversion Manual
	SET Con_Anclaje			:= 6;
	SET Con_MontosAnclados	:= 7;
	SET Con_CedeVenAnt		:= 9;
	SET Esta_Vigente		:='N';				-- Estatus Vigente
	SET Esta_Activo			:='A';				-- Estatus Activo
	SET DesCapital			:= 'SOLO CAPITAL';
	SET DesCapitalInteres	:= 'CAPITAL MAS INTERESES';
	SET DesNoAplica			:= 'NO APLICA';
	SET Capital				:= 'C';
	SET CapitalInteres		:= 'CI';
	SET NoAplica			:= 'N';
	SET Str_SI				:= 'S';				-- Constante SI
	SET PagoIntAlVen		:= 'V';				-- Pago de interes al vencimiento
	SET PagoIntFinMes		:= 'F';				-- Pago de interes a fin de mes
	SET Cadena_Vacia		:= '';				-- Cadena vacia

	SELECT	FechaSistema
	INTO	Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT 1;

	IF(Par_TipoConsulta = Con_Principal)THEN
		SET Var_CedeMadreID :=	(SELECT 	CedeOriID
									FROM 	CEDESANCLAJE
									WHERE	CedeAncID = Par_CedeID);
		SET Var_CedeMadreID :=	IFNULL(Var_CedeMadreID,Entero_Cero);
		SET Var_EstatusISR := (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
		SET Var_EstatusISR := IFNULL(Var_EstatusISR, Cadena_Vacia);

		SELECT		CedeID,				TipoCedeID,			CuentaAhoID,		ClienteID,			FechaInicio,
					FechaVencimiento,	Monto,				Plazo,				TasaFija,			SobreTasa,
					PisoTasa,			TechoTasa,			TasaISR,			TasaNeta,			InteresGenerado,
					InteresRecibir,		SaldoProvision,		ValorGat,			ValorGatReal,		EstatusImpresion,
					MonedaID,			FechaVenAnt,		(Monto + InteresRecibir) AS TotalRecibir,
					Estatus, 			FechaApertura,		TipoPagoInt,		TasaBase,			CalculoInteres,
					PlazoOriginal,		Reinversion,		Reinvertir,			Var_CedeMadreID	AS CedeMadreID,
					CajaRetiro,			DiasPeriodo,		PagoIntCal,			Var_EstatusISR AS EstatusISR,
					IF(Var_EstatusISR = Esta_Activo, FNISRINFOCAL(Monto, Plazo, (TasaISR*100)), InteresRetener) AS InteresRetener
			FROM 	CEDES
			WHERE 	CedeID = Par_CedeID;

	END IF;


	IF(Par_TipoConsulta = Con_CheckList)THEN

		SELECT	cd.CedeID AS CedeID,
				cd.ClienteID AS ClienteID,
				cl.NombreCompleto AS NombreCliente,
				cd.TipoCedeID AS TipoCedeID,
				tc.Descripcion AS Descripcion,
				cd.Estatus AS Estatus,
				cd.FechaInicio AS FechaInicio,
				cd.FechaVencimiento AS FechaVencimiento,
				FORMAT(cd.Monto,2) AS Monto
			FROM 	CEDES cd,
					CLIENTES cl,
					TIPOSCEDES tc
			WHERE 	cd.CedeID 		= Par_CedeID
			AND 	cd.ClienteID 	= cl.ClienteID
			AND 	cd.TipoCedeID 	= tc.TipoCedeID;

	END IF;

	IF(Par_TipoConsulta = Con_NumCedes)THEN
		SELECT	COUNT(`CedeID`)
			FROM 	CEDES
			WHERE 	ClienteID 	= Par_ClienteID
			AND 	Estatus		= Esta_Vigente;

	END IF;

	IF(Par_TipoConsulta = Con_Reinvertir) THEN

		SELECT 	IFNULL(SUM(IFNULL(cede.Monto,Entero_Cero)),Entero_Cero) AS MontosAnclados
				INTO	Var_MontosAnclados
			FROM 	CEDESANCLAJE anc
					INNER JOIN CEDES cede ON anc.CedeAncID = cede.CedeID AND cede.Estatus = Esta_Vigente
			WHERE 	anc.CedeOriID = Par_CedeID;


		SELECT 	IFNULL(SUM(IFNULL(Amo.SaldoProvision,Entero_Cero)),Entero_Cero) AS MontosAnclados,
				SUM(Amo.ISRCal)
				INTO	Var_InteresesAnclados, Var_InteresRetener
			FROM 	CEDESANCLAJE anc
					INNER JOIN CEDES cede ON anc.CedeAncID = cede.CedeID AND cede.Estatus = Esta_Vigente
					INNER JOIN AMORTIZACEDES AS Amo ON cede.CedeID=Amo.CedeID  AND Amo.Estatus = Esta_Vigente
			WHERE 	anc.CedeOriID = Par_CedeID ;

		SET Var_InteresRetener 		:=IFNULL(Var_InteresRetener,Entero_Cero);
		SET Var_InteresesAnclados 	:= IFNULL(Var_InteresesAnclados,Entero_Cero);
		SET Var_InteresesAnclados 	:= Var_InteresesAnclados - Var_InteresRetener;


		SELECT	cede.CedeID,			cede.TipoCedeID,		cede.CuentaAhoID,	cede.ClienteID,		cede.FechaInicio,
				cede.FechaVencimiento,	cede.Monto,				cede.Plazo,			cede.TasaFija,		cede.TasaISR,
				cede.TasaNeta,			cede.CalculoInteres,	cede.TasaBase,		cede.SobreTasa,		cede.PisoTasa,
				cede.TechoTasa,			cede.InteresGenerado,
				((Amo.SaldoProvision - Amo.ISRCal)+Var_InteresesAnclados) AS InteresRecibir,
				cede.ValorGat,		cede.ValorGatReal,
				cede.MonedaID,			cede.Estatus,			cede.TipoPagoInt,	cede.Reinvertir AS Reinvertir,
				CASE cede.Reinvertir	WHEN Capital		THEN DesCapital
										WHEN CapitalInteres	THEN DesCapitalInteres
										WHEN NoAplica		THEN DesNoAplica END AS DesReinveritr,		cede.PlazoOriginal,
				cede.Reinversion,		cede.CajaRetiro, (IFNULL(Var_MontosAnclados,Entero_Cero) +cede.Monto) AS MontosAnclados,
                cede.DiasPeriodo,		cede.PagoIntCal
			FROM 	CEDES cede
					LEFT JOIN CEDESANCLAJE AS Cd ON cede.CedeID =Cd.CedeAncID
					INNER JOIN AMORTIZACEDES AS Amo ON cede.CedeID=Amo.CedeID
			WHERE 	cede.CedeID = Par_CedeID AND Cd.CedeAncID IS NULL
			AND 	Amo.Estatus = 'N';
	END IF;

	IF(Par_TipoConsulta = Con_MontosAnclados) THEN

		SELECT IFNULL(SUM(cede.Monto),Entero_Cero) AS MontosAnclados, IFNULL(SUM(cede.InteresRecibir),Entero_Cero) AS InteresAnclados
			FROM 	CEDESANCLAJE anc
					INNER JOIN CEDES cede ON anc.CedeAncID = cede.CedeID AND cede.Estatus = Esta_Vigente
			WHERE 	anc.CedeOriID	= Par_CedeID;

	END IF;

	IF(Par_TipoConsulta = Con_Anclaje)THEN

		SET Var_CedeMadreID	:=	(SELECT CedeOriID FROM CEDESANCLAJE WHERE CedeAncID = Par_CedeID);

		SET Var_CedeMadreID	:=	IFNULL(Var_CedeMadreID,Entero_Cero);

		SELECT 	IFNULL(SUM(cede.Monto),Entero_Cero) AS MontosAnclados
				INTO	Var_MontosAnclados
			FROM	CEDESANCLAJE anc
					INNER JOIN CEDES cede ON anc.CedeAncID = cede.CedeID
			WHERE 	anc.CedeOriID	= Par_CedeID;

		SELECT 	MAX(CedeAncID)
				INTO	Var_CedeAncID
			FROM 	CEDESANCLAJE anc
					INNER JOIN CEDES cede ON anc.CedeAncID = cede.CedeID AND cede.Estatus = 'N'
			WHERE 	anc.CedeOriID = Par_CedeID;

		SELECT 	anc.NuevaTasa
				INTO	Var_NuevaTasa
			FROM 	CEDESANCLAJE anc
					INNER JOIN CEDES cede ON anc.CedeAncID = cede.CedeID AND cede.Estatus = 'N'
			WHERE 	anc.CedeOriID = Par_CedeID
			  AND    anc.CedeAncID = Var_CedeAncID;

		SET Var_CedeAncID	:=	IFNULL(Var_CedeAncID,Entero_Cero);
		SET Var_NuevaTasa	:=	IFNULL(Var_NuevaTasa,Entero_Cero);


		SELECT	cede.CedeID,			cede.CuentaAhoID,		cede.TipoCedeID,		cede.FechaVencimiento,	cede.Monto,
				cede.TasaFija,			cede.Estatus,			cede.ClienteID,			cede.MonedaID,			cede.Plazo,
				cede.TasaBase,			cede.SobreTasa,			cede.PisoTasa,			cede.TechoTasa,			cede.CalculoInteres,
				cede.PlazoOriginal,		cede.InteresGenerado,	cede.InteresRetener,	cede.InteresRecibir,	cede.ValorGat,
				cede.ValorGatReal,		Var_CedeMadreID,		(cede.Monto+Var_MontosAnclados) AS MontosAnclados,	Var_NuevaTasa AS NuevaTasa,
				cede.CajaRetiro
			FROM 	CEDES cede
				WHERE 	cede.CedeID = Par_CedeID;

	END IF;

	IF(Par_TipoConsulta = Con_CedeVenAnt)THEN
		SET Var_CedeMadreID :=	(SELECT CedeOriID
									FROM CEDESANCLAJE
									WHERE CedeAncID = Par_CedeID);
		SET Var_CedeMadreID :=	IFNULL(Var_CedeMadreID,Entero_Cero);

		SELECT	MIN(FechaInicio) INTO 	Var_FechaAmorVig
			FROM 	AMORTIZACEDES
			WHERE 	CedeID=Par_CedeID
            AND 	Estatus=Esta_Vigente;

		SET Var_InteresRetener := IFNULL(Var_InteresRetener,Entero_Cero);

		SELECT	CedeID,				TipoCedeID,			CuentaAhoID,		ClienteID,			FechaInicio,
				FechaVencimiento,	Monto,				Plazo,				TasaFija,			SobreTasa,
				PisoTasa,			TechoTasa,			TasaISR,			TasaNeta,			InteresGenerado,
				InteresRecibir,		SaldoProvision,		ValorGat,			ValorGatReal,		EstatusImpresion,
				MonedaID,			FechaVenAnt,		Var_InteresRetener AS InteresRetener,	Monto + InteresRecibir AS TotalRecibir,
				Estatus,			FechaApertura,		TipoPagoInt,		TasaBase,			CalculoInteres,
				PlazoOriginal,		Reinversion,		Reinvertir,			Var_CedeMadreID	AS CedeMadreID,
				CajaRetiro,			Var_FechaAmorVig AS AmorVig
			FROM CEDES
			WHERE CedeID = Par_CedeID;

	END IF;

END TerminaStore$$