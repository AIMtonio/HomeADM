-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONOCIMIENTOCTACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOCTACON`;DELIMITER $$

CREATE PROCEDURE `CONOCIMIENTOCTACON`(
	/*SP para la consulta de conocimiento de la cuenta*/
	Par_CuentaAhoID		BIGINT(12),			-- Numero de la cuenta de ahorro
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Con_Principal	INT;
DECLARE Con_Foranea		INT;
DECLARE Con_Report		INT;
DECLARE Con_Report2		INT;
DECLARE Con_Existe		INT;
DECLARE Cte				INT;
DECLARE TelCte			VARCHAR(20);
DECLARE CtaAho			VARCHAR(15);
DECLARE NomCte			VARCHAR(150);
DECLARE FechaNac		DATE;
DECLARE FechaCons		DATE;
DECLARE EdoCivil		CHAR(2);
DECLARE tipoPer			CHAR(1);
DECLARE Nacional		VARCHAR(30);
DECLARE nRFC			VARCHAR(13);
DECLARE RFCgrupo		VARCHAR(13);
DECLARE Sex				CHAR(1);
DECLARE Nocupacion		INT;
DECLARE Ocupacion		TEXT;
DECLARE Direccion		VARCHAR(200);
DECLARE nIdentif		INT;
DECLARE Identif			VARCHAR(30);
DECLARE nActBmx			BIGINT;
DECLARE ActBmx			VARCHAR(200);
DECLARE LugTrabajo		VARCHAR(100);
DECLARE Puest			VARCHAR(100);
DECLARE DirecTrab		VARCHAR(200);
DECLARE TelTrab			VARCHAR(20);
DECLARE PFteIng			VARCHAR(100);
DECLARE NomRef			VARCHAR(50);
DECLARE NomRef2			VARCHAR(50);
DECLARE DomRef			VARCHAR(150);
DECLARE DomRef2			VARCHAR(150);
DECLARE TelRef			VARCHAR(20);
DECLARE TelRef2			VARCHAR(20);
DECLARE BancRef			VARCHAR(45);
DECLARE BancRef2		VARCHAR(45);
DECLARE NoctaRef		VARCHAR(30);
DECLARE NoctaRef2		VARCHAR(30);
DECLARE Ngrupo			VARCHAR(100);
DECLARE Particip		DOUBLE;
DECLARE NacionalGrup	VARCHAR(30);
DECLARE Empleados		VARCHAR(10);
DECLARE ServProd		VARCHAR(50);
DECLARE CobGeo			CHAR(1);
DECLARE Estados			VARCHAR(45);
DECLARE ImporVta		DOUBLE;
DECLARE Activ			DOUBLE;
DECLARE Pasiv			DOUBLE;
DECLARE Capit			DOUBLE;
DECLARE PImport			VARCHAR(50);
DECLARE PImport2		VARCHAR(50);
DECLARE PImport3		VARCHAR(50);
DECLARE PExport			VARCHAR(50);
DECLARE PExport2		VARCHAR(50);
DECLARE PExport3		VARCHAR(50);
DECLARE IngAMes			VARCHAR(10);
DECLARE DImport			CHAR(5);
DECLARE DExport			CHAR(5);
DECLARE DirOficial 		INT;
DECLARE Tipo			CHAR(1);
DECLARE Estatus_Vigente CHAR(1);
DECLARE Tipo_Consecutiva CHAR(1);
DECLARE EsOficial       CHAR(1);
DECLARE tipoPerFis  	CHAR(1);
DECLARE tipoPerAe   	CHAR(1);
DECLARE tipoPerMor  	CHAR(1);

DECLARE desTipoPerFis 	VARCHAR(20);
DECLARE desTipoPerAe  	VARCHAR(20);
DECLARE desTipoPerMor 	VARCHAR(20);
DECLARE DesEdoCivilS   VARCHAR(50);
DECLARE DesEdoCivilCS  VARCHAR(50);
DECLARE DesEdoCivilCM  VARCHAR(50);
DECLARE DesEdoCivilCC  VARCHAR(80);
DECLARE DesEdoCivilV   VARCHAR(50);
DECLARE DesEdoCivilD   VARCHAR(50);
DECLARE DesEdoCivilSE  VARCHAR(50);
DECLARE DesEdoCivilU   VARCHAR(50);

DECLARE EdoCivilS   CHAR(2);
DECLARE EdoCivilCS  CHAR(2);
DECLARE EdoCivilCM  CHAR(2);
DECLARE EdoCivilCC  CHAR(2);
DECLARE EdoCivilV   CHAR(2);
DECLARE EdoCivilD   CHAR(2);
DECLARE EdoCivilSE  CHAR(2);
DECLARE EdoCivilU   CHAR(2);

DECLARE NacionalN    CHAR(1);
DECLARE NacionalE    CHAR(1);
DECLARE DesNacionalN VARCHAR(15);
DECLARE DesNacionalE VARCHAR(15);
DECLARE sexoF        CHAR(1);
DECLARE sexoM        CHAR(1);
DECLARE desSexoF     VARCHAR(15);
DECLARE desSsexoM    VARCHAR(15);


-- CONOCIMIENTO DE CTA. SOFIEXPRESS --
DECLARE	Con_ConocCta	INT;
DECLARE	PersonaMoral	CHAR(1);
DECLARE	PersonaFisica	CHAR(1);
DECLARE	Dir_Oficial		CHAR(1);
DECLARE	Id_Oficial		CHAR(1);
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;

DECLARE	Var_TipoPersona	VARCHAR(50);
DECLARE	Var_CteApPat	VARCHAR(50);
DECLARE	Var_CteApMat	VARCHAR(50);
DECLARE	Var_EdoCivil	VARCHAR(100);
DECLARE	Var_Sexo		VARCHAR(50);
DECLARE	Var_Identi		VARCHAR(100);
DECLARE	Var_NumIdenti	VARCHAR(150);
DECLARE	Var_FecVenId	DATE;
-- -------------------------------- --

-- Asignacion de Constantes
SET	Con_Principal	:= 1;		-- Consulta principal
SET	Con_Foranea		:= 2;		-- Consulta foranea
SET	Con_Report		:= 3;		-- consulta para reportePersonaFisica
SET	Con_Report2		:= 4;		-- consulta para reportePersonaMoral
SET	Con_Existe		:= 5;		-- consulta para saber si ya existe conocimiento de cta
SET DirOficial		:= 6;		-- Direccion tipo 6 que es Oficial y se encuentra en la tabla TIPODIRECCION

--   Asignacion Cte. SOFIEXPRESS    --
SET	Con_ConocCta	:=	7;		-- Consulta para el conocimiento de cuenta de sofiexpress
SET PersonaMoral	:=	'M';	-- Tipo persona moral
SET	PersonaFisica	:=	'F';	-- Tipo persona fisica
SET Dir_Oficial		:=	'S';	-- Si es direccion oficial
SET	Id_Oficial		:=	'S';	-- Si es identificacion oficial
SET Cadena_Vacia	:=	'';		-- Cadena vacia
SET Fecha_Vacia		:=	'1900-01-01';	-- Fecha Vacia

-- -------------------------------- --
SET Estatus_Vigente  := 'V'; 	-- estatus vigente
SET Tipo_Consecutiva := 'C'; 	-- acta consecutiva
SET EsOficial        := 'S'; 	-- direccion oficial
SET tipoPerFis 		 := 'F'; 	-- persona fisica
SET tipoPerAe        := 'A'; 	-- persona fisica
SET tipoPerMor       := 'M'; 	-- persona moral
SET desTipoPerFis    := 'PERSONA FISICA'; -- descripcion persona fisica
SET desTipoPerAe     := 'PERSONA FISICA'; -- descripcion persona fisica
SET desTipoPerMor    := 'PERSONA MORAL';  -- descripcion persona moral
SET DesEdoCivilS  	 :=  'SOLTERO'; 					-- estado civil
SET DesEdoCivilCS 	 :=  'CASADO BIENES SEPARADOS'; 	-- estado civil
SET DesEdoCivilCM 	 :=  'CASADO BIENES MANCOMUNADOS'; -- estado civil
SET DesEdoCivilCC 	 :=  'CASADO BIENES MANCOMUNADOS CON CAPITULACION'; -- estado civil
SET DesEdoCivilV  	 :=  'VIUDO';                      -- estado civil
SET DesEdoCivilD  	 :=  'DIVORCIADO';                 -- estado civil
SET DesEdoCivilSE 	 :=  'SEPARADO';                   -- estado civil
SET DesEdoCivilU  	 :=  'UNION LIBRE';                -- estado civil

SET EdoCivilS  := 'S';   -- estado civil
SET EdoCivilCS := 'CS';	 -- estado civil
SET EdoCivilCM := 'CM';	 -- estado civil
SET EdoCivilCC := 'CC';	 -- estado civil
SET EdoCivilV  := 'V';   -- estado civil
SET EdoCivilD  := 'D';	 -- estado civil
SET EdoCivilSE := 'SE';	 -- estado civil
SET EdoCivilU  := 'U';	 -- estado civil

SET NacionalN      := 'N'; 			-- nacionalidad
SET NacionalE      := 'E'; 			-- nacionalidad
SET DesNacionalN   := 'NACIONAL'; 	-- descripcion nacionalidad
SET DesNacionalE   := 'EXTRANGERA';	-- descripcion nacionalidad

SET sexoF      	   := 'F';  		-- sexo femenino
SET sexoM          := 'M';  		-- sexo masculino
SET desSexoF       := 'FEMENINO'; 	-- descripcion sexo femenino
SET desSsexoM      := 'FEMENINO'; 	-- descripcion sexo masculino

/* Consulta 1.- Por Llave Principal */
IF(Par_NumCon = Con_Principal) THEN
	  SELECT	CuentaAhoID,		FORMAT(DepositoCred,2)DepositoCred,	FORMAT(RetirosCargo,2)RetirosCargo,		ProcRecursos,	ConcentFondo,
			    AdmonGtosIng,		PagoNomina,		    				CtaInversion,							PagoCreditos,	OtroUso,
				DefineUso,			RecursoProvProp,					RecursoProvTer,							NumDepositos, 	FrecDepositos,
				NumRetiros, 		FrecRetiros,						MediosElectronicos
	    FROM  CONOCIMIENTOCTA
	   WHERE  CuentaAhoID 	= Par_CuentaAhoID;
END IF;

/* Consulta 3.- Reporte conocimiento de cuenta Persona Fisica*/
IF(Par_NumCon = Con_Report) THEN
	SET Cte := (SELECT ClienteID FROM CUENTASAHO  WHERE CuentaAhoID = Par_CuentaAhoID );
	SELECT 		Cli.NombreCompleto, 	Cli.FechaNacimiento, 	Cli.Puesto, 			Cli.TelTrabajo, 	LugardeTrabajo,
				Cli.ActividadBancoMx,	Act.Descripcion, 		Dir.DireccionCompleta,	Cli.EstadoCivil,	Cli.Nacion,
				Cli.RFC,				Cli.Sexo,			 	Oc.Descripcion,			Cli.TipoPersona
		INTO 	NomCte, 				FechaNac, 				Puest, 					TelTrab,			LugTrabajo,
				nActBmx,				ActBmx,					Direccion,				EdoCivil,			Nacional,
				nRFC,					Sex,					Ocupacion,				Tipo
			   FROM	CLIENTES Cli
	LEFT OUTER JOIN ACTIVIDADESBMX	Act ON Cli.ActividadBancoMx = Act.ActividadBMXID
	LEFT OUTER JOIN OCUPACIONES		Oc  ON Cli.OcupacionID = Oc.OcupacionID
	LEFT OUTER JOIN DIRECCLIENTE    Dir ON Dir.Oficial = EsOficial AND  Dir.ClienteID = Cli.ClienteID
			  WHERE Cli.ClienteID = Cte;

	SET CtaAho :=(SELECT LPAD(CONVERT(Par_CuentaAhoID,CHAR),11, 0));
	SET DirecTrab := (SELECT DireccionCompleta FROM DIRECCLIENTE WHERE ClienteID = Cte AND TipoDireccionID = 3 LIMIT 1);

	SELECT	Nombre
		    INTO Identif
			FROM TIPOSIDENTI Tp,
				 IDENTIFICLIENTE Id
		   WHERE Id.ClienteID = Cte
			 AND Tp.TipoIdentiID = Id.IdentificID LIMIT 0 ,1;


	SELECT   PFuenteIng,	NombreRef,	 	NombreRef2,  DomicilioRef, DomicilioRef2,
			 TelefonoRef,  TelefonoRef2,    BancoRef,    BancoRef2,    NoCuentaRef,
			 NoCuentaRef2
		INTO PFteIng,		NomRef,		    NomRef2,     DomRef,       DomRef2,
			 TelRef,  		TelRef2,		BancRef,	 BancRef2,	   NoctaRef,
			 NoctaRef2
		FROM CONOCIMIENTOCTE
	   WHERE ClienteID = Cte LIMIT 0, 1;

	SELECT	CuentaAhoID,		CtaAho,			DepositoCred,		RetirosCargo,			ProcRecursos,
			ConcentFondo,		AdmonGtosIng,	PagoNomina,			CtaInversion,			PagoCreditos,
			OtroUso,			DefineUso,		RecursoProvProp, 	RecursoProvTer, 		CURDATE() AS fecha, 	Cte,
			NomCte,				FechaNac,		EdoCivil,			Nacional,				nRFC,
			Sex,				Ocupacion,		Direccion,			Identif,				ActBmx,
			LugTrabajo,			Puest,			DirecTrab,			TelTrab,				PFteIng,
			NomRef,				NomRef2,		DomRef,				DomRef2,				TelRef,
			TelRef2,			BancRef,		BancRef2,			NoctaRef,				NoctaRef2,
			Tipo, 				NumDepositos,   FrecDepositos,  	NumRetiros,         	FrecRetiros,
			MediosElectronicos
		FROM CONOCIMIENTOCTA
		WHERE  CuentaAhoID 	= Par_CuentaAhoID;
END IF;

/* Consulta 4.- Reporte conocimiento de cuenta Persona Moral*/
IF(Par_NumCon = Con_Report2) THEN
	SET Cte := (SELECT ClienteID FROM CUENTASAHO  WHERE CuentaAhoID = Par_CuentaAhoID );
    SET CtaAho :=(SELECT LPAD(CONVERT(Par_CuentaAhoID,CHAR),11, 0));

	SELECT 	NombreCompleto,	 		TipoPersona,			Nacion,			RFC,	Telefono,
			Dir.DireccionCompleta, 	Cli.ActividadBancoMx,	Act.Descripcion
	  INTO  NomCte,					tipoPer,				Nacional,		nRFC,	TelCte,
			Direccion,				ActBmx,					ActBmx
	        FROM CLIENTES Cli,
		         ACTIVIDADESBMX Act
 LEFT OUTER JOIN DIRECCLIENTE  Dir ON (Dir.TipoDireccionID = DirOficial) -- Busca la direccion tipo 6 que es Oficial y se encuentra en la tabla TIPODIRECCION
		   WHERE Cli.ClienteID = Cte
		     AND Cli.ActividadBancoMx = Act.ActividadBMXID;

	SELECT     PFuenteIng,		NombRefCom,		NombRefCom2,	DomicilioRef,	DomicilioRef2,	TelRefCom,
			   TelRefCom2, 	    BancoRef,   	BancoRef2,      NoCuentaRef,    NoCuentaRef2,   NomGrupo,
			   RFC,             Participacion,  Nacionalidad,   NoEmpleados,    Serv_Produc,    Cober_Geograf,
			   Estados_Presen,  ImporteVta,	    Activos,        Pasivos,        Capital,        PaisesImport,
			   PaisesImport2,   PaisesImport3,  PaisesExport,   PaisesExport2,  PaisesExport3,  IngAproxMes,
			   DolaresImport,   DolaresExport
		  INTO PFteIng  ,		NomRef,			NomRef2,		DomRef,			DomRef2,		TelRef,
			   TelRef2,			BancRef,        BancRef2,       NoctaRef,       NoctaRef2,      Ngrupo,
			   RFCgrupo,    	Particip,		NacionalGrup,	Empleados,		ServProd,		CobGeo,
			   Estados,			ImporVta,		Activ,			Pasiv,			Capit,          PImport,
			   PImport2	,		PImport3,		PExport,		PExport2,		PExport3,		IngAMes,
			   DImport,			DExport
					 FROM CONOCIMIENTOCTE
					 WHERE ClienteID = Cte LIMIT 0, 1;

	SET FechaCons := (SELECT FechaEsc FROM ESCRITURAPUB WHERE ClienteID = Cte AND Esc_Tipo = Tipo_Consecutiva AND Estatus = Estatus_Vigente);

	SELECT	CuentaAhoID,		CtaAho,			DepositoCred,		RetirosCargo,			ProcRecursos,
			ConcentFondo,		AdmonGtosIng,	PagoNomina,		    CtaInversion,			PagoCreditos,
			OtroUso,			DefineUso,		RecursoProvProp,	CURDATE() AS fecha, 	Cte,
			NomCte,			    Nacional,		nRFC,			    Direccion,				ActBmx,
			PFteIng,			NomRef,			NomRef2,			DomRef,					DomRef2,
			TelRef,			    TelRef2,		BancRef,			BancRef2,				NoctaRef,
			NoctaRef2,		    Ngrupo,			RFCgrupo,			Particip,				NacionalGrup,
			Empleados,		    ServProd,		CobGeo,				Estados,				ImporVta,
			Activ,				Pasiv,			Capit,				PImport,				PImport2,
			PImport3,		    PExport,		PExport2,			PExport3,				IngAMes,
			DImport,			DExport,		FechaCons,			TelCte, 				NumDepositos,
			FrecDepositos,  	NumRetiros,     FrecRetiros,		MediosElectronicos
		FROM CONOCIMIENTOCTA
		WHERE  CuentaAhoID 	= Par_CuentaAhoID;
END IF;

/* Consulta 5.- Para validar si la cuenta tiene un conocimiento de cuenta */
IF(Par_NumCon = Con_Existe) THEN
	SELECT	CuentaAhoID
		FROM CONOCIMIENTOCTA
		WHERE  CuentaAhoID 	= Par_CuentaAhoID;
END IF;

/* SECCION - Consulta 4.- CONOCIMIENTO DE CUENTA SOFIEXPRESS */
IF(Par_NumCon = Con_ConocCta)	THEN
	/* SELECT	"SECCION - CONOCIMIENTO DE CUENTA SOFIEXPRESS"; */
	SET	Cte		:=	(SELECT ClienteID FROM CUENTASAHO  WHERE CuentaAhoID = Par_CuentaAhoID );
    SET	CtaAho	:=	(SELECT LPAD(CONVERT(Par_CuentaAhoID,CHAR),11, 0));

	SELECT	Cli.TipoPersona
	INTO	tipoPer
	FROM	CLIENTES	Cli
	WHERE	Cli.ClienteID	=	Cte;

	-- persona fisica
	SELECT 	CONCAT(IFNULL(Cli.PrimerNombre, Cadena_Vacia),
				CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) = Cadena_Vacia	THEN	CONCAT(' ', Cli.SegundoNombre)
						ELSE Cadena_Vacia
				END,
				CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) = Cadena_Vacia	THEN	CONCAT(' ', Cli.TercerNombre)
						ELSE Cadena_Vacia
				END
			),						Cli.ApellidoPaterno,	Cli.ApellidoMaterno,
			Cli.FechaNacimiento, 	Cli.EstadoCivil,		Cli.Nacion,			Cli.RFC,		Cli.Sexo,
			Act.Descripcion
	INTO	NomCte,					Var_CteApPat,			Var_CteApMat,
			FechaNac,				Var_EdoCivil,				Nacional,			nRFC,		Var_Sexo,
			ActBmx
	FROM	CLIENTES		Cli
	LEFT OUTER JOIN	ACTIVIDADESBMX	Act	ON	Act.ActividadBMXID	=	Cli.ActividadBancoMX
	WHERE	Cli.ClienteID	=	Cte;

	SELECT	Dir.DireccionCompleta
	INTO	Direccion
	FROM	DIRECCLIENTE	Dir
	WHERE	Dir.ClienteID	=	Cte
	AND		Dir.Oficial		=	Dir_Oficial;

	SELECT	Tid.Nombre,		Id.NumIdentific,	Id.FecVenIden
	INTO	Var_Identi,		Var_NumIdenti,		Var_FecVenId
	FROM		IDENTIFICLIENTE Id
	INNER JOIN	TIPOSIDENTI		Tid	ON	Tid.TipoIdentiID	=	Id.TipoIdentiID
									AND	Tid.Oficial			=	Id_Oficial
	WHERE	Id.ClienteID	=	Cte
		AND	Id.Oficial		=	Id_Oficial;

	-- SETTING VALUES

	SET	Var_TipoPersona	:=	(CASE	tipoPer
										WHEN tipoPerFis	THEN	desTipoPerFis
										WHEN tipoPerAe	THEN	desTipoPerAe
										WHEN tipoPerMor	THEN	desTipoPerMor
										ELSE Cadena_Vacia
							END);

	SET	Var_EdoCivil	:=	(CASE	Var_EdoCivil
										WHEN EdoCivilS  THEN DesEdoCivilS
										WHEN EdoCivilCS THEN DesEdoCivilCS
										WHEN EdoCivilCM THEN DesEdoCivilCM
										WHEN EdoCivilCC THEN DesEdoCivilCC
										WHEN EdoCivilV  THEN DesEdoCivilV
										WHEN EdoCivilD  THEN DesEdoCivilD
										WHEN EdoCivilSE THEN DesEdoCivilSE
										WHEN EdoCivilU  THEN DesEdoCivilU
										ELSE Cadena_Vacia
							END);

	SET	Nacional		:=	(CASE	Nacional
											WHEN NacionalN	THEN DesNacionalN
											WHEN NacionalE	THEN DesNacionalE
											ELSE Cadena_Vacia
							END);
	SET	Var_Sexo		:=	(CASE	Var_Sexo
									WHEN	sexoF	THEN desSexoF
									WHEN	sexoM	THEN desSsexoM
									ELSE	Cadena_Vacia
							END);
	SET	Var_Identi		:=	IFNULL(Var_Identi, Cadena_Vacia);
	SET	Var_NumIdenti	:=	IFNULL(Var_NumIdenti, Cadena_Vacia);
	SET	Var_FecVenId	:=	IFNULL(Var_FecVenId, Fecha_Vacia);

	SELECT	Cte, 			CtaAho,				Var_TipoPersona,
			NomCte,			Var_CteApPat,		Var_CteApMat,		FechaNac,		Var_EdoCivil,
			Nacional,		nRFC,				Var_Sexo,			Direccion,
			Var_Identi,		Var_NumIdenti,		Var_FecVenId;
END IF;

END TerminaStore$$