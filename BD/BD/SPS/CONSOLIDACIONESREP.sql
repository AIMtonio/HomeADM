-- CONSOLIDACIONESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSOLIDACIONESREP`;
DELIMITER $$
CREATE PROCEDURE `CONSOLIDACIONESREP`(
	-- SP PARA OBTENER DATOS DEL REPORTE DE CONSOLIDACIONES DE CREDITO
	Par_FechaInicio			DATE,				-- Fecha Inicial de Busqueda de Renovaciones
	Par_FechaFin			DATE,				-- Fecha Final de Busqueda de Renovaciones
	Par_SucursalID			INT(10),			-- Sucursal de Credito Renovado
	Par_ProductoCreditoID	INT(10),			-- Producto de Credito del Credito Renovado

	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT,				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT				-- Parametro de auditoria
)
TerminaStore:begin

	-- Declaracion de Constantes
	DECLARE Var_EsConsolidado	CHAR(1);		-- Cosntante es consolidado S
	DECLARE Var_CartaInterna	CHAR(1);		-- Constante carta interna I
	DECLARE Var_DecimalCero		DECIMAL(18,2);	-- Constante Decimal 0.0
	DECLARE Var_EstatusPagado	CHAR(1);		-- Cosntante Pagado P
	DECLARE Var_Inactivo		VARCHAR(20);	-- Cosntante

	DECLARE Var_EnteroCero		INT(11);
	DECLARE	Var_EstInactivo		CHAR(1);		-- Constante Estado Inactivo
	DECLARE	Var_EstAutorizado	CHAR(1);		-- Constante Estado Autorizado
	DECLARE	Var_EstVigente		CHAR(1);		-- Constante Estado Vigente
	DECLARE	Var_EstPagado		CHAR(1);		-- Constante Estado Pagado

	DECLARE	Var_EstCancelado 	CHAR(1);		-- Constante Consolado
	DECLARE	Var_EstVencido		CHAR(1);		-- Constante Vencido
	DECLARE	Var_EstCastigado	CHAR(1);		-- Constante Castigado
	DECLARE	Var_Autorizado		VARCHAR(20);	-- Constante texto AUTORIZADO
	DECLARE	Var_Vigente			VARCHAR(20);	-- Constante texto VIGENTE

	DECLARE	Var_Pagado			VARCHAR(20);	-- Constante texto PAGADO
	DECLARE	Var_Cancelado		VARCHAR(20);	-- Constante texto CANCELADO
	DECLARE	Var_Vencido			VARCHAR(20);	-- Constante texto VENCIDO
	DECLARE	Var_Castigado		VARCHAR(20);	-- Constante texto CASTIGADO
	DECLARE Var_CadenaVacia		CHAR(1);		-- Constante Cadena Vacia

	DECLARE Var_FechaVacia		DATE;			-- Constante Fecha Vacia
	DECLARE Var_EnteroUno		INT(11);		-- Constante Entero 1
	DECLARE Var_Separador		CHAR(1);		-- Constante Separador -

	-- Asignación de Constantes
	SET	Var_EsConsolidado	:= 'S';				-- Cosntante es consolidado S
	SET	Var_CartaInterna	:= 'I';				-- Constante carta interna I
	SET	Var_DecimalCero		:= 0.0;				-- Constante Decimal 0.0
	SET	Var_EstatusPagado	:= 'P';				-- Cosntante Pagado P
	SET	Var_EnteroCero		:= 0;				-- Entero Cero

	SET	Var_EstInactivo		:= 'I';				-- Estatus Var_Inactivo
	SET	Var_EstAutorizado	:= 'A';				-- Estatus Var_Autorizado
	SET	Var_EstVigente		:= 'V';				-- Estatus Var_Vigente
	SET	Var_EstPagado		:= 'P';				-- Estatus Var_Pagado
	SET	Var_EstCancelado	:= 'C';				-- Estatus Var_Cancelado

	SET	Var_EstVencido		:= 'B';				-- Estatus Var_Vencido
	SET	Var_EstCastigado	:= 'K';				-- Estatus Var_Cancelado
	SET	Var_Inactivo		:= 'INACTIVO';		-- Descripcion Estatus Var_Inactivo
	SET	Var_Autorizado		:= 'AUTORIZADO';	-- Descripcion Estatus Var_Autorizado
	SET	Var_Vigente			:= 'VIGENTE';		-- Descripcion Estatus Var_Vigente

	SET	Var_Pagado			:= 'PAGADO';		-- Descripcion Estatus Var_Pagado
	SET	Var_Cancelado		:= 'CANCELADO';		-- Descripcion Estatus Var_Cancelado
	SET	Var_Vencido			:= 'VENCIDO';		-- Descripcion Estatus Var_Vencido
	SET	Var_Castigado		:= 'CASTIGADO';		-- Descripcion Estatus Var_Castigado
	SET	Var_CadenaVacia		:= '';				-- Constante Cadena Vacia

	SET	Var_FechaVacia		:= '1900-01-01';	-- Constante Fecha Vacia
	SET	Var_EnteroUno		:= 1;				-- Constante Entero 1
	SET	Var_Separador		:= '-';				-- Constante Separador -

	SET	Par_FechaInicio 		:= IFNULL(Par_FechaInicio,Var_FechaVacia);
	SET	Par_FechaFin			:= IFNULL(Par_FechaFin,Var_FechaVacia);
	SET	Par_SucursalID			:= IFNULL(Par_SucursalID,Var_EnteroCero);
	SET	Par_ProductoCreditoID	:= IFNULL(Par_ProductoCreditoID,Var_EnteroCero);

	DROP TABLE IF EXISTS TMPCONSOLIDACIONESREP;
	CREATE TEMPORARY TABLE TMPCONSOLIDACIONESREP(
		ClienteID			INT(11),
		NombreCompleto		VARCHAR(200),
		CreditoOrigenID		VARCHAR(200),
		CreditoDestinoID	BIGINT(12),
		ProductoCreditoID	INT(4),
		ProductoDestino		VARCHAR(100),
		FechaMinistrado		DATE,
		Estatus				VARCHAR(20),
		EstatusActual		VARCHAR(20),
		MontoOriginal		DECIMAL(12,2),
		NumPagoSoste		INT,
		SaldoTotalCapital	DECIMAL(12,2),
		SaldoInteresTotal	DECIMAL(12,2),
		SaldoMoratorioTotal	DECIMAL(12,2),
		Hora				TIME,
		SucursalID			INT(11),
		NombreSucurs		VARCHAR(50),
		PRIMARY KEY (CreditoDestinoID)
	);

	INSERT INTO TMPCONSOLIDACIONESREP (
				ClienteID,				NombreCompleto,		CreditoOrigenID,	CreditoDestinoID,	ProductoCreditoID,
				ProductoDestino,
				FechaMinistrado,
				Estatus,
				EstatusActual,
				MontoOriginal,			NumPagoSoste,		SaldoTotalCapital,
				SaldoInteresTotal,
				SaldoMoratorioTotal,
				Hora,					SucursalID,			NombreSucurs)
		SELECT 	Cre.ClienteID,			Cli.NombreCompleto,	Var_CadenaVacia,	Cre.CreditoID,		Cre.ProductoCreditoID,
				CONCAT(Cre.ProductoCreditoID,'-',Prod.Descripcion),
				Cre.FechaMinistrado,
				CASE Liq.EstatusCreacion
					WHEN Var_EstInactivo THEN Var_Inactivo
					WHEN Var_EstAutorizado THEN Var_Autorizado
					WHEN Var_EstVigente THEN Var_Vigente
					WHEN Var_EstPagado THEN Var_Pagado
					WHEN Var_EstCancelado THEN Var_Cancelado
					WHEN Var_EstVencido THEN Var_Vencido
					WHEN Var_EstCastigado THEN Var_Castigado
					ELSE Var_Vencido
				END AS EstatusActual,
				CASE Cre.Estatus
					WHEN Var_EstInactivo THEN Var_Inactivo
					WHEN Var_EstAutorizado THEN Var_Autorizado
					WHEN Var_EstVigente THEN Var_Vigente
					WHEN Var_EstPagado THEN Var_Pagado
					WHEN Var_EstCancelado THEN Var_Cancelado
					WHEN Var_EstVencido THEN Var_Vencido
					WHEN Var_EstCastigado THEN Var_Castigado
				END AS EstatusActual,
				Cre.MontoCredito,		Liq.NumPagoSoste,	IFNULL(SUM(Amo.SaldoCapVigente + Amo.SaldoCapAtrasa + Amo.SaldoCapVencido + Amo.SaldoCapVenNExi),Var_DecimalCero),
				IFNULL(SUM(Amo.SaldoInteresOrd + Amo.SaldoInteresAtr + Amo.SaldoInteresVen + Amo.SaldoInteresPro + Amo.SaldoIntNoConta + Amo.SaldoIVAInteres),Var_DecimalCero),
				IFNULL(SUM(Amo.SaldoMoratorios + Amo.SaldoIVAMorato + Amo.SaldoMoraVencido + Amo.SaldoMoraCarVen),Var_DecimalCero),
				TIME(NOW()),			Cre.SucursalID ,	Suc.NombreSucurs
		FROM CREDITOS Cre
		INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
		INNER JOIN PRODUCTOSCREDITO Prod ON Cre.ProductoCreditoID = Prod.ProducCreditoID
		INNER JOIN CONSOLIDACIONCARTALIQ Liq ON Cre.SolicitudCreditoID = Liq.SolicitudCreditoID
		INNER JOIN AMORTICREDITO Amo ON Amo.CreditoID = Cre.CreditoID AND Amo.Estatus != Var_EstatusPagado
		INNER JOIN SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID
		WHERE Cre.EsConsolidado = Var_EsConsolidado
		  AND Cre.FechaMinistrado BETWEEN Par_FechaInicio AND Par_FechaFin
		GROUP BY Cre.CreditoID,Liq.ConsolidaCartaID;

	DROP TABLE IF EXISTS TMPCREDITOSORIGEN;
	CREATE TEMPORARY TABLE TMPCREDITOSORIGEN(
		CreditoID	BIGINT(12),
		CreOrigen	VARCHAR(800),
		PRIMARY KEY (CreditoID)
	);

	INSERT INTO TMPCREDITOSORIGEN (
				CreditoID,		CreOrigen)
		SELECT	Cre.CreditoID,	SUBSTRING(GROUP_CONCAT(Car.CreditoID),1,800)
		FROM CREDITOS Cre
		INNER JOIN CONSOLIDACIONCARTALIQ Liq ON Cre.SolicitudCreditoID = Liq.SolicitudCreditoID
		INNER JOIN CONSOLIDACARTALIQDET AS LiqDet ON Liq.ConsolidaCartaID	= LiqDet.ConsolidaCartaID
		  AND LiqDet.TIPOCARTA = Var_CartaInterna
		INNER JOIN CARTALIQUIDACION Car ON LiqDet.CartaLiquidaID = Car.CartaLiquidaID
		WHERE Cre.EsConsolidado = Var_EsConsolidado
		GROUP BY Cre.CreditoID;

	UPDATE TMPCONSOLIDACIONESREP Rep
		INNER JOIN TMPCREDITOSORIGEN CreOri ON Rep.CreditoDestinoID = CreOri.CreditoID
		SET Rep.CreditoOrigenID = CreOri.CreOrigen;

	IF (Par_SucursalID = Var_EnteroCero AND Par_ProductoCreditoID = Var_EnteroCero) THEN
		SELECT	ClienteID,			NombreCompleto,		CreditoOrigenID,		CreditoDestinoID,	ProductoDestino,
				FechaMinistrado,	Estatus,			EstatusActual,			MontoOriginal,		NumPagoSoste,
				SaldoTotalCapital,	SaldoInteresTotal,	SaldoMoratorioTotal,	Hora,				SucursalID,
				NombreSucurs
			FROM TMPCONSOLIDACIONESREP;
	ELSEIF(Par_SucursalID != Var_EnteroCero AND Par_ProductoCreditoID = Var_EnteroCero) THEN
		SELECT	ClienteID,			NombreCompleto,		CreditoOrigenID,		CreditoDestinoID,	ProductoDestino,
				FechaMinistrado,	Estatus,			EstatusActual,			MontoOriginal,		NumPagoSoste,
				SaldoTotalCapital,	SaldoInteresTotal,	SaldoMoratorioTotal,	Hora,				SucursalID,
				NombreSucurs
			FROM TMPCONSOLIDACIONESREP
			WHERE SucursalID = Par_SucursalID;
	ELSEIF (Par_SucursalID = Var_EnteroCero AND Par_ProductoCreditoID != Var_EnteroCero) THEN
		SELECT	ClienteID,			NombreCompleto,		CreditoOrigenID,		CreditoDestinoID,	ProductoDestino,
				FechaMinistrado,	Estatus,			EstatusActual,			MontoOriginal,		NumPagoSoste,
				SaldoTotalCapital,	SaldoInteresTotal,	SaldoMoratorioTotal,	Hora,				SucursalID,
				NombreSucurs
			FROM TMPCONSOLIDACIONESREP
			WHERE ProductoCreditoID = Par_ProductoCreditoID;
	ELSEIF (Par_SucursalID != Var_EnteroCero AND Par_ProductoCreditoID != Var_EnteroCero) THEN
		SELECT	ClienteID,			NombreCompleto,		CreditoOrigenID,		CreditoDestinoID,	ProductoDestino,
				FechaMinistrado,	Estatus,			EstatusActual,			MontoOriginal,		NumPagoSoste,
				SaldoTotalCapital,	SaldoInteresTotal,	SaldoMoratorioTotal,	Hora,				SucursalID,
				NombreSucurs
			FROM TMPCONSOLIDACIONESREP
			WHERE ProductoCreditoID = Par_ProductoCreditoID
			  AND SucursalID = Par_SucursalID;
	END IF;

	DROP TABLE TMPCONSOLIDACIONESREP;
	DROP TABLE TMPCREDITOSORIGEN;

END TerminaStore$$