-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CINTAINTFPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CINTAINTFPRO`;
DELIMITER $$


CREATE PROCEDURE `CINTAINTFPRO`(
/* SP PARA CINTA DE BURO DE CREDITO DIARIO FORMATO CSV*/
  Par_FechaCorteBC  DATE,     -- Fecha de Corte para generar el reporte
  /* Parametros de Auditoria */
    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),

    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        	)

TerminaStore: BEGIN

  -- DECLARACION DE VARIABLES
  DECLARE TEST          VARCHAR(20);
  DECLARE ETIQUETA        VARCHAR(20);
  DECLARE Var_Cinta         VARCHAR(60000);
  DECLARE LONGITUD        DECIMAL;
  DECLARE Var_ClienteID       INT(11);

  DECLARE Var_ApellidoPaterno   VARCHAR(40);
  DECLARE Var_ApellidoMaterno   VARCHAR(40);
  DECLARE Var_Adicional     VARCHAR(40);
  DECLARE Var_PrimerNombre    VARCHAR(40);
  DECLARE Var_SegundoNombre   VARCHAR(50);

  DECLARE Var_TercerNombre    VARCHAR(50);
  DECLARE Var_Segundo       VARCHAR(40);
  DECLARE Var_FechaNacimiento   VARCHAR(40);
  DECLARE Var_RFC         VARCHAR(40);
  DECLARE Var_Prefijo       VARCHAR(40);

  DECLARE Var_EstadoCivil     VARCHAR(40);
  DECLARE Var_Sexo        VARCHAR(40);
  DECLARE Var_FechaDefuncion        VARCHAR(10);
  DECLARE Var_IndicadorDef          CHAR(2);
  DECLARE Var_CalleNumero     VARCHAR(80);

    DECLARE Var_Colonia       VARCHAR(80);
  DECLARE Var_Municipio     VARCHAR(80);
  DECLARE Var_estado        VARCHAR(40);
  DECLARE Var_CP          VARCHAR(40);
  DECLARE Var_Telefono      VARCHAR(40);

    DECLARE Var_member        VARCHAR(40);
  DECLARE Var_nombre        VARCHAR(40);
  DECLARE Var_Cuenta        VARCHAR(40);
  DECLARE Var_Responsabilidad   VARCHAR(40);
  DECLARE Var_TipoCuenta      VARCHAR(40);

    DECLARE Var_TipoContrato    VARCHAR(40);
  DECLARE Var_Moneda        VARCHAR(40);
  DECLARE Var_NPagos        VARCHAR(40);
  DECLARE Var_FrecPagos     VARCHAR(40);
  DECLARE Var_saldo       VARCHAR(40);

    DECLARE Var_vencido       VARCHAR(40);
  DECLARE Var_FechaInicio     VARCHAR(40);
  DECLARE Var_MontoCredito    VARCHAR(40);
  DECLARE Var_ImportePagos    VARCHAR(40);
  DECLARE Var_Incumplimiento    VARCHAR(40);

    DECLARE Var_LimiteCred      VARCHAR(40);
  DECLARE Var_FechaCompra     VARCHAR(40);
  DECLARE Var_FechaReporte    VARCHAR(40);
  DECLARE Var_FechaCierre     VARCHAR(40);
  DECLARE Var_NPagosVencidos    VARCHAR(40);

    DECLARE Var_NDiasAtraso     VARCHAR(40);
  DECLARE Var_MOP         VARCHAR(40);
  DECLARE Var_MOPInteres      VARCHAR(40);
  DECLARE Var_UltimoPago      VARCHAR(40);
  DECLARE Var_SVigente      INT(14) DEFAULT 0;

    DECLARE Var_SVencido      INT(14) DEFAULT 0;
  DECLARE Var_NSegmentos      INT(5) DEFAULT 0;
  DECLARE Var_FechaCorte      VARCHAR(40);
  DECLARE Var_SaldoTotal      VARCHAR(40);
  DECLARE hayRegistros      BOOLEAN DEFAULT TRUE;

  DECLARE `Member`        VARCHAR(40);
  DECLARE NombreEmp       VARCHAR(100);
  DECLARE Formato_Envio     VARCHAR(20);
  DECLARE EncabezadoCVS     VARCHAR(1500);
  DECLARE Var_CintaID       INT(11);


  DECLARE Var_ApellidoAdicional   VARCHAR(1);
  DECLARE Var_DirComplemento    VARCHAR(100);
  DECLARE Var_Ciudad        VARCHAR(50);

    DECLARE Var_Empresa       VARCHAR(101);
  DECLARE Var_CalleNumero2    VARCHAR(41);
  DECLARE Var_DirComplemento2   VARCHAR(41);
  DECLARE Var_Colonia2      VARCHAR(41);
  DECLARE Var_Municipio2      VARCHAR(41);

    DECLARE Var_Ciudad2       VARCHAR(41);
  DECLARE Var_Estado2       VARCHAR(40);
  DECLARE Var_CP2         VARCHAR(8);
  DECLARE Var_Telefono2     VARCHAR(40);
  DECLARE Var_Salario       VARCHAR(10);

    DECLARE Var_ClaveObservacion  VARCHAR(3);
  DECLARE Var_ClaveOtorAnt    VARCHAR(20);
  DECLARE Var_NombreOtorAnt   VARCHAR(40);
  DECLARE Var_NumCtaAnterior    VARCHAR(40);
  DECLARE Var_FechaAnterior   DATE;

    DECLARE Var_MontoUltPago    INT(11);
  DECLARE Var_MontoUltPagoCHAR  VARCHAR(40);
  DECLARE Var_DiasTrans     VARCHAR(40);
  DECLARE Var_DiasPago      VARCHAR(40);
  DECLARE Var_FechaRep      VARCHAR(40);

    DECLARE Var_InteresReportado  VARCHAR(40);
  DECLARE EstatusPagado       CHAR(1);
  DECLARE EstatusVigente      CHAR(1);
  DECLARE EstatusCastigado    CHAR(1);
  DECLARE EstatusVencido      CHAR(1);

  DECLARE DiasCtaReciente     INT(11);
  DECLARE Cadena_Vacia      CHAR(1);
  DECLARE Espacio_Blanco      CHAR(1);
  DECLARE Fecha_Vacia       DATE;
  DECLARE Entero_Cero       INT(11);

    DECLARE Entero_Uno        INT(11);
  DECLARE Formato_Cinta     VARCHAR(8);
  DECLARE Formato_Comas       VARCHAR(8);
  DECLARE Separador         CHAR(1);
  DECLARE Salto_Linea       VARCHAR(2);

    DECLARE Casado_BS       CHAR(2);
  DECLARE Casado_BM       CHAR(2);
  DECLARE Casado_BMC        CHAR(2);
  DECLARE Viudo         CHAR(1);
  DECLARE Union_libre       CHAR(1);

    DECLARE Casado_BC         CHAR(1);
  DECLARE Union_libreBC       CHAR(1);
  DECLARE Viudo_BC        CHAR(1);
  DECLARE EdoSeparado       CHAR(2);
  DECLARE SI_DiaHabil       CHAR(1);

  DECLARE No_DiaHabil       CHAR(1);
  DECLARE DiasMaxReporte      INT(2);
  DECLARE Fecha_Vaciaddmmyyyy   CHAR(8);
  DECLARE Var_TipoPersona     CHAR(1);
  DECLARE FechaMigracion      CHAR(8);

  DECLARE Var_PromagraID      VARCHAR(15);
  DECLARE Entero_Diez       INT(2);
  DECLARE Factor_Meses      DECIMAL(12,2);
  DECLARE Var_PlazoMeses      VARCHAR(6);
  DECLARE Var_Nacionalidad    CHAR(5);

  DECLARE Var_NacDomicilio    CHAR(5);
  DECLARE Var_NacDomicilio2   CHAR(5);
  DECLARE Var_DiaAtrFecFinCre   VARCHAR(11);
  DECLARE Var_CorreoElect     VARCHAR(50);
  DECLARE Var_FechaUltPagoVen   VARCHAR(10);

  DECLARE TipoPersFisica      CHAR(1);
  DECLARE TipoDomTrabajo      INT(11);
  DECLARE PaisMexico        INT(11);
  DECLARE DomicilioConocido   VARCHAR(50);
  DECLARE SinNumero       VARCHAR(3);

  DECLARE CalleConocido     VARCHAR(12);
  DECLARE CalleConocida     VARCHAR(12);
  DECLARE FormatoFecha      VARCHAR(10);
  DECLARE Str_SI          CHAR(1);
  DECLARE Str_NO          CHAR(1);

  DECLARE LimpiaAlfabetico    VARCHAR(2);   -- Limpieza de texto que contiene solo letras
  DECLARE LimpiaAlfaNumerico    VARCHAR(2);   -- Limpieza de texto que contiene letras y numeros
  DECLARE IndicadorDef          CHAR(1);
  DECLARE Mop01                 VARCHAR(3);
  DECLARE Mop97                 VARCHAR(3);
  DECLARE ClaveObsCtaCanc       CHAR(2);
  DECLARE ClaveObsCtaCauQue     CHAR(2);
  DECLARE ConsConsolidado       VARCHAR(2);         /*Cadena Consolidado*/
  -- Declara la constante que contendrá los datos de la cinta de buro
  DECLARE CINTABURO CURSOR FOR
    SELECT
      ClienteID,      ApellidoPaterno,    ApellidoMaterno,    Adicional,      PrimerNombre,
      SegundoNombre,    TercerNombre,     FechaNacimiento,    RFC,        Prefijo,
      EstadoCivil,    Sexo,                 FechaDefuncion,     IndicadorDefuncion,        CalleNumero,
      DirComplemento,   Colonia,        Municipio,        Ciudad,       Estado,
      CP,         Telefono,       Empresa,        CalleNumero2,   DirComplemento2,
      Colonia2,     Municipio2,       Ciudad2,        Estado2,      CP2,
      Telefono2,      Salario,        '' AS member,     '' AS Nombre,
      CASE IFNULL(CreditoIDCte,'') WHEN ''
              THEN CreditoIDSAFI
                ELSE CreditoIDCte
                  END AS Cuenta,
      Responsabilidad,  TipoCuenta,       TipoContrato,     Moneda,       NPagos,
      FrecPagos,      FechaInicio,      Vencido,        MontoCredito,   ImportePagos,
      Incumplimiento,   Saldo,          FechaCierre,      NoCuotasAtraso,   ClaveObervacion,
      DiasAtraso,     FechaPago,        MOP,          SaldoTotal,     TipoPersona,
      MontoUltPago,   PlazoCredito,     Nacionalidad,     DiasAtraso,     NacDomicilio,
      CorreoElect,    FechaUltPagoVen
        FROM DatosClientesCrePagados;

  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET hayRegistros = FALSE;

  SET EstatusPagado   :='P';
  SET EstatusVigente  :='V';
  SET EstatusCastigado:='K';
  SET EstatusVencido  :='B';
  SET DiasCtaReciente :=90;
  SET Cadena_Vacia  :='';
  SET Fecha_Vacia   :='1900-01-01';
  SET Entero_Cero   :=0;
  SET Entero_Uno    :=1;
  SET Formato_Cinta   :='INTF11';
  SET Formato_Comas :='CVS';
  SET Espacio_Blanco  :=' ';
  SET Separador   :=',';
  SET Salto_Linea   :='\n';
  SET Casado_BMC    :='CC';
  SET Casado_BM     :='CM';
  SET Casado_BS     :='CS';
  SET Viudo       :='V';
  SET Union_libre   :='U';
  SET Casado_BC     :='M';
  SET Viudo_BC    :='W';
  SET Union_libreBC   :='F';
  SET EdoSeparado     :='SE';

  SET Var_ApellidoAdicional :=',';
  SET Var_Prefijo       :=',';
  SET Var_CalleNumero2    :=',';
  SET Var_DirComplemento2   :=',';
  SET Var_Colonia2      :=',';
  SET Var_Municipio2      :=',';
  SET Var_Ciudad2       :=',';
  SET Var_Estado2       :=',';
  SET Var_CP2         :=',';
  SET Var_Telefono2     :=',';

  SET Var_ClaveOtorAnt    :=',';
  SET Var_NombreOtorAnt   :=',';
  SET Var_NumCtaAnterior    :=',';

  SET Var_NumCtaAnterior    :=',';
  SET Var_NombreOtorAnt   :=',';
  SET Var_ClaveOtorAnt    :=',';
  SET Var_Empresa       :=',';
  SET Var_Salario       :=',';
  SET Var_Ciudad        :=',';

  SET SI_DiaHabil       :='S';
  SET No_DiaHabil       :='N';
  SET DiasMaxReporte      :=0;
  SET Fecha_Vaciaddmmyyyy   :='01011900';
  SET FechaMigracion      :='30092014';
  SET Var_PromagraID      :='MIGRACION';
  SET Entero_Diez       :=10;

  SET TipoPersFisica      := 'F';
  SET TipoDomTrabajo      := 3;
  SET PaisMexico        := 700;
  SET DomicilioConocido   := 'DOMICILIO CONOCIDO SN';
  SET SinNumero       := 'SN';
  SET CalleConocido     := '%CONOCIDO%';
  SET CalleConocida     := '%CONOCIDA%';
  SET LimpiaAlfabetico    := 'A';
  SET LimpiaAlfaNumerico    := 'AN';
  SET Str_SI          := 'S';
  SET Str_NO          := 'N';
  SET FormatoFecha      := '%d%m%Y';
  SET IndicadorDef      :='Y';
  SET Mop01             := '01'; /* MOP para cuenta al corriente */
  SET Mop97             := '97'; /* MOP para cuenta con deuda parcial */
  SET ClaveObsCtaCanc   := 'CC';
  SET ClaveObsCtaCauQue := 'UP';
  SET ConsConsolidado  := 'CO';
  SET Formato_Envio     := Formato_Comas;

  SET Factor_Meses      := 30.4;
  -- encabezado de la cinta (de 5 en 5)
  SET EncabezadoCVS:=Cadena_Vacia;
    -- 1 - 10
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CLAVE_OTORGANTE_1,NOMBRE DEL OTORGANTE_1,FECHA DEL REPORTE,APELLIDO_PATERNO,APELLIDO_MATERNO,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'APELLIDO_ADICIONAL,PRIMER_NOMBRE,SEGUNDO_NOMBRE,FECHA_DE_NACIMIENTO,RFC,');
    -- 11 - 20
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'PREFIJO,NACIONALIDAD,ESTADO_CIVIL,SEXO,FECHA_DEFUNCION,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'INDICADOR_DEFUNCION,DIRECCION_CALLE_NUMERO,DIRECCION_COMPLEMENTO,COLONIA_O_POBLACION,DELEGACION_O_MUNICIPIO,');
    -- 21 - 30
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CIUDAD,ESTADO,C.P.,TELEFONO,DIRECCION_ORIGEN,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'EMPRESA,DIRECCION_CALLE_NUMERO_1,DIRECCION_COMPLEMENTO_1,COLONIA_O_POBLACION_1,DELEGACION_O_MUNICIPIO_1,');
    -- 31 - 40
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CIUDAD_1,ESTADO_1,C.P._1,TELEFONO_1,SALARIO,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'DIRECCION_ORIGEN,CLAVE_OTORGANTE,NOMBRE DEL OTORGANTE,NUMERO_CUENTA,TIPO_RESPONSABILIDAD_CUENTA,');
    -- 41 - 50
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'TIPO_CUENTA,TIPO_CONTRATO,MONEDA,NUMERO_DE_PAGOS,FRECUENCIA_DE_PAGOS,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'FECHA_APERTURA,MONTO_A_PAGAR,FECHA_ULTIMO_PAGO,FECHA_ULTIMA_COMPRA,FECHA_CIERRE_CREDITO,');
    -- 51 - 60
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'FECHA_REPORTE,CREDITO_MAXIMO,SALDO_ACTUAL,LIMITE_DE_CREDITO,SALDO_VENCIDO,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'NUMERO_PAGOS_VENCIDOS,FORMA_PAGO_MOP,CLAVE_OBSERVACION,CLAVE_ANTERIOR_OTORGANTE,NOMBRE_ANTERIOR_OTORGANTE,');
    -- 61 - 70
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'NUMERO_CTA_ANTERIOR,FECHA_PRIMER_INCUMPLIMIENTO,SALDO_INSOLUTO,MONTO_ULTIMO_PAGO,PLAZO_CREDITO,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'MONTO_CREDITO_ORIGINAL,FECHA_INGRESO_CARTERA_VENCIDA,MONTO_INTERESES,FORMA_PAGO_MOP_INTERESES,DIAS_VENCIMIENTO,');
    -- 71
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CORREO_ELECTRONICO',Salto_Linea);

  SET Var_FechaCorte    :=Par_FechaCorteBC;
  SET Var_FechaAnterior :=(SELECT DIASFESTIVOSINVERSA(Par_FechaCorteBC,DiasMaxReporte,No_DiaHabil,SI_DiaHabil));

  SELECT   ClaveInstitID,     Nombre
    INTO   `Member`,      NombreEmp
    FROM BUCREPARAMETROS;

  DELETE FROM BUROCREDINTF  WHERE Fecha=Par_FechaCorteBC;

  SET Var_CintaID := (SELECT COALESCE(MAX(CintaID),Entero_Cero) FROM BUROCREDINTF ) + Entero_Uno;

  DROP TABLE IF EXISTS TEMPORAL_PERIODICIDADBC;

  CREATE  TABLE TEMPORAL_PERIODICIDADBC (
    PeriodicidadID    INT(11) NOT NULL,
    FrecuenciaID      VARCHAR(2) NOT NULL,
    Periodicidad      VARCHAR(45) NULL,
    PeriodicidadAbrev   VARCHAR(10) NULL,
    FrecuenciaBC        VARCHAR(45) NULL,
    DiaMinimo       INT(5),
    DiaMaximo       INT(8),
    PRIMARY KEY (PeriodicidadID,FrecuenciaID));

  INSERT INTO TEMPORAL_PERIODICIDADBC VALUES
    (1,'S','SEMANAL','SEM.','W',1,10),
    (2,'C','CATORCENAL','CATORCNL','K',0,0),
    (3,'Q','QUINCENAL','QUIN.','S',11,20),
    (4,'M','MENSUAL','MEN','M',21,45),
    (5,'B','BIMESTRAL','BIM','B',46,75),
    (6,'T','TRIMESTRAL','TRIM','Q',76,105),
    (7,'R','TRIMESTRAL','TRIM','Q',76,105),
    (8,'E','SEMESTRAL','SEM','H',171,195),
    (9,'A','ANUAL','AN','Y',356,375),
    (10,'P','PERIODO','PER','V',0,0),
    (11,'L','LIBRES','LIB','V',0,0),
    (12,'U','UNICO','UN','V',106,170),
    (13,'U','UNICO','UN','V',196,355),
    (14,'U','UNICO','UN','V',376,99999999);

  -- creacion de la tabla temporal con los datos que contendra la cinta
  DROP TABLE IF EXISTS DatosClientesCrePagados;
  CREATE TABLE DatosClientesCrePagados(
    ClienteID   INT(11),    ApellidoPaterno VARCHAR(50),  ApellidoMaterno VARCHAR(50),  Adicional   VARCHAR(50),
    PrimerNombre  VARCHAR(50),  SegundoNombre VARCHAR(50),  TercerNombre  VARCHAR(50),  FechaNacimiento VARCHAR(10),
    RFC       VARCHAR(18),  Prefijo     VARCHAR(10),  EstadoCivil   CHAR(2),    Sexo      CHAR(1),
    FechaDefuncion      VARCHAR(8),  IndicadorDefuncion     CHAR(1),  CalleNumero   VARCHAR(100), Colonia     VARCHAR(200),
    Municipio   VARCHAR(100), Ciudad      VARCHAR(50),  Estado      VARCHAR(20),  `member`      VARCHAR(50),
    CP        CHAR(6),    Telefono    VARCHAR(10),  DirComplemento  VARCHAR(100), Empresa     VARCHAR(100),
    CalleNumero2  VARCHAR(40),  Colonia2    VARCHAR(40),  Municipio2    VARCHAR(40),  Ciudad2     VARCHAR(40),
    Estado2     VARCHAR(20),  CP2       CHAR(6),    Telefono2   VARCHAR(11),  DirComplemento2 VARCHAR(100),
    Salario     VARCHAR(10),  CreditoIDCte  VARCHAR(20),  Estatus     CHAR(1),    CreditoIDSAFI BIGINT(12),
    FechaPago   CHAR(8),    Incumplimiento  VARCHAR(8),   NPagos      INT(11),    FrecPagos   CHAR(2),
    Saldo     INT(11),    MontoCredito  INT(11),    Vencido     INT(11),    FechaInicio   CHAR(8),
    ImportePagos  INT(11),    FechaCierre   CHAR(8),    NoCuotasAtraso  INT(11),    DiasAtraso    INT(11),
    DiasPasoAtraso  INT(11),    SaldoTotal    INT(11),    MOP       CHAR(2),    TipoContrato  CHAR(8),
    Moneda      CHAR(5),    Responsabilidad CHAR(1),    TipoCuenta    CHAR(1),    TipoPersona   CHAR(1),
    ClaveObervacion CHAR(3),    MontoUltPago  INT(11),    Transaccion   BIGINT,     PlazoCredito  DECIMAL(12,2),
    Nacionalidad  CHAR(5),    PaisID      INT(11),    DiasAtraFecFinCre INT(11),    PaisResidencia  INT(11),
    NacDomicilio  CHAR(5),    CorreoElect   VARCHAR(50),  FechaUltPagoVen CHAR(8),    OcupacionID   INT(11),
  INDEX DatosClientesCrePagados1 (ClienteID),
  INDEX DatosClientesCrePagados2 (CreditoIDCte),
  INDEX DatosClientesCrePagados3 (CreditoIDSAFI));

  -- Insercion de los datos generales, los valores de saldos son actualizados posteriormente.
  INSERT INTO DatosClientesCrePagados(
  SELECT  MAX(Cli.ClienteID),         MAX(Cli.ApellidoPaterno),                   MAX(Cli.ApellidoMaterno),             Cadena_Vacia AS Adicional,
      MAX(Cli.PrimerNombre),        MAX(Cli.SegundoNombre),                     MAX(Cli.TercerNombre),                DATE_FORMAT(MAX(Cli.FechaNacimiento),FormatoFecha)AS FechaNacimiento,
      MAX(Cli.RFC),           MAX(Cli.Titulo) AS Prefijo,                   MAX(Cli.EstadoCivil),               MAX(Cli.Sexo),
      Cadena_Vacia AS FechaDefuncon,     Cadena_Vacia AS IndicadorDefuncion,
            LEFT(IF( (IFNULL(MAX(Dir.Calle),Cadena_Vacia)=Cadena_Vacia AND IFNULL(MAX(Dir.NumeroCasa),Cadena_Vacia)=Cadena_Vacia)OR(IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocida OR IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocido),
           DomicilioConocido,
                     CONCAT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),' ',IFNULL(MAX(Dir.NumeroCasa),SinNumero))),40) AS CalleNumero,
      TRIM(LEFT(CONCAT(MAX(Col.TipoAsenta),' ',MAX(Col.Asentamiento)),40)) AS Colonia,            TRIM(LEFT(MAX(Mun.Nombre),40)) AS Municipio,    TRIM(LEFT(MAX(Loc.NombreLocalidad),40)) AS Ciudad,
      MAX(Est.EqBuroCred) AS Estado,   Cadena_Vacia AS member,                   MAX(Dir.CP),                  MAX(Cli.Telefono),
      SUBSTRING(CONCAT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),' ', IFNULL(MAX(Dir.NumeroCasa),SinNumero)),41,(LENGTH(CONCAT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),' ',IFNULL(MAX(Dir.NumeroCasa),Cadena_Vacia))))) AS DirComplemento,
      IF(MAX(Cli.LugardeTrabajo)=Cadena_Vacia,MAX(Cli.NombreCompleto),MAX(Cli.LugardeTrabajo))  AS Empresa,
            LEFT(IF( (IFNULL(MAX(Dir.Calle),Cadena_Vacia)=Cadena_Vacia AND IFNULL(MAX(Dir.NumeroCasa),Cadena_Vacia)=Cadena_Vacia)OR(IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocida OR IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocido),
           DomicilioConocido,
                     CONCAT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),' ',IFNULL(MAX(Dir.NumeroCasa),SinNumero))),40) AS CalleNumero2,
            TRIM(LEFT(CONCAT(MAX(Col.TipoAsenta),' ',MAX(Col.Asentamiento)),40))  AS Colonia2,          TRIM(LEFT(MAX(Mun.Nombre),40)) AS Municipio2,   TRIM(LEFT(MAX(Loc.NombreLocalidad),40))  AS Ciudad2,
            MAX(Est.EqBuroCred) AS Estado2,   MAX(Dir.CP) AS CP2,                   SUBSTRING(Cli.Telefono,1,11) AS Telefono2,
      Cadena_Vacia  AS DirComplemento2,Cadena_Vacia AS Salario,                 MAX(EqC.CreditoIDCte),              MAX(Cre.Estatus),
      MAX(Cre.CreditoID),           DATE_FORMAT(Det.FechaPago,FormatoFecha) AS UltimoPago,    Cadena_Vacia AS Incumplimiento,         MAX(Cre.NumAmortizacion),
      Cadena_Vacia AS FrecuenciaBC,   Entero_Cero AS Saldo,                   MAX(Cre.MontoCredito),              Entero_Cero AS Vencido,
      DATE_FORMAT(MAX(Cre.FechaInicio),FormatoFecha) AS FechaIncio,
      Entero_Cero AS  ImportePagos, DATE_FORMAT(MAX(Cre.FechTerminacion),FormatoFecha) AS FechaCierre,  NULL AS NoCuotasAtraso,           NULL AS DiasAtraso,
      MAX(Pro.DiasPasoAtraso),    Entero_Cero AS  SaldoTotal,                 Cadena_Vacia AS MOP,
      CASE WHEN MAX(Cre.EsConsolidado) = Str_SI THEN
        ConsConsolidado
      ELSE
        MAX(Pro.TipoContratoBCID) END  AS TipoContratoBCID,
      Cadena_Vacia AS Moneda,     MAX(Pro.EsGrupal),                      MAX(Pro.EsRevolvente),              MAX(Cli.TipoPersona),
      Cadena_Vacia AS ClaveObervacion,Entero_Cero AS MontoUltPago,                MAX(Det.Transaccion),             MAX(Cre.PlazoID),
      Cadena_Vacia AS Nacionalidad, MAX(Cli.LugarNacimiento),                   Entero_Cero AS DiasAtraFecFinCre,         MAX(Cli.PaisResidencia),
            Cadena_Vacia AS NacDomicilio, MAX(Cli.Correo) AS CorreoElect,               Cadena_Vacia AS FechaUltPagoVen,       MAX(Cli.OcupacionID)
  FROM CREDITOS Cre
    LEFT  JOIN DETALLEPAGCRE  Det   ON  Cre.CreditoID = Det.CreditoID
    INNER JOIN PRODUCTOSCREDITO Pro   ON  Cre.ProductoCreditoID = Pro.ProducCreditoID
    LEFT  JOIN EQU_CREDITOS   EqC   ON  Det.CreditoID = EqC.CreditoIDSAFI
    INNER JOIN CLIENTES     Cli   ON  Cre.ClienteID = Cli.ClienteID
    INNER JOIN DIRECCLIENTE   Dir   ON  Cre.ClienteID = Dir.ClienteID AND Dir.Oficial = Str_SI
    INNER JOIN ESTADOSREPUB   Est   ON  Dir.EstadoID = Est.EstadoID
    INNER JOIN MUNICIPIOSREPUB  Mun   ON Dir.EstadoID = Mun.EstadoID    AND Dir.MunicipioID = Mun.MunicipioID
    INNER JOIN LOCALIDADREPUB   Loc   ON Dir.EstadoID = Loc.EstadoID    AND Dir.MunicipioID = Loc.MunicipioID
                                        AND Dir.LocalidadID = Loc.LocalidadID
    INNER JOIN COLONIASREPUB  Col   ON Dir.EstadoID = Col.EstadoID    AND Dir.MunicipioID = Col.MunicipioID
                                        AND Dir.ColoniaID = Col.ColoniaID
  WHERE Cre.Estatus IN (EstatusVigente,EstatusVencido,EstatusCastigado,EstatusPagado)
    AND (Det.FechaPago BETWEEN Var_FechaAnterior AND  Par_FechaCorteBC)
        AND Cli.TipoPersona = TipoPersFisica
    GROUP BY Det.FechaPago, Det.CreditoID);

  -- Se actualiza la fecha cierre de los creditos que fueron liquidados posterior a la fecha del reporte
  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI =Cre.CreditoID
  SET Dat.FechaCierre =Fecha_Vaciaddmmyyyy
  WHERE Cre.FechTerminacion > Par_FechaCorteBC;

  --  ==== Eliminamos Creditos que se desembolsaron posterior a la fecha corte
  DELETE FROM DatosClientesCrePagados
  WHERE CONVERT(SUBSTRING(FechaInicio,3,2),SIGNED)>MONTH(Var_FechaCorte)
  AND SUBSTRING(FechaInicio,5,4) = YEAR(Var_FechaCorte);

  --  ==== Eliminamos Creditos que se hayan liquidado anterior a la Fecha corte

  DELETE FROM DatosClientesCrePagados
  WHERE CONVERT(SUBSTRING(FechaCierre,3,2),SIGNED)<MONTH(Var_FechaCorte)
  AND SUBSTRING(FechaCierre,5,4) = YEAR(Var_FechaCorte);

  --  ==== Eliminamos Creditos que se hayan liquidado posterior a la Fecha corte

  DELETE FROM DatosClientesCrePagados
  WHERE CONVERT(SUBSTRING(FechaCierre,3,2),SIGNED)>MONTH(Var_FechaCorte)
  AND SUBSTRING(FechaCierre,5,4) = YEAR(Var_FechaCorte);

  DROP TABLE IF EXISTS Temp_ActuaFechaPagoCredito;
  CREATE TABLE Temp_ActuaFechaPagoCredito(
    CreditoID BIGINT(12),
    FechaPago DATE,
    MontoUltPag INT(11),
    PRIMARY KEY(CreditoID)
  );

  DROP TABLE IF EXISTS EstatusCreditos;

  CREATE TABLE EstatusCreditos(
    SELECT MAX(Dat.CreditoIDSAFI) AS CreditoIDSAFI, MAX(Sal.EstatusCredito) AS Estatus
      FROM DatosClientesCrePagados Dat
        INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoIDSAFI = Sal.CreditoID
      WHERE Sal.FechaCorte =Var_FechaCorte
    GROUP BY CreditoID);

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN EstatusCreditos Est ON Dat.CreditoIDSAFI = Est.CreditoIDSAFI
  SET Dat.Estatus=Est.Estatus;

  DROP TABLE IF EXISTS EstatusCreditos;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
  SET Dat.Estatus =EstatusPagado
  WHERE Cre.FechTerminacion <=Var_FechaCorte AND Cre.FechTerminacion <> '1900-01-01';

  -- Se Inicializan las Fechas de Pago
  UPDATE DatosClientesCrePagados
  SET FechaPago='01011900',MontoUltPago =0;

  -- Si el credito es migrado y no tiene registro en DETALLEPAGCRE
  -- SE TOMA LA FECHA LIQUIDA DE LA CUOTA
  INSERT INTO Temp_ActuaFechaPagoCredito(
     SELECT MAX(Cre.CreditoID) ,MAX(Amo.FechaLiquida),0
    FROM  CREDITOS Cre
      LEFT JOIN DETALLEPAGCRE  Det ON Cre.CreditoID = Det.CreditoID
      INNER JOIN AMORTICREDITO Amo ON Cre.CreditoID = Amo.CreditoID
    WHERE IFNULL(Det.CreditoID,Cadena_Vacia)= Cadena_Vacia
      AND   IFNULL(Amo.FechaLiquida,Fecha_Vacia)<>Fecha_Vacia
      AND   Amo.Estatus = EstatusPagado AND  Amo.FechaLiquida <= Var_FechaCorte
     GROUP BY Amo.CreditoID);

  UPDATE Temp_ActuaFechaPagoCredito tmp
    INNER JOIN DETALLEPAGCRE Det ON tmp.CreditoID = Det.CreditoID
  SET  tmp.MontoUltPag =ROUND(Det.MontoTotPago)
  WHERE Det.FechaPago = tmp.FechaPago;

  UPDATE DatosClientesCrePagados Det
    INNER JOIN Temp_ActuaFechaPagoCredito Tem ON Det.CreditoIDSAFI = Tem.CreditoID
  SET Det.FechaPago = DATE_FORMAT(Tem.FechaPago,FormatoFecha),Det.MontoUltPago=Tem.MontoUltPag
  WHERE Tem.FechaPago <=  Par_FechaCorteBC;

  TRUNCATE Temp_ActuaFechaPagoCredito;

  -- Se actualiza el valor del ultimo pago del Credito
  INSERT INTO Temp_ActuaFechaPagoCredito(
    SELECT MAX(Det.CreditoID)  , MAX(Det.FechaPago),Entero_Cero
      FROM DatosClientesCrePagados Dat
        INNER JOIN DETALLEPAGCRE Det ON Dat.CreditoIDSAFI = Det.CreditoID
    WHERE Det.FechaPago <= Var_FechaCorte
    GROUP BY CreditoID);

  -- Actualizamos Monto Ultimo Pago de Creditos que estan en DETPAGCRE
  DROP TABLE IF EXISTS Temp_UltimoPago;

  CREATE TABLE Temp_UltimoPago(
    CreditoID     BIGINT(12),
    MontUltimoPago  DECIMAL(14,2),
    FechaPago     DATE,
    PRIMARY KEY (CreditoID)
  );

  INSERT INTO  Temp_UltimoPago
    SELECT Det.CreditoID ,SUM(Det.MontoTotPago)AS MontUltimoPago ,MAX(tm.FechaPago) AS FechaPago
       FROM DatosClientesCrePagados Dat
        INNER JOIN Temp_ActuaFechaPagoCredito tm ON Dat.CreditoIDSAFI = tm.CreditoID
        INNER JOIN DETALLEPAGCRE Det ON Dat.CreditoIDSAFI = Det.CreditoID
    WHERE tm.FechaPago = Det.FechaPago
    GROUP BY Det.CreditoID;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN Temp_UltimoPago tm ON Dat.CreditoIDSAFI = tm.CreditoID
  SET Dat.MontoUltPago =ROUND(tm.MontUltimoPago),
    Dat.FechaPago = DATE_FORMAT(tm.FechaPago,FormatoFecha);

  DROP TABLE IF EXISTS Temp_ActuaFechaPagoCredito;
  DROP TABLE IF EXISTS Temp_UltimoPago;

  -- Se Inicializan las Fechas de Pago vacio

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI =Cre.CreditoID
  SET Dat.FechaCierre =Fecha_Vaciaddmmyyyy
  WHERE Cre.FechTerminacion > Par_FechaCorteBC;


  UPDATE DatosClientesCrePagados Det
    INNER JOIN CREDITOS Cre     ON Det.CreditoIDSAFI  = Cre.CreditoID
    INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID= Pro.ProducCreditoID
  SET Det.Responsabilidad = (CASE Pro.EsGrupal WHEN Str_NO THEN 'I'
                         WHEN Str_SI THEN 'J' END),
    Det.TipoCuenta = (CASE Pro.EsRevolvente WHEN Str_NO THEN 'I'
                         WHEN Str_SI THEN 'R' END);

-- ===== La Fecha de Incumplimiento se actualizan de acuerdo al comportamiento del Cliente durante el mes que se reporta

  DROP TABLE IF EXISTS Incumplimiento;

  CREATE TABLE Incumplimiento(
    Numero INT(11),
    CreditoID  BIGINT(12),
    FechaIncum DATE,
    PRIMARY KEY(Numero,CreditoID)
  );

  -- Creditos del Mes que probablemente incumplieron
  INSERT INTO Incumplimiento
    SELECT 1,MAX(Dat.CreditoIDSAFI),'1900-01-01' FROM DatosClientesCrePagados Dat
      INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoIDSAFI = Sal.CreditoID
    WHERE Sal.SalCapAtrasado >0 AND Sal.FechaCorte =Var_FechaCorte
      AND CONVERT(SUBSTRING(Dat.FechaInicio,3,2),SIGNED)=MONTH(Var_FechaCorte )
      AND SUBSTRING(Dat.FechaInicio,5,4) = YEAR(Var_FechaCorte )
    GROUP BY Sal.CreditoID;

  -- Creditos Migrados que probablemente incumplieron
  INSERT INTO Incumplimiento
    SELECT 2,MAX(Eq.CreditoIDSAFI),Fecha_Vacia FROM EQU_CREDITOS Eq
      INNER JOIN SALDOSCREDITOS Sal ON Eq.CreditoIDSAFI = Sal.CreditoID
    WHERE Sal.SalCapAtrasado >0
      AND Sal.FechaCorte =Var_FechaCorte
      AND Eq.FechaIncumplimiento= Fecha_Vacia
    GROUP BY Sal.CreditoID;

  -- 3 Se Actualiza La fecha de Incumpliento de los creditos
  INSERT INTO Incumplimiento
    SELECT 3,MAX(Dat.CreditoID),MIN(FechaCorte) FROM Incumplimiento Dat
      INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoID = Sal.CreditoID
    WHERE Sal.SalCapAtrasado >0
      AND Sal.FechaCorte>=Var_FechaAnterior
      AND Sal.FechaCorte <= Var_FechaCorte
    GROUP BY Sal.CreditoID;

  -- = Actualizamo los Creditos migrados su Fecha de Incumplimiento
  UPDATE EQU_CREDITOS Equ
    INNER JOIN  Incumplimiento Inc ON Equ.CreditoIDSAFI = Inc.CreditoID
  SET Equ.FechaIncumplimiento = Inc.FechaIncum
  WHERE Equ.FechaIncumplimiento =Fecha_Vacia AND Inc.Numero=3;

  -- = Insertamos la Fecha de Incumplimiento de los creditos del mes
  INSERT INTO EQU_CREDITOS
    SELECT Inc.CreditoID ,Inc.CreditoID ,Cadena_Vacia,Inc.FechaIncum FROM Incumplimiento Inc
      LEFT JOIN EQU_CREDITOS Equ ON Equ.CreditoIDSAFI = Inc.CreditoID
    WHERE IFNULL(CreditoIDSAFI,Cadena_Vacia)=Cadena_Vacia AND Numero=3;

  -- Actualizamos las Fechas de Incumplimiento en el la tabla DatosClientesCrePagados
  UPDATE DatosClientesCrePagados Dat
    INNER JOIN EQU_CREDITOS EqC  ON Dat.CreditoIDSAFI = EqC.CreditoIDSAFI
  SET Dat.Incumplimiento = DATE_FORMAT(EqC.FechaIncumplimiento,FormatoFecha)
  WHERE  IFNULL(EqC.FechaIncumplimiento,Fecha_Vacia) <> Fecha_Vacia;

  -- Si la Fecha de incumplimiento es mayor a la Fechacorte dejamos vacio el campo
  UPDATE DatosClientesCrePagados Dat
    INNER JOIN EQU_CREDITOS EqC  ON Dat.CreditoIDSAFI = EqC.CreditoIDSAFI
  SET Dat.Incumplimiento = Cadena_Vacia
  WHERE  IFNULL(EqC.FechaIncumplimiento,Fecha_Vacia) >= Var_FechaCorte ;

  DROP TABLE IF EXISTS Incumplimiento;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
    INNER JOIN TEMPORAL_PERIODICIDADBC Tem ON Cre.FrecuenciaCap = Tem.FrecuenciaID
  SET Dat.FrecPagos = Tem.FrecuenciaBC
  WHERE Dat.FrecPagos <>'U';

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS                Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
    INNER JOIN TEMPORAL_PERIODICIDADBC tmp ON  DATEDIFF(Cre.FechaVencimien,Cre.FechaInicio) >= tmp.DiaMinimo
                         AND DATEDIFF(Cre.FechaVencimien,Cre.FechaInicio) <= tmp.DiaMaximo
  SET Dat.FrecPagos = tmp.FrecuenciaBC
   WHERE Dat.FrecPagos ='U' ;

  DROP TABLE IF EXISTS TEMPORAL_PERIODICIDADBC;

  DROP TABLE IF EXISTS Tem_SumaSaldoCapCreditos;
  CREATE TABLE Tem_SumaSaldoCapCreditos(
    CreditoID   BIGINT(12),
    Saldo     DECIMAL(14,2),
    Vencido     DECIMAL(14,2),
    SaldoTotal  DECIMAL(14,2),
    PRIMARY KEY (CreditoID)
  );

  INSERT INTO Tem_SumaSaldoCapCreditos(
    SELECT MAX(Dat.CreditoIDSAFI) AS CreditoIDSAFI,
         IFNULL(ROUND(SUM(Sal.salCapVigente + Sal.SalCapAtrasado +
                      Sal.SalCapVencido + Sal.SalCapVenNoExi)),Entero_Cero) AS Saldo,
         IFNULL(ROUND(SUM((Sal.salCapAtrasado)+(Sal.SalCapVencido)
              +(Sal.SalCapVenNoExi))),Entero_Cero) AS Vencido,
         IFNULL(ROUND(SUM((Sal.SalCapVigente) + (Sal.SalCapAtrasado) +
              (Sal.SalCapVencido) + (Sal.SalCapVenNoExi) +
              (Sal.SalIntOrdinario)+(Sal.SalIntAtrasado) +
              (Sal.SalIntVencido) + (Sal.SalIntProvision) +
              (Sal.SalIntNoConta) + (Sal.SalMoratorios) +
              (Sal.SaldoMoraVencido)+(Sal.SaldoMoraCarVen) +
              (Sal.SalComFaltaPago) + (Sal.SaldoComServGar) + (Sal.SalOtrasComisi) +
              (Sal.SalIVAInteres)+(Sal.SalIVAMoratorios) +
              (Sal.SalIVAComFalPago)+ (Sal.SaldoIVAComSerGar)+(Sal.SalIVAComisi)))
              ,Entero_Cero) AS SaldoTotal
      FROM DatosClientesCrePagados Dat
        INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoIDSAFI = Sal.CreditoID
      WHERE Sal.FechaCorte =Par_FechaCorteBC
      GROUP BY Sal.CreditoID);

	-- INICIO Notas de Cargo

	DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOINTFDIA;
	CREATE TEMPORARY TABLE TMPEXIGIBLESNOTASCARGOINTFDIA (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		MontoExigible			DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOINTFDIA;
	CREATE TEMPORARY TABLE TMPPAGOSNOTASCARGOINTFDIA (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	-- Montos de notas de cargo registradas a fecha corte
	INSERT INTO TMPEXIGIBLESNOTASCARGOINTFDIA (	CreditoID,			Monto,									MontoExigible	)
									SELECT		NTC.CreditoID,		ROUND(SUM(ROUND(NTC.Monto, 2)), 2),		Entero_Cero
										FROM	NOTASCARGO NTC
										INNER JOIN DatosClientesCrePagados TMP ON TMP.CreditoIDSAFI = NTC.CreditoID AND NTC.FechaRegistro <= Par_FechaCorteBC
										INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = NTC.CreditoID AND NTC.AmortizacionID = AMO.AmortizacionID AND AMO.FechaExigible <= Par_FechaCorteBC
										GROUP BY NTC.CreditoID, AMO.CreditoID;

	-- Montos pagados de notas de cargo a fechas exigibles
	INSERT INTO TMPPAGOSNOTASCARGOINTFDIA (	CreditoID,			Monto	)
								SELECT		DET.CreditoID,		ROUND(SUM(ROUND(DET.MontoNotasCargo, 2)), 2)
									FROM	TMPEXIGIBLESNOTASCARGOINTFDIA TMP
									INNER JOIN DETALLEPAGCRE DET ON DET.CreditoID = TMP.CreditoID AND DET.FechaPago <= Par_FechaCorteBC
									INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID and DET.AmortizacionID = AMO.AmortizacionID AND AMO.FechaExigible <= Par_FechaCorteBC
									GROUP BY DET.CreditoID, AMO.CreditoID;

	-- Exigible de notas de cargo a fecha corte
	UPDATE TMPEXIGIBLESNOTASCARGOINTFDIA NTC
		INNER JOIN TMPPAGOSNOTASCARGOINTFDIA PAG ON NTC.CreditoID = PAG.CreditoID
	SET	NTC.MontoExigible = ROUND(NTC.Monto - PAG.Monto, 2);

	UPDATE TMPEXIGIBLESNOTASCARGOINTFDIA
	SET	MontoExigible = Entero_Cero
	WHERE MontoExigible < Entero_Cero;

	-- FIN Notas de Cargo

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN Tem_SumaSaldoCapCreditos Tem ON Dat.CreditoIDSAFI = Tem.CreditoID
  SET Dat.Saldo = Tem.Saldo, Dat.Vencido = Tem.Vencido, Dat.SaldoTotal = Tem.SaldoTotal;

	UPDATE DatosClientesCrePagados TMP
		INNER JOIN TMPEXIGIBLESNOTASCARGOINTFDIA NTC ON NTC.CreditoID = TMP.CreditoIDSAFI
	SET	TMP.SaldoTotal = ROUND(TMP.SaldoTotal + NTC.MontoExigible, 2);

	DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOINTFDIA;
	DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOINTFDIA;

  DROP TABLE IF EXISTS Tem_SumaSaldoCapCreditos;

  UPDATE DatosClientesCrePagados
    SET ImportePagos = FUNCIONIMPORTEPAGO(CreditoIDSAFI,Par_FechaCorteBC);

  -- == Se mensualiza El Monto de Pagos (ImportePago) ========
  DROP TABLE IF EXISTS MontoCuotaCredito;

  CREATE TABLE MontoCuotaCredito (
    CreditoID BIGINT(12),
    MontoPago INT(11),
    PRIMARY KEY (CreditoID)
    );

  INSERT INTO MontoCuotaCredito
    SELECT MAX(Dat.CreditoIDSAFI) AS CreditoID ,
        ROUND(SUM(Pag.Capital + Pag.Interes + Pag.IVAInteres)) AS MontoPago
      FROM DatosClientesCrePagados Dat
        INNER JOIN PAGARECREDITO Pag ON Dat.CreditoIDSAFI = Pag.CreditoID
    WHERE Pag.AmortizacionID= 1 AND Dat.FrecPagos IN ('W','K','S','M','B','Q','H','Y')
     GROUP BY Pag.CreditoID;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN MontoCuotaCredito Mon ON Dat.CreditoIDSAFI = Mon.CreditoID
  SET Dat.ImportePagos =(CASE Dat.FrecPagos WHEN 'W' THEN (Mon.MontoPago * 4)
            WHEN 'K' THEN (Mon.MontoPago * 2)
            WHEN 'S' THEN (Mon.MontoPago * 2)
            WHEN 'M' THEN Mon.MontoPago
            WHEN 'B' THEN ROUND(Mon.MontoPago / 2)
            WHEN 'Q' THEN ROUND(Mon.MontoPago /2)
            WHEN 'H' THEN ROUND(Mon.MontoPago /6)
            WHEN 'Y' THEN ROUND(Mon.MontoPago /12)
              END );

  DROP TABLE IF EXISTS MontoCuotaCredito;

  -- == Se mensualiza El Monto de Pagos (ImportePago) FIN ========
  UPDATE DatosClientesCrePagados  Dat
    INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoIDSAFI = Sal.CreditoID
  SET Dat.DiasAtraso = Sal.DiasAtraso, Dat.NoCuotasAtraso=Sal.NoCuotasAtraso
  WHERE Sal.FechaCorte =Par_FechaCorteBC;


  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
    INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
  SET Vencido = Entero_Cero
  WHERE (IFNULL(Dat.DiasAtraso,Entero_Cero) - IFNULL(Pro.DiasPasoAtraso,Entero_Cero))<= Entero_Cero;

  UPDATE DatosClientesCrePagados TMPD, CARCREDITOSUSPENDIDO CC
    SET TMPD.FechaDefuncion = DATE_FORMAT(CC.FechaDefuncion, FormatoFecha),
        TMPD.IndicadorDefuncion = IndicadorDef
    WHERE TMPD.CreditoIDSAFI = CC.CreditoID;

  DROP TABLE IF EXISTS temp_RangoMOP;
  CREATE TABLE temp_RangoMOP(
    NoConseMOP     INT(11),
    LimiteInferior INT(11),
    LimiteSuperior BIGINT(11),
    MOP        CHAR(2),
    PRIMARY KEY    (NoConseMOP),
    INDEX temp_RangoMOP1 (MOP)
  );

  INSERT INTO temp_RangoMOP VALUES
    (1,0,0,'01'),
    (2,1,29,'02'),
    (3,30,59,'03'),
    (4,60,89,'04'),
    (5,90,119,'05'),
    (6,120,149,'06'),
    (7,150,360,'07'),
    (8,360,9999999999,'96');

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP ='00'
  WHERE DATEDIFF(Par_FechaCorteBC,Cre.FechaInicio)<=DiasCtaReciente
    AND Cre.Estatus =EstatusVigente
    AND Dat.DiasAtraso =Entero_Cero;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    INNER  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP ='01'
  WHERE  Cre.Estatus =EstatusVigente
    AND IFNULL(Dat.DiasAtraso,Entero_Cero)= Entero_Cero;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP ='02'
  WHERE Dat.DiasAtraso  BETWEEN 1 AND 29;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP ='03'
  WHERE Dat.DiasAtraso  BETWEEN 30 AND 59;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP ='04'
  WHERE Dat.DiasAtraso  BETWEEN 60 AND 89;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP ='05'
  WHERE Dat.DiasAtraso  BETWEEN 90 AND 119;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP ='06'
  WHERE Dat.DiasAtraso  BETWEEN 120 AND 149;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP ='07'
  WHERE Dat.DiasAtraso  BETWEEN 150 AND 365;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP ='96'
  WHERE Dat.DiasAtraso>365;

  UPDATE DatosClientesCrePagados
  SET MOP ='01'
  WHERE FechaCierre <>'01011900';

  DROP TABLE IF EXISTS temp_RangoMOP;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN  CRECASTIGOS Cas ON Dat.CreditoIDSAFI = Cas.CreditoID
  SET Dat.FechaCierre = DATE_FORMAT(Cas.Fecha,FormatoFecha), Dat.ClaveObervacion='LC', MOP ='97'
  WHERE Dat.Estatus=EstatusCastigado;

  UPDATE DatosClientesCrePagados
    SET Incumplimiento = Fecha_Vaciaddmmyyyy
  WHERE IFNULL(Incumplimiento,Cadena_Vacia)=Cadena_Vacia;

  UPDATE DatosClientesCrePagados
    SET NoCuotasAtraso = Entero_Cero
  WHERE IFNULL(NoCuotasAtraso,Cadena_Vacia) =Cadena_Vacia;

  UPDATE DatosClientesCrePagados
    SET Telefono = Cadena_Vacia
  WHERE LENGTH(Telefono) <> Entero_Diez;

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN DETALLEPAGCRE Det ON Dat.CreditoIDSAFI =  Det.CreditoID
  SET Dat.MontoUltPago  = IFNULL(ROUND(Det.MontoTotPago),0)
  WHERE Det.FechaPago = CONCAT(SUBSTRING(Dat.FechaPago,5,8),'-',SUBSTRING(Dat.FechaPago,3,2),'-',SUBSTRING(Dat.FechaPago,1,2));

  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
    INNER JOIN MONEDAS  Mon ON Cre.MonedaID    = Mon.MonedaID
  SET Dat.Moneda = Mon.EqBuroCred;

  -- Limpieza nombre del cliente
  UPDATE DatosClientesCrePagados SET
    ApellidoPaterno = FNLIMPIACARACTBUROCRED(ApellidoPaterno,LimpiaAlfabetico),
        ApellidoMaterno = FNLIMPIACARACTBUROCRED(ApellidoMaterno,LimpiaAlfabetico),
        PrimerNombre    = FNLIMPIACARACTBUROCRED(PrimerNombre,LimpiaAlfabetico),
        SegundoNombre = FNLIMPIACARACTBUROCRED(SegundoNombre,LimpiaAlfabetico),
        TercerNombre  = FNLIMPIACARACTBUROCRED(TercerNombre,LimpiaAlfabetico),
        Prefijo     = FNLIMPIACARACTBUROCRED(Prefijo,LimpiaAlfabetico);

  UPDATE DatosClientesCrePagados CRE
    INNER JOIN CREDITOSPLAZOS PLA ON CRE.PlazoCredito = PLA.PlazoID
  SET CRE.PlazoCredito=PLA.Dias/Factor_Meses;

  -- Actualizamos la nacionalidad del domicilio de cliente
  UPDATE DatosClientesCrePagados Dat
    INNER JOIN PAISES Pa ON Dat.PaisResidencia = Pa.PaisID
  SET NacDomicilio = Pa.EqBuroCred;

  -- Actualizamos la nacionalidad del cliente
  UPDATE DatosClientesCrePagados Dat
    INNER JOIN PAISES Pa ON Dat.PaisID = Pa.PaisID
  SET Nacionalidad = Pa.EqBuroCred;

  -- == Se indica los dias de Vencimiento del Credito
  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS  Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
  SET DiasAtraFecFinCre = IF(DATEDIFF(Cre.FechaVencimien,Var_FechaCorte)<Entero_Cero,Entero_Cero,DATEDIFF(Cre.FechaVencimien,Var_FechaCorte))
  WHERE  Dat.DiasAtraso > 0 AND Cre.FechaVencimien <= Var_FechaCorte;

  UPDATE DatosClientesCrePagados
  SET MOP='00'
  WHERE CONVERT(SUBSTRING(FechaInicio,3,2),SIGNED)=MONTH(Var_FechaCorte)
    AND SUBSTRING(FechaInicio,5,4) = YEAR(Var_FechaCorte)
        AND MOP='01'
        AND FechaPago='01011900';

  -- == Se indica los dias de Vencimiento de pago del Credito
  UPDATE DatosClientesCrePagados Dat
    INNER JOIN CREDITOS cre ON Dat.CreditoIDSAFI=cre.CreditoID
  SET Dat.FechaUltPagoVen = DATE_FORMAT(cre.FechaVencimien,FormatoFecha)
  WHERE Dat.Estatus = EstatusVencido
    AND cre.FechaVencimien<= Var_FechaCorte
    AND Dat.DiasAtraso > 0;

    DROP TABLE IF EXISTS TMP_OCUPACIONES;
  CREATE TEMPORARY TABLE TMP_OCUPACIONES(
    OcupacionID   INT(11),
        Descripcion   VARCHAR(50),
        INDEX(OcupacionID)
    );

    INSERT INTO TMP_OCUPACIONES (OcupacionID, Descripcion)
    SELECT OcupacionID,'LABORES DEL HOGAR'
      FROM OCUPACIONES
        WHERE Descripcion LIKE '%casa%' AND ImplicaTrabajo = Str_NO;

  INSERT INTO TMP_OCUPACIONES (OcupacionID, Descripcion)
    SELECT OcupacionID,'ESTUDIANTE'
      FROM OCUPACIONES
        WHERE Descripcion LIKE '%estudiante%' AND ImplicaTrabajo = Str_NO;

  INSERT INTO TMP_OCUPACIONES (OcupacionID, Descripcion)
    SELECT OcupacionID,'JUBILADO'
      FROM OCUPACIONES
        WHERE Descripcion LIKE '%jubilado%' AND ImplicaTrabajo = Str_NO;

  INSERT INTO TMP_OCUPACIONES (OcupacionID, Descripcion)
    SELECT OcupacionID,'DESEMPLEADO'
      FROM OCUPACIONES
        WHERE (Descripcion LIKE '%desempleado%' OR Descripcion LIKE '%desocupado%') AND ImplicaTrabajo = Str_NO;

    UPDATE DatosClientesCrePagados Dat
    INNER JOIN TMP_OCUPACIONES tmp ON Dat.OcupacionID=tmp.OcupacionID
    SET Dat.Empresa     = tmp.Descripcion
    WHERE Dat.TipoPersona   = TipoPersFisica;

    DROP TABLE IF EXISTS TMP_OCUPACIONES;

    -- Cuenta Cancelada o cerrada
    UPDATE DatosClientesCrePagados Dat
        SET Dat.ClaveObervacion = ClaveObsCtaCanc
    WHERE Dat.SaldoTotal = Entero_Cero
        AND Dat.Vencido = Entero_Cero
        AND Dat.MOP = Mop01
        AND Dat.ImportePagos = Entero_Cero
        AND Dat.FechaCierre = DATE_FORMAT(Par_FechaCorteBC, FormatoFecha);

    -- Cuenta  quebrantada
    UPDATE DatosClientesCrePagados Dat
        SET Dat.ClaveObervacion = ClaveObsCtaCauQue
    WHERE Dat.SaldoTotal > Entero_Cero
        AND Dat.Vencido > Entero_Cero
        AND Dat.MOP = Mop97
        AND Dat.ImportePagos > Entero_Cero
        AND (Dat.FechaCierre = Fecha_Vaciaddmmyyyy
            OR Dat.FechaCierre <> Fecha_Vaciaddmmyyyy);

  IF (Formato_Envio=Formato_Comas) THEN
    SET Separador   :=  ',';
    SET Var_Cinta     :=  EncabezadoCVS;
    SET Var_FechaCorte  :=  CONCAT(COALESCE(DATE_FORMAT(Var_FechaCorte,FormatoFecha),Cadena_Vacia),Separador) ;

    INSERT INTO BUROCREDINTF
          (CintaID,   ClienteID,    Clave,  Fecha,        Cinta)
      VALUES  (Var_CintaID, Entero_Cero,  `Member`, Par_FechaCorteBC, Var_Cinta);

    OPEN CINTABURO;
      FETCH CINTABURO INTO
          Var_ClienteID,      Var_ApellidoPaterno,  Var_ApellidoMaterno,  Var_Adicional,    Var_PrimerNombre,
          Var_SegundoNombre,    Var_TercerNombre,   Var_FechaNacimiento,  Var_RFC,      Var_Prefijo,
          Var_EstadoCivil,    Var_Sexo,       Var_FechaDefuncion,       Var_IndicadorDef,      Var_CalleNumero,
          Var_DirComplemento,   Var_Colonia,      Var_Municipio,      Var_Ciudad,     Var_estado,
          Var_CP,         Var_Telefono,     Var_Empresa,      Var_CalleNumero2, Var_DirComplemento2,
          Var_Colonia2,     Var_Municipio2,     Var_Ciudad2,      Var_Estado2,    Var_CP2,
          Var_Telefono2,      Var_Salario,      Var_member,       Var_nombre,     Var_Cuenta,
          Var_Responsabilidad,  Var_TipoCuenta,     Var_TipoContrato,   Var_Moneda,     Var_NPagos,
          Var_FrecPagos,      Var_FechaInicio,    Var_vencido,      Var_MontoCredito, Var_ImportePagos,
          Var_Incumplimiento,   Var_saldo,        Var_FechaCierre,    Var_NPagosVencidos, Var_ClaveObservacion,
          Var_NDiasAtraso,    Var_UltimoPago,     Var_MOP,        Var_SaldoTotal,   Var_TipoPersona,
          Var_MontoUltPago,   Var_PlazoMeses,     Var_Nacionalidad,   Var_DiaAtrFecFinCre,Var_NacDomicilio,
          Var_CorreoElect,    Var_FechaUltPagoVen;

      WHILE hayRegistros DO

        SET Var_EstadoCivil:= (CASE Var_EstadoCivil
                      WHEN Casado_BM  THEN Casado_BC
                      WHEN Casado_BMC THEN Casado_BC
                      WHEN Casado_BS  THEN Casado_BC
                      WHEN Viudo    THEN Viudo_BC
                      WHEN Union_libre THEN Union_libreBC
                      WHEN EdoSeparado THEN Cadena_Vacia
                        ELSE LEFT(Var_EstadoCivil,1)
                    END);

        IF(Var_Prefijo='SRITA') THEN
          SET Var_Prefijo :='SRTA';
        END IF;

        IF(Var_FechaCierre != Fecha_Vaciaddmmyyyy) THEN
          SET Var_SaldoTotal    :=Entero_Cero;
          SET Var_NPagosVencidos  :=Entero_Cero;
          SET Var_Incumplimiento  :=Fecha_Vaciaddmmyyyy;
          SET Var_ImportePagos  := Entero_Cero;
        ELSE
          SET Var_FechaCierre := Cadena_Vacia;
        END IF;

        IF(LENGTH(Var_Telefono) != 10) THEN
          SET Var_Telefono :=Cadena_Vacia;
        END IF;

        IF(LENGTH(Var_RFC) != 13 AND Var_TipoPersona !='M') THEN
          SET Var_RFC :=Cadena_Vacia;
        END IF;

        IF (Var_MOP ='97') THEN -- Para CreditosCastigados
          SET Var_saldo       := Entero_Cero;
          SET Var_ImportePagos  := Entero_Cero;
          SET Var_ClaveObservacion:='UP';
        END IF;

        SET Var_CalleNumero   := FNLIMPIACARACTBUROCRED(Var_CalleNumero,LimpiaAlfaNumerico);
        SET Var_DirComplemento  := FNLIMPIACARACTBUROCRED(Var_DirComplemento,LimpiaAlfaNumerico);
        SET Var_Colonia     := FNLIMPIACARACTBUROCRED(Var_Colonia,LimpiaAlfaNumerico);
        SET Var_Ciudad      := FNLIMPIACARACTBUROCRED(Var_Ciudad,LimpiaAlfaNumerico);
        SET Var_Municipio   := FNLIMPIACARACTBUROCRED(Var_Municipio,LimpiaAlfaNumerico);
        SET Var_estado      := FNLIMPIACARACTBUROCRED(Var_estado,LimpiaAlfabetico);

        SET Var_Empresa     := FNLIMPIACARACTBUROCRED(Var_Empresa,LimpiaAlfaNumerico);

        SET Var_CalleNumero2  := FNLIMPIACARACTBUROCRED(Var_CalleNumero2,LimpiaAlfaNumerico);
        SET Var_DirComplemento2 := FNLIMPIACARACTBUROCRED(Var_DirComplemento2,LimpiaAlfaNumerico);
        SET Var_Colonia2    := FNLIMPIACARACTBUROCRED(Var_Colonia2,LimpiaAlfaNumerico);
        SET Var_Ciudad2     := FNLIMPIACARACTBUROCRED(Var_Ciudad2,LimpiaAlfaNumerico);
        SET Var_Municipio2    := FNLIMPIACARACTBUROCRED(Var_Municipio2,LimpiaAlfaNumerico);
        SET Var_Estado2     := FNLIMPIACARACTBUROCRED(Var_Estado,LimpiaAlfabetico);

        SET Var_ApellidoPaterno := IFNULL(IF(Var_ApellidoPaterno=Cadena_Vacia,NULL,Var_ApellidoPaterno),'NO PROPORCIONADO');
        SET Var_ApellidoMaterno := IFNULL(IF(Var_ApellidoMaterno=Cadena_Vacia,NULL,Var_ApellidoMaterno),'NO PROPORCIONADO');
        SET Var_ApellidoPaterno := CONCAT(COALESCE(Var_ApellidoPaterno,Cadena_Vacia),Separador) ;
        SET Var_ApellidoMaterno := CONCAT(COALESCE(Var_ApellidoMaterno,Cadena_Vacia),Separador) ;
        SET Var_PrimerNombre  := CONCAT(COALESCE(Var_PrimerNombre,Cadena_Vacia),Separador );
        SET Var_SegundoNombre := IFNULL(Var_SegundoNombre,Cadena_Vacia);
        SET Var_TercerNombre  := IFNULL(Var_TercerNombre,Cadena_Vacia);

        SET Var_Segundo     := TRIM(CONCAT(Var_SegundoNombre,' ',Var_TercerNombre));
        SET Var_Segundo     := CONCAT(COALESCE(Var_Segundo,Cadena_Vacia),Separador) ;
        SET Var_FechaNacimiento := CONCAT(COALESCE(Var_FechaNacimiento,Cadena_Vacia),Separador) ;
        SET Var_RFC       := CONCAT(COALESCE(Var_RFC,Cadena_Vacia),Separador) ;
        SET Var_Prefijo     := CONCAT(COALESCE(Var_Prefijo,Cadena_Vacia),Separador);
        SET Var_EstadoCivil   := CONCAT(COALESCE(Var_EstadoCivil,Cadena_Vacia),Separador) ;
        SET Var_Sexo      := CONCAT(COALESCE(Var_Sexo,Cadena_Vacia),Separador);
        SET Var_FechaDefuncion := CONCAT(COALESCE(Var_FechaDefuncion,Cadena_Vacia),Separador);
        SET Var_IndicadorDef    := CONCAT(COALESCE(Var_IndicadorDef,Cadena_Vacia),Separador);
        SET Var_CalleNumero   := CONCAT(COALESCE(Var_CalleNumero,Cadena_Vacia),Separador) ;
        SET Var_DirComplemento  := CONCAT(COALESCE(Var_DirComplemento,Cadena_Vacia),Separador) ;
        SET Var_Colonia     := CONCAT(COALESCE(Var_Colonia,Cadena_Vacia),Separador) ;
        SET Var_Municipio     := CONCAT(COALESCE(Var_Municipio,Cadena_Vacia),Separador) ;
        SET Var_Ciudad      := CONCAT(COALESCE(Var_Ciudad,Cadena_Vacia),Separador);
        SET Var_estado      := CONCAT(COALESCE(Var_estado,Cadena_Vacia),Separador) ;
        SET Var_CP        := CONCAT(COALESCE(Var_CP,Cadena_Vacia),Separador) ;

        SET Var_Empresa     :=  CONCAT(COALESCE(Var_Empresa,Cadena_Vacia),Separador);
        SET Var_CalleNumero2  :=  CONCAT(COALESCE(Var_CalleNumero2,Cadena_Vacia),Separador);
        SET Var_DirComplemento2 :=  CONCAT(COALESCE(Var_DirComplemento2,Cadena_Vacia),Separador);
        SET Var_Colonia2    :=  CONCAT(COALESCE(Var_Colonia2,Cadena_Vacia),Separador);
        SET Var_Municipio2    :=  CONCAT(COALESCE(Var_Municipio2,Cadena_Vacia),Separador);
        SET Var_Ciudad2     :=  CONCAT(COALESCE(Var_Ciudad2,Cadena_Vacia),Separador);
        SET Var_Estado2     :=  CONCAT(COALESCE(Var_Estado2,Cadena_Vacia),Separador);
        SET Var_CP2       :=  CONCAT(COALESCE(Var_CP2,Cadena_Vacia),Separador);
        SET Var_Telefono2   :=  CONCAT(COALESCE(Var_Telefono2,Cadena_Vacia),Separador);
        SET Var_Salario     :=  CONCAT(COALESCE(Var_Salario,Cadena_Vacia),Separador);

        SET Var_member      := CONCAT(COALESCE(`Member`,Cadena_Vacia),Separador);
        SET Var_nombre      := CONCAT(COALESCE(NombreEmp,Cadena_Vacia),Separador) ;
        SET Var_Cuenta      := CONCAT(COALESCE(Var_Cuenta,Cadena_Vacia),Separador) ;
        SET Var_Responsabilidad := CONCAT(COALESCE(Var_Responsabilidad,Cadena_Vacia),Separador);
        SET Var_TipoCuenta    := CONCAT(COALESCE(Var_TipoCuenta,Cadena_Vacia),Separador);
        SET Var_TipoContrato  := UPPER(CONCAT(COALESCE(Var_TipoContrato,Cadena_Vacia),Separador));
        SET Var_Moneda      := CONCAT(COALESCE(Var_Moneda,Cadena_Vacia),Separador) ;
        SET Var_Npagos      := CONCAT(COALESCE(Var_NPagos,Cadena_Vacia),Separador) ;
        SET Var_FrecPagos     := CONCAT(COALESCE(Var_FrecPagos,Cadena_Vacia),Separador) ;
        SET Var_ImportePagos  := CONCAT(COALESCE(Var_ImportePagos,Cadena_Vacia),Separador) ;
        SET Var_FechaCompra   := CONCAT(COALESCE(Var_FechaInicio,Cadena_Vacia),Separador) ;
        SET Var_FechaInicio   := CONCAT(COALESCE(Var_FechaInicio,Cadena_Vacia),Separador) ;

        IF (Var_UltimoPago ='01011900') THEN -- validando si tiene un ultimo pago
          SET Var_UltimoPago    := Var_FechaCompra;
        ELSE
          SET Var_UltimoPago    := CONCAT(COALESCE(Var_UltimoPago,Cadena_Vacia),Separador) ;
        END IF;

        SET Var_FechaReporte  := CONCAT(COALESCE(DATE_FORMAT(Par_FechaCorteBC,FormatoFecha),Cadena_Vacia),Separador) ;
        SET Var_MontoCredito  := CONCAT(COALESCE(Var_MontoCredito,Cadena_Vacia),Separador) ;
        SET Var_vencido     := CONCAT(COALESCE(Var_vencido,Cadena_Vacia),Separador) ;
        SET Var_NPagosVencidos  := CONCAT(COALESCE(Var_NPagosVencidos,Cadena_Vacia),Separador) ;
        SET Var_ClaveObservacion:= CONCAT(COALESCE(Var_ClaveObservacion,Cadena_Vacia),Separador) ;
        SET Var_MOP       := CONCAT(COALESCE(LPAD(Var_MOP,2,'0'),Cadena_Vacia),Separador) ;
        SET Var_MOPInteres    := Var_MOP;
        SET Var_Incumplimiento  := CONCAT(COALESCE(Var_Incumplimiento,Cadena_Vacia),Separador);
        SET Var_saldo       := CONCAT(COALESCE(Var_saldo,Cadena_Vacia),Separador) ;
        SET Var_FechaCierre   := CONCAT(COALESCE(Var_FechaCierre,Cadena_Vacia),Separador);
        SET Var_SaldoTotal    := CONCAT(COALESCE(Var_SaldoTotal,Cadena_Vacia),Separador);
        SET Var_LimiteCred    := CONCAT(Entero_Cero,Separador);
        SET Var_PlazoMeses    := CONCAT(COALESCE(ROUND(Var_PlazoMeses),Entero_Cero),Separador);
        SET Var_Nacionalidad  := CONCAT(COALESCE(Var_Nacionalidad,Cadena_Vacia),Separador);
        SET Var_NacDomicilio  := CONCAT(COALESCE(Var_NacDomicilio,Cadena_Vacia),Separador);
        SET Var_NacDomicilio2 := Var_NacDomicilio;
        SET Var_Telefono    := CONCAT(COALESCE(Var_Telefono,Cadena_Vacia),Separador);
        SET Var_DiaAtrFecFinCre := CONCAT(COALESCE(Var_DiaAtrFecFinCre,Entero_Cero),Separador);
        SET Var_FechaUltPagoVen := CONCAT(COALESCE(Var_FechaUltPagoVen,Cadena_Vacia),Separador);
        SET Var_MontoUltPagoCHAR:= CONCAT(COALESCE(Var_MontoUltPago,Cadena_Vacia),Separador);
        SET Var_CorreoElect   := CONCAT(COALESCE(Var_CorreoElect,Cadena_Vacia),Cadena_Vacia);

        SET Var_TipoCuenta := CONCAT('I',Separador); -- Individual

        IF (Var_MOP ='01,' AND Var_FechaCierre <> ',') THEN
          SET Var_ClaveObservacion :='CC,';
        END IF;

       -- IF (Var_SaldoTotal = Entero_Cero AND Var_vencido = Entero_Cero AND Var_MOP = '01' AND Var_ImportePagos = Entero_Cero)

        SET Var_InteresReportado := '0,';

        IF (Var_FechaUltPagoVen != Separador) THEN
          SET Var_InteresReportado := ROUND(FNTOTALINTERESCREDITO(TRIM(TRAILING ',' FROM Var_Cuenta)));
          SET Var_InteresReportado := CONCAT(COALESCE(Var_InteresReportado,Cadena_Vacia),Separador);
        END IF;

        SET Var_Cinta:= CONCAT(
            Var_member,       Var_nombre,         Var_FechaCorte,       Var_ApellidoPaterno,    Var_ApellidoMaterno,
            Var_ApellidoAdicional,  Var_PrimerNombre,     Var_Segundo,          Var_FechaNacimiento,    Var_RFC,
            Var_Prefijo,      Var_Nacionalidad,       Var_EstadoCivil,      Var_Sexo,           Var_FechaDefuncion,
            Var_IndicadorDef,     Var_CalleNumero,      Var_DirComplemento,     Var_Colonia,        Var_Municipio,
            Var_Ciudad,       Var_estado,         Var_CP,           Var_Telefono,         Var_NacDomicilio,
            Var_Empresa,      Var_CalleNumero2,       Var_DirComplemento2,    Var_Colonia2,       Var_Municipio2,
            Var_Ciudad2,      Var_Estado2,        Var_CP2,          Var_Telefono2,        Var_Salario,
            Var_NacDomicilio2,    Var_member,         Var_nombre,         Var_Cuenta,         Var_Responsabilidad,
            Var_TipoCuenta,     Var_TipoContrato,     Var_Moneda,         Var_NPagos,         Var_FrecPagos,
            Var_FechaInicio,    Var_ImportePagos,     Var_UltimoPago,       Var_FechaCompra,      Var_FechaCierre,
            Var_FechaCorte,     Var_MontoCredito,     Var_SaldoTotal,       Var_LimiteCred,       Var_vencido,
            Var_NPagosVencidos,   Var_MOP,          Var_ClaveObservacion,   Var_ClaveOtorAnt,     Var_NombreOtorAnt,
            Var_NumCtaAnterior,   Var_Incumplimiento,     Var_saldo,          Var_MontoUltPagoCHAR,   Var_PlazoMeses,
            Var_MontoCredito,   Var_FechaUltPagoVen,    Var_InteresReportado,     Var_MOPInteres,       Var_DiaAtrFecFinCre,
            Var_CorreoElect,    Salto_Linea);

        INSERT INTO BUROCREDINTF VALUES (Var_CintaID, Var_ClienteID,  `Member`, Par_FechaCorteBC, Var_Cinta);

        FETCH CINTABURO INTO

          Var_ClienteID,      Var_ApellidoPaterno,  Var_ApellidoMaterno,  Var_Adicional,    Var_PrimerNombre,
          Var_SegundoNombre,    Var_TercerNombre,   Var_FechaNacimiento,  Var_RFC,      Var_Prefijo,
          Var_EstadoCivil,    Var_Sexo,       Var_FechaDefuncion,       Var_IndicadorDef,      Var_CalleNumero,
          Var_DirComplemento,   Var_Colonia,      Var_Municipio,      Var_Ciudad,     Var_estado,
          Var_CP,         Var_Telefono,     Var_Empresa,      Var_CalleNumero2, Var_DirComplemento2,
          Var_Colonia2,     Var_Municipio2,     Var_Ciudad2,      Var_Estado2,    Var_CP2,
          Var_Telefono2,      Var_Salario,      Var_member,       Var_nombre,     Var_Cuenta,
          Var_Responsabilidad,  Var_TipoCuenta,     Var_TipoContrato,   Var_Moneda,     Var_NPagos,
          Var_FrecPagos,      Var_FechaInicio,    Var_vencido,        Var_MontoCredito, Var_ImportePagos,
          Var_Incumplimiento,   Var_saldo,        Var_FechaCierre,    Var_NPagosVencidos, Var_ClaveObservacion,
          Var_NDiasAtraso,    Var_UltimoPago,     Var_MOP,        Var_SaldoTotal,   Var_TipoPersona,
          Var_MontoUltPago,   Var_PlazoMeses,     Var_Nacionalidad,   Var_DiaAtrFecFinCre,Var_NacDomicilio,
          Var_CorreoElect,    Var_FechaUltPagoVen;

        SET Var_Incumplimiento  := IFNULL(Var_Incumplimiento,Cadena_Vacia);

      END WHILE;

    CLOSE CINTABURO;

  END IF;

DROP TABLE IF EXISTS DatosClientesCrePagados;

END TerminaStore$$
