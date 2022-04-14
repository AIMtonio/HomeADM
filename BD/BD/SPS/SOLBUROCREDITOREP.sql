-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLBUROCREDITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLBUROCREDITOREP`;
DELIMITER $$


CREATE PROCEDURE `SOLBUROCREDITOREP`(
	/*SP para el reporte de Solicitud de buro de crédito se ocupa en el prpt ReporteBuroCredito.prpt*/
	Par_FolioSol		VARCHAR(30),
	Par_Consecutivo		INT,
	Par_NumCon			INT,

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN
-- Variables cursor
DECLARE tamanio			INT;
DECLARE fechaAntCad		CHAR(10);
DECLARE VarConsecutivo	INT;
DECLARE VarCadena		VARCHAR(100);
DECLARE VarFolioBC		VARCHAR(30);
DECLARE VarFecha		DATE;
DECLARE VarTamCadena	INT;
DECLARE varFechaHis		DATE;
DECLARE VarAnio			INT;
DECLARE cadenaHis		VARCHAR(80);
DECLARE cadHisPagos		VARCHAR(150);

DECLARE varCons			INT;
DECLARE varA			CHAR(4);
DECLARE varCad			VARCHAR(100);

-- declaracion de variables
DECLARE contador 			INT;
DECLARE varcontador 		INT;
DECLARE cantRegistros 		INT;
DECLARE VarCadenaHistorico	VARCHAR(180);
DECLARE VarTamCadenaHis		INT(11);
DECLARE VarValorHis			VARCHAR(11);

-- Declaracion de variables SEGMENTO PN
DECLARE nom 			VARCHAR(50);
DECLARE nom2 			VARCHAR(50);
DECLARE ap 				VARCHAR(50);
DECLARE am 				VARCHAR(50);
DECLARE nombre 			VARCHAR(100);
DECLARE Var_RFC 		CHAR(13);
DECLARE FechaNacCad 	CHAR(10);
DECLARE FechaNac 		DATE;
DECLARE charAnio 			CHAR(4);
DECLARE mes 			CHAR(2);
DECLARE dia 			CHAR(2);
DECLARE Var_IFE 		VARCHAR(30); -- 18 soporte
DECLARE Var_CURP 		CHAR(18);
DECLARE regBCsegPN 		VARCHAR(30);
DECLARE Var_SeSolNum	VARCHAR(15); -- numero de solicitud al buro de credito.

-- Variables del Segmento de TL
DECLARE fechaApertura  		CHAR(12);
DECLARE fechaActual			CHAR(12);
DECLARE fechaUltPago		CHAR(12);
DECLARE fechaUltCompra		CHAR(12);
DECLARE Var_FechaCierre		CHAR(12);
DECLARE fechaUltCero		CHAR(12);
DECLARE fechaMaxMora1		CHAR(12);
DECLARE VarFrecPago			CHAR(12);
DECLARE VarMaximoCerradas	DECIMAL(12,2);
-- Declaracion de variables SEGMENTO PA ------
DECLARE VarRegBCsegPA 	VARCHAR(30);
-- Declaracion de variables SEGMENTO PE ------
DECLARE VarRegBCsegPE 		VARCHAR(30);
DECLARE VarFechContrata		VARCHAR(15);
DECLARE VarUltDiaEmpleo		VARCHAR(12);


DECLARE VarSaldoActual 		DECIMAL(12,2);
DECLARE VarLimiteCerradas 	DECIMAL(12,2);
DECLARE Var_CuentasAb		VARCHAR(60);
DECLARE Var_LimiteAb		DECIMAL(14,2);
DECLARE Var_MaxAb			DECIMAL(14,2);
DECLARE Var_SaldoAcAb		DECIMAL(14,2);
DECLARE Var_SaldoVenAb		DECIMAL(14,2);
DECLARE Var_PagoRealizar	DECIMAL(14,2);
DECLARE Var_CuentasCerr		MEDIUMTEXT;

DECLARE Var_CharCuentasAb	VARCHAR(60);
DECLARE Var_CharLimiteAb	VARCHAR(60);
DECLARE Var_CharMaxAb		VARCHAR(60);
DECLARE Var_CharSaldoAcAb	VARCHAR(60);
DECLARE Var_CharSaldoVenAb	VARCHAR(60);
DECLARE Var_CharPagoRealizar VARCHAR(60);
DECLARE Var_CharCuentasCerr	VARCHAR(60);
DECLARE Var_MOPMora 		VARCHAR(100);
DECLARE Var_Observacion		VARCHAR(5);

# ------------ Declaracion de constantes ------------------------
-- Tipos de consultas
DECLARE	ConSegPN		INT; # INFORMACION GENERAL
DECLARE	ConSegPA		INT; # DOMICILIOS DEL INVESTIGADO
DECLARE	ConSegPE		INT; # DOMICILIOS EMPLEO
DECLARE	ConSegIQ		INT; # DETALLE DE LAS CONSULTAS
DECLARE	ConSegHIHR		INT; # ALERTAS HAWK
DECLARE	ConSegTL		INT; # DETALLE DE LOS CREDITOS
DECLARE	ConSegRS		INT; # RESUMEN DE CREDITOS
DECLARE	ConSegSC		INT; #  SCORE
DECLARE HistPagos		INT; # Para la cadena de historico de pagos

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Entero_Cero		INT;
DECLARE Fecha_Vacia     DATE;
DECLARE	Decimal_Cero	DECIMAL(12,4);
DECLARE FechaVacia		CHAR(8);
-- Tipos de Segmentos
DECLARE 	seg0 			CHAR(2);
DECLARE 	seg1 			CHAR(2);
DECLARE 	seg2 			CHAR(2);
DECLARE 	seg3 			CHAR(2);
DECLARE 	seg4 			CHAR(2);
DECLARE 	seg5 			CHAR(2);
DECLARE 	seg6 			CHAR(2);
DECLARE 	seg7 			CHAR(2);
DECLARE 	seg8			CHAR(2);
DECLARE 	seg9			CHAR(2);
DECLARE 	seg10			CHAR(2);
DECLARE 	seg11			CHAR(2);
DECLARE 	seg12			CHAR(2);
DECLARE 	seg13			CHAR(2);
DECLARE 	seg14			CHAR(2);
DECLARE 	seg15			CHAR(2);
DECLARE 	seg16			CHAR(2);
DECLARE 	seg17			CHAR(2);
DECLARE 	seg19			CHAR(2);
DECLARE 	seg21			CHAR(2);
DECLARE 	seg22			CHAR(2);
DECLARE 	seg23			CHAR(2);
DECLARE 	seg24			CHAR(2);
DECLARE		seg25			CHAR(2);
DECLARE 	seg26			CHAR(2);
DECLARE 	seg27			CHAR(2);
DECLARE 	seg28			CHAR(2);
DECLARE 	seg29			CHAR(2);
DECLARE 	seg30			CHAR(2);
DECLARE 	seg36			CHAR(2);
DECLARE 	seg37			CHAR(2);
DECLARE 	seg38			CHAR(2);
DECLARE 	segPN 			CHAR(2);
DECLARE 	segPA			CHAR(2);
DECLARE 	segPE			CHAR(2);
DECLARE 	segIQ			CHAR(2);
DECLARE 	segHI			CHAR(2);
DECLARE 	segHR			CHAR(2);
DECLARE 	segSC			CHAR(2);
DECLARE 	segTL			CHAR(2);
DECLARE 	segRS			CHAR(2);

#------ Declaracion de constantes Segmento PE -------
-- Constantes de periodo de pago
DECLARE	Bimestral		CHAR(1);
DECLARE	BimeDescrip		VARCHAR(15);

DECLARE	Diario			CHAR(1);
DECLARE	DiarioDescrip	VARCHAR(15);

DECLARE	PorHora			CHAR(1);
DECLARE	PorHoDescrip	VARCHAR(15);

DECLARE	Catorcenal		CHAR(1);
DECLARE	CatorDescrip	VARCHAR(15);

DECLARE	Mensual			CHAR(1);
DECLARE	MensualDescrip	VARCHAR(15);

DECLARE	Quincenal		CHAR(1);
DECLARE	QuincDescrip	VARCHAR(15);

DECLARE	Semanal			CHAR(1);
DECLARE	SemaDescrip		VARCHAR(15);

DECLARE	Anual			CHAR(1);
DECLARE	AnualDescrip	VARCHAR(15);


#------- Declaracion de constantes Segmento IQ ------
DECLARE	UsuarioAut		CHAR(1);	-- Usuario Autorizado (Adicionales)
DECLARE	Individual		CHAR(1);
DECLARE	Mancomunado		CHAR(1);
DECLARE	ObligadoSolid	CHAR(1);	-- Obligado Solidario
DECLARE	RespDescUsu		VARCHAR(30);	-- Descripcion usuario del tipo de responsabilidad de acuerdo manual BC
DECLARE	RespDescIndiv	VARCHAR(30);	-- Descripcion individual del tipo de responsabilidad de acuerdo manual BC
DECLARE	RespDescManc	VARCHAR(30);	-- Descripcion mancomunado del tipo de responsabilidad de acuerdo manual BC
DECLARE	RespDescOSol	VARCHAR(30);	-- Descripcion obligado solidario del tipo de responsabilidad de acuerdo manual BC
-- constantes de codigo de tipo de contrato de acuerdo anexo 2 manual BC  segmento IQ
DECLARE	MueblesCod		CHAR(2);
DECLARE	MuebDescrip		VARCHAR(40);

DECLARE	AgropecuaCod	CHAR(2);
DECLARE	AgropDescrip	VARCHAR(40);

DECLARE	ArrAutoamCod	CHAR(2);
DECLARE	ArrAutoDescrip	VARCHAR(40);

DECLARE	AviacionCod		CHAR(2);
DECLARE	AviacDescrip	VARCHAR(40);

DECLARE	ComAutoCod		CHAR(2);
DECLARE	ComAutoDescrip	VARCHAR(40);

DECLARE	FianzaCod		CHAR(2);
DECLARE	FianzaDescrip	VARCHAR(40);

DECLARE	BoteCod			CHAR(2);
DECLARE	BoteDescrip		VARCHAR(40);

DECLARE	TarjCredCod		CHAR(2);
DECLARE	TarjCredDescrip	VARCHAR(40);

DECLARE	CartasCredCod	CHAR(2);
DECLARE	CarCredDescrip	VARCHAR(40);

DECLARE	CredFiscalCod	CHAR(2);
DECLARE	CreFiscDescrip	VARCHAR(40);

DECLARE	LineaCredCod	CHAR(2);
DECLARE	LinCredDescrip	VARCHAR(40);

DECLARE	ConsolidCod		CHAR(2);
DECLARE	ConsolidDescrip	VARCHAR(40);

DECLARE	CredSimpCod		CHAR(2);
DECLARE	CredSimpDescrip	VARCHAR(40);

DECLARE	ConColaterCod	CHAR(2);
DECLARE	ConColaDescrip	VARCHAR(40);

DECLARE	DescuentCod		CHAR(2);
DECLARE	DescDescrip		VARCHAR(40);

DECLARE	EquipoCod		CHAR(2);
DECLARE	EquipoDescrip	VARCHAR(40);

DECLARE	FideicomCod		CHAR(2);
DECLARE	FideiDescrip	VARCHAR(40);

DECLARE	FactorajCod		CHAR(2);
DECLARE	FactoDescrip	VARCHAR(30);

DECLARE	HabilAvioCod	CHAR(2);
DECLARE	HabAvDescrip	VARCHAR(40);

DECLARE	HomeEquiCod		CHAR(2);
DECLARE	HomeEqDescrip	VARCHAR(40);

DECLARE	MejorCasaCod	CHAR(2);
DECLARE	MejCaDescrip	VARCHAR(40);

DECLARE	LinCreReinsCod	CHAR(2);
DECLARE	LCreReiDescrip	VARCHAR(40);

DECLARE	ArrendamienCod	CHAR(2);
DECLARE	ArrendaDescrip	VARCHAR(40);

DECLARE	OtrosCod		CHAR(2);
DECLARE	OtrosDescrip	VARCHAR(40);

DECLARE	OAdeuVencCod	CHAR(2);
DECLARE	OAdeVeDescrip	VARCHAR(40);

DECLARE	PrePFAEmpCod	CHAR(2);
DECLARE	PrePFAEmpDescr	VARCHAR(70);

DECLARE	EditorialCod	CHAR(2);
DECLARE	EditorDescrip	VARCHAR(40);

DECLARE	PreGarUnInCod	CHAR(2);
DECLARE	PreGarUInDescr	VARCHAR(80);

DECLARE	PresPersonCod	CHAR(2);
DECLARE	PrePerDescrip	VARCHAR(40);

DECLARE	PresNominaCod	CHAR(2);
DECLARE	PreNomiDescrip	VARCHAR(40);

DECLARE	QuirografCod	CHAR(2);
DECLARE	QuirogDescrip	VARCHAR(40);

DECLARE	PrendarioCod	CHAR(2);
DECLARE	PrendaDescrip	VARCHAR(40);

DECLARE	PagoServiCod	CHAR(2);
DECLARE	PagoSerDescrip	VARCHAR(40);

DECLARE	RestructCod		CHAR(2);
DECLARE	RestructDescrip	VARCHAR(40);

DECLARE	RedescuentoCod	CHAR(2);
DECLARE	RedescDescrip	VARCHAR(40);

DECLARE	BienesRaiCod	CHAR(2);
DECLARE	BienRaiDescrip	VARCHAR(40);

DECLARE	RefaccionCod	CHAR(2);
DECLARE	RefaccDescrip	VARCHAR(40);

DECLARE	RenovadoCod		CHAR(2);
DECLARE	RenovDescrip	VARCHAR(40);

DECLARE	VehicRecreCod	CHAR(2);
DECLARE	VehiRecDescrip	VARCHAR(40);

DECLARE	TarjGaranCod	CHAR(2);
DECLARE	TarGarDescrip	VARCHAR(40);

DECLARE	PresGaranCod	CHAR(2);
DECLARE	PreGarDescrip	VARCHAR(40);

DECLARE	SegurosCod		CHAR(2);
DECLARE	SegurosDescrip	VARCHAR(40);

DECLARE	SegHipotecaCod	CHAR(2);
DECLARE	SegHipoDescrip	VARCHAR(40);

DECLARE	PresEstudiaCod	CHAR(2);
DECLARE	PresEstDescrip	VARCHAR(40);

DECLARE	TarjCreEmpCod	CHAR(2);
DECLARE	TaCreEDescrip	VARCHAR(40);

DECLARE	DesconocCod		CHAR(2);
DECLARE	DescoDescrip	VARCHAR(40);

DECLARE	PresNoGarCod	CHAR(2);
DECLARE	PNoGarDescrip	VARCHAR(40);

#------- Declaracion de constantes Segmento HI HR -----
DECLARE	Var_Otorgante	VARCHAR(15);
DECLARE	Var_BDDBC		VARCHAR(15);


# ------- Declaracion de constantes Segmento SC -----
-- constantes de codigo del valor de score
DECLARE	NEndeudCod		INT;
DECLARE	NEndeudDesc		VARCHAR(100);

DECLARE	SaldoVenAcCod	INT;
DECLARE	SaldoVenAcDes	VARCHAR(100);

DECLARE	SalVAcRevCod	INT;
DECLARE	SalVAcRevDes	VARCHAR(100);

DECLARE	ConsRecienCod	INT;
DECLARE	ConsRecienDes	VARCHAR(100);

DECLARE	CtaMorHistCod	INT;
DECLARE	CtaMorHistDes	VARCHAR(100);

DECLARE	CtaMorCreHCod	INT;
DECLARE	CtaMorCreHDes	VARCHAR(100);

DECLARE	NumCtasMorCod	INT;
DECLARE	NumCtasMorDes	VARCHAR(100);

DECLARE	AumCtasMorCod	INT;
DECLARE	AumCtasMorDes	VARCHAR(100);

DECLARE	PBajAntTCreCod	INT;
DECLARE	PBajAntTCreDes	VARCHAR(100);

DECLARE	PBajAntTCDepCod	INT;
DECLARE	PBajAntTCDepDes	VARCHAR(100);

DECLARE	PBajAntTCRevCod	INT;
DECLARE	PBajAntTCRevDes	VARCHAR(100);

DECLARE	TCreMayRiesCod	INT;
DECLARE	TCreMayRiesDes	VARCHAR(100);

DECLARE	NumCtasAbieCod	INT;
DECLARE	NumCtasAbieDes	VARCHAR(100);

DECLARE	NumCtasRevACod	INT;
DECLARE	NumCtasRevADes	VARCHAR(100);

DECLARE	PropASalLimCCod	INT;
DECLARE	PropASalLimCDes	VARCHAR(100);

DECLARE	UltCtaApRecCod	INT;
DECLARE	UltCtaApRecDes	VARCHAR(100);

DECLARE	CtasMorRecCod	INT;
DECLARE	CtasMorRecDes	VARCHAR(100);

DECLARE	CtaMAntARecCod	INT;
DECLARE	CtaMAntARecDes	VARCHAR(100);

DECLARE	CtaRevMARecCod	INT;
DECLARE	CtaRevMARecDes	VARCHAR(100);

DECLARE	RelCtasMorYsCod	INT;
DECLARE	RelCtasMorYsDes	VARCHAR(100);

DECLARE	RelExpMorHCCod	INT;
DECLARE	RelExpMorHCDes	VARCHAR(100);

DECLARE	ConDifInstCod	INT;
DECLARE	ConDifInstDes	VARCHAR(100);

DECLARE	ConUlt48MCod	INT;
DECLARE	ConUlt48MDes	VARCHAR(100);

DECLARE	VarCtasPlazCod	INT;
DECLARE	VarCtasPlazDes	VARCHAR(100);

DECLARE	ConUlt6MCod		INT;
DECLARE	ConUlt6MDes		VARCHAR(100);

DECLARE	ConCerUl48MCod	INT;
DECLARE	ConCerUl48MDes	VARCHAR(100);

DECLARE	PropAlSalLCCod	INT;
DECLARE	PropAlSalLCDes	VARCHAR(100);

DECLARE	CtasAbUlt48Cod	INT;
DECLARE	CtasAbUlt48Des	VARCHAR(100);

-- constantes de codigo de error de score
DECLARE	SolNoAutCod	INT;
DECLARE	SolNoAutDes	VARCHAR(45);

DECLARE	SolSCInvalCod	INT;
DECLARE	SolSCInvalDes	VARCHAR(45);

DECLARE	SCNoDisponCod	INT;
DECLARE	SCNoDisponDes	VARCHAR(45);

#-------- Constantes Segmento TL --------
-- Constante de Tipods de Credito
DECLARE ApMueblesClave	 	CHAR(2);
DECLARE ApMueblesDes	 	VARCHAR(100);

DECLARE AgropeClave		 	CHAR(2);
DECLARE AgropeDes		 	VARCHAR(100);

DECLARE ArrAutoClave	 	CHAR(2);
DECLARE ArrAutoDes	    	VARCHAR(100);

DECLARE AviacionClave	 	CHAR(2);
DECLARE AviacionDes      	VARCHAR(100);

DECLARE CompAutoClave		CHAR(2);
DECLARE CompAutoDes     	VARCHAR(100);

DECLARE FianzaClave			CHAR(2);
DECLARE FianzaDes   		VARCHAR(100);

DECLARE BoteLanClave		CHAR(2);
DECLARE BoteLanDes      	VARCHAR(100);

DECLARE TarCreClave			CHAR(2);
DECLARE TarCreDes       	VARCHAR(100);

DECLARE CarCreClave			CHAR(2);
DECLARE CarCreDes       	VARCHAR(100);

DECLARE CreFisClave			CHAR(2);
DECLARE CreFisDes       	VARCHAR(100);

DECLARE LinCreClave			CHAR(2);
DECLARE LinCreDes       	VARCHAR(100);

DECLARE ConsoClave			CHAR(2);
DECLARE ConsoDes        	VARCHAR(100);

DECLARE CreSimClave			CHAR(2);
DECLARE CreSimDes       	VARCHAR(100);

DECLARE ConColClave			CHAR(2);
DECLARE ConColDes      	 	VARCHAR(100);

DECLARE DescuClave			CHAR(2);
DECLARE DescuDes        	VARCHAR(100);

DECLARE EqClave				CHAR(2);
DECLARE EqDes           	VARCHAR(100);

DECLARE FideiClave			CHAR(2);
DECLARE FideiDes        	VARCHAR(100);

DECLARE FacClave			CHAR(2);
DECLARE FacDes          	VARCHAR(100);

DECLARE HabilClave			CHAR(2);
DECLARE HabilDes        	VARCHAR(100);

DECLARE PresHomeClave		CHAR(2);
DECLARE PresHomeDes     	VARCHAR(100);

DECLARE MejCasaClave		CHAR(2);
DECLARE MejCasaDes     	 	VARCHAR(100);

DECLARE ArrenClave			CHAR(2);
DECLARE ArrenDes        	VARCHAR(100);

DECLARE OtrosClave			CHAR(2);
DECLARE OtrosDes       		VARCHAR(100);

DECLARE OtrosAdVenClave		CHAR(2);
DECLARE OtrosAdVenDes       VARCHAR(100);

DECLARE PresPFAEClave		CHAR(2);
DECLARE PresPFAEDes         VARCHAR(100);

DECLARE EditorialClave		CHAR(2);
DECLARE EditorialDes        VARCHAR(100);

DECLARE PresGUEClave		CHAR(2);
DECLARE PresGUEDes          VARCHAR(100);

DECLARE PresPerClave		CHAR(2);
DECLARE PresPerDes          VARCHAR(100);

DECLARE PresNomClave		CHAR(2);
DECLARE PresNomDes          VARCHAR(100);

DECLARE PrendaClave			CHAR(2);
DECLARE PrendaDes           VARCHAR(100);

DECLARE QuiroClave			CHAR(2);
DECLARE QuiroDes            VARCHAR(100);

DECLARE RestruClave			CHAR(2);
DECLARE RestruDes           VARCHAR(100);

DECLARE RedesClave			CHAR(2);
DECLARE RedesDes            VARCHAR(100);

DECLARE BienRaiClave		CHAR(2);
DECLARE BienRaiDes          VARCHAR(100);

DECLARE RefacClave			CHAR(2);
DECLARE RefacDes            VARCHAR(100);

DECLARE RenoClave			CHAR(2);
DECLARE RenoDes             VARCHAR(100);

DECLARE VehiRecClave		CHAR(2);
DECLARE VehiRecDes          VARCHAR(100);

DECLARE TarGarClave			CHAR(2);
DECLARE TarGarDes           VARCHAR(100);

DECLARE PreGarClave			CHAR(2);
DECLARE PreGarDes           VARCHAR(100);

DECLARE SegurClave			CHAR(2);
DECLARE SegurDes            VARCHAR(100);

DECLARE SegHipoClave		CHAR(2);
DECLARE SegHipoDes          VARCHAR(100);

DECLARE PresEstClave		CHAR(2);
DECLARE PresEstDes          VARCHAR(100);

DECLARE TarCreEmpClave		CHAR(2);
DECLARE TarCreEmpDes        VARCHAR(100);

DECLARE DesconoClave		CHAR(2);
DECLARE DesconoDes          VARCHAR(100);

DECLARE PresNoGarClave		CHAR(2);
DECLARE PresNoGarDes        VARCHAR(100);
-- Tipos de Cuenta
DECLARE PagFijosClave		CHAR(1);
DECLARE PagFijosDes			VARCHAR(50);
DECLARE HipoClave			CHAR(1);
DECLARE HipoDes				VARCHAR(50);
DECLARE SinLimPresClave		CHAR(1);
DECLARE SinLimPresDes		VARCHAR(50);
DECLARE RevolvenClave		CHAR(1);
DECLARE RevolvenDes			VARCHAR(50);
DECLARE CredRepDunClave		CHAR(1);
DECLARE CredRepDunDes		VARCHAR(50);

-- Tipo Responsabilidad
DECLARE IndiClave			CHAR(1);
DECLARE IndiDes				VARCHAR(50);
DECLARE MancomClave			CHAR(1);
DECLARE MancomDes			VARCHAR(50);
DECLARE ObSolClave			CHAR(1);
DECLARE ObSolDes			VARCHAR(50);

-- MOP(Forma de Pago)
DECLARE CtaSinInfClave		CHAR(2);
DECLARE CtaSinInfDes        VARCHAR(60);

DECLARE RecienAperClave		CHAR(2);
DECLARE RecienAperDes       VARCHAR(60);

DECLARE CorrienClave		CHAR(2);
DECLARE CorrienDes          VARCHAR(60);

DECLARE Atras0129Clave		CHAR(2);
DECLARE Atras0129Des        VARCHAR(60);

DECLARE Atras3059Clave		CHAR(2);
DECLARE Atras3059Des        VARCHAR(60);

DECLARE Atras6089Clave		CHAR(2);
DECLARE Atras6089Des        VARCHAR(60);

DECLARE Atras9019Clave		CHAR(2);
DECLARE Atras9019Des        VARCHAR(60);

DECLARE Atras2049Clave		CHAR(2);
DECLARE Atras2049Des        VARCHAR(60);

DECLARE Atras5012Clave		CHAR(2);
DECLARE Atras5012Des        VARCHAR(60);

DECLARE Atras12MClave		CHAR(2);
DECLARE Atras12MDes         VARCHAR(60);

DECLARE CtaCastigClave		CHAR(2);
DECLARE CtaCastigDes        VARCHAR(60);

DECLARE FraudCliClave		CHAR(2);
DECLARE FraudCliDes			VARCHAR(60);

/* DECLARACION DE CURSORES*/
DECLARE  CursorHis  CURSOR FOR
	SELECT Consecutivo, CadenaHistorico, FolioConsultaBC, FechaAntigua,	TamCadenaHis
		FROM tmp_hisPagBuro
		WHERE FolioConsultaBC=Par_FolioSol;

DECLARE CursorAnio CURSOR FOR
	SELECT Anio, Consecutivo FROM tmp_histoFecha WHERE Consecutivo = Par_Consecutivo GROUP BY Anio, Consecutivo;

SET Par_FolioSol := IFNULL(Par_FolioSol,0);
#----------- Asignacion de constantes -------------
-- Tipos de Consultas
SET	ConSegPN	:=	1;
SET	ConSegPA	:=	2;
SET	ConSegPE	:=	3;
SET	ConSegHIHR	:=	4;
SET ConSegSC	:=	5;
SET ConSegTL	:=  6;
SET ConSegRS	:=  7;
SET ConSegIQ	:=  8;
SET HistPagos	:=	9;

SET	Cadena_Vacia:= '';
SET	Decimal_Cero:= 0.0;
SET	Entero_Cero	:= 0;
SET	Fecha_Vacia	:= '1900-01-01';
SET FechaVacia	:= '01011900';
SET cadHisPagos := '';
-- Segmentos
SET seg0		:= '00';
SET seg1		:= '01';
SET seg2		:= '02';
SET seg3		:= '03';
SET seg4		:= '04';
SET seg5		:= '05';
SET seg6		:= '06';
SET seg7		:= '07';
SET seg8		:= '08';
SET seg9		:= '09';
SET seg10		:= '10';
SET seg11		:= '11';
SET seg12		:= '12';
SET seg13		:= '13';
SET seg14		:= '14';
SET seg15		:= '15';
SET seg16		:= '16';
SET seg17		:= '17';
SET	seg19		:= '19';
SET seg21		:= '21';
SET seg22		:= '22';
SET seg23		:= '23';
SET seg24		:= '24';
SET seg25		:= '25';
SET seg26		:= '26';
SET seg27		:= '27';
SET seg28		:= '28';
SET seg29		:= '29';
SET seg30		:= '30';
SET seg36		:= '36';
SET seg37		:= '37';
SET seg38		:= '38';
SET segPN 		:= 'PN';
SET segPA 		:= 'PA';
SET segIQ		:= 'IQ';
SET segPE		:= 'PE';
SET segHI		:= 'HI';
SET segHR		:= 'HR';
SET segSC		:= 'SC';
SET segTL		:= 'TL';
SET segRS		:= 'RS';
-- Asignacion de Constantes segmento PE
-- Constantes de periodo de pago
SET	Bimestral		:= 'B';
SET	BimeDescrip		:= 'Bimestral';

SET	Diario			:= 'D';
SET	DiarioDescrip	:= 'Diario';

SET	PorHora			:= 'H';
SET	PorHoDescrip	:= 'PorHora';

SET	Catorcenal		:= 'K';
SET	CatorDescrip	:= 'Catorcenal';

SET	Mensual			:= 'M';
SET	MensualDescrip	:= 'Mensual';

SET	Quincenal		:= 'S';
SET	QuincDescrip	:= 'Quincenal';

SET	Semanal			:= 'W';
SET	SemaDescrip		:= 'Semanal';

SET	Anual			:= 'Y';
SET	AnualDescrip	:= 'Anual';

-- Asignacion de Constantes segmento IQ
SET	UsuarioAut		:= 'A';
SET	Individual		:= 'I';
SET	Mancomunado		:= 'M';
SET	ObligadoSolid	:= 'C';
SET	RespDescUsu		:= 'USUARIO AUTORIZADO';
SET	RespDescIndiv	:= 'INDIVIDUAL';
SET	RespDescManc	:= 'MANCOMUNADO';
SET	RespDescOSol	:= 'OBLIGADO SOLIDARIO';

-- Constantes  de codigo de tipo de contrato de acuerdo anexo 2 manual BC segmento IQ
SET	MueblesCod		:= 'AF';
SET	MuebDescrip		:= 'APARATOS/MUEBLES';

SET	AgropecuaCod	:= 'AG';
SET	AgropDescrip	:= 'AGROPECUARIO(PFAE)';

SET	ArrAutoamCod	:= 'AL';
SET	ArrAutoDescrip	:= 'ARRENDAMIENTO AUTOMOTRIZ';

SET	AviacionCod		:= 'AP';
SET	AviacDescrip	:= 'AVIACION';

SET	ComAutoCod		:= 'AU';
SET	ComAutoDescrip	:= 'COMPRA DE AUTOMOVIL';

SET	FianzaCod		:= 'BD';
SET	FianzaDescrip	:= 'FIANZA';

SET	BoteCod			:= 'BT';
SET	BoteDescrip		:= 'BOTE / LANCHA';

SET	TarjCredCod		:= 'CC';
SET	TarjCredDescrip	:= 'TARJETA DE CREDITO';

SET	CartasCredCod	:= 'CE';
SET	CarCredDescrip	:= 'CARTAS DE CREDITO (PFAE)';

SET	CredFiscalCod	:= 'CF';
SET	CreFiscDescrip	:= 'CREDITO FISCAL';

SET	LineaCredCod	:= 'CL';
SET	LinCredDescrip	:= 'LINEA DE CREDITO';

SET	ConsolidCod		:= 'CO';
SET	ConsolidDescrip	:= 'CONSOLIDACION';

SET	CredSimpCod		:= 'CS';
SET	CredSimpDescrip	:= 'CREDITO SIMPLE (PFAE)';

SET	ConColaterCod	:= 'CT';
SET	ConColaDescrip	:= 'CON  COLATERAL (PFAE)';

SET	DescuentCod		:= 'DE';
SET	DescDescrip		:= 'DESCUENTOS (PFAE)';

SET	EquipoCod		:= 'EQ';
SET	EquipoDescrip	:= 'EQUIPO';

SET	FideicomCod		:= 'FI';
SET	FideiDescrip	:= 'FIDEICOMISO (PFAE)';

SET	FactorajCod		:= 'FT';
SET	FactoDescrip	:= 'FACTORAJE';

SET	HabilAvioCod	:= 'HA';
SET	HabAvDescrip	:= 'HABILITACION O AVIO (PFAE)';

SET	HomeEquiCod		:= 'HE';
SET	HomeEqDescrip	:= 'PRESTAMO TIPO HOME "EQUITY”';

SET	MejorCasaCod	:= 'HI';
SET	MejCaDescrip	:= 'MEJORAS A LA CASA';

SET	LinCreReinsCod	:= 'LR';
SET	LCreReiDescrip	:= 'LINEA DE CREDITO REINSTALABLE';

SET	ArrendamienCod	:= 'LS';
SET	ArrendaDescrip	:= 'ARRENDAMIENTO';

SET	OtrosCod		:= 'MI';
SET	OtrosDescrip	:= 'OTROS';

SET	OAdeuVencCod	:= 'OA';
SET	OAdeVeDescrip	:= 'OTROS ADEUDOS VENCIDOS (PFAE)';

SET	PrePFAEmpCod	:= 'PA';
SET	PrePFAEmpDescr	:= 'PRESTAMO PARA PERSONAS FISICAS CON ACTIVIDAD EMPRESARIAL (PFAE)';

SET	EditorialCod	:= 'PB';
SET	EditorDescrip	:= 'EDITORIAL';

SET	PreGarUnInCod	:= 'PG';
SET	PreGarUInDescr	:= 'PGUE - PRESTAMO COMO GARANTIA DE UNIDADES INDUSTRIALES PARA PFAE';

SET	PresPersonCod	:= 'PL';
SET	PrePerDescrip	:= 'PRESTAMO PERSONAL';

SET	PresNominaCod	:= 'PN';
SET	PreNomiDescrip	:= 'PRESTAMO DE NOMINA';

SET	QuirografCod	:= 'PQ';
SET	QuirogDescrip	:= 'QUIROGRAFARIO (PFAE)';

SET	PrendarioCod	:= 'PR';
SET	PrendaDescrip	:= 'Prendario (PFAE)';

SET	PagoServiCod	:= 'PS';
SET	PagoSerDescrip	:= 'PAGO DE SERVICIOS';

SET	RestructCod		:= 'RC';
SET	RestructDescrip	:= 'REESTRUCTURADO (PFAE)';

SET	RedescuentoCod	:= 'RD';
SET	RedescDescrip	:= 'Redescuento (PFAE)';

SET	BienesRaiCod	:= 'RE';
SET	BienRaiDescrip	:= 'Bienes Raíces';

SET	RefaccionCod	:= 'RF';
SET	RefaccDescrip	:= 'REFACCIONARIO (PFAE)';

SET	RenovadoCod		:= 'RN';
SET	RenovDescrip	:= 'RENOVADO (PFAE)';

SET	VehicRecreCod	:= 'RV';
SET	VehiRecDescrip	:= 'VEHICULO RECREATIVO';

SET	TarjGaranCod	:= 'SC';
SET	TarGarDescrip	:= 'TARJETA GARANTIZADA';

SET	PresGaranCod	:= 'SE';
SET	PreGarDescrip	:= 'PRESTAMO GARANTIZADO';

SET	SegurosCod		:= 'SG';
SET	SegurosDescrip	:= 'SEGUROS';

SET	SegHipotecaCod	:= 'SM';
SET	SegHipoDescrip	:= 'SEGUNDA HIPOTECA';

SET	PresEstudiaCod	:= 'ST';
SET	PresEstDescrip	:= 'PRESTAMO PARA ESTUDIANTE';

SET	TarjCreEmpCod	:= 'TE';
SET	TaCreEDescrip	:= 'TARJETA DE CREDITO EMPRESARIAL';

SET	DesconocCod		:= 'UK';
SET	DescoDescrip	:= 'DESCONOCIDO';

SET	PresNoGarCod	:= 'US';
SET	PNoGarDescrip	:= 'PRESTAMO NO GARANTIZADO';


SET	Var_Otorgante	:= 'OTORGANTE';
SET	Var_BDDBC		:= 'BDD BC';



SET	NEndeudCod		:= 1;
SET	NEndeudDesc		:= 'NIVEL DE ENDEUDAMIENTO';

SET	SaldoVenAcCod	:= 2;
SET	SaldoVenAcDes	:= 'SALDO VENCIDO ACTUAL';

SET	SalVAcRevCod	:= 3;
SET	SalVAcRevDes	:= 'SALDO VENCIDO ACTUAL EN CUENTAS REVOLVENTES';

SET	ConsRecienCod	:= 4;
SET	ConsRecienDes	:= 'CONSULTA MUY RECIENTE';

SET	CtaMorHistCod	:= 5;
SET	CtaMorHistDes	:= 'CUENTAS CON MOROSIDAD EN EL HISTORICO (MAXIMO 48 MESES)';

SET	CtaMorCreHCod	:= 6;
SET	CtaMorCreHDes	:= 'CUENTAS CON MOROSIDAD EN CREDITOS HIPOTECARIOS (MAXIMO 48 MESES)';

SET	NumCtasMorCod	:= 7;
SET	NumCtasMorDes	:= 'NUMERO DE CUENTAS CON MOROSIDAD';

SET	AumCtasMorCod	:= 8;
SET	AumCtasMorDes	:= 'AUMENTO DE CUENTAS CON MOROSIDAD';

SET	PBajAntTCreCod	:= 9;
SET	PBajAntTCreDes	:= 'PROMEDIO BAJO DE ANTIGÜEDAD EN EL TOTAL DE LOS CREDITOS';

SET	PBajAntTCDepCod	:= 10;
SET	PBajAntTCDepDes	:= 'PROMEDIO BAJO DE ANTIGÜEDAD EN EL TOTAL DE LOS CREDITOS DEPARTAMENTALES';

SET	PBajAntTCRevCod	:= 11;
SET	PBajAntTCRevDes	:= 'PROMEDIO BAJO DE ANTIGÜEDAD EN EL TOTAL DE LOS CREDITOS REVOLVENTES';

SET	TCreMayRiesCod	:= 12;
SET	TCreMayRiesDes	:= 'TIPO DE CREDITO CON MAYOR RIESGO';

SET	NumCtasAbieCod	:= 13;
SET	NumCtasAbieDes	:= 'NUMERO DE CUENTAS ABIERTAS';

SET	NumCtasRevACod	:= 14;
SET	NumCtasRevADes	:= 'NUMERO DE CUENTAS REVOLVENTES';

SET	PropASalLimCCod	:= 15;
SET	PropASalLimCDes	:= 'PROPORCION ALTA ENTRE SALDOS CONTRA LIMITES DE CREDITO REVOLVENTES';

SET	UltCtaApRecCod	:= 16;
SET	UltCtaApRecDes	:= 'ULTIMA CUENTA NUEVA APERTURADA RECIENTEMENTE';

SET	CtasMorRecCod	:= 17;
SET	CtasMorRecDes	:= 'CUENTAS CON MOROSIDAD RECIENTE';

SET	CtaMAntARecCod	:= 18;
SET	CtaMAntARecDes	:= 'CUENTA MAS ANTIGUA APERTURADA RECIENTEMENTE';

SET	CtaRevMARecCod	:= 19;
SET	CtaRevMARecDes	:= 'CUENTA REVOLVENTE MAS ANTIGUA APERTURADA RECIENTEMENTE';

SET	RelCtasMorYsCod	:= 20;
SET	RelCtasMorYsDes	:= 'RELACION ENTRE CUENTAS CON MOROSIDAD Y SIN MOROSIDAD';

SET	RelExpMorHCCod	:= 21;
SET	RelExpMorHCDes	:= 'RELACION ENTRE EXPERIENCIAS CON MOROSIDAD Y SIN MOROSIDAD EN EL HISTORIAL CREDITICIO';

SET	ConDifInstCod	:= 22;
SET	ConDifInstDes	:= 'CONSULTAS DE DIFERENTES INSTITUCIONES';

SET	ConUlt48MCod	:= 23;
SET	ConUlt48MDes	:= 'CONSULTAS EN LOS ULTIMOS 48 MESES';

SET	VarCtasPlazCod	:= 24;
SET	VarCtasPlazDes	:= 'VARIAS CUENTAS A PLAZO';

SET	ConUlt6MCod		:= 26;
SET	ConUlt6MDes		:= 'CONSULTAS EN LOS ULTIMOS 6 MESES';

SET	ConCerUl48MCod	:= 27;
SET	ConCerUl48MDes	:= 'CONSULTAS CERRADAS EN LOS ULTIMOS 48 MESES';

SET	PropAlSalLCCod	:= 28;
SET	PropAlSalLCDes	:= 'PROPORCION ALTA ENTRE SALDOS CONTRA LIMITES DE CREDITO';

SET	CtasAbUlt48Cod	:= 29;
SET	CtasAbUlt48Des	:= 'CUENTAS ABIERTAS EN LOS ULTIMOS 48 MESES';

-- constantes de codigo de error de score
SET	SolNoAutCod		:= 1;
SET	SolNoAutDes		:= 'SOLICITUD NO AUTORIZADA';

SET	SolSCInvalCod	:= 2;
SET	SolSCInvalDes	:= 'SOLICITUD DE SCORE INVALIDA';

SET	SCNoDisponCod	:= 3;
SET	SCNoDisponDes	:= 'SCORE NO DISPONIBLE';

#-------- Constantes Segmento TL --------
-- Constante de Tipods de Credito
SET ApMueblesClave	 	:='AF';
SET ApMueblesDes	 	:='APARATOS/MUEBLES';

SET AgropeClave		 	:='AG';
SET AgropeDes		 	:='AGROPECUARIO (PFAE)';

SET ArrAutoClave	 	:='AL';
SET ArrAutoDes	     	:='ARRENDAMIENTO AUTOMOTRIZ';

SET AviacionClave	 	:='AP';
SET AviacionDes      	:='AVIACIÓN';

SET CompAutoClave		:='AU';
SET CompAutoDes     	:='COMPRA DE AUTOMÓVIL';

SET FianzaClave			:='BD';
SET FianzaDes   		:='FIANZA';

SET BoteLanClave		:='BT';
SET BoteLanDes      	:='BOTE/LANCHA';

SET TarCreClave			:='CC';
SET TarCreDes       	:='TARJETA DE CRÉDITO';

SET CarCreClave			:='CE';
SET CarCreDes       	:='CARTAS DE CRÉDITO (PFAE)';

SET CreFisClave			:='CF';
SET CreFisDes       	:='CRÉDITO FISCAL';

SET LinCreClave			:='CL';
SET LinCreDes       	:='LÍNEA DE CRÉDITO';

SET ConsoClave			:='CO';
SET ConsoDes        	:='CONSOLIDACIÓN';

SET CreSimClave			:='CS';
SET CreSimDes       	:='CRÉDITO SIMPLE';

SET ConColClave			:='CT';
SET ConColDes      	 	:='CON COLATERAL (PFAE)';

SET DescuClave			:='DE';
SET DescuDes        	:='DESCUENTOS (PFAE)';

SET EqClave				:='EQ';
SET EqDes           	:='EQUIPO';

SET FideiClave			:='FI';
SET FideiDes        	:='FIDEICOMISO (PFAE)';

SET FacClave			:='FT';
SET FacDes          	:='FACTORAJE';

SET HabilClave			:='HA';
SET HabilDes        	:='HABILITACIÓN O AVÍO (PFAE)';

SET PresHomeClave		:='HE';
SET PresHomeDes     	:='PRÉSTAMO TIPO HOME EQUITY';

SET MejCasaClave		:='HI';
SET MejCasaDes     	 	:='MEJORAS A LA CASA';

SET ArrenClave			:='LS';
SET ArrenDes        	:='ARRENDAMIENTO';

SET OtrosClave			:='MI';
SET OtrosDes       		:='OTROS';

SET OtrosAdVenClave		:='OA';
SET OtrosAdVenDes       :='OTROS ADEUDOS VENCIDOS (PFAE)';

SET PresPFAEClave		:='PA';
SET PresPFAEDes         :='PRÉSTAMO PARA PERSONAS FÍSICAS CON ACTIVIDAD EMPRESARIAL (PFAE)';

SET EditorialClave		:='PB';
SET EditorialDes        :='EDITORIAL';

SET PresGUEClave		:='PG';
SET PresGUEDes          :='PGUE (PRÉSTAMO COMO GARANTÍA DE UNIDADES INDUSTRIALES) (PFAE)';

SET PresPerClave		:='PL';
SET PresPerDes          :='PRÉSTAMO PERSONAL';

SET PresNomClave		:='PN';
SET PresNomDes          :='PRÉSTAMO DE NÓMINA';

SET PrendaClave			:='PR';
SET PrendaDes           :='PRENDARIO (PFAE)';

SET QuiroClave			:='PQ';
SET QuiroDes            :='QUIROGRAFARIO (PFAE)';

SET RestruClave			:='RC';
SET RestruDes           :='REESTRUCTURADO (PFAE)';

SET RedesClave			:='RD';
SET RedesDes            :='REDESCUENTO (PFAE)';

SET BienRaiClave		:='RE';
SET BienRaiDes          :='BIENES RAÍCES';

SET RefacClave			:='RF';
SET RefacDes            :='REFACCIONARIO (PFAE)';

SET RenoClave			:='RN';
SET RenoDes             :='RENOVADO (PFAE)';

SET VehiRecClave		:='RV';
SET VehiRecDes          :='VEHÍCULO RECREATIVO';

SET TarGarClave			:='SC';
SET TarGarDes           :='TARJETA GARANTIZADA';

SET PreGarClave			:='SE';
SET PreGarDes           :='PRÉSTAMO GARANTIZADO';

SET SegurClave			:='SG';
SET SegurDes            :='SEGUROS';

SET SegHipoClave		:='SM';
SET SegHipoDes          :='SEGUNDA HIPOTECA';

SET PresEstClave		:='ST';
SET PresEstDes          :='PRÉSTAMO PARA ESTUDIANTE';

SET TarCreEmpClave		:='TE';
SET TarCreEmpDes        :='TARJETA DE CRÉDITO EMPRESARIAL';

SET DesconoClave		:='UK';
SET DesconoDes          :='DESCONOCIDO';

SET PresNoGarClave		:='US';
SET PresNoGarDes        :='PRÉSTAMO NO GARANTIZADO';

-- Tipos de Cuenta
SET PagFijosClave		:='I';
SET PagFijosDes			:='PAGOS FIJOS';
SET HipoClave			:='M';
SET HipoDes				:='HIPOTECA';
SET SinLimPresClave		:='O';
SET SinLimPresDes		:='SIN LÍMITE PREESTABLECIDO';
SET RevolvenClave		:='R';
SET RevolvenDes			:='REVOLVENTE';
SET CredRepDunClave		:='X';
SET CredRepDunDes		:='CUANDO ES UN CRÉDITO REPORTADO A DUN&BRADSTREET';

-- Tipo Responsabilidad
SET IndiClave		:='I';
SET IndiDes			:='INDIVIDUAL';
SET MancomClave		:='J';
SET MancomDes		:='MANCOMUNADO';
SET ObSolClave		:='C';
SET ObSolDes		:='OBLIGADO SOLIDARIO';


SET CtaSinInfClave	:='UR';
SET CtaSinInfDes 	:='CUENTA SIN INFORMACIÓN.';

SET RecienAperClave	:='00';
SET RecienAperDes   :='MUY RECIENTE PARA SER INFORMADA';

SET CorrienClave 	:='01';
SET CorrienDes      :='CUENTA AL CORRIENTE';

SET Atras0129Clave	:='02';
SET Atras0129Des    :='ATRASO DE 01 A 29 DÍAS';

SET Atras3059Clave	:='03';
SET Atras3059Des    :='ATRASO DE 30 A 59 DÍAS';

SET Atras6089Clave	:='04';
SET Atras6089Des    :='ATRASO DE 60 A 89 DÍAS';

SET Atras9019Clave	:='05';
SET Atras9019Des    :='ATRASO DE 90 A 119 DÍAS';

SET Atras2049Clave	:='06';
SET Atras2049Des    :='ATRASO DE 120 A 149 DÍAS';

SET Atras5012Clave	:='07';
SET Atras5012Des    :='ATRASO DE 150 DÍAS HASTA 12 MESES';

SET Atras12MClave	:='96';
SET Atras12MDes     :='ATRASO DE 12 MESES';

SET CtaCastigClave	:='97';
SET CtaCastigDes    :='CUENTA CON DEUDA PARCIAL O TOTAL SIN RECUPERAR';

SET FraudCliClave	:='99';
SET FraudCliDes		:='FRAUDE COMETIDO POR EL CLIENTE';

SET VarSaldoActual		:= 0.00;
SET VarLimiteCerradas 	:= 0.00;
SET VarMaximoCerradas	:= 0.00;
SET Var_CharCuentasAb	:= '';
# ---------------- DATOS:= GENERALES (SEGMENTO PN) -------------------------------------------

 IF(Par_NumCon = ConSegPN) THEN

	SET nom :=  (SELECT IFNULL(PN_VALOR,Cadena_Vacia)
					FROM 	bur_segpn
					WHERE	BUR_SOLNUM 	= Par_FolioSol
					AND 	PN_SEGMEN 	= seg2 );


	SET nom2 :=  (SELECT IFNULL(PN_VALOR,Cadena_Vacia)
					FROM 	bur_segpn
					WHERE	BUR_SOLNUM 	= Par_FolioSol
					AND 	PN_SEGMEN 	= seg3 );


	SET ap := (SELECT  IFNULL(PN_VALOR,Cadena_Vacia)
					FROM 	bur_segpn
					WHERE	BUR_SOLNUM	= Par_FolioSol
					AND  	PN_SEGMEN 	= segPN );



	SET am :=  (SELECT IFNULL(PN_VALOR,Cadena_Vacia)
					FROM 	bur_segpn
					WHERE	BUR_SOLNUM 	= Par_FolioSol
					AND  	PN_SEGMEN 	= seg0 );


	SET Var_RFC := (SELECT IFNULL(PN_VALOR,Cadena_Vacia)
						FROM 	bur_segpn
						WHERE	BUR_SOLNUM 	= Par_FolioSol
						AND  	PN_SEGMEN 	= seg5 );


	SET FechaNacCad := (SELECT 	IFNULL(PN_VALOR,Fecha_Vacia)
							FROM 	bur_segpn
							WHERE	BUR_SOLNUM 	= Par_FolioSol
							AND  	PN_SEGMEN 	= seg4 );


	SET dia := (SUBSTR(FechaNacCad,1,2) );
	SET mes := (SUBSTR(FechaNacCad,3,2) );
	SET charAnio := (SUBSTR(FechaNacCad,5,4) );

	IF(IFNULL(charAnio,Cadena_Vacia) <> Cadena_Vacia AND IFNULL(mes,Cadena_Vacia) <> Cadena_Vacia AND IFNULL(dia,Cadena_Vacia) <> Cadena_Vacia )THEN
			SET FechaNacCad	:= IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);
		END IF;

	IF(IFNULL(FechaNacCad,Cadena_Vacia) = Cadena_Vacia)THEN
			SET FechaNacCad	:= Fecha_Vacia;
		END IF;

	SET FechaNac	:= IFNULL(FechaNacCad, Fecha_Vacia);


	SET Var_IFE := (SELECT 	IFNULL(PN_VALOR,Cadena_Vacia)
						FROM 	bur_segpn
						WHERE	BUR_SOLNUM 	= Par_FolioSol
						AND  	PN_SEGMEN 	= seg14 );

	SET Var_CURP := (SELECT 	IFNULL(PN_VALOR,Cadena_Vacia)
						FROM 	bur_segpn
						WHERE	BUR_SOLNUM 	= Par_FolioSol
						AND  	PN_SEGMEN 	= seg15 );

	SET regBCsegPN:= (SELECT 	IFNULL(RS_VALOR,Cadena_Vacia)
						FROM 	bur_segrs
						WHERE	BUR_SOLNUM 	= Par_FolioSol
						AND  	RS_SEGMEN 	= segRS
						LIMIT 1);

	SET Var_SeSolNum:= (SELECT IFNULL(FOL_BUR,Cadena_Vacia) -- TICKET_2794 aortega --
					 FROM	bur_fol
					 WHERE BUR_SOLNUM	= Par_FolioSol
					 LIMIT 1);

	SET dia  := (SUBSTR(regBCsegPN,1,2) );
	SET mes  := (SUBSTR(regBCsegPN,3,2) );
	SET charAnio := (SUBSTR(regBCsegPN,5,4) );

	SET regBCsegPN := CONCAT(charAnio,"-",mes,"-",dia);


	SET nombre:= CONCAT(nom," ",nom2);


	DROP TABLE IF EXISTS tmp_bur_temp1;


	CREATE TEMPORARY TABLE tmp_bur_temp1(
		FechaNacC		DATE,
		Var_RFCC 		VARCHAR(13),
		Var_IFE 		VARCHAR(30),
		Var_CURP 		VARCHAR(18));

	INSERT INTO tmp_bur_temp1
    (FechaNacC,Var_RFCC,Var_IFE,Var_CURP)
		SELECT
				CASE IFNULL(CLI.FechaNacimiento,Cadena_Vacia) WHEN '' THEN PRO.FechaNacimiento
					ELSE CLI.FechaNacimiento END AS FechaNacC,
				CASE SOL.RFC WHEN '' THEN PRO.RFC ELSE SOL.RFC END AS Var_RFCC,
				CASE IDE.TipoIdentiID WHEN 4 THEN IDE.NumIdentific ELSE '' END AS Var_IFE,
				IFNULL(CLI.CURP,Cadena_Vacia) AS Var_CURP
				FROM SOLBUROCREDITO SOL
				LEFT JOIN PROSPECTOS PRO ON SOL.RFC = PRO.RFC
				LEFT OUTER JOIN CLIENTES CLI ON SOL.RFC =  CLI.RFCOficial
				LEFT JOIN IDENTIFICLIENTE IDE ON CLI.ClienteID = IDE.ClienteID
			  WHERE SOL.FolioConsulta REGEXP '^[0-9]+$' AND SOL.FolioConsulta = CAST(Par_FolioSol AS UNSIGNED);


	SELECT  CONCAT(IFNULL(SOL.PrimerNombre,Cadena_Vacia)," ",IFNULL(SOL.SegundoNombre,Cadena_Vacia)," ",IFNULL(SOL.TercerNombre,Cadena_Vacia)) AS nombre,
			CONCAT(IFNULL(SOL.ApellidoPaterno,Cadena_Vacia)," ",Case when IFNULL(SOL.ApellidoMaterno,Cadena_Vacia) = 'NO PROPORCIONADO' then '' else SOL.ApellidoMaterno end  ) AS Apellidos,  -- se agrego el case AEuan T_10449
			CASE IFNULL(CON.Var_RFCC,Cadena_Vacia) WHEN '' THEN A.RFC ELSE SOL.RFC END AS Var_RFC,
			CASE IFNULL(CON.FechaNacC,Cadena_Vacia) WHEN '' THEN A.FechaNac
					ELSE CON.FechaNacC END AS FechaNac,
			CON.Var_IFE,
			CON.Var_CURP,
			regBCsegPN,
			Var_SeSolNum
		FROM
			tmp_bur_temp1	CON,
			SOLBUROCREDITO 	SOL
			LEFT JOIN AVALES A ON SOL.RFC = A.RFC
		WHERE SOL.FolioConsulta = CAST(Par_FolioSol AS UNSIGNED)
		GROUP BY SOL.RFC, 				SOL.PrimerNombre, 	SOL.SegundoNombre,  SOL.TercerNombre, 	SOL.ApellidoPaterno,
				 SOL.ApellidoMaterno,	CON.Var_RFCC,		CON.FechaNacC,		A.FechaNac,			CON.Var_IFE,
                 CON.Var_CURP;

END IF;





IF(Par_NumCon = ConSegPA) THEN
	DROP TABLE IF EXISTS TMPDIRECCIONESPA;
	CREATE TEMPORARY TABLE TMPDIRECCIONESPA
											(	Consecutivo		INT,
												FolioSol 		VARCHAR(30),
												CalleYnum 		VARCHAR(100),
												Colonia 		VARCHAR(50),
												DelOMunicipio 	VARCHAR(100),
												Ciudad 			VARCHAR(50),
												Estado			VARCHAR(50),
												CP 				CHAR(5),
												Telefono		VARCHAR(20),
												RegBCsegPA		VARCHAR(30));



	SET cantRegistros := (SELECT MAX(PA_CONSEC)
						FROM 	bur_segpa
						WHERE 	BUR_SOLNUM = Par_FolioSol);

	SET contador := 1;
  WHILE contador <= cantRegistros  DO

	SET VarRegBCsegPA :="";
	SET VarRegBCsegPA := (SELECT IFNULL(PA_VALOR,Fecha_Vacia)
							FROM 	bur_segpa
							WHERE 	BUR_SOLNUM = Par_FolioSol
							AND  	PA_SEGMEN = seg12
							AND 	PA_CONSEC = contador);

	SET VarRegBCsegPA :=  (SELECT LTRIM(VarRegBCsegPA));
		SET dia := (SUBSTR(VarRegBCsegPA,1,2) );
		SET mes := (SUBSTR(VarRegBCsegPA,3,2) );
		SET charAnio := (SUBSTR(VarRegBCsegPA,5,4) );
		SET VarRegBCsegPA := CONCAT(charAnio,"-",mes,"-",dia);

		INSERT INTO TMPDIRECCIONESPA (
										Consecutivo,	FolioSol,		CalleYnum,	Colonia,	DelOMunicipio,
										Ciudad,			Estado,			CP,			Telefono,	RegBCsegPA)
						VALUES		  (	contador,		Par_FolioSol,	CONCAT((SELECT IFNULL(PA_VALOR,Cadena_Vacia)
																		FROM 	bur_segpa
																		WHERE 	BUR_SOLNUM = Par_FolioSol
																		AND  	PA_SEGMEN = segPA
																		AND PA_CONSEC = contador),Cadena_Vacia,
																		(SELECT IFNULL(PA_VALOR,Cadena_Vacia)
																		FROM 	bur_segpa
																		WHERE 	BUR_SOLNUM = Par_FolioSol
																		AND  	PA_SEGMEN = seg0
																		AND PA_CONSEC = contador)),
										(SELECT  IFNULL(PA_VALOR,Cadena_Vacia)
												FROM 	bur_segpa
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PA_SEGMEN = seg1
												AND 	PA_CONSEC = contador),
										(SELECT  IFNULL(PA_VALOR,Cadena_Vacia)
												FROM 	bur_segpa
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PA_SEGMEN = seg2
												AND 	PA_CONSEC = contador),
										(SELECT  IFNULL(PA_VALOR,Cadena_Vacia)
												FROM 	bur_segpa
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PA_SEGMEN = seg3
												AND 	PA_CONSEC = contador),
										(SELECT  IFNULL(PA_VALOR,Cadena_Vacia)
												FROM 	bur_segpa
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PA_SEGMEN = seg4
												AND 	PA_CONSEC = contador),
					 					(SELECT  IFNULL(PA_VALOR,Cadena_Vacia)
												FROM 	bur_segpa
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PA_SEGMEN = seg5
												AND 	PA_CONSEC = contador),
										CONCAT((SELECT  IFNULL(PA_VALOR,Cadena_Vacia)
												FROM 	bur_segpa
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PA_SEGMEN = seg7
												AND 	PA_CONSEC = contador),"  ",(SELECT  IFNULL(PA_VALOR,Cadena_Vacia)
												FROM 	bur_segpa
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PA_SEGMEN = seg8
												AND 	PA_CONSEC = contador)),
										  VarRegBCsegPA
										);
		SET contador := contador +1;

	END WHILE;


SELECT Consecutivo,	FolioSol,		CalleYnum,	Colonia,	DelOMunicipio,
		Ciudad,			Estado,			CP,			Telefono,	RegBCsegPA
		FROM TMPDIRECCIONESPA
		WHERE FolioSol = Par_FolioSol;


DROP TABLE TMPDIRECCIONESPA;
END IF;



IF(Par_NumCon = ConSegPE) THEN

DROP TABLE IF EXISTS TMPDIRECCIONESPE;

	CREATE TEMPORARY TABLE TMPDIRECCIONESPE
											(	Consecutivo		INT,
												FolioSol 		VARCHAR(30),
												Compañia		VARCHAR(40),
												Puesto			VARCHAR(30),
												Salario			MEDIUMTEXT,
												BaseSalarial	CHAR(1),
												CalleYnum 		VARCHAR(100),
												Colonia 		VARCHAR(50),
												DelOMunicipio 	VARCHAR(100),
												Ciudad 			VARCHAR(50),
												Estado			VARCHAR(50),
												CP 				CHAR(5),
												Telefono		VARCHAR(20),
												RegBCsegPE		VARCHAR(30),
												FechContrata	VARCHAR(15),
												UltDiaEmpleo	VARCHAR(12));



	SET cantRegistros := (SELECT MAX(PE_CONSEC)
						FROM 	bur_segpe
						WHERE 	BUR_SOLNUM = Par_FolioSol);
	SET contador := 1;
	WHILE contador <= cantRegistros  DO

SET VarRegBCsegPE :="";
SET VarRegBCsegPE := (SELECT IFNULL(PE_VALOR,Fecha_Vacia)
						FROM 	bur_segpe
						WHERE 	BUR_SOLNUM = Par_FolioSol
						AND  	PE_SEGMEN = seg17
						AND 	PE_CONSEC = contador);

SET VarRegBCsegPE :=  (SELECT LTRIM(VarRegBCsegPE));
		SET dia := (SUBSTR(VarRegBCsegPE,1,2) );
		SET mes := (SUBSTR(VarRegBCsegPE,3,2) );
		SET charAnio := (SUBSTR(VarRegBCsegPE,5,4) );
		SET VarRegBCsegPE := CONCAT(charAnio,"-",mes,"-",dia);


SET VarFechContrata :="";
SET VarFechContrata := (SELECT IFNULL(PE_VALOR,Fecha_Vacia)
						FROM 	bur_segpe
						WHERE 	BUR_SOLNUM = Par_FolioSol
						AND  	PE_SEGMEN = seg11
						AND 	PE_CONSEC = contador);

SET VarFechContrata :=  (SELECT LTRIM(VarFechContrata));
		SET dia := (SUBSTR(VarFechContrata,1,2) );
		SET mes := (SUBSTR(VarFechContrata,3,2) );
		SET charAnio := (SUBSTR(VarFechContrata,5,4) );
		SET VarFechContrata := CONCAT(charAnio,"-",mes,"-",dia);

SET VarUltDiaEmpleo :="";
SET VarUltDiaEmpleo := (SELECT IFNULL(PE_VALOR,Fecha_Vacia)
						FROM 	bur_segpe
						WHERE 	BUR_SOLNUM = Par_FolioSol
						AND  	PE_SEGMEN = seg16
						AND 	PE_CONSEC = contador);

SET VarUltDiaEmpleo:=  (SELECT LTRIM(VarUltDiaEmpleo));
		SET dia := (SUBSTR(VarUltDiaEmpleo,1,2) );
		SET mes := (SUBSTR(VarUltDiaEmpleo,3,2) );
		SET charAnio := (SUBSTR(VarUltDiaEmpleo,5,4) );
		SET VarUltDiaEmpleo:= CONCAT(charAnio,"-",mes,"-",dia);

		INSERT INTO TMPDIRECCIONESPE (
										Consecutivo,	FolioSol,		Compañia,		Puesto,			Salario,
										BaseSalarial,	CalleYnum,		Colonia,		DelOMunicipio,	Ciudad,
										Estado,			CP,				Telefono,		RegBCsegPE,		FechContrata,
										UltDiaEmpleo)
						VALUES		  (	contador,		Par_FolioSol,	(SELECT IFNULL(PE_VALOR,Cadena_Vacia)
																		FROM 	bur_segpe
																		WHERE 	BUR_SOLNUM = Par_FolioSol
																		AND  	PE_SEGMEN = segPE
																		AND PE_CONSEC = contador),

										(SELECT IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg10
												AND PE_CONSEC = contador),
										(SELECT  IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg13
												AND 	PE_CONSEC = contador),
										(SELECT  IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg14
												AND 	PE_CONSEC = contador),

										CONCAT((SELECT IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg0
												AND PE_CONSEC = contador),Cadena_Vacia,
												(SELECT IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg1
												AND PE_CONSEC = contador)),

										(SELECT  IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg2
												AND 	PE_CONSEC = contador),
										(SELECT  IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg3
												AND 	PE_CONSEC = contador),
										(SELECT  IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg4
												AND 	PE_CONSEC = contador),
										(SELECT  IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg5
												AND 	PE_CONSEC = contador),
										(SELECT  IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg6
												AND 	PE_CONSEC = contador),
										(SELECT  IFNULL(PE_VALOR,Cadena_Vacia)
												FROM 	bur_segpe
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	PE_SEGMEN = seg7
												AND 	PE_CONSEC = contador),
										VarRegBCsegPE,
										VarFechContrata,
										VarUltDiaEmpleo
										);

		SET contador := contador +1;

	END WHILE;


SELECT Consecutivo,	FolioSol,		Compañia,		Puesto,			CAST(Salario AS DECIMAL(12,4)) AS Salario,
		IFNULL( (CASE BaseSalarial
		WHEN  Bimestral  		THEN BimeDescrip
		WHEN  Diario  			THEN DiarioDescrip
		WHEN  PorHora  			THEN PorHoDescrip
		WHEN  Catorcenal  		THEN CatorDescrip
		WHEN  Mensual  			THEN MensualDescrip
		WHEN  Quincenal  		THEN QuincDescrip
		WHEN  Semanal  			THEN SemaDescrip
		WHEN  Anual  			THEN AnualDescrip
		END), Cadena_Vacia) AS DescripBase,
		CalleYnum,		Colonia,		DelOMunicipio,	Ciudad,			Estado,
		CP,				Telefono,		RegBCsegPE,		FechContrata,	UltDiaEmpleo
		FROM TMPDIRECCIONESPE
		WHERE FolioSol = Par_FolioSol;
END IF;




IF(Par_NumCon = ConSegHIHR) THEN
	DROP TABLE IF EXISTS TMPMENSALERTAHIHR;
	CREATE TEMPORARY TABLE TMPMENSALERTAHIHR
											(	Consecutivo		INT,
												FolioSol 		VARCHAR(30),
												FechaRep		VARCHAR(15),
												Clave			CHAR(3),
												Otorgante		VARCHAR(16),
												Mensaje			VARCHAR(150),
												Origen			CHAR(2));

SET cantRegistros := (SELECT MAX(HI_CONSEC)
						FROM 	bur_seghi
						WHERE 	BUR_SOLNUM = Par_FolioSol);
	SET contador := 1;
	WHILE contador <= cantRegistros  DO

		SET FechaNacCad :="";
		SET FechaNacCad := (SELECT IFNULL(HI_VALOR,Fecha_Vacia)
										FROM 	bur_seghi
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	HI_SEGMEN = segHI
										AND 	HI_CONSEC = contador);
		SET dia := (SUBSTR(FechaNacCad,1,2) );
		SET mes := (SUBSTR(FechaNacCad,3,2) );
		SET charAnio := (SUBSTR(FechaNacCad,5,4) );


	IF(IFNULL(charAnio,Cadena_Vacia) <> Cadena_Vacia AND IFNULL(mes,Cadena_Vacia) <> Cadena_Vacia AND IFNULL(dia,Cadena_Vacia) <> Cadena_Vacia)THEN
			SET FechaNacCad	:= IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);
		END IF;

	IF(IFNULL(FechaNacCad,Cadena_Vacia) = Cadena_Vacia)THEN
			SET FechaNacCad	:= Fecha_Vacia;
		END IF;

	SET FechaNacCad	:= IFNULL(FechaNacCad,Fecha_Vacia);



		INSERT INTO TMPMENSALERTAHIHR (
										Consecutivo,	FolioSol,		FechaRep,		Clave,		Otorgante,
										Mensaje,		Origen)
						VALUES		  (	contador,		Par_FolioSol,	FechaNacCad,	(SELECT IFNULL(HI_VALOR,Cadena_Vacia)
																							FROM 	bur_seghi
																							WHERE 	BUR_SOLNUM = Par_FolioSol
																							AND  	HI_SEGMEN = seg0
																							AND HI_CONSEC = contador),

										(SELECT IFNULL(HI_VALOR,Cadena_Vacia)
												FROM 	bur_seghi
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	HI_SEGMEN = seg1
												AND 	HI_CONSEC = contador),
										(SELECT  IFNULL(HI_VALOR,Cadena_Vacia)
												FROM 	bur_seghi
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	HI_SEGMEN = seg2
												AND 	HI_CONSEC = contador),
										segHI);

	SET contador := contador +1;

	END WHILE;


SET cantRegistros := (SELECT MAX(HR_CONSEC)
						FROM 	bur_seghr
						WHERE 	BUR_SOLNUM = Par_FolioSol);
	 SET contador := 1;
	WHILE contador <= cantRegistros  DO
		SET FechaNacCad :="";
		SET FechaNacCad := (SELECT IFNULL(HR_VALOR,Fecha_Vacia)
										FROM 	bur_seghr
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	HR_SEGMEN = segHR
										AND 	HR_CONSEC = contador);
		SET dia := (SUBSTR(FechaNacCad,1,2) );
		SET mes := (SUBSTR(FechaNacCad,3,2) );
		SET charAnio := (SUBSTR(FechaNacCad,5,4) );
		SET FechaNacCad := CONCAT(charAnio,"-",mes,"-",dia);

		INSERT INTO TMPMENSALERTAHIHR (
										Consecutivo,	FolioSol,		FechaRep,		Clave,		Otorgante,
										Mensaje,		Origen)
						VALUES		  (	contador,		Par_FolioSol,	FechaNacCad,	(SELECT IFNULL(HR_VALOR,Cadena_Vacia)
																							FROM 	bur_seghr
																							WHERE 	BUR_SOLNUM = Par_FolioSol
																							AND  	HR_SEGMEN = seg0
																							AND 	HR_CONSEC = contador),

										(SELECT IFNULL(HR_VALOR,Cadena_Vacia)
												FROM 	bur_seghr
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	HR_SEGMEN = seg1
												AND 	HR_CONSEC = contador),
										(SELECT  IFNULL(HR_VALOR,Cadena_Vacia)
												FROM 	bur_seghr
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	HR_SEGMEN = seg2
												AND 	HR_CONSEC = contador),
										segHR);

	SET contador := contador +1;

	END WHILE;
SET	Var_Otorgante	:= 'OTORGANTE';
SET	Var_BDDBC		:= 'BDD BC';

	SELECT Consecutivo,	FolioSol,		FechaRep,		Clave,		Otorgante,
		Mensaje,		(CASE Origen
							WHEN  segHI  		THEN   Var_Otorgante
							WHEN  segHR  		THEN 	Var_BDDBC
						END) AS Origen
	FROM TMPMENSALERTAHIHR
	WHERE FolioSol = Par_FolioSol;

DROP TABLE TMPMENSALERTAHIHR;


END IF;



IF(Par_NumCon = ConSegSC) THEN

	SET cantRegistros := (SELECT MAX(SC_CONSEC)
						FROM 	bur_segsc
						WHERE 	BUR_SOLNUM = Par_FolioSol);

	DROP TABLE IF EXISTS TMPCONSULTASSC;
	CREATE TEMPORARY TABLE TMPCONSULTASSC
											(	Consecutivo		INT,
												FolioSol 		VARCHAR(30),
												NombreSC 		VARCHAR(30),
												ValorSC 		CHAR(4),
												Causa1			CHAR(3),
												Causa2			CHAR(3),
												Causa3			CHAR(3),
												CausaNoSC		CHAR(2));

	SET contador := 1;
	WHILE contador <= cantRegistros  DO


		INSERT INTO TMPCONSULTASSC (
										Consecutivo,	FolioSol,		NombreSC,	ValorSC,	Causa1,
										Causa2,			Causa3,			CausaNoSC)
						VALUES		  (	contador,		Par_FolioSol,	(SELECT IFNULL(SC_VALOR,Cadena_Vacia)
																		FROM 	bur_segsc
																		WHERE 	BUR_SOLNUM = Par_FolioSol
																		AND  	SC_SEGMEN = segSC
																		AND 	SC_CONSEC = contador),

										(SELECT IFNULL(SC_VALOR,Cadena_Vacia)
										FROM 	bur_segsc
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	SC_SEGMEN = seg1
										AND 	SC_CONSEC = contador),
										(SELECT IFNULL(SC_VALOR,Cadena_Vacia)
										FROM 	bur_segsc
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	SC_SEGMEN = seg2
										AND 	SC_CONSEC = contador),
										(SELECT IFNULL(SC_VALOR,Decimal_Cero)
										FROM 	bur_segsc
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	SC_SEGMEN = seg3
										AND 	SC_CONSEC = contador),
										(SELECT IFNULL(SC_VALOR,Cadena_Vacia)
										FROM 	bur_segsc
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	SC_SEGMEN = seg4
										AND 	SC_CONSEC = contador),
										(SELECT IFNULL(SC_VALOR,Cadena_Vacia)
										FROM 	bur_segsc
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	SC_SEGMEN = seg6
										AND 	SC_CONSEC = contador)
										);



		SET contador := contador +1;

	END WHILE;


SELECT Consecutivo,	FolioSol,	NombreSC,	ValorSC,
	   (CASE Causa1
		WHEN  NEndeudCod  		THEN NEndeudDesc
		WHEN  SaldoVenAcCod  	THEN SaldoVenAcDes
		WHEN  SalVAcRevCod  	THEN SalVAcRevDes
		WHEN  ConsRecienCod  	THEN ConsRecienDes
		WHEN  CtaMorHistCod  	THEN CtaMorHistDes
		WHEN  CtaMorCreHCod  	THEN CtaMorCreHDes
		WHEN  NumCtasMorCod  	THEN NumCtasMorDes
		WHEN  AumCtasMorCod  	THEN AumCtasMorDes
		WHEN  PBajAntTCreCod  	THEN PBajAntTCreDes
		WHEN  PBajAntTCDepCod  	THEN PBajAntTCDepDes
		WHEN  PBajAntTCRevCod  	THEN PBajAntTCRevDes
		WHEN  TCreMayRiesCod  	THEN TCreMayRiesDes
		WHEN  NumCtasAbieCod  	THEN NumCtasAbieDes
		WHEN  NumCtasRevACod  	THEN NumCtasRevADes
		WHEN  PropASalLimCCod  	THEN PropASalLimCDes
		WHEN  UltCtaApRecCod  	THEN UltCtaApRecDes
		WHEN  CtasMorRecCod  	THEN CtasMorRecDes
		WHEN  CtaMAntARecCod  	THEN CtaMAntARecDes
		WHEN  CtaRevMARecCod  	THEN CtaRevMARecDes
		WHEN  RelCtasMorYsCod  	THEN RelCtasMorYsDes
		WHEN  RelExpMorHCCod  	THEN RelExpMorHCDes
		WHEN  ConDifInstCod  	THEN ConDifInstDes
		WHEN  ConUlt48MCod  	THEN ConUlt48MDes
		WHEN  VarCtasPlazCod  	THEN VarCtasPlazDes
		WHEN  ConUlt6MCod  		THEN ConUlt6MDes
		WHEN  ConCerUl48MCod  	THEN ConCerUl48MDes
		WHEN  PropAlSalLCCod  	THEN PropAlSalLCDes
		WHEN  CtasAbUlt48Cod  	THEN CtasAbUlt48Des
		END) AS DescripCausa1,
		 (CASE Causa2
		WHEN  NEndeudCod  		THEN NEndeudDesc
		WHEN  SaldoVenAcCod  	THEN SaldoVenAcDes
		WHEN  SalVAcRevCod  	THEN SalVAcRevDes
		WHEN  ConsRecienCod  	THEN ConsRecienDes
		WHEN  CtaMorHistCod  	THEN CtaMorHistDes
		WHEN  CtaMorCreHCod  	THEN CtaMorCreHDes
		WHEN  NumCtasMorCod  	THEN NumCtasMorDes
		WHEN  AumCtasMorCod  	THEN AumCtasMorDes
		WHEN  PBajAntTCreCod  	THEN PBajAntTCreDes
		WHEN  PBajAntTCDepCod  	THEN PBajAntTCDepDes
		WHEN  PBajAntTCRevCod  	THEN PBajAntTCRevDes
		WHEN  TCreMayRiesCod  	THEN TCreMayRiesDes
		WHEN  NumCtasAbieCod  	THEN NumCtasAbieDes
		WHEN  NumCtasRevACod  	THEN NumCtasRevADes
		WHEN  PropASalLimCCod  	THEN PropASalLimCDes
		WHEN  UltCtaApRecCod  	THEN UltCtaApRecDes
		WHEN  CtasMorRecCod  	THEN CtasMorRecDes
		WHEN  CtaMAntARecCod  	THEN CtaMAntARecDes
		WHEN  CtaRevMARecCod  	THEN CtaRevMARecDes
		WHEN  RelCtasMorYsCod  	THEN RelCtasMorYsDes
		WHEN  RelExpMorHCCod  	THEN RelExpMorHCDes
		WHEN  ConDifInstCod  	THEN ConDifInstDes
		WHEN  ConUlt48MCod  	THEN ConUlt48MDes
		WHEN  VarCtasPlazCod  	THEN VarCtasPlazDes
		WHEN  ConUlt6MCod  		THEN ConUlt6MDes
		WHEN  ConCerUl48MCod  	THEN ConCerUl48MDes
		WHEN  PropAlSalLCCod  	THEN PropAlSalLCDes
		WHEN  CtasAbUlt48Cod  	THEN CtasAbUlt48Des
		END) AS DescripCausa2,
		(CASE Causa3
		WHEN  NEndeudCod  		THEN NEndeudDesc
		WHEN  SaldoVenAcCod  	THEN SaldoVenAcDes
		WHEN  SalVAcRevCod  	THEN SalVAcRevDes
		WHEN  ConsRecienCod  	THEN ConsRecienDes
		WHEN  CtaMorHistCod  	THEN CtaMorHistDes
		WHEN  CtaMorCreHCod  	THEN CtaMorCreHDes
		WHEN  NumCtasMorCod  	THEN NumCtasMorDes
		WHEN  AumCtasMorCod  	THEN AumCtasMorDes
		WHEN  PBajAntTCreCod  	THEN PBajAntTCreDes
		WHEN  PBajAntTCDepCod  	THEN PBajAntTCDepDes
		WHEN  PBajAntTCRevCod  	THEN PBajAntTCRevDes
		WHEN  TCreMayRiesCod  	THEN TCreMayRiesDes
		WHEN  NumCtasAbieCod  	THEN NumCtasAbieDes
		WHEN  NumCtasRevACod  	THEN NumCtasRevADes
		WHEN  PropASalLimCCod  	THEN PropASalLimCDes
		WHEN  UltCtaApRecCod  	THEN UltCtaApRecDes
		WHEN  CtasMorRecCod  	THEN CtasMorRecDes
		WHEN  CtaMAntARecCod  	THEN CtaMAntARecDes
		WHEN  CtaRevMARecCod  	THEN CtaRevMARecDes
		WHEN  RelCtasMorYsCod  	THEN RelCtasMorYsDes
		WHEN  RelExpMorHCCod  	THEN RelExpMorHCDes
		WHEN  ConDifInstCod  	THEN ConDifInstDes
		WHEN  ConUlt48MCod  	THEN ConUlt48MDes
		WHEN  VarCtasPlazCod  	THEN VarCtasPlazDes
		WHEN  ConUlt6MCod  		THEN ConUlt6MDes
		WHEN  ConCerUl48MCod  	THEN ConCerUl48MDes
		WHEN  PropAlSalLCCod  	THEN PropAlSalLCDes
		WHEN  CtasAbUlt48Cod  	THEN CtasAbUlt48Des
		END) AS DescripCausa3,
		(CASE CausaNoSC
		WHEN  SolNoAutCod  		THEN SolNoAutDes
		WHEN  SolSCInvalCod  	THEN SolSCInvalDes
		WHEN  SCNoDisponCod  	THEN SCNoDisponDes
		END) AS DescripNoCausa
		FROM TMPCONSULTASSC
		WHERE FolioSol = Par_FolioSol;

 DROP TABLE TMPCONSULTASSC;

END IF; -- fin de la consulta del segmento SC


# ---------------- DETALLE DE LOS CREDITOS (SEGMENTO TL) -------------------------------------------
IF(Par_NumCon = ConSegTL) THEN
	/* se elimina la tabla temporal si es que existiera para despues crearse*/
	DROP TABLE IF EXISTS TMPDETCREDTL;
	CREATE TEMPORARY TABLE TMPDETCREDTL(
		Consecutivo		INT,
		FolioSol 		VARCHAR(30),
		Otorgante 		VARCHAR(100),
		NumCuenta 		VARCHAR(50),
		TipoCredito 	VARCHAR(100),
		TipoCuenta 		VARCHAR(50),
		TipoRespons		VARCHAR(50),

		Moneda 			CHAR(5),
		FechaAper		VARCHAR(12),
		FechaAct		VARCHAR(12),
		FechaUltPago	VARCHAR(12),
		FechaUltComp	VARCHAR(12),

		FechaCierre		VARCHAR(12),
		FechaSaldoCero	VARCHAR(12),
		LimiteCredito	MEDIUMTEXT,
		CreditoMaximo   MEDIUMTEXT,
		SaldoActual		MEDIUMTEXT,

		SaldoVencido	MEDIUMTEXT,
		MontoPagar		MEDIUMTEXT,
		MOP				VARCHAR(100),
		FechaMaxMora	VARCHAR(12),
		MontoMaxMora	MEDIUMTEXT,
        MOPMora			VARCHAR(100),
		FrecuenciaPag	VARCHAR(2));

	SET cantRegistros := (SELECT MAX(TL_CONSEC)
							FROM 	bur_segtl
							WHERE 	BUR_SOLNUM = Par_FolioSol);
	SET contador := 1;

	WHILE contador <= cantRegistros  DO
		-- Asignacion de fechas
		SET fechaApertura :="";
		SET fechaApertura := (SELECT  IFNULL(TL_VALOR,FechaVacia)
								  FROM 	bur_segtl
								  WHERE 	BUR_SOLNUM = Par_FolioSol
								  AND  	TL_SEGMEN = seg13
								  AND 	TL_CONSEC = contador);

		SET fechaApertura :=  (SELECT LTRIM(fechaApertura));
		SET dia := (SUBSTR(fechaApertura,1,2) );
		SET mes := (SUBSTR(fechaApertura,3,2) );
		SET charAnio := (SUBSTR(fechaApertura,5,4) );
		SET fechaApertura := IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);
		-- --------------------------------------------------------------

		SET fechaActual :="";
		SET fechaActual := (SELECT  IFNULL(TL_VALOR,FechaVacia)
								FROM 	bur_segtl
							    WHERE 	BUR_SOLNUM = Par_FolioSol
								AND  	TL_SEGMEN = segTL
								AND 	TL_CONSEC = contador);

		SET fechaActual :=  (SELECT LTRIM(fechaActual));
				SET dia := (SUBSTR(fechaActual,1,2) );
				SET mes := (SUBSTR(fechaActual,3,2) );
				SET charAnio := (SUBSTR(fechaActual,5,4) );
		SET fechaActual :=IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);

		-- ---------------------------------------------------------------
		SET fechaUltPago :="";
		SET fechaUltPago := (SELECT  IFNULL(TL_VALOR,FechaVacia)
								 FROM 	bur_segtl
								 WHERE 	BUR_SOLNUM = Par_FolioSol
								 AND  	TL_SEGMEN = seg14
								 AND 	TL_CONSEC = contador);

		SET fechaUltPago :=  (SELECT LTRIM(fechaUltPago));
		SET dia := (SUBSTR(fechaUltPago,1,2) );
		SET mes := (SUBSTR(fechaUltPago,3,2) );
		SET charAnio := (SUBSTR(fechaUltPago,5,4) );
		SET fechaUltPago := IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);
		-- ---------------------------------------------------------------
		SET fechaUltCompra :="";
		SET fechaUltCompra :=(SELECT  IFNULL(TL_VALOR,FechaVacia)
								  FROM 	bur_segtl
								  WHERE 	BUR_SOLNUM = Par_FolioSol
								  AND  	TL_SEGMEN = seg15
								  AND 	TL_CONSEC = contador) ;

		SET fechaUltCompra :=  (SELECT LTRIM(fechaUltCompra));
		SET dia := (SUBSTR(fechaUltCompra,1,2) );
		SET mes := (SUBSTR(fechaUltCompra,3,2) );
		SET charAnio := (SUBSTR(fechaUltCompra,5,4) );
		SET fechaUltCompra := IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);

		-- ---------------------------------------------------------------
		-- FECHA DE CIERRE
		SET Var_FechaCierre :="";
		SET Var_FechaCierre :=(SELECT  IFNULL(TL_VALOR,FechaVacia)
						FROM 	bur_segtl
						WHERE 	BUR_SOLNUM = Par_FolioSol
						AND  	TL_SEGMEN = seg16
						AND 	TL_CONSEC = contador);

		SET Var_FechaCierre :=  (SELECT LTRIM(Var_FechaCierre));
		SET dia := (SUBSTR(Var_FechaCierre,1,2) );
		SET mes := (SUBSTR(Var_FechaCierre,3,2) );
		SET charAnio := (SUBSTR(Var_FechaCierre,5,4) );
		SET Var_FechaCierre := IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);

		-- --------------------------------------------------------------
		SET fechaUltCero :="";
		SET fechaUltCero :=(SELECT  IFNULL(TL_VALOR,FechaVacia)
								FROM 	bur_segtl
								WHERE 	BUR_SOLNUM = Par_FolioSol
								AND  	TL_SEGMEN = seg19
								AND 	TL_CONSEC = contador);

		SET fechaUltCero :=  (SELECT LTRIM(fechaUltCero));
		SET dia := (SUBSTR(fechaUltCero,1,2) );
		SET mes := (SUBSTR(fechaUltCero,3,2) );
		SET charAnio := (SUBSTR(fechaUltCero,5,4) );
		SET fechaUltCero := IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);

		SET fechaMaxMora1 :="";
		SET fechaMaxMora1 := (SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
							FROM 	bur_segtl
							WHERE 	BUR_SOLNUM = Par_FolioSol
							AND  	TL_SEGMEN = seg37
							AND 	TL_CONSEC = contador);

		SET fechaMaxMora1 :=  (SELECT LTRIM(fechaMaxMora1));
		SET dia := (SUBSTR(fechaMaxMora1,1,2) );
		SET mes := (SUBSTR(fechaMaxMora1,3,2) );
		SET charAnio := (SUBSTR(fechaMaxMora1,5,4) );
		SET fechaMaxMora1 := IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);

		SET VarFrecPago := (SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
							FROM 	bur_segtl
							WHERE 	BUR_SOLNUM = Par_FolioSol
							AND  	TL_SEGMEN = seg11
							AND 	TL_CONSEC = contador);

		SET Var_MOPMora := (SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
							FROM 	bur_segtl
							WHERE 	BUR_SOLNUM = Par_FolioSol
							AND  	TL_SEGMEN = seg38
							AND 	TL_CONSEC = contador);
		--  --------------------------- Inserta en la tabla temporal ------------------------------
		INSERT INTO TMPDETCREDTL (
			Consecutivo,	FolioSol,     	Otorgante,		NumCuenta, 	    TipoCredito,
			TipoCuenta,		TipoRespons,  	Moneda,			FechaAper,		FechaAct,
			FechaUltPago,	FechaUltComp, 	FechaCierre,	FechaSaldoCero,	LimiteCredito,
			CreditoMaximo,  SaldoActual,  	SaldoVencido,	MontoPagar,     MOP,
			FechaMaxMora,	MontoMaxMora,	MOPMora,		FrecuenciaPag )
		VALUES(
			contador,		Par_FolioSol,	(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
																FROM 	bur_segtl
																WHERE 	BUR_SOLNUM = Par_FolioSol
																AND  	TL_SEGMEN = seg2
																AND 	TL_CONSEC = contador),
												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg4
													AND 	TL_CONSEC = contador),
												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg7
													AND 	TL_CONSEC = contador),
												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg6
													AND 	TL_CONSEC = contador),
												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg5
													AND 	TL_CONSEC = contador),

												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg8
													AND 	TL_CONSEC = contador),

												fechaApertura,
												fechaActual,
												fechaUltPago,
												fechaUltCompra,
												Var_FechaCierre,
												fechaUltCero,
												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg23
													AND 	TL_CONSEC = contador),
												(SELECT  IFNULL(TL_VALOR, Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg21
													AND 	TL_CONSEC = contador),
												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg22
													AND 	TL_CONSEC = contador),

												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg24
													AND 	TL_CONSEC = contador),
												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg12
													AND 	TL_CONSEC = contador),
												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg26
													AND 	TL_CONSEC = contador),
												fechaMaxMora1,
												(SELECT  IFNULL(TL_VALOR,Cadena_Vacia)
													FROM 	bur_segtl
													WHERE 	BUR_SOLNUM = Par_FolioSol
													AND  	TL_SEGMEN = seg36
													AND 	TL_CONSEC = contador),
                                                    Var_MOPMora,
										VarFrecPago
										);

		SET contador := contador +1;
	END WHILE;

	SELECT  tmp.Consecutivo,	tmp.FolioSol,     tmp.Otorgante,	tmp.NumCuenta, 	(CASE tmp.TipoCredito
									WHEN ApMueblesClave	THEN ApMueblesDes
									WHEN AgropeClave	THEN AgropeDes
									WHEN ArrAutoClave 	THEN ArrAutoDes
									WHEN AviacionClave 	THEN    AviacionDes
									WHEN CompAutoClave	THEN CompAutoDes
									WHEN FianzaClave	THEN FianzaDes
									WHEN BoteLanClave	THEN BoteLanDes
									WHEN TarCreClave	THEN TarCreDes
									WHEN CarCreClave	THEN CarCreDes
									WHEN CreFisClave	THEN CreFisDes
									WHEN LinCreClave	THEN LinCreDes
									WHEN ConsoClave		THEN ConsoDes
									WHEN CreSimClave	THEN CreSimDes
									WHEN ConColClave    THEN ConColDes
									WHEN DescuClave		THEN DescuDes
									WHEN EqClave		THEN EqDes
									WHEN FideiClave		THEN FideiDes
									WHEN FacClave		THEN FacDes
									WHEN HabilClave		THEN HabilDes
									WHEN PresHomeClave	THEN PresHomeDes
									WHEN MejCasaClave	THEN MejCasaDes
									WHEN ArrenClave		THEN ArrenDes
									WHEN OtrosClave		THEN OtrosDes
									WHEN OtrosAdVenClave THEN OtrosAdVenDes
									WHEN PresPFAEClave	THEN PresPFAEDes
									WHEN EditorialClave	THEN EditorialDes
									WHEN PresGUEClave	THEN PresGUEDes
									WHEN PresPerClave	THEN PresPerDes
									WHEN PresNomClave	THEN PresNomDes
									WHEN PrendaClave	THEN PrendaDes
									WHEN QuiroClave		THEN QuiroDes
									WHEN RestruClave	THEN RestruDes
									WHEN RedesClave		THEN RedesDes
									WHEN BienRaiClave	THEN BienRaiDes
									WHEN RefacClave		THEN RefacDes
									WHEN RenoClave		THEN RenoDes
									WHEN VehiRecClave	THEN VehiRecDes
									WHEN TarGarClave	THEN TarGarDes
									WHEN PreGarClave	THEN PreGarDes
									WHEN SegurClave		THEN SegurDes
									WHEN SegHipoClave	THEN SegHipoDes
									WHEN PresEstClave	THEN PresEstDes
									WHEN TarCreEmpClave THEN TarCreEmpDes
									WHEN DesconoClave	THEN DesconoDes
									WHEN PresNoGarClave THEN PresNoGarDes END) AS TipoCredito,
		(CASE tmp.TipoCuenta
			WHEN PagFijosClave	 THEN PagFijosDes
			WHEN HipoClave		 THEN HipoDes
			WHEN SinLimPresClave THEN SinLimPresDes
			WHEN RevolvenClave	 THEN RevolvenDes
			WHEN CredRepDunClave THEN CredRepDunDes	END )AS TipoCuenta,
		(CASE tmp.TipoRespons
			WHEN IndiClave	  THEN IndiDes
			WHEN MancomClave THEN MancomDes
			WHEN ObSolClave  THEN ObSolDes	END)AS TipoRespons,
		tmp.Moneda,       	tmp.FechaAper,		tmp.FechaAct,
		tmp.FechaUltPago,	tmp.FechaUltComp, tmp.FechaCierre,	tmp.FechaSaldoCero,	CAST(tmp.LimiteCredito AS DECIMAL(12,2)) AS LimiteCredito,
		CAST(tmp.CreditoMaximo AS DECIMAL(12,2)) AS CreditoMaximo,  CAST(tmp.SaldoActual AS DECIMAL(12,2)) AS SaldoActual,
		CAST(tmp.SaldoVencido AS DECIMAL(12,2)) AS SaldoVencido,	CAST(tmp.MontoPagar AS DECIMAL(12,2)) AS MontoPagar,
		(CASE tmp.MOP
			WHEN CtaSinInfClave	THEN CONCAT(CtaSinInfClave,"= ",CtaSinInfDes)
			WHEN RecienAperClave THEN  CONCAT(CtaSinInfClave,"= ",RecienAperDes)
			WHEN CorrienClave 	THEN CONCAT(CorrienClave,"= ",CorrienDes)
			WHEN Atras0129Clave	THEN CONCAT(Atras0129Clave,"= ",Atras0129Des)
			WHEN Atras3059Clave THEN CONCAT(Atras3059Clave,"= ",Atras3059Des)
			WHEN Atras6089Clave	THEN CONCAT(Atras6089Clave,"= ",Atras6089Des)
			WHEN Atras9019Clave	THEN CONCAT(Atras9019Clave,"= ",Atras9019Des)
			WHEN Atras2049Clave THEN CONCAT(Atras2049Clave,"= ",Atras2049Des)
			WHEN Atras5012Clave THEN CONCAT(Atras5012Clave,"= ",Atras5012Des)
			WHEN Atras12MClave THEN CONCAT(Atras12MClave,"= ",Atras12MDes)
			WHEN Atras12MClave THEN CONCAT(Atras12MClave,"= ",Atras12MDes)
			WHEN CtaCastigClave THEN CONCAT(CtaCastigClave,"= ",CtaCastigDes)
			WHEN FraudCliClave	THEN CONCAT(FraudCliClave,"= ",FraudCliDes)
		 END )AS MOP,
		 tmp.FechaMaxMora,	CAST(tmp.MontoMaxMora AS DECIMAL (12,2)) AS MontoMaxMora, MOPMora,
			CASE tmp.FrecuenciaPag
				WHEN "B" THEN "Bimestral"
				WHEN "D" THEN "Diario"
				WHEN "H" THEN "Semestral"
				WHEN "K" THEN "Catorcenal"
				WHEN "M" THEN "Mensual"
				WHEN "P" THEN  "Deducción del salario"
				WHEN "Q" THEN "Trimestral"
				WHEN "S" THEN "Quincenal"
				WHEN "V" THEN "Variable"
				WHEN "W" THEN"Semanal"
				WHEN "Y" THEN  "Anual"
				WHEN "Z" THEN "Pago mínimo" END AS FrecuenciaPag
	FROM TMPDETCREDTL tmp
	WHERE tmp.FolioSol = Par_FolioSol;


END IF;


/*7. SECCION PARA LLENAR EL RESUMEN DEL CREDITO */
IF(Par_NumCon = ConSegRS) THEN

	/*SE ELIMINA Y LUEGO SE VUELVE A CREAR LA TABLA TEMPORAL */
	DROP TABLE IF EXISTS TMPOCONSULTARS;
	CREATE TEMPORARY TABLE TMPOCONSULTARS(
		Consecutivo		INT,
		FolioSol 		VARCHAR(30),
		CuentasAb 		VARCHAR(60),
		LimiteAb		DECIMAL(12,2),
		MaxAb			DECIMAL(12,2),
		SaldoAcAb		DECIMAL(12,2),
		SaldoVenAb		DECIMAL(12,2),
		PagoRealizar	DECIMAL(12,2),
		CuentasCerr		VARCHAR(60),
		LimiteCerradas	DECIMAL(12,2),
		MaximoCerradas	DECIMAL(12,2)
	);

	SET cantRegistros :=	(SELECT MAX(RS_CONSEC)
								FROM 	bur_segrs
								WHERE 	BUR_SOLNUM = Par_FolioSol);


	SET contador := 1;
DROP TABLE IF EXISTS tmp_saldosCuentas;
CREATE TABLE tmp_saldosCuentas
(
	BUR_SOLNUM 	VARCHAR(15),
	TL_CONSEC	VARCHAR(15),
	FechaCierre	VARCHAR(15),
	Monto		VARCHAR(15),
	MontoMax	VARCHAR(15)
);
 -- selene
	INSERT INTO tmp_saldosCuentas(BUR_SOLNUM,TL_CONSEC,FechaCierre)
		SELECT BUR_SOLNUM, TL_CONSEC, TL_VALOR
		FROM 	bur_segtl
		WHERE 	BUR_SOLNUM = Par_FolioSol
		AND TL_SEGMEN = seg16;

	UPDATE tmp_saldosCuentas tmp ,bur_segtl bur
	SET tmp.Monto=bur.TL_VALOR
	WHERE tmp.BUR_SOLNUM=bur.BUR_SOLNUM
	AND tmp.TL_CONSEC=bur.TL_CONSEC
	AND bur.TL_SEGMEN=Seg23;


	UPDATE tmp_saldosCuentas tmp ,bur_segtl bur
	SET tmp.MontoMax=bur.TL_VALOR
	WHERE tmp.BUR_SOLNUM=bur.BUR_SOLNUM
	AND tmp.TL_CONSEC=bur.TL_CONSEC
	AND bur.TL_SEGMEN=Seg21;



	WHILE contador <= cantRegistros  DO
		SET VarSaldoActual := (SELECT  SUM(IFNULL(RS_VALOR,Decimal_Cero))
								FROM 	bur_segrs
								WHERE 	BUR_SOLNUM = Par_FolioSol
								AND  	RS_SEGMEN = seg22
								AND 	RS_CONSEC = contador);


		SET Var_CharSaldoAcAb		:= (SELECT IFNULL(RS_VALOR,Decimal_Cero)
										FROM 	bur_segrs
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	RS_SEGMEN = seg23
										AND 	RS_CONSEC = contador);
		SET Var_CharSaldoAcAb		:= IFNULL(Var_CharSaldoAcAb,Cadena_Vacia);
		SET Var_SaldoAcAb		:=  (CAST(REPLACE(Var_CharSaldoAcAb,'+','') AS DECIMAL(14,2)));

		SET Var_CharSaldoAcAb		:= (SELECT IFNULL(RS_VALOR,Decimal_Cero)
										FROM 	bur_segrs
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	RS_SEGMEN = seg28
										AND 	RS_CONSEC = contador);
		SET Var_CharSaldoAcAb		:= IFNULL(Var_CharSaldoAcAb,Cadena_Vacia);
		SET Var_SaldoAcAb			:= Var_SaldoAcAb + CAST(REPLACE(Var_CharSaldoAcAb,'+','') AS DECIMAL(14,2));

		-- SALDO VENCIDO ABIERTAS **
		SET Var_CharSaldoVenAb		:=  (SELECT IFNULL(RS_VALOR,Cadena_Vacia)
										FROM 	bur_segrs
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	RS_SEGMEN = seg24
										AND 	RS_CONSEC = contador);
		SET Var_CharSaldoVenAb		:= IFNULL(Var_CharSaldoVenAb,Cadena_Vacia);
		SET Var_SaldoVenAb			:= CAST(REPLACE(Var_CharSaldoVenAb,'+','')	AS DECIMAL(14,2));
		SET Var_SaldoVenAb			:= IFNULL(Var_SaldoVenAb,Decimal_Cero );
		SET Var_CharSaldoVenAb		:=  (SELECT IFNULL(RS_VALOR,Cadena_Vacia)
										FROM 	bur_segrs
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	RS_SEGMEN = seg29
										AND 	RS_CONSEC = contador);
		SET Var_CharSaldoVenAb	:= IFNULL(Var_CharSaldoVenAb,Cadena_Vacia);
		SET Var_SaldoVenAb		:= Var_SaldoVenAb+ CAST(REPLACE(Var_CharSaldoVenAb,'+','')	AS DECIMAL(14,2));
		SET Var_SaldoVenAb			:= IFNULL(Var_SaldoVenAb,Decimal_Cero );

		-- PAGOS A REALIZAR **
		SET Var_CharPagoRealizar	:= (SELECT IFNULL(RS_VALOR,Cadena_Vacia)
										FROM 	bur_segrs
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	RS_SEGMEN = seg25
										AND 	RS_CONSEC = contador);
		SET Var_CharPagoRealizar	:= IFNULL(Var_CharPagoRealizar,Cadena_Vacia);
		SET Var_PagoRealizar	:= CAST(REPLACE(Var_CharPagoRealizar,'+','') AS DECIMAL(14,2));

		SET Var_CharPagoRealizar	:= (SELECT IFNULL(RS_VALOR,Cadena_Vacia)
										FROM 	bur_segrs
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	RS_SEGMEN = seg30
										AND 	RS_CONSEC = contador);
		SET Var_CharPagoRealizar	:= IFNULL(Var_CharPagoRealizar,Cadena_Vacia);
		SET Var_PagoRealizar		:= Var_PagoRealizar + CAST(REPLACE(Var_CharPagoRealizar,'+','') AS DECIMAL(14,2));




INSERT INTO TMPOCONSULTARS (
			Consecutivo,		FolioSol,		CuentasAb,			LimiteAb,			MaxAb,
			SaldoAcAb,			SaldoVenAb,		PagoRealizar,		CuentasCerr,		LimiteCerradas,
			MaximoCerradas)
		VALUES(
			contador,			Par_FolioSol,	Var_CuentasAb,		CAST(Var_LimiteAb AS DECIMAL(12,2)),		CAST(Var_MaxAb AS DECIMAL(12,2)),
			CAST(Var_SaldoAcAb AS DECIMAL(12,2)),		CAST(Var_SaldoVenAb AS DECIMAL(12,2)),	CAST(Var_PagoRealizar AS DECIMAL(12,2)), Var_CuentasCerr,
			CAST(VarLimiteCerradas  AS DECIMAL(12,2)),
			CAST(VarMaximoCerradas AS DECIMAL(12,2)));

		SET contador := contador +1;

	END WHILE;

	SET VarLimiteCerradas = ( SELECT SUM(IFNULL(monto,0.0)) FROM tmp_saldosCuentas WHERE FechaCierre <>'');
	SET Var_LimiteAb = ( SELECT SUM(IFNULL(monto,0.0)) FROM tmp_saldosCuentas WHERE FechaCierre = '');
	SET Var_CuentasAb = ( SELECT COUNT(TL_CONSEC) FROM tmp_saldosCuentas WHERE FechaCierre = '');
	SET Var_CuentasCerr  = ( SELECT COUNT(TL_CONSEC) FROM tmp_saldosCuentas WHERE FechaCierre <> '');

	SET Var_MaxAb =( SELECT SUM(IFNULL(montoMax,0.0)) FROM tmp_saldosCuentas WHERE FechaCierre = '');
	SET VarMaximoCerradas =( SELECT SUM(IFNULL(montoMax,0.0)) FROM tmp_saldosCuentas WHERE FechaCierre <> '');

    UPDATE  TMPOCONSULTARS SET
    CuentasAb		=	Var_CuentasAb,
    LimiteAb		=	CAST(Var_LimiteAb AS DECIMAL(12,2)),
    MaxAb			=	CAST(Var_MaxAb AS DECIMAL(12,2)),
    CuentasCerr		= 	Var_CuentasCerr,
    LimiteCerradas	= CAST(VarLimiteCerradas AS DECIMAL(12,2)),
    MaximoCerradas 	= CAST(VarMaximoCerradas AS DECIMAL(12,2));

	SELECT  Consecutivo,	FolioSol,							CuentasAb,		LimiteAb,		MaxAb,
			SaldoAcAb,		SaldoVenAb, 						PagoRealizar,	CuentasCerr,	LimiteCerradas,
			MaximoCerradas,	Decimal_Cero AS SalActCerradas,		Decimal_Cero AS MontoCerradas
	FROM TMPOCONSULTARS
	WHERE FolioSol = Par_FolioSol;

	DROP TABLE IF EXISTS  TMPOCONSULTARS;
	DROP TABLE IF EXISTS tmp_saldosCuentas;
END IF;



IF(Par_NumCon = ConSegIQ) THEN

SET cantRegistros := (SELECT MAX(IQ_CONSEC)
						FROM 	bur_segiq
						WHERE 	BUR_SOLNUM = Par_FolioSol);

	 DROP TABLE IF EXISTS TMPCONSULTASIQ;
	CREATE TEMPORARY TABLE TMPCONSULTASIQ
											(	Consecutivo		INT,
												FolioSol 		VARCHAR(30),
												Otorgante 		VARCHAR(16),
												FechConsulta 	DATE,
												Responsabilidad	CHAR(1),
												TipoContrato	CHAR(2),
												Importe			DECIMAL(14,4),
												TipoMoneda		CHAR(2));
	SET contador := 1;
	WHILE contador <= cantRegistros  DO

		SET FechaNacCad :="";
		SET FechaNacCad := (SELECT IFNULL(IQ_VALOR,Fecha_Vacia)
										FROM 	bur_segiq
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	IQ_SEGMEN = segIQ
										AND 	IQ_CONSEC = contador);

		SET dia := (SUBSTR(FechaNacCad,1,2) );
		SET mes := (SUBSTR(FechaNacCad,3,2) );
		SET charAnio := (SUBSTR(FechaNacCad,5,4) );


		SET FechaNacCad := CONCAT(charAnio,"-",mes,"-",dia);

		INSERT INTO TMPCONSULTASIQ (
										Consecutivo,	FolioSol,		Otorgante,	FechConsulta,	Responsabilidad,
										TipoContrato,	Importe,		TipoMoneda)
						VALUES		  (	contador,		Par_FolioSol,	(SELECT IFNULL(IQ_VALOR,Cadena_Vacia)
																		FROM 	bur_segiq
																		WHERE 	BUR_SOLNUM = Par_FolioSol
																		AND  	IQ_SEGMEN = seg2
																		AND 	IQ_CONSEC = contador),
										FechaNacCad,
										(SELECT IFNULL(IQ_VALOR,Cadena_Vacia)
										FROM 	bur_segiq
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	IQ_SEGMEN = seg7
										AND 	IQ_CONSEC = contador),
										(SELECT IFNULL(IQ_VALOR,Cadena_Vacia)
										FROM 	bur_segiq
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	IQ_SEGMEN = seg4
										AND 	IQ_CONSEC = contador),
										(SELECT IFNULL(IQ_VALOR,Decimal_Cero)
										FROM 	bur_segiq
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	IQ_SEGMEN = seg6
										AND 	IQ_CONSEC = contador),
										(SELECT IFNULL(IQ_VALOR,Cadena_Vacia)
										FROM 	bur_segiq
										WHERE 	BUR_SOLNUM = Par_FolioSol
										AND  	IQ_SEGMEN = seg5
										AND 	IQ_CONSEC = contador)
										);



		SET contador := contador +1;

	END WHILE;



SELECT Consecutivo,	FolioSol,	Otorgante,	FechConsulta,
	   (CASE Responsabilidad
		WHEN  UsuarioAut  		THEN RespDescUsu
		WHEN  Individual  		THEN RespDescIndiv
		WHEN  Mancomunado  		THEN RespDescManc
		WHEN  ObligadoSolid  	THEN RespDescOSol
		END) AS DescripRespons,
		(CASE TipoContrato
		WHEN  MueblesCod 		THEN MuebDescrip
		WHEN  AgropecuaCod  	THEN AgropDescrip
		WHEN  ArrAutoamCod  	THEN ArrAutoDescrip
		WHEN  AviacionCod  		THEN AviacDescrip
		WHEN  ComAutoCod  		THEN ComAutoDescrip
		WHEN  FianzaCod  		THEN FianzaDescrip
		WHEN  BoteCod  			THEN BoteDescrip
		WHEN  TarjCredCod  		THEN TarjCredDescrip
		WHEN  CartasCredCod  	THEN CarCredDescrip
		WHEN  CredFiscalCod  	THEN CreFiscDescrip
		WHEN  LineaCredCod  	THEN LinCredDescrip
		WHEN  ConsolidCod  		THEN ConsolidDescrip
		WHEN  CredSimpCod  		THEN CredSimpDescrip
		WHEN  ConColaterCod  	THEN ConColaDescrip
		WHEN  DescuentCod  		THEN DescDescrip
		WHEN  EquipoCod  		THEN EquipoDescrip
		WHEN  FideicomCod  		THEN FideiDescrip
		WHEN  FactorajCod  		THEN FactoDescrip
		WHEN  HabilAvioCod 		THEN HabAvDescrip
		WHEN  HomeEquiCod  		THEN HomeEqDescrip
		WHEN  MejorCasaCod  	THEN MejCaDescrip
		WHEN  LinCreReinsCod  	THEN LCreReiDescrip
		WHEN  ArrendamienCod  	THEN ArrendaDescrip
		WHEN  OtrosCod  		THEN OtrosDescrip
		WHEN  OAdeuVencCod  	THEN OAdeVeDescrip
		WHEN  PrePFAEmpCod  	THEN PrePFAEmpDescr
		WHEN  EditorialCod  	THEN EditorDescrip
		WHEN  PreGarUnInCod  	THEN PreGarUInDescr
		WHEN  PresPersonCod  	THEN PrePerDescrip
		WHEN  PresNominaCod  	THEN PreNomiDescrip
		WHEN  QuirografCod  	THEN QuirogDescrip
		WHEN  PrendarioCod  	THEN PrendaDescrip
		WHEN  PagoServiCod  	THEN PagoSerDescrip
		WHEN  RestructCod  		THEN RestructDescrip
		WHEN  RedescuentoCod  	THEN RedescDescrip
		WHEN  BienesRaiCod  	THEN BienRaiDescrip
		WHEN  RefaccionCod  	THEN RefaccDescrip
		WHEN  RenovadoCod  		THEN RenovDescrip
		WHEN  VehicRecreCod  	THEN VehiRecDescrip
		WHEN  TarjGaranCod  	THEN TarGarDescrip
		WHEN  PresGaranCod  	THEN PreGarDescrip
		WHEN  SegurosCod  		THEN SegurosDescrip
		WHEN  SegHipotecaCod  	THEN SegHipoDescrip
		WHEN  PresEstudiaCod  	THEN PresEstDescrip
		WHEN  TarjCreEmpCod 	THEN TaCreEDescrip
		WHEN  DesconocCod  		THEN DescoDescrip
		WHEN  PresNoGarCod  	THEN PNoGarDescrip

		END) AS DescTipoContrato,

	Importe,	TipoMoneda
		FROM TMPCONSULTASIQ
		WHERE FolioSol = Par_FolioSol;


 DROP TABLE TMPCONSULTASIQ;

END IF;

-- 9.
IF(Par_NumCon = HistPagos) THEN

	TRUNCATE tmp_histoFecha;
	TRUNCATE tmp_hisPagBuro;


		SET contador := 0;
		SET contador := contador +1;

		SET fechaAntCad :="";
		SET fechaAntCad := (SELECT  	TL_VALOR
							FROM 	bur_segtl
							WHERE 	BUR_SOLNUM = Par_FolioSol
							AND  	TL_SEGMEN = seg28
							AND 	TL_CONSEC = Par_Consecutivo);
		SET dia			:= (SUBSTR(fechaAntCad,1,2) );
		SET mes			:= (SUBSTR(fechaAntCad,3,2) );
		SET charAnio	:= (SUBSTR(fechaAntCad,5,4) );
		IF(IFNULL(charAnio,Cadena_Vacia) <> Cadena_Vacia AND IFNULL(mes,Cadena_Vacia) <> Cadena_Vacia AND IFNULL(dia,Cadena_Vacia) <> Cadena_Vacia)THEN
			SET fechaAntCad	:= IFNULL(CONCAT(charAnio,"-",mes,"-",dia),Fecha_Vacia);
		END IF;

		IF(IFNULL(fechaAntCad,'') = '' )THEN
			SET fechaAntCad	:=Fecha_Vacia;
		END IF;

		SET fechaAntCad	:= IFNULL(fechaAntCad,Fecha_Vacia);


		INSERT INTO tmp_hisPagBuro(
			Consecutivo,	CadenaHistorico,	FolioConsultaBC,	FechaAntigua,	TamCadenaHis)
			VALUES( Par_Consecutivo,
			   IFNULL((SELECT  TL_VALOR
					FROM 	bur_segtl
					WHERE 	BUR_SOLNUM = Par_FolioSol
					AND  	TL_SEGMEN = seg27
					AND 	TL_CONSEC = Par_Consecutivo),''),
				Par_FolioSol,
				fechaAntCad,
				 IFNULL((SELECT  LENGTH(TL_VALOR)
					FROM 	bur_segtl
					WHERE 	BUR_SOLNUM = Par_FolioSol
					AND  	TL_SEGMEN = seg27
					AND 	TL_CONSEC = Par_Consecutivo),0) -- Antes tenia '' pero tronaba por modo estricto se cambia a 0
				);
	SELECT Consecutivo, CadenaHistorico, FolioConsultaBC, FechaAntigua,	TamCadenaHis
		INTO VarConsecutivo,VarCadena, VarFolioBC, VarFecha, VarTamCadena
		FROM tmp_hisPagBuro
		WHERE FolioConsultaBC=Par_FolioSol
		AND Consecutivo =Par_Consecutivo ;

			SET varFechaHis := VarFecha;
			SET contador := 1;
			WHILE contador <= VarTamCadena  DO
				SET charAnio := SUBSTR(varFechaHis,1,4);
				SET mes  := SUBSTR(varFechaHis,6,2);

				INSERT INTO tmp_histoFecha(Consecutivo, FolioConsultaBC, ValorHis, Anio, Mes)
					VALUES(VarConsecutivo,VarFolioBC,
									(SELECT  SUBSTR(VarCadena,contador,1)
										FROM 	tmp_hisPagBuro
										WHERE 	FolioConsultaBC = Par_FolioSol
										AND 	Consecutivo= VarConsecutivo),
									charAnio,	mes);



				SET contador := contador +1;
				SET varFechaHis := (SELECT DATE_SUB(varFechaHis,INTERVAL 1 MONTH));

			END WHILE;

    DROP TABLE IF EXISTS TMPHISTORICO;
	CREATE TEMPORARY TABLE TMPHISTORICO(
		Consecutivo		INT,
		AnioHis 		CHAR(4),
		Cadena			VARCHAR(100),
        Observacion		VARCHAR(10000));


	SET @cadenaHis = '';
	OPEN  CursorAnio;
		BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			LOOP
			FETCH CursorAnio  INTO VarAnio,varcontador;

			SET varCons := (SELECT tf.Consecutivo
				FROM (SELECT ta.Consecutivo,tm.mes, ta.Anio
						FROM tmp_mesbur tm,
							(SELECT Consecutivo,Anio FROM tmp_histoFecha WHERE Consecutivo=varcontador GROUP BY Anio, Consecutivo ) AS ta
					  ORDER BY Anio, tm.mes) AS tf
					  LEFT OUTER JOIN tmp_histoFecha  AS th ON th.Consecutivo = varcontador
					  AND FolioConsultaBC = Par_FolioSol
					  AND tf.mes = th.Mes AND tf.Anio = th.Anio
				WHERE tf.Anio = VarAnio
				ORDER BY tf.Anio, tf.Mes  DESC LIMIT 1);

            SET varA := (SELECT tf.Anio
				FROM (SELECT ta.Consecutivo,tm.mes, ta.Anio
						FROM tmp_mesbur tm,
							(SELECT Consecutivo,Anio FROM tmp_histoFecha WHERE Consecutivo=varcontador GROUP BY Anio, Consecutivo ) AS ta
					  ORDER BY Anio, tm.mes) AS tf
					  LEFT OUTER JOIN tmp_histoFecha  AS th ON th.Consecutivo = varcontador
					  AND FolioConsultaBC = Par_FolioSol
					  AND tf.mes = th.Mes AND tf.Anio = th.Anio
				WHERE tf.Anio = VarAnio
				ORDER BY tf.Anio, tf.Mes  DESC LIMIT 1);

			SET varCad := (SELECT @cadenaHis := CONCAT(@cadenaHis,IFNULL(th.ValorHis,' '), '  ')
				FROM (SELECT ta.Consecutivo,tm.mes, ta.Anio
						FROM tmp_mesbur tm,
							(SELECT Consecutivo,Anio FROM tmp_histoFecha WHERE Consecutivo=varcontador GROUP BY Anio, Consecutivo ) AS ta
					  ORDER BY Anio, tm.mes) AS tf
					  LEFT OUTER JOIN tmp_histoFecha  AS th ON th.Consecutivo = varcontador
					  AND FolioConsultaBC = Par_FolioSol
					  AND tf.mes = th.Mes AND tf.Anio = th.Anio
				WHERE tf.Anio = VarAnio
				ORDER BY tf.Anio, tf.Mes  DESC LIMIT 1);

                SET Var_Observacion :=  (SELECT  IFNULL(TL_VALOR,'')
												FROM 	bur_segtl
												WHERE 	BUR_SOLNUM = Par_FolioSol
												AND  	TL_SEGMEN = seg30
                                                AND 	TL_CONSEC=varcontador);

								SET @cadenaHis = '';

			INSERT INTO TMPHISTORICO (	Consecutivo,		AnioHis,		Cadena,		Observacion	)
						VALUES	 (		varCons, 			varA,  			varCad,		Var_Observacion );
			END LOOP;
		END;
	CLOSE CursorAnio;

UPDATE TMPHISTORICO,CATCLAVESOBS  SET
Observacion =CONCAT(Observacion,'= ',Descripcion)
WHERE Observacion =Clave;

SELECT * FROM TMPHISTORICO;

DROP TABLE TMPHISTORICO;

TRUNCATE tmp_histoFecha;
TRUNCATE tmp_hisPagBuro;

END IF;


END TerminaStore$$

DELIMITER ;

