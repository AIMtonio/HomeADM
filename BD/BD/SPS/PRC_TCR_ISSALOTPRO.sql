-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRC_TCR_ISSALOTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRC_TCR_ISSALOTPRO`;DELIMITER $$

CREATE PROCEDURE `PRC_TCR_ISSALOTPRO`()
BEGIN

/* Declaracion de Contantes */
DECLARE   Ent_Cero        INT;
DECLARE   NoEnviado       CHAR(1);
DECLARE   Iss_LimCred         DECIMAL;
DECLARE   Sta_Solici        INT;
DECLARE   Sta_Archivo       INT;
DECLARE   TipTarCredito     CHAR(1);


/*  Declaracion de Variables  */
DECLARE   ContaRegis        INT;
DECLARE   DataGroup       VARCHAR(9) ;
DECLARE   MesageCodeAltaS2    VARCHAR(4) ;
DECLARE   FillerSec2        TEXT ;
DECLARE   CBS_BankID        VARCHAR(30);
DECLARE   Num_TipoDoc       VARCHAR(15);
DECLARE   Num_TipDoc        VARCHAR(15);
DECLARE   FechaGenArch      VARCHAR(8);
DECLARE   CodigoRefe        VARCHAR(15);
DECLARE   ExpiraTar       VARCHAR(6) ;
DECLARE   NombreTarjeta     VARCHAR(60);
DECLARE   BacnkAccount      VARCHAR(30);
DECLARE   ConsignaEntrega     CHAR(1);
DECLARE   NombrePadre       VARCHAR(40);
DECLARE   NombreMadre       VARCHAR(40);
DECLARE   NomCardHolder     VARCHAR(60);  --  Nombre del Tarjetabiente
DECLARE   ApeCardHolder     VARCHAR(60);  -- Appellidos del Tarjetabiente
DECLARE   ServDefault       CHAR(1);
DECLARE   LlevaFoto       CHAR(1);
DECLARE   NivelRelacion     CHAR(1);
DECLARE   CardCarrier       CHAR(2);
DECLARE   CardHolderType      CHAR(1);  -- Tipo de Tarjetaabiente 1.-Titular   2.-Adicional
DECLARE   DriverType        CHAR(1);
DECLARE   Via           CHAR(2);
DECLARE   LoanAllowed       CHAR(1);
DECLARE   Bonificacion      VARCHAR(5);
DECLARE   IndicadorEspecial   CHAR(1);
DECLARE   CodigoEspecial      CHAR(2);
DECLARE   MesageCodeAltaS3    VARCHAR(4) ;
DECLARE   LimiteCredito     VARCHAR(18);
DECLARE   SalarioCardHolder   VARCHAR(18);
DECLARE   TipoAsigaLimCred    CHAR(1) ; -- Tipo de asignacion de el limite de credito 0 - Assigned by bank  1- Assigned by salary.
DECLARE   MontoMaxAsignado    VARCHAR(18);
DECLARE   MesageCodeAltaS4    VARCHAR(4) ;
DECLARE   TipoDireccion     CHAR(2) ;
DECLARE   Dir_Calle       VARCHAR(60);
DECLARE   Dir_NumeroExt     VARCHAR(5) ;
DECLARE   Dir_Colonia       VARCHAR(50);
DECLARE   Dir_Complemento     VARCHAR(30);
DECLARE   Dir_Ciudad        VARCHAR(50);
DECLARE   EstadoRepu        VARCHAR(4) ;  --  ID de el estado de la republica de acuerdo a catalogo de Prosa
DECLARE   Dir_CodidoPos     VARCHAR(10);
DECLARE   TelFijo         VARCHAR(20);
DECLARE   TelFax          VARCHAR(20);
DECLARE   TelCelular        VARCHAR(20);
DECLARE   CorreoEelc        VARCHAR(128);
DECLARE   FecDesde        VARCHAR(8);
DECLARE   FecHasta        VARCHAR(8);
DECLARE   NumInterno        VARCHAR(10);
DECLARE   TiempoVivirDir      VARCHAR(8);-- Period of residence Period of time the cardholder lives in the specified address. (format YYYYMMDD) Same as date from." Se coloca el dato en caso de tenerlo, para el resto son 00000000
DECLARE   EntregaTipoDir      CHAR(2);
DECLARE   MesageCodeAltaS5    VARCHAR(4) ;
DECLARE   NombreEmpresa     VARCHAR(64);
DECLARE   PuestoTrabajo     VARCHAR(64);
DECLARE   Salario         VARCHAR(18);
DECLARE   FechaIngresoTrab    VARCHAR(8) ;
DECLARE   SucursalDeCompania    VARCHAR(30);
DECLARE   Departamento      VARCHAR(30);
DECLARE   AreaCompania      VARCHAR(30);
DECLARE   NumEmpleados      VARCHAR(12);
DECLARE   CorreoTrabajo     VARCHAR(128);
DECLARE   TipoContrato      VARCHAR(1);
DECLARE   TipoIngresos      VARCHAR(1);
DECLARE   OtrosIngresos     VARCHAR(18);
DECLARE   Titular         VARCHAR(1);
DECLARE   MesageCodeAltaS6    VARCHAR(4);
DECLARE   Agencia         VARCHAR(9);
DECLARE   CBSCuenta       VARCHAR(30);
DECLARE   CBSMoneda       VARCHAR(3);
DECLARE   ExtraInfo       VARCHAR(80);
DECLARE   OverDraft       VARCHAR(18);
DECLARE   CBSTipoCuenta     CHAR(2);
DECLARE   MesageCodeAltaS7    VARCHAR(4);
DECLARE   MonMaxRetDiaPOS     VARCHAR(18);
DECLARE   MonMaxRetDiaATM     VARCHAR(18);
DECLARE   MonMaxRetSemPOS     VARCHAR(18);
DECLARE   MonMaxRetSemATM     VARCHAR(18);
DECLARE   MonMaxRetMesPOS     VARCHAR(18);
DECLARE   MonMaxRetMesATM     VARCHAR(18);
DECLARE   NumMaxTraDiaPOS     VARCHAR(9) ;
DECLARE   NumMaxTraDiaATM     VARCHAR(9) ;
DECLARE   NumMaxTraSemPOS     VARCHAR(9) ;
DECLARE   NumMaxTraSemATM     VARCHAR(9) ;
DECLARE   NumMaxTraMesPOS     VARCHAR(9) ;
DECLARE   NumMaxTraMesATM     VARCHAR(9) ;
DECLARE   MontoMaxDevol     VARCHAR(18);
DECLARE   MesageCodeAltaS8    VARCHAR(4)  ;
DECLARE   CuentaDefault     CHAR(1) ;


/*  Variables con las que se recuperan los valores de el Cursor */
DECLARE    Val_IssSeccion     SMALLINT;
DECLARE   Val_IssCampoID      SMALLINT;
DECLARE   Val_IssAltaLot      TEXT;


DECLARE    FechaAct       DATETIME;
DECLARE   FolioArchivo      BIGINT  ;
DECLARE   FolioString       VARCHAR(6) ;
DECLARE   FechaHoraCrea     VARCHAR(12);
DECLARE   RegistroID        VARCHAR(7);
DECLARE   TotalRegistros      VARCHAR(9);
DECLARE   TipoDirLlegaEdoCta    CHAR(2);
DECLARE   TipoDirLlegaTar     CHAR(2);
DECLARE   CodigoPais        VARCHAR(3);
DECLARE   NombreCortoProsa    VARCHAR(9);


/* Declaracion de las constantes para identificar cada seccion de el archivo ISS  */
DECLARE   SEC_HEADER        SMALLINT;
DECLARE   SEC_REGISTROTARJETA   SMALLINT;
DECLARE   SEC_LIMITCREDITO    SMALLINT;
DECLARE   SEC_DIRECCION     SMALLINT;
DECLARE   SEC_JOBRECORD     SMALLINT;
DECLARE   SEC_CBSACCOUND      SMALLINT;
DECLARE   SEC_LIMITCREDITODSM   SMALLINT;
DECLARE   SEC_CBSASSOCIATION    SMALLINT;
DECLARE   SEC_TRAILERRECORD   SMALLINT;


/*  Declaracion  de ID de los Campos o columnas de la Seccion 1 que corresponde a el Header
  De acuerdo a el Layout de Prosa   */
DECLARE   SEC1_HEADER         SMALLINT;
DECLARE   SEC1_APPCOMING        SMALLINT;
DECLARE   SEC1_CONFAUTORIZADOR    SMALLINT;
DECLARE   SEC1_TIPOFILE       SMALLINT;
DECLARE   SEC1_PERIODICIDAD     SMALLINT;
DECLARE   SEC1_EXTENCION        SMALLINT;
DECLARE   SEC1_USUARIO        SMALLINT;
DECLARE   SEC1_PASSWORD       SMALLINT;
DECLARE   SEC1_IDENTIFICACION     SMALLINT;



/*  Declaracion  de ID de los Campos o columnas de la Seccion 2 que corresponde a  Cards and Accounts Record
  De acuerdo a el Layout de Prosa   */

DECLARE   SEC2_CMSUSER        INT;
DECLARE   SEC2_PASSWCMS       INT;
DECLARE   SEC2_CHECKEDAUTORIZA    INT;
DECLARE   SEC2_DEF_SUCURSAUTOR    INT;
DECLARE   SEC2_DEF_PRODUCPROSA    INT;
DECLARE   SEC2_DEF_TIPODOCAUTORI    INT;
DECLARE   SEC2_DEF_ALTANUMTAR     INT;
DECLARE   SEC2_DEF_ALTAPRIMARYCARD  INT;
DECLARE   SEC2_DEF_GRUPOENALTATAR   INT;
DECLARE   SEC2_DEF_TIPOTARJETA    INT;
DECLARE   SEC2_DEF_COSTOCODE      INT;
DECLARE   SEC2_MESESVIGENCIA      INT;
DECLARE   SEC2_DEF_CLIENTEVIP     INT;
DECLARE   SEC2_NOMBRETARJETA      INT;
DECLARE   SEC2_DEF_EMBOSSING      INT;
DECLARE   SEC2_PIN_PCI        INT;
DECLARE   SEC2_TRACK1_PCI       INT;
DECLARE   SEC2_TRACK2_PCI       INT;
DECLARE   SEC2_PASSTELEFONO     INT;
DECLARE   SEC2_VIGENCIAPASSTEL    INT;
DECLARE   SEC2_DEF_CORREOVACIO    INT;
DECLARE   SEC2_DEF_ADONDEEVIATARJETA  INT;
DECLARE   SEC2_DEF_COMPENVIAPLASTICO  INT;
DECLARE   SEC2_DEF_EMBOSADORA     INT;
DECLARE   SEC2_DEF_EXPIRACODE     INT;
DECLARE   SEC2_DEF_FECHACUMPLE    INT;
DECLARE   SEC2_DEF_LUGARNACIMIENTO  INT;
DECLARE   SEC2_DEF_NACIONALIDAD   INT;
DECLARE   SEC2_DEF_GENEROPERSONA    INT;
DECLARE   SEC2_DEF_ESTADOCIVIL    INT;
DECLARE   SEC2_DEF_OCUPACION      INT;
DECLARE   SEC2_DEF_GIRONEGOCIO    INT;
DECLARE   SEC2_DEF_CANTEMPLEADOS    INT;
DECLARE   SEC2_DEF_RFC        INT;
DECLARE   SEC2_ORGANIZACION     INT;
DECLARE   SEC2_DEF_ESTADOREPUBLICA  INT;
DECLARE   SEC2_DEF_OVERLIMIT      INT;
DECLARE   SEC2_DEF_LINEGROUPREF   INT;
DECLARE   SEC2_DEF_TIPOMONEDA     INT;
DECLARE   SEC2_DEF_PASSWCUECLI    INT;
DECLARE   SEC2_DEF_LENGUAJEOPERA    INT;
DECLARE   SEC2_DEF_NIVELACCESOTAR   INT;
DECLARE   SEC2_DEF_CODIGOCANALESVENT  INT;
DECLARE   SEC2_DEF_CAMPANIAVENTAS   INT;
DECLARE   SEC2_DEF_PROMOTOR     INT;
DECLARE   SEC2_DEF_CONSIGNACION   INT;
DECLARE   SEC2_DEF_TITULOPERSONA    INT;
DECLARE   SEC2_PAMCARDNUMBER      INT;
DECLARE   SEC2_MERCHANTCODE     INT;
DECLARE   SEC2_FILLER         INT;




/*  Declaracion  de ID de los Campos o columnas de la Seccion 3 que corresponde a  Limite de Credito
  De acuerdo a el Layout de Prosa   */
DECLARE   SEC3_CMSUSER        SMALLINT;
DECLARE   SEC3_PASSWCMS       SMALLINT;
DECLARE   SEC3_CHECKEDAUTORIZA    SMALLINT;
DECLARE   SEC3_DEF_SUCURSAUTOR    SMALLINT;
DECLARE   SEC3_DEF_PRODUCPROSA    SMALLINT;
DECLARE   SEC3_DEF_TIPODOCAUTORI    SMALLINT;
DECLARE   SEC3_DEF_ALTANUMTAR     SMALLINT;
DECLARE   SEC3_MONEDA         SMALLINT;
DECLARE   SEC3_TIPOINCREMENTO     SMALLINT;


/*  Declaracion  de ID de los Campos o columnas de la Seccion 4 que corresponde a  Direccion
  De acuerdo a el Layout de Prosa   */
DECLARE   SEC4_CMSUSER        SMALLINT;
DECLARE   SEC4_PASSWCMS       SMALLINT;
DECLARE   SEC4_CHECKEDAUTORIZA    SMALLINT;
DECLARE   SEC4_DEF_SUCURSAUTOR    SMALLINT;
DECLARE   SEC4_DEF_PRODUCPROSA    SMALLINT;
DECLARE   SEC4_DEF_TIPODOCAUTORI    SMALLINT;
DECLARE   SEC4_DEF_ALTANUMTAR     SMALLINT;
DECLARE   SEC4_FILLER         SMALLINT;



/*  Declaracion  de ID de los Campos o columnas de la Seccion 5 que corresponde a  Job Record
  De acuerdo a el Layout de Prosa   */

DECLARE   SEC5_CMSUSER        SMALLINT;
DECLARE   SEC5_PASSWCMS       SMALLINT;
DECLARE   SEC5_CHECKEDAUTORIZA    SMALLINT;
DECLARE   SEC5_DEF_SUCURSAUTOR    SMALLINT;
DECLARE   SEC5_DEF_PRODUCPROSA    SMALLINT;
DECLARE   SEC5_DEF_TIPODOCAUTORI    SMALLINT;
DECLARE   SEC5_DEF_ALTANUMTAR     SMALLINT;
DECLARE   SEC5_LINEANEGOCIO     SMALLINT;
DECLARE   SEC5_COMPANIA_CGC     SMALLINT;


/*  Declaracion  de ID de los Campos o columnas de la Seccion 6 que corresponde a  CBS Accound Record
  De acuerdo a el Layout de Prosa   */
DECLARE   SEC6_CMSUSER        SMALLINT;
DECLARE   SEC6_PASSWCMS       SMALLINT;
DECLARE   SEC6_CHECKEDAUTORIZA    SMALLINT;
DECLARE   SEC6_DEF_SUCURSAUTOR    SMALLINT;
DECLARE   SEC6_DEF_PRODUCPROSA    SMALLINT;
DECLARE   SEC6_DEF_TIPODOCAUTORI    SMALLINT;
DECLARE   SEC6_DEF_ALTANUMTAR     SMALLINT;



/*  Declaracion  de ID de los Campos o columnas de la Seccion 7 que corresponde a  Daily, Weekly, and Monthly Credit Limit
  De acuerdo a el Layout de Prosa   */
DECLARE   SEC7_CMSUSER        SMALLINT;
DECLARE   SEC7_PASSWCMS       SMALLINT;
DECLARE   SEC7_CHECKEDAUTORIZA    SMALLINT;
DECLARE   SEC7_DEF_SUCURSAUTOR    SMALLINT;
DECLARE   SEC7_DEF_PRODUCPROSA    SMALLINT;
DECLARE   SEC7_DEF_TIPODOCAUTORI    SMALLINT;
DECLARE   SEC7_DEF_ALTANUMTAR     SMALLINT;
DECLARE   SEC7_FILLER         SMALLINT;


/*  Declaracion  de ID de los Campos o columnas de la Seccion 8 que corresponde a  CBS Account Association Record
  De acuerdo a el Layout de Prosa   */
DECLARE   SEC8_CMSUSER        SMALLINT;
DECLARE   SEC8_PASSWCMS       SMALLINT;
DECLARE   SEC8_CHECKEDAUTORIZA    SMALLINT;
DECLARE   SEC8_DEF_SUCURSAUTOR    SMALLINT;
DECLARE   SEC8_DEF_PRODUCPROSA    SMALLINT;
DECLARE   SEC8_DEF_TIPODOCAUTORI    SMALLINT;
DECLARE   SEC8_DEF_ALTANUMTAR     SMALLINT;


/*  Declaracion  de ID de los Campos o columnas de la Seccion 9 que corresponde a  Trailer Record
  De acuerdo a el Layout de Prosa   */
DECLARE   SEC9_HEADERRECORD       SMALLINT;
DECLARE   SEC9_APPLICATIONCOMMING     SMALLINT;
DECLARE   SEC9_CHECKEDAUTORIZA      SMALLINT;
DECLARE   SEC9_TIPOFILE         SMALLINT;
DECLARE   SEC9_PERIODICIDAD       SMALLINT;
DECLARE   SEC9_EXTENCION          SMALLINT;
DECLARE   SEC9_CMSUSER          SMALLINT;
DECLARE   SEC9_PASSWCMS         SMALLINT;
DECLARE   SEC9_SENDERIDENTIFICATION   SMALLINT;


/* Variables de la Seccion 1 que corresponde a el Header en las cuales se recupera los valores
   parametrizados en la tabla */
DECLARE   Val_SEC1HEADER        VARCHAR(7);
DECLARE   Val_SEC1APPCOMING     VARCHAR(3);
DECLARE   Val_SEC1CONFAUTORIZADOR   VARCHAR(5);
DECLARE   Val_SEC1TIPOFILE      VARCHAR(4);
DECLARE   Val_SEC1PERIODICIDAD    CHAR(2);
DECLARE   Val_SEC1EXTENCION     VARCHAR(4);
DECLARE   Val_SEC1USUARIO       VARCHAR(8);
DECLARE   Val_SEC1PASSWORD      VARCHAR(16);
DECLARE   Val_SEC1IDENTIFICACION    VARCHAR(6) ;




/* Variables de la Seccion 2 que corresponde a Cards and Accounts Record en las cuales se recupera los valores
   parametrizados en la tabla */
DECLARE   Val_SEC2CMSUSER           VARCHAR(16);
DECLARE   Val_SEC2PASSWCMS          VARCHAR(16);
DECLARE   Val_SEC2CHECKEDAUTORIZA       VARCHAR(4);
DECLARE   Val_SEC2DEF_SUCURSAUTOR       VARCHAR(5);
DECLARE   Val_SEC2DEF_PRODUCPROSA       CHAR(2);
DECLARE   Val_SEC2DEF_TIPODOCAUTORI     CHAR(2);
DECLARE   Val_SEC2DEF_ALTANUMTAR        VARCHAR(19);
DECLARE   Val_SEC2DEF_ALTAPRIMARYCARD     VARCHAR(19);
DECLARE   Val_SEC2DEF_GRUPOENALTATAR      VARCHAR(7);
DECLARE   Val_SEC2DEF_TIPOTARJETA       CHAR(2);
DECLARE   Val_SEC2DEF_COSTOCODE       VARCHAR(4);
DECLARE   Val_SEC2MESESVIGENCIA       CHAR(2);
DECLARE   Val_SEC2DEF_CLIENTEVIP        CHAR(1);
DECLARE   Val_SEC2NOMBRETARJETA       VARCHAR(27);
DECLARE   Val_SEC2DEF_EMBOSSING       VARCHAR(25);
DECLARE   Val_SEC2PIN_PCI           VARCHAR(16);
DECLARE   Val_SEC2TRACK1_PCI          VARCHAR(79);
DECLARE   Val_SEC2TRACK2_PCI          VARCHAR(40);
DECLARE   Val_SEC2PASSTELEFONO        VARCHAR(16);
DECLARE   Val_SEC2VIGENCIAPASSTEL       VARCHAR(8);
DECLARE   Val_SEC2DEF_CORREOVACIO       VARCHAR(16);
DECLARE   Val_SEC2DEF_ADONDEEVIATARJETA   CHAR(1);
DECLARE   Val_SEC2DEF_COMPENVIAPLASTICO   CHAR(2);
DECLARE   Val_SEC2DEF_EMBOSADORA        CHAR(2);
DECLARE   Val_SEC2DEF_EXPIRACODE        CHAR(2);
DECLARE   Val_SEC2DEF_FECHACUMPLE       VARCHAR(8);
DECLARE   Val_SEC2DEF_LUGARNACIMIENTO     VARCHAR(25);
DECLARE   Val_SEC2DEF_NACIONALIDAD      VARCHAR(25);
DECLARE   Val_SEC2DEF_GENEROPERSONA     CHAR(1);
DECLARE   Val_SEC2DEF_ESTADOCIVIL       CHAR(2);
DECLARE   Val_SEC2DEF_OCUPACION       VARCHAR(4);
DECLARE   Val_SEC2DEF_GIRONEGOCIO       VARCHAR(4);
DECLARE   Val_SEC2DEF_CANTEMPLEADOS     CHAR(2) ;
DECLARE   Val_SEC2DEF_RFC           VARCHAR(15);
DECLARE   Val_SEC2ORGANIZACION        VARCHAR(10);
DECLARE   Val_SEC2DEF_ESTADOREPUBLICA     VARCHAR(4);
DECLARE   Val_SEC2DEF_OVERLIMIT       CHAR(1);
DECLARE   Val_SEC2DEF_LINEGROUPREF      CHAR(2);
DECLARE   Val_SEC2DEF_TIPOMONEDA        CHAR(2);
DECLARE   Val_SEC2DEF_PASSWCUECLI       VARCHAR(16);
DECLARE   Val_SEC2DEF_LENGUAJEOPERA     CHAR(2);
DECLARE   Val_SEC2DEF_NIVELACCESOTAR      VARCHAR(127);
DECLARE   Val_SEC2DEF_CODIGOCANALESVENT   VARCHAR(4);
DECLARE   Val_SEC2DEF_CAMPANIAVENTAS      VARCHAR(4);
DECLARE   Val_SEC2DEF_PROMOTOR        VARCHAR(10);
DECLARE   Val_SEC2DEF_CONSIGNACION      CHAR(1);
DECLARE   Val_SEC2DEF_TITULOPERSONA     VARCHAR(5);
DECLARE   Val_SEC2PAMCARDNUMBER       VARCHAR(7);
DECLARE   Val_SEC2MERCHANTCODE        VARCHAR(8);
DECLARE   Val_SEC2FILLER                TEXT;


/* Variables de la Seccion 3 que corresponde a Limite de Credito en las cuales se recupera los valores
   parametrizados en la tabla */

DECLARE   Val_SEC3CMSUSER           VARCHAR(16);
DECLARE   Val_SEC3PASSWCMS          VARCHAR(16);
DECLARE   Val_SEC3CHECKEDAUTORIZA       VARCHAR(4);
DECLARE   Val_SEC3DEF_SUCURSAUTOR       VARCHAR(5);
DECLARE   Val_SEC3DEF_PRODUCPROSA       CHAR(2);
DECLARE   Val_SEC3DEF_TIPODOCAUTORI     CHAR(2) ;
DECLARE   Val_SEC3DEF_ALTANUMTAR        VARCHAR(19);
DECLARE   Val_SEC3MONEDA            VARCHAR(4) ;
DECLARE   Val_SEC3TIPOINCREMENTO        VARCHAR(1) ;


/* Variables de la Seccion 4 que corresponde a Direccion en las cuales se recupera los valores
   parametrizados en la tabla */
DECLARE   Val_SEC4CMSUSER           VARCHAR(16);
DECLARE   Val_SEC4PASSWCMS          VARCHAR(16);
DECLARE   Val_SEC4CHECKEDAUTORIZA       VARCHAR(4) ;
DECLARE   Val_SEC4DEF_SUCURSAUTOR       VARCHAR(5) ;
DECLARE   Val_SEC4DEF_PRODUCPROSA       CHAR(2) ;
DECLARE   Val_SEC4DEF_TIPODOCAUTORI     CHAR(2) ;
DECLARE   Val_SEC4DEF_ALTANUMTAR        VARCHAR(19);
DECLARE   Val_SEC4FILLER            VARCHAR(48);


/* Variables de la Seccion 5 que corresponde a Job record en las cuales se recupera los valores
   parametrizados en la tabla */
DECLARE   Val_SEC5CMSUSER           VARCHAR(16);
DECLARE   Val_SEC5PASSWCMS          VARCHAR(16);
DECLARE   Val_SEC5CHECKEDAUTORIZA       VARCHAR(4) ;
DECLARE   Val_SEC5DEF_SUCURSAUTOR       VARCHAR(5) ;
DECLARE   Val_SEC5DEF_PRODUCPROSA       CHAR(2) ;
DECLARE   Val_SEC5DEF_TIPODOCAUTORI     CHAR(2) ;
DECLARE   Val_SEC5DEF_ALTANUMTAR        VARCHAR(19);
DECLARE   Val_SEC5LINEANEGOCIO        VARCHAR(4) ;
DECLARE   Val_SEC5COMPANIA_CGC        VARCHAR(15);



/* Variables de la Seccion 6 que corresponde a CBS Accound record en las cuales se recupera los valores
   parametrizados en la tabla */
DECLARE   Val_SEC6CMSUSER       VARCHAR(16);
DECLARE   Val_SEC6PASSWCMS      VARCHAR(16);
DECLARE   Val_SEC6CHECKEDAUTORIZA   VARCHAR(4) ;
DECLARE   Val_SEC6DEF_SUCURSAUTOR   VARCHAR(5) ;
DECLARE   Val_SEC6DEF_PRODUCPROSA   CHAR(2) ;
DECLARE   Val_SEC6DEF_TIPODOCAUTORI CHAR(2) ;
DECLARE   Val_SEC6DEF_ALTANUMTAR    VARCHAR(19);



/* Variables de la Seccion 7 que corresponde a Daily, Weekly, and Monthly Credit Limit
  en las cuales se recupera los valores parametrizados en la tabla */
DECLARE   Val_SEC7CMSUSER       VARCHAR(16);
DECLARE   Val_SEC7PASSWCMS      VARCHAR(16);
DECLARE   Val_SEC7CHECKEDAUTORIZA   VARCHAR(4) ;
DECLARE   Val_SEC7DEF_SUCURSAUTOR   VARCHAR(5) ;
DECLARE   Val_SEC7DEF_PRODUCPROSA   CHAR(2) ;
DECLARE   Val_SEC7DEF_TIPODOCAUTORI CHAR(2) ;
DECLARE   Val_SEC7DEF_ALTANUMTAR    VARCHAR(19);
DECLARE   Val_SEC7FILLER        VARCHAR(50);


/* Variables de la Seccion 8 que corresponde a CBS Account Association Record
  en las cuales se recupera los valores parametrizados en la tabla */
DECLARE   Val_SEC8CMSUSER       VARCHAR(16);
DECLARE   Val_SEC8PASSWCMS      VARCHAR(16);
DECLARE   Val_SEC8CHECKEDAUTORIZA   VARCHAR(4) ;
DECLARE   Val_SEC8DEF_SUCURSAUTOR   VARCHAR(5) ;
DECLARE   Val_SEC8DEF_PRODUCPROSA   CHAR(2) ;
DECLARE   Val_SEC8DEF_TIPODOCAUTORI CHAR(2) ;
DECLARE   Val_SEC8DEF_ALTANUMTAR    VARCHAR(19);


/* Variables de la Seccion 9 que corresponde a Trailer Record
  en las cuales se recupera los valores parametrizados en la tabla */
DECLARE   Val_SEC9HEADERRECORD      VARCHAR(7);
DECLARE   Val_SEC9APPLICATIONCOMMING    VARCHAR(3);
DECLARE   Val_SEC9CHECKEDAUTORIZA     VARCHAR(5) ;
DECLARE   Val_SEC9TIPOFILE        VARCHAR(4);
DECLARE   Val_SEC9PERIODICIDAD      CHAR(2);
DECLARE   Val_SEC9EXTENCION       VARCHAR(4);
DECLARE   Val_SEC9CMSUSER         VARCHAR(8);
DECLARE   Val_SEC9PASSWCMS        VARCHAR(16);
DECLARE   Val_SEC9SENDERIDENTIFICATION  VARCHAR(6);


-- Declaracion de Variables para tabla de solicitudes de tarjeta
DECLARE   Num_Solici      INT    ;
DECLARE   FechaSolici     DATE   ;
DECLARE   Num_Sucurs      VARCHAR(5);
DECLARE   Iss_CantTarj    INT    ;
DECLARE   Tipo_Tarjeta    VARCHAR(4);
DECLARE   Vigencia_Meses    INT    ;
DECLARE   ColorPlastico   INT    ;
DECLARE   ColorTarjeta    VARCHAR(2);

DECLARE Cue_ParametrosISS CURSOR FOR
  SELECT  Iss_Seccion,  Iss_CampoID,  Iss_AltaLot
  FROM TCR_TCISSVALF_ADM;

  -- Cursor para obtener las solicitudes de tarjeta
DECLARE Cur_SolicitudISS CURSOR FOR
    SELECT  LOT.LoteDebitoID, LOT.FechaRegistro,  RIGHT(CONCAT('00000', LOT.SucursalSolicita),5), LOT.NumTarjetas,  TIT.TipoProsaID,
        TIT.VigenciaMeses,  TIT.ColorTarjeta
      FROM    LOTETARJETADEB  LOT
            INNER JOIN  TIPOTARJETADEB  TIT
        ON TIT.TipoTarjetaDebID= LOT.TipoTarjetaDebID

        AND LOT.Estatus = Sta_Solici; -- este cursor nunca se cumplira, debera sustituir la tabla a la cual se leera en cuestion de tarjeta de credito y cambiar el on del inner join

/* Asignacion de Constantes */
SET     Ent_Cero        = 0   ; -- Valor Constante de Entero Cero
SET     NoEnviado       = 'N'   ; -- Indica que el Archivo ISS no se ha enviado a Prosa
SET     TipoDirLlegaEdoCta    = '01'  ; --  01 Donde llega el Estado Cuenta
SET     TipoDirLlegaTar     = '05'  ; --  05 Lugar donde llega la tarjeta fisicamente.
SET     CodigoPais        = '484' ; -- Valor por default indicado en el layout
SET       Iss_LimCred       = 0   ; -- Valor por default para limite de credito
SET     Sta_Solici        = 1   ; -- Valor de estatus Tarjetas Solicitadas
SET     Sta_Archivo       = 2   ; -- Valor de estatus Tarjeta en Archivo


/* Secciones de el Layout dpara el Archvio ISS */
SET     SEC_HEADER          = 1 ;
SET     SEC_REGISTROTARJETA     = 2 ;
SET     SEC_LIMITCREDITO      = 3 ;
SET     SEC_DIRECCION       = 4 ;
SET     SEC_JOBRECORD       = 5 ;
SET     SEC_CBSACCOUND        = 6 ;
SET     SEC_LIMITCREDITODSM     = 7 ;
SET     SEC_CBSASSOCIATION      = 8 ;
SET     SEC_TRAILERRECORD     = 9 ;



/*  Asignacions de ID de los Campos o columnas de la Seccion 1 que corresponde a el Header
  De acuerdo a el Layout de Prosa  */
SET     SEC1_HEADER       = 1;
SET     SEC1_APPCOMING      = 2;
SET     SEC1_CONFAUTORIZADOR  = 3;
SET     SEC1_TIPOFILE     = 4;
SET     SEC1_PERIODICIDAD   = 5;
SET     SEC1_EXTENCION      = 7;
SET     SEC1_USUARIO      = 9;
SET     SEC1_PASSWORD     = 10;
SET     SEC1_IDENTIFICACION   = 12;



/*  Asignacions de ID de los Campos o columnas de la Seccion 2 que corresponde a Cards and Accounts Record
  De acuerdo a el Layout de Prosa   */

SET   SEC2_CMSUSER          = 1 ;
SET   SEC2_PASSWCMS         = 2 ;
SET   SEC2_CHECKEDAUTORIZA      = 6 ;
SET   SEC2_DEF_SUCURSAUTOR      = 7 ;
SET   SEC2_DEF_PRODUCPROSA      = 8 ;
SET   SEC2_DEF_TIPODOCAUTORI      = 10;
SET   SEC2_DEF_ALTANUMTAR       = 12;
SET   SEC2_DEF_ALTAPRIMARYCARD    = 13;
SET   SEC2_DEF_GRUPOENALTATAR     = 14;
SET   SEC2_DEF_TIPOTARJETA      = 18;
SET   SEC2_DEF_COSTOCODE        = 19;
SET   SEC2_MESESVIGENCIA        = 21;
SET   SEC2_DEF_CLIENTEVIP       = 22;
SET   SEC2_NOMBRETARJETA        = 23;
SET   SEC2_DEF_EMBOSSING        = 24;
SET   SEC2_PIN_PCI          = 25;
SET   SEC2_TRACK1_PCI         = 26;
SET   SEC2_TRACK2_PCI         = 27;
SET   SEC2_PASSTELEFONO       = 28;
SET   SEC2_VIGENCIAPASSTEL      = 29;
SET   SEC2_DEF_CORREOVACIO      = 30;
SET   SEC2_DEF_ADONDEEVIATARJETA    = 31;
SET   SEC2_DEF_COMPENVIAPLASTICO    = 32;
SET   SEC2_DEF_EMBOSADORA       = 33;
SET   SEC2_DEF_EXPIRACODE       = 34;
SET   SEC2_DEF_FECHACUMPLE      = 35;
SET   SEC2_DEF_LUGARNACIMIENTO    = 36;
SET   SEC2_DEF_NACIONALIDAD     = 37;
SET   SEC2_DEF_GENEROPERSONA      = 38;
SET   SEC2_DEF_ESTADOCIVIL      = 39;
SET   SEC2_DEF_OCUPACION        = 41;
SET   SEC2_DEF_GIRONEGOCIO      = 42;
SET   SEC2_DEF_CANTEMPLEADOS      = 43;
SET   SEC2_DEF_RFC          = 44;
SET   SEC2_ORGANIZACION       = 45;
SET   SEC2_DEF_ESTADOREPUBLICA    = 46;
SET   SEC2_DEF_OVERLIMIT        = 47;
SET   SEC2_DEF_LINEGROUPREF     = 48;
SET   SEC2_DEF_TIPOMONEDA       = 49;
SET   SEC2_DEF_PASSWCUECLI      = 51;
SET   SEC2_DEF_LENGUAJEOPERA      = 52;
SET   SEC2_DEF_NIVELACCESOTAR     = 53;
SET   SEC2_DEF_CODIGOCANALESVENT    = 54;
SET   SEC2_DEF_CAMPANIAVENTAS     = 55;
SET   SEC2_DEF_PROMOTOR       = 56;
SET   SEC2_DEF_CONSIGNACION     = 57;
SET   SEC2_DEF_TITULOPERSONA      = 64;
SET   SEC2_PAMCARDNUMBER        = 68;
SET   SEC2_MERCHANTCODE       = 74;
SET   SEC2_FILLER           = 78;


/*  Asignacions de ID de los Campos o columnas de la Seccion 3 que corresponde a Limite de Credito
  De acuerdo a el Layout de Prosa   */

SET   SEC3_CMSUSER          = 1 ;
SET   SEC3_PASSWCMS         = 2 ;
SET   SEC3_CHECKEDAUTORIZA      = 6 ;
SET   SEC3_DEF_SUCURSAUTOR      = 7 ;
SET   SEC3_DEF_PRODUCPROSA      = 8 ;
SET   SEC3_DEF_TIPODOCAUTORI      = 10;
SET   SEC3_DEF_ALTANUMTAR       = 12;
SET   SEC3_MONEDA           = 13;
SET   SEC3_TIPOINCREMENTO       = 18;


/*  Asignacions de ID de los Campos o columnas de la Seccion 4 que corresponde a Direccion
  De acuerdo a el Layout de Prosa   */
SET   SEC4_CMSUSER          =  1 ;
SET   SEC4_PASSWCMS         =  2 ;
SET   SEC4_CHECKEDAUTORIZA      =  6 ;
SET   SEC4_DEF_SUCURSAUTOR      =  7 ;
SET   SEC4_DEF_PRODUCPROSA      =  8 ;
SET   SEC4_DEF_TIPODOCAUTORI      =  10;
SET   SEC4_DEF_ALTANUMTAR       =  12;
SET   SEC4_FILLER           =  31;



/*  Asignacions de ID de los Campos o columnas de la Seccion 5 que corresponde a Job Record
  De acuerdo a el Layout de Prosa   */
SET   SEC5_CMSUSER          = 1 ;
SET   SEC5_PASSWCMS         = 2 ;
SET   SEC5_CHECKEDAUTORIZA      = 6 ;
SET   SEC5_DEF_SUCURSAUTOR      = 7 ;
SET   SEC5_DEF_PRODUCPROSA      = 8 ;
SET   SEC5_DEF_TIPODOCAUTORI      = 10;
SET   SEC5_DEF_ALTANUMTAR       = 12;
SET   SEC5_LINEANEGOCIO       = 18;
SET   SEC5_COMPANIA_CGC       = 19;


/*  Asignacions de ID de los Campos o columnas de la Seccion 6 que corresponde a CBS Accound Record
  De acuerdo a el Layout de Prosa   */
SET   SEC6_CMSUSER          = 1;
SET   SEC6_PASSWCMS         = 2;
SET   SEC6_CHECKEDAUTORIZA      = 6;
SET   SEC6_DEF_SUCURSAUTOR      = 7;
SET   SEC6_DEF_PRODUCPROSA      = 8;
SET   SEC6_DEF_TIPODOCAUTORI      = 10;
SET   SEC6_DEF_ALTANUMTAR       = 12;


/*  Asignacions de ID de los Campos o columnas de la Seccion 7 que corresponde a Daily, Weekly, and Monthly Credit Limit
  De acuerdo a el Layout de Prosa   */
SET   SEC7_CMSUSER        = 1 ;
SET   SEC7_PASSWCMS       = 2 ;
SET   SEC7_CHECKEDAUTORIZA    = 6 ;
SET   SEC7_DEF_SUCURSAUTOR    = 7 ;
SET   SEC7_DEF_PRODUCPROSA    = 8 ;
SET   SEC7_DEF_TIPODOCAUTORI    = 10;
SET   SEC7_DEF_ALTANUMTAR     = 12;
SET   SEC7_FILLER         = 26;



/*  Asignacions de ID de los Campos o columnas de la Seccion 8 que corresponde a CBS Account Association Record
  De acuerdo a el Layout de Prosa   */
SET   SEC8_CMSUSER          = 1 ;
SET   SEC8_PASSWCMS         = 2 ;
SET   SEC8_CHECKEDAUTORIZA      = 6 ;
SET   SEC8_DEF_SUCURSAUTOR      = 7 ;
SET   SEC8_DEF_PRODUCPROSA      = 8 ;
SET   SEC8_DEF_TIPODOCAUTORI      = 10;
SET   SEC8_DEF_ALTANUMTAR       = 12;


/*  Asignacions de ID de los Campos o columnas de la Seccion 9 que corresponde a Trailer Record
  De acuerdo a el Layout de Prosa   */
SET   SEC9_HEADERRECORD       = 1 ;
SET   SEC9_APPLICATIONCOMMING     = 2 ;
SET   SEC9_CHECKEDAUTORIZA      = 3 ;
SET   SEC9_TIPOFILE         = 4 ;
SET   SEC9_PERIODICIDAD       = 5 ;
SET   SEC9_EXTENCION          = 7 ;
SET   SEC9_CMSUSER          = 9 ;
SET   SEC9_PASSWCMS         = 10;
SET   SEC9_SENDERIDENTIFICATION   = 12;


OPEN Cue_ParametrosISS;
    BEGIN
      DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP
          FETCH Cue_ParametrosISS
            INTO Val_IssSeccion, Val_IssCampoID,  Val_IssAltaLot;
          BEGIN
            IF Val_IssSeccion = SEC_HEADER
            THEN

              SET Val_SEC1HEADER        = LEFT(CONCAT(CASE WHEN Val_IssCampoID = SEC1_HEADER    THEN Val_IssAltaLot ELSE Val_SEC1HEADER END, SPACE(7)),7);
              SET Val_SEC1APPCOMING     = CASE WHEN Val_IssCampoID = SEC1_APPCOMING         THEN Val_IssAltaLot ELSE Val_SEC1APPCOMING END;
              SET Val_SEC1CONFAUTORIZADOR     = CASE WHEN Val_IssCampoID = SEC1_CONFAUTORIZADOR   THEN Val_IssAltaLot ELSE Val_SEC1CONFAUTORIZADOR END;
              SET Val_SEC1TIPOFILE      = CASE WHEN Val_IssCampoID = SEC1_TIPOFILE        THEN Val_IssAltaLot ELSE Val_SEC1TIPOFILE END;


              SET Val_SEC1PERIODICIDAD    = CASE WHEN Val_IssCampoID = SEC1_PERIODICIDAD      THEN Val_IssAltaLot ELSE Val_SEC1PERIODICIDAD END;
              SET Val_SEC1EXTENCION     = LEFT(CONCAT(CASE WHEN Val_IssCampoID = SEC1_EXTENCION THEN Val_IssAltaLot ELSE Val_SEC1EXTENCION END, SPACE(4)),4);
              SET Val_SEC1USUARIO       = LEFT(CONCAT(CASE WHEN Val_IssCampoID = SEC1_USUARIO THEN Val_IssAltaLot ELSE Val_SEC1USUARIO END, SPACE(8)),8);
              SET Val_SEC1PASSWORD      = CASE WHEN Val_IssCampoID = SEC1_PASSWORD        THEN Val_IssAltaLot ELSE Val_SEC1PASSWORD END;
              SET Val_SEC1IDENTIFICACION    = CASE WHEN Val_IssCampoID = SEC1_IDENTIFICACION    THEN Val_IssAltaLot ELSE Val_SEC1IDENTIFICACION END;

                        END IF;

                        IF Val_IssSeccion = SEC_REGISTROTARJETA
                        THEN
              SET Val_SEC2CMSUSER         = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_CMSUSER      THEN  Val_IssAltaLot  ELSE  Val_SEC2CMSUSER         END, SPACE(16)),16);
              SET Val_SEC2PASSWCMS        = CASE WHEN  Val_IssCampoID =   SEC2_PASSWCMS           THEN  Val_IssAltaLot  ELSE  Val_SEC2PASSWCMS        END;
              SET Val_SEC2CHECKEDAUTORIZA     = CASE WHEN  Val_IssCampoID =   SEC2_CHECKEDAUTORIZA        THEN  Val_IssAltaLot  ELSE  Val_SEC2CHECKEDAUTORIZA     END;
              SET Val_SEC2DEF_SUCURSAUTOR     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_SUCURSAUTOR        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_SUCURSAUTOR     END;
              SET Val_SEC2DEF_PRODUCPROSA     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_PRODUCPROSA        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_PRODUCPROSA     END;
              SET Val_SEC2DEF_TIPODOCAUTORI   = CASE WHEN  Val_IssCampoID =   SEC2_DEF_TIPODOCAUTORI        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_TIPODOCAUTORI   END;
              SET Val_SEC2DEF_ALTANUMTAR      = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_DEF_ALTANUMTAR   THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_ALTANUMTAR      END, SPACE(19)),19);
              SET Val_SEC2DEF_ALTAPRIMARYCARD   = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_DEF_ALTAPRIMARYCARD THEN Val_IssAltaLot  ELSE  Val_SEC2DEF_ALTAPRIMARYCARD   END, SPACE(19)),19);
              SET Val_SEC2DEF_GRUPOENALTATAR    = CASE WHEN  Val_IssCampoID =   SEC2_DEF_GRUPOENALTATAR       THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_GRUPOENALTATAR    END;
              SET Val_SEC2DEF_TIPOTARJETA     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_TIPOTARJETA        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_TIPOTARJETA     END;
              SET Val_SEC2DEF_COSTOCODE     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_COSTOCODE          THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_COSTOCODE     END;
              SET Val_SEC2MESESVIGENCIA     = CASE WHEN  Val_IssCampoID =   SEC2_MESESVIGENCIA          THEN  Val_IssAltaLot  ELSE  Val_SEC2MESESVIGENCIA     END;
              SET Val_SEC2DEF_CLIENTEVIP      = CASE WHEN  Val_IssCampoID =   SEC2_DEF_CLIENTEVIP         THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_CLIENTEVIP      END;
              SET Val_SEC2NOMBRETARJETA     = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_NOMBRETARJETA    THEN  Val_IssAltaLot  ELSE  Val_SEC2NOMBRETARJETA     END, SPACE(27)),27);
              SET Val_SEC2DEF_EMBOSSING     = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_DEF_EMBOSSING    THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_EMBOSSING     END, SPACE(25)),25);
              SET Val_SEC2PIN_PCI         = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_PIN_PCI      THEN  Val_IssAltaLot  ELSE  Val_SEC2PIN_PCI         END, SPACE(16)),16);
              SET Val_SEC2TRACK1_PCI        = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_TRACK1_PCI     THEN  Val_IssAltaLot  ELSE  Val_SEC2TRACK1_PCI        END, SPACE(79)),79);
              SET Val_SEC2TRACK2_PCI        = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_TRACK2_PCI     THEN  Val_IssAltaLot  ELSE  Val_SEC2TRACK2_PCI        END, SPACE(40)),40);
              SET Val_SEC2PASSTELEFONO      = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_PASSTELEFONO   THEN  Val_IssAltaLot  ELSE  Val_SEC2PASSTELEFONO      END, SPACE(16)),16);
              SET Val_SEC2VIGENCIAPASSTEL     = CASE WHEN  Val_IssCampoID =   SEC2_VIGENCIAPASSTEL        THEN  Val_IssAltaLot  ELSE  Val_SEC2VIGENCIAPASSTEL     END;
              SET Val_SEC2DEF_CORREOVACIO     = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_DEF_CORREOVACIO  THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_CORREOVACIO       END, SPACE(16)),16);
              SET Val_SEC2DEF_ADONDEEVIATARJETA = CASE WHEN  Val_IssCampoID =   SEC2_DEF_ADONDEEVIATARJETA      THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_ADONDEEVIATARJETA END;
              SET Val_SEC2DEF_COMPENVIAPLASTICO = CASE WHEN  Val_IssCampoID =   SEC2_DEF_COMPENVIAPLASTICO      THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_COMPENVIAPLASTICO END;
              SET Val_SEC2DEF_EMBOSADORA      = CASE WHEN  Val_IssCampoID =   SEC2_DEF_EMBOSADORA         THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_EMBOSADORA      END;
              SET Val_SEC2DEF_EXPIRACODE      = CASE WHEN  Val_IssCampoID =   SEC2_DEF_EXPIRACODE         THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_EXPIRACODE      END;
              SET Val_SEC2DEF_FECHACUMPLE     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_FECHACUMPLE        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_FECHACUMPLE       END;
              SET Val_SEC2DEF_LUGARNACIMIENTO   = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_DEF_LUGARNACIMIENTO THEN Val_IssAltaLot  ELSE  Val_SEC2DEF_LUGARNACIMIENTO     END,SPACE(25)),25);
              SET Val_SEC2DEF_NACIONALIDAD    = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_DEF_NACIONALIDAD THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_NACIONALIDAD    END,SPACE(25)),25);
              SET Val_SEC2DEF_GENEROPERSONA   = CASE WHEN  Val_IssCampoID =   SEC2_DEF_GENEROPERSONA        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_GENEROPERSONA   END;
              SET Val_SEC2DEF_ESTADOCIVIL     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_ESTADOCIVIL        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_ESTADOCIVIL       END;
              SET Val_SEC2DEF_OCUPACION     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_OCUPACION          THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_OCUPACION     END;
              SET Val_SEC2DEF_GIRONEGOCIO     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_GIRONEGOCIO        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_GIRONEGOCIO       END;
              SET Val_SEC2DEF_CANTEMPLEADOS   = CASE WHEN  Val_IssCampoID =   SEC2_DEF_CANTEMPLEADOS        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_CANTEMPLEADOS   END;
              SET Val_SEC2DEF_RFC         = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_DEF_RFC      THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_RFC           END,SPACE(15)),15);
              SET Val_SEC2ORGANIZACION      = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_ORGANIZACION   THEN  Val_IssAltaLot  ELSE  Val_SEC2ORGANIZACION      END,SPACE(10)),10);
              SET Val_SEC2DEF_ESTADOREPUBLICA   = CASE WHEN  Val_IssCampoID =   SEC2_DEF_ESTADOREPUBLICA      THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_ESTADOREPUBLICA     END;
              SET Val_SEC2DEF_OVERLIMIT     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_OVERLIMIT          THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_OVERLIMIT     END;
              SET Val_SEC2DEF_LINEGROUPREF    = CASE WHEN  Val_IssCampoID =   SEC2_DEF_LINEGROUPREF       THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_LINEGROUPREF    END;
              SET Val_SEC2DEF_TIPOMONEDA      = CASE WHEN  Val_IssCampoID =   SEC2_DEF_TIPOMONEDA         THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_TIPOMONEDA      END;
              SET Val_SEC2DEF_PASSWCUECLI     = CASE WHEN  Val_IssCampoID =   SEC2_DEF_PASSWCUECLI        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_PASSWCUECLI     END;
              SET Val_SEC2DEF_LENGUAJEOPERA   = CASE WHEN  Val_IssCampoID =   SEC2_DEF_LENGUAJEOPERA        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_LENGUAJEOPERA   END;
              SET Val_SEC2DEF_NIVELACCESOTAR    = LEFT(CONCAT(CASE WHEN  Val_IssCampoID =   SEC2_DEF_NIVELACCESOTAR THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_NIVELACCESOTAR    END,SPACE(127)),1127);
              SET Val_SEC2DEF_CODIGOCANALESVENT = CASE WHEN  Val_IssCampoID =   SEC2_DEF_CODIGOCANALESVENT      THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_CODIGOCANALESVENT END;
              SET Val_SEC2DEF_CAMPANIAVENTAS    = CASE WHEN  Val_IssCampoID =   SEC2_DEF_CAMPANIAVENTAS       THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_CAMPANIAVENTAS    END;
              SET Val_SEC2DEF_PROMOTOR      = CASE WHEN  Val_IssCampoID =   SEC2_DEF_PROMOTOR         THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_PROMOTOR      END;
              SET Val_SEC2DEF_CONSIGNACION    = CASE WHEN  Val_IssCampoID =   SEC2_DEF_CONSIGNACION       THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_CONSIGNACION    END;
              SET Val_SEC2DEF_TITULOPERSONA   = CASE WHEN  Val_IssCampoID =   SEC2_DEF_TITULOPERSONA        THEN  Val_IssAltaLot  ELSE  Val_SEC2DEF_TITULOPERSONA   END;
              SET Val_SEC2PAMCARDNUMBER     = CASE WHEN  Val_IssCampoID =   SEC2_PAMCARDNUMBER          THEN  Val_IssAltaLot  ELSE  Val_SEC2PAMCARDNUMBER     END;
              SET Val_SEC2MERCHANTCODE      = CASE WHEN  Val_IssCampoID =   SEC2_MERCHANTCODE         THEN  Val_IssAltaLot  ELSE  Val_SEC2MERCHANTCODE      END;
              SET Val_SEC2FILLER            = CASE WHEN  Val_IssCampoID =   SEC2_FILLER             THEN  Val_IssAltaLot  ELSE  Val_SEC2FILLER            END;
            END IF;

                        IF Val_IssSeccion = SEC_LIMITCREDITO
                        THEN
              SET Val_SEC3CMSUSER       = LEFT(CONCAT(CASE WHEN Val_IssCampoID = SEC3_CMSUSER   THEN Val_IssAltaLot ELSE  Val_SEC3CMSUSER       END,SPACE(16)),16);
              SET Val_SEC3PASSWCMS      = CASE WHEN Val_IssCampoID = SEC3_PASSWCMS        THEN Val_IssAltaLot ELSE  Val_SEC3PASSWCMS      END;
              SET Val_SEC3CHECKEDAUTORIZA   = CASE WHEN Val_IssCampoID = SEC3_CHECKEDAUTORIZA     THEN Val_IssAltaLot ELSE  Val_SEC3CHECKEDAUTORIZA   END;
              SET Val_SEC3DEF_SUCURSAUTOR   = CASE WHEN Val_IssCampoID = SEC3_DEF_SUCURSAUTOR     THEN Val_IssAltaLot ELSE  Val_SEC3DEF_SUCURSAUTOR   END;
              SET Val_SEC3DEF_PRODUCPROSA   = CASE WHEN Val_IssCampoID = SEC3_DEF_PRODUCPROSA     THEN Val_IssAltaLot ELSE  Val_SEC3DEF_PRODUCPROSA   END;
              SET Val_SEC3DEF_TIPODOCAUTORI = CASE WHEN Val_IssCampoID = SEC3_DEF_TIPODOCAUTORI   THEN Val_IssAltaLot ELSE  Val_SEC3DEF_TIPODOCAUTORI END;
              SET Val_SEC3DEF_ALTANUMTAR    = CASE WHEN Val_IssCampoID = SEC3_DEF_ALTANUMTAR      THEN Val_IssAltaLot ELSE  Val_SEC3DEF_ALTANUMTAR    END;
              SET Val_SEC3MONEDA        = CASE WHEN Val_IssCampoID = SEC3_MONEDA          THEN Val_IssAltaLot ELSE  Val_SEC3MONEDA        END;
              SET Val_SEC3TIPOINCREMENTO      = CASE WHEN Val_IssCampoID = SEC3_TIPOINCREMENTO      THEN Val_IssAltaLot ELSE  Val_SEC3TIPOINCREMENTO      END;
                        END IF;

                        IF Val_IssSeccion = SEC_DIRECCION
                        THEN
              SET Val_SEC4CMSUSER       = LEFT(CONCAT(CASE WHEN Val_IssCampoID =  SEC4_CMSUSER  THEN Val_IssAltaLot ELSE  Val_SEC4CMSUSER       END,SPACE(16)),16);
              SET Val_SEC4PASSWCMS      = CASE WHEN Val_IssCampoID =  SEC4_PASSWCMS       THEN Val_IssAltaLot ELSE  Val_SEC4PASSWCMS      END;
              SET Val_SEC4CHECKEDAUTORIZA   = CASE WHEN Val_IssCampoID =  SEC4_CHECKEDAUTORIZA    THEN Val_IssAltaLot ELSE  Val_SEC4CHECKEDAUTORIZA   END;
              SET Val_SEC4DEF_SUCURSAUTOR   = CASE WHEN Val_IssCampoID =  SEC4_DEF_SUCURSAUTOR    THEN Val_IssAltaLot ELSE  Val_SEC4DEF_SUCURSAUTOR   END;
              SET Val_SEC4DEF_PRODUCPROSA   = CASE WHEN Val_IssCampoID =  SEC4_DEF_PRODUCPROSA    THEN Val_IssAltaLot ELSE  Val_SEC4DEF_PRODUCPROSA   END;
              SET Val_SEC4DEF_TIPODOCAUTORI = CASE WHEN Val_IssCampoID =  SEC4_DEF_TIPODOCAUTORI    THEN Val_IssAltaLot ELSE  Val_SEC4DEF_TIPODOCAUTORI END;
              SET Val_SEC4DEF_ALTANUMTAR    = CASE WHEN Val_IssCampoID =  SEC4_DEF_ALTANUMTAR     THEN Val_IssAltaLot ELSE  Val_SEC4DEF_ALTANUMTAR    END;
              SET Val_SEC4FILLER        = LEFT(CONCAT(CASE WHEN Val_IssCampoID =  SEC4_FILLER         THEN Val_IssAltaLot ELSE  Val_SEC4FILLER        END, SPACE(48)),48);
                        END IF;

                        IF  Val_IssSeccion = SEC_JOBRECORD
                        THEN
              SET   Val_SEC5CMSUSER       = LEFT(CONCAT(CASE WHEN Val_IssCampoID  = SEC5_CMSUSER  THEN  Val_IssAltaLot    ELSE  Val_SEC5CMSUSER       END, SPACE(16)),16);
              SET   Val_SEC5PASSWCMS      = CASE WHEN Val_IssCampoID  = SEC5_PASSWCMS       THEN  Val_IssAltaLot    ELSE  Val_SEC5PASSWCMS      END;
              SET   Val_SEC5CHECKEDAUTORIZA   = CASE WHEN Val_IssCampoID  = SEC5_CHECKEDAUTORIZA    THEN  Val_IssAltaLot    ELSE  Val_SEC5CHECKEDAUTORIZA   END;
              SET   Val_SEC5DEF_SUCURSAUTOR   = CASE WHEN Val_IssCampoID  = SEC5_DEF_SUCURSAUTOR    THEN  Val_IssAltaLot    ELSE  Val_SEC5DEF_SUCURSAUTOR   END;
              SET   Val_SEC5DEF_PRODUCPROSA   = CASE WHEN Val_IssCampoID  = SEC5_DEF_PRODUCPROSA    THEN  Val_IssAltaLot    ELSE  Val_SEC5DEF_PRODUCPROSA   END;
              SET   Val_SEC5DEF_TIPODOCAUTORI = CASE WHEN Val_IssCampoID  = SEC5_DEF_TIPODOCAUTORI    THEN  Val_IssAltaLot    ELSE  Val_SEC5DEF_TIPODOCAUTORI END;
              SET   Val_SEC5DEF_ALTANUMTAR    = CASE WHEN Val_IssCampoID  = SEC5_DEF_ALTANUMTAR     THEN  Val_IssAltaLot    ELSE  Val_SEC5DEF_ALTANUMTAR    END;
              SET   Val_SEC5LINEANEGOCIO    = CASE WHEN Val_IssCampoID  = SEC5_LINEANEGOCIO     THEN  Val_IssAltaLot    ELSE  Val_SEC5LINEANEGOCIO    END;
              SET   Val_SEC5COMPANIA_CGC    = CASE WHEN Val_IssCampoID  = SEC5_COMPANIA_CGC     THEN  Val_IssAltaLot    ELSE  Val_SEC5COMPANIA_CGC    END;
            END IF;

            IF Val_IssSeccion = SEC_CBSACCOUND
                        THEN
              SET   Val_SEC6CMSUSER       = LEFT(CONCAT(CASE WHEN Val_IssCampoID  = SEC6_CMSUSER  THEN  Val_IssAltaLot    ELSE  Val_SEC6CMSUSER       END, SPACE(16)),16);
              SET   Val_SEC6PASSWCMS      = CASE WHEN Val_IssCampoID  = SEC6_PASSWCMS       THEN  Val_IssAltaLot    ELSE  Val_SEC6PASSWCMS      END;
              SET   Val_SEC6CHECKEDAUTORIZA   = CASE WHEN Val_IssCampoID  = SEC6_CHECKEDAUTORIZA    THEN  Val_IssAltaLot    ELSE  Val_SEC6CHECKEDAUTORIZA   END;
              SET   Val_SEC6DEF_SUCURSAUTOR   = CASE WHEN Val_IssCampoID  = SEC6_DEF_SUCURSAUTOR    THEN  Val_IssAltaLot    ELSE  Val_SEC6DEF_SUCURSAUTOR   END;
              SET   Val_SEC6DEF_PRODUCPROSA   = CASE WHEN Val_IssCampoID  = SEC6_DEF_PRODUCPROSA    THEN  Val_IssAltaLot    ELSE  Val_SEC6DEF_PRODUCPROSA   END;
              SET   Val_SEC6DEF_TIPODOCAUTORI = CASE WHEN Val_IssCampoID  = SEC6_DEF_TIPODOCAUTORI    THEN  Val_IssAltaLot    ELSE  Val_SEC6DEF_TIPODOCAUTORI END;
              SET   Val_SEC6DEF_ALTANUMTAR    = CASE WHEN Val_IssCampoID  = SEC6_DEF_ALTANUMTAR     THEN  Val_IssAltaLot    ELSE  Val_SEC6DEF_ALTANUMTAR    END;
                        END IF;

                        IF Val_IssSeccion = SEC_LIMITCREDITODSM
                        THEN
              SET   Val_SEC7CMSUSER       = LEFT(CONCAT(CASE WHEN Val_IssCampoID  = SEC7_CMSUSER  THEN  Val_IssAltaLot    ELSE  Val_SEC7CMSUSER       END, SPACE(16)),16);
              SET   Val_SEC7PASSWCMS      = CASE WHEN Val_IssCampoID  = SEC7_PASSWCMS       THEN  Val_IssAltaLot    ELSE  Val_SEC7PASSWCMS      END;
              SET   Val_SEC7CHECKEDAUTORIZA   = CASE WHEN Val_IssCampoID  = SEC7_CHECKEDAUTORIZA    THEN  Val_IssAltaLot    ELSE  Val_SEC7CHECKEDAUTORIZA   END;
              SET   Val_SEC7DEF_SUCURSAUTOR   = CASE WHEN Val_IssCampoID  = SEC7_DEF_SUCURSAUTOR    THEN  Val_IssAltaLot    ELSE  Val_SEC7DEF_SUCURSAUTOR   END;
              SET   Val_SEC7DEF_PRODUCPROSA   = CASE WHEN Val_IssCampoID  = SEC7_DEF_PRODUCPROSA    THEN  Val_IssAltaLot    ELSE  Val_SEC7DEF_PRODUCPROSA   END;
              SET   Val_SEC7DEF_TIPODOCAUTORI = CASE WHEN Val_IssCampoID  = SEC7_DEF_TIPODOCAUTORI    THEN  Val_IssAltaLot    ELSE  Val_SEC7DEF_TIPODOCAUTORI END;
              SET   Val_SEC7DEF_ALTANUMTAR    = CASE WHEN Val_IssCampoID  = SEC7_DEF_ALTANUMTAR     THEN  Val_IssAltaLot    ELSE  Val_SEC7DEF_ALTANUMTAR    END;
              SET   Val_SEC7FILLER        = LEFT(CONCAT(CASE WHEN Val_IssCampoID  = SEC7_FILLER   THEN  Val_IssAltaLot    ELSE  Val_SEC7FILLER        END, SPACE(50)),50);
            END IF;

            IF Val_IssSeccion = SEC_CBSASSOCIATION
                        THEN
              SET   Val_SEC8CMSUSER       = LEFT(CONCAT(CASE WHEN Val_IssCampoID  = SEC8_CMSUSER  THEN  Val_IssAltaLot    ELSE  Val_SEC8CMSUSER       END, SPACE(16)),16);
              SET   Val_SEC8PASSWCMS      = CASE WHEN Val_IssCampoID  = SEC8_PASSWCMS       THEN  Val_IssAltaLot    ELSE  Val_SEC8PASSWCMS      END;
              SET   Val_SEC8CHECKEDAUTORIZA   = CASE WHEN Val_IssCampoID  = SEC8_CHECKEDAUTORIZA    THEN  Val_IssAltaLot    ELSE  Val_SEC8CHECKEDAUTORIZA   END;
              SET   Val_SEC8DEF_SUCURSAUTOR   = CASE WHEN Val_IssCampoID  = SEC8_DEF_SUCURSAUTOR    THEN  Val_IssAltaLot    ELSE  Val_SEC8DEF_SUCURSAUTOR   END;
              SET   Val_SEC8DEF_PRODUCPROSA   = CASE WHEN Val_IssCampoID  = SEC8_DEF_PRODUCPROSA    THEN  Val_IssAltaLot    ELSE  Val_SEC8DEF_PRODUCPROSA   END;
              SET   Val_SEC8DEF_TIPODOCAUTORI = CASE WHEN Val_IssCampoID  = SEC8_DEF_TIPODOCAUTORI    THEN  Val_IssAltaLot    ELSE  Val_SEC8DEF_TIPODOCAUTORI END;
              SET   Val_SEC8DEF_ALTANUMTAR    = CASE WHEN Val_IssCampoID  = SEC8_DEF_ALTANUMTAR     THEN  Val_IssAltaLot    ELSE  Val_SEC8DEF_ALTANUMTAR    END;
            END IF;

            IF Val_IssSeccion = SEC_TRAILERRECORD
            THEN
              SET Val_SEC9HEADERRECORD      =   CASE WHEN Val_IssCampoID =  SEC9_HEADERRECORD       THEN  Val_IssAltaLot    ELSE  Val_SEC9HEADERRECORD        END;
              SET Val_SEC9APPLICATIONCOMMING    =   CASE WHEN Val_IssCampoID =  SEC9_APPLICATIONCOMMING     THEN  Val_IssAltaLot    ELSE  Val_SEC9APPLICATIONCOMMING      END;
              SET Val_SEC9CHECKEDAUTORIZA     =   CASE WHEN Val_IssCampoID =  SEC9_CHECKEDAUTORIZA      THEN  Val_IssAltaLot    ELSE  Val_SEC9CHECKEDAUTORIZA       END;
              SET Val_SEC9TIPOFILE        =   CASE WHEN Val_IssCampoID =  SEC9_TIPOFILE         THEN  Val_IssAltaLot    ELSE  Val_SEC9TIPOFILE          END;
              SET Val_SEC9PERIODICIDAD      =   CASE WHEN Val_IssCampoID =  SEC9_PERIODICIDAD       THEN  Val_IssAltaLot    ELSE  Val_SEC9PERIODICIDAD        END;
              SET Val_SEC9EXTENCION       =   LEFT(CONCAT(CASE WHEN Val_IssCampoID =  SEC9_EXTENCION    THEN  Val_IssAltaLot    ELSE  Val_SEC9EXTENCION         END, SPACE(4)),4);
              SET Val_SEC9CMSUSER         =   CASE WHEN Val_IssCampoID =  SEC9_CMSUSER          THEN  Val_IssAltaLot    ELSE  Val_SEC9CMSUSER           END;
              SET Val_SEC9PASSWCMS        =   CASE WHEN Val_IssCampoID =  SEC9_PASSWCMS         THEN  Val_IssAltaLot    ELSE  Val_SEC9PASSWCMS          END;
              SET Val_SEC9SENDERIDENTIFICATION  =   CASE WHEN Val_IssCampoID =  SEC9_SENDERIDENTIFICATION   THEN  Val_IssAltaLot    ELSE  Val_SEC9SENDERIDENTIFICATION    END;
            END IF;

          END;
        END LOOP;
    END;
    CLOSE Cue_ParametrosISS;

SET FillerSec2      = SPACE(1008);
SET TotalRegistros    = '000000000';
SET RegistroID      = '0000000';
SET DataGroup     = '999999999';-- No se como se obtiene por lo que de momento se le indica el valor de default indicado en el layout
SET MesageCodeAltaS2  = '0001';     -- No se como se obtiene por lo que de momento se le indica el valor de default indicado en el layout
SET CBS_BankID      = SPACE(30);  -- Si se va a especificar algun valor no se de donde obtenerlo
SET Num_TipoDoc     = SPACE(15);
SET CodigoRefe      = SPACE(15);    -- corresponde a la columna 17  Proposal Reference(Codigo de referencias)
SET NombreTarjeta   = CONCAT('SIN DATOS', SPACE(61));  -- en el alta por default es "SIN DATOS" el nombre se indica al asignar la tarjeta
SET BacnkAccount    =  SPACE(30);
SET ConsignaEntrega   = 'N';   --  Valor indicado como Default
SET NombrePadre     = SPACE(40);   -- Valor indicado por default como espacios
SET NombreMadre     = SPACE(40);
SET NomCardHolder   = CONCAT('SINNOMBRE',SPACE(51));
SET ApeCardHolder   = CONCAT('SIN DATOS DE LA PERSONA',SPACE(37));
SET ServDefault     = '0' ;         -- El valor default
SET LlevaFoto     = '0';
SET NivelRelacion   = '0';
SET CardCarrier     = '00';
SET CardHolderType    = '0';      --   Por default el tipo es Titular
SET DriverType      = '0';    --   Aplica para las tarjetas de Gasolina, si es un vale de gasolina el valor es  1 , si corresponde a una tarjeta de flotilla el valor es 2. Para el resto el valor es 0.
SET Via         = '00';
SET LoanAllowed     = '0';
SET Bonificacion    = '00000';    --  Valor defaul
SET IndicadorEspecial = '0';
SET CodigoEspecial    = '00';
SET MesageCodeAltaS3  = '0004';   -- Valor default para la seccion 3 indicado en el layout para el Alta
SET SalarioCardHolder = '000000000000000000';
SET TipoAsigaLimCred  = '0';      -- 0 - Assigned by bank   1- Assigned by salary.
SET MesageCodeAltaS4  = '0003';   -- Valor default para la seccion 4 indicado en el layout para el Alta
SET MesageCodeAltaS5  = '0009';   -- Valor default para la seccion 5 indicado en el layout para el Alta
SET MesageCodeAltaS6  = '0106';   -- Indica que depend;e el valor de lo que se dese realizar pero no indica como se determina Message CodeIs a code of operation The options are 0106 / 0206 / 0306   Depend;e de la operacion a realizar
SET NombreCortoProsa  = 'BANCOFDB ';   -- Valor de nombre corto proporcionado por prosa
SET Agencia       = '000000001';   -- Valor por default indicado en layout
SET CBSCuenta     = BacnkAccount;  --  si es diferente es indica el valor
SET CBSMoneda     = '484';      -- Codigo de Moneda de la CBS. El valor default para Mexico es 484
SET ExtraInfo     = REPEAT('0',80);   --  Extra information Datos adicionales de la cuenta , si no se tiene valor se llena de  0
SET OverDraft     = REPEAT('0', 18);
SET CBSTipoCuenta   = '00';         --  Se indica el valor que se especifica como default en el layout
SET MesageCodeAltaS7  = '0108';       -- Message Code Is a code of operation The options are 0108 / 0208
SET MesageCodeAltaS8  = '0110';       --  Message Code Is a code of operation The options are 0110
SET CuentaDefault   = '0';        -- IS Default   1 – Default Account    0 – NOT Default Account

-- Se obtiene el Limite de Credito
SET Iss_LimCred     = IFNULL(Iss_LimCred, 1);
SET LimiteCredito   = CONCAT(RIGHT(CONCAT('00000000000000',CAST(CAST(Iss_LimCred AS DECIMAL(14)) AS CHAR(14))), 14),'0000');

-- De momento se le asigna el mismo que el limite  ya que no se de donde obtener este valor
SET MontoMaxAsignado  = LimiteCredito;

/*
    ==  Espacio para obtener la direccion de momento se indican los valores por default  ==

*/
SET TipoDireccion     = TipoDirLlegaTar;
SET   Dir_Calle     = SPACE(60);
SET   Dir_NumeroExt   = '00000';
SET   Dir_Colonia     = SPACE(50);
SET   Dir_Complemento   = SPACE(30);
SET   Dir_Ciudad      = SPACE(50);
SET   EstadoRepu      = '0031';   -- Valor corresponde a Yucatan de acuerdo a catalogo de Prosa
SET   Dir_CodidoPos   = '0000000000'; -- El valor por defaul indicado en layout es 0 no se especifica cuando se tenga un valor si se rellena con cero o con espacios ya que en mexico el codigo postal es de 5 posiciones

/*
    ==  Espacio para obtener la direccion de momento se indican los valores por default  ==

*/
SET TelFijo     = SPACE(20);
SET TelFax      = SPACE(20);
SET TelCelular    = SPACE(20);
SET CorreoEelc    = SPACE(128);
SET FecDesde    = '00000000';
SET FecHasta    = '00000000';
SET NumInterno    = SPACE(10);
SET TiempoVivirDir  = '00000000';   -- Period of residence Period of time the cardholder lives in the specified address. (format YYYYMMDD) Same as date from."  Se coloca el dato en caso de tenerlo, para el resto son 00000000
SET EntregaTipoDir  = '00';


SET EntregaTipoDir    = CASE WHEN TipoDireccion = TipoDirLlegaEdoCta  THEN  '02' ELSE '00'  END;  -- Si el Tipo es 1 se indica 02 o 03 cualquier cosa diferente se indica 00  especificado en layout

/*
    ==  Espacio para obtener los datos de trabajo de momento se indican los valores por default  ==

*/
SET NombreEmpresa = SPACE(64);
SET PuestoTrabajo = SPACE(64);
SET Salario     = '000000000000000000';

/*
    ==  Espacio para obtener los datos de ingresos de momento se indican los valores por default  ==

*/
SET SucursalDeCompania  = SPACE(30);
SET Departamento    = SPACE(30);
SET AreaCompania    = SPACE(30);
SET NumEmpleados    = SPACE(12);
SET CorreoTrabajo   = SPACE(128);
SET TipoContrato    = SPACE(1);
SET TipoIngresos    = SPACE(1);
SET OtrosIngresos   = '000000000000000000';
SET Titular       = SPACE(1);

/*
    ==  Espacio para obtener los Limites transaccionales Diarios, Semana y Mes de cada tarjeta

*/

SET MonMaxRetDiaPOS = '099999999999999999';
SET   MonMaxRetDiaATM = '099999999999999999';
SET   MonMaxRetSemPOS = '099999999999999999';
SET   MonMaxRetSemATM = '099999999999999999';
SET   MonMaxRetMesPOS = '099999999999999999';
SET   MonMaxRetMesATM = '099999999999999999';
SET   NumMaxTraDiaPOS = '099999999';
SET   NumMaxTraDiaATM = '099999999';
SET   NumMaxTraSemPOS = '099999999';
SET   NumMaxTraSemATM = '099999999';
SET   NumMaxTraMesPOS = '099999999';
SET   NumMaxTraMesATM = '099999999';
SET   MontoMaxDevol = '099999999999999999';


SET FolioArchivo  = (SELECT IFNULL( MAX(Arc_FolioAr) , Ent_Cero) + 1
FROM TCR_ISSARCH_ADM );


  SET FolioString   = RIGHT(CONCAT('000000',FolioArchivo), 6);
  SET FechaAct    = NOW();

  SET FechaHoraCrea = CONCAT(CAST(YEAR(FechaAct) AS CHAR(4)), RIGHT(CONCAT('00', CAST(MONTH(FechaAct) AS CHAR(2))), 2), RIGHT(CONCAT('00',CAST(DAY(FechaAct) AS CHAR(2))), 2)
              ,RIGHT(CONCAT('00', CAST(HOUR(FechaAct) AS CHAR(2))) , 2), RIGHT(CONCAT('00',CAST(MINUTE(FechaAct) AS CHAR(2))), 2));
  -- Se usa para las columnas 15 y 16
  SET FechaGenArch  = CONCAT(CAST(YEAR(FechaAct) AS CHAR(4)), RIGHT(CONCAT('00', CAST(MONTH(FechaAct) AS CHAR(2))), 2), RIGHT(CONCAT('00',CAST(DAY(FechaAct) AS CHAR(2))), 2));

  SET RegistroID    = '0000000';

  SET Num_TipDoc = (SELECT  RIGHT(CONCAT(REPEAT('0',15),IFNULL(MAX(Arc_NumDoc),Ent_Cero)),15)
    FROM TCR_ISSARCH_ADM);

  SET DataGroup   = Ent_Cero;

    -- cuando requiera usarse este sp para tarjeta de credito habra de hacer selec a la tabla correspondiente
    IF  EXISTS  (SELECT LoteDebitoID
    FROM LOTETARJETADEB
      WHERE Estatus = 3)
  THEN
        -- Se inserta la primer seccion (1)  de el Archivo ISS que corresponde a el Header
    INSERT INTO TCR_TCARCISS_ADM  ( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,  Iss_S1Cam1,
                    Iss_S1Cam2,   Iss_S1Cam3,   Iss_S1Cam4,   Iss_S1Cam5,   Iss_S1Cam6,
                    Iss_S1Cam7,   Iss_S1Cam8,   Iss_S1Cam9,   Iss_S1Cam10,  Iss_S1Cam11,
                    Iss_S1Cam12)
    SELECT  FolioArchivo,     NoEnviado,          FechaAct,         SEC_HEADER,     Val_SEC1HEADER,
        Val_SEC1APPCOMING,    Val_SEC1CONFAUTORIZADOR,  Val_SEC1TIPOFILE,     Val_SEC1PERIODICIDAD, FolioString,
        Val_SEC1EXTENCION,    FechaHoraCrea,        Val_SEC1USUARIO,      Val_SEC1PASSWORD,   TotalRegistros,
        Val_SEC1IDENTIFICACION;
       OPEN Cur_SolicitudISS;
    BEGIN
      DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP
          FETCH Cur_SolicitudISS
            INTO Num_Solici,    FechaSolici,   Num_Sucurs,  Iss_CantTarj, Tipo_Tarjeta,
              Vigencia_Meses,   ColorPlastico;
          BEGIN
              SET ContaRegis    = Ent_Cero;

              --  Se insertan la segunda seccion (2) de el archivo ISS que corresponde a Cards and Accounts Record
              --  Se genera la cantidad de registros indicada por el parametro Iss_CantTarj
              -- select DataGroup   = Ent_Cero
              SET Num_TipoDoc = '0';
              SET ExpiraTar   = CONCAT(CAST(YEAR(DATE_ADD(FechaAct,INTERVAL Vigencia_Meses MONTH))AS CHAR(4)),RIGHT(CONCAT('000',CAST(MONTH(DATE_ADD(FechaAct,INTERVAL Vigencia_Meses MONTH))AS CHAR(2))),2));

              SET Num_TipoDoc = RIGHT(CONCAT(REPEAT('0',15),(SELECT MAX(Num_Folio) FROM TCR_FOLIOS_ADM WHERE FolioID= '001')), 15);

                            WHILE ContaRegis < Iss_CantTarj
                            DO
                            UPDATE TCR_FOLIOS_ADM SET
                Num_Folio = Num_TipoDoc + 1
                WHERE FolioID= '001';

                SET ContaRegis    = ContaRegis + 1;
                SET RegistroID    = RIGHT(CONCAT(REPEAT('0',7),CAST(RegistroID AS SIGNED) +  1 ), 7);
                SET ColorTarjeta  = RIGHT(CONCAT('00',CAST( ColorPlastico AS CHAR(2))) , 2);
                SET Num_TipoDoc   = RIGHT(CONCAT(REPEAT('0',15),CAST(Num_TipoDoc AS SIGNED) +  1), 15);
                SET  Val_SEC2MESESVIGENCIA = CAST(Vigencia_Meses AS CHAR(2));
                SET  DataGroup    = RIGHT(CONCAT(REPEAT('0',9),DataGroup  +  1), 9);
                SET BacnkAccount  = RIGHT(CONCAT(REPEAT('0',30), CAST(Num_TipoDoc AS SIGNED)), 30);


                                INSERT INTO TCR_TCARCISS_ADM  ( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,
                                Iss_S2Cam1,   Iss_S2Cam2,   Iss_S2Cam3,   Iss_S2Cam4,   Iss_S2Cam5,
                                Iss_S2Cam6,   Iss_S2Cam7,   Iss_S2Cam8,   Iss_S2Cam9,   Iss_S2Cam10,
                                Iss_S2Cam11,  Iss_S2Cam12,  Iss_S2Cam13,  Iss_S2Cam14,  Iss_S2Cam15,
                                Iss_S2Cam16,  Iss_S2Cam17,  Iss_S2Cam18,  Iss_S2Cam19,  Iss_S2Cam20,
                                Iss_S2Cam21,  Iss_S2Cam22,  Iss_S2Cam23,  Iss_S2Cam24,  Iss_S2Cam25,
                                Iss_S2Cam26,  Iss_S2Cam27,  Iss_S2Cam28,  Iss_S2Cam29,  Iss_S2Cam30,
                                Iss_S2Cam31,  Iss_S2Cam32,  Iss_S2Cam33,  Iss_S2Cam34,  Iss_S2Cam35,
                                Iss_S2Cam36,  Iss_S2Cam37,  Iss_S2Cam38,  Iss_S2Cam39,  Iss_S2Cam40,
                                Iss_S2Cam41,  Iss_S2Cam42,  Iss_S2Cam43,  Iss_S2Cam44,  Iss_S2Cam45,
                                Iss_S2Cam46,  Iss_S2Cam47,  Iss_S2Cam48,  Iss_S2Cam49,  Iss_S2Cam50,
                                Iss_S2Cam51,  Iss_S2Cam52,  Iss_S2Cam53,  Iss_S2Cam54,  Iss_S2Cam55,
                                Iss_S2Cam56,  Iss_S2Cam57,  Iss_S2Cam58,  Iss_S2Cam59,  Iss_S2Cam60,
                                Iss_S2Cam61,  Iss_S2Cam62,  Iss_S2Cam63,  Iss_S2Cam64,  Iss_S2Cam65,
                                Iss_S2Cam66,  Iss_S2Cam67,  Iss_S2Cam68,  Iss_S2Cam69,  Iss_S2Cam70,
                                Iss_S2Cam71,  Iss_S2Cam72,  Iss_S2Cam73,  Iss_S2Cam74,  Iss_S2Cam75,
                                Iss_S2Cam76,  Iss_S2Cam77,  Iss_S2Cam78 , Iss_Orden)

                      SELECT  FolioArchivo,         NoEnviado,            FechaAct,           SEC_REGISTROTARJETA,
                          Val_SEC2CMSUSER,        Val_SEC2PASSWCMS,       RegistroID,           DataGroup,              MesageCodeAltaS2,
                          Val_SEC2CHECKEDAUTORIZA,    Val_SEC2DEF_SUCURSAUTOR,    Val_SEC2DEF_PRODUCPROSA,    CBS_BankID,           Val_SEC2DEF_TIPODOCAUTORI,
                                                    Num_TipoDoc,          Val_SEC2DEF_ALTANUMTAR,     Val_SEC2DEF_ALTAPRIMARYCARD,  Val_SEC2DEF_GRUPOENALTATAR,     FechaGenArch,
                          FechaGenArch,         CodigoRefe,           Tipo_Tarjeta,         Val_SEC2DEF_COSTOCODE,        ExpiraTar,
                          Val_SEC2MESESVIGENCIA,      Val_SEC2DEF_CLIENTEVIP,     Val_SEC2NOMBRETARJETA,      Val_SEC2DEF_EMBOSSING,        Val_SEC2PIN_PCI,
                          Val_SEC2TRACK1_PCI,       Val_SEC2TRACK2_PCI,       Val_SEC2PASSTELEFONO,     Val_SEC2VIGENCIAPASSTEL,      Val_SEC2DEF_CORREOVACIO,
                          Val_SEC2DEF_ADONDEEVIATARJETA,  Val_SEC2DEF_COMPENVIAPLASTICO,  Val_SEC2DEF_EMBOSADORA,     Val_SEC2DEF_EXPIRACODE,       Val_SEC2DEF_FECHACUMPLE,
                          Val_SEC2DEF_LUGARNACIMIENTO,  Val_SEC2DEF_NACIONALIDAD,   Val_SEC2DEF_GENEROPERSONA,    Val_SEC2DEF_ESTADOCIVIL,      NombreTarjeta,
                          Val_SEC2DEF_OCUPACION,      Val_SEC2DEF_GIRONEGOCIO,    Val_SEC2DEF_CANTEMPLEADOS,    Val_SEC2DEF_RFC,          Val_SEC2ORGANIZACION,
                          Val_SEC2DEF_ESTADOREPUBLICA,  Val_SEC2DEF_OVERLIMIT,      Val_SEC2DEF_LINEGROUPREF,   Val_SEC2DEF_TIPOMONEDA,       BacnkAccount,
                          Val_SEC2DEF_PASSWCUECLI,    Val_SEC2DEF_LENGUAJEOPERA,    Val_SEC2DEF_NIVELACCESOTAR,   Val_SEC2DEF_CODIGOCANALESVENT,      Val_SEC2DEF_CAMPANIAVENTAS,
                          Val_SEC2DEF_PROMOTOR,     Val_SEC2DEF_CONSIGNACION,   ConsignaEntrega,        NombrePadre,            NombreMadre,
                          ColorTarjeta,         NomCardHolder,          ApeCardHolder,          Val_SEC2DEF_TITULOPERSONA,      ServDefault,
                          LlevaFoto,            NivelRelacion,          Val_SEC2PAMCARDNUMBER,      CardCarrier,            CardHolderType,
                          DriverType,           Via,              LoanAllowed,          Val_SEC2MERCHANTCODE,       Bonificacion,
                          IndicadorEspecial,        CodigoEspecial,         FillerSec2,           CAST(RegistroID AS SIGNED INTEGER);


          --  Se insertan la tercer seccion (3) de el archivo ISS que corresponde a  Credit Limit
      --  Se genera la cantidad de registros indicada por el parametro Iss_CantTarj lo equivalente a un registro para cada tarjeta

      SET RegistroID  = RIGHT(CONCAT('0000000',CAST(  CAST(RegistroID AS SIGNED) +  1    AS CHAR(7))), 7);


        -- Se inserta la tercer Seccion de el Srchivo ISS que corresponde a Credit Limit
      INSERT INTO TCR_TCARCISS_ADM( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,
                      Iss_S3Cam1,   Iss_S3Cam2,   Iss_S3Cam3,   Iss_S3Cam4,   Iss_S3Cam5,
                      Iss_S3Cam6,   Iss_S3Cam7,   Iss_S3Cam8,   Iss_S3Cam9,   Iss_S3Cam10,
                      Iss_S3Cam11,  Iss_S3Cam12,  Iss_S3Cam13,  Iss_S3Cam14,  Iss_S3Cam15,
                      Iss_S3Cam16,  Iss_S3Cam17,  Iss_S3Cam18,  Iss_Orden )
      SELECT    FolioArchivo,         NoEnviado,            FechaAct,         SEC_LIMITCREDITO,
            Val_SEC3CMSUSER,        Val_SEC3PASSWCMS,       RegistroID,         DataGroup,              MesageCodeAltaS3,
            Val_SEC3CHECKEDAUTORIZA,    Val_SEC3DEF_SUCURSAUTOR,    Val_SEC3DEF_PRODUCPROSA,  CBS_BankID,             Val_SEC3DEF_TIPODOCAUTORI,
            Num_TipoDoc,          Val_SEC3DEF_ALTANUMTAR,     Val_SEC3MONEDA,       LimiteCredito,            SalarioCardHolder,
            TipoAsigaLimCred,       MontoMaxAsignado,       Val_SEC3TIPOINCREMENTO,   CAST(RegistroID AS SIGNED INTEGER);


            --  Se insertan la cuarta seccion (4) de el archivo ISS que corresponde a  Addresses Record
      --  Se genera la cantidad de registros indicada por el parametro Iss_CantTarj lo equivalente a un registro para cada tarjeta
      SET TipoDirLlegaTar = '01';  -- 01 Donde llega el Estado Cuenta

        -- Para la prueba se dejo fijo una sucursal, se requiere ajustar este paso para leer la direccion de cada sucursal que pide tarjetas
      SET Dir_Calle   =  (SELECT LEFT(CONCAT(RTRIM(LTRIM(IFNULL(Calle, ''))),SPACE(60)), 60) FROM SUCURSALES  WHERE  SucursalID = CAST(Num_Sucurs AS SIGNED));
      SET Dir_NumeroExt = (SELECT RIGHT(CONCAT('00000',IFNULL(Numero, '')) , 5) FROM SUCURSALES  WHERE SucursalID = CAST(Num_Sucurs AS SIGNED));
      SET Dir_Colonia   = (SELECT LEFT(CONCAT(LTRIM(RTRIM(IFNULL(Colonia, ''))),SPACE(50)) ,50) FROM SUCURSALES WHERE SucursalID = CAST(Num_Sucurs AS SIGNED));
      SET Dir_Ciudad      = (SELECT LEFT(CONCAT(LTRIM(RTRIM(IFNULL(Mun.Nombre, ''))),SPACE(50)) , 50) FROM SUCURSALES Suc INNER JOIN MUNICIPIOSREPUB Mun ON Suc.EstadoID = Mun.EstadoID AND Suc.MunicipioID= Mun.MunicipioID WHERE SucursalID = CAST(Num_Sucurs AS SIGNED));
            SET EstadoRepu    = (SELECT LEFT(CONCAT(LTRIM(RTRIM(IFNULL(Est.EstadoID, ''))),SPACE(50)) , 50) FROM SUCURSALES Suc INNER JOIN ESTADOSREPUB Est ON Suc.EstadoID = Est.EstadoID WHERE SucursalID = CAST(Num_Sucurs AS SIGNED));
      SET Dir_CodidoPos = (SELECT RIGHT(CONCAT('0000000000',LTRIM(RTRIM(IFNULL(CP, '')))),10) FROM SUCURSALES WHERE SucursalID = CAST(Num_Sucurs AS SIGNED));
      SET TelFijo     = (SELECT LEFT(CONCAT(LTRIM(RTRIM(IFNULL(Telefono, ''))),SPACE(20)), 20) FROM SUCURSALES WHERE SucursalID = CAST(Num_Sucurs AS SIGNED));




      SET RegistroID  = RIGHT(CONCAT('0000000',CAST(  CAST(RegistroID AS SIGNED) +  1    AS CHAR(7))), 7);



      -- Se inserta la Cuarta Seccion de el Srchivo ISS que corresponde a Addresses Record
      INSERT INTO TCR_TCARCISS_ADM( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,
                      Iss_S4Cam1,   Iss_S4Cam2,   Iss_S4Cam3,   Iss_S4Cam4,   Iss_S4Cam5,
                      Iss_S4Cam6,   Iss_S4Cam7,   Iss_S4Cam8,   Iss_S4Cam9,   Iss_S4Cam10,
                      Iss_S4Cam11,  Iss_S4Cam12,  Iss_S4Cam13,  Iss_S4Cam14,  Iss_S4Cam15,
                      Iss_S4Cam16,  Iss_S4Cam17,  Iss_S4Cam18,  Iss_S4Cam19,  Iss_S4Cam20,
                      Iss_S4Cam21,  Iss_S4Cam22,  Iss_S4Cam23,  Iss_S4Cam24,  Iss_S4Cam25,
                      Iss_S4Cam26,  Iss_S4Cam27,  Iss_S4Cam28,  Iss_S4Cam29,  Iss_S4Cam30,
                      Iss_S4Cam31,  Iss_Orden)
            SELECT    FolioArchivo,         NoEnviado,            FechaAct,         SEC_DIRECCION,
                  Val_SEC4CMSUSER,        Val_SEC4PASSWCMS,       RegistroID,         DataGroup,      MesageCodeAltaS4,
                  Val_SEC4CHECKEDAUTORIZA,    Val_SEC4DEF_SUCURSAUTOR,    Val_SEC4DEF_PRODUCPROSA,  CBS_BankID,     Val_SEC4DEF_TIPODOCAUTORI,
                                    Num_TipoDoc,          Val_SEC4DEF_ALTANUMTAR,     TipoDirLlegaTar,      Dir_Calle,      Dir_NumeroExt,
                  Dir_Colonia,          Dir_Complemento,        Dir_Ciudad,         EstadoRepu,     CodigoPais,
                  Dir_CodidoPos,          TelFijo,            TelFax,           TelCelular,     CorreoEelc,
                  FecDesde,           FecHasta,           NumInterno,         TiempoVivirDir,   EntregaTipoDir,
                  Val_SEC4FILLER,       CAST(RegistroID AS SIGNED INTEGER);


                       SET  TipoDirLlegaTar = '05' ; -- 05 Lugar donde llega la tarjeta fisicamente.


      SET RegistroID  = RIGHT(CONCAT('0000000',CAST(  CAST(RegistroID AS SIGNED) +  1    AS CHAR(7))), 7);


        -- Se inserta la Cuarta Seccion de el Srchivo ISS que corresponde a Addresses Record
      INSERT INTO TCR_TCARCISS_ADM( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,
                      Iss_S4Cam1,   Iss_S4Cam2,   Iss_S4Cam3,   Iss_S4Cam4,   Iss_S4Cam5,
                      Iss_S4Cam6,   Iss_S4Cam7,   Iss_S4Cam8,   Iss_S4Cam9,   Iss_S4Cam10,
                      Iss_S4Cam11,  Iss_S4Cam12,  Iss_S4Cam13,  Iss_S4Cam14,  Iss_S4Cam15,
                      Iss_S4Cam16,  Iss_S4Cam17,  Iss_S4Cam18,  Iss_S4Cam19,  Iss_S4Cam20,
                      Iss_S4Cam21,  Iss_S4Cam22,  Iss_S4Cam23,  Iss_S4Cam24,  Iss_S4Cam25,
                      Iss_S4Cam26,  Iss_S4Cam27,  Iss_S4Cam28,  Iss_S4Cam29,  Iss_S4Cam30,
                      Iss_S4Cam31,  Iss_Orden)
          SELECT    FolioArchivo,         NoEnviado,            FechaAct,         SEC_DIRECCION,
                Val_SEC4CMSUSER,        Val_SEC4PASSWCMS,       RegistroID,         DataGroup,        MesageCodeAltaS4,
                                Val_SEC4CHECKEDAUTORIZA,    Val_SEC4DEF_SUCURSAUTOR,    Val_SEC4DEF_PRODUCPROSA,  CBS_BankID,     Val_SEC4DEF_TIPODOCAUTORI,
                Num_TipoDoc,          Val_SEC4DEF_ALTANUMTAR,     TipoDirLlegaTar,        Dir_Calle,        Dir_NumeroExt,
                Dir_Colonia,          Dir_Complemento,        Dir_Ciudad,         EstadoRepu,     CodigoPais,
                Dir_CodidoPos,          TelFijo,            TelFax,           TelCelular,     CorreoEelc,
                FecDesde,           FecHasta,           NumInterno,         TiempoVivirDir,   EntregaTipoDir,
                Val_SEC4FILLER,       CAST(RegistroID AS SIGNED INTEGER);



          --  Se insertan la quinta seccion (5) de el archivo ISS que corresponde a  Job Record
      --  Se genera la cantidad de registros indicada por el parametro Iss_CantTarj lo equivalente a un registro para cada tarjeta


    -- select ContaRegis  = ContaRegis + 1
        SET RegistroID    = RIGHT(CONCAT('0000000',CAST(  CAST(RegistroID AS SIGNED) +  1    AS CHAR(7))), 7);
        SET FechaIngresoTrab= FechaGenArch;
        SET NumEmpleados  = RIGHT(CONCAT(REPEAT('0',12),Num_Sucurs),12);

        -- Se inserta la quinta Seccion de el archivo ISS que corresponde a Job Record
        INSERT INTO TCR_TCARCISS_ADM( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,
                        Iss_S5Cam1,   Iss_S5Cam2,   Iss_S5Cam3,   Iss_S5Cam4,   Iss_S5Cam5,
                        Iss_S5Cam6,   Iss_S5Cam7,   Iss_S5Cam8,   Iss_S5Cam9,   Iss_S5Cam10,
                        Iss_S5Cam11,  Iss_S5Cam12,  Iss_S5Cam13,  Iss_S5Cam14,  Iss_S5Cam15,
                        Iss_S5Cam16,  Iss_S5Cam17,  Iss_S5Cam18,  Iss_S5Cam19,  Iss_S5Cam20,
                        Iss_S5Cam21,  Iss_S5Cam22,  Iss_S5Cam23,  Iss_S5Cam24,  Iss_S5Cam25,
                        Iss_S5Cam26,  Iss_S5Cam27,  Iss_S5Cam28,  Iss_Orden)
            SELECT    FolioArchivo,         NoEnviado,            FechaAct,           SEC_JOBRECORD,
                  Val_SEC5CMSUSER,        Val_SEC5PASSWCMS,       RegistroID,           DataGroup,        MesageCodeAltaS5,
                  Val_SEC5CHECKEDAUTORIZA,    Val_SEC5DEF_SUCURSAUTOR,    Val_SEC5DEF_PRODUCPROSA,    CBS_BankID,       Val_SEC5DEF_TIPODOCAUTORI,
                                    Num_TipoDoc,          Val_SEC5DEF_ALTANUMTAR,     FechaGenArch,         NombreEmpresa,      PuestoTrabajo,
                  Salario,            FechaIngresoTrab,       Val_SEC5LINEANEGOCIO,     Val_SEC5COMPANIA_CGC, SucursalDeCompania,
                  Departamento,         AreaCompania,         NumEmpleados,         CorreoTrabajo,      TipoContrato,
                  TipoIngresos,         OtrosIngresos,          Titular,            CAST(RegistroID AS SIGNED INTEGER);

      -- se inserta la sexta seccion del ISS que corresponde al registro 106

        SET RegistroID  = RIGHT(CONCAT('0000000',CAST(  CAST(RegistroID AS SIGNED) +  1    AS CHAR(7))), 7);
        SET CBSCuenta = RIGHT(CONCAT(REPEAT('0',30),CAST(Num_TipoDoc AS SIGNED)), 30);

        INSERT INTO TCR_TCARCISS_ADM( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,
                        Iss_S6Cam1,   Iss_S6Cam2,   Iss_S6Cam3,   Iss_S6Cam4,   Iss_S6Cam5,
                        Iss_S6Cam6,   Iss_S6Cam7,   Iss_S6Cam8,   Iss_S6Cam9,   Iss_S6Cam10,
                        Iss_S6Cam11,  Iss_S6Cam12,  Iss_S6Cam13,  Iss_S6Cam14,  Iss_S6Cam15,
                        Iss_S6Cam16,  Iss_S6Cam17,  Iss_S6Cam18,  Iss_S6Cam19,  Iss_Orden)
              SELECT    FolioArchivo,         NoEnviado,            FechaAct,         SEC_CBSACCOUND,
                    Val_SEC6CMSUSER,        Val_SEC6PASSWCMS,       RegistroID,         DataGroup,        MesageCodeAltaS6,
                    Val_SEC6CHECKEDAUTORIZA,    Val_SEC6DEF_SUCURSAUTOR,    Val_SEC6DEF_PRODUCPROSA,  CBS_BankID,       Val_SEC6DEF_TIPODOCAUTORI,
                                        Num_TipoDoc,          Val_SEC6DEF_ALTANUMTAR,     NombreCortoProsa,     Agencia,        CBSCuenta,
                    CBSMoneda,            ExtraInfo,            OverDraft,          CBSTipoCuenta,      CAST(RegistroID AS SIGNED INTEGER);


           --  Se insertan la septima seccion (7) de el archivo ISS que corresponde a  Daily, Weekly, and Monthly Credit Limit Record
      SET RegistroID  = RIGHT(CONCAT('0000000',CAST(  CAST(RegistroID AS SIGNED) +  1    AS CHAR(7))), 7);


      -- Se inserta la septima Seccion de el Srchivo ISS que corresponde a Daily, Weekly, and Monthly Credit Limit Record
      INSERT INTO TCR_TCARCISS_ADM( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,
                      Iss_S7Cam1,   Iss_S7Cam2,   Iss_S7Cam3,   Iss_S7Cam4,   Iss_S7Cam5,
                      Iss_S7Cam6,   Iss_S7Cam7,   Iss_S7Cam8,   Iss_S7Cam9,   Iss_S7Cam10,
                      Iss_S7Cam11,  Iss_S7Cam12,  Iss_S7Cam13,  Iss_S7Cam14,  Iss_S7Cam15,
                      Iss_S7Cam16,  Iss_S7Cam17,  Iss_S7Cam18,  Iss_S7Cam19,  Iss_S7Cam20,
                      Iss_S7Cam21,  Iss_S7Cam22,  Iss_S7Cam23,  Iss_S7Cam24,  Iss_S7Cam25,
                      Iss_S7Cam26,  Iss_Orden)
      SELECT    FolioArchivo,         NoEnviado,            FechaAct,           SEC_LIMITCREDITODSM,
            Val_SEC7CMSUSER,        Val_SEC7PASSWCMS,       RegistroID,           DataGroup,          MesageCodeAltaS7,
            Val_SEC7CHECKEDAUTORIZA,    Val_SEC7DEF_SUCURSAUTOR,    Val_SEC7DEF_PRODUCPROSA,    CBS_BankID,         Val_SEC7DEF_TIPODOCAUTORI,
                        Num_TipoDoc,          Val_SEC7DEF_ALTANUMTAR,     MonMaxRetDiaPOS,        MonMaxRetDiaATM,      MonMaxRetSemPOS,
            MonMaxRetSemATM,        MonMaxRetMesPOS,        MonMaxRetMesATM,        NumMaxTraDiaPOS,      NumMaxTraDiaATM,
            NumMaxTraSemPOS,        NumMaxTraSemATM,        NumMaxTraMesPOS,        NumMaxTraMesATM,      MontoMaxDevol,
            Val_SEC7FILLER,       CAST(RegistroID AS SIGNED INTEGER);



      -- Se inserta la octava Seccion de el Archivo ISS que corresponde a CBS Account Association Record registro 110
        SET RegistroID  = RIGHT(CONCAT('0000000',CAST(  CAST(RegistroID AS SIGNED) +  1    AS CHAR(7))), 7);
        SET CBSCuenta = RIGHT(CONCAT(REPEAT('0',30),CAST(Num_TipoDoc AS SIGNED)), 30);

        INSERT INTO TCR_TCARCISS_ADM( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,
                        Iss_S8Cam1,   Iss_S8Cam2,   Iss_S8Cam3,   Iss_S8Cam4,   Iss_S8Cam5,
                        Iss_S8Cam6,   Iss_S8Cam7,   Iss_S8Cam8,   Iss_S8Cam9,   Iss_S8Cam10,
                        Iss_S8Cam11,  Iss_S8Cam12,  Iss_S8Cam13,  Iss_S8Cam14,  Iss_S8Cam15,
                        Iss_S8Cam16,  Iss_S8Cam17,  Iss_S8Cam18,  Iss_S8Cam19,  Iss_Orden)
        SELECT    FolioArchivo,         NoEnviado,            FechaAct,           SEC_CBSASSOCIATION,
              Val_SEC8CMSUSER,        Val_SEC8PASSWCMS,       RegistroID,           DataGroup,          MesageCodeAltaS8,
              Val_SEC8CHECKEDAUTORIZA,    Val_SEC8DEF_SUCURSAUTOR,    Val_SEC8DEF_PRODUCPROSA,    CBS_BankID,         Val_SEC8DEF_TIPODOCAUTORI,
                            Num_TipoDoc,          Val_SEC8DEF_ALTANUMTAR,     CBSMoneda,            NombreCortoProsa,     Agencia,
              CBSCuenta,            CBSMoneda,            CBSTipoCuenta,          CuentaDefault,        CAST(RegistroID AS SIGNED INTEGER);
        END WHILE;

            UPDATE TCR_TCARCISS_ADM
            SET Iss_Registro =CONCAT(Iss_S2Cam1 , Iss_S2Cam2 ,  Iss_S2Cam3 ,  Iss_S2Cam4 ,  Iss_S2Cam5 ,
                        Iss_S2Cam6 ,  Iss_S2Cam7 ,  Iss_S2Cam8 ,  Iss_S2Cam9 ,  Iss_S2Cam10 ,
                        Iss_S2Cam11 , Iss_S2Cam12 , Iss_S2Cam13 , Iss_S2Cam14 , Iss_S2Cam15 ,
                        Iss_S2Cam16 , Iss_S2Cam17 , Iss_S2Cam18 , Iss_S2Cam19 , Iss_S2Cam20 ,
                        Iss_S2Cam21 , Iss_S2Cam22 , Iss_S2Cam23 , Iss_S2Cam24 , Iss_S2Cam25 ,
                        Iss_S2Cam26 , Iss_S2Cam27 , Iss_S2Cam28 , Iss_S2Cam29 , Iss_S2Cam30 ,
                        Iss_S2Cam31 , Iss_S2Cam32 , Iss_S2Cam33 , Iss_S2Cam34 , Iss_S2Cam35 ,
                        Iss_S2Cam36 , Iss_S2Cam37 , Iss_S2Cam38 , Iss_S2Cam39 , Iss_S2Cam40 ,
                        Iss_S2Cam41 , Iss_S2Cam42 , Iss_S2Cam43 , Iss_S2Cam44 , Iss_S2Cam45 ,
                        Iss_S2Cam46 , Iss_S2Cam47 , Iss_S2Cam48 , Iss_S2Cam49 , Iss_S2Cam50 ,
                        Iss_S2Cam51 , Iss_S2Cam52 , Iss_S2Cam53 , Iss_S2Cam54 , Iss_S2Cam55 ,
                        Iss_S2Cam56 , Iss_S2Cam57 , Iss_S2Cam58 , Iss_S2Cam59 , Iss_S2Cam60 ,
                        Iss_S2Cam61 , Iss_S2Cam62 , Iss_S2Cam63 , Iss_S2Cam64 , Iss_S2Cam65 ,
                        Iss_S2Cam66 , Iss_S2Cam67 , Iss_S2Cam68 , Iss_S2Cam69 , Iss_S2Cam70 ,
                        Iss_S2Cam71 , Iss_S2Cam72 , Iss_S2Cam73 , Iss_S2Cam74 , Iss_S2Cam75 ,
                        Iss_S2Cam76 , Iss_S2Cam77 , Iss_S2Cam78),
                Iss_ConsecDoc = CAST(Iss_S2Cam11 AS DECIMAL)
            WHERE Iss_FolioAr = FolioArchivo
              AND Iss_Seccion = SEC_REGISTROTARJETA;

            UPDATE TCR_TCARCISS_ADM
            SET Iss_Registro =CONCAT(Iss_S3Cam1 , Iss_S3Cam2 , Iss_S3Cam3 ,   Iss_S3Cam4 ,    Iss_S3Cam5 ,
                      Iss_S3Cam6 ,  Iss_S3Cam7 , Iss_S3Cam8 ,   Iss_S3Cam9 ,    Iss_S3Cam10 ,
                      Iss_S3Cam11 , Iss_S3Cam12 , Iss_S3Cam13 , Iss_S3Cam14 , Iss_S3Cam15 ,
                      Iss_S3Cam16 , Iss_S3Cam17 , Iss_S3Cam18),
              Iss_ConsecDoc = CAST(Iss_S3Cam11 AS DECIMAL)
            WHERE Iss_FolioAr = FolioArchivo
              AND Iss_Seccion = SEC_LIMITCREDITO;

            UPDATE TCR_TCARCISS_ADM

            SET Iss_Registro =CONCAT(Iss_S4Cam1 , Iss_S4Cam2  , Iss_S4Cam3  , Iss_S4Cam4  , Iss_S4Cam5  ,
                      Iss_S4Cam6  , Iss_S4Cam7  , Iss_S4Cam8  , Iss_S4Cam9  , Iss_S4Cam10 ,
                      Iss_S4Cam11 , Iss_S4Cam12 , Iss_S4Cam13 , Iss_S4Cam14 , Iss_S4Cam15 ,
                      Iss_S4Cam16 , Iss_S4Cam17 , Iss_S4Cam18 , Iss_S4Cam19 , Iss_S4Cam20 ,
                      Iss_S4Cam21 , Iss_S4Cam22 , Iss_S4Cam23 , Iss_S4Cam24 , Iss_S4Cam25 ,
                      Iss_S4Cam26 , Iss_S4Cam27 , Iss_S4Cam28 , Iss_S4Cam29 , Iss_S4Cam30 ,
                      Iss_S4Cam31),
              Iss_ConsecDoc = CAST(Iss_S4Cam11 AS DECIMAL)
            WHERE Iss_FolioAr = FolioArchivo
              AND Iss_Seccion = SEC_DIRECCION;



            UPDATE TCR_TCARCISS_ADM
            SET Iss_Registro =CONCAT(Iss_S5Cam1 , Iss_S5Cam2  , Iss_S5Cam3  , Iss_S5Cam4  , Iss_S5Cam5  ,
                      Iss_S5Cam6  , Iss_S5Cam7  , Iss_S5Cam8  , Iss_S5Cam9  , Iss_S5Cam10 ,
                      Iss_S5Cam11 , Iss_S5Cam12 , Iss_S5Cam13 , Iss_S5Cam14 , Iss_S5Cam15 ,
                      Iss_S5Cam16 , Iss_S5Cam17 , Iss_S5Cam18 , Iss_S5Cam19 , Iss_S5Cam20 ,
                      Iss_S5Cam21 , Iss_S5Cam22 , Iss_S5Cam23 , Iss_S5Cam24 , Iss_S5Cam25 ,
                      Iss_S5Cam26 , Iss_S5Cam27 , Iss_S5Cam28),
              Iss_ConsecDoc = CAST(Iss_S5Cam11 AS DECIMAL)
            WHERE Iss_FolioAr = FolioArchivo
              AND Iss_Seccion = SEC_JOBRECORD;

            UPDATE TCR_TCARCISS_ADM
            SET Iss_Registro =CONCAT(Iss_S6Cam1 , Iss_S6Cam2  , Iss_S6Cam3  , Iss_S6Cam4  , Iss_S6Cam5  ,
                      Iss_S6Cam6  , Iss_S6Cam7  , Iss_S6Cam8  , Iss_S6Cam9  , Iss_S6Cam10 ,
                      Iss_S6Cam11 , Iss_S6Cam12 , Iss_S6Cam13 , Iss_S6Cam14 , Iss_S6Cam15 ,
                      Iss_S6Cam16 , Iss_S6Cam17 , Iss_S6Cam18 , Iss_S6Cam19),
              Iss_ConsecDoc = CAST(Iss_S6Cam11 AS DECIMAL)
            WHERE Iss_FolioAr = FolioArchivo
              AND Iss_Seccion = SEC_CBSACCOUND;

              UPDATE TCR_TCARCISS_ADM
            SET Iss_Registro =CONCAT(Iss_S7Cam1 , Iss_S7Cam2  , Iss_S7Cam3  , Iss_S7Cam4  , Iss_S7Cam5  ,
                      Iss_S7Cam6  , Iss_S7Cam7  , Iss_S7Cam8  , Iss_S7Cam9  , Iss_S7Cam10 ,
                      Iss_S7Cam11 , Iss_S7Cam12 , Iss_S7Cam13 , Iss_S7Cam14 , Iss_S7Cam15 ,
                      Iss_S7Cam16 , Iss_S7Cam17 , Iss_S7Cam18 , Iss_S7Cam19 , Iss_S7Cam20 ,
                      Iss_S7Cam21 , Iss_S7Cam22 , Iss_S7Cam23 , Iss_S7Cam24 , Iss_S7Cam25 ,
                      Iss_S7Cam26),
              Iss_ConsecDoc = CAST(Iss_S7Cam11 AS DECIMAL)
            WHERE Iss_FolioAr = FolioArchivo
              AND Iss_Seccion = SEC_LIMITCREDITODSM;

            UPDATE TCR_TCARCISS_ADM
            SET Iss_Registro =CONCAT(Iss_S8Cam1 , Iss_S8Cam2  , Iss_S8Cam3  , Iss_S8Cam4  , Iss_S8Cam5  ,
                      Iss_S8Cam6  , Iss_S8Cam7  , Iss_S8Cam8  , Iss_S8Cam9  , Iss_S8Cam10 ,
                      Iss_S8Cam11 , Iss_S8Cam12 , Iss_S8Cam13 , Iss_S8Cam14 , Iss_S8Cam15 ,
                      Iss_S8Cam16 , Iss_S8Cam17 , Iss_S8Cam18 , Iss_S8Cam19),
              Iss_ConsecDoc = CAST(Iss_S8Cam11 AS DECIMAL)
            WHERE Iss_FolioAr = FolioArchivo
              AND Iss_Seccion = SEC_CBSASSOCIATION;


            SELECT LoteDebitoID FROM LOTETARJETADEB
            WHERE LoteDebitoID = Num_Solici ;

            UPDATE LOTETARJETADEB
            SET Estatus =  Sta_Archivo
            WHERE LoteDebitoID = Num_Solici;
          END;
        END LOOP;
    END;
    CLOSE Cur_SolicitudISS;

        --  Se inserta la novena seccion (9) de el archivo ISS que corresponde a  Trailer Record
    SET RegistroID  = RIGHT(CONCAT('0000000',CAST(  CAST(RegistroID AS SIGNED) +  1    AS CHAR(7))), 7);
    INSERT INTO TCR_TCARCISS_ADM( Iss_FolioAr,  Iss_Enviado,  Iss_FecGen,   Iss_Seccion,
                    Iss_S9Cam1,   Iss_S9Cam2,   Iss_S9Cam3,   Iss_S9Cam4,   Iss_S9Cam5,
                    Iss_S9Cam6,   Iss_S9Cam7,   Iss_S9Cam8,   Iss_S9Cam9,   Iss_S9Cam10,
                    Iss_S9Cam11,  Iss_S9Cam12,  Iss_Orden)
        SELECT    FolioArchivo,       NoEnviado,              FechaAct,           SEC_TRAILERRECORD,
              Val_SEC9HEADERRECORD,   Val_SEC9APPLICATIONCOMMING,   Val_SEC9CHECKEDAUTORIZA,    Val_SEC9TIPOFILE,     Val_SEC9PERIODICIDAD,
              FolioString,        Val_SEC9EXTENCION,          FechaHoraCrea,          Val_SEC9CMSUSER,      Val_SEC9PASSWCMS,
              TotalRegistros,     Val_SEC9SENDERIDENTIFICATION,   CAST(RegistroID AS SIGNED INTEGER);


  SET TotalRegistros = (SELECT RIGHT(CONCAT('000000000',IFNULL(COUNT(Iss_FolioAr), Ent_Cero)), 9)
    FROM TCR_TCARCISS_ADM
    WHERE Iss_FolioAr = FolioArchivo);

    END IF;

    UPDATE TCR_TCARCISS_ADM
    SET Iss_Registro =CONCAT( Iss_S1Cam1, Iss_S1Cam2, Iss_S1Cam3, Iss_S1Cam4,   Iss_S1Cam5,   Iss_S1Cam6,
                  Iss_S1Cam7, Iss_S1Cam8, Iss_S1Cam9, Iss_S1Cam10,  Iss_S1Cam11,  Iss_S1Cam12)
    WHERE Iss_FolioAr = FolioArchivo
    AND Iss_Seccion = SEC_HEADER;

  UPDATE TCR_TCARCISS_ADM
    SET Iss_S1Cam11 = TotalRegistros,
      Iss_S9Cam11 = TotalRegistros
    WHERE Iss_FolioAr = FolioArchivo
    AND Iss_Seccion IN (SEC_HEADER, SEC_TRAILERRECORD);

  UPDATE TCR_TCARCISS_ADM
    SET Iss_Registro =CONCAT(Iss_S9Cam1,  Iss_S9Cam2, Iss_S9Cam3, Iss_S9Cam4, Iss_S9Cam5,
                Iss_S9Cam6,   Iss_S9Cam7, Iss_S9Cam8, Iss_S9Cam9, Iss_S9Cam10,
                Iss_S9Cam11,  Iss_S9Cam12)
    WHERE Iss_FolioAr = FolioArchivo
    AND Iss_Seccion = SEC_TRAILERRECORD;


  -- Inserta de la tabla de paso a la tabla de archivos
  INSERT INTO TCR_ISSARCH_ADM
  SELECT Iss_FolioAr,  Iss_Enviado,  Iss_FecGen, Iss_Orden,  Iss_Seccion,
       Iss_Registro, Iss_ConsecDoc
    FROM  TCR_TCARCISS_ADM
    WHERE Iss_FolioAr = FolioArchivo
    ORDER BY Iss_Orden  ASC ;

  TRUNCATE  TABLE TCR_TCARCISS_ADM;

END$$