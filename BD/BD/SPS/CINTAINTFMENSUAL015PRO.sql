-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CINTAINTFMENSUAL015PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CINTAINTFMENSUAL015PRO`;
DELIMITER $$


CREATE PROCEDURE `CINTAINTFMENSUAL015PRO`(
/* SP PARA CINTA DE BURO DE CREDITO MENSUAL FORMATO CSV */
  Par_FechaCorteBC  DATE,     -- Fecha de Corte para generar el reporte
  Par_CintaBCID   INT(11),  -- CintaID corresponde a BUROCREDINTFMEN
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
  DECLARE Var_Cinta         VARCHAR(60000);
  DECLARE LONGITUD        DECIMAL;
  DECLARE Var_ClienteID       INT;
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
  DECLARE Var_FDef        VARCHAR(40);
  DECLARE Var_InDef       VARCHAR(40);
  DECLARE Var_CalleNumero     VARCHAR(80);
  DECLARE Var_Colonia       VARCHAR(80);
  DECLARE Var_Municipio     VARCHAR(80);
  DECLARE Var_estado        VARCHAR(40);
  DECLARE Var_CP          VARCHAR(40);
  DECLARE Var_Telefono      VARCHAR(40);
  DECLARE Var_member        VARCHAR(40);
  DECLARE Var_nombre        VARCHAR(40);
  DECLARE Var_Cuenta        VARCHAR(40);
  DECLARE Var_CuentaAux     VARCHAR(40);
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
  DECLARE Var_NDiasAtraso     INT(11);
  DECLARE Var_MOP         VARCHAR(40);
  DECLARE Var_MOPInteres      VARCHAR(40);
  DECLARE Var_UltimoPago      VARCHAR(40);
  DECLARE Var_SVigente      INT(14) DEFAULT 0;
  DECLARE Var_SVencido      INT(14) DEFAULT 0;
  DECLARE Var_NSegmentos      INT(5) DEFAULT 0;
  DECLARE Var_FechaCorte      VARCHAR(40);
  DECLARE Var_SaldoTotal      VARCHAR(40);
  DECLARE hayRegistros      BOOLEAN DEFAULT TRUE;

  DECLARE `Member`          VARCHAR(40);
  DECLARE NombreEmp       VARCHAR(100);
  DECLARE Formato_Envio     VARCHAR(20);
  DECLARE EncabezadoCVS     VARCHAR(1500);
  DECLARE Var_CintaID       INT;

  DECLARE Var_ApellidoAdicional   VARCHAR(1);
  DECLARE Var_FechaDefuncion    VARCHAR(1);
  DECLARE Var_IndicadorDef    VARCHAR(1);
  DECLARE Var_DirComplemento    VARCHAR(100);
  DECLARE Var_Ciudad        VARCHAR(50);
  DECLARE Var_Empresa       VARCHAR(41);
  DECLARE Var_CalleNumero2    VARCHAR(80);
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
  DECLARE DiasCtaReciente     INT;
  DECLARE Cadena_Vacia      CHAR(1);
  DECLARE Espacio_Blanco      CHAR(1);
  DECLARE Fecha_Vacia       DATE;
  DECLARE Entero_Cero       INT;
  DECLARE Entero_Uno        INT;
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
  DECLARE Soltero_BC        CHAR(1);

  DECLARE SI_DiaHabil       CHAR(1);
  DECLARE No_DiaHabil       CHAR(1);
  DECLARE DiasMaxReporte      INT(2);
  DECLARE Fecha_Vaciaddmmyyyy   CHAR(8);
  DECLARE Var_TipoPersona     CHAR(1);
  DECLARE FechaMigracion      CHAR(8);
  DECLARE Var_PromagraID      VARCHAR(15);
  DECLARE Entero_Diez       INT(2);
  DECLARE Var_FechaFin      DATE;
  DECLARE Var_FechaInicial    DATE;

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
  DECLARE SinNumero       VARCHAR(5);
  DECLARE CalleConocido     VARCHAR(12);
  DECLARE CalleConocida     VARCHAR(12);
  DECLARE FormatoFecha      VARCHAR(10);
  DECLARE FormatoFechaInicio    VARCHAR(10);
  DECLARE Str_SI          CHAR(1);
  DECLARE Str_NO          CHAR(1);
  DECLARE LimpiaAlfabetico    VARCHAR(2);   -- Limpieza de texto que contiene solo letras
  DECLARE LimpiaAlfaNumerico    VARCHAR(2);   -- Limpieza de texto que contiene letras y numeros
    -- CLAVES MOPS
  DECLARE MopUR         VARCHAR(3);
  DECLARE Mop00         VARCHAR(3);
  DECLARE Mop01         VARCHAR(3);
  DECLARE Mop02         VARCHAR(3);
  DECLARE Mop03         VARCHAR(3);
  DECLARE Mop04         VARCHAR(3);
  DECLARE Mop05         VARCHAR(3);
  DECLARE Mop06         VARCHAR(3);
  DECLARE Mop07         VARCHAR(3);
  DECLARE Mop96         VARCHAR(3);
  DECLARE Mop97         VARCHAR(3);
  DECLARE Mop99         VARCHAR(3);
    DECLARE DiasTresMeses     INT(11);
    DECLARE EtiquetaNumero      VARCHAR(10);
    -- TIPOS DE RESPONSABILIDAD
    DECLARE TipoRespIndividual    CHAR(1);
    DECLARE TipoRespMancomunado   CHAR(1);
    DECLARE TipoRespObligadoSol   CHAR(1);
    DECLARE TipoCtaPagosFijos   CHAR(1);
    DECLARE TipoCtaHipoteca     CHAR(1);
    DECLARE TipoCtaSinLimite    CHAR(1);
    DECLARE TipoCtaRevolvente   CHAR(1);
    -- CLAVES DE OBSERVACION
    DECLARE ClaveObsCtaCanc     CHAR(2);
    DECLARE ClaveObsFiniq     CHAR(2);
    DECLARE ClaveObsCtaCast     CHAR(2);
    -- TIPOS DE FRECUENCIAS DE PAGOS
    DECLARE FrecBimestralBC     CHAR(1);
    DECLARE FreDiarioBC       CHAR(1);
    DECLARE FrecSemestralBC     CHAR(1);
    DECLARE FrecCatorcenalBC    CHAR(1);
    DECLARE FrecMensualBC     CHAR(1);
    DECLARE FrecDeduccionBC     CHAR(1);
    DECLARE FrecTrimestralBC    CHAR(1);
    DECLARE FrecQuincenalBC     CHAR(1);
    DECLARE FrecVariableBC      CHAR(1);
    DECLARE FrecSemanalBC     CHAR(1);
    DECLARE FrecAnualBC       CHAR(1);
    DECLARE FrecPagoMinimoBC    CHAR(1);
    DECLARE FrecPagoUnicoSAFI   CHAR(1);
    DECLARE PersMoral       CHAR(1);
    DECLARE NombreNoProporcionado VARCHAR(20);
    DECLARE PrefijoSRITA      VARCHAR(6);
    DECLARE PrefijoSRTA       VARCHAR(6);
  DECLARE OcupacionHOGAR      VARCHAR(20);
  DECLARE OcupacionESTUDIANTE   VARCHAR(20);
  DECLARE OcupacionJUBILADO   VARCHAR(20);
  DECLARE OcupacionDESEMPLEADO  VARCHAR(20);
  DECLARE LikeCasa        VARCHAR(20);
  DECLARE LikeEstudiante      VARCHAR(20);
  DECLARE LikeJubilado      VARCHAR(20);
  DECLARE LikeDesempleado     VARCHAR(20);
  DECLARE LikeDesocupado      VARCHAR(20);

  -- Declara la constante que contendrá los datos de la cinta de buro
  DECLARE CINTABURO CURSOR FOR
    SELECT
      ClienteID,      ApellidoPaterno,    ApellidoMaterno,    Adicional,      PrimerNombre,
      SegundoNombre,    TercerNombre,     FechaNacimiento,    RFC,        Prefijo,
      EstadoCivil,    Sexo,         FDef,         InDef,        CalleNumero,
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
        FROM TMPDATOSCTESCREDPAG  ORDER BY FechaUltPagoVen ASC;

  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET hayRegistros = FALSE;

  SET EstatusPagado       :='P';
  SET EstatusVigente      :='V';
  SET EstatusCastigado    :='K';
  SET EstatusVencido      :='B';
  SET DiasCtaReciente     :=29;
  SET Cadena_Vacia      :='';
  SET Fecha_Vacia       :='1900-01-01';
  SET Entero_Cero       :=0;
  SET Entero_Uno        :=1;
  SET Formato_Cinta       :='INTF11';
  SET Formato_Comas     :='CVS';
  SET Espacio_Blanco      :=' ';
  SET Separador       :=',';
  SET Salto_Linea       :='\n';
  SET Casado_BMC        :='CC';
  SET Casado_BM         :='CM';
  SET Casado_BS         :='CS';
  SET Viudo           :='V';
  SET Union_libre       :='U';
  SET Casado_BC         :='M';
  SET Viudo_BC        :='W';
  SET Union_libreBC       :='F';
  SET EdoSeparado         :='SE';
  SET Soltero_BC          :='S';

  SET Var_ApellidoAdicional :=',';
  SET Var_Prefijo       :=',';
  SET Var_IndicadorDef    :=',';
  SET Var_FechaDefuncion    :=',';
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
  SET DiasMaxReporte      :=5;
  SET Fecha_Vaciaddmmyyyy   :='01011900';
  SET FechaMigracion      :='30092014';
  SET Var_PromagraID      :='MIGRACION';
  SET Entero_Diez       :=10;

  SET TipoPersFisica      := 'F';
  SET TipoDomTrabajo      := 3;
  SET PaisMexico        := 700;
  SET DomicilioConocido   := 'DOMICILIO CONOCIDO SN';
  SET SinNumero       := ' SN';
  SET CalleConocido     := '%CONOCIDO%';
  SET CalleConocida     := '%CONOCIDA%';
  SET LimpiaAlfabetico    := 'A';
  SET LimpiaAlfaNumerico    := 'AN';
  SET Str_SI          := 'S';
  SET Str_NO          := 'N';
  SET FormatoFecha      := '%d%m%Y';
  SET FormatoFechaInicio    := '%Y-%m-01';

  SET Formato_Envio     := Formato_Comas;

  SET MopUR         := 'UR'; -- MOP para cuenta sin información
  SET Mop00         := '00'; -- MOP para cuenta nuy reciente
  SET Mop01         := '01'; -- MOP para cuenta al corriente
  SET Mop02         := '02'; -- MOP para cuenta con atraso
  SET Mop03         := '03'; -- MOP para cuenta con atraso
  SET Mop04         := '04'; -- MOP para cuenta con atraso
  SET Mop05         := '05'; -- MOP para cuenta con atraso
  SET Mop06         := '06'; -- MOP para cuenta con atraso
  SET Mop07         := '07'; -- MOP para cuenta con atraso
  SET Mop96         := '96'; -- MOP para cuenta con atraso
  SET Mop97         := '97'; -- MOP para cuenta con deuda parcial
  SET Mop99         := '99'; -- MOP para fraude cometido por el cte
  SET Factor_Meses      := 30.4;
  SET DiasTresMeses     := 60;
  SET EtiquetaNumero      := ' NUM ';
    SET TipoRespIndividual    := 'I';
    SET TipoRespMancomunado   := 'J';
    SET TipoRespObligadoSol   := 'C';
    SET TipoCtaPagosFijos   := 'I';
    SET TipoCtaHipoteca     := 'M';
    SET TipoCtaSinLimite    := 'O';
    SET TipoCtaRevolvente   := 'R';
    SET ClaveObsCtaCanc     := 'CC';
    SET ClaveObsFiniq     := 'LC';
    SET ClaveObsCtaCast     := 'UP';
    SET FrecBimestralBC     := 'B';
    SET FreDiarioBC       := 'D';
    SET FrecSemestralBC     := 'H';
    SET FrecCatorcenalBC    := 'K';
    SET FrecMensualBC     := 'M';
    SET FrecDeduccionBC     := 'P';
    SET FrecTrimestralBC    := 'Q';
    SET FrecQuincenalBC     := 'S';
    SET FrecVariableBC      := 'V';
    SET FrecSemanalBC     := 'W';
    SET FrecAnualBC       := 'Y';
    SET FrecPagoMinimoBC    := 'Z';
    SET FrecPagoUnicoSAFI   := 'U';
    SET PersMoral       := 'M';
    SET NombreNoProporcionado := 'NO PROPORCIONADO';
    SET PrefijoSRITA      := 'SRITA';
    SET PrefijoSRTA       := 'SRTA';
  SET OcupacionHOGAR      := 'LABORES DEL HOGAR';
  SET OcupacionESTUDIANTE   := 'ESTUDIANTE';
  SET OcupacionJUBILADO   := 'JUBILADO';
  SET OcupacionDESEMPLEADO  := 'DESEMPLEADO';
  SET LikeCasa        := '%casa%';
  SET LikeEstudiante      := '%estudiante%';
  SET LikeJubilado      := '%jubilado%';
  SET LikeDesempleado     := '%desempleado%';
  SET LikeDesocupado      := '%desocupado%';

  -- encabezado de la cinta (de 5 en 5)
  SET EncabezadoCVS:=Cadena_Vacia;
    -- 1 - 10
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CLAVE_OTORGANTE_1,NOMBRE DEL OTORGANTE_1,FECHA DEL REPORTE,APELLIDO_PATERNO,APELLIDO_MATERNO,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'APELLIDO_ADICIONAL,PRIMER_NOMBRE,SEGUNDO_NOMBRE,FECHA_DE_NACIMIENTO,RFC,');
    -- 11 - 20
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'PREFIJO,NACIONALIDAD,ESTADO_CIVIL,SEXO,FECHA_DEFUNCIÓN,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'INDICADOR_DEFUNCIÓN,DIRECCIÓN_CALLE_NÚMERO,DIRECCIÓN_COMPLEMENTO,COLONIA_O_POBLACIÓN,DELEGACIÓN_O_MUNICIPIO,');
    -- 21 - 30
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CIUDAD,ESTADO,C.P.,TELÉFONO,DIRECCIÓN_ORIGEN,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'EMPRESA,DIRECCIÓN_CALLE_NÚMERO_1,DIRECCIÓN_COMPLEMENTO_1,COLONIA_O_POBLACIÓN_1,DELEGACIÓN_O_MUNICIPIO_1,');
    -- 31 - 40
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CIUDAD_1,ESTADO_1,C.P._1,TELÉFONO_1,SALARIO,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'DIRECCIÓN_ORIGEN,CLAVE_OTORGANTE,NOMBRE DEL OTORGANTE,NÚMERO_CUENTA,TIPO_RESPONSABILIDAD_CUENTA,');
    -- 41 - 50
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'TIPO_CUENTA,TIPO_CONTRATO,MONEDA,NÚMERO_DE_PAGOS,FRECUENCIA_DE_PAGOS,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'FECHA_APERTURA,MONTO_A_PAGAR,FECHA_ÚLTIMO_PAGO,FECHA_ÚLTIMA_COMPRA,FECHA_CIERRE_CREDITO,');
    -- 51 - 60
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'FECHA_REPORTE,CREDITO_MAXIMO,SALDO_ACTUAL,LIMITE_DE_CRÉDITO,SALDO_VENCIDO,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'NÚMERO_PAGOS_VENCIDOS,FORMA_PAGO_MOP,CLAVE_OBSERVACION,CLAVE_ANTERIOR_OTORGANTE,NOMBRE_ANTERIOR_OTORGANTE,');
    -- 61 - 70
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'NÚMERO_CTA_ANTERIOR,FECHA_PRIMER_INCUMPLIMIENTO,SALDO_INSOLUTO,MONTO_ULTIMO_PAGO,PLAZO_CREDITO,');
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'MONTO_CREDITO_ORIGINAL,FECHA_INGRESO_CARTERA_VENCIDA,MONTO_INTERESES,FORMA_PAGO_MOP_INTERESES,DÍAS_VENCIMIENTO,');
    -- 71
  SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CORREO_ELECTRONICO',Salto_Linea);


  SET Var_FechaFin    :=LAST_DAY(Par_FechaCorteBC);
    SET Var_FechaCorte    :=Var_FechaFin;
  SET Var_FechaInicial  := DATE_FORMAT(Par_FechaCorteBC, FormatoFechaInicio);

  SELECT   ClaveInstitID,     Nombre
    INTO   `Member`,      NombreEmp
    FROM BUCREPARAMETROS;

  DELETE FROM BUROCREDINTFMEN  WHERE Fecha=Par_FechaCorteBC;

  SET Var_CintaID:= Par_CintaBCID;

  DROP TABLE IF EXISTS TMPPERIODICIDADBC;

  CREATE TABLE TMPPERIODICIDADBC (
    PeriodicidadID      INT(11) NOT NULL,
    FrecuenciaID        VARCHAR(2) NOT NULL,
    Periodicidad        VARCHAR(45) NULL,
    PeriodicidadAbrev   VARCHAR(10) NULL,
    FrecuenciaBC        VARCHAR(45) NULL,
    DiaMinimo         INT(5),
    DiaMaximo         INT(8),
    PRIMARY KEY (PeriodicidadID,FrecuenciaID));

  INSERT INTO TMPPERIODICIDADBC VALUES
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
    (14,'U','UNICO','UN','V',376,99999999),
    (15,'D','SEMANAL','SEM.','W',1,10);

  -- Temporal que guarda los nombres de los municipios correctamente
  DROP TABLE IF EXISTS TEMPORAL_MUNICIP;

  CREATE TABLE TEMPORAL_MUNICIP (
    EstadoID      INT(11) NOT NULL,
    MunicipioID     INT(11) NOT NULL,
    NombreCorrecto  VARCHAR(150) NULL,
    Nombre      VARCHAR(150) NULL,
    INDEX (EstadoID,MunicipioID)
  );

  INSERT INTO TEMPORAL_MUNICIP VALUES
    (1,10,'EL LLANO','LLANO, EL'),
    (3,3,'LA PAZ','PAZ, LA'),
    (3,8,'LOS CABOS','CABOS, LOS'),
    (7,14,'EL BOSQUE','BOSQUE, EL'),
    (7,20,'LA CONCORDIA','CONCORDIA, LA'),
    (7,36,'LA GRANDEZA','GRANDEZA, LA'),
    (7,41,'LA INDEPENDENCIA','INDEPENDENCIA, LA'),
    (7,50,'LA LIBERTAD','LIBERTAD, LA'),
    (7,52,'LAS MARGARITAS','MARGARITAS, LAS'),
    (7,70,'EL PORVENIR','PORVENIR, EL'),
    (7,75,'LAS ROSAS','ROSAS, LAS'),
    (7,99,'LA TRINITARIA','TRINITARIA, LA'),
    (8,16,'LA CRUZ','CRUZ, LA'),
    (8,64,'EL TULE','TULE, EL'),
    (9,8,'LA MAGDALENA CONTRERAS','MAGDALENA CONTRERAS, LA'),
    (10,18,'EL ORO','ORO, EL'),
    (12,68,'LA UNION DE ISIDORO MONTES DE OCA','UNION DE ISIDORO MONTES DE OCA, LA'),
    (13,9,'EL ARENAL','ARENAL, EL'),
    (13,40,'LA MISION','MISION, LA'),
    (14,9,'EL ARENAL','ARENAL, EL'),
    (14,18,'LA BARCA','BARCA, LA'),
    (14,37,'EL GRULLO','GRULLO, EL'),
    (14,43,'LA HUERTA','HUERTA, LA'),
    (14,54,'EL LIMON','LIMON, EL'),
    (14,57,'LA MANZANILLA DE LA PAZ','MANZANILLA DE LA PAZ, LA'),
    (14,70,'EL SALTO','SALTO, EL'),
    (15,64,'EL ORO','ORO, EL'),
    (15,70,'LA PAZ','PAZ, LA'),
    (16,35,'LA HUACANA','HUACANA, LA'),
    (16,69,'LA PIEDAD','PIEDAD, LA'),
    (16,75,'LOS REYES','REYES, LOS'),
    (18,9,'EL NAYAR','NAYAR, EL'),
    (18,19,'LA YESCA','YESCA, LA'),
    (19,3,'LOS ALDAMAS','ALDAMAS, LOS'),
    (19,27,'LOS HERRERAS','HERRERAS, LOS'),
    (19,42,'LOS RAMONES','RAMONES, LOS'),
    (20,10,'EL BARRIO DE LA SOLEDAD','BARRIO DE LA SOLEDAD, EL'),
    (20,17,'LA COMPAÑIA','COMPAÑIA, LA'),
    (20,30,'EL ESPINAL','ESPINAL, EL'),
    (20,69,'LA PE','PE, LA'),
    (20,76,'LA REFORMA','REFORMA, LA'),
    (20,556,'LA TRINIDAD VISTA HERMOSA','TRINIDAD VISTA HERMOSA, LA'),
    (21,95,'LA MAGDALENA TLATLAUQUITEPEC','MAGDALENA TLATLAUQUITEPEC, LA'),
    (21,118,'LOS REYES DE JUAREZ','REYES DE JUAREZ, LOS'),
    (22,11,'EL MARQUES','MARQUES, EL'),
    (24,58,'EL NARANJO','NARANJO, EL'),
    (25,10,'EL FUERTE','FUERTE, EL'),
    (26,21,'LA COLORADA','COLORADA, LA'),
    (28,21,'EL MANTE','MANTE, EL'),
    (29,7,'EL CARMEN TEQUEXQUITLA','CARMEN TEQUEXQUITLA, EL'),
    (29,48,'LA MAGDALENA TLALTELULCO','MAGDALENA TLALTELULCO, LA'),
    (30,16,'LA ANTIGUA','ANTIGUA, LA'),
    (30,61,'LAS CHOAPAS','CHOAPAS, LAS'),
    (30,107,'LAS MINAS','MINAS, LAS'),
    (30,127,'LA PERLA','PERLA, LA'),
    (30,132,'LAS VIGAS DE RAMIREZ','VIGAS DE RAMIREZ, LAS'),
    (30,137,'LOS REYES','REYES, LOS'),
    (30,205,'EL HIGO','HIGO, EL'),
    (32,41,'EL SALVADOR','SALVADOR, EL');

  -- creacion de la tabla temporal con los datos que contendrá la cinta
  DROP TABLE IF EXISTS TMPDATOSCTESCREDPAG;
  CREATE TABLE TMPDATOSCTESCREDPAG(
    ClienteID   INT(11),    ApellidoPaterno VARCHAR(50),  ApellidoMaterno VARCHAR(50),  Adicional   VARCHAR(50),
    PrimerNombre  VARCHAR(50),  SegundoNombre VARCHAR(50),  TercerNombre  VARCHAR(50),  FechaNacimiento VARCHAR(10),
    RFC       VARCHAR(18),  Prefijo     VARCHAR(10),  EstadoCivil   CHAR(2),    Sexo      CHAR(1),
    FDef      VARCHAR(10),  InDef     VARCHAR(10),  CalleNumero   VARCHAR(100), Colonia     VARCHAR(200),
    Municipio   VARCHAR(100), Ciudad      VARCHAR(50),  Estado      VARCHAR(20),  `member`      VARCHAR(50),
    CP        CHAR(6),    Telefono    VARCHAR(10),  DirComplemento  VARCHAR(100), Empresa     VARCHAR(41),
    CalleNumero2  VARCHAR(41),  Colonia2    VARCHAR(41),  Municipio2    VARCHAR(41),  Ciudad2     VARCHAR(41),
    Estado2     VARCHAR(20),  CP2       CHAR(6),    Telefono2   VARCHAR(11),  DirComplemento2 VARCHAR(100),
    Salario     VARCHAR(10),  CreditoIDCte  VARCHAR(20),  Estatus     CHAR(1),    CreditoIDSAFI BIGINT(12),
    FechaPago   CHAR(8),    Incumplimiento  VARCHAR(8),   NPagos      INT(11),    FrecPagos   CHAR(2),
    Saldo     INT(11),    MontoCredito  INT(11),    Vencido     INT(11),    FechaInicio   CHAR(8),
    ImportePagos  INT(11),    FechaCierre   CHAR(8),    NoCuotasAtraso  INT(11),    DiasAtraso    INT(11),
    DiasPasoAtraso  INT(11),    SaldoTotal    INT(11),    MOP       CHAR(2),    TipoContrato  CHAR(8),
    Moneda      CHAR(5),    Responsabilidad CHAR(1),    TipoCuenta    CHAR(1),    TipoPersona   CHAR(1),
    ClaveObervacion CHAR(3),    MontoUltPago  INT(11),    Transaccion   BIGINT,     PlazoID     VARCHAR(20),
    Nacionalidad  CHAR(5),    PaisID      INT(11),    DiasAtraFecFinCre INT(11),    PaisResidencia  INT(11),
    NacDomicilio  CHAR(5),    CorreoElect   VARCHAR(50),  FechaUltPagoVen CHAR(8),    OcupacionID   INT(11),
        PlazoCredito  DECIMAL(12,2),
  INDEX TMPDATOSCTESCREDPAG1 (ClienteID),
  INDEX TMPDATOSCTESCREDPAG2 (CreditoIDCte),
  INDEX TMPDATOSCTESCREDPAG3 (CreditoIDSAFI));

  -- Insercion de los datos generales, los valores de saldos son actualizados posteriormente.
  INSERT INTO TMPDATOSCTESCREDPAG(
  SELECT  MAX(Cli.ClienteID),   MAX(Cli.ApellidoPaterno),       MAX(Cli.ApellidoMaterno),    Cadena_Vacia AS Adicional,
      MAX(Cli.PrimerNombre),    MAX(Cli.SegundoNombre),         MAX(Cli.TercerNombre),       DATE_FORMAT(MAX(Cli.FechaNacimiento),FormatoFecha)AS FechaNacimiento,
      MAX(Cli.RFC),           MAX(Cli.Titulo) AS Prefijo,     MAX(Cli.EstadoCivil),        MAX(Cli.Sexo),
      Cadena_Vacia AS FDef,     Cadena_Vacia AS InDef,
      IF((IFNULL(MAX(Dir.Calle),Cadena_Vacia)=Cadena_Vacia AND IFNULL(MAX(Dir.NumeroCasa),Entero_Cero)=Entero_Cero)OR(IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocida OR IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocido),
      DomicilioConocido,
      CONCAT(LEFT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),(40-LENGTH(IF(IFNULL(MAX(Dir.NumeroCasa),Entero_Cero)=Entero_Cero,SinNumero,CONCAT(EtiquetaNumero,MAX(Dir.NumeroCasa)))))
      ),IF(IFNULL(MAX(Dir.NumeroCasa),Entero_Cero)=Entero_Cero,SinNumero,CONCAT(EtiquetaNumero,MAX(Dir.NumeroCasa))))) AS CalleNumero,
      TRIM(LEFT(CONCAT(MAX(Col.TipoAsenta),' ',MAX(Col.Asentamiento)),40)) AS Colonia,            TRIM(LEFT(MAX(Mun.Nombre),40)) AS Municipio,     TRIM(LEFT(MAX(Loc.NombreLocalidad),40)) AS Ciudad,
      MAX(Est.EqBuroCred) AS Estado,   Cadena_Vacia AS `member`,                   MAX(Dir.CP),                     IF(IFNULL(MAX(Cli.Telefono),Entero_Cero)!=Entero_Cero,MAX(Cli.Telefono),Cli.TelefonoCelular) AS Telefono,
      Cadena_Vacia AS DirComplemento,
      LEFT(IF(MAX(Cli.LugardeTrabajo)=Cadena_Vacia,MAX(Cli.NombreCompleto),MAX(Cli.LugardeTrabajo)),40)  AS Empresa,
            IF((IFNULL(MAX(Dir.Calle),Cadena_Vacia)=Cadena_Vacia AND IFNULL(MAX(Dir.NumeroCasa),Entero_Cero)=Entero_Cero)OR(IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocida OR IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocido),
         DomicilioConocido,
         CONCAT(LEFT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),(40-LENGTH(IF(IFNULL(MAX(Dir.NumeroCasa),Entero_Cero)=Entero_Cero,SinNumero,CONCAT(EtiquetaNumero,MAX(Dir.NumeroCasa)))))
         ),IF(IFNULL(MAX(Dir.NumeroCasa),Entero_Cero)=Entero_Cero,SinNumero,CONCAT(EtiquetaNumero,MAX(Dir.NumeroCasa))))) AS CalleNumero2,
            TRIM(LEFT(CONCAT(MAX(Col.TipoAsenta),' ',MAX(Col.Asentamiento)),40))  AS Colonia2,          TRIM(LEFT(MAX(Mun.Nombre),40)) AS Municipio2,     TRIM(LEFT(MAX(Loc.NombreLocalidad),40))  AS Ciudad2,
            MAX(Est.EqBuroCred) AS Estado2,    MAX(Dir.CP) AS CP,                IF(IFNULL(MAX(Cli.Telefono),Entero_Cero)!=Entero_Cero,MAX(Cli.Telefono), MAX(Cli.TelefonoCelular)) AS Telefono2,
      Cadena_Vacia  AS DirComplemento2, Cadena_Vacia AS Salario,                MAX(EqC.CreditoIDCte),      MAX(Cre.Estatus),
      Cre.CreditoID,                  DATE_FORMAT(MAX(Det.FechaPago),FormatoFecha) AS UltimoPago,       Cadena_Vacia AS Incumplimiento,             MAX(Cre.NumAmortizacion),
      Cadena_Vacia AS FrecuenciaBC,   Entero_Cero AS Saldo,                   MAX(Cre.MontoCredito),      Entero_Cero AS Vencido,
      DATE_FORMAT(MAX(Cre.FechaInicio),FormatoFecha) AS FechaIncio,
      Entero_Cero AS  ImportePagos, DATE_FORMAT(Cre.FechTerminacion,FormatoFecha) AS FechaCierre, NULL AS NoCuotasAtraso,           NULL AS DiasAtraso,
      Pro.DiasPasoAtraso,           Entero_Cero AS  SaldoTotal,     Cadena_Vacia AS MOP,                MAX(Pro.TipoContratoBCID),
      Cadena_Vacia AS Moneda,         Pro.EsGrupal,                   MAX(Pro.EsRevolvente),              MAX(Cli.TipoPersona),
      Cadena_Vacia AS ClaveObervacion,  Entero_Cero AS MontoUltPago,    MAX(Det.Transaccion),               IFNULL(MAX(Cre.PlazoID),Entero_Cero) AS PlazoID,
      Cadena_Vacia AS Nacionalidad,   MAX(Cli.LugarNacimiento),       Entero_Cero AS DiasAtraFecFinCre,   MAX(Cli.PaisResidencia),
    Cadena_Vacia AS NacDomicilio,   MAX(Cli.Correo) AS CorreoElect, Cadena_Vacia AS FechaUltPagoVen,    MAX(Cli.OcupacionID),
    Entero_Cero AS PlazoCredito
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
    AND Cre.FechaInicio <= Var_FechaFin AND (Cre.FechTerminacion >= Var_FechaInicial OR Cre.FechTerminacion = Fecha_Vacia)
        AND Cli.TipoPersona = TipoPersFisica
  GROUP BY  Cre.CreditoID);

  --  ==== Actualizamos el nombre de el municipio
  UPDATE TMPDATOSCTESCREDPAG D, TEMPORAL_MUNICIP T
  SET D.Municipio = T.NombreCorrecto,
    D.Municipio2 = T.NombreCorrecto
    WHERE D.Municipio=T.Nombre;

  --  ==== Eliminamos Creditos que se desembolsaron posterior a la fecha corte
  DELETE FROM TMPDATOSCTESCREDPAG
  WHERE CONVERT(SUBSTRING(FechaInicio,3,2),SIGNED)>MONTH(Var_FechaFin)
  AND SUBSTRING(FechaInicio,5,4) = YEAR(Var_FechaFin);

  --  ==== Eliminamos Creditos que se hayan liquidado anterior a la Fecha corte

  DELETE FROM TMPDATOSCTESCREDPAG
  WHERE CONVERT(SUBSTRING(FechaCierre,3,2),SIGNED)<MONTH(Var_FechaFin)
  AND SUBSTRING(FechaCierre,5,4) = YEAR(Var_FechaFin);

  --  ==== Eliminamos Creditos que se hayan liquidado posterior a la Fecha corte

  DELETE FROM TMPDATOSCTESCREDPAG
  WHERE CONVERT(SUBSTRING(FechaCierre,3,2),SIGNED)>MONTH(Var_FechaFin)
  AND SUBSTRING(FechaCierre,5,4) = YEAR(Var_FechaFin);

  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
  CREATE TABLE TMPACTFECHAPAGOCRED(
    CreditoID BIGINT(12) NOT NULL,
    FechaPago DATE,
    MontoUltPag INT(11),
    PRIMARY KEY(CreditoID)
  );

  DROP TABLE IF EXISTS TMPESTATUSCREDITOS;

  CREATE TABLE TMPESTATUSCREDITOS(
    SELECT MAX(Dat.CreditoIDSAFI) AS CreditoIDSAFI, MAX(Sal.EstatusCredito) AS Estatus
      FROM TMPDATOSCTESCREDPAG Dat
        INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoIDSAFI = Sal.CreditoID
      WHERE Sal.FechaCorte =Var_FechaFin
    GROUP BY CreditoID);

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN TMPESTATUSCREDITOS Est ON Dat.CreditoIDSAFI = Est.CreditoIDSAFI
  SET Dat.Estatus=Est.Estatus;

  DROP TABLE IF EXISTS TMPESTATUSCREDITOS;

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
  SET Dat.Estatus =EstatusPagado
  WHERE Cre.FechTerminacion <=Var_FechaFin AND Cre.FechTerminacion <> Fecha_Vacia;

  -- Se Inicializan las Fechas de Pago
  UPDATE TMPDATOSCTESCREDPAG
  SET FechaPago=Fecha_Vaciaddmmyyyy,MontoUltPago = Entero_Cero;

  -- Si el credito es migrado y no tiene registro en DETALLEPAGCRE
  -- SE TOMA LA FECHA LIQUIDA DE LA CUOTA
  INSERT INTO TMPACTFECHAPAGOCRED(
     SELECT MAX(Cre.CreditoID) ,MAX(Amo.FechaLiquida), Entero_Cero
    FROM  CREDITOS Cre
      LEFT JOIN DETALLEPAGCRE  Det ON Cre.CreditoID = Det.CreditoID
      INNER JOIN AMORTICREDITO Amo ON Cre.CreditoID = Amo.CreditoID
    WHERE IFNULL(Det.CreditoID,Cadena_Vacia)= Cadena_Vacia
      AND   IFNULL(Amo.FechaLiquida,Fecha_Vacia)<>Fecha_Vacia
      AND   Amo.Estatus = EstatusPagado AND  Amo.FechaLiquida <= Var_FechaFin
     GROUP BY Amo.CreditoID);

  UPDATE TMPACTFECHAPAGOCRED tmp
    INNER JOIN DETALLEPAGCRE Det ON tmp.CreditoID = Det.CreditoID
  SET  tmp.MontoUltPag =ROUND(Det.MontoTotPago)
  WHERE Det.FechaPago = tmp.FechaPago;


  UPDATE TMPDATOSCTESCREDPAG Det
    INNER JOIN TMPACTFECHAPAGOCRED Tem ON Det.CreditoIDSAFI = Tem.CreditoID
  SET Det.FechaPago = DATE_FORMAT(Tem.FechaPago,FormatoFecha),Det.MontoUltPago=Tem.MontoUltPag
  WHERE Tem.FechaPago <=  Par_FechaCorteBC;

  TRUNCATE TMPACTFECHAPAGOCRED;

  -- Se actualiza el valor del ultimo pago del Credito
  INSERT INTO TMPACTFECHAPAGOCRED(
    SELECT MAX(Det.CreditoID)  , MAX(Det.FechaPago),Entero_Cero
      FROM TMPDATOSCTESCREDPAG Dat
        INNER JOIN DETALLEPAGCRE Det ON Dat.CreditoIDSAFI = Det.CreditoID
    WHERE Det.FechaPago <= Var_FechaFin
    GROUP BY CreditoID);

  -- Actualizamos Monto Ultimo Pago de Creditos que estan en DETPAGCRE
  DROP TABLE IF EXISTS TEMP_ULTIMOPAGO;

  CREATE TABLE TEMP_ULTIMOPAGO(
    CreditoID     BIGINT(12) NOT NULL,
    MontUltimoPago  DECIMAL(14,2),
    FechaPago     DATE,
    PRIMARY KEY (CreditoID)
  );

  INSERT INTO  TEMP_ULTIMOPAGO
    SELECT Det.CreditoID ,SUM(Det.MontoTotPago)AS MontUltimoPago ,MAX(tm.FechaPago)
       FROM TMPDATOSCTESCREDPAG Dat
        INNER JOIN TMPACTFECHAPAGOCRED tm ON Dat.CreditoIDSAFI = tm.CreditoID
        INNER JOIN DETALLEPAGCRE Det ON Dat.CreditoIDSAFI = Det.CreditoID
    WHERE tm.FechaPago = Det.FechaPago
    GROUP BY Det.CreditoID;

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN TEMP_ULTIMOPAGO tm ON Dat.CreditoIDSAFI = tm.CreditoID
  SET Dat.MontoUltPago =ROUND(tm.MontUltimoPago),
    Dat.FechaPago = DATE_FORMAT(tm.FechaPago,FormatoFecha);

  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
  DROP TABLE IF EXISTS TEMP_ULTIMOPAGO;

  -- Se Inicializan las Fechas de Pago vacio

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI =Cre.CreditoID
  SET Dat.FechaCierre =Fecha_Vaciaddmmyyyy
  WHERE Cre.FechTerminacion > Par_FechaCorteBC;


  UPDATE TMPDATOSCTESCREDPAG Det
    INNER JOIN CREDITOS Cre     ON Det.CreditoIDSAFI  = Cre.CreditoID
    INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID= Pro.ProducCreditoID
  SET Det.Responsabilidad = (CASE Pro.EsGrupal WHEN Str_NO THEN TipoRespIndividual
                         WHEN Str_SI THEN TipoRespMancomunado END),
    Det.TipoCuenta = (CASE Pro.EsRevolvente WHEN Str_NO THEN TipoCtaPagosFijos
                         WHEN Str_SI THEN TipoCtaRevolvente END);

-- ===== La Fecha de Incumplimiento se actualizan de acuerdo al comportamiento del Cliente durante el mes que se reporta

  DROP TABLE IF EXISTS TMPINCUMPLIMIENTO;

  CREATE TABLE TMPINCUMPLIMIENTO(
    Numero INT(11) NOT NULL,
    CreditoID  BIGINT(12) NOT NULL,
    FechaIncum DATE,
    PRIMARY KEY(Numero,CreditoID)
  );

  -- Creditos del Mes que probablemente incumplieron
  INSERT INTO TMPINCUMPLIMIENTO
    SELECT 1,MAX(Dat.CreditoIDSAFI),Fecha_Vacia FROM TMPDATOSCTESCREDPAG Dat
      INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoIDSAFI = Sal.CreditoID
    WHERE Sal.SalCapAtrasado > Entero_Cero AND Sal.FechaCorte < Var_FechaFin
      AND CONVERT(SUBSTRING(Dat.FechaInicio,3,2),SIGNED)=MONTH(Var_FechaFin )
      AND SUBSTRING(Dat.FechaInicio,5,4) = YEAR(Var_FechaFin )
    GROUP BY Sal.CreditoID;

  -- ticket A&E
  INSERT INTO TMPINCUMPLIMIENTO
    SELECT 1,MAX(Dat.CreditoIDSAFI),Fecha_Vacia FROM TMPDATOSCTESCREDPAG Dat
      INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoIDSAFI = Sal.CreditoID
    WHERE Sal.SalCapAtrasado > Entero_Cero AND Sal.FechaCorte =Var_FechaFin
      AND CONVERT(SUBSTRING(Dat.FechaInicio,3,2),SIGNED)<>MONTH(Var_FechaFin )
    GROUP BY Sal.CreditoID;

  -- Creditos Migrados que probablemente incumplieron
  INSERT INTO TMPINCUMPLIMIENTO
    SELECT 2,MAX(Eq.CreditoIDSAFI),Fecha_Vacia FROM EQU_CREDITOS Eq
      INNER JOIN SALDOSCREDITOS Sal ON Eq.CreditoIDSAFI = Sal.CreditoID
    WHERE Sal.SalCapAtrasado > Entero_Cero
      AND Sal.FechaCorte =Var_FechaFin
      AND Eq.FechaIncumplimiento= Fecha_Vacia
    GROUP BY Sal.CreditoID;

  INSERT INTO TMPINCUMPLIMIENTO
    SELECT 3,Dat.CreditoID,MIN(FechaExigible) FROM TMPINCUMPLIMIENTO Dat
      INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoID = Sal.CreditoID
    WHERE Sal.SalCapAtrasado > Entero_Cero
      AND Sal.FechaCorte <= Var_FechaFin
    GROUP BY Dat.CreditoID;

  -- = Actualizamo los Creditos migrados su Fecha de Incumplimiento
  UPDATE EQU_CREDITOS Equ
    INNER JOIN  TMPINCUMPLIMIENTO Inc ON Equ.CreditoIDSAFI = Inc.CreditoID
  SET Equ.FechaIncumplimiento = Inc.FechaIncum
  WHERE Equ.FechaIncumplimiento =Fecha_Vacia AND Inc.Numero=3;

  -- = Insertamos la Fecha de Incumplimiento de los creditos del mes
  INSERT INTO EQU_CREDITOS
    SELECT Inc.CreditoID ,Inc.CreditoID ,Cadena_Vacia,Inc.FechaIncum FROM TMPINCUMPLIMIENTO Inc
      LEFT JOIN EQU_CREDITOS Equ ON Equ.CreditoIDSAFI = Inc.CreditoID
    WHERE IFNULL(CreditoIDSAFI,Cadena_Vacia)=Cadena_Vacia AND Numero=3;

  -- Actualizamos las Fechas de Incumplimiento en el la tabla TMPDATOSCTESCREDPAG
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN EQU_CREDITOS EqC  ON Dat.CreditoIDSAFI = EqC.CreditoIDSAFI
  SET Dat.Incumplimiento = DATE_FORMAT(EqC.FechaIncumplimiento,FormatoFecha)
  WHERE  IFNULL(EqC.FechaIncumplimiento,Fecha_Vacia) <> Fecha_Vacia;

  -- Si la Fecha de incumplimiento es mayor a la Fechacorte dejamos vacio el campo
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN EQU_CREDITOS EqC  ON Dat.CreditoIDSAFI = EqC.CreditoIDSAFI
  SET Dat.Incumplimiento = Cadena_Vacia
  WHERE  IFNULL(EqC.FechaIncumplimiento,Fecha_Vacia) >= Var_FechaFin ;

  DROP TABLE IF EXISTS TMPINCUMPLIMIENTO;

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
    INNER JOIN TMPPERIODICIDADBC Tem ON Cre.FrecuenciaCap = Tem.FrecuenciaID
  SET Dat.FrecPagos = Tem.FrecuenciaBC
  WHERE Dat.FrecPagos <> FrecPagoUnicoSAFI;

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS                Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
    INNER JOIN TMPPERIODICIDADBC tmp ON  DATEDIFF(Cre.FechaVencimien,Cre.FechaInicio) >= tmp.DiaMinimo
                         AND DATEDIFF(Cre.FechaVencimien,Cre.FechaInicio) <= tmp.DiaMaximo
  SET Dat.FrecPagos = tmp.FrecuenciaBC
   WHERE Dat.FrecPagos = FrecPagoUnicoSAFI ;

  DROP TABLE IF EXISTS TMPPERIODICIDADBC;

  DROP TABLE IF EXISTS TMPSUMASALDOCAPCRED;
  CREATE TABLE TMPSUMASALDOCAPCRED(
    CreditoID   BIGINT(12) NOT NULL,
    Saldo     DECIMAL(14,2),
    Vencido     DECIMAL(14,2),
    SaldoTotal  DECIMAL(14,2),
    PRIMARY KEY (CreditoID)
  );

  INSERT INTO TMPSUMASALDOCAPCRED(
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
              (Sal.SalComFaltaPago) + (Sal.SaldoComServGar)+ (Sal.SalOtrasComisi)))
              ,Entero_Cero) AS SaldoTotal
      FROM TMPDATOSCTESCREDPAG Dat
        INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoIDSAFI = Sal.CreditoID
      WHERE Sal.FechaCorte =Par_FechaCorteBC
      GROUP BY Sal.CreditoID);


  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN TMPSUMASALDOCAPCRED Tem ON Dat.CreditoIDSAFI = Tem.CreditoID
  SET Dat.Saldo = Tem.Saldo, Dat.Vencido = Tem.Vencido, Dat.SaldoTotal = Tem.SaldoTotal;

  DROP TABLE IF EXISTS TMPSUMASALDOCAPCRED;

  UPDATE TMPDATOSCTESCREDPAG
    SET ImportePagos = FUNCIONIMPORTEPAGO(CreditoIDSAFI,Par_FechaCorteBC);

  -- == Se mensualiza El Monto de Pagos (ImportePago) ========
  DROP TABLE IF EXISTS TMPMONTOCUOTACREDITO;

  CREATE TABLE TMPMONTOCUOTACREDITO (
    CreditoID BIGINT(12) NOT NULL,
    MontoPago INT(11),
    PRIMARY KEY (CreditoID)
    );

  INSERT INTO TMPMONTOCUOTACREDITO
    SELECT MAX(Dat.CreditoIDSAFI) AS CreditoID ,
        ROUND(SUM(Pag.Capital + Pag.Interes + Pag.IVAInteres)) AS MontoPago
      FROM TMPDATOSCTESCREDPAG Dat
        INNER JOIN PAGARECREDITO Pag ON Dat.CreditoIDSAFI = Pag.CreditoID
    WHERE Pag.AmortizacionID= 1 AND Dat.FrecPagos IN (FrecSemanalBC,FrecCatorcenalBC,FrecQuincenalBC,FrecMensualBC,FrecBimestralBC,FrecTrimestralBC,FrecSemestralBC,FrecAnualBC)
     GROUP BY Pag.CreditoID;

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN TMPMONTOCUOTACREDITO Mon ON Dat.CreditoIDSAFI = Mon.CreditoID
  SET Dat.ImportePagos =(CASE Dat.FrecPagos WHEN FrecSemanalBC THEN (Mon.MontoPago * 4)
            WHEN FrecCatorcenalBC THEN (Mon.MontoPago * 2)
            WHEN FrecQuincenalBC THEN (Mon.MontoPago * 2)
            WHEN FrecMensualBC THEN Mon.MontoPago
            WHEN FrecBimestralBC THEN ROUND(Mon.MontoPago / 2)
            WHEN FrecTrimestralBC THEN ROUND(Mon.MontoPago /2)
            WHEN FrecSemestralBC THEN ROUND(Mon.MontoPago /6)
            WHEN FrecAnualBC THEN ROUND(Mon.MontoPago /12)
              END );

  DROP TABLE IF EXISTS TMPMONTOCUOTACREDITO;

  -- == Se mensualiza El Monto de Pagos (ImportePago) FIN ========
  UPDATE TMPDATOSCTESCREDPAG  Dat
    INNER JOIN SALDOSCREDITOS Sal ON Dat.CreditoIDSAFI = Sal.CreditoID
  SET Dat.DiasAtraso = IF(Sal.DiasAtraso>999,999,Sal.DiasAtraso), Dat.NoCuotasAtraso=Sal.NoCuotasAtraso
  WHERE Sal.FechaCorte =Par_FechaCorteBC;


  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
    INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
  SET Vencido = Entero_Cero
  WHERE (IFNULL(Dat.DiasAtraso,Entero_Cero) - IFNULL(Pro.DiasPasoAtraso,Entero_Cero))<= Entero_Cero;

  DROP TABLE IF EXISTS TEMP_RANGOMOP;
  CREATE TABLE TEMP_RANGOMOP(
    NoConseMOP     INT(11) NOT NULL,
    LimiteInferior INT(11),
    LimiteSuperior BIGINT(11),
    MOP        CHAR(2),
    PRIMARY KEY    (NoConseMOP),
    INDEX TEMP_RANGOMOP1 (MOP)
  );

  INSERT INTO TEMP_RANGOMOP VALUES
    (1,0,0,'01'),
    (2,1,29,'02'),
    (3,30,59,'03'),
    (4,60,89,'04'),
    (5,90,119,'05'),
    (6,120,149,'06'),
    (7,150,360,'07'),
    (8,360,9999999999,'96');

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP =Mop00
  WHERE DATEDIFF(Par_FechaCorteBC,Cre.FechaInicio)<DiasCtaReciente
    AND Cre.Estatus =EstatusVigente
    AND Dat.DiasAtraso =Entero_Cero;

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS    Cre  ON Cre.CreditoID = Dat.CreditoIDSAFI
    INNER  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP =Mop01
  WHERE  Cre.Estatus =EstatusVigente
    AND IFNULL(Dat.DiasAtraso,Entero_Cero)= Entero_Cero;

  UPDATE TMPDATOSCTESCREDPAG Dat
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP =Mop02
  WHERE Dat.DiasAtraso  BETWEEN 1 AND 29;

  UPDATE TMPDATOSCTESCREDPAG Dat
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP =Mop03
  WHERE Dat.DiasAtraso  BETWEEN 30 AND 59;

  UPDATE TMPDATOSCTESCREDPAG Dat
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP =Mop04
  WHERE Dat.DiasAtraso  BETWEEN 60 AND 89;

  UPDATE TMPDATOSCTESCREDPAG Dat
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP =Mop05
  WHERE Dat.DiasAtraso  BETWEEN 90 AND 119;

  UPDATE TMPDATOSCTESCREDPAG Dat
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP =Mop06
  WHERE Dat.DiasAtraso  BETWEEN 120 AND 149;

  UPDATE TMPDATOSCTESCREDPAG Dat
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP =Mop07
  WHERE Dat.DiasAtraso  BETWEEN 150 AND 365;

  UPDATE TMPDATOSCTESCREDPAG Dat
    LEFT  JOIN DETALLEPAGCRE Det  ON Dat.CreditoIDSAFI = Det.CreditoID
  SET MOP =Mop96
  WHERE Dat.DiasAtraso>365;

  UPDATE TMPDATOSCTESCREDPAG
  SET MOP =Mop01
  WHERE FechaCierre <>Fecha_Vaciaddmmyyyy;

  DROP TABLE IF EXISTS TEMP_RANGOMOP;

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN  CRECASTIGOS Cas ON Dat.CreditoIDSAFI = Cas.CreditoID
  SET Dat.FechaCierre = DATE_FORMAT(Cas.Fecha,FormatoFecha), Dat.ClaveObervacion=ClaveObsFiniq, MOP =Mop97
  WHERE Dat.Estatus=EstatusCastigado;

  UPDATE TMPDATOSCTESCREDPAG
    SET Incumplimiento = Fecha_Vaciaddmmyyyy
  WHERE IFNULL(Incumplimiento,Cadena_Vacia)=Cadena_Vacia;

  UPDATE TMPDATOSCTESCREDPAG
    SET NoCuotasAtraso = Entero_Cero
  WHERE IFNULL(NoCuotasAtraso,Cadena_Vacia) =Cadena_Vacia;

  UPDATE TMPDATOSCTESCREDPAG
    SET Telefono = Cadena_Vacia
  WHERE LENGTH(Telefono) <> Entero_Diez;

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN DETALLEPAGCRE Det ON Dat.CreditoIDSAFI =  Det.CreditoID
  SET Dat.MontoUltPago  = IFNULL(ROUND(Det.MontoTotPago),0)
  WHERE Det.FechaPago = CONCAT(SUBSTRING(Dat.FechaPago,5,8),'-',SUBSTRING(Dat.FechaPago,3,2),'-',SUBSTRING(Dat.FechaPago,1,2));

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
    INNER JOIN MONEDAS  Mon ON Cre.MonedaID    = Mon.MonedaID
  SET Dat.Moneda = Mon.EqBuroCred;

  -- Limpieza nombre del cliente
  UPDATE TMPDATOSCTESCREDPAG SET
    ApellidoPaterno = FNLIMPIACARACTBUROCRED(ApellidoPaterno,LimpiaAlfabetico),
    ApellidoMaterno = FNLIMPIACARACTBUROCRED(ApellidoMaterno,LimpiaAlfabetico),
    PrimerNombre    = FNLIMPIACARACTBUROCRED(PrimerNombre,LimpiaAlfabetico),
    SegundoNombre = FNLIMPIACARACTBUROCRED(SegundoNombre,LimpiaAlfabetico),
    TercerNombre  = FNLIMPIACARACTBUROCRED(TercerNombre,LimpiaAlfabetico),
    Prefijo     = FNLIMPIACARACTBUROCRED(Prefijo,LimpiaAlfabetico);

  -- Cambio de Orden Apellidos si se carece de Apellido Paterno
     UPDATE TMPDATOSCTESCREDPAG SET
    ApellidoPaterno = ApellidoMaterno,
          ApellidoMaterno = Cadena_Vacia
  WHERE ApellidoPaterno = 'X';

  UPDATE TMPDATOSCTESCREDPAG CRE
    INNER JOIN CREDITOSPLAZOS PLA ON CRE.PlazoID = PLA.PlazoID
  SET CRE.PlazoCredito=PLA.Dias/Factor_Meses;

  -- Actualizamos la nacionalidad del domicilio de cliente
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN PAISES Pa ON Dat.PaisResidencia = Pa.PaisID
  SET NacDomicilio = Pa.EqBuroCred;

  -- Actualizamos la nacionalidad del cliente
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN PAISES Pa ON Dat.PaisID = Pa.PaisID
  SET Nacionalidad = Pa.EqBuroCred;

  -- == Se indica los dias de Vencimiento del Credito
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS  Cre ON Dat.CreditoIDSAFI = Cre.CreditoID
  SET DiasAtraFecFinCre = IF(DATEDIFF(Cre.FechaVencimien,Var_FechaFin)<Entero_Cero,Entero_Cero,DATEDIFF(Cre.FechaVencimien,Var_FechaFin))
  WHERE  Dat.DiasAtraso > 0 AND Cre.FechaVencimien <= Var_FechaFin;

  UPDATE TMPDATOSCTESCREDPAG
  SET MOP=Mop00
  WHERE CONVERT(SUBSTRING(FechaInicio,3,2),SIGNED)=MONTH(Var_FechaFin)
    AND SUBSTRING(FechaInicio,5,4) = YEAR(Var_FechaFin)
        AND MOP=Mop01
        AND FechaPago=Fecha_Vaciaddmmyyyy;

  -- == Se indica los dias de Vencimiento de pago del Credito
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN (SELECT CreditoID,MIN(FechaVencim) AS FechaVencim
            FROM AMORTICREDITO WHERE Estatus=EstatusVencido GROUP BY CreditoID)AS cre
        ON Dat.CreditoIDSAFI=cre.CreditoID
  SET Dat.FechaUltPagoVen = DATE_FORMAT(cre.FechaVencim,FormatoFecha)
  WHERE Dat.Estatus = EstatusVencido
    AND cre.FechaVencim<= Var_FechaFin
    AND Dat.DiasAtraso > 0;

    DROP TABLE IF EXISTS TMP_OCUPACIONES;
  CREATE TEMPORARY TABLE TMP_OCUPACIONES(
    OcupacionID   INT(11),
        Descripcion   VARCHAR(50),
        INDEX(OcupacionID)
    );

    INSERT INTO TMP_OCUPACIONES (OcupacionID, Descripcion)
    SELECT OcupacionID, OcupacionHOGAR
      FROM OCUPACIONES
        WHERE Descripcion LIKE LikeCasa AND ImplicaTrabajo = Str_NO;

  INSERT INTO TMP_OCUPACIONES (OcupacionID, Descripcion)
    SELECT OcupacionID, OcupacionESTUDIANTE
      FROM OCUPACIONES
        WHERE Descripcion LIKE LikeEstudiante AND ImplicaTrabajo = Str_NO;

  INSERT INTO TMP_OCUPACIONES (OcupacionID, Descripcion)
    SELECT OcupacionID, OcupacionJUBILADO
      FROM OCUPACIONES
        WHERE Descripcion LIKE LikeJubilado AND ImplicaTrabajo = Str_NO;

  INSERT INTO TMP_OCUPACIONES (OcupacionID, Descripcion)
    SELECT OcupacionID, OcupacionDESEMPLEADO
      FROM OCUPACIONES
        WHERE (Descripcion LIKE LikeDesempleado OR Descripcion LIKE LikeDesocupado) AND ImplicaTrabajo = Str_NO;

    UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN TMP_OCUPACIONES tmp ON Dat.OcupacionID=tmp.OcupacionID
    SET Dat.Empresa     = tmp.Descripcion
    WHERE Dat.TipoPersona   = TipoPersFisica;

    DROP TABLE IF EXISTS TMP_OCUPACIONES;

  IF (Formato_Envio=Formato_Comas) THEN
    SET Separador   :=  ',';
    SET Var_Cinta     :=  EncabezadoCVS;
    SET Var_FechaCorte  :=  CONCAT(COALESCE(DATE_FORMAT(Var_FechaCorte,FormatoFecha),Cadena_Vacia),Separador) ;

    INSERT INTO BUROCREDINTFMEN
          (CintaID,   ClienteID,    Clave,  Fecha,        Cinta)
      VALUES  (Var_CintaID, Entero_Cero,  `Member`, Par_FechaCorteBC, Var_Cinta);

    OPEN CINTABURO;
      BEGIN DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
      CICLO: LOOP
      FETCH CINTABURO INTO
          Var_ClienteID,      Var_ApellidoPaterno,  Var_ApellidoMaterno,  Var_Adicional,    Var_PrimerNombre,
          Var_SegundoNombre,    Var_TercerNombre,   Var_FechaNacimiento,  Var_RFC,      Var_Prefijo,
          Var_EstadoCivil,    Var_Sexo,       Var_FDef,       Var_InDef,      Var_CalleNumero,
          Var_DirComplemento,   Var_Colonia,      Var_Municipio,      Var_Ciudad,     Var_estado,
          Var_CP,         Var_Telefono,     Var_Empresa,      Var_CalleNumero2, Var_DirComplemento2,
          Var_Colonia2,     Var_Municipio2,     Var_Ciudad2,      Var_Estado2,    Var_CP2,
          Var_Telefono2,      Var_Salario,      Var_member,       Var_nombre,     Var_CuentaAux,
          Var_Responsabilidad,  Var_TipoCuenta,     Var_TipoContrato,   Var_Moneda,     Var_NPagos,
          Var_FrecPagos,      Var_FechaInicio,    Var_vencido,      Var_MontoCredito, Var_ImportePagos,
          Var_Incumplimiento,   Var_saldo,        Var_FechaCierre,    Var_NPagosVencidos, Var_ClaveObservacion,
          Var_NDiasAtraso,    Var_UltimoPago,     Var_MOP,        Var_SaldoTotal,   Var_TipoPersona,
          Var_MontoUltPago,   Var_PlazoMeses,     Var_Nacionalidad,   Var_DiaAtrFecFinCre,Var_NacDomicilio,
          Var_CorreoElect,    Var_FechaUltPagoVen;

        SET Var_EstadoCivil:= (CASE Var_EstadoCivil
                      WHEN Casado_BM  THEN Casado_BC
                      WHEN Casado_BMC THEN Casado_BC
                      WHEN Casado_BS  THEN Casado_BC
                      WHEN Viudo    THEN Viudo_BC
                      WHEN Union_libre THEN Union_libreBC
                      WHEN EdoSeparado THEN Soltero_BC
                        ELSE LEFT(Var_EstadoCivil,1)
                    END);

        IF(Var_Prefijo=PrefijoSRITA) THEN
          SET Var_Prefijo :=PrefijoSRTA;
        END IF;

        IF(Var_FechaCierre != Fecha_Vaciaddmmyyyy) THEN
          SET Var_SaldoTotal    :=Entero_Cero;
          SET Var_NPagosVencidos  :=Entero_Cero;
          SET Var_Incumplimiento  :=Fecha_Vaciaddmmyyyy;
          SET Var_ImportePagos  := Entero_Cero;
        ELSE
          SET Var_FechaCierre := Cadena_Vacia;
        END IF;

                SET Var_MOP := TRIM(Var_MOP);

        /* SI HAN TRANSCURRIDO MAS DE 3 MESES DESDE LA FECHA DE INICIO DEL CREDITO A LA FECHA DE CORTE
                 * Y TIENE UN MOP 00 (MUY RECIENTE PARA SER CALIFICADA
                 * Y CON FRECUENCIA SEMESTRAL, ANUAL O UNICO, ENTONCES SE LE ASIGNA MOP 01 (CUENTA AL CORRIENTE) */
                IF(DATEDIFF(STR_TO_DATE(Var_FechaCorte, FormatoFecha),STR_TO_DATE(Var_FechaInicio, FormatoFecha))>DiasTresMeses AND IFNULL(Var_MOP,Mop00)=Mop00 AND Var_FrecPagos IN(FrecSemestralBC))THEN
          SET Var_MOP := MopUR;
                END IF;

                /* SI ES PAGO UNICO O ANUAL Y TIENE UN MOP 00*/
                IF(IFNULL(Var_MOP,Cadena_Vacia)=Cadena_Vacia AND Var_FrecPagos IN(FrecAnualBC,FrecVariableBC))THEN
          SET Var_MOP := MopUR;
                END IF;

                /* SI ES DE FRECUENCIA VARIABLE Y EL IMPORTE DE PAGO ES CERO ENTONCES SE SETEA CON EL SALDO TOTAL */
        IF(Var_FrecPagos = FrecVariableBC AND IFNULL(TRIM(Var_ImportePagos),Entero_Cero) = Entero_Cero)THEN
          SET Var_ImportePagos := Var_SaldoTotal;
        END IF;

                -- SI LA FECHA DE INCUMPLIMIENTO ESTA VACIA Y HAY DIAS DE ATRASO, SE SUMAN A LA FECHA DEL ULTIMO PAGO LOS DIAS DE ATRASO
                IF(Var_Incumplimiento=Fecha_Vaciaddmmyyyy AND IFNULL(Var_NDiasAtraso,Entero_Cero) > Entero_Cero)THEN
          SET Var_Incumplimiento := DATE_ADD(STR_TO_DATE(Var_FechaInicio, FormatoFecha), INTERVAL IFNULL(Var_NDiasAtraso,Entero_Cero)DAY);
                    SET Var_Incumplimiento := DATE_FORMAT(Var_Incumplimiento,FormatoFecha);
                END IF;

        IF(LENGTH(Var_Telefono) != 10) THEN
          SET Var_Telefono :=Cadena_Vacia;
        END IF;

        IF(LENGTH(Var_RFC) != 13 AND Var_TipoPersona != PersMoral) THEN
          SET Var_RFC :=Cadena_Vacia;
        END IF;

        IF (Var_MOP =Mop97) THEN -- Para CreditosCastigados
          SET Var_saldo       := Entero_Cero;
          SET Var_ImportePagos  := Entero_Cero;
          SET Var_ClaveObservacion:= ClaveObsCtaCast;
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

        SET Var_ApellidoPaterno := IFNULL(IF(Var_ApellidoPaterno=Cadena_Vacia,NULL,Var_ApellidoPaterno),NombreNoProporcionado);
        SET Var_ApellidoMaterno := IFNULL(IF(Var_ApellidoMaterno=Cadena_Vacia,NULL,Var_ApellidoMaterno),NombreNoProporcionado);
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
        SET Var_Sexo      := CONCAT(COALESCE(Var_Sexo,Cadena_Vacia),Separador) ;
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
        SET Var_Cuenta      := CONCAT(COALESCE(Var_CuentaAux,Cadena_Vacia),Separador) ;
        SET Var_Responsabilidad := CONCAT(COALESCE(Var_Responsabilidad,Cadena_Vacia),Separador);
        SET Var_TipoCuenta    := CONCAT(COALESCE(Var_TipoCuenta,Cadena_Vacia),Separador);
        SET Var_TipoContrato  := UPPER(CONCAT(COALESCE(Var_TipoContrato,Cadena_Vacia),Separador));
        SET Var_Moneda      := CONCAT(COALESCE(Var_Moneda,Cadena_Vacia),Separador) ;
        SET Var_Npagos      := CONCAT(COALESCE(Var_NPagos,Cadena_Vacia),Separador) ;
        SET Var_FrecPagos     := CONCAT(COALESCE(Var_FrecPagos,Cadena_Vacia),Separador) ;
        SET Var_ImportePagos  := CONCAT(COALESCE(Var_ImportePagos,Cadena_Vacia),Separador) ;
        SET Var_FechaCompra   := CONCAT(COALESCE(Var_FechaInicio,Cadena_Vacia),Separador) ;
        SET Var_FechaInicio   := CONCAT(COALESCE(Var_FechaInicio,Cadena_Vacia),Separador) ;

        IF (Var_UltimoPago =Fecha_Vaciaddmmyyyy) THEN -- validando si tiene un ultimo pago
          SET Var_UltimoPago    := Var_FechaCompra;
        ELSE
          SET Var_UltimoPago    := CONCAT(COALESCE(Var_UltimoPago,Cadena_Vacia),Separador) ;
        END IF;

        SET Var_MOP       := IF(IFNULL(Var_MOP,Cadena_Vacia)=Cadena_Vacia,Mop01,Var_MOP);
        SET Var_FechaReporte  := CONCAT(COALESCE(DATE_FORMAT(Par_FechaCorteBC,FormatoFecha),Cadena_Vacia),Separador) ;
        SET Var_MontoCredito  := CONCAT(COALESCE(Var_MontoCredito,Cadena_Vacia),Separador) ;
        SET Var_vencido     := CONCAT(COALESCE(Var_vencido,Cadena_Vacia),Separador) ;
        SET Var_NPagosVencidos  := CONCAT(COALESCE(Var_NPagosVencidos,Cadena_Vacia),Separador) ;
        SET Var_ClaveObservacion:= CONCAT(COALESCE(Var_ClaveObservacion,Cadena_Vacia),Separador) ;
        SET Var_MOP       := CONCAT(Var_MOP,Separador);
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

        SET Var_TipoCuenta := CONCAT(TipoCtaPagosFijos,Separador); -- Individual

        IF (Var_MOP =TRIM(CONCAT(Mop01,Separador)) AND Var_FechaCierre <> Separador) THEN
          SET Var_ClaveObservacion :=TRIM(CONCAT(ClaveObsCtaCanc,Separador));
        END IF;

        SET Var_InteresReportado := TRIM(CONCAT(Entero_Cero,Separador));

        IF (Var_FechaUltPagoVen != Separador) THEN
          SET Var_InteresReportado := ROUND(FNTOTALINTERESCREDITO(Var_CuentaAux));
          SET Var_InteresReportado := CONCAT(COALESCE(Var_InteresReportado,Entero_Cero),Separador);
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

        INSERT INTO BUROCREDINTFMEN VALUES (Var_CintaID,  Var_ClienteID,  `Member`, Par_FechaCorteBC, Var_Cinta);

        SET Var_Incumplimiento  := IFNULL(Var_Incumplimiento,Cadena_Vacia);

            END LOOP;
            END;
    CLOSE CINTABURO;

  END IF;

  DROP TABLE IF EXISTS TMPDATOSCTESCREDPAG;
END TerminaStore$$