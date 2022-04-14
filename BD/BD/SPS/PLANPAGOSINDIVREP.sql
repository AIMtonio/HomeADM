-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLANPAGOSINDIVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLANPAGOSINDIVREP`;DELIMITER $$

CREATE PROCEDURE `PLANPAGOSINDIVREP`(
    Par_GrupoID         INT,
    Par_CreditoID       BIGINT(12),
    Par_ClienteID       INT,
    Par_TipoReporte     INT,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
		)
TerminaStore: BEGIN

-- Declaracion de Variables amortizacion
DECLARE	NumInstitucion 		INT;
DECLARE DireccionInstitu 	VARCHAR(250);
DECLARE NombreInstitu 		VARCHAR(100);
DECLARE	Sucurs				VARCHAR(50);
DECLARE Registro_Reca		VARCHAR(200);
-- --------------------------------------
-- variables datos grupo
DECLARE Var_NumInt          INT;
DECLARE Var_NomGrupo        VARCHAR(50);
DECLARE Var_SolicitudPres   INT;
DECLARE Var_Cargo            INT;
DECLARE Var_Estado           VARCHAR(50);
DECLARE Var_TipoPlan       VARCHAR(50);
DECLARE Var_TipoPrestamo   VARCHAR(50);
DECLARE Var_NumAmort         INT;
DECLARE Var_ClienteID        INT;
DECLARE Var_Promotor       VARCHAR(50);
DECLARE Var_Sucursal       VARCHAR(50);
DECLARE Var_CicloGruAc        INT;
DECLARE Var_CicloAnt        INT;
DECLARE Var_NumCredAnt       BIGINT(12);
DECLARE Var_MontoCredAnt     DECIMAL(12,2);

DECLARE Var_TasaAnual   			DECIMAL(12,4);
DECLARE Var_TasaMens   	 		DECIMAL(12,4);
DECLARE Var_TasaFlat    			DECIMAL(12,4);
DECLARE Var_CAT         			DECIMAL(12,4);
DECLARE Var_CreditoID   			BIGINT(12);
DECLARE Var_TotInteres  			DECIMAL(14,2);
DECLARE Var_NumAmorti   			INT;
DECLARE Var_MontoCred   			DECIMAL(14,2);
DECLARE Var_SumMonCred         DECIMAL(14,2);
DECLARE Var_PorcGarLiq  			DECIMAL(12,2);
DECLARE Var_MontoGarLiq   			DECIMAL(14,2);
DECLARE Var_MonGarLiq   			VARCHAR(20);
DECLARE Var_Plazo       			VARCHAR(100);
DECLARE Var_FechaVenc   			DATE;
DECLARE Var_MontoSeguro 			DECIMAL(14,2);
DECLARE Var_PorcCobert  			DECIMAL(12,4);
DECLARE Var_NomRepres   			VARCHAR(300);
DECLARE Var_Periodo     			INT;
DECLARE Var_Frecuencia  			CHAR(1);
DECLARE Var_DesFrec     			VARCHAR(100);
DECLARE Var_FacRiesgo   			DECIMAL(12,6);
DECLARE Var_FrecSeguro  			VARCHAR(100);
DECLARE Var_NumRECA    			VARCHAR(200);
DECLARE Var_DiaVencimiento			VARCHAR(20);
DECLARE Var_MesVencimiento			VARCHAR(20);
DECLARE Var_AnioVencimiento		VARCHAR(20);
DECLARE Var_RepresentanteLegal		VARCHAR(200);
DECLARE Var_DirccionInstitucion	VARCHAR(300);
DECLARE Var_SexoRepteLegal			CHAR(200);
DECLARE Var_TelInstitucion			VARCHAR(20);
DECLARE Var_NombreEstado			VARCHAR(100);
DECLARE Var_RFCOficial 			VARCHAR(20);
DECLARE Var_DiaSistema				INT;
DECLARE Var_AnioSistema			INT;
DECLARE Var_MesSistema 			VARCHAR(20);
DECLARE Var_NomCortoInstit			VARCHAR(50);
DECLARE Var_FechaMinistrado     VARCHAR(15);
DECLARE Var_ProductoCreditoID    INT;

-- Variables  Alternativa 19
DECLARE Var_TipoCredito         VARCHAR(250);  -- Caracteristicas del Producto de  credito
DECLARE Var_DescProdCre         VARCHAR(250);  -- Descripcion del producto de credito
DECLARE Var_CliNombres          VARCHAR(100);  -- Nombre del cliente
DECLARE Var_NumeroCuenta			VARCHAR(100);
DECLARE Var_NombreBanco				VARCHAR(100);
DECLARE Var_Clabe					VARCHAR(100);
DECLARE Var_SucursalCred			INT(11);
DECLARE Var_PeriodCap 			INT(11);
DECLARE Var_PeriodInt 			INT(11);
DECLARE Var_FrecCapital 		CHAR(1);
DECLARE Var_FrecInteres 		CHAR(1);
DECLARE Var_FrecuenciaTxt		VARCHAR(30);


DECLARE Var_EstatusCredito		CHAR(1);

-- Declaracion de Constantes
DECLARE Esta_Activo     CHAR(1);
DECLARE Lis_Integra         INT;
DECLARE Tipo_Amortizacion         INT;
DECLARE	EstCerrado		CHAR(1);
DECLARE Tipo_DatosGrupo	 INT;
DECLARE Tipo_Enca          INT;
DECLARE Tipo_Alternativa INT;		-- Tipo Alternativa 19
DECLARE Tipo_AmortizaAlternativa INT(11);  -- Amortizaciones Alternativa

DECLARE Cadena_Vacia        CHAR(1);
DECLARE Entero_Cero         INT;
DECLARE Fecha_Vacia         DATE;
DECLARE Est_Activo          CHAR(1);
DECLARE Int_Presiden        INT;
DECLARE Tipo_DatosCred          INT;
DECLARE EstatusAutorizado	CHAR(1);
DECLARE EstatusInactivo		CHAR(1);

DECLARE FrecSemanal       	CHAR(1);
DECLARE FrecCatorcenal      CHAR(1);
DECLARE FrecLibre       	CHAR(1);
DECLARE FrecQuincenal     	CHAR(1);
DECLARE FrecMensual       	CHAR(1);
DECLARE FrecPeriodica     	CHAR(1);
DECLARE FrecBimestral     	CHAR(1);
DECLARE FrecTrimestral      CHAR(1);
DECLARE FrecTetramestral	CHAR(1);
DECLARE FrecSemestral     	CHAR(1);
DECLARE FrecAnual       	CHAR(1);
DECLARE FrecUnico       	CHAR(1);
DECLARE FrecDecenal       	CHAR(1);

DECLARE TxtSemanal        	VARCHAR(20);
DECLARE TxtCatorcenal     	VARCHAR(20);
DECLARE TxtQuincenal      	VARCHAR(20);
DECLARE TxtMensual        	VARCHAR(20);
DECLARE TxtPeriodica      	VARCHAR(20);
DECLARE TxtBimestral      	VARCHAR(20);
DECLARE TxtTrimestral     	VARCHAR(20);
DECLARE TxtTetramestral		VARCHAR(20);
DECLARE TxtSemestral      	VARCHAR(20);
DECLARE TxtAnual        	VARCHAR(20);
DECLARE TxtDecenal        	VARCHAR(20);
DECLARE TxtLibres       	VARCHAR(20);
DECLARE TxtUnico        	VARCHAR(40);

-- Asignacion de Constantes
SET	EstCerrado			:= 'C';
SET Esta_Activo         := 'A';

SET Cadena_Vacia        := '';              -- String Vacio
SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero         := 0;               -- Entero en Cero
SET Est_Activo          := 'A';             -- Estatus del Integrante: Activo
SET Int_Presiden        := 1;               -- Tipo de Integrante: Presidente
SET Tipo_DatosCred      := 1;               -- Reporte datos de credito
SET Tipo_DatosGrupo    	:= 2;				    -- ReporteGrupos
SET Lis_Integra    		:= 3;                     -- Reporte Integrantes
SET Tipo_Amortizacion   := 4;               -- Reporte Amortizacion
SET Tipo_Enca           := 5;           -- encabezado
SET Tipo_Alternativa    := 6;           -- Encabezado Alternativa 19
SET Tipo_AmortizaAlternativa  := 7; 	-- Tabla de amortizaciones Alternativa 19

SET EstatusAutorizado	:='A';			-- Estatus Autorizado
SET EstatusInactivo		:='I';			-- Estatus Inactivo

SET FrecSemanal     	:= 'S';
SET FrecCatorcenal    	:= 'C';
SET FrecQuincenal   	:= 'Q';
SET FrecMensual     	:= 'M';
SET FrecPeriodica   	:= 'P';
SET FrecBimestral   	:= 'B';
SET FrecTrimestral    	:= 'T';
SET FrecTetramestral	:= 'R';
SET FrecSemestral   	:= 'E';
SET FrecAnual     		:= 'A';
SET FrecUnico     		:= 'U';
SET FrecLibre     		:= 'L';
SET FrecDecenal     	:= 'D';

SET TxtSemanal      	:= 'Semanal' ;
SET TxtCatorcenal   	:= 'Catorcenal' ;
SET TxtQuincenal    	:= 'Quincenal' ;
SET TxtMensual      	:= 'Mensual' ;
SET TxtPeriodica    	:= 'Periodica'   ;
SET TxtBimestral    	:= 'Bimestral' ;
SET TxtTrimestral   	:= 'Trimestral' ;
SET TxtTetramestral		:= 'Tetramestral' ;
SET TxtSemestral    	:= 'Semestral';
SET TxtAnual      		:= 'Anual';
SET TxtDecenal      	:= 'Decenal';
SET TxtUnico        	:= 'Pago Unico';
SET TxtLibres			:= 'Libres';


-- Tipo de Reporte datos de credito
IF (Par_TipoReporte = Tipo_DatosCred) THEN
-- ciclo actual del grupo
         SET Var_MontoCredAnt   := FORMAT(Entero_Cero,2);
         SET Var_NumCredAnt   := Entero_Cero;

     SELECT FechaMinistrado, ProductoCreditoID INTO Var_FechaMinistrado, Var_ProductoCreditoID
            FROM CREDITOS
            WHERE CreditoID = Par_CreditoID;

        SELECT CreditoID, MontoCredito INTO Var_NumCredAnt, Var_MontoCredAnt
                FROM CREDITOS
                WHERE ClienteID = Par_ClienteID AND FechaMinistrado < Var_FechaMinistrado
                AND (GrupoID != 0 OR GrupoID IS NOT NULL) AND ProductoCreditoID = Var_ProductoCreditoID
                ORDER BY FechaMinistrado DESC LIMIT 1;

    SET Var_TasaAnual   := Entero_Cero;
    SET Var_TasaMens    := Entero_Cero;
    SET Var_TasaFlat    := Entero_Cero;
    SET Var_MontoSeguro := Entero_Cero;
    SET Var_PorcCobert  := Entero_Cero;

    SELECT
            CASE WHEN Sol.GrupoID >0 THEN 'GRUPAL'
            ELSE CASE WHEN Sol.GrupoID <0 THEN 'INDIVIDUAL'
            END	END,Sol.NumAmortizacion  INTO
            Var_TipoPrestamo,Var_NumAmort
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol
        WHERE Ing.GrupoID   = Par_GrupoID
          AND Ing.Cargo     = Int_Presiden
          AND Ing.Estatus   = Est_Activo
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID;

    SELECT
            CASE WHEN Sol.TipoPagoCapital = 'C' THEN 'CRECIENTES'
            ELSE CASE WHEN Sol.TipoPagoCapital = 'I' THEN 'IGUALES'
            ELSE CASE WHEN Sol.TipoPagoCapital = 'L' THEN 'LIBRES'
            END	END END  INTO  Var_TipoPlan
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol
        WHERE Ing.GrupoID   = Par_GrupoID
          AND Ing.Cargo     = Int_Presiden
          AND Ing.Estatus   = Est_Activo
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID;

    SELECT Sol.TasaFija,        Sol.CreditoID, Sol.NumAmortizacion, Sol.MontoAutorizado,
           Sol.PeriodicidadCap, Sol.FrecuenciaCap   INTO
            Var_TasaAnual,      Var_CreditoID, Var_NumAmorti,       Var_MontoCred,
            Var_Periodo,        Var_Frecuencia
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol
        WHERE Ing.GrupoID   = Par_GrupoID
          AND Ing.Cargo     = Int_Presiden
          AND Ing.Estatus   = Est_Activo
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID;

    SET Var_TasaAnual   := IFNULL(Var_TasaAnual, Entero_Cero);
    SET Var_CreditoID   := IFNULL(Var_CreditoID, Entero_Cero);
    SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);

    SET Var_TasaMens    := ROUND(Var_TasaAnual / 12, 4);

    SELECT  SUM(Amo.Interes) INTO Var_TotInteres
        FROM AMORTICREDITO Amo
        WHERE Amo.CreditoID = Var_CreditoID;

    SET Var_TotInteres  := IFNULL(Var_TotInteres, Entero_Cero);
	SET Var_TasaFlat    := (IF(Var_MontoCred != Entero_Cero, (IF(Var_NumAmorti != Entero_Cero, (Var_TotInteres / Var_NumAmorti), Entero_Cero) / Var_MontoCred), Entero_Cero) /
                                Var_Periodo ) * 30 * 100;
    SET Var_TasaFlat    := ROUND(Var_TasaFlat, 4);

    SELECT Cre.ValorCAT,  ROUND(Cre.PorcGarLiq,2), Pro.FactorRiesgoSeguro, Pro.RegistroRECA, Cre.FechaVencimien,
           CONCAT(PrimerNombre,
                    (CASE WHEN IFNULL(SegundoNombre, '') != '' THEN CONCAT(' ', SegundoNombre)
                          ELSE Cadena_Vacia
                     END),
                   (CASE WHEN IFNULL(TercerNombre, '') != '' THEN  CONCAT(' ', TercerNombre)
                         ELSE Cadena_Vacia
                    END), ' ',
                  ApellidoPaterno, ' ', ApellidoMaterno) INTO
            Var_CAT,        Var_PorcGarLiq, Var_FacRiesgo,  Var_NumRECA,    Var_FechaVenc,
            Var_NomRepres
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

    SELECT SUM(Cre.MontoSeguroVida), SUM(Cre.MontoCredito)  INTO Var_MontoSeguro, Var_SumMonCred
        FROM INTEGRAGRUPOSCRE Ing,
             CREDITOS Cre
        WHERE Ing.GrupoID   = Par_GrupoID
          AND Ing.Estatus   = Est_Activo
          AND Ing.SolicitudCreditoID    = Cre.SolicitudCreditoID;

    SET Var_MontoSeguro		:= IFNULL(Var_MontoSeguro, Entero_Cero);
    SET Var_MontoGarLiq		:= ROUND(Var_SumMonCred * Var_PorcGarLiq / 100, 2);
	SET Var_MonGarLiq 		:= FORMAT(Var_MontoGarLiq,2);

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
                WHEN Var_Frecuencia ='A' THEN 'aÃ±o'

            END  INTO Var_FrecSeguro;

	SELECT DAY(Var_FechaVenc) , 	YEAR(Var_FechaVenc) , CASE
				WHEN MONTH(Var_FechaVenc) = 1  THEN 'Enero'
				WHEN MONTH(Var_FechaVenc) = 2  THEN 'Febrero'
				WHEN MONTH(Var_FechaVenc) = 3  THEN 'Marzo'
				WHEN MONTH(Var_FechaVenc) = 4  THEN 'Abril'
				WHEN MONTH(Var_FechaVenc) = 5  THEN 'Mayo'
				WHEN MONTH(Var_FechaVenc) = 6  THEN 'Junio'
				WHEN MONTH(Var_FechaVenc) = 7  THEN 'Julio'
				WHEN MONTH(Var_FechaVenc) = 8  THEN 'Agosto'
				WHEN MONTH(Var_FechaVenc) = 9  THEN 'Septiembre'
				WHEN MONTH(Var_FechaVenc) = 10 THEN 'Octubre'
				WHEN MONTH(Var_FechaVenc) = 11 THEN 'Noviembre'
				WHEN MONTH(Var_FechaVenc) = 12 THEN 'Diciembre' END

	INTO 	Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;

	SET NumInstitucion  	:= (SELECT InstitucionID FROM PARAMETROSSIS);

	SELECT	Direccion,			Nombre
	INTO	DireccionInstitu,	NombreInstitu
	FROM 	INSTITUCIONES
	WHERE 	InstitucionID = NumInstitucion;

    SELECT 	Var_NumCredAnt, 	Var_MontoCredAnt,	Var_Plazo,      	Var_FechaVenc,  Var_DesFrec,
			Var_NumAmort, 		Var_TipoPrestamo, 	Var_TipoPlan, 		Var_TasaAnual, 	Var_TasaMens,
            Var_TasaFlat,   	Var_MontoSeguro,    Var_PorcCobert, 	Var_CAT,       	Var_PorcGarLiq,
            Var_MonGarLiq,  	Var_NomRepres,      Var_FrecSeguro, 	Var_NumRECA, 	Var_DiaVencimiento,
			Var_AnioVencimiento,Var_MesVencimiento,	DireccionInstitu,	NombreInstitu;

END IF;


IF (Par_TipoReporte = Tipo_DatosGrupo) THEN

    SELECT cli.NombreCompleto,
       CASE WHEN inte.Cargo = 1 THEN 'PRESIDENTE'
            WHEN inte.Cargo = 2 THEN 'TESORERO'
            WHEN inte.Cargo = 3 THEN 'SECRETARIO'
            WHEN inte.Cargo = 4 THEN 'INTEGRANTE' END AS Cargo,
       CASE WHEN inte.Estatus = 'A' THEN 'ACTIVO'
            WHEN inte.Estatus= 'I' THEN 'INACTIVO'
            WHEN inte.Estatus= 'R' THEN 'RECHAZADO' END AS Estado

        FROM
            INTEGRAGRUPOSCRE inte, CLIENTES cli
        WHERE inte.ClienteID = Par_ClienteID AND inte.GrupoID = Par_GrupoID AND inte.ClienteID = cli.ClienteID;

END IF;

IF(Par_TipoReporte = Lis_Integra) THEN
    SELECT  Cre. ClienteID,     Cte.NombreCompleto, Cre.MontoCredito
    FROM INTEGRAGRUPOSCRE Inte,
             CLIENTES  Cte,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre
    WHERE Inte.GrupoID	= Par_GrupoID
    AND Cre.ClienteID = Sol.ClienteID
    AND Sol.ClienteID = Inte.ClienteID
    AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
    AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
    AND Cte.ClienteID = Cre.ClienteID
    AND Inte.Estatus = Esta_Activo;

END IF;

IF(Par_TipoReporte = Tipo_Amortizacion) THEN
    SET NumInstitucion  	:= (SELECT InstitucionID FROM PARAMETROSSIS);

	SELECT	Direccion,		Nombre
			INTO
			DireccionInstitu,	NombreInstitu
		FROM INSTITUCIONES
		WHERE InstitucionID = NumInstitucion;

		SET Sucurs		:= (SELECT S.NombreSucurs
								FROM USUARIOS U, SUCURSALES S
								WHERE UsuarioID=1
								AND U.SucursalUsuario= S.SucursalID);

	SET Var_EstatusCredito	:=(SELECT Estatus
							FROM CREDITOS
								WHERE CreditoID = Par_CreditoID);
	SET Var_EstatusCredito	:=IFNULL(Var_EstatusCredito,Cadena_Vacia);

	IF (Var_EstatusCredito = EstatusAutorizado OR Var_EstatusCredito = EstatusInactivo)THEN
		SELECT	Amo.AmortizacionID,	    Amo.FechaInicio,    Amo.FechaVencim,    Amo.FechaExigible,
			(Amo.Capital+Amo.Interes+Amo.IVAInteres) AS montoCuota,     Amo.Interes,    Amo.IVAInteres,
			Amo.Capital,	Amo.SaldoCapital, NombreInstitu,	DireccionInstitu,   Sucurs
				FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Par_CreditoID;
	ELSE
		SELECT	Pag.AmortizacionID,	    Pag.FechaInicio,    Pag.FechaVencim,    Pag.FechaExigible,
			(Pag.Capital+Pag.Interes+Pag.IVAInteres) AS montoCuota,    Pag.Interes,    Pag.IVAInteres,
			Pag.Capital,	 NombreInstitu,	DireccionInstitu,   Sucurs
				FROM PAGARECREDITO Pag
			WHERE Pag.CreditoID = Par_CreditoID;
	END IF;

END IF;

IF(Par_TipoReporte = Lis_Integra) THEN
    SELECT  Cre. ClienteID,     Cte.NombreCompleto, Cre.MontoCredito
        FROM INTEGRAGRUPOSCRE Inte,
                 CLIENTES  Cte,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
        WHERE Inte.GrupoID	= Par_GrupoID
        AND Cre.ClienteID = Sol.ClienteID
        AND Sol.ClienteID = Inte.ClienteID
        AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
        AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
        AND Cte.ClienteID = Cre.ClienteID
        AND Inte.Estatus = Esta_Activo;

END IF;

IF(Par_TipoReporte = Tipo_Enca) THEN
    SELECT	P.NombrePromotor, S.NombreSucurs INTO Var_Promotor, Var_Sucursal
        FROM	CLIENTES 	C,
				PROMOTORES 	P,
				SUCURSALES  S
			WHERE C.ClienteID= Par_ClienteID
			AND C.PromotorActual=P.PromotorID
			AND C.SucursalOrigen=S.SucursalID;


	SELECT R.RegistroReca INTO Registro_Reca
	FROM  CREDITOS C
		INNER JOIN PRODUCTOSCREDITO R
		WHERE  CreditoID=Par_CreditoID
			AND C.ProductoCreditoID=R.ProducCreditoID;

    SELECT Par_ClienteID,Var_Promotor, Var_Sucursal,Registro_Reca;

END IF;

-- Seccion Alternativa 19
IF( Par_TipoReporte =   Tipo_Alternativa )   THEN

	SET Var_SucursalCred := (SELECT SucursalID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
	-- Datos del Banco
	SELECT CA.SucursalInstit, CA.NumCtaInstit, CA.CueClave
	INTO 	Var_NombreBanco,	Var_NumeroCuenta,	Var_Clabe
	FROM SUCURSALES SU
	INNER JOIN CENTROCOSTOS CC ON SU.CentroCostoID = CC.CentroCostoID
	INNER JOIN CUENTASAHOTESO CA ON CC.CentroCostoID = CA.CentroCostoID
	WHERE SucursalID = Var_SucursalCred
	ORDER BY SucursalID
	LIMIT 1;

    SELECT  Par.InstitucionID,  Ins.Nombre,     Ins.DirFiscal
    INTO    NumInstitucion,     NombreInstitu,  DireccionInstitu
    FROM        PARAMETROSSIS   Par
    INNER JOIN  INSTITUCIONES   Ins ON  Ins.InstitucionID   =   Par.InstitucionID;

    SELECT  Suc.NombreSucurs,   Cli.NombreCompleto
    INTO    Sucurs,         Var_CliNombres
    FROM            CLIENTES    Cli
    LEFT OUTER JOIN SUCURSALES  Suc ON  Suc.SucursalID  =   Cli.SucursalOrigen
    LEFT OUTER JOIN PROMOTORES  Pro ON  Pro.PromotorID  =   Cli.PromotorActual
    WHERE   Cli.ClienteID   =   Par_ClienteID;


    SELECT IFNULL(PeriodicidadCap,Entero_Cero), IFNULL(PeriodicidadInt,Entero_Cero),
				IFNULL(FrecuenciaCap, Cadena_Vacia), IFNULL(FrecuenciaInt, Cadena_Vacia)
        INTO Var_PeriodCap, Var_PeriodInt, Var_FrecCapital, Var_FrecInteres
        FROM CREDITOS
        WHERE CreditoID =Par_CreditoID;

        IF(Var_PeriodCap <= Var_PeriodInt) THEN
			SET Var_Frecuencia := Var_FrecCapital;
            ELSE
            SET Var_Frecuencia := Var_FrecInteres;
            END IF;

        SELECT
			CASE
                            WHEN Var_Frecuencia = FrecSemanal   THEN TxtSemanal
                            WHEN Var_Frecuencia =FrecCatorcenal   THEN TxtCatorcenal
                            WHEN Var_Frecuencia =FrecQuincenal  THEN TxtQuincenal
                            WHEN Var_Frecuencia =FrecMensual    THEN TxtMensual
                            WHEN Var_Frecuencia =FrecPeriodica  THEN TxtPeriodica
                            WHEN Var_Frecuencia =FrecBimestral  THEN TxtBimestral
                            WHEN Var_Frecuencia =FrecTrimestral   THEN TxtTrimestral
                            WHEN Var_Frecuencia =FrecTetramestral THEN TxtTetramestral
                            WHEN Var_Frecuencia =FrecSemestral  THEN TxtSemestral
                            WHEN Var_Frecuencia =FrecAnual    THEN TxtAnual
                            WHEN Var_Frecuencia =FrecLibre    THEN TxtLibres
                            WHEN Var_Frecuencia =FrecUnico    THEN TxtUnico
                            WHEN Var_Frecuencia =FrecDecenal    THEN TxtDecenal
                            ELSE Cadena_Vacia
                          END
                          INTO Var_FrecuenciaTxt
            FROM CREDITOS
           WHERE CreditoID = Par_CreditoID;

  SELECT Pro.Descripcion, Pro.Caracteristicas,  Pro.RegistroRECA,   Cre.TasaFija, Cre.NumAmortizacion, Pc.Descripcion, Cre.PeriodicidadCap
    INTO           Var_DescProdCre,  Var_TipoCredito, Var_NumRECA, Var_TasaAnual, Var_NumAmorti,Var_Plazo, Var_Periodo
    FROM        CREDITOS    Cre
    INNER JOIN  PRODUCTOSCREDITO    Pro ON  Pro.ProducCreditoID =   Cre.ProductoCreditoID
    INNER JOIN CREDITOSPLAZOS Pc ON Pc.PlazoID = Cre.PlazoID
    WHERE   Cre.CreditoID   =   Par_CreditoID;



    SET NombreInstitu   :=  IFNULL(NombreInstitu, Cadena_Vacia);
    SET Sucurs      :=  IFNULL(Sucurs, Cadena_Vacia);
    SET DireccionInstitu := IFNULL(DireccionInstitu, Cadena_Vacia);
    SET Var_CliNombres      :=  IFNULL(Var_CliNombres,  Cadena_Vacia);
    SET Var_DescProdCre      :=  IFNULL(Var_DescProdCre,  Cadena_Vacia);
    SET Var_TipoCredito        :=  IFNULL(Var_TipoCredito,    Cadena_Vacia);
    SET Var_NumRECA        :=  IFNULL(Var_NumRECA,    Cadena_Vacia);
    SET Var_TasaAnual        :=  IFNULL(Var_TasaAnual,    Cadena_Vacia);
    SET Var_NumAmorti        :=  IFNULL(Var_NumAmorti,    Cadena_Vacia);
    SET Var_Plazo        :=  IFNULL(Var_Plazo,    Cadena_Vacia);
    SET Var_Periodo         := IFNULL(Var_Periodo,  Cadena_Vacia);


    SELECT  NombreInstitu,  Sucurs,    DireccionInstitu,   Var_CliNombres, Var_DescProdCre,
     Var_TipoCredito,    Var_NumRECA,   ROUND(Var_TasaAnual,2) AS Var_TasaAnual,  Var_NumAmorti,  Var_Plazo,
     Var_Periodo, Var_NombreBanco,	  Var_NumeroCuenta,	 Var_Clabe, Var_FrecuenciaTxt;

END IF;

IF(Par_TipoReporte = Tipo_AmortizaAlternativa) THEN
    SET NumInstitucion  	:= (SELECT InstitucionID FROM PARAMETROSSIS);

	SELECT	Direccion,		Nombre
			INTO
			DireccionInstitu,	NombreInstitu
		FROM INSTITUCIONES
		WHERE InstitucionID = NumInstitucion;

		SET Sucurs		:= (SELECT S.NombreSucurs
								FROM USUARIOS U, SUCURSALES S
								WHERE UsuarioID=1
								AND U.SucursalUsuario= S.SucursalID);

	SET Var_EstatusCredito	:=(SELECT Estatus
							FROM CREDITOS
								WHERE CreditoID = Par_CreditoID);
	SET Var_EstatusCredito	:=IFNULL(Var_EstatusCredito,Cadena_Vacia);

	IF (Var_EstatusCredito = EstatusAutorizado OR Var_EstatusCredito = EstatusInactivo)THEN
		SELECT	Amo.AmortizacionID,	    Amo.FechaInicio,    Amo.FechaVencim,    Amo.FechaExigible,
			(Amo.Capital+Amo.Interes+Amo.IVAInteres) AS montoCuota,     Amo.Interes,    Amo.IVAInteres,
			Amo.Capital,	CONCAT('$ ',FORMAT(Amo.SaldoCapital,2)) AS SaldoCapital, NombreInstitu,	DireccionInstitu,   Sucurs
				FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Par_CreditoID;
	ELSE


		SELECT	Pag.AmortizacionID,	    Pag.FechaInicio,    Pag.FechaVencim,    Pag.FechaExigible,
			(Pag.Capital+Pag.Interes+Pag.IVAInteres) AS montoCuota,    Pag.Interes,    Pag.IVAInteres,
			Pag.Capital,
            CONCAT('$ ',FORMAT((@Var_MontoCred:= ROUND(@Var_MontoCred,2)-Pag.Capital),2)) AS SaldoCapital,	 NombreInstitu,	DireccionInstitu,   Sucurs
				FROM PAGARECREDITO Pag,
                 (SELECT @Var_MontoCred := S.MontoAutorizado
							FROM SOLICITUDCREDITO S
                            INNER JOIN CREDITOS C
							ON S.SolicitudCreditoID = C.SolicitudCreditoID
                            WHERE C.CreditoID = Par_CreditoID) AS Var_MontoCred
			WHERE Pag.CreditoID = Par_CreditoID;
	END IF;

END IF;


END TerminaStore$$