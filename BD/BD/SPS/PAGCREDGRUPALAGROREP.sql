-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREDGRUPALAGROREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREDGRUPALAGROREP`;DELIMITER $$

CREATE PROCEDURE `PAGCREDGRUPALAGROREP`(
	-- Reporte Pagare Grupal
	Par_GrupoID				INT(11),				-- Numero de Grupo
	Par_TipoRep				TINYINT UNSIGNED,		-- Tipo de Reporte
	/*Parametros de auditoria*/
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia  			CHAR(1);
	DECLARE ComisionMonto       	CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(14,2);
	DECLARE DiaCobComFalPago  		CHAR(1);
	DECLARE DirecOficial  			CHAR(1);
	DECLARE Entero_Cero   			INT;
	DECLARE EsGarantiaReal      	CHAR(1);
	DECLARE EstatusAutorizado 		CHAR(1);
	DECLARE EstatusInactivo   		CHAR(1);
	DECLARE EstatusVigente  		CHAR(1);
	DECLARE EstCerrado    			CHAR(1);
	DECLARE Fecha_Vacia   			DATE;
	DECLARE IntActivo   			CHAR(1);
	DECLARE Lis_Integra   			INT;
	DECLARE Lis_PreSeTe   			INT;
	DECLARE Presidente    			INT;
	DECLARE Secretario    			INT;
	DECLARE SiCobraFaltaPago  		CHAR(1);
	DECLARE SolAutoriza   			CHAR(1); -- Solicitud del credito Autorizado
	DECLARE SolDesembolsada 		CHAR(1);
	DECLARE Tesorero    			INT;
	DECLARE Tip_PagareTfija 		INT;
	DECLARE Tip_PagareTfijaAlternativa 		INT;  -- Tipo Alternativa 19
	DECLARE Tip_PTFGarant 			INT;

	-- Declaracion de Variables
	DECLARE DireccionClient   		VARCHAR(500);
	DECLARE DireccionCte    		VARCHAR(500);
	DECLARE DireccionInstitu  		VARCHAR(250);
	DECLARE FactorM       			FLOAT;
	DECLARE FechaActSis     		VARCHAR(200);
	DECLARE FechaInicCred     		DATE;
	DECLARE FechaMinis      		DATE;
	DECLARE fechaPTF      			DATE;
	DECLARE FechaVencCred     		DATE;
	DECLARE FormulaTasa    			VARCHAR(100);
	DECLARE FrecuencInt     		CHAR(1);
	DECLARE IDCliente       		INT(11);
	DECLARE MontoCred       		DECIMAL(12,2);
	DECLARE NombreCliente     		VARCHAR(200);
	DECLARE NombreInstitu     		VARCHAR(100);
	DECLARE NombreTasa      		VARCHAR(100);
	DECLARE NomGrupo            	VARCHAR(50);
	DECLARE NumInstitucion    		INT;
	DECLARE PisTasa       			FLOAT;
	DECLARE Puntos        			FLOAT;
	DECLARE Sucurs        			VARCHAR(50);
	DECLARE TasaVariable    		INT;
	DECLARE TechTasa      			FLOAT;
	DECLARE Var_Cargo           	INT;
	DECLARE Var_CargoSec        	INT;
	DECLARE Var_CargoTes        	INT;
	DECLARE Var_ClienteID       	INT;
	DECLARE Var_ClienteIDSec    	INT;
	DECLARE Var_ClienteIDTes    	INT;
	DECLARE Var_DescProCre    		VARCHAR(200);
	DECLARE Var_Direccion     		VARCHAR(500);
	DECLARE Var_DireccionSec    	VARCHAR(500);
	DECLARE Var_DireccionTes    	VARCHAR(500);
	DECLARE Var_EstatusCredito  	CHAR(1);
	DECLARE Var_FechaMinis    		DATE;
	DECLARE Var_FechaVencimi    	DATE;
	DECLARE Var_NombreEstadom   	VARCHAR(50);
	DECLARE Var_NombreMuni      	VARCHAR(50);
	DECLARE Var_NomPres       		VARCHAR(50);
	DECLARE Var_NomSec        		VARCHAR(50);
	DECLARE Var_NomTes        		VARCHAR(50);
	DECLARE Var_TasaMoraAnual 		DECIMAL(12,4);

	/* datos para obtener obligado solidario de mas alternativa*/
	DECLARE ObSol_ClienteID   		INT(11);
	DECLARE ObSol_Nombre    		VARCHAR(200);
	DECLARE ObSol_Direcc    		VARCHAR(300);
	DECLARE Cadena_Default    		VARCHAR(100);
	DECLARE FechaIniGpo     		DATE;
	DECLARE VQ_Garantia         	INT;
	DECLARE VQ_TipoDocu       		INT;

	-- Inicia declaracion FEMAZA
	DECLARE Var_CreditoID       	BIGINT(12);
	DECLARE Var_ProductoCredito     INT;
	DECLARE Var_TotalCredito    	DECIMAL(12,2); -- Monto del CrÃ©dito
	DECLARE Var_MontoComision     	DECIMAL(12,4);
	DECLARE Var_CobraFaltaPago    	CHAR(1);
	DECLARE Var_CriterioComFalPago  CHAR(1);
	DECLARE Var_TipCobComFalPago    CHAR(1);
	DECLARE Var_PerCobComFalPago    CHAR(1);
	DECLARE Var_TxtComision         VARCHAR(200);
	DECLARE Var_TipoComision      	CHAR(1);
	-- Fin declaracion FEMAZA

	-- Declaracion Alternativa 19
	DECLARE Var_NumeroCuenta			VARCHAR(100);
	DECLARE Var_NombreBanco				VARCHAR(100);
	DECLARE Var_Clabe					VARCHAR(100);
	DECLARE Var_ComGastosCobranza       DECIMAL(10,2);
	DECLARE Var_ComGastosCobranzaTxt    VARCHAR(100);
	DECLARE Var_FechaMinisTxt			VARCHAR(100);
	DECLARE Var_SucursalCred			INT(11);


	-- Asignacion de Constantes
	SET Presidente    		:=1;		-- Presidente
	SET Secretario    		:=3;		-- Secretario
	SET Tesorero    		:=2;		-- Tesorero
	SET Cadena_Vacia  		:= '';		-- Cadena vacia
	SET Fecha_Vacia   		:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero   		:= 0;		-- Entero cero
	SET Tip_PagareTfija 	:= 1;		-- Pagare Tasa Fija
	SET Lis_Integra   		:= 2;		-- Lista integrantes de Grupo
	SET Lis_PreSeTe   		:= 3;		-- Lista Presidente, Secretario y Tesorero del grupo
	SET Tip_PTFGarant 		:= 4;		-- Pagare Tasa Fija Garantia

	SET Tip_PagareTfijaAlternativa 	:= 5;		-- Tipo Pagare Alternativa 19
	SET EstCerrado    		:= 'C';		-- Estatus Cerrado
	SET DirecOficial  		:= 'S';		-- Direccion Oficial
	SET SolAutoriza   		:= 'A'; 	-- Solicitud de Credito Autorizado
	SET SolDesembolsada 	:= 'D';		-- Solicitud Desembolsada
	SET IntActivo   		:= 'A'; 	-- Integrante del Grupo Activo
	SET EstatusVigente  	:='V';  	-- Estatus Vigente del credito
	SET EstatusAutorizado 	:='A';      -- Estatus Autorizado
	SET EstatusInactivo   	:='I';      -- Estatus Inactivo
	SET Cadena_Default  	:= 'NO APLICA'; -- cadena DEFAULT para mas alternativa

	SET VQ_Garantia     	:= 3;		-- Garantia
	SET VQ_TipoDocu     	:= 13;		-- Tipo de Documento
	SET EsGarantiaReal  	:= 'S';		-- Garantia REAL: SI
	SET SiCobraFaltaPago  	:= 'S';		-- Cobra Falta de Pago: SI
	SET DiaCobComFalPago  	:= 'D';		-- Dia Comision Falta de Pago
	SET ComisionMonto 		:= 'M';		-- Monto Comision
	SET Var_TxtComision 	:= '';		-- Descripcion Monto Comision
	SET Decimal_Cero		:= 0.0;			-- DECIMAL Cero

	-- Query para reporte de pagare tasa fija de credito Grupal
	IF(Par_TipoRep = Tip_PagareTfija) THEN
		SELECT Edo.Nombre ,Mu.Nombre INTO Var_NombreEstadom,Var_NombreMuni
			FROM  SUCURSALES Suc,
				ESTADOSREPUB Edo,
				USUARIOS  Usu,
				MUNICIPIOSREPUB Mu
				WHERE UsuarioID   =Aud_Usuario
				AND Edo.EstadoID  = Suc.EstadoID
				AND Usu.SucursalUsuario= Suc.SucursalID
					AND Mu.MunicipioID=Suc.MunicipioID
					AND Edo.EstadoID = Mu.EstadoID;

		SELECT  InstitucionID,  FORMATEAFECHACONTRATO(FechaSistema)
			INTO  NumInstitucion, FechaActSis
			FROM  PARAMETROSSIS
			LIMIT 1;

		SELECT  Direccion,      Nombre
			INTO  DireccionInstitu, NombreInstitu
			FROM INSTITUCIONES
			WHERE InstitucionID = NumInstitucion;

		SELECT
			Sol.FechaVencimiento, Cre.FechaMinistrado, Cre.CreditoID, Cre.ProductoCreditoID, Cre.MontoCredito
			INTO
			Var_FechaVencimi,Var_FechaMinis, Var_CreditoID, Var_ProductoCredito, Var_TotalCredito   -- modificado para llenar variables FEMAZA
			FROM  CREDITOS      Cre,
			SOLICITUDCREDITO  Sol,
			INTEGRAGRUPOSCRE  Igr,
			GRUPOSCREDITO   Gru
			WHERE Gru.GrupoID = Igr.GrupoID
			AND Igr.GrupoID = Par_GrupoID
			AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
			AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
			AND Gru.EstatusCiclo = EstCerrado
			ORDER BY Cre.SolicitudCreditoID ASC
			LIMIT 1;

		SET Sucurs    := (SELECT S.NombreSucurs
					FROM USUARIOS U, SUCURSALES S
					WHERE UsuarioID=1
					AND U.SucursalUsuario= S.SucursalID);

		/* busqueda de obligado solidario por garantia REAL */
		SELECT
			cl.ClienteID,
			NombreCompleto
			INTO
			ObSol_ClienteID,
			ObSol_Nombre
			FROM
				INTEGRAGRUPOSCRE  ic,
				ASIGNAGARANTIAS   Asi ,
				GARANTIAS       Gar ,
				CLASIFGARANTIAS   Cla ,
				SOLICITUDCREDITO  sol,
				CLIENTES      cl
				WHERE
					ic.GrupoID = 1
				AND Asi.SolicitudCreditoID  = ic.SolicitudCreditoID
				AND Gar.GarantiaID      = Asi.GarantiaID
				AND Cla.TipoGarantiaID    = Gar.TipoGarantiaID
				AND Cla.ClasifGarantiaID  = Gar.ClasifGarantiaID
				AND Cla.EsGarantiaReal    = EsGarantiaReal
				AND Gar.TipoGarantiaID    !=  VQ_Garantia
				AND Gar.TipoDocumentoID   !=  VQ_TipoDocu
				AND sol.SolicitudCreditoID  = ic.SolicitudCreditoID
				AND cl.ClienteID      = sol.ClienteID
				LIMIT 1;

		SET ObSol_ClienteID := IFNULL(ObSol_ClienteID, Entero_Cero);

		/* busqueda de obligado solidario por garantia hipotecaria */
		IF ( ObSol_ClienteID =  Entero_Cero) THEN
			SELECT
				cl.ClienteID,
				NombreCompleto
			INTO
				ObSol_ClienteID,
				ObSol_Nombre
			FROM
				INTEGRAGRUPOSCRE ic,
				ASIGNAGARANTIAS   Asi ,
				GARANTIAS       Gar,
				SOLICITUDCREDITO  sol,
				CLIENTES      cl
			WHERE
				ic.GrupoID = 1
				AND Asi.SolicitudCreditoID  = ic.SolicitudCreditoID
				AND Gar.GarantiaID      = Asi.GarantiaID
				AND Gar.TipoDocumentoID   = VQ_TipoDocu
				AND Gar.TipoGarantiaID    = VQ_Garantia
				AND sol.SolicitudCreditoID  = ic.SolicitudCreditoID
				AND cl.ClienteID      = sol.ClienteID
				LIMIT 1;
		END IF;

		SET ObSol_ClienteID := IFNULL(ObSol_ClienteID, Entero_Cero);

		IF (ObSol_ClienteID = Entero_Cero) THEN
			SET ObSol_Nombre := Cadena_Default;
			SET ObSol_Direcc := Cadena_Default;
		  ELSE
			SET ObSol_Direcc :=
			(SELECT
				dr.DireccionCompleta
			FROM
				DIRECCLIENTE dr
			WHERE
				dr.ClienteID = ObSol_ClienteID
				AND dr.Oficial = DirecOficial
				LIMIT 1
			);
		END IF;

		-- SECCION FEMAZA
		SELECT prod.ProducCreditoID, prod.CobraFaltaPago, prod.CriterioComFalPag, prod.TipCobComFalPago, prod.PerCobComFalPag
			INTO Var_ProductoCredito, Var_CobraFaltaPago, Var_CriterioComFalPago, Var_TipCobComFalPago, Var_PerCobComFalPago
			FROM PRODUCTOSCREDITO AS prod, CREDITOS cr
				WHERE prod.ProducCreditoID=cr.ProductoCreditoID
				AND cr.CreditoID = Var_CreditoID;

		-- Para FEMAZA Generación de cadena para Comsion por pago tardÃ­o.
		IF (Var_CobraFaltaPago = SiCobraFaltaPago) THEN
			SET Var_TxtComision := 'De no pagarse en las fechas establecidas causara ademas un cargo por concepto de comision por pago tardio de ';

			SELECT  COM.TipoComision, COM.Comision
				INTO Var_TipoComision, Var_MontoComision
				FROM ESQUEMACOMISCRE AS COM INNER JOIN CREDITOS AS CRE ON CRE.ProductoCreditoID = COM.ProducCreditoID
				WHERE Var_TotalCredito BETWEEN COM.MontoInicial AND COM.MontoFinal AND CRE.ProductoCreditoID = Var_ProductoCredito AND CRE.CreditoID = Var_CreditoID;

			IF (Var_TipoComision = ComisionMonto) THEN
				SET Var_TxtComision := CONCAT(Var_TxtComision, '$ ', CAST(FORMAT(Var_MontoComision,2) AS CHAR), ' (', TRIM(FUNCIONNUMLETRAS(Var_MontoComision)), ')');
			  ELSE
				SET Var_TxtComision := CONCAT(Var_TxtComision, CAST(Var_MontoComision AS CHAR), ' % (', FUNCIONNUMEROSLETRAS(Var_MontoComision), ' Porciento)');
			END IF;

			IF (Var_PerCobComFalPago = DiaCobComFalPago) THEN
				SET Var_TxtComision := CONCAT(Var_TxtComision, '. Por cada dia de atraso.');
			  ELSE
				SET Var_TxtComision := CONCAT(Var_TxtComision, '. Por incumplimiento.');
			END IF;
		END IF;

		SELECT  CREDITOS.CreditoID INTO Var_CreditoID
			FROM  CLIENTES, INTEGRAGRUPOSCRE, SOLICITUDCREDITO,
				CREDITOS
				WHERE SOLICITUDCREDITO.GrupoID = Par_GrupoID
				AND  SOLICITUDCREDITO.ClienteID = INTEGRAGRUPOSCRE.ClienteID
				AND INTEGRAGRUPOSCRE.Cargo = 1
				AND CLIENTES.ClienteID = INTEGRAGRUPOSCRE.ClienteID
				AND INTEGRAGRUPOSCRE.GrupoID=SOLICITUDCREDITO.GrupoID
				AND  SOLICITUDCREDITO.CreditoID = CREDITOS.CreditoID
					AND CREDITOS.Estatus = 'A';

		SELECT  IF(Cre.TipCobComMorato = 'N',(Cre.TasaFija*PRO.FactorMora)/100 ,PRO.FactorMora )
			INTO Var_TasaMoraAnual
		FROM PRODUCTOSCREDITO PRO, CREDITOS     Cre
			WHERE Cre.CreditoID = Var_CreditoID
			AND Cre.ProductoCreditoID=PRO.ProducCreditoID;

		IF EXISTS(SELECT Estatus
			FROM CREDITOS
				WHERE GrupoID = Par_GrupoID
				AND Estatus IN(EstatusAutorizado,EstatusInactivo))THEN

			SELECT  MIN(Amo.AmortizacionID),         MIN(Amo.FechaInicio),      Var_FechaVencimi,Var_FechaMinis,    Amo.FechaExigible,            SUM((Amo.Capital+Amo.Interes+Amo.IVAInteres)) AS montoCuota,
				SUM(Amo.Interes) AS Interes,    SUM(Amo.IVAInteres) AS IVAinteres,  SUM(Amo.Capital) AS Capital,  FORMAT(SUM(Cre.MontoCredito),2) AS MontoCredito,
				MIN(Gru.NombreGrupo),          MIN(Cre.TasaFija),           MIN(Gru.CicloActual),        NombreInstitu,              DireccionInstitu,
				Sucurs,               MIN(Cre.FactorMora)  , Var_NombreEstadom,Var_NombreMuni,FORMAT((pow(10,2)*(MIN(Cre.TasaFija)/12)+0.5)/pow(10,2),2) AS Formula,Format(MIN(Cre.FactorMora)*((pow(10,2)*(MIN(Cre.TasaFija)/12)+0.5)/pow(10,2)),2)AS FactorM,
				IFNULL(MIN(pc.Descripcion), 'NO APLICA') AS Var_DescProCre,
				CONVPORCANT(SUM(Cre.MontoCredito),'$','Peso','Nacional') AS Montocletra,
				CONVPORCANT(MIN(Cre.TasaFija),'%','2','') AS TasaOrdinariaAnual,
				CONVPORCANT(ROUND(MIN(Cre.TasaFija) /12 , 2),'%','2','') TasaOrdinariaMensual,
				ObSol_Nombre,
				ObSol_Direcc,
				FechaActSis,CONVPORCANT(ROUND(Var_TasaMoraAnual,4),'%','4','') AS VarTasaFija,
				LOWER(FechaActSis) AS FechaActual,
				Var_TxtComision AS TxtComision
				FROM AMORTICREDITOAGRO    Amo,
					CREDITOS      Cre LEFT OUTER JOIN PRODUCTOSCREDITO pc ON pc.ProducCreditoID = Cre.ProductoCreditoID,
					SOLICITUDCREDITO  Sol,
					INTEGRAGRUPOSCRE  Igr,
					GRUPOSCREDITO   Gru
				WHERE Gru.GrupoID = Igr.GrupoID
				AND Igr.GrupoID = Par_GrupoID
				AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
				AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Amo.CreditoID      = Cre.CreditoID
				AND Gru.EstatusCiclo = EstCerrado
				GROUP BY FechaExigible;
		  ELSE -- si el credito ya esta vigente para imprimir el pagare se tomaran los datos de PAGARECREDITO.
			SELECT  MIN(Pag.AmortizacionID),       MIN(Pag.FechaInicio),          Var_FechaVencimi,       Var_FechaMinis,     Pag.FechaExigible,      SUM((Pag.Capital+Pag.Interes+Pag.IVAInteres)) AS montoCuota,
				SUM(Pag.Interes)AS Interes, SUM(Pag.IVAInteres) AS IVAinteres,  SUM(Pag.Capital) AS Capital,  FORMAT(SUM(Cre.MontoCredito),2) AS MontoCredito,
				MIN(Gru.NombreGrupo),        MIN(Cre.TasaFija),           MIN(Gru.CicloActual),        NombreInstitu,      DireccionInstitu,
				Sucurs,               MIN(Cre.FactorMora),            Var_NombreEstadom,       Var_NombreMuni, FORMAT((pow(10,2)*(MIN(Cre.TasaFija)/12)+0.5)/pow(10,2),2) AS Formula,Format(MIN(Cre.FactorMora)*((pow(10,2)*(MIN(Cre.TasaFija)/12)+0.5)/pow(10,2)),2)AS FactorM,
				IFNULL(MIN(pc.Descripcion), 'NO APLICA') AS Var_DescProCre,
				CONVPORCANT(SUM(Cre.MontoCredito),'$','Peso','Nacional') AS Montocletra,
				CONVPORCANT(MIN(Cre.TasaFija),'%','2','') AS TasaOrdinariaAnual,
				CONVPORCANT(ROUND(MIN(Cre.TasaFija) /12 , 2),'%','2','') TasaOrdinariaMensual,
				ObSol_Nombre,
				ObSol_Direcc,
				FechaActSis,CONVPORCANT(ROUND(Var_TasaMoraAnual,4),'%','4','') AS VarTasaFija,
				LOWER(FechaActSis) AS FechaActual,
				Var_TxtComision AS TxtComision
			FROM   PAGARECREDITO    Pag,
				CREDITOS      Cre LEFT OUTER JOIN PRODUCTOSCREDITO pc ON pc.ProducCreditoID = Cre.ProductoCreditoID,
				SOLICITUDCREDITO  Sol,
				INTEGRAGRUPOSCRE  Igr,
				GRUPOSCREDITO   Gru
				WHERE Gru.GrupoID = Igr.GrupoID
				AND Igr.GrupoID = Par_GrupoID
				AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
				AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
				AND Pag.CreditoID      = Cre.CreditoID
				AND Gru.EstatusCiclo = EstCerrado
				GROUP BY FechaExigible;
		END IF;
	END IF;


	-- Query para obtener deudores de pagare tasa fija de credito Grupal
	IF(Par_TipoRep = Lis_Integra) THEN
		SELECT  Cli.NombreCompleto, Cli.ClienteID, Dir.DireccionCompleta
		FROM
			SOLICITUDCREDITO  Sol,
			INTEGRAGRUPOSCRE  Igr,
			GRUPOSCREDITO   Gru,
			CLIENTES Cli,
			DIRECCLIENTE Dir
			WHERE Gru.GrupoID = Igr.GrupoID
			AND Igr.GrupoID = Par_GrupoID
			AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
			AND   Gru.EstatusCiclo = EstCerrado
			AND    Sol.ClienteID= Cli.ClienteID
			AND    Cli.ClienteID= Dir.ClienteID
			AND    Dir.Oficial = DirecOficial
			AND    (Sol.Estatus= SolAutoriza OR Sol.Estatus= SolDesembolsada)
			AND    Igr.Estatus= IntActivo;
	END IF;

	-- Query para obtener garantes de pagare tasa fija de credito Grupal
	IF(Par_TipoRep = Tip_PTFGarant) THEN
		SELECT DISTINCT (CASE
			WHEN Gr.ClienteID != Entero_Cero THEN (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID= Gr.ClienteID)
			WHEN (Gr.GaranteID != Entero_Cero AND  Gr.ClienteID != Entero_Cero ) THEN (SELECT GaranteNombre FROM GARANTIAS WHERE GaranteID= Gr.GaranteID)
			END) AS garante,
			(CASE
			WHEN Gr.ClienteID != Entero_Cero THEN (SELECT DireccionCompleta FROM DIRECCLIENTE WHERE ClienteID=Gr.ClienteID  AND Oficial= DirecOficial)
			WHEN Gr.GaranteID != Entero_Cero THEN (SELECT CONCAT(Gar.CalleGarante,', No. ',Gar.NumExtGarante,', Interior ',Gar.NumIntGarante,', Col. ',
									Gar.ColoniaGarante,' C.P. ',Gar.CodPostalGarante,', ',Est.Nombre, ', ', Mun.Nombre)
								FROM GARANTIAS Gar,
									ESTADOSREPUB    Est,
									MUNICIPIOSREPUB   Mun
									WHERE Gar.GaranteID =Gr.GaranteID
									AND Gar.EstadoIDGarante   = Est.EstadoID
									AND Est.EstadoID    = Mun.EstadoID
									AND Mun.MunicipioID   = Gar.MunicipioID )
			END)AS direcGarante
		FROM
			SOLICITUDCREDITO  Sol,
			INTEGRAGRUPOSCRE  Igr,
			GRUPOSCREDITO   Gru,
			ASIGNAGARANTIAS   Asi,
			GARANTIAS     Gr
		WHERE Gru.GrupoID = Igr.GrupoID
		AND Igr.GrupoID = Par_GrupoID
		AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
		AND Sol.SolicitudCreditoID=Asi.SolicitudCreditoID
		AND Asi.SolicitudCreditoID=Igr.SolicitudCreditoID
		AND Asi.GarantiaID= Gr.GarantiaID
		AND Gru.EstatusCiclo = EstCerrado;
	END IF;
END TerminaStore$$