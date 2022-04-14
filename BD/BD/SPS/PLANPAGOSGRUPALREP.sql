-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLANPAGOSGRUPALREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLANPAGOSGRUPALREP`;
DELIMITER $$


CREATE PROCEDURE `PLANPAGOSGRUPALREP`(
    Par_GrupoID         INT,
    Par_TipoReporte     INT,
    
    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
    )

TerminaStore: BEGIN

-- Declaracion de Variables amortizacion
DECLARE NumInstitucion          INT;
DECLARE DireccionInstitu        VARCHAR(250);
DECLARE NombreInstitu           VARCHAR(100);
DECLARE Sucurs                  VARCHAR(50);
DECLARE Registro_Reca           VARCHAR(200);
-- --------------------------------------
-- variables datos grupo
DECLARE Var_NumInt              INT;
DECLARE Var_NomGrupo            VARCHAR(50);
DECLARE Var_SolicitudPres       INT;
DECLARE Var_Cargo               INT;
DECLARE Var_Estado              VARCHAR(50);
DECLARE Var_TipoPlan            VARCHAR(50);
DECLARE Var_TipoPrestamo        VARCHAR(50);
DECLARE Var_NumAmort            INT;
DECLARE Var_ClienteID           INT;
DECLARE Var_Promotor            VARCHAR(50);
DECLARE Var_Sucursal            VARCHAR(50); 
DECLARE Var_CicloGruAc          INT;
DECLARE Var_CicloAnt            INT;
DECLARE Var_NumCredAnt          BIGINT(12);
DECLARE Var_MontoCredAnt        DECIMAL(12,2); 

DECLARE Var_TasaAnual           DECIMAL(12,4);
DECLARE Var_TasaMens            DECIMAL(12,4);
DECLARE Var_TasaFlat            DECIMAL(12,4);
DECLARE Var_CAT                 DECIMAL(12,4);
DECLARE Var_CreditoID           BIGINT(12);
DECLARE Var_TotInteres          DECIMAL(14,2);
DECLARE Var_NumAmorti           INT;
DECLARE Var_MontoCred           DECIMAL(14,2);
DECLARE Var_SumMonCred          DECIMAL(14,2);
DECLARE Var_PorcGarLiq          DECIMAL(12,2);
DECLARE Var_MontoGarLiq         DECIMAL(14,2);
DECLARE Var_MonGarLiq           VARCHAR(20);
DECLARE Var_Plazo               VARCHAR(100);
DECLARE Var_FechaVenc           DATE;
DECLARE Var_MontoSeguro         DECIMAL(14,2);
DECLARE Var_PorcCobert          DECIMAL(12,4);
DECLARE Var_NomRepres           VARCHAR(300);
DECLARE Var_Periodo             INT;
DECLARE Var_Frecuencia          CHAR(1);
DECLARE Var_DesFrec             VARCHAR(100);
DECLARE Var_FacRiesgo           DECIMAL(12,6);
DECLARE Var_FrecSeguro          VARCHAR(100);
DECLARE Var_NumRECA             VARCHAR(200);
DECLARE Var_DiaVencimiento      VARCHAR(20);
DECLARE Var_MesVencimiento      VARCHAR(20);
DECLARE Var_AnioVencimiento     VARCHAR(20);
DECLARE Var_RepresentanteLegal  VARCHAR(200);
DECLARE Var_DirccionInstitucion VARCHAR(300);
DECLARE Var_SexoRepteLegal      CHAR(200);
DECLARE Var_TelInstitucion      VARCHAR(50);
DECLARE Var_NombreEstado        VARCHAR(100);
DECLARE Var_RFCOficial          VARCHAR(20);
DECLARE Var_DiaSistema          INT;
DECLARE Var_AnioSistema         INT;
DECLARE Var_MesSistema          VARCHAR(20);
DECLARE Var_NomCortoInstit      VARCHAR(50);
DECLARE Var_ProductoCreditoID   INT(11);

-- Variables  Alternativa 19
DECLARE Var_TipoCredito         VARCHAR(250);  -- Caracteristicas del credito
DECLARE Var_MontoCreditoLetra   VARCHAR(200);  -- Monto del credito con letra
DECLARE Var_NumeroCuenta            VARCHAR(100);
DECLARE Var_NombreBanco             VARCHAR(100);
DECLARE Var_Clabe                   VARCHAR(100);
DECLARE Var_MontoCredLetra      VARCHAR(100);
DECLARE Var_SucursalCred        INT(11);
DECLARE Var_PeriodCap           INT(11);
DECLARE Var_PeriodInt           INT(11);
DECLARE Var_FrecCapital         CHAR(1);
DECLARE Var_FrecInteres         CHAR(1);
DECLARE Var_FrecuenciaTxt       VARCHAR(30);
      


-- Declaracion de Constantes
DECLARE Esta_Activo             CHAR(1);
DECLARE Lis_Integra             INT;
DECLARE Tipo_Amortizacion       INT;
DECLARE EstCerrado              CHAR(1);
DECLARE Tipo_DatosGrupo         INT;
DECLARE Tipo_Enca               INT;

DECLARE Cadena_Vacia            CHAR(1);
DECLARE Entero_Cero             INT;
DECLARE Fecha_Vacia             DATE;
DECLARE Est_Activo              CHAR(1);
DECLARE Int_Presiden            INT;
DECLARE Tipo_DatosCred          INT;
DECLARE EstatusAutorizado       CHAR(1);
DECLARE EstatusInactivo         CHAR(1);

DECLARE Tipo_AmortSTF           INT;
DECLARE Var_NomProduc           CHAR(100);
DECLARE NoGrup                  INT;
DECLARE DirPreGru               CHAR(250);
DECLARE DirOficial              CHAR(1);
DECLARE Var_FecMinist           VARCHAR(100);

DECLARE Tab_AmortSTF            INT;
DECLARE CargoPresi              INT;

 -- Constantes Alternativa 19
DECLARE Tipo_Alternativa        INT;  -- Tipo Reporte Alternativa 19
DECLARE Tipo_EncaAlternativa    INT;    -- Tipo encabezado Alternativa 19

DECLARE FrecSemanal         CHAR(1);
DECLARE FrecCatorcenal      CHAR(1);
DECLARE FrecLibre           CHAR(1);
DECLARE FrecQuincenal       CHAR(1);
DECLARE FrecMensual         CHAR(1);
DECLARE FrecPeriodica       CHAR(1);
DECLARE FrecBimestral       CHAR(1);
DECLARE FrecTrimestral      CHAR(1);
DECLARE FrecTetramestral    CHAR(1);
DECLARE FrecSemestral       CHAR(1);
DECLARE FrecAnual           CHAR(1);
DECLARE FrecUnico           CHAR(1);
DECLARE FrecDecenal         CHAR(1);

DECLARE TxtSemanal          VARCHAR(20);
DECLARE TxtCatorcenal       VARCHAR(20);
DECLARE TxtQuincenal        VARCHAR(20);
DECLARE TxtMensual          VARCHAR(20);
DECLARE TxtPeriodica        VARCHAR(20);
DECLARE TxtBimestral        VARCHAR(20);
DECLARE TxtTrimestral       VARCHAR(20);
DECLARE TxtTetramestral     VARCHAR(20);
DECLARE TxtSemestral        VARCHAR(20);
DECLARE TxtAnual            VARCHAR(20);
DECLARE TxtDecenal          VARCHAR(20);
DECLARE TxtLibres           VARCHAR(20);
DECLARE TxtUnico        	VARCHAR(40);

-- Asignacion de Constantes
SET EstCerrado          := 'C';
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
SET EstatusInactivo		:= 'I';		-- Estatus Inactivo del Credito
SET EstatusAutorizado	:= 'A';		-- Estatus Autorizado
SET Tipo_AmortSTF       := 6 ;
SET Tab_AmortSTF        := 7;
SET DirOficial          := 'S';
SET CargoPresi          := 1;

-- Constantes Alternativa 19
SET Tipo_Alternativa    := 8;           -- Reporte Tipo Alternativa 19
SET Tipo_EncaAlternativa := 9;          -- Encabezado Alternativa 19

SET FrecSemanal         := 'S';
SET FrecCatorcenal      := 'C';   
SET FrecQuincenal       := 'Q';   
SET FrecMensual         := 'M'; 
SET FrecPeriodica       := 'P';    
SET FrecBimestral       := 'B';   
SET FrecTrimestral      := 'T';   
SET FrecTetramestral    := 'R';
SET FrecSemestral       := 'E';
SET FrecAnual           := 'A'; 
SET FrecUnico           := 'U'; 
SET FrecLibre           := 'L';
SET FrecDecenal         := 'D';

SET TxtSemanal          := 'Semanal' ; 
SET TxtCatorcenal       := 'Catorcenal' ;
SET TxtQuincenal        := 'Quincenal' ;
SET TxtMensual          := 'Mensual' ;
SET TxtPeriodica        := 'Periodica'   ;
SET TxtBimestral        := 'Bimestral' ;
SET TxtTrimestral       := 'Trimestral' ;
SET TxtTetramestral     := 'Tetramestral' ;
SET TxtSemestral        := 'Semestral';
SET TxtAnual            := 'Anual';
SET TxtDecenal          := 'Decenal';
SET TxtUnico            := 'Pago Unico';
SET TxtLibres           := 'Libres';

-- Tipo de Reporte datos de credito
IF (Par_TipoReporte = Tipo_DatosCred) THEN
-- ciclo actual del grupo
    SELECT  CicloActual INTO Var_CicloGruAc
        FROM    
                GRUPOSCREDITO G
            WHERE GrupoID = Par_GrupoID ;
        IF(Var_CicloGruAc=1)THEN

                SET Var_MontoCredAnt   := FORMAT(Entero_Cero,2);
                SET Var_NumCredAnt   := Entero_Cero;

        END IF;
        IF(Var_CicloGruAc>1) THEN

                SET Var_CicloAnt   := Var_CicloGruAc-1;
                SELECT  Cr.CreditoID INTO Var_NumCredAnt
                        FROM    
                            `HIS-INTEGRAGRUPOSCRE`  H,
                            CREDITOS Cr,
                            GRUPOSCREDITO G
                        WHERE H.GrupoID = Par_GrupoID 
                        AND H.SolicitudCreditoID = Cr.SolicitudCreditoID
                        AND H.Cargo = Int_Presiden AND H.Ciclo = Var_CicloAnt
                        AND G.GrupoID = H.GrupoID
                        AND Cr.Estatus = 'P'; -- Agregado por Aeuan_T14335

                SELECT  SUM(Cr.MontoCredito)INTO Var_MontoCredAnt
                        FROM    
                                `HIS-INTEGRAGRUPOSCRE`  H,
                                CREDITOS Cr
                            WHERE H.GrupoID = Par_GrupoID AND H.Ciclo = Var_CicloAnt
                            AND H.SolicitudCreditoID = Cr.SolicitudCreditoID;
                    
         END IF;

    SET Var_TasaAnual   := Entero_Cero;
    SET Var_TasaMens    := Entero_Cero;
    SET Var_TasaFlat    := Entero_Cero;
    SET Var_MontoSeguro := Entero_Cero;
    SET Var_PorcCobert  := Entero_Cero;
    
    SELECT 
            CASE WHEN Sol.GrupoID >0 THEN 'GRUPAL'
            ELSE CASE WHEN Sol.GrupoID <0 THEN 'INDIVIDUAL'
            END END,Sol.NumAmortizacion  INTO
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
            END END END  INTO  Var_TipoPlan
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

    SET Var_MontoSeguro     := IFNULL(Var_MontoSeguro, Entero_Cero);
    SET Var_MontoGarLiq     := ROUND(Var_SumMonCred * Var_PorcGarLiq / 100, 2);
    SET Var_MonGarLiq       := FORMAT(Var_MontoGarLiq,2);

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

    SELECT DAY(Var_FechaVenc) ,     YEAR(Var_FechaVenc) , CASE 
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

    INTO    Var_DiaVencimiento, Var_AnioVencimiento,  Var_MesVencimiento;


    SELECT Var_NumCredAnt, Var_MontoCredAnt,Var_Plazo,          Var_FechaVenc,      Var_DesFrec, Var_NumAmort, Var_TipoPrestamo, Var_TipoPlan, Var_TasaAnual,   Var_TasaMens,
            Var_TasaFlat,       Var_MontoSeguro,    Var_PorcCobert, Var_CAT,        Var_PorcGarLiq,
            Var_MonGarLiq,      Var_NomRepres,      Var_FrecSeguro, Var_NumRECA,    Var_DiaVencimiento,
            Var_AnioVencimiento,Var_MesVencimiento;

END IF;


IF (Par_TipoReporte = Tipo_DatosGrupo) THEN

    SET Var_NumInt   := Entero_Cero;
    
    SELECT Gru.NombreGrupo,COUNT(I.GrupoID) INTO Var_NomGrupo, Var_NumInt
    FROM GRUPOSCREDITO Gru
    INNER JOIN INTEGRAGRUPOSCRE AS I ON Gru.GrupoID=I.GrupoID
    WHERE Gru.GrupoID=Par_GRupoID GROUP BY Gru.GrupoID; 
    
    SET Var_NumInt   := IFNULL(Var_NumInt, Entero_Cero);

    SELECT I.SolicitudCreditoID,I.Cargo,
        CASE WHEN I.Estatus = 'A' THEN 'ACTIVO'
        ELSE CASE WHEN I.Estatus = 'A' THEN 'INACTIVO'
        END END INTO Var_SolicitudPres,Var_Cargo,Var_Estado 
    FROM GRUPOSCREDITO Gru
    INNER JOIN INTEGRAGRUPOSCRE AS I ON Gru.GrupoID=I.GrupoID AND I.Cargo=Int_Presiden
    WHERE Gru.GrupoID=Par_GrupoID;

    SELECT Var_NomGrupo, Var_NumInt,Var_SolicitudPres,Var_Cargo,Var_Estado;

END IF;

IF(Par_TipoReporte = Lis_Integra) THEN  
    SELECT  Cre. ClienteID,     Cte.NombreCompleto, Cre.MontoCredito
    FROM INTEGRAGRUPOSCRE Inte,
             CLIENTES  Cte,
             SOLICITUDCREDITO Sol,        
             CREDITOS Cre
    WHERE Inte.GrupoID  = Par_GrupoID
    AND Cre.ClienteID = Sol.ClienteID
    AND Sol.ClienteID = Inte.ClienteID
    AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID 
    AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID 
    AND Cte.ClienteID = Cre.ClienteID
    AND Inte.Estatus = Esta_Activo;

END IF;

IF(Par_TipoReporte = Tipo_Amortizacion) THEN    
    SET NumInstitucion      := (SELECT InstitucionID FROM PARAMETROSSIS);  

    SELECT  Direccion,      Nombre
            INTO    
            DireccionInstitu,   NombreInstitu
        FROM INSTITUCIONES 
        WHERE InstitucionID = NumInstitucion;

        SET Sucurs      := (SELECT S.NombreSucurs  
                                FROM USUARIOS U, SUCURSALES S 
                                WHERE UsuarioID=1 
                                AND U.SucursalUsuario= S.SucursalID);
    IF EXISTS (SELECT Estatus
                FROM CREDITOS
                    WHERE GrupoID = Par_GrupoID
                    AND Estatus in(EstatusAutorizado,EstatusInactivo))THEN
        SELECT  MIN(Amo.AmortizacionID) AS AmortizacionID,                  MIN(Amo.FechaInicio) AS FechaInicio,                    MIN(Amo.FechaVencim) AS FechaVencim,                Amo.FechaExigible,                      SUM((Amo.Capital+Amo.Interes+Amo.IVAInteres)) AS montoCuota,
                SUM(Amo.Interes) AS Interes,        SUM(Amo.IVAInteres) AS IVAinteres, SUM(Amo.Capital) AS Capital, FORMAT(SUM(Cre.MontoCredito),2) AS MontoCredito,
                MIN(Gru.NombreGrupo) AS NombreGrupo,                    MIN(Cre.TasaFija) AS TasaFija,                      MIN(Gru.CicloActual) AS CicloActual,                NombreInstitu,                          DireccionInstitu,   
                Sucurs,                             MIN(Cre.FactorMora) AS FactorMora                   
            FROM     AMORTICREDITO      Amo,
                    CREDITOS            Cre,
                    SOLICITUDCREDITO    Sol,
                    INTEGRAGRUPOSCRE    Igr,
                    GRUPOSCREDITO       Gru
                WHERE Gru.GrupoID = Igr.GrupoID
                AND Igr.GrupoID = Par_GrupoID
                AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
                AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Amo.CreditoID          = Cre.CreditoID
                AND Gru.EstatusCiclo = EstCerrado
                GROUP BY FechaExigible;
		ELSE -- si el Credito ya fue desembolsado la informacion se obtiene de la tabla PAGARECREDITO
            SELECT  MIN(Pag.AmortizacionID) AS AmortizacionID,                  MIN(Pag.FechaInicio) AS FechaInicio,                    MIN(Pag.FechaVencim) AS FechaVencim,                Pag.FechaExigible,                      SUM((Pag.Capital+Pag.Interes+Pag.IVAInteres)) AS montoCuota,
                SUM(Pag.Interes) AS Interes,        SUM(Pag.IVAInteres) AS IVAinteres,  SUM(Pag.Capital) AS Capital,        FORMAT(SUM(Cre.MontoCredito),2) AS MontoCredito,
                MIN(Gru.NombreGrupo) AS NombreGrupo,                    MIN(Cre.TasaFija) AS TasaFija,                      MIN(Gru.CicloActual) AS CicloActual,                NombreInstitu,                          DireccionInstitu,   
                Sucurs,                             MIN(Cre.FactorMora) AS FactorMora                   
            FROM     PAGARECREDITO      Pag,
                    CREDITOS            Cre,
                    SOLICITUDCREDITO    Sol,
                    INTEGRAGRUPOSCRE    Igr,
                    GRUPOSCREDITO       Gru
                WHERE Gru.GrupoID = Igr.GrupoID
                AND Igr.GrupoID = Par_GrupoID
                AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
                AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Pag.CreditoID          = Cre.CreditoID
                AND Gru.EstatusCiclo = EstCerrado
                GROUP BY FechaExigible;
        END IF;
END IF;

IF(Par_TipoReporte = Lis_Integra) THEN  
    SELECT  Cre. ClienteID,     Cte.NombreCompleto, Cre.MontoCredito
        FROM INTEGRAGRUPOSCRE Inte,
                 CLIENTES  Cte,
                 SOLICITUDCREDITO Sol,        
                 CREDITOS Cre
        WHERE Inte.GrupoID  = Par_GrupoID
        AND Cre.ClienteID = Sol.ClienteID
        AND Sol.ClienteID = Inte.ClienteID
        AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID 
        AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID 
        AND Cte.ClienteID = Cre.ClienteID
        AND Inte.Estatus = Esta_Activo;

END IF;

IF(Par_TipoReporte = Tipo_Enca) THEN    
        SELECT  Cre. ClienteID INTO  Var_ClienteID
        FROM    INTEGRAGRUPOSCRE Inte,
                CLIENTES  Cte,
                SOLICITUDCREDITO Sol,        
                CREDITOS Cre 
        WHERE   Inte.GrupoID    = Par_GrupoID
            AND Cre.ClienteID = Sol.ClienteID
            AND Sol.ClienteID = Inte.ClienteID
            AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID 
            AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID 
            AND Cte.ClienteID = Cre.ClienteID
            AND Inte.Estatus = Esta_Activo
            AND Inte.Cargo     = Int_Presiden;

        SELECT  
                P.NombrePromotor, S.NombreSucurs INTO Var_Promotor, Var_Sucursal
        FROM    CLIENTES    C,
                PROMOTORES  P,
                SUCURSALES  S               
        WHERE   C.ClienteID=Var_ClienteID 
            AND C.PromotorActual=P.PromotorID
            AND C.SucursalOrigen=S.SucursalID;


        SELECT
                Sol.CreditoID  INTO Var_CreditoID
        FROM    INTEGRAGRUPOSCRE Ing,
                SOLICITUDCREDITO Sol
        WHERE   Ing.GrupoID   = Par_GrupoID
          AND   Ing.Cargo     = Int_Presiden
          AND   Ing.Estatus   = Est_Activo
          AND   Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID;

        SELECT
                R.RegistroReca INTO Registro_Reca
        FROM    CREDITOS C
                INNER JOIN PRODUCTOSCREDITO R
        WHERE   CreditoID=Var_CreditoID
            AND C.ProductoCreditoID=R.ProducCreditoID;

    SET NumInstitucion      := (SELECT InstitucionID FROM PARAMETROSSIS);  

    SELECT  Direccion,          Nombre
    INTO    DireccionInstitu,   NombreInstitu
    FROM    INSTITUCIONES 
    WHERE   InstitucionID = NumInstitucion;


    SELECT  Var_ClienteID,  Var_Promotor,   Var_Sucursal,   Registro_Reca,  DireccionInstitu,
            NombreInstitu;

END IF;

IF (Par_TipoReporte = Tipo_AmortSTF) THEN           

    SELECT  GruCre.GrupoID,     GruCre.CicloActual,     GruCre.NombreGrupo
      INTO  NoGrup,             Var_CicloGruAc,         Var_NomGrupo    
        FROM    GRUPOSCREDITO GruCre
            WHERE GrupoID = Par_GrupoID;
    
    SELECT  FORMATEAFECHACONTRATO(Cred.FechaMinistrado),    DirCli.DireccionCompleta
      INTO  Var_FecMinist,                                  DirPreGru
        FROM    INTEGRAGRUPOSCRE    InGruCre,
                CREDITOS            Cred,
                DIRECCLIENTE        DirCli
            WHERE   InGruCre.GrupoID        =   Par_GrupoID
                AND InGruCre.Cargo          =   Int_Presiden
                AND Cred.SolicitudCreditoID =   InGruCre.SolicitudCreditoID
                AND DirCli.ClienteID        =   Cred.ClienteID
                AND DirCli.Oficial          =   DirOficial;
    
    SELECT  SUM(Cre.MontoCredito)
      INTO  Var_MontoCred
        FROM    CREDITOS Cre,INTEGRAGRUPOSCRE Inte
            WHERE   Cre.GrupoID = Par_GrupoID 
                AND Cre.SolicitudCreditoID = Inte.SolicitudCreditoID;
    
    SELECT  ProdCre.Descripcion,    Cred.ValorCAT,  ProdCre.RegistroRECA
    INTO    Var_NomProduc,          Var_CAT,        Var_NumRECA
        FROM    PRODUCTOSCREDITO    ProdCre,
                CREDITOS            Cred,
                INTEGRAGRUPOSCRE    InGruCre
            WHERE   Cred.GrupoID            =   Par_GrupoID
                AND InGruCre.Cargo          =   Int_Presiden
                AND Cred.SolicitudCreditoID =   InGruCre.SolicitudCreditoID
                AND Cred.ProductoCreditoID  =   ProdCre.ProducCreditoID
        limit 1;
    
    -- Tabla temporal para sumar el monto total del credito (Capital + Interes + IVA interes)
    DROP TABLE IF EXISTS TMPCREDITOSGRUPO;
    
    CREATE TEMPORARY TABLE TMPCREDITOSGRUPO(
        CreditoID   BIGINT,
        ClienteID   BIGINT,
        TotPagar    DECIMAL(14,2),
        INDEX(CreditoID,ClienteID)
    ); 
    
    INSERT INTO TMPCREDITOSGRUPO (
            CreditoID,      ClienteID,      TotPagar)
    SELECT  Sol.CreditoID,  Sol.ClienteID,  SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres)
        FROM    SOLICITUDCREDITO Sol,
                AMORTICREDITO   Amo,
                INTEGRAGRUPOSCRE    InGruCre
        WHERE   Sol.GrupoID             =   Par_GrupoID
            AND Sol.CicloGrupo          =   Var_CicloGruAc
            AND Amo.CreditoID           =   Sol.CreditoID
            and Sol.SolicitudCreditoID = InGruCre.SolicitudCreditoID 
        GROUP BY Sol.CreditoID, Sol.ClienteID;
        
    SELECT  SUM(TotPagar)
      INTO  Var_SumMonCred
        FROM TMPCREDITOSGRUPO;

    DROP TABLE IF EXISTS TMPCREDITOSGRUPO;
    -- Fin de la suma monto total del credito (Capital + Interes + IVA interes)
    
    SET Var_NumRECA := UPPER(Var_NumRECA);
    
	# ================== OBTENEMOS LOS DATOS PARA IMPRIMIR EN EL REPORTE ====================
    SELECT	NoGrup,			Var_CicloGruAc,		Var_FecMinist,		Var_NomGrupo,		Var_NomProduc,
            DirPreGru,      Var_MontoCred,      Var_SumMonCred,     Var_CAT,            Var_NumRECA;

END IF;

/* Tabla de amortizaciones en el plan de pago credito grupal STF*/
IF(Par_TipoReporte = Tab_AmortSTF) then
    IF EXISTS(SELECT Estatus
            FROM CREDITOS
                WHERE GrupoID = Par_GrupoID
                AND Estatus in(EstatusAutorizado,EstatusInactivo))THEN
        SELECT  MIN(Amo.AmortizacionID) AS AmortizacionID,      Amo.FechaExigible,  SUM(Amo.SaldoCapital) AS SaldoCapital,  SUM(Amo.Capital) AS Capital,    SUM(Amo.Interes) AS SaldoInteresOrd,
                SUM(Amo.IVAInteres) AS SaldoIVAInteres, 0.00    AS Comisiones,      SUM((Amo.Capital)+(Amo.Interes)+(Amo.IVAInteres)) AS PagoFijo
        FROM    AMORTICREDITO       Amo,
                CREDITOS            Cre,
                SOLICITUDCREDITO    Sol,
                INTEGRAGRUPOSCRE    Igr,
                GRUPOSCREDITO       Gru
            WHERE Gru.GrupoID = Igr.GrupoID
            AND Igr.GrupoID = Par_GrupoID
            AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
            AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
            AND Amo.CreditoID          = Cre.CreditoID
            AND Gru.EstatusCiclo = EstCerrado
            GROUP BY FechaExigible;
	ELSE  -- si el Credito ya fue desembolsado la informacion se obtiene de la tabla PAGARECREDITO
        SELECT  MIN(Pag.AmortizacionID) AS AmortizacionID,      Pag.FechaExigible,  SUM(Pag.Capital) AS SaldoCapital,   SUM(Pag.Capital) AS Capital,    SUM(Pag.Interes) AS SaldoInteresOrd,
                SUM(Pag.IVAInteres) AS SaldoIVAInteres, 0.00    AS Comisiones,      SUM((Pag.Capital)+(Pag.Interes)+(Pag.IVAInteres)) AS PagoFijo
        FROM    
                PAGARECREDITO       Pag,
                CREDITOS            Cre,
                SOLICITUDCREDITO    Sol,
                INTEGRAGRUPOSCRE    Igr,
                GRUPOSCREDITO       Gru
            WHERE Gru.GrupoID = Igr.GrupoID
            AND Igr.GrupoID = Par_GrupoID
            AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
            AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
            AND Pag.CreditoID          = Cre.CreditoID
            AND Gru.EstatusCiclo = EstCerrado
            GROUP BY FechaExigible;
    END IF;
END IF;



-- Tabla de Amortizaciones en el Plan de Pagos Grupal Alternativa 19

IF(Par_TipoReporte = Tipo_Alternativa) THEN
    SET NumInstitucion      := (SELECT InstitucionID FROM PARAMETROSSIS);

    SELECT  DirFiscal,      Nombre
            INTO    
            DireccionInstitu,   NombreInstitu
        FROM INSTITUCIONES 
        WHERE InstitucionID = NumInstitucion;

        SET Sucurs      := (SELECT S.NombreSucurs  
                                FROM USUARIOS U, SUCURSALES S 
                                WHERE UsuarioID=1 
                                AND U.SucursalUsuario= S.SucursalID);
                            
     SELECT
                Sol.CreditoID
                INTO Var_CreditoID
        FROM    INTEGRAGRUPOSCRE Ing,
                SOLICITUDCREDITO Sol
        WHERE   Ing.GrupoID   = Par_GrupoID
          AND   Ing.Cargo     = Int_Presiden
          AND   Ing.Estatus   = Est_Activo
          AND   Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID;
          

          
    IF EXISTS (SELECT Estatus
                FROM CREDITOS
                    WHERE GrupoID = Par_GrupoID
                    AND Estatus in(EstatusAutorizado,EstatusInactivo))THEN
        SELECT  MIN(Amo.AmortizacionID) AS AmortizacionID,  MIN(Amo.FechaInicio) AS FechaInicio,    DATE_FORMAT(MIN(Amo.FechaVencim),'%d-%m-%Y') AS FechaVencim,    Amo.FechaExigible,
                CONCAT('$ ',FORMAT(SUM((Amo.Capital+Amo.Interes+Amo.IVAInteres)),2)) AS montoCuota,
                CONCAT('$ ',FORMAT(SUM(Amo.Interes),2)) AS Interes,
                CONCAT('$ ',FORMAT(SUM(Amo.IVAInteres),2)) IVAinteres,
                CONCAT('$ ',FORMAT(SUM(Amo.Capital),2)) AS Capital,
                CONCAT('$ ',FORMAT(SUM(Cre.MontoCredito),2)) AS MontoCredito,
                CONVPORCANT(ROUND(SUM(Cre.MontoCredito),2), '$','peso', 'Nacional')AS Var_MontoCreditoLetra,
                MIN(Gru.NombreGrupo) AS NombreGrupo,                    MIN(Cre.TasaFija) AS TasaFija,                       MIN(Gru.CicloActual) AS CicloActual,                NombreInstitu,                          DireccionInstitu,   
                Sucurs,                             MIN(Cre.FactorMora) AS FactorMora,
                (SUM(Amo.SaldoCapital)) AS Var_MontoCred               
            FROM     AMORTICREDITO      Amo,
                    CREDITOS            Cre,
                    SOLICITUDCREDITO    Sol,
                    INTEGRAGRUPOSCRE    Igr,
                    GRUPOSCREDITO       Gru
                WHERE Gru.GrupoID = Igr.GrupoID
                AND Igr.GrupoID = Par_GrupoID
                AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
                AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Amo.CreditoID          = Cre.CreditoID
                AND Gru.EstatusCiclo = EstCerrado
                GROUP BY FechaExigible;
        ELSE -- si el Credito ya fue desembolsado la informacion se obtiene de la tabla PAGARECREDITO
        SET @Var_TotCred := 0;
        SET @Var_TotCredRest := 0;            
            
            SELECT                  
                 SUM(Pag.Capital+Pag.Interes+Pag.IVAInteres) INTO @Var_TotCred
            FROM
                    PAGARECREDITO      Pag,                
                    CREDITOS            Cre,
                    SOLICITUDCREDITO    Sol,
                    INTEGRAGRUPOSCRE    Igr,
                    GRUPOSCREDITO       Gru
                WHERE Gru.GrupoID = Igr.GrupoID
                AND Igr.GrupoID = Par_GrupoID
                AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
                AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Pag.CreditoID          = Cre.CreditoID
                AND Gru.EstatusCiclo = EstCerrado
                GROUP BY Gru.GrupoID;
                
           
        DROP TABLE IF EXISTS TmpAmortizaciones;
        
		-- tabla temporal donde inserta las amortizaciones del credito grupal
        CREATE TEMPORARY TABLE TmpAmortizaciones(
            AmortizacionID          INT(11),
            FechaInicio             VARCHAR(10),
            FechaVencim     VARCHAR(10),
            FechaExigible           VARCHAR(10),
            montoCuota              VARCHAR(50),
            Interes                 VARCHAR(50),
            IVAinteres              VARCHAR(50),
            Capital                 VARCHAR(50),
            MontoCredito            VARCHAR(50),
            Var_MontoCreditoLetra   VARCHAR(200),
            NombreGrupo             VARCHAR(200),
            TasaFija                DECIMAL(14,2),
            CicloActual             INT(11),
            FactorMora              FLOAT,  
            CapitalT                DECIMAL(14,2),
            PRIMARY KEY  (AmortizacionID));  
            
            INSERT INTO TmpAmortizaciones (AmortizacionID,  FechaInicio,    FechaVencim,    FechaExigible,  montoCuota,
                                            Interes,        IVAinteres,     Capital,            MontoCredito,   Var_MontoCreditoLetra,
                                            NombreGrupo,    TasaFija,       CicloActual,        FactorMora,     CapitalT)
            SELECT  MIN(Pag.AmortizacionID) AS AmortizacionID,  MIN(Pag.FechaInicio) AS FechaInicio,    DATE_FORMAT(MIN(Pag.FechaVencim),'%d-%m-%Y') AS FechaVencim,
                    Pag.FechaExigible, 
                    CONCAT('$ ',FORMAT(SUM((Pag.Capital+Pag.Interes+Pag.IVAInteres)),2)) AS montoCuota,
                    CONCAT('$ ',FORMAT(SUM(Pag.Interes),2)) AS Interes,
                    CONCAT('$ ', FORMAT(SUM(Pag.IVAInteres),2) ) AS IVAinteres,
                    CONCAT('$ ', FORMAT(SUM(Pag.Capital),2)) AS Capital,
                    CONCAT('$ ',FORMAT(SUM(Cre.MontoCredito),2)) AS MontoCredito,
                    CONVPORCANT(ROUND(SUM(Cre.MontoCredito),2), '$','peso', 'Nacional')AS Var_MontoCreditoLetra,
                    MIN(Gru.NombreGrupo) AS NombreGrupo,    MIN(Cre.TasaFija) AS TasaFija,  MIN(Gru.CicloActual) AS CicloActual,      MIN(Cre.FactorMora) AS FactorMora,               
                 SUM(Pag.Capital+Pag.Interes+Pag.IVAInteres) 
            FROM
                    PAGARECREDITO      Pag,                
                    CREDITOS            Cre,
                    SOLICITUDCREDITO    Sol,
                    INTEGRAGRUPOSCRE    Igr,
                    GRUPOSCREDITO       Gru
                WHERE Gru.GrupoID = Igr.GrupoID
                AND Igr.GrupoID = Par_GrupoID
                AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
                AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Pag.CreditoID          = Cre.CreditoID
                AND Gru.EstatusCiclo = EstCerrado
                GROUP BY FechaExigible;                          
   
            SELECT TmpAmortizaciones.*,@Var_TotCred := (@Var_TotCred -CapitalT) AS Var_MontoCred,
            NombreInstitu,DireccionInstitu,Sucurs FROM
            TmpAmortizaciones;
          
        END IF;
END IF;


IF(Par_TipoReporte = Tipo_EncaAlternativa) THEN
    -- Nombre del Grupo
    
    SELECT NombreGrupo INTO Var_NomGrupo
        FROM GRUPOSCREDITO
        WHERE GrupoID = Par_GrupoID;
    
 SELECT  Cre. ClienteID      
 INTO  Var_ClienteID
        FROM    INTEGRAGRUPOSCRE Inte,
                CLIENTES  Cte,
                SOLICITUDCREDITO Sol,        
                CREDITOS Cre 
        WHERE   Inte.GrupoID    = Par_GrupoID
            AND Cre.ClienteID = Sol.ClienteID
            AND Sol.ClienteID = Inte.ClienteID
            AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID 
            AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID 
            AND Cte.ClienteID = Cre.ClienteID
            AND Inte.Estatus = Esta_Activo
            AND Inte.Cargo     = Int_Presiden;

        SELECT  
                 S.NombreSucurs INTO Var_Sucursal
        FROM    CLIENTES    C,
                SUCURSALES  S               
        WHERE   C.ClienteID=Var_ClienteID 
            AND C.SucursalOrigen=S.SucursalID;


        SELECT
                Sol.CreditoID
                INTO Var_CreditoID
        FROM    INTEGRAGRUPOSCRE Ing,
                SOLICITUDCREDITO Sol
        WHERE   Ing.GrupoID   = Par_GrupoID
          AND   Ing.Cargo     = Int_Presiden
          AND   Ing.Estatus   = Est_Activo
          AND   Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID;

        SELECT IFNULL(PeriodicidadCap,Entero_Cero), IFNULL(PeriodicidadInt,Entero_Cero), 
                IFNULL(FrecuenciaCap, Cadena_Vacia), IFNULL(FrecuenciaInt, Cadena_Vacia)
        INTO Var_PeriodCap, Var_PeriodInt, Var_FrecCapital, Var_FrecInteres
        FROM CREDITOS
        WHERE CreditoID =Var_CreditoID;
        
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
           WHERE CreditoID = Var_CreditoID;
          
        
            SELECT
                R.RegistroReca, R.Caracteristicas,  C.NumAmortizacion,  Pc.Descripcion, C.PeriodicidadCap
                    
                    
        INTO Registro_Reca,     Var_TipoCredito,    Var_NumAmorti,          Var_Plazo,      Var_Periodo
        FROM    CREDITOS C
                INNER JOIN PRODUCTOSCREDITO R
                INNER JOIN CREDITOSPLAZOS Pc ON Pc.PlazoID = C.PlazoID
        WHERE   CreditoID=Var_CreditoID
            AND C.ProductoCreditoID=R.ProducCreditoID;

    SET NumInstitucion      := (SELECT InstitucionID FROM PARAMETROSSIS);  

    SELECT  DirFiscal,          Nombre
    INTO    DireccionInstitu,   NombreInstitu
    FROM    INSTITUCIONES 
    WHERE   InstitucionID = NumInstitucion;
    
    -- Datos del Banco
    SET Var_SucursalCred := (SELECT SucursalID FROM CREDITOS WHERE CreditoID = Var_CreditoID);
    
    SELECT CA.SucursalInstit, CA.NumCtaInstit, CA.CueClave
    INTO    Var_NombreBanco,    Var_NumeroCuenta,   Var_Clabe
    FROM SUCURSALES SU
    INNER JOIN CENTROCOSTOS CC ON SU.CentroCostoID = CC.CentroCostoID
    INNER JOIN CUENTASAHOTESO CA ON CC.CentroCostoID = CA.CentroCostoID
    WHERE SucursalID = Var_SucursalCred
    ORDER BY SucursalID
    LIMIT 1;

    SELECT SUM(MontoCredito) INTO Var_MontoCred
    FROM CREDITOS
    WHERE GrupoID = Par_GrupoID;
    
    SET Var_MontoCredLetra := CONVPORCANT(Var_MontoCred, '$','peso', 'Nacional');
    
    SELECT  Var_ClienteID,      Var_Sucursal,       DireccionInstitu,       NombreInstitu,      Registro_Reca, 
            Var_TipoCredito,    Var_NombreBanco,    Var_NumeroCuenta,       Var_Clabe,          Var_NomGrupo,
            Var_NumAmorti,      Var_Plazo,          Var_Periodo,            Var_MontoCred,      Var_MontoCredLetra,
            Var_FrecuenciaTxt;

END IF;


END TerminaStore$$