-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOSCREDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOSCREDREP`;DELIMITER $$

CREATE PROCEDURE `CONTRATOSCREDREP`(
	-- SP para obtener informacion de contratos de creditos
    Par_GrupoID         INT,				-- Numero de Grupo
    Par_TipoReporte     INT,				-- Tipo de Reporte


    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria
			)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_TasaAnual   		DECIMAL(12,4);
	DECLARE Var_TasaMens   	 		DECIMAL(12,4);
	DECLARE Var_TasaFlat    		DECIMAL(12,4);
	DECLARE Var_CAT         		DECIMAL(12,4);
	DECLARE Var_CreditoID   		BIGINT(12);
	DECLARE Var_TotInteres  		DECIMAL(14,2);
	DECLARE Var_NumAmorti   		INT;
	DECLARE Var_MontoCred   		DECIMAL(14,2);
	DECLARE Var_SumMonCred          DECIMAL(14,2);
	DECLARE Var_PorcGarLiq  		DECIMAL(12,2);
	DECLARE Var_MontoGarLiq   		DECIMAL(14,2);
	DECLARE Var_MonGarLiq   		VARCHAR(20);
	DECLARE Var_Plazo       		VARCHAR(100);
	DECLARE Var_FechaInicio   		DATE;
	DECLARE Var_FechaVenc   		DATE;
	DECLARE Var_MontoSeguro 		DECIMAL(14,2);
	DECLARE Var_PorcCobert  		DECIMAL(12,4);
	DECLARE Var_NomRepres   		VARCHAR(300);
	DECLARE Var_Periodo     		INT;
	DECLARE Var_Frecuencia  		CHAR(1);
	DECLARE Var_DesFrec     		VARCHAR(100);
	DECLARE Var_FacRiesgo   		DECIMAL(12,6);
	DECLARE Var_FrecSeguro  		VARCHAR(100);
	DECLARE Var_NumRECA    			VARCHAR(200);
	DECLARE Var_DiaVencimiento		VARCHAR(20);
	DECLARE Var_MesVencimiento		VARCHAR(20);
	DECLARE Var_AnioVencimiento		VARCHAR(20);
	DECLARE Var_RepresentanteLegal	VARCHAR(200);
	DECLARE Var_DirccionInstitucion	VARCHAR(300);
	DECLARE Var_SexoRepteLegal		CHAR(200);
	DECLARE Var_TelInstitucion		VARCHAR(20);
	DECLARE Var_NombreEstado		VARCHAR(100);
	DECLARE Var_RFCOficial 			VARCHAR(20);
	DECLARE Var_DiaSistema			INT;
	DECLARE Var_AnioSistema			INT;
	DECLARE Var_MesSistema 			VARCHAR(20);
	DECLARE Var_NomCortoInstit		VARCHAR(50);
	DECLARE Var_MtoLetra            VARCHAR(100);
	DECLARE Var_GarantiaLetra       VARCHAR(100);
	DECLARE Var_DesFrecLet          VARCHAR(50);
	DECLARE Var_TotPagar            DECIMAL(14,2);
	DECLARE Var_TotPagLetra         VARCHAR(100);
	DECLARE Var_NombreIntegrantes	VARCHAR(1000);
	DECLARE MontoCredito            VARCHAR(150);
	DECLARE Var_Recurso				VARCHAR(100);
	DECLARE MontoTotPagar           VARCHAR(150);
	DECLARE Var_NomGrupoCred		CHAR(50);
	DECLARE Var_Cliente             VARCHAR(50);
	DECLARE Var_CURP                VARCHAR(18);
	DECLARE Var_Telefono            VARCHAR(15);
	DECLARE Var_DireccionCompleta   VARCHAR(250);
	DECLARE Var_NombreDeudor        VARCHAR(250);
	DECLARE Var_NumRegTemporal      INT;
	DECLARE Var_DestinoProyecto     VARCHAR(250);
	DECLARE Var_NumIntegrantes      INT;
	DECLARE Var_TasaMoraAnual       DECIMAL(12,4);
	DECLARE Var_TasaMoratoria       DECIMAL(12,4);


	DECLARE	TipoContratoGrupal		INT;
	DECLARE	Var_TipoPersona			CHAR(1);
	DECLARE	Var_ClienteID			INT;
	DECLARE Var_NomInst				VARCHAR(200);
	DECLARE Var_DescProducto		VARCHAR(200);
	DECLARE Var_ProductoCre			INT(11);
	DECLARE Var_FechaActualTxt		VARCHAR(200);
	DECLARE Var_GarLiqGrup			DECIMAL(12,2);
	DECLARE Gar_DescGarantia 		VARCHAR(200);
	DECLARE	Gar_NumFactura			VARCHAR(200);
	DECLARE	GHi_DescGarantia		VARCHAR(200);
	DECLARE	GHi_Estado				VARCHAR(200);
	DECLARE	GHi_Municipio			VARCHAR(200);


	DECLARE	PersonaFisica			CHAR(1);
	DECLARE	PersonaMoral			CHAR(1);
	DECLARE DirecOficial			CHAR(1);
	DECLARE FirmaContMasAlt			INT(11);
	DECLARE FirmaCaratMasAlt		INT(11);
	DECLARE VQ_Garantia       		INT;
	DECLARE VQ_TipoDocu       		INT;

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia        	CHAR(1);
	DECLARE	Cadena_Default			VARCHAR(100);
	DECLARE Entero_Cero         	INT;
	DECLARE Fecha_Vacia         	DATE;
	DECLARE Est_Activo          	CHAR(1);
	DECLARE DirOficial          	CHAR(1);
	DECLARE Int_Presiden        	INT;
	DECLARE Tipo_Anexo          	INT;
	DECLARE Tipo_EncContrato		INT;
	DECLARE Tipo_CaratulaTR	    	INT;
	DECLARE Con_IntegraGrupo    	INT;
	DECLARE FirmaDeudores	    	INT;
	DECLARE limiteTabla		    	INT;
	DECLARE Contador				INT;
	DECLARE Numero					INT;
	DECLARE IntegrantesGrupos   	INT;
	DECLARE TasaFijaAnual   		CHAR(1);
    DECLARE Var_MaxIntegrantes 		INT(11);
	DECLARE Var_MinIntegrantes 		INT(11);
	DECLARE Tipo_CaratulaNP			INT;


	DECLARE	TipoCttoGpalSTF			INT;
	DECLARE	Var_TipoCred			VARCHAR(50);
	DECLARE	Var_FecVenTxt			VARCHAR(100);
	DECLARE	Var_SucCreID			INT;
	DECLARE	Var_SucCreDir			VARCHAR(200);
	DECLARE	Var_SucCreEdo			VARCHAR(100);
	DECLARE	FecMinistrado			DATE;
	DECLARE	Tipo_Presi				INT;
	DECLARE	Tipo_Tesorero			INT;
	DECLARE	Tipo_Secre				INT;
	DECLARE	Var_NomPresi			VARCHAR(150);
	DECLARE	Var_NomTesore			VARCHAR(150);
	DECLARE	Var_NomSecre			VARCHAR(150);
	DECLARE	Var_PresiDir			VARCHAR(250);
	DECLARE	Var_TipoCobroMora		CHAR(1);
	DECLARE Var_CicloActual			INT(11);
	DECLARE N_VecesLaTasa			CHAR(1);
	DECLARE Var_DescPlazo			VARCHAR(50);
	DECLARE Var_PlazoID				VARCHAR(20);


	DECLARE Var_DomSuc          	VARCHAR(250);
	DECLARE Var_MuniEdo         	VARCHAR(250);
	DECLARE Var_ProductoCred    	INT(11);

	-- Alternativa 19
	DECLARE NombreInt				VARCHAR(500);
	DECLARE NombreSucurs			VARCHAR(50);
	DECLARE Var_NomLocRP            VARCHAR(150);
	DECLARE Var_NomEstRP			VARCHAR(50);
	DECLARE Var_EscrituraPublic     VARCHAR(50);
	DECLARE Var_VolumenEsc          VARCHAR(20);
	DECLARE Var_NomNotario          VARCHAR(100);
	DECLARE Var_Notaria             INT(11);
	DECLARE Var_NomLocEsc           VARCHAR(150);
	DECLARE Var_NomEstEsc           VARCHAR(100);
	DECLARE Var_NotDireccion        VARCHAR(240);
	DECLARE FechaEscPub				DATE;
	DECLARE FechaRegPub				DATE;
	DECLARE FechaEscPubTxt			VARCHAR(100);
	DECLARE FechaRegPubTxt			VARCHAR(100);
	DECLARE RFCInstitucion			VARCHAR(13);
	DECLARE EstadoSuc				VARCHAR(100);
	DECLARE MunicipioSuc			VARCHAR(150);
	DECLARE Var_GastosCobranza		DECIMAL(10,2);
	DECLARE Var_GastosCobranzaTxt	VARCHAR(100);
	DECLARE Var_TasaAnualTxt		VARCHAR(100);
	DECLARE Var_TasaMensTxt			VARCHAR(100);
	DECLARE Var_TasaMensMoraTxt		VARCHAR(100);
	DECLARE Var_FactorM				DECIMAL(14,2);
	DECLARE Var_FechaMinisTxt		VARCHAR(100);
	DECLARE Var_PorGarLiqTxt		VARCHAR(100);
	DECLARE Var_MontoFarLiqTxt		VARCHAR(100);
	DECLARE Var_DescGarantia		VARCHAR(60);
	DECLARE	Var_DocGarantia			VARCHAR(60);

	-- CONSTANTES
	DECLARE Int_GrupoAlt			INT(11);
	DECLARE Tipo_CaratulaAlt		INT(11);
	DECLARE TipoConstit				CHAR(1);
	DECLARE EstSoltero              CHAR;
	DECLARE EstCasBienSep           CHAR(2);
	DECLARE EstCasBienMan           CHAR(2);
	DECLARE EstcasBienManCap        CHAR(2);
	DECLARE EstViudo                CHAR(2);
	DECLARE EstDivorciado           CHAR(2);
	DECLARE EstSeparado             CHAR(2);
	DECLARE EsteUnionLibre          CHAR;

	DECLARE TxtSoltero              VARCHAR(50);
	DECLARE TxtCasBienSep           VARCHAR(50);
	DECLARE TxtCasBienMan           VARCHAR(50);
	DECLARE TxtcasBienManCap        VARCHAR(50);
	DECLARE TxtViudo                VARCHAR(50);
	DECLARE TxtDivorciado           VARCHAR(50);
	DECLARE TxtSeparado             VARCHAR(50);
	DECLARE TxteUnionLibre          VARCHAR(50);

	DECLARE FrecSemanal             CHAR;
	DECLARE FrecCatorcenal          CHAR;
	DECLARE FrecQuincenal           CHAR;
	DECLARE FrecMensual             CHAR;
	DECLARE FrecPeriodica           CHAR;
	DECLARE FrecBimestral           CHAR;
	DECLARE FrecTrimestral          CHAR;
	DECLARE FrecTetramestral        CHAR;
	DECLARE FrecSemestral           CHAR;
	DECLARE FrecAnual               CHAR;

	DECLARE TxtSemanales            VARCHAR(20);
	DECLARE TxtCatorcenales         VARCHAR(20);
	DECLARE TxtQuincenales          VARCHAR(20);

	DECLARE TxtMensuales            VARCHAR(20);
	DECLARE TxtPeriodos             VARCHAR(20);
	DECLARE TxtBimestrales          VARCHAR(20);
	DECLARE TxtTrimestrales         VARCHAR(20);
	DECLARE TxtTetramestrales       VARCHAR(20);
	DECLARE TxtSemestrales          VARCHAR(20);
	DECLARE TxtAnuales  			VARCHAR(20);

	DECLARE TxtNacionM				CHAR(1);
	DECLARE TxtNacionE				CHAR(1);
	DECLARE TxtMexicana				VARCHAR(15);
	DECLARE TxtExtranjera			VARCHAR(15);
	DECLARE Masculino               CHAR;
	DECLARE Femenino                CHAR;
	DECLARE TxtMasculino            VARCHAR(20);
	DECLARE TxtFemenino             VARCHAR(20);

	-- CURSOR para obtener datos del deudor
	DECLARE CURSORDEUDOR CURSOR FOR
	SELECT NombreCompleto
			FROM INTEGRAGRUPOSCRE Ing,
				 SOLICITUDCREDITO Sol,
				 CREDITOS Cre,
				 PRODUCTOSCREDITO Pro,
				 CLIENTES Cli
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Cargo     != Int_Presiden
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
			  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
			  AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
			  AND Cre.ClienteID = Cli.ClienteID;

	-- CURSOR para obtener los datos de integrantes del grupo
	DECLARE CURSORINTEGRANTES CURSOR FOR
	SELECT NombreCompleto
			FROM INTEGRAGRUPOSCRE Ing,
				 SOLICITUDCREDITO Sol,
				 CLIENTES Cli
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
			  AND Sol.ClienteID = Cli.ClienteID;

	-- Asignacion de Constantes
	SET Cadena_Vacia        := '';
	SET Cadena_Default		:=	'NO APLICA';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Est_Activo          := 'A';
	SET DirOficial          := 'S';
	SET Int_Presiden        := 1;
	SET Tipo_Anexo          := 1;
	SET Tipo_EncContrato    := 2;
	SET Tipo_CaratulaTR     := 3;
	SET Con_IntegraGrupo    := 4;
	SET FirmaDeudores       := 5;
	SET IntegrantesGrupos	:= 6;
	SET Contador			:= 0;
	SET limiteTabla			:= 0;
	SET TasaFijaAnual		:= 'T';


	SET TipoContratoGrupal	:=	7;
	SET FirmaContMasAlt		:=	8;
	SET FirmaCaratMasAlt	:=	9;
	SET	PersonaFisica		:=	'F';
	SET	PersonaMoral		:=	'M';
	SET DirecOficial		:=	'S';
	SET VQ_Garantia   		:=	3;
	SET VQ_TipoDocu   		:=	13;


	SET	TipoCttoGpalSTF		:=	10;
	SET	Tipo_Presi			:=	1;
	SET	Tipo_Tesorero		:=	2;
	SET	Tipo_Secre			:=	3;
	SET N_VecesLaTasa		:= 'N';

	SET Int_GrupoAlt		:= 11;
	SET Tipo_CaratulaAlt	:= 12;
	SET TipoConstit			:='C';
	SET EstSoltero                  := 'S';
	SET EstCasBienSep               := 'CS';
	SET EstCasBienMan               := 'CM';
	SET EstcasBienManCap            := 'CC';
	SET EstViudo                    := 'V';

	SET EstDivorciado               := 'D';
	SET EstSeparado                 := 'SE';
	SET EsteUnionLibre              := 'U';
	SET TxtSoltero                  := 'SOLTERO';
	SET TxtCasBienSep               := 'CASADO BIENES SEPARADOS';
	SET TxtCasBienMan               := 'CASADO BIENES MANCOMUNADOS';
	SET TxtcasBienManCap            := 'CASADO BIENES MANCOMUNADOS CON CAPITULACION';
	SET TxtViudo                    := 'VIUDO';
	SET TxtDivorciado               := 'DIVORCIADO';
	SET TxtSeparado                 := 'SEPARADO';
	SET TxteUnionLibre              := 'UNION LIBRE';

	SET FrecSemanal                 :='S' ;
	SET FrecCatorcenal              :='C' ;
	SET FrecQuincenal               :='Q' ;
	SET FrecMensual                 :='M' ;
	SET FrecPeriodica               :='P' ;
	SET FrecBimestral               :='B' ;
	SET FrecTrimestral              :='T' ;
	SET FrecTetramestral            :='R' ;
	SET FrecSemestral               :='E' ;
	SET FrecAnual                   :='A' ;

	SET TxtPeriodos                 := 'periodos';
	SET TxtSemanales                :=  'semanales'  ;
	SET TxtCatorcenales             :=  'catorcenales' ;
	SET TxtQuincenales              :=  'quincenales' ;
	SET TxtMensuales                :=  'mensuales' ;
	SET TxtBimestrales              :=  'bimestrales' ;
	SET TxtTrimestrales             := 'trimestrales' ;
	SET TxtTetramestrales           := 'tetramestrales' ;
	SET TxtSemestrales              := 'semestrales';
	SET TxtAnuales                  := 'anuales';


	SET TxtNacionM			:= 'N';
	SET TxtNacionE			:= 'E';
	SET TxtMexicana		    := 'MEXICANA';
	SET TxtExtranjera		:= 'ENTRANJERA';

	SET Masculino                   := 'M';
	SET Femenino                    := 'F';
	SET TxtMasculino                := 'MASCULINO';
	SET TxtFemenino                 := 'FEMENINO';
	SET Tipo_CaratulaNP		:= 15;


	IF (Par_TipoReporte = Tipo_Anexo) THEN

		SET Var_TasaAnual   := Entero_Cero;
		SET Var_TasaMens    := Entero_Cero;
		SET Var_TasaFlat    := Entero_Cero;
		SET Var_MontoSeguro := Entero_Cero;
		SET Var_PorcCobert  := Entero_Cero;

		SELECT
			Sol.TasaFija,        Sol.CreditoID, Sol.NumAmortizacion, Sol.MontoAutorizado,
			Sol.PeriodicidadCap, Sol.FrecuenciaCap
		INTO
			Var_TasaAnual,      Var_CreditoID, Var_NumAmorti,       Var_MontoCred,
			Var_Periodo,        Var_Frecuencia
		FROM
			INTEGRAGRUPOSCRE Ing,
			SOLICITUDCREDITO Sol
		WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Cargo     = Int_Presiden
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID;

		SET Var_NomGrupoCred:= (SELECT NombreGrupo FROM GRUPOSCREDITO WHERE GrupoID=Par_GrupoID);
		SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
		SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
		SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);
		SET Var_TasaMens    := ROUND(Var_TasaAnual / 12, 4);
        SET Var_Periodo     := IFNULL(Var_Periodo,Entero_Cero);
        SET Var_Frecuencia     := IFNULL(Var_Frecuencia,Entero_Cero);
        SET Var_MontoCred   := IFNULL(Var_MontoCred,Entero_Cero);

		SELECT  SUM(Amo.Interes) INTO Var_TotInteres
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Var_CreditoID;
		SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
		SET Var_TasaFlat    := CASE WHEN Var_Periodo = Entero_Cero OR Var_MontoCred=Entero_Cero THEN Entero_Cero ELSE ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
									Var_Periodo ) * 30 * 100 END;
		SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);
		SELECT	Cre.ValorCAT,  ROUND(Cre.PorcGarLiq,2), Pro.FactorRiesgoSeguro, Pro.RegistroRECA, Cre.FechaVencimien,
			   CONCAT(PrimerNombre,
						(CASE WHEN IFNULL(SegundoNombre, '') != '' THEN CONCAT(' ', SegundoNombre)
							  ELSE Cadena_Vacia
						 END),
					   (CASE WHEN IFNULL(TercerNombre, '') != '' THEN  CONCAT(' ', TercerNombre)
							 ELSE Cadena_Vacia
						END), ' ',
					  ApellidoPaterno, ' ', ApellidoMaterno) , Pro.Descripcion, Pro.ProducCreditoID
		INTO	Var_CAT,        Var_PorcGarLiq,		Var_FacRiesgo,  Var_NumRECA,    Var_FechaVenc,
				Var_NomRepres,	Var_DescProducto,	Var_ProductoCre
			FROM CREDITOS Cre,
				 PRODUCTOSCREDITO Pro,
				 CLIENTES Cli
			WHERE Cre.CreditoID = Var_CreditoID
			  AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
			  AND Cre.ClienteID = Cli.ClienteID;

		SET Var_CAT  := IFNULL(Var_CAT, Entero_Cero);
		SET Var_PorcGarLiq  := IFNULL(Var_PorcGarLiq, Entero_Cero);
		SET Var_FacRiesgo  := IFNULL(Var_FacRiesgo, Entero_Cero);
		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semanal'
					WHEN Var_Frecuencia ='C' THEN 'catorcenal'
					WHEN Var_Frecuencia ='Q' THEN 'quincenal'
					WHEN Var_Frecuencia ='M' THEN 'mensual'
					WHEN Var_Frecuencia ='P' THEN 'periodica'
					WHEN Var_Frecuencia ='B' THEN 'bimestral'
					WHEN Var_Frecuencia ='T' THEN 'trimestral'
					WHEN Var_Frecuencia ='R' THEN 'tetramestral'
					WHEN Var_Frecuencia ='E' THEN 'semestral'
					WHEN Var_Frecuencia ='A' THEN 'anual'
				END INTO Var_DesFrec;
		SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);
		SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
				CASE
					WHEN Var_Frecuencia ='S' THEN 'semanas'
					WHEN Var_Frecuencia ='C' THEN 'catorcenas'
					WHEN Var_Frecuencia ='Q' THEN 'quincenas'
					WHEN Var_Frecuencia ='M' THEN 'meses'
					WHEN Var_Frecuencia ='P' THEN 'periodos'
					WHEN Var_Frecuencia ='B' THEN 'bimestres'
					WHEN Var_Frecuencia ='T' THEN 'trimestres'
					WHEN Var_Frecuencia ='R' THEN 'tetramestres'
					WHEN Var_Frecuencia ='E' THEN 'semestres'
					WHEN Var_Frecuencia ='A' THEN 'años'

				END ) INTO Var_Plazo;
		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semanales'
					WHEN Var_Frecuencia ='C' THEN 'catorcenales'
					WHEN Var_Frecuencia ='Q' THEN 'quincenales'
					WHEN Var_Frecuencia ='M' THEN 'mensuales'
					WHEN Var_Frecuencia ='P' THEN 'periodos'
					WHEN Var_Frecuencia ='B' THEN 'bimestrales'
					WHEN Var_Frecuencia ='T' THEN 'trimestrales'
					WHEN Var_Frecuencia ='R' THEN 'tetramestrales'
					WHEN Var_Frecuencia ='E' THEN 'semestrales'
					WHEN Var_Frecuencia ='A' THEN 'anuales'

				END INTO Var_DesFrecLet;

		SELECT SUM(Cre.MontoSeguroVida), SUM(Cre.MontoCredito)  INTO Var_MontoSeguro, Var_SumMonCred
			FROM INTEGRAGRUPOSCRE Ing,
				 CREDITOS Cre
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID    = Cre.SolicitudCreditoID;

		SET Var_MontoSeguro		:= IFNULL(Var_MontoSeguro, Entero_Cero);
		SET Var_MontoGarLiq		:= (SELECT  SUM(AporteCliente) AS MontoTotal
										FROM CREDITOS Cre
											INNER JOIN INTEGRAGRUPOSCRE Ing
											ON Cre.SolicitudCreditoID = Ing.SolicitudCreditoID
										WHERE Ing.GrupoID= Par_GrupoID);

		 SET Var_MonGarLiq 		:= FORMAT(Var_MontoGarLiq,2);

		SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_TotPagar
			FROM INTEGRAGRUPOSCRE Ing,
				 CREDITOS Cre,
				 AMORTICREDITO Amo
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID    = Cre.SolicitudCreditoID
			  AND Amo.CreditoID = Cre.CreditoID;

		SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);

		SELECT FUNCIONNUMLETRAS(Var_TotPagar) INTO Var_TotPagLetra;
		SELECT FUNCIONNUMLETRAS(Var_SumMonCred) INTO Var_MtoLetra;
		SELECT FUNCIONNUMLETRAS(Var_MontoGarLiq) INTO Var_GarantiaLetra;

		SET Var_PorcCobert  :=  ROUND((Var_FacRiesgo / 7 * Var_Periodo * 1000), 4);
		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semana'
					WHEN Var_Frecuencia ='C' THEN 'catorcena'
					WHEN Var_Frecuencia ='Q' THEN 'quincena'
					WHEN Var_Frecuencia ='M' THEN 'mes'
					WHEN Var_Frecuencia ='P' THEN 'periodo'
					WHEN Var_Frecuencia ='B' THEN 'bimestre'
					WHEN Var_Frecuencia ='T' THEN 'trimestre'
					WHEN Var_Frecuencia ='R' THEN 'tetramestre'
					WHEN Var_Frecuencia ='E' THEN 'semestre'
					WHEN Var_Frecuencia ='A' THEN 'año'

				END  INTO Var_FrecSeguro;

		SELECT DAY(Var_FechaVenc) , 	YEAR(Var_FechaVenc) , CASE
					WHEN month(Var_FechaVenc) = 1  THEN 'Enero'
					WHEN month(Var_FechaVenc) = 2  THEN 'Febrero'
					WHEN month(Var_FechaVenc) = 3  THEN 'Marzo'
					WHEN month(Var_FechaVenc) = 4  THEN 'Abril'
					WHEN month(Var_FechaVenc) = 5  THEN 'Mayo'
					WHEN month(Var_FechaVenc) = 6  THEN 'Junio'
					WHEN month(Var_FechaVenc) = 7  THEN 'Julio'
					WHEN month(Var_FechaVenc) = 8  THEN 'Agosto'
					WHEN month(Var_FechaVenc) = 9  THEN 'Septiembre'
					WHEN month(Var_FechaVenc) = 10 THEN 'Octubre'
					WHEN month(Var_FechaVenc) = 11 THEN 'Noviembre'
					WHEN month(Var_FechaVenc) = 12 THEN 'Diciembre' END

		INTO 	Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;

		SET MontoCredito := CONCAT('$ ', FORMAT(Var_SumMonCred, 2), ', (', Var_MtoLetra, ' M.N.)');
		SET MontoTotPagar := CONCAT('$ ', FORMAT(Var_TotPagar, 2), ', (', Var_TotPagLetra, ' M.N.)');

		SELECT
			ins.Nombre, ins.DirFiscal , FORMATEAFECHACONTRATO(FechaSistema)
		INTO		Var_NomInst, Var_DirccionInstitucion, Var_FechaActualTxt
		FROM
			PARAMETROSSIS par,
			INSTITUCIONES ins
		WHERE
			par.InstitucionID = ins.InstitucionID;


		SELECT 	ROUND(Porcentaje ,2)
		INTO	Var_GarLiqGrup
		FROM 	ESQUEMAGARANTIALIQ
		WHERE 	ProducCreditoID	= 	Var_ProductoCre
		AND 	LimiteInferior	<= 	Var_SumMonCred
		AND 	LimiteSuperior	>= 	Var_SumMonCred
		LIMIT 1;


		SELECT
			 Gar.Observaciones,
			 Gar.SerieFactura
		INTO
			Gar_DescGarantia,
			Gar_NumFactura
		FROM
			INTEGRAGRUPOSCRE 	ic,
			ASIGNAGARANTIAS 	Asi	,
			GARANTIAS 			Gar	,
			CLASIFGARANTIAS		Cla
		WHERE
			ic.GrupoID = Par_GrupoID
			AND Asi.SolicitudCreditoID	=	ic.SolicitudCreditoID
			AND Gar.GarantiaID			=	Asi.GarantiaID
			AND	Cla.TipoGarantiaID		=	Gar.TipoGarantiaID
			AND	Cla.ClasifGarantiaID	=	Gar.ClasifGarantiaID
			AND Cla.EsGarantiaReal		=	'S'
			AND Gar.TipoGarantiaID		!=	VQ_Garantia
			AND Gar.TipoDocumentoID		!=	VQ_TipoDocu
			LIMIT 1;


		SELECT
			Gar.Observaciones,
			ed.Nombre,
			CONCAT('estado de ',mun.Nombre)
		INTO
			GHi_DescGarantia,
			GHi_Estado,
			GHi_Municipio
		FROM
			INTEGRAGRUPOSCRE ic,
			ASIGNAGARANTIAS 	Asi	,
			GARANTIAS 			Gar
			LEFT OUTER JOIN ESTADOSREPUB 		ed	ON 	ed.EstadoID				=	Gar.EstadoID
			LEFT OUTER JOIN MUNICIPIOSREPUB 	mun	ON 	mun.EstadoID				=	Gar.EstadoID
													AND	mun.MunicipioID			=	Gar.MunicipioID
		WHERE
			ic.GrupoID = Par_GrupoID
		AND Asi.SolicitudCreditoID	=	ic.SolicitudCreditoID
		AND	Gar.GarantiaID			=	Asi.GarantiaID
		AND Gar.TipoDocumentoID = VQ_TipoDocu AND Gar.TipoGarantiaID = VQ_Garantia LIMIT 1;


		SET Var_NomInst 			:= IFNULL(Var_NomInst,Cadena_Default);
		SET Var_DirccionInstitucion := IFNULL(Var_DirccionInstitucion,Cadena_Default);
		SET Var_FechaActualTxt 		:= IFNULL(Var_FechaActualTxt,Cadena_Default);
		SET Var_DescProducto 		:= IFNULL(Var_DescProducto,Cadena_Default);
		SET Var_GarLiqGrup 			:= IFNULL(Var_GarLiqGrup,0.0);
		SET Gar_DescGarantia 		:= IFNULL(Gar_DescGarantia,Cadena_Default);
		SET Gar_NumFactura 			:= IFNULL(Gar_NumFactura,Cadena_Default);
		SET GHi_DescGarantia 		:= IFNULL(GHi_DescGarantia,Cadena_Default);
		SET GHi_Estado 				:= IFNULL(GHi_Estado,Cadena_Default);
		SET GHi_Municipio 			:= IFNULL(GHi_Municipio,Cadena_Default);

		SELECT 	Var_Plazo,      	Var_FechaVenc,     		Var_DesFrec,    	Var_TasaAnual, 	Var_TasaMens,
				Var_TasaFlat,   	Var_MontoSeguro,    	Var_PorcCobert, 	Var_CAT,       	Var_PorcGarLiq,
				Var_MonGarLiq,  	Var_NomRepres,      	Var_FrecSeguro, 	Var_NumRECA, 	Var_DiaVencimiento,
				Var_AnioVencimiento,Var_MesVencimiento, 	Var_GarantiaLetra , MontoCredito, 	Var_MtoLetra,
				Var_NumAmorti,      Var_DesFrecLet, 		MontoTotPagar, 		Var_TotPagLetra,Var_NomGrupoCred,
				Var_NomInst, 		Var_DirccionInstitucion,Var_FechaActualTxt, Var_DescProducto,
				CONVPORCANT(ROUND(Var_TasaAnual,2),'%','2','') AS TasaOrdinariaTxt,
				CONVPORCANT(ROUND(Var_TasaAnual/12, 2), '%','2','') AS TasaOrdinariaMensualTxt,
				CONVPORCANT(Var_SumMonCred,'$','Peso','Nacional') AS MontoTotalTxt,
				CONVPORCANT(ROUND(Var_SumMonCred*Var_GarLiqGrup/100,2),'$','Peso','Nacional') AS MontoGarLiquid,
				Var_GarLiqGrup, 	Gar_DescGarantia,		Gar_NumFactura, 	GHi_DescGarantia,GHi_Estado,
				GHi_Municipio, 		FORMAT(Var_SumMonCred,2) AS Var_SumMonCred, FORMAT(Var_TotPagar,2) AS Var_TotPagar , ROUND(Var_TasaAnual,2) AS TasaOrdinaria, ROUND(Var_TasaAnual * 0.16,2)  AS TasaIva,
				ROUND(Var_TasaAnual * 1.16,2) AS TasaAnual,	CONVPORCANT(ROUND(Var_CAT,2),'%','2','') AS Var_CATtxt;
	END IF;

	IF (Par_TipoReporte = Tipo_EncContrato) THEN

		SELECT
				Upper(Par.NombreRepresentante),		Suc.DirecCompleta,	Cli.Sexo,				Cli.Telefono,
				Est.Nombre ,						Cli.RFCOficial,		DAY(Par.FechaSistema), YEAR(Par.FechaSistema),

				CASE
					WHEN month(Par.FechaSistema) = 1  THEN 'ENERO'
					WHEN month(Par.FechaSistema) = 2  THEN 'FEBRERO'
					WHEN month(Par.FechaSistema) = 3  THEN 'MARZO'
					WHEN month(Par.FechaSistema) = 4  THEN 'ABRIL'
					WHEN month(Par.FechaSistema) = 5  THEN 'MAYO'
					WHEN month(Par.FechaSistema) = 6  THEN 'JUNIO'
					WHEN month(Par.FechaSistema) = 7  THEN 'JULIO'
					WHEN month(Par.FechaSistema) = 8  THEN 'AGOSTO'
					WHEN month(Par.FechaSistema) = 9  THEN 'SEPTIEMBRE'
					WHEN month(Par.FechaSistema) = 10 THEN 'OCTUBRE'
					WHEN month(Par.FechaSistema) = 11 THEN 'NOVIEMBRE'
					WHEN month(Par.FechaSistema) = 12 THEN 'DICIEMBRE'  END AS MesSistema, FRL.Recurso
			INTO

			Var_RepresentanteLegal,	   	Var_DirccionInstitucion, 	Var_SexoRepteLegal, Var_TelInstitucion,
			Var_NombreEstado, 			Var_RFCOficial , 			Var_DiaSistema, 	Var_AnioSistema,
			Var_MesSistema, Var_Recurso


		FROM

		PARAMETROSSIS  Par
		INNER 	JOIN SUCURSALES Suc			ON Suc.SucursalID			= Par.SucursalMatrizID
		INNER 	JOIN CLIENTES Cli 			ON Cli.ClienteID 			= Par.ClienteInstitucion
		INNER 	JOIN ESTADOSREPUB Est		ON Est.EstadoID				= Suc.EstadoID
		INNER 	JOIN FIRMAREPLEGAL FRL 		ON Par.NombreRepresentante	= FRL.RepresentLegal  AND FRL.Consecutivo=(SELECT MAX(Consecutivo) FROM FIRMAREPLEGAL F INNER JOIN PARAMETROSSIS P ON F.RepresentLegal=P.NombreRepresentante);



		SELECT 	UPPER(Inst.NombreCorto) 	INTO Var_NomCortoInstit
		FROM 	 	INSTITUCIONES Inst,PARAMETROSSIS Par
		WHERE 		Inst.InstitucionID	=	Par.InstitucionID;


		SELECT Var_RepresentanteLegal,	   	Var_DirccionInstitucion, 	Var_SexoRepteLegal, Var_TelInstitucion,
				Var_NombreEstado, 			Var_RFCOficial , 			Var_DiaSistema, 	Var_AnioSistema,
				Var_MesSistema,				Var_NomCortoInstit, 		Var_Recurso;



	END IF;


	IF (Par_TipoReporte = Tipo_CaratulaTR) THEN
		SELECT CONCAT(MPIOS.Nombre,', ',EDOS.Nombre) AS Municipio, SUCS.DirecCompleta
		INTO Var_MuniEdo, Var_DomSuc
		FROM GRUPOSCREDITO AS GPOS
			INNER JOIN SUCURSALES AS SUCS ON SUCS.SucursalID = GPOS.SucursalID
			INNER JOIN MUNICIPIOSREPUB AS MPIOS ON (MPIOS.MunicipioID = SUCS.MunicipioID AND MPIOS.EstadoID = SUCS.EstadoID)
			INNER JOIN ESTADOSREPUB AS EDOS ON EDOS.EstadoID = SUCS.EstadoID
		WHERE GrupoID = Par_GrupoID;

		SET Var_TasaAnual   := Entero_Cero;
		SET Var_TasaMens    := Entero_Cero;
		SET Var_TasaFlat    := Entero_Cero;
		SET Var_MontoSeguro := Entero_Cero;
		SET Var_PorcCobert  := Entero_Cero;


		SELECT  Sol.TasaFija,        Sol.CreditoID,      Sol.NumAmortizacion,
				Sol.MontoAutorizado, Sol.PeriodicidadCap, Sol.FrecuenciaCap,
				Sol.Proyecto,        Sol.FactorMora,	Sol.ProductoCreditoID
				INTO
				Var_TasaAnual,       Var_CreditoID, 		Var_NumAmorti,
				Var_MontoCred,		 Var_Periodo,        Var_Frecuencia,
				Var_DestinoProyecto, Var_TasaMoraAnual,		Var_ProductoCred
			FROM INTEGRAGRUPOSCRE Ing,
				 SOLICITUDCREDITO Sol
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Cargo     = Int_Presiden
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID;

		SET Var_NomGrupoCred:= (SELECT NombreGrupo FROM GRUPOSCREDITO WHERE GrupoID=Par_GrupoID);
		SET Var_TasaAnual   	:= IFNULL(Var_TasaAnual, Entero_Cero);
		SET Var_TasaMoraAnual   := IFNULL(Var_TasaMoraAnual, Entero_Cero);
		SET Var_CreditoID   	:= IFNULL(Var_CreditoID, Entero_Cero);
		SET Var_NumAmorti   	:= IFNULL(Var_NumAmorti, Entero_Cero);
		SET Var_Periodo   	:= IFNULL(Var_Periodo, Entero_Cero);
		SET Var_Frecuencia   	:= IFNULL(Var_Frecuencia, Entero_Cero);
		SET Var_TasaMens    	:= ROUND(Var_TasaAnual / 12, 2);
		SET Var_TasaMoratoria   := ROUND( Var_TasaAnual * Var_TasaMoraAnual, 2);


		SELECT TipCobComMorato INTO Var_TipoCobroMora
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Var_ProductoCred;

		IF (Var_TipoCobroMora = TasaFijaAnual) THEN
			SET Var_TasaMoratoria := ROUND(Var_TasaMoraAnual, 2);
		ELSE
			SET Var_TasaMoratoria := ROUND(Var_TasaAnual * Var_TasaMoraAnual, 2);
		END IF;

		SELECT  SUM(Amo.Interes) INTO Var_TotInteres
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Var_CreditoID;

		SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
		SET Var_TasaFlat    := CASE WHEN Var_Periodo = Entero_Cero OR Var_MontoCred=Entero_Cero THEN Entero_Cero ELSE ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
									Var_Periodo ) * 30 * 100 END;
		SET Var_TasaFlat    := ROUND(Var_TasaFlat, 2);

		SELECT Cre.ValorCAT,  ROUND(Cre.PorcGarLiq,2), Pro.FactorRiesgoSeguro, Pro.RegistroRECA, Cre.FechaInicio, Cre.FechaVencimien,
			   CONCAT(PrimerNombre,
						(CASE WHEN IFNULL(SegundoNombre, '') != '' THEN CONCAT(' ', SegundoNombre)
							  ELSE Cadena_Vacia
						 END),
					   (CASE WHEN IFNULL(TercerNombre, '') != '' THEN  CONCAT(' ', TercerNombre)
							 ELSE Cadena_Vacia
						END), ' ',
					  ApellidoPaterno, ' ', ApellidoMaterno)AS NombreCompleto,
					  Cli.ClienteID,Cli.CURP,Cli.Telefono,Dir.DireccionCompleta
				INTO Var_CAT,        Var_PorcGarLiq, Var_FacRiesgo,  Var_NumRECA,    Var_FechaInicio,
					 Var_FechaVenc,  Var_NomRepres,  Var_Cliente,     Var_CURP,      Var_Telefono,
					 Var_DireccionCompleta
			FROM CREDITOS Cre,
				 PRODUCTOSCREDITO Pro,
				 CLIENTES Cli,
				DIRECCLIENTE Dir
			WHERE Cre.CreditoID = Var_CreditoID
			  AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
			  AND Cre.ClienteID = Cli.ClienteID
			  AND Cli.ClienteID = Dir.ClienteID
			  AND Dir.Oficial=DirOficial;

		SET Var_CAT  := IFNULL(Var_CAT, Entero_Cero);
		SET Var_PorcGarLiq  := IFNULL(Var_PorcGarLiq, Entero_Cero);
		SET Var_FacRiesgo  := IFNULL(Var_FacRiesgo, Entero_Cero);

		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semanal'
					WHEN Var_Frecuencia ='C' THEN 'catorcenal'
					WHEN Var_Frecuencia ='Q' THEN 'quincenal'
					WHEN Var_Frecuencia ='M' THEN 'mensual'
					WHEN Var_Frecuencia ='P' THEN 'periodica'
					WHEN Var_Frecuencia ='B' THEN 'bimestral'
					WHEN Var_Frecuencia ='T' THEN 'trimestral'
					WHEN Var_Frecuencia ='R' THEN 'tetramestral'
					WHEN Var_Frecuencia ='E' THEN 'semestral'
					WHEN Var_Frecuencia ='A' THEN 'anual'
					WHEN Var_Frecuencia ='U' THEN 'pago unico'
				END INTO Var_DesFrec;

		SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

		SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
				CASE
					WHEN Var_Frecuencia ='S' THEN 'semanas'
					WHEN Var_Frecuencia ='C' THEN 'catorcenas'
					WHEN Var_Frecuencia ='Q' THEN 'quincenas'
					WHEN Var_Frecuencia ='M' THEN 'meses'
					WHEN Var_Frecuencia ='P' THEN 'periodos'
					WHEN Var_Frecuencia ='B' THEN 'bimestres'
					WHEN Var_Frecuencia ='T' THEN 'trimestres'
					WHEN Var_Frecuencia ='R' THEN 'tetramestres'
					WHEN Var_Frecuencia ='E' THEN 'semestres'
					WHEN Var_Frecuencia ='A' THEN 'anios'
					WHEN Var_Frecuencia ='U' THEN 'pago unico'

				END ) INTO Var_Plazo;
		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semanales'
					WHEN Var_Frecuencia ='C' THEN 'catorcenales'
					WHEN Var_Frecuencia ='Q' THEN 'quincenales'
					WHEN Var_Frecuencia ='M' THEN 'mensuales'
					WHEN Var_Frecuencia ='P' THEN 'periodos'
					WHEN Var_Frecuencia ='B' THEN 'bimestrales'
					WHEN Var_Frecuencia ='T' THEN 'trimestrales'
					WHEN Var_Frecuencia ='R' THEN 'tetramestrales'
					WHEN Var_Frecuencia ='E' THEN 'semestrales'
					WHEN Var_Frecuencia ='A' THEN 'anuales'
					WHEN Var_Frecuencia ='U' THEN 'pago unico'

				END INTO Var_DesFrecLet;

		SELECT SUM(Cre.MontoSeguroVida), SUM(Cre.MontoCredito)  INTO Var_MontoSeguro, Var_SumMonCred
			FROM INTEGRAGRUPOSCRE Ing,
				 CREDITOS Cre
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID    = Cre.SolicitudCreditoID;

		SET Var_MontoSeguro		:= IFNULL(Var_MontoSeguro, Entero_Cero);
		SET Var_MonGarLiq 		:= FORMAT(Var_SumMonCred * Var_PorcGarLiq/100,2);

		SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_TotPagar
			FROM INTEGRAGRUPOSCRE Ing,
				 CREDITOS Cre,
				 AMORTICREDITO Amo
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID    = Cre.SolicitudCreditoID
			  AND Amo.CreditoID = Cre.CreditoID;

		SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);

		SELECT FUNCIONNUMLETRAS(Var_TotPagar) INTO Var_TotPagLetra;
		SELECT FUNCIONNUMLETRAS(Var_SumMonCred) INTO Var_MtoLetra;
		SELECT FUNCIONNUMLETRAS(Var_MontoGarLiq) INTO Var_GarantiaLetra;

		SET Var_PorcCobert  :=  ROUND((Var_FacRiesgo / 7 * Var_Periodo * 1000), 2);
		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semana'
					WHEN Var_Frecuencia ='C' THEN 'catorcena'
					WHEN Var_Frecuencia ='Q' THEN 'quincena'
					WHEN Var_Frecuencia ='M' THEN 'mes'
					WHEN Var_Frecuencia ='P' THEN 'periodo'
					WHEN Var_Frecuencia ='B' THEN 'bimestre'
					WHEN Var_Frecuencia ='T' THEN 'trimestre'
					WHEN Var_Frecuencia ='R' THEN 'tetramestre'
					WHEN Var_Frecuencia ='E' THEN 'semestre'
					WHEN Var_Frecuencia ='A' THEN 'año'
					WHEN Var_Frecuencia ='U' THEN 'pago unico'
				END  INTO Var_FrecSeguro;

		SELECT DAY(Var_FechaVenc) , 	YEAR(Var_FechaVenc) , CASE
					WHEN month(Var_FechaVenc) = 1  THEN 'Enero'
					WHEN month(Var_FechaVenc) = 2  THEN 'Febrero'
					WHEN month(Var_FechaVenc) = 3  THEN 'Marzo'
					WHEN month(Var_FechaVenc) = 4  THEN 'Abril'
					WHEN month(Var_FechaVenc) = 5  THEN 'Mayo'
					WHEN month(Var_FechaVenc) = 6  THEN 'Junio'
					WHEN month(Var_FechaVenc) = 7  THEN 'Julio'
					WHEN month(Var_FechaVenc) = 8  THEN 'Agosto'
					WHEN month(Var_FechaVenc) = 9  THEN 'Septiembre'
					WHEN month(Var_FechaVenc) = 10 THEN 'Octubre'
					WHEN month(Var_FechaVenc) = 11 THEN 'Noviembre'
					WHEN month(Var_FechaVenc) = 12 THEN 'Diciembre' END

		INTO 	Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;

			SELECT  COUNT(*) INTO Var_NumIntegrantes
			 FROM INTEGRAGRUPOSCRE Ing,
						 SOLICITUDCREDITO Sol,
						 CREDITOS Cre,
						 PRODUCTOSCREDITO Pro,
						 CLIENTES Cli,
						 DIRECCLIENTE Dir
					WHERE Ing.GrupoID   = Par_GrupoID
					  AND Ing.Estatus   = Est_Activo
					  AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
					  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
					  AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cli.ClienteID = Dir.ClienteID
					  AND Dir.Oficial=DirOficial;
		SET Var_RepresentanteLegal:=(SELECT NombreRepresentante FROM PARAMETROSSIS);
		SET MontoCredito := CONCAT('$ ', FORMAT(Var_SumMonCred, 2), ' (', Var_MtoLetra, ' M.N.)');
		SET MontoTotPagar := CONCAT('$ ', FORMAT(Var_TotPagar, 2), ' (', Var_TotPagLetra, ' M.N.)');

		SELECT 	Var_Plazo,      		Var_FechaInicio,    	Var_FechaVenc,      Var_DesFrec,    Var_TasaAnual,
				Var_TasaMens,			Var_TasaFlat,   		Var_MontoSeguro,    Var_PorcCobert, Var_CAT,
				Var_PorcGarLiq,			Var_MonGarLiq,  		Var_NomRepres,      Var_Cliente,    Var_CURP,
				Var_Telefono,   		Var_DireccionCompleta,  Var_FrecSeguro, 	Var_NumRECA, 	Var_DiaVencimiento,
				Var_AnioVencimiento,	Var_MesVencimiento, 	Var_GarantiaLetra , MontoCredito, 	Var_MtoLetra,
				Var_NumAmorti,			Var_DesFrecLet, 		MontoTotPagar, 		Var_TotPagLetra,Var_NomGrupoCred,
				Var_DestinoProyecto,    Var_NumIntegrantes,     Var_TasaMoraAnual,  Var_TasaMoratoria,Var_RepresentanteLegal,
				Var_MuniEdo, Var_DomSuc;

	END IF;


	IF (Par_TipoReporte = Con_IntegraGrupo) THEN
	SELECT Ing.GrupoID,NombreCompleto,Cli.ClienteID,
			CURP,Telefono,DireccionCompleta
			FROM INTEGRAGRUPOSCRE Ing,
				 SOLICITUDCREDITO Sol,
				 CREDITOS Cre,
				 PRODUCTOSCREDITO Pro,
				 CLIENTES Cli,
				 DIRECCLIENTE Dir
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Cargo     != Int_Presiden
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
			  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
			  AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
			  AND Cre.ClienteID = Cli.ClienteID
			  AND Cli.ClienteID = Dir.ClienteID
			  AND Dir.Oficial=DirOficial;
	END IF;


	IF(Par_TipoReporte = FirmaDeudores) THEN
		DROP TABLE IF EXISTS  TMFIRMADEUDOR;
		CREATE TEMPORARY TABLE TMFIRMADEUDOR(
			Folio				INT AUTO_INCREMENT,
			Tmp_Descripcion  	VARCHAR(150),
			Tmp_Descripcion2    VARCHAR(150),
			PRIMARY KEY (Folio)
		);

		OPEN CURSORDEUDOR;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORDEUDOR INTO
				 Var_NombreDeudor;

			SET limiteTabla := (
			SELECT  COUNT(*)
			FROM INTEGRAGRUPOSCRE Ing,
						 SOLICITUDCREDITO Sol,
						 CREDITOS Cre,
						 PRODUCTOSCREDITO Pro,
						 CLIENTES Cli,
						 DIRECCLIENTE Dir
					WHERE Ing.GrupoID   = Par_GrupoID
					  AND Ing.Cargo     != Int_Presiden
					  AND Ing.Estatus   = Est_Activo
					  AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
					  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
					  AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cli.ClienteID = Dir.ClienteID
					  AND Dir.Oficial=DirOficial);
			IF contador = 2 THEN
				SET contador = 0;
			END IF;
			IF(contador = 0)THEN
				INSERT INTO TMFIRMADEUDOR  (Tmp_Descripcion) VALUES (CONCAT("DEUDOR SOLIDARIO"));
				INSERT INTO TMFIRMADEUDOR  (Tmp_Descripcion) VALUES (Cadena_Vacia);
				INSERT INTO TMFIRMADEUDOR  (Tmp_Descripcion) VALUES (Cadena_Vacia);
				INSERT INTO TMFIRMADEUDOR  (Tmp_Descripcion) VALUES ("_________________________________________");
				INSERT INTO TMFIRMADEUDOR  (Tmp_Descripcion) VALUES (CONCAT("C. ",Var_NombreDeudor));
				INSERT INTO TMFIRMADEUDOR  (Tmp_Descripcion) VALUES (Cadena_Vacia);

				SET	Var_NumRegTemporal := (SELECT MAX(Folio) FROM TMFIRMADEUDOR);
				SET	Var_NumRegTemporal := IFNULL(Var_NumRegTemporal, 0);
			END IF;
			IF(contador = 1)THEN

				UPDATE TMFIRMADEUDOR
				SET Tmp_Descripcion2 = CONCAT("DEUDOR SOLIDARIO")
				WHERE Folio = Var_NumRegTemporal-5;

				UPDATE TMFIRMADEUDOR
				SET Tmp_Descripcion2 = Cadena_Vacia
				WHERE Folio = Var_NumRegTemporal;

				UPDATE TMFIRMADEUDOR
				SET Tmp_Descripcion2 = Cadena_Vacia
				WHERE Folio = Var_NumRegTemporal;

				UPDATE TMFIRMADEUDOR
				SET Tmp_Descripcion2 = "_________________________________________"
				WHERE Folio = Var_NumRegTemporal-2;

				UPDATE TMFIRMADEUDOR
				SET Tmp_Descripcion2 = CONCAT("C. ",Var_NombreDeudor)
				WHERE Folio = Var_NumRegTemporal-1;

				UPDATE TMFIRMADEUDOR
				SET Tmp_Descripcion2 = Cadena_Vacia
				WHERE Folio = Var_NumRegTemporal;
			END IF;
			SET contador = contador + 1;
			END LOOP;
		END;
		CLOSE CURSORDEUDOR;
		SELECT Tmp_Descripcion,Tmp_Descripcion2
			FROM TMFIRMADEUDOR;
		DROP TABLE IF EXISTS TMFIRMADEUDOR;
	END IF;

	IF (Par_TipoReporte=IntegrantesGrupos) THEN
		SET Var_NombreIntegrantes:="";
		DROP TABLE IF EXISTS  TMPINTEGRANTES;
		CREATE TEMPORARY TABLE TMPINTEGRANTES(
			Tmp_Descripcion  	VARCHAR(1000)
		);

		OPEN CURSORINTEGRANTES;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP

			FETCH CURSORINTEGRANTES INTO
				 Var_NombreDeudor;
				SET Var_NombreIntegrantes :=CONCAT(Var_NombreIntegrantes,"C. ",Var_NombreDeudor,", ");
			END LOOP;
		END;
		CLOSE CURSORINTEGRANTES;

			INSERT INTO TMPINTEGRANTES(Tmp_Descripcion)
				VALUES(Var_NombreIntegrantes);

			SET Numero :=(SELECT LENGTH(Tmp_Descripcion)
						FROM TMPINTEGRANTES);
			SET Numero :=Numero-2;
			SELECT SUBSTRING(Tmp_Descripcion,1,Numero) AS Descripcion
							FROM TMPINTEGRANTES;
			DROP TABLE TMPINTEGRANTES;
	END IF;

	IF (Par_TipoReporte = TipoContratoGrupal) THEN


		SELECT	IFNULL(CAST(Cli.NombreCompleto AS CHAR),Cadena_Default)	AS	Var_NombreCompleto,
				IFNULL(
					CAST(
					CASE	Cli.TipoPersona
						WHEN	'M'	THEN	'Moral'
						ELSE	'Fisica'
					END AS CHAR),Cadena_Default)						AS	Var_TipoPersona,
				IFNULL(
					CASE	Cli.Sexo
						WHEN	'M'	THEN	'masculino'
						ELSE	'femenino'
					END	,Cadena_Default)					AS	Var_Sexo,
				IFNULL(
					FORMATEAFECHACONTRATO( DATE(Cli.FechaNacimiento)),Cadena_Default)							AS Var_FechaNac,
				IFNULL(Edo.Nombre,Cadena_Default)			AS	Var_NomEstado,
				IFNULL(
					IF(P.PaisID = 700, 'MEXICO', P.Nombre),Cadena_Default)				AS	Var_PaisNac,
				IFNULL(
					IF(P.PaisID = 700, Ed2.Nombre, P.Nombre),Cadena_Default)				AS	Var_EdoNac,
				IFNULL(
					CASE	Cli.Nacion
						WHEN	'N'	THEN	'mexicana'
						ELSE	'extranjera'
					END,Cadena_Default)						AS	Var_Nacionalidad,
				IFNULL(Oc.Descripcion,Cadena_Default)		AS	Var_Ocupacion,
				IFNULL(Ge.Descripcion,Cadena_Default)		AS	Var_GradoEscolar,
				IFNULL(Cli.Puesto,Cadena_Default)			AS	Var_Profesion,
				IFNULL(Abm.Descripcion,Cadena_Default)		AS	Var_ActEconomica,
				IFNULL(
					CASE	Cli.EstadoCivil
						WHEN 'S' THEN 'SOLTERO'
						WHEN 'CS' THEN 'CASADO CON BIENES SEPARADOS'
						WHEN 'CM' THEN 'CASADO CON BIENES MANCOMUNADOS'
						WHEN 'CM' THEN 'CASADO CON BIENES MANCOMUNADOS CON CAPITULACION'
						WHEN 'V' THEN 'VIUDO'
						WHEN 'D' THEN 'DIVORCIADO'
						WHEN 'SE' THEN 'SEPARADO'
						WHEN 'U' THEN 'UNION LIBRE'
						ELSE
						 Cadena_Default
					END,Cadena_Default)						AS	Var_EdoCivil,
				IFNULL(Cli.TelefonoCelular,Cadena_Default)	AS	Var_Telefono,
				IFNULL(Cli.Correo,Cadena_Default)			AS	Var_Correo,
				IFNULL(Cli.CURP,Cadena_Default)				AS	Var_CURP,
				IFNULL(Dir.NumeroCasa,Cadena_Default)		AS	Var_NumCasa,
				IFNULL(Dir.Calle,Cadena_Default)			AS	Var_Calle,
				IFNULL(Dir.Colonia,Cadena_Default)			AS	Var_Colonia,
				IFNULL(Dir.CP,Cadena_Default)				AS	Var_CP,
				IFNULL(mun.Nombre,Cadena_Default)			AS	Var_Ciudad,
				IFNULL(Loc.NombreLocalidad,Cadena_Default)	AS	Var_Localidad,
				IFNULL(Cli.RFCOficial,Cadena_Default)		AS	Var_RFC
		FROM			SOLICITUDCREDITO	Sol
		INNER	JOIN	CLIENTES			Cli	ON	Cli.ClienteID	=	Sol.ClienteID
		LEFT OUTER JOIN	DIRECCLIENTE		Dir	ON	Dir.ClienteID	=	Cli.ClienteID
												AND	Dir.Oficial		=	DirecOficial
		LEFT OUTER JOIN	ESTADOSREPUB		Edo	ON	Edo.EstadoID	=	Dir.EstadoID
		LEFT OUTER JOIN	ESTADOSREPUB		Ed2	ON	Ed2.EstadoID	=	Cli.EstadoID
		LEFT OUTER JOIN MUNICIPIOSREPUB		mun ON	mun.EstadoID	=	Dir.EstadoID
												AND	mun.MunicipioID =	Dir.MunicipioID
		LEFT OUTER JOIN	LOCALIDADREPUB		Loc	ON	Loc.EstadoID	=	Dir.EstadoID
												AND	Loc.MunicipioID	=	Dir.MunicipioID
												AND	Loc.LocalidadID	=	Dir.LocalidadID
		LEFT OUTER JOIN PAISES				P	ON	P.PaisID		=	Cli.LugarNacimiento
		LEFT OUTER JOIN OCUPACIONES			Oc	ON	Oc.OcupacionID	=	Cli.OcupacionID
		LEFT OUTER JOIN	SOCIODEMOGRAL		Sc	ON	Sc.ClienteID	=	Cli.ClienteID
		LEFT OUTER JOIN	CATGRADOESCOLAR		Ge	ON	Ge.GradoEscolarID	=	Sc.GradoEscolarID
		LEFT OUTER JOIN	ACTIVIDADESBMX		Abm ON	Cli.ActividadBancoMX		=	Abm.ActividadBMXID
		WHERE	GrupoID =	Par_GrupoID;

	END IF;

	IF (Par_TipoReporte = FirmaContMasAlt) THEN
		DROP TABLE IF EXISTS  TMPINTEGRANTES;
		CREATE TEMPORARY TABLE TMPINTEGRANTES(
			IntegrantesID	INT(11),
			Tmp_NombIzq  	VARCHAR(250),
			Tmp_NombMed  	VARCHAR(250),
			Tmp_NombDer  	VARCHAR(250),
			Tmp_TitIzq  	VARCHAR(250),
			Tmp_TitMed  	VARCHAR(250),
			Tmp_TitDer  	VARCHAR(250)
		);
		SET Contador := 0;
		SET Numero := 1;
		SET Var_NomRepres := (SELECT NombreRepresentante FROM PARAMETROSSIS LIMIT 1);
		OPEN CURSORINTEGRANTES;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
			FETCH CURSORINTEGRANTES INTO Var_NombreDeudor;
				CASE (MOD(Contador,3)  )
				WHEN 0 THEN
					IF(Numero = 1) THEN
						INSERT INTO TMPINTEGRANTES VALUES (Numero, Var_NomRepres,Var_NombreDeudor,'','POR "LA ACREDITANTE"','"LOS ACREDITADOS"','' );
						SET Contador = Contador + 1;
					ELSE
						INSERT INTO TMPINTEGRANTES VALUES (Numero, Var_NombreDeudor,'','','"LOS ACREDITADOS"','','' );
					END IF;
				WHEN 1 THEN
					UPDATE TMPINTEGRANTES SET
						Tmp_NombMed = Var_NombreDeudor,
						Tmp_TitMed = '"LOS ACREDITADOS"'
					WHERE IntegrantesID = Numero;
				WHEN 2 THEN
					UPDATE TMPINTEGRANTES SET
						Tmp_NombDer = Var_NombreDeudor,
						Tmp_TitDer = '"LOS ACREDITADOS"'
					WHERE IntegrantesID = Numero;
					SET Numero = Numero + 1;
				ELSE
					SET Var_NombreDeudor := Var_NombreDeudor;
				END CASE;
				SET Contador = Contador + 1;
			END LOOP;
		END;
		CLOSE CURSORINTEGRANTES;
		SET Var_NombreDeudor := '';

		SELECT
			NombreCompleto
		INTO
			Var_NombreDeudor
		FROM
			INTEGRAGRUPOSCRE 	ic,
			ASIGNAGARANTIAS 	Asi	,
			GARANTIAS 			Gar	,
			CLASIFGARANTIAS		Cla	,
			SOLICITUDCREDITO	sol,
			CLIENTES			cl
		WHERE
				ic.GrupoID = Par_GrupoID
			AND Asi.SolicitudCreditoID	=	ic.SolicitudCreditoID
			AND Gar.GarantiaID			=	Asi.GarantiaID
			AND	Cla.TipoGarantiaID		=	Gar.TipoGarantiaID
			AND	Cla.ClasifGarantiaID	=	Gar.ClasifGarantiaID
			AND Cla.EsGarantiaReal		=	'S'
			AND Gar.TipoGarantiaID		!=	VQ_Garantia
			AND Gar.TipoDocumentoID		!=	VQ_TipoDocu
			AND sol.SolicitudCreditoID	=	ic.SolicitudCreditoID
			AND cl.ClienteID			=	sol.ClienteID
			LIMIT 1;
		IF(IFNULL(Var_NombreDeudor, '') = '') THEN


			SELECT
				NombreCompleto
			INTO
				Var_NombreDeudor
			FROM
				INTEGRAGRUPOSCRE ic,
				ASIGNAGARANTIAS 	Asi	,
				GARANTIAS 			Gar,
				SOLICITUDCREDITO	sol,
				CLIENTES			cl
			WHERE
					ic.GrupoID = Par_GrupoID
				AND Asi.SolicitudCreditoID	=	ic.SolicitudCreditoID
				AND	Gar.GarantiaID			=	Asi.GarantiaID
				AND Gar.TipoDocumentoID 	= VQ_TipoDocu
				AND Gar.TipoGarantiaID 		= VQ_Garantia
				AND sol.SolicitudCreditoID	=	ic.SolicitudCreditoID
				AND cl.ClienteID			=	sol.ClienteID
				LIMIT 1;
		END IF;
		SET Var_NombreDeudor := (SELECT IF(IFNULL(Var_NombreDeudor,'') = '', Cadena_Default,Var_NombreDeudor));
		CASE (MOD(Contador,3))
			WHEN 0 THEN
				INSERT INTO TMPINTEGRANTES VALUES (Numero, Var_NombreDeudor,'','','"LOS OBLIGADOS SOLIDARIOS"','','' );
			WHEN 1 THEN
				UPDATE TMPINTEGRANTES SET
					Tmp_NombMed = Var_NombreDeudor,
					Tmp_TitMed = '"LOS OBLIGADOS SOLIDARIOS"'
				WHERE IntegrantesID = Numero;
			ELSE
				UPDATE TMPINTEGRANTES SET
						Tmp_NombDer = Var_NombreDeudor,
						Tmp_TitDer = '"LOS OBLIGADOS SOLIDARIOS"'
				WHERE IntegrantesID = Numero;
		END CASE;
		SELECT * FROM TMPINTEGRANTES;
	END IF;

	IF (Par_TipoReporte = FirmaCaratMasAlt) THEN
		DROP TABLE IF EXISTS  TMPINTEGRANTES;
		CREATE TEMPORARY TABLE TMPINTEGRANTES(
			IntegrantesID	INT(11),
			Tmp_Acreditados	VARCHAR(250),
			Tmp_Obligados  	VARCHAR(250)
		);
		SET Contador := 0;
		SET Numero := 1;
		OPEN CURSORINTEGRANTES;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
			FETCH CURSORINTEGRANTES INTO Var_NombreDeudor;
				INSERT INTO TMPINTEGRANTES VALUES (Numero, Var_NombreDeudor,'' );
				SET Numero := Numero +1;
			END LOOP;
		END;
		CLOSE CURSORINTEGRANTES;
		SET Var_NombreDeudor := '';

		SELECT
			NombreCompleto
		INTO
			Var_NombreDeudor
		FROM
			INTEGRAGRUPOSCRE 	ic,
			ASIGNAGARANTIAS 	Asi	,
			GARANTIAS 			Gar	,
			CLASIFGARANTIAS		Cla	,
			SOLICITUDCREDITO	sol,
			CLIENTES			cl
		WHERE
				ic.GrupoID = Par_GrupoID
			AND Asi.SolicitudCreditoID	=	ic.SolicitudCreditoID
			AND Gar.GarantiaID			=	Asi.GarantiaID
			AND	Cla.TipoGarantiaID		=	Gar.TipoGarantiaID
			AND	Cla.ClasifGarantiaID	=	Gar.ClasifGarantiaID
			AND Cla.EsGarantiaReal		=	'S'
			AND Gar.TipoGarantiaID		!=	VQ_Garantia
			AND Gar.TipoDocumentoID		!=	VQ_TipoDocu
			AND sol.SolicitudCreditoID	=	ic.SolicitudCreditoID
			AND cl.ClienteID			=	sol.ClienteID
			LIMIT 1;
		IF(IFNULL(Var_NombreDeudor, '') = '') THEN


			SELECT
				NombreCompleto
			INTO
				Var_NombreDeudor
			FROM
				INTEGRAGRUPOSCRE ic,
				ASIGNAGARANTIAS 	Asi	,
				GARANTIAS 			Gar,
				SOLICITUDCREDITO	sol,
				CLIENTES			cl
			WHERE
					ic.GrupoID = Par_GrupoID
				AND Asi.SolicitudCreditoID	=	ic.SolicitudCreditoID
				AND	Gar.GarantiaID			=	Asi.GarantiaID
				AND Gar.TipoDocumentoID 	= VQ_TipoDocu
				AND Gar.TipoGarantiaID 		= VQ_Garantia
				AND sol.SolicitudCreditoID	=	ic.SolicitudCreditoID
				AND cl.ClienteID			=	sol.ClienteID
				LIMIT 1;
		END IF;
		SET Var_NombreDeudor := (SELECT IF(IFNULL(Var_NombreDeudor,'') = '', Cadena_Default,Var_NombreDeudor));

		UPDATE TMPINTEGRANTES SET
			Tmp_Obligados = Var_NombreDeudor
		WHERE IntegrantesID = 1;



		SELECT * FROM TMPINTEGRANTES;
	END IF;


	IF (Par_TipoReporte = TipoCttoGpalSTF) THEN

		SELECT	Gpo.NombreGrupo, 	CicloActual
		INTO	Var_NomGrupoCred,	Var_CicloActual
		FROM	GRUPOSCREDITO	Gpo
		WHERE	Gpo.GrupoID	=	Par_GrupoID;

		DROP TABLE IF EXISTS TMPCREDITOSGRUPO;

		CREATE TEMPORARY TABLE TMPCREDITOSGRUPO(
			CreditoID	BIGINT,
			ClienteID 	BIGINT,
			MontoCred	DECIMAL(14,2),
			TotPagar	DECIMAL(14,2),
			INDEX(CreditoID,ClienteID)
		);

		INSERT INTO TMPCREDITOSGRUPO (
				CreditoID,		ClienteID, MontoCred, TotPagar)
		SELECT	Sol.CreditoID,	MAX(Sol.ClienteID), SUM(Amo.Capital),SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres)
			FROM	SOLICITUDCREDITO Sol,
					AMORTICREDITO	Amo
			WHERE	Sol.GrupoID				=	Par_GrupoID
				AND Sol.CicloGrupo			=	Var_CicloActual
				AND Amo.CreditoID			=	Sol.CreditoID
			GROUP BY Sol.CreditoID;

		SELECT	Sol.CreditoID,	Sol.ProductoCreditoID,	Sol.NumAmortizacion,	Sol.FrecuenciaCap
		INTO	Var_CreditoID,	Var_ProductoCre,		Var_NumAmorti,			Var_Frecuencia
			FROM	INTEGRAGRUPOSCRE Ing,
					SOLICITUDCREDITO Sol
			WHERE	Ing.GrupoID				=	Par_GrupoID
				AND Ing.Cargo				=	Int_Presiden
				AND Ing.Estatus				=	Est_Activo
				AND Ing.SolicitudCreditoID	=	Sol.SolicitudCreditoID;

		SELECT	Pro.Descripcion,	Pro.RegistroRECA,
				CASE	WHEN	IFNULL(Pro.EsGrupal,Cadena_Vacia) = 'S'	THEN	'Grupal'
						ELSE	'N'
				END,
				Pro.TipCobComMorato
		INTO	Var_DescProducto,	Var_NumRECA,		Var_TipoCred,	Var_TipoCobroMora
		FROM	PRODUCTOSCREDITO	Pro
		WHERE	Pro.ProducCreditoID	=	Var_ProductoCre;

		SELECT	Cre.ValorCAT,	Cre.TasaFija,	Cre.SucursalID,	FORMATEAFECHACONTRATO(Cre.FechaVencimien),	Cre.FechaMinistrado,
				CASE	WHEN	Var_TipoCobroMora = N_VecesLaTasa	THEN	Cre.FactorMora * Cre.TasaFija
						ELSE	Cre.TasaFija
				END
		INTO	Var_CAT,		Var_TasaAnual,	Var_SucCreID,	Var_FecVenTxt,								FecMinistrado,
				Var_TasaMoraAnual
		FROM	CREDITOS			Cre,
				CLIENTES			Cli
		WHERE	Cre.CreditoID			=	Var_CreditoID
			AND	Cli.ClienteID			=	Cre.ClienteID;

		SELECT	IF(PRO.TipCobComMorato = N_VecesLaTasa,(Cre.TasaFija*PRO.FactorMora)/100 ,PRO.FactorMora )
		  INTO Var_TasaMoraAnual
			FROM PRODUCTOSCREDITO PRO, CREDITOS			Cre
				WHERE Cre.CreditoID = Var_CreditoID
					AND	Cre.ProductoCreditoID=PRO.ProducCreditoID;

		SELECT	SUM(MontoCred),		SUM(TotPagar)
		INTO	Var_MontoCred,		Var_TotPagar
		FROM	TMPCREDITOSGRUPO cre;

		DROP TABLE IF EXISTS TMPCREDITOSGRUPO;

		SELECT PlazoID INTO Var_PlazoID
			FROM CREDITOS
			WHERE CreditoID=Var_CreditoID;

		SELECT Descripcion INTO Var_DescPlazo
		FROM CREDITOSPLAZOS
		WHERE PlazoID=Var_PlazoID;

		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semanales'
					WHEN Var_Frecuencia ='C' THEN 'catorcenales'
					WHEN Var_Frecuencia ='Q' THEN 'quincenales'
					WHEN Var_Frecuencia ='M' THEN 'mensuales'
					WHEN Var_Frecuencia ='P' THEN 'periodos'
					WHEN Var_Frecuencia ='B' THEN 'bimestrales'
					WHEN Var_Frecuencia ='T' THEN 'trimestrales'
					WHEN Var_Frecuencia ='R' THEN 'tetramestrales'
					WHEN Var_Frecuencia ='E' THEN 'semestrales'
					WHEN Var_Frecuencia ='A' THEN 'anuales'
					ELSE	'No Aplica'
				END INTO Var_DesFrec;


		SELECT	Ins.Nombre,		Par.NombreRepresentante,	Ins.DirFiscal,				FORMATEAFECHACONTRATO(FechaSistema)
		INTO	Var_NomInst,	Var_RepresentanteLegal,		Var_DirccionInstitucion,	Var_FechaActualTxt
		FROM	PARAMETROSSIS	Par,
				INSTITUCIONES	Ins
		WHERE	Par.InstitucionID	=	Ins.InstitucionID;

		SELECT	Suc.DirecCompleta,	Edo.Nombre
		INTO	Var_SucCreDir,		Var_SucCreEdo
		FROM		SUCURSALES	Suc
		INNER JOIN	ESTADOSREPUB	Edo ON	Edo.EstadoID	=	Suc.EstadoID
		WHERE	Suc.SucursalID	=	Var_SucCreID;

		SELECT	SUM(Cre.MontoCredito),	SUM(Cre.MontoSeguroVida)
		INTO	Var_SumMonCred,			Var_MontoSeguro
		FROM	INTEGRAGRUPOSCRE Ing,
				CREDITOS Cre
		WHERE	Ing.GrupoID				=	Par_GrupoID
			AND Ing.Estatus				=	Est_Activo
			AND Ing.SolicitudCreditoID	=	Cre.SolicitudCreditoID;

		SELECT	CONCAT(Cli.PrimerNombre,
						CASE	WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.SegundoNombre)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.TercerNombre)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.ApellidoPaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.ApellidoPaterno)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.ApellidoMaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.ApellidoMaterno)
								ELSE Cadena_Vacia
						END
				),				Dir.DireccionCompleta
		INTO	Var_NomPresi,	Var_PresiDir
		FROM	INTEGRAGRUPOSCRE	Ing,
				CLIENTES			Cli,
				DIRECCLIENTE		Dir
		WHERE	Ing.GrupoID				=	Par_GrupoID
			AND Ing.Estatus				=	Est_Activo
			AND	Ing.Cargo				=	Tipo_Presi
			AND	Cli.ClienteID			=	Ing.ClienteID
			AND	Dir.ClienteID			=	Ing.ClienteID
			AND	Dir.Oficial				=	DirOficial;

		SELECT	CONCAT(Cli.PrimerNombre,
						CASE	WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.SegundoNombre)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.TercerNombre)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.ApellidoPaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.ApellidoPaterno)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.ApellidoMaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.ApellidoMaterno)
								ELSE Cadena_Vacia
						END
				)
		INTO	Var_NomTesore
		FROM	INTEGRAGRUPOSCRE	Ing,
				CLIENTES			Cli
		WHERE	Ing.GrupoID				=	Par_GrupoID
			AND Ing.Estatus				=	Est_Activo
			AND	Ing.Cargo				=	Tipo_Tesorero
			AND	Cli.ClienteID			=	Ing.ClienteID;

		SELECT	CONCAT(Cli.PrimerNombre,
						CASE	WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.SegundoNombre)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.TercerNombre)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.ApellidoPaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.ApellidoPaterno)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.ApellidoMaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.ApellidoMaterno)
								ELSE Cadena_Vacia
						END
				)
		INTO	Var_NomSecre
		FROM	INTEGRAGRUPOSCRE	Ing,
				CLIENTES			Cli
		WHERE	Ing.GrupoID				=	Par_GrupoID
			AND Ing.Estatus				=	Est_Activo
			AND	Ing.Cargo				=	Tipo_Secre
			AND	Cli.ClienteID			=	Ing.ClienteID;

		SET Var_NumRECA := UPPER(Var_NumRECA);

		SELECT	Var_NumRECA,	Var_DescProducto,		Var_TipoCred,	Var_NomGrupoCred,	Var_CAT,
				Var_TasaAnual,	Var_TasaMoraAnual,		Var_NumAmorti,	Var_DesFrec,		Var_FecVenTxt,
				Var_MontoCred,	Var_TotPagar,
				Var_NomInst,	Var_RepresentanteLegal,	Var_SucCreDir,	Var_SumMonCred,		CONVPORCANT(Var_SumMonCred,'$','Peso','N.') AS Var_SumMonCredTxt,
				CONVPORCANT(ROUND(Var_TasaMoraAnual,4),'%','4','') AS Var_TasaMoraAnualTxt,
								Var_SucCreEdo,			FecMinistrado,	Var_NomPresi,		Var_NomTesore,
				Var_NomSecre,	Var_PresiDir, Var_DescPlazo;

	END IF;

	-- Seccion ALternativa 19
	IF (Par_TipoReporte = Tipo_CaratulaAlt) THEN
				-- REGISTRO PUBLICO
		SELECT MPIOSRPP.Nombre AS NomLocRP, EDORPP.Nombre, RPP.FechaRegPub
			INTO Var_NomLocRP, 	Var_NomEstRP, FechaRegPub
			  FROM ESCRITURAPUB AS RPP
				INNER  JOIN MUNICIPIOSREPUB AS MPIOSRPP ON (MPIOSRPP.MunicipioID = RPP.LocalidadRegPub
														AND MPIOSRPP.EstadoID = RPP.EstadoIDReg)
				INNER  JOIN ESTADOSREPUB AS EDORPP ON (EDORPP.EstadoID = RPP.EstadoIDReg)
			WHERE RPP.EmpresaID = Par_EmpresaID
				AND RPP.Esc_Tipo = TipoConstit
				AND RPP.ClienteID=1 LIMIT 1;

			-- NOTARIA
			SELECT ESC.EscrituraPublic, ESC.VolumenEsc, ESC.Notaria, MPIOSESC.Nombre AS NomLocEsc,
				EDOESC.Nombre AS NomEstEsc, DES.Titular AS NomNotario, DES.Direccion, ESC.FechaEsc
		   INTO Var_EscrituraPublic, Var_VolumenEsc, Var_Notaria, Var_NomLocEsc,
				Var_NomEstEsc, Var_NomNotario, Var_NotDireccion, FechaEscPub
			FROM ESCRITURAPUB AS ESC
				INNER  JOIN MUNICIPIOSREPUB AS MPIOSESC ON (MPIOSESC.MunicipioID = ESC.LocalidadEsc AND MPIOSESC.EstadoID = ESC.EstadoIDReg)
				INNER  JOIN ESTADOSREPUB AS EDOESC ON (EDOESC.EstadoID = ESC.EstadoIDEsc)
				INNER  JOIN NOTARIAS AS DES ON DES.NotariaID = ESC.Notaria
			WHERE ESC.EmpresaID = Par_EmpresaID
				AND ESC.Esc_Tipo = TipoConstit
				AND ESC.ClienteID=1 LIMIT 1;

		SET FechaRegPubTxt    :=  IFNULL(FORMATEAFECHACONTRATO(FechaRegPub), Cadena_Vacia);
		SET FechaEscPubTxt    :=  IFNULL(FORMATEAFECHACONTRATO(FechaEscPub), Cadena_Vacia);

		SELECT	Gpo.NombreGrupo, 	CicloActual
		INTO	Var_NomGrupoCred,	Var_CicloActual
		FROM	GRUPOSCREDITO	Gpo
		WHERE	Gpo.GrupoID	=	Par_GrupoID;

		DROP TABLE IF EXISTS TMPCREDITOSGRUPO;

		CREATE TEMPORARY TABLE TMPCREDITOSGRUPO(
			CreditoID	BIGINT,
			ClienteID 	BIGINT,
			MontoCred	DECIMAL(14,2),
			TotPagar	DECIMAL(14,2),
			INDEX(CreditoID,ClienteID)
		);

		INSERT INTO TMPCREDITOSGRUPO (
				CreditoID,		ClienteID, MontoCred, TotPagar)
		SELECT	Sol.CreditoID,	MAX(Sol.ClienteID), SUM(Amo.Capital),SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres)
			FROM	SOLICITUDCREDITO Sol,
					AMORTICREDITO	Amo
			WHERE	Sol.GrupoID				=	Par_GrupoID
				AND Sol.CicloGrupo			=	Var_CicloActual
				AND Amo.CreditoID			=	Sol.CreditoID
			GROUP BY Sol.CreditoID;

		SELECT	Sol.CreditoID,	Sol.ProductoCreditoID,	Sol.NumAmortizacion,	Sol.FrecuenciaCap
		INTO	Var_CreditoID,	Var_ProductoCre,		Var_NumAmorti,			Var_Frecuencia
			FROM	INTEGRAGRUPOSCRE Ing,
					SOLICITUDCREDITO Sol
			WHERE	Ing.GrupoID				=	Par_GrupoID
				AND Ing.Cargo				=	Int_Presiden
				AND Ing.Estatus				=	Est_Activo
				AND Ing.SolicitudCreditoID	=	Sol.SolicitudCreditoID;

		SELECT	Pro.Descripcion,	Pro.RegistroRECA,
				CASE	WHEN	IFNULL(Pro.EsGrupal,Cadena_Vacia) = 'S'	THEN	'Grupal'
						ELSE	'N'
				END,
				Pro.TipCobComMorato
		INTO	Var_DescProducto,	Var_NumRECA,		Var_TipoCred,	Var_TipoCobroMora
		FROM	PRODUCTOSCREDITO	Pro
		WHERE	Pro.ProducCreditoID	=	Var_ProductoCre;

		SELECT	Cre.ValorCAT,	Cre.TasaFija,	Cre.SucursalID,	FORMATEAFECHACONTRATO(Cre.FechaVencimien),	Cre.FechaMinistrado,
				CASE	WHEN	Var_TipoCobroMora = N_VecesLaTasa	THEN	Cre.FactorMora * Cre.TasaFija
						ELSE	Cre.TasaFija
				END,	Cre.FactorMora,	ROUND(Cre.PorcGarLiq,2)
		INTO	Var_CAT,			Var_TasaAnual,	Var_SucCreID,	Var_FecVenTxt,	FecMinistrado,
				Var_TasaMoraAnual,	Var_FactorM,	Var_PorcGarLiq
		FROM	CREDITOS			Cre,
				CLIENTES			Cli
		WHERE	Cre.CreditoID			=	Var_CreditoID
			AND	Cli.ClienteID			=	Cre.ClienteID;

		SELECT	IF(TipCobComMorato = N_VecesLaTasa,(Cre.TasaFija*PRO.FactorMora) ,PRO.FactorMora )
		  INTO Var_TasaMoraAnual
			FROM PRODUCTOSCREDITO PRO, CREDITOS			Cre
				WHERE Cre.CreditoID = Var_CreditoID
					AND	Cre.ProductoCreditoID=PRO.ProducCreditoID;

		SELECT	SUM(MontoCred),		SUM(TotPagar)
		INTO	Var_MontoCred,		Var_TotPagar
		FROM	TMPCREDITOSGRUPO cre;

		 SET Var_TasaAnualTxt 	:= IFNULL(CONVPORCANT(ROUND(Var_TasaAnual,2),'%','2',''), Cadena_Vacia) ;
		SET Var_TasaMens    	:= IFNULL(ROUND(Var_TasaAnual / 12, 2),Entero_Cero);
		SET Var_TasaMensTxt		:= IFNULL(CONVPORCANT(ROUND(Var_TasaMens,2),'%','2',''), Cadena_Vacia) ;
		SET Var_TasaMensMoraTxt	:= IFNULL(CONVPORCANT(ROUND(Var_TasaMoraAnual/12,2),'%','2',''), Cadena_Vacia) ;

		DROP TABLE IF EXISTS TMPCREDITOSGRUPO;

		SELECT PlazoID INTO Var_PlazoID
			FROM CREDITOS
			WHERE CreditoID=Var_CreditoID;

		SELECT Descripcion INTO Var_DescPlazo
		FROM CREDITOSPLAZOS
		WHERE PlazoID=Var_PlazoID;

		SELECT  CASE
					WHEN Var_Frecuencia =FrecSemanal THEN TxtSemanales
					WHEN Var_Frecuencia =FrecCatorcenal THEN TxtCatorcenales
					WHEN Var_Frecuencia =FrecQuincenal THEN TxtQuincenales
					WHEN Var_Frecuencia =FrecMensual THEN TxtMensuales
					WHEN Var_Frecuencia =FrecPeriodica THEN TxtPeriodos
					WHEN Var_Frecuencia =FrecBimestral THEN TxtBimestrales
					WHEN Var_Frecuencia =FrecTrimestral THEN TxtTrimestrales
					WHEN Var_Frecuencia =FrecTetramestral THEN TxtTetramestrales
					WHEN Var_Frecuencia =FrecSemestral THEN TxtSemestrales
					WHEN Var_Frecuencia =FrecAnual THEN TxtAnuales
					ELSE	'No Aplica'
				END INTO Var_DesFrec;

		 -- Garantia Liquida

		SET Var_MontoGarLiq		:= (SELECT  SUM(AporteCliente) AS MontoTotal
										FROM CREDITOS Cre
											INNER JOIN INTEGRAGRUPOSCRE Ing
											ON Cre.SolicitudCreditoID = Ing.SolicitudCreditoID
										WHERE Ing.GrupoID= Par_GrupoID);

		 SET Var_MonGarLiq 		:= FORMAT(Var_MontoGarLiq,2);

		-- Garantia Hipotecaria

		SELECT Cla.Descripcion, Doc.Descripcion
		  INTO Var_DescGarantia, Var_DocGarantia
		FROM
			INTEGRAGRUPOSCRE 	ic,
			ASIGNAGARANTIAS 	Asi	,
			GARANTIAS 			Gar	,
			TIPOSDOCUMENTOS 	Doc,
			CLASIFGARANTIAS		Cla	,
			SOLICITUDCREDITO	sol,
			CLIENTES			cl
		WHERE
				ic.GrupoID = Par_GrupoID
			AND Asi.SolicitudCreditoID	=	ic.SolicitudCreditoID
			AND Gar.GarantiaID			=	Asi.GarantiaID
			AND	Cla.TipoGarantiaID		=	Gar.TipoGarantiaID
			AND	Cla.ClasifGarantiaID	=	Gar.ClasifGarantiaID
			AND Gar.TipoDocumentoID		= 	Doc.TipoDocumentoID
			AND Gar.TipoGarantiaID		=	VQ_Garantia
			AND sol.SolicitudCreditoID	=	ic.SolicitudCreditoID
			AND cl.ClienteID			=	sol.ClienteID
			LIMIT 1;

		-- Garantia REAL
		SET Var_NombreDeudor := Cadena_Vacia;
		SELECT
			NombreCompleto, Gar.Observaciones
		INTO
			Var_NombreDeudor, Gar_DescGarantia
		FROM
			INTEGRAGRUPOSCRE 	ic,
			ASIGNAGARANTIAS 	Asi	,
			GARANTIAS 			Gar	,
			CLASIFGARANTIAS		Cla	,
			SOLICITUDCREDITO	sol,
			CLIENTES			cl
		WHERE
				ic.GrupoID = Par_GrupoID
			AND Asi.SolicitudCreditoID	=	ic.SolicitudCreditoID
			AND Gar.GarantiaID			=	Asi.GarantiaID
			AND	Cla.TipoGarantiaID		=	Gar.TipoGarantiaID
			AND	Cla.ClasifGarantiaID	=	Gar.ClasifGarantiaID
			AND Cla.EsGarantiaReal		=	'S'
			AND Gar.TipoGarantiaID		!=	VQ_Garantia
			AND Gar.TipoDocumentoID		!=	VQ_TipoDocu
			AND sol.SolicitudCreditoID	=	ic.SolicitudCreditoID
			AND cl.ClienteID			=	sol.ClienteID
			LIMIT 1;
		IF(IFNULL(Var_NombreDeudor, Cadena_Vacia) = Cadena_Vacia) THEN
			SELECT
				NombreCompleto, Gar.Observaciones
			INTO
				Var_NombreDeudor, Gar_DescGarantia
			FROM
				INTEGRAGRUPOSCRE ic,
				ASIGNAGARANTIAS 	Asi	,
				GARANTIAS 			Gar,
				SOLICITUDCREDITO	sol,
				CLIENTES			cl
			WHERE
					ic.GrupoID = Par_GrupoID
				AND Asi.SolicitudCreditoID	=	ic.SolicitudCreditoID
				AND	Gar.GarantiaID			=	Asi.GarantiaID
				AND Gar.TipoDocumentoID 	= VQ_TipoDocu
				AND Gar.TipoGarantiaID 		= VQ_Garantia
				AND sol.SolicitudCreditoID	=	ic.SolicitudCreditoID
				AND cl.ClienteID			=	sol.ClienteID
				LIMIT 1;
	END IF;
		SET Var_NombreDeudor := (SELECT IF(IFNULL(Var_NombreDeudor,Cadena_Vacia) = Cadena_vacia, Cadena_Default,Var_NombreDeudor));

		-- Domicilio Presidente Grupo

		SELECT	CONCAT(Cli.PrimerNombre,
						CASE	WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.SegundoNombre)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.TercerNombre)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.ApellidoPaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.ApellidoPaterno)
								ELSE Cadena_Vacia
						END,
						CASE	WHEN IFNULL(Cli.ApellidoMaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Cli.ApellidoMaterno)
								ELSE Cadena_Vacia
						END
				),				Dir.DireccionCompleta
		INTO	Var_NomPresi,	Var_PresiDir
		FROM	INTEGRAGRUPOSCRE	Ing,
				CLIENTES			Cli,
				DIRECCLIENTE		Dir
		WHERE	Ing.GrupoID			=	Par_GrupoID
			AND Ing.Estatus			=	Est_Activo
			AND	Ing.Cargo			=	Tipo_Presi
			AND	Cli.ClienteID		=	Ing.ClienteID
			AND	Dir.ClienteID		=	Ing.ClienteID
			AND	Dir.Oficial			=	DirOficial;

		-- Datos Institucion

		SELECT	Ins.Nombre,		Par.NombreRepresentante,	Ins.DirFiscal,				FORMATEAFECHACONTRATO(FechaSistema), Ins.RFC
		INTO	Var_NomInst,	Var_RepresentanteLegal,		Var_DirccionInstitucion,	Var_FechaActualTxt,	RFCInstitucion
		FROM	PARAMETROSSIS	Par,
				INSTITUCIONES	Ins
		WHERE	Par.InstitucionID	=	Ins.InstitucionID;

		SELECT	Suc.DirecCompleta,	Suc.NombreSucurs, Edo.Nombre, Mun.Nombre
		INTO	Var_SucCreDir,		NombreSucurs,	EstadoSuc,	MunicipioSuc
		FROM		SUCURSALES	Suc
		INNER JOIN	ESTADOSREPUB	Edo ON	Edo.EstadoID	=	Suc.EstadoID
		INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID
										AND Suc.MunicipioID = Mun.MunicipioID
		WHERE	Suc.SucursalID	=	Var_SucCreID;

		SELECT	SUM(Cre.MontoCredito),	SUM(Cre.MontoSeguroVida)
		INTO	Var_SumMonCred,			Var_MontoSeguro
		FROM	INTEGRAGRUPOSCRE Ing,
				CREDITOS Cre
		WHERE	Ing.GrupoID				=	Par_GrupoID
			AND Ing.Estatus				=	Est_Activo
			AND Ing.SolicitudCreditoID	=	Cre.SolicitudCreditoID;

		 DROP TABLE IF EXISTS TMPINTEGRAGRUPO;

		CREATE TEMPORARY TABLE TMPINTEGRAGRUPO(
			ClienteID 	INT,
			ProspectoID BIGINT (20),
			NombreCompleto VARCHAR(200),
			INDEX(ClienteID,ProspectoID)
		);

		INSERT INTO TMPINTEGRAGRUPO (
				ClienteID, ProspectoID)
		SELECT	Igc.ClienteID,	Igc.ProspectoID
		FROM	INTEGRAGRUPOSCRE Igc
			WHERE	Igc.GrupoID			=	Par_GrupoID;


		UPDATE TMPINTEGRAGRUPO T,
				CLIENTES C
		 SET T.NombreCompleto = C.NombreCompleto
		 WHERE T.ClienteID = C.ClienteID
		 AND T.ProspectoID = Entero_Cero;

		  UPDATE TMPINTEGRAGRUPO T,
				PROSPECTOS P
		 SET T.NombreCompleto = P.NombreCompleto
		 WHERE T.ProspectoID = P.ProspectoID
		 AND T.ClienteID = Entero_Cero;

		SELECT GROUP_CONCAT(DISTINCT NombreCompleto SEPARATOR ', ') AS NombreInteg
		INTO NombreInt
			FROM TMPINTEGRAGRUPO;

		 -- Comisiones
		SET Var_GastosCobranza := Entero_Cero;
		SET Var_GastosCobranzaTxt := CONVPORCANT(Var_GastosCobranza,'$', 'Peso', 'Nacional');

		SET Var_NumRECA := UPPER(Var_NumRECA);
		SET Var_FechaMinisTxt := FORMATEAFECHACONTRATO(FecMinistrado);
		SET Var_PorGarLiqTxt   := CONVPORCANT(ROUND(Var_PorcGarLiq,2),'%','2','');
		SET Var_MontoFarLiqTxt	:= CONVPORCANT(Var_MontoGarLiq,'$', 'Peso', 'Nacional');


		SELECT	Var_NumRECA,				Var_DescProducto,		Var_TipoCred,	Var_NomGrupoCred,		CONVPORCANT(ROUND(Var_CAT,2),'%','2','') AS Var_CAT,
				Var_TasaAnual,				Var_TasaMoraAnual,		Var_NumAmorti,	Var_DesFrec,			Var_FecVenTxt,
				Var_MontoCred,				Var_TotPagar,
				Var_NomInst,				Var_RepresentanteLegal,	Var_SucCreDir,	Var_SumMonCred,			CONVPORCANT(Var_SumMonCred,'$','Peso','N.') AS Var_SumMonCredTxt,
				CONVPORCANT(ROUND(Var_TasaMoraAnual,2),'%','2','') AS Var_TasaMoraAnualTxt,					NombreSucurs,
				FecMinistrado,	 			Var_DescPlazo,			NombreInt,		Var_NomLocRP, 			Var_NomEstRP,
				Var_EscrituraPublic,		Var_VolumenEsc, 		Var_Notaria, 	Var_NomLocEsc,			Var_NomEstEsc,
				Var_NomNotario, 			Var_NotDireccion, 		FechaEscPubTxt,	FechaRegPubTxt,			RFCInstitucion,
				Var_DirccionInstitucion,	EstadoSuc,				MunicipioSuc, 	Var_GastosCobranzaTxt,	Var_TasaAnualTxt,
				Var_TasaMensTxt,			Var_TasaMensMoraTxt,	Var_FactorM,	Var_FechaMinisTxt,		Var_MontoGarLiq,
				Var_PorcGarLiq,				Var_PorGarLiqTxt,		Var_MontoFarLiqTxt,	Var_NombreDeudor, 	Gar_DescGarantia,
				Var_DescGarantia, 			Var_DocGarantia,		Var_NomPresi,	Var_PresiDir;


	END IF;

	IF (Par_TipoReporte = Int_GrupoAlt) THEN
		-- TABLA TEMPORAL PARA ALMACENAR LOS  DATOS DEL CLIENTE
		DROP TABLE IF EXISTS TMPDATOSCLIENTE;
			CREATE TEMPORARY TABLE TMPDATOSCLIENTE(
				ClienteID			BIGINT(12),
				NombreCompleto		VARCHAR(200),
				ApellidoPaterno		VARCHAR(50),
				ApellidoMaterno 	VARCHAR(50),
				Sexo				CHAR(1),
				FechaNacimiento		DATE,
				FechaNacimientoTxt	VARCHAR(100),
				LugarNacimientoID	INT(11),
				LugarNacimiento		VARCHAR(150),
				EstadoNacID			INT(11),
				EstadoNac			VARCHAR(100),
				Nacionalidad		CHAR(1),
				OcupacionID			INT(11),
				DescOcup			TEXT,
				EstadoCivil			CHAR(2),
				TelefonoCelular		VARCHAR(20),
				Correo				VARCHAR(50),
				CURP				CHAR(18),
				NumIdentific		VARCHAR(30),

			-- Direccion Cliente
				NumExt				CHAR(10),
				Calle				VARCHAR(50),
				ColoniaID			INT(11),
				NomColonia			VARCHAR(400),
				Cp					CHAR(5),
				EstadoID			INT(11),
				NomEstado			VARCHAR(100),
				MunicipioID			INT(11),
				NomMunicipio		VARCHAR(150),
				RFC					CHAR(13)

			);

			INSERT INTO TMPDATOSCLIENTE (ClienteID,			NombreCompleto,		ApellidoPaterno,	ApellidoMaterno,	Sexo,
										FechaNacimiento,	LugarNacimientoID,	EstadoNacID,	  	Nacionalidad,       OcupacionID,
										DescOcup,          	EstadoCivil,		TelefonoCelular,	Correo,             CURP,
										NumIdentific, 		NumExt, 			Calle, 				ColoniaID, 			NomColonia,
										Cp,					EstadoID,          MunicipioID,			RFC)

			SELECT 	Ing.ClienteID,			CONCAT(Cli.PrimerNombre, ' ', Cli.SegundoNombre, ' ', Cli.TercerNombre),
					Cli.ApellidoPaterno,	Cli.ApellidoMaterno,		Cli.Sexo,		Cli.FechaNacimiento,	Cli.LugarNacimiento,
					Cli.EstadoID,			Cli.Nacion,					O.OcupacionId,  O.Descripcion,			Cli.EstadoCivil,
					Cli.TelefonoCelular,	Cli.Correo,	 				Cli.CURP,   	Idf.NumIdentific,		Dir.NumeroCasa,
					Dir.Calle,				Dir.ColoniaID,				Dir.Colonia, 	Dir.CP,                	Dir.EstadoID,
					Dir.MunicipioID,		Cli.RFC
				 FROM INTEGRAGRUPOSCRE Ing,
				 SOLICITUDCREDITO Sol,
				 CREDITOS Cre,
				 DIRECCLIENTE Dir,
				  CLIENTES Cli
			LEFT OUTER JOIN OCUPACIONES O ON Cli.OcupacionID = O.OcupacionID
			LEFT OUTER JOIN ACTIVIDADESBMX abm ON Cli.ActividadBancoMX = abm.ActividadBMXID
			LEFT OUTER JOIN IDENTIFICLIENTE Idf ON Cli.ClienteID = Idf.ClienteID
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
			  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
			  AND Cre.ClienteID = Cli.ClienteID
			  AND Cli.ClienteID = Dir.ClienteID
			  AND Dir.Oficial= DirOficial;

			-- SE ACTUALIZAN CAMPOS

		-- LUGAR DE NACIMIENTO
		UPDATE  TMPDATOSCLIENTE T,
				PAISES P
		SET		T.LugarNacimiento=P.Nombre
		WHERE	T.LugarNacimientoID=P.PaisID;

		   -- ESTADO NACIMIENTO
		UPDATE  TMPDATOSCLIENTE T,
				ESTADOSREPUB E
		SET		T.EstadoNac=E.Nombre
		WHERE	T.EstadoNacID=E.EstadoID;


		   -- ESTADO RESIDENCIA
		UPDATE  TMPDATOSCLIENTE T,
				ESTADOSREPUB E
		SET		T.NomEstado=E.Nombre
		WHERE	T.EstadoID=E.EstadoID;

			-- MUNICIPIO RESIDENCIA
		UPDATE  TMPDATOSCLIENTE T,
				MUNICIPIOSREPUB M
		SET		T.NomMunicipio=M.Nombre
		WHERE 	T.MunicipioID=M.MunicipioID
			AND T.EstadoID=M.EstadoID;


	   SELECT	ClienteID,			NombreCompleto,		ApellidoPaterno,	ApellidoMaterno,	CASE Sexo
																									WHEN Masculino THEN TxtMasculino
																									ELSE TxtFemenino
																								END AS Genero,
				FechaNacimiento,   FORMATEAFECHACONTRATO(FechaNacimiento) AS FechaNac,	CASE LugarNacimientoID
																							WHEN  700 THEN  'MEXICO'
																							ELSE  IFNULL(LugarNacimiento, Cadena_Vacia)
																						END AS LugarNacimiento,
			EstadoNac,          CASE Nacionalidad
								  WHEN TxtNacionM THEN TxtMexicana
								  WHEN TxtNacionE THEN TxtExtranjera
								END AS Nacionalidad,
			DescOcup, CASE	EstadoCivil
						WHEN EstSoltero THEN TxtSoltero
						WHEN EstCasBienSep THEN TxtCasBienSep
						WHEN EstCasBienMan THEN TxtCasBienMan
						WHEN EstcasBienManCap THEN TxtcasBienManCap
						WHEN EstViudo THEN TxtViudo
						WHEN EstDivorciado THEN TxtDivorciado
						WHEN EstSeparado THEN TxtSeparado
						WHEN EsteUnionLibre THEN TxteUnionLibre
						ELSE
						 Cadena_Vacia
					END AS EstadoCivil,
				TelefonoCelular,	Correo,			CURP,		NumIdentific,	NumExt,
				Calle,				ColoniaID,		NomColonia,	Cp,		        NomEstado,
				NomMunicipio,		RFC
			FROM TMPDATOSCLIENTE;

	END IF;

    IF (Par_TipoReporte = Tipo_CaratulaNP) THEN
		SELECT CONCAT(MPIOS.Nombre,', ',EDOS.Nombre) AS Municipio, SUCS.DirecCompleta
		INTO Var_MuniEdo, Var_DomSuc
		FROM GRUPOSCREDITO AS GPOS
			INNER JOIN SUCURSALES AS SUCS ON SUCS.SucursalID = GPOS.SucursalID
			INNER JOIN MUNICIPIOSREPUB AS MPIOS ON (MPIOS.MunicipioID = SUCS.MunicipioID AND MPIOS.EstadoID = SUCS.EstadoID)
			INNER JOIN ESTADOSREPUB AS EDOS ON EDOS.EstadoID = SUCS.EstadoID
		WHERE GrupoID = Par_GrupoID;

		SET Var_TasaAnual   := Entero_Cero;
		SET Var_TasaMens    := Entero_Cero;
		SET Var_TasaFlat    := Entero_Cero;
		SET Var_MontoSeguro := Entero_Cero;
		SET Var_PorcCobert  := Entero_Cero;


		SELECT  Sol.TasaFija,        Sol.CreditoID,      Sol.NumAmortizacion,
				Sol.MontoAutorizado, Sol.PeriodicidadCap, Sol.FrecuenciaCap,
				Sol.Proyecto,        Sol.FactorMora,	Sol.ProductoCreditoID
				INTO
				Var_TasaAnual,       Var_CreditoID, 		Var_NumAmorti,
				Var_MontoCred,		 Var_Periodo,        Var_Frecuencia,
				Var_DestinoProyecto, Var_TasaMoraAnual,		Var_ProductoCred
			FROM INTEGRAGRUPOSCRE Ing,
				 SOLICITUDCREDITO Sol
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Cargo     = Int_Presiden
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID;

		SET Var_NomGrupoCred:= (SELECT NombreGrupo FROM GRUPOSCREDITO WHERE GrupoID=Par_GrupoID);
		SET Var_TasaAnual   	:= IFNULL(Var_TasaAnual, Entero_Cero);
		SET Var_TasaMoraAnual   := IFNULL(Var_TasaMoraAnual, Entero_Cero);
		SET Var_CreditoID   	:= IFNULL(Var_CreditoID, Entero_Cero);
		SET Var_NumAmorti   	:= IFNULL(Var_NumAmorti, Entero_Cero);
		SET Var_TasaMens    	:= ROUND(Var_TasaAnual / 12, 2);
		SET Var_TasaMoratoria   := ROUND( Var_TasaAnual * Var_TasaMoraAnual, 2);

		SELECT TipCobComMorato INTO Var_TipoCobroMora
		FROM PRODUCTOSCREDITO
		WHERE ProducCreditoID = Var_ProductoCred;

		IF (Var_TipoCobroMora = TasaFijaAnual) THEN
			SET Var_TasaMoratoria := ROUND(Var_TasaMoraAnual, 2);
		ELSE
			SET Var_TasaMoratoria := ROUND(Var_TasaAnual * Var_TasaMoraAnual, 2);
		END IF;

		SELECT  SUM(Amo.Interes) INTO Var_TotInteres
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Var_CreditoID;

		SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
		SET Var_TasaFlat    := CASE WHEN Var_Periodo = Entero_Cero OR Var_MontoCred=Entero_Cero THEN Entero_Cero ELSE ( ( (Var_TotInteres / Var_NumAmorti) / Var_MontoCred ) /
									Var_Periodo ) * 30 * 100 END;
		SET Var_TasaFlat    := ROUND(Var_TasaFlat, 2);

		SELECT Cre.ValorCAT,  ROUND(Cre.PorcGarLiq,2), Pro.FactorRiesgoSeguro, Pro.RegistroRECA, Cre.FechaInicio, Cre.FechaVencimien,
			   CONCAT(PrimerNombre,
						(CASE WHEN IFNULL(SegundoNombre, '') != '' THEN CONCAT(' ', SegundoNombre)
							  ELSE Cadena_Vacia
						 END),
					   (CASE WHEN IFNULL(TercerNombre, '') != '' THEN  CONCAT(' ', TercerNombre)
							 ELSE Cadena_Vacia
						END), ' ',
					  ApellidoPaterno, ' ', ApellidoMaterno)AS NombreCompleto,
					  Cli.ClienteID,Cli.CURP,Cli.Telefono,Dir.DireccionCompleta
				INTO Var_CAT,        Var_PorcGarLiq, Var_FacRiesgo,  Var_NumRECA,    Var_FechaInicio,
					 Var_FechaVenc,  Var_NomRepres,  Var_Cliente,     Var_CURP,      Var_Telefono,
					 Var_DireccionCompleta
			FROM CREDITOS Cre,
				 PRODUCTOSCREDITO Pro,
				 CLIENTES Cli,
				DIRECCLIENTE Dir
			WHERE Cre.CreditoID = Var_CreditoID
			  AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
			  AND Cre.ClienteID = Cli.ClienteID
			  AND Cli.ClienteID = Dir.ClienteID
			  AND Dir.Oficial=DirOficial;

		SET Var_CAT  := IFNULL(Var_CAT, Entero_Cero);
		SET Var_PorcGarLiq  := IFNULL(Var_PorcGarLiq, Entero_Cero);
		SET Var_FacRiesgo  := IFNULL(Var_FacRiesgo, Entero_Cero);

		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semanal'
					WHEN Var_Frecuencia ='C' THEN 'catorcenal'
					WHEN Var_Frecuencia ='Q' THEN 'quincenal'
					WHEN Var_Frecuencia ='M' THEN 'mensual'
					WHEN Var_Frecuencia ='P' THEN 'periodica'
					WHEN Var_Frecuencia ='B' THEN 'bimestral'
					WHEN Var_Frecuencia ='T' THEN 'trimestral'
					WHEN Var_Frecuencia ='R' THEN 'tetramestral'
					WHEN Var_Frecuencia ='E' THEN 'semestral'
					WHEN Var_Frecuencia ='A' THEN 'anual'
					WHEN Var_Frecuencia ='U' THEN 'pago unico'
				END INTO Var_DesFrec;

		SET Var_DesFrec     := IFNULL(Var_DesFrec, Cadena_Vacia);

		SELECT  CONCAT(CONVERT(Var_NumAmorti, CHAR), ' ' ,
				CASE
					WHEN Var_Frecuencia ='S' THEN 'semanas'
					WHEN Var_Frecuencia ='C' THEN 'catorcenas'
					WHEN Var_Frecuencia ='Q' THEN 'quincenas'
					WHEN Var_Frecuencia ='M' THEN 'meses'
					WHEN Var_Frecuencia ='P' THEN 'periodos'
					WHEN Var_Frecuencia ='B' THEN 'bimestres'
					WHEN Var_Frecuencia ='T' THEN 'trimestres'
					WHEN Var_Frecuencia ='R' THEN 'tetramestres'
					WHEN Var_Frecuencia ='E' THEN 'semestres'
					WHEN Var_Frecuencia ='A' THEN 'anios'
					WHEN Var_Frecuencia ='U' THEN 'pago unico'

				END ) INTO Var_Plazo;
		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semanales'
					WHEN Var_Frecuencia ='C' THEN 'catorcenales'
					WHEN Var_Frecuencia ='Q' THEN 'quincenales'
					WHEN Var_Frecuencia ='M' THEN 'mensuales'
					WHEN Var_Frecuencia ='P' THEN 'periodos'
					WHEN Var_Frecuencia ='B' THEN 'bimestrales'
					WHEN Var_Frecuencia ='T' THEN 'trimestrales'
					WHEN Var_Frecuencia ='R' THEN 'tetramestrales'
					WHEN Var_Frecuencia ='E' THEN 'semestrales'
					WHEN Var_Frecuencia ='A' THEN 'anuales'
					WHEN Var_Frecuencia ='U' THEN 'pago unico'

				END INTO Var_DesFrecLet;

		SELECT SUM(Cre.MontoSeguroVida), SUM(Cre.MontoCredito)  INTO Var_MontoSeguro, Var_SumMonCred
			FROM INTEGRAGRUPOSCRE Ing,
				 CREDITOS Cre
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID    = Cre.SolicitudCreditoID;

		SET Var_MontoSeguro		:= IFNULL(Var_MontoSeguro, Entero_Cero);
		SET Var_MonGarLiq 		:= FORMAT(Var_SumMonCred * Var_PorcGarLiq/100,2);

		SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) INTO Var_TotPagar
			FROM INTEGRAGRUPOSCRE Ing,
				 CREDITOS Cre,
				 AMORTICREDITO Amo
			WHERE Ing.GrupoID   = Par_GrupoID
			  AND Ing.Estatus   = Est_Activo
			  AND Ing.SolicitudCreditoID    = Cre.SolicitudCreditoID
			  AND Amo.CreditoID = Cre.CreditoID;

		SET Var_TotPagar    := IFNULL(Var_TotPagar, Entero_Cero);

		SELECT FUNCIONNUMLETRAS(Var_TotPagar) INTO Var_TotPagLetra;
		SELECT FUNCIONNUMLETRAS(Var_SumMonCred) INTO Var_MtoLetra;
		SELECT FUNCIONNUMLETRAS(Var_MontoGarLiq) INTO Var_GarantiaLetra;

		SET Var_PorcCobert  :=  ROUND((Var_FacRiesgo / 7 * Var_Periodo * 1000), 2);
		SELECT  CASE
					WHEN Var_Frecuencia ='S' THEN 'semana'
					WHEN Var_Frecuencia ='C' THEN 'catorcena'
					WHEN Var_Frecuencia ='Q' THEN 'quincena'
					WHEN Var_Frecuencia ='M' THEN 'mes'
					WHEN Var_Frecuencia ='P' THEN 'periodo'
					WHEN Var_Frecuencia ='B' THEN 'bimestre'
					WHEN Var_Frecuencia ='T' THEN 'trimestre'
					WHEN Var_Frecuencia ='R' THEN 'tetramestre'
					WHEN Var_Frecuencia ='E' THEN 'semestre'
					WHEN Var_Frecuencia ='A' THEN 'año'
					WHEN Var_Frecuencia ='U' THEN 'pago unico'
				END  INTO Var_FrecSeguro;

		SELECT DAY(Var_FechaVenc) , 	YEAR(Var_FechaVenc) , CASE
					WHEN month(Var_FechaVenc) = 1  THEN 'Enero'
					WHEN month(Var_FechaVenc) = 2  THEN 'Febrero'
					WHEN month(Var_FechaVenc) = 3  THEN 'Marzo'
					WHEN month(Var_FechaVenc) = 4  THEN 'Abril'
					WHEN month(Var_FechaVenc) = 5  THEN 'Mayo'
					WHEN month(Var_FechaVenc) = 6  THEN 'Junio'
					WHEN month(Var_FechaVenc) = 7  THEN 'Julio'
					WHEN month(Var_FechaVenc) = 8  THEN 'Agosto'
					WHEN month(Var_FechaVenc) = 9  THEN 'Septiembre'
					WHEN month(Var_FechaVenc) = 10 THEN 'Octubre'
					WHEN month(Var_FechaVenc) = 11 THEN 'Noviembre'
					WHEN month(Var_FechaVenc) = 12 THEN 'Diciembre' END

		INTO 	Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;

			SELECT  COUNT(*) INTO Var_NumIntegrantes
			 FROM INTEGRAGRUPOSCRE Ing,
						 SOLICITUDCREDITO Sol,
						 CREDITOS Cre,
						 PRODUCTOSCREDITO Pro,
						 CLIENTES Cli,
						 DIRECCLIENTE Dir
					WHERE Ing.GrupoID   = Par_GrupoID
					  AND Ing.Estatus   = Est_Activo
					  AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
					  AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
					  AND Cre.ProductoCreditoID  = Pro.ProducCreditoID
					  AND Cre.ClienteID = Cli.ClienteID
					  AND Cli.ClienteID = Dir.ClienteID
					  AND Dir.Oficial=DirOficial;
		SET Var_RepresentanteLegal:=(SELECT NombreRepresentante FROM PARAMETROSSIS);
		SET MontoCredito := CONCAT('$ ', FORMAT(Var_SumMonCred, 2), ' (', Var_MtoLetra, ' M.N.)');
		SET MontoTotPagar := CONCAT('$ ', FORMAT(Var_TotPagar, 2), ' (', Var_TotPagLetra, ' M.N.)');

        SELECT  MaxIntegrantes, MinIntegrantes INTO Var_MaxIntegrantes, Var_MinIntegrantes
       FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre,
             PRODUCTOSCREDITO Pro
          WHERE Ing.GrupoID   = Par_GrupoID
            AND Ing.Estatus   = Est_Activo
            AND Ing.SolicitudCreditoID = Sol.SolicitudCreditoID
            AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
            AND Cre.ProductoCreditoID  = Pro.ProducCreditoID LIMIT 1;

		SELECT 	Var_Plazo,      		Var_FechaInicio,    	Var_FechaVenc,      Var_DesFrec,    Var_TasaAnual,
				Var_TasaMens,			Var_TasaFlat,   		Var_MontoSeguro,    Var_PorcCobert, Var_CAT,
				Var_PorcGarLiq,			Var_MonGarLiq,  		Var_NomRepres,      Var_Cliente,    Var_CURP,
				Var_Telefono,   		Var_DireccionCompleta,  Var_FrecSeguro, 	Var_NumRECA, 	Var_DiaVencimiento,
				Var_AnioVencimiento,	Var_MesVencimiento, 	Var_GarantiaLetra , MontoCredito, 	Var_MtoLetra,
				Var_NumAmorti,			Var_DesFrecLet, 		MontoTotPagar, 		Var_TotPagLetra,Var_NomGrupoCred,
				Var_DestinoProyecto,    Var_NumIntegrantes,     Var_TasaMoraAnual,  Var_TasaMoratoria,Var_RepresentanteLegal,
				Var_MuniEdo, Var_DomSuc, Var_MaxIntegrantes, Var_MinIntegrantes;

	END IF;

END TerminaStore$$