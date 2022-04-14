-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONESCON`;

DELIMITER $$
CREATE PROCEDURE `APORTACIONESCON`(
	# =======================================================
	# -- SP PARA CONSULTAR INFORMACION DE LOS APORTACIONES---
	# =======================================================
	Par_AportacionID		INT(11),		-- NÚMERO DE APORTACIÓN.
	Par_TipoAportacionID	INT(11),		-- Tipo Aportacion
	Par_ClienteID		    INT(11),		-- NÚMERO DE CLIENTE.
	Par_TipoConsulta	    INT(11),		-- NÚMERO DE CONSULTA
	/* Parámetros de Auditoría */
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
	DECLARE Var_AportMadreID		INT(11);
	DECLARE Var_MontosAnclados		DECIMAL(18,2);
	DECLARE Var_InteresesAnclados	DECIMAL(18,2);
	DECLARE Var_AportacionAncID		INT(11);
	DECLARE Var_NuevaTasa			DECIMAL(18,4);
	DECLARE Var_InteresRetener		DECIMAL(18,4);
	DECLARE Var_FechaAmorVig		DATE;
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_BancaPatrimonial	CHAR(1);
	DECLARE Var_TipoPagoInt			CHAR(1);
	DECLARE Var_EstatusISR			CHAR(1);
    DECLARE Var_Comentarios			INT(11);			-- Comentarios de las aportaciones especiales
    DECLARE Var_MaxPuntos			DECIMAL(12,2);		-- Maximo de puntos permitidos para tasa de aportacion
    DECLARE Var_MinPuntos			DECIMAL(12,2);		-- Minimo de puntos permitidos para tasa de aportacion
    DECLARE Var_PerfilAutAport		INT(11);			-- Perfil del usuario que puede autorizar aportaciones especiales
	DECLARE Var_TipoAportID			INT(11);
	DECLARE Var_AportConsID			INT(11);
	DECLARE Var_ExisteCons			CHAR(1);
	DECLARE Var_AmortizacionID		INT(11);
	DECLARE Var_CapitalAmo			DECIMAL(18,2);
	DECLARE Var_InteresGenAmo		DECIMAL(18,2);
	DECLARE Var_InteresRetAmo		DECIMAL(18,2);
	DECLARE Var_InteresTotAmo		DECIMAL(18,2);
	DECLARE Var_TotalRecibirAm		DECIMAL(18,2);

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(1);
	DECLARE Con_Principal			INT(1);
	DECLARE Con_NumAports			INT(11);
	DECLARE Con_CheckList   		INT(11);
	DECLARE Con_Reinvertir			INT(1);
	DECLARE Con_Anclaje				INT(1);
	DECLARE Con_MontosAnclados		INT(1);
	DECLARE Con_AportVenAnt			INT(1);
	DECLARE Con_AportCliente		INT(1);
	DECLARE Con_AportConsolida		INT(11);
	DECLARE Con_AportClienteVen		INT(11);
	DECLARE Esta_Vigente			CHAR(1);
	DECLARE Esta_Activo				CHAR(1);
	DECLARE	DesCapital				VARCHAR(50);
	DECLARE DesCapitalInteres		VARCHAR(50);
	DECLARE DesNoAplica				VARCHAR(50);
	DECLARE Capital					CHAR(2);
	DECLARE CapitalInteres			CHAR(2);
	DECLARE NoAplica				CHAR(2);
	DECLARE Str_SI					CHAR(1);
	DECLARE Str_NO					CHAR(1);
	DECLARE PagoIntAlVen			CHAR(1);
	DECLARE PagoIntFinMes			CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;				-- Constante cero
	SET Con_Principal		:= 1;				-- Consulta principal
	SET Con_NumAports		:= 3;				-- Consulta el número total de aps
	SET Con_CheckList       := 4;
	SET Con_Reinvertir		:= 5;				-- Consulta para Renversion Manual
	SET Con_Anclaje			:= 6;
	SET Con_MontosAnclados	:= 7;
	SET Con_AportVenAnt		:= 9;
	SET Con_AportCliente	:= 10;				-- Consulta el monto global x cliente
	SET Con_AportConsolida	:= 11;				-- Consulta aportaciones consolidadas
	SET Con_AportClienteVen	:= 12;				-- Consulta el monto global x cliente al vencimiento
	SET Esta_Vigente		:='N';				-- Estatus Vigente
	SET Esta_Activo			:='A';				-- Estatus Activo
	SET DesCapital			:= 'SOLO CAPITAL';
	SET DesCapitalInteres	:= 'CAPITAL MAS INTERESES';
	SET DesNoAplica			:= 'NO APLICA';
	SET Capital				:= 'C';
	SET CapitalInteres		:= 'CI';
	SET NoAplica			:= 'N';
	SET Str_SI				:= 'S';				-- Constante SI
	SET Str_NO				:= 'N';				-- Constante NO
	SET PagoIntAlVen		:= 'V';				-- Pago de interes al vencimiento
	SET PagoIntFinMes		:= 'F';				-- Pago de interes a fin de mes
	SET Cadena_Vacia		:= '';				-- Cadena vacia

	SELECT	FechaSistema
	INTO	Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT 1;

	IF(Par_TipoConsulta = Con_Principal)THEN
		SET Var_AportMadreID :=	(SELECT 	AportacionOriID
									FROM 	APORTANCLAJE
									WHERE	AportacionAncID = Par_AportacionID);
		SET Var_AportMadreID :=	IFNULL(Var_AportMadreID,Entero_Cero);
		SET Var_EstatusISR := (SELECT Estatus FROM ISRPARAM ORDER BY FechaActual DESC LIMIT 1);
		SET Var_EstatusISR := IFNULL(Var_EstatusISR, Cadena_Vacia);

        -- seccion para obtener el numero de comentarios de cambio de tasa de la aportacion
        SELECT COUNT(AportacionID) INTO Var_Comentarios
        FROM CAMBIOTASAAPORT
        WHERE AportacionID=Par_AportacionID;
        SET Var_Comentarios := IFNULL(Var_Comentarios, Entero_Cero);

        -- Consulta para obtener el maximo y minimo de puntos permitidos para la oportacion
        SELECT tip.MaxPuntos, tip.MinPuntos
        INTO Var_MaxPuntos,Var_MinPuntos
		FROM APORTACIONES ap
			INNER JOIN TIPOSAPORTACIONES tip ON ap.TipoAportacionID=tip.TipoAportacionID
		WHERE ap.AportacionID=Par_AportacionID;
        SET Var_MaxPuntos := IFNULL(Var_MaxPuntos, Entero_Cero);
        SET Var_MinPuntos := IFNULL(Var_MinPuntos, Entero_Cero);

        -- Consulta para obtener el perfil del usuario que puede autorizar aportaciones especiales
        SELECT PerfilAutEspAport
        INTO Var_PerfilAutAport
        FROM PARAMETROSSIS;
        SET Var_PerfilAutAport := IFNULL(Var_PerfilAutAport, Entero_Cero);

		# DATOS DE LA CONSOLIDACIÓN.
		SET Var_AportConsID := (SELECT AportacionID FROM APORTCONSOLIDADAS WHERE AportConsID = Par_AportacionID LIMIT 1);
		/* INICIO DE TOTAL A PAGAR DE LA APORTACIÓN DE ACUERDO A SU CALENDARIO DE PAGOS (AMORTIZACIONES).*/
		# SE OBTIENE LA ÚLTIMA CUOTA.
		SET Var_AmortizacionID := (SELECT MAX(AmortizacionID) FROM AMORTIZAAPORT WHERE AportacionID = Par_AportacionID);

		# TOTALES DE LA ÚLTIMA CUOTA.
		SELECT
			AM.Capital,		AM.Interes,			AM.InteresRetener,	ROUND((AM.Interes - AM.InteresRetener),2)
		INTO
			Var_CapitalAmo,	Var_InteresGenAmo,	Var_InteresRetAmo,	Var_InteresTotAmo
		FROM AMORTIZAAPORT AM
		WHERE AM.AportacionID = Par_AportacionID
			AND AM.AmortizacionID = Var_AmortizacionID;

		SET Var_CapitalAmo := IFNULL(Var_CapitalAmo, Entero_Cero);
		SET Var_InteresGenAmo := IFNULL(Var_InteresGenAmo, Entero_Cero);
		SET Var_InteresRetAmo := IFNULL(Var_InteresRetAmo, Entero_Cero);
		SET Var_InteresTotAmo := IFNULL(Var_InteresTotAmo, Entero_Cero);

		# TOTAL A PAGAR POR TODA LA APORTACIÓN (CAPITAL + INTERESES).
		SET Var_TotalRecibirAm := ROUND((Var_CapitalAmo + Var_InteresTotAmo),2);
		/* FIN DE TOTAL A PAGAR DE LA APORTACIÓN DE ACUERDO A SU CALENDARIO DE PAGOS (AMORTIZACIONES).*/

		SELECT		AportacionID,		TipoAportacionID,	CuentaAhoID,		ClienteID,			FechaInicio,
					FechaVencimiento,	Monto,				Plazo,				TasaFija,			SobreTasa,
					PisoTasa,			TechoTasa,			TasaISR,			TasaNeta,			InteresGenerado,
					InteresRecibir,		SaldoProvision,		ValorGat,			ValorGatReal,		EstatusImpresion,
					MonedaID,			FechaVenAnt,		(Monto + InteresRecibir) AS TotalRecibir,
					Estatus, 			FechaApertura,		TipoPagoInt,		TasaBase,			CalculoInteres,
					PlazoOriginal,		Reinversion,		Reinvertir,			Var_AportMadreID	AS AportMadreID,
					CajaRetiro,			DiasPeriodo,		PagoIntCal,			Var_EstatusISR AS EstatusISR,
					InteresRetener,
                    Var_Comentarios AS Comentarios,		Var_MaxPuntos AS MaxPuntos,	Var_MinPuntos AS MinPuntos,
                    Var_PerfilAutAport AS perfilAutoriza,
					MontoGlobal,		TasaMontoGlobal,	IncluyeGpoFam, 		DiasPago,		PagoIntCapitaliza,
                    OpcionAport,		CantidadReno,		InvRenovar,			Notas,			AperturaAport,
					IF(IFNULL(ConsolidarSaldos,Str_NO) != Str_NO,Str_SI,Str_NO) AS ConsolidarSaldos,
					Var_AportConsID AS AportConsID,			Var_TotalRecibirAm AS TotalFinal
			FROM 	APORTACIONES
			WHERE 	AportacionID = Par_AportacionID;

	END IF;


	IF(Par_TipoConsulta = Con_CheckList)THEN

		SELECT	ap.AportacionID AS AportacionID,
				ap.ClienteID AS ClienteID,
				cl.NombreCompleto AS NombreCliente,
				ap.TipoAportacionID AS TipoAportacionID,
				tc.Descripcion AS Descripcion,
				ap.Estatus AS Estatus,
				ap.FechaInicio AS FechaInicio,
				ap.FechaVencimiento AS FechaVencimiento,
				FORMAT(ap.Monto,2) AS Monto
			FROM 	APORTACIONES ap,
					CLIENTES cl,
					TIPOSAPORTACIONES tc
			WHERE 	ap.AportacionID 		= Par_AportacionID
			AND 	ap.ClienteID 	= cl.ClienteID
			AND 	ap.TipoAportacionID 	= tc.TipoAportacionID;

	END IF;

	IF(Par_TipoConsulta = Con_NumAports)THEN
		SELECT	COUNT(`AportacionID`)
			FROM 	APORTACIONES
			WHERE 	ClienteID 	= Par_ClienteID
			AND 	Estatus		= Esta_Vigente;

	END IF;

	IF(Par_TipoConsulta = Con_Reinvertir) THEN

		SELECT 	IFNULL(SUM(IFNULL(ap.Monto,Entero_Cero)),Entero_Cero) AS MontosAnclados
				INTO	Var_MontosAnclados
			FROM 	APORTANCLAJE anc
					INNER JOIN APORTACIONES ap ON anc.AportacionAncID = ap.AportacionID AND ap.Estatus = Esta_Vigente
			WHERE 	anc.AportacionOriID = Par_AportacionID;


		SELECT 	IFNULL(SUM(IFNULL(Amo.SaldoProvision,Entero_Cero)),Entero_Cero) AS MontosAnclados,
				SUM(Amo.ISRCal)
				INTO	Var_InteresesAnclados, Var_InteresRetener
			FROM 	APORTANCLAJE anc
					INNER JOIN APORTACIONES ap ON anc.AportacionAncID = ap.AportacionID AND ap.Estatus = Esta_Vigente
					INNER JOIN AMORTIZAAPORT AS Amo ON ap.AportacionID=Amo.AportacionID  AND Amo.Estatus = Esta_Vigente
			WHERE 	anc.AportacionOriID = Par_AportacionID ;

		SET Var_InteresRetener 		:=IFNULL(Var_InteresRetener,Entero_Cero);
		SET Var_InteresesAnclados 	:= IFNULL(Var_InteresesAnclados,Entero_Cero);
		SET Var_InteresesAnclados 	:= Var_InteresesAnclados - Var_InteresRetener;

        -- seccion para obtener el numero de comentarios de cambio de tasa de la aportacion
        SELECT COUNT(AportacionID) INTO Var_Comentarios
        FROM CAMBIOTASAAPORT
        WHERE AportacionID=Par_AportacionID;
        SET Var_Comentarios := IFNULL(Var_Comentarios, Entero_Cero);

        -- Consulta para obtener el perfil del usuario que puede autorizar aportaciones especiales
        SELECT PerfilAutEspAport
        INTO Var_PerfilAutAport
        FROM PARAMETROSSIS;
        SET Var_PerfilAutAport := IFNULL(Var_PerfilAutAport, Entero_Cero);


		SELECT	ap.AportacionID,		ap.TipoAportacionID,	ap.CuentaAhoID,		ap.ClienteID,		ap.FechaInicio,
				ap.FechaVencimiento,	ap.Monto,				ap.Plazo,			ap.TasaFija,		ap.TasaISR,
				ap.TasaNeta,			ap.CalculoInteres,		ap.TasaBase,		ap.SobreTasa,		ap.PisoTasa,
				ap.TechoTasa,			ap.InteresGenerado,
				((Amo.SaldoProvision - Amo.ISRCal)+Var_InteresesAnclados) AS InteresRecibir,
				ap.ValorGat,			ap.ValorGatReal,
				ap.MonedaID,			ap.Estatus,			ap.TipoPagoInt,	ap.Reinvertir AS Reinvertir,
				CASE ap.Reinvertir	WHEN Capital		THEN DesCapital
										WHEN CapitalInteres	THEN DesCapitalInteres
										WHEN NoAplica		THEN DesNoAplica END AS DesReinveritr,		ap.PlazoOriginal,
				ap.Reinversion,		ap.CajaRetiro, (IFNULL(Var_MontosAnclados,Entero_Cero) +ap.Monto) AS MontosAnclados,
				ap.DiasPeriodo,		ap.PagoIntCal, Var_Comentarios AS Comentarios, Var_PerfilAutAport AS perfilAutoriza,
                AportacionRenovada,	ap.MontoGlobal,ap.TasaMontoGlobal,ap.IncluyeGpoFam, ap.DiasPago, ap.PagoIntCapitaliza
			FROM 	APORTACIONES ap
					LEFT JOIN APORTANCLAJE AS Cd ON ap.AportacionID =Cd.AportacionAncID
					INNER JOIN AMORTIZAAPORT AS Amo ON ap.AportacionID=Amo.AportacionID
			WHERE 	ap.AportacionID = Par_AportacionID AND Cd.AportacionAncID IS NULL
			AND 	Amo.Estatus = 'N';
	END IF;

	IF(Par_TipoConsulta = Con_MontosAnclados) THEN

		SELECT IFNULL(SUM(ap.Monto),Entero_Cero) AS MontosAnclados, IFNULL(SUM(ap.InteresRecibir),Entero_Cero) AS InteresAnclados
			FROM 	APORTANCLAJE anc
					INNER JOIN APORTACIONES ap ON anc.AportacionAncID = ap.AportacionID AND ap.Estatus = Esta_Vigente
			WHERE 	anc.AportacionOriID	= Par_AportacionID;

	END IF;

	IF(Par_TipoConsulta = Con_Anclaje)THEN

		SET Var_AportMadreID	:=	(SELECT AportacionOriID FROM APORTANCLAJE WHERE AportacionAncID = Par_AportacionID);

		SET Var_AportMadreID	:=	IFNULL(Var_AportMadreID,Entero_Cero);

		SELECT 	IFNULL(SUM(ap.Monto),Entero_Cero) AS MontosAnclados
				INTO	Var_MontosAnclados
			FROM	APORTANCLAJE anc
					INNER JOIN APORTACIONES ap ON anc.AportacionAncID = ap.AportacionID
			WHERE 	anc.AportacionOriID	= Par_AportacionID;

		SELECT 	MAX(AportacionAncID)
				INTO	Var_AportacionAncID
			FROM 	APORTANCLAJE anc
					INNER JOIN APORTACIONES ap ON anc.AportacionAncID = ap.AportacionID AND ap.Estatus = 'N'
			WHERE 	anc.AportacionOriID = Par_AportacionID;

		SELECT 	anc.NuevaTasa
				INTO	Var_NuevaTasa
			FROM 	APORTANCLAJE anc
					INNER JOIN APORTACIONES ap ON anc.AportacionAncID = ap.AportacionID AND ap.Estatus = 'N'
			WHERE 	anc.AportacionOriID = Par_AportacionID
			  AND    anc.AportacionAncID = Var_AportacionAncID;

		SET Var_AportacionAncID	:=	IFNULL(Var_AportacionAncID,Entero_Cero);
		SET Var_NuevaTasa	:=	IFNULL(Var_NuevaTasa,Entero_Cero);


		SELECT	ap.AportacionID,		ap.CuentaAhoID,		ap.TipoAportacionID,	ap.FechaVencimiento,	ap.Monto,
				ap.TasaFija,			ap.Estatus,			ap.ClienteID,			ap.MonedaID,			ap.Plazo,
				ap.TasaBase,			ap.SobreTasa,		ap.PisoTasa,			ap.TechoTasa,			ap.CalculoInteres,
				ap.PlazoOriginal,		ap.InteresGenerado,	ap.InteresRetener,		ap.InteresRecibir,		ap.ValorGat,
				ap.ValorGatReal,		Var_AportMadreID,		(ap.Monto+Var_MontosAnclados) AS MontosAnclados,	Var_NuevaTasa AS NuevaTasa,
				ap.CajaRetiro
			FROM 	APORTACIONES ap
				WHERE 	ap.AportacionID = Par_AportacionID;

	END IF;

	IF(Par_TipoConsulta = Con_AportVenAnt)THEN
		SET Var_AportMadreID :=	(SELECT AportacionOriID
									FROM APORTANCLAJE
									WHERE AportacionAncID = Par_AportacionID);
		SET Var_AportMadreID :=	IFNULL(Var_AportMadreID,Entero_Cero);

		SELECT	MIN(FechaInicio) INTO 	Var_FechaAmorVig
			FROM 	AMORTIZAAPORT
			WHERE 	AportacionID=Par_AportacionID
			AND 	Estatus=Esta_Vigente;

		SET Var_InteresRetener := IFNULL(Var_InteresRetener,Entero_Cero);

        -- seccion para obtener el numero de comentarios de cambio de tasa de la aportacion
        SELECT COUNT(AportacionID) INTO Var_Comentarios
        FROM CAMBIOTASAAPORT
        WHERE AportacionID=Par_AportacionID;
        SET Var_Comentarios := IFNULL(Var_Comentarios, Entero_Cero);

		SET Var_AportConsID := Par_ClienteID;
		SET Var_ExisteCons := Str_NO;

		# SE VALIDA SI EXISTE EN OTRO GRUPO DE CONSOLIDACIÓN.
		IF(EXISTS(SELECT * FROM APORTCONSOLIDADAS WHERE AportConsID = Par_AportacionID))THEN
			SET Var_ExisteCons := Str_SI;
		END IF;


		SELECT	AportacionID,		TipoAportacionID,	CuentaAhoID,		ClienteID,			FechaInicio,
				FechaVencimiento,	Monto,				Plazo,				TasaFija,			SobreTasa,
				PisoTasa,			TechoTasa,			TasaISR,			TasaNeta,			InteresGenerado,
				InteresRecibir,		SaldoProvision,		ValorGat,			ValorGatReal,		EstatusImpresion,
				MonedaID,			FechaVenAnt,		Var_InteresRetener AS InteresRetener,	Monto + InteresRecibir AS TotalRecibir,
				Estatus,			FechaApertura,		TipoPagoInt,		TasaBase,			CalculoInteres,
				PlazoOriginal,		Reinversion,		Reinvertir,			Var_AportMadreID	AS AportMadreID,
				CajaRetiro,			Var_FechaAmorVig AS AmorVig,			Var_Comentarios AS Comentarios,
				MontoGlobal,		TasaMontoGlobal,	IncluyeGpoFam,		DiasPago,			PagoIntCapitaliza,
				OpcionAport,		CantidadReno,		InvRenovar,			Notas,				Var_ExisteCons AS Existe
			FROM APORTACIONES
			WHERE AportacionID = Par_AportacionID;

	END IF;

	# MONTO GLOBAL DE LAS APORTACIONES VIGENTES DEL CTE. Y/O DE SU GRUPO FAMILIAR.
	IF(Par_TipoConsulta = Con_AportCliente)THEN
		SET Var_TipoAportID := Par_AportacionID;

		# RESULTADO DE LA CONSULTA.
		SELECT FNAPORTMONTOGLOBAL(Var_TipoAportID,Par_ClienteID) AS MontoGlobal;
	END IF;

	# APORTACIONES CONSOLIDADAS.
	IF(Par_TipoConsulta = Con_AportConsolida)THEN
		SET Var_AportConsID := Par_ClienteID;
		SET Var_ExisteCons := Str_NO;

		# SE VALIDA SI EXISTE EN OTRO GRUPO DE CONSOLIDACIÓN.
		IF(EXISTS(SELECT * FROM APORTCONSOLIDADAS WHERE AportacionID != Par_AportacionID AND AportConsID = Var_AportConsID))THEN
			SET Var_ExisteCons := Str_SI;
		END IF;

		# SE OBTIENE LA ÚLTIMA CUOTA.
		SET Var_AmortizacionID := (SELECT MAX(AmortizacionID) FROM AMORTIZAAPORT WHERE AportacionID = Var_AportConsID);

		# TOTALES DE LA ÚLTIMA CUOTA.
		SELECT
			AM.Capital,		AM.Interes,			AM.InteresRetener,	ROUND((AM.Interes - AM.InteresRetener),2)
		INTO
			Var_CapitalAmo,	Var_InteresGenAmo,	Var_InteresRetAmo,	Var_InteresTotAmo
		FROM AMORTIZAAPORT AM
		WHERE AM.AportacionID = Var_AportConsID
			AND AM.AmortizacionID = Var_AmortizacionID;

		SET Var_CapitalAmo := IFNULL(Var_CapitalAmo, Entero_Cero);
		SET Var_InteresGenAmo := IFNULL(Var_InteresGenAmo, Entero_Cero);
		SET Var_InteresRetAmo := IFNULL(Var_InteresRetAmo, Entero_Cero);
		SET Var_InteresTotAmo := IFNULL(Var_InteresTotAmo, Entero_Cero);

		# TOTAL A PAGAR POR TODA LA APORTACIÓN (CAPITAL + INTERESES).
		SET Var_TotalRecibirAm := ROUND((Var_CapitalAmo + Var_InteresTotAmo),2);

		SELECT
			AportacionID,	ClienteID,		Estatus,		FechaVencimiento,	Monto,
			InteresGenerado,InteresRetener,	InteresRecibir,	Reinvertir,			Var_TotalRecibirAm AS TotalFinal,
			Var_ExisteCons AS Existe
		FROM APORTACIONES
			WHERE AportacionID = Var_AportConsID;

	END IF;

	# MONTO GLOBAL DE LAS APORTACIONES VIGENTES DEL CTE. Y/O DE SU GRUPO FAMILIAR.
	IF(Par_TipoConsulta = Con_AportClienteVen)THEN

		# RESULTADO DE LA CONSULTA.
		SELECT FNAPORTMONTOGLOBALVENCIM(Par_AportacionID, Par_TipoAportacionID, Par_ClienteID) AS MontoGlobal;
	END IF;

END TerminaStore$$