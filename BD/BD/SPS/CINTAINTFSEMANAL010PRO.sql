-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CINTAINTFSEMANAL010PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CINTAINTFSEMANAL010PRO`;
DELIMITER $$

CREATE PROCEDURE `CINTAINTFSEMANAL010PRO`(
/* SP PARA CINTA DE BURO DE CREDITO SEMANAL FORMATO CSV  PARA CONSOL*/
	Par_FechaCorteBC 	DATE,
	Par_CintaBCID		INT(11),
	Par_TipoFormatoCinta	INT(11),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,

    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN

	DECLARE TEST 					VARCHAR(20);
	DECLARE Var_Cinta 				VARCHAR(60000);
	DECLARE LONGITUD 				DECIMAL;
	DECLARE Var_ClienteID 			INT;
	DECLARE Var_ApellidoPaterno 	VARCHAR(26);
	DECLARE Var_ApellidoMaterno		VARCHAR(26);
	DECLARE Var_Adicional			VARCHAR(26);
	DECLARE Var_PrimerNombre		VARCHAR(26);
	DECLARE Var_SegundoNombre		VARCHAR(26);
	DECLARE Var_TercerNombre		VARCHAR(26);
	DECLARE Var_Segundo				VARCHAR(40);
	DECLARE Var_FechaNacimiento		CHAR(10);
	DECLARE Var_RFC 				VARCHAR(40);
	DECLARE Var_Prefijo 			VARCHAR(40);
	DECLARE Var_EstadoCivil			VARCHAR(40);
	DECLARE Var_Sexo				VARCHAR(40);
	DECLARE Var_FDef				VARCHAR(40);
	DECLARE Var_InDef				VARCHAR(40);
	DECLARE Var_CalleNumero			VARCHAR(80);
	DECLARE Var_Colonia				VARCHAR(80);
	DECLARE Var_Municipio			VARCHAR(80);
	DECLARE Var_estado				VARCHAR(40);
	DECLARE Var_CP	 				VARCHAR(40);
	DECLARE Var_Telefono 			VARCHAR(40);
	DECLARE Var_member				VARCHAR(40);
	DECLARE Var_nombre				VARCHAR(40);
	DECLARE Var_Cuenta				VARCHAR(40);
	DECLARE Var_CuentaAux			VARCHAR(40);
	DECLARE Var_Responsabilidad		VARCHAR(40);
	DECLARE Var_TipoCuenta	 		VARCHAR(40);
	DECLARE Var_TipoContrato		VARCHAR(40);
	DECLARE Var_Moneda				VARCHAR(40);
	DECLARE Var_NPagos				VARCHAR(40);
	DECLARE Var_FrecPagos			VARCHAR(40);
	DECLARE Var_saldo				VARCHAR(40);
	DECLARE Var_vencido				VARCHAR(40);
	DECLARE Var_FechaInicio			VARCHAR(40);
	DECLARE Var_MontoCredito		VARCHAR(40);
	DECLARE Var_ImportePagos		BIGINT;
	DECLARE Var_ImportePagosStr		VARCHAR(40);
	DECLARE Var_Incumplimiento 		VARCHAR(40);
	DECLARE Var_LimiteCred 			VARCHAR(40);
	DECLARE Var_FechaCompra 		VARCHAR(40);
	DECLARE Var_FechaReporte 		VARCHAR(40);
	DECLARE Var_FechaCierre 		VARCHAR(40);
	DECLARE Var_NPagosVencidos 		VARCHAR(40);
	DECLARE Var_NDiasAtraso 		INT(11);
	DECLARE Var_MOP 				VARCHAR(40);
	DECLARE Var_MOPInteres			VARCHAR(40);
	DECLARE Var_UltimoPago 			VARCHAR(40);
	DECLARE Var_SVigente 			INT(14) DEFAULT 0;
	DECLARE Var_SVencido 			INT(14) DEFAULT 0;
	DECLARE Var_NSegmentos 			INT(5) DEFAULT 0;
	DECLARE Var_FechaCorte			DATE;
    DECLARE Var_FechaCorteStr		VARCHAR(8);
	DECLARE Var_SaldoTotal 			VARCHAR(40);
	DECLARE hayRegistros 			BOOLEAN DEFAULT TRUE;

	DECLARE `Member`					VARCHAR(40);
	DECLARE NombreEmp				VARCHAR(100);
	DECLARE Formato_Envio			VARCHAR(20);
	DECLARE EncabezadoCVS			VARCHAR(1500);
	DECLARE Var_CintaID				INT;

	DECLARE Var_ApellidoAdicional  	VARCHAR(1);
	DECLARE Var_FechaDefuncion		VARCHAR(1);
	DECLARE Var_IndicadorDef		VARCHAR(1);
	DECLARE Var_DirComplemento		VARCHAR(100);
	DECLARE Var_Ciudad				VARCHAR(50);
	DECLARE Var_Empresa				VARCHAR(99);
	DECLARE Var_CalleNumero2		VARCHAR(40);
	DECLARE Var_DirComplemento2		VARCHAR(41);
	DECLARE Var_Colonia2			VARCHAR(41);
	DECLARE Var_Municipio2			VARCHAR(41);
	DECLARE Var_Ciudad2				VARCHAR(41);
	DECLARE Var_Estado2				VARCHAR(40);
	DECLARE Var_CP2					VARCHAR(8);
	DECLARE Var_Telefono2			VARCHAR(40);
	DECLARE Var_Salario				VARCHAR(10);
	DECLARE Var_ClaveObservacion	VARCHAR(3);
	DECLARE Var_ClaveOtorAnt		VARCHAR(20);
	DECLARE Var_NombreOtorAnt		VARCHAR(40);
	DECLARE Var_NumCtaAnterior		VARCHAR(40);
	DECLARE Var_FechaAnterior		DATE;
	DECLARE Var_MontoUltPago		INT(11);
	DECLARE Var_MontoUltPagoCHAR	VARCHAR(40);
	DECLARE Var_DiasTrans			VARCHAR(40);
	DECLARE Var_DiasPago			VARCHAR(40);
	DECLARE Var_FechaRep			VARCHAR(40);
	DECLARE Var_InteresReportado	VARCHAR(40);
	DECLARE Fec_SigPeriodo			DATE;

	DECLARE EstatusPagado   		CHAR(1);
	DECLARE EstatusVigente  		CHAR(1);
	DECLARE EstatusCastigado 		CHAR(1);
	DECLARE EstatusVencido 			CHAR(1);
    DECLARE EstatusAtrasado			CHAR(1);
	DECLARE DiasCtaReciente 		INT;
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Espacio_Blanco  		CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Entero_Uno 				INT;
	DECLARE Formato_Cinta			VARCHAR(8);
	DECLARE Formato_Comas   		VARCHAR(8);
	DECLARE Separador 				CHAR(1);
	DECLARE Salto_Linea 			VARCHAR(2);
	DECLARE Casado_BS				CHAR(2);
	DECLARE Casado_BM				CHAR(2);
	DECLARE Casado_BMC				CHAR(2);
	DECLARE Viudo					CHAR(1);
	DECLARE Union_libre				CHAR(1);
	DECLARE Casado_BC 				CHAR(1);
	DECLARE Union_libreBC 			CHAR(1);
	DECLARE Viudo_BC 				CHAR(1);
	DECLARE EdoSeparado				CHAR(2);
	DECLARE Soltero_BC				CHAR(1);

	DECLARE SI_DiaHabil				CHAR(1);
	DECLARE No_DiaHabil				CHAR(1);
	DECLARE DiasMaxReporte 			INT(2);
	DECLARE	Fecha_Vaciaddmmyyyy 	CHAR(8);
	DECLARE Var_TipoPersona			CHAR(1);
	DECLARE FechaMigracion			CHAR(8);
	DECLARE	Var_PromagraID			VARCHAR(15);
	DECLARE Entero_Diez				INT(2);
	DECLARE Var_FechaFin			DATE;
	DECLARE Var_FechaInicial		DATE;

	DECLARE Factor_Meses 			DECIMAL(12,2);
	DECLARE Var_PlazoMeses			VARCHAR(6);
	DECLARE Var_Nacionalidad		CHAR(5);
	DECLARE Var_NacDomicilio		CHAR(5);
	DECLARE Var_NacDomicilio2		CHAR(5);
	DECLARE Var_DiaAtrFecFinCre		VARCHAR(11);
	DECLARE Var_CorreoElect			VARCHAR(50);
	DECLARE Var_FechaUltPagoVen		VARCHAR(10);

	DECLARE TipoPersFisica			CHAR(1);
	DECLARE TipoDomTrabajo			INT(11);
	DECLARE PaisMexico				INT(11);
	DECLARE DomicilioConocido		VARCHAR(50);
	DECLARE SinNumero				VARCHAR(5);
	DECLARE CalleConocido			VARCHAR(12);
	DECLARE CalleConocida			VARCHAR(12);
	DECLARE FormatoFecha			VARCHAR(10);
	DECLARE FormatoFechaInicio		VARCHAR(10);
	DECLARE Str_SI					CHAR(1);
	DECLARE Str_NO					CHAR(1);
	DECLARE LimpiaAlfabetico		VARCHAR(2);
	DECLARE LimpiaAlfaNumerico		VARCHAR(2);

	DECLARE MopUR					VARCHAR(3);
	DECLARE Mop00					VARCHAR(3);
	DECLARE Mop01					VARCHAR(3);
	DECLARE Mop02					VARCHAR(3);
	DECLARE Mop03					VARCHAR(3);
	DECLARE Mop04					VARCHAR(3);
	DECLARE Mop05					VARCHAR(3);
	DECLARE Mop06					VARCHAR(3);
	DECLARE Mop07					VARCHAR(3);
	DECLARE Mop96					VARCHAR(3);
	DECLARE Mop97					VARCHAR(3);
	DECLARE Mop99					VARCHAR(3);
    DECLARE DiasTresMeses			INT(11);
    DECLARE EtiquetaNumero			VARCHAR(10);

    DECLARE TipoRespIndividual		CHAR(1);
    DECLARE TipoRespMancomunado		CHAR(1);
    DECLARE TipoRespObligadoSol		CHAR(1);
    DECLARE TipoCtaPagosFijos		CHAR(1);
    DECLARE TipoCtaHipoteca			CHAR(1);
    DECLARE TipoCtaSinLimite		CHAR(1);
    DECLARE TipoCtaRevolvente		CHAR(1);

    DECLARE ClaveObsCtaCanc			CHAR(2);
    DECLARE ClaveObsFiniq			CHAR(2);
    DECLARE ClaveObsCtaCast			CHAR(2);
    DECLARE ClaveObsCedido			CHAR(2);

    DECLARE FrecBimestralBC			CHAR(1);
    DECLARE FreDiarioBC				CHAR(1);
    DECLARE FrecSemestralBC			CHAR(1);
    DECLARE FrecCatorcenalBC		CHAR(1);
    DECLARE FrecMensualBC			CHAR(1);
    DECLARE FrecDeduccionBC			CHAR(1);
    DECLARE FrecTrimestralBC		CHAR(1);
    DECLARE FrecQuincenalBC			CHAR(1);
    DECLARE FrecVariableBC			CHAR(1);
    DECLARE FrecSemanalBC			CHAR(1);
    DECLARE FrecAnualBC				CHAR(1);
    DECLARE FrecPagoMinimoBC		CHAR(1);
    DECLARE FrecPagoUnicoSAFI		CHAR(1);
    DECLARE PersMoral				CHAR(1);
    DECLARE EstatusInactivo			CHAR(1);
    DECLARE NombreNoProporcionado	VARCHAR(20);
    DECLARE PrefijoSRITA			VARCHAR(6);
    DECLARE PrefijoSRTA				VARCHAR(6);
	DECLARE OcupacionHOGAR			VARCHAR(20);
	DECLARE OcupacionESTUDIANTE		VARCHAR(20);
	DECLARE OcupacionJUBILADO		VARCHAR(20);
	DECLARE OcupacionDESEMPLEADO	VARCHAR(20);
	DECLARE LikeCasa				VARCHAR(20);
	DECLARE LikeEstudiante			VARCHAR(20);
	DECLARE LikeJubilado			VARCHAR(20);
	DECLARE LikeDesempleado			VARCHAR(20);
	DECLARE LikeDesocupado			VARCHAR(20);

	SET EstatusPagado   		:='P';
	SET EstatusVigente  		:='V';
	SET EstatusCastigado		:='K';
	SET EstatusVencido 			:='B';
    SET EstatusAtrasado			:='A';
	SET DiasCtaReciente 		:=29;
	SET Cadena_Vacia			:='';
	SET Fecha_Vacia				:='1900-01-01';
	SET Entero_Cero 			:=0;
	SET Entero_Uno				:=1;
	SET Formato_Cinta   		:='INTF11';
	SET Formato_Comas			:='CVS';
	SET Espacio_Blanco  		:=' ';
	SET Separador				:=',';
	SET Salto_Linea 			:='\n';
	SET Casado_BMC				:='CC';
	SET Casado_BM 				:='CM';
	SET Casado_BS 				:='CS';
	SET Viudo 					:='V';
	SET Union_libre 			:='U';
	SET Casado_BC 				:='M';
	SET Viudo_BC 				:='W';
	SET Union_libreBC  			:='F';
	SET EdoSeparado	  			:='SE';
	SET Soltero_BC	  			:='S';

	SET Var_ApellidoAdicional	:=',';
	SET Var_Prefijo				:=',';
	SET Var_IndicadorDef		:=',';
	SET Var_FechaDefuncion		:=',';
	SET Var_CalleNumero2		:=',';
	SET Var_DirComplemento2		:=',';
	SET Var_Colonia2			:=',';
	SET Var_Municipio2			:=',';
	SET Var_Ciudad2				:=',';
	SET Var_Estado2				:=',';
	SET Var_CP2					:=',';
	SET Var_Telefono2			:=',';

	SET Var_ClaveOtorAnt		:=',';
	SET Var_NombreOtorAnt		:=',';
	SET Var_NumCtaAnterior		:=',';

	SET Var_NumCtaAnterior		:=',';
	SET Var_NombreOtorAnt		:=',';
	SET Var_ClaveOtorAnt		:=',';
	SET Var_Empresa				:=',';
	SET Var_Salario				:=',';
	SET Var_Ciudad 				:=',';

	SET SI_DiaHabil				:='S';
	SET No_DiaHabil				:='N';
	SET DiasMaxReporte			:=5;
	SET Fecha_Vaciaddmmyyyy		:='01011900';
	SET FechaMigracion			:='30092014';
	SET Var_PromagraID			:='MIGRACION';
	SET Entero_Diez				:=10;

	SET TipoPersFisica			:= 'F';
	SET TipoDomTrabajo			:= 3;
	SET PaisMexico				:= 700;
	SET DomicilioConocido		:= 'DOMICILIO CONOCIDO SN';
	SET SinNumero				:= ' SN';
	SET CalleConocido			:= '%CONOCIDO%';
	SET CalleConocida			:= '%CONOCIDA%';
	SET LimpiaAlfabetico		:= 'A';
	SET LimpiaAlfaNumerico		:= 'AN';
	SET Str_SI					:= 'S';
	SET Str_NO					:= 'N';
	SET FormatoFecha			:= '%d%m%Y';
	SET FormatoFechaInicio		:= '%Y-%m-01';

	SET Formato_Envio			:= Formato_Comas;

	SET MopUR					:= 'UR';
	SET Mop00					:= '00';
	SET Mop01					:= '01';
	SET Mop02					:= '02';
	SET Mop03					:= '03';
	SET Mop04					:= '04';
	SET Mop05					:= '05';
	SET Mop06					:= '06';
	SET Mop07					:= '07';
	SET Mop96					:= '96';
	SET Mop97					:= '97';
	SET Mop99					:= '99';
	SET Factor_Meses			:= 30.4;
	SET DiasTresMeses			:= 60;
	SET EtiquetaNumero			:= ' NUM ';
    SET TipoRespIndividual		:= 'I';
    SET TipoRespMancomunado		:= 'J';
    SET TipoRespObligadoSol		:= 'C';
    SET TipoCtaPagosFijos		:= 'I';
    SET TipoCtaHipoteca			:= 'M';
    SET TipoCtaSinLimite		:= 'O';
    SET TipoCtaRevolvente		:= 'R';
    SET ClaveObsCtaCanc			:= 'CC';
    SET ClaveObsFiniq			:= 'LC';
    SET ClaveObsCtaCast			:= 'UP';
    SET ClaveObsCedido			:= 'CV';

    SET FrecBimestralBC			:= 'B';
    SET FreDiarioBC				:= 'D';
    SET FrecSemestralBC			:= 'H';
    SET FrecCatorcenalBC		:= 'K';
    SET FrecMensualBC			:= 'M';
    SET FrecDeduccionBC			:= 'P';
    SET FrecTrimestralBC		:= 'Q';
    SET FrecQuincenalBC			:= 'S';
    SET FrecVariableBC			:= 'V';
    SET FrecSemanalBC			:= 'W';
    SET FrecAnualBC				:= 'Y';
    SET FrecPagoMinimoBC		:= 'Z';
    SET FrecPagoUnicoSAFI		:= 'U';
    SET PersMoral				:= 'M';
    SET EstatusInactivo			:= 'I';
    SET NombreNoProporcionado	:= 'NO PROPORCIONADO';
    SET PrefijoSRITA			:= 'SRITA';
    SET PrefijoSRTA				:= 'SRTA';
	SET OcupacionHOGAR			:= 'LABORES DEL HOGAR';
	SET OcupacionESTUDIANTE		:= 'ESTUDIANTE';
	SET OcupacionJUBILADO		:= 'JUBILADO';
	SET OcupacionDESEMPLEADO	:= 'DESEMPLEADO';
	SET LikeCasa				:= '%casa%';
	SET LikeEstudiante			:= '%estudiante%';
	SET LikeJubilado			:= '%jubilado%';
	SET LikeDesempleado			:= '%desempleado%';
	SET LikeDesocupado			:= '%desocupado%';


    -- SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
    SET sql_mode = '';

	SET EncabezadoCVS:=Cadena_Vacia;

	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CLAVE_OTORGANTE_1,NOMBRE DEL OTORGANTE_1,FECHA DEL REPORTE,APELLIDO_PATERNO,APELLIDO_MATERNO,');
	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'APELLIDO_ADICIONAL,PRIMER_NOMBRE,SEGUNDO_NOMBRE,FECHA_DE_NACIMIENTO,RFC,');

	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'PREFIJO,NACIONALIDAD,ESTADO_CIVIL,SEXO,FECHA_DEFUNCION,');
	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'INDICADOR_DEFUNCION,DIRECCION_CALLE_NUMERO,DIRECCION_COMPLEMENTO,COLONIA_O_POBLACION,DELEGACION_O_MUNICIPIO,');

	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CIUDAD,ESTADO,C.P.,TELEFONO,DIRECCION_ORIGEN,');
	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'EMPRESA,DIRECCION_CALLE_NUMERO_1,DIRECCION_COMPLEMENTO_1,COLONIA_O_POBLACION_1,DELEGACION_O_MUNICIPIO_1,');

	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CIUDAD_1,ESTADO_1,C.P._1,TELEFONO_1,SALARIO,');
	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'DIRECCION_ORIGEN,CLAVE_OTORGANTE,NOMBRE DEL OTORGANTE,NUMERO_CUENTA,TIPO_RESPONSABILIDAD_CUENTA,');

	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'TIPO_CUENTA,TIPO_CONTRATO,MONEDA,NUMERO_DE_PAGOS,FRECUENCIA_DE_PAGOS,');
	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'FECHA_APERTURA,MONTO_A_PAGAR,FECHA_ULTIMO_PAGO,FECHA_ULTIMA_COMPRA,FECHA_CIERRE_CREDITO,');

	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'FECHA_REPORTE,CREDITO_MAXIMO,SALDO_ACTUAL,LIMITE_DE_CREDITO,SALDO_VENCIDO,');
	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'NUMERO_PAGOS_VENCIDOS,FORMA_PAGO_MOP,CLAVE_OBSERVACION,CLAVE_ANTERIOR_OTORGANTE,NOMBRE_ANTERIOR_OTORGANTE,');

	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'NUMERO_CTA_ANTERIOR,FECHA_PRIMER_INCUMPLIMIENTO,SALDO_INSOLUTO,MONTO_ULTIMO_PAGO,PLAZO_CREDITO,');
	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'MONTO_CREDITO_ORIGINAL,FECHA_ULT_PAGO_VENCIDO,INTERES_REPORTADO,FORMA_PAGO_INTERES,DIAS_DESDE_ULT_PAGO,');

	SET EncabezadoCVS:=CONCAT(EncabezadoCVS,'CORREO_ELECTRONICO',Salto_Linea);


	SET Var_FechaFin		:= LAST_DAY(Par_FechaCorteBC);
    SET Var_FechaCorte		:= Var_FechaFin;
	SET Var_FechaInicial  	:= DATE_SUB(Par_FechaCorteBC, INTERVAL 7 DAY);
    SET Fec_SigPeriodo		:= DATE_ADD(Var_FechaFin, INTERVAL 1 MONTH);

	SELECT 	 ClaveInstitID,	    Nombre
	  INTO 	 `Member`,			NombreEmp
		FROM BUCREPARAMETROS;

	DELETE FROM BUROCREDINTFMEN  WHERE Fecha=Par_FechaCorteBC;

	SET Var_CintaID:= Par_CintaBCID;


	DROP TABLE IF EXISTS TEMPORAL_MUNICIP;

	CREATE TABLE TEMPORAL_MUNICIP (
	  EstadoID 			INT(11) NOT NULL,
	  MunicipioID 		INT(11) NOT NULL,
	  NombreCorrecto	VARCHAR(150) NULL,
	  Nombre 			VARCHAR(150) NULL,
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


	DROP TABLE IF EXISTS TMPDATOSCTESCREDPAG;
	CREATE TABLE TMPDATOSCTESCREDPAG(
		ClienteID		INT(11),		ApellidoPaterno		VARCHAR(50),	ApellidoMaterno		VARCHAR(50),	Adicional		VARCHAR(50),
		PrimerNombre	VARCHAR(50),	SegundoNombre		VARCHAR(50),	TercerNombre		VARCHAR(50),	FechaNacimiento	VARCHAR(10),
		RFC				VARCHAR(18),	Prefijo				VARCHAR(10),	EstadoCivil			CHAR(2),		Sexo			CHAR(1),
		FDef			VARCHAR(10),	InDef				VARCHAR(10),	CalleNumero			VARCHAR(100),	Colonia			VARCHAR(200),
		Municipio		VARCHAR(100),	Ciudad				VARCHAR(50), 	Estado				VARCHAR(20),	`member`		VARCHAR(50),
		CP				CHAR(6),		Telefono			VARCHAR(10),	DirComplemento		VARCHAR(100),	Empresa			VARCHAR(99),
		CalleNumero2	VARCHAR(41),	Colonia2			VARCHAR(41),	Municipio2			VARCHAR(41),	Ciudad2			VARCHAR(41),
		Estado2			VARCHAR(20),	CP2					CHAR(6),		Telefono2			VARCHAR(11),	DirComplemento2	VARCHAR(100),
		Salario			VARCHAR(10),	CreditoIDCte		VARCHAR(20),	Estatus				CHAR(1),		CreditoIDSAFI	BIGINT(12),
		FechaPago		CHAR(8),		Incumplimiento 		VARCHAR(8),		NPagos				INT(11),		FrecPagos		CHAR(2),
		Saldo			INT(11),		MontoCredito		INT(11),		Vencido				INT(11),		FechaInicio		CHAR(8),
		ImportePagos	INT(11),		FechaCierre			CHAR(8),		NoCuotasAtraso		INT(11),		DiasAtraso		INT(11),
		DiasPasoAtraso	INT(11),		SaldoTotal 			INT(11),		MOP 				CHAR(2),		TipoContrato	CHAR(8),
		Moneda			CHAR(5),		Responsabilidad		CHAR(1),		TipoCuenta			CHAR(1),		TipoPersona		CHAR(1),
		ClaveObervacion	CHAR(3),		MontoUltPago		INT(11),		PlazoID				VARCHAR(20),	Nacionalidad	CHAR(5),
		PaisID			INT(11),		DiasAtraFecFinCre	INT(11),		PaisResidencia		INT(11),		NacDomicilio	CHAR(5),
		CorreoElect		VARCHAR(50),	FechaUltPagoVen		CHAR(8),		OcupacionID			INT(11),		PlazoCredito	DECIMAL(12,2),
		MonedaID		INT(11),		GraciaMoratorios	INT,			GraciaPasoAtraso	INT,			FecTerminacion	DATE,
		InicioCredito	DATE,			InteresReportado	INT,			Cuenta				VARCHAR(40),	Cinta			TEXT,
		CreditoContID	BIGINT(20),		EstatusCont			CHAR(1),		EstatusGaranFIRA	CHAR(1),		ImportePagosCont INT(11),
        FechaAtraso		DATE,			DiasAtrasoCont		INT,			FechaAtrasoCont		DATE,
	INDEX TMPDATOSCTESCREDPAG1 (ClienteID),
	INDEX TMPDATOSCTESCREDPAG2 (CreditoIDCte),
	INDEX TMPDATOSCTESCREDPAG3 (CreditoContID),
	INDEX TMPDATOSCTESCREDPAG4 (CreditoIDSAFI));

	INSERT INTO TMPDATOSCTESCREDPAG(
	SELECT  Cli.ClienteID,		IFNULL(IF(Cli.ApellidoPaterno = Cadena_Vacia OR Cli.ApellidoPaterno = Espacio_Blanco,NULL,Cli.ApellidoPaterno),Cadena_Vacia),		IFNULL(IF(Cli.ApellidoMaterno = Cadena_Vacia OR Cli.ApellidoMaterno = Espacio_Blanco,NULL,Cli.ApellidoMaterno),Cadena_Vacia),		Cadena_Vacia AS Adicional,		Cli.PrimerNombre,
		Cli.SegundoNombre,	Cli.TercerNombre,			DATE_FORMAT(Cli.FechaNacimiento,FormatoFecha)AS FechaNacimiento,
    	CASE WHEN (LENGTH(Cli.RFC) > 13 OR LENGTH(Cli.RFC) < 10 ) AND Cli.TipoPersona = PersMoral THEN  Cadena_Vacia
			 ELSE Cli.RFCOficial
		END AS RFC,
        Cli.Titulo,
		CASE Cli.EstadoCivil
			WHEN Casado_BM	THEN Casado_BC
			WHEN Casado_BMC	THEN Casado_BC
			WHEN Casado_BS	THEN Casado_BC
			WHEN Viudo 		THEN Viudo_BC
			WHEN Union_libre THEN Union_libreBC
			WHEN EdoSeparado THEN Soltero_BC
				ELSE LEFT(Cli.EstadoCivil, 1)
		END AS EstadoCivil,

		Cli.Sexo,	Cadena_Vacia AS FDef,		Cadena_Vacia AS InDef,

		IF( (IFNULL(Dir.Calle,Cadena_Vacia)=Cadena_Vacia AND IFNULL(Dir.NumeroCasa,Entero_Cero)=Entero_Cero)OR(IFNULL(Dir.Calle,Cadena_Vacia) LIKE CalleConocida OR IFNULL(Dir.Calle,Cadena_Vacia) LIKE CalleConocido) ,
		 DomicilioConocido,
		 CONCAT(LEFT(IFNULL(Dir.Calle,Cadena_Vacia),(40-LENGTH(IF(IFNULL(Dir.NumeroCasa,Entero_Cero)=Entero_Cero,SinNumero,CONCAT(EtiquetaNumero,Dir.NumeroCasa))))
		),IF(IFNULL(Dir.NumeroCasa,Entero_Cero)=Entero_Cero,SinNumero,CONCAT(EtiquetaNumero,Dir.NumeroCasa)))) AS CalleNumero,

		TRIM(LEFT(CONCAT(Col.TipoAsenta,' ',Col.Asentamiento),40)) AS Colonia,		TRIM(LEFT(Mun.Nombre,40)) AS Municipio,		TRIM(LEFT(Loc.NombreLocalidad,40)) AS Ciudad,
		Est.EqBuroCred AS Estado,		Cadena_Vacia AS member,		Dir.CP,		SUBSTRING(REPLACE(IF(IFNULL(Cli.Telefono,Cadena_Vacia)!=Cadena_Vacia,Cli.Telefono,Cli.TelefonoCelular), ' ', ''), 1, 10) AS Telefono,
		Cadena_Vacia AS DirComplemento,		LEFT(IF(Cli.LugardeTrabajo=Cadena_Vacia,Cli.NombreCompleto,Cli.LugardeTrabajo),40)  AS Empresa,


        Cadena_Vacia AS CalleNumero2,		Cadena_Vacia AS Colonia2,		Cadena_Vacia AS Municipio2,		Cadena_Vacia AS Ciudad2,		Cadena_Vacia AS Estado2,
		Cadena_Vacia  AS CP2,				IF(IFNULL(Cli.TelTrabajo,Entero_Cero) != Entero_Cero,   Cli.TelTrabajo, Cadena_Vacia) AS Telefono2,		Cadena_Vacia  AS DirComplemento2,
		Cadena_Vacia AS Salario,			EqC.CreditoIDCte,				Cre.Estatus,			Cre.CreditoID,
		DATE_FORMAT(Cre.FechaInicio, FormatoFecha) AS FechaPago,
		Fecha_Vaciaddmmyyyy AS Incumplimiento, Cre.NumAmortizacion,
		CASE WHEN Cre.FrecuenciaCap  = 'C'  THEN 'K'
			 WHEN Cre.FrecuenciaCap  = 'Q'  THEN 'S'
			 WHEN Cre.FrecuenciaCap  = 'M'  THEN 'M'
			 WHEN Cre.FrecuenciaCap  = 'B'  THEN 'B'
			 WHEN Cre.FrecuenciaCap  = 'E'  THEN 'H'
			 WHEN Cre.FrecuenciaCap  = 'A'  THEN 'Y'
			 WHEN Cre.FrecuenciaCap  = 'S'  OR Cre.FrecuenciaCap  = 'D' THEN 'W'
			 WHEN Cre.FrecuenciaCap  = 'T' OR Cre.FrecuenciaCap  = 'R'  THEN 'Q'
			 WHEN Cre.FrecuenciaCap  = 'P' OR Cre.FrecuenciaCap  = 'L'
				 OR Cre.FrecuenciaCap  = 'U' THEN 'V'
		END AS FrecPagos,
		Entero_Cero AS Saldo,			Cre.MontoCredito,		Entero_Cero AS Vencido,		DATE_FORMAT(Cre.FechaInicio, FormatoFecha) AS FechaInicio,
		Entero_Cero AS	ImportePagos,	DATE_FORMAT(Cre.FechTerminacion,FormatoFecha) AS FechaCierre,		Entero_Cero AS NoCuotasAtraso,			Entero_Cero AS DiasAtraso,
		Pro.DiasPasoAtraso,				Entero_Cero AS  SaldoTotal,			Cadena_Vacia AS MOP,			Pro.TipoContratoBCID,					Cadena_Vacia AS Moneda,
		Pro.EsGrupal,					Pro.EsRevolvente,					Cli.TipoPersona,				Cadena_Vacia AS ClaveObervacion,Entero_Cero AS MontoUltPago,
		IFNULL(Cre.PlazoID,Entero_Cero) AS PlazoID,							Cadena_Vacia AS Nacionalidad,	Cli.LugarNacimiento, 					Entero_Cero AS DiasAtraFecFinCre,
		Cli.PaisResidencia,				Cadena_Vacia AS NacDomicilio,		Cli.Correo AS CorreoElect,
		CASE WHEN Cre.FechTraspasVenc != Fecha_Vacia AND Cre.FechTraspasVenc < Par_FechaCorteBC THEN
				  DATE_FORMAT(Cre.FechTraspasVenc, FormatoFecha)
			ELSE Cadena_Vacia
		END,
		Cli.OcupacionID,				Entero_Cero AS PlazoCredito,		Cre.MonedaID AS MonedaID,			Pro.GraciaMoratorios,				Pro.DiasPasoAtraso,
        Cre.FechTerminacion,			Cre.FechaInicio,					Entero_Cero AS InteresReportado,	Cadena_Vacia AS Cuenta, 			Cadena_Vacia  AS Cinta,
        IFNULL(Con.CreditoID,Entero_Cero)  AS CreditoContID, 				IFNULL(Con.Estatus,EstatusInactivo) AS EstatusCont,						Cre.EstatusGarantiaFIRA,
        Entero_Cero AS ImportePagosCont, 	Fecha_Vacia AS FechaAtraso, 	Entero_Cero AS DiasAtrasoCont,											Fecha_Vacia	AS FechaAtrasoCont
	FROM CREDITOS Cre
		INNER JOIN PRODUCTOSCREDITO	Pro 	ON 	Cre.ProductoCreditoID = Pro.ProducCreditoID
		LEFT  JOIN EQU_CREDITOS 	EqC 	ON	Cre.CreditoID = EqC.CreditoIDSAFI
		INNER JOIN CLIENTES		 	Cli 	ON  Cre.ClienteID = Cli.ClienteID
		INNER JOIN DIRECCLIENTE	 	Dir 	ON  Cre.ClienteID = Dir.ClienteID	AND Dir.Oficial = Str_SI
		INNER JOIN ESTADOSREPUB  	Est 	ON 	Dir.EstadoID = Est.EstadoID
		INNER JOIN MUNICIPIOSREPUB 	Mun		ON Dir.EstadoID = Mun.EstadoID		AND Dir.MunicipioID = Mun.MunicipioID
		INNER JOIN LOCALIDADREPUB 	Loc		ON Dir.EstadoID = Loc.EstadoID		AND Dir.MunicipioID = Loc.MunicipioID
												AND Dir.LocalidadID	= Loc.LocalidadID
		LEFT OUTER JOIN COLONIASREPUB Col 	ON Dir.EstadoID = Col.EstadoID		AND Dir.MunicipioID = Col.MunicipioID
												AND Dir.ColoniaID	= Col.ColoniaID
		LEFT OUTER JOIN CREDITOSCONT Con ON Con.creditoID = Cre.creditoID
	WHERE Cre.FechTerminacion BETWEEN Var_FechaInicial AND Par_FechaCorteBC
	  AND Cre.FechTerminacion < Cre.FechaVencimien
	  AND Cli.TipoPersona = TipoPersFisica
	  AND Cre.Estatus = EstatusPagado
	GROUP BY  Cre.CreditoID);

	UPDATE TMPDATOSCTESCREDPAG Tem,
			DIRECCLIENTE Dir,
			ESTADOSREPUB Est,
			MUNICIPIOSREPUB Mun,
			LOCALIDADREPUB Loc,
			COLONIASREPUB Col SET

			Tem.CalleNumero2 = IF((	IFNULL(Dir.Calle, Cadena_Vacia) = Cadena_Vacia AND
									IFNULL(Dir.NumeroCasa, Entero_Cero) = Entero_Cero) OR
									(	IFNULL(Dir.Calle,Cadena_Vacia) LIKE CalleConocida OR
										IFNULL(Dir.Calle,Cadena_Vacia) LIKE CalleConocido),
									DomicilioConocido,

									CONCAT(LEFT(IFNULL(Dir.Calle, Cadena_Vacia),
												(40-LENGTH(IF(IFNULL(Dir.NumeroCasa, Entero_Cero) = Entero_Cero,
															SinNumero, CONCAT(EtiquetaNumero,Dir.NumeroCasa))))
												),IF(IFNULL(Dir.NumeroCasa,Entero_Cero) = Entero_Cero,SinNumero,
									CONCAT(EtiquetaNumero,Dir.NumeroCasa)))),

			Tem.Colonia2	= TRIM(LEFT(CONCAT(Col.TipoAsenta,' ',Col.Asentamiento),40)),
			Tem.Municipio2	= TRIM(LEFT(Mun.Nombre,40)),
			Tem.Ciudad2		= TRIM(LEFT(Loc.NombreLocalidad,40)),
			Tem.Estado2		= Est.EqBuroCred,
			Tem.CP2			= Dir.CP

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
		  AND Dir.ColoniaID	= Col.ColoniaID;


	UPDATE TMPDATOSCTESCREDPAG D, TEMPORAL_MUNICIP T
	SET D.Municipio = T.NombreCorrecto,
		D.Municipio2 = T.NombreCorrecto
    WHERE D.Municipio=T.Nombre;


	DELETE FROM TMPDATOSCTESCREDPAG
		WHERE CONVERT(SUBSTRING(FechaInicio,3,2),SIGNED)>MONTH(Var_FechaFin)
		AND SUBSTRING(FechaInicio,5,4) = YEAR(Var_FechaFin);


	UPDATE TMPDATOSCTESCREDPAG SET
		FechaCierre = Fecha_Vaciaddmmyyyy
	WHERE CreditoContID > Entero_Cero
		AND EstatusCont= EstatusVigente
		AND Estatus = EstatusPagado;


	DELETE FROM TMPDATOSCTESCREDPAG
		WHERE CONVERT(SUBSTRING(FechaCierre,3,2),SIGNED)<MONTH(Var_FechaFin)
		AND SUBSTRING(FechaCierre,5,4) = YEAR(Var_FechaFin);


	UPDATE TMPDATOSCTESCREDPAG Dat
		INNER JOIN CREDITOS Cre ON Dat.CreditoIDSAFI =Cre.CreditoID
	SET Dat.FechaCierre =Fecha_Vaciaddmmyyyy
	WHERE Cre.FechTerminacion > Par_FechaCorteBC;



	DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
	CREATE TABLE TMPACTFECHAPAGOCRED(
		CreditoID 		BIGINT(12),
        AmortizacionID	INT,
		FechaPago 		DATE,
		MontoUltPag 	DECIMAL(14,2),

		INDEX TMPACTFECHAPAGOCRED (CreditoID),
		INDEX TMPACTFECHAPAGOCRED1 (CreditoID, AmortizacionID)
	);


	DROP TABLE IF EXISTS TMPACTFECHAPAGOCREDCONT;
	CREATE TABLE TMPACTFECHAPAGOCREDCONT(
		CreditoID 		BIGINT(12),
        AmortizacionID	INT,
		FechaPago 		DATE,
		MontoUltPag 	DECIMAL(14,2),

		INDEX TMPACTFECHAPAGOCREDCONT (CreditoID),
		INDEX TMPACTFECHAPAGOCREDCONT1 (CreditoID, AmortizacionID)
	);


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
		CreditoID 		BIGINT(12),
        MontoPago		DECIMAL(14,2),

		INDEX TMPDETULTIMOPAGO1 (CreditoID)

	);


	INSERT INTO TMPACTFECHAPAGOCREDCONT
		SELECT Amo.CreditoID, MAX(Amo.AmortizacionID), Fecha_Vacia, Entero_Cero
		FROM TMPDATOSCTESCREDPAG Cre,
			 AMORTICREDITOCONT Amo
		WHERE Cre.CreditoContID = Amo.CreditoID
		  AND Amo.Estatus = EstatusPagado
		  AND Amo.FechaLiquida <> Fecha_Vacia
		  AND Amo.FechaLiquida <= Var_FechaFin
		GROUP BY Amo.CreditoID;

	DROP TABLE IF EXISTS TMPDETULTIMOPAGOCONT;
	CREATE TABLE TMPDETULTIMOPAGOCONT(
		CreditoID 		BIGINT(12),
        MontoPago		DECIMAL(14,2),

		INDEX TMPDETULTIMOPAGOCONT1 (CreditoID)

	);


	INSERT INTO TMPDETULTIMOPAGO
	SELECT	Pag.CreditoID, SUM(MontoTotPago)
		FROM TMPACTFECHAPAGOCRED Tem,
			 DETALLEPAGCRE Pag
		WHERE Tem.CreditoID = Pag.CreditoID
          AND Tem.AmortizacionID = Pag.AmortizacionID
		  AND Pag.FechaPago  <= Var_FechaFin
		GROUP BY Pag.CreditoID;



	INSERT INTO TMPDETULTIMOPAGOCONT
	SELECT	Pag.CreditoID, SUM(MontoTotPago)
		FROM TMPACTFECHAPAGOCREDCONT Tem,
			 DETALLEPAGCRECONT Pag
		WHERE Tem.CreditoID = Pag.CreditoID
          AND Tem.AmortizacionID = Pag.AmortizacionID
		  AND Pag.FechaPago  <= Var_FechaFin
		GROUP BY Pag.CreditoID;



	UPDATE TMPACTFECHAPAGOCRED Det, TMPDETULTIMOPAGO Pag SET
		Det.MontoUltPag = Pag.MontoPago
    WHERE Det.CreditoID = Pag.CreditoID;

	UPDATE TMPACTFECHAPAGOCRED Tmp, AMORTICREDITO Amo SET
		Tmp.FechaPago 	= Amo.FechaLiquida,
		Tmp.MontoUltPag = (Amo.Capital + Amo.Interes + Amo.IVAInteres)

    WHERE Tmp.MontoUltPag 	 != Entero_Cero
	  AND Tmp.CreditoID 	 = Amo.CreditoID
      AND Tmp.AmortizacionID = Amo.AmortizacionID;



	UPDATE TMPACTFECHAPAGOCREDCONT Det, TMPDETULTIMOPAGOCONT Pag SET
		Det.MontoUltPag = Pag.MontoPago
    WHERE Det.CreditoID = Pag.CreditoID;

	UPDATE TMPACTFECHAPAGOCREDCONT Tmp, AMORTICREDITOCONT Amo SET
		Tmp.FechaPago 	= Amo.FechaLiquida,
		Tmp.MontoUltPag = (Amo.Capital + Amo.Interes + Amo.IVAInteres)

    WHERE Tmp.MontoUltPag 	 != Entero_Cero
	  AND Tmp.CreditoID 	 = Amo.CreditoID
      AND Tmp.AmortizacionID = Amo.AmortizacionID;


 	UPDATE TMPDATOSCTESCREDPAG Det
 		INNER JOIN TMPACTFECHAPAGOCRED Tem ON Det.CreditoIDSAFI	= Tem.CreditoID
 			AND Tem.FechaPago <=  Par_FechaCorteBC
		LEFT OUTER JOIN TMPACTFECHAPAGOCREDCONT Tmp	ON Det.CreditoIDSAFI= Tmp.CreditoID
			AND Tmp.FechaPago <=  Par_FechaCorteBC
 	SET
		Det.FechaPago 	 = (CASE WHEN Tem.FechaPago >= IFNULL(Tmp.FechaPago,Fecha_Vacia) THEN DATE_FORMAT(Tem.FechaPago, FormatoFecha)
									ELSE DATE_FORMAT(Tmp.FechaPago, FormatoFecha)
							END),
		Det.MontoUltPago = (CASE WHEN Tem.FechaPago > IFNULL(Tmp.FechaPago,Fecha_Vacia) THEN ROUND(IFNULL(Tem.MontoUltPag,Entero_Cero),Entero_Cero)
								WHEN Tem.FechaPago < IFNULL(Tmp.FechaPago,Fecha_Vacia) THEN ROUND(IFNULL(Tmp.MontoUltPag, Entero_Cero), Entero_Cero)
								WHEN Tem.FechaPago = IFNULL(Tmp.FechaPago,Fecha_Vacia) THEN (ROUND(IFNULL(Tem.MontoUltPag,Entero_Cero), Entero_Cero)+ROUND(IFNULL(Tmp.MontoUltPag,Entero_Cero), Entero_Cero))
							END);

	  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
	  DROP TABLE IF EXISTS TMPDETULTIMOPAGO;
	  DROP TABLE IF EXISTS TMPACTFECHAPAGOCREDCONT;
	  DROP TABLE IF EXISTS TMPDETULTIMOPAGOCONT;


	DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
	CREATE TABLE TMPACTFECHAPAGOCRED(
		CreditoID 		BIGINT(12),
		FechaPago		DATE,
        TransaccionID	BIGINT,

		INDEX TMPACTFECHAPAGOCRED (CreditoID, FechaPago, TransaccionID)
	);

	INSERT INTO TMPACTFECHAPAGOCRED
		SELECT	Pag.CreditoID, MAX(Pag.FechaPago), MAX(Pag.Transaccion)
			FROM TMPDATOSCTESCREDPAG Tem,
				 DETALLEPAGCRE Pag
			WHERE Tem.CreditoIDSAFI = Pag.CreditoID
			  AND Pag.FechaPago  <= Var_FechaFin
			GROUP BY Pag.CreditoID;

	DROP TABLE IF EXISTS TMPDETULTIMOPAGO;
	CREATE TABLE TMPDETULTIMOPAGO(
		CreditoID 		BIGINT(12),
		FechaPago 		DATE,
        MontoPago		DECIMAL(14,2),

		INDEX TMPDETULTIMOPAGO1 (CreditoID)
	);

	INSERT INTO TMPDETULTIMOPAGO
		SELECT	Pag.CreditoID, MAX(Pag.FechaPago), SUM(Pag.MontoTotPago)
			FROM TMPACTFECHAPAGOCRED Tem,
				 DETALLEPAGCRE Pag
			WHERE Tem.CreditoId = Pag.CreditoID
			  AND Tem.FechaPago = Pag.FechaPago
			  AND Tem.TransaccionID = Pag.Transaccion
			GROUP BY Pag.CreditoID;


	DROP TABLE IF EXISTS TMPACTFECHAPAGOCREDCONT;
	CREATE TABLE TMPACTFECHAPAGOCREDCONT(
		CreditoID 		BIGINT(12),
		FechaPago		DATE,
        TransaccionID	BIGINT,

		INDEX TMPACTFECHAPAGOCREDCONT (CreditoID, FechaPago, TransaccionID)
	);

	INSERT INTO TMPACTFECHAPAGOCREDCONT
		SELECT	Pag.CreditoID, MAX(Pag.FechaPago), MAX(Pag.Transaccion)
			FROM TMPDATOSCTESCREDPAG Tem,
				 DETALLEPAGCRECONT Pag
			WHERE Tem.CreditoIDSAFI = Pag.CreditoID
			  AND Pag.FechaPago  <= Var_FechaFin
			GROUP BY Pag.CreditoID;

	DROP TABLE IF EXISTS TMPDETULTIMOPAGOCONT;
	CREATE TABLE TMPDETULTIMOPAGOCONT(
		CreditoID 		BIGINT(12),
		FechaPago 		DATE,
        MontoPago		DECIMAL(14,2),

		INDEX TMPDETULTIMOPAGOCONT1 (CreditoID)
	);

	INSERT INTO TMPDETULTIMOPAGOCONT
		SELECT	Pag.CreditoID, MAX(Pag.FechaPago), SUM(Pag.MontoTotPago)
			FROM TMPACTFECHAPAGOCREDCONT Tem,
				 DETALLEPAGCRECONT Pag
			WHERE Tem.CreditoId = Pag.CreditoID
			  AND Tem.FechaPago = Pag.FechaPago
			  AND Tem.TransaccionID = Pag.Transaccion
			GROUP BY Pag.CreditoID;


 	UPDATE TMPDATOSCTESCREDPAG Det
 		INNER JOIN TMPDETULTIMOPAGO Tem ON Det.CreditoIDSAFI	= Tem.CreditoID
 			AND Tem.FechaPago <=  Par_FechaCorteBC
		LEFT OUTER JOIN TMPDETULTIMOPAGOCONT Tmp	ON Det.CreditoIDSAFI= Tmp.CreditoID
			AND Tmp.FechaPago <=  Par_FechaCorteBC
 	SET
		Det.FechaPago 	 = (CASE WHEN Tem.FechaPago >= IFNULL(Tmp.FechaPago,Fecha_Vacia) THEN DATE_FORMAT(Tem.FechaPago, FormatoFecha)
									ELSE DATE_FORMAT(Tmp.FechaPago, FormatoFecha)
							END),
		Det.MontoUltPago = (CASE WHEN Tem.FechaPago > IFNULL(Tmp.FechaPago,Fecha_Vacia) THEN ROUND(IFNULL(Tem.MontoPago,Entero_Cero), Entero_Cero)
								WHEN Tem.FechaPago < IFNULL(Tmp.FechaPago,Fecha_Vacia) THEN ROUND(IFNULL(Tmp.MontoPago,Entero_Cero), Entero_Cero)
								WHEN Tem.FechaPago = IFNULL(Tmp.FechaPago,Fecha_Vacia) THEN (ROUND(IFNULL(Tem.MontoPago,Entero_Cero), Entero_Cero)+ROUND(IFNULL(Tmp.MontoPago,Entero_Cero), Entero_Cero))
							END);

	  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
	  DROP TABLE IF EXISTS TMPDETULTIMOPAGO;
	  DROP TABLE IF EXISTS TMPACTFECHAPAGOCREDCONT;
	  DROP TABLE IF EXISTS TMPDETULTIMOPAGOCONT;



	  DROP TABLE IF EXISTS TMPACTFECHAPAGOCRED;
	  DROP TABLE IF EXISTS TEMP_ULTIMOPAGO;

	UPDATE TMPDATOSCTESCREDPAG Det
		INNER JOIN CREDITOS Cre 		ON Det.CreditoIDSAFI	= Cre.CreditoID
		INNER JOIN PRODUCTOSCREDITO Pro	ON Cre.ProductoCreditoID= Pro.ProducCreditoID
	SET Det.Responsabilidad = (CASE Pro.EsGrupal WHEN Str_NO THEN TipoRespIndividual
												 WHEN Str_SI THEN TipoRespMancomunado END),
		Det.TipoCuenta = (CASE Pro.EsRevolvente	WHEN Str_NO THEN TipoCtaPagosFijos
												 WHEN Str_SI THEN TipoCtaRevolvente END);



	DROP TABLE IF EXISTS TMPSALDOSCREDITOCINTABC;

	CREATE TABLE TMPSALDOSCREDITOCINTABC (
	  CreditoID 			BIGINT NOT NULL,
	  Estatus				CHAR(1),
	  SaldoAtrasoVencido	DECIMAL(16,2),
	  ExigibleSigPeriodo	DECIMAL(16,2),
	  PrimerIncumplimiento	DATE,
	  SaldoTotal 			DECIMAL(14,2),
	  NoCuotasAtraso		INT,
	  DiasAtraso			INT,
	  SaldoInsoluto			DECIMAL(14,2),
	  SaldoInteres			DECIMAL(14,2),
	  GraciaMoratorios		INT,
	  FrecPagos				CHAR(2),
	  INDEX (CreditoID)
	);

	INSERT INTO TMPSALDOSCREDITOCINTABC

		SELECT 	Tem.CreditoIDSAFI,
				CASE WHEN IFNULL(Sal.EstatusCredito, Cadena_Vacia)  = Cadena_Vacia THEN Tem.Estatus
					 ELSE Sal.EstatusCredito
				END,

			   (	IFNULL(Sal.SalCapAtrasado, Entero_Cero) + IFNULL(Sal.SalCapVencido , Entero_Cero)+
					IFNULL(Sal.SalIntAtrasado, Entero_Cero) + IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalMoratorios, Entero_Cero) +
					IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SalComFaltaPago, Entero_Cero) + IFNULL(Sal.SaldoComServGar, Entero_Cero) + IFNULL(Sal.SalOtrasComisi, Entero_Cero) ) AS SaldoAtrasoVencido,


				(	IFNULL(Sal.SalCapAtrasado, Entero_Cero) + IFNULL(Sal.SalCapVencido, Entero_Cero) +
					IFNULL(Sal.SalIntAtrasado, Entero_Cero) + IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalMoratorios, Entero_Cero) +
					IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SalComFaltaPago, Entero_Cero) + IFNULL(Sal.SaldoComServGar, Entero_Cero) + IFNULL(Sal.SalOtrasComisi, Entero_Cero) ) AS ExigibleSigPeriodo,

				Fecha_Vacia,


				( IFNULL(Sal.SalCapVigente, Entero_Cero) + IFNULL(Sal.SalCapAtrasado, Entero_Cero) + IFNULL(Sal.SalCapVencido, Entero_Cero) +
				  IFNULL(Sal.SalCapVenNoExi, Entero_Cero) + IFNULL(Sal.SalIntOrdinario, Entero_Cero) + IFNULL(Sal.SalIntAtrasado, Entero_Cero) +
				  IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalIntProvision, Entero_Cero) + IFNULL(Sal.SalIntNoConta, Entero_Cero) +
				  IFNULL(Sal.SalMoratorios, Entero_Cero) + IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SaldoMoraCarVen, Entero_Cero) +
				  IFNULL(Sal.SalComFaltaPago, Entero_Cero) + IFNULL(Sal.SaldoComServGar, Entero_Cero) + IFNULL(Sal.SalOtrasComisi, Entero_Cero)
				) AS SaldoTotal,

				IFNULL(Entero_Cero, Entero_Cero),
				IFNULL(Sal.DiasAtraso, Entero_Cero),


				(IFNULL(Sal.salCapVigente, Entero_Cero) + IFNULL(Sal.SalCapAtrasado, Entero_Cero) +
				 IFNULL(Sal.SalCapVencido, Entero_Cero) + IFNULL(Sal.SalCapVenNoExi, Entero_Cero) ) AS SaldoInsoluto,


				( IFNULL(Sal.SalIntOrdinario, Entero_Cero) + IFNULL(Sal.SalIntAtrasado, Entero_Cero) +
				  IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalIntProvision, Entero_Cero) + IFNULL(Sal.SalIntNoConta, Entero_Cero)
				) AS SaldoInteres,
				Tem.GraciaMoratorios, Tem.FrecPagos

			FROM TMPDATOSCTESCREDPAG Tem
			LEFT OUTER JOIN SALDOSCREDITOS Sal ON Tem.CreditoIDSAFI = Sal.CreditoID
											    AND Sal.FechaCorte = Par_FechaCorteBC;


	DROP TABLE IF EXISTS TMPSALDOSCREDITOCINTABCCONT;

	CREATE TABLE TMPSALDOSCREDITOCINTABCCONT (
	  CreditoID 			BIGINT NOT NULL,
	  Estatus				CHAR(1),
	  SaldoAtrasoVencido	DECIMAL(16,2),
	  ExigibleSigPeriodo	DECIMAL(16,2),
	  PrimerIncumplimiento	DATE,
	  SaldoTotal 			DECIMAL(14,2),
	  NoCuotasAtraso		INT,
	  DiasAtraso			INT,
	  SaldoInsoluto			DECIMAL(14,2),
	  SaldoInteres			DECIMAL(14,2),
	  GraciaMoratorios		INT,
	  FrecPagos				CHAR(2),
	  INDEX (CreditoID)
	);

	INSERT INTO TMPSALDOSCREDITOCINTABCCONT

		SELECT 	Tem.CreditoIDSAFI,
				CASE WHEN IFNULL(Sal.EstatusCredito, Cadena_Vacia)  = Cadena_Vacia THEN Tem.EstatusCont
					 ELSE Sal.EstatusCredito
				END,

			   (	IFNULL(Sal.SalCapAtrasado, Entero_Cero) + IFNULL(Sal.SalCapVencido , Entero_Cero)+
					IFNULL(Sal.SalIntAtrasado, Entero_Cero) + IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalMoratorios, Entero_Cero) +
					IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SalComFaltaPago, Entero_Cero) + IFNULL(Sal.SaldoComServGar, Entero_Cero) + IFNULL(Sal.SalOtrasComisi, Entero_Cero) ) AS SaldoAtrasoVencido,


				(	IFNULL(Sal.SalCapAtrasado, Entero_Cero) + IFNULL(Sal.SalCapVencido, Entero_Cero) +
					IFNULL(Sal.SalIntAtrasado, Entero_Cero) + IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalMoratorios, Entero_Cero) +
					IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SalComFaltaPago, Entero_Cero) + IFNULL(Sal.SaldoComServGar, Entero_Cero) + IFNULL(Sal.SalOtrasComisi, Entero_Cero) ) AS ExigibleSigPeriodo,

				Fecha_Vacia,


				( IFNULL(Sal.SalCapVigente, Entero_Cero) + IFNULL(Sal.SalCapAtrasado, Entero_Cero) + IFNULL(Sal.SalCapVencido, Entero_Cero) +
				  IFNULL(Sal.SalCapVenNoExi, Entero_Cero) + IFNULL(Sal.SalIntOrdinario, Entero_Cero) + IFNULL(Sal.SalIntAtrasado, Entero_Cero) +
				  IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalIntProvision, Entero_Cero) + IFNULL(Sal.SalIntNoConta, Entero_Cero) +
				  IFNULL(Sal.SalMoratorios, Entero_Cero) + IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SaldoMoraCarVen, Entero_Cero) +
				  IFNULL(Sal.SalComFaltaPago, Entero_Cero) + IFNULL(Sal.SaldoComServGar, Entero_Cero) + IFNULL(Sal.SalOtrasComisi, Entero_Cero)
				) AS SaldoTotal,								-

				IFNULL(Entero_Cero, Entero_Cero),
				IFNULL(Sal.DiasAtraso, Entero_Cero),


				(IFNULL(Sal.salCapVigente, Entero_Cero) + IFNULL(Sal.SalCapAtrasado, Entero_Cero) +
				 IFNULL(Sal.SalCapVencido, Entero_Cero) + IFNULL(Sal.SalCapVenNoExi, Entero_Cero) ) AS SaldoInsoluto,


				( IFNULL(Sal.SalIntOrdinario, Entero_Cero) + IFNULL(Sal.SalIntAtrasado, Entero_Cero) +
				  IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalIntProvision, Entero_Cero) + IFNULL(Sal.SalIntNoConta, Entero_Cero)
				) AS SaldoInteres,
				Tem.GraciaMoratorios, Tem.FrecPagos

			FROM TMPDATOSCTESCREDPAG Tem
			LEFT OUTER JOIN SALDOSCREDITOSCONT Sal ON Tem.CreditoContID = Sal.CreditoID
											    AND Sal.FechaCorte = Par_FechaCorteBC;
-- Para generar el numero de cuotas en un rango de fechas
    DROP TABLE IF EXISTS TMPAMOTICUOTAS;
    CREATE TABLE TMPAMOTICUOTAS(
    CreditoID BIGINT(20),
    NumCuotas INT(11)
    );

    INSERT INTO TMPAMOTICUOTAS
    SELECT CreditoID,COUNT(CreditoID) NumCuotas FROM AMORTICREDITO
	WHERE FechaVencim BETWEEN Var_FechaInicial AND Var_FechaFin
    AND Estatus IN (EstatusVencido,EstatusAtrasado) GROUP BY CreditoID;

    UPDATE TMPSALDOSCREDITOCINTABCCONT tem, TMPAMOTICUOTAS temc
    SET tem.NoCuotasAtraso= temc.NumCuotas
    WHERE tem.CreditoID=temc.CreditoID;
-- TERMINA CONSEGUIR NUMERO DE CUOTAS ATRASADAS

	DROP TABLE IF EXISTS TMPINCUMPLECINTABC;

	CREATE TABLE TMPINCUMPLECINTABC (
	  CreditoID 			BIGINT NOT NULL,
	  PrimerIncumplimiento	DATE,
	  INDEX (CreditoID)
	);

	INSERT INTO TMPINCUMPLECINTABC
		SELECT	Tem.CreditoID, MIN(Amo.FechaExigible)

			FROM AMORTICREDITO Amo,
				 TMPSALDOSCREDITOCINTABC Tem
			WHERE Tem.CreditoID = Amo.CreditoID
			  AND Amo.FechaExigible <= Par_FechaCorteBC
			  AND ( 	IFNULL(Amo.FechaLiquida, Fecha_Vacia) = Fecha_Vacia
					OR	(		IFNULL(Amo.FechaLiquida, Fecha_Vacia) != Fecha_Vacia
						 AND 	DATE_ADD(Amo.FechaExigible, INTERVAL Tem.GraciaMoratorios DAY) < Amo.FechaLiquida
						)
					)
			GROUP BY Tem.CreditoID;


	UPDATE TMPSALDOSCREDITOCINTABC Sal, TMPINCUMPLECINTABC Tem SET
		Sal.PrimerIncumplimiento = Tem.PrimerIncumplimiento
		WHERE Sal.CreditoID = Tem.CreditoID;

    DROP TABLE IF EXISTS TMPINCUMPLECINTABC;

	DROP TABLE IF EXISTS TMPINCUMPLECINTABCCONT;

	CREATE TABLE TMPINCUMPLECINTABCCONT (
	  CreditoID 			BIGINT NOT NULL,
	  PrimerIncumplimiento	DATE,
	  INDEX (CreditoID)
	);


	INSERT INTO TMPINCUMPLECINTABCCONT
		SELECT	Tem.CreditoID, MIN(Amo.FechaExigible)

			FROM AMORTICREDITOCONT Amo,
				 TMPSALDOSCREDITOCINTABCCONT Tem
			WHERE Tem.CreditoID = Amo.CreditoID
			  AND Amo.FechaExigible <= Par_FechaCorteBC
			  AND ( 	IFNULL(Amo.FechaLiquida, Fecha_Vacia) = Fecha_Vacia
					OR	(		IFNULL(Amo.FechaLiquida, Fecha_Vacia) != Fecha_Vacia
						 AND 	DATE_ADD(Amo.FechaExigible, INTERVAL Tem.GraciaMoratorios DAY) < Amo.FechaLiquida
						)
					)
			GROUP BY Tem.CreditoID;

	UPDATE TMPSALDOSCREDITOCINTABCCONT Sal, TMPINCUMPLECINTABCCONT Tem SET
		Sal.PrimerIncumplimiento = Tem.PrimerIncumplimiento
	WHERE Sal.CreditoID = Tem.CreditoID;

	  DROP TABLE IF EXISTS TMPINCUMPLECINTABCCONT;



	DROP TABLE IF EXISTS TMPEXISIGPERIODOCINTABC;

	CREATE TABLE TMPEXISIGPERIODOCINTABC (
	  CreditoID 			BIGINT NOT NULL,
	  ExigibleSigPeriodo	DECIMAL(16,2),
	  INDEX (CreditoID)
	);


	INSERT INTO TMPEXISIGPERIODOCINTABC
		SELECT	Tem.CreditoID, SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres)

			FROM AMORTICREDITO Amo,
				 TMPSALDOSCREDITOCINTABC Tem
			WHERE Tem.CreditoID = Amo.CreditoID
			  AND Tem.FrecPagos IN ('D','K','M','S','W')
			  AND Amo.FechaExigible > Par_FechaCorteBC
			  AND Amo.FechaExigible <= Fec_SigPeriodo
			  AND ( Amo.Estatus != 'P'
					OR (Amo.Estatus = 'P' AND Amo.FechaLiquida > Fec_SigPeriodo) )
			GROUP BY Tem.CreditoID;

	UPDATE TMPSALDOSCREDITOCINTABC Sal, TMPEXISIGPERIODOCINTABC Tem SET
		Sal.ExigibleSigPeriodo = Sal.ExigibleSigPeriodo + Tem.ExigibleSigPeriodo
	WHERE Sal.CreditoID = Tem.CreditoID;

	  DROP TABLE IF EXISTS TMPEXISIGPERIODOCINTABC;



	DROP TABLE IF EXISTS TMPEXISIGPERIODOCINTABCCONT;

	CREATE TABLE TMPEXISIGPERIODOCINTABCCONT (
	  CreditoID 			BIGINT NOT NULL,
	  ExigibleSigPeriodo	DECIMAL(16,2),
	  INDEX (CreditoID)
	);


	INSERT INTO TMPEXISIGPERIODOCINTABCCONT
		SELECT	Tem.CreditoID, SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres)

			FROM AMORTICREDITOCONT Amo,
				 TMPSALDOSCREDITOCINTABCCONT Tem
			WHERE Tem.CreditoID = Amo.CreditoID
			  AND Tem.FrecPagos IN ('D','K','M','S','W')
			  AND Amo.FechaExigible > Par_FechaCorteBC
			  AND Amo.FechaExigible <= Fec_SigPeriodo
			  AND ( Amo.Estatus != EstatusPagado
					OR (Amo.Estatus = EstatusPagado AND Amo.FechaLiquida > Fec_SigPeriodo) )
			GROUP BY Tem.CreditoID;

	UPDATE TMPSALDOSCREDITOCINTABCCONT Sal, TMPEXISIGPERIODOCINTABCCONT Tem SET
		Sal.ExigibleSigPeriodo = Sal.ExigibleSigPeriodo + Tem.ExigibleSigPeriodo
	WHERE Sal.CreditoID = Tem.CreditoID;

	  DROP TABLE IF EXISTS TMPEXISIGPERIODOCINTABCCONT;


	DROP TABLE IF EXISTS TMPEXISIGPERIODOMAYORCINTABC;

	CREATE TABLE TMPEXISIGPERIODOMAYORCINTABC (
		CreditoID 			BIGINT NOT NULL,
		AmortizacionID		INT,
		ExigibleSigPeriodo	DECIMAL(16,2),
		INDEX TMPEXISIGPERIODOMAYORCINTABC_1(CreditoID),
		INDEX TMPEXISIGPERIODOMAYORCINTABC_2(CreditoID, AmortizacionID)
	);

	INSERT INTO TMPEXISIGPERIODOMAYORCINTABC
		SELECT	Tem.CreditoID, MIN(AmortizacionID), Entero_Cero

			FROM AMORTICREDITO Amo,
				 TMPSALDOSCREDITOCINTABC Tem
			WHERE Tem.CreditoID = Amo.CreditoID
			  AND Tem.FrecPagos NOT IN ('D','K','M','S','W')
			  AND Amo.FechaExigible > Par_FechaCorteBC
			  AND ( Amo.Estatus != 'P'
					OR (Amo.Estatus = 'P' AND Amo.FechaLiquida > Fec_SigPeriodo) )
			GROUP BY Tem.CreditoID;

	UPDATE TMPEXISIGPERIODOMAYORCINTABC Tem, AMORTICREDITO Amo SET
		Tem.ExigibleSigPeriodo = (Amo.Capital + Amo.Interes + Amo.IVAInteres)
		WHERE Tem.CreditoID 	 = Amo.CreditoID
		  AND Tem.AmortizacionID = Amo.AmortizacionID;


	UPDATE TMPSALDOSCREDITOCINTABC Sal, TMPEXISIGPERIODOMAYORCINTABC Tem SET
		Sal.ExigibleSigPeriodo = Sal.ExigibleSigPeriodo + Tem.ExigibleSigPeriodo
		WHERE Sal.CreditoID = Tem.CreditoID;

	 DROP TABLE IF EXISTS TMPEXISIGPERIODOMAYORCINTABC;





	DROP TABLE IF EXISTS TMPEXISIGPERIODOMAYORCINTABCCONT;

	CREATE TABLE TMPEXISIGPERIODOMAYORCINTABCCONT (
		CreditoID 			BIGINT NOT NULL,
		AmortizacionID		INT,
		ExigibleSigPeriodo	DECIMAL(16,2),
		INDEX TMPEXISIGPERIODOMAYORCINTABCCONT_1(CreditoID),
		INDEX TMPEXISIGPERIODOMAYORCINTABCCONT_2(CreditoID, AmortizacionID)
	);

	INSERT INTO TMPEXISIGPERIODOMAYORCINTABCCONT
		SELECT	Tem.CreditoID, MIN(AmortizacionID), Entero_Cero

			FROM AMORTICREDITOCONT Amo,
				 TMPSALDOSCREDITOCINTABCCONT Tem
			WHERE Tem.CreditoID = Amo.CreditoID
			  AND Tem.FrecPagos NOT IN ('D','K','M','S','W')
			  AND Amo.FechaExigible > Par_FechaCorteBC
			  AND ( Amo.Estatus != 'P'
					OR (Amo.Estatus = 'P' AND Amo.FechaLiquida > Fec_SigPeriodo) )
			GROUP BY Tem.CreditoID;

	UPDATE TMPEXISIGPERIODOMAYORCINTABCCONT Tem, AMORTICREDITOCONT Amo SET
		Tem.ExigibleSigPeriodo = (Amo.Capital + Amo.Interes + Amo.IVAInteres)
		WHERE Tem.CreditoID 	 = Amo.CreditoID
		  AND Tem.AmortizacionID = Amo.AmortizacionID;


	UPDATE TMPSALDOSCREDITOCINTABCCONT Sal, TMPEXISIGPERIODOMAYORCINTABCCONT Tem SET
		Sal.ExigibleSigPeriodo = Sal.ExigibleSigPeriodo + Tem.ExigibleSigPeriodo
	WHERE Sal.CreditoID = Tem.CreditoID;

	DROP TABLE IF EXISTS TMPEXISIGPERIODOMAYORCINTABCCONT;

	UPDATE TMPDATOSCTESCREDPAG Dat
		INNER JOIN TMPSALDOSCREDITOCINTABC Tem ON Dat.CreditoIDSAFI = Tem.CreditoID
		LEFT OUTER JOIN  TMPSALDOSCREDITOCINTABCCONT Tmp ON Dat.CreditoIDSAFI = Tmp.CreditoID
    SET

		Dat.Incumplimiento	= CASE WHEN Tem.PrimerIncumplimiento = Fecha_Vacia
											AND Tmp.PrimerIncumplimiento = Fecha_Vacia
										THEN Fecha_Vaciaddmmyyyy
									WHEN Tem.PrimerIncumplimiento >= Tmp.PrimerIncumplimiento
										THEN DATE_FORMAT(Tem.PrimerIncumplimiento, FormatoFecha)
								  	ELSE DATE_FORMAT(Tmp.PrimerIncumplimiento, FormatoFecha)
							  END,

		Dat.SaldoTotal 		= ROUND((IFNULL(Tem.SaldoTotal,Entero_Cero) + IFNULL(Tmp.SaldoTotal,Entero_Cero)),Entero_Cero),
		Dat.Vencido 		= ROUND((IFNULL(Tem.SaldoAtrasoVencido,Entero_Cero) + IFNULL(Tmp.SaldoAtrasoVencido,Entero_Cero)),Entero_Cero),
		Dat.NoCuotasAtraso	= Tmp.NoCuotasAtraso,
		Dat.Saldo 			= ROUND((IFNULL(Tem.SaldoInsoluto,Entero_Cero) + IFNULL(Tmp.SaldoInsoluto,Entero_Cero)),Entero_Cero),
		Dat.DiasAtraso		= Tem.DiasAtraso,
        Dat.DiasAtrasoCont	= Tmp.DiasAtraso,
		Dat.Estatus			= CASE WHEN Dat.FecTerminacion <> Fecha_Vacia AND
										Dat.FecTerminacion <= Var_FechaFin THEN EstatusPagado
									ELSE Tem.Estatus
							  END,

		Dat.FechaUltPagoVen = CASE WHEN Dat.Estatus	!= EstatusVencido THEN Cadena_Vacia
									ELSE Dat.FechaUltPagoVen
							 END,

		Dat.InteresReportado = ROUND((IFNULL(Tem.SaldoInteres,Entero_Cero) + IFNULL(Tmp.SaldoInteres,Entero_Cero)),Entero_Cero);

    UPDATE TMPDATOSCTESCREDPAG Dat, BITACORAAPLIGAR Bic SET
		Dat.FechaAtrasoCont = Bic.FechaAtraso
	WHERE Dat.CreditoContID = Bic.CreditoID;


    DROP TABLE IF EXISTS TMPDIASATRASOCRE;

	CREATE TABLE TMPDIASATRASOCRE (
		CreditoID 			BIGINT NOT NULL,
		FechaAtraso			DATE,
		INDEX TMPDIASATRASOCRE_1(CreditoID)
	);

	INSERT INTO TMPDIASATRASOCRE
		SELECT	Tem.CreditoIDSAFI, MIN(Amo.FechaExigible)
	FROM AMORTICREDITO Amo,
		 TMPDATOSCTESCREDPAG Tem
	WHERE Tem.CreditoIDSAFI = Amo.CreditoID
		AND Amo.FechaExigible <=Par_FechaCorteBC
          AND Amo.Estatus != 'P';


    UPDATE TMPDATOSCTESCREDPAG Dat, TMPDIASATRASOCRE Tmp SET
		Dat.FechaAtraso = Tmp.FechaAtraso
	WHERE Dat.CreditoIDSAFI = Tmp.CreditoID
		AND Dat.CreditoContID = Entero_Cero;

	UPDATE TMPDATOSCTESCREDPAG Dat SET
		Dat.DiasAtraso = (DATEDIFF(Par_FechaCorteBC, Dat.FechaAtraso)-Dat.GraciaMoratorios)
	WHERE Dat.DiasAtraso = NULL
		AND Dat.FechaAtraso <> Fecha_Vacia;


	UPDATE TMPDATOSCTESCREDPAG Dat SET
        Dat.DiasAtrasoCont	=( DATEDIFF(Par_FechaCorteBC, Dat.FechaAtrasoCont)-Dat.GraciaMoratorios)
	WHERE Dat.DiasAtrasoCont = NULL
		AND Dat.FechaAtrasoCont<> Fecha_Vacia;

	UPDATE TMPDATOSCTESCREDPAG Dat SET
		Dat.Vencido = Entero_Cero,
		Dat.DiasAtraso = Entero_Cero
	WHERE Dat.DiasAtraso <= Entero_Cero;


	UPDATE TMPDATOSCTESCREDPAG Dat SET
        Dat.DiasAtrasoCont = Entero_Cero
	WHERE Dat.DiasAtrasoCont <= Entero_Cero;


    UPDATE TMPDATOSCTESCREDPAG Dat SET
		Dat.DiasAtraso = CASE WHEN Dat.DiasAtraso>Dat.DiasAtrasoCont THEN
							Dat.DiasAtraso
						 ELSE
							Dat.DiasAtrasoCont END;

	  DROP TABLE IF EXISTS TMPSALDOSCREDITOCINTABC;
	  DROP TABLE IF EXISTS TMPSALDOSCREDITOCINTABCCONT;




	UPDATE TMPDATOSCTESCREDPAG
		SET ImportePagos = FUNCIONIMPORTEPAGO(CreditoIDSAFI,Par_FechaCorteBC);

	UPDATE TMPDATOSCTESCREDPAG
		SET ImportePagosCont = FUNCIONIMPORTEPAGO(CreditoContID,Par_FechaCorteBC)
	WHERE CreditoContID > Entero_Cero;

	UPDATE TMPDATOSCTESCREDPAG
		SET ImportePagos = (IFNULL(ImportePagos,Entero_Cero)+ IFNULL(ImportePagosCont,Entero_Cero));



	DROP TABLE IF EXISTS TMPMONTOCUOTACREDITO;

	CREATE TABLE TMPMONTOCUOTACREDITO (
		CreditoID BIGINT(12),
		MontoPago INT(11),
		PRIMARY KEY (CreditoID)
    );

	INSERT INTO TMPMONTOCUOTACREDITO
		SELECT Dat.CreditoIDSAFI AS CreditoID ,
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


	UPDATE TMPDATOSCTESCREDPAG Dat SET
		MOP = CASE WHEN		Dat.Estatus = EstatusVigente
						AND Dat.DiasAtraso = Entero_Cero
						AND DATEDIFF(Par_FechaCorteBC, Dat.InicioCredito) < DiasCtaReciente THEN Mop00

					WHEN	( Dat.Estatus = EstatusVigente
							  AND Dat.DiasAtraso = Entero_Cero
							  AND DATEDIFF(Par_FechaCorteBC, Dat.InicioCredito) >= DiasCtaReciente)
							OR  FechaCierre <> Fecha_Vaciaddmmyyyy THEN Mop01

					WHEN Dat.DiasAtraso  BETWEEN 1 AND 29 THEN Mop02
					WHEN Dat.DiasAtraso  BETWEEN 30 AND 59 THEN Mop03
					WHEN Dat.DiasAtraso  BETWEEN 60 AND 89 THEN Mop04
					WHEN Dat.DiasAtraso  BETWEEN 90 AND 119 THEN Mop05
					WHEN Dat.DiasAtraso  BETWEEN 120 AND 149 THEN Mop06
					WHEN Dat.DiasAtraso  BETWEEN 150 AND 365 THEN Mop07
					WHEN Dat.DiasAtraso  > 365 THEN Mop96
				END;



	UPDATE TMPDATOSCTESCREDPAG Dat
		INNER JOIN  CRECASTIGOS Cas ON Dat.CreditoIDSAFI = Cas.CreditoID SET

		Dat.FechaCierre 	= DATE_FORMAT(Cas.Fecha, FormatoFecha),
		Dat.ClaveObervacion	= ClaveObsCtaCast,
        Dat.ImportePagos	= Entero_Cero,
        Dat.Saldo			= Entero_Cero,
		Dat.MOP 			= Mop97

		WHERE Dat.Estatus = EstatusCastigado
		  AND Cas.Fecha <= Par_FechaCorteBC;

	UPDATE TMPDATOSCTESCREDPAG Dat SET
		Dat.MOP = MopUR
		WHERE DATEDIFF(Var_FechaCorte, STR_TO_DATE(Dat.FechaInicio, FormatoFecha)) > DiasTresMeses
		  AND IFNULL(Dat.MOP, Mop00) = Mop00
		  AND Dat.FrecPagos = FrecSemestralBC;


	UPDATE TMPDATOSCTESCREDPAG  SET
		MOP = MopUR
		WHERE IFNULL(MOP, Cadena_Vacia) = Cadena_Vacia
		  AND FrecPagos IN(FrecAnualBC, FrecVariableBC);

    UPDATE TMPDATOSCTESCREDPAG  SET
		ClaveObervacion = ClaveObsCtaCanc
		WHERE MOP = Mop01
		  AND Var_FechaCierre <> Separador;


	UPDATE TMPDATOSCTESCREDPAG	SET
		MOP=Mop00
	WHERE CONVERT(SUBSTRING(FechaInicio,3,2),SIGNED)=MONTH(Var_FechaFin)
		AND SUBSTRING(FechaInicio,5,4) <= YEAR(Var_FechaFin)
        AND MOP=Mop01
        AND FechaPago=Fecha_Vaciaddmmyyyy;

	DELETE FROM TMPDATOSCTESCREDPAG
	WHERE  FechaCierre != Fecha_Vaciaddmmyyyy AND FechaCierre != Cadena_Vacia
		AND CONVERT(SUBSTRING(FechaCierre,3,2),SIGNED)<MONTH(Var_FechaFin)
		AND SUBSTRING(FechaCierre,5,4) <= YEAR(Var_FechaFin);


	UPDATE TMPDATOSCTESCREDPAG
		SET Telefono = Cadena_Vacia
	WHERE LENGTH(Telefono) <> Entero_Diez;

	UPDATE TMPDATOSCTESCREDPAG Dat
		INNER JOIN MONEDAS	Mon ON Dat.MonedaID = Mon.MonedaID
	SET Dat.Moneda = Mon.EqBuroCred;

    UPDATE TMPDATOSCTESCREDPAG Dat
		SET Dat.Cuenta = CASE IFNULL(Dat.CreditoIDCte,Cadena_Vacia) WHEN Cadena_Vacia
						THEN Dat.CreditoIDSAFI
						ELSE Dat.CreditoIDCte END ;


	UPDATE TMPDATOSCTESCREDPAG SET
		ApellidoPaterno	= FNLIMPIACARACTBUROCRED(ApellidoPaterno,LimpiaAlfabetico),
		ApellidoMaterno	= FNLIMPIACARACTBUROCRED(ApellidoMaterno,LimpiaAlfabetico),
		PrimerNombre  	= FNLIMPIACARACTBUROCRED(PrimerNombre,LimpiaAlfabetico),
		SegundoNombre	= FNLIMPIACARACTBUROCRED(SegundoNombre,LimpiaAlfabetico),
		TercerNombre	= FNLIMPIACARACTBUROCRED(TercerNombre,LimpiaAlfabetico),
		Prefijo			= FNLIMPIACARACTBUROCRED(Prefijo,LimpiaAlfabetico),
		CalleNumero		= FNLIMPIACARACTBUROCRED(CalleNumero,LimpiaAlfaNumerico),
		DirComplemento	= FNLIMPIACARACTBUROCRED(DirComplemento,LimpiaAlfaNumerico),
		Colonia			= FNLIMPIACARACTBUROCRED(Colonia,LimpiaAlfaNumerico),
		Ciudad			= FNLIMPIACARACTBUROCRED(Ciudad,LimpiaAlfaNumerico),
		Municipio		= FNLIMPIACARACTBUROCRED(Municipio,LimpiaAlfaNumerico),
		Estado 			= FNLIMPIACARACTBUROCRED(Estado,LimpiaAlfabetico),
		Empresa 		= FNLIMPIACARACTBUROCRED(Empresa,LimpiaAlfaNumerico),
		CalleNumero2	= FNLIMPIACARACTBUROCRED(CalleNumero2,LimpiaAlfaNumerico),
		DirComplemento2	= FNLIMPIACARACTBUROCRED(DirComplemento2,LimpiaAlfaNumerico),
		Colonia2		= FNLIMPIACARACTBUROCRED(Colonia2,LimpiaAlfaNumerico),
		Ciudad2			= FNLIMPIACARACTBUROCRED(Ciudad2,LimpiaAlfaNumerico),
		Municipio2		= FNLIMPIACARACTBUROCRED(Municipio2,LimpiaAlfaNumerico),
		Estado2			= FNLIMPIACARACTBUROCRED(Estado,LimpiaAlfabetico),
        ApellidoPaterno	= IFNULL(IF(ApellidoPaterno=Cadena_Vacia,NULL,ApellidoPaterno),NombreNoProporcionado),
		ApellidoMaterno = IFNULL(IF(ApellidoMaterno=Cadena_Vacia,NULL,ApellidoMaterno),NombreNoProporcionado),
        TercerNombre	= IFNULL(TercerNombre,Cadena_Vacia),
		SegundoNombre	= TRIM(CONCAT(SegundoNombre,' ',TercerNombre)),

        CalleNumero		= FNLIMPIADIRBUROCRED(CalleNumero),
		CalleNumero2	= FNLIMPIADIRBUROCRED(CalleNumero2);


	UPDATE TMPDATOSCTESCREDPAG SET
		ApellidoPaterno = ApellidoMaterno,
		ApellidoMaterno = Cadena_Vacia
	WHERE ApellidoPaterno = 'X';

	UPDATE TMPDATOSCTESCREDPAG CRE
		INNER JOIN CREDITOSPLAZOS PLA ON CRE.PlazoID = PLA.PlazoID
	SET CRE.PlazoCredito = PLA.Dias / Factor_Meses;


	UPDATE TMPDATOSCTESCREDPAG Dat
		INNER JOIN PAISES Pa ON Dat.PaisResidencia = Pa.PaisID
	SET NacDomicilio = Pa.EqBuroCred;


	UPDATE TMPDATOSCTESCREDPAG Dat
		INNER JOIN PAISES Pa ON Dat.PaisID = Pa.PaisID
	SET Nacionalidad = Pa.EqBuroCred;


	UPDATE TMPDATOSCTESCREDPAG Dat SET
		Dat.Telefono =
			CASE WHEN	LENGTH(Dat.Telefono) != 10 THEN
				Cadena_Vacia
			ELSE
				Dat.Telefono END;

    DROP TABLE IF EXISTS TMP_OCUPACIONES;
	CREATE TEMPORARY TABLE TMP_OCUPACIONES(
		OcupacionID		INT(11),
        Descripcion		VARCHAR(50),
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
    SET Dat.Empresa 		= tmp.Descripcion
    WHERE Dat.TipoPersona 	= TipoPersFisica;

     DROP TABLE IF EXISTS TMP_OCUPACIONES;

    UPDATE TMPDATOSCTESCREDPAG SET
		SaldoTotal 		= Entero_Cero,
        NoCuotasAtraso	= Entero_Cero,
        Incumplimiento	= Fecha_Vaciaddmmyyyy,
        ImportePagos	= Entero_Cero
	WHERE FechaCierre 	!= Fecha_Vaciaddmmyyyy;

    UPDATE TMPDATOSCTESCREDPAG SET
		Prefijo = PrefijoSRTA
	WHERE Prefijo 	= PrefijoSRITA;


     UPDATE TMPDATOSCTESCREDPAG SET
		ImportePagos = SaldoTotal
	WHERE FrecPagos = FrecVariableBC AND IFNULL(ImportePagos, Entero_Cero) = Entero_Cero;


	DROP TABLE IF EXISTS TMPFECHACIERREBC;

	CREATE TABLE TMPFECHACIERREBC (
	  CreditoID 			BIGINT NOT NULL,
	  FechaUltimaAmo		DATE,
	  INDEX (CreditoID)
	);


	INSERT INTO TMPFECHACIERREBC
		SELECT	Tem.CreditoIDSAFI, MAX(Amo.FechaLiquida)
		FROM AMORTICREDITO Amo,
			 TMPDATOSCTESCREDPAG Tem
		WHERE Tem.CreditoIDSAFI = Amo.CreditoID
		  AND Tem.FechaCierre 	= Fecha_Vaciaddmmyyyy
		  AND Tem.Estatus = EstatusPagado
		  AND Tem.Saldo = Entero_Cero
		  AND Tem.ImportePagos = Entero_Cero
		  AND Tem.SaldoTotal = Entero_Cero
		GROUP BY Tem.CreditoIDSAFI;

	UPDATE TMPDATOSCTESCREDPAG Dat, TMPFECHACIERREBC Tem SET
		Dat.FechaCierre =  Tem.FechaUltimaAmo
	WHERE Dat.CreditoIDSAFI = Tem.CreditoID;

	 DROP TABLE IF EXISTS TMPFECHACIERREBC;


	DROP TABLE IF EXISTS TMPFECHACIERREBCCONT;

	CREATE TABLE TMPFECHACIERREBCCONT (
	  CreditoID 			BIGINT NOT NULL,
	  FechaUltimaAmo		DATE,
	  INDEX (CreditoID)
	);


	INSERT INTO TMPFECHACIERREBCCONT
		SELECT	Tem.CreditoIDSAFI, MAX(Amo.FechaLiquida)
		FROM AMORTICREDITOCONT Amo,
			 TMPDATOSCTESCREDPAG Tem
		WHERE Tem.CreditoContID = Amo.CreditoID
		  AND Tem.FechaCierre 	= Fecha_Vaciaddmmyyyy
		  AND Tem.Estatus = EstatusPagado
		  AND Tem.Saldo = Entero_Cero
		  AND Tem.ImportePagos = Entero_Cero
		  AND Tem.SaldoTotal = Entero_Cero
		GROUP BY Tem.CreditoIDSAFI;

	UPDATE TMPDATOSCTESCREDPAG Dat, TMPFECHACIERREBCCONT Tem SET
		Dat.FechaCierre =  Tem.FechaUltimaAmo
	WHERE Dat.CreditoContID = Tem.CreditoID;

	 DROP TABLE IF EXISTS TMPFECHACIERREBCCONT;


    UPDATE TMPDATOSCTESCREDPAG SET
		FechaCierre = Cadena_Vacia
	WHERE FechaCierre 	= Fecha_Vaciaddmmyyyy;

	SET Var_FechaCorteStr	:= 	DATE_FORMAT(Var_FechaCorte,FormatoFecha) ;

    UPDATE TMPDATOSCTESCREDPAG Dat SET
		Cinta = CONCAT_WS(Separador,
			`Member`,				NombreEmp,					Var_FechaCorteStr,								IFNULL(IF(Dat.ApellidoPaterno=Cadena_Vacia OR Dat.ApellidoPaterno =Espacio_Blanco,NULL,Dat.ApellidoPaterno),NombreNoProporcionado),		IFNULL(IF(Dat.ApellidoMaterno=Cadena_Vacia OR Dat.ApellidoMaterno=Espacio_Blanco,NULL,Dat.ApellidoMaterno),NombreNoProporcionado),
			Cadena_Vacia,		IFNULL(Dat.PrimerNombre,Cadena_Vacia),										IFNULL(Dat.SegundoNombre,Cadena_Vacia),					IFNULL(Dat.FechaNacimiento,Cadena_Vacia),
			IFNULL(Dat.RFC,Cadena_Vacia),					IFNULL(Dat.Prefijo,Cadena_Vacia),				IFNULL(Dat.Nacionalidad,Cadena_Vacia),					IFNULL(Dat.EstadoCivil,Soltero_BC),
            IFNULL(Dat.Sexo,Cadena_Vacia),					Cadena_Vacia,		Cadena_Vacia,				IFNULL(Dat.CalleNumero,Cadena_Vacia),					IFNULL(Dat.DirComplemento,Cadena_Vacia),
            IFNULL(Dat.Colonia,Cadena_Vacia),				IFNULL(Dat.Municipio,Cadena_Vacia),				IFNULL(Dat.Ciudad,Cadena_Vacia),	 					IFNULL(Dat.Estado,Cadena_Vacia),
            IFNULL(Dat.CP,Cadena_Vacia),					IFNULL(Dat.Telefono,Cadena_Vacia), 	 			IFNULL(Dat.NacDomicilio,Cadena_Vacia),					IFNULL(Dat.Empresa,Cadena_Vacia),
            IFNULL(Dat.CalleNumero2,Cadena_Vacia), 			IFNULL(Dat.DirComplemento2,Cadena_Vacia),		IFNULL(Dat.Colonia2,Cadena_Vacia),						IFNULL(Dat.Municipio2,Cadena_Vacia),
			IFNULL(Dat.Ciudad2,Cadena_Vacia),				IFNULL(Dat.Estado2,Cadena_Vacia), 				IFNULL(Dat.CP2,Cadena_Vacia),							IFNULL(Dat.Telefono2,Cadena_Vacia),
			IFNULL(Dat.Salario,Cadena_Vacia),				IFNULL(Dat.NacDomicilio,Cadena_Vacia), 			`Member`,				NombreEmp, 							IFNULL(Dat.Cuenta,Cadena_Vacia),
            IFNULL(Dat.Responsabilidad,Cadena_Vacia),		IFNULL(Dat.TipoCuenta,TipoCtaPagosFijos),		IFNULL(Dat.TipoContrato,Cadena_Vacia),					IFNULL(Dat.Moneda,Cadena_Vacia),
            IFNULL(Dat.NPagos,Cadena_Vacia),				IFNULL(Dat.FrecPagos,Cadena_Vacia),				IFNULL(Dat.FechaInicio,Cadena_Vacia),					IFNULL(Dat.ImportePagos,Cadena_Vacia),
			IFNULL(Dat.FechaPago,Cadena_Vacia),  			IFNULL(Dat.FechaInicio,Cadena_Vacia),			IFNULL(Dat.FechaCierre,Cadena_Vacia),					Var_FechaCorteStr,
            IFNULL(Dat.MontoCredito,Cadena_Vacia),			IFNULL(Dat.SaldoTotal,Cadena_Vacia), 			Entero_Cero, 											IFNULL(Dat.Vencido,Cadena_Vacia),
			IFNULL(Dat.NoCuotasAtraso,Cadena_Vacia),		IFNULL(Dat.MOP,MopUR),							IFNULL(Dat.ClaveObervacion,Cadena_Vacia),				Cadena_Vacia,
            Cadena_Vacia,				Cadena_Vacia,		IFNULL(Dat.Incumplimiento,Cadena_Vacia),		IFNULL(Dat.Saldo,Cadena_Vacia), 						IFNULL(Dat.MontoUltPago,Entero_Cero),
            IFNULL(Dat.PlazoCredito,Cadena_Vacia),			IFNULL(Dat.MontoCredito,Cadena_Vacia),			IFNULL(Dat.FechaUltPagoVen,Cadena_Vacia),				IFNULL(Dat.InteresReportado,Cadena_Vacia),
            IFNULL(Dat.MOP,MopUR),							IFNULL(Dat.DiasAtraso,Cadena_Vacia)),
		Cinta= CONCAT(Cinta,Separador,ifnull(Dat.CorreoElect,''),Salto_Linea);

	IF (Formato_Envio = Formato_Comas) THEN

		SET Var_Cinta := EncabezadoCVS;

		INSERT INTO BUROCREDINTFMEN
					(CintaID,		ClienteID,		Clave,	Fecha,				Cinta)
			VALUES	(Var_CintaID,	Entero_Cero,	`Member`,	Par_FechaCorteBC,	Var_Cinta);


		INSERT INTO BUROCREDINTFMEN
			(CintaID,		ClienteID,		Clave,	Fecha,				Cinta)
		SELECT  Var_CintaID,	Var_ClienteID,	`Member`,	Par_FechaCorteBC,	Dat.Cinta
			FROM TMPDATOSCTESCREDPAG Dat;

	END IF;

	DROP TABLE IF EXISTS TMPDATOSCTESCREDPAG;

END TerminaStore$$