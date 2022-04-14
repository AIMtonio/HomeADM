-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CINTABNCPMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CINTABNCPMPRO`;

DELIMITER $$
CREATE PROCEDURE `CINTABNCPMPRO`(
    /* SP PARA CINTA DE BURO DE CREDITO DE PERSONAS MORALES MENSUAL FORMATO CSV */
    Par_FechaCorteBC        DATE,       -- Fecha de Corte para generar el reporte
    Par_TipoReporte         CHAR(1),    -- Tipo de Reporte M.- Mensual  S.- Semanal
    Par_CintaBCID           INT(11),    -- CintaID corresponde a BUROCREDBNCPMMEN
    Par_TipoFormatoCinta    INT(11),    -- Tipo de Formato de la cinta de buro 1.-Formato CSV, 2.-Formato INTL

     /* Parametros de Auditoria */
    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN
    #Declaracion de Constantes
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Fecha_Vacia             DATE;
    DECLARE Entero_Cero             INT;
    DECLARE Entero_Uno              INT;
    DECLARE Entero_Dos              INT;
    DECLARE Entero_Tres             INT;
    DECLARE Entero_Cuatro           INT;
    DECLARE Entero_Cinco            INT;
    DECLARE Entero_Seis             INT;
    DECLARE Entero_Cuarenta         INT;
    DECLARE Entero_Mil              INT;
    DECLARE NoveNovenNue            INT;
    DECLARE TrescieSesenta          INT;
    DECLARE IdentSegHD              VARCHAR(8);
    DECLARE IdentSegEM              CHAR(2);
    DECLARE IdentSegAC              CHAR(2);
    DECLARE IdentSegCR              CHAR(2);
    DECLARE IdentSegDE              CHAR(2);
    DECLARE IdentSegAV              CHAR(2);
    DECLARE IdentSegTS              CHAR(2);
    DECLARE PersonaMoral            CHAR(1);
    DECLARE PersonaFCAE             CHAR(1);
    DECLARE EncabezadoHDCVS         VARCHAR(500); -- Encabezado de inicio HD
    DECLARE EncabezadoEMCVS         VARCHAR(500); -- Encabezado datos generales EM
    DECLARE Var_EncabezadoACCVS     TEXT; -- Encabezado datos generales AC
    DECLARE EncabezadoACCVS         TEXT;         -- Encabezado datos generales AV
    DECLARE EncabezadoCRCVS         VARCHAR(500); -- Encabezado datos generales CR
    DECLARE EncabezadoDECVS         VARCHAR(500); -- Encabezado datos generales DE
    DECLARE EncabezadoAVCVS         TEXT;         -- Encabezado datos generales AV
    DECLARE Var_EncabezadoAVCVS     TEXT;         -- Encabezado datos generales AV
    DECLARE EncabezadoTSCVS         VARCHAR(500); -- Encabezado datos generales TS
    DECLARE DomicilioConocido       VARCHAR(50);
    DECLARE SinNumero               VARCHAR(3);
    DECLARE CalleConocido           VARCHAR(12);
    DECLARE CalleConocida           VARCHAR(12);
    DECLARE Si                      CHAR(1);
    DECLARE Unico                   VARCHAR(2);
    DECLARE Vigente                 CHAR(1);
    DECLARE Vencido                 CHAR(1);
    DECLARE Castigado               CHAR(1);
    DECLARE Pagado                  CHAR(1);
    DECLARE Separador               CHAR(1);
    DECLARE Salto_Linea             VARCHAR(2);
    DECLARE InstAnterior            VARCHAR(4);
    DECLARE Espacio                 CHAR(2);
    DECLARE Formato                 INT;
    DECLARE Fecha                   VARCHAR(10);
    DECLARE Periodo                 VARCHAR(8);
    DECLARE Usuario                 VARCHAR(10);
    DECLARE Letra_enie              CHAR(2);
    DECLARE Letra_N                 CHAR(2);
    DECLARE AAcento                 CHAR(1);
    DECLARE EAcento                 CHAR(1);
    DECLARE IAcento                 CHAR(1);
    DECLARE OAcento                 CHAR(1);
    DECLARE UAcento                 CHAR(1);
    DECLARE VocalA                  CHAR(1);
    DECLARE VocalE                  CHAR(1);
    DECLARE VocalI                  CHAR(1);
    DECLARE VocalO                  CHAR(1);
    DECLARE VocalU                  CHAR(1);

    #Declaracion de variables
    DECLARE Var_Cinta               LONGTEXT;
    DECLARE Var_FechaFin            DATE;
    DECLARE Var_FechaInicial        DATE;
    DECLARE Var_Contador            INT;
    DECLARE Var_ContadorTotal       INT;
    DECLARE Var_TotalSaldos         INT;
    DECLARE Var_UltimoReg           INT;
    DECLARE Var_Cliente             INT;
    DECLARE Var_CintaID             INT;
    DECLARE Var_IDControl           INT;
    DECLARE Var_Claveusuario        INT;
    DECLARE Var_TipoUsuario         VARCHAR(4);
    DECLARE Var_TipoCreditoNV       BIGINT(12);
    DECLARE Fec_me                  DECIMAL(6,2);
    DECLARE Etiqueta_LC             VARCHAR(3);
    DECLARE Etiqueta_LG             VARCHAR(3);
    DECLARE FechaIn                 DATE;
    DECLARE CompaniasVa             INT;
    # Accionistas
    DECLARE Etiqueta_AV             VARCHAR(4);         -- Etiqueta de Segmento de AVAL
    DECLARE Etiqueta_AC             VARCHAR(4);         -- Etiqueta de Segmento de ACCIONISTA
    DECLARE NumEncabezados          INT(11);
    DECLARE NumEncabezadosDir       INT(11);
    DECLARE NumEncabezadoAval       INT(11);
    DECLARE NumEncabezadoDirectivo  INT(11);
    DECLARE NumColumnas             INT(11);
    DECLARE SeparadorTS             TEXT;

    DECLARE UltCredID               BIGINT(12);     -- ID del ultimo credito
    DECLARE VeriCredID              VARCHAR(11);    -- ID del ultimo credito con avales
    DECLARE PosTS                   INT;        -- Posicion del identificador TS
    DECLARE NumColUltCred           INT(11);        -- Total de columnas por avales del ultimo credito
    DECLARE CliEspecifico           INT;        -- Numero del cliente especifico

    DECLARE CliEspConsol            INT;        -- Cliente especifico para CONSOL
    DECLARE ClienteConsol       VARCHAR(20);        -- Nombre del cliente especifico
    DECLARE Var_ConsecutivoID       INT(11);        -- Variable para almacenar un valor consecutivo
    DECLARE Var_NombreInstitucion   VARCHAR(75);    -- Nombre de la institucion
    DECLARE Var_Version             CHAR(2);        -- Version de la cadena INTL
    DECLARE Par_NumErr              INT(11);        -- Numero de Error
    DECLARE Par_ErrMen              VARCHAR(400);   -- Mensaje de Error

    -- Asignacion de Tipo de Reporte
    DECLARE Reporte_Semanal     CHAR(1);        -- Reporte Semanal
    DECLARE Reporte_Mensual     CHAR(1);        -- Reporte Mensual
    DECLARE Con_SI              CHAR(1);        -- Constantes SI
    DECLARE ExpresionRegular    VARCHAR(20);    -- Expresion Regular
    DECLARE LimpiaAlfaNumerico  CHAR(2);        -- Limpiar texto Alfa Numerico
    DECLARE Con_NO              CHAR(1);        -- Constante NO
    DECLARE Var_ReportarTotalIntegrantes CHAR(1);
    DECLARE Var_MaxRegistroID   INT(11);
    DECLARE Var_SolicitudCreditoID BIGINT(20);
    DECLARE Var_CreditoID          BIGINT(20);
    DECLARE Var_ClienteID       INT(11);
    DECLARE SegAccionistaVacio  VARCHAR(30);    -- Segmento de Accionista Vacio
    DECLARE LimpiaAlfabetico    VARCHAR(2);     -- Limpieza de texto que contiene solo letras

    -- DECLARACION DE CLAVE DE OBSERVACION
    DECLARE Etiqueta_RV             VARCHAR(3);  -- Clave de observacion sin pago menor por modificacion de la situacion del cliente
    DECLARE Etiqueta_RA             VARCHAR(3);  -- Cuenta reestructurada sin pago menor, por programa institucional o gubernamental, incluyendo los apoyos a damnificados por catástrofes naturales
    DECLARE Var_Renovacion          CHAR(1);     -- Variable para tipos de renovacion
    DECLARE Var_Reestructura        CHAR(1);     -- Variables para reestructuras
    DECLARE Con_TipoCliente         CHAR(1);     -- Constante Tipo Cliente
    DECLARE Con_TipoGarante         CHAR(1);     -- Constante Tipo Garanta
    DECLARE Con_TipoAval            CHAR(1);     -- Constante Tipo Aval
    DECLARE Con_TipoDirectivo       CHAR(1);     -- Constante Tipo Directivo
    DECLARE Var_FechaSistema        DATE;

    #Asiganacion de constantes
    SET Cadena_Vacia            := '';
    SET Fecha_Vacia             :='1900-01-01';
    SET Entero_Cero             := 0;
    SET Entero_Uno              := 1;
    SET Entero_Dos              := 2;
    SET Entero_tres             := 3;
    SET Entero_Cuatro           := 4;
    SET Entero_Cinco            := 5;
    SET Entero_Seis             := 6;
    SET Entero_Cuarenta         := 40;
    SET Entero_Mil              := 1000;
    SET NoveNovenNue            := 999;
    SET TrescieSesenta          := 360;
    SET IdentSegHD              :='BNCPM';
    SET IdentSegEM              :='EM';
    SET IdentSegAC              :='AC';
    SET IdentSegCR              :='CR';
    SET IdentSegDE              :='DE';
    SET IdentSegAV              :='AV';
    SET IdentSegTS              :='TS';
    SET PersonaMoral            := 'M';
    SET PersonaFCAE             := 'A';
    SET DomicilioConocido       := 'DOMICILIO CONOCIDO SN';
    SET SinNumero               := 'SN';
    SET CalleConocido           := '%CONOCIDO%';
    SET CalleConocida           := '%CONOCIDA%';
    SET Si                      := 'S';
    SET Unico                   :='U';
    SET Vigente                 :='V';
    SET Vencido                 :='B';
    SET Castigado               :='K';
    SET Pagado                  :='P';
    SET Separador               :=',';
    SET Salto_Linea             :='\n';
    SET Espacio                 :=' ';
    SET Letra_enie              :='Ñ';
    SET Letra_N                 :='N';
    SET AAcento                 :='Á';
    SET EAcento                 :='É';
    SET IAcento                 :='Í';
    SET OAcento                 :='Ó';
    SET UAcento                 :='Ú';
    SET VocalA                  :='A';
    SET VocalE                  :='E';
    SET VocalI                  :='I';
    SET VocalO                  :='O';
    SET VocalU                  :='U';
    SET InstAnterior            :=(SELECT ClaveUsuarioBCPM FROM BUCREPARAMETROS);
    SET Fecha                   :=DATE_FORMAT(LAST_DAY(Par_FechaCorteBC),'%d%m%Y');
    SET Periodo                 :=SUBSTRING(DATE_FORMAT(Par_FechaCorteBC,'%d%m%Y'), 3,8);
    SET Usuario                 :=Cadena_Vacia;
    SET Fec_me                  :=30.4;
    SET Etiqueta_LC             :='LC';
    SET Etiqueta_LG             :='LG';
    SET Etiqueta_AV             :='AV';
    SET Etiqueta_AC             :='AC';
    SET Formato                 := 1;
    SET EncabezadoAVCVS         := Cadena_Vacia;
    SET EncabezadoACCVS         := Cadena_Vacia;

    SET CliEspConsol            := 10;          -- Cliente especifico para CONSOL
    SET ClienteConsol           := 'CONSOL NEGOCIOS';   -- Nombre del cliente
    SET Var_Version             := '05';

    -- Encabezado de la cinta HD
    SET EncabezadoHDCVS:=Cadena_Vacia;
    SET EncabezadoHDCVS:=CONCAT(EncabezadoHDCVS,'Identificador,Institucion,Inst. Ant,Tipo Institucion,Formato,Fecha,Periodo,Usuario');
    -- Encabezado de la cinta EM
    SET EncabezadoEMCVS:=Cadena_Vacia;
    SET EncabezadoEMCVS:=CONCAT(EncabezadoEMCVS,'Identificador,RFC,Codigo Ciudadano,Numero Dun,Compania,Nombre 1,Nombre 2,Paterno,');
    SET EncabezadoEMCVS:=CONCAT(EncabezadoEMCVS,'Materno,Nacionalidad,Calificacion Banco de Mex.,Banxico 1,Banxico 2,Banxico 3,Direccion 1,');
    SET EncabezadoEMCVS:=CONCAT(EncabezadoEMCVS,'Direccion 2,Colonia/Poblacion,Delegacion/Municipio,Ciudad,Estado,C.P.,Telefono,');
    SET EncabezadoEMCVS:=CONCAT(EncabezadoEMCVS,'Extension,Fax,Tipo Cliente,Estado extranjero,Pais,Clave de Cosolidacion,');
    -- Encabezado de la cinta AC
    SET Var_EncabezadoACCVS:=Cadena_Vacia;
    SET Var_EncabezadoACCVS:=CONCAT(Var_EncabezadoACCVS,'Identificador,RFC Accionista,Codigo Ciudadano,Numero Dun,Nombre Cia.,Nombre 1,Nombre 2,Paterno,');
    SET Var_EncabezadoACCVS:=CONCAT(Var_EncabezadoACCVS,'Materno,Porcentaje,Direccion 1,Direccion 2,Colonia/Poblacion,Delegacion/Municipio,');
    SET Var_EncabezadoACCVS:=CONCAT(Var_EncabezadoACCVS,'Ciudad,Estado,C.P.,Telefono,Extension,Fax,Tipo Cliente,Estado extranjero,Pais,');
    -- Encabezado de la cinta CR
    SET EncabezadoCRCVS:=Cadena_Vacia;
    SET EncabezadoCRCVS:=CONCAT(EncabezadoCRCVS,'Identificador,RFC Empresa,Numero Experiencias,Contrato,Contrato Anterior.,Fecha Apertura,Plazo,Tipo de Credito,');
    SET EncabezadoCRCVS:=CONCAT(EncabezadoCRCVS,'Saldo Inicial,Moneda,Numero Pagos,Frecuencia de Pagos,Importe de Pagos,Fecha Ultimo Pago,Fecha Reestructura,');
    SET EncabezadoCRCVS:=CONCAT(EncabezadoCRCVS,'Pago en efectivo,Fecha Liquidacion,Quita,Dacion,Quebranto,Observaciones,Especiales,Fecha Primer Incum,Saldo Insoluto,Crédito Máximo Utilizado,Fecha de Ingreso a cartera vencida,');
    -- Encabezado de la cinta DE
    SET EncabezadoDECVS:=Cadena_Vacia;
    SET EncabezadoDECVS:=CONCAT(EncabezadoDECVS,'Identificador,RFC Empresa,Contrato,Dias Vencimiento,Cantidad,Interes,');
    -- Encabezado de la cinta DE
    SET Var_EncabezadoAVCVS:=Cadena_Vacia;
    SET Var_EncabezadoAVCVS:=CONCAT(Var_EncabezadoAVCVS,'Identificador,RFC Aval,Codigo Ciudadano,Numero Dun,Nombre Cia.,Nombre 1,Nombre 2,Paterno,Materno,');
    SET Var_EncabezadoAVCVS:=CONCAT(Var_EncabezadoAVCVS,'Direccion 1,Direccion 2,Colonia/Poblacion,Delegacion/Municipio,Ciudad,Estado,C.P.,Telefono,Extension,Fax,');
    SET Var_EncabezadoAVCVS:=CONCAT(Var_EncabezadoAVCVS,'Tipo Cliente,Estado extranjero,Pais,');
    -- Encabezado de la cinta TS
    SET EncabezadoTSCVS:=Cadena_Vacia;
    SET EncabezadoTSCVS:=CONCAT(EncabezadoTSCVS,'Identificador,Numero de Companias,Cantidad');
     #Asiganacion de constantes
    SET Var_FechaFin        := LAST_DAY(Par_FechaCorteBC);
    SET Var_FechaInicial    := DATE_FORMAT(Par_FechaCorteBC, '%Y-%m-01');
    SET Var_TotalSaldos     := Entero_Cero;
    SET Var_Contador        := Entero_Cero;
    SET Var_CintaID         := Par_CintaBCID;
    SET Var_IDControl       := Entero_Uno;
    SET Var_Cinta           := Cadena_Vacia;

    -- Seteo de Tipo de Reporte
    SET Reporte_Semanal := 'S';
    SET Reporte_Mensual := 'M';
    SET Con_SI          := 'S';
    SET ExpresionRegular    := '^[a-zA-Z0-9_]*$';
    SET LimpiaAlfaNumerico  := 'AN';
    SET Con_NO              := 'N';
    SET SegAccionistaVacio      := 'AC,,,,,,,,,,,,,,,,,,,,,,';
    SET LimpiaAlfabetico        := 'A';

    -- ASIGNACION DE CLAVES DE OBSERVACION
    SET Etiqueta_RV             :='RV';  -- Clave de observacion sin pago menor por modificacion de la situacion del cliente
    SET Etiqueta_RA             :='RA';  -- Cuenta reestructurada sin pago menor, por programa institucional o gubernamental, incluyendo los apoyos a damnificados por catástrofes naturales
    SET Var_Renovacion          :='O';   -- Variable para tipos de renovacion
    SET Var_Reestructura        :='R';   -- Variables para reestructuras
    SET Con_TipoCliente         := 'C';
    SET Con_TipoGarante         := 'G';
    SET Con_TipoAval            := 'A';
    SET Con_TipoDirectivo       := 'D';

ManejoErrores:BEGIN

    -- Validacion de datos nulo
    SET Par_TipoFormatoCinta := IFNULL(Par_TipoFormatoCinta, Entero_Cero);

    -- Creacion de la tabla temporal con los datos que contendrá la cinta
    DROP TABLE IF EXISTS TMPDATOSEM;
    CREATE TABLE TMPDATOSEM(
        ID                  INT AUTO_INCREMENT PRIMARY KEY,                     ClienteID           INT(11),            IdentificaEM    CHAR(2),
        RFC                 VARCHAR(13),    CURP                VARCHAR(18),    NumDun              VARCHAR(10),        Compania        VARCHAR(75),
        PrimerNombre        VARCHAR(75),    SegundoNombre       VARCHAR(75),    ApePaterno          VARCHAR(25),        ApeMaterno      VARCHAR(25),
        Nacionalidad        CHAR(2),        CalifCartera        CHAR(2),        ActEconomica1       VARCHAR(11),        ActEconomica2   VARCHAR(11),
        ActEconomica3       VARCHAR(11),    PriLinDireccion     VARCHAR(40),    SegLinDireccion     VARCHAR(40),        Colonia         VARCHAR(60),
        Municipio           VARCHAR(40),    Ciudad              VARCHAR(40),    Estado              CHAR(4),            CP              VARCHAR(10),
        Telefono            VARCHAR(11),    ExtTelefono         VARCHAR(8),     Fax                 VARCHAR(11),        TipoCliente     INT(1),
        EdoExtranjero       VARCHAR(40),    Pais                CHAR(2),        ClaveConsolida      VARCHAR(8),         IdentificaAC    CHAR(2),
        RFCAC               VARCHAR(13),    CURPAC              VARCHAR(18),    NumDunAC            VARCHAR(10),        CompaniaAC      VARCHAR(75),
        PrimerNombreAC      VARCHAR(75),    SegundoNombreAC     VARCHAR(75),    ApePaternoAC        VARCHAR(25),        ApeMaternoAC    VARCHAR(25),
        PorcentajeAC        CHAR(2),        PriLinDireccionAC   VARCHAR(40),    SegLinDireccionAC   VARCHAR(40),        ColoniaAC       VARCHAR(60),
        MunicipioAC         VARCHAR(40),    CiudadAC            VARCHAR(40),    EstadoAC            VARCHAR(4),         CPAC            VARCHAR(10),
        TelefonoAC          VARCHAR(11),    ExtTelefonoAC       VARCHAR(8),     FaxAC               VARCHAR(11),        TipoClienteAC   VARCHAR(1),
        EdoExtranjeroAC     VARCHAR(40),    PaisAC              CHAR(2),        IdentificaCR        CHAR(2),            RFCCR           VARCHAR(13),
        NumExpeCred         VARCHAR(6),     ContratoCR          VARCHAR(25),    CreditoIDAnt        VARCHAR(20),        FechaInicio     VARCHAR(8),
        Plazo               DECIMAL(6,2),   TipoCredito         VARCHAR(4),     SaldoInicial        INT(20),            Moneda          TEXT,
        NumPagos            INT(4),         FrecuenciaPag       VARCHAR(4),     ImportePago         INT(20),            FechaUltPago    VARCHAR(8),
        FechaReestru        VARCHAR(8),     PagoEfectivo        VARCHAR(20),    FechaLiquida        VARCHAR(8),         Quita           VARCHAR(20),
        Dacion              VARCHAR(20),    Quebranto           VARCHAR(20),    ClaveObserva        VARCHAR(4),         CredEspecial    CHAR(1),
        FechaPrimerIn       VARCHAR(10),     SaldoInsoluto       INT(20),        IdentificaDE        CHAR(2),            RFCDE           VARCHAR(13),
        Contrato            VARCHAR(25),    DiasVencido         INT(3),         Saldo               INT(20),            IdentificaAV    CHAR(2),
        RFCAV               VARCHAR(13),    CURPAV              VARCHAR(18),    NumDunAV            VARCHAR(10),        CompaniaAV      VARCHAR(75),
        PrimerNombreAV      VARCHAR(75),    SegundoNombreAV     VARCHAR(75),    ApePaternoAV        VARCHAR(25),        ApeMaternoAV    VARCHAR(25),
        PriLinDireccionAV   VARCHAR(40),    SegLinDireccionAV   VARCHAR(40),    ColoniaAV           VARCHAR(60),        MunicipioAV     VARCHAR(40),
        CiudadAV            VARCHAR(40),    EstadoAV            VARCHAR(4),     CPAV                VARCHAR(10),        TelefonoAV      VARCHAR(11),
        ExtTelefonoAV       VARCHAR(8),     FaxAV               VARCHAR(11),    TipoClienteAV       VARCHAR(1),         EdoExtranjeroAV VARCHAR(40),
        PaisAV              CHAR(2),        CreditoID           BIGINT(12),     CredMaxUti          DECIMAL(14,2),      FechIngCarVen   VARCHAR(12),
        InteresCred         DECIMAL(14,2),  CadenaAvales        TEXT,           Cinta               LONGTEXT,           IdentificaTS    TEXT,
        NumReportes         VARCHAR(7),     TotalSaldos         VARCHAR(20),    SolicitudCreditoID  BIGINT(12),         CadenaDirectivo TEXT,
        NumAccionistas      INT(11),        HeaderINTL          TEXT,
        FechaUltimoPago    VARCHAR(10),     FechIngCarVen2   VARCHAR(12),
    INDEX TMPDATOSEM1 (CreditoID),
    INDEX TMPDATOSEM2 (ClienteID),
    INDEX TMPDATOSEM3 (FechaLiquida));

    IF( Par_TipoReporte = Reporte_Semanal ) THEN

    SET Var_FechaInicial := DATE_SUB(Par_FechaCorteBC, INTERVAL 7 DAY);
    -- Insercion de los datos generales, los valores de saldos son actualizados posteriormente.
    INSERT INTO TMPDATOSEM(
        ClienteID,          IdentificaEM,       RFC,                CURP,               NumDun,                 Compania,           PrimerNombre,       SegundoNombre,
        ApePaterno,         ApeMaterno,         Nacionalidad,       CalifCartera,       ActEconomica1,          ActEconomica2,      ActEconomica3,      PriLinDireccion,
        SegLinDireccion,    Colonia ,           Municipio,          Ciudad,             Estado,                 CP,                 Telefono,           ExtTelefono,
        Fax, TipoCliente,   EdoExtranjero,      Pais,               ClaveConsolida,     IdentificaAC,           RFCAC,              CURPAC,             NumDunAC,
        CompaniaAC,         PrimerNombreAC,     SegundoNombreAC,    ApePaternoAC,       ApeMaternoAC,           PorcentajeAC,       PriLinDireccionAC,  SegLinDireccionAC,
        ColoniaAC,          MunicipioAC,        CiudadAC,           EstadoAC,           CPAC,                   TelefonoAC,         ExtTelefonoAC,      FaxAC,
        TipoClienteAC,      EdoExtranjeroAC,    PaisAC,             IdentificaCR,       RFCCR,                  NumExpeCred,        ContratoCR,         CreditoIDAnt,
        FechaInicio,        Plazo,              TipoCredito,        SaldoInicial,       Moneda,                 NumPagos,           FrecuenciaPag,      ImportePago,
        FechaUltPago,       FechaReestru,       PagoEfectivo,       FechaLiquida,       Quita,                  Dacion,             Quebranto,          ClaveObserva,
        CredEspecial,       FechaPrimerIn,      SaldoInsoluto,      IdentificaDE,       RFCDE,                  Contrato,           DiasVencido,        Saldo,
        IdentificaAV,       RFCAV,              CURPAV,             NumDunAV,           CompaniaAV,             PrimerNombreAV,     SegundoNombreAV,    ApePaternoAV,
        ApeMaternoAV,       PriLinDireccionAV,  SegLinDireccionAV,  ColoniaAV,          MunicipioAV,            CiudadAV,           EstadoAV,           CPAV,
        TelefonoAV,         ExtTelefonoAV,      FaxAV,              TipoClienteAV,      EdoExtranjeroAV,        PaisAV,             CreditoID,          CredMaxUti,
        FechIngCarVen,      InteresCred,        CadenaAvales,       IdentificaTS,       NumReportes,            TotalSaldos,        SolicitudCreditoID, CadenaDirectivo,
        NumAccionistas,     HeaderINTL,        FechaUltimoPago,     FechIngCarVen2
     )

    SELECT  MAX(Cli.ClienteID) AS ClienteID,                     IdentSegEM,       MAX(Cli.RFCOficial),  IFNULL(MAX(Cli.CURP),Cadena_Vacia) AS CURP,             Cadena_Vacia AS  NumDun,   LEFT(FNLIMPIACARACTBUROCRED(MAX(Cli.RazonSocial),'A'),75) AS compania,  IFNULL(MAX(Cli.PrimerNombre),Cadena_Vacia) AS PrimerNombre,
            IFNULL(MAX(Cli.SegundoNombre),Cadena_Vacia) AS SegundoNombre,               IFNULL(MAX(Cli.ApellidoPaterno),Cadena_Vacia) AS ApePaterno,            IFNULL(MAX(Cli.ApellidoMaterno),Cadena_Vacia) AS ApeMaterno,
            TRIM(LEFT(MAX(Pai.EqBuroCred),Entero_Cinco)) AS Nacionalidad,   Cadena_Vacia AS CalifCartera,
            MAX(Act.NumeroBuroCred),                Cadena_Vacia AS ActEconomica2,  Cadena_Vacia AS ActEconomica3,
            LEFT(IF((IFNULL(MAX(Dir.Calle),Cadena_Vacia)=Cadena_Vacia AND IFNULL(MAX(Dir.NumeroCasa),Cadena_Vacia)=Cadena_Vacia)OR(IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocida OR
            IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocido) , DomicilioConocido, CONCAT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),Cadena_Vacia,' ',IFNULL(MAX(Dir.NumeroCasa),SinNumero))),Entero_Cuarenta) AS PriLinDireccion,
            SUBSTRING(IF((IFNULL(MAX(Dir.Calle),Cadena_Vacia)=Cadena_Vacia AND IFNULL(MAX(Dir.NumeroCasa),Cadena_Vacia)=Cadena_Vacia)OR(IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocida OR
            IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocido) , DomicilioConocido, CONCAT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),Cadena_Vacia,' ',IFNULL(MAX(Dir.NumeroCasa),SinNumero))),41,40) AS SegLinDireccion,
            TRIM(LEFT(CONCAT(MAX(Col.Asentamiento)),Entero_Cuarenta)) AS Colonia,   TRIM(LEFT(MAX(Mun.Nombre),Entero_Cuarenta)) AS Municipio,
            TRIM(LEFT(MAX(Mun.Ciudad),Entero_Cuarenta))  AS Ciudad,             MAX(Est.EqBuroCred) AS Estado,      MAX(Dir.CP),            MAX(Cli.Telefono),              Cadena_Vacia AS ExtTelefono,            LEFT(IFNULL(MAX(Cli.Fax),Cadena_Vacia),11) AS Fax,
            CASE MAX(Cli.TipoPersona) WHEN PersonaMoral THEN Entero_Uno WHEN PersonaFCAE THEN Entero_Dos END  AS TipoCliente,        Cadena_Vacia AS EdoExtranjero,          TRIM(LEFT(MAX(Pai.EqBuroCred),Entero_Cinco)) AS Pais,
            Cadena_Vacia AS ClaveConsolida,         Cadena_Vacia AS  IdentificaAC,          Cadena_Vacia AS RFCAC,   Cadena_Vacia AS CURPAC,        Cadena_Vacia AS NumDunAC,
            Cadena_Vacia AS CompaniaAC,         Cadena_Vacia AS PrimerNombreAC,     Cadena_Vacia AS SegundoNombreAC,        Cadena_Vacia AS ApePaternoAC,           Cadena_Vacia AS ApeMaternoAC,   Cadena_Vacia AS PorcentajeAC,
            Cadena_Vacia AS PriLinDireccionAC,  Cadena_Vacia AS SegLinDireccionAC,  Cadena_Vacia AS ColoniaAC,              Cadena_Vacia AS MunicipioAC,            Cadena_Vacia AS CiudadAC,       Cadena_Vacia AS EstadoAC,
            Cadena_Vacia AS CPAC,               Cadena_Vacia AS TelefonoAC,         Cadena_Vacia AS ExtTelefonoAC,          Cadena_Vacia AS FaxAC,                  Cadena_Vacia AS TipoClienteAC,  Cadena_Vacia AS EdoExtranjeroAC,
            Cadena_Vacia AS PaisAC,             IdentSegCR,                         MAX(Cli.RFCOficial),                            Cadena_Vacia AS NumExpeCred,            IFNULL(MAX(EqC.CreditoIDCte),MAX(Cre.CreditoID)) AS ContratoCR,
            CASE MAX(Cre.Relacionado) WHEN Entero_Cero THEN Cadena_Vacia ELSE MAX(Cre.Relacionado) END AS CreditoIDAnt,                 DATE_FORMAT(MAX(Cre.FechaInicio),'%d%m%Y') AS FechaInicio,  MAX(Pla.Dias),
            Cadena_Vacia AS TipoCredito,        MAX(Cre.MontoCredito) AS SaldoInicial,                  MAX(Mon.EqBuroCredPM),                      MAX(Cre.NumAmortizacion),                   MAX(Cre.PeriodicidadCap),
            Entero_Cero AS ImportePago,         CASE  WHEN MAX(Cre.FechTerminacion) != Fecha_Vacia AND  MAX(Cre.FechTerminacion) <= Par_FechaCorteBC THEN   DATE_FORMAT(MAX(Cre.FechTerminacion),'%d%m%Y')    ELSE  DATE_FORMAT(IFNULL(MAX(Det.FechaPago),MAX(Cre.FechaInicio)),'%d%m%Y')   END AS FechaUltPago,  Cadena_Vacia AS   FechaReestru,
            Cadena_Vacia AS PagoEfectivo,
           CASE WHEN MAX(Cre.FechTerminacion) != Fecha_Vacia AND  MAX(Cre.FechTerminacion) BETWEEN ADDDATE(LAST_DAY(SUBDATE(Par_FechaCorteBC, INTERVAL 1 MONTH)), 1) AND  Par_FechaCorteBC THEN
           DATE_FORMAT(MAX(Cre.FechTerminacion),'%d%m%Y')
           ELSE Cadena_Vacia END AS FechaLiquida,
        Cadena_Vacia AS Quita,  Cadena_Vacia AS Dacion,
            Cadena_Vacia AS Quebranto,          Cadena_Vacia AS ClaveObserva,      Cadena_Vacia AS CredEspecial,            Cadena_Vacia AS FechaPrimerIn,          Entero_Cero AS SaldoInsoluto,
            IdentSegDE,     MAX(Cli.RFCOficial),        IFNULL(MAX(EqC.CreditoIDCte),MAX(Cre.CreditoID)) AS Contrato,                           Entero_Cero AS DiasVencido,             Entero_Cero AS  Saldo,
            Cadena_Vacia AS  IdentificaAV,      Cadena_Vacia AS RFCAV,              Cadena_Vacia AS CURPAV,                 Cadena_Vacia AS NumDunAV,               Cadena_Vacia AS CompaniaAV,         Cadena_Vacia AS PrimerNombreAV,
            Cadena_Vacia AS SegundoNombreAV,    Cadena_Vacia AS ApePaternoAV,       Cadena_Vacia AS ApeMaternoAV,           Cadena_Vacia AS PriLinDireccionAV,      Cadena_Vacia AS SegLinDireccionAV,  Cadena_Vacia AS ColoniaAV,
            Cadena_Vacia AS MunicipioAV,        Cadena_Vacia AS CiudadAV,           Cadena_Vacia AS EstadoAV,               Cadena_Vacia AS CPAV,                   Cadena_Vacia AS TelefonoAV,         Cadena_Vacia AS ExtTelefonoAV,
            Cadena_Vacia AS FaxAV,              Cadena_Vacia AS TipoClienteAV,      Cadena_Vacia AS EdoExtranjeroAV,        Cadena_Vacia AS PaisAV,                 MAX(Cre.CreditoID),                 Cre.MontoCredito AS CredMaxUti,
            DATE_FORMAT(MAX(Cre.FechTraspasVenc),'%d%m%Y') AS FechIngCarVen,   Entero_Cero AS InteresCred, Cadena_Vacia AS CadenaAvales, Cadena_Vacia AS IdentificaTS,       Cadena_Vacia AS NumReportes,
            Cadena_Vacia AS TotalSaldos,        Cre.SolicitudCreditoID, Cadena_Vacia AS CadenaDirectivo,     Entero_Cero AS NumAccionistas, Cadena_Vacia,
            CASE  WHEN MAX(Cre.FechTerminacion) != Fecha_Vacia AND  MAX(Cre.FechTerminacion) <= Par_FechaCorteBC THEN   MAX(Cre.FechTerminacion)   ELSE  IFNULL(MAX(Det.FechaPago),MAX(Cre.FechaInicio)) END,
            MAX(Cre.FechTraspasVenc)
    FROM CREDITOS Cre
        LEFT  JOIN DETALLEPAGCRE    Det     ON  Cre.CreditoID = Det.CreditoID  AND Det.FechaPago <= Par_FechaCorteBC
        INNER JOIN PRODUCTOSCREDITO Pro     ON  Cre.ProductoCreditoID = Pro.ProducCreditoID
        LEFT  JOIN EQU_CREDITOS     EqC     ON  Det.CreditoID = EqC.CreditoIDSAFI
        INNER JOIN CREDITOSPLAZOS   Pla     ON  Pla.PlazoID = Cre.PlazoID
        INNER JOIN MONEDAS          Mon     ON  Mon.MonedaID = Cre.MonedaID
        INNER JOIN CLIENTES         Cli     ON  Cre.ClienteID = Cli.ClienteID
        INNER JOIN DIRECCLIENTE     Dir     ON  Cre.ClienteID = Dir.ClienteID   AND Dir.Oficial = Si
        INNER JOIN ESTADOSREPUB     Est     ON  Dir.EstadoID = Est.EstadoID
        INNER JOIN ACTIVIDADESBMX   Act     ON  Cli.ActividadBancoMX = Act.ActividadBMXID
        INNER JOIN PAISES           Pai     ON  Pai.PaisID  =Cli.PaisResidencia AND Pai.PaisID=Cli.PaisResidencia
        INNER JOIN MUNICIPIOSREPUB  Mun     ON  Dir.EstadoID = Mun.EstadoID     AND Dir.MunicipioID =Mun.MunicipioID
        INNER JOIN COLONIASREPUB    Col     ON  Dir.EstadoID = Col.EstadoID     AND Dir.MunicipioID = Col.MunicipioID
                                                                                AND Dir.ColoniaID   = Col.ColoniaID
    WHERE Cre.FechTerminacion BETWEEN Var_FechaInicial AND Par_FechaCorteBC
      AND Cre.FechTerminacion < Cre.FechaVencimien
      AND Cli.TipoPersona IN (PersonaMoral,PersonaFCAE )
      AND Cre.Estatus = Pagado
    GROUP BY  Cre.CreditoID ORDER BY ClienteID;
    END IF;

    IF( Par_TipoReporte = Reporte_Mensual ) THEN

        -- Insercion de los datos generales, los valores de saldos son actualizados posteriormente.
        INSERT INTO TMPDATOSEM(
            ClienteID,          IdentificaEM,       RFC,                CURP,               NumDun,                 Compania,           PrimerNombre,       SegundoNombre,
            ApePaterno,         ApeMaterno,         Nacionalidad,       CalifCartera,       ActEconomica1,          ActEconomica2,      ActEconomica3,      PriLinDireccion,
            SegLinDireccion,    Colonia ,           Municipio,          Ciudad,             Estado,                 CP,                 Telefono,           ExtTelefono,
            Fax, TipoCliente,   EdoExtranjero,      Pais,               ClaveConsolida,     IdentificaAC,           RFCAC,              CURPAC,             NumDunAC,
            CompaniaAC,         PrimerNombreAC,     SegundoNombreAC,    ApePaternoAC,       ApeMaternoAC,           PorcentajeAC,       PriLinDireccionAC,  SegLinDireccionAC,
            ColoniaAC,          MunicipioAC,        CiudadAC,           EstadoAC,           CPAC,                   TelefonoAC,         ExtTelefonoAC,      FaxAC,
            TipoClienteAC,      EdoExtranjeroAC,    PaisAC,             IdentificaCR,       RFCCR,                  NumExpeCred,        ContratoCR,         CreditoIDAnt,
            FechaInicio,        Plazo,              TipoCredito,        SaldoInicial,       Moneda,                 NumPagos,           FrecuenciaPag,      ImportePago,
            FechaUltPago,       FechaReestru,       PagoEfectivo,       FechaLiquida,       Quita,                  Dacion,             Quebranto,          ClaveObserva,
            CredEspecial,       FechaPrimerIn,      SaldoInsoluto,      IdentificaDE,       RFCDE,                  Contrato,           DiasVencido,        Saldo,
            IdentificaAV,       RFCAV,              CURPAV,             NumDunAV,           CompaniaAV,             PrimerNombreAV,     SegundoNombreAV,    ApePaternoAV,
            ApeMaternoAV,       PriLinDireccionAV,  SegLinDireccionAV,  ColoniaAV,          MunicipioAV,            CiudadAV,           EstadoAV,           CPAV,
            TelefonoAV,         ExtTelefonoAV,      FaxAV,              TipoClienteAV,      EdoExtranjeroAV,        PaisAV,             CreditoID,          CredMaxUti,
            FechIngCarVen,      InteresCred,        CadenaAvales,       IdentificaTS,       NumReportes,            TotalSaldos,        SolicitudCreditoID, CadenaDirectivo,
            NumAccionistas,     HeaderINTL,        FechaUltimoPago,
            FechIngCarVen2
         )

        SELECT  MAX(Cli.ClienteID) AS ClienteID,                     IdentSegEM,       MAX(Cli.RFCOficial),  IFNULL(MAX(Cli.CURP),Cadena_Vacia) AS CURP,             Cadena_Vacia AS  NumDun,   LEFT(FNLIMPIACARACTBUROCRED(MAX(Cli.RazonSocial),'A'),75) AS compania,   IFNULL(MAX(Cli.PrimerNombre),Cadena_Vacia) AS PrimerNombre,
                IFNULL(MAX(Cli.SegundoNombre),Cadena_Vacia) AS SegundoNombre,               IFNULL(MAX(Cli.ApellidoPaterno),Cadena_Vacia) AS ApePaterno,            IFNULL(MAX(Cli.ApellidoMaterno),Cadena_Vacia) AS ApeMaterno,
                TRIM(LEFT(MAX(Pai.EqBuroCred),Entero_Cinco)) AS Nacionalidad,   Cadena_Vacia AS CalifCartera,
                MAX(Act.NumeroBuroCred),                Cadena_Vacia AS ActEconomica2,  Cadena_Vacia AS ActEconomica3,
                LEFT(IF((IFNULL(MAX(Dir.Calle),Cadena_Vacia)=Cadena_Vacia AND IFNULL(MAX(Dir.NumeroCasa),Cadena_Vacia)=Cadena_Vacia)OR(IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocida OR
                IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocido) , DomicilioConocido, CONCAT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),Cadena_Vacia,' ',IFNULL(MAX(Dir.NumeroCasa),SinNumero))),Entero_Cuarenta) AS PriLinDireccion,
                SUBSTRING(IF((IFNULL(MAX(Dir.Calle),Cadena_Vacia)=Cadena_Vacia AND IFNULL(MAX(Dir.NumeroCasa),Cadena_Vacia)=Cadena_Vacia)OR(IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocida OR
                IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocido) , DomicilioConocido, CONCAT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),Cadena_Vacia,' ',IFNULL(MAX(Dir.NumeroCasa),SinNumero))),41,40) AS SegLinDireccion,
                TRIM(LEFT(CONCAT(MAX(Col.Asentamiento)),Entero_Cuarenta)) AS Colonia,   TRIM(LEFT(MAX(Mun.Nombre),Entero_Cuarenta)) AS Municipio,
                TRIM(LEFT(MAX(Mun.Ciudad),Entero_Cuarenta))  AS Ciudad,             MAX(Est.EqBuroCred) AS Estado,      MAX(Dir.CP),            MAX(Cli.Telefono),              Cadena_Vacia AS ExtTelefono,             LEFT(IFNULL(MAX(Cli.Fax),Cadena_Vacia),11) AS Fax,
                CASE MAX(Cli.TipoPersona) WHEN PersonaMoral THEN Entero_Uno WHEN PersonaFCAE THEN Entero_Dos END  AS TipoCliente,        Cadena_Vacia AS EdoExtranjero,          TRIM(LEFT(MAX(Pai.EqBuroCred),Entero_Cinco)) AS Pais,
                Cadena_Vacia AS ClaveConsolida,         Cadena_Vacia AS  IdentificaAC,          Cadena_Vacia AS RFCAC,   Cadena_Vacia AS CURPAC,        Cadena_Vacia AS NumDunAC,
                Cadena_Vacia AS CompaniaAC,         Cadena_Vacia AS PrimerNombreAC,     Cadena_Vacia AS SegundoNombreAC,        Cadena_Vacia AS ApePaternoAC,           Cadena_Vacia AS ApeMaternoAC,   Cadena_Vacia AS PorcentajeAC,
                Cadena_Vacia AS PriLinDireccionAC,  Cadena_Vacia AS SegLinDireccionAC,  Cadena_Vacia AS ColoniaAC,              Cadena_Vacia AS MunicipioAC,            Cadena_Vacia AS CiudadAC,       Cadena_Vacia AS EstadoAC,
                Cadena_Vacia AS CPAC,               Cadena_Vacia AS TelefonoAC,         Cadena_Vacia AS ExtTelefonoAC,          Cadena_Vacia AS FaxAC,                  Cadena_Vacia AS TipoClienteAC,  Cadena_Vacia AS EdoExtranjeroAC,
                Cadena_Vacia AS PaisAC,             IdentSegCR,                         MAX(Cli.RFCOficial),                            Cadena_Vacia AS NumExpeCred,            IFNULL(MAX(EqC.CreditoIDCte),MAX(Cre.CreditoID)) AS ContratoCR,
                CASE MAX(Cre.Relacionado) WHEN Entero_Cero THEN Cadena_Vacia ELSE MAX(Cre.Relacionado) END AS CreditoIDAnt,
                DATE_FORMAT(MAX(Cre.FechaInicio),'%d%m%Y') AS FechaInicio,  MAX(Pla.Dias) AS Plazo,
                Cadena_Vacia AS TipoCredito,        MAX(Cre.MontoCredito) AS SaldoInicial,                  MAX(Mon.EqBuroCredPM),                      MAX(Cre.NumAmortizacion),                   MAX(Cre.PeriodicidadCap),
                Entero_Cero AS ImportePago,         CASE  WHEN MAX(Cre.FechTerminacion) != Fecha_Vacia AND  MAX(Cre.FechTerminacion) <= Par_FechaCorteBC THEN   DATE_FORMAT(MAX(Cre.FechTerminacion),'%d%m%Y')    ELSE  DATE_FORMAT(IFNULL(MAX(Det.FechaPago),MAX(Cre.FechaInicio)),'%d%m%Y')   END AS FechaUltPago,  Cadena_Vacia AS   FechaReestru,
                Cadena_Vacia AS PagoEfectivo,
               CASE WHEN MAX(Cre.FechTerminacion) != Fecha_Vacia AND  MAX(Cre.FechTerminacion) BETWEEN ADDDATE(LAST_DAY(SUBDATE(Par_FechaCorteBC, INTERVAL 1 MONTH)), 1) AND  Par_FechaCorteBC THEN
               DATE_FORMAT(MAX(Cre.FechTerminacion),'%d%m%Y')
               ELSE Cadena_Vacia END AS FechaLiquida,
            Cadena_Vacia AS Quita,  Cadena_Vacia AS Dacion,
                Cadena_Vacia AS Quebranto,          Cadena_Vacia AS ClaveObserva,      Cadena_Vacia AS CredEspecial,            Cadena_Vacia AS FechaPrimerIn,          Entero_Cero AS SaldoInsoluto,
                IdentSegDE,     MAX(Cli.RFCOficial),        IFNULL(MAX(EqC.CreditoIDCte),MAX(Cre.CreditoID)) AS Contrato,                           Entero_Cero AS DiasVencido,             Entero_Cero AS  Saldo,
                Cadena_Vacia AS  IdentificaAV,      Cadena_Vacia AS RFCAV,              Cadena_Vacia AS CURPAV,                 Cadena_Vacia AS NumDunAV,               Cadena_Vacia AS CompaniaAV,         Cadena_Vacia AS PrimerNombreAV,
                Cadena_Vacia AS SegundoNombreAV,    Cadena_Vacia AS ApePaternoAV,       Cadena_Vacia AS ApeMaternoAV,           Cadena_Vacia AS PriLinDireccionAV,      Cadena_Vacia AS SegLinDireccionAV,  Cadena_Vacia AS ColoniaAV,
                Cadena_Vacia AS MunicipioAV,        Cadena_Vacia AS CiudadAV,           Cadena_Vacia AS EstadoAV,               Cadena_Vacia AS CPAV,                   Cadena_Vacia AS TelefonoAV,         Cadena_Vacia AS ExtTelefonoAV,
                Cadena_Vacia AS FaxAV,              Cadena_Vacia AS TipoClienteAV,      Cadena_Vacia AS EdoExtranjeroAV,        Cadena_Vacia AS PaisAV,                 MAX(Cre.CreditoID),                 Cre.MontoCredito AS CredMaxUti,
                DATE_FORMAT(MAX(Cre.FechTraspasVenc),'%d%m%Y') AS FechIngCarVen,   Entero_Cero AS InteresCred, Cadena_Vacia AS CadenaAvales, Cadena_Vacia AS IdentificaTS,       Cadena_Vacia AS NumReportes,
                Cadena_Vacia AS TotalSaldos,        Cre.SolicitudCreditoID,             Cadena_Vacia AS CadenaDirectivo,        Entero_Cero AS NumAccionistas,          Cadena_Vacia,
                CASE  WHEN MAX(Cre.FechTerminacion) != Fecha_Vacia AND  MAX(Cre.FechTerminacion) <= Par_FechaCorteBC THEN   MAX(Cre.FechTerminacion)    ELSE  IFNULL(MAX(Det.FechaPago),MAX(Cre.FechaInicio))   END,
                Cre.FechTraspasVenc
        FROM CREDITOS Cre
            LEFT  JOIN DETALLEPAGCRE    Det     ON  Cre.CreditoID = Det.CreditoID  AND Det.FechaPago <= Var_FechaFin
            INNER JOIN PRODUCTOSCREDITO Pro     ON  Cre.ProductoCreditoID = Pro.ProducCreditoID
            LEFT  JOIN EQU_CREDITOS     EqC     ON  Det.CreditoID = EqC.CreditoIDSAFI
            INNER JOIN CREDITOSPLAZOS   Pla     ON  Pla.PlazoID = Cre.PlazoID
            INNER JOIN MONEDAS          Mon     ON  Mon.MonedaID = Cre.MonedaID
            INNER JOIN CLIENTES         Cli     ON  Cre.ClienteID = Cli.ClienteID
            INNER JOIN DIRECCLIENTE     Dir     ON  Cre.ClienteID = Dir.ClienteID   AND Dir.Oficial = Si
            INNER JOIN ESTADOSREPUB     Est     ON  Dir.EstadoID = Est.EstadoID
            INNER JOIN ACTIVIDADESBMX   Act     ON  Cli.ActividadBancoMX = Act.ActividadBMXID
            INNER JOIN PAISES           Pai     ON  Pai.PaisID  =Cli.PaisResidencia AND Pai.PaisID=Cli.PaisResidencia
            INNER JOIN MUNICIPIOSREPUB  Mun     ON  Dir.EstadoID = Mun.EstadoID     AND Dir.MunicipioID =Mun.MunicipioID
            INNER JOIN COLONIASREPUB    Col     ON  Dir.EstadoID = Col.EstadoID     AND Dir.MunicipioID = Col.MunicipioID
                                                                                    AND Dir.ColoniaID   = Col.ColoniaID
        WHERE  Cli.TipoPersona IN (PersonaMoral,PersonaFCAE ) AND Cre.Estatus IN(Vigente,Vencido,Castigado,Pagado)
        AND Cre.FechaInicio <= Var_FechaFin
            AND (Cre.FechTerminacion BETWEEN Var_FechaInicial AND Var_FechaFin
                    OR Cre.FechTerminacion = Fecha_Vacia    )
        GROUP BY  Cre.CreditoID ORDER BY ClienteID;
    END IF;


    UPDATE TMPDATOSEM SET ApePaterno=ApeMaterno, ApeMaterno=NULL
        WHERE (ApePaterno IS NULL OR ApePaterno='') AND ApeMaterno <> '';

    UPDATE TMPDATOSEM SET ApeMaterno='NO PROPORCIONADO'
        WHERE ApeMaterno IS NULL OR ApeMaterno='';

    #Avales Tabla
    DROP TABLE IF EXISTS TMPAVALESLISTA;
    CREATE TABLE TMPAVALESLISTA(
        SolCred             VARCHAR(30),    CredID              VARCHAR(30),    IdentificaAV        CHAR(2),        RFCAV               VARCHAR(13),   CURPAV        VARCHAR(18),
        NumDunAV            VARCHAR(10),    CompaniaAV          VARCHAR(75),    PrimerNombreAV      VARCHAR(75),    SegundoNombreAV     VARCHAR(75),   ApePaternoAV  VARCHAR(25),
        ApeMaternoAV        VARCHAR(25),    PriLinDireccionAV   VARCHAR(40),    SegLinDireccionAV   VARCHAR(40),    ColoniaAV           VARCHAR(60),   MunicipioAV   VARCHAR(40),
        CiudadAV            VARCHAR(40),    EstadoAV            VARCHAR(4),     CPAV                VARCHAR(10),    TelefonoAV          VARCHAR(11),   ExtTelefonoAV VARCHAR(8),
        FaxAV               VARCHAR(11),    TipoClienteAV       VARCHAR(1),     EdoExtranjeroAV     VARCHAR(40),    PaisAV              CHAR(2),       CadenaAval    TEXT,
        NumAvales           INT(11),        ClienteID           INT(11),        AvalID              INT(11),        ProspectoID         INT(11),       CicloAvID     INT(11),
    INDEX TMPAVALESLISTA1 (SolCred),
    INDEX TMPAVALESLISTA2 (CredID),
    INDEX TMPAVALESLISTA3 (CicloAvID)
    );

    -- Tabla de Directivos
    DROP TABLE IF EXISTS TMPDIRECTIVOSLISTA;
    CREATE TABLE TMPDIRECTIVOSLISTA(
        ClienteID           INT(11),        CreditoID           BIGINT(12),     IdentificaAC        CHAR(2),
        RFCAC               VARCHAR(13),    CURPAC              VARCHAR(18),    NumDunAC            VARCHAR(10),   CompaniaAC          VARCHAR(75),
        PrimerNombreAC      VARCHAR(75),    SegundoNombreAC     VARCHAR(75),    ApePaternoAC        VARCHAR(25),   ApeMaternoAC        VARCHAR(25),
        PorcentajeAC        INT(2),         PriLinDireccionAC   VARCHAR(40),    SegLinDireccionAC   VARCHAR(40),   ColoniaAC           VARCHAR(60),
        MunicipioAC         VARCHAR(40),    CiudadAC            VARCHAR(40),    EstadoAC            VARCHAR(4),    CPAC                VARCHAR(10),
        TelefonoAC          VARCHAR(11),    ExtTelefonoAC       VARCHAR(8),     FaxAC               VARCHAR(11),   TipoClienteAC       VARCHAR(1),
        EdoExtranjeroAC     VARCHAR(40),    PaisAC              CHAR(2),        CadenaAccionista    TEXT,
        NumDirectivos       INT(11),        RelacionadoID       INT(11),        TipoRelacionado     CHAR(1),       DirectivoID         INT(11),
        CicloAcID           INT(11),
    INDEX TMPDIRECTIVOSLISTA1 (ClienteID),
    INDEX TMPDIRECTIVOSLISTA2 (CreditoID),
    INDEX TMPDIRECTIVOSLISTA3 (CicloAcID));

    SELECT ReportarTotalIntegrantes
    INTO Var_ReportarTotalIntegrantes
    FROM PARAMETROSSIS
    LIMIT 1;

    SET Var_ReportarTotalIntegrantes := IFNULL(Var_ReportarTotalIntegrantes, Con_NO);

    IF( Var_ReportarTotalIntegrantes = Con_NO) THEN

        SET Var_Contador := 1;
        SELECT MAX(ID)
        INTO Var_MaxRegistroID
        FROM TMPDATOSEM;

        WHILE ( Var_Contador <= Var_MaxRegistroID ) DO

            SELECT  SolicitudCreditoID,     ClienteID,      CreditoID
            INTO    Var_SolicitudCreditoID, Var_ClienteID,  Var_CreditoID
            FROM TMPDATOSEM
            WHERE ID = Var_Contador;

            -- Se insertan IDS de clientes y avales
            INSERT INTO TMPDIRECTIVOSLISTA(
                    ClienteID,          CreditoID,       IdentificaAC,  RelacionadoID,  TipoRelacionado,   DirectivoID,
                    CURPAC,             NumDunAC,        CiudadAC,      FaxAC,          EdoExtranjeroAC,   PaisAC,
                    CadenaAccionista,   NumDirectivos,   PorcentajeAC)
            SELECT  Var_ClienteID,   Var_CreditoID,   Etiqueta_AC,
                    CASE WHEN Dir.RelacionadoID > Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion = Dir.Entero_Cero THEN Dir.RelacionadoID
                         WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion > Entero_Cero AND Dir.AvalRelacion = Dir.Entero_Cero THEN Dir.GaranteRelacion
                         WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion > Dir.Entero_Cero THEN Dir.AvalRelacion
                         WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion = Dir.Entero_Cero THEN Dir.DirectivoID
                         ELSE Entero_Cero
                    END AS RelacionadoID,
                    CASE WHEN Dir.RelacionadoID > Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion = Entero_Cero THEN Con_TipoCliente
                         WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion > Entero_Cero AND Dir.AvalRelacion = Entero_Cero THEN Con_TipoGarante
                         WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion > Entero_Cero THEN Con_TipoAval
                         WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion = Entero_Cero THEN Con_TipoDirectivo
                         ELSE Cadena_Vacia
                    END AS TipoRelacionado,
                    Dir.DirectivoID, Cadena_Vacia
                   Cadena_Vacia,    Cadena_Vacia,    Cadena_Vacia,  Cadena_Vacia,   Cadena_Vacia,      'MX',
                   Cadena_Vacia,    Entero_Cero,    CEIL(PorcentajeAcciones)
            FROM DIRECTIVOS Dir
            WHERE Dir.ClienteID = Var_ClienteID AND Dir.EsAccionista = Con_SI
            LIMIT 1;


            -- Se insertan IDS de clientes y avales
            INSERT INTO TMPAVALESLISTA(
                SolCred,     CredID,       IdentificaAV,       ClienteID,           AvalID,    ProspectoID,
                CURPAV,      NumDunAV,      CiudadAV,           FaxAV,               EdoExtranjeroAV,   PaisAV,
                CadenaAval,  NumAvales)
            SELECT Ava.SolicitudCreditoID,  Var_CreditoID,      Etiqueta_AV,       Ava.ClienteID,  Ava.AvalID,     Ava.ProspectoID,
                   Cadena_Vacia,    Cadena_Vacia,     Cadena_Vacia, Cadena_Vacia,   Cadena_Vacia,    'MX',
                   Cadena_Vacia,    Entero_Cero
            FROM AVALESPORSOLICI Ava
            INNER JOIN AVALES Aval ON Ava.AvalID = Aval.AvalID
            WHERE Ava.SolicitudCreditoID = Var_SolicitudCreditoID AND Ava.Estatus = 'U'
              AND Aval.TipoPersona <> 'F'
            UNION ALL
            (SELECT Ava.SolicitudCreditoID,  Var_CreditoID,      Etiqueta_AV,       Ava.ClienteID,  Ava.AvalID,     Ava.ProspectoID,
                   Cadena_Vacia,    Cadena_Vacia,     Cadena_Vacia, Cadena_Vacia,   Cadena_Vacia,    'MX',
                   Cadena_Vacia,    Entero_Cero
            FROM AVALESPORSOLICI Ava
            INNER JOIN PROSPECTOS Cli ON Ava.ProspectoID = Cli.ProspectoID
            WHERE Ava.SolicitudCreditoID = Var_SolicitudCreditoID AND Ava.Estatus = 'U'
              AND Cli.TipoPersona <> 'F')
            UNION ALL
            (SELECT Ava.SolicitudCreditoID,  Var_CreditoID,      Etiqueta_AV,       Ava.ClienteID,  Ava.AvalID,     Ava.ProspectoID,
                   Cadena_Vacia,    Cadena_Vacia,     Cadena_Vacia, Cadena_Vacia,   Cadena_Vacia,    'MX',
                   Cadena_Vacia,    Entero_Cero
            FROM AVALESPORSOLICI Ava
            INNER JOIN CLIENTES Cli ON Ava.ClienteID = Cli.ClienteID
            WHERE Ava.SolicitudCreditoID = Var_SolicitudCreditoID AND Ava.Estatus = 'U'
            AND Cli.TipoPersona <> 'F')
            LIMIT 1;

            SET Var_Contador := Var_Contador + 1;
            SET Var_SolicitudCreditoID := Entero_Cero;
            SET Var_ClienteID := Entero_Cero;
            SET Var_CreditoID := Entero_Cero;

        END WHILE;

        SET Var_Contador := Entero_Cero;
    ELSE
        -- Se insertan IDS de clientes y avales
        INSERT INTO TMPDIRECTIVOSLISTA(
            ClienteID,          CreditoID,       IdentificaAC,  RelacionadoID,  TipoRelacionado,   DirectivoID,
            CURPAC,             NumDunAC,        CiudadAC,      FaxAC,          EdoExtranjeroAC,   PaisAC,
            CadenaAccionista,   NumDirectivos,   PorcentajeAC)
        SELECT  Tmp.ClienteID,   Tmp.CreditoID,   Etiqueta_AC,
                CASE WHEN Dir.RelacionadoID > Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion = Entero_Cero THEN Dir.RelacionadoID
                     WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion > Entero_Cero AND Dir.AvalRelacion = Entero_Cero THEN Dir.GaranteRelacion
                     WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion > Entero_Cero THEN Dir.AvalRelacion
                     WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion = Entero_Cero THEN Dir.DirectivoID
                     ELSE Entero_Cero
                END AS RelacionadoID,
                CASE WHEN Dir.RelacionadoID > Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion = Entero_Cero THEN Con_TipoCliente
                     WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion > Entero_Cero AND Dir.AvalRelacion = Entero_Cero THEN Con_TipoGarante
                     WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion > Entero_Cero THEN Con_TipoAval
                     WHEN Dir.RelacionadoID = Entero_Cero AND Dir.GaranteRelacion = Entero_Cero AND Dir.AvalRelacion = Entero_Cero THEN Con_TipoDirectivo
                     ELSE Cadena_Vacia
                END AS TipoRelacionado,
                Dir.DirectivoID, Cadena_Vacia
               Cadena_Vacia,    Cadena_Vacia,    Cadena_Vacia,  Cadena_Vacia,   Cadena_Vacia,      'MX',
               Cadena_Vacia,    Entero_Cero,    CEIL(PorcentajeAcciones)
        FROM DIRECTIVOS Dir
        INNER JOIN TMPDATOSEM Tmp ON Dir.ClienteID = Tmp.ClienteID
        WHERE Dir.EsAccionista = Con_SI;


        -- Se insertan IDS de clientes y avales
        INSERT INTO TMPAVALESLISTA(
            SolCred,     CredID,       IdentificaAV,       ClienteID,           AvalID,    ProspectoID,
            CURPAV,      NumDunAV,      CiudadAV,           FaxAV,               EdoExtranjeroAV,   PaisAV,
            CadenaAval,  NumAvales)
        SELECT Ava.SolicitudCreditoID,  TMP.CreditoID,      Etiqueta_AV,       Ava.ClienteID,  Ava.AvalID,     Ava.ProspectoID,
               Cadena_Vacia,    Cadena_Vacia,     Cadena_Vacia, Cadena_Vacia,   Cadena_Vacia,    'MX',
               Cadena_Vacia,    Entero_Cero
        FROM AVALESPORSOLICI Ava
        INNER JOIN TMPDATOSEM TMP ON TMP.SolicitudCreditoID = Ava.SolicitudCreditoID
          AND Ava.Estatus = 'U';

    END IF;

    -- ACTUALIZAN datos para  avales
    UPDATE TMPAVALESLISTA TMP
        INNER JOIN AVALES Val ON Val.AvalID=TMP.AvalID
        INNER JOIN ESTADOSREPUB Est ON Val.EstadoID = Est.EstadoID
        INNER JOIN MUNICIPIOSREPUB Mun ON Val.MunicipioID = Mun.MunicipioID AND Val.EstadoID = Mun.EstadoID
        INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Val.MunicipioID AND Loc.EstadoID=Val.EstadoID AND Loc.LocalidadID=Val.LocalidadID
    SET
        RFCAV             = IF(Val.TipoPersona = "A",Val.RFC, Val.RFCpm),
        CompaniaAV        = FNLIMPIACARACTBUROCRED(Val.RazonSocial,'A'),
        PrimerNombreAV    = UPPER(REPLACE(Val.PrimerNombre,'Ñ','N')),
        SegundoNombreAV   = UPPER(REPLACE(Val.SegundoNombre,'Ñ','N')),
        ApePaternoAV      = UPPER(REPLACE(Val.ApellidoPaterno,'Ñ','N')),

        ApeMaternoAV      = UPPER(REPLACE(Val.ApellidoMaterno,'Ñ','N')),
        PriLinDireccionAV = UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Val.Calle,''),' ',
                            COALESCE(Val.NumExterior,''),' ',
                            COALESCE(Val.NumInterior,''),' ',COALESCE(Val.Manzana,''),' ',COALESCE(Val.Lote,'')),',',''),1,40)),
        SegLinDireccionAV = UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Val.Calle,''),' ',
                            COALESCE(Val.NumExterior,''),' ',
                            COALESCE(Val.NumInterior,''),' ',COALESCE(Val.Manzana,''),' ',COALESCE(Val.Lote,'')),',',''),41,40)),
        ColoniaAV         = UPPER(SUBSTRING(REPLACE(Val.Colonia,',',''),1,60)),
        MunicipioAV       = UPPER(Mun.Nombre),

        EstadoAV          = UPPER(Est.EqBuroCred),
        CPAV              = Val.CP,
        TelefonoAV        = Val.TelefonoCel,
        ExtTelefonoAV     = Val.ExtTelefonoPart,
        TipoClienteAV     = CASE WHEN Val.TipoPersona = 'A' THEN '2' ELSE '1' END ;

    -- Se actualizan los datos de Directivos de Tipo Cliente
    UPDATE TMPDIRECTIVOSLISTA Tmp
    INNER JOIN CLIENTES Cli ON Cli.ClienteID = Tmp.RelacionadoID
    INNER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND IFNULL(Dir.Oficial, 'N') = Con_SI
    LEFT JOIN COLONIASREPUB Col ON Col.ColoniaID = Dir.ColoniaID  AND Dir.MunicipioID = Col.MunicipioID AND Dir.EstadoID = Col.EstadoID
    LEFT JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Dir.LocalidadID  AND Dir.MunicipioID = Loc.MunicipioID AND Dir.EstadoID = Loc.EstadoID
    LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
    LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Dir.EstadoID SET
        RFCAC             = UPPER(Cli.RFCOficial),
        CURPAC            = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN  CURP
                                     ELSE Cadena_Vacia
                                END),
        CompaniaAC        = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN
                                         CASE WHEN Cli.RazonSocial REGEXP ExpresionRegular THEN Cli.RazonSocial
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.RazonSocial,LimpiaAlfaNumerico) END
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN  Cadena_Vacia
                                     ELSE Cadena_Vacia
                                END),
        PrimerNombreAC    = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.PrimerNombre REGEXP ExpresionRegular THEN Cli.PrimerNombre
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.PrimerNombre,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        SegundoNombreAC    = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.SegundoNombre REGEXP ExpresionRegular THEN Cli.SegundoNombre
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.SegundoNombre,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        ApePaternoAC       = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.ApellidoPaterno REGEXP ExpresionRegular THEN Cli.ApellidoPaterno
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.ApellidoPaterno,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                            END),
        ApeMaternoAC       = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.ApellidoMaterno REGEXP ExpresionRegular THEN Cli.ApellidoMaterno
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.ApellidoMaterno,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        TelefonoAC        = CASE WHEN IFNULL(Cli.Telefono, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(Cli.TelefonoCelular, Cadena_Vacia)  = Cadena_Vacia THEN IFNULL(Cli.Telefono, Cadena_Vacia)
                                 WHEN IFNULL(Cli.Telefono, Cadena_Vacia)  = Cadena_Vacia AND IFNULL(Cli.TelefonoCelular, Cadena_Vacia) <> Cadena_Vacia THEN IFNULL(Cli.TelefonoCelular, Cadena_Vacia)
                                 ELSE Cadena_Vacia
                            END ,
        ExtTelefonoAC     = Cli.ExtTelefonoPart,
        TipoClienteAC     = CASE WHEN Cli.TipoPersona IN( 'F', 'A' ) THEN '2' ELSE '1' END,
        PriLinDireccionAC = UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Dir.Calle,''),' ',
                            COALESCE(Dir.NumeroCasa,''),' ',
                            COALESCE(Dir.NumInterior,''),' ',COALESCE(Dir.Manzana,''),' ',COALESCE(Dir.Lote,'')),',',''),1,40)),
        SegLinDireccionAC = UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Dir.Calle,''),' ',
                            COALESCE(Dir.NumeroCasa,''),' ',
                            COALESCE(Dir.NumInterior,''),' ',COALESCE(Dir.Manzana,''),' ',COALESCE(Dir.Lote,'')),',',''),1,40)),
        ColoniaAC         = UPPER(SUBSTRING(REPLACE(Col.Asentamiento,',',''),1,60)),
        CiudadAC          = Cadena_Vacia,
        PriLinDireccionAC = CASE WHEN Tmp.PriLinDireccionAC REGEXP ExpresionRegular THEN Tmp.PriLinDireccionAC
                                 ELSE FNLIMPIACARACTBUROCRED(Tmp.PriLinDireccionAC,LimpiaAlfaNumerico)
                            END,
        SegLinDireccionAC = CASE WHEN Tmp.SegLinDireccionAC REGEXP ExpresionRegular THEN Tmp.SegLinDireccionAC
                                 ELSE FNLIMPIACARACTBUROCRED(Tmp.SegLinDireccionAC,LimpiaAlfaNumerico)
                            END,
        ColoniaAC         = CASE WHEN Tmp.ColoniaAC REGEXP ExpresionRegular THEN Tmp.ColoniaAC
                                 ELSE FNLIMPIACARACTBUROCRED(Tmp.ColoniaAC,LimpiaAlfaNumerico)
                            END,
        CiudadAC          = CASE WHEN Tmp.CiudadAC REGEXP ExpresionRegular THEN  SUBSTRING(Tmp.CiudadAC,1,40)
                                 ELSE FNLIMPIACARACTBUROCRED( SUBSTRING(REPLACE(IFNULL(Tmp.CiudadAC, Cadena_Vacia),',',''),1,40),LimpiaAlfaNumerico)
                            END,
        MunicipioAC          = UPPER(CASE WHEN Mun.Nombre REGEXP ExpresionRegular THEN  SUBSTRING(Mun.Nombre,1,60)
                                 ELSE FNLIMPIACARACTBUROCRED( SUBSTRING(REPLACE(IFNULL(Mun.Nombre, Cadena_Vacia),',',''),1,60),LimpiaAlfaNumerico)
                            END),
        EstadoAC          = UPPER(Est.EqBuroCred),
        CPAC              = Dir.CP
    WHERE TipoRelacionado = Con_TipoCliente;

    -- Se actualizan los datos de Directivos de Tipo Garante
    UPDATE TMPDIRECTIVOSLISTA Tmp
    INNER JOIN GARANTES Cli ON Cli.GaranteID = Tmp.RelacionadoID
    LEFT JOIN COLONIASREPUB Col ON Col.ColoniaID = Cli.ColoniaID  AND Cli.MunicipioID = Col.MunicipioID AND Cli.EstadoID = Col.EstadoID
    LEFT JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Cli.LocalidadID  AND Cli.MunicipioID = Loc.MunicipioID AND Cli.EstadoID = Loc.EstadoID
    LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Cli.EstadoID AND Mun.MunicipioID = Cli.MunicipioID
    LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Cli.EstadoID SET
        RFCAC             = UPPER(Cli.RFCOficial),
        CURPAC            = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN  CURP
                                     ELSE Cadena_Vacia
                                END),
        CompaniaAC        = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN
                                         CASE WHEN Cli.RazonSocial REGEXP ExpresionRegular THEN Cli.RazonSocial
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.RazonSocial,LimpiaAlfaNumerico) END
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN  Cadena_Vacia
                                     ELSE Cadena_Vacia
                                END),
        PrimerNombreAC    = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.PrimerNombre REGEXP ExpresionRegular THEN Cli.PrimerNombre
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.PrimerNombre,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        SegundoNombreAC    = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.SegundoNombre REGEXP ExpresionRegular THEN Cli.SegundoNombre
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.SegundoNombre,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        ApePaternoAC       = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.ApellidoPaterno REGEXP ExpresionRegular THEN Cli.ApellidoPaterno
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.ApellidoPaterno,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                            END),
        ApeMaternoAC       = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.ApellidoMaterno REGEXP ExpresionRegular THEN Cli.ApellidoMaterno
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.ApellidoMaterno,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        TelefonoAC        = Cli.TelefonoCelular,
        ExtTelefonoAC     = Cli.ExtTelefonoPart,
        TipoClienteAC     = CASE WHEN Cli.TipoPersona IN( 'F', 'A' ) THEN '2' ELSE '1' END,
        PriLinDireccionAC = UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Cli.Calle,''),' ',
                            COALESCE(Cli.NumeroCasa,''),' ',
                            COALESCE(Cli.NumInterior,''),' ',COALESCE(Cli.Manzana,''),' ',COALESCE(Cli.Lote,'')),',',''),1,40)),
        SegLinDireccionAC = UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Cli.Calle,''),' ',
                            COALESCE(Cli.NumeroCasa,''),' ',
                            COALESCE(Cli.NumInterior,''),' ',COALESCE(Cli.Manzana,''),' ',COALESCE(Cli.Lote,'')),',',''),1,40)),
        ColoniaAC         = UPPER(SUBSTRING(REPLACE(Col.Asentamiento,',',''),1,60)),
        CiudadAC          = Cadena_Vacia,
        PriLinDireccionAC = CASE WHEN Tmp.PriLinDireccionAC REGEXP ExpresionRegular THEN Tmp.PriLinDireccionAC
                                 ELSE FNLIMPIACARACTBUROCRED(Tmp.PriLinDireccionAC,LimpiaAlfaNumerico)
                            END,
        SegLinDireccionAC = CASE WHEN Tmp.SegLinDireccionAC REGEXP ExpresionRegular THEN Tmp.SegLinDireccionAC
                                 ELSE FNLIMPIACARACTBUROCRED(Tmp.SegLinDireccionAC,LimpiaAlfaNumerico)
                            END,
        ColoniaAC         = CASE WHEN Tmp.ColoniaAC REGEXP ExpresionRegular THEN Tmp.ColoniaAC
                                 ELSE FNLIMPIACARACTBUROCRED(Tmp.ColoniaAC,LimpiaAlfaNumerico)
                            END,
        CiudadAC          = CASE WHEN Tmp.CiudadAC REGEXP ExpresionRegular THEN  SUBSTRING(Tmp.CiudadAC,1,40)
                                 ELSE FNLIMPIACARACTBUROCRED( SUBSTRING(REPLACE(IFNULL(Tmp.CiudadAC, Cadena_Vacia),',',''),1,40),LimpiaAlfaNumerico)
                            END,
        MunicipioAC          = UPPER(CASE WHEN Mun.Nombre REGEXP ExpresionRegular THEN  SUBSTRING(Mun.Nombre,1,60)
                                 ELSE FNLIMPIACARACTBUROCRED( SUBSTRING(REPLACE(IFNULL(Mun.Nombre, Cadena_Vacia),',',''),1,60),LimpiaAlfaNumerico)
                            END),
        EstadoAC          = UPPER(Est.EqBuroCred),
        CPAC              = Cli.CP
    WHERE TipoRelacionado = Con_TipoGarante;

    -- Se actualizan los datos de Directivos de Tipo Aval
    UPDATE TMPDIRECTIVOSLISTA Tmp
    INNER JOIN AVALES Cli ON Cli.AvalID = Tmp.RelacionadoID
    LEFT JOIN COLONIASREPUB Col ON Col.ColoniaID = Cli.ColoniaID  AND Cli.MunicipioID = Col.MunicipioID AND Cli.EstadoID = Col.EstadoID
    LEFT JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Cli.LocalidadID  AND Cli.MunicipioID = Loc.MunicipioID AND Cli.EstadoID = Loc.EstadoID
    LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Cli.EstadoID AND Mun.MunicipioID = Cli.MunicipioID
    LEFT JOIN ESTADOSREPUB Est ON Est.EstadoID = Cli.EstadoID SET
        RFCAC             = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN IFNULL(RFCpm, Cadena_Vacia)
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN  IFNULL(RFC, Cadena_Vacia)
                                     ELSE Cadena_Vacia
                                END),
        CURPAC            = Cadena_Vacia,
        CompaniaAC        = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN
                                         CASE WHEN IFNULL(Cli.RazonSocial, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Cli.RazonSocial, Cadena_Vacia)
                                              ELSE FNLIMPIACARACTBUROCRED(IFNULL(Cli.RazonSocial, Cadena_Vacia),LimpiaAlfaNumerico) END
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN  Cadena_Vacia
                                     ELSE Cadena_Vacia
                                END),
        PrimerNombreAC    = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN IFNULL(Cli.PrimerNombre, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Cli.PrimerNombre, Cadena_Vacia)
                                              ELSE FNLIMPIACARACTBUROCRED(IFNULL(Cli.PrimerNombre, Cadena_Vacia),LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        SegundoNombreAC    = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Cli.SegundoNombre, Cadena_Vacia)
                                              ELSE FNLIMPIACARACTBUROCRED(IFNULL(Cli.SegundoNombre, Cadena_Vacia),LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        ApePaternoAC       = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN IFNULL(Cli.ApellidoPaterno, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Cli.ApellidoPaterno, Cadena_Vacia)
                                              ELSE FNLIMPIACARACTBUROCRED(IFNULL(Cli.ApellidoPaterno, Cadena_Vacia),LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                            END),
        ApeMaternoAC       = UPPER(
                                CASE WHEN TipoPersona = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoPersona IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN IFNULL(Cli.ApellidoMaterno, Cadena_Vacia) REGEXP ExpresionRegular THEN IFNULL(Cli.ApellidoMaterno, Cadena_Vacia)
                                              ELSE FNLIMPIACARACTBUROCRED(IFNULL(Cli.ApellidoMaterno, Cadena_Vacia),LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        TelefonoAC        = CASE WHEN IFNULL(Cli.Telefono, Cadena_Vacia) <> Cadena_Vacia AND IFNULL(Cli.TelefonoCel, Cadena_Vacia)  = Cadena_Vacia THEN IFNULL(Cli.Telefono, Cadena_Vacia)
                                 WHEN IFNULL(Cli.Telefono, Cadena_Vacia)  = Cadena_Vacia AND IFNULL(Cli.TelefonoCel, Cadena_Vacia) <> Cadena_Vacia THEN IFNULL(Cli.TelefonoCel, Cadena_Vacia)
                                 ELSE Cadena_Vacia
                            END ,
        ExtTelefonoAC     = IFNULL(Cli.ExtTelefonoPart, Cadena_Vacia),
        TipoClienteAC     = CASE WHEN Cli.TipoPersona IN( 'F', 'A' ) THEN '2' ELSE '1' END,
        PriLinDireccionAC = UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Cli.Calle,''),' ',
                            COALESCE(Cli.NumExterior,''),' ',
                            COALESCE(Cli.NumInterior,''),' ',COALESCE(Cli.Manzana,''),' ',COALESCE(Cli.Lote,'')),',',''),1,40)),
        SegLinDireccionAC = UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Cli.Calle,''),' ',
                            COALESCE(Cli.NumExterior,''),' ',
                            COALESCE(Cli.NumInterior,''),' ',COALESCE(Cli.Manzana,''),' ',COALESCE(Cli.Lote,'')),',',''),1,40)),
        ColoniaAC         = UPPER(SUBSTRING(REPLACE(IFNULL(Col.Asentamiento, Cadena_Vacia),',',''),1,60)),
        CiudadAC          = Cadena_Vacia,
        PriLinDireccionAC = CASE WHEN Tmp.PriLinDireccionAC REGEXP ExpresionRegular THEN Tmp.PriLinDireccionAC
                                 ELSE FNLIMPIACARACTBUROCRED(Tmp.PriLinDireccionAC,LimpiaAlfaNumerico)
                            END,
        SegLinDireccionAC = CASE WHEN Tmp.SegLinDireccionAC REGEXP ExpresionRegular THEN Tmp.SegLinDireccionAC
                                 ELSE FNLIMPIACARACTBUROCRED(Tmp.SegLinDireccionAC,LimpiaAlfaNumerico)
                            END,
        ColoniaAC         = CASE WHEN Tmp.ColoniaAC REGEXP ExpresionRegular THEN Tmp.ColoniaAC
                                 ELSE FNLIMPIACARACTBUROCRED(Tmp.ColoniaAC,LimpiaAlfaNumerico)
                            END,
        CiudadAC          = CASE WHEN Tmp.CiudadAC REGEXP ExpresionRegular THEN  SUBSTRING(Tmp.CiudadAC,1,40)
                                 ELSE FNLIMPIACARACTBUROCRED( SUBSTRING(REPLACE(IFNULL(Tmp.CiudadAC, Cadena_Vacia),',',''),1,40),LimpiaAlfaNumerico)
                            END,
        MunicipioAC          = UPPER(CASE WHEN Mun.Nombre REGEXP ExpresionRegular THEN  SUBSTRING(Mun.Nombre,1,60)
                                 ELSE FNLIMPIACARACTBUROCRED( SUBSTRING(REPLACE(IFNULL(Mun.Nombre, Cadena_Vacia),',',''),1,60),LimpiaAlfaNumerico)
                            END),
        EstadoAC          = UPPER(Est.EqBuroCred),
        CPAC              = Cli.CP
    WHERE TipoRelacionado = Con_TipoAval;

    -- Se actualizan los datos de Directivos de Tipo Directivo
    UPDATE TMPDIRECTIVOSLISTA Tmp
    INNER JOIN DIRECTIVOS Cli ON Cli.DirectivoID = Tmp.DirectivoID
    LEFT JOIN COLONIASREPUB Col ON Cli.EdoNacimiento = Col.EstadoID AND Cli.MunNacimiento = Col.MunicipioID AND Cli.ColoniaID = Col.ColoniaID
    LEFT JOIN MUNICIPIOSREPUB Mun ON Cli.EdoNacimiento  = Mun.EstadoID AND  Cli.MunNacimiento = Mun.MunicipioID
    LEFT JOIN ESTADOSREPUB Est ON Cli.EdoNacimiento = Est.EstadoID SET
        RFCAC             = UPPER(Cli.RFC),
        CURPAC            = UPPER(
                                CASE WHEN TipoAccionista = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoAccionista IN (PersonaFCAE, 'F' ) THEN  CURP
                                     ELSE Cadena_Vacia
                                END),
        CompaniaAC        = UPPER(
                                CASE WHEN TipoAccionista = PersonaMoral THEN
                                         CASE WHEN Cli.NombreCompania REGEXP ExpresionRegular THEN Cli.NombreCompania
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.NombreCompania,LimpiaAlfaNumerico) END
                                     WHEN TipoAccionista IN (PersonaFCAE, 'F' ) THEN  Cadena_Vacia
                                     ELSE Cadena_Vacia
                                END),
        PrimerNombreAC    = UPPER(
                                CASE WHEN TipoAccionista = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoAccionista IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.PrimerNombre REGEXP ExpresionRegular THEN Cli.PrimerNombre
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.PrimerNombre,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        SegundoNombreAC    = UPPER(
                                CASE WHEN TipoAccionista = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoAccionista IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.SegundoNombre REGEXP ExpresionRegular THEN Cli.SegundoNombre
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.SegundoNombre,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        ApePaternoAC       = UPPER(
                                CASE WHEN TipoAccionista = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoAccionista IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.ApellidoPaterno REGEXP ExpresionRegular THEN Cli.ApellidoPaterno
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.ApellidoPaterno,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        ApeMaternoAC       = UPPER(
                                CASE WHEN TipoAccionista = PersonaMoral THEN Cadena_Vacia
                                     WHEN TipoAccionista IN (PersonaFCAE, 'F' ) THEN
                                         CASE WHEN Cli.ApellidoMaterno REGEXP ExpresionRegular THEN Cli.ApellidoMaterno
                                              ELSE FNLIMPIACARACTBUROCRED(Cli.ApellidoMaterno,LimpiaAlfaNumerico) END
                                     ELSE Cadena_Vacia
                                END),
        TelefonoAC        = Cli.TelefonoCelular,
        ExtTelefonoAC     = Cli.ExtTelefonoPart,
        TipoClienteAC     = CASE WHEN Cli.TipoAccionista IN( 'F', 'A' ) THEN '2' ELSE '1' END,

        PriLinDireccionAC = UPPER(
                                CASE WHEN Cli.Direccion1 REGEXP ExpresionRegular THEN SUBSTRING(Cli.Direccion1,1,40)
                                     ELSE FNLIMPIACARACTBUROCRED(SUBSTRING(Cli.Direccion1,1,40),LimpiaAlfaNumerico) END),
        SegLinDireccionAC = UPPER(
                                CASE WHEN Cli.Direccion2 REGEXP ExpresionRegular THEN SUBSTRING(Cli.Direccion2,1,40)
                                     ELSE FNLIMPIACARACTBUROCRED(SUBSTRING(Cli.Direccion2,1,40),LimpiaAlfaNumerico) END),

        ColoniaAC         = UPPER(
                                CASE WHEN IFNULL(Col.Asentamiento, Cadena_Vacia) REGEXP ExpresionRegular THEN SUBSTRING(REPLACE(IFNULL(Col.Asentamiento, Cadena_Vacia),',',''),1,60)
                                     ELSE FNLIMPIACARACTBUROCRED(SUBSTRING(REPLACE(IFNULL(Col.Asentamiento, Cadena_Vacia),',',''),1,60),LimpiaAlfaNumerico) END),
        MunicipioAC       = UPPER(
                                CASE WHEN Mun.Nombre REGEXP ExpresionRegular THEN  SUBSTRING(Mun.Nombre,1,60)
                                     ELSE FNLIMPIACARACTBUROCRED( SUBSTRING(REPLACE(IFNULL(Mun.Nombre, Cadena_Vacia),',',''),1,60),LimpiaAlfaNumerico)
                                END),
        EstadoAC          = UPPER(Est.EqBuroCred),
        CPAC              = Cli.CodigoPostal,
        CiudadAC          = Cadena_Vacia,
        EdoExtranjeroAC   = UPPER(
                                CASE WHEN IFNULL(Cli.EdoExtranjero, Cadena_Vacia) REGEXP ExpresionRegular THEN SUBSTRING(REPLACE(IFNULL(Cli.EdoExtranjero, Cadena_Vacia),',',''),1,60)
                                     ELSE FNLIMPIACARACTBUROCRED(SUBSTRING(REPLACE(IFNULL(Cli.EdoExtranjero, Cadena_Vacia),',',''),1,60),LimpiaAlfaNumerico) END)
    WHERE TipoRelacionado = Con_TipoDirectivo;

    DELETE TMP FROM  TMPAVALESLISTA TMP
        INNER JOIN AVALES Val ON Val.AvalID=TMP.AvalID
        WHERE  Val.TipoPersona='F';

    -- ACTUALIZAN datos para Clientes

    UPDATE TMPAVALESLISTA TMP
        INNER JOIN CLIENTES Cli ON Cli.ClienteID=TMP.ClienteID
        INNER JOIN DIRECCLIENTE     Dir     ON  Cli.ClienteID = Dir.ClienteID   AND Dir.Oficial = 'S'
        INNER JOIN ESTADOSREPUB Est ON Dir.EstadoID = Est.EstadoID
        INNER JOIN MUNICIPIOSREPUB Mun ON Dir.MunicipioID = Mun.MunicipioID AND Dir.EstadoID = Mun.EstadoID
    INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Dir.MunicipioID AND Loc.EstadoID=Dir.EstadoID and Loc.LocalidadID=Dir.LocalidadID
    SET
        RFCAV      =  Cli.RFC,
        CURPAV     =  Cli.CURP,  -- CURP para clientes que son avales, avales y prospectos no tienen registros de curp
        CompaniaAV  =  FNLIMPIACARACTBUROCRED(Cli.RazonSocial,'A'),
        PrimerNombreAV =  UPPER(REPLACE(Cli.PrimerNombre,'Ñ','N')) ,
        SegundoNombreAV =UPPER(REPLACE(Cli.SegundoNombre,'Ñ','N')),
        ApePaternoAV    =UPPER(REPLACE(Cli.ApellidoPaterno,'Ñ','N')),
        ApeMaternoAV    =UPPER(REPLACE(Cli.ApellidoMaterno,'Ñ','N')),


            PriLinDireccionAV= UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Dir.Calle,''),' ',
        COALESCE(Dir.NumeroCasa,''),' ',
        COALESCE(Dir.NumInterior,''),' ',COALESCE(Dir.Manzana,''),' ',COALESCE(Dir.Lote,'')),',',''),1,40)),




        SegLinDireccionAV=UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Dir.Calle,''),' ',
        COALESCE(Dir.NumeroCasa,''),' ',
        COALESCE(Dir.NumInterior,''),' ',COALESCE(Dir.Manzana,''),' ',COALESCE(Dir.Lote,'')),',',''),41,40)),
        ColoniaAV        =  UPPER(SUBSTRING(REPLACE(Dir.Colonia,',',''),1,60)),
        MunicipioAV      =  UPPER(Mun.Nombre),
        EstadoAV         =UPPER(Est.EqBuroCred),
        CPAV             =Dir.CP,
        TelefonoAV       =Cli.TelefonoCelular,
        ExtTelefonoAV    =Cli.ExtTelefonoPart,
        TipoClienteAV    =CASE WHEN Cli.TipoPersona = 'A' THEN '2' ELSE '1' END ;

    DELETE TMP FROM  TMPAVALESLISTA TMP
        INNER JOIN CLIENTES Cli ON Cli.ClienteID=TMP.ClienteID
        WHERE  Cli.TipoPersona='F';

        -- ACTUALIZAN datos para Prospectos
    UPDATE TMPAVALESLISTA TMP
        INNER JOIN PROSPECTOS Pro ON Pro.ProspectoID=TMP.ProspectoID
        INNER JOIN ESTADOSREPUB Est ON Pro.EstadoID = Est.EstadoID
        INNER JOIN MUNICIPIOSREPUB Mun ON Pro.MunicipioID = Mun.MunicipioID AND Pro.EstadoID = Mun.EstadoID
    INNER JOIN LOCALIDADREPUB Loc ON Loc.MunicipioID=Pro.MunicipioID AND Loc.EstadoID=Pro.EstadoID and Loc.LocalidadID=Pro.LocalidadID
    SET
        RFCAV            =  Pro.RFC,
        CompaniaAV       =  FNLIMPIACARACTBUROCRED(Pro.RazonSocial,'A'),
        PrimerNombreAV   =  UPPER(REPLACE(Pro.PrimerNombre,'Ñ','N')) ,
        SegundoNombreAV  =  UPPER(REPLACE(Pro.SegundoNombre,'Ñ','N')),
        ApePaternoAV     =  UPPER(REPLACE(Pro.ApellidoPaterno,'Ñ','N')),
        ApeMaternoAV     =  UPPER(REPLACE(Pro.ApellidoMaterno,'Ñ','N')),

       PriLinDireccionAV=UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Pro.Calle,''),' ',
         COALESCE(Pro.NumExterior,''),' ',
         COALESCE(Pro.NumInterior,''),' ',COALESCE(Pro.Manzana,''),' ',COALESCE(Pro.Lote,'')),',',''),1,40)),
       SegLinDireccionAV=UPPER(SUBSTRING(REPLACE(CONCAT(COALESCE(Pro.Calle,''),' ',
         COALESCE(Pro.NumExterior,''),' ',
         COALESCE(Pro.NumInterior,''),' ',COALESCE(Pro.Manzana,''),' ',COALESCE(Pro.Lote,'')),',',''),41,40)),




        ColoniaAV        = UPPER(SUBSTRING(REPLACE(Pro.Colonia,',',''),1,60)),
        MunicipioAV      = UPPER(Mun.Nombre) ,
        EstadoAV         =UPPER(Est.EqBuroCred),
        CPAV             =Pro.CP,
        TelefonoAV       =Pro.Telefono,
        ExtTelefonoAV    =Pro.ExtTelefonoPart,
        TipoClienteAV    =CASE WHEN Pro.TipoPersona = 'A' THEN '2' ELSE '1' END ;

    DELETE  TMP FROM  TMPAVALESLISTA TMP
        INNER JOIN PROSPECTOS P ON P.ProspectoID=TMP.ProspectoID
        WHERE  P.TipoPersona='F';

    UPDATE TMPAVALESLISTA SET ApePaternoAV=ApeMaternoAV, ApeMaternoAV=NULL
        WHERE (ApePaternoAV IS NULL OR ApePaternoAV='') AND ApeMaternoAV <> '';

    UPDATE TMPAVALESLISTA SET ApeMaternoAV='NO PROPORCIONADO'
        WHERE ApeMaternoAV IS NULL OR ApeMaternoAV='';

        UPDATE TMPAVALESLISTA SET
        PriLinDireccionAV   = REPLACE(PriLinDireccionAV,'Ñ','N'),
        SegLinDireccionAV   = REPLACE(SegLinDireccionAV,'Ñ','N'),
        ColoniaAV           = REPLACE(ColoniaAV,'Ñ','N'),
        MunicipioAV         = REPLACE(MunicipioAV,'Ñ','N'),
        EstadoAV            = REPLACE(EstadoAV,'Ñ','N');


    UPDATE  TMPAVALESLISTA SET
        PrimerNombreAV    = REPLACE(PrimerNombreAV,PrimerNombreAV,FNLIMPIACARACTERESACENTOS(PrimerNombreAV)),
        SegundoNombreAV   = REPLACE(SegundoNombreAV,SegundoNombreAV,FNLIMPIACARACTERESACENTOS(SegundoNombreAV)),
        ApePaternoAV      = REPLACE(ApePaternoAV,ApePaternoAV,FNLIMPIACARACTERESACENTOS(ApePaternoAV)),
        ApeMaternoAV      = REPLACE(ApeMaternoAV,ApeMaternoAV,FNLIMPIACARACTERESACENTOS(ApeMaternoAV)),
        PriLinDireccionAV = REPLACE(PriLinDireccionAV,PriLinDireccionAV,FNLIMPIACARACTERESACENTOS(PriLinDireccionAV)),
        SegLinDireccionAV = REPLACE(SegLinDireccionAV,SegLinDireccionAV,FNLIMPIACARACTERESACENTOS(SegLinDireccionAV)),
        ColoniaAV         = REPLACE(ColoniaAV,ColoniaAV,FNLIMPIACARACTERESACENTOS(ColoniaAV)),
        MunicipioAV       = REPLACE(MunicipioAV,MunicipioAV,FNLIMPIACARACTERESACENTOS(MunicipioAV)),
        EstadoAV          = REPLACE(EstadoAV,EstadoAV,FNLIMPIACARACTERESACENTOS(EstadoAV)),
        PriLinDireccionAV = REPLACE(PriLinDireccionAV,PriLinDireccionAV,FNLIMPIACARACTERESACENTOS(PriLinDireccionAV)),
        SegLinDireccionAV = REPLACE(SegLinDireccionAV,SegLinDireccionAV,FNLIMPIACARACTERESACENTOS(SegLinDireccionAV)),
        ColoniaAV         = REPLACE(ColoniaAV,ColoniaAV,FNLIMPIACARACTERESACENTOS(ColoniaAV)),
        MunicipioAV       = REPLACE(MunicipioAV,MunicipioAV,FNLIMPIACARACTERESACENTOS(MunicipioAV)),
        EstadoAV          = REPLACE(EstadoAV,EstadoAV,FNLIMPIACARACTERESACENTOS(EstadoAV));


    #Obtener el numero maximo de avales por credito
        SET NumEncabezados    := (SELECT COUNT(CredID) AS CONTEO FROM TMPAVALESLISTA GROUP BY CredID ORDER BY CONTEO DESC LIMIT 1);
        SET NumEncabezadoAval := IFNULL(NumEncabezados,Entero_Cero);

    -- Numero de Directivos por Credito
    SET NumEncabezadosDir      := (SELECT COUNT(CreditoID) AS CONTEO FROM TMPDIRECTIVOSLISTA GROUP BY CreditoID ORDER BY CONTEO DESC LIMIT 1);
    SET NumEncabezadoDirectivo := IFNULL(NumEncabezadosDir,Entero_Cero);


    IF( Var_ReportarTotalIntegrantes = Con_NO ) THEN

        SET NumEncabezados    := 1;
        SET NumEncabezadosDir := 1;

    END IF;

    #Ciclo para encabezados de avales
    WHILE(NumEncabezados > Entero_Cero) DO
        SET EncabezadoAVCVS := CONCAT(EncabezadoAVCVS,Var_EncabezadoAVCVS);
        SET NumEncabezados  := NumEncabezados - Entero_Uno;
    END WHILE;

    #Ciclo para encabezados de avales
    WHILE(NumEncabezadosDir > Entero_Cero) DO
        SET EncabezadoACCVS    := CONCAT(EncabezadoACCVS,Var_EncabezadoACCVS);
        SET NumEncabezadosDir  := NumEncabezadosDir - Entero_Uno;
    END WHILE;
    SET NumEncabezadosDir := NumEncabezadoDirectivo;

    #Cadena Avales
    UPDATE TMPAVALESLISTA Ava
        INNER JOIN TMPDATOSEM TMP ON Ava.CredID = TMP.CreditoID SET
        Ava.CadenaAval = CONCAT_WS(
            Separador,              IFNULL(Ava.IdentificaAV,Cadena_Vacia),      IFNULL(Ava.RFCAV,Cadena_Vacia),             IFNULL(Ava.CURPAV,Cadena_Vacia),            IFNULL(Ava.NumDunAV,Cadena_Vacia),
            IFNULL(Ava.CompaniaAV,Cadena_Vacia),            IFNULL(Ava.PrimerNombreAV,Cadena_Vacia),        IFNULL(Ava.SegundoNombreAV,Cadena_Vacia),   IFNULL(Ava.ApePaternoAV,Cadena_Vacia),  IFNULL(Ava.ApeMaternoAV,Cadena_Vacia),
            IFNULL(Ava.PriLinDireccionAV,Cadena_Vacia), IFNULL(Ava.SegLinDireccionAV,Cadena_Vacia), IFNULL(Ava.ColoniaAV,Cadena_Vacia),         IFNULL(Ava.MunicipioAV,Cadena_Vacia),   IFNULL(Ava.CiudadAV,Cadena_Vacia),
            IFNULL(Ava.EstadoAV,Cadena_Vacia),          IFNULL(Ava.CPAV,Cadena_Vacia),              IFNULL(Ava.TelefonoAV,Cadena_Vacia),            IFNULL(Ava.ExtTelefonoAV,Cadena_Vacia), IFNULL(Ava.FaxAV,Cadena_Vacia),
            IFNULL(Ava.TipoClienteAV,Cadena_Vacia),     IFNULL(Ava.EdoExtranjeroAV,Cadena_Vacia),   IFNULL(Ava.PaisAV,Cadena_Vacia));

    #Cadena Directivos
    UPDATE TMPDIRECTIVOSLISTA Dir
        INNER JOIN TMPDATOSEM TMP ON Dir.CreditoID = TMP.CreditoID SET
        Dir.CadenaAccionista = CONCAT_WS(
            Separador,                                  IFNULL(Dir.IdentificaAC,Cadena_Vacia),      IFNULL(Dir.RFCAC,Cadena_Vacia),             IFNULL(Dir.CURPAC,Cadena_Vacia),        IFNULL(Dir.NumDunAC,Cadena_Vacia),
            IFNULL(Dir.CompaniaAC,Cadena_Vacia),        IFNULL(Dir.PrimerNombreAC,Cadena_Vacia),    IFNULL(Dir.SegundoNombreAC,Cadena_Vacia),   IFNULL(Dir.ApePaternoAC,Cadena_Vacia),  IFNULL(Dir.ApeMaternoAC,Cadena_Vacia),
            IFNULL(Dir.PorcentajeAC,Entero_Cero),       IFNULL(Dir.PriLinDireccionAC,Cadena_Vacia), IFNULL(Dir.SegLinDireccionAC,Cadena_Vacia), IFNULL(Dir.ColoniaAC,Cadena_Vacia),     IFNULL(Dir.MunicipioAC,Cadena_Vacia),
            IFNULL(Dir.CiudadAC,Cadena_Vacia),          IFNULL(Dir.EstadoAC,Cadena_Vacia),          IFNULL(Dir.CPAC,Cadena_Vacia),              IFNULL(Dir.TelefonoAC,Cadena_Vacia),    IFNULL(Dir.ExtTelefonoAC,Cadena_Vacia),
            IFNULL(Dir.FaxAC,Cadena_Vacia),             IFNULL(Dir.TipoClienteAC,Cadena_Vacia),     IFNULL(Dir.EdoExtranjeroAC,Cadena_Vacia),   IFNULL(Dir.PaisAC,Cadena_Vacia));

    DROP TABLE IF EXISTS LISAVA;

    CREATE TEMPORARY TABLE LISAVA(
        CredID  VARCHAR(50),
        CadAval TEXT,
    INDEX LISAVA1 (CredID));

    DROP TABLE IF EXISTS LISDIRECT;
    CREATE TEMPORARY TABLE LISDIRECT(
        CreditoID   VARCHAR(50),
        NumAccionistas INT(11),
        CadenaDir   TEXT,
    INDEX LISAVA1 (CreditoID));

    SET session group_concat_max_len:=15000;

    INSERT INTO LISAVA(
        SELECT CredID , GROUP_CONCAT(DISTINCT CadenaAval) AS CadenaAval FROM TMPAVALESLISTA GROUP BY CredID
    );

    INSERT INTO LISDIRECT(
        SELECT CreditoID ,COUNT(CreditoID), GROUP_CONCAT(DISTINCT CadenaAccionista) AS CadenaAccionista FROM TMPDIRECTIVOSLISTA GROUP BY CreditoID
    );

    UPDATE TMPDATOSEM TMP
        INNER JOIN  LISAVA  Ava ON Ava.CredID = TMP.CreditoID
        SET TMP.CadenaAvales = Ava.CadAval;

    UPDATE TMPDATOSEM TMP
        INNER JOIN LISDIRECT Lis ON Lis.CreditoID = TMP.CreditoID SET
    TMP.CadenaDirectivo = Lis.CadenaDir,
    TMP.NumAccionistas  = Lis.NumAccionistas;

    #Obtenemos los datos de la institucion
    SELECT  ClaveUsuarioBCPM,   TipoUsuarioBCPM,    LEFT(Nombre, 75)
    INTO    Var_Claveusuario,   Var_TipoUsuario,    Var_NombreInstitucion
    FROM BUCREPARAMETROS;

    #Cambiamos los valores que contengan la letra ñ
    UPDATE TMPDATOSEM
    SET   Compania=REPLACE(Compania,Letra_enie,Letra_N),PrimerNombre=REPLACE(PrimerNombre,Letra_enie,Letra_N),SegundoNombre=REPLACE(SegundoNombre,Letra_enie,Letra_N),
          ApePaterno=REPLACE(ApePaterno,Letra_enie,Letra_N),ApeMaterno=REPLACE(ApeMaterno,Letra_enie,Letra_N),PriLinDireccion=REPLACE(PriLinDireccion,Letra_enie,Letra_N),
          PriLinDireccion=REPLACE(PriLinDireccion,Letra_enie,Letra_N), Colonia=REPLACE(Colonia,Letra_enie,Letra_N),Municipio=REPLACE(Municipio,Letra_enie,Letra_N),
          Ciudad=REPLACE(Ciudad,Letra_enie,Letra_N);
    #Cambiamos los valores que contengan acento en la letra a
    UPDATE TMPDATOSEM
    SET   Compania=REPLACE(Compania,AAcento,VocalA),PrimerNombre=REPLACE(PrimerNombre,AAcento,VocalA),SegundoNombre=REPLACE(SegundoNombre,AAcento,VocalA),
          ApePaterno=REPLACE(ApePaterno,AAcento,VocalA),ApeMaterno=REPLACE(ApeMaterno,AAcento,VocalA),PriLinDireccion=REPLACE(PriLinDireccion,AAcento,VocalA),
          PriLinDireccion=REPLACE(PriLinDireccion,AAcento,VocalA), Colonia=REPLACE(Colonia,AAcento,VocalA),Municipio=REPLACE(Municipio,AAcento,VocalA),
          Ciudad=REPLACE(Ciudad,AAcento,VocalA);
    #Cambiamos los valores que contengan acento en la letra e
    UPDATE TMPDATOSEM
    SET   Compania=REPLACE(Compania,EAcento,VocalE),PrimerNombre=REPLACE(PrimerNombre,EAcento,VocalE),SegundoNombre=REPLACE(SegundoNombre,EAcento,VocalE),
          ApePaterno=REPLACE(ApePaterno,EAcento,VocalE),ApeMaterno=REPLACE(ApeMaterno,EAcento,VocalE),PriLinDireccion=REPLACE(PriLinDireccion,EAcento,VocalE),
          PriLinDireccion=REPLACE(PriLinDireccion,EAcento,VocalE), Colonia=REPLACE(Colonia,EAcento,VocalE),Municipio=REPLACE(Municipio,EAcento,VocalE),
          Ciudad=REPLACE(Ciudad,EAcento,VocalE);
    #Cambiamos los valores que contengan acento en la letra i
    UPDATE TMPDATOSEM
    SET   Compania=REPLACE(Compania,IAcento,VocalI),PrimerNombre=REPLACE(PrimerNombre,IAcento,VocalI),SegundoNombre=REPLACE(SegundoNombre,IAcento,VocalI),
          ApePaterno=REPLACE(ApePaterno,IAcento,VocalI),ApeMaterno=REPLACE(ApeMaterno,IAcento,VocalI),PriLinDireccion=REPLACE(PriLinDireccion,IAcento,VocalI),
          PriLinDireccion=REPLACE(PriLinDireccion,IAcento,VocalI), Colonia=REPLACE(Colonia,IAcento,VocalI),Municipio=REPLACE(Municipio,IAcento,VocalI),
          Ciudad=REPLACE(Ciudad,IAcento,VocalI);
    #Cambiamos los valores que contengan acento en la letra o
    UPDATE TMPDATOSEM
    SET   Compania=REPLACE(Compania,OAcento,VocalO),PrimerNombre=REPLACE(PrimerNombre,OAcento,VocalO),SegundoNombre=REPLACE(SegundoNombre,OAcento,VocalO),
          ApePaterno=REPLACE(ApePaterno,OAcento,VocalO),ApeMaterno=REPLACE(ApeMaterno,OAcento,VocalO),PriLinDireccion=REPLACE(PriLinDireccion,OAcento,VocalO),
          PriLinDireccion=REPLACE(PriLinDireccion,OAcento,VocalO), Colonia=REPLACE(Colonia,OAcento,VocalO),Municipio=REPLACE(Municipio,OAcento,VocalO),
          Ciudad=REPLACE(Ciudad,OAcento,VocalO);
    #Cambiamos los valores que contengan acento en la letra u
    UPDATE TMPDATOSEM
    SET   Compania=REPLACE(Compania,UAcento,VocalU),PrimerNombre=REPLACE(PrimerNombre,UAcento,VocalU),SegundoNombre=REPLACE(SegundoNombre,UAcento,VocalU),
          ApePaterno=REPLACE(ApePaterno,UAcento,VocalU),ApeMaterno=REPLACE(ApeMaterno,UAcento,VocalU),PriLinDireccion=REPLACE(PriLinDireccion,UAcento,VocalU),
          PriLinDireccion=REPLACE(PriLinDireccion,UAcento,VocalU), Colonia=REPLACE(Colonia,UAcento,VocalU),Municipio=REPLACE(Municipio,UAcento,VocalU),
          Ciudad=REPLACE(Ciudad,UAcento,VocalU);

    #Actualizamos los datos para personas morales respecto lo datos del representante legal
    UPDATE TMPDATOSEM
    SET CURP=Cadena_Vacia,PrimerNombre=Cadena_Vacia,SegundoNombre=Cadena_Vacia,ApePaterno=Cadena_Vacia,ApeMaterno=Cadena_Vacia
    WHERE TipoCliente=Entero_Uno;

    #Actualizamos el importe del pago
    SELECT COUNT(*)   INTO Var_Contador    FROM TMPDATOSEM ;

    DROP TABLE IF EXISTS TMPCREPAGADOS;

    CREATE TABLE TMPCREPAGADOS(
        Numero      INT(11),
        CreditoID   BIGINT(12),
        Fechaliq    VARCHAR(8),
        PRIMARY KEY(Numero,CreditoID)
    );
    INSERT INTO TMPCREPAGADOS
     SELECT Entero_Uno,Dat.CreditoID,MAX(Dat.FechaLiquida) FROM TMPDATOSEM Dat
        WHERE  FechaLiquida!=Cadena_Vacia
        GROUP BY Dat.CreditoID;

    UPDATE TMPCREPAGADOS SET Numero=Entero_Dos
    WHERE CONVERT(SUBSTRING(Fechaliq,3,Entero_Dos),SIGNED)<MONTH(Var_FechaFin)
    AND SUBSTRING(Fechaliq,5,4) = YEAR(Var_FechaFin);

    UPDATE TMPDATOSEM Dat
        INNER JOIN TMPCREPAGADOS Cre  ON Dat.CreditoID = Cre.CreditoID
    SET Dat.CreditoID = Entero_Cero
    WHERE  Cre.Numero=Entero_Dos;

    DELETE FROM TMPDATOSEM
        WHERE CreditoID = Entero_Cero;

    DROP TABLE IF EXISTS TMPCREPAGADOS;

    DROP TABLE IF EXISTS TMPCRERECIENTES;

    CREATE TABLE TMPCRERECIENTES(
        Numero      INT(11),
        CreditoID   BIGINT(12),
        FechaIni    VARCHAR(8),
        PRIMARY KEY(Numero,CreditoID)
    );
    INSERT INTO TMPCRERECIENTES
     SELECT Entero_Uno,Dat.CreditoID,MAX(Dat.FechaInicio) FROM TMPDATOSEM Dat
        WHERE  FechaInicio!=Cadena_Vacia
        GROUP BY Dat.CreditoID; -- CAMBIO PARA CORREGIR LLAVE DUPLICADA

    UPDATE TMPCRERECIENTES SET Numero=Entero_Dos
        WHERE CONVERT(SUBSTRING(FechaIni,3,Entero_Dos),SIGNED)>MONTH(Var_FechaFin)
        AND SUBSTRING(FechaIni,5,4)= YEAR(Var_FechaFin) OR SUBSTRING(FechaIni,5,4)> YEAR(Var_FechaFin);


    UPDATE TMPDATOSEM Dat
        INNER JOIN TMPCRERECIENTES Cre  ON Dat.CreditoID = Cre.CreditoID
    SET Dat.CreditoID = Entero_Cero
    WHERE  Cre.Numero=Entero_Dos;

    DELETE FROM TMPDATOSEM
        WHERE CreditoID = Entero_Cero;

    DROP TABLE IF EXISTS TMPCRERECIENTES;

    UPDATE TMPDATOSEM
    SET ImportePago = FUNCIONIMPORTEPAGO(CreditoID,Par_FechaCorteBC);
    #Actualizamos la clave banxico

    UPDATE TMPDATOSEM SET ActEconomica1=CONCAT(Entero_Cero,ActEconomica1) WHERE (LENGTH(ActEconomica1)=Entero_Seis);

    #Actualizamos Fecha Incumplimiento
    DROP TABLE IF EXISTS Incumplimiento;

    CREATE TABLE Incumplimiento(
        Numero      INT(11),
        CreditoID   BIGINT(12),
        FechaIncum  DATE,
        PRIMARY KEY(Numero,CreditoID)
    );

    -- Creditos del Mes que probablemente incumplieron
    INSERT INTO Incumplimiento
        SELECT Entero_Uno,Dat.CreditoID,Fecha_Vacia FROM TMPDATOSEM Dat
            INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoID = Sal.CreditoID
        WHERE Sal.SalCapAtrasado >Entero_Cero AND Sal.FechaCorte =Var_FechaFin
            AND CONVERT(SUBSTRING(Dat.FechaInicio,Entero_Tres,Entero_Dos),SIGNED)=MONTH(Var_FechaFin )
            AND SUBSTRING(Dat.FechaInicio,Entero_Cinco,Entero_Cuatro) = YEAR(Var_FechaFin )
        GROUP BY Sal.CreditoID, Dat.CreditoID;

    -- Creditos Migrados que probablemente incumplieron
     INSERT INTO Incumplimiento
        SELECT Entero_Dos,Eq.CreditoIDSAFI,Fecha_Vacia FROM EQU_CREDITOS Eq
            INNER JOIN SALDOSCREDITOS Sal ON Eq.CreditoIDSAFI = Sal.CreditoID
        WHERE Sal.SalCapAtrasado >Entero_Cero
            AND Sal.FechaCorte =Var_FechaFin
            AND Eq.FechaIncumplimiento= Fecha_Vacia
        GROUP BY Sal.CreditoID, Eq.CreditoIDSAFI;

    -- 3 Se Actualiza La fecha de Incumpliento de los creditos
    INSERT INTO Incumplimiento
        SELECT Entero_Tres,Dat.CreditoID,MIN(FechaCorte) FROM Incumplimiento Dat
            INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoID = Sal.CreditoID
        WHERE Sal.SalCapAtrasado >Entero_Cero
            AND Sal.FechaCorte>=Var_FechaInicial
            AND Sal.FechaCorte <= Var_FechaFin
        GROUP BY Sal.CreditoID, Dat.CreditoID;

    -- Actualizamo los Creditos migrados su Fecha de Incumplimiento
    UPDATE EQU_CREDITOS Equ
        INNER JOIN  Incumplimiento Inc ON Equ.CreditoIDSAFI = Inc.CreditoID
    SET Equ.FechaIncumplimiento = Inc.FechaIncum
    WHERE Equ.FechaIncumplimiento =Fecha_Vacia AND Inc.Numero=Entero_Tres;

    -- Insertamos la Fecha de Incumplimiento de los creditos del mes
    INSERT INTO EQU_CREDITOS
        SELECT Inc.CreditoID ,Inc.CreditoID ,Cadena_Vacia,MAX(Inc.FechaIncum) FROM Incumplimiento Inc
            LEFT JOIN EQU_CREDITOS Equ ON Equ.CreditoIDSAFI = Inc.CreditoID
        WHERE IFNULL(CreditoIDSAFI,Cadena_Vacia)=Cadena_Vacia AND Numero=Entero_Tres
        GROUP BY Inc.CreditoID;

    -- Actualizamos las Fechas de Incumplimiento en el la tabla TMPDATOSEM
    UPDATE TMPDATOSEM Dat
        INNER JOIN EQU_CREDITOS EqC  ON Dat.CreditoID = EqC.CreditoIDSAFI
    SET Dat.FechaPrimerIn = DATE_FORMAT(EqC.FechaIncumplimiento,'%d%m%Y')
    WHERE  IFNULL(EqC.FechaIncumplimiento,Fecha_Vacia) <> Fecha_Vacia;

    -- Si la Fecha de incumplimiento es mayor a la Fechacorte dejamos vacio el campo
    UPDATE TMPDATOSEM Dat
        INNER JOIN EQU_CREDITOS EqC  ON Dat.CreditoID = EqC.CreditoIDSAFI
    SET Dat.FechaPrimerIn = Cadena_Vacia
    WHERE  IFNULL(EqC.FechaIncumplimiento,Fecha_Vacia) >= Var_FechaFin ;

    DROP TABLE IF EXISTS Incumplimiento;

    #Actualizamos Saldos
    DROP TABLE IF EXISTS TEMPSUMASALDOSCRED;

    CREATE TABLE TEMPSUMASALDOSCRED(
        CreditoID        BIGINT(12),
        Saldo            DECIMAL(14,2),
        SaldoTotal       DECIMAL(14,2),
        Vencido          DECIMAL(14,2),
        PRIMARY KEY (CreditoID)
    );

    INSERT INTO TEMPSUMASALDOSCRED(
        SELECT Dat.CreditoID,
                IFNULL(ROUND(SUM((Sal.salCapVigente + Sal.SalCapAtrasado +
                Sal.SalCapVencido + Sal.SalCapVenNoExi))),Entero_Cero) AS Saldo,
                IFNULL(ROUND(SUM((Sal.SalCapVigente) + (Sal.SalCapAtrasado) +
                        (Sal.SalCapVencido) + (Sal.SalCapVenNoExi) +
                        (Sal.SalIntOrdinario)+(Sal.SalIntAtrasado) +
                        (Sal.SalIntVencido) + (Sal.SalIntProvision) +
                        (Sal.SalIntNoConta) + (Sal.SalMoratorios) +
                        (Sal.SaldoMoraVencido)+(Sal.SaldoMoraCarVen) +
                        (Sal.SalComFaltaPago) + (Sal.SaldoComServGar) + (Sal.SalOtrasComisi)))
                        ,Entero_Cero) AS SaldoTotal,
                IFNULL(ROUND(SUM((Sal.salCapAtrasado)+(Sal.SalCapVencido)
                +(Sal.SalCapVenNoExi))),Entero_Cero) AS Vencido
    FROM TMPDATOSEM Dat
    INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoID = Sal.CreditoID
    WHERE Sal.FechaCorte =Par_FechaCorteBC
    GROUP BY Sal.CreditoID, Dat.CreditoID);


    UPDATE TMPDATOSEM Dat
    INNER JOIN TEMPSUMASALDOSCRED Tem ON Dat.CreditoID = Tem.CreditoID
    SET Dat.SaldoInsoluto = Tem.Saldo, Dat.Saldo = Tem.SaldoTotal;

    SELECT FechaSistema
    INTO Var_FechaSistema
    FROM PARAMETROSSIS
    LIMIT 1;

    -- actualizacion de dias de atraso
    UPDATE TMPDATOSEM   Dat
    INNER JOIN SALDOSCREDITOS   Sal ON Dat.CreditoID = Sal.CreditoID
    SET Dat.DiasVencido = Sal.DiasAtraso
    WHERE Sal.FechaCorte = CASE WHEN Par_FechaCorteBC = Var_FechaSistema THEN DATE_SUB(Par_FechaCorteBC, INTERVAL 1 DAY)
                                ELSE Par_FechaCorteBC END;
    #Valida que los dias de vencimiento no sean mayor a 3 digitos

    UPDATE TMPDATOSEM SET DiasVencido=NoveNovenNue WHERE DiasVencido>=Entero_Mil;
    -- actualizamos la frecuencia del pago
    UPDATE TMPDATOSEM SET FrecuenciaPag=TrescieSesenta WHERE FrecuenciaPag>=Entero_Mil;
    -- =====================================================================================
    -- NUEVA SECCION PARA VALIDAR FECHA INCUMPLIMIENTO

    DROP TABLE IF EXISTS TEMPFECHAINCUMPLIMIENTO;

    CREATE TABLE TEMPFECHAINCUMPLIMIENTO(
        CreditoID        BIGINT(12),
        FechaIncumple    DATE,
        DiasAtraso       INT,
        PRIMARY KEY (CreditoID)
    );

    -- agregamos los creditos que tienen dias de atraso y no tienen fecha de incumplimiento
    INSERT INTO TEMPFECHAINCUMPLIMIENTO(
        SELECT Dat.CreditoID,   Fecha_Vacia,    MAX(Dat.DiasVencido)
    FROM TMPDATOSEM Dat
        WHERE Dat.DiasVencido>Entero_Cero
        AND Dat.FechaPrimerIn = Cadena_Vacia
        GROUP BY Dat.CreditoID); -- GROUP BY para corrgir llave duplicada

    -- actualizamos de amorticredito
    UPDATE TEMPFECHAINCUMPLIMIENTO      AS TMP
        INNER JOIN AMORTICREDITO    AS AMO  ON AMO.CreditoID = TMP.CreditoID
    SET TMP.FechaIncumple = AMO.FechaExigible

        WHERE AMO.Estatus <> Pagado
        AND  AMO.FechaExigible <=Par_FechaCorteBC;

    -- Ajuste para fecha de primer Incumpliento
    DROP TEMPORARY TABLE IF EXISTS TMPFECHAINCUMP;
    CREATE TEMPORARY TABLE TMPFECHAINCUMP(
    CreditoID       BIGINT(20) PRIMARY KEY NOT NULL,
    FechaIncump     DATE,
    FechaIncump2     DATE);

    INSERT INTO TMPFECHAINCUMP
    SELECT MIN(AMO.CreditoID) AS CreditoID, MIN(AMO.FechaLiquida) AS FechaIncump, MIN(AMO.FechaLiquida) AS FechaIncump2
        FROM TEMPFECHAINCUMPLIMIENTO AS TMP
        INNER JOIN AMORTICREDITO AS AMO ON AMO.CreditoID = TMP.CreditoID
            WHERE AMO.FechaExigible < AMO.FechaLiquida AND AMO.FechaLiquida <=Par_FechaCorteBC
            GROUP BY AMO.CreditoID;

    UPDATE TEMPFECHAINCUMPLIMIENTO  AS TMP
    INNER JOIN TMPFECHAINCUMP AS TMPFECH ON TMPFECH.CreditoID = TMP.CreditoID
        SET TMP.FechaIncumple = TMPFECH.FechaIncump;
    -- Fin Ajuste Fecha

    -- actualizamos en TMPDATOSEM
    UPDATE TMPDATOSEM Dat
        INNER JOIN TEMPFECHAINCUMPLIMIENTO Tem ON Dat.CreditoID = Tem.CreditoID
    SET Dat.FechaPrimerIn= DATE_FORMAT(Tem.FechaIncumple,'%d%m%Y');

    UPDATE TMPDATOSEM Dat
    INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoID = Sal.CreditoID
    INNER JOIN TMPFECHAINCUMP Tmp ON Sal.CreditoID = Tmp.CreditoID SET
        Dat.FechaPrimerIn = DATE_FORMAT( DATE_SUB(Sal.FechaCorte, INTERVAL Sal.DiasAtraso DAY),'%d%m%Y')
    WHERE Sal.FechaCorte = Dat.FechIngCarVen2
      AND Dat.FechaPrimerIn <> ''
      AND FechaUltimoPago > FechaIncump2
      AND Sal.DiasAtraso > Entero_Cero
      AND Dat.FechIngCarVen2 <> '1900-01-01';

    UPDATE TMPDATOSEM Dat
        SET Dat.FechaPrimerIn = Cadena_Vacia
    WHERE Dat.FechaPrimerIn = '01011900';

    -- =====================================================================================
    -- NUEVA SECCION PARA VALIDAR EL IMPORTE DE PAGO
    UPDATE TMPDATOSEM DET
        INNER JOIN EQU_CREDITOS   AS EQU ON EQU.CreditoIDCte = DET.Contrato
        INNER JOIN SALDOSCREDITOS AS SAL ON SAL.CreditoID    = EQU.CreditoIDSAFI
    SET DET.ImportePago     = SAL.MontoTotalExi
        WHERE   DET.ImportePago     =   Entero_Cero
        AND     DET.FechaUltPago    !=  Cadena_Vacia
        AND     DET.FechaLiquida    =   Cadena_Vacia
        AND     SAL.FechaCorte      =   Par_FechaCorteBC;

    -- ======================FIN IMPORTE DE PAGO================================================
    -- =====================================================================================
    -- NUEVA SECCION PARA VALIDAR EL IMPORTE DE PAGO QUE SIGUEN EN 0

    UPDATE TMPDATOSEM DET
        INNER JOIN SALDOSCREDITOS AS SAL ON SAL.CreditoID    = DET.CreditoID
         SET DET.ImportePago     = SAL.MontoTotalExi
    WHERE   DET.ImportePago     =   Entero_Cero
    AND     DET.FechaUltPago    !=  Cadena_Vacia
    AND     DET.FechaLiquida    =   Cadena_Vacia
    AND     SAL.FechaCorte      =   Par_FechaCorteBC;

    -- ======================FIN IMPORTE DE PAGO================================================

    -- INICIO Notas de Cargo

    DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOBNCPM;
    CREATE TEMPORARY TABLE TMPEXIGIBLESNOTASCARGOBNCPM (
        CreditoID               BIGINT(12),
        Monto                   DECIMAL(14,2),
        MontoExigible           DECIMAL(14,2),
        PRIMARY KEY (CreditoID)
    );

    DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOBNCPM;
    CREATE TEMPORARY TABLE TMPPAGOSNOTASCARGOBNCPM (
        CreditoID               BIGINT(12),
        Monto                   DECIMAL(14,2),
        PRIMARY KEY (CreditoID)
    );

    -- Montos de notas de cargo registradas a fecha corte
    INSERT INTO TMPEXIGIBLESNOTASCARGOBNCPM (   CreditoID,          Monto,                                  MontoExigible   )
                                    SELECT      NTC.CreditoID,      ROUND(SUM(ROUND(NTC.Monto, 2)), 2),     Entero_Cero
                                        FROM    NOTASCARGO NTC
                                        INNER JOIN TMPDATOSEM TMP ON TMP.CreditoID = NTC.CreditoID AND NTC.FechaRegistro <= Par_FechaCorteBC
                                        INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = NTC.CreditoID AND NTC.AmortizacionID = AMO.AmortizacionID AND AMO.FechaExigible <= Par_FechaCorteBC
                                        GROUP BY NTC.CreditoID, AMO.CreditoID;

    -- Montos pagados de notas de cargo a fechas exigibles
    INSERT INTO TMPPAGOSNOTASCARGOBNCPM (   CreditoID,          Monto   )
                                SELECT      DET.CreditoID,      ROUND(SUM(ROUND(DET.MontoNotasCargo, 2)), 2)
                                    FROM    TMPEXIGIBLESNOTASCARGOBNCPM TMP
                                    INNER JOIN DETALLEPAGCRE DET ON DET.CreditoID = TMP.CreditoID AND DET.FechaPago <= Par_FechaCorteBC
                                    INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID and DET.AmortizacionID = AMO.AmortizacionID AND AMO.FechaExigible <= Par_FechaCorteBC
                                    GROUP BY DET.CreditoID, AMO.CreditoID;

    -- Exigible de notas de cargo a fecha corte
    UPDATE TMPEXIGIBLESNOTASCARGOBNCPM NTC
        INNER JOIN TMPPAGOSNOTASCARGOBNCPM PAG ON NTC.CreditoID = PAG.CreditoID
    SET NTC.MontoExigible = ROUND(NTC.Monto - PAG.Monto, 2);

    UPDATE TMPEXIGIBLESNOTASCARGOBNCPM
    SET MontoExigible = Entero_Cero
    WHERE MontoExigible < Entero_Cero;

    UPDATE TMPDATOSEM TMP
        INNER JOIN TMPEXIGIBLESNOTASCARGOBNCPM NTC ON NTC.CreditoID = TMP.CreditoID
    SET TMP.ImportePago = ROUND(TMP.ImportePago + NTC.MontoExigible, 2),
        TMP.Saldo       = ROUND(TMP.Saldo + NTC.MontoExigible, 2);

    DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOBNCPM;
    DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOBNCPM;

    -- FIN Notas de Cargo

    DROP TABLE IF EXISTS TEMPSUMASALDOSCRED;
    #Actualiza saldo de quitas
    DROP TABLE IF EXISTS TEMPSALDOSQUI;

    CREATE TABLE TEMPSALDOSQUI(
        CreditoID        BIGINT(12),
        TotalCondonado   DECIMAL(14,2),
        PRIMARY KEY (CreditoID)
    );
    INSERT INTO TEMPSALDOSQUI(
        SELECT Dat.CreditoID,
                IFNULL(ROUND(SUM(Cqi.MontoCapital + Cqi.MontoInteres +
                Cqi.MontoMoratorios + Cqi.MontoComisiones)),Entero_Cero) AS TotalCondonado
    FROM TMPDATOSEM Dat
    INNER JOIN CREQUITAS Cqi ON Dat.CreditoID = Cqi.CreditoID
    GROUP BY Dat.CreditoID -- Para corección de llave duplicada
    );

    UPDATE TMPDATOSEM Dat
    INNER JOIN TEMPSALDOSQUI Tem ON Dat.CreditoID = Tem.CreditoID
    SET Dat.Quita = Tem.TotalCondonado;

    DROP TABLE IF EXISTS TEMPSALDOSQUI;
    #Actualizamos fecha de reestrutura
    DROP TABLE IF EXISTS TEMPREESTRUCTURA;

    CREATE TABLE TEMPREESTRUCTURA(
        CreditoID   BIGINT(12),
        Fecha       DATE,
        PRIMARY KEY (CreditoID)
    );

    INSERT INTO TEMPREESTRUCTURA(
        SELECT Dat.CreditoID,
               Ree.FechaRegistro
    FROM TMPDATOSEM Dat
    INNER JOIN REESTRUCCREDITO Ree ON Dat.CreditoID = Ree.CreditoDestinoID
    GROUP BY Dat.CreditoID,  Ree.FechaRegistro);

    UPDATE TMPDATOSEM Dat
    INNER JOIN TEMPREESTRUCTURA Tem ON Dat.CreditoID = Tem.CreditoID
    SET Dat.FechaReestru = DATE_FORMAT(Tem.Fecha,'%d%m%Y');

    DROP TABLE IF EXISTS TEMPREESTRUCTURA;
    # Actualizamos el tipo de credito
    DROP TABLE IF EXISTS TEMPTIPOCRED;

    CREATE TABLE TEMPTIPOCRED(
        CreditoID       BIGINT(12),
        Clasificacion   VARCHAR(4),
        PRIMARY KEY (CreditoID)
    );

    INSERT INTO TEMPTIPOCRED(
        SELECT Dat.CreditoID,
               Cla.CodClasificBuroPM
    FROM TMPDATOSEM Dat
    INNER JOIN CREDITOS Cre ON Cre.CreditoID = Dat.CreditoID
    INNER JOIN DESTINOSCREDITO Des ON Des.DestinoCreID = Cre.DestinoCreID
    INNER JOIN CLASIFICCREDITO Cla ON Cla.ClasificacionID = Des.SubClasifID
    GROUP BY Dat.CreditoID, Cla.CodClasificBuroPM);

    UPDATE TMPDATOSEM Dat
    INNER JOIN TEMPTIPOCRED Tem ON Dat.CreditoID = Tem.CreditoID
    SET Dat.TipoCredito = Tem.Clasificacion;

    -- Se actualiza la clave para los creditos renovados
    UPDATE TMPDATOSEM Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoID = Cre.CreditoID
        SET Dat.TipoCredito = 1324
    WHERE Cre.TipoCredito = 'O';

    SELECT CreditoID INTO Var_TipoCreditoNV FROM TMPDATOSEM WHERE TipoCredito = Cadena_Vacia LIMIT Entero_Uno;

    SET Var_TipoCreditoNV := IFNULL(Var_TipoCreditoNV,Entero_Cero);

    DROP TABLE IF EXISTS TEMPTIPOCRED;

    -- Actualizamos ultimos valores de segmento TS
    SET NumColumnas := IFNULL((NumEncabezadoAval*22),Entero_Cero);

    SET UltCredID := (SELECT CreditoID FROM (SELECT ClienteID, CreditoID FROM TMPDATOSEM ORDER BY ClienteID DESC LIMIT 1) as creditoID);
    SET VeriCredID := (SELECT IFNULL((SELECT CredID FROM TMPAVALESLISTA WHERE CredID = UltCredID GROUP BY CredID ),Entero_Cero));

    IF(VeriCredID <> Entero_Cero) THEN
        SET NumColUltCred := (SELECT COUNT(CredID) AS CONTEO FROM TMPAVALESLISTA WHERE CredID = UltCredID GROUP BY CredID);
        SET PosTS := NumColUltCred * 22;
        SET NumColumnas := NumColumnas - PosTS;

    END IF;

    SELECT COUNT(*)   INTO Var_ContadorTotal FROM TMPDATOSEM ;
    SELECT SUM(Saldo) INTO Var_TotalSaldos FROM TMPDATOSEM ;
    SELECT MAX(ID)    INTO Var_UltimoReg   FROM TMPDATOSEM;
      -- Compañias vacias
    SET CompaniasVa := (SELECT COUNT(RFC) FROM (SELECT RFC FROM TMPDATOSEM GROUP BY RFC) as totalCompania);

        SET SeparadorTS := '';

    WHILE NumColumnas > Entero_Cero DO

        SET SeparadorTS := CONCAT(SeparadorTS,Separador);
        SET NumColumnas := NumColumnas - Entero_Uno;
    END WHILE;
    IF (SeparadorTS <> '') THEN

    UPDATE TMPDATOSEM SET
        NumReportes = CompaniasVa, TotalSaldos=Var_TotalSaldos,IdentificaTS=CONCAT( SeparadorTS,IdentSegTS)
    WHERE ID=Var_UltimoReg;
    ELSE

    UPDATE TMPDATOSEM SET
        NumReportes = CompaniasVa, TotalSaldos=Var_TotalSaldos,IdentificaTS=IdentSegTS
    WHERE ID=Var_UltimoReg;
    END IF;

    UPDATE TMPDATOSEM tmp INNER JOIN SALDOSCREDITOS sal
        ON sal.FechaCorte = Par_FechaCorteBC AND tmp.CreditoID = sal.CreditoID
    SET tmp.InteresCred = sal.SalIntOrdinario+sal.SalIntAtrasado+sal.salIntVencido+sal.SalIntProvision;
     -- Actualización de Interes del Credito para creditos castigados Version 5
    UPDATE TMPDATOSEM tmp INNER JOIN CRECASTIGOS cre
        ON tmp.CreditoID = cre.CreditoID
    SET tmp.InteresCred = cre.InteresCastigado;
    -- Actualizamos fechas vacias
    UPDATE TMPDATOSEM Dat
        SET Dat.FechIngCarVen = Cadena_Vacia
    WHERE Dat.FechIngCarVen = '01011900';
     -- PLAZO
     UPDATE TMPDATOSEM Dat
     SET Dat.Plazo = Dat.Plazo/Fec_me;

    -- LC
    UPDATE TMPDATOSEM tmp
        SET tmp.ClaveObserva = Etiqueta_LC
    WHERE tmp.Saldo = Entero_Cero
        AND tmp.ImportePago = Entero_Cero
        AND tmp.DiasVencido > Entero_Cero
        AND tmp.Quita > Entero_Cero
        AND tmp.FechaLiquida != Cadena_Vacia;
    -- LG
    UPDATE TMPDATOSEM tmp
        SET tmp.ClaveObserva = Etiqueta_LG
    WHERE tmp.Saldo = Entero_Cero
        AND   tmp.ImportePago = Entero_Cero
        AND   tmp.DiasVencido = Entero_Cero
        AND   tmp.Quita > Entero_Cero;

    -- saca datos de reestructuras
    DROP TABLE IF EXISTS  TMPCSREESCRED;
    CREATE TABLE TMPCSREESCRED
    select * from TMPDATOSEM where CreditoID <> Entero_Cero and CreditoIDAnt <> Entero_Cero;

    -- Agrega fecha liquidacion a creditos origenn de reestructura de acuerdo al manual
    UPDATE TMPDATOSEM tmp
    INNER JOIN REESTRUCCREDITO  res ON tmp.CreditoIDAnt = res.CreditoOrigenID
        SET
            tmp.FechaLiquida = DATE_FORMAT(res.FechaRegistro,'%d%m%Y');

    UPDATE TMPDATOSEM tmp  -- actualiza fecha inicio del credito del credito origen
    INNER JOIN REESTRUCCREDITO res ON tmp.CreditoID=res.CreditoDestinoID
    INNER JOIN CREDITOS CRE ON res.CreditoOrigenID = CRE.CreditoID
        SET
            tmp.FechaInicio = DATE_FORMAT(CRE.FechaInicio,'%d%m%Y');

    -- actualiza reesctruturas creditos origen deacuerdo a manual,
    UPDATE TMPDATOSEM tm
    INNER JOIN REESTRUCCREDITO r on tm.CreditoIDAnt = r.CreditoOrigenID
        SET
            tm.DiasVencido  =   Entero_Cero,
            tm.ImportePago  =   Entero_Cero,
            tm.Saldo        =   Entero_Cero,
            tm.ContratoCR   =   IF(CreditoIDAnt <> Entero_Cero,CreditoIDAnt,ContratoCR),
            tm.Contrato     =   IF(CreditoIDAnt <> Entero_Cero,CreditoIDAnt,ContratoCR),
            tm.CreditoID    =   IF(CreditoIDAnt <> Entero_Cero,CreditoIDAnt,ContratoCR),
            tm.CreditoIDAnt =   IF(CreditoIDAnt=CreditoID,'',CreditoIDAnt);

    -- actualiza para creditos destino (actual) de reestruturas acorde al manual
    UPDATE TMPCSREESCRED CS
        INNER JOIN CREDITOS C on CS.CreditoID=C.CreditoID AND C.TipoCredito IN ('O','R') AND C.Estatus <> 'P'
        SET
            FechaReestru = NULL,
            FechaLiquida = NULL,
            DiasVencido = Entero_Cero;

    UPDATE TMPCSREESCRED tmp  -- actualiza fecha inicio del credito del credito destino (actual)
    INNER JOIN REESTRUCCREDITO res ON  tmp.CreditoID=res.CreditoDestinoID
    INNER JOIN CREDITOS CRE ON res.CreditoDestinoID = CRE.CreditoID
        SET
            tmp.FechaInicio = DATE_FORMAT(CRE.FechaInicio,'%d%m%Y');

    -- inserta nuevamente
    INSERT INTO TMPDATOSEM
        (ID, ClienteID, IdentificaEM, RFC, CURP,
        NumDun, Compania, PrimerNombre, SegundoNombre,
        ApePaterno, ApeMaterno, Nacionalidad, CalifCartera, ActEconomica1,
        ActEconomica2, ActEconomica3, PriLinDireccion, SegLinDireccion, Colonia,
        Municipio, Ciudad, Estado, CP, Telefono,
        ExtTelefono, Fax, TipoCliente, EdoExtranjero, Pais,
        ClaveConsolida, IdentificaAC, RFCAC, CURPAC, NumDunAC,
        CompaniaAC, PrimerNombreAC, SegundoNombreAC, ApePaternoAC, ApeMaternoAC,
        PorcentajeAC, PriLinDireccionAC, SegLinDireccionAC, ColoniaAC, MunicipioAC,
        CiudadAC, EstadoAC, CPAC, TelefonoAC, ExtTelefonoAC,
        FaxAC, TipoClienteAC, EdoExtranjeroAC, PaisAC, IdentificaCR,
        RFCCR, NumExpeCred, ContratoCR, CreditoIDAnt, FechaInicio,
        Plazo, TipoCredito, SaldoInicial, Moneda, NumPagos,
        FrecuenciaPag, ImportePago, FechaUltPago, FechaReestru, PagoEfectivo,
        FechaLiquida, Quita, Dacion, Quebranto, ClaveObserva,
        CredEspecial, FechaPrimerIn, SaldoInsoluto, IdentificaDE, RFCDE,
        Contrato, DiasVencido, Saldo, IdentificaAV, RFCAV,
        CURPAV, NumDunAV, CompaniaAV, PrimerNombreAV, SegundoNombreAV,
        ApePaternoAV, ApeMaternoAV, PriLinDireccionAV, SegLinDireccionAV, ColoniaAV,
        MunicipioAV, CiudadAV, EstadoAV, CPAV, TelefonoAV,
        ExtTelefonoAV, FaxAV, TipoClienteAV, EdoExtranjeroAV, PaisAV,
        CreditoID, CredMaxUti, FechIngCarVen, InteresCred, CadenaAvales,
        Cinta, IdentificaTS, NumReportes, TotalSaldos, SolicitudCreditoID,
        CadenaDirectivo, NumAccionistas)

    SELECT
        0, ClienteID, IdentificaEM, RFC, CURP,
        NumDun, Compania, PrimerNombre, SegundoNombre,
        ApePaterno, ApeMaterno, Nacionalidad, CalifCartera, ActEconomica1,
        ActEconomica2, ActEconomica3, PriLinDireccion, SegLinDireccion, Colonia,
        Municipio, Ciudad, Estado, CP, Telefono,
        ExtTelefono, Fax, TipoCliente, EdoExtranjero, Pais,
        ClaveConsolida, IdentificaAC, RFCAC, CURPAC, NumDunAC,
        CompaniaAC, PrimerNombreAC, SegundoNombreAC, ApePaternoAC, ApeMaternoAC,
        PorcentajeAC, PriLinDireccionAC, SegLinDireccionAC, ColoniaAC, MunicipioAC,
        CiudadAC, EstadoAC, CPAC, TelefonoAC, ExtTelefonoAC,
        FaxAC, TipoClienteAC, EdoExtranjeroAC, PaisAC, IdentificaCR,
        RFCCR, NumExpeCred, ContratoCR, CreditoIDAnt, FechaInicio,
        Plazo, TipoCredito, SaldoInicial, Moneda, NumPagos,
        FrecuenciaPag, ImportePago, FechaUltPago, FechaReestru, PagoEfectivo,
        FechaLiquida, Quita, Dacion, Quebranto, ClaveObserva,
        CredEspecial, FechaPrimerIn, SaldoInsoluto, IdentificaDE, RFCDE,
        Contrato, DiasVencido, Saldo, IdentificaAV, RFCAV,
        CURPAV, NumDunAV, CompaniaAV, PrimerNombreAV, SegundoNombreAV,
        ApePaternoAV, ApeMaternoAV, PriLinDireccionAV, SegLinDireccionAV, ColoniaAV,
        MunicipioAV, CiudadAV, EstadoAV, CPAV, TelefonoAV,
        ExtTelefonoAV, FaxAV, TipoClienteAV, EdoExtranjeroAV, PaisAV,
        CreditoID, CredMaxUti, FechIngCarVen, InteresCred, CadenaAvales,
        Cinta, IdentificaTS, NumReportes, TotalSaldos, SolicitudCreditoID,
        CadenaDirectivo, NumAccionistas
    FROM TMPCSREESCRED;
    -- elimina tabla actualizada
    DROP TABLE TMPCSREESCRED;

    -- Agregar validacion  Clave RA
    UPDATE TMPDATOSEM  tmp
    INNER JOIN CREDITOS cr ON tmp.CreditoID=cr.CreditoID
    INNER JOIN REESTRUCCREDITO rc ON cr.CreditoID=rc.CreditoOrigenID
        SET
            tmp.ClaveObserva = Etiqueta_RA
    WHERE cr.EsAgropecuario = Si
        AND rc.FechaRegistro BETWEEN Var_FechaInicial AND Var_FechaFin;

    DROP TABLE IF EXISTS CSDELTCREDREENOFECH;
    CREATE TABLE CSDELTCREDREENOFECH
    SELECT CreditoOrigenID,CreditoDestinoID,FechaRegistro
    FROM TMPDATOSEM t
    INNER JOIN CREDITOS c ON t.CreditoID = c.CreditoID
    INNER JOIN REESTRUCCREDITO r ON c.CreditoID=r.CreditoOrigenID
    WHERE NOT c.FechTerminacion BETWEEN Var_FechaInicial AND Var_FechaFin;

    -- Quita registros de creditos origen que no se reestruturaron en el mes
    DELETE FROM TMPDATOSEM WHERE CreditoID IN (SELECT CreditoOrigenID FROM CSDELTCREDREENOFECH);
    -- Quita credito anterior si no esta reestruturado a la fecha que se reporta
    UPDATE TMPDATOSEM T
    INNER JOIN CSDELTCREDREENOFECH C ON T.CreditoIDAnt = C.CreditoOrigenID AND T.CreditoID = C.CreditoDestinoID
        SET
            T.CreditoIDAnt='';
    DROP TABLE CSDELTCREDREENOFECH;

    -- QUITA MAYOR A 0 Y ETIQUETA VACIA
    UPDATE TMPDATOSEM tmp
        SET tmp.Quita = Cadena_Vacia
    WHERE tmp.Quita > Entero_Cero
        AND   tmp.ClaveObserva = Cadena_Vacia;

        -- Fecha de incumplimiento mayor al periodo
    UPDATE TMPDATOSEM tmp
        SET tmp.FechIngCarVen =  DATE_FORMAT((Par_FechaCorteBC),'%d%m%Y')
    WHERE tmp.FechIngCarVen != Cadena_Vacia
        AND STR_TO_DATE(tmp.FechIngCarVen, '%d%m%Y') > Par_FechaCorteBC ;
    UPDATE TMPDATOSEM   tmp
    INNER JOIN SALDOSCREDITOS   sc ON tmp.CreditoID = sc.CreditoID
    SET tmp.FechIngCarVen  = Cadena_Vacia
    WHERE sc.FechaCorte = Par_FechaCorteBC and sc.DiasAtraso=0;

    -- Dias vencidos cero
    #Guarda la cinta en el historico
    -- Guarda el encabezado HD y sus Valores
    SET Var_Cinta:=CONCAT(EncabezadoHDCVS,Salto_Linea);

    INSERT INTO BUROCREDINTFPM
        (CintaID,   ClienteID,     Clave,  Fecha,  Cinta)
    VALUES  (Var_CintaID, Entero_Cero,  Entero_Cero, Par_FechaCorteBC, Var_Cinta);

    SET Var_Cinta := Cadena_Vacia;

    SET CliEspecifico := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CliProcEspecifico');
    IF (CliEspecifico = CliEspConsol) THEN
         SET Var_Cinta := CONCAT_WS(Separador,  IdentSegHD,     Var_Claveusuario,   InstAnterior,   Var_TipoUsuario,    Formato,    Fecha,  Periodo,    ClienteConsol ,Salto_Linea);
    ELSE
         SET Var_Cinta := CONCAT_WS(Separador,  IdentSegHD,     Var_Claveusuario,   InstAnterior,   Var_TipoUsuario,    Formato,    Fecha,  Periodo ,Salto_Linea);
    END IF;


    -- Cuando la cinta es de tipo 2 es formato INTL
    IF(Par_TipoFormatoCinta = Entero_Dos)THEN
        SELECT  IFNULL(MAX(HeaderSegmentoID), Entero_Cero) + Entero_Uno
        INTO    Var_ConsecutivoID
        FROM HEADERCADENAINTLCINTA FOR UPDATE;
        SET Var_NombreInstitucion := IFNULL(Var_NombreInstitucion, Cadena_Vacia);

        SET Aud_FechaActual := NOW();
        DELETE FROM HEADERCADENAINTLCINTA;

        INSERT INTO HEADERCADENAINTLCINTA(
            HeaderSegmentoID,       Identificador,      ClaveUsuarioBC,     ClaveUsuarioAntBC,      TipoInstitucion,
            Formato,                Fecha,              Periodo,            VersionINTL,            NombreOtorgante,
            Filler,                 TipoPersona,        EmpresaID,          Usuario,                FechaActual,
            DireccionIP,            ProgramaID,         Sucursal,           NumTransaccion
        )
        VALUES(
            Var_ConsecutivoID,      IdentSegHD,         Var_Claveusuario,   InstAnterior,           Var_TipoUsuario,
            Formato,                Fecha,              Periodo,            Var_Version,            Var_NombreInstitucion,
            Cadena_Vacia,           PersonaMoral,       Aud_EmpresaID,      Aud_Usuario,            Aud_FechaActual,
            Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
        );
    END IF;

    INSERT INTO BUROCREDINTFPM
        (CintaID,   ClienteID,     Clave,  Fecha,  Cinta)
    VALUES  (Var_CintaID, Entero_Cero,  Entero_Cero, Par_FechaCorteBC, Var_Cinta);
    SET Var_Cinta:=Cadena_Vacia;

    -- Guarda el encabezado General y sus Valores
    SET Var_Cinta:=CONCAT(EncabezadoEMCVS,EncabezadoACCVS,EncabezadoCRCVS,EncabezadoDECVS,EncabezadoAVCVS,EncabezadoTSCVS,Salto_Linea);

    INSERT INTO BUROCREDINTFPM
        (CintaID,   ClienteID,     Clave,  Fecha,  Cinta)
    VALUES  (Var_CintaID, Entero_Cero,  Entero_Cero, Par_FechaCorteBC, Var_Cinta);

    SET Var_Cinta:=Cadena_Vacia;

    -- Mayores al periodo
    SET FechaIn := (SELECT MIN(AMO.FechaExigible) FROM TEMPFECHAINCUMPLIMIENTO AS TMP
        INNER JOIN AMORTICREDITO    AS AMO  ON AMO.CreditoID = TMP.CreditoID
            WHERE AMO.FechaExigible < AMO.FechaLiquida
                AND AMO.FechaExigible <= Par_FechaCorteBC
                AND TMP.FechaIncumple = Fecha_Vacia);

    UPDATE TMPDATOSEM AS TMP
        SET TMP.FechaPrimerIn = DATE_FORMAT(FechaIn,'%d%m%Y')
    WHERE TMP.FechaPrimerIn = Cadena_Vacia
        AND TMP.DiasVencido > Entero_Cero;

    UPDATE TMPDATOSEM TDS SET
            FrecuenciaPag=(SELECT CEILING(AVG(datediff(FechaVencim,FechaInicio)))
                            FROM AMORTICREDITO
                            WHERE CreditoID=TDS.CreditoID)
     WHERE (FrecuenciaPag=0 OR FrecuenciaPag is NULL);

    -- Se limpia los campos
    UPDATE TMPDATOSEM SET
        Municipio = FNLIMPIACARACTBUROCRED(Municipio,LimpiaAlfabetico);

    -- Guarda los datos separado por cliente
    UPDATE TMPDATOSEM Dat SET
        Cinta = CONCAT_WS(Separador,
            IFNULL(Dat.IdentificaEM,Cadena_Vacia),     IFNULL(Dat.RFC,Cadena_Vacia),                 IFNULL(Dat.CURP,Cadena_Vacia),            IFNULL(Dat.NumDun,Cadena_Vacia),              IFNULL(Dat.Compania,Cadena_Vacia),            IFNULL(Dat.PrimerNombre,Cadena_Vacia),        IFNULL(Dat.SegundoNombre,Cadena_Vacia),
            IFNULL(Dat.ApePaterno,Cadena_Vacia),       IFNULL(Dat.ApeMaterno,Cadena_Vacia),          IFNULL(Dat.Nacionalidad,Cadena_Vacia),    IFNULL(Dat.CalifCartera,Cadena_Vacia),        IFNULL(Dat.ActEconomica1,Cadena_Vacia),       IFNULL(Dat.ActEconomica2,Cadena_Vacia),       IFNULL(Dat.ActEconomica3,Cadena_Vacia),
            IFNULL(Dat.PriLinDireccion,Cadena_Vacia),  IFNULL(Dat.SegLinDireccion,Cadena_Vacia),     IFNULL(Dat.Colonia,Cadena_Vacia),         IFNULL(Dat.Municipio,Cadena_Vacia),           IFNULL(Dat.Ciudad,Cadena_Vacia),              IFNULL(Dat.Estado,Cadena_Vacia),              IFNULL(Dat.CP,Cadena_Vacia),
            IFNULL(Dat.Telefono,Cadena_Vacia),         IFNULL(Dat.ExtTelefono,Cadena_Vacia),         IFNULL(Dat.Fax,Cadena_Vacia),             IFNULL(Dat.TipoCliente,Cadena_Vacia),         IFNULL(Dat.EdoExtranjero,Cadena_Vacia),       IFNULL(Dat.Pais,Cadena_Vacia),                IFNULL(Dat.ClaveConsolida,Cadena_Vacia),
            CASE WHEN NumAccionistas <> NumEncabezadosDir THEN
                    CASE WHEN NumAccionistas = Entero_Cero THEN
                            CONCAT(IFNULL(Dat.CadenaDirectivo, Cadena_Vacia), FNCOMPLETASEGMENTO('AC', NumEncabezadosDir, Dat.NumAccionistas))
                         ELSE  CONCAT(IFNULL(Dat.CadenaDirectivo, Cadena_Vacia),',', FNCOMPLETASEGMENTO('AC', NumEncabezadosDir, Dat.NumAccionistas))END
                 ELSE IF(NumEncabezadosDir = Entero_Cero, SegAccionistaVacio,IFNULL(Dat.CadenaDirectivo, Cadena_Vacia)) END,
            IFNULL(Dat.IdentificaCR,Cadena_Vacia),     IFNULL(Dat.RFCCR,Cadena_Vacia),               IFNULL(Dat.NumExpeCred,Cadena_Vacia),         IFNULL(Dat.ContratoCR,Cadena_Vacia),          IFNULL(Dat.CreditoIDAnt,Cadena_Vacia),
            IFNULL(Dat.FechaInicio,Cadena_Vacia),      IFNULL(Dat.Plazo,Cadena_Vacia),               IFNULL(Dat.TipoCredito,Cadena_Vacia),     IFNULL(Dat.SaldoInicial,Cadena_Vacia),        IFNULL(Dat.Moneda,Cadena_Vacia),              IFNULL(Dat.NumPagos,Cadena_Vacia),            IFNULL(Dat.FrecuenciaPag,Cadena_Vacia),
            IFNULL(Dat.ImportePago,Cadena_Vacia),      IFNULL(Dat.FechaUltPago,Cadena_Vacia),        IFNULL(Dat.FechaReestru,Cadena_Vacia),    IFNULL(Dat.PagoEfectivo,Cadena_Vacia),        IFNULL(Dat.FechaLiquida,Cadena_Vacia),        IFNULL(Dat.Quita,Cadena_Vacia),               IFNULL(Dat.Dacion,Cadena_Vacia),
            IFNULL(Dat.Quebranto,Cadena_Vacia),        IFNULL(Dat.ClaveObserva,Cadena_Vacia),        IFNULL(Dat.CredEspecial,Cadena_Vacia),    IFNULL(Dat.FechaPrimerIn,Cadena_Vacia),       IFNULL(Dat.SaldoInsoluto,Cadena_Vacia),       IFNULL(Dat.CredMaxUti,Cadena_Vacia),          IFNULL(Dat.FechIngCarVen,Cadena_Vacia),
            IFNULL(Dat.IdentificaDE,Cadena_Vacia),     IFNULL(Dat.RFCDE,Cadena_Vacia),               IFNULL(Dat.Contrato,Cadena_Vacia),        IFNULL(Dat.DiasVencido,Cadena_Vacia),         IFNULL(Dat.Saldo,Cadena_Vacia),               IFNULL(Dat.InteresCred,Cadena_Vacia),         IFNULL(Dat.CadenaAvales,Cadena_Vacia),
            IFNULL(Dat.IdentificaTS,Cadena_Vacia),     IFNULL(Dat.NumReportes,Cadena_Vacia),         IFNULL(Dat.TotalSaldos,Cadena_Vacia),       Salto_Linea);

    /*
        COLUMNA CSV     |   COLUMNA TABLA
        Importe de Pagos    ImportePago     SI APLICA
        Cantidad            Saldo           SI APLICA
    */

    INSERT INTO BUROCREDINTFPM
        (CintaID,   ClienteID,     Clave,  Fecha,  Cinta)
    SELECT
        Var_CintaID, Entero_Cero,  Entero_Cero, Par_FechaCorteBC, Dat.Cinta FROM TMPDATOSEM AS Dat ;

    IF (Var_TipoCreditoNV != Entero_Cero)THEN
                SET Var_Cinta:=CONCAT('LA COLUMNA TIPO DE CREDITO TIENE CAMPOS VACIOS,',Salto_Linea, 'CONFIGURAR TABLA: CLASIFICCREDITO');
                 INSERT INTO BUROCREDINTFPM
                        (CintaID,   ClienteID,     Clave,  Fecha,  Cinta)
                VALUES  (Var_CintaID, Entero_Cero,  Entero_Cero, Par_FechaCorteBC, Var_Cinta);
    END IF;

    -- Cuando la cinta es de tipo 2 es formato INTL
    -- Se invoca al sp que arma la cadena INTL
    IF(Par_TipoFormatoCinta = Entero_Dos)THEN
        CALL ARMACADENAINTLCINTAPMPRO(
            Par_FechaCorteBC,
            Con_NO,             Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
        );
    END IF;
    -- SE BORRAN REGISTROS DE LA TABLA PIVOTE
    DELETE FROM TMPDATOSEM;
    DROP TABLE IF EXISTS TMPDIRECTIVOSLISTA;
    DROP TABLE IF EXISTS TMPAVALESLISTA;

END ManejoErrores;

END TerminaStore$$