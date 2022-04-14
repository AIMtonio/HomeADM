-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDINGRESOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDINGRESOREP`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDINGRESOREP`(
	-- Clientes	- Reportes	- 		Solicitud Ingreso
	Par_ClienteID		BIGINT(20),
    Par_TipoReporte		INT(11),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
	)

TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_NombrePromotor  VARCHAR(200);
DECLARE Var_ClienteID       BIGINT;
DECLARE Var_ProspectoID     BIGINT;
DECLARE Var_SucursalID      INT(11);
DECLARE Var_Numcliente      BIGINT;
DECLARE Var_NombreSucurs    VARCHAR(200);
DECLARE Var_NombreCli       VARCHAR(200);
DECLARE Var_FecNacCli       DATE;
DECLARE Var_PaisNac         VARCHAR(200);
DECLARE Var_EstadoNac       VARCHAR(200);
DECLARE Var_CliSexo         CHAR(1);
DECLARE Var_CliGenero       VARCHAR(20);
DECLARE Var_Ocupacion       VARCHAR(500);
DECLARE Var_ClaveNacion     CHAR(1);
DECLARE Var_CliNacion       VARCHAR(20);
DECLARE Var_ClaveEstCiv     CHAR(2);
DECLARE Var_DescriEstCiv    VARCHAR(50);
DECLARE Var_CliCURP         VARCHAR(20);
DECLARE Var_CliRFC          VARCHAR(20);
DECLARE Var_EscoCli         VARCHAR(100);
DECLARE Var_CliCalle        VARCHAR(200);
DECLARE Var_CliNumInt       VARCHAR(20);
DECLARE Var_CliPiso         VARCHAR(20);
DECLARE Var_CliLote         VARCHAR(20);
DECLARE Var_CliManzana      VARCHAR(20);
DECLARE Var_CliColoni       VARCHAR(200);
DECLARE Var_CliNumCasa      VARCHAR(20);
DECLARE Var_CliMunici       VARCHAR(200);
DECLARE Var_CliColMun       VARCHAR(300);
DECLARE Var_CliCalNum       VARCHAR(300);
DECLARE Var_1aEntreCalle    VARCHAR(200);
DECLARE Var_2aEntreCalle    VARCHAR(200);
DECLARE Var_CliTelTra       VARCHAR(20);
DECLARE Var_CliTelCel       VARCHAR(20);
DECLARE Var_CliTelPart      VARCHAR(20);
DECLARE Var_DirecCompleta	VARCHAR(400);
DECLARE Var_CliValorViv     DECIMAL(12,2);
DECLARE Var_CliTipViv       VARCHAR(100);
DECLARE Var_CliMatViv       VARCHAR(100);
DECLARE Var_DirTrabajo      VARCHAR(300);
DECLARE Var_CliLugTra       VARCHAR(200);
DECLARE Var_CliPuesto       VARCHAR(100);
DECLARE Var_CliAntTra       DECIMAL(12,2);
DECLARE Var_DesCliAntTra    VARCHAR(100);
DECLARE Var_MontoSolici     DECIMAL(14,2);
DECLARE Var_Finalidad       VARCHAR(200);
DECLARE Var_Tasa            DECIMAL(12,4);
DECLARE Var_DesProducto     VARCHAR(200);
DECLARE Var_Plazo           VARCHAR(100);
DECLARE Var_Moneda          VARCHAR(50);
DECLARE Var_Destino         VARCHAR(200);
DECLARE Var_Frecuencia      VARCHAR(50);
DECLARE Var_TipoGarant      VARCHAR(50);
DECLARE Var_ConyPriNom      VARCHAR(100);
DECLARE Var_ConySegNom      VARCHAR(100);
DECLARE Var_ConyTerNom      VARCHAR(100);
DECLARE Var_ConyApePat      VARCHAR(100);
DECLARE Var_ConyApeMat      VARCHAR(100);
DECLARE Var_ConyFecNac      DATE;
DECLARE Var_ConyPaiNac      VARCHAR(100);
DECLARE Var_ConyEstNac      VARCHAR(100);
DECLARE Var_ConyNomEmp      VARCHAR(200);
DECLARE Var_ConyEstEmp      VARCHAR(100);
DECLARE Var_ConyMunEmp      VARCHAR(100);
DECLARE Var_ConyColEmp      VARCHAR(200);
DECLARE Var_ConyCalEmp      VARCHAR(200);
DECLARE Var_ConyNumExt      VARCHAR(20);
DECLARE Var_ConyNumInt      VARCHAR(20);
DECLARE Var_ConyNumPiso     VARCHAR(20);
DECLARE Var_ConyCodPos      VARCHAR(5);
DECLARE Var_ConyAntAnio     VARCHAR(20);
DECLARE Var_ConyAntMes      VARCHAR(20);
DECLARE Var_ConyTelTra      VARCHAR(20);
DECLARE Var_ConyTelCel      VARCHAR(20);
DECLARE Var_ConyNomCom      VARCHAR(300);
DECLARE Var_DirEmpCony      VARCHAR(300);
DECLARE Var_ConyAntTra      VARCHAR(100);
DECLARE Var_ConyOcupa       VARCHAR(500);
DECLARE Var_ConyNacion      VARCHAR(50);
DECLARE Var_ProducCredID    INT(11);
DECLARE Var_ClienteEdad     INT(11);
DECLARE Var_ConyugeEdad     INT(11);
DECLARE Var_NumCreditos     INT(11);
DECLARE Var_CicBaseCli      INT(11);
DECLARE Var_ClienteCiclo    INT(11);
DECLARE Var_NumCreTra       INT(11);
DECLARE Var_MonUltCred      DECIMAL(14,2);
DECLARE Var_NumDepend       INT(11);
DECLARE Var_NumHijos        INT(11);
DECLARE Var_PEPS            VARCHAR(10);
DECLARE Var_DescripcionPEP  VARCHAR(100);
DECLARE Var_ParPEP          VARCHAR(10);
DECLARE Var_ParPEPNom       VARCHAR(30);
DECLARE Var_ParPEPAP        VARCHAR(30);
DECLARE Var_ParPEPAM        VARCHAR(30);
DECLARE Var_DirOfi          CHAR(1);
DECLARE Var_FechaAltaCli	DATE;

DECLARE Var_TipoViv				VARCHAR(200);
DECLARE Var_NomEstado			VARCHAR(200);
DECLARE Var_CodigoP				CHAR(5);
DECLARE Var_NombreRef			VARCHAR(50);
DECLARE Var_TelefonoRef			VARCHAR(50);
DECLARE Var_ExTelRfCm			VARCHAR(50);
DECLARE Var_DomicilioRef		VARCHAR(50);
DECLARE Var_NombreRef2			VARCHAR(50);
DECLARE Var_TelefonoRef2		VARCHAR(50);
DECLARE Var_ExTelRfCm2			VARCHAR(50);
DECLARE Var_DomicilioRef2		VARCHAR(50);
DECLARE Var_NombRefCom			VARCHAR(50);
DECLARE Var_TelRefCom			VARCHAR(50);
DECLARE Var_NombRefCom2			VARCHAR(50);
DECLARE Var_TelRefCom2			VARCHAR(50);
DECLARE Var_BancoRef			VARCHAR(50);
DECLARE Var_NoCuentaRef			VARCHAR(50);
DECLARE Var_BancoRef2			VARCHAR(50);
DECLARE Var_NoCuentaRef2		VARCHAR(50);
DECLARE Var_Encabezado			VARCHAR(500);
DECLARE Var_Nombre				VARCHAR(200);
DECLARE Var_Relacion			VARCHAR(200);
DECLARE Var_Porcentaje			VARCHAR(200);
DECLARE Var_DepEcon				INT(11);
DECLARE Var_DescDir				VARCHAR(200);
DECLARE Var_DirTrab				VARCHAR(200);
DECLARE TotalIngre				DECIMAL(14,2);
DECLARE TotalEgre				DECIMAL(14,2);
DECLARE Var_CompromisoAho		DECIMAL(14,2);
DECLARE Var_Observaciones		VARCHAR(500);
DECLARE Var_PoderNotarialGte 	VARCHAR(500);
DECLARE Var_NombreMun			VARCHAR(500);
DECLARE Var_NombreInstitucion	VARCHAR(500);
DECLARE Var_TituloGte			VARCHAR(10);
DECLARE Var_NombreGerente		VARCHAR(200);
DECLARE Var_CalcAntiguedad 	 	CHAR(1);
DECLARE Var_NO					CHAR(1);
DECLARE Var_SI					CHAR(1);

DECLARE Fecha_Vacia     		DATE;
DECLARE Decimal_Cero    		DECIMAL(12,2);
DECLARE Entero_Cero     		INT;
DECLARE Cadena_Vacia    		CHAR(1);
DECLARE Seccion_General 		INT(11);
DECLARE Seccion_EconoIng    	INT(11);
DECLARE Seccion_EconoEgr    	INT(11);
DECLARE Seccion_DepEcono    	INT(11);
DECLARE Seccion_Avales      	INT(11);
DECLARE Seccion_Garant      	INT(11);
DECLARE Seccion_Refere      	INT(11);
DECLARE Seccion_Benefi      	INT(11);
DECLARE	Seccion_TercerFirmante	INT(11);
DECLARE	Seccion_BenefiYANGA		INT(11);
DECLARE	Seccion_GralSOFI		INT(11);
DECLARE	Seccion_BenefiSOFI		INT(11);
DECLARE Si_Requiere     		CHAR(1);
DECLARE Es_Beneficiario 		CHAR(1);
DECLARE Tipo_Ingreso    		CHAR(1);
DECLARE Tipo_Egreso     		CHAR(1);
DECLARE Est_Vigente     		CHAR(1);
DECLARE Ava_Autorizado  		CHAR(1);
DECLARE Gar_Autorizado  		CHAR(1);
DECLARE Cue_Activa      		CHAR(1);
DECLARE Rel_Hijo        		INT(11);
DECLARE Est_Pagado      		CHAR(1);
DECLARE Gen_Masculino   		CHAR(1);
DECLARE Gen_Femenino    		CHAR(1);
DECLARE Des_Masculino   		VARCHAR(20);
DECLARE Des_Femenino    		VARCHAR(20);
DECLARE Nac_Mexicano    		CHAR(1);
DECLARE	Nac_Extranjero			CHAR(1);
DECLARE Des_Mexicano    		VARCHAR(20);
DECLARE Des_Extranjero  		VARCHAR(20);
DECLARE Var_CliArchID   		INT(11);

DECLARE Est_Soltero     		CHAR(2);
DECLARE Est_CasBieSep   		CHAR(2);
DECLARE Est_CasBieMan   		CHAR(2);
DECLARE Est_CasCapitu  			CHAR(2);
DECLARE Est_Viudo       		CHAR(2);
DECLARE Est_Divorciad   		CHAR(2);
DECLARE Est_Seperados   		CHAR(2);
DECLARE Est_UnionLibre  		CHAR(2);
DECLARE Dir_Oficial     		CHAR(1);
DECLARE Dir_Trabajo     		INT(11);
DECLARE Des_Soltero     		CHAR(50);
DECLARE Des_CasBieSep   		CHAR(50);
DECLARE Des_CasBieMan   		CHAR(50);
DECLARE Des_CasCapitu   		CHAR(50);
DECLARE Des_Viudo       		CHAR(50);
DECLARE Des_Divorciad   		CHAR(50);
DECLARE Des_Seperados   		CHAR(50);
DECLARE Des_UnionLibre  		CHAR(50);
DECLARE Var_Recur       		VARCHAR(500);
DECLARE Foto            		INT(11);
DECLARE Var_EstadoSuc			VARCHAR(200);
DECLARE	Var_MunciSuc			VARCHAR(500);
DECLARE	Var_FechaSis			VARCHAR(100);
DECLARE Var_MesSis				VARCHAR(15);
DECLARE Var_DiaSis				INT(2);
DECLARE Var_AnioSis				INT(4);
DECLARE TipoLinaNeg				INT(11);
DECLARE Egreso					CHAR(1);
DECLARE Ingreso					CHAR(1);
DECLARE Fecha_Sis       		DATE;
DECLARE No_Oficial          	CHAR(1);

/* SECCION 01: Solicitud de apertura de cuenta */
DECLARE	Var_TipoCte				INT(11);
DECLARE	PersonaFisica			CHAR(1);
DECLARE	PersonaMoral			CHAR(1);
DECLARE	Var_MenorEdad			CHAR(1);
DECLARE	Var_CalleSuc			VARCHAR(200);
DECLARE	Var_NumCasaSuc			VARCHAR(50);
DECLARE	Var_ColSuc				VARCHAR(200);
DECLARE	Var_TipoPersona			CHAR(1);

DECLARE	Var_NomEmpresa			VARCHAR(200);
DECLARE	Var_EmpCalle			VARCHAR(150);
DECLARE	Var_EmpNum				VARCHAR(10);
DECLARE	Var_EmpCP				VARCHAR(20);
DECLARE	Var_EmpCol				VARCHAR(200);
DECLARE	Var_EmpCalleRef			VARCHAR(350);
DECLARE	Var_EmpLocalidad		VARCHAR(200);
DECLARE	Var_EmpEstado			VARCHAR(200);
DECLARE	Var_EmpMun				VARCHAR(200);
DECLARE	Var_EmpFecCons			DATE;
DECLARE	Var_GiroMerc			VARCHAR(200);
DECLARE	TipoConstitutiva		CHAR(1);
DECLARE	Var_EmpTelPart			VARCHAR(20);
DECLARE	Var_EmpNacion			VARCHAR(20);
DECLARE	Var_CliCalleRef			VARCHAR(350);
DECLARE	Var_CliLocalidad		VARCHAR(200);
DECLARE	Var_RFCm				VARCHAR(20);
DECLARE	Var_NomRepLeg			VARCHAR(200);		-- Nombre del Representante legal cuando el cliente es una Persona Moral.
DECLARE	Var_CliTiempoHab		VARCHAR(150);		-- Tiempo de Residecia.
DECLARE	Var_CliCorreo			VARCHAR(150);		-- Correo del Cliente.
DECLARE	Var_CliServSol			INT(11);				-- Servicios Solicitados

DECLARE	Dir_Negocio				INT(11);				-- Constante para Identidicar Direccion de Tipo Negocio, TipoDireccionID: 2
DECLARE	Dir_Hogar				INT(11);				-- Constante para Identidicar Direccion de Tipo Hogar, TipoDireccionID: 1
DECLARE	Var_DescTipoViv			VARCHAR(200);		-- DescripciÃ³n del tipo de vivienda.
DECLARE	Var_TotIngOrd			DECIMAL(14,2);		-- Ingresos Ordinarios.
DECLARE	Var_DescIngOrd			VARCHAR(200);		-- DescripciÃ³n de los Ingresos Ordinarios.
DECLARE	Var_TotIngFam			DECIMAL(14,2);		-- Ingresos de Apoyo de Familiares.
DECLARE	Var_DescIngFam			VARCHAR(200);		-- Descripcion de Ingresos por Apoyo Familiar.
DECLARE	Var_TotIngOtros			DECIMAL(14,2);		-- Otros Ingresos
DECLARE	Var_DescIngOtros		VARCHAR(200);		-- Descripcion de Otros Ingresos

DECLARE	Var_TotEgrOrd			DECIMAL(14,2);		-- Egresos Ordinarios
DECLARE	Var_DescEgrOrd			VARCHAR(200);		-- Descripcion de Egresos Ordinarios
DECLARE	Var_TotEgrFam			DECIMAL(14,2);		-- Egresos Gastos Familiares
DECLARE	Var_DescEgrFam			VARCHAR(200);		-- Descripcion de Egresos Gastos Familiares
DECLARE	Var_OtrosEgr			DECIMAL(14,2);		-- Egresos Otros
DECLARE	Var_DescOtrosEgr		VARCHAR(200);		-- Descripcion de Egresos Otros

DECLARE	Var_TutorID				INT(11);
DECLARE	Var_NombreTutor			VARCHAR(250);
DECLARE	Var_MAApePat			VARCHAR(100);
DECLARE	Var_MAApeMat			VARCHAR(100);
DECLARE	Var_MANombres			VARCHAR(150);
DECLARE	Var_MAFecNac			VARCHAR(150);
DECLARE	Var_MAEdad				INT(11);
DECLARE	Var_MANacion			VARCHAR(50);
DECLARE	Var_MACURP				VARCHAR(20);

DECLARE	Var_ReFamNom			VARCHAR(200);		-- Nombre de la Referencia Familiar
DECLARE	Var_ReFamPar			VARCHAR(200);		-- Parentesco
DECLARE	Var_ReFamDom			VARCHAR(250);		-- Domicilio
DECLARE	Var_ReFamTel			VARCHAR(50);		-- Telefono

DECLARE	Var_RefPerNom			VARCHAR(200);
DECLARE	Var_RefPerPar			VARCHAR(200);
DECLARE	Var_RefPerDom			VARCHAR(250);
DECLARE	Var_RefPerTel			VARCHAR(50);

DECLARE	Var_TransID				BIGINT;

DECLARE	Var_CliApePat			VARCHAR(100);
DECLARE	Var_CliApeMat			VARCHAR(100);
DECLARE	Var_CliNombres			VARCHAR(150);

DECLARE	Var_TrabCalle			VARCHAR(200);
DECLARE	Var_TrabNum				VARCHAR(100);
DECLARE	Var_TrabCol				VARCHAR(150);
DECLARE	Var_RegConyug			VARCHAR(150);


DECLARE Cue_Cancel              CHAR(1);
DECLARE Cue_Inactiva            CHAR(1);

DECLARE Var_RelacionadoID		INT(11);
DECLARE Var_EsAvalID			INT(11);
DECLARE Var_EsGaranteID			INT(11);
-- IALDANA T_15576
DECLARE Cue_Bloq            	CHAR(1);
-- FIN IALDANA



/*CURSOR para sacar datos de beneficiarios de la cuenta principal*/
DECLARE CURSORBENEFICIARIOS CURSOR FOR
SELECT Cup.NombreCompleto,Tip.Descripcion,Cup.Porcentaje
	FROM CUENTASAHO	Cue
		INNER JOIN CUENTASPERSONA Cup ON Cup.CuentaAhoID=Cue.CuentaAhoID
		INNER JOIN TIPORELACIONES Tip ON Cup.ParentescoID=Tip.TipoRelacionID
	WHERE Cue.ClienteID=Par_ClienteID
		AND EsPrincipal= Var_SI
		AND EsBeneficiario= Var_SI
		AND EstatusRelacion = Est_Vigente
		AND Cue.Estatus = Cue_Activa;


DECLARE CURSORBENEFICIARIOSYANGA CURSOR FOR
SELECT Cup.NombreCompleto,Tip.Descripcion,Cup.Porcentaje
	FROM CUENTASAHO	Cue
		INNER JOIN CUENTASPERSONA Cup ON Cup.CuentaAhoID=Cue.CuentaAhoID
		LEFT OUTER JOIN TIPORELACIONES Tip ON Cup.ParentescoID=Tip.TipoRelacionID
	WHERE Cue.ClienteID=Par_ClienteID
		AND EsBeneficiario= Var_SI
		AND EstatusRelacion = Est_Vigente
		AND Cue.Estatus = Cue_Activa;

DECLARE CURSORBENEFISOFI CURSOR FOR
	SELECT Cup.NombreCompleto,IFNULL(Tip.Descripcion, Cadena_Vacia),Cup.Porcentaje,Cup.Domicilio,Cup.TelefonoCelular
	FROM CUENTASAHO	Cue
		INNER JOIN CUENTASPERSONA Cup ON Cup.CuentaAhoID	=	Cue.CuentaAhoID
		LEFT OUTER JOIN TIPORELACIONES Tip ON Cup.ParentescoID	=	Tip.TipoRelacionID
	WHERE Cue.ClienteID			=	Par_ClienteID
		AND Cue.EsPrincipal		=	Var_SI				-- Indica si es cuenta Principal :	S - Si,	N - No
		AND Cup.EsBeneficiario	=	Var_SI				-- indica si la persona es Beneficiario:	S=Si N=No
		AND Cup.EstatusRelacion =	Est_Vigente
		-- IALDANA T_15576 Se cambia el igual por el not IN para que considere aquellas cuentas con estatus diferentes a Canceladas y Bloqueadas
		AND Cue.Estatus			NOT IN(Cue_Cancel, Cue_Bloq);

-- Asigancion de Constantes
SET Fecha_Vacia         	:= '1900-01-01';            -- Fecha Vacia
SET Decimal_Cero        	:= 0.0;                     -- DECIMAL en Cero
SET Entero_Cero         	:= 0;                       -- Entero en Cero
SET Cadena_Vacia        	:= '';                      -- String o Cadena Vacia
SET Seccion_General     	:= 1;                       -- Seccion Gral, Cliente, Solicitud
SET Seccion_EconoIng    	:= 2;                       -- Seccion Economica del Cliente Ingreso
SET Seccion_EconoEgr    	:= 3;                       -- Seccion Economica del Cliente Egreso
SET Seccion_DepEcono    	:= 4;                       -- Seccion Dependientes Economicos del Cliente
SET Seccion_Refere      	:= 7;                       -- Seccion Referencias Personales
SET Seccion_Benefi      	:= 8;                       -- Seccion Beneficiarios
SET Seccion_TercerFirmante	:= 9;      					-- Seccion Tercer Firmante
SET	Seccion_BenefiYANGA		:= 10; 						-- Seccion Beneficiarios
SET	Seccion_GralSOFI		:= 11;						-- Seccion Gral
SET	Seccion_BenefiSOFI		:= 12;						-- Seccion Beneficiarios SOFIEXPRESS
SET Foto               	 	:= 1;                       -- Numero de Fotos

SET Si_Requiere         	:= 'S';                     -- Si Rquiere Garantia
SET Es_Beneficiario     	:= 'S';                     -- La Relacion es de Beneficiario
SET Tipo_Ingreso        	:= 'I';                     -- Tipo de Dato SocioEconomico: Ingreso
SET Tipo_Egreso         	:= 'E';                     -- Tipo de Dato SocioEconomico: Engreso
SET Gen_Masculino       	:= 'M';                     -- Genero: Masculino
SET Gen_Femenino        	:= 'F';                     -- Genero: Femenino
SET Des_Masculino       	:= 'MASCULINO';             -- Descripcion Genero: Masculino
SET Des_Femenino        	:= 'FEMENINO';              -- Descripcion Genero: Femenino
SET Nac_Mexicano        	:= 'N';                     -- Nacionalidad: N.- Nacional 	- Mexicano
SET	Nac_Extranjero			:= 'E';						-- Nacionalidad: E.- Extranjera - Extranjero
SET Des_Mexicano        	:= 'MEXICANA';              -- Nacionalidad: Mexicana
SET Des_Extranjero      	:= 'EXTRANJERA';            -- Nacionalidad: Extranjera
SET Est_Vigente         	:= 'V';                     -- Estatus del Credito Vigente
SET Est_Pagado          	:= 'P';                     -- Estatus del Credito Pagado
SET Ava_Autorizado      	:= 'U';                     -- Estatus del Aval: Autorizado
SET Gar_Autorizado      	:= 'A';                     -- Asignacion de Garantia: Autorizado
SET Cue_Activa          	:= 'A';                     -- Estatus de la Cuenta Activa
SET Rel_Hijo            	:= 3;                       -- Tipo de Relacion: Hijo
SET Est_Soltero     		:= 'S';        				-- Estado Civil Soltero
SET Est_CasBieSep   		:= 'CS';       				-- Casado Bienes Separados
SET Est_CasBieMan   		:= 'CM';      				-- Casado Bienes Mancomunados
SET Est_CasCapitu   		:= 'CC';       				-- Casado Bienes Mancomunados Con Capitulacion
SET Est_Viudo       		:= 'V';        				-- Viudo
SET Est_Divorciad   		:= 'D';        				-- Divorciado
SET Est_Seperados   		:= 'SE';       				-- Separado
SET Est_UnionLibre  		:= 'U';        				-- UNION Libre
SET Dir_Oficial     		:= 'S';        				-- Tipo de Direccion: Oficial
SET Dir_Trabajo     		:= 3;          				-- Tipo de Direccion: Trabajo
SET Des_Soltero     		:= 'SOLTERO(A)';			-- Descripcion SOLTERO
SET Des_CasBieSep   		:= 'CASADO(A) BIENES SEPARADOS';	-- Descripcion CASADO(A) BIENES SEPARADOS
SET Des_CasBieMan   		:= 'CASADO(A) BIENES MANCOMUNADOS'; -- Descripcion CASADO(A) BIENES MANCOMUNADOS
SET Des_CasCapitu   		:= 'CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION'; -- Descripcion CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION
SET Des_Viudo       		:= 'VIUDO(A)';				-- Descripcion VIUDO
SET Des_Divorciad   		:= 'DIVORCIADO(A)';			-- Descripcion DIVORCIADO
SET Des_Seperados   		:= 'SEPARADO(A)';			-- Descripcion SEPARADO
SET Des_UnionLibre  		:= 'UNION LIBRE';			-- Descripcion UNION LIBRE
SET TipoLinaNeg				:= 1;
SET Egreso					:= 'E';						-- Valor Egreso
SET Ingreso					:= 'I';						-- Valor Ingreso
SET Var_NO					:= 'N';						-- Valor NO
SET Var_SI					:= 'S';
SET No_Oficial              := 'N';
SET	PersonaMoral			:= 'M';
SET	PersonaFisica			:=	'F';
SET	Dir_Negocio				:=	2;
SET	Dir_Hogar				:=	1;
SET	TipoConstitutiva		:=	'C';

SET Cue_Cancel          	:= 'C';
SET Cue_Inactiva        	:= 'I';
-- IALDANA T_15576
SET Cue_Bloq        		:= 'B';
-- FIN IALDANA

SET Var_CalcAntiguedad  	:= IFNULL((SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'DetLaboralCteConyug'), Var_NO);

SELECT CASE MONTH(FechaSistema)
					WHEN 1 THEN 'ENERO'
					WHEN 2 THEN 'FEBRERO'
					WHEN 3 THEN 'MARZO'
					WHEN 4 THEN 'ABRIL'
					WHEN 5 THEN 'MAYO'
					WHEN 6 THEN 'JUNIO'
					WHEN 7 THEN 'JULIO'
					WHEN 8 THEN 'AGOSTO'
					WHEN 9 THEN 'SEPTIEMBRE'
					WHEN 10 THEN 'OCTUBRE'
					WHEN 11 THEN 'NOVIEMBRE'
					WHEN 12 THEN 'DICIEMBRE'
					END AS meses,	DAY(FechaSistema),	YEAR(FechaSistema),	FechaSistema
	INTO	Var_MesSis,				Var_DiaSis,			Var_AnioSis,		Fecha_Sis
		FROM PARAMETROSSIS;

DROP TABLE IF EXISTS TMPBENEFISOFI;
CREATE TEMPORARY TABLE TMPBENEFISOFI(
	`TransactionID`		BIGINT,
	`ClienteID`			BIGINT,
	`NombreCompleto`	VARCHAR(400),
    `Parentesco`		VARCHAR(400),
    `Porcentaje`		VARCHAR(100),
    `Domicilio`			VARCHAR(200),
	`Telefono`			VARCHAR(100)
);

DROP TABLE IF EXISTS TMPBENEFICIARIO;
CREATE TEMPORARY TABLE TMPBENEFICIARIO(
    `Tmp_Descripcion`   VARCHAR(400),
    `Tmp_Cuerpo`        VARCHAR(100),
    `Tmp_Estilo`        VARCHAR(100)
);

IF(Par_TipoReporte = Seccion_General) THEN
	SELECT  MAX(ClienteArchivosID) INTO Var_CliArchID
		FROM 	CLIENTEARCHIVOS
        WHERE ClienteID     = Par_ClienteID
          AND TipoDocumento = Foto;

	SELECT	 C.Recurso INTO Var_Recur
		FROM 	CLIENTEARCHIVOS C,
				TIPOSDOCUMENTOS TI
		WHERE C.ClienteID     = Par_ClienteID
		AND   C.TipoDocumento = Foto
		AND   C.ClienteArchivosID = Var_CliArchID
		AND   C.TipoDocumento = TI.TipoDocumentoID;

	IF(Par_ClienteID != Entero_Cero) THEN
        SET Var_Numcliente  := Par_ClienteID;
        SELECT  Cli.NombreCompleto, Cli.FechaNacimiento,    Pan.Nombre,         Esr.Nombre,         Cli.Sexo,
				Ocu.Descripcion,    Cli.Nacion,         	Cli.EstadoCivil,	Cli.CURP,           Cli.RFC,
                Cli.TelTrabajo, 	Cli.TelefonoCelular, 	Cli.Telefono,       Cli.LugardeTrabajo,	Cli.Puesto,
				CASE WHEN Var_CalcAntiguedad = Var_SI
					THEN	CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
								THEN Entero_Cero
								ELSE ROUND(DATEDIFF(Fecha_Sis,Cli.FechaIniTrabajo) / 365, 1)
							END
					ELSE Cli.AntiguedadTra
				END,
                Cli.SucursalOrigen,		Cli.Observaciones
		INTO	Var_NombreCli,		Var_FecNacCli,      	Var_PaisNac,		Var_EstadoNac,		Var_CliSexo,
				Var_Ocupacion, 		Var_ClaveNacion,		Var_ClaveEstCiv,    Var_CliCURP,		Var_CliRFC,
				Var_CliTelTra, 		Var_CliTelCel,			Var_CliTelPart,     Var_CliLugTra,		Var_CliPuesto,
				Var_CliAntTra, 		Var_SucursalID,			Var_Observaciones
            FROM	CLIENTES Cli
				INNER JOIN PAISES Pan ON Cli.LugarNacimiento = Pan.PaisID
				LEFT OUTER JOIN ESTADOSREPUB Esr ON Cli.EstadoID = Esr.EstadoID
				LEFT OUTER JOIN OCUPACIONES Ocu ON Cli.OcupacionID = Ocu.OcupacionID
            WHERE ClienteID = Par_ClienteID;

		SET Var_ClaveEstCiv := IFNULL(Var_ClaveEstCiv, Cadena_Vacia);

        SELECT	CASE WHEN Ccte.PEPs = Var_SI THEN 'SI' ELSE CASE WHEN Ccte.PEPs = Var_NO THEN 'NO' END END,
				F.Descripcion,
				CASE WHEN Ccte.ParentescoPEP = Var_SI THEN 'SI' ELSE CASE WHEN Ccte.ParentescoPEP = Var_NO THEN 'NO' END END,
				NombFamiliar,	APaternoFam,			AMaternoFam
        INTO	Var_PEPS,		Var_DescripcionPEP,		Var_ParPEP,		Var_ParPEPNom,		Var_ParPEPAP,
				Var_ParPEPAM
			FROM CONOCIMIENTOCTE Ccte,
				 FUNCIONESPUB F
			WHERE	Ccte.ClienteID=Par_ClienteID
				AND Ccte.FuncionID=F.FuncionID;

        SELECT	P.NombrePromotor INTO Var_NombrePromotor
			FROM 	CLIENTES 	C,
					PROMOTORES 	P,
					SUCURSALES  S
			WHERE	C.ClienteID=Par_ClienteID
				AND C.PromotorActual=P.PromotorID
				AND C.SucursalOrigen=S.SucursalID;

        SELECT	Dir.Calle,				Dir.NumInterior,	Dir.Piso,		Dir.Lote,				Dir.Manzana,
				Col.Asentamiento,		Dir.NumeroCasa, 	Mun.Nombre,		Dir.PrimeraEntreCalle,	Dir.SegundaEntreCalle,
                Dir.DireccionCompleta,	Dir.Descripcion,	Est.Nombre,		Dir.CP, 				Dir.Oficial
		INTO	Var_CliCalle,			Var_CliNumInt,		Var_CliPiso,	Var_CliLote, 			Var_CliManzana,
				Var_CliColoni, 			Var_CliNumCasa,		Var_CliMunici,	Var_1aEntreCalle,		Var_2aEntreCalle,
                Var_DirecCompleta,		Var_DescDir,		Var_NomEstado,	Var_CodigoP,			Var_DirOfi
            FROM DIRECCLIENTE Dir,
                 COLONIASREPUB Col,
                 MUNICIPIOSREPUB Mun
				INNER JOIN ESTADOSREPUB Est
			WHERE 	ClienteID			= Par_ClienteID
				AND Oficial 		= Dir_Oficial
				AND Dir.EstadoID 	= Col.EstadoID
				AND Dir.MunicipioID = Col.MunicipioID
				AND Dir.ColoniaID 	= Col.ColoniaID
				AND Mun.EstadoID  	= Col.EstadoID
				AND Est.EstadoID	= Dir.EstadoID
				AND Mun.MunicipioID	= Col.MunicipioID
            LIMIT 1;

		SELECT DireccionCompleta INTO Var_DirTrabajo
			FROM DIRECCLIENTE Dir
            WHERE	ClienteID		= Par_ClienteID
				AND	TipoDireccionID = Dir_Trabajo
            LIMIT 1;

	END IF;

    SET Var_DirOfi      := IFNULL(Var_DirOfi,	No_Oficial);
    SET Var_NomEstado	:= IFNULL(Var_NomEstado,Cadena_Vacia);
    SET Var_CliSexo 	:= IFNULL(Var_CliSexo, 	Cadena_Vacia);

    IF(Var_CliSexo = Gen_Masculino) THEN
        SET Var_CliGenero   := Des_Masculino;
    ELSE
        SET Var_CliGenero   := Des_Femenino;
    END IF;

    IF (Var_ClaveNacion = Nac_Mexicano) THEN
        SET Var_CliNacion   := Des_Mexicano;
    ELSE
        SET Var_CliNacion   := Des_Extranjero;
    END IF;

    SET Var_DescriEstCiv    := (SELECT CASE Var_ClaveEstCiv
                                    WHEN Est_Soltero	THEN Des_Soltero
                                    WHEN Est_CasBieSep  THEN Des_CasBieSep
                                    WHEN Est_CasBieMan  THEN Des_CasBieMan
                                    WHEN Est_CasCapitu  THEN Des_CasCapitu
                                    WHEN Est_Viudo		THEN Des_Viudo
                                    WHEN Est_Divorciad  THEN Des_Divorciad
                                    WHEN Est_Seperados  THEN Des_Seperados
                                    WHEN Est_UnionLibre	THEN Des_UnionLibre
                                    ELSE Cadena_Vacia
                                END );

    SELECT Esc.Descripcion INTO Var_EscoCli
		FROM SOCIODEMOGRAL Soc,
             CATGRADOESCOLAR Esc
        WHERE Soc.ClienteID			= Par_ClienteID
          AND Soc.GradoEscolarID	= Esc.GradoEscolarID;

    SET Var_EscoCli 		:= IFNULL(Var_EscoCli, Cadena_Vacia);
    SET Var_CliCalle    	:= IFNULL(Var_CliCalle, Cadena_Vacia);
    SET Var_CliNumInt   	:= IFNULL(Var_CliNumInt, Cadena_Vacia);
    SET Var_CliPiso     	:= IFNULL(Var_CliPiso, Cadena_Vacia);
    SET Var_CliLote     	:= IFNULL(Var_CliLote, Cadena_Vacia);
    SET Var_CliManzana  	:= IFNULL(Var_CliManzana, Cadena_Vacia);
    SET Var_CliColoni   	:= IFNULL(Var_CliColoni, Cadena_Vacia);
    SET Var_CliNumCasa  	:= IFNULL(Var_CliNumCasa, Cadena_Vacia);
    SET Var_CliMunici   	:= IFNULL(Var_CliMunici, Cadena_Vacia);
    SET Var_1aEntreCalle   	:= IFNULL(Var_1aEntreCalle, Cadena_Vacia);
    SET Var_2aEntreCalle   	:= IFNULL(Var_2aEntreCalle, Cadena_Vacia);
    SET Var_CliTelTra  		:= IFNULL(Var_CliTelTra, Cadena_Vacia);
    SET Var_CliTelCel   	:= IFNULL(Var_CliTelCel, Cadena_Vacia);
    SET Var_CliTelPart  	:= IFNULL(Var_CliTelPart, Cadena_Vacia);
    SET Var_CliLugTra   	:= IFNULL(Var_CliLugTra, Cadena_Vacia);
    SET Var_CliPuesto   	:= IFNULL(Var_CliPuesto, Cadena_Vacia);
    SET Var_CliAntTra   	:= IFNULL(Var_CliAntTra, Entero_Cero);
    SET Var_CliCalNum   	:= Var_CliCalle;

    IF(Var_CliNumCasa != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' No. ', Var_CliNumCasa);
    END IF;

    IF(Var_CliNumInt != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' INTERIOR ', Var_CliNumInt);
    END IF;

    IF(Var_CliLote != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' LOTE ', Var_CliLote);
    END IF;

    IF(Var_CliManzana != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' MANZANA ', Var_CliManzana);
    END IF;

    IF(Var_CliPiso != Cadena_Vacia) THEN
        SET Var_CliCalNum   := CONCAT(Var_CliCalNum, ' PISO ', Var_CliPiso);
    END IF;

    SET Var_CliColMun   := CONCAT(Var_CliColoni, ',', Var_CliMunici);
    SET Var_DirTrabajo      := IFNULL(Var_DirTrabajo, Cadena_Vacia);

	IF(Var_CliAntTra>1) THEN
		SET Var_DesCliAntTra    := CONCAT(FORMAT(Var_CliAntTra, 1), " Años");
	ELSE
		SET Var_DesCliAntTra    := CONCAT(FORMAT(Var_CliAntTra, 1), " Años");
	END IF;

	IF (Var_CliNumCasa = Cadena_Vacia) THEN
		SET Var_CliNumCasa := 'SN';
    END IF;

	SELECT Tip.Descripcion INTO Var_TipoViv
		FROM TIPOVIVIENDA Tip
			INNER JOIN SOCIODEMOVIVIEN Soc ON Soc.TipoViviendaID=Tip.TipoViviendaID
		WHERE Soc.ClienteID=Par_ClienteID LIMIT 1;

    SELECT  Coy.PrimerNombre,       Coy.SegundoNombre,      Coy.TercerNombre,       Coy.ApellidoPaterno,	Coy.ApellidoMaterno,
			Coy.FechaNacimiento,    Pan.Nombre,             Esr.Nombre,				Coy.EmpresaLabora,      Est.Nombre,
            Mun.Nombre,             Coy.Colonia,			Coy.Calle,              Coy.NumeroExterior,     Coy.NumeroInterior,
            Coy.NumeroPiso,         Coy.CodigoPostal,
			CASE WHEN Var_CalcAntiguedad = Var_SI
				THEN CASE WHEN IFNULL(Coy.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia
					THEN Entero_Cero
					ELSE ROUND(DATEDIFF(Fecha_Sis,Coy.FechaIniTrabajo) / 365) END
				ELSE Coy.AntiguedadAnios
			END,
			CASE WHEN Var_CalcAntiguedad = Var_SI
				THEN Entero_Cero
				ELSE Coy.AntiguedadMeses
			END,
			TelefonoTrabajo,		TelCelular,				Ocu.Descripcion,
            CASE WHEN Coy.Nacionalidad = Nac_Mexicano
				THEN Des_Mexicano
                ELSE Des_Extranjero
            END
	INTO 	Var_ConyPriNom,         Var_ConySegNom,         Var_ConyTerNom,         Var_ConyApePat,			Var_ConyApeMat,
			Var_ConyFecNac,         Var_ConyPaiNac,         Var_ConyEstNac,         Var_ConyNomEmp,         Var_ConyEstEmp,
            Var_ConyMunEmp,         Var_ConyColEmp,         Var_ConyCalEmp,         Var_ConyNumExt,         Var_ConyNumInt,
            Var_ConyNumPiso,        Var_ConyCodPos,         Var_ConyAntAnio,        Var_ConyAntMes,         Var_ConyTelTra,
            Var_ConyTelCel,         Var_ConyOcupa,          Var_ConyNacion
    FROM SOCIODEMOCONYUG Coy
		LEFT OUTER JOIN PAISES Pan 			ON Coy.PaisNacimiento 		= Pan.PaisID
		LEFT OUTER JOIN ESTADOSREPUB Esr 	ON Coy.EstadoNacimiento 	= Esr.EstadoID
		LEFT OUTER JOIN ESTADOSREPUB Est 	ON Coy.EntidadFedTrabajo 	= Est.EstadoID
		LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Coy.EntidadFedTrabajo 	= Mun.EstadoID AND Coy.MunicipioTrabajo  = Mun.MunicipioID
		LEFT OUTER JOIN OCUPACIONES Ocu 	ON Coy.OcupacionID 			= Ocu.OcupacionID
    WHERE Coy.ClienteID = Par_ClienteID;

    SET Var_ClienteEdad := YEAR(Fecha_Sis)-YEAR(Var_FecNacCli)	+ IF(DATE_FORMAT(Fecha_Sis ,'%m-%d') >= DATE_FORMAT(Var_FecNacCli	,'%m-%d'), 0, -1);
    SET Var_ConyugeEdad := YEAR(Fecha_Sis)-YEAR(Var_ConyFecNac)	+ IF(DATE_FORMAT(Fecha_Sis ,'%m-%d') >= DATE_FORMAT(Var_ConyFecNac	,'%m-%d'), 0, -1);

    SELECT Suc.NombreSucurs,Est.Nombre ,Mun.Nombre INTO Var_NombreSucurs,Var_EstadoSuc, Var_MunciSuc
        FROM SUCURSALES Suc,
			ESTADOSREPUB Est,
			MUNICIPIOSREPUB Mun
        WHERE SucursalID = Var_SucursalID AND
				Suc.EstadoID=Est.EstadoID AND
				Est.EstadoID =Mun.EstadoID  AND
				Suc.MunicipioID=Mun.MunicipioID;

    SET Var_NombreSucurs	:= IFNULL(Var_NombreSucurs, Cadena_Vacia);
    SET Var_ConyPriNom      := IFNULL(Var_ConyPriNom, Cadena_Vacia);
    SET Var_ConySegNom      := IFNULL(Var_ConySegNom, Cadena_Vacia);
    SET Var_ConyTerNom      := IFNULL(Var_ConyTerNom, Cadena_Vacia);
    SET Var_ConyApePat      := IFNULL(Var_ConyApePat, Cadena_Vacia);
    SET Var_ConyApeMat      := IFNULL(Var_ConyApeMat, Cadena_Vacia);
    SET Var_ConyFecNac      := IFNULL(Var_ConyFecNac, Fecha_Vacia);
    SET Var_ConyPaiNac      := IFNULL(Var_ConyPaiNac, Cadena_Vacia);
    SET Var_ConyEstNac      := IFNULL(Var_ConyEstNac, Cadena_Vacia);
    SET Var_ConyNomEmp      := IFNULL(Var_ConyNomEmp, Cadena_Vacia);
    SET Var_ConyEstEmp      := IFNULL(Var_ConyEstEmp, Cadena_Vacia);
    SET Var_ConyMunEmp      := IFNULL(Var_ConyMunEmp, Cadena_Vacia);
    SET Var_ConyColEmp      := IFNULL(Var_ConyColEmp, Cadena_Vacia);
    SET Var_ConyCalEmp      := IFNULL(Var_ConyCalEmp, Cadena_Vacia);
    SET Var_ConyNumExt      := IFNULL(Var_ConyNumExt, Cadena_Vacia);
    SET Var_ConyNumInt      := IFNULL(Var_ConyNumInt, Cadena_Vacia);
    SET Var_ConyNumPiso     := IFNULL(Var_ConyNumPiso, Cadena_Vacia);
    SET Var_ConyCodPos      := IFNULL(Var_ConyCodPos, Cadena_Vacia);
    SET Var_ConyAntAnio     := IFNULL(Var_ConyAntAnio, Cadena_Vacia);
    SET Var_ConyAntMes      := IFNULL(Var_ConyAntMes, Cadena_Vacia);
    SET Var_ConyTelTra      := IFNULL(Var_ConyTelTra, Cadena_Vacia);
    SET Var_ConyTelCel      := IFNULL(Var_ConyTelCel, Cadena_Vacia);
    SET Var_ConyOcupa       := IFNULL(Var_ConyOcupa, Cadena_Vacia);
    SET Var_ConyNacion      := IFNULL(Var_ConyNacion, Cadena_Vacia);
    SET Var_ConyugeEdad     := IFNULL(Var_ConyugeEdad, Entero_Cero);
    SET Var_PaisNac         := IFNULL(Var_PaisNac, Cadena_Vacia);
    SET Var_EstadoNac       := IFNULL(Var_EstadoNac, Cadena_Vacia);
    SET Var_CliCURP         := IFNULL(Var_CliCURP, Cadena_Vacia);
    SET Var_Ocupacion       := IFNULL(Var_Ocupacion, Cadena_Vacia);
    SET Var_ConyNomCom  	:= Var_ConyPriNom;

    IF(Var_ConySegNom != Cadena_Vacia) THEN
        SET Var_ConyNomCom  := CONCAT(Var_ConyNomCom, " ", Var_ConySegNom);
    END IF;

    IF(Var_ConyTerNom != Cadena_Vacia) THEN
        SET Var_ConyNomCom  := CONCAT(Var_ConyNomCom, " ", Var_ConyTerNom);
    END IF;

    SET Var_ConyNomCom  := CONCAT(Var_ConyNomCom, " ", Var_ConyApePat, " ", Var_ConyApeMat);

    SET Var_DirEmpCony  := Var_ConyCalEmp;

    IF(Var_ConyNumExt != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " No ", CONVERT(Var_ConyNumExt, CHAR));
    END IF;

    IF(Var_ConyNumInt != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " Interior ", CONVERT(Var_ConyNumInt, CHAR));
    END IF;

    IF(Var_ConyNumPiso != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " Piso ", CONVERT(Var_ConyNumPiso, CHAR));
    END IF;

    IF(Var_ConyNumInt != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, " Col. ", Var_ConyColEmp);
    END IF;

    IF(Var_ConyEstEmp != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, ", ", Var_ConyEstEmp);
    END IF;

    IF(Var_ConyMunEmp != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, ", ", Var_ConyMunEmp);
    END IF;

    IF(Var_ConyMunEmp != Cadena_Vacia) THEN
        SET Var_DirEmpCony  := CONCAT(Var_DirEmpCony, ", CP ", Var_ConyCodPos);
    END IF;

    SET Var_ConyAntTra  := Cadena_Vacia;

    IF(Var_ConyAntAnio != Cadena_Vacia) THEN
        SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntAnio, CHAR), " Año(s) ");

    IF(Var_ConyAntMes != Cadena_Vacia) THEN
            SET Var_ConyAntTra  := CONCAT(Var_ConyAntTra, " y ", CONVERT(Var_ConyAntMes, CHAR), " Mese(s)");
        END IF;
    ELSE
        IF(Var_ConyAntMes != Entero_Cero) THEN
            SET Var_ConyAntTra  := CONCAT(CONVERT(Var_ConyAntMes, CHAR), " Mese(s)");
        END IF;
    END IF;


	SET Var_FechaSis := CONCAT(Var_DiaSis," ","DE"," ",Var_MesSis," ","DE"," ", Var_AnioSis);
	SELECT COUNT(ClienteID) INTO Var_DepEcon FROM SOCIODEMODEPEND  WHERE ClienteID=Par_ClienteID;

    SELECT 	IFNULL(SUM(Cli.Monto),0) INTO TotalEgre
		FROM	CLIDATSOCIOE Cli
			INNER JOIN CATDATSOCIOE Cat ON Cli.CatSocioEID = Cat.CatSocioEID
		WHERE	Cli.ClienteID	= Par_ClienteID
			AND Cli.LinNegID	= TipoLinaNeg
			AND Cat.Tipo=Egreso;

    SELECT	IFNULL(SUM(Cli.Monto),0) INTO TotalIngre
		FROM	CLIDATSOCIOE Cli
			INNER JOIN CATDATSOCIOE Cat ON Cli.CatSocioEID = Cat.CatSocioEID
		WHERE 	Cli.ClienteID	= Par_ClienteID
			AND Cli.LinNegID	= TipoLinaNeg
			AND Cat.Tipo=Ingreso;

	SELECT IFNULL(CompromisoAhorro,Entero_Cero)	INTO Var_CompromisoAho	FROM PARAMETROSCAJA;

    SELECT DireccionCompleta INTO Var_DirTrab
		FROM	DIRECCLIENTE
		WHERE	ClienteID		= Par_ClienteID
			AND	TipoDireccionID	= Dir_Trabajo LIMIT 1;

	SELECT		Suc.PoderNotarialGte,	Mun.Nombre,		Suc.TituloGte,	Us.NombreCompleto,
				(SELECT UPPER(Ins.Nombre) FROM PARAMETROSSIS Par INNER JOIN INSTITUCIONES Ins ON Ins.InstitucionID=Par.InstitucionID)
		INTO	Var_PoderNotarialGte,	Var_NombreMun,	Var_TituloGte,	Var_NombreGerente,	Var_NombreInstitucion
			FROM SUCURSALES Suc
				INNER JOIN MUNICIPIOSREPUB Mun ON Mun.MunicipioID=Suc.MunicipioID AND Mun.EstadoID=Suc.EstadoID
				INNER JOIN USUARIOS Us ON Us.UsuarioID=Suc.NombreGerente
			WHERE Suc.SucursalID	= Aud_Sucursal;

    SELECT  Var_NombreSucurs,   Var_Numcliente,     Var_NombreCli,      Var_FecNacCli,      Var_PaisNac,
            Var_EstadoNac,      Var_CliGenero,      Var_Ocupacion,      Var_CliNacion,      Var_DescriEstCiv,
            Var_CliCURP,        Var_CliRFC,         Var_EscoCli,        Var_CliCalNum,      Var_CliColMun,
            Var_1aEntreCalle,   Var_2aEntreCalle,   Var_CliTelTra,      Var_CliTelPart,     Var_CliValorViv,
            Var_DirTrabajo,     Var_CliLugTra,      Var_CliPuesto,      Var_DesCliAntTra,   Var_ConyNomCom,
            Var_ConyFecNac,     Var_ConyPaiNac,     Var_ConyEstNac,     Var_ConyNomEmp,     Var_ConyTelTra,
            Var_ConyTelCel,     Var_DirEmpCony,     Var_ConyAntTra,     Var_ClienteEdad,    Var_ConyugeEdad,
            Var_ConyOcupa,      Var_ConyNacion,     Var_Recur,          Var_CliTelCel,      Var_PEPS,
            Var_DescripcionPEP, Var_ParPEP,         Var_ParPEPNom,      Var_ParPEPAP,       Var_ParPEPAM,
			Var_ClaveEstCiv,	Var_DirecCompleta, 	Var_EstadoSuc, 		Var_MunciSuc,		Var_FechaSis,
			Var_CliCalle,		Var_CliMunici,		Var_DescDir,		Var_NomEstado,		Var_CodigoP,
			Var_DirTrabajo,		Var_DepEcon,		Var_CliNumCasa,		Var_TipoViv,		TotalEgre,
			TotalIngre,			Var_CompromisoAho,	Var_DirTrab,		Var_Observaciones,	Var_PoderNotarialGte,
			Var_NombreMun,		Var_NombreInstitucion,Var_TituloGte,	Var_NombreGerente,	CONCAT(Fecha_Sis) AS Fecha_Sis,
			Var_DirOfi;
END IF;

IF (Par_TipoReporte=Seccion_Benefi)THEN

    OPEN CURSORBENEFICIARIOS;
	BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP
	FETCH CURSORBENEFICIARIOS INTO
		Var_Nombre,	Var_Relacion,	Var_Porcentaje;

        INSERT TMPBENEFICIARIO VALUES(Var_Nombre,	Var_Relacion,	Var_Porcentaje);
	END LOOP;
	END;
	CLOSE CURSORBENEFICIARIOS;

    SELECT  Tmp_Descripcion,    Tmp_Cuerpo,   Tmp_Estilo
		FROM TMPBENEFICIARIO;

	DROP TABLE IF EXISTS TMPBENEFICIARIO;
END IF;

IF (Par_TipoReporte=Seccion_BenefiYANGA)THEN
	OPEN CURSORBENEFICIARIOSYANGA;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
		FETCH CURSORBENEFICIARIOSYANGA INTO
			Var_Nombre,	Var_Relacion,	Var_Porcentaje;

			INSERT TMPBENEFICIARIO VALUES(Var_Nombre,Var_Relacion,Var_Porcentaje);
		END LOOP;
	END;
	CLOSE CURSORBENEFICIARIOSYANGA;

	SELECT  Tmp_Descripcion,    Tmp_Cuerpo,   Tmp_Estilo
		FROM TMPBENEFICIARIO;

	DROP TABLE IF EXISTS TMPBENEFICIARIO;
END IF;

IF(Par_TipoReporte=Seccion_Refere)THEN
	SELECT  NombreRef,		TelefonoRef,	DomicilioRef,	NombreRef2,		TelefonoRef2,
			DomicilioRef2,	NombRefCom,		TelRefCom,	 	NombRefCom2,	TelRefCom2,
			BancoRef,		NoCuentaRef,	BancoRef2,	 	NoCuentaRef2
		FROM CONOCIMIENTOCTE
			WHERE ClienteID=Par_ClienteID;
END IF;

IF(Par_TipoReporte = Seccion_TercerFirmante) THEN
	SELECT Rel.CuentaAhoID, Cue.TipoCuentaID, Rel.NombreCompleto
		FROM CUENTASPERSONA Rel
			INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Rel.CuentaAhoID AND Cue.Estatus = Cue_Activa
		WHERE 	Cue.ClienteID		= Par_ClienteID
			AND Rel.EsFirmante		= Var_SI
			AND Rel.EstatusRelacion	= Est_Vigente
			AND Rel.ClienteID		<> Par_ClienteID
		ORDER BY Rel.CuentaAhoID, Rel.PersonaID;
END IF;

IF(Par_TipoReporte = Seccion_GralSOFI) THEN
	SET	Var_TutorID	:=	Entero_Cero;
	SELECT	Cli.SucursalOrigen	INTO Var_SucursalID
		FROM	CLIENTES	Cli
		WHERE	Cli.ClienteID	=	Par_ClienteID;

	SELECT	TipoPersona,		EsMenorEdad
		INTO	Var_TipoPersona,	Var_MenorEdad
		FROM	CLIENTES
		WHERE	ClienteID	=	Par_ClienteID;

	SET Var_Numcliente  := IFNULL(Par_ClienteID,Entero_Cero);

	IF(	Var_MenorEdad	=	Var_SI	)	THEN
		SELECT	ClienteTutorID,	NombreTutor
		INTO	Var_TutorID,	Var_NombreTutor
			FROM	SOCIOMENOR
			WHERE	SocioMenorID	=	Par_ClienteID;

		SET	Var_TutorID	:=	IFNULL(Var_TutorID, Entero_Cero);

		SELECT	CONCAT(	Cli.PrimerNombre,
						CASE	WHEN	IFNULL(Cli.SegundoNombre,	Cadena_Vacia)	<>	Cadena_Vacia	THEN	CONCAT(' ', Cli.SegundoNombre)
								ELSE	Cadena_Vacia
						END,
						CASE	WHEN	IFNULL(Cli.TercerNombre,	Cadena_Vacia)	<>	Cadena_Vacia	THEN	CONCAT(' ', Cli.TercerNombre)
								ELSE	Cadena_Vacia
						END
				),				Cli.ApellidoPaterno,	Cli.ApellidoMaterno,	Cli.FechaNacimiento,
				Cli.Nacion,		Cli.CURP,				YEAR(Fecha_Sis )-YEAR(Cli.FechaNacimiento) + IF(DATE_FORMAT(Fecha_Sis ,'%m-%d') >= DATE_FORMAT(Cli.FechaNacimiento,'%m-%d'), 0, -1),	Cli.SucursalOrigen
		INTO	Var_MANombres,	Var_MAApePat,			Var_MAApeMat,			Var_MAFecNac,
				Var_MANacion,	Var_MACURP,				Var_MAEdad,				Var_SucursalID
		FROM CLIENTES Cli
		LEFT OUTER JOIN	PAISES			Pan ON Cli.LugarNacimiento	=	Pan.PaisID
		LEFT OUTER JOIN	ESTADOSREPUB	Esr ON Cli.EstadoID			=	Esr.EstadoID
		LEFT OUTER JOIN	OCUPACIONES		Ocu ON Cli.OcupacionID		=	Ocu.OcupacionID
		WHERE ClienteID = Par_ClienteID;

		IF(	Var_TutorID	<>	Entero_Cero	)	THEN
			SET	Var_Numcliente	:=	Var_TutorID;
		ELSE
			SET	Var_NumCliente	:=	Entero_Cero;
		END IF;
	ELSE
		IF(	Var_TipoPersona	=	PersonaMoral	)	THEN
			SELECT	Cli.RazonSocial,	Dir.Calle,		Dir.NumeroCasa,		Dir.CP,			Dir.Colonia,
					CONCAT(IFNULL(Dir.PrimeraEntreCalle, Cadena_Vacia),
						CASE	WHEN	IFNULL(Dir.SegundaEntreCalle, Cadena_Vacia)	<>	Cadena_Vacia	THEN	CONCAT(' y ', Dir.SegundaEntreCalle)
								ELSE	Cadena_Vacia
						END
					),					Loc.NombreLocalidad,	Edo.Nombre,		Mun.Nombre,
					Cli.RFCpm,
					CONCAT(IFNULL(D.PrimerNombre, Cadena_Vacia),
							CASE	WHEN	IFNULL(D.SegundoNombre, Cadena_Vacia)	<>	Cadena_Vacia	THEN	CONCAT(' ', D.SegundoNombre) -- se cambio el alias de la tabla AEUAN_T_15183
									ELSE	Cadena_Vacia
							END,
							CASE	WHEN	IFNULL(D.TercerNombre, Cadena_Vacia)	<>	Cadena_Vacia	THEN	CONCAT(' ', D.TercerNombre)
									ELSE	Cadena_Vacia
							END,
							CASE	WHEN	IFNULL(D.ApellidoPaterno, Cadena_Vacia)	<>	Cadena_Vacia	THEN	CONCAT(' ', D.ApellidoPaterno)
									ELSE	Cadena_Vacia
							END,
							CASE	WHEN	IFNULL(D.ApellidoMaterno, Cadena_Vacia)	<>	Cadena_Vacia	THEN	CONCAT(' ', D.ApellidoMaterno)
									ELSE	Cadena_Vacia
							END
					),	Cli.Telefono,	Cli.Nacion
			INTO	Var_NomEmpresa,		Var_EmpCalle,		Var_EmpNum,		Var_EmpCP,		Var_EmpCol,
					Var_EmpCalleRef,	Var_EmpLocalidad,	Var_EmpEstado,	Var_EmpMun,
					Var_RFCm,			Var_NomRepLeg,		Var_EmpTelPart,	Var_EmpNacion
			FROM	CLIENTES	Cli
			LEFT OUTER JOIN DIRECTIVOS D on Cli.ClienteID = D.ClienteID -- se agreo el left outer AEUAN_T_15183
			LEFT OUTER JOIN	DIRECCLIENTE	Dir	ON	Dir.ClienteID		=	Cli.ClienteID
												AND	Dir.Oficial			=	Dir_Oficial
			LEFT OUTER JOIN	LOCALIDADREPUB	Loc	ON	Loc.LocalidadID		=	Dir.LocalidadID
												AND	Loc.EstadoID		=	Dir.EstadoID
												AND	Loc.MunicipioID		=	Dir.MunicipioID
			LEFT OUTER JOIN	ESTADOSREPUB	Edo	ON	Edo.EstadoID		=	Dir.EstadoID
			LEFT OUTER JOIN	MUNICIPIOSREPUB	Mun	ON	Mun.EstadoID		=	Dir.EstadoID
												AND	Mun.MunicipioID		=	Dir.MunicipioID
			WHERE	Cli.ClienteID	=	Par_ClienteID LIMIT 1;

			SELECT	FechaEsc INTO	Var_EmpFecCons
				FROM	ESCRITURAPUB	Esc
				WHERE	Esc.ClienteID	=	Par_ClienteID
				AND		Esc.Esc_Tipo	=	TipoConstitutiva
				LIMIT 1;
			
			SELECT RelacionadoID, GaranteRelacion, AvalRelacion
			INTO Var_RelacionadoID, Var_EsGaranteID, Var_EsAvalID
			 FROM DIRECTIVOS
			 WHERE ClienteID = Var_Numcliente AND EsApoderado = 'S' LIMIT 1; -- TICKET 14628 SE AGREGA LA VARIABLE NUMCLIENTE LAYALAD ECHAN

			IF (IFNULL(Var_RelacionadoID, Entero_Cero)!= Entero_Cero ) THEN
				SET Var_Numcliente  := IFNULL(Var_RelacionadoID,Entero_Cero);
			ELSE 
				IF (IFNULL(Var_EsGaranteID, Entero_Cero)!= Entero_Cero ) THEN
					SET Var_Numcliente  := IFNULL(Var_EsGaranteID,Entero_Cero);
				ELSE 
					IF (IFNULL(Var_EsAvalID, Entero_Cero)!= Entero_Cero ) THEN
						SET Var_Numcliente  := IFNULL(Var_EsAvalID,Entero_Cero);
					END IF;
				END IF;
			END IF;

			SELECT	Giro	INTO	Var_GiroMerc	FROM	CONOCIMIENTOCTE	Ccte	WHERE	Ccte.ClienteID	=	Par_ClienteID;
		END IF;
	END IF;

	IF(Var_Numcliente	<>	Entero_Cero)	THEN
		SELECT  CONCAT(	Cli.PrimerNombre,
						CASE	WHEN	IFNULL(Cli.SegundoNombre,Cadena_Vacia) <> Cadena_Vacia THEN	CONCAT(' ',Cli.SegundoNombre)
								ELSE	Cadena_Vacia
						END,
						CASE	WHEN	IFNULL(Cli.TercerNombre,Cadena_Vacia) <> Cadena_Vacia THEN	CONCAT(' ',Cli.TercerNombre)
								ELSE	Cadena_Vacia
						END	),
				Cli.ApellidoPaterno,	Cli.ApellidoMaterno,		Cli.FechaNacimiento,	Cli.Nacion,				Cli.Telefono,
				Cli.CURP,				Cli.Correo,					Cli.RFC,				Ocu.Descripcion,		Cli.LugardeTrabajo,
                Cli.TelTrabajo,
				CASE WHEN Var_CalcAntiguedad = Var_SI THEN
						CASE WHEN IFNULL(Cli.FechaIniTrabajo,Fecha_Vacia) = Fecha_Vacia	THEN Entero_Cero
							 ELSE YEAR(Fecha_Sis)-YEAR(Cli.FechaIniTrabajo) + IF(DATE_FORMAT(Fecha_Sis ,'%m-%d') >= DATE_FORMAT(Cli.FechaIniTrabajo,'%m-%d'), 0, -1)
						END
					 ELSE Cli.AntiguedadTra END,
				Cli.EstadoCivil,		Cli.TelefonoCelular,		Cli.Puesto,				Cli.SucursalOrigen,		Cli.Observaciones
		INTO	Var_CliNombres,			Var_CliApePat,				Var_CliApeMat,			Var_FecNacCli,			Var_ClaveNacion,
				Var_CliTelPart,			Var_CliCURP,				Var_CliCorreo,			Var_CliRFC,				Var_Ocupacion,
                Var_CliLugTra,			Var_CliTelTra,				Var_CliAntTra,			Var_ClaveEstCiv,		Var_CliTelCel,
                Var_CliPuesto,			Var_SucursalID,				Var_Observaciones
		FROM CLIENTES Cli
			LEFT OUTER JOIN	OCUPACIONES		Ocu ON	Ocu.OcupacionID	=	Cli.OcupacionID
			WHERE ClienteID = Var_Numcliente;


		SELECT	Dir.Calle,				Dir.NumInterior,			Dir.Piso,				Dir.Lote,				Dir.Manzana,
				Dir.Colonia,			Dir.NumeroCasa,				Mun.Nombre,
                CONCAT(	IFNULL(Dir.PrimeraEntreCalle, Cadena_Vacia),
						CASE	WHEN	IFNULL(Dir.SegundaEntreCalle, Cadena_Vacia) <> Cadena_Vacia
							THEN	CONCAT(' y ',Dir.SegundaEntreCalle)
							ELSE	Cadena_Vacia	END),
				Dir.DireccionCompleta,	Dir.Descripcion,			Est.Nombre,				Dir.CP,					Loc.NombreLocalidad
		INTO	Var_CliCalle,			Var_CliNumInt,				Var_CliPiso,			Var_CliLote,			Var_CliManzana,
				Var_CliColoni,			Var_CliNumCasa,				Var_CliMunici,			Var_CliCalleRef,		Var_DirecCompleta,
                Var_DescDir,			Var_NomEstado,				Var_CodigoP, 			Var_CliLocalidad
			FROM	DIRECCLIENTE	Dir
				LEFT OUTER JOIN	MUNICIPIOSREPUB	Mun	ON	Mun.EstadoID	=	Dir.EstadoID
												AND	Mun.MunicipioID	=	Dir.MunicipioID
				LEFT OUTER JOIN	ESTADOSREPUB	Est	ON	Est.EstadoID	=	Dir.EstadoID
				LEFT OUTER JOIN	LOCALIDADREPUB	Loc	ON	Loc.LocalidadID	=	Dir.LocalidadID
												AND Loc.MunicipioID	=	Dir.MunicipioID
												AND Loc.EstadoID	=	Dir.EstadoID
			WHERE	Dir.ClienteID		= 	Var_Numcliente
				AND	Dir.TipoDireccionID	=	Dir_Hogar
				AND	Dir.Oficial			= 	Dir_Oficial
			LIMIT 1;

		SELECT	Dir.DireccionCompleta,	Dir.Calle,	Dir.NumeroCasa,	Dir.Colonia
			INTO	Var_DirTrabajo,		Var_TrabCalle,	Var_TrabNum,	Var_TrabCol
			FROM	DIRECCLIENTE Dir
				WHERE	ClienteID			=	Var_Numcliente
				AND		Dir.TipoDireccionID	=	Dir_Trabajo
				LIMIT 1;

		IF (Var_TipoPersona = PersonaMoral) THEN
					SET Var_TrabCalle = IFNULL(Var_EmpCalle, Cadena_Vacia);
					SET Var_TrabNum = IFNULL(Var_EmpNum, Cadena_Vacia);
					SET Var_TrabCol = IFNULL(Var_EmpCol, Cadena_Vacia);

					/* agrega Aeuan T_TICKET 14628*/
					SELECT  CONCAT(	Dir.PrimerNombre,
						CASE	WHEN	IFNULL(Dir.SegundoNombre,Cadena_Vacia) <> Cadena_Vacia THEN	CONCAT(' ',Dir.SegundoNombre)
								ELSE	Cadena_Vacia
						END,
						CASE	WHEN	IFNULL(Dir.TercerNombre,Cadena_Vacia) <> Cadena_Vacia THEN	CONCAT(' ',Dir.TercerNombre)
								ELSE	Cadena_Vacia
						END	),
				        Dir.ApellidoPaterno,	Dir.ApellidoMaterno
				        INTO	Var_CliNombres,			Var_CliApePat,				Var_CliApeMat

				FROM DIRECTIVOS Dir where Dir.ClienteID=Par_ClienteID limit 1;

				-- fin
		END IF;
	
		
		SELECT	Soc.TipoViviendaID, Tip.Descripcion, Soc.TiempoHabitarDom
			INTO	Var_TipoViv,		Var_DescTipoViv,	Var_CliTiempoHab
			FROM TIPOVIVIENDA	Tip, SOCIODEMOVIVIEN Soc
				WHERE	ClienteID			=	Var_Numcliente
					AND Soc.TipoViviendaID	= Tip.TipoViviendaID
				LIMIT 1;

		SELECT	COUNT(ClienteID)
			INTO	Var_DepEcon
			FROM	SOCIODEMODEPEND
			WHERE	ClienteID	=	Var_Numcliente;

		SELECT  CONCAT(IFNULL(Coy.PrimerNombre,Cadena_Vacia),
						CASE	WHEN	IFNULL(Coy.SegundoNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Coy.SegundoNombre)
								ELSE	Cadena_Vacia
						END,
						CASE	WHEN	IFNULL(Coy.TercerNombre, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Coy.TercerNombre)
								ELSE	Cadena_Vacia
						END,
						CASE	WHEN	IFNULL(Coy.ApellidoPaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Coy.ApellidoPaterno)
								ELSE	Cadena_Vacia
						END,
						CASE	WHEN	IFNULL(Coy.ApellidoMaterno, Cadena_Vacia) <> Cadena_Vacia	THEN	CONCAT(' ',Coy.ApellidoMaterno)
								ELSE	Cadena_Vacia
						END
				),
				Ocu.Descripcion
		INTO
				Var_ConyNomCom,	Var_ConyOcupa
		FROM 			SOCIODEMOCONYUG Coy
		LEFT OUTER JOIN OCUPACIONES 	Ocu ON Coy.OcupacionID = Ocu.OcupacionID
		WHERE	Coy.ClienteID	=	Var_Numcliente;

		SELECT	IFNULL(SUM(Cli.Monto), Entero_Cero),	Cat.Descripcion
		INTO	Var_TotIngOrd, 					Var_DescIngOrd
		FROM	CATDATSOCIOE			Cat
		LEFT OUTER JOIN	CLIDATSOCIOE	Cli	ON	Cli.ClienteID	=	Var_Numcliente
											AND	Cli.LinNegID	=	1
											AND	Cli.CatSocioEID	=	Cat.CatSocioEID
		WHERE	Cat.CatSocioEID	=	1;

		SELECT	IFNULL(SUM(Cli.Monto), Entero_Cero),	Cat.Descripcion
		INTO	Var_TotIngFam,					Var_DescIngFam
		FROM	CATDATSOCIOE			Cat
		LEFT OUTER JOIN	CLIDATSOCIOE	Cli	ON	Cli.ClienteID	=	Var_Numcliente
											AND	Cli.LinNegID	=	1
											AND	Cli.CatSocioEID	=	Cat.CatSocioEID
		WHERE	Cat.CatSocioEID	=	4;

		SELECT	IFNULL(SUM(Cli.Monto), Entero_Cero),	GROUP_CONCAT(Cat.Descripcion)
		INTO	Var_TotIngOtros,					Var_DescIngOtros
		FROM	CATDATSOCIOE			Cat
		LEFT OUTER JOIN	CLIDATSOCIOE	Cli	ON	Cli.ClienteID	=	Var_Numcliente
											AND	Cli.LinNegID	=	1
											AND	Cli.CatSocioEID	=	Cat.CatSocioEID
		WHERE	Cat.CatSocioEID	IN	(5,6);

		SELECT 	IFNULL(SUM(Cli.Monto),0)
		INTO	TotalIngre
		FROM		CLIDATSOCIOE	Cli
		INNER JOIN	CATDATSOCIOE	Cat	ON Cli.CatSocioEID = Cat.CatSocioEID
		WHERE		Cli.ClienteID	=	Var_Numcliente
			AND 	Cli.LinNegID	=	1
			AND		Cat.Tipo		=	Ingreso;

		SELECT	IFNULL(SUM(Cli.Monto), Entero_Cero),	Cat.Descripcion
		INTO	Var_TotEgrOrd, 					Var_DescEgrOrd
		FROM	CATDATSOCIOE			Cat
		LEFT OUTER JOIN	CLIDATSOCIOE	Cli	ON	Cli.ClienteID	=	Var_Numcliente
											AND	Cli.LinNegID	=	1
											AND	Cli.CatSocioEID	=	Cat.CatSocioEID
		WHERE	Cat.CatSocioEID	=	9;

		SELECT	IFNULL(SUM(Cli.Monto), Entero_Cero),	Cat.Descripcion
		INTO	Var_TotEgrFam, 					Var_DescEgrFam
		FROM	CATDATSOCIOE			Cat
		LEFT OUTER JOIN	CLIDATSOCIOE	Cli	ON	Cli.ClienteID	=	Var_Numcliente
											AND	Cli.LinNegID	=	1
											AND	Cli.CatSocioEID	=	Cat.CatSocioEID
		WHERE	Cat.CatSocioEID	=	8;

		SELECT	IFNULL(SUM(Cli.Monto), Entero_Cero),	GROUP_CONCAT(Cat.Descripcion)
		INTO	Var_OtrosEgr, 					Var_DescOtrosEgr
		FROM	CATDATSOCIOE			Cat
		LEFT OUTER JOIN	CLIDATSOCIOE	Cli	ON	Cli.ClienteID	=	Var_Numcliente
											AND	Cli.LinNegID	=	1
											AND	Cli.CatSocioEID	=	Cat.CatSocioEID
		WHERE	Cat.CatSocioEID	IN	(2,3,7,10,11);

		SELECT 	IFNULL(SUM(Cli.Monto),0)
		INTO TotalEgre
		FROM	CLIDATSOCIOE Cli,
				CATDATSOCIOE Cat
		WHERE 	Cli.ClienteID	=	Var_Numcliente
			AND	Cli.LinNegID	=	TipoLinaNeg
			AND Cat.Tipo		=	Egreso
			AND Cli.CatSocioEID = 	Cat.CatSocioEID;
/*
TICKET 14628 SE COMENTA PARA QUE NO SEAN VALOR CERO 
		IF (Var_TipoPersona = PersonaMoral) THEN
			SET Var_TotIngOrd = Entero_Cero;
			SET Var_TotIngFam = Entero_Cero;
			SET Var_TotIngOtros = Entero_Cero;
			SET TotalIngre = Entero_Cero;
			SET Var_TotEgrOrd = Entero_Cero;
			SET Var_TotEgrFam = Entero_Cero;
			SET Var_OtrosEgr = Entero_Cero;
			SET TotalEgre = Entero_Cero;
		END IF;  FIN DEL COMENTARIO TICKET 14628 LAYALA ECHAN*/
		
	END IF;

	IF(	Var_MenorEdad	=	Var_SI)	THEN
		SET	Var_Numcliente	:=	Par_ClienteID;
	END IF;

	SELECT	NombreRef,			Tr1.Descripcion,	DomicilioRef,		TelefonoRef,		NombreRef2,
			Tr2.Descripcion,	DomicilioRef2,		TelefonoRef2,		NombRefCom,			BancoRef,
			NoCuentaRef,		TelRefCom,			ExtTelRefCom,		NombRefCom2,		BancoRef2,
			NoCuentaRef2,		TelRefCom2,			ExtTelRefCom2
	INTO	Var_ReFamNom,		Var_ReFamPar,		Var_ReFamDom,		Var_ReFamTel,		Var_RefPerNom,
			Var_RefPerPar,		Var_RefPerDom,		Var_RefPerTel,		Var_NombRefCom,		Var_BancoRef,
            Var_NoCuentaRef,	Var_TelRefCom,		Var_ExTelRfCm,		Var_NombRefCom2,	Var_BancoRef2,
            Var_NoCuentaRef2,	Var_TelRefCom2,		Var_ExTelRfCm2
		FROM CONOCIMIENTOCTE Ccte
			LEFT OUTER JOIN	TIPORELACIONES	Tr1	ON	Tr1.TipoRelacionID	=	TipoRelacion1
			LEFT OUTER JOIN	TIPORELACIONES	Tr2	ON	Tr2.TipoRelacionID	=	TipoRelacion2
		WHERE Ccte.ClienteID	=	Var_Numcliente;

	SELECT		Suc.NombreSucurs,	Est.Nombre,		Mun.Nombre,		Suc.Calle,		Suc.Numero,		Suc.Colonia
		INTO	Var_NombreSucurs,	Var_EstadoSuc,	Var_MunciSuc,	Var_CalleSuc,	Var_NumCasaSuc,	Var_ColSuc
		FROM	SUCURSALES Suc,
				ESTADOSREPUB Est,
				MUNICIPIOSREPUB Mun
		WHERE 	SucursalID		= Var_SucursalID
			AND	Suc.EstadoID	= Est.EstadoID
			AND	Est.EstadoID	= Mun.EstadoID
			AND	Suc.MunicipioID	= Mun.MunicipioID;

	SELECT (SELECT UPPER(Ins.Nombre)
			FROM PARAMETROSSIS Par
			INNER JOIN INSTITUCIONES Ins ON Ins.InstitucionID=Par.InstitucionID)
			INTO Var_NombreInstitucion
	FROM SUCURSALES Suc
	INNER JOIN MUNICIPIOSREPUB Mun ON Mun.MunicipioID=Suc.MunicipioID AND Mun.EstadoID=Suc.EstadoID
	WHERE Suc.SucursalID=Aud_Sucursal;

	SELECT CASE	MotivoApertura
				WHEN	1	THEN	1
				WHEN	6	THEN	2
				ELSE	0
			END, FechaAlta
	INTO	Var_CliServSol, 	Var_FechaAltaCli
	FROM CLIENTES
	WHERE ClienteID = Par_ClienteID;

	SET	Var_FechaSis			:=	Fecha_Sis;
	SET	Var_NombreInstitucion	:=	IFNULL(Var_NombreInstitucion,	Cadena_Vacia);
	SET	Var_CalleSuc			:=	IFNULL(Var_CalleSuc,Cadena_Vacia);
	SET	Var_NumCasaSuc			:=	IFNULL(Var_NumCasaSuc,Cadena_Vacia);
	SET	Var_ColSuc				:=	IFNULL(Var_ColSuc, Cadena_Vacia);
	SET	Var_MunciSuc			:=	IFNULL(Var_MunciSuc, Cadena_Vacia);
	SET	Var_EstadoSuc			:=	IFNULL(Var_EstadoSuc, Cadena_Vacia);

	SET	Var_TipoCte		:=	(SELECT	CASE	Var_MenorEdad
								WHEN	Var_SI
									THEN	3					-- MENOR AHORRADOR
									ELSE	CASE	Var_TipoPersona
												WHEN	PersonaMoral
													THEN	2	-- PERSONA MORAL
													ELSE	1							-- PERSONA FISICA
											END
									END
							);
	SET	Var_NomEmpresa		:=	IFNULL(Var_NomEmpresa, Cadena_Vacia);
	SET	Var_EmpCalle		:=	IFNULL(Var_EmpCalle, Cadena_Vacia);
	SET	Var_EmpNum			:=	IFNULL(Var_EmpNum, Cadena_Vacia);
	SET	Var_EmpCP			:=	IFNULL(Var_EmpCP, Cadena_Vacia);
	SET	Var_EmpCol			:=	IFNULL(Var_EmpCol, Cadena_Vacia);
	SET	Var_EmpCalleRef		:=	IFNULL(Var_EmpCalleRef, Cadena_Vacia);
	SET	Var_EmpLocalidad	:=	IFNULL(Var_EmpLocalidad, Cadena_Vacia);
	SET	Var_EmpEstado		:=	IFNULL(Var_EmpEstado, Cadena_Vacia);
	SET	Var_EmpMun			:=	IFNULL(Var_EmpMun, Cadena_Vacia);
	SET	Var_EmpFecCons		:=	IFNULL(Var_EmpFecCons, Fecha_Vacia);
	SET	Var_GiroMerc		:=	IFNULL(Var_GiroMerc, Cadena_Vacia);
	SET	Var_EmpTelPart		:=	IFNULL(Var_EmpTelPart, Cadena_Vacia);
	IF (Var_EmpNacion = Nac_Mexicano) THEN
        SET Var_EmpNacion   := Des_Mexicano;
    ELSE
		IF( Var_EmpNacion = Nac_Extranjero )THEN
			SET Var_EmpNacion   := Des_Extranjero;
		ELSE
			SET Var_EmpNacion   := Cadena_Vacia;
		END IF;
    END IF;
	SET	Var_RFCm			:=	IFNULL(Var_RFCm, Cadena_Vacia);
	SET	Var_NomRepLeg		:=	IFNULL(Var_NomRepLeg,	Cadena_Vacia);
	SET	Var_TipoPersona		:=	IFNULL(Var_TipoPersona, Cadena_Vacia);
	SET	Var_CliApePat		:=	IFNULL(Var_CliApePat, Cadena_Vacia);
	SET	Var_CliApeMat		:=	IFNULL(Var_CliApeMat, Cadena_Vacia);
	SET	Var_CliNombres		:=	IFNULL(Var_CliNombres, Cadena_Vacia);
	SET	Var_DirecCompleta	:=	IFNULL(Var_DirecCompleta, Cadena_Vacia);
    SET Var_CliCalle    	:=	IFNULL(Var_CliCalle, Cadena_Vacia);
    SET Var_CliNumCasa  	:=	IFNULL(Var_CliNumCasa, Cadena_Vacia);
    SET Var_CliColoni   	:=	IFNULL(Var_CliColoni, Cadena_Vacia);
	SET	Var_CodigoP			:=	IFNULL(Var_CodigoP, Cadena_Vacia);
	SET	Var_CliCalleRef		:=	IFNULL(Var_CliCalleRef, Cadena_Vacia);
	SET	Var_CliLocalidad	:=	IFNULL(Var_CliLocalidad,	Cadena_Vacia);
	SET Var_NomEstado		:=	IFNULL(Var_NomEstado, Cadena_Vacia);
    SET Var_CliMunici   	:=	IFNULL(Var_CliMunici, Cadena_Vacia);
	SET	Var_CliTiempoHab	:=	CASE WHEN IFNULL(Var_CliTiempoHab, Cadena_Vacia) <> Cadena_Vacia THEN CONCAT(FLOOR(Var_CliTiempoHab/12),'.', FLOOR(MOD(Var_CliTiempoHab,12)),' AÑO(S)')
									 ELSE Cadena_Vacia
								END;
	SET	Var_FecNacCli	:=	IFNULL(Var_FecNacCli,	Fecha_Vacia);
	IF (Var_ClaveNacion = Nac_Mexicano) THEN
        SET Var_CliNacion   := Des_Mexicano;
    ELSE
		IF( Var_ClaveNacion = Nac_Extranjero )THEN
			SET Var_CliNacion   := Des_Extranjero;
		ELSE
			SET Var_CliNacion   := Cadena_Vacia;
		END IF;
    END IF;
    SET Var_CliTelPart  	:= IFNULL(Var_CliTelPart, Cadena_Vacia);
    SET Var_CliCURP         := IFNULL(Var_CliCURP, Cadena_Vacia);
	SET	Var_CliCorreo		:= IFNULL(Var_CliCorreo,	Cadena_Vacia);
	SET	Var_CliRFC			:= IFNULL(Var_CliRFC,	Cadena_Vacia);
    SET Var_Ocupacion       := IFNULL(Var_Ocupacion, Cadena_Vacia);
    SET Var_CliLugTra   	:= IFNULL(Var_CliLugTra, Cadena_Vacia);
	SET	Var_TrabCalle		:= IFNULL(Var_TrabCalle,	Cadena_Vacia);
	SET	Var_TrabNum			:= IFNULL(Var_TrabNum,Cadena_Vacia);
	SET	Var_TrabCol			:= IFNULL(Var_TrabCol, Cadena_Vacia);
    SET Var_CliTelTra  		:= IFNULL(Var_CliTelTra, Cadena_Vacia);

	IF(IFNULL(Var_CliAntTra, Entero_Cero) <> Entero_Cero) THEN
		IF(Var_CliAntTra >	1)	THEN
			SET Var_DesCliAntTra    := CONCAT(FORMAT(Var_CliAntTra, 1), " Años");
		ELSE
			SET Var_DesCliAntTra    := CONCAT(FORMAT(Var_CliAntTra, 1), " Años");
		END IF;
	ELSE
		SET Var_DesCliAntTra    := IFNULL(Var_DesCliAntTra,'0 Años');
	END IF;

	SET	Var_DepEcon			:=	IFNULL(Var_DepEcon,	Entero_Cero);
	SET	Var_ClaveEstCiv		:=	IFNULL(Var_ClaveEstCiv, Cadena_Vacia);
	SET Var_DescriEstCiv    := (SELECT CASE Var_ClaveEstCiv
                                    WHEN Est_Soltero  	THEN Des_Soltero
                                    WHEN Est_CasBieSep  THEN Des_CasBieSep
                                    WHEN Est_CasBieMan  THEN Des_CasBieMan
                                    WHEN Est_CasCapitu  THEN Des_CasCapitu
                                    WHEN Est_Viudo  	THEN Des_Viudo
                                    WHEN Est_Divorciad  THEN Des_Divorciad
                                    WHEN Est_Seperados  THEN Des_Seperados
                                    WHEN Est_UnionLibre THEN Des_UnionLibre
                                    ELSE Cadena_Vacia
                                END );
	SET Var_RegConyug    := (SELECT CASE Var_ClaveEstCiv
                                WHEN Est_CasBieSep  THEN Des_CasBieSep
                                WHEN Est_CasBieMan  THEN Des_CasBieMan
                                WHEN Est_CasCapitu  THEN Des_CasCapitu
                                ELSE Cadena_Vacia
                            END );
    SET Var_ConyNomCom		:=	IFNULL(Var_ConyNomCom, Cadena_Vacia);
    SET Var_ConyOcupa       := IFNULL(Var_ConyOcupa, Cadena_Vacia);
	SET	Var_TipoViv			:=	IFNULL(Var_TipoViv,	Cadena_Vacia);
	SET	Var_TotIngOrd		:=	IFNULL(Var_TotIngOrd,	Entero_Cero);
	SET	Var_DescIngOrd		:=	IFNULL(Var_DescIngOrd,	Cadena_Vacia);
	SET	Var_TotIngFam		:=	IFNULL(Var_TotIngFam,	Entero_Cero);
	SET	Var_DescIngFam		:=	IFNULL(Var_DescIngFam,	Cadena_Vacia);
	SET	Var_TotIngOtros		:=	IFNULL(Var_TotIngOtros,	Entero_Cero);
	SET	Var_DescIngOtros	:=	IFNULL(Var_DescIngOtros,	Cadena_Vacia);
	SET	TotalIngre			:=	IFNULL(TotalIngre,	Entero_Cero);
	SET	Var_TotEgrOrd		:=	IFNULL(Var_TotEgrOrd,	Entero_Cero);
	SET	Var_DescEgrOrd		:=	IFNULL(Var_DescEgrOrd,	Cadena_Vacia);
	SET	Var_TotEgrFam		:=	IFNULL(Var_TotEgrFam,	Entero_Cero);
	SET	Var_DescEgrFam		:=	IFNULL(Var_DescEgrFam,	Cadena_Vacia);
	SET	Var_OtrosEgr		:=	IFNULL(Var_OtrosEgr,	Entero_Cero);
	SET	Var_DescOtrosEgr	:=	IFNULL(Var_DescOtrosEgr,	Cadena_Vacia);
	SET	TotalEgre			:=	IFNULL(TotalEgre,	Entero_Cero);
	SET	Var_MAApePat		:=	IFNULL(Var_MAApePat,Cadena_Vacia);
	SET	Var_MAApeMat		:= 	IFNULL(Var_MAApeMat,Cadena_Vacia);
	SET	Var_MANombres		:=	IFNULL(Var_MANombres,Cadena_Vacia);
	SET	Var_MAFecNac		:=	IFNULL(Var_MAFecNac,	Cadena_Vacia);
	SET	Var_MAEdad			:=	IFNULL(Var_MAEdad,	Entero_Cero);
	IF (Var_MANacion = Nac_Mexicano) THEN
        SET Var_MANacion   := Des_Mexicano;
    ELSE
        SET Var_MANacion   := Des_Extranjero;
    END IF;
	SET	Var_MACURP			:=	IFNULL(Var_MACURP, Cadena_Vacia);
	SET	Var_NombreTutor		:=	IFNULL(Var_NombreTutor, Cadena_Vacia);
	SET	Var_ReFamNom		:=	IFNULL(Var_ReFamNom, Cadena_Vacia);
	SET	Var_ReFamPar		:=	IFNULL(Var_ReFamPar, Cadena_Vacia);
	SET	Var_ReFamDom		:=	IFNULL(Var_ReFamDom, Cadena_Vacia);
	SET	Var_ReFamTel		:=	IFNULL(Var_ReFamTel, Cadena_Vacia);
	SET	Var_RefPerNom		:=	IFNULL(Var_RefPerNom, Cadena_Vacia);
	SET	Var_RefPerPar		:=	IFNULL(Var_RefPerPar, Cadena_Vacia);
	SET	Var_RefPerDom		:=	IFNULL(Var_RefPerDom, Cadena_Vacia);
	SET	Var_RefPerTel		:=	IFNULL(Var_RefPerTel, Cadena_Vacia);
	SET	Var_NombRefCom		:=	IFNULL(Var_NombRefCom, Cadena_Vacia);
	SET	Var_BancoRef		:=	IFNULL(Var_BancoRef, Cadena_Vacia);
	SET	Var_NoCuentaRef		:=	IFNULL(Var_NoCuentaRef, Cadena_Vacia);
	SET	Var_TelRefCom		:=	IFNULL(Var_TelRefCom, Cadena_Vacia);
	SET	Var_NombRefCom2		:=	IFNULL(Var_NombRefCom2, Cadena_Vacia);
	SET	Var_BancoRef2		:=	IFNULL(Var_BancoRef2, Cadena_Vacia);
	SET	Var_NoCuentaRef2	:=	IFNULL(Var_NoCuentaRef2, Cadena_Vacia);
	SET	Var_TelRefCom2		:=	IFNULL(Var_TelRefCom2, Cadena_Vacia);
	SET	Var_ExTelRfCm		:=	IFNULL(Var_ExTelRfCm, Cadena_Vacia);
	SET	Var_ExTelRfCm2		:=	IFNULL(Var_ExTelRfCm2, Cadena_Vacia);
	


	IF(Var_ClaveEstCiv = 'S' or Var_ClaveEstCiv='V' or Var_ClaveEstCiv='D' or Var_ClaveEstCiv='SE') THEN
    
    SET Var_ConyNomCom	:='';
    SET Var_ConyOcupa	:='';
    SET Var_RegConyug	:='';
 	
    END IF;
    

    SELECT  Var_TipoCte,		Var_NomEmpresa,		Var_EmpCalle,		Var_EmpNum,			Var_EmpCP,
			Var_EmpCol,			Var_EmpCalleRef,	Var_EmpLocalidad,	Var_EmpEstado,		Var_EmpMun,
			Var_EmpTelPart,		Var_EmpNacion,
			CASE	WHEN	Var_EmpFecCons = Fecha_Vacia THEN Cadena_Vacia
					ELSE	Var_EmpFecCons
			END	AS	Var_EmpFecCons,		Var_GiroMerc,		Var_RFCm,			Var_NomRepLeg,		Var_TipoPersona,
			Var_CliApePat,		Var_CliApeMat,		Var_CliNombres,		Var_DirecCompleta,	Var_CliCalle,
			Var_CliNumCasa,		Var_CliColoni,		Var_CodigoP,		Var_CliCalleRef,	Var_CliLocalidad,
			Var_NomEstado,		Var_CliMunici,		Var_CliTiempoHab,
			CASE	WHEN	Var_FecNacCli = Fecha_Vacia THEN Cadena_Vacia
					ELSE	Var_FecNacCli
			END	AS	Var_FecNacCli,
			Var_CliNacion,
			Var_CliTelPart,		Var_CliCURP,		Var_CliCorreo,		Var_CliRFC,			Var_Ocupacion,
			Var_CliLugTra,		Var_TrabCalle,		Var_TrabNum,		Var_TrabCol,		Var_CliTelTra,
			Var_DesCliAntTra,	Var_DepEcon,		Var_ClaveEstCiv,	Var_ConyNomCom,		Var_ConyOcupa,
			Var_TipoViv,		Var_TotIngOrd,		Var_DescIngOrd,		Var_TotIngFam,		Var_DescIngFam,
			Var_TotIngOtros,	Var_DescIngOtros,	TotalIngre,			Var_TotEgrOrd,		Var_DescEgrOrd,
			Var_TotEgrFam,		Var_DescEgrFam,		Var_OtrosEgr,		Var_DescOtrosEgr,	TotalEgre,
			Var_MAApePat,		Var_MAApeMat,		Var_MANombres,		Var_MAFecNac,		Var_MAEdad,
			Var_MANacion,		Var_MACURP,			Var_NombreTutor,	Var_TutorID,		Var_ReFamNom,
			Var_ReFamPar,		Var_ReFamDom,		Var_ReFamTel,		Var_RefPerNom,		Var_RefPerPar,
			Var_RefPerDom,		Var_RefPerTel,		Var_NombRefCom,		Var_BancoRef,		Var_NoCuentaRef,
			Var_TelRefCom,		Var_NombRefCom2,	Var_BancoRef2,		Var_NoCuentaRef2,	Var_TelRefCom2,
			Var_CalleSuc,		Var_NumCasaSuc,		Var_ColSuc,			Var_MunciSuc,		Var_EstadoSuc,
			Var_NombreInstitucion,	Var_MenorEdad,	Var_CliServSol,		Var_FechaSis, 		Var_DescriEstCiv,
			Var_RegConyug,		Var_FechaAltaCli,	Var_ExTelRfCm,		Var_ExTelRfCm2
			;
END IF;


IF (Par_TipoReporte	=	Seccion_BenefiSOFI)THEN

	CALL	TRANSACCIONESPRO(Var_TransID);

	OPEN CURSORBENEFISOFI;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP

			FETCH CURSORBENEFISOFI
			INTO	Var_Nombre,Var_Relacion,Var_Porcentaje,Var_DirecCompleta,Var_CliTelPart;

			INSERT TMPBENEFISOFI VALUES(Var_TransID,Par_ClienteID,Var_Nombre,Var_Relacion,Var_Porcentaje,Var_DirecCompleta,Var_CliTelPart);

		END LOOP;
	END;
	CLOSE CURSORBENEFISOFI;

	SELECT  TransactionID,	ClienteID,	NombreCompleto,	Parentesco,	Porcentaje,	Domicilio,	Telefono
    FROM TMPBENEFISOFI;

	DELETE	FROM	TMPBENEFISOFI	WHERE TransactionID = Var_TransID;
END IF;

END TerminaStore$$