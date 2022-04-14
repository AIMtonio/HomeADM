-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITO010CON
DELIMITER ;
DROP PROCEDURE IF EXISTS AMORTICREDITO010CON;
DELIMITER $$

CREATE PROCEDURE `AMORTICREDITO010CON`(
/*SP para la consulta de las amortizaciones de creditos individuales CONSOL*/
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

	
	DECLARE	DirOficialSi		CHAR(1);
	DECLARE Var_EstatusCredito	CHAR(1);		-- Estatus del Credito

	
	DECLARE Con_PagIndConsol INT(11);
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
	DECLARE	Var_DirecSuc    		VARCHAR(400); 
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
	DECLARE Var_PlazoCredito		VARCHAR(100);


	DECLARE Var_TotalCredito		DECIMAL(12,2); -- Monto del Crédito
	DECLARE Var_MontoComision   	DECIMAL(12,4);
	DECLARE Var_CobraFaltaPago  	CHAR(1);


	DECLARE Var_FechaMinisLetra     	VARCHAR(100);
	DECLARE Var_MontoTotPagarLetra  	VARCHAR(100);
	DECLARE Var_CapitalLetra        	VARCHAR(100);

	
	DECLARE Var_TipoCobroMora			CHAR(1);
	
    -- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';-- Fecha Vacia
	SET	Entero_Cero			:= 0;			-- Entero Cero
	SET Decimal_Cero		:= 0.0;			-- DECIMAL Cero
	
	SET Con_PagIndConsol :=1;           -- Consulta Pagare por integrante de Consol.


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
	
	SET SiCobraFaltaPago  	:= 'S';		-- Cobra Comision Falta de Pago: SI
	SET ComisionMonto		:= 'M';		-- Comision: Monto
	SET EsTasa_Fija			:='T';		-- Tasa Fija

	IF(Par_NumCon = Con_PagIndConsol) THEN
		SET Var_DescripcionProCre:=
			(	SELECT pro.Descripcion FROM PRODUCTOSCREDITO pro, CREDITOS cre 
				WHERE pro.ProducCreditoID = cre.ProductoCreditoID AND cre.CreditoID = Par_CreditoID);
		SET NumInstitucion  	:= (SELECT InstitucionID FROM PARAMETROSSIS);  
		SELECT	Direccion,		Nombre
		 INTO	DireccionInstitu,	NombreInstitu
			FROM INSTITUCIONES 
			WHERE InstitucionID = NumInstitucion;
		SELECT	DISTINCT
						Cre.ClienteID,	Cli.NombreCompleto,		Cre.TasaFija,				Cre.MontoCredito,Cre.FechaVencimien,
						Cre.FactorMora,	Cre.FechaMinistrado,	IFNULL(Dir.DireccionCompleta,Cadena_Vacia), MontoCredito, Cre.Estatus
                        
				INTO 	IDCliente,		NombreCliente,			Var_TasaFija,				MontoCred,			FechaVencCred,
						FactorM,		FechaMinis,				DireccionCte, 				Var_TotalCredito,	Var_EstatusCredito
			FROM CREDITOS Cre
					LEFT OUTER JOIN CLIENTES Cli
						ON Cre.ClienteID= Cli.ClienteID
					LEFT OUTER JOIN DIRECCLIENTE Dir
						ON Cli.ClienteID= Dir.ClienteID 
						AND Dir.Oficial = DirOficialSi
					WHERE Cre.CreditoID = Par_CreditoID;
		SET fechaPTF:= (SELECT FechaActual 
			FROM AMORTICREDITO 
			WHERE CreditoID = Par_CreditoID 
			 AND 	AmortizacionID=1);
			SELECT 			Suc.NombreSucurs,		Edo.Nombre, 		Mun.Nombre, 		Suc.DirecCompleta
					INTO  Sucurs,Var_EstadoSuc, Var_MuniSuc, Var_DirecSuc
				FROM 	CREDITOS	Cre
						INNER JOIN SUCURSALES Suc ON Cre.SucursalID = Suc.SucursalID
						INNER JOIN ESTADOSREPUB  Edo ON Suc.EstadoID =Edo.EstadoID
                        INNER JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID=Edo.EstadoID AND Mun.MunicipioID = Suc.MunicipioID					
				WHERE CreditoID		= Par_CreditoID;
			SET Var_TipoCobroMora	:=(SELECT TipCobComMorato FROM CREDITOS WHERE CreditoID = Par_CreditoID);
			IF(Var_TipoCobroMora = EsTasa_Fija)THEN
				SET Mora := FactorM;		
			ELSE 
				SET Mora := Var_TasaFija*FactorM;		
			END IF;
			SET FijaTasa := IFNULL(Var_TasaFIja,Decimal_Cero);
		
			SELECT cp.Descripcion
            INTO Var_PlazoCredito
            FROM	CREDITOS cr
			INNER JOIN PRODUCTOSCREDITO  pc  ON pc.ProducCreditoID = cr.ProductoCreditoID
			INNER JOIN CREDITOSPLAZOS    cp  ON cr.PlazoID     = cp.PlazoID
            AND CreditoID = Par_CreditoID;
		IF (Var_EstatusCredito = EstatusAutorizado OR Var_EstatusCredito = EstatusInactivo )THEN

            SELECT AMO.AmortizacionID,	AMO.FechaInicio,AMO.FechaVencim as FechaVencimiento,	FNFECHATEXTO(AMO.FechaExigible) AS FechaExigible,FNFECHATEXTO(AMO.FechaVencim) AS FechaVenciCuota,
				CONCAT('$ ',FORMAT((AMO.Capital+AMO.Interes+AMO.IVAInteres),2)) AS montoCuota,
				CONCAT('$ ',  FORMAT(AMO.Interes,2)) AS Interes,
                CONCAT('$ ',FORMAT(AMO.IVAInteres,2)) AS IVAInteres,
                CONCAT('$ ', FORMAT(AMO.Capital,2)) AS Capital,		DireccionInstitu,	 NombreInstitu,
				   NombreCliente,		Var_TasaFija,	FORMAT(MontoCred,2),	FechaVencCred,	 	 fechaPTF,
				   Sucurs,				FactorM,		FechaMinis,			DireccionCte,		 AMO.CreditoID,  
				   Var_EstadoSuc , 		Var_MuniSuc,	UPPER(CONCAT(Var_MuniSuc, ', ',Var_EstadoSuc)) AS Var_DirecSuc, Var_PlazoCredito,		Mora,		FijaTasa,
					REPLACE(UPPER(CONVPORCANT(MontoCred, '$','Peso', 'N.')), 'm. n.', 'M.N.') AS Montocletra, 
					Var_DescripcionProCre,
					REPLACE(CONCAT(SUBSTRING(CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''), 1, POSITION('(' IN CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''))),SUBSTRING(CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''), POSITION('(' IN CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''))+1,1),
						LOWER(SUBSTRING(CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''), POSITION('(' IN CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''))+2, POSITION(')' IN CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''))))),' por ciento','') AS TasaOrdinariaMensual,
					CONVPORCANT(ROUND((FijaTasa)*1.16/12,2),'%','2','') AS tasaAnualizadaMensual,
					CONVPORCANT(ROUND(FijaTasa,2),'%','2','') AS TasaOrdinariaAnual,
					CONVPORCANT(ROUND(FijaTasa*0.16,2),'%','2','') AS taiva,
					CONVPORCANT(ROUND(FijaTasa*0.16/12,2),'%','2','') AS taivaMensual,
					CONVPORCANT(ROUND((FijaTasa)*3/360,2),'%','2','') AS TasaMoraDiaria,
					CONVPORCANT(ROUND((FijaTasa)*3/12,2),'%','2','') AS TasaMoraMensual,
					CONVPORCANT(ROUND(((FijaTasa)*3/360)*1.16*MontoCred/100,2),'$','peso','Nacional') AS ValorMoraDiaria,
					FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS)) AS FechaSis,
					(SELECT pro.ProducCreditoID FROM PRODUCTOSCREDITO pro, CREDITOS cre WHERE pro.ProducCreditoID = cre.ProductoCreditoID AND cre.CreditoID = Par_CreditoID) AS ProductoCre
			 		,(SELECT MAX(FechaVencimiento)	FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID)AS Par_FechaultimaAmortizacion,
					(SELECT RegistroRECA FROM CREDITOS cr , PRODUCTOSCREDITO  pc WHERE cr.CreditoID = Par_CreditoID AND cr.ProductoCreditoID = pc.ProducCreditoID) AS Var_Reca,
					LOWER(FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS))) AS FechaActual,
                   	CONCAT(RIGHT(AMO.FechaInicio,2),' (',FNLETRACAPITAL(SUBSTRING(FUNCIONSOLONUMLETRAS(DAY(AMO.FechaInicio)), 1, LENGTH(FUNCIONSOLONUMLETRAS(DAY(AMO.FechaInicio)))-1)),') de ',FUNCIONMESNOMBRE(AMO.FechaInicio),' del ',
             			YEAR(AMO.FechaInicio),' (',UPPER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(AMO.FechaInicio)), 1, 1)),LOWER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(AMO.FechaInicio)), 2, LENGTH(FUNCIONSOLONUMLETRAS(YEAR(AMO.FechaInicio)))-2)),')') AS FechaEnLetras,
                 	CONCAT(RIGHT(FechaVencCred,2),' (',FNLETRACAPITAL(SUBSTRING(FUNCIONSOLONUMLETRAS(DAY(FechaVencCred)), 1, LENGTH(FUNCIONSOLONUMLETRAS(DAY(FechaVencCred)))-1)),') de ',FUNCIONMESNOMBRE(FechaVencCred),' del ',
                 		YEAR(FechaVencCred),' (',UPPER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(FechaVencCred)), 1, 1)),LOWER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(FechaVencCred)), 2, LENGTH(FUNCIONSOLONUMLETRAS(YEAR(FechaVencCred)))-2)),')') AS FechaEnLetrasVen
			FROM AMORTICREDITO AMO
				WHERE AMO.CreditoID = Par_CreditoID;	
		 ELSE 
		
	
			SELECT PAG.AmortizacionID,	PAG.FechaInicio,PAG.FechaVencim as FechaVencimiento,FNFECHATEXTO(PAG.FechaExigible) AS FechaExigible, FNFECHATEXTO(PAG.FechaVencim) AS FechaVenciCuota,
				CONCAT('$ ',FORMAT((PAG.Capital+PAG.Interes+PAG.IVAInteres),2)) AS montoCuota,
				CONCAT('$ ',  FORMAT(PAG.Interes,2)) AS Interes,
                CONCAT('$ ',FORMAT(PAG.IVAInteres,2)) AS IVAInteres,
                CONCAT('$ ', FORMAT(PAG.Capital,2)) AS Capital,		DireccionInstitu,	 NombreInstitu,
				   NombreCliente,		Var_TasaFija,	FORMAT(MontoCred,2),	FechaVencCred,	 	 fechaPTF,
				   Sucurs,				FactorM,		FechaMinis,			DireccionCte,		 PAG.CreditoID,  
				   Var_EstadoSuc , 		Var_MuniSuc,	UPPER(CONCAT(Var_MuniSuc, ', ',Var_EstadoSuc)) AS Var_DirecSuc, Var_PlazoCredito,		Mora,		 			FijaTasa,
					REPLACE(UPPER(CONVPORCANT(MontoCred, '$','Peso', 'N.')), 'm. n.', 'M.N.') AS Montocletra, 
					Var_DescripcionProCre,
					REPLACE(CONCAT(SUBSTRING(CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''), 1, POSITION('(' IN CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''))),SUBSTRING(CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''), POSITION('(' IN CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''))+1,1),
						LOWER(SUBSTRING(CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''), POSITION('(' IN CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''))+2, POSITION(')' IN CONVPORCANT(ROUND(FijaTasa /12 , 2),'%','2',''))))),' por ciento','') AS TasaOrdinariaMensual,
					CONVPORCANT(ROUND((FijaTasa)*1.16/12,2),'%','2','') AS tasaAnualizadaMensual,
					CONVPORCANT(ROUND(FijaTasa,2),'%','2','') AS TasaOrdinariaAnual,
					CONVPORCANT(ROUND(FijaTasa*0.16,2),'%','2','') AS taiva,
					CONVPORCANT(ROUND(FijaTasa*0.16/12,2),'%','2','') AS taivaMensual,
					CONVPORCANT(ROUND((FijaTasa)*3/360,2),'%','2','') AS TasaMoraDiaria,
					CONVPORCANT(ROUND((FijaTasa)*3/12,2),'%','2','') AS TasaMoraMensual,
					CONVPORCANT(ROUND(((FijaTasa)*3/360)*1.16*MontoCred/100,2),'$','peso','Nacional') AS ValorMoraDiaria,
					FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS)) AS FechaSis,
					(SELECT pro.ProducCreditoID FROM PRODUCTOSCREDITO pro, CREDITOS cre WHERE pro.ProducCreditoID = cre.ProductoCreditoID AND cre.CreditoID = Par_CreditoID) AS ProductoCre
			 		,(SELECT MAX(FechaVencimiento)	FROM PAGARECREDITO WHERE CreditoID = Par_CreditoID)AS Par_FechaultimaAmortizacion,
					(SELECT RegistroRECA FROM CREDITOS cr , PRODUCTOSCREDITO  pc WHERE cr.CreditoID = Par_CreditoID AND cr.ProductoCreditoID = pc.ProducCreditoID) AS Var_Reca,
					LOWER(FORMATEAFECHACONTRATO((SELECT FechaSistema FROM PARAMETROSSIS))) AS FechaActual,
                   	CONCAT(RIGHT(PAG.FechaInicio,2),' (',FNLETRACAPITAL(SUBSTRING(FUNCIONSOLONUMLETRAS(DAY(PAG.FechaInicio)), 1, LENGTH(FUNCIONSOLONUMLETRAS(DAY(PAG.FechaInicio)))-1)),') de ',FUNCIONMESNOMBRE(PAG.FechaInicio),' del ',
             			YEAR(PAG.FechaInicio),' (',UPPER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(PAG.FechaInicio)), 1, 1)),LOWER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(PAG.FechaInicio)), 2, LENGTH(FUNCIONSOLONUMLETRAS(YEAR(PAG.FechaInicio)))-2)),')') AS FechaEnLetras,
                 	CONCAT(RIGHT(FechaVencCred,2),' (',FNLETRACAPITAL(SUBSTRING(FUNCIONSOLONUMLETRAS(DAY(FechaVencCred)), 1, LENGTH(FUNCIONSOLONUMLETRAS(DAY(FechaVencCred)))-1)),') de ',FUNCIONMESNOMBRE(FechaVencCred),' del ',
                 		YEAR(FechaVencCred),' (',UPPER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(FechaVencCred)), 1, 1)),LOWER(SUBSTRING(FUNCIONSOLONUMLETRAS(YEAR(FechaVencCred)), 2, LENGTH(FUNCIONSOLONUMLETRAS(YEAR(FechaVencCred)))-2)),')') AS FechaEnLetrasVen
			FROM PAGARECREDITO PAG
				WHERE PAG.CreditoID = Par_CreditoID;	
		END IF;
	END IF;


END TerminaStore$$
