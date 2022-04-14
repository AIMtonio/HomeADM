-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREDGRUPALREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREDGRUPALREP`;
DELIMITER $$


CREATE PROCEDURE `PAGCREDGRUPALREP`(
    -- Reporte Pagare Grupal
    Par_GrupoID             INT,                -- Numero de Grupo
    Par_TipoRep             TINYINT UNSIGNED,   -- Tipo de Reporte
    Par_EmpresaID           INT(11),            -- Parametro de Auditoria
    Aud_Usuario             INT(11),            -- Parametro de Auditoria
    Aud_FechaActual         DATETIME,           -- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),        -- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(50),        -- Parametro de Auditoria
    Aud_Sucursal            INT(11),            -- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)          -- Parametro de Auditoria
                )

TerminaStore: BEGIN

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Fecha_Vacia             DATE;
    DECLARE Entero_Cero             INT;
    DECLARE Tip_PagareTfija         INT;
    DECLARE Tip_PagareTfijaAlternativa      INT;  -- Tipo Alternativa 19
    DECLARE Lis_Integra             INT;
    DECLARE Lis_PreSeTe             INT;
    DECLARE Tip_PTFGarant           INT;
    DECLARE EstCerrado              CHAR(1);
    DECLARE DirecOficial            CHAR(1);
    
    DECLARE Presidente              INT;
    DECLARE Secretario              INT;
    DECLARE Tesorero                INT;
    DECLARE SolAutoriza             CHAR(1); -- Solicitud del credito Autorizado
    DECLARE SolDesembolsada         CHAR(1);
    DECLARE IntActivo               CHAR(1);
    DECLARE EstatusVigente          CHAR(1);
    DECLARE EstatusAutorizado       CHAR(1);
    DECLARE EstatusInactivo         CHAR(1);
    DECLARE EsGarantiaReal          CHAR(1);
    
    DECLARE SiCobraFaltaPago        CHAR(1);
    DECLARE DiaCobComFalPago        CHAR(1);
    DECLARE ComisionMonto           CHAR(1);
    DECLARE Decimal_Cero            DECIMAL(14,2);

    -- Declaracion de Variables
    DECLARE Var_NomPres             VARCHAR(50);
    DECLARE Var_Cargo               INT;
    DECLARE Var_ClienteID           INT;  
    DECLARE Var_Direccion           VARCHAR(500);
    DECLARE Var_NomSec              VARCHAR(50);
    DECLARE Var_CargoSec            INT;
    DECLARE Var_ClienteIDSec        INT;  
    DECLARE Var_DireccionSec        VARCHAR(500);
    DECLARE Var_NomTes              VARCHAR(50);
    DECLARE Var_CargoTes            INT;
    
    DECLARE Var_ClienteIDTes        INT;  
    DECLARE Var_DireccionTes        VARCHAR(500);
    DECLARE Var_NombreEstadom       VARCHAR(50);
    DECLARE Var_NombreMuni          VARCHAR(50);
    DECLARE Var_DirecSuc            VARCHAR(400); 
    DECLARE Var_DescProCre          VARCHAR(200);
    DECLARE NomGrupo                VARCHAR(50);
    DECLARE NumInstitucion          INT;
    DECLARE DireccionInstitu        VARCHAR(250);
    DECLARE NombreInstitu           VARCHAR(100);
    DECLARE MontoCred               DECIMAL(12,2);
    DECLARE Var_PlazoCredito        VARCHAR(100);
    
    DECLARE FechaActSis             VARCHAR(200);
    DECLARE FechaInicCred           DATE;
    DECLARE FechaVencCred           DATE;
    DECLARE Var_FechaMinis          DATE;
    DECLARE TasaVariable            INT;
    DECLARE NombreTasa              VARCHAR(100);
    DECLARE IDCliente               INT(11);
    DECLARE NombreCliente           VARCHAR(200);
    DECLARE FormulaTasa             VARCHAR(100);
    DECLARE DireccionClient         VARCHAR(500);
    
    DECLARE FrecuencInt             CHAR(1);
    DECLARE PisTasa                 FLOAT;
    DECLARE TechTasa                FLOAT;
    DECLARE Puntos                  FLOAT;
    DECLARE fechaPTF                DATE;
    DECLARE Var_FechaVencimi        DATE;
    DECLARE Sucurs                  VARCHAR(50);
    DECLARE FactorM                 FLOAT;
    DECLARE FechaMinis              DATE;
    DECLARE DireccionCte            VARCHAR(500);
    
    DECLARE Var_EstatusCredito      CHAR(1);
    DECLARE Var_TasaMoraAnual       DECIMAL(12,4);
    
    /* datos para obtener obligado solidario de mas alternativa*/
    DECLARE ObSol_ClienteID         INT(11);
    DECLARE ObSol_Nombre            VARCHAR(200);
    DECLARE ObSol_Direcc            VARCHAR(300);
    DECLARE Cadena_Default          VARCHAR(100);
    DECLARE FechaIniGpo             DATE;
    DECLARE VQ_Garantia             INT;
    DECLARE VQ_TipoDocu             INT;

    -- Inicia declaracion FEMAZA
    DECLARE Var_CreditoID           BIGINT(12);
    DECLARE Var_ProductoCredito     INT;
    DECLARE Var_TotalCredito        DECIMAL(12,2); -- Monto del CrÃ©dito
    DECLARE Var_MontoComision       DECIMAL(12,4);
    DECLARE Var_CobraFaltaPago      CHAR(1);
    DECLARE Var_CriterioComFalPago  CHAR(1);
    DECLARE Var_TipCobComFalPago    CHAR(1);
    DECLARE Var_PerCobComFalPago    CHAR(1);
    DECLARE Var_TxtComision         VARCHAR(200);
    DECLARE Var_TipoComision        CHAR(1);
    -- Fin declaracion FEMAZA

    -- Declaracion Alternativa 19
    DECLARE Var_NumeroCuenta            VARCHAR(100);
    DECLARE Var_NombreBanco             VARCHAR(100);
    DECLARE Var_Clabe                   VARCHAR(100);
    DECLARE Var_ComGastosCobranza       DECIMAL(10,2);
    DECLARE Var_ComGastosCobranzaTxt    VARCHAR(100);
    DECLARE Var_FechaMinisTxt           VARCHAR(100);
    DECLARE Var_SucursalCred            INT(11);
    DECLARE Var_NumAmortizacion         INT(11);
    DECLARE Var_NumAmortInteres         INT(11); 
    DECLARE NumCuota                    INT(11);
    DECLARE Consecutivo                 INT(11);
    DECLARE Lis_IntegraConsol           INT(11);
    DECLARE Var_NombreCompleto_2        VARCHAR(500);
    DECLARE Var_DireccionCompleto_2     VARCHAR(500);
    DECLARE var_NumIntegrante           INT(11);
    DECLARE Contador                    INT(11);
    DECLARE ContaIntegra                INT(11);
    -- Asignacion de Constantes
    SET Presidente          :=1;        -- Presidente
    SET Secretario          :=3;        -- Secretario
    SET Tesorero            :=2;        -- Tesorero
    SET Cadena_Vacia        := '';      -- Cadena vacia
    SET Fecha_Vacia         := '1900-01-01';    -- Fecha vacia
    SET Entero_Cero         := 0;       -- Entero cero
    SET Tip_PagareTfija     := 1;       -- Pagare Tasa Fija
    SET Lis_Integra         := 2;       -- Lista integrantes de Grupo
    SET Lis_PreSeTe         := 3;       -- Lista Presidente, Secretario y Tesorero del grupo
    SET Tip_PTFGarant       := 4;       -- Pagare Tasa Fija Garantia
    SET Lis_IntegraConsol   := 6; -- Validar que este valor no este ocupado para otro cliente

    SET Tip_PagareTfijaAlternativa  := 5;       -- Tipo Pagare Alternativa 19
    SET EstCerrado          := 'C';     -- Estatus Cerrado
    SET DirecOficial        := 'S';     -- Direccion Oficial
    SET SolAutoriza         := 'A';     -- Solicitud de Credito Autorizado
    SET SolDesembolsada     := 'D';     -- Solicitud Desembolsada
    SET IntActivo           := 'A';     -- Integrante del Grupo Activo
    SET EstatusVigente      :='V';      -- Estatus Vigente del credito
    SET EstatusAutorizado   :='A';      -- Estatus Autorizado
    SET EstatusInactivo     :='I';      -- Estatus Inactivo
    SET Cadena_Default      := 'NO APLICA'; -- cadena DEFAULT para mas alternativa

    SET VQ_Garantia         := 3;       -- Garantia 
    SET VQ_TipoDocu         := 13;      -- Tipo de Documento
    SET EsGarantiaReal      := 'S';     -- Garantia REAL: SI
    SET SiCobraFaltaPago    := 'S';     -- Cobra Falta de Pago: SI
    SET DiaCobComFalPago    := 'D';     -- Dia Comision Falta de Pago
    SET ComisionMonto       := 'M';     -- Monto Comision
    SET Var_TxtComision     := '';      -- Descripcion Monto Comision
    SET Decimal_Cero        := 0.0;         -- DECIMAL Cero

    -- Query para reporte de pagare tasa fija de credito Grupal
    IF(Par_TipoRep = Tip_PagareTfija) THEN


  SELECT        Edo.Nombre,         Mun.Nombre,             Suc.DirecCompleta
            INTO    Var_NombreEstadom , Var_NombreMuni ,    Var_DirecSuc 
    FROM INTEGRAGRUPOSCRE  Igr
         inner join CREDITOS Cre on Igr.SolicitudCreditoID = Cre.SolicitudCreditoID
         inner join SUCURSALES Suc on Cre.SucursalID = Suc.SucursalID
         inner join ESTADOSREPUB  Edo on Suc.EstadoID =Edo.EstadoID
         inner join MUNICIPIOSREPUB Mun ON Mun.EstadoID=Edo.EstadoID AND Mun.MunicipioID = Suc.MunicipioID  
    WHERE Igr. GrupoID = Par_GrupoID limit 1;

        SELECT  InstitucionID,  FORMATEAFECHACONTRATO(FechaSistema)
        INTO  NumInstitucion, FechaActSis
        FROM  PARAMETROSSIS 
        LIMIT 1;

        SELECT  Direccion,      Nombre
        INTO  DireccionInstitu, NombreInstitu
        FROM INSTITUCIONES 
        WHERE InstitucionID = NumInstitucion;
        
        SELECT  Cre.FechaVencimien, Cre.FechaMinistrado, Cre.CreditoID, Cre.ProductoCreditoID, Cre.MontoCredito 
        INTO Var_FechaVencimi,Var_FechaMinis, Var_CreditoID, Var_ProductoCredito, Var_TotalCredito                            -- modificado para llenar variables FEMAZA
            
          FROM  CREDITOS      Cre,
            SOLICITUDCREDITO  Sol,
            INTEGRAGRUPOSCRE  Igr,
            GRUPOSCREDITO   Gru
          WHERE Gru.GrupoID = Igr.GrupoID
          AND Igr.GrupoID = Par_GrupoID AND Igr.Cargo=Presidente
          AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
          AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Gru.EstatusCiclo = EstCerrado;
          SELECT cp.Descripcion
            INTO Var_PlazoCredito
          FROM  CREDITOS cr
          INNER JOIN PRODUCTOSCREDITO  pc  ON pc.ProducCreditoID = cr.ProductoCreditoID
          INNER JOIN CREDITOSPLAZOS    cp  ON cr.PlazoID     = cp.PlazoID
          AND CreditoID = Var_CreditoID;



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
      SELECT prod.ProducCreditoID, prod.CobraFaltaPago, prod.CriterioComFalPag, prod.TipCobComFalPago, prod.PerCobComFalPag,
                NumAmortizacion,NumAmortInteres 
      INTO Var_ProductoCredito, Var_CobraFaltaPago, Var_CriterioComFalPago, Var_TipCobComFalPago, Var_PerCobComFalPago,
            Var_NumAmortizacion,Var_NumAmortInteres 
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
        IF (Var_NumAmortizacion < Var_NumAmortInteres) THEN
                SET NumCuota =Var_NumAmortInteres;
            ELSE
                SET NumCuota =Var_NumAmortizacion;
        END IF;

      IF EXISTS(SELECT Estatus
            FROM CREDITOS
              WHERE GrupoID = Par_GrupoID
              AND Estatus IN(EstatusAutorizado,EstatusInactivo))THEN

        SELECT  Amo.AmortizacionID,             Amo.FechaInicio,                    Var_FechaVencimi,               Var_FechaMinis, Amo.FechaExigible ,  SUM((Amo.Capital+Amo.Interes+Amo.IVAInteres)) AS montoCuota,
                SUM(Amo.Interes) AS Interes,    SUM(Amo.IVAInteres) AS IVAinteres,  SUM(Amo.Capital) AS Capital,    FORMAT(SUM(Cre.MontoCredito),2) AS MontoCredito,
                MAX(Gru.NombreGrupo),                Var_PlazoCredito,                   MAX(Cre.TasaFija) AS TasaFija,  MAX(Gru.CicloActual),                                                    NombreInstitu, 
                replace(DireccionInstitu,'CENTRO.','CENTRO,') as DireccionInstitu, 
                Sucurs, Var_DirecSuc,          MAX( Cre.FactorMora) AS FactorMora  , Var_NombreEstadom,Var_NombreMuni,FORMAT((pow(10,2)*(MAX(Cre.TasaFija)/12)+0.5)/pow(10,2),2) AS Formula,Format(MAX(Cre.FactorMora)*((pow(10,2)*(MAX(Cre.TasaFija)/12)+0.5)/pow(10,2)),2)AS FactorM,
                IFNULL(MAX(pc.Descripcion), 'NO APLICA') AS Var_DescProCre,
                upper(CONVPORCANT(SUM(Cre.MontoCredito),'$','PESO','N.')) AS Montocletra,
                CONVPORCANT(MAX(Cre.TasaFija),'%','2','') AS TasaOrdinariaAnual,
                replace(CONVPORCANT(ROUND(MAX(Cre.TasaFija) /12 , 2),'%','2',''),'por ciento','') as TasaOrdinariaMensual,
                ObSol_Nombre,
                ObSol_Direcc,
                FechaActSis,CONVPORCANT(ROUND(Var_TasaMoraAnual,4),'%','4','') AS VarTasaFija,
                LOWER(FechaActSis) AS FechaActual,
                Var_TxtComision AS TxtComision, MAX(Gru.GrupoID) as VarGrupoID,
                lower(concat(right(Amo.FechaInicio,2),' (',FUNCIONSOLONUMLETRAS(day(Amo.FechaInicio)),') de ',FUNCIONMESNOMBRE(Amo.FechaInicio),' del ',
                year(Amo.FechaInicio),' (',FUNCIONSOLONUMLETRAS(year(Amo.FechaInicio)),')')) as FechaEnLetras,
                lower(concat(right(Var_FechaVencimi,2),' (',SUBSTRING(FUNCIONSOLONUMLETRAS(day(Var_FechaVencimi)), 1, length(FUNCIONSOLONUMLETRAS(day(Var_FechaVencimi)))-1),') de ',FUNCIONMESNOMBRE(Var_FechaVencimi),' del ',
                year(Var_FechaVencimi),' (',SUBSTRING(FUNCIONSOLONUMLETRAS(year(Var_FechaVencimi)), 1, length(FUNCIONSOLONUMLETRAS(year(Var_FechaVencimi)))-1),')')) as FechaEnLetrasVen,   NumCuota
          FROM   AMORTICREDITO    Amo
               inner join CREDITOS      Cre on Amo.CreditoID      = Cre.CreditoID
              inner join INTEGRAGRUPOSCRE  Igr on Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
              inner join SOLICITUDCREDITO  Sol on Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
              inner join GRUPOSCREDITO   Gru on Gru.GrupoID = Igr.GrupoID
              LEFT OUTER JOIN PRODUCTOSCREDITO pc ON pc.ProducCreditoID = Cre.ProductoCreditoID
            WHERE  Igr.GrupoID = Par_GrupoID
                AND Gru.EstatusCiclo = EstCerrado
            GROUP BY FechaExigible,Amo.AmortizacionID,Amo.FechaInicio;
      ELSE -- si el credito ya esta vigente para imprimir el pagare se tomaran los datos de PAGARECREDITO.
        SELECT  Pag.AmortizacionID,       Pag.FechaInicio,          Var_FechaVencimi,       Var_FechaMinis,Pag.FechaExigible,      SUM((Pag.Capital+Pag.Interes+Pag.IVAInteres)) AS montoCuota,
                SUM(Pag.Interes)AS Interes, SUM(Pag.IVAInteres) AS IVAinteres,  SUM(Pag.Capital) AS Capital,  FORMAT(SUM(Cre.MontoCredito),2) AS MontoCredito,
            MAX(Gru.NombreGrupo),  Var_PlazoCredito,      MAX(Cre.TasaFija) AS TasaFija,           MAX(Gru.CicloActual),        NombreInstitu,      replace(DireccionInstitu,'CENTRO.','CENTRO,') as DireccionInstitu, 
            Sucurs, CONCAT(ifnull(Var_NombreMuni,Cadena_Vacia),", ",ifnull(Var_NombreEstadom,Cadena_Vacia)) as Var_DirecSuc,             MAX(Cre.FactorMora) AS FactorMora,            Var_NombreEstadom,       Var_NombreMuni, FORMAT((pow(10,2)*(MAX(Cre.TasaFija)/12)+0.5)/pow(10,2),2) AS Formula,Format(MAX(Cre.FactorMora)*((pow(10,2)*(MAX(Cre.TasaFija)/12)+0.5)/pow(10,2)),2)AS FactorM,
            IFNULL(MAX(pc.Descripcion), 'NO APLICA') AS Var_DescProCre,
            UPPER(CONVPORCANT(SUM(Cre.MontoCredito),'$','PESO','N.')) AS Montocletra,
            CONVPORCANT(MAX(Cre.TasaFija),'%','2','') AS TasaOrdinariaAnual,
            REPLACE(CONCAT(SUBSTRING(CONVPORCANT(ROUND(MAX(Cre.TasaFija) /12 , 2),'%','2',''), 1, POSITION('(' IN CONVPORCANT(ROUND(MAX(Cre.TasaFija) /12 , 2),'%','2',''))),SUBSTRING(CONVPORCANT(ROUND(MAX(Cre.TasaFija) /12 , 2),'%','2',''), POSITION('(' IN CONVPORCANT(ROUND(MAX(Cre.TasaFija) /12 , 2),'%','2',''))+1,1),
                LOWER(SUBSTRING(CONVPORCANT(ROUND(MAX(Cre.TasaFija) /12 , 2),'%','2',''), POSITION('(' IN CONVPORCANT(ROUND(MAX(Cre.TasaFija) /12 , 2),'%','2',''))+2, POSITION(')' IN CONVPORCANT(ROUND(MAX(Cre.TasaFija) /12 , 2),'%','2',''))))),' por ciento','') as TasaOrdinariaMensual,
                ObSol_Nombre,
                ObSol_Direcc,
                FechaActSis,CONVPORCANT(ROUND(Var_TasaMoraAnual,4),'%','4','') AS VarTasaFija,
                LOWER(FechaActSis) AS FechaActual,
            Var_TxtComision AS TxtComision, MAX(Gru.GrupoID) as VarGrupoID,            
            CONCAT(right(Pag.FechaInicio,2),' (',FNLETRACAPITAL(SUBSTRING(FUNCIONSOLONUMLETRAS(day(Pag.FechaInicio)), 1, length(FUNCIONSOLONUMLETRAS(day(Pag.FechaInicio)))-1)),') de ',FUNCIONMESNOMBRE(Pag.FechaInicio),' del ',
                year(Pag.FechaInicio),' (',UPPER(SUBSTRING(FUNCIONSOLONUMLETRAS(year(Pag.FechaInicio)),1,1)),LOWER(SUBSTRING(FUNCIONSOLONUMLETRAS(year(Pag.FechaInicio)), 2, length(FUNCIONSOLONUMLETRAS(year(Pag.FechaInicio)))-2)),')') as FechaEnLetras,

            CONCAT(right(Var_FechaVencimi,2),' (',FNLETRACAPITAL(SUBSTRING(FUNCIONSOLONUMLETRAS(day(Var_FechaVencimi)), 1, length(FUNCIONSOLONUMLETRAS(day(Var_FechaVencimi)))-1)),') de ',FUNCIONMESNOMBRE(Var_FechaVencimi),' del ',
                year(Var_FechaVencimi),' (',UPPER(SUBSTRING(FUNCIONSOLONUMLETRAS(year(Var_FechaVencimi)),1,1)),LOWER(SUBSTRING(FUNCIONSOLONUMLETRAS(year(Var_FechaVencimi)), 2, length(FUNCIONSOLONUMLETRAS(year(Var_FechaVencimi)))-2)),')') 

            as FechaEnLetrasVen,     NumCuota
        FROM   PAGARECREDITO    Pag
            inner join CREDITOS Cre on Pag.CreditoID      = Cre.CreditoID
            inner join INTEGRAGRUPOSCRE  Igr on Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
            inner join SOLICITUDCREDITO  Sol on Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
            inner join GRUPOSCREDITO   Gru on  Gru.GrupoID = Igr.GrupoID
            LEFT OUTER JOIN PRODUCTOSCREDITO pc ON pc.ProducCreditoID = Cre.ProductoCreditoID
          WHERE Igr.GrupoID = Par_GrupoID  AND Gru.EstatusCiclo = EstCerrado
          GROUP BY FechaExigible,Pag.AmortizacionID, Pag.FechaInicio;          
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
          WHERE Gru.GrupoID = Igr.GrupoID         AND Igr.GrupoID = Par_GrupoID
          AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID         AND   Gru.EstatusCiclo = EstCerrado
          AND    Sol.ClienteID= Cli.ClienteID         AND    Cli.ClienteID= Dir.ClienteID         AND    Dir.Oficial = DirecOficial
          AND    (Sol.Estatus= SolAutoriza OR Sol.Estatus= SolDesembolsada)
          AND    Igr.Estatus= IntActivo;

    END IF;

    -- Query para obtener avales de pagare tasa fija de credito Grupal
    IF(Par_TipoRep = Lis_PreSeTe) THEN
          SELECT  Gru.NombreGrupo, Cli.NombreCompleto,  Igr.Cargo, Cli.ClienteID, Dir.DireccionCompleta 
          INTO NomGrupo, Var_NomPres, Var_Cargo,Var_ClienteID,Var_Direccion
        FROM  
            SOLICITUDCREDITO  Sol,
            INTEGRAGRUPOSCRE  Igr,
            GRUPOSCREDITO   Gru,
            CLIENTES Cli,
            DIRECCLIENTE Dir
          WHERE Gru.GrupoID = Igr.GrupoID
          AND Igr.GrupoID = Par_GrupoID AND Igr.Cargo = Presidente
          AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Gru.EstatusCiclo = EstCerrado
          AND    Sol.ClienteID= Cli.ClienteID
          AND    Cli.ClienteID= Dir.ClienteID
          AND    Dir.Oficial = DirecOficial   
          AND    (Sol.Estatus= SolAutoriza OR Sol.Estatus= SolDesembolsada)
          AND    Igr.Estatus= IntActivo;
          
     
        -- Secretario     
      SELECT  Cli.NombreCompleto, Igr.Cargo, Cli.ClienteID, Dir.DireccionCompleta 
          INTO Var_NomSec, Var_CargoSec,Var_ClienteIDSec,Var_DireccionSec
        FROM  
            SOLICITUDCREDITO  Sol,
            INTEGRAGRUPOSCRE  Igr,
            GRUPOSCREDITO   Gru,
            CLIENTES Cli,
            DIRECCLIENTE Dir
          WHERE Gru.GrupoID = Igr.GrupoID
          AND Igr.GrupoID = Par_GrupoID AND Igr.Cargo = Secretario
          AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Gru.EstatusCiclo = EstCerrado
          AND    Sol.ClienteID= Cli.ClienteID
          AND    Cli.ClienteID= Dir.ClienteID
          AND    Dir.Oficial = DirecOficial
          AND    (Sol.Estatus= SolAutoriza OR Sol.Estatus= SolDesembolsada)
          AND    Igr.Estatus= IntActivo;

        -- Tesorero
          SELECT  Cli.NombreCompleto, Igr.Cargo, Cli.ClienteID, Dir.DireccionCompleta 
          INTO Var_NomTes, Var_CargoTes,Var_ClienteIDTes,Var_DireccionTes
        FROM  
            SOLICITUDCREDITO  Sol,
            INTEGRAGRUPOSCRE  Igr,
            GRUPOSCREDITO   Gru,
            CLIENTES Cli,
            DIRECCLIENTE Dir
          WHERE Gru.GrupoID = Igr.GrupoID
          AND Igr.GrupoID = Par_GrupoID AND Igr.Cargo = Tesorero
          AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Gru.EstatusCiclo = EstCerrado
          AND    Sol.ClienteID= Cli.ClienteID
          AND    Cli.ClienteID= Dir.ClienteID
          AND    Dir.Oficial = DirecOficial
          AND    (Sol.Estatus= SolAutoriza OR Sol.Estatus= SolDesembolsada)
          AND    Igr.Estatus= IntActivo;

           SELECT NomGrupo, Var_NomPres, Var_Cargo,Var_ClienteID,Var_Direccion,Var_NomSec, Var_CargoSec,Var_ClienteIDSec,Var_DireccionSec,Var_NomTes, Var_CargoTes,Var_ClienteIDTes,Var_DireccionTes;

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

    -- Query para reporte de pagare tasa fija de credito Grupal
    IF(Par_TipoRep = Tip_PagareTfijaAlternativa) THEN

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

        SELECT  DirFiscal,      Nombre
        INTO  DireccionInstitu, NombreInstitu
        FROM INSTITUCIONES 
        WHERE InstitucionID = NumInstitucion;    
      
        SELECT  Cre.FechaVencimien, Cre.FechaMinistrado, Cre.CreditoID, Cre.ProductoCreditoID, Cre.MontoCredito 
        INTO Var_FechaVencimi,Var_FechaMinis, Var_CreditoID, Var_ProductoCredito, Var_TotalCredito                            -- modificado para llenar variables FEMAZA
            
          FROM  CREDITOS      Cre,
            SOLICITUDCREDITO  Sol,
            INTEGRAGRUPOSCRE  Igr,
            GRUPOSCREDITO   Gru
          WHERE Gru.GrupoID = Igr.GrupoID
          AND Igr.GrupoID = Par_GrupoID AND Igr.Cargo=Presidente
          AND Cre.SolicitudCreditoID = Igr.SolicitudCreditoID
          AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID
          AND Gru.EstatusCiclo = EstCerrado;

        SET Var_FechaMinisTxt :=  FORMATEAFECHACONTRATO(Var_FechaMinis);
        SET Sucurs    := (SELECT S.NombreSucurs  
                    FROM USUARIOS U, SUCURSALES S 
                    WHERE UsuarioID=1 
                    AND U.SucursalUsuario= S.SucursalID);
                    
       SET Var_SucursalCred := (SELECT SucursalID FROM CREDITOS WHERE CreditoID = Var_CreditoID);              
        -- Datos del Banco 
        SELECT CA.SucursalInstit, CA.NumCtaInstit, CA.CueClave
        INTO    Var_NombreBanco,    Var_NumeroCuenta,   Var_Clabe
        FROM SUCURSALES SU
        INNER JOIN CENTROCOSTOS CC ON SU.CentroCostoID = CC.CentroCostoID
        INNER JOIN CUENTASAHOTESO CA ON CC.CentroCostoID = CA.CentroCostoID
        WHERE SucursalID = Var_SucursalCred
        ORDER BY SucursalID
        LIMIT 1;
    /* busqueda de obligado solidario por garantia REAL */

        SELECT  cl.ClienteID,       NombreCompleto
          INTO    ObSol_ClienteID,  ObSol_Nombre
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

      SELECT prod.ProducCreditoID, prod.CobraFaltaPago, prod.CriterioComFalPag, prod.TipCobComFalPago, prod.PerCobComFalPag
      INTO Var_ProductoCredito, Var_CobraFaltaPago, Var_CriterioComFalPago, Var_TipCobComFalPago, Var_PerCobComFalPago
      FROM PRODUCTOSCREDITO AS prod, CREDITOS cr
      WHERE prod.ProducCreditoID=cr.ProductoCreditoID
        AND cr.CreditoID = Var_CreditoID;
      
      -- Generación de cadena para Comsion por pago tardio.
      IF (Var_CobraFaltaPago = SiCobraFaltaPago) THEN
        
        SET Var_TxtComision := 'De no pagarse en las fechas establecidas causara ademas un cargo por concepto de comision por pago tardio de ';
        
        SELECT  COM.TipoComision, COM.Comision
        INTO Var_TipoComision, Var_MontoComision
                FROM ESQUEMACOMISCRE AS COM 
                INNER JOIN CREDITOS AS CRE ON CRE.ProductoCreditoID = COM.ProducCreditoID
        WHERE Var_TotalCredito BETWEEN COM.MontoInicial AND COM.MontoFinal AND CRE.ProductoCreditoID = Var_ProductoCredito AND CRE.CreditoID = Var_CreditoID;
         
        IF (Var_TipoComision = ComisionMonto) THEN
          SET Var_TxtComision := CONCAT(Var_TxtComision, '$ ', CAST(FORMAT(Var_MontoComision,2) AS CHAR), ' (', TRIM(FUNCIONNUMLETRAS(Var_MontoComision)), ')');
        ELSE
          SET Var_TxtComision := CONCAT(Var_TxtComision, CAST(Var_MontoComision AS CHAR), ' % (', FUNCIONNUMEROSLETRAS(Var_MontoComision), ' Porciento)');
        END IF;
        
        IF (Var_PerCobComFalPago = DiaCobComFalPago) THEN
          SET Var_TxtComision := CONCAT(Var_TxtComision, '. Por cada dia de atraso');
        ELSE
          SET Var_TxtComision := CONCAT(Var_TxtComision, '. Por incumplimiento');
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

      SELECT  IF(Cre.TipCobComMorato = 'N',(Cre.TasaFija*Cre.FactorMora)/100 ,Cre.FactorMora )
          INTO Var_TasaMoraAnual
        FROM PRODUCTOSCREDITO PRO, CREDITOS     Cre
          WHERE Cre.CreditoID = Var_CreditoID
            AND Cre.ProductoCreditoID=PRO.ProducCreditoID;

        SET Var_ComGastosCobranza       := Decimal_Cero;   
        SET Var_ComGastosCobranzaTxt    := CONVPORCANT(Var_ComGastosCobranza, '$','peso', 'Nacional');
        SET Var_ComGastosCobranzaTxt    := IFNULL(Var_ComGastosCobranzaTxt,Entero_Cero); 
      IF EXISTS(SELECT Estatus
            FROM CREDITOS
              WHERE GrupoID = Par_GrupoID
              AND Estatus IN(EstatusAutorizado,EstatusInactivo))THEN

        SELECT  Amo.AmortizacionID,         Amo.FechaInicio,      Var_FechaVencimi,Var_FechaMinis,    Amo.FechaExigible,            SUM((Amo.Capital+Amo.Interes+Amo.IVAInteres)) AS montoCuota,
            SUM(Amo.Interes) AS Interes,    SUM(Amo.IVAInteres) AS IVAinteres,  SUM(Amo.Capital) AS Capital,  FORMAT(SUM(Cre.MontoCredito),2) AS MontoCredito,
                MAX(Gru.NombreGrupo),                Cre.TasaFija,          MAX(Gru.CicloActual),     NombreInstitu,      DireccionInstitu,           Sucurs,
                Cre.FactorMora,                 Var_NombreEstadom,      Var_NombreMuni,     FORMAT((pow(10,2)*(Cre.TasaFija/12)+0.5)/pow(10,2),2) AS Formula,       
                Format(Cre.FactorMora*((pow(10,2)*(Cre.TasaFija/12)+0.5)/pow(10,2)),2)AS FactorM,
                IFNULL(pc.Descripcion, 'NO APLICA') AS Var_DescProCre,  
                pc.Caracteristicas,
                des.Descripcion,    pc.RegistroRECA,    Var_NumeroCuenta,           Var_NombreBanco,
                Var_Clabe,                      Var_ComGastosCobranzaTxt,CONVPORCANT(SUM(Cre.MontoCredito),'$','Peso','Nacional') AS Montocletra,
            CONVPORCANT(Cre.TasaFija,'%','2','') AS TasaOrdinariaAnual,
            CONVPORCANT(ROUND(Cre.TasaFija /12 , 2),'%','2','') TasaOrdinariaMensual,
            ObSol_Nombre,
            ObSol_Direcc,
            FechaActSis,CONVPORCANT(ROUND(Var_TasaMoraAnual,4),'%','4','') AS VarTasaFija,
            Var_FechaMinisTxt,
            CONCAT('$ ',FORMAT(SUM((Amo.Capital+Amo.Interes+Amo.IVAInteres)),2)) AS MontoCuotaInd,        
            FNDECIMALALETRA(Cre.FactorMora,1) AS FactorMoraLetra
          FROM   AMORTICREDITO    Amo,
              CREDITOS      Cre 
              LEFT OUTER JOIN PRODUCTOSCREDITO pc ON pc.ProducCreditoID = Cre.ProductoCreditoID
              LEFT OUTER JOIN DESTINOSCREDITO des ON des.DestinoCreID = Cre.DestinoCreID,
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
        SELECT  MAX(Pag.AmortizacionID) AS AmortizacionID,       MAX(Pag.FechaInicio) AS FechaInicio,          Var_FechaVencimi,       Var_FechaMinis,     Pag.FechaExigible,      SUM((Pag.Capital+Pag.Interes+Pag.IVAInteres)) AS montoCuota,
            SUM(Pag.Interes)AS Interes, SUM(Pag.IVAInteres) AS IVAinteres,  SUM(Pag.Capital) AS Capital,  FORMAT(SUM(Cre.MontoCredito),2) AS MontoCredito,
            MAX(Gru.NombreGrupo),        MAX(Cre.TasaFija) AS TasaFija,           MAX(Gru.CicloActual),        NombreInstitu,      DireccionInstitu, 
          Sucurs,               MAX(Cre.FactorMora) AS FactorMora,            Var_NombreEstadom,       Var_NombreMuni, FORMAT((pow(10,2)*(MAX(Cre.TasaFija)/12)+0.5)/pow(10,2),2) AS Formula,Format(MAX(Cre.FactorMora)*((pow(10,2)*(MAX(Cre.TasaFija)/12)+0.5)/pow(10,2)),2)AS FactorM,
            IFNULL(MAX(pc.Descripcion), 'NO APLICA') AS Var_DescProCre,
            MAX(des.Descripcion) AS Descripcion,
            MAX(pc.Caracteristicas) AS Caracteristicas,
            MAX(pc.RegistroRECA) AS RegistroRECA,
            Var_NumeroCuenta,
            Var_NombreBanco,
            Var_Clabe,
            Var_ComGastosCobranzaTxt,
            MAX(pc.RegistroRECA) AS RegistroRECA,
            CONVPORCANT(SUM(Cre.MontoCredito),'$','Peso','Nacional') AS Montocletra,
            CONVPORCANT(MAX(Cre.TasaFija),'%','2','') AS TasaOrdinariaAnual,
            CONVPORCANT(ROUND(MAX(Cre.TasaFija) /12 , 2),'%','2','') TasaOrdinariaMensual,
            ObSol_Nombre,
            ObSol_Direcc,
            FechaActSis,CONVPORCANT(ROUND(Var_TasaMoraAnual,4),'%','4','') AS VarTasaFija,
            Var_FechaMinisTxt,
            CONCAT('$ ',FORMAT((SUM((Pag.Capital+Pag.Interes+Pag.IVAInteres))),2)) AS MontoCuotaInd,
            CONVPORCANT(MAX(Cre.FactorMora), 'D', 1, '') AS FactorMoraLetra
        FROM   PAGARECREDITO    Pag,
            CREDITOS      Cre 
            LEFT OUTER JOIN PRODUCTOSCREDITO pc ON pc.ProducCreditoID = Cre.ProductoCreditoID
            LEFT OUTER JOIN DESTINOSCREDITO des ON des.DestinoCreID = Cre.DestinoCreID,
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

IF(Par_TipoRep = Lis_IntegraConsol) THEN     
        set @Consecutivo:=0;
        drop table if exists IntegrantesConsol;
        create table IntegrantesConsol(
        Numero int(11),
        NombreCompleto varchar(500),
        ClienteID       int(11),
        DireccionCompleta Varchar(500),
        NombreCompleto_2 varchar(500),
        DireccionCompleta_2 Varchar(500),
        primary key(Numero)
        );
        insert into IntegrantesConsol
          SELECT  (@Consecutivo:=(@Consecutivo +1)) AS Numero, Cli.NombreCompleto, Cli.ClienteID, Dir.DireccionCompleta,'',''
        FROM  
            SOLICITUDCREDITO  Sol,
            INTEGRAGRUPOSCRE  Igr,
            GRUPOSCREDITO   Gru,
            CLIENTES Cli,
            DIRECCLIENTE Dir
          WHERE Gru.GrupoID = Igr.GrupoID         AND Igr.GrupoID = Par_GrupoID
          AND Igr.SolicitudCreditoID = Sol.SolicitudCreditoID         AND   Gru.EstatusCiclo = EstCerrado
          AND    Sol.ClienteID= Cli.ClienteID         AND    Cli.ClienteID= Dir.ClienteID         AND    Dir.Oficial = DirecOficial
          AND    (Sol.Estatus= SolAutoriza OR Sol.Estatus= SolDesembolsada)
          AND    Igr.Estatus= IntActivo;
          set  var_NumIntegrante    := (select max(Numero) from IntegrantesConsol);
          set  Contador             := round(var_NumIntegrante/2);
          set  ContaIntegra         := 1;
          while (Contador <= var_NumIntegrante)
          do
             set Contador := Contador+1;
          select NombreCompleto , DireccionCompleta into
                Var_NombreCompleto_2 , Var_DireccionCompleto_2
          from IntegrantesConsol where Numero=Contador;
          update IntegrantesConsol
          set Nombrecompleto_2= Var_NombreCompleto_2, DireccionCompleta_2=Var_DireccionCompleto_2
          where Numero =ContaIntegra;
            set ContaIntegra            := ContaIntegra +1;
            set Var_NombreCompleto_2    :='';
            set Var_DireccionCompleto_2 :='';
          end while;
          select NombreCompleto,DireccionCompleta,NombreCompleto_2,DireccionCompleta_2 
                from IntegrantesConsol 
                    where Numero <= round(var_NumIntegrante/2);
          drop table if exists IntegrantesConsol;
    END IF;

END TerminaStore$$