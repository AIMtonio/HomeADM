-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATCREDIPASIVOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATCREDIPASIVOREP`;DELIMITER $$

CREATE PROCEDURE `CONTRATCREDIPASIVOREP`(
# =====================================================================
# ----- STORE QUE REALIZA REPORTE DE CREDITOS PASIVOS----
# =====================================================================
	Par_CreditoID         INT(11),       	-- CreditoID
    Par_TipoReporte       TINYINT UNSIGNED, -- Tipo de Reporte
    Par_InstitutFondID    INT(11),          -- ID de la institucion de fondeo

    Par_EmpresaID         INT(11),          -- Empresa ID
    Aud_Usuario           INT(11),          -- Usuario
    Aud_FechaActual       DATETIME,         -- Fecha Actual
    Aud_DireccionIP       VARCHAR(15),      -- Direccion IP
    Aud_ProgramaID        VARCHAR(50),      -- Progarma
    Aud_Sucursal          INT(11),          -- Sucursal ID
    Aud_NumTransaccion    BIGINT(20)        -- Numero de Transaccion
)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_MontoCred           DECIMAL(14,2);  -- Monto del creito en numero
    DECLARE Var_MontoLetra          VARCHAR(512);   -- Monto del credito en letras
    DECLARE Var_TasaOrdin           DECIMAL(14,2);  -- Monto de la tasa ordinaria en numero
    DECLARE Var_TasaLetra           VARCHAR(512);   -- Monto del credito en letras
    DECLARE Var_NumAmorti           INT(11);        -- Numero de amortizaciones
    DECLARE Var_NumAmortiLetra      VARCHAR(512);   -- Numero de amortizaciones en letras
    DECLARE Var_Frecuencia          CHAR(1);		-- frecuencia de los pagos
    DECLARE Var_FrecuenciaInt       CHAR(1);		-- frecuencia de los intereses
    DECLARE Var_FrecuenciaTxt       VARCHAR(512);	-- frecuencia pag en letras
    DECLARE Var_DiaFechaInicio      INT(11);		-- dia de inicio del credito
    DECLARE Var_MesFechaInicio      VARCHAR(25);	-- mes de inicio del credito
    DECLARE Var_AnioFechaInicio     INT(11);		-- anio d einicio del credito
    DECLARE Var_FechaInicio         VARCHAR(50);	-- feceha de inicio
    DECLARE Var_PeriodicidadCap     VARCHAR(100);	-- periodicidad del capital
    DECLARE Var_DiaEscritura        INT(11);		-- dia de creacion d ela escritura
    DECLARE Var_MesEscritura        INT(11);		-- mes de la alta de la escritura
    DECLARE Var_AnioEscritura       INT(11);		-- anio de creacion de la escritura
    DECLARE Var_DirInstitucion      VARCHAR(500);	-- direcion de la institucion
    DECLARE Var_NombreInsFondeo     VARCHAR(200);	--  nombre instucion de fondeo
    DECLARE Var_RazonSocInsFon      VARCHAR(200);	-- razon social de la ins de fondeo
    DECLARE Var_NomRepLegalIns     	VARCHAR(200);	-- representante legal de la institucion
    DECLARE Var_NomRepLegalInsFon   VARCHAR(200);	-- representante legal de la institucion fondeo
    DECLARE Var_DireccionInsFon     VARCHAR(500);	-- direccion de inst de fondeo
    DECLARE Var_RFCInsFon           VARCHAR(13);	-- rfc de la inst de fondeo
    DECLARE Var_RFCIns              VARCHAR(13);    -- rfc de la institucion
    DECLARE Var_DireccionFiscal     VARCHAR(250);	-- direccion fiscal de la institucion
    DECLARE Var_NombTitular         VARCHAR(200);	-- nombre del titular d ela cuenta bancaria
    DECLARE Var_NomIns      		VARCHAR(100);	-- nombre de la institucion
    DECLARE Var_NumCuentaBan        VARCHAR(20); 	-- numeor de cuenta bancaria
    DECLARE Var_CuentaClabe         VARCHAR(18);  	-- numero de cuenta clabe
    DECLARE Var_NombMunicipio       VARCHAR(150); 	-- nombre del municipio de la ins
    DECLARE Var_NombEstado          VARCHAR(100); 	-- nombre del estado de la ins
    DECLARE Var_NumEscrituraP       VARCHAR(50);	-- numero de escritura publica
    DECLARE Var_NomNotario          VARCHAR(100);	-- nombre del notario
    DECLARE Var_NumNotaria          INT(11);		-- numero de notaria
    DECLARE Var_FolioEscrituraP     VARCHAR(10);	-- folio de la esc. publica
    DECLARE Var_ClienteInstitucion  INT(11);		-- ID cliente institucional
    DECLARE Var_TotPagLetra			VARCHAR(512);	-- total de pago en letras
    DECLARE Var_TasaOrdinLetra		VARCHAR(512);	-- tasa ordinaria  en letras
    DECLARE Var_NomBanco			VARCHAR(50);	-- Nombre del banco
    DECLARE Var_FactorMora			DECIMAL(14,2);	-- Factor mora
    -- Declaracion de Constantes
    DECLARE TipoContratoFisica      INT(11);      -- Contarto para Persona Fisica o FCAE
    DECLARE TipoContratoMoral       INT(11);      -- Contarto para Persona Morales
	DECLARE TipoTablaAmortiza       INT(11);      -- Contarto para TABLE de Amor
    DECLARE Entero_Cero             INT(11);      -- Entero cero
    DECLARE Entero_Uno				INT(11);	  -- ENTERO UNO
    DECLARE Constitutiva			CHAR(1);	  -- Tipo de cata cons
    -- Asignacion de constantes
    SET TipoContratoFisica         := 1;
    SET TipoContratoMoral          := 2;
    SET TipoTablaAmortiza		   := 3;
    SET Entero_Cero                := 0;
    SET Entero_Uno				   := 1;
	SET Constitutiva			   := 'C';

    -- Tipo de Reporte Contrato Personas Fisicas
    IF (Par_TipoReporte = TipoContratoFisica) THEN

        -- Se obtienen los datos de la institucion de Fondeo
        SELECT  InsF.NombreInstitFon,   InsF.RazonSocInstFo,    Par.NombreRepresentante,    InsF.RepresentanteLegal,    InsF.DireccionCompleta,
                InsF.RFC,               Ins.RFC,                Ins.DirFiscal ,             InsF.NombreTitular,         Ins.Nombre,
                InsF.NumCtaInstit,      InsF.CuentaClabe,       Mun.Nombre,                 Edo.Nombre,                 Par.ClienteInstitucion
        INTO    Var_NombreInsFondeo,    Var_RazonSocInsFon,     Var_NomRepLegalIns,        	Var_NomRepLegalInsFon,      Var_DireccionInsFon,
                Var_RFCInsFon,          Var_RFCIns,             Var_DireccionFiscal,        Var_NombTitular,            Var_NomIns,
                Var_NumCuentaBan,       Var_CuentaClabe,        Var_NombMunicipio,          Var_NombEstado,             Var_ClienteInstitucion
        FROM   INSTITUTFONDEO   InsF, PARAMETROSSIS Par, INSTITUCIONES Ins
        LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON  Mun.EstadoID  = Ins.EstadoEmpresa
            AND Mun.MunicipioID = Ins.MunicipioEmpresa
        LEFT OUTER JOIN ESTADOSREPUB  Edo ON  Edo.EstadoID  = Ins.EstadoEmpresa
            WHERE InsF.InstitutFondID = Par_InstitutFondID
            AND   Par.EmpresaID = InsF.EmpresaID
            AND   Ins.InstitucionID = Par.InstitucionID;

        -- Datos de la escritura constitutiva
        SELECT  EscP.EscrituraPublic,       DAYOFMONTH(EscP.FechaEsc),      MONTH(EscP.FechaEsc),       YEAR(EscP.FechaEsc),        EscP.NomNotario,
                EscP.Notaria,               EscP.FolioRegPub
        INTO    Var_NumEscrituraP,          Var_DiaEscritura,               Var_MesEscritura,           Var_AnioEscritura,          Var_NomNotario,
                Var_NumNotaria,             Var_FolioEscrituraP
        FROM  ESCRITURAPUB EscP,    PARAMETROSSIS Par
        WHERE EscP.ClienteID = Var_ClienteInstitucion
			AND EscP.Esc_Tipo = Constitutiva
            LIMIT 1;

        -- Datos tabla de Creditos de Fondeo
        SELECT  Cred.Monto,                 Cred.TasaFija,          		CredP.Dias,    			    Cred.FrecuenciaCap,      			DAYOFMONTH(Cred.FechaInicio),
                MONTH(Cred.FechaInicio),    YEAR(Cred.FechaInicio),      	Cred.FechaInicio,        	UPPER(Cat.DescInfinitivo),    		Ins.Nombre
        INTO    Var_MontoCred,              Var_TasaOrdin,          		Var_NumAmorti,      		Var_Frecuencia,     				Var_DiaFechaInicio,
                Var_MesFechaInicio,         Var_AnioFechaInicio,    		Var_FechaInicio,    		Var_PeriodicidadCap,				Var_NomBanco
        FROM CREDITOSPLAZOS CredP, CATFRECUENCIAS Cat, CREDITOFONDEO Cred
			INNER JOIN INSTITUCIONES Ins ON  Ins.InstitucionID  = Cred.InstitucionID
            WHERE Cred.CreditoFondeoID = Par_CreditoID
			AND Cred.PlazoID		= CredP.PlazoID
            AND Cred.FrecuenciaInt	= Cat.FrecuenciaID;

        SET Var_MontoCred    := IFNULL(Var_MontoCred, Entero_Cero);
        SET Var_TasaOrdin    := IFNULL(Var_TasaOrdin, Entero_Cero);
        SET Var_NumAmorti    := IFNULL(Var_NumAmorti, Entero_Cero);
		SET Var_FechaInicio  := UPPER(FNFECHATEXTO(Var_FechaInicio));
        -- Actualiza el plazo en meses:
        SET Var_NumAmorti := Var_NumAmorti / 30;

        SELECT FUNCIONNUMLETRAS(Var_MontoCred)  INTO  Var_MontoLetra;
        SELECT FUNCIONSOLONUMLETRAS(Var_NumAmorti)  INTO  Var_NumAmortiLetra;
        SELECT FUNCIONSOLONUMLETRAS(Var_TasaOrdin)  INTO  Var_TasaOrdinLetra;


        -- Actualiza el mes de inicio
		SELECT CASE WHEN Var_MesFechaInicio = 1 THEN 'ENERO'
			WHEN Var_MesFechaInicio = 2 THEN 'FEBRERO'
			WHEN Var_MesFechaInicio = 3 THEN 'MARZO'
			WHEN Var_MesFechaInicio = 4 THEN 'ABRIL'
			WHEN Var_MesFechaInicio = 5 THEN 'MAYO'
			WHEN Var_MesFechaInicio = 6 THEN 'JUNIO'
			WHEN Var_MesFechaInicio = 7 THEN 'JULIO'
			WHEN Var_MesFechaInicio = 8 THEN 'AGOSTO'
			WHEN Var_MesFechaInicio = 9 THEN 'SEPTIEMBRE'
			WHEN Var_MesFechaInicio = 10 THEN 'OCTUBRE'
			WHEN Var_MesFechaInicio = 11 THEN 'NOVIEMBRE'
			WHEN Var_MesFechaInicio = 12 THEN 'DICIEMBRE'
		END INTO Var_MesFechaInicio;


        SELECT  Var_NombreInsFondeo,    Var_RazonSocInsFon,     Var_NomRepLegalIns,        	Var_NomRepLegalInsFon,      Var_DireccionInsFon,
                Var_RFCInsFon,          Var_RFCIns,             Var_DireccionFiscal,        Var_NombTitular,            Var_NomIns,
                Var_NumCuentaBan,       Var_CuentaClabe,        Var_NombMunicipio,          Var_NombEstado,             Var_NumEscrituraP,
                Var_DiaEscritura,       Var_MesEscritura,       Var_AnioEscritura,          Var_NomNotario,             Var_NumNotaria,
                Var_FolioEscrituraP,    FORMAT(Var_MontoCred,2) AS Var_MontoCred,           Var_TasaOrdin,              Var_NumAmorti,
                Var_Frecuencia,   		Var_DiaFechaInicio,     Var_MesFechaInicio,     	Var_AnioFechaInicio,        Var_FechaInicio,
                Var_PeriodicidadCap,	Var_MontoLetra,			Var_TotPagLetra,			Var_NumAmortiLetra,			Var_TasaOrdinLetra,
                Var_NomBanco;
		END IF;

		IF(Par_TipoReporte = TipoTablaAmortiza)THEN
         SELECT
            Amo.AmortizacionID,
			UPPER(FNFECHATEXTO(Amo.FechaInicio)) AS  FechaInicioAmo,
            UPPER(FNFECHATEXTO(Amo.FechaExigible)) AS  FechaPagoAmo,
            DATEDIFF(Amo.FechaExigible,Amo.FechaInicio) AS  DiasPagoAmo,
            IFNULL(CreF.Monto,Entero_Cero)   AS  SaldoInsolutoAmo,
            IFNULL((CreF.TasaFija/100) ,Entero_Cero)  AS TasaBaseAmo,
            IFNULL(CreF.Monto,Entero_Cero) AS MontoFondeoAmo,
            IFNULL(Amo.Interes,Entero_Cero)     AS  PagoInteresOrdAmo,
            IFNULL(Amo.Retencion,Entero_Cero)    AS  PagoISRAmo,
            IFNULL((Amo.Interes - Amo.Retencion),Entero_Cero) AS  PagoTotalAmo

        FROM  AMORTIZAFONDEO Amo , CREDITOFONDEO CreF
            WHERE Amo.CreditoFondeoID   =   Par_CreditoID
                AND Amo.CreditoFondeoID =   CreF.CreditoFondeoID;
		END IF;


END TerminaStore$$