-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOAGROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOAGROCON`;DELIMITER $$

CREATE PROCEDURE `AMORTICREDITOAGROCON`(
/*SP para la consulta de las amortizaciones de creditos*/
	Par_CreditoID			BIGINT(12),				-- Numero de Credito
	Par_NumCon				TINYINT UNSIGNED,		-- Numero de Consulta
	Par_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
			)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE	Con_Principal		INT;
	DECLARE	Con_Foranea			INT;
	DECLARE Con_PagareTVar 		INT;
	DECLARE	Con_PagareTfija		INT;
	DECLARE	Con_PagoCred		INT;
	DECLARE	Con_PrimAmort		INT;

    DECLARE Con_DiasAtraso		INT;
	DECLARE Con_Recibo          INT;
	DECLARE Con_PagAlternativa  INT;            -- Constante Alternativa19
	DECLARE	DirOficialSi		CHAR(1);
	DECLARE Var_EstatusCredito	CHAR(1);		-- Estatus del Credito
	DECLARE Var_FechaOper		DATE;
	DECLARE Var_DiasAtraso		INT;
	DECLARE Registro_Reca		VARCHAR(200); /*Registro Reca*/
	DECLARE Con_PagarePlanIdeal INT;
	DECLARE Con_Totalvigente	INT(11);

    DECLARE Con_Cuotas          INT(11);
	DECLARE Con_SalFinPlazoWS	INT(11);
	DECLARE SIPagaIVA       	CHAR(1);
	DECLARE NOPagaIVA       	CHAR(1);
	DECLARE SiCobraFaltaPago	CHAR(1);
	DECLARE ComisionMonto       CHAR(1);
	DECLARE EsTasa_Fija			CHAR(1);

	-- DECLARACION DE VARIABLES
	DECLARE	NumInstitucion 			INT;
	DECLARE DireccionInstitu 		VARCHAR(250);
	DECLARE NombreInstitu 			VARCHAR(100);
	DECLARE MontoCred 				DECIMAL(12,2);
	DECLARE FechaInicCred 			DATE;
	DECLARE FechaVencCred 			DATE;
	DECLARE TasaVariable 			INT;
	DECLARE TasaBase_ID            	INT;
	DECLARE NombreTasa 				VARCHAR(100);
	DECLARE IDCliente 				INT(11);

    DECLARE NombreCliente 			VARCHAR(200);
	DECLARE FormulaTasa 			VARCHAR(100);
	DECLARE DireccionClient 		VARCHAR(500);
	DECLARE FrecuencInt 			CHAR(1);
	DECLARE PisTasa 				DECIMAL(12,4);
	DECLARE TechTasa 				DECIMAL(12,4);
	DECLARE Puntos 					DECIMAL(12,4);
	DECLARE Var_TasaFija 			DECIMAL(12,4);
	DECLARE fechaPTF 				DATE;
	DECLARE	Sucurs					VARCHAR(50);

    DECLARE	FactorM					DECIMAL(12,4);
	DECLARE FechaMinis	 			DATE;
	DECLARE DireccionCte	 		VARCHAR(250);
	DECLARE	Var_EstadoSuc			VARCHAR(100); -- guarda el nombre del estado de la sucursal
	DECLARE	Var_MuniSuc    			VARCHAR(100); -- guarda el nombre del municipio de la sucursal
	DECLARE PagareImpresoSI			CHAR(1);
	DECLARE EstatusVigente			CHAR(1);		-- Estatus Vigente
	DECLARE EstatusInactivo			CHAR(1);		-- Estatus Inactivo
	DECLARE EstatusAutorizado		CHAR(1);
	DECLARE Est_Pagado				CHAR(1);		-- Estatus Pagado

    DECLARE Esta_Vencido			CHAR(1);
	DECLARE Esta_Vigente			CHAR(1);
	DECLARE Esta_Atrazado			CHAR(1);
	DECLARE Var_RecClienteID    	VARCHAR(50);
	DECLARE Var_RecSolicitud    	VARCHAR(50);
	DECLARE Var_RecFechaRegistro 	VARCHAR(250);
	DECLARE Var_RecFechaInicio   	DATE;
	DECLARE Var_RecNombreSuc     	VARCHAR(250);
	DECLARE Var_RecNombreGte     	VARCHAR(250);
	DECLARE Var_RecTituloGte     	VARCHAR(50);

    DECLARE Var_RecTipDispersion 	VARCHAR(50);
	DECLARE FrecuenciaInt 		 	CHAR(1);
	DECLARE NumAmortizacion 	 	INT (11);
	DECLARE	Var_ProductoCredito 	INT(11);
	DECLARE Var_DiasPasoVencim		INT;
	DECLARE Var_CiudadInstitu		VARCHAR(50);
	DECLARE Var_EdoInstitu			VARCHAR(50);
	DECLARE Var_TotPagar        	DECIMAL(14,2);
	DECLARE Var_TotPagLetra     	VARCHAR(100);
	DECLARE MontoTotPagar       	VARCHAR(150);

    DECLARE Var_FrecSeguro  		VARCHAR(100);
	DECLARE Var_TotPagarCapital 	DECIMAL(14,2);
	DECLARE Var_TotCapLetra     	VARCHAR(100);
	DECLARE Var_MontoCuota      	VARCHAR(150);
	DECLARE Mora 					DECIMAL(12,2);
	DECLARE FijaTasa				DECIMAL(12,2);
	DECLARE Var_NombreCliente 		VARCHAR(150);
	DECLARE Var_TotCapVigente		DECIMAL(14,2);
	DECLARE Var_DescripcionProCre 	VARCHAR(100);
	DECLARE Var_DescripcionDesCre 	TEXT;		-- Descripcion Prod Credito Alternativa 19

    DECLARE Var_CuotasPagadas 		INT(11); -- Cuotas Pagadas
	DECLARE Var_TotalCuotas 		INT (11); -- Total Cuotas
	DECLARE Var_PagaIVA     		CHAR(1);
	DECLARE Var_IVA         		DECIMAL(12,2);
	DECLARE Var_PagaIVAInt  		CHAR(1);
	DECLARE Var_PagaIVAMor  		CHAR(1);
	DECLARE Var_IVAMora     		DECIMAL(12,2);
	DECLARE Var_TotalCap			DECIMAL(14,2);
	DECLARE Var_TotalInt			DECIMAL(14,2);
	DECLARE	Var_TotalIva			DECIMAL(14,2);

    DECLARE VarTotalCuotas			DECIMAL(14,2);
	DECLARE VarMontoCuotas			DECIMAL(14,2);
	DECLARE Var_NCuotas				INT(11);

	-- Inicia declaracion FEMAZA
	DECLARE Var_TotalCredito		DECIMAL(12,2); -- Monto del Crédito
	DECLARE Var_MontoComision   	DECIMAL(12,4);
	DECLARE Var_CobraFaltaPago  	CHAR(1);
	DECLARE Var_CriterioComFalPago  CHAR(1);
	DECLARE Var_TipCobComFalPago   	CHAR(1);
	DECLARE Var_PerCobComFalPago   	CHAR(1);
	DECLARE Var_TxtComision       	VARCHAR(200);
	DECLARE Var_TipoComision    	CHAR(1);
	-- Fin declaracion FEMAZA

	-- Declaracion de Variables Alternativa 19
	DECLARE Var_FechaMinisLetra     	VARCHAR(100);
	DECLARE Var_MontoTotPagarLetra  	VARCHAR(100);
	DECLARE Var_CapitalLetra        	VARCHAR(100);
	DECLARE Var_MontoComisionLetra  	VARCHAR(100);
	DECLARE Var_ComPenaConvencional     DECIMAL(10,2);
	DECLARE Var_ComPenaConvencionalTxt  VARCHAR(100);
	DECLARE Var_ComGastosCobranza       DECIMAL(10,2);
	DECLARE Var_ComGastosCobranzaTxt    VARCHAR(100);
	DECLARE Var_NumeroCuenta			VARCHAR(100);
	DECLARE Var_NombreBanco				VARCHAR(100);

    DECLARE Var_Clabe					VARCHAR(100);
	DECLARE Var_SucursalCred			INT(11);
	DECLARE Var_TipoCobroMora			CHAR(1);

    -- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';-- Fecha Vacia
	SET	Entero_Cero			:= 0;			-- Entero Cero
	SET Decimal_Cero		:= 0.0;			-- DECIMAL Cero
	SET	Con_Principal		:= 1;			-- Consulta Principal
	SET	Con_Foranea			:= 2;			-- Consulta Foranea
	SET Con_PagareTVar 		:= 3;			-- Consulta Pagare Tasa Variable
	SET Con_PagareTfija		:= 4;			-- Consulta Pagare Tasa Fija
	SET	Con_PagoCred		:= 5; 			-- Consulta Pago de Credito
	SET	Con_PrimAmort		:= 6; 			-- Consulta Primer Amortizacion

    SET Con_DiasAtraso		:= 7;			-- Consulta Dias de Atrazo
	SET Con_Recibo		    := 8; 			-- Consulta para generar el Recibo de Prestamo Individual
	SET Con_Totalvigente	:= 9;			-- Consulta usada en ventanilla para validar el capital vigente
	SET Con_Cuotas          :=10;			-- Consulta usada para obtener el total de cuotas y las cuotas pagadas
	SET Con_SalFinPlazoWS	:=11;			-- Consulta del Saldo Fin Plazo via WS para SANA TUS FINANZAS
	SET Con_PagAlternativa  :=12;           -- Consulta Pagare Alternativa19


	-- Consulta para generar el Recibo de Prestamo Individual
	SET	DirOficialSi		:= 'S'; 	-- Si es Direccion Oficial
	SET PagareImpresoSI		:='S';		-- Si Paga Impuestos
	SET EstatusVigente		:='V';		-- Estatus Vigente del Credito
	SET EstatusInactivo		:='I';		-- Estatus Inactivo del Credito
	SET EstatusAutorizado	:='A';		-- Estatus Autorizado
	SET Est_Pagado			:='P';      -- ESTATUS PAGADO
	SET Esta_Vencido		:='B';		-- Estatus Vencido
	SET Esta_Vigente		:='V';      -- ESTATUS Vigente
	SET Esta_Atrazado		:='A';		-- Estatus Atrazado
	SET SIPagaIVA       	:= 'S';     -- Si paga IVA

    SET NOPagaIVA       	:= 'N';		-- No paga IVA
	SET SiCobraFaltaPago  	:= 'S';		-- Cobra Comision Falta de Pago: SI
	SET ComisionMonto		:= 'M';		-- Comision: Monto
	SET EsTasa_Fija			:='T';		-- Tasa Fija
	SET Var_TxtComision 	:= '';		-- Descripcion Monto Comision

	IF(Par_NumCon = Con_Principal) THEN
		SELECT	  AmortizacionID,	FechaInicio,	FechaVencim,	FechaExigible,	Interes,	IVAInteres,
				  Capital
		FROM AMORTICREDITOAGRO
		WHERE  CreditoID = Par_CreditoID;
	END IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT	AmortizacionID,	CreditoID,	FechaInicio,	FechaVencim
		FROM AMORTICREDITOAGRO
		WHERE  CreditoID = Par_CreditoID;
	END IF;


	SET Var_EstatusCredito	:=(SELECT Estatus
								FROM CREDITOS
									WHERE CreditoID = Par_CreditoID);

	IF(Par_NumCon = Con_PagareTVar) THEN
		SET NumInstitucion   := (SELECT InstitucionID FROM PARAMETROSSIS);
		SET DireccionInstitu := (SELECT Direccion FROM INSTITUCIONES WHERE InstitucionID = NumInstitucion );
		SET NombreInstitu    := (SELECT Nombre FROM INSTITUCIONES WHERE InstitucionID = NumInstitucion );
		SET MontoCred 	   	 := (SELECT MontoCredito FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET FechaInicCred    := (SELECT FechaInicio FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET FechaVencCred    := (SELECT FechaVencimien FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET TasaVariable     := (SELECT CalcInteresID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET TasaBase_ID      := (SELECT TasaBase FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET NombreTasa       := (SELECT Nombre FROM TASASBASE WHERE TasaBaseID = TasaBase_ID);
		SET FormulaTasa      := (SELECT Formula FROM FORMTIPOCALINT WHERE FormInteresID = TasaVariable);
		SET IDCliente        := (SELECT ClienteID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET NombreCliente    := (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = IDCLiente);
		SET DireccionClient  := (SELECT DireccionCompleta FROM DIRECCLIENTE WHERE ClienteID = IDCliente AND Oficial='S');
		SET FrecuencInt	     := (SELECT Cre.FrecuenciaInt FROM CREDITOS Cre WHERE Cre.CreditoID = Par_CreditoID);
		SET PisTasa 	   	:= (SELECT PisoTasa FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET TechTasa 	   	:= (SELECT TechoTasa FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		SET Puntos 		   	:= (SELECT SobreTasa FROM CREDITOS WHERE CreditoID = Par_CreditoID);



	IF (Var_EstatusCredito = EstatusAutorizado OR Var_EstatusCredito = EstatusInactivo)THEN
		SELECT 	AmortizacionID,	FechaInicio,	FechaVencim,	 Capital,		FechaExigible,	DireccionInstitu,
				NombreInstitu,	 MontoCred,		FechaInicCred,		FechaVencCred,	FormulaTasa,	NombreTasa,
				NombreCliente,	TasaVariable,	DireccionClient,	FrecuencInt,	PisTasa,		TechTasa,Puntos
		FROM AMORTICREDITOAGRO
		WHERE CreditoID = Par_CreditoID;
	ELSE
		SELECT AmortizacionID,	FechaInicio,	FechaVencim,	Capital,		FechaExigible,	DireccionInstitu,
				NombreInstitu,	MontoCred,		FechaInicCred,	FechaVencCred,	FormulaTasa,	NombreTasa,
				NombreCliente,	TasaVariable,	DireccionClient,FrecuencInt,	PisTasa,		TechTasa,
				Puntos
			FROM PAGARECREDITO
				WHERE  CreditoID = Par_CreditoID;
	END IF;


	END IF;


	IF(Par_NumCon = Con_PagareTfija) THEN
		SET Var_DescripcionProCre:=
			(	SELECT pro.Descripcion FROM PRODUCTOSCREDITO pro, CREDITOS cre
				WHERE pro.ProducCreditoID = cre.ProductoCreditoID AND cre.CreditoID = Par_CreditoID);
		SET NumInstitucion  	:= (SELECT InstitucionID FROM PARAMETROSSIS);
		SELECT	Direccion,		Nombre
		 INTO	DireccionInstitu,	NombreInstitu
			FROM INSTITUCIONES
			WHERE InstitucionID = NumInstitucion;

		SELECT	DISTINCT
						Cre.ClienteID,	Cli.NombreCompleto,		Cre.TasaFija,				Cre.MontoCredito,	Cre.FechaVencimien,
						Cre.FactorMora,	Cre.FechaMinistrado,	IFNULL(Dir.DireccionCompleta,Cadena_Vacia), MontoCredito
				INTO 	IDCliente,		NombreCliente,			Var_TasaFija,				MontoCred,			FechaVencCred,
						FactorM,		FechaMinis,				DireccionCte, Var_TotalCredito
			FROM CREDITOS Cre
					LEFT OUTER JOIN CLIENTES Cli
						ON Cre.ClienteID= Cli.ClienteID
					LEFT OUTER JOIN DIRECCLIENTE Dir
						ON Cli.ClienteID= Dir.ClienteID
						AND Dir.Oficial = DirOficialSi
					WHERE Cre.CreditoID = Par_CreditoID;

		SET fechaPTF:= (SELECT FechaActual
			FROM AMORTICREDITOAGRO
			WHERE CreditoID = Par_CreditoID
			 AND 	AmortizacionID=1);

		SELECT Suc.NombreSucurs,	Edo.Nombre, Mun.Nombre
		INTO  Sucurs,Var_EstadoSuc, Var_MuniSuc
				FROM 	SUCURSALES Suc,
						ESTADOSREPUB AS Edo LEFT OUTER JOIN
					MUNICIPIOSREPUB AS Mun ON Mun.EstadoID=Edo.EstadoID,
						USUARIOS	Usu
				WHERE UsuarioID		=Aud_Usuario
				AND Edo.EstadoID 	= Suc.EstadoID
			AND Mun.MunicipioID 	= Suc.MunicipioID
				AND Usu.SucursalUsuario= Suc.SucursalID;

			SET Var_TipoCobroMora	:=(SELECT TipCobComMorato FROM CREDITOS WHERE CreditoID = Par_CreditoID);
			IF(Var_TipoCobroMora = EsTasa_Fija)THEN
				SET Mora := FactorM;
			ELSE
				SET Mora := Var_TasaFija*FactorM;
			END IF;

			SET FijaTasa := IFNULL(Var_TasaFIja,Decimal_Cero);

		-- Tasa Iva y tasa ordinaria son para el pagaré de Mas Alternativas reguladas por el reca
		IF (Var_EstatusCredito = EstatusAutorizado OR Var_EstatusCredito = EstatusInactivo )THEN
				 -- SECCION FEMAZA
				SELECT prod.ProducCreditoID, prod.CobraFaltaPago, prod.CriterioComFalPag, prod.TipCobComFalPago, prod.PerCobComFalPag
				INTO Var_ProductoCredito, Var_CobraFaltaPago, Var_CriterioComFalPago, Var_TipCobComFalPago, Var_PerCobComFalPago
				FROM PRODUCTOSCREDITO AS prod, CREDITOS cr
				WHERE prod.ProducCreditoID=cr.ProductoCreditoID
					AND cr.CreditoID = Par_CreditoID;

				SET Var_NCuotas := (SELECT COUNT(AmortizacionID)
				FROM AMORTICREDITOAGRO
				WHERE CreditoID = Par_CreditoID);

				-- Para FEMAZA Generación de cadena para Comsion por pago tardío.
				IF (Var_CobraFaltaPago = SiCobraFaltaPago) THEN
					SET Var_TxtComision := 'De no pagarse en las fechas establecidas causara ademas un cargo por concepto de comision por pago tardio de ';

					SELECT  COM.TipoComision, COM.Comision
					INTO Var_TipoComision, Var_MontoComision
					FROM ESQUEMACOMISCRE AS COM INNER JOIN CREDITOS AS CRE ON CRE.ProductoCreditoID = COM.ProducCreditoID
					WHERE Var_TotalCredito BETWEEN COM.MontoInicial AND COM.MontoFinal AND CRE.ProductoCreditoID = Var_ProductoCredito AND CRE.CreditoID = Par_CreditoID;

					IF (Var_TipoComision = ComisionMonto) THEN
						SET Var_TxtComision := CONCAT(Var_TxtComision, ' $ ', CAST(FORMAT(Var_MontoComision,2) AS CHAR), ' (', TRIM(FUNCIONNUMLETRAS(Var_MontoComision)), ').');
					ELSE
						SET Var_TxtComision := CONCAT(Var_TxtComision, CAST(Var_MontoComision AS CHAR), ' % (', FUNCIONNUMEROSLETRAS(Var_MontoComision), ' Porciento).');
					END IF;
				END IF;

			SELECT AmortizacionID,	FechaInicio,	FechaVencim,			FechaExigible,	(Capital+Interes+IVAInteres) AS montoCuota,
				   Interes,	IVAInteres,		Capital,				DireccionInstitu,	 NombreInstitu,
				   NombreCliente,	Var_TasaFija,	FORMAT(MontoCred,2),	FechaVencCred,	 fechaPTF,
				   Sucurs,			FactorM,		FechaMinis,				DireccionCte,	CreditoID,  Var_NCuotas 	AS NCuotas,
				   SaldoCapital,	Var_EstadoSuc , Var_MuniSuc,			Mora ,			FijaTasa,

					CONVPORCANT(MontoCred, '$','Peso', 'Nacional')AS Montocletra,
					Var_DescripcionProCre,
					CONVPORCANT(ROUND(FijaTasa*0.16,2),'%','2','') AS taiva,
					CONVPORCANT(ROUND(FijaTasa*0.16/12,2),'%','2','') AS taivaMensual,
					CONVPORCANT(ROUND((FijaTasa)/12,2),'%','2','') AS TasaOrdinariaMensual,
					CONVPORCANT(ROUND((FijaTasa)*1.16/12,2),'%','2','') AS tasaAnualizadaMensual,
					CONVPORCANT(ROUND(FijaTasa,2),'%','2','') AS TasaOrdinariaAnual,
					CONVPORCANT(ROUND((FijaTasa)*3/360,2),'%','2','') AS TasaMoraDiaria,
					CONVPORCANT(ROUND((FijaTasa)*3/12,2),'%','2','') AS TasaMoraMensual,
					CONVPORCANT(ROUND(((FijaTasa)*3/360)*1.16*MontoCred/100,2),'$','peso','Nacional') AS ValorMoraDiaria,
					FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS)) AS FechaSis,
					(SELECT pro.ProducCreditoID FROM PRODUCTOSCREDITO pro, CREDITOS cre WHERE pro.ProducCreditoID = cre.ProductoCreditoID AND cre.CreditoID = Par_CreditoID) AS ProductoCre,
					(SELECT MAX(FechaVencim)	FROM AMORTICREDITOAGRO WHERE CreditoID = Par_CreditoID)AS Par_FechaultimaAmortizacion,
				(SELECT RegistroRECA FROM CREDITOS cr , PRODUCTOSCREDITO  pc WHERE cr.CreditoID = Par_CreditoID AND cr.ProductoCreditoID = pc.ProducCreditoID) AS Var_Reca, Var_TxtComision AS TxtComision,
				LOWER(FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS))) AS FechaActual
			FROM AMORTICREDITOAGRO
				WHERE CreditoID = Par_CreditoID;
		 ELSE
			SELECT prod.ProducCreditoID, prod.CobraFaltaPago, prod.CriterioComFalPag, prod.TipCobComFalPago, prod.PerCobComFalPag
				INTO Var_ProductoCredito, Var_CobraFaltaPago, Var_CriterioComFalPago, Var_TipCobComFalPago, Var_PerCobComFalPago
				FROM PRODUCTOSCREDITO AS prod, CREDITOS cr
				WHERE prod.ProducCreditoID=cr.ProductoCreditoID
					AND cr.CreditoID = Par_CreditoID;

				SET Var_NCuotas := (SELECT COUNT(AmortizacionID)
				FROM AMORTICREDITOAGRO
				WHERE CreditoID = Par_CreditoID);

				IF (Var_CobraFaltaPago = SiCobraFaltaPago) THEN
					SET Var_TxtComision := 'De no pagarse en las fechas establecidas causara ademas un cargo por concepto de comision por pago tardio de ';

					SELECT  COM.TipoComision, COM.Comision
					INTO Var_TipoComision, Var_MontoComision
					FROM ESQUEMACOMISCRE AS COM INNER JOIN CREDITOS AS CRE ON CRE.ProductoCreditoID = COM.ProducCreditoID
					WHERE Var_TotalCredito BETWEEN COM.MontoInicial AND COM.MontoFinal AND CRE.ProductoCreditoID = Var_ProductoCredito AND CRE.CreditoID = Par_CreditoID;

					IF (Var_TipoComision = ComisionMonto) THEN
						SET Var_TxtComision := CONCAT(Var_TxtComision, ' $ ', CAST(FORMAT(Var_MontoComision,2) AS CHAR), ' (', TRIM(FUNCIONNUMLETRAS(Var_MontoComision)), ').');
					ELSE
						SET Var_TxtComision := CONCAT(Var_TxtComision, CAST(Var_MontoComision AS CHAR), ' % (', FUNCIONNUMEROSLETRAS(Var_MontoComision), ' Porciento).');
					END IF;
				END IF;

			SET Var_NCuotas := (SELECT COUNT(AmortizacionID)
				FROM PAGARECREDITO PAG
				WHERE PAG.CreditoID = Par_CreditoID);

			SELECT PAG.AmortizacionID,	PAG.FechaInicio,PAG.FechaVencim,	PAG.FechaExigible,	(PAG.Capital+PAG.Interes+PAG.IVAInteres) AS montoCuota,
				   PAG.Interes,			PAG.IVAInteres,	PAG.Capital,		DireccionInstitu,	 NombreInstitu,
				   NombreCliente,		Var_TasaFija,	FORMAT(MontoCred,2),	FechaVencCred,	 	 fechaPTF,
				   Sucurs,				FactorM,		FechaMinis,			DireccionCte,		 PAG.CreditoID,  Var_NCuotas 	AS NCuotas,
				   Var_EstadoSuc , Var_MuniSuc,				Mora	,		 FijaTasa,

					CONVPORCANT(MontoCred, '$','Peso', 'Nacional')AS Montocletra,
					Var_DescripcionProCre,
					CONVPORCANT(ROUND((FijaTasa)/12,2),'%','2','') AS TasaOrdinariaMensual,
					CONVPORCANT(ROUND((FijaTasa)*1.16/12,2),'%','2','') AS tasaAnualizadaMensual,
					CONVPORCANT(ROUND(FijaTasa,2),'%','2','') AS TasaOrdinariaAnual,
					CONVPORCANT(ROUND(FijaTasa*0.16,2),'%','2','') AS taiva,
					CONVPORCANT(ROUND(FijaTasa*0.16/12,2),'%','2','') AS taivaMensual,
					CONVPORCANT(ROUND((FijaTasa)*3/360,2),'%','2','') AS TasaMoraDiaria,
					CONVPORCANT(ROUND((FijaTasa)*3/12,2),'%','2','') AS TasaMoraMensual,
					CONVPORCANT(ROUND(((FijaTasa)*3/360)*1.16*MontoCred/100,2),'$','peso','Nacional') AS ValorMoraDiaria,
					FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS)) AS FechaSis,
					(SELECT pro.ProducCreditoID FROM PRODUCTOSCREDITO pro, CREDITOS cre WHERE pro.ProducCreditoID = cre.ProductoCreditoID AND cre.CreditoID = Par_CreditoID) AS ProductoCre
			 ,(SELECT MAX(FechaVencim)	FROM PAGARECREDITO WHERE CreditoID = Par_CreditoID)AS Par_FechaultimaAmortizacion,
				(SELECT RegistroRECA FROM CREDITOS cr , PRODUCTOSCREDITO  pc WHERE cr.CreditoID = Par_CreditoID AND cr.ProductoCreditoID = pc.ProducCreditoID) AS Var_Reca, Var_TxtComision AS TxtComision,
				LOWER(FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS))) AS FechaActual
			FROM PAGARECREDITO PAG
				WHERE PAG.CreditoID = Par_CreditoID;

		 END IF;

	END IF;

	IF(Par_NumCon = Con_PrimAmort) THEN
		SELECT	FechaInicio
		FROM AMORTICREDITOAGRO
		WHERE  CreditoID = Par_CreditoID
		AND AmortizacionID = 1;
	END IF;


	-- Dias de Atraso Actuales
	IF(Par_NumCon = Con_DiasAtraso)THEN
		SET Var_FechaOper   := (SELECT FechaSistema
									FROM PARAMETROSSIS);
		SELECT (DATEDIFF(Var_FechaOper, IFNULL(MIN(FechaExigible), Var_FechaOper)))  AS DiasAtraso
					FROM AMORTICREDITOAGRO Amo
					WHERE Amo.CreditoID = Par_CreditoID
					  AND Amo.Estatus != Est_Pagado
					  AND Amo.FechaExigible <= Var_FechaOper;

	END IF;

	-- Consulta para generar el Recibo de Prestamo Individual
	IF(Par_NumCon = Con_Recibo)THEN
		SELECT Cli.ClienteID,Sol.SolicitudCreditoID,
			CONCAT(DAY(Sol.FechaRegistro), " de ",
					CASE MONTH(Sol.FechaRegistro)	WHEN '01' THEN 'Enero'	WHEN '02' THEN 'Febrero' WHEN '03' THEN 'Marzo'	WHEN '04' THEN 'Abril'
					WHEN '05' THEN 'Mayo' WHEN '06' THEN 'Junio' WHEN '07' THEN 'Julio' WHEN '08' THEN 'Agosto'	WHEN '09' THEN 'Septiembre'
					WHEN '10' THEN 'Octubre' WHEN '11' THEN 'Noviembre'	WHEN '12' THEN 'Diciembre' END , " de ", YEAR(Sol.FechaRegistro))
				AS FechaRegistro,Cre.FechaInicio,
				CASE Cre.TipoDispersion
							WHEN "S" THEN "SPEI"
							WHEN "C" THEN "CHEQUE"
							WHEN "O" THEN "ORDEN DE PAGO"
							WHEN "E" THEN "EFECTIVO"
					END AS TipoDispersion
					INTO  Var_RecClienteID,	Var_RecSolicitud,	Var_RecFechaRegistro,Var_RecFechaInicio,Var_RecTipDispersion
			FROM CREDITOS Cre
				INNER JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID=Cre.SolicitudCreditoID
				INNER JOIN CLIENTES Cli ON Cli.ClienteID=Cre.ClienteID
			WHERE Cre.CreditoID=Par_CreditoID;

		SELECT Suc.NombreSucurs,Usu.NombreCompleto,Suc.TituloGte
				INTO  Var_RecNombreSuc,	Var_RecNombreGte,	Var_RecTituloGte
				FROM SUCURSALES Suc
					INNER JOIN USUARIOS Usu ON Usu.UsuarioID=Suc.NombreGerente
				WHERE Suc.SucursalID=Aud_Sucursal;

		SELECT Var_RecClienteID,	Var_RecSolicitud,	Var_RecFechaRegistro,Var_RecFechaInicio,
			   Var_RecNombreSuc,	Var_RecNombreGte,	Var_RecTituloGte,	Var_RecTipDispersion;

	END IF;
	-- 9 consulta usada en ventanilla para validar el capital  vigente
	IF(Par_NumCon = Con_Totalvigente) THEN

		SET Var_TotCapVigente	:= (SELECT SUM(SaldoCapVigente) FROM AMORTICREDITOAGRO
									WHERE CreditoID = Par_CreditoID AND Estatus IN ( EstatusVigente,Esta_Vencido));

		SELECT	 Var_TotCapVigente AS TotalCapitalVig;
	END IF;

	-- 10 consulta usada para obtner el total de cuotas y las cuotas pagadas
	IF(Par_NumCon = Con_Cuotas) THEN
		SELECT COUNT(AMOR.AmortizacionID) AS Amortiza, C.NumAmortizacion INTO Var_CuotasPagadas, Var_TotalCuotas
		FROM AMORTICREDITOAGRO AS AMOR
		INNER JOIN CREDITOS AS C ON AMOR.CreditoID=C.CreditoID
		WHERE AMOR.Estatus=Est_Pagado AND C.CreditoID=Par_CreditoID;

		SELECT Var_CuotasPagadas AS CuotasPagadas, Var_TotalCuotas AS TotalCuotas;
	END IF;


	-- 11 consulta usada para obtener el saldo total final de plazo WS para SANA TUS FINANZAS
	IF(Par_NumCon = Con_SalFinPlazoWS) THEN

		DROP TABLE IF EXISTS TMPAMORTICREDITOAGRO;
		CREATE TEMPORARY TABLE TMPAMORTICREDITOAGRO(
			AmortizacionID 			INT(4),
			CreditoID			 	BIGINT(12),
			Estatus					VARCHAR(1),
			TotalCuotas				DECIMAL(14,2),
			MontoCuotas				DECIMAL(14,2)
		);
		CREATE INDEX TMPAMORTICREDITOAGRO_IDX1 ON TMPAMORTICREDITOAGRO (AmortizacionID, CreditoID);

		SELECT Cli.PagaIVA, Suc.IVA, Pro.CobraIVAInteres,   Pro.CobraIVAMora, Suc.IVA INTO
			   Var_PagaIVA, Var_IVA, Var_PagaIVAInt, Var_PagaIVAMor, Var_IVAMora
			FROM CREDITOS Cre,
				 CLIENTES Cli,
				 SUCURSALES Suc,
				 PRODUCTOSCREDITO Pro
			WHERE Cre.CreditoID = Par_CreditoID
			  AND Cre.ClienteID = Cli.ClienteID
			  AND Cli.SucursalOrigen = Suc.SucursalID
			  AND Pro.ProducCreditoID = Cre.ProductoCreditoID;

		SET Var_PagaIVA 	:= IFNULL(Var_PagaIVA, SIPagaIVA);
		SET Var_PagaIVAInt 	:= IFNULL(Var_PagaIVAInt, SIPagaIVA);
		SET Var_PagaIVAMor 	:= IFNULL(Var_PagaIVAMor, SIPagaIVA);

		SET Var_IVA 	:= IFNULL(Var_IVA, Entero_Cero);
		SET Var_IVAMora := IFNULL(Var_IVAMora, Entero_Cero);

		IF(Var_PagaIVA = NOPagaIVA ) THEN
			SET Var_IVA 	:= Entero_Cero;
			SET Var_IVAMora := Entero_Cero;
		ELSE
			IF (Var_PagaIVAInt = NOPagaIVA) THEN
				SET Var_IVA := Entero_Cero;
			END IF;

			IF (Var_PagaIVAMor = NOPagaIVA) THEN
				SET Var_IVAMora := Entero_Cero;
			END IF;
		END IF;

		-- Se calcula el monto de la cuota y el total de la cuota y se guardan en una tabla temporal
		INSERT INTO TMPAMORTICREDITOAGRO
		SELECT  AmortizacionID,  CreditoID, Estatus,
				ROUND(
					SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido +
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
				ROUND(SaldoOtrasComis * Var_IVA, 2) AS totalCuota,
				ROUND(Capital + Interes + IVAInteres,2) AS montoCuota

			FROM AMORTICREDITOAGRO
			WHERE CreditoID = Par_CreditoID;

		-- Se suman todas las cuotas de las amortizaciones que sean ATRAZADAS o VENCIDAS excepto las PAGADAS
		SELECT SUM(TotalCuotas) INTO VarTotalCuotas
			FROM TMPAMORTICREDITOAGRO
				WHERE Estatus = Esta_Atrazado OR Estatus = Esta_Vencido AND Estatus != Est_Pagado;

		-- Se suman todos los montos de las amortizaciones que sean VIGENTES excepto las PAGADAS Decimal_Cero
		SELECT SUM(MontoCuotas) INTO VarMontoCuotas
			FROM TMPAMORTICREDITOAGRO
				WHERE Estatus = Esta_Vigente AND Estatus != Est_Pagado;

		SET VarTotalCuotas := IFNULL(VarTotalCuotas,Decimal_Cero);
		SET VarMontoCuotas := IFNULL(VarMontoCuotas,Decimal_Cero);

		SELECT Par_CreditoID AS CreditoID, (VarTotalCuotas+VarMontoCuotas) AS SaldoFinalPlazo;
		DROP TABLE IF EXISTS TMPAMORTICREDITOAGRO;
	END IF;

	IF(Par_NumCon = Con_PagAlternativa) THEN
		-- Descripcion del producto
		SET Var_DescripcionProCre:=
			(SELECT pro.Descripcion
				FROM PRODUCTOSCREDITO pro, CREDITOS cre
				WHERE pro.ProducCreditoID = cre.ProductoCreditoID
				AND cre.CreditoID = Par_CreditoID);

		-- Producto de Credito
		SET Var_ProductoCredito:=
			(SELECT pro.ProducCreditoID
				FROM PRODUCTOSCREDITO pro, CREDITOS cre
				WHERE pro.ProducCreditoID = cre.ProductoCreditoID
				AND cre.CreditoID = Par_CreditoID);

		-- Descripcion del destino de credito

		SET Var_DescripcionDesCre:=
			(SELECT pro.Caracteristicas
				FROM PRODUCTOSCREDITO pro, CREDITOS cre
				WHERE pro.ProducCreditoID = cre.ProductoCreditoID
				AND cre.CreditoID = Par_CreditoID);

		-- Nombre de la institucion, direccion
		SET NumInstitucion      := (SELECT InstitucionID FROM PARAMETROSSIS);
		SELECT  DirFiscal,      Nombre
		 INTO   DireccionInstitu,   NombreInstitu
			FROM INSTITUCIONES
			WHERE InstitucionID = NumInstitucion;

		SET Var_SucursalCred := (SELECT SucursalID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
		-- Datos del Banco
		SELECT CA.SucursalInstit, 	CA.NumCtaInstit, 	CA.CueClave
			INTO Var_NombreBanco,	Var_NumeroCuenta,	Var_Clabe
			FROM SUCURSALES SU
			INNER JOIN CENTROCOSTOS CC ON SU.CentroCostoID = CC.CentroCostoID
			INNER JOIN CUENTASAHOTESO CA ON CC.CentroCostoID = CA.CentroCostoID
			WHERE SucursalID = Var_SucursalCred
			ORDER BY SucursalID
			LIMIT 1;


		-- Datos del credito (nombre del cliente, direccion cliente, Tasa Fija, Monto Credito, Total Credito)
		SELECT  DISTINCT
						Cre.ClienteID,  Cli.NombreCompleto,     Cre.TasaFija,               Cre.MontoCredito,   Cre.FechaVencimien,
						Cre.FactorMora, Cre.FechaMinistrado,    IFNULL(Dir.DireccionCompleta,Cadena_Vacia), MontoCredito
				INTO    IDCliente,      NombreCliente,          Var_TasaFija,               MontoCred,          FechaVencCred,
						FactorM,        FechaMinis,             DireccionCte, Var_TotalCredito
			FROM CREDITOS Cre
					LEFT OUTER JOIN CLIENTES Cli
						ON Cre.ClienteID= Cli.ClienteID
					LEFT OUTER JOIN DIRECCLIENTE Dir
						ON Cli.ClienteID= Dir.ClienteID
						AND Dir.Oficial = DirOficialSi
					WHERE Cre.CreditoID = Par_CreditoID;

		-- Fecha de Amortizacion
		SET fechaPTF:= (SELECT FechaActual
			FROM AMORTICREDITOAGRO
			WHERE CreditoID = Par_CreditoID
			 AND    AmortizacionID=1);

		-- Datos de la sucursal (municipio y estado)
		SELECT Suc.NombreSucurs,    Edo.Nombre, Mun.Nombre
		INTO  Sucurs,Var_EstadoSuc, Var_MuniSuc
				FROM    SUCURSALES Suc,
							ESTADOSREPUB AS Edo
					LEFT OUTER JOIN	MUNICIPIOSREPUB AS Mun
					ON Mun.EstadoID=Edo.EstadoID,
						USUARIOS    Usu
				WHERE UsuarioID     =Aud_Usuario
				AND Edo.EstadoID    = Suc.EstadoID
			AND Mun.MunicipioID     = Suc.MunicipioID
				AND Usu.SucursalUsuario= Suc.SucursalID;

			-- Tasa Fija Anual
			SET Mora		:=	Var_TasaFija*FactorM;
			SET FijaTasa	:=	IFNULL(Var_TasaFIja,Decimal_Cero);


			SET Var_ComPenaConvencional := Decimal_Cero;
			SET Var_ComGastosCobranza	:= Decimal_Cero;

			SET Var_ComGastosCobranzaTxt 	:= CONVPORCANT(Var_ComGastosCobranza, '$','peso', 'Nacional');
			SET Var_ComPenaConvencionalTxt 	:= CONVPORCANT(ROUND(Var_ComPenaConvencional,2),'%','2','');
			SET Var_ComPenaConvencional 	:= IFNULL(Var_ComPenaConvencional,Decimal_Cero);
			SET Var_ComGastosCobranza 		:= IFNULL(Var_ComGastosCobranza,Decimal_Cero);
			SET Var_ComPenaConvencionalTxt 	:= IFNULL(Var_ComPenaConvencionalTxt, Cadena_Vacia);
			SET Var_ComGastosCobranzaTxt 	:= IFNULL(Var_ComGastosCobranzaTxt,Cadena_Vacia);

		IF (Var_EstatusCredito = EstatusAutorizado OR Var_EstatusCredito = EstatusInactivo )THEN

				SELECT prod.ProducCreditoID, 	prod.CobraFaltaPago, 	prod.CriterioComFalPag, 	prod.TipCobComFalPago, 	prod.PerCobComFalPag,
						prod.RegistroRECA
					INTO Var_ProductoCredito, 	Var_CobraFaltaPago, 	Var_CriterioComFalPago, 	Var_TipCobComFalPago, 	Var_PerCobComFalPago,
					Registro_Reca
				FROM PRODUCTOSCREDITO AS prod, CREDITOS cr
				WHERE prod.ProducCreditoID=cr.ProductoCreditoID
					AND cr.CreditoID = Par_CreditoID;

				SET Var_NCuotas := (SELECT COUNT(AmortizacionID)
				FROM AMORTICREDITOAGRO
				WHERE CreditoID = Par_CreditoID);

				SET MontoTotPagar := (SELECT SUM(Capital+Interes+IVAInteres)
				FROM AMORTICREDITOAGRO
				WHERE CreditoID = Par_CreditoID);


				IF (Var_CobraFaltaPago = SiCobraFaltaPago) THEN
					SET Var_TxtComision := 'De no pagarse en las fechas establecidas causara ademas un cargo por concepto de comision por pago tardio de ';

					SELECT  COM.TipoComision, COM.Comision
					INTO Var_TipoComision, Var_MontoComision
						FROM ESQUEMACOMISCRE AS COM
						INNER JOIN CREDITOS AS CRE
						ON CRE.ProductoCreditoID = COM.ProducCreditoID
						WHERE Var_TotalCredito
						BETWEEN COM.MontoInicial AND COM.MontoFinal AND CRE.ProductoCreditoID = Var_ProductoCredito
												 AND CRE.CreditoID = Par_CreditoID;
					IF (Var_TipoComision = ComisionMonto) THEN
						SET Var_TxtComision := CONCAT(Var_TxtComision, ' $ ', CAST(FORMAT(Var_MontoComision,2) AS CHAR), ' (', TRIM(FUNCIONNUMLETRAS(Var_MontoComision)), ')');
					ELSE
						SET Var_TxtComision := CONCAT(Var_TxtComision, CAST(Var_MontoComision AS CHAR), ' % (', FUNCIONNUMEROSLETRAS(Var_MontoComision), ' Porciento)');
					END IF;
				END IF;

			SELECT AmortizacionID,  FechaInicio,    FechaVencim,            FechaExigible,  CONCAT('$ ', FORMAT((Capital+Interes+IVAInteres),2)) AS montoCuota,
					   Interes, 		IVAInteres,     Capital,      			MontoTotPagar,  		DireccionInstitu,
					   NombreInstitu,   NombreCliente,  Var_TasaFija,   		FORMAT(MontoCred,2),    FechaVencCred,
					   fechaPTF,	    Sucurs,         FactorM,    			CONVPORCANT(ROUND(FactorM,2),'%','2','') AS Factorcletra,
					   FechaMinis,      DireccionCte,   CreditoID,  			Var_NCuotas AS NCuotas, SaldoCapital,
					   Var_EstadoSuc,  	Var_MuniSuc,    Mora ,          		FijaTasa,               Registro_Reca,

					CONVPORCANT(MontoCred, '$','peso', 'Nacional')AS Montocletra,
					CONCAT('(',FUNCIONNUMLETRAS(MontoCred),'Moneda Nacional )') AS MontoLetra,
					CONVPORCANT(MontoTotPagar, '$','peso', 'Nacional')AS Var_MontoTotPagarLetra,
					CONVPORCANT(Capital, '$','peso', 'Nacional')AS Var_CapitalLetra,               Var_MontoComision,
					Var_ComGastosCobranzaTxt,
					Var_ComPenaConvencionalTxt,
					Var_DescripcionProCre,
					Var_DescripcionDesCre,
					Var_NombreBanco,
					Var_NumeroCuenta,
					Var_Clabe,
					Var_ProductoCredito,
					CONVPORCANT(ROUND(Var_MontoComision,2),'%','2','') AS Var_MontoComisionLetra,
					CONVPORCANT(ROUND(FijaTasa*0.16,2),'%','2','') AS taiva,
					CONVPORCANT(ROUND(FijaTasa*0.16/12,2),'%','2','') AS taivaMensual,
					CONVPORCANT(ROUND((FijaTasa)/12,2),'%','2','') AS TasaOrdinariaMensual,
					CONVPORCANT(ROUND((FijaTasa)*1.16/12,2),'%','2','') AS tasaAnualizadaMensual,
					CONVPORCANT(ROUND(FijaTasa,2),'%','2','') AS TasaOrdinariaAnual, -- Tasa Fija
					CONVPORCANT(ROUND((FijaTasa)*3/360,2),'%','2','') AS TasaMoraDiaria,
					CONVPORCANT(ROUND((FijaTasa)*3/12,2),'%','2','') AS TasaMoraMensual,
					CONVPORCANT(ROUND(((FijaTasa)*3/360)*1.16*MontoCred/100,2),'$','peso','Nacional') AS ValorMoraDiaria,
					FORMATEAFECHACONTRATO(FechaMinis) AS Var_FechaMinisLetra,
					FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS)) AS FechaSis,
					(SELECT pro.ProducCreditoID FROM PRODUCTOSCREDITO pro, CREDITOS cre WHERE pro.ProducCreditoID = cre.ProductoCreditoID AND cre.CreditoID = Par_CreditoID) AS ProductoCre,
					(SELECT MAX(FechaVencim)    FROM AMORTICREDITOAGRO WHERE CreditoID = Par_CreditoID)AS Par_FechaultimaAmortizacion,
				(SELECT RegistroRECA FROM CREDITOS cr , PRODUCTOSCREDITO  pc WHERE cr.CreditoID = Par_CreditoID AND cr.ProductoCreditoID = pc.ProducCreditoID) AS Var_Reca, Var_TxtComision AS TxtComision,
				CONVPORCANT((Capital+Interes+IVAInteres), '$','peso', 'Nacional')AS MontoCuotaInd
			FROM AMORTICREDITOAGRO
				WHERE CreditoID = Par_CreditoID;
		 ELSE


			SET Var_NCuotas := (SELECT COUNT(AmortizacionID)
				FROM PAGARECREDITO PAG
				WHERE PAG.CreditoID = Par_CreditoID);

			SET MontoTotPagar := (SELECT SUM(PAG.Capital+PAG.Interes+PAG.IVAInteres)
				FROM PAGARECREDITO PAG
				WHERE CreditoID = Par_CreditoID);

				SELECT prod.ProducCreditoID, prod.CobraFaltaPago, prod.CriterioComFalPag, prod.TipCobComFalPago, prod.PerCobComFalPag,
					   prod.RegistroRECA
					INTO Var_ProductoCredito, Var_CobraFaltaPago, Var_CriterioComFalPago, Var_TipCobComFalPago, Var_PerCobComFalPago,
					   Registro_Reca
				FROM PRODUCTOSCREDITO AS prod, CREDITOS cr
				WHERE prod.ProducCreditoID=cr.ProductoCreditoID
					AND cr.CreditoID = Par_CreditoID;

				SELECT PAG.AmortizacionID,  PAG.FechaInicio,	 PAG.FechaVencim,    PAG.FechaExigible,		CONCAT('$ ', FORMAT((PAG.Capital+PAG.Interes+PAG.IVAInteres),2)) AS montoCuota,
					   MontoTotPagar,	    PAG.Interes,         PAG.IVAInteres, 	 PAG.Capital,      		MontoTotPagar,
					   DireccionInstitu,    NombreInstitu,		 NombreCliente,      Var_TasaFija,   		FORMAT(MontoCred,2),
					   FechaVencCred,       fechaPTF,			 Sucurs,             FactorM,    			CONVPORCANT(ROUND(FactorM,2),'%','2','') AS Factorcletra,
					   FechaMinis,          DireccionCte,        PAG.CreditoID,  	 Var_NCuotas AS NCuotas,Var_EstadoSuc ,
					   Var_MuniSuc,         Mora,  			     FijaTasa, 			Registro_Reca,

					CONVPORCANT(MontoCred, '$','peso', 'Nacional')AS Montocletra,
					CONCAT('(',FUNCIONNUMLETRAS(MontoCred),'Moneda Nacional )') AS MontoLetra,
					CONVPORCANT(MontoTotPagar, '$','peso', 'Nacional')AS Var_MontoTotPagarLetra,
					CONVPORCANT(Capital, '$','peso', 'Nacional')AS Var_CapitalLetra,
					CONVPORCANT(Var_MontoComision, '$N','peso', 'Nacional')AS MontoComision,
					Var_ComGastosCobranzaTxt,
					Var_ComPenaConvencionalTxt,
					Var_DescripcionProCre,
					Var_DescripcionDesCre,
					Var_NombreBanco,
					Var_NumeroCuenta,
					Var_Clabe,
					Var_ProductoCredito,
					CONVPORCANT(ROUND(Var_MontoComision,2),'%','2','') AS Var_MontoComisionLetra,
					CONVPORCANT(ROUND((FijaTasa)/12,2),'%','2','') AS TasaOrdinariaMensual,
					CONVPORCANT(ROUND((FijaTasa)*1.16/12,2),'%','2','') AS tasaAnualizadaMensual,
					CONVPORCANT(ROUND(FijaTasa,2),'%','2','') AS TasaOrdinariaAnual,
					CONVPORCANT(ROUND(FijaTasa*0.16,2),'%','2','') AS taiva,
					CONVPORCANT(ROUND(FijaTasa*0.16/12,2),'%','2','') AS taivaMensual,
					CONVPORCANT(ROUND((FijaTasa)*3/360,2),'%','2','') AS TasaMoraDiaria,
					CONVPORCANT(ROUND((FijaTasa)*3/12,2),'%','2','') AS TasaMoraMensual,
					CONVPORCANT(ROUND(((FijaTasa)*3/360)*1.16*MontoCred/100,2),'$','peso','Nacional') AS ValorMoraDiaria,
					FORMATEAFECHACONTRATO(FechaMinis) AS Var_FechaMinisLetra,
					FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS)) AS FechaSis,
					(SELECT pro.ProducCreditoID FROM PRODUCTOSCREDITO pro, CREDITOS cre WHERE pro.ProducCreditoID = cre.ProductoCreditoID AND cre.CreditoID = Par_CreditoID) AS ProductoCre
			 ,(SELECT MAX(FechaVencim)  FROM PAGARECREDITO WHERE CreditoID = Par_CreditoID)AS Par_FechaultimaAmortizacion,
				(SELECT RegistroRECA FROM CREDITOS cr , PRODUCTOSCREDITO  pc WHERE cr.CreditoID = Par_CreditoID AND cr.ProductoCreditoID = pc.ProducCreditoID) AS Var_Reca, Var_TxtComision AS TxtComision,
				 CONVPORCANT((PAG.Capital+PAG.Interes+PAG.IVAInteres), '$','peso', 'Nacional')AS MontoCuotaInd
			FROM PAGARECREDITO PAG
				WHERE PAG.CreditoID = Par_CreditoID;

		 END IF;

	END IF;


END TerminaStore$$