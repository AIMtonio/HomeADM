-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CINTAINTFSEMANAL000PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CINTAINTFSEMANAL000PRO`;
DELIMITER $$

CREATE PROCEDURE `CINTAINTFSEMANAL000PRO`(
/* SP PARA CINTA DE BURO DE CREDITO SEMANAL FORMATO CSV */
    Par_FechaCorteBC    DATE,     -- Fecha de Corte para generar el reporte
    Par_CintaBCID       INT(11),  -- CintaID corresponde a BUROCREDINTFMEN
    Par_TipoFormatoCinta	INT(11),
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
  /* DECLARACION DE VARIABLES */
	DECLARE Var_Cinta         VARCHAR(60000);
	DECLARE Var_ClienteID       INT;
	DECLARE Var_FechaCorte      DATE;
	DECLARE Var_FechaCorteStr   VARCHAR(8);
	DECLARE Var_Member        VARCHAR(40);
	DECLARE Var_NombreEmp     VARCHAR(100);
	DECLARE Var_EncabezadoCVS   VARCHAR(1500);
	DECLARE Var_CintaID       INT;
	DECLARE Var_Fec_SigPeriodo    DATE;
	DECLARE Var_FechaFin      DATE;
	DECLARE Var_FechaInicial    DATE;
  /* DECLARACION DE CONSTANTES */
  DECLARE EstatusPagado       CHAR(1);
  DECLARE EstatusVigente      CHAR(1);
  DECLARE EstatusCastigado    CHAR(1);
  DECLARE EstatusVencido      CHAR(1);
  DECLARE EstatusAtrasado     CHAR(1);
  DECLARE EstatusRenovado     CHAR(1);
  DECLARE DiasCtaReciente     INT;
  DECLARE Cadena_Vacia      CHAR(1);
  DECLARE Fecha_Vacia       DATE;
  DECLARE Entero_Cero       INT;
  DECLARE Entero_Uno        INT;
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
  DECLARE Fecha_Vaciaddmmyyyy   CHAR(8);
  DECLARE Entero_Diez       INT(2);
  DECLARE Factor_Meses      DECIMAL(12,2);
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
  DECLARE SexoFemenino      CHAR(1);
  DECLARE PrefijoSR         CHAR(2);
  DECLARE LimpiaAlfabetico    VARCHAR(2);   /* Limpieza de texto que contiene solo letras */
  DECLARE LimpiaAlfaNumerico    VARCHAR(2);   /* Limpieza de texto que contiene letras y numeros */
  DECLARE ConsConsolidado       VARCHAR(2);         /*Cadena Consolidado*/
    /* CLAVES MOPS */
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
	/* TIPOS DE RESPONSABILIDAD */
	DECLARE TipoRespIndividual    CHAR(1);
	DECLARE TipoRespMancomunado   CHAR(1);
	DECLARE TipoRespObligadoSol   CHAR(1);
	DECLARE TipoCtaPagosFijos   CHAR(1);
	DECLARE TipoCtaHipoteca     CHAR(1);
	DECLARE TipoCtaSinLimite    CHAR(1);
	DECLARE TipoCtaRevolvente   CHAR(1);
	/* CLAVES DE OBSERVACION */
	DECLARE ClaveObsCtaCanc     CHAR(2);
	DECLARE ClaveObsFiniq     CHAR(2);
	DECLARE ClaveObsCtaCast     CHAR(2);
	/* TIPOS DE FRECUENCIAS DE PAGOS */
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
	DECLARE EstatusInactivo     CHAR(1);
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
	DECLARE ClavePC         CHAR(3);
	DECLARE ClaveSG         CHAR(3);
  DECLARE Entero_Tres				  INT(11);
	DECLARE Var_Fecha				    VARCHAR(30);
	DECLARE Var_SaldosTotal			INT(11);
	DECLARE Var_SaldosVig			  INT(11);
	DECLARE Var_ConteoReg			  INT(11);
	DECLARE Var_InicioEXT			  VARCHAR(10);
	DECLARE Var_FinEXT				  VARCHAR(10);
	DECLARE Var_SegmentoEXT			VARCHAR(10);
    /* Asignacion Constantes */
  SET EstatusPagado       :='P';
  SET EstatusVigente      :='V';
  SET EstatusCastigado    :='K';
  SET EstatusVencido      :='B';
  SET EstatusAtrasado     := 'A';
  SET EstatusRenovado     :='O';
  SET DiasCtaReciente     :=29;
  SET Cadena_Vacia      :='';
  SET Fecha_Vacia       :='1900-01-01';
  SET Entero_Cero       :=0;
  SET Entero_Uno        :=1;
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
  SET PrefijoSR         := 'SR';
  SET Fecha_Vaciaddmmyyyy   :='01011900';
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
  SET SexoFemenino      := 'F';
  SET FormatoFecha      := '%d%m%Y';
  SET FormatoFechaInicio    := '%Y-%m-01';


  SET MopUR         := 'UR'; /* MOP para cuenta sin informacion */
  SET Mop00         := '00'; /* MOP para cuenta nuy reciente */
  SET Mop01         := '01'; /* MOP para cuenta al corriente */
  SET Mop02         := '02'; /* MOP para cuenta con atraso */
  SET Mop03         := '03'; /* MOP para cuenta con atraso */
  SET Mop04         := '04'; /* MOP para cuenta con atraso */
  SET Mop05         := '05'; /* MOP para cuenta con atraso */
  SET Mop06         := '06'; /* MOP para cuenta con atraso */
  SET Mop07         := '07'; /* MOP para cuenta con atraso */
  SET Mop96         := '96'; /* MOP para cuenta con atraso */
  SET Mop97         := '97'; /* MOP para cuenta con deuda parcial */
  SET Mop99         := '99'; /* MOP para fraude cometido por el cte */
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
	SET EstatusInactivo     := 'I';
	SET ClavePC         := 'PC';
	SET ClaveSG         := 'SG';
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
  SET Entero_Tres				  := 3;
	SET Var_InicioEXT			  := 'BOF';
	SET Var_FinEXT				  := 'EOF';
	SET Var_SegmentoEXT			:= '**';

	SET Var_FechaFin		    := LAST_DAY(Par_FechaCorteBC);
  SET Var_FechaCorte		  := Var_FechaFin;
	SET Var_FechaInicial  	:= DATE_SUB(Par_FechaCorteBC, INTERVAL 7 DAY);
  SET Var_Fec_SigPeriodo	:= DATE_ADD(Var_FechaFin, INTERVAL 1 MONTH);

	SELECT 	 ClaveInstitID,	    Nombre
	  INTO 	 Var_Member,			Var_NombreEmp
		FROM BUCREPARAMETROS;

  SET ConsConsolidado    := 'CO';

	DELETE FROM BUROCREDINTFMEN  WHERE Fecha=Par_FechaCorteBC;

	SET Var_CintaID:= Par_CintaBCID;

	IF(Par_TipoFormatoCinta = Entero_Tres)THEN
		SELECT REPLACE(DATE_FORMAT(Par_FechaCorteBC, '%d/%m/%Y'), '/', '')INTO Var_Fecha;
		/* encabezado de la cinta EXT */
		SET Var_EncabezadoCVS:=Cadena_Vacia;
		SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS, Var_InicioEXT,'|',Var_Member,'|',Var_Fecha,'|',Var_SegmentoEXT,'|',Salto_Linea);
		SET Separador		:= '|';
	END IF;

  IF(Par_TipoFormatoCinta <> Entero_Tres)THEN
    /* encabezado de la cinta (de 5 en 5) */
    SET Var_EncabezadoCVS:=Cadena_Vacia;
      /* 1 - 10 */
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'CLAVE_OTORGANTE_1,NOMBRE DEL OTORGANTE_1,FECHA DEL REPORTE,APELLIDO_PATERNO,APELLIDO_MATERNO,');
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'APELLIDO_ADICIONAL,PRIMER_NOMBRE,SEGUNDO_NOMBRE,FECHA_DE_NACIMIENTO,RFC,');
      /* 11 - 20 */
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'PREFIJO,NACIONALIDAD,ESTADO_CIVIL,SEXO,FECHA_DEFUNCION,');
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'INDICADOR_DEFUNCION,DIRECCION_CALLE_NUMERO,DIRECCION_COMPLEMENTO,COLONIA_O_POBLACION,DELEGACION_O_MUNICIPIO,');
      /* 21 - 30 */
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'CIUDAD,ESTADO,C.P.,TELEFONO,DIRECCION_ORIGEN,');
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'EMPRESA,DIRECCION_CALLE_NUMERO_1,DIRECCION_COMPLEMENTO_1,COLONIA_O_POBLACION_1,DELEGACION_O_MUNICIPIO_1,');
      /* 31 - 40 */
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'CIUDAD_1,ESTADO_1,C.P._1,TELEFONO_1,SALARIO,');
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'DIRECCION_ORIGEN,CLAVE_OTORGANTE,NOMBRE DEL OTORGANTE,NUMERO_CUENTA,TIPO_RESPONSABILIDAD_CUENTA,');
      /* 41 - 50 */
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'TIPO_CUENTA,TIPO_CONTRATO,MONEDA,NUMERO_DE_PAGOS,FRECUENCIA_DE_PAGOS,');
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'FECHA_APERTURA,MONTO_A_PAGAR,FECHA_ULTIMO_PAGO,FECHA_ULTIMA_COMPRA,FECHA_CIERRE_CREDITO,');
      /* 51 - 60 */
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'FECHA_REPORTE,CREDITO_MAXIMO,SALDO_ACTUAL,LIMITE_DE_CREDITO,SALDO_VENCIDO,');
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'NUMERO_PAGOS_VENCIDOS,FORMA_PAGO_MOP,CLAVE_OBSERVACION,CLAVE_ANTERIOR_OTORGANTE,NOMBRE_ANTERIOR_OTORGANTE,');
      /* 61 - 70 */
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'NUMERO_CTA_ANTERIOR,FECHA_PRIMER_INCUMPLIMIENTO,SALDO_INSOLUTO,MONTO_ULTIMO_PAGO,PLAZO_CREDITO,');
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'MONTO_CREDITO_ORIGINAL,FECHA_ULT_PAGO_VENCIDO,INTERES_REPORTADO,FORMA_PAGO_INTERES,DIAS_DESDE_ULT_PAGO,');
      /* 71 */
    SET Var_EncabezadoCVS:=CONCAT(Var_EncabezadoCVS,'CORREO_ELECTRONICO',Salto_Linea);
    END  IF;


  /* Temporal que guarda los nombres de los municipios correctamente */

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

  /* creacion de la tabla temporal con los datos que contendra la cinta */
  DROP TABLE IF EXISTS TMPDATOSCTESCREDPAG;
  CREATE TABLE TMPDATOSCTESCREDPAG(
    ClienteID   		INT(11),    	ApellidoPaterno   VARCHAR(50),  ApellidoMaterno   VARCHAR(50),  Adicional   		VARCHAR(50),
    PrimerNombre  	VARCHAR(50),  SegundoNombre   	VARCHAR(50),  TercerNombre    	VARCHAR(50),  FechaNacimiento VARCHAR(10),
    RFC       			VARCHAR(18),  Prefijo       		VARCHAR(10),  EstadoCivil     	CHAR(2),    	Sexo      			CHAR(1),
    FDef      			VARCHAR(10),  InDef       			VARCHAR(10),  CalleNumero     	VARCHAR(100), Colonia     		VARCHAR(200),
    Municipio   		VARCHAR(100), Ciudad        		VARCHAR(50),  Estado        		VARCHAR(20),  member      		VARCHAR(50),
    CP        			CHAR(6),    	Telefono      		VARCHAR(11),  DirComplemento    VARCHAR(100), Empresa     		VARCHAR(99),
    CalleNumero2 		VARCHAR(41),  Colonia2      		VARCHAR(41),  Municipio2      	VARCHAR(41),  Ciudad2     		VARCHAR(41),
    Estado2    	 		VARCHAR(20),  CP2         			CHAR(6),    	Telefono2     		VARCHAR(11),  DirComplemento2 VARCHAR(100),
    Salario     		VARCHAR(10),  CreditoIDCte    	VARCHAR(20),  Estatus       		CHAR(1),    	CreditoIDSAFI 	BIGINT(12),
    FechaPago   		CHAR(8),    	Incumplimiento    VARCHAR(8),   NPagos        		INT(11),    	FrecPagos   		CHAR(2),
    Saldo     			INT(11),    	MontoCredito    	INT(11),    	Vencido       		INT(11),    	FechaInicio   	CHAR(8),
    ImportePagos  	INT(11),    	FechaCierre     	CHAR(8),    	NoCuotasAtraso    INT(11),    	DiasAtraso    	INT(11),
    DiasPasoAtraso  INT(11),    	SaldoTotal      	INT(11),    	MOP         			CHAR(2),    	TipoContrato  	CHAR(8),
    Moneda      		CHAR(5),    	Responsabilidad   CHAR(1),    	TipoCuenta      	CHAR(1),    	TipoPersona   	CHAR(1),
    ClaveObervacion CHAR(3),   	 	MontoUltPago    	INT(11),    	PlazoID       		VARCHAR(20),  Nacionalidad  	CHAR(5),
    PaisID      		INT(11),    	DiasAtraFecFinCre INT(11),    	PaisResidencia    INT(11),    	NacDomicilio  	CHAR(5),
    CorreoElect   	VARCHAR(50),  FechaUltPagoVen   CHAR(8),    	OcupacionID     	INT(11),    	PlazoCredito  	DECIMAL(12,2),
    MonedaID    		INT(11),    	GraciaMoratorios  INT,      		GraciaPasoAtraso  INT,      		FecTerminacion  DATE,
    InicioCredito 	DATE,     		InteresReportado  INT,      		Cuenta        		VARCHAR(40),  Cinta     			TEXT,
    FechaAtraso   	DATE,     		TipoCredito     	CHAR(2),
  INDEX TMPDATOSCTESCREDPAG1 (ClienteID),
  INDEX TMPDATOSCTESCREDPAG2 (CreditoIDCte),
  INDEX TMPDATOSCTESCREDPAG3 (CreditoIDSAFI));

  -- Insercion de los datos generales, los valores de saldos son actualizados posteriormente.
  INSERT INTO TMPDATOSCTESCREDPAG(
  SELECT  MAX(Cli.ClienteID) AS ClienteID,        IFNULL(MAX(Cli.ApellidoPaterno),Cadena_Vacia) AS ApellidoPaterno,   IFNULL(MAX(Cli.ApellidoMaterno),Cadena_Vacia) AS ApellidoMaterno,   Cadena_Vacia AS Adicional,
      MAX(Cli.PrimerNombre) AS PrimerNombre,    MAX(Cli.SegundoNombre) AS SegundoNombre,                          MAX(Cli.TercerNombre) AS TercerNombre,                      DATE_FORMAT(MAX(Cli.FechaNacimiento),FormatoFecha)AS FechaNacimiento,

      CASE WHEN LENGTH(MAX(Cli.RFC)) != 13 AND MAX(Cli.TipoPersona) != PersMoral THEN  Cadena_Vacia
     ELSE MAX(Cli.RFC)
    END AS RFC,

      IFNULL(Cli.Titulo,Cadena_Vacia) AS Prefijo,
    CASE MAX(Cli.EstadoCivil)
    WHEN Casado_BM  THEN Casado_BC
    WHEN Casado_BMC THEN Casado_BC
    WHEN Casado_BS  THEN Casado_BC
    WHEN Viudo    THEN Viudo_BC
    WHEN Union_libre THEN Union_libreBC
    WHEN EdoSeparado THEN Soltero_BC
      ELSE LEFT(MAX(Cli.EstadoCivil), 1)
    END AS EstadoCivil,

    MAX(Cli.Sexo) AS Sexo,
    Cadena_Vacia AS FDef,     Cadena_Vacia AS InDef,

    IF(/*IF(*/ (IFNULL(MAX(Dir.Calle),Cadena_Vacia)=Cadena_Vacia AND IFNULL(MAX(Dir.NumeroCasa),Entero_Cero)=Entero_Cero)OR(IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocida OR IFNULL(MAX(Dir.Calle),Cadena_Vacia) LIKE CalleConocido)/*) IF*/ ,
    /*THEN*/ DomicilioConocido,
    /*ELSE*/ CONCAT(LEFT(IFNULL(MAX(Dir.Calle),Cadena_Vacia),(40-LENGTH(IF(IFNULL(MAX(Dir.NumeroCasa),Entero_Cero)=Entero_Cero,SinNumero,CONCAT(EtiquetaNumero,MAX(Dir.NumeroCasa)))))
    ),IF(IFNULL(MAX(Dir.NumeroCasa),Entero_Cero)=Entero_Cero,SinNumero,CONCAT(EtiquetaNumero,MAX(Dir.NumeroCasa))))) AS CalleNumero,

    TRIM(LEFT(CONCAT(MAX(Col.TipoAsenta),' ',MAX(Col.Asentamiento)),40)) AS Colonia,            TRIM(LEFT(MAX(Mun.Nombre),40)) AS Municipio,     TRIM(LEFT(MAX(Loc.NombreLocalidad),40)) AS Ciudad,
    MAX(Est.EqBuroCred) AS Estado,   Cadena_Vacia AS member,                   MAX(Dir.CP) AS CP,                     SUBSTRING(REPLACE(IF(IFNULL(MAX(Cli.Telefono),Cadena_Vacia)!=Cadena_Vacia,MAX(Cli.Telefono),MAX(Cli.TelefonoCelular)), ' ', ''), 1, 10) AS Telefono,
    Cadena_Vacia AS DirComplemento,
    LEFT(IF(MAX(Cli.LugardeTrabajo)=Cadena_Vacia,MAX(Cli.NombreCompleto),MAX(Cli.LugardeTrabajo)),40)  AS Empresa,

    -- INFORMACION DEL TRABAJO DEL CLIENTE O ACREDITADO
    Cadena_Vacia AS CalleNumero2,
    Cadena_Vacia AS Colonia2,
    Cadena_Vacia AS Municipio2,
    Cadena_Vacia AS Ciudad2,
    Cadena_Vacia AS Estado2,
    Cadena_Vacia  AS CP2,
    SUBSTRING(REPLACE(IF(IFNULL(MAX(Cli.TelTrabajo),Cadena_Vacia)!=Cadena_Vacia,MAX(Cli.TelTrabajo),Cadena_Vacia), '-', ''), 1, 10) AS Telefono2,
    Cadena_Vacia  AS DirComplemento2,
    Cadena_Vacia AS Salario,    MAX(EqC.CreditoIDCte) AS CreditoIDCte,               MAX(Cre.Estatus) AS Estatus,
    Cre.CreditoID,
    DATE_FORMAT(MAX(Cre.FechaInicio), FormatoFecha) AS FechaPago,  -- La Fecha de Ultimo Pago: Inicialmente es la Fecha de Inicio segun Manual BC
    Fecha_Vaciaddmmyyyy AS Incumplimiento, MAX(Cre.NumAmortizacion) AS NumAmortizacion,

    CASE WHEN MAX(Cre.FrecuenciaCap)  = 'C' THEN 'K'
      WHEN MAX(Cre.FrecuenciaCap)  = 'Q' THEN 'S'
      WHEN MAX(Cre.FrecuenciaCap)  = 'M' THEN 'M'
      WHEN MAX(Cre.FrecuenciaCap)  = 'B' THEN 'B'
      WHEN MAX(Cre.FrecuenciaCap)  = 'E' THEN 'H'
      WHEN MAX(Cre.FrecuenciaCap)  = 'A' THEN 'Y'
      WHEN MAX(Cre.FrecuenciaCap)  = 'S' OR MAX(Cre.FrecuenciaCap)  = 'D' THEN 'W'
      WHEN MAX(Cre.FrecuenciaCap)  = 'T' OR MAX(Cre.FrecuenciaCap)  = 'R'  THEN 'Q'
      WHEN MAX(Cre.FrecuenciaCap)  = 'P' OR MAX(Cre.FrecuenciaCap)  = 'L'
      OR   MAX(Cre.FrecuenciaCap)  = 'U' THEN 'V'
    END AS FrecPagos,

    Entero_Cero AS Saldo,                                 MAX(Cre.MontoCredito) AS MontoCredito,    Entero_Cero AS Vencido,
    DATE_FORMAT(MAX(Cre.FechaInicio), FormatoFecha) AS FechaInicio,
    Entero_Cero AS  ImportePagos,

    DATE_FORMAT(MAX(Cre.FechTerminacion),FormatoFecha) AS FechaCierre,

    Entero_Cero AS NoCuotasAtraso,              Entero_Cero AS DiasAtraso,
    MAX(Pro.DiasPasoAtraso) AS DiasPasoAtraso,  Entero_Cero AS  SaldoTotal,                       Cadena_Vacia AS MOP,
	CASE WHEN MAX(Cre.EsConsolidado) = Str_SI THEN
		ConsConsolidado
	ELSE
		MAX(Pro.TipoContratoBCID)
	END AS TipoContratoBCID,
    Cadena_Vacia AS Moneda,             MAX(Pro.EsGrupal) AS EsGrupal,                        MAX(Pro.EsRevolvente) AS EsRevolvente,              MAX(Cli.TipoPersona) AS TipoPersona,
    Cadena_Vacia AS ClaveObervacion,      Entero_Cero AS MontoUltPago,                      IFNULL(MAX(Cre.PlazoID),Entero_Cero) AS PlazoID,
    Cadena_Vacia AS Nacionalidad,         MAX(Cli.LugarNacimiento) AS LugarNacimiento,            Entero_Cero AS DiasAtraFecFinCre,               MAX(Cli.PaisResidencia) AS PaisResidencia,
    Cadena_Vacia AS NacDomicilio,         IFNULL(MAX(Cli.Correo),Cadena_Vacia) AS CorreoElect,

    CASE WHEN MAX(Cre.FechTraspasVenc) != Fecha_Vacia AND MAX(Cre.FechTraspasVenc) < Par_FechaCorteBC THEN
        DATE_FORMAT(MAX(Cre.FechTraspasVenc), FormatoFecha)
      ELSE Cadena_Vacia
    END,

    MAX(Cli.OcupacionID) AS OcupacionID,
    Entero_Cero AS PlazoCredito,            MAX(Cre.MonedaID) AS MonedaID,      MAX(Pro.GraciaMoratorios) AS GraciaMoratorios,          MAX(Pro.DiasPasoAtraso) AS DiasPasoAtraso,
    MAX(Cre.FechTerminacion) AS FechTerminacion,    MAX(Cre.FechaInicio) AS FechaInicio,    Entero_Cero AS InteresReportado,                Cadena_Vacia AS Cuenta,
    Cadena_Vacia  AS Cinta,               Fecha_Vacia AS FechaAtraso,             IFNULL(MAX(Cre.TipoCredito),Cadena_Vacia) AS TipoCredito

  FROM CREDITOS Cre
    INNER JOIN PRODUCTOSCREDITO Pro   ON  Cre.ProductoCreditoID = Pro.ProducCreditoID
    LEFT  JOIN EQU_CREDITOS   EqC   ON  Cre.CreditoID = EqC.CreditoIDSAFI
    INNER JOIN CLIENTES     Cli   ON  Cre.ClienteID = Cli.ClienteID
    INNER JOIN DIRECCLIENTE   Dir   ON  Cre.ClienteID = Dir.ClienteID AND Dir.Oficial = Str_SI
    INNER JOIN ESTADOSREPUB   Est   ON  Dir.EstadoID = Est.EstadoID
    INNER JOIN MUNICIPIOSREPUB  Mun   ON Dir.EstadoID = Mun.EstadoID    AND Dir.MunicipioID = Mun.MunicipioID
    INNER JOIN LOCALIDADREPUB   Loc   ON Dir.EstadoID = Loc.EstadoID    AND Dir.MunicipioID = Loc.MunicipioID
                                        AND Dir.LocalidadID = Loc.LocalidadID
    LEFT OUTER JOIN COLONIASREPUB   Col   ON Dir.EstadoID = Col.EstadoID    AND Dir.MunicipioID = Col.MunicipioID
                                        AND Dir.ColoniaID = Col.ColoniaID
  WHERE Cre.FechTerminacion BETWEEN Var_FechaInicial AND Par_FechaCorteBC
	  AND Cre.FechTerminacion < Cre.FechaVencimien
    AND Cli.TipoPersona = TipoPersFisica
    AND Cre.Estatus = EstatusPagado
  GROUP BY  Cre.CreditoID);

  /* Actualizamos la Direccion del Trabajo. REVISADO*/
  UPDATE TMPDATOSCTESCREDPAG Tem,
      DIRECCLIENTE Dir,
      ESTADOSREPUB Est,
      MUNICIPIOSREPUB Mun,
      LOCALIDADREPUB Loc,
      COLONIASREPUB Col SET

      Tem.CalleNumero2 = IF(( IFNULL(Dir.Calle, Cadena_Vacia) = Cadena_Vacia AND
                  IFNULL(Dir.NumeroCasa, Entero_Cero) = Entero_Cero) OR
                  ( IFNULL(Dir.Calle,Cadena_Vacia) LIKE CalleConocida OR
                    IFNULL(Dir.Calle,Cadena_Vacia) LIKE CalleConocido),
                  DomicilioConocido,
                  /*ELSE*/
                  CONCAT(LEFT(IFNULL(Dir.Calle, Cadena_Vacia),
                        (40-LENGTH(IF(IFNULL(Dir.NumeroCasa, Entero_Cero) = Entero_Cero,
                              SinNumero, CONCAT(EtiquetaNumero,Dir.NumeroCasa))))
                        ),IF(IFNULL(Dir.NumeroCasa,Entero_Cero) = Entero_Cero,SinNumero,
                  CONCAT(EtiquetaNumero,Dir.NumeroCasa)))),

      Tem.Colonia2  = TRIM(LEFT(CONCAT(Col.TipoAsenta,' ',Col.Asentamiento),40)),
      Tem.Municipio2  = TRIM(LEFT(Mun.Nombre,40)),
      Tem.Ciudad2   = TRIM(LEFT(Loc.NombreLocalidad,40)),
      Tem.Estado2   = Est.EqBuroCred,
      Tem.CP2     = Dir.CP

    WHERE Tem.ClienteID = Dir.ClienteID
      AND Dir.TipoDireccionID = TipoDomTrabajo
      AND Dir.EstadoID = Est.EstadoID
      AND Dir.EstadoID = Mun.EstadoID
      AND Dir.MunicipioID = Mun.MunicipioID
      AND Dir.EstadoID = Loc.EstadoID
      AND Dir.MunicipioID = Loc.MunicipioID
      AND Dir.LocalidadID = Loc.LocalidadID
      AND Dir.EstadoID = Col.EstadoID
      AND Dir.MunicipioID = Col.MunicipioID
      AND Dir.ColoniaID = Col.ColoniaID;

  /* Actualizamos el nombre de el municipio. REVISADO */
  UPDATE TMPDATOSCTESCREDPAG D, TEMPORAL_MUNICIP T
  SET D.Municipio = T.NombreCorrecto,
    D.Municipio2 = T.NombreCorrecto
    WHERE D.Municipio=T.Nombre;

    /* Eliminamos Creditos que se desembolsaron posterior a la fecha corte*/
  DELETE FROM TMPDATOSCTESCREDPAG
  WHERE CONVERT(SUBSTRING(FechaInicio,3,2),SIGNED)>MONTH(Var_FechaFin)
  AND SUBSTRING(FechaInicio,5,4) = YEAR(Var_FechaFin);

  /* Eliminamos Creditos que se hayan liquidado anterior a la Fecha corte*/
  DELETE FROM TMPDATOSCTESCREDPAG
  WHERE CONVERT(SUBSTRING(FechaCierre,3,2),SIGNED)<MONTH(Var_FechaFin)
  AND SUBSTRING(FechaCierre,5,4) = YEAR(Var_FechaFin);

    /* Se Inicializan las Fechas de Pago vacio */
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI =Cre.CreditoID
  SET Dat.FechaCierre =Fecha_Vaciaddmmyyyy
  WHERE Cre.FechTerminacion > Par_FechaCorteBC;

    /* -----------------------------------------------------------------------------
    -- INICIO DE LA FECHA Y MONTO DEL ULTIMO PAGO
  -- Fecha Ultimo Pago. Campo 14
  -- Monto del Ultimo Pago. Campo 45
  -- ----------------------------------------------------------------------------- */
  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
  CREATE TABLE TMPACTFECHAPAGOCRED(
    CreditoID     BIGINT(12),
        AmortizacionID  INT,
    FechaPago     DATE,
    MontoUltPag   DECIMAL(14,2),

    INDEX TMPACTFECHAPAGOCRED (CreditoID),
    INDEX TMPACTFECHAPAGOCRED1 (CreditoID, AmortizacionID)

  );

  /* Si el credito es migrado y no tiene registro en DETALLEPAGCRE
  -- SE TOMA LA FECHA LIQUIDA DE LA CUOTA */
  INSERT INTO TMPACTFECHAPAGOCRED
    SELECT Amo.CreditoID, MAX(Amo.AmortizacionID), Fecha_Vacia, Entero_Cero
    FROM TMPDATOSCTESCREDPAG Cre,
       AMORTICREDITO Amo
    WHERE Cre.CreditoIDSAFI = Amo.CreditoID
      AND Amo.Estatus = EstatusPagado
      AND Amo.FechaLiquida <> Fecha_Vacia
      AND Amo.FechaLiquida <= Var_FechaFin
    GROUP BY Amo.CreditoID;

  DROP TABLE IF EXISTS TMPDETULTIMOPAGO;
  CREATE TABLE TMPDETULTIMOPAGO(
    CreditoID     BIGINT(12),
        MontoPago   DECIMAL(14,2),

    INDEX TMPDETULTIMOPAGO1 (CreditoID)
  );

  INSERT INTO TMPDETULTIMOPAGO
    SELECT  Pag.CreditoID, SUM(MontoTotPago)
      FROM TMPACTFECHAPAGOCRED Tem,
         DETALLEPAGCRE Pag
      WHERE Tem.CreditoID = Pag.CreditoID
              AND Tem.AmortizacionID = Pag.AmortizacionID
        AND Pag.FechaPago  <= Var_FechaFin
      GROUP BY Pag.CreditoID;

  UPDATE TMPACTFECHAPAGOCRED Det, TMPDETULTIMOPAGO Pag SET
    Det.MontoUltPag = Pag.MontoPago
  WHERE Det.CreditoID = Pag.CreditoID;

  UPDATE TMPACTFECHAPAGOCRED Tmp, AMORTICREDITO Amo SET
    Tmp.FechaPago   = Amo.FechaLiquida,
    Tmp.MontoUltPag = (Amo.Capital + Amo.Interes + Amo.IVAInteres)

        WHERE Tmp.MontoUltPag    = Entero_Cero
      AND Tmp.CreditoID    = Amo.CreditoID
          AND Tmp.AmortizacionID = Amo.AmortizacionID;


  UPDATE TMPDATOSCTESCREDPAG Det, TMPACTFECHAPAGOCRED Tem SET
    Det.FechaPago    = DATE_FORMAT(Tem.FechaPago, FormatoFecha),
    Det.MontoUltPago = ROUND(Tem.MontoUltPag, 0)
  WHERE Det.CreditoIDSAFI = Tem.CreditoID
    AND Tem.FechaPago <=  Par_FechaCorteBC;

  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
  DROP TABLE IF EXISTS TMPDETULTIMOPAGO;

  -- Ultimos Pago para los NO migrados que si tienen registros en DETALLEPAGCRE
  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
  CREATE TABLE TMPACTFECHAPAGOCRED(
    CreditoID     BIGINT(12),
    FechaPago   DATE,
        TransaccionID BIGINT,

    INDEX TMPACTFECHAPAGOCRED (CreditoID, FechaPago, TransaccionID)
  );

  INSERT INTO TMPACTFECHAPAGOCRED
    SELECT  Pag.CreditoID, MAX(Pag.FechaPago), MAX(Pag.Transaccion)
      FROM TMPDATOSCTESCREDPAG Tem,
         DETALLEPAGCRE Pag
      WHERE Tem.CreditoIDSAFI = Pag.CreditoID
        AND Pag.FechaPago  <= Var_FechaFin
      GROUP BY Pag.CreditoID;

  DROP TABLE IF EXISTS TMPDETULTIMOPAGO;
  CREATE TABLE TMPDETULTIMOPAGO(
    CreditoID     BIGINT(12),
    FechaPago     DATE,
        MontoPago   DECIMAL(14,2),

    INDEX TMPDETULTIMOPAGO1 (CreditoID)
  );

  INSERT INTO TMPDETULTIMOPAGO
    SELECT  Pag.CreditoID, MAX(Pag.FechaPago), SUM(Pag.MontoTotPago)
      FROM TMPACTFECHAPAGOCRED Tem,
         DETALLEPAGCRE Pag
      WHERE Tem.CreditoId = Pag.CreditoID
        AND Tem.FechaPago = Pag.FechaPago
        AND Tem.TransaccionID = Pag.Transaccion
      GROUP BY Pag.CreditoID;

  UPDATE TMPDATOSCTESCREDPAG Det, TMPDETULTIMOPAGO Tem SET
    Det.FechaPago    = DATE_FORMAT(Tem.FechaPago, FormatoFecha),
    Det.MontoUltPago = ROUND(Tem.MontoPago, 0)
  WHERE Det.CreditoIDSAFI = Tem.CreditoID
    AND Tem.FechaPago <=  Par_FechaCorteBC;

  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
  DROP TABLE IF EXISTS TMPDETULTIMOPAGO;

  -- -------------------------------------------------

  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
  DROP TABLE IF EXISTS TEMP_ULTIMOPAGO;

  UPDATE TMPDATOSCTESCREDPAG Det
    INNER JOIN CREDITOS Cre     ON Det.CreditoIDSAFI  = Cre.CreditoID
    INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID= Pro.ProducCreditoID
  SET Det.Responsabilidad = (CASE Pro.EsGrupal WHEN Str_NO THEN TipoRespIndividual
                         WHEN Str_SI THEN TipoRespMancomunado END),
    Det.TipoCuenta = (CASE Pro.EsRevolvente WHEN Str_NO THEN TipoCtaPagosFijos
                         WHEN Str_SI THEN TipoCtaRevolvente END);

  /* ---------------------------------------------------------------------------------
  -- OBTENEMOS LOS SALDOS DE CARTER AL DIA DE CORTE. REVISADO
  -- ------------------------------------------------------------------------------*/

  DROP TABLE IF EXISTS TMPSALDOSCREDITOCINTABC;

  CREATE TABLE TMPSALDOSCREDITOCINTABC (
    CreditoID       BIGINT NOT NULL,
    Estatus       CHAR(1),
    SaldoAtrasoVencido  DECIMAL(16,2),
    ExigibleSigPeriodo  DECIMAL(16,2),
    PrimerIncumplimiento  DATE,
    SaldoTotal      DECIMAL(14,2),
    NoCuotasAtraso    INT,
    DiasAtraso      INT,
    SaldoInsoluto     DECIMAL(14,2),
    SaldoInteres      DECIMAL(14,2),
    GraciaMoratorios    INT,
    FrecPagos       CHAR(2),
    INDEX (CreditoID)
  );

  INSERT INTO TMPSALDOSCREDITOCINTABC

  SELECT  Tem.CreditoIDSAFI,
      CASE WHEN IFNULL(Sal.EstatusCredito, Cadena_Vacia)  = Cadena_Vacia THEN Tem.Estatus
         ELSE Sal.EstatusCredito
      END,

       (  IFNULL(Sal.SalCapAtrasado, Entero_Cero) + IFNULL(Sal.SalCapVencido , Entero_Cero)+
        IFNULL(Sal.SalIntAtrasado, Entero_Cero) + IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalMoratorios, Entero_Cero) +
        IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SalComFaltaPago, Entero_Cero) + IFNULL(Sal.SaldoComServGar, Entero_Cero) + IFNULL(Sal.SalOtrasComisi, Entero_Cero) ) AS SaldoAtrasoVencido,

      /* El Exigible "Inicial" del Siguiente Periodo es lo atrasado y vencido*/
      ( IFNULL(Sal.SalCapAtrasado, Entero_Cero) + IFNULL(Sal.SalCapVencido, Entero_Cero) +
        IFNULL(Sal.SalIntAtrasado, Entero_Cero) + IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalMoratorios, Entero_Cero) +
        IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SalComFaltaPago, Entero_Cero) + IFNULL(Sal.SaldoComServGar, Entero_Cero) + IFNULL(Sal.SalOtrasComisi, Entero_Cero) ) AS ExigibleSigPeriodo,

      Fecha_Vacia,

      /* Saldo Actual*/
      ( IFNULL(Sal.SalCapVigente, Entero_Cero) + IFNULL(Sal.SalCapAtrasado, Entero_Cero) + IFNULL(Sal.SalCapVencido, Entero_Cero) +
        IFNULL(Sal.SalCapVenNoExi, Entero_Cero) + IFNULL(Sal.SalIntOrdinario, Entero_Cero) + IFNULL(Sal.SalIntAtrasado, Entero_Cero) +
        IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalIntProvision, Entero_Cero) + IFNULL(Sal.SalIntNoConta, Entero_Cero) +
        IFNULL(Sal.SalMoratorios, Entero_Cero) + IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SaldoMoraCarVen, Entero_Cero) +
        IFNULL(Sal.SalComFaltaPago, Entero_Cero) + IFNULL(Sal.SaldoComServGar, Entero_Cero) + IFNULL(Sal.SalOtrasComisi, Entero_Cero)
      ) AS SaldoTotal,                -- Campo 22. Saldo Actual

      IFNULL(Sal.NoCuotasAtraso, Entero_Cero),
      IFNULL(Sal.DiasAtraso, Entero_Cero),

      /* Campo 44. Saldo Insoluto de Capital o Principal*/
      (IFNULL(Sal.salCapVigente, Entero_Cero) + IFNULL(Sal.SalCapAtrasado, Entero_Cero) +
       IFNULL(Sal.SalCapVencido, Entero_Cero) + IFNULL(Sal.SalCapVenNoExi, Entero_Cero) ) AS SaldoInsoluto,

      /* Saldo de Interes Campo. 47*/
      ( IFNULL(Sal.SalIntOrdinario, Entero_Cero) + IFNULL(Sal.SalIntAtrasado, Entero_Cero) +
        IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalIntProvision, Entero_Cero) + IFNULL(Sal.SalIntNoConta, Entero_Cero)
      ) AS SaldoInteres,
      Tem.GraciaMoratorios, Tem.FrecPagos

  FROM TMPDATOSCTESCREDPAG Tem
  LEFT OUTER JOIN SALDOSCREDITOS Sal ON Tem.CreditoIDSAFI = Sal.CreditoID
                     AND Sal.FechaCorte = Par_FechaCorteBC
                     AND Sal.EstatusCredito <> EstatusCastigado
  WHERE Tem.Estatus <> EstatusCastigado;

	-- INICIO Notas de Cargo

	DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOINTFSEM;
	CREATE TEMPORARY TABLE TMPEXIGIBLESNOTASCARGOINTFSEM (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		MontoExigible			DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOINTFSEM;
	CREATE TEMPORARY TABLE TMPPAGOSNOTASCARGOINTFSEM (
		CreditoID				BIGINT(12),
		Monto					DECIMAL(14,2),
		PRIMARY KEY (CreditoID)
	);

	-- Montos de notas de cargo registradas a fecha corte
	INSERT INTO TMPEXIGIBLESNOTASCARGOINTFSEM (	CreditoID,			Monto,									MontoExigible	)
									SELECT		NTC.CreditoID,		ROUND(SUM(ROUND(NTC.Monto, 2)), 2),		Entero_Cero
										FROM	NOTASCARGO NTC
										INNER JOIN TMPSALDOSCREDITOCINTABC TMP ON TMP.CreditoID = NTC.CreditoID AND NTC.FechaRegistro <= Par_FechaCorteBC
										INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = NTC.CreditoID AND NTC.AmortizacionID = AMO.AmortizacionID AND AMO.FechaExigible <= Par_FechaCorteBC
										GROUP BY NTC.CreditoID, AMO.CreditoID;

	-- Montos pagados de notas de cargo a fechas exigibles
	INSERT INTO TMPPAGOSNOTASCARGOINTFSEM (	CreditoID,			Monto	)
								SELECT		DET.CreditoID,		ROUND(SUM(ROUND(DET.MontoNotasCargo, 2)), 2)
									FROM	TMPEXIGIBLESNOTASCARGOINTFSEM TMP
									INNER JOIN DETALLEPAGCRE DET ON DET.CreditoID = TMP.CreditoID AND DET.FechaPago <= Par_FechaCorteBC
									INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID and DET.AmortizacionID = AMO.AmortizacionID AND AMO.FechaExigible <= Par_FechaCorteBC
									GROUP BY DET.CreditoID, AMO.CreditoID;

	-- Exigible de notas de cargo a fecha corte
	UPDATE TMPEXIGIBLESNOTASCARGOINTFSEM NTC
		INNER JOIN TMPPAGOSNOTASCARGOINTFSEM PAG ON NTC.CreditoID = PAG.CreditoID
	SET	NTC.MontoExigible = ROUND(NTC.Monto - PAG.Monto, 2);

	UPDATE TMPEXIGIBLESNOTASCARGOINTFSEM
	SET	MontoExigible = Entero_Cero
	WHERE MontoExigible < Entero_Cero;

	UPDATE TMPSALDOSCREDITOCINTABC TMP
		INNER JOIN TMPEXIGIBLESNOTASCARGOINTFSEM NTC ON NTC.CreditoID = TMP.CreditoID
	SET	TMP.SaldoAtrasoVencido	= ROUND(TMP.SaldoAtrasoVencido + NTC.MontoExigible, 2),
		TMP.ExigibleSigPeriodo	= ROUND(TMP.ExigibleSigPeriodo + NTC.MontoExigible, 2),
		TMP.SaldoTotal			= ROUND(TMP.SaldoTotal + NTC.MontoExigible, 2);

	DROP TEMPORARY TABLE IF EXISTS TMPPAGOSNOTASCARGOINTFSEM;
	DROP TEMPORARY TABLE IF EXISTS TMPEXIGIBLESNOTASCARGOINTFSEM;

	-- FIN Notas de Cargo

  INSERT INTO TMPSALDOSCREDITOCINTABC
  SELECT  CreditoID,EstatusCastigado,
      (SaldoCapital + SaldoInteres + SaldoMoratorio + SaldoAccesorios + SaldoNotCargoRev + SaldoNotCargoSinIVA + SaldoNotCargoConIVA) AS SaldoAtrasoVencido,
      (SaldoCapital + SaldoInteres + SaldoMoratorio + SaldoAccesorios + SaldoNotCargoRev + SaldoNotCargoSinIVA + SaldoNotCargoConIVA) AS ExigibleSinPeriodo,
      Fecha_Vacia AS PrimerIncu,
      (SaldoCapital + SaldoInteres + SaldoMoratorio + SaldoAccesorios + SaldoNotCargoRev + SaldoNotCargoSinIVA + SaldoNotCargoConIVA)  AS SaldoTotal,
      Entero_Cero AS CuotaAtraso,
      DATEDIFF(Par_FechaCorteBC,FecPrimAtraso) AS DiaAtraso,
      SaldoCapital AS Insoluto,
      SaldoInteres AS Interes,
      Tem.GraciaMoratorios,
      Tem.FrecPagos
    FROM CRECASTIGOS AS Cre, TMPDATOSCTESCREDPAG Tem
      WHERE Cre.CreditoID = Tem.CreditoIDSAFI
      AND Fecha BETWEEN Var_FechaInicial AND Par_FechaCorteBC;


  DROP TABLE IF EXISTS TMPNUMPAGCAS;

  CREATE TABLE TMPNUMPAGCAS(
    CreditoID     BIGINT NOT NULL,
    NumPagosAtr   INT,
    INDEX(CreditoID)
  );

  INSERT  INTO TMPNUMPAGCAS
    SELECT Cre.CreditoID, COUNT(Amo.AmortizacionID) AS NumPag
      FROM AMORTICREDITO Amo, CRECASTIGOS Cre
    WHERE Amo.CreditoID = Cre.CreditoID
      AND Amo.FechaLiquida = Cre.Fecha
      AND Cre.Fecha BETWEEN Var_FechaInicial AND Par_FechaCorteBC
      GROUP BY Cre.CreditoID;

  UPDATE TMPSALDOSCREDITOCINTABC Cre, TMPNUMPAGCAS Pag
    SET Cre.NoCuotasAtraso = Pag.NumPagosAtr
  WHERE Cre.CreditoID = Pag.CreditoID;


  -- CALCULO DE LA FECHA DEL PRIMER INCUMPLIMIENTO. CAMPO 43
  DROP TABLE IF EXISTS TMPINCUMPLECINTABC;

  CREATE TABLE TMPINCUMPLECINTABC (
    CreditoID       BIGINT NOT NULL,
    PrimerIncumplimiento  DATE,
    INDEX (CreditoID)
  );

  -- Creditos del Mes que probablemente incumplieron
  INSERT INTO TMPINCUMPLECINTABC
    SELECT  Tem.CreditoID, MIN(Amo.FechaExigible)

      FROM AMORTICREDITO Amo,
         TMPSALDOSCREDITOCINTABC Tem
      WHERE Tem.CreditoID = Amo.CreditoID
        AND Amo.FechaExigible <= Par_FechaCorteBC
        AND (   IFNULL(Amo.FechaLiquida, Fecha_Vacia) = Fecha_Vacia
          OR  (   IFNULL(Amo.FechaLiquida, Fecha_Vacia) != Fecha_Vacia
             AND  DATE_ADD(Amo.FechaExigible, INTERVAL Tem.GraciaMoratorios DAY) < Amo.FechaLiquida
            )
          )
      GROUP BY Tem.CreditoID;

  UPDATE TMPSALDOSCREDITOCINTABC Sal, TMPINCUMPLECINTABC Tem SET
    Sal.PrimerIncumplimiento = Tem.PrimerIncumplimiento
    WHERE Sal.CreditoID = Tem.CreditoID;

  DROP TABLE IF EXISTS TMPINCUMPLECINTABC;


  /* CALCULO DEL MONTO EXIGIBLE SIGUIENTE PERIODO. MONTO A PAGAR CAMPO 12. */
  DROP TABLE IF EXISTS TMPEXISIGPERIODOCINTABC;

  CREATE TABLE TMPEXISIGPERIODOCINTABC (
    CreditoID       BIGINT NOT NULL,
    ExigibleSigPeriodo  DECIMAL(16,2),
    INDEX (CreditoID)
  );

  /* Para Frecuencias de Pago: Diario, Semanal, Catorcenal, Quincenal, Mensual */
  INSERT INTO TMPEXISIGPERIODOCINTABC
    SELECT  Tem.CreditoID, SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres)

      FROM AMORTICREDITO Amo,
         TMPSALDOSCREDITOCINTABC Tem
      WHERE Tem.CreditoID = Amo.CreditoID
        AND Tem.FrecPagos IN ('D','K','M','S','W')
        AND Amo.FechaExigible > Par_FechaCorteBC
        AND Amo.FechaExigible <= Var_Fec_SigPeriodo
        AND ( Amo.Estatus NOT IN ('P','K')
          OR (Amo.Estatus = 'P' AND Amo.FechaLiquida > Var_Fec_SigPeriodo) )
      GROUP BY Tem.CreditoID;

  UPDATE TMPSALDOSCREDITOCINTABC Sal, TMPEXISIGPERIODOCINTABC Tem SET
    Sal.ExigibleSigPeriodo = Sal.ExigibleSigPeriodo + Tem.ExigibleSigPeriodo
    WHERE Sal.CreditoID = Tem.CreditoID;

  DROP TABLE IF EXISTS TMPEXISIGPERIODOCINTABC;

  -- Para Frecuencias "Mayores" a Mensual
  DROP TABLE IF EXISTS TMPEXISIGPERIODOMAYORCINTABC;

  CREATE TABLE TMPEXISIGPERIODOMAYORCINTABC (
    CreditoID       BIGINT NOT NULL,
    AmortizacionID    INT,
    ExigibleSigPeriodo  DECIMAL(16,2),
    INDEX TMPEXISIGPERIODOMAYORCINTABC_1(CreditoID),
    INDEX TMPEXISIGPERIODOMAYORCINTABC_2(CreditoID, AmortizacionID)
  );

  INSERT INTO TMPEXISIGPERIODOMAYORCINTABC
    SELECT  Tem.CreditoID, MIN(AmortizacionID), Entero_Cero

      FROM AMORTICREDITO Amo,
         TMPSALDOSCREDITOCINTABC Tem
      WHERE Tem.CreditoID = Amo.CreditoID
        AND Tem.FrecPagos NOT IN ('D','K','M','S','W')
        AND Amo.FechaExigible > Par_FechaCorteBC
        AND ( Amo.Estatus NOT IN ('P','K')
          OR (Amo.Estatus = 'P' AND Amo.FechaLiquida > Var_Fec_SigPeriodo) )
      GROUP BY Tem.CreditoID;

  UPDATE TMPEXISIGPERIODOMAYORCINTABC Tem, AMORTICREDITO Amo SET
    Tem.ExigibleSigPeriodo = (Amo.Capital + Amo.Interes + Amo.IVAInteres)

    WHERE Tem.CreditoID    = Amo.CreditoID
      AND Tem.AmortizacionID = Amo.AmortizacionID;


  UPDATE TMPSALDOSCREDITOCINTABC Sal, TMPEXISIGPERIODOMAYORCINTABC Tem SET
    Sal.ExigibleSigPeriodo = Sal.ExigibleSigPeriodo + Tem.ExigibleSigPeriodo
    WHERE Sal.CreditoID = Tem.CreditoID;

  DROP TABLE IF EXISTS TMPEXISIGPERIODOMAYORCINTABC;

  /* FIN CALCULO DEL MONTO EXIGIBLE SIGUIENTE PERIODO */

  UPDATE TMPDATOSCTESCREDPAG Dat, TMPSALDOSCREDITOCINTABC Tem SET

    Dat.Incumplimiento  = CASE WHEN Tem.PrimerIncumplimiento = Fecha_Vacia THEN Fecha_Vaciaddmmyyyy
                  ELSE DATE_FORMAT(Tem.PrimerIncumplimiento, FormatoFecha)
                END,

    Dat.SaldoTotal    = CEILING(Tem.SaldoTotal),
    Dat.Vencido     = CEILING(Tem.SaldoAtrasoVencido),
    Dat.NoCuotasAtraso  = Tem.NoCuotasAtraso,
    Dat.Saldo       = ROUND(Tem.SaldoInsoluto, 0),
    Dat.DiasAtraso    = IFNULL(Tem.DiasAtraso-Dat.GraciaMoratorios,-999),
    Dat.Estatus     = CASE WHEN Dat.FecTerminacion <> Fecha_Vacia AND
                    Dat.FecTerminacion <= Var_FechaFin AND Dat.Estatus <>'K' THEN EstatusPagado
                  ELSE Tem.Estatus
                END,

    Dat.FechaUltPagoVen = CASE WHEN Dat.Estatus != EstatusVencido THEN Cadena_Vacia
                  ELSE Dat.FechaUltPagoVen
               END,

    Dat.InteresReportado = Tem.SaldoInteres

    WHERE Dat.CreditoIDSAFI = Tem.CreditoID;

  /* Tabla temporal para dias de atraso de creditos activos */
    DROP TABLE IF EXISTS TMPDIASATRASOCRE;

  CREATE TABLE TMPDIASATRASOCRE (
    CreditoID       BIGINT NOT NULL,
    FechaAtraso     DATE,
    INDEX TMPDIASATRASOCRE_1(CreditoID)
  );

  INSERT INTO TMPDIASATRASOCRE
    SELECT  Tem.CreditoIDSAFI, MAX(Amo.FechaExigible)
  FROM AMORTICREDITO Amo,
     TMPDATOSCTESCREDPAG Tem
  WHERE Tem.CreditoIDSAFI = Amo.CreditoID
    AND Amo.FechaExigible <=Par_FechaCorteBC
          AND Amo.Estatus != EstatusPagado
          GROUP BY Tem.CreditoIDSAFI;

    -- Actualizacion Activos
    UPDATE TMPDATOSCTESCREDPAG Dat, TMPDIASATRASOCRE Tmp SET
    Dat.FechaAtraso = Tmp.FechaAtraso
  WHERE Dat.CreditoIDSAFI = Tmp.CreditoID
    AND Dat.DiasAtraso=-999;

  /*Calculo dias atraso activos */
  UPDATE TMPDATOSCTESCREDPAG Dat SET
    Dat.DiasAtraso = (DATEDIFF(Par_FechaCorteBC, Dat.FechaAtraso)-Dat.GraciaMoratorios)
  WHERE Dat.FechaAtraso <> Fecha_Vacia
   AND Dat.DiasAtraso=-999;

  /*Consideracion de dias de gracia*/
  UPDATE TMPDATOSCTESCREDPAG Dat SET
    Dat.Vencido = Entero_Cero,
    Dat.DiasAtraso = Entero_Cero,
        Dat.Incumplimiento = Fecha_Vaciaddmmyyyy
  WHERE Dat.DiasAtraso <= Entero_Cero;

  DROP TABLE IF EXISTS TMPSALDOSCREDITOCINTABC;

  UPDATE TMPDATOSCTESCREDPAG
    SET ImportePagos = FUNCIONIMPORTEPAGO(CreditoIDSAFI,Par_FechaCorteBC);

  -- == Se mensualiza El Monto de Pagos (ImportePago) ========
  DROP TABLE IF EXISTS TMPMONTOCUOTACREDITO;

  CREATE TABLE TMPMONTOCUOTACREDITO (
    CreditoID BIGINT(12),
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

  -- ---------------------------------------------------------
  -- INICIA EL CALCULO DEL MOP. Manner of Payment, Campo 26
  -- ---------------------------------------------------------
  UPDATE TMPDATOSCTESCREDPAG Dat SET
    MOP = CASE WHEN   Dat.Estatus = EstatusVigente
            AND Dat.DiasAtraso = Entero_Cero
            AND DATEDIFF(Par_FechaCorteBC, Dat.InicioCredito) < DiasCtaReciente THEN Mop00

          WHEN  ( Dat.Estatus IN(EstatusVigente,EstatusVencido,EstatusAtrasado)
                AND Dat.DiasAtraso = Entero_Cero
                AND Dat.Vencido = Entero_Cero
                AND DATEDIFF(Par_FechaCorteBC, Dat.InicioCredito) >= DiasCtaReciente)
              OR  FechaCierre <> Fecha_Vaciaddmmyyyy THEN Mop01

          WHEN Dat.DiasAtraso  BETWEEN 1 AND 29 THEN Mop02
          WHEN Dat.DiasAtraso  BETWEEN 30 AND 59 THEN Mop03
          WHEN Dat.DiasAtraso  BETWEEN 60 AND 89 THEN Mop04
          WHEN Dat.DiasAtraso  BETWEEN 90 AND 119 THEN Mop05
          WHEN Dat.DiasAtraso  BETWEEN 120 AND 149 THEN Mop06
          WHEN Dat.DiasAtraso  BETWEEN 150 AND 365 THEN Mop07
          WHEN Dat.DiasAtraso  > 365 THEN Mop96
                    ELSE Cadena_Vacia
        END;

  -- REVISADO. TODO REVISAR CLAVES Y MOPS
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN  CRECASTIGOS Cas ON Dat.CreditoIDSAFI = Cas.CreditoID SET

    Dat.FechaCierre   = DATE_FORMAT(Cas.Fecha, FormatoFecha),
    Dat.ClaveObervacion = ClaveObsCtaCast,
        Dat.ImportePagos  = Dat.Saldo,
    Dat.MOP       = Mop97

    WHERE Dat.Estatus = EstatusCastigado
      AND Cas.Fecha <= Par_FechaCorteBC;

  /* SI HAN TRANSCURRIDO MAS DE 3 MESES DESDE LA FECHA DE INICIO DEL CREDITO A LA FECHA DE CORTE
   * Y TIENE UN MOP 00 (MUY RECIENTE PARA SER CALIFICADA
   * Y CON FRECUENCIA SEMESTRAL, ANUAL O UNICO, ENTONCES SE LE ASIGNA MOP 01 (CUENTA AL CORRIENTE) */

  UPDATE TMPDATOSCTESCREDPAG Dat SET
    Dat.MOP = MopUR
    WHERE DATEDIFF(Var_FechaCorte, STR_TO_DATE(Dat.FechaInicio, FormatoFecha)) > DiasTresMeses
      AND IFNULL(Dat.MOP, Mop00) = Mop00
      AND Dat.FrecPagos = FrecSemestralBC;

  /* SI ES PAGO UNICO O ANUAL Y TIENE UN MOP 00*/
  UPDATE TMPDATOSCTESCREDPAG  SET
    MOP = MopUR
    WHERE IFNULL(MOP, Cadena_Vacia) = Cadena_Vacia
      AND FrecPagos IN(FrecAnualBC, FrecVariableBC);

    -- nuevos calculos MOP
  UPDATE TMPDATOSCTESCREDPAG  SET
    MOP=Mop00
  WHERE CONVERT(SUBSTRING(FechaInicio,3,2),SIGNED)=MONTH(Var_FechaFin)
    AND SUBSTRING(FechaInicio,5,4) <= YEAR(Var_FechaFin)
        AND MOP=IFNULL(MOP,Mop01)=Mop01
        AND FechaPago=Fecha_Vaciaddmmyyyy;

  DELETE FROM TMPDATOSCTESCREDPAG
  WHERE  FechaCierre != Fecha_Vaciaddmmyyyy AND FechaCierre != Cadena_Vacia
    AND CONVERT(SUBSTRING(FechaCierre,3,2),SIGNED)<MONTH(Var_FechaFin)
    AND SUBSTRING(FechaCierre,5,4) <= YEAR(Var_FechaFin);
  -- FIN DEL CALCULO DEL MOP

  UPDATE TMPDATOSCTESCREDPAG
    SET Telefono = Cadena_Vacia
  WHERE LENGTH(Telefono) <> Entero_Diez;

  UPDATE TMPDATOSCTESCREDPAG
    SET Telefono2 = Cadena_Vacia
  WHERE LENGTH(Telefono2) <> Entero_Diez;

  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN MONEDAS  Mon ON Dat.MonedaID = Mon.MonedaID
  SET Dat.Moneda = Mon.EqBuroCred;

    UPDATE TMPDATOSCTESCREDPAG Dat
    SET Dat.Cuenta = CASE IFNULL(Dat.CreditoIDCte,Cadena_Vacia) WHEN Cadena_Vacia
            THEN Dat.CreditoIDSAFI
            ELSE Dat.CreditoIDCte END ;

  -- Limpieza nombre del cliente
  UPDATE TMPDATOSCTESCREDPAG SET
    ApellidoPaterno = FNLIMPIACARACTBUROCRED(ApellidoPaterno,LimpiaAlfabetico),
    ApellidoMaterno = FNLIMPIACARACTBUROCRED(ApellidoMaterno,LimpiaAlfabetico),
    PrimerNombre    = FNLIMPIACARACTBUROCRED(PrimerNombre,LimpiaAlfabetico),
    SegundoNombre = FNLIMPIACARACTBUROCRED(SegundoNombre,LimpiaAlfabetico),
    TercerNombre  = FNLIMPIACARACTBUROCRED(TercerNombre,LimpiaAlfabetico),
    Prefijo     = FNLIMPIACARACTBUROCRED(Prefijo,LimpiaAlfabetico),
    CalleNumero   = FNLIMPIACARACTBUROCRED(CalleNumero,LimpiaAlfaNumerico),
    DirComplemento  = FNLIMPIACARACTBUROCRED(DirComplemento,LimpiaAlfaNumerico),
    Colonia     = FNLIMPIACARACTBUROCRED(Colonia,LimpiaAlfaNumerico),
    Ciudad      = FNLIMPIACARACTBUROCRED(Ciudad,LimpiaAlfaNumerico),
    Municipio   = FNLIMPIACARACTBUROCRED(Municipio,LimpiaAlfaNumerico),
    Estado      = FNLIMPIACARACTBUROCRED(Estado,LimpiaAlfabetico),
    Empresa     = FNLIMPIACARACTBUROCRED(Empresa,LimpiaAlfaNumerico),
    CalleNumero2  = FNLIMPIACARACTBUROCRED(CalleNumero2,LimpiaAlfaNumerico),
    DirComplemento2 = FNLIMPIACARACTBUROCRED(DirComplemento2,LimpiaAlfaNumerico),
    Colonia2    = FNLIMPIACARACTBUROCRED(Colonia2,LimpiaAlfaNumerico),
    Ciudad2     = FNLIMPIACARACTBUROCRED(Ciudad2,LimpiaAlfaNumerico),
    Municipio2    = FNLIMPIACARACTBUROCRED(Municipio2,LimpiaAlfaNumerico),
    Estado2     = FNLIMPIACARACTBUROCRED(Estado,LimpiaAlfabetico),
        TercerNombre  = IFNULL(TercerNombre,Cadena_Vacia),
    SegundoNombre = TRIM(CONCAT(SegundoNombre,' ',TercerNombre)),
        -- funcion que limpia direcciones
        CalleNumero   = FNLIMPIADIRBUROCRED(CalleNumero),
    CalleNumero2  = FNLIMPIADIRBUROCRED(CalleNumero2);
  -- Cambio de Orden Apellidos si se carece de Apellido Paterno
     UPDATE TMPDATOSCTESCREDPAG SET
    ApellidoPaterno = ApellidoMaterno,
          ApellidoMaterno = Cadena_Vacia
  WHERE ApellidoPaterno = 'X';

    UPDATE TMPDATOSCTESCREDPAG SET
    ApellidoPaterno = NombreNoProporcionado
  WHERE ApellidoPaterno=Cadena_Vacia;

    UPDATE TMPDATOSCTESCREDPAG SET
    ApellidoMaterno = NombreNoProporcionado
  WHERE ApellidoMaterno=Cadena_Vacia;

  UPDATE TMPDATOSCTESCREDPAG CRE
    INNER JOIN CREDITOSPLAZOS PLA ON CRE.PlazoID = PLA.PlazoID
  SET CRE.PlazoCredito = PLA.Dias / Factor_Meses;

  -- Actualizamos la nacionalidad del domicilio de cliente
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN PAISES Pa ON Dat.PaisResidencia = Pa.PaisID
  SET NacDomicilio = Pa.EqBuroCred;

  -- Actualizamos la nacionalidad del cliente
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN PAISES Pa ON Dat.PaisID = Pa.PaisID
  SET Nacionalidad = Pa.EqBuroCred;

    -- Actaulizacion telefono
  UPDATE TMPDATOSCTESCREDPAG Dat SET
    Dat.Telefono =
      CASE WHEN LENGTH(Dat.Telefono) != 10 THEN
        Cadena_Vacia
      ELSE
        Dat.Telefono END;

  /*Se indica los dias de Vencimiento de pago del Credito*/
  UPDATE TMPDATOSCTESCREDPAG Dat
    INNER JOIN (SELECT CreditoID,MIN(FechaVencim) AS FechaVencim
            FROM AMORTICREDITO WHERE Estatus IN(EstatusVigente,EstatusVencido,EstatusAtrasado) GROUP BY CreditoID)AS cre
        ON Dat.CreditoIDSAFI=cre.CreditoID
  SET Dat.FechaUltPagoVen = DATE_FORMAT(cre.FechaVencim,FormatoFecha)
  WHERE Dat.Estatus IN(EstatusVencido,EstatusAtrasado,EstatusVigente)
    AND cre.FechaVencim<= Var_FechaFin
    AND Dat.DiasAtraso > Entero_Cero;

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

    -- ACTUALIZACION PARA CREDITOS CON FECHA DE VENCIMIENTO
    UPDATE TMPDATOSCTESCREDPAG SET
    SaldoTotal    = Entero_Cero,
        NoCuotasAtraso  = Entero_Cero,
        Incumplimiento  = Fecha_Vaciaddmmyyyy,
        ImportePagos  = Entero_Cero
  WHERE FechaCierre   != Fecha_Vaciaddmmyyyy
    AND Estatus <> EstatusCastigado;

    UPDATE TMPDATOSCTESCREDPAG SET
    Prefijo = PrefijoSRTA
  WHERE Prefijo   = PrefijoSRITA;

    UPDATE TMPDATOSCTESCREDPAG SET
    NoCuotasAtraso = Entero_Cero
  WHERE MOP IN(Mop00,Mop01,MopUR);

    -- Dias de atraso > 999
    UPDATE TMPDATOSCTESCREDPAG SET
    DiasAtraso = 999
  WHERE DiasAtraso>=999;

  /* SI ES DE FRECUENCIA VARIABLE Y EL IMPORTE DE PAGO ES CERO ENTONCES SE SETEA CON EL SALDO TOTAL */
     UPDATE TMPDATOSCTESCREDPAG SET
    ImportePagos = SaldoTotal
  WHERE FrecPagos = FrecVariableBC AND IFNULL(ImportePagos, Entero_Cero) = Entero_Cero;

    -- Actualizacion fecha cierre para creditos pagados
  DROP TABLE IF EXISTS TMPFECHACIERREBC;

  CREATE TABLE TMPFECHACIERREBC (
    CreditoID       BIGINT NOT NULL,
    FechaUltimaAmo    DATE,
    INDEX (CreditoID)
  );

  -- Creditos del Mes que probablemente incumplieron
  INSERT INTO TMPFECHACIERREBC
    SELECT  Tem.CreditoIDSAFI, MAX(Amo.FechaLiquida)
      FROM AMORTICREDITO Amo,
         TMPDATOSCTESCREDPAG Tem
      WHERE Tem.CreditoIDSAFI = Amo.CreditoID
        AND Tem.FechaCierre   = Fecha_Vaciaddmmyyyy
        AND Tem.Estatus = EstatusPagado
        AND Tem.Saldo = Entero_Cero
        AND Tem.ImportePagos = Entero_Cero
              AND Tem.SaldoTotal = Entero_Cero
       GROUP BY Tem.CreditoIDSAFI;

  UPDATE TMPDATOSCTESCREDPAG Dat, TMPFECHACIERREBC Tem SET
    Dat.FechaCierre =  DATE_FORMAT(Tem.FechaUltimaAmo,FormatoFecha)
  WHERE Dat.CreditoIDSAFI = Tem.CreditoID;

  DROP TABLE IF EXISTS TMPFECHACIERREBC;

    /*Actualizacion para creditos pagados con MOP NULL*/
    UPDATE TMPDATOSCTESCREDPAG  SET
    MOP=Mop01
  WHERE Estatus = EstatusPagado
     AND MOP = Cadena_Vacia
       AND DiasAtraso = Entero_Cero
     AND Vencido = Entero_Cero;

    UPDATE TMPDATOSCTESCREDPAG SET
    FechaCierre = Cadena_Vacia
  WHERE FechaCierre   = Fecha_Vaciaddmmyyyy;

    -- Actualizacion para bcreditos renovados que tengan fecha de ingreso a cartera vencida
    UPDATE TMPDATOSCTESCREDPAG Dat SET
    Dat.FechaUltPagoVen =  Cadena_Vacia
  WHERE Dat.TipoCredito = 'R'
    AND Dat.Incumplimiento= Fecha_Vaciaddmmyyyy;

    -- obtener claves de observacion de la tabla CLAVEOBSERVACIONBC
    UPDATE TMPDATOSCTESCREDPAG Dat, CLAVEOBSERVACIONBC Cla SET
    Dat.ClaveObervacion=Cla.ClaveObservaBC
  WHERE Dat.CreditoIDSAFI = Cla.CreditoID
    AND Cla.ClaveObservaBC IN(ClavePC,ClaveSG)
    AND Dat.SaldoTotal> Entero_Cero
        AND Dat.Vencido > Entero_Cero
        AND Dat.FechaCierre= Cadena_Vacia
        AND Dat.MOP NOT IN(Mop00,Mop01,MopUR);

    /*Actualizacion para los créditos renovados que nacen con estatus B por liquidación anticipada Ticket 5338*/
    UPDATE TMPDATOSCTESCREDPAG Dat  SET
    Dat.MOP=Mop01
  WHERE Dat.Estatus = EstatusVencido
     AND Dat.MOP = Cadena_Vacia
       AND Dat.DiasAtraso = Entero_Cero
     AND Dat.Vencido = Entero_Cero
     AND Dat.TipoCredito = EstatusRenovado;

    UPDATE TMPDATOSCTESCREDPAG SET
    FechaCierre = Cadena_Vacia
  WHERE FechaCierre   = Fecha_Vaciaddmmyyyy;

  -- Se actualiza el campo Fecha de Incumplimiento cuando la fecha es menor a la fecha de Apertura
  DROP TABLE IF EXISTS TMPFECHAINCUMP;

  CREATE TABLE TMPFECHAINCUMP (
    CreditoIDSAFI       BIGINT NOT NULL,
    Incumplimiento    DATE,
    INDEX (CreditoIDSAFI)
  );

  INSERT INTO TMPFECHAINCUMP
    SELECT Dat.CreditoIDSAFI, MIN(Amo.FechaExigible) AS Incumplimiento
    FROM TMPDATOSCTESCREDPAG Dat
        INNER JOIN AMORTICREDITO Amo
    WHERE  STR_TO_DATE(Dat.FechaInicio,'%d%m%Y') < Amo.FechaExigible
    GROUP BY Dat.CreditoIDSAFI;

  UPDATE TMPDATOSCTESCREDPAG Dat INNER JOIN TMPFECHAINCUMP Fech ON Dat.CreditoIDSAFI = Fech.CreditoIDSAFI SET
    Dat.Incumplimiento  =   DATE_FORMAT(Fech.Incumplimiento, FormatoFecha)
  WHERE Dat.Incumplimiento != Fecha_Vaciaddmmyyyy AND  STR_TO_DATE(Dat.FechaInicio,'%d%m%Y') > STR_TO_DATE( Dat.Incumplimiento,'%d%m%Y');

  SET Var_FechaCorteStr :=  DATE_FORMAT(Var_FechaCorte,FormatoFecha) ;

    IF(Par_TipoFormatoCinta = Entero_Tres)THEN

		UPDATE TMPDATOSCTESCREDPAG Dat SET
		Cinta = CONCAT_WS(Separador,
        IFNULL(Dat.CreditoIDSAFI,Cadena_Vacia),         IFNULL(Dat.Responsabilidad,Cadena_Vacia),       IFNULL(Dat.TipoCuenta,TipoCtaPagosFijos),
        IFNULL(Dat.TipoContrato,Cadena_Vacia),          IFNULL(Dat.Moneda,Cadena_Vacia),                Cadena_Vacia,
        IFNULL(Dat.FrecPagos,Cadena_Vacia),             IFNULL(Dat.ImportePagos,Cadena_Vacia),          IFNULL(Dat.FechaInicio,Cadena_Vacia),
        IFNULL(Dat.FechaPago,Cadena_Vacia),             IFNULL(Dat.FechaInicio,Cadena_Vacia),           Cadena_Vacia,
        Var_Fecha,                              		    IFNULL(Dat.MontoCredito,Cadena_Vacia),          IFNULL(Dat.SaldoTotal,Cadena_Vacia),
        Entero_Cero,           							            Cadena_Vacia,                                   IFNULL(Dat.MOP,Cadena_Vacia),
        Cadena_Vacia,         							            Var_SegmentoEXT),

		  Cinta= CONCAT(Cinta,Separador,Salto_Linea);

        SET Var_Cinta 		:=	Var_EncabezadoCVS;
        SET Var_ClienteID	:= Entero_Cero;

			INSERT INTO BUROCREDINTFMEN
					(CintaID,		ClienteID,		Clave,		Fecha,				Cinta)
			VALUES	(Var_CintaID,	Entero_Cero,	Var_Member,	Par_FechaCorteBC,	Var_Cinta);

			INSERT INTO BUROCREDINTFMEN
			(CintaID,		ClienteID,			Clave,		Fecha,				Cinta)
			SELECT  Var_CintaID,	Dat.ClienteID,	Var_Member,	Par_FechaCorteBC,	Dat.Cinta
				FROM TMPDATOSCTESCREDPAG Dat;

			SELECT COUNT(*) INTO Var_ConteoReg FROM BUROCREDINTFMEN WHERE Fecha = Par_FechaCorteBC;
      SET Var_ConteoReg :=Var_ConteoReg-Entero_Uno;
			SELECT SUM(SaldoTotal), SUM(Vencido)
			INTO Var_SaldosTotal, Var_SaldosVig FROM TMPDATOSCTESCREDPAG;

			SET Var_Cinta		:= Cadena_Vacia;
			SET Var_Cinta		:=CONCAT(Var_FinEXT,Separador,Var_ConteoReg,Separador,Var_SaldosTotal,Separador,Var_SaldosVig,Separador,Var_SegmentoEXT,Separador);

			INSERT INTO BUROCREDINTFMEN
					(CintaID,		ClienteID,		Clave,		Fecha,				Cinta)
			VALUES	(Var_CintaID,	Entero_Cero,	Var_Member,	Par_FechaCorteBC,	Var_Cinta);

		ELSE

		UPDATE TMPDATOSCTESCREDPAG Dat SET
		Cinta = CONCAT_WS(Separador,
			Var_Member,			Var_NombreEmp,				Var_FechaCorteStr,								IFNULL(Dat.ApellidoPaterno,Cadena_Vacia),		IFNULL(Dat.ApellidoMaterno,NombreNoProporcionado),
			Cadena_Vacia,		IFNULL(Dat.PrimerNombre,Cadena_Vacia),										IFNULL(Dat.SegundoNombre,Cadena_Vacia),			IFNULL(Dat.FechaNacimiento,Cadena_Vacia),
			IFNULL(Dat.RFC,Cadena_Vacia),					IFNULL(Dat.Prefijo,Cadena_Vacia),				IFNULL(Dat.Nacionalidad,Cadena_Vacia),			IFNULL(Dat.EstadoCivil,Soltero_BC),
            IFNULL(Dat.Sexo,Cadena_Vacia),					Cadena_Vacia,		Cadena_Vacia,				IFNULL(Dat.CalleNumero,Cadena_Vacia),			IFNULL(Dat.DirComplemento,Cadena_Vacia),
            IFNULL(Dat.Colonia,Cadena_Vacia),				IFNULL(Dat.Municipio,Cadena_Vacia),				IFNULL(Dat.Ciudad,Cadena_Vacia),	 			IFNULL(Dat.Estado,Cadena_Vacia),
            IFNULL(Dat.CP,Cadena_Vacia),					IFNULL(Dat.Telefono,Cadena_Vacia), 	 			IFNULL(Dat.NacDomicilio,Cadena_Vacia),			IFNULL(Dat.Empresa,Cadena_Vacia),
            IFNULL(Dat.CalleNumero2,Cadena_Vacia), 			IFNULL(Dat.DirComplemento2,Cadena_Vacia),		IFNULL(Dat.Colonia2,Cadena_Vacia),				IFNULL(Dat.Municipio2,Cadena_Vacia),
			IFNULL(Dat.Ciudad2,Cadena_Vacia),				IFNULL(Dat.Estado2,Cadena_Vacia), 				IFNULL(Dat.CP2,Cadena_Vacia),					IFNULL(Dat.Telefono2,Cadena_Vacia),
			IFNULL(Dat.Salario,Cadena_Vacia),				IFNULL(Dat.NacDomicilio,Cadena_Vacia), 			Var_Member,				Var_NombreEmp, 			IFNULL(Dat.Cuenta,Cadena_Vacia),
            IFNULL(Dat.Responsabilidad,Cadena_Vacia),		IFNULL(Dat.TipoCuenta,TipoCtaPagosFijos),		IFNULL(Dat.TipoContrato,Cadena_Vacia),			IFNULL(Dat.Moneda,Cadena_Vacia),
            IFNULL(Dat.NPagos,Cadena_Vacia),				IFNULL(Dat.FrecPagos,Cadena_Vacia),				IFNULL(Dat.FechaInicio,Cadena_Vacia),			IFNULL(Dat.ImportePagos,Cadena_Vacia),
			IFNULL(Dat.FechaPago,Cadena_Vacia),  			IFNULL(Dat.FechaInicio,Cadena_Vacia),			IFNULL(Dat.FechaCierre,Cadena_Vacia),			Var_FechaCorteStr,
            IFNULL(Dat.MontoCredito,Cadena_Vacia),			IFNULL(Dat.SaldoTotal,Cadena_Vacia), 			Entero_Cero, 									IFNULL(Dat.Vencido,Cadena_Vacia),
			IFNULL(Dat.NoCuotasAtraso,Cadena_Vacia),		Dat.MOP,										IFNULL(Dat.ClaveObervacion,Cadena_Vacia),		Cadena_Vacia,
            Cadena_Vacia,				Cadena_Vacia,		IFNULL(Dat.Incumplimiento,Cadena_Vacia),		IFNULL(Dat.Saldo,Cadena_Vacia), 				IFNULL(Dat.MontoUltPago,Cadena_Vacia),
            IFNULL(Dat.PlazoCredito,Cadena_Vacia),			IFNULL(Dat.MontoCredito,Cadena_Vacia),			IFNULL(Dat.FechaUltPagoVen,Cadena_Vacia),		IFNULL(Dat.InteresReportado,Cadena_Vacia),
            IFNULL(Dat.MOP,MopUR),							IFNULL(Dat.DiasAtraso,Cadena_Vacia)),

		Cinta= CONCAT(Cinta,Separador,Dat.CorreoElect,Salto_Linea);

		SET Var_Cinta 		:=	Var_EncabezadoCVS;
        SET Var_ClienteID	:= Entero_Cero;

		INSERT INTO BUROCREDINTFMEN
				(CintaID,		ClienteID,		Clave,		Fecha,				Cinta)
		VALUES	(Var_CintaID,	Entero_Cero,	Var_Member,	Par_FechaCorteBC,	Var_Cinta);

		INSERT INTO BUROCREDINTFMEN
		(CintaID,		ClienteID,			Clave,		Fecha,				Cinta)
		SELECT  Var_CintaID,	Dat.ClienteID,	Var_Member,	Par_FechaCorteBC,	Dat.Cinta
			FROM TMPDATOSCTESCREDPAG Dat;

		END IF;

  DROP TABLE IF EXISTS TMPDATOSCTESCREDPAG;

END TerminaStore$$
