-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONOCIMIENTOCTAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOCTAREP`;DELIMITER $$

CREATE PROCEDURE `CONOCIMIENTOCTAREP`(
	Par_CuentaAhoID			BIGINT(12),

	Par_Institucion			TINYINT UNSIGNED, -- numero solo para relacionar la empresa en este caso orderexpress
	Par_TipoRep				TINYINT UNSIGNED, -- tipo conocimiento de cta para persona moral,fisica, etc tasa fija, tasa variable persona fisica persona moral
	Par_Seccion				TINYINT UNSIGNED, -- seccion del reporte a mostrar cabecera, cuerpo, pie, pag1 etc


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

	)
TerminaStore:BEGIN
-- declaracion de variables
DECLARE Cte					INT;
DECLARE CtaAho				VARCHAR(15);
DECLARE DirecTrab			VARCHAR(200);
DECLARE	Var_Titulo			VARCHAR(50);
DECLARE NomCte				VARCHAR(150);
DECLARE	Var_CteApPat		VARCHAR(50);
DECLARE	Var_CteApMat		VARCHAR(50);
DECLARE FechaNac			DATE;
DECLARE	Var_EdoCivil		VARCHAR(100);
DECLARE Nacional			VARCHAR(30);
DECLARE nRFC				VARCHAR(13);
DECLARE	Var_Sexo			VARCHAR(50);
DECLARE ActBmx				VARCHAR(300);
DECLARE LugTrabajo			VARCHAR(100);
DECLARE Puest				VARCHAR(100);
DECLARE TelTrab				VARCHAR(20);
DECLARE Ocupacion			VARCHAR(500);
DECLARE Direccion			VARCHAR(200);
DECLARE	Var_Identi			VARCHAR(100);
DECLARE	Var_NumIdenti		VARCHAR(150);
DECLARE	Var_FecVenId		DATE;
DECLARE NomRef				VARCHAR(50);
DECLARE NomRef2				VARCHAR(50);
DECLARE DomRef				VARCHAR(150);
DECLARE DomRef2				VARCHAR(150);
DECLARE TelRef				VARCHAR(20);
DECLARE TelRef2				VARCHAR(20);
DECLARE BancRef				VARCHAR(45);
DECLARE BancRef2			VARCHAR(45);
DECLARE NoctaRef			VARCHAR(30);
DECLARE NoctaRef2			VARCHAR(30);
DECLARE	Var_DepositoCred	DECIMAL(12,2);
DECLARE	Var_RetirosCargo	DECIMAL(12,2);
DECLARE	Var_ProcRecursos	VARCHAR(100);
DECLARE	Var_ConcentFondo	VARCHAR(100);
DECLARE	Var_AdmonGtosIng	VARCHAR(100);
DECLARE	Var_CtaInversion	VARCHAR(100);
DECLARE	Var_PagoCreditos	VARCHAR(100);
DECLARE	Var_OtroUso			VARCHAR(100);
DECLARE	Var_DefineUso		VARCHAR(100);
DECLARE	Var_PagoNomina		VARCHAR(100);
DECLARE	Var_RecursoProvProp		VARCHAR(100);
DECLARE	Var_RecursoProvTer		VARCHAR(100);
DECLARE	Var_MediosElectronicos	VARCHAR(100);
DECLARE	Var_TipoPersona			VARCHAR(50);
DECLARE	Var_FechaNac			VARCHAR(100);
DECLARE tipoPer					CHAR(1);
DECLARE	Var_UsoCta				INT;
DECLARE	Var_OtrosDesc			VARCHAR(100);
DECLARE	Var_ProvRecursos		INT;

-- declaracion de Constantes
DECLARE	Cons_SofiExpress 	INT;
DECLARE	Cons_TipoCTOCTA		INT;
DECLARE	Cons_SecPrinc		INT;
DECLARE	Cadena_Vacia		CHAR(1);					-- Cadena Vacia
DECLARE	Fecha_Vacia			DATE;						-- Fecha Vacia
DECLARE	Decimal_Cero		DECIMAL;					-- Decimal en Cero
DECLARE	Entero_Cero			INT;						-- Entero en Cero

DECLARE	Dir_Oficial			CHAR(1);					-- Direccion Oficial
DECLARE	Dir_Trabajo			INT;						-- Tipo de Direccion: Trabajo
DECLARE	Id_Oficial			CHAR(1);					-- Identificacion Oficial
DECLARE	PersonaMoral		CHAR(1);					-- Tipo de Persona:	Moral
DECLARE	PersonaFisicActEmp	CHAR(1);					-- Tipo de Persona:	Fisica con Actividad Empresarial
DECLARE	PersonaFisica		CHAR(1);					-- Tipo de Persona:	Fisica
DECLARE	Desc_PerMoral		VARCHAR(50);				-- Descripcion PERSONA MORAL
DECLARE	Desc_PerFisica		VARCHAR(50);				-- Descripcion PERSONA FISICA
DECLARE Est_Soltero			CHAR(1);        			-- Estado Civil Soltero
DECLARE Est_CasBieSep   	CHAR(2);       				-- Casado Bienes Separados
DECLARE Est_CasBieMan   	CHAR(2);      				-- Casado Bienes Mancomunados
DECLARE Est_CasCapitu   	CHAR(2);       				-- Casado Bienes Mancomunados Con Capitulacion
DECLARE Est_Viudo       	CHAR(1);        			-- Viudo
DECLARE Est_Divorciad   	CHAR(1);        			-- Divorciado
DECLARE Est_Seperados   	CHAR(2);       				-- Separado
DECLARE Est_UnionLibre  	CHAR(1);        			-- Union Libre
DECLARE Des_Soltero     	VARCHAR(100);				-- Descripcion SOLTERO
DECLARE Des_CasBieSep   	VARCHAR(100);				-- Descripcion CASADO(A) BIENES SEPARADOS
DECLARE Des_CasBieMan   	VARCHAR(100);				-- Descripcion CASADO(A) BIENES MANCOMUNADOS
DECLARE Des_CasCapitu   	VARCHAR(100);				-- Descripcion CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION
DECLARE Des_Viudo       	VARCHAR(100);				-- Descripcion VIUDO
DECLARE Des_Divorciad   	VARCHAR(100);				-- Descripcion DIVORCIADO
DECLARE Des_Seperados   	VARCHAR(100);				-- Descripcion SEPARADO
DECLARE Des_UnionLibre  	VARCHAR(100);				-- Descripcion UNION LIBRE
DECLARE Nac_Mexicano    	CHAR(1);					-- Nacionalidad: N.- Nacional 	- Mexicano
DECLARE	Nac_Extranjero		CHAR(1);					-- Nacionalidad: E.- Extranjera - Extranjero
DECLARE Des_Mexicano    	VARCHAR(20);				-- Nacionalidad: Mexicana
DECLARE Des_Extranjero  	VARCHAR(20);				-- Nacionalidad: Extranjera

-- -------------------------------- --

-- asignacion de Constantes
SET Cons_SofiExpress		:=	1;
SET Cons_TipoCTOCTA			:=	1;
SET Cons_SecPrinc			:=	1;
SET Cadena_Vacia			:=	'';
SET Fecha_Vacia				:=	'1900-01-01';
SET	Decimal_Cero			:=	0.0;
SET	Entero_Cero				:=	0;

SET Dir_Oficial				:=	'S';
SET	Dir_Trabajo				:=	3;
SET	Id_Oficial				:=	'S';
SET PersonaMoral			:=	'M';
SET	PersonaFisica			:=	'F';
SET	PersonaFisicActEmp		:=	'A';
SET	Desc_PerMoral			:=	'Persona Moral';
SET	Desc_PerFisica			:=	'Persona Fisica';
SET Est_Soltero     		:= 'S';
SET Est_CasBieSep   		:= 'CS';
SET Est_CasBieMan   		:= 'CM';
SET Est_CasCapitu   		:= 'CC';
SET Est_Viudo       		:= 'V';
SET Est_Divorciad   		:= 'D';
SET Est_Seperados   		:= 'SE';
SET Est_UnionLibre  		:= 'U';
SET Des_Soltero     		:= 'SOLTERO(A)';
SET Des_CasBieSep   		:= 'CASADO(A) BIENES SEPARADOS';
SET Des_CasBieMan   		:= 'CASADO(A) BIENES MANCOMUNADOS';
SET Des_CasCapitu   		:= 'CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION';
SET Des_Viudo       		:= 'VIUDO(A)';
SET Des_Divorciad   		:= 'DIVORCIADO(A)';
SET Des_Seperados   		:= 'SEPARADO(A)';
SET Des_UnionLibre  		:= 'UNION LIBRE';
SET Nac_Mexicano        	:= 'N';
SET	Nac_Extranjero			:= 'E';
SET Des_Mexicano        	:= 'MEXICANA';
SET Des_Extranjero      	:= 'EXTRANJERA';

/* SECCION - CONOCIMIENTO DE CUENTA SOFIEXPRESS */
IF(Par_Institucion = Cons_SofiExpress) THEN
	IF(Par_TipoRep = Cons_TipoCTOCTA) THEN
		IF(Par_Seccion = Cons_SecPrinc) THEN

			SET	Cte		:=	(	SELECT 	ClienteID
								FROM 	CUENTASAHO
								WHERE 	CuentaAhoID = Par_CuentaAhoID );
			SET	CtaAho	:=	(	LPAD(CONVERT(Par_CuentaAhoID,CHAR),11, 0));
			SET DirecTrab := (SELECT DireccionCompleta FROM DIRECCLIENTE WHERE ClienteID = Cte AND TipoDireccionID = 3 LIMIT 1);
			SELECT	Cli.TipoPersona
			INTO	tipoPer
			FROM	CLIENTES	Cli
			WHERE	Cli.ClienteID	=	Cte;

			SELECT 	Titulo,					TRIM(CONCAT(
												IFNULL(Cli.PrimerNombre, Cadena_Vacia),' ',
												IFNULL(Cli.SegundoNombre, Cadena_Vacia), ' ',
												IFNULL(Cli.TercerNombre, Cadena_Vacia)
											)),				Cli.ApellidoPaterno,Cli.ApellidoMaterno,	Cli.FechaNacimiento,
					Cli.EstadoCivil,		Cli.Nacion,		Cli.RFC,			Cli.Sexo,				Oc.Descripcion,
					Cli.LugardeTrabajo,		Cli.Puesto,		Cli.TelTrabajo,		Oc.Descripcion
				INTO
					Var_Titulo,				NomCte,			Var_CteApPat,		Var_CteApMat,			FechaNac,
					Var_EdoCivil,			Nacional,		nRFC,				Var_Sexo,				ActBmx,
					LugTrabajo,				Puest,			TelTrab,			Ocupacion
			FROM	CLIENTES		Cli
			LEFT OUTER JOIN	OCUPACIONES		Oc	ON	Oc.OcupacionID		=	Cli.OcupacionID
			WHERE	Cli.ClienteID	=	Cte;

			SELECT	Dir.DireccionCompleta
			INTO	Direccion
			FROM	DIRECCLIENTE	Dir
			WHERE	Dir.ClienteID	=	Cte
			AND		Dir.Oficial		=	Dir_Oficial
			LIMIT	1;

			SELECT	Dir.DireccionCompleta
			INTO	DirecTrab
			FROM	DIRECCLIENTE	Dir
			WHERE	Dir.ClienteID	=	Cte
			AND		Dir.Oficial		=	Dir_Oficial
			AND		Dir.TipoDireccionID	=	Dir_Trabajo
			LIMIT	1;

			SELECT	Tid.Nombre,		Id.NumIdentific,	Id.FecVenIden
			INTO	Var_Identi,		Var_NumIdenti,		Var_FecVenId
			FROM		IDENTIFICLIENTE Id
			INNER JOIN	TIPOSIDENTI		Tid	ON	Tid.TipoIdentiID	=	Id.TipoIdentiID
											AND	Tid.Oficial			=	Id_Oficial
			WHERE	Id.ClienteID	=	Cte
			AND	Id.Oficial		=	Id_Oficial
			LIMIT	1;

			SELECT	CCte.NombreRef,		CCte.DomicilioRef,		CCte.TelefonoRef,
					CCte.NombreRef2,	CCte.DomicilioRef2,		CCte.TelefonoRef2,
					CCte.BancoRef,		CCte.NoCuentaRef,
					CCte.BancoRef2,		CCte.NoCuentaRef2
			INTO	NomRef,				DomRef,					TelRef,
					NomRef2,			DomRef2,				TelRef2,
					BancRef,			NoctaRef,
					BancRef2,			NoctaRef2
			FROM	CONOCIMIENTOCTE	CCte
			WHERE	CCte.ClienteID	=	Cte;

			SELECT	CCta.DepositoCred,	CCta.RetirosCargo,	CCta.ProcRecursos,	ConcentFondo,	AdmonGtosIng,
					CtaInversion,		PagoCreditos, 		OtroUso,			DefineUso,		PagoNomina,
					RecursoProvProp,	RecursoProvTer,		MediosElectronicos
			INTO	Var_DepositoCred,	Var_RetirosCargo,	Var_ProcRecursos,	Var_ConcentFondo,Var_AdmonGtosIng,
					Var_CtaInversion,	Var_PagoCreditos,	Var_OtroUso,		Var_DefineUso,	Var_PagoNomina,
					Var_RecursoProvProp,Var_RecursoProvTer,	Var_MediosElectronicos
			FROM	CONOCIMIENTOCTA	CCta
			WHERE	CCta.CuentaAhoID	=	Par_CuentaAhoID;



			IF( tipoPer	=	PersonaMoral)	THEN
				SELECT	Ts.Descripcion,	Cli.RazonSocial,	Cli.RFCpm
				INTO	ActBmx,			LugTrabajo,			nRFC
				FROM			CLIENTES		Cli
				LEFT OUTER JOIN	TIPOSOCIEDAD	Ts	ON	Ts.TipoSociedadID	=	Cli.TipoSociedadID
				WHERE	Cli.ClienteID	=	Cte;

				SET	Puest	:=	Cadena_Vacia;
			END IF;


			-- SETTING VALUES
			SET	Var_TipoPersona		:=(	CASE	tipoPer
												WHEN	PersonaFisica		THEN	Desc_PerFisica
												WHEN	PersonaFisicActEmp	THEN	Desc_PerFisica
												WHEN	PersonaMoral		THEN	Desc_PerMoral
												ELSE	Cadena_Vacia
										END);
			SET	Var_Titulo			:=	IFNULL(Var_Titulo, Cadena_Vacia);
			SET	NomCte				:=	IFNULL(NomCte, Cadena_Vacia);
			SET	Var_CteApPat		:=	IFNULL(Var_CteApPat, Cadena_Vacia);
			SET	Var_CteApMat		:=	IFNULL(Var_CteApMat, Cadena_Vacia);
			SET	Var_FechaNac		:=	CASE	FechaNac
											WHEN	Fecha_Vacia	THEN	Cadena_Vacia
											ELSE	FORMATOFECHACOMPLETA(FechaNac)
										END;
			SET	Var_EdoCivil		:=	(	CASE	Var_EdoCivil
												WHEN Est_Soltero	THEN	Des_Soltero
												WHEN Est_CasBieSep	THEN	Des_CasBieSep
												WHEN Est_CasBieMan	THEN	Des_CasBieMan
												WHEN Est_CasCapitu	THEN	Des_CasCapitu
												WHEN Est_Viudo		THEN	Des_Viudo
												WHEN Est_Divorciad	THEN	Des_Divorciad
												WHEN Est_Seperados	THEN	Des_Seperados
												WHEN Est_UnionLibre	THEN	Des_UnionLibre
												ELSE				Cadena_Vacia
											END);
			SET	Nacional			:=	(	CASE	Nacional
													WHEN	Nac_Mexicano	THEN	Des_Mexicano
													WHEN	Nac_Extranjero	THEN	Des_Extranjero
													ELSE	Cadena_Vacia
											END);
			SET Direccion			:= CONCAT(Direccion,',',' ','MEXICO');
			SET	nRFC				:=	IFNULL(nRFC, Cadena_Vacia);
			SET	Var_Sexo			:=	IFNULL(Var_Sexo,Cadena_Vacia);
			SET	Ocupacion			:=	IFNULL(Ocupacion, Cadena_Vacia);
			SET	ActBmx				:=	IFNULL(ActBmx, Cadena_Vacia);
			SET	LugTrabajo			:=	IFNULL(LugTrabajo, Cadena_Vacia);
			SET	Puest				:=	IFNULL(Puest, Cadena_Vacia);
			SET	DirecTrab			:=	IFNULL(DirecTrab, Cadena_Vacia);
			SET	TelTrab				:=	IFNULL(TelTrab, Cadena_Vacia);
			SET	Direccion			:=	IFNULL(Direccion, Cadena_Vacia);
			SET	Var_Identi			:=	IFNULL(Var_Identi, Cadena_Vacia);
			SET	Var_NumIdenti		:=	IFNULL(Var_NumIdenti, Cadena_Vacia);
			SET	Var_FecVenId		:=	IFNULL(Var_FecVenId, Fecha_Vacia);

			SET	NomRef				:=	IFNULL(NomRef, Cadena_Vacia);
			SET	DomRef				:=	IFNULL(DomRef, Cadena_Vacia);
			SET	TelRef				:=	IFNULL(TelRef, Cadena_Vacia);
			SET	NomRef2				:=	IFNULL(NomRef2, Cadena_Vacia);
			SET	DomRef2				:=	IFNULL(DomRef2, Cadena_Vacia);
			SET	TelRef2				:=	IFNULL(TelRef2, Cadena_Vacia);

			SET	BancRef				:=	IFNULL(BancRef, Cadena_Vacia);
			SET	NoctaRef			:=	IFNULL(NoctaRef, Cadena_Vacia);
			SET	BancRef2			:=	IFNULL(BancRef2, Cadena_Vacia);
			SET	NoctaRef2			:=	IFNULL(NoctaRef2, Cadena_Vacia);

			SET	Var_DepositoCred	:=	IFNULL(Var_DepositoCred, Decimal_Cero);
			SET	Var_RetirosCargo	:=	IFNULL(Var_RetirosCargo, Decimal_Cero);
			SET	Var_ProcRecursos	:=	IFNULL(Var_ProcRecursos, Cadena_Vacia);
			SET	Var_UsoCta			:=	IFNULL(Var_UsoCta, Entero_Cero);
			SET	Var_OtrosDesc		:=	IFNULL(Var_OtrosDesc, Cadena_Vacia);
			SET	Var_ProvRecursos	:=	IFNULL(Var_ProvRecursos, Entero_Cero);
			SET	Var_ConcentFondo	:=	IFNULL(Var_ConcentFondo, Cadena_Vacia);
			SET	Var_AdmonGtosIng	:=	IFNULL(Var_AdmonGtosIng, Cadena_Vacia);
			SET	Var_CtaInversion	:=	IFNULL(Var_CtaInversion, Cadena_Vacia);
			SET	Var_PagoCreditos	:=	IFNULL(Var_PagoCreditos, Cadena_Vacia);
			SET	Var_OtroUso			:=	IFNULL(Var_OtroUso, Cadena_Vacia);
			SET	Var_DefineUso		:=	IFNULL(Var_DefineUso, Cadena_Vacia);
			SET	Var_PagoNomina		:=	IFNULL(Var_PagoNomina, Cadena_Vacia);
			SET	Var_RecursoProvProp	:=	IFNULL(Var_RecursoProvProp, Cadena_Vacia);
			SET	Var_RecursoProvTer	:=	IFNULL(Var_RecursoProvTer, Cadena_Vacia);
			SET Var_MediosElectronicos := IFNULL(Var_MediosElectronicos, Cadena_Vacia);

			SELECT	Cte, 				CtaAho,				Var_Titulo,			Var_TipoPersona,	NomCte,
					Var_CteApPat,		Var_CteApMat,		Var_FechaNac,		Var_EdoCivil,		Nacional,
					nRFC,				Var_Sexo,			ActBmx,				LugTrabajo,			DirecTrab,
					Puest,				Direccion,			Var_Identi,			Var_NumIdenti,		Var_FecVenId,
					NomRef,				DomRef,				TelRef,				NomRef2,			DomRef2,
					TelRef2,			BancRef,			NoctaRef,			BancRef2,			NoctaRef2,
					Var_DepositoCred,	Var_RetirosCargo,	Var_ProcRecursos,	Var_UsoCta,			Var_OtrosDesc,
					Var_ProvRecursos,	TelTrab,			Ocupacion,			Var_ConcentFondo,	Var_AdmonGtosIng,
					Var_CtaInversion,	Var_PagoCreditos,	Var_OtroUso,		Var_DefineUso,		Var_PagoNomina,
					Var_RecursoProvProp,Var_RecursoProvTer,	Var_MediosElectronicos AS MediosElectronicos
					;

		END IF;
	END IF;
END IF;

END TerminaStore$$