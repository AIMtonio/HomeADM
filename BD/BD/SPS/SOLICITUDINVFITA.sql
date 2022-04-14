DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICITUDINVFITA;
DELIMITER $$
CREATE PROCEDURE `SOLICITUDINVFITA`(


    Par_InversionID   		BIGINT(12),				
	Par_EmpresaID			INT(11),				
	Aud_Usuario				INT(11),				
	Aud_FechaActual			DATETIME,				
	Aud_DireccionIP			VARCHAR(15),			
	Aud_ProgramaID			VARCHAR(50),			
	Aud_Sucursal			INT(11),				
	Aud_NumTransaccion		BIGINT(20)				
)
TerminaStore: BEGIN

	DECLARE Var_ClienteID				BIGINT(12);
	DECLARE Var_Sucursal				VARCHAR(50);
    DECLARE Var_FechaIngreso   	  		DATE;
	DECLARE Var_TipoPersona         	VARCHAR(50);
    DECLARE Var_NombresCte				VARCHAR(100);
    DECLARE Var_ApellidoPaterno			VARCHAR(50);
    DECLARE Var_ApellidoMaterno			VARCHAR(50);
    DECLARE Var_FechaNacimiento	  		DATE;
    DECLARE Var_EdoNacimiento			VARCHAR(50);
    DECLARE Var_PaisNacimiento			VARCHAR(50);
    DECLARE Var_Nacionalidad			VARCHAR(50);
    DECLARE Var_Genero					VARCHAR(50);
    DECLARE Var_EdoCivil				VARCHAR(50);
    DECLARE Var_RegMatrimonial			VARCHAR(100);
    DECLARE Var_Ocupacion				VARCHAR(300);

    DECLARE Var_PaisResidencia			VARCHAR(100);
    DECLARE Var_CURP					VARCHAR(18);
    DECLARE Var_RegHacienda				CHAR(2);
    DECLARE Var_RFC						VARCHAR(13);
    DECLARE Var_PaisAsignaRFC			VARCHAR(100);
    DECLARE Var_FEA 					VARCHAR(50);
    DECLARE Var_TelefonoLoc				VARCHAR(10);
    DECLARE Var_TelefonoPart			VARCHAR(10);
    DECLARE Var_TelefonoCel				VARCHAR(10);
	DECLARE Var_CorreoElec				VARCHAR(50);
	DECLARE Var_Observaciones			VARCHAR(150);
	
	DECLARE Var_TipoIdentific			VARCHAR(50);
	DECLARE Var_NumIdentific			VARCHAR(50);
	DECLARE Var_VigIdentific			VARCHAR(50);
	
	DECLARE Var_EsPEP					CHAR(2);
	DECLARE Var_PaisPEP					VARCHAR(50);
	DECLARE Var_EdoPEP					VARCHAR(50);
	DECLARE Var_MuniPEP					VARCHAR(100);
	DECLARE Var_CargoPEP				VARCHAR(50);
	DECLARE Var_ConsultaPEP				VARCHAR(20);
	DECLARE Var_ClasifcPEP				VARCHAR(50);
	DECLARE Var_FamiliarPEP				CHAR(2);
	DECLARE Var_ParentezcoPEP			VARCHAR(50);
	DECLARE Var_ConsangPEP				VARCHAR(50);
	DECLARE Var_AfinidadPEP				VARCHAR(50);
	DECLARE Var_NombresFamPEP			VARCHAR(100);
	DECLARE Var_ApPatFamPEP				VARCHAR(50);
	DECLARE Var_ApMatFamPEP				VARCHAR(50);
	DECLARE Var_PaisFamPEP				VARCHAR(50);
	DECLARE Var_EdoFamPEP				VARCHAR(50);
	DECLARE Var_MuniFamPEP				VARCHAR(100);
	DECLARE Var_CargoFamPEP				VARCHAR(50);
	DECLARE Var_ConsulFamPEP			VARCHAR(20);
	DECLARE Var_ClasifcFamPEP			VARCHAR(20);
	
	DECLARE Var_TipoDirecc				VARCHAR(20);
	DECLARE Var_CalleDomPart			VARCHAR(50);
	DECLARE Var_NumExtDomPart			VARCHAR(10);
	DECLARE Var_NumIntDomPart			VARCHAR(10);
	DECLARE Var_PisoDomPart				VARCHAR(10);
	DECLARE Var_ColDomPart				VARCHAR(100);
	DECLARE Var_MunDomPart				VARCHAR(100);
	DECLARE Var_CiudadDomPart			VARCHAR(100);
	DECLARE Var_EdoDomPart				VARCHAR(50);
	DECLARE Var_CPDomPart				VARCHAR(5);
	DECLARE Var_PaisDomPart				VARCHAR(50);
	DECLARE Var_PrimCalleDomPart		VARCHAR(50);
	DECLARE Var_SegCalleDomPart			VARCHAR(50);
	DECLARE Var_LatitudDomPart			VARCHAR(50);
	DECLARE Var_LongitudDomPart			VARCHAR(50);
	DECLARE Var_TipoDomPart				VARCHAR(16);
	DECLARE Var_DescDomPart				VARCHAR(150);
	DECLARE Var_LoteDomPart				VARCHAR(10);
	DECLARE Var_ManzanaDomPart			VARCHAR(10);
	DECLARE Var_TipoPropDomPart			VARCHAR(500); -- IALDANA T_16137 Se homologa el tamaño de la variable por el de la tabla
	DECLARE Var_AntigDomPart			VARCHAR(50);

	DECLARE Var_CalleDomFisc			VARCHAR(50);
	DECLARE Var_NumExtDomFisc			VARCHAR(10);
	DECLARE Var_NumIntDomFisc			VARCHAR(10);
	DECLARE Var_ColDomFisc				VARCHAR(100);
	DECLARE Var_MunDomFisc				VARCHAR(100);
	DECLARE Var_CiudadDomFisc			VARCHAR(100);
	DECLARE Var_EdoDomFisc				VARCHAR(50);

	DECLARE Var_CalleDomExt				VARCHAR(50);
	DECLARE Var_NumExtDomExt			VARCHAR(10);
	DECLARE Var_NumIntDomExt			VARCHAR(10);
	DECLARE Var_ColDomExt				VARCHAR(100);
	DECLARE Var_MunDomExt				VARCHAR(100);
	DECLARE Var_CiudadDomExt			VARCHAR(100);
	DECLARE Var_EdoDomExt				VARCHAR(50);
	DECLARE Var_CPDomExt				VARCHAR(5);
	DECLARE Var_PaisDomExt				VARCHAR(50);

	DECLARE Var_Trabajo					VARCHAR(100);
	DECLARE Var_Puesto					VARCHAR(50);
	DECLARE Var_CtoTrabajo				VARCHAR(100);
	DECLARE Var_FechIniTrabajo			DATE;
	DECLARE Var_AntigTrabajo			VARCHAR(5);
	DECLARE Var_DireccTrabajo			VARCHAR(200);
	DECLARE Var_TelTrabajo				VARCHAR(200);

	DECLARE Var_ClasificCte				VARCHAR(50);
	DECLARE Var_MotAperCte				VARCHAR(50);
	DECLARE Var_SecGralCte				VARCHAR(250);
	DECLARE Var_ActBMXCte				VARCHAR(250);
	DECLARE Var_ActINEGICte				VARCHAR(250);
	DECLARE Var_ActFRCte				VARCHAR(250);
	DECLARE Var_ActFOMURCte				VARCHAR(250);
	DECLARE Var_SecEcoCte				VARCHAR(250);
	DECLARE Var_PagaIVACte				VARCHAR(2);
	DECLARE Var_PagaISRCte				VARCHAR(2);
    
	DECLARE Var_NombreCompleto			VARCHAR(300);

	DECLARE Var_PersRelCta				CHAR(2);
	DECLARE Var_PersRelCotCta			CHAR(1);
	DECLARE Var_PersRelAutCta			CHAR(1);
	DECLARE Var_PersRelPopRCta			CHAR(1);
	DECLARE Var_PersRelProvRCta			CHAR(1);

	DECLARE Var_NomPrimRefCte			VARCHAR(150);
	DECLARE Var_NumCtaPrimRefCte		VARCHAR(20);
	DECLARE Var_DirPrimRefCte			VARCHAR(150);
	DECLARE Var_TelPrimRefCte			VARCHAR(10);
	DECLARE Var_NomSegRefCte			VARCHAR(150);
	DECLARE Var_NumCtaSegRefCte			VARCHAR(20);
	DECLARE Var_DirSegRefCte			VARCHAR(150);
	DECLARE Var_TelSegRefCte			VARCHAR(10);
	DECLARE Var_BancoPrimRefCte			VARCHAR(150);
	DECLARE Var_TipoCtaPrimRefCte		VARCHAR(20);
	DECLARE Var_CtaPrimRefCte			VARCHAR(20);
	DECLARE Var_SucPrimRefCte			VARCHAR(100);
	DECLARE Var_TDCPrimRefCte			VARCHAR(18);
	DECLARE Var_InstPrimRefCte			VARCHAR(50);
	DECLARE Var_CredPrimRefCte			VARCHAR(2);
	DECLARE Var_InstCPrimRefCte			VARCHAR(50);
	DECLARE Var_BancoSegRefCte			VARCHAR(150);
	DECLARE Var_TipoCtaSegRefCte		VARCHAR(20);
	DECLARE Var_CtaSegRefCte			VARCHAR(20);
	DECLARE Var_SucSegRefCte			VARCHAR(100);
	DECLARE Var_TDCSegRefCte			VARCHAR(18);
	DECLARE Var_InstSegRefCte			VARCHAR(50);
	DECLARE Var_CredSegRefCte			VARCHAR(2);
	DECLARE Var_InstCSegRefCte			VARCHAR(50);
	DECLARE Var_NomPrimerRef			VARCHAR(150);
	DECLARE Var_DomPrimerRef			VARCHAR(150);
	DECLARE Var_TelPrimerRef			VARCHAR(150);
	DECLARE Var_RelPrimerRef			VARCHAR(150);
	DECLARE Var_NomSegunRef				VARCHAR(150);
	DECLARE Var_DomSegunRef				VARCHAR(150);
	DECLARE Var_TelSegunRef				VARCHAR(150);
	DECLARE Var_RelSegunRef				VARCHAR(150);

	DECLARE Var_NombreConyuge			VARCHAR(250);

	DECLARE Var_IngresoMes				DECIMAL(12,2);
	DECLARE Var_IngExtraMes				DECIMAL(12,2);
	DECLARE Var_IngOtrosMes				DECIMAL(12,2);
	
	DECLARE Var_EgAliment				DECIMAL(12,2);
	DECLARE Var_EgServicios				DECIMAL(12,2);
	DECLARE Var_EgEscuela				DECIMAL(12,2);
	DECLARE Var_EgCasa					DECIMAL(12,2);
	DECLARE Var_EgDeudas				DECIMAL(12,2);
	DECLARE Var_EgAhorros				DECIMAL(12,2);
	DECLARE Var_EgOtros					DECIMAL(12,2);

	DECLARE Var_DepCred					INT(10);
	DECLARE Var_RetCargos				INT(10);
	DECLARE Var_NumDep					INT(10);
	DECLARE Var_NumRet					INT(10);
	DECLARE Var_FrecDep					INT(10);
	DECLARE Var_FrecRet					INT(10);

	DECLARE Var_ProcRec					VARCHAR(150);
	DECLARE Var_ConcFondo				CHAR(1);
	DECLARE Var_AdmonGasIng				CHAR(1);
	DECLARE Var_PagoNom					CHAR(1);
	DECLARE Var_CtaInver				CHAR(1);
	DECLARE Var_PagoCred				CHAR(1);
	DECLARE Var_MediosElec				CHAR(1);
	DECLARE Var_FinOtros				CHAR(1);

	DECLARE Var_CtaPropia				CHAR(1);
	DECLARE Var_CtaTercero				CHAR(1);
	DECLARE Var_CtaApoderado			CHAR(1);

	DECLARE Var_FechSistema				DATE;
	DECLARE Var_NomCompCte				VARCHAR(200);
	DECLARE Var_EjecAperCta				VARCHAR(200);
	
	-- AJUSTE 
	DECLARE Var_RazonSocial VARCHAR(200);

DECLARE Var_FechaConstitucion DATE;
DECLARE Var_NombreNotario VARCHAR(200);
DECLARE Var_NumNotario INT;
DECLARE Var_InscripcionReg VARCHAR(200); 
DECLARE Var_EscrituraPubPM VARCHAR(50);
DECLARE Var_GrupoEmpresarial VARCHAR(200);
DECLARE Var_TipoSociedadDesc VARCHAR (200);

DECLARE Var_DescDir VARCHAR (200);
DECLARE Var_Accionista VARCHAR (200);
DECLARE Var_PresidenteConsejoAdmon VARCHAR (200);
DECLARE Var_SecretarioConsejoAdmon VARCHAR (200);
DECLARE Var_TesoreroConsejoAdmon VARCHAR (200);
DECLARE Var_Administrador VARCHAR (200);
DECLARE Var_DirectorGeneral VARCHAR (200);
DECLARE Var_FolioRegPub INT;
DECLARE Var_FechaEscPub DATE;
DECLARE Var_FechaVenEst DATE;
DECLARE TipoPersona CHAR(1);
DECLARE Var_FechaEsc DATE;
 DECLARE Var_Relacionado VARCHAR (20);
 DECLARE NombreRelacionado VARCHAR(500);
 DECLARE Var_Garante VARCHAR(20);
DECLARE Var_Aval VARCHAR(20);
DECLARE Var_ApellMatRel VARCHAR(200);
DECLARE Var_ApellPatRel VARCHAR (200);
 DECLARE Var_FechaNacRela DATE;
 DECLARE Var_EstadoRela VARCHAR(200);
 DECLARE Var_PaisRela VARCHAR(200);
 DECLARE Var_NacionRela VARCHAR (200);
 DECLARE Var_SexoRela VARCHAR(200);
 DECLARE Var_OcupacionRela VARCHAR(200);
 DECLARE Var_PaisResideRela VARCHAR(200);
 DECLARE Var_CURPRela VARCHAR(200);
 DECLARE Var_RegistroHaRela VARCHAR(200);
 DECLARE Var_NumIdentiRela VARCHAR(200);
 DECLARE Var_FEARela VARCHAR(200);
 DECLARE Var_PaisFEARela VARCHAR(200);
 DECLARE Var_RFCRela VARCHAR(200);
 DECLARE Var_TelefonoRela INT;
 DECLARE Var_TelefonoCelRela INT;
 DECLARE Var_CorreoRela VARCHAR(200);
 DECLARE Var_DescripcionRela VARCHAR(200);
 DECLARE Var_IdentifiRela VARCHAR(200);
 DECLARE Var_FechaVenIdenRela DATE;
DECLARE Var_PrimerNombreAccMay25 VARCHAR(200);
 DECLARE Var_SegundoNombreAccMay25 VARCHAR(200);
DECLARE Var_ApellidoMaternoAccMay25 VARCHAR(200);
DECLARE Var_ApellPatAccMay25 VARCHAR(200);
DECLARE Var_RFCAccMay25 VARCHAR(200);
DECLARE Var_RazonSocialAccMay25 VARCHAR(200);
DECLARE Var_RelacionadoAcciones INT;
DECLARE Var_GaranteAcciones INT;
DECLARE Var_AvalAcciones INT;
DECLARE Var_RazonSocialRela VARCHAR(200);

DECLARE Var_PresidenteConsejo VARCHAR(200);
DECLARE Var_TesoreroConsejo VARCHAR(200);
DECLARE Var_SecretarioConsejo VARCHAR(200);
DECLARE Var_OtroConsejo VARCHAR(200);
DECLARE Var_ConsejoRelacionado INT;
DECLARE Var_NombresConsejo VARCHAR(200);
DECLARE Var_ApellidoPaternoConsejo VARCHAR(200);
DECLARE Var_ApellidoMaternoConsejo VARCHAR(200);
DECLARE Var_ConsejoRelID INT;
DECLARE Var_ConsejoTeID INT;
DECLARE Var_NombresConsejoTeso VARCHAR(200);
DECLARE Var_ApellidoPaternoConsejoTeso VARCHAR(200);
DECLARE Var_ApellidoMaternoConsejoTeso VARCHAR (200);
DECLARE Var_ConsejoGarID  INT;
DECLARE Var_ConsejoAvalID INT;

 

	DECLARE		Var_NombRefCom VARCHAR(200);
	DECLARE Var_NombRefCom2 VARCHAR(200);
	DECLARE Var_TelRefCom VARCHAR(200);
	DECLARE Var_TelRefCom2 VARCHAR(200);
	DECLARE Var_NoCuentaRefCom VARCHAR(200);
	DECLARE Var_NoCuentaRefCom2 VARCHAR(200);
	DECLARE Var_DireccionRefCom VARCHAR(200);
	DECLARE Var_DireccionRefCom2 VARCHAR(200);
	DECLARE Var_ExtTelRefCom VARCHAR(200);
	DECLARE Var_ExtTelRefCom2 VARCHAR(200);
	DECLARE Var_BancoRef VARCHAR(200);
	DECLARE Var_BanTipoCuentaRef VARCHAR(200);
	DECLARE Var_NoCuentaRef VARCHAR(200);
	DECLARE Var_BanSucursalRef VARCHAR(200);
	DECLARE Var_BanNoTarjetaRef VARCHAR(200);
	DECLARE Var_BanTarjetaInsRef VARCHAR(200);
	DECLARE Var_BanCreOtraEnt1 VARCHAR(200);
	DECLARE Var_BanInsOtraEnt VARCHAR(200);
	DECLARE Var_BancoRef2 VARCHAR(200);
	DECLARE Var_NoCuentaRef2 VARCHAR(200);
	DECLARE Var_BanSucursalRef2 VARCHAR(200);
	DECLARE Var_BanNoTarjetaRef2 VARCHAR(200);
	DECLARE Var_BanTarjetaInsRef2 VARCHAR(200);
	DECLARE Var_CredOtraEnt2 VARCHAR(200);
	DECLARE Var_BanInsOtraEnt2 VARCHAR(200);
	DECLARE Var_NombreRef VARCHAR(200);
	DECLARE Var_DomicilioRef VARCHAR(200);
	DECLARE Var_TelefonoRef VARCHAR(200);
	DECLARE Var_extTelefonoRefUno VARCHAR(200);
	DECLARE Var_NombreRef2 VARCHAR(200);
	DECLARE Var_DomicilioRef2 VARCHAR(200);
	DECLARE Var_TelefonoRef2 VARCHAR(200);
	DECLARE Var_extTelefonoRefDos VARCHAR(200);
	DECLARE Var_PFuenteIng VARCHAR(200);
	DECLARE Var_Descripcion VARCHAR(200);


	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Entero_Cero					INT;
    DECLARE Entero_Uno					INT;
    DECLARE Entero_Dos					INT;
    DECLARE Fecha_Vacia					DATE;
	DECLARE Var_SI        				CHAR(1);
    DECLARE Var_NO        				CHAR(1);
    DECLARE Des_Si						CHAR(2);
    DECLARE Des_No						CHAR(2);
    DECLARE Nac_Mexicano    			CHAR(1);
    DECLARE Nac_Extranj					CHAR(1);
    DECLARE NNacional					VARCHAR(18);     	
    DECLARE NExtranjero					VARCHAR(18);
    DECLARE Gen_Masculino				CHAR(1);	
 	DECLARE	Gen_Femenino				CHAR(1);	
 	DECLARE	Des_GenMasc					VARCHAR(10);		
 	DECLARE	Des_GenFem					VARCHAR(10);

    DECLARE DirOficial					CHAR(1);
    DECLARE IdeOficial      			CHAR(1);
    DECLARE TipoPer_PF					CHAR(1);
    DECLARE TipoPer_PM					CHAR(1);
    DECLARE TipoPer_PA					CHAR(1);
    DECLARE Des_PF						VARCHAR(50);
    DECLARE Des_PM						VARCHAR(50);
    DECLARE Des_PA						VARCHAR(50);
    DECLARE Pais_NoEspec				VARCHAR(30);
    DECLARE Est_Soltero     			CHAR(1);
    DECLARE Est_CasBieSep				CHAR(2);
    DECLARE Est_CasBieMan   			CHAR(2);
    DECLARE Est_CasCapitu				CHAR(2);
    DECLARE Est_Viudo					CHAR(1);
    DECLARE Est_Divorciad				CHAR(1);
    DECLARE Est_Seperados				CHAR(2);
    DECLARE Est_UnionLibre				CHAR(1);
    DECLARE Des_Soltero					VARCHAR(50);
    DECLARE Des_CasBieSep				VARCHAR(50);
    DECLARE Des_CasBieMan				VARCHAR(50);
    DECLARE Des_CasCapitu				VARCHAR(50);
    DECLARE Des_Viudo					VARCHAR(50);
    DECLARE Des_Divorciad				VARCHAR(50);
    DECLARE Des_Seperados				VARCHAR(50);
    DECLARE Des_UnionLibre				VARCHAR(50);
	
    DECLARE ClasificI     				CHAR(1);
    DECLARE ClasificN     				CHAR(1);
    DECLARE ClasificE     				CHAR(1);
    DECLARE ClasificC     				CHAR(1);
    DECLARE ClasificR     				CHAR(1);
    DECLARE ClasificF     				CHAR(1);
    DECLARE ClasificM     				CHAR(1);
    DECLARE ClasificO     				CHAR(1);
    
    DECLARE Des_ClasificI				VARCHAR(30);
    DECLARE Des_ClasificN				VARCHAR(30);
    DECLARE Des_ClasificE				VARCHAR(30);
    DECLARE Des_ClasificC				VARCHAR(30);
    DECLARE Des_ClasificR				VARCHAR(35);
    DECLARE Des_ClasificF				VARCHAR(30);
    DECLARE Des_ClasificM				VARCHAR(30);
    DECLARE Des_ClasificO				VARCHAR(30);
    
    DECLARE MotivoAperUno     			INT;
    DECLARE MotivoAperDos     			INT;  
    DECLARE MotivoAperTres      		INT;
    DECLARE MotivoAperCuatro   			INT; 
    DECLARE MotivoAperCinco    			INT; 
    DECLARE MotivoAperSeis     			INT; 
    
    DECLARE Des_MotivoAperUno    		VARCHAR(30); 
    DECLARE Des_MotivoAperDos    		VARCHAR(30); 
    DECLARE Des_MotivoAperTres  		VARCHAR(30); 
    DECLARE Des_MotivoAperCuatro		VARCHAR(30); 
    DECLARE Des_MotivoAperCinco 		VARCHAR(30); 
    DECLARE Des_MotivoAperSeis			VARCHAR(30);
    
    DECLARE Var_X     					CHAR(1);
    DECLARE Est_Vigente					CHAR(1);

	
	SET Cadena_Vacia        	:= '';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
    SET Entero_Dos				:= 2;
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Var_SI        			:= 'S';
	SET Var_NO        			:= 'N';
	SET Des_Si					:= 'SI';
	SET Des_No					:= 'NO';
	SET Nac_Mexicano    		:= 'N';
	SET Nac_Extranj    			:= 'E';
	SET NNacional     			:= 'MEXICANA';
	SET NExtranjero    			:= 'EXTRANJERA';
	SET Gen_Masculino			:= 'M';
	SET Gen_Femenino			:= 'F';
	SET Des_GenMasc				:= 'MASCULINO';
	SET Des_GenFem				:= 'FEMENINO';
	SET DirOficial          	:= 'S';
	SET IdeOficial          	:= 'S';
	SET TipoPer_PF				:= 'F';
	SET TipoPer_PM				:= 'M';
	SET TipoPer_PA				:= 'A';
	SET Des_PF					:= 'PERSONA FÍSICA';
	SET Des_PM					:= 'PERSONA MORAL';
	SET Des_PA					:= 'PERSONA FÍSICA CON ACTIVIDAD EMPRESARIAL';
    SET Pais_NoEspec			:= 'INSUFICIENTEMENTE ESPECIFICADO';
	SET Est_Soltero       		:= 'S';
	SET Est_CasBieSep     		:= 'CS';
	SET Est_CasBieMan     		:= 'CM';
	SET Est_CasCapitu     		:= 'CC';
	SET Est_Viudo         		:= 'V';
	SET Est_Divorciad     		:= 'D';
	SET Est_Seperados     		:= 'SE';
	SET Est_UnionLibre    		:= 'U';
	SET Des_Soltero       		:= 'SOLTERO(A)';
	SET Des_CasBieSep     		:= 'CASADO(A) BIENES SEPARADOS';
	SET Des_CasBieMan     		:= 'CASADO(A) BIENES MANCOMUNADOS';
	SET Des_CasCapitu     		:= 'CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION';
	SET Des_Viudo         		:= 'VIUDO(A)';
	SET Des_Divorciad     		:= 'DIVORCIADO(A)';
	SET Des_Seperados     		:= 'SEPARADO(A)';
	SET Des_UnionLibre   		:= 'UNION LIBRE';
    SET ClasificI       		:= 'I';
    SET ClasificN       		:= 'N'; 
    SET ClasificE        		:= 'E';
    SET ClasificC        		:= 'C';
    SET ClasificR        		:= 'R';
    SET ClasificF        		:= 'F';
    SET ClasificM        		:= 'M';
    SET ClasificO        		:= 'O';
    SET Des_ClasificI			:= 'CLIENTE INDEPENDIENTE';
    SET Des_ClasificN			:= 'CLIENTE EMPRESA DE NOMINA';
    SET Des_ClasificE			:= 'CLIENTE EMPLEADO';
    SET Des_ClasificC			:= 'CLIENTE CORPORTATIVO';
    SET Des_ClasificR			:= 'CLIENTE RELACIONADO A CORPORATIVO';
    SET Des_ClasificF			:= 'CLIENTE NEGOCIO AFILIADO';
    SET Des_ClasificM			:= 'CLIENTE EMPLEADO DE NOMINA';
    SET Des_ClasificO			:= 'CLIENTE FUNCIONARIO';
    
    SET MotivoAperUno       	:= 1;
    SET MotivoAperDos       	:= 2; 
    SET MotivoAperTres    		:= 3;
    SET MotivoAperCuatro    	:= 4;
    SET MotivoAperCinco     	:= 5;
	SET MotivoAperSeis      	:= 6;

    SET Des_MotivoAperUno     	:= 'CREDITO';
    SET Des_MotivoAperDos     	:= 'RECOMENDADO';
    SET Des_MotivoAperTres    	:= 'PUBLICIDAD  CAMPAÑA PROMOCION';
    SET Des_MotivoAperCuatro  	:= 'NECESIDAD/ PROVEEDOR';
    SET Des_MotivoAperCinco   	:= 'CERCANIA DE SUCURSAL';
    SET Des_MotivoAperSeis		:= 'CUENTA DE CAPTACION';
    SET Var_X					:= 'X';
    SET Est_Vigente				:= 'V';
    

		SELECT  
			IFNULL(FechaSistema, Fecha_Vacia) AS FecdhaSis
			INTO	Var_FechSistema
		FROM 
			PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID;

        SELECT
			IFNULL(Cte.ClienteID, Entero_Cero),
            IFNULL(Suc.NombreSucurs, Cadena_Vacia),
            IFNULL(Cte.FechaAlta, Fecha_Vacia),
						-- AJUSTE
						IFNULL(Cte.RazonSocial,Cadena_Vacia), 
						IFNULL(Cte.TipoPersona,Cadena_Vacia) AS TipoPersona,
						-- FIN AJUSTE
			(CASE IFNULL(Cte.TipoPersona, Cadena_Vacia) WHEN TipoPer_PF THEN Des_PF
													   WHEN TipoPer_PM THEN Des_PM
                                                       WHEN TipoPer_PA THEN Des_PA END) AS TipoPersona,
            IFNULL(Cte.SoloNombres, Cadena_Vacia),
            IFNULL(Cte.ApellidoPaterno, Cadena_Vacia),
            IFNULL(Cte.ApellidoMaterno, Cadena_Vacia),
            IFNULL(Cte.FechaNacimiento, Fecha_Vacia),
            IFNULL(Edo.Nombre, Cadena_Vacia),
            IFNULL(P.Nombre, Cadena_Vacia) AS PaisNac, 
            (CASE IFNULL(Cte.Nacion,Cadena_Vacia) WHEN Nac_Mexicano THEN NNacional
												  WHEN Nac_Extranj THEN NExtranjero END) AS Nacionalidad,
            (CASE IFNULL(Cte.Sexo,Cadena_Vacia) WHEN Gen_Masculino THEN Des_GenMasc	
												WHEN Gen_Femenino  THEN Des_GenFem END) AS Genero,
            (CASE IFNULL(Cte.EstadoCivil,Cadena_Vacia)	WHEN Est_Soltero	 THEN Des_Soltero
														WHEN Est_CasBieSep	 THEN LEFT(Des_CasBieSep, 9)
														WHEN Est_CasBieMan	 THEN LEFT(Des_CasBieMan, 9)
														WHEN Est_CasCapitu  THEN LEFT(Des_CasCapitu, 9)
														WHEN Est_Viudo		 THEN Des_Viudo
														WHEN Est_Divorciad	 THEN Des_Divorciad
														WHEN Est_Seperados	 THEN Des_Seperados
														WHEN Est_UnionLibre THEN Des_UnionLibre END) AS EstadoCivil,
                                             
			(CASE IFNULL(Cte.EstadoCivil,Cadena_Vacia)	WHEN Est_CasBieSep	 THEN SUBSTRING(Des_CasBieSep, 11,16)
														WHEN Est_CasBieMan	 THEN SUBSTRING(Des_CasBieMan, 11,19)
														WHEN Est_CasCapitu   THEN SUBSTRING(Des_CasCapitu, 11,36) 
																 ELSE Cadena_Vacia END) AS Regimen,
            IFNULL(Ocp.Descripcion,Cadena_Vacia),
            IFNULL(Pai.Nombre,Cadena_Vacia),
            IFNULL(Cte.CURP,Cadena_Vacia),
            (CASE IFNULL(Cte.RegistroHacienda,Cadena_Vacia) WHEN Var_SI THEN Des_Si
															WHEN Var_NO THEN Des_No END) AS RegHacienda,
            IFNULL(Cte.RFCOficial,Cadena_Vacia),
            (CASE IFNULL(Pa.Nombre, Cadena_Vacia) WHEN Pais_NoEspec THEN Cadena_Vacia
												  ELSE Pa.Nombre END) AS PaisRFC,
            IFNULL(Cte.FEA,Cadena_Vacia),
            IFNULL(Cte.Telefono,Cadena_Vacia),
            IFNULL(Cte.Telefono,Cadena_Vacia),
            IFNULL(Cte.TelefonoCelular,Cadena_Vacia),
            IFNULL(Cte.Correo,Cadena_Vacia),
            IFNULL(Cte.Observaciones,Cadena_Vacia),
            (CASE IFNULL(Cte.Clasificacion,Cadena_Vacia) WHEN ClasificI THEN Des_ClasificI
														 WHEN ClasificN THEN Des_ClasificN
                                                         WHEN ClasificE THEN Des_ClasificE
                                                         WHEN ClasificC THEN Des_ClasificC
                                                         WHEN ClasificR THEN Des_ClasificR
                                                         WHEN ClasificF THEN Des_ClasificF
                                                         WHEN ClasificM THEN Des_ClasificM
                                                         WHEN ClasificO THEN Des_ClasificO END) AS Clasificacion,
            (CASE IFNULL(Cte.MotivoApertura,Entero_Cero) WHEN MotivoAperUno    THEN Des_MotivoAperUno   
														 WHEN MotivoAperDos    THEN Des_MotivoAperDos   
                                                         WHEN MotivoAperTres   THEN Des_MotivoAperTres  
                                                         WHEN MotivoAperCuatro THEN Des_MotivoAperCuatro
                                                         WHEN MotivoAperCinco  THEN Des_MotivoAperCinco 
                                                         WHEN MotivoAperSeis   THEN Des_MotivoAperSeis	END) AS MotivoApertura,
            IFNULL(Sct.Descripcion, Cadena_Vacia),
            IFNULL(Bmx.Descripcion, Cadena_Vacia),
            IFNULL(Ing.Descripcion, Cadena_Vacia),
            IFNULL(Fr.Descripcion,Cadena_Vacia),
            IFNULL(Fom.Descripcion,Cadena_Vacia),
            IFNULL(Sec.Descripcion,Cadena_Vacia),
            (CASE IFNULL(Cte.PagaIVA,Cadena_Vacia) WHEN Var_SI THEN Des_Si
                                                   WHEN Var_NO THEN Des_No END) AS PagaIva,
            (CASE IFNULL(Cte.PagaISR,Cadena_Vacia) WHEN Var_SI THEN Des_Si
                                                   WHEN Var_NO THEN Des_No END) AS PagaISR,
			IFNULL(Cte.Puesto,Cadena_Vacia),			IFNULL(Cte.LugardeTrabajo,Cadena_Vacia),	IFNULL(Cte.AntiguedadTra,Entero_Cero),
            IFNULL(Cte.DomicilioTrabajo,Cadena_Vacia),	IFNULL(Cte.TelTrabajo,Cadena_Vacia), 		IFNULL(Cte.NombreCompleto, Cadena_Vacia),
			IFNULL(Cte.FechaIniTrabajo,Fecha_Vacia),
			-- AJUSTE
			IFNULL(Cte.FechaConstitucion,Cadena_Vacia),
			IFNULL(Cte.NombreNotario,Cadena_Vacia),
			IFNULL(Cte.NumNotario,Entero_Cero),
			IFNULL(Cte.InscripcionReg,Cadena_Vacia),
			IFNULL(Cte.EscrituraPubPM,Entero_Cero)
		INTO	
            Var_ClienteID,			Var_Sucursal,			Var_FechaIngreso,     	Var_RazonSocial, TipoPersona, Var_TipoPersona,		Var_NombresCte,
            Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_FechaNacimiento,	Var_EdoNacimiento,		Var_PaisNacimiento,
            Var_Nacionalidad,		Var_Genero,				Var_EdoCivil,			Var_RegMatrimonial, 	Var_Ocupacion,
            Var_PaisResidencia,		Var_CURP,				Var_RegHacienda,		Var_RFC,				Var_PaisAsignaRFC,
            Var_FEA,				Var_TelefonoLoc,
            Var_TelefonoPart,		Var_TelefonoCel,		Var_CorreoElec,			Var_Observaciones,
            Var_ClasificCte, 		Var_MotAperCte, 		Var_SecGralCte, 		Var_ActBMXCte, 			Var_ActINEGICte,
            Var_ActFRCte,			Var_ActFOMURCte,		Var_SecEcoCte, 			Var_PagaIVACte,			Var_PagaISRCte,
            Var_Puesto,				Var_CtoTrabajo,			Var_AntigTrabajo,		Var_DireccTrabajo,		Var_TelTrabajo,
            Var_NombreCompleto,		Var_FechIniTrabajo, Var_FechaConstitucion, Var_NombreNotario, Var_NumNotario, Var_InscripcionReg, Var_EscrituraPubPM
		FROM
			INVERSIONES Inv
		INNER JOIN CLIENTES Cte ON Cte.ClienteID = Inv.ClienteID
        INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Cte.SucursalOrigen
        INNER JOIN ESTADOSREPUB Edo ON Edo.EstadoID = Cte.EstadoID
        INNER JOIN PAISES P ON P.PaisID = Cte.LugarNacimiento
        INNER JOIN PAISES Pa ON Pa.PaisID = Cte.PaisConstitucionID
        INNER JOIN PAISES Pai ON Pai.PaisID = Cte.PaisResidencia
        INNER JOIN SECTORES Sct ON Sct.SectorID = Cte.SectorGeneral
        INNER JOIN ACTIVIDADESBMX Bmx ON Bmx.ActividadBMXID = Cte.ActividadBancoMX
        INNER JOIN ACTIVIDADESINEGI Ing ON Ing.ActividadINEGIID = Cte.ActividadINEGI
        INNER JOIN ACTIVIDADESFR Fr ON Fr.ActividadFRID = Cte.ActividadFR
        INNER JOIN ACTIVIDADESFOMUR Fom ON Fom.ActividadFOMURID = Cte.ActividadFOMURID
        INNER JOIN SECTORESECONOM Sec ON Sec.SectorEcoID = Cte.SectorEconomico
        LEFT JOIN OCUPACIONES Ocp ON Ocp.OcupacionID = Cte.OcupacionID
		LEFT JOIN  TIPOSOCIEDAD Tip ON Tip.TipoSociedadID = Cte.TipoSociedadID
		WHERE Inv.InversionID = Par_InversionID;
        
		SELECT
			IFNULL(Tide.Nombre,Cadena_Vacia),	IFNULL(Ide.NumIdentific,Cadena_Vacia),	IFNULL(Ide.FecVenIden,Cadena_Vacia)
		INTO
            Var_TipoIdentific,					Var_NumIdentific,						Var_VigIdentific
		FROM 
			INVERSIONES Inv
		INNER JOIN IDENTIFICLIENTE Ide ON Ide.ClienteID = Inv.ClienteID
		INNER JOIN TIPOSIDENTI Tide ON Tide.TipoIdentiID = Ide.IdentificID
		WHERE Inv.InversionID = Par_InversionID
		LIMIT Entero_Uno;
        
    		SELECT 
			(CASE IFNULL(Ccte.PEPs,Cadena_Vacia) WHEN Var_SI THEN Des_Si
                                                 WHEN Var_NO THEN Des_No END) AS EsPEP,
            IFNULL(Fun.Descripcion,Cadena_Vacia),
            (CASE IFNULL(Ccte.ParentescoPEP,Cadena_Vacia) WHEN Var_SI THEN Des_Si
                                                          WHEN Var_NO THEN Des_No END) AS EsFamPEP,
            IFNULL(Ccte.NombFamiliar,Cadena_Vacia), 	IFNULL(Ccte.APaternoFam,Cadena_Vacia),
			IFNULL(Ccte.AMaternoFam,Cadena_Vacia),
            Ccte.NombRefCom,		Ccte.NoCuentaRefCom,	Ccte.DireccionRefCom,	Ccte.TelRefCom,
            Ccte.NombRefCom2,		Ccte.NoCuentaRefCom2,	Ccte.DireccionRefCom2,	Ccte.TelRefCom2,
            Ccte.BancoRef, 			Ccte.BanTipoCuentaRef, 	Ccte.NoCuentaRef, 		Ccte.BanSucursalRef,
            Ccte.BanNoTarjetaRef,	Ccte.BanTarjetaInsRef, 	Ccte.BanCredOtraEnt, 	Ccte.BanInsOtraEnt,
            Ccte.BancoRef2, 		Ccte.BanTipoCuentaRef2, Ccte.NoCuentaRef2, 		Ccte.BanSucursalRef2,
            Ccte.BanNoTarjetaRef2,	Ccte.BanTarjetaInsRef2, Ccte.BanCredOtraEnt2, 	Ccte.BanInsOtraEnt2,
            Ccte.NombreRef, 		Ccte.DomicilioRef, 		Ccte.TelefonoRef, 		Ccte.TipoRelacion1,
            Ccte.NombreRef2, 		Ccte.DomicilioRef2, 	Ccte.TelefonoRef2, 		Ccte.TipoRelacion2
		INTO
			Var_EsPEP,				Var_CargoPEP,			Var_FamiliarPEP,	Var_NombresFamPEP,		Var_ApPatFamPEP,
            Var_ApMatFamPEP,
            Var_NomPrimRefCte,		Var_NumCtaPrimRefCte,	Var_DirPrimRefCte,		Var_TelPrimRefCte,		Var_NomSegRefCte,
            Var_NumCtaSegRefCte,	Var_DirSegRefCte,		Var_TelSegRefCte,		Var_BancoPrimRefCte,	Var_TipoCtaPrimRefCte,
            Var_CtaPrimRefCte,		Var_SucPrimRefCte,		Var_TDCPrimRefCte,		Var_InstPrimRefCte,		Var_CredPrimRefCte,
            Var_InstCPrimRefCte,	Var_BancoSegRefCte,		Var_TipoCtaSegRefCte,	Var_CtaSegRefCte,		Var_SucSegRefCte,
            Var_TDCSegRefCte,		Var_InstSegRefCte, 		Var_CredSegRefCte,		Var_InstCSegRefCte,		Var_NomPrimerRef,
            Var_DomPrimerRef,		Var_TelPrimerRef,		Var_RelPrimerRef,		Var_NomSegunRef,		Var_DomSegunRef,
            Var_TelSegunRef,		Var_RelSegunRef
            
        FROM
		INVERSIONES Inv
		INNER JOIN CONOCIMIENTOCTE Ccte ON Ccte.ClienteID = Inv.ClienteID
		LEFT JOIN FUNCIONESPUB Fun ON Fun.FuncionID = Ccte.FuncionID
		WHERE Inv.InversionID = Par_InversionID;  

        SELECT 
			(CASE WHEN IFNULL(MAX(Cper.CuentaAhoID),Entero_Cero) <> 0 THEN Des_Si ELSE Des_No END) AS PersRelac, 
            (CASE WHEN IFNULL(MAX(Cper.EsCotitular),Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS Cotitular, 
            (CASE WHEN IFNULL(MAX(Cper.EsFirmante),Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS Firmante,
            (CASE WHEN IFNULL(MAX(Cper.EsPropReal),Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS PropReal,
            (CASE WHEN IFNULL(MAX(Cper.EsProvRecurso),Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS ProvRec,
            (CASE WHEN IFNULL(MAX(Cper.EsApoderado),Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS Apoder
            
		INTO
			Var_PersRelCta,		Var_PersRelCotCta,	Var_PersRelAutCta,	Var_PersRelPopRCta,	Var_PersRelProvRCta,
            Var_CtaApoderado
		FROM
			INVERSIONES Inv
		INNER JOIN CUENTASPERSONA Cper ON Cper.CuentaAhoID = Inv.CuentaAhoID AND Cper.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID
		AND Cper.EstatusRelacion = Est_Vigente;
        
		SELECT 
			IFNULL(Tipd.Descripcion,Cadena_Vacia),		IFNULL(Dir.Calle,Cadena_Vacia), 			IFNULL(Dir.NumeroCasa,Cadena_Vacia), 		IFNULL(Dir.NumInterior,Cadena_Vacia), 
			IFNULL(Dir.Piso,Cadena_Vacia), 				IFNULL(CONCAT(Col.TipoAsenta,Cadena_Vacia,Col.Asentamiento,Cadena_Vacia),Cadena_Vacia), IFNULL(Mun.Nombre,Cadena_Vacia),
            IFNULL(Loc.NombreLocalidad,Cadena_Vacia),	IFNULL(Edo.Nombre,Cadena_Vacia),			IFNULL(CodigoPostal,Cadena_Vacia),
            Cadena_Vacia,								IFNULL(Dir.PrimeraEntreCalle,Cadena_Vacia), IFNULL(Dir.SegundaEntreCalle,Cadena_Vacia), 	IFNULL(Dir.Latitud,Cadena_Vacia),
            IFNULL(Dir.Longitud,Cadena_Vacia),
            (CASE WHEN IFNULL(Dir.Oficial,Cadena_Vacia) = Var_SI AND IFNULL(Dir.Fiscal,Cadena_Vacia) = Var_SI THEN 'OFICIAL / FISCAL'
				  WHEN IFNULL(Dir.Oficial,Cadena_Vacia) = Var_SI AND (IFNULL(Dir.Fiscal,Cadena_Vacia) = Cadena_Vacia OR IFNULL(Dir.Fiscal,Cadena_Vacia) = Var_NO) THEN 'OFICIAL'
                  WHEN (IFNULL(Dir.Oficial,Cadena_Vacia) = Cadena_Vacia OR IFNULL(Dir.Oficial,Cadena_Vacia) = Var_NO) AND IFNULL(Dir.Fiscal,Cadena_Vacia) = Var_SI THEN 'FISCAL'
                  ELSE Cadena_Vacia END) AS TipoDomPart,
			IFNULL(Dir.Descripcion,Cadena_Vacia),	IFNULL(Dir.Lote,Cadena_Vacia),				IFNULL(Dir.Manzana,Cadena_Vacia)
            
        INTO    
            Var_TipoDirecc,							Var_CalleDomPart,						Var_NumExtDomPart,						Var_NumIntDomPart,
            Var_PisoDomPart,						Var_ColDomPart, 						Var_MunDomPart, 						Var_CiudadDomPart,
            Var_EdoDomPart,							Var_CPDomPart,							Var_PaisDomPart,						Var_PrimCalleDomPart,
            Var_SegCalleDomPart,					Var_LatitudDomPart,						Var_LongitudDomPart,					Var_TipoDomPart,
            Var_DescDomPart,						Var_LoteDomPart,						Var_ManzanaDomPart												
		FROM 
			INVERSIONES Inv
		INNER JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Inv.ClienteID
		INNER JOIN TIPOSDIRECCION Tipd ON Tipd.TipoDireccionID = Dir.TipoDireccionID
		INNER JOIN ESTADOSREPUB Edo	ON Edo.EstadoID = Dir.EstadoID
		INNER JOIN MUNICIPIOSREPUB Mun ON Mun.MunicipioID = Dir.MunicipioID AND Mun.EstadoID = Dir.EstadoID
		INNER JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Dir.LocalidadID AND Loc.MunicipioID = Dir.MunicipioID AND Loc.EstadoID = Dir.EstadoID
		INNER JOIN COLONIASREPUB Col ON  Col.ColoniaID = Dir.ColoniaID AND Col.EstadoID = Dir.EstadoID AND Col.MunicipioID = Dir.MunicipioID
		WHERE Inv.InversionID = Par_InversionID
        AND Tipd.TipoDireccionID = Entero_Uno;
        
		SELECT 
			IFNULL(S.Descripcion,Cadena_Vacia) AS Descripcion , ROUND(IFNULL(S.TiempoHabitarDom,Entero_Cero)/12,0) AS AntDom
		INTO
			Var_TipoPropDomPart,				Var_AntigDomPart
		FROM 
			INVERSIONES Inv
		INNER JOIN SOCIODEMOVIVIEN S ON S.ClienteID = Inv.ClienteID
        INNER JOIN TIPOVIVIENDA T ON T.TipoViviendaID = S.TipoViviendaID
		WHERE Inv.InversionID = Par_InversionID;
        
		SELECT 
			IFNULL(Dir.Calle,Cadena_Vacia), 		IFNULL(Dir.NumeroCasa,Cadena_Vacia), 		IFNULL(Dir.NumInterior,Cadena_Vacia), 
			IFNULL(CONCAT(Col.TipoAsenta,Cadena_Vacia,	Col.Asentamiento,Cadena_Vacia),Cadena_Vacia),
            IFNULL(Mun.Nombre,Cadena_Vacia),		IFNULL(Loc.NombreLocalidad,Cadena_Vacia),	IFNULL(Edo.Nombre,Cadena_Vacia)
            
        INTO    
			Var_CalleDomFisc,	Var_NumExtDomFisc, 	Var_NumIntDomFisc,	Var_ColDomFisc,	Var_MunDomFisc,
            Var_CiudadDomFisc, 	Var_EdoDomFisc															
		FROM 
			INVERSIONES Inv
		LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Inv.ClienteID
		INNER JOIN TIPOSDIRECCION Tipd ON Tipd.TipoDireccionID = Dir.TipoDireccionID
		INNER JOIN ESTADOSREPUB Edo	ON Edo.EstadoID = Dir.EstadoID
		INNER JOIN MUNICIPIOSREPUB Mun ON Mun.MunicipioID = Dir.MunicipioID AND Mun.EstadoID = Dir.EstadoID
		INNER JOIN LOCALIDADREPUB Loc ON Loc.LocalidadID = Dir.LocalidadID AND Loc.MunicipioID = Dir.MunicipioID AND Loc.EstadoID = Dir.EstadoID
		INNER JOIN COLONIASREPUB Col ON  Col.ColoniaID = Dir.ColoniaID AND Col.EstadoID = Dir.EstadoID AND Col.MunicipioID = Dir.MunicipioID
		WHERE Inv.InversionID = Par_InversionID
        AND Tipd.TipoDireccionID = Entero_Dos;
        
		SELECT
			SUM(D.Monto) 
        INTO 
			Var_IngresoMes
		FROM 
			INVERSIONES Inv
		INNER JOIN CLIDATSOCIOE D ON Inv.ClienteID = D.ClienteID        
        WHERE Inv.InversionID = Par_InversionID
        AND D.CatSocioEID = 1;

		SELECT 
			SUM(D.Monto) 
		INTO
			Var_IngExtraMes
        FROM 
			INVERSIONES Inv
		INNER JOIN CLIDATSOCIOE D ON Inv.ClienteID = D.ClienteID        
        WHERE Inv.InversionID = Par_InversionID
        AND D.CatSocioEID = 4;

		SELECT 
			SUM(D.Monto)
		INTO 
			Var_IngOtrosMes
		FROM 
			INVERSIONES Inv
		INNER JOIN CLIDATSOCIOE D ON Inv.ClienteID = D.ClienteID        
        WHERE Inv.InversionID = Par_InversionID
        AND D.CatSocioEID IN (2,3,5,6,7,8);

		SELECT 
			SUM(D.Monto)
		INTO 
			Var_EgAliment
		FROM 
			INVERSIONES Inv
		INNER JOIN CLIDATSOCIOE D ON Inv.ClienteID = D.ClienteID        
        WHERE Inv.InversionID = Par_InversionID        
        AND CatSocioEID = 9;
		
		SELECT 
			SUM(D.Monto)
		INTO 
			Var_EgServicios
		FROM 
			INVERSIONES Inv
		INNER JOIN CLIDATSOCIOE D ON Inv.ClienteID = D.ClienteID        
        WHERE Inv.InversionID = Par_InversionID
        AND D.CatSocioEID IN (15,16,17,18,19,20);
		
		SELECT 
			SUM(D.Monto)
		INTO 
			Var_EgEscuela
		FROM 
			INVERSIONES Inv
		INNER JOIN CLIDATSOCIOE D ON Inv.ClienteID = D.ClienteID        
        WHERE Inv.InversionID = Par_InversionID
        AND D.CatSocioEID = 10;
		
		SELECT 
			SUM(D.Monto)
		INTO 
			Var_EgCasa
		FROM 
			INVERSIONES Inv
		INNER JOIN CLIDATSOCIOE D ON Inv.ClienteID = D.ClienteID        
        WHERE Inv.InversionID = Par_InversionID
        AND D.CatSocioEID IN (11,22,23);
		
		SELECT 
			SUM(D.Monto)
		INTO 
			Var_EgOtros
		FROM 
			INVERSIONES Inv
		INNER JOIN CLIDATSOCIOE D ON Inv.ClienteID = D.ClienteID        
        WHERE Inv.InversionID = Par_InversionID
        AND D.CatSocioEID IN (12,13);
        
        SELECT
			IFNULL(FNGENNOMBRECOMPLETO(Con.PrimerNombre, Con.SegundoNombre, Con.TercerNombre, Con.ApellidoPaterno, Con.ApellidoMaterno),Cadena_Vacia)
		INTO
			Var_NombreConyuge
		FROM
			INVERSIONES Inv
		LEFT JOIN SOCIODEMOCONYUG Con ON Con.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;

        SELECT
			IFNULL(Us.NombreCompleto,Cadena_Vacia)
		INTO
			Var_EjecAperCta
		FROM
			INVERSIONES Inv
		INNER JOIN USUARIOS Us ON Us.UsuarioID = Inv.Usuario
        WHERE Inv.InversionID = Par_InversionID;

        SELECT 
			IFNULL(Per.DepositosMax,Entero_Cero), 	IFNULL(Per.RetirosMax,Entero_Cero), 		IFNULL(Per.NumDepositos,Entero_Cero), 			IFNULL(Per.NumRetiros,Entero_Cero), 	IFNULL(Con.FrecDepositos,Entero_Cero),
            IFNULL(Con.FrecRetiros,Entero_Cero), 			IFNULL(Con.ProcRecursos,Cadena_Vacia),
            (CASE WHEN IFNULL(Con.ConcentFondo,Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS ConFondo,
            (CASE WHEN IFNULL(Con.AdmonGtosIng,Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS AdmonGtos,
            (CASE WHEN IFNULL(Con.PagoNomina,Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS PagoNomina,
            (CASE WHEN IFNULL(Con.CtaInversion,Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS CtaInv,
            (CASE WHEN IFNULL(Con.PagoCreditos,'') = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS PagCre,
            (CASE WHEN IFNULL(Con.MediosElectronicos,Cadena_Vacia) = Var_SI THEN Var_X ELSE Cadena_Vacia END) AS MedElec,
			IFNULL(Con.DefineUso,Cadena_Vacia),
            (CASE WHEN IFNULL(Con.RecursoProvProp,Cadena_Vacia) IN (Var_SI, 'P') THEN Var_X ELSE Cadena_Vacia END) AS RecProp,
            (CASE WHEN IFNULL(Con.RecursoProvTer,Cadena_Vacia) IN (Var_SI, 'P') THEN Var_X ELSE Cadena_Vacia END) AS RecTerc
		INTO
       		Var_DepCred,	Var_RetCargos,	Var_NumDep,		Var_NumRet,			Var_FrecDep,
            Var_FrecRet,	Var_ProcRec,	Var_ConcFondo,	Var_AdmonGasIng,	Var_PagoNom,
            Var_CtaInver,	Var_PagoCred,	Var_MediosElec,	Var_FinOtros,		Var_CtaPropia,
			Var_CtaTercero																		
        FROM 
			INVERSIONES Inv
        LEFT JOIN PLDPERFILTRANS Per ON Per.ClienteID = Inv.ClienteID
        LEFT JOIN CONOCIMIENTOCTA Con ON Con.CuentaAhoID = Inv.CuentaAhoID
        WHERE Inv.InversionID = Par_InversionID;
 
		-- AJUSTE
		SELECT NombreGrupo,Descripcion 
		INTO Var_GrupoEmpresarial,Var_TipoSociedadDesc
		FROM INVERSIONES Inv
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = Inv.ClienteID
		INNER JOIN GRUPOSEMP GRU ON GRU.GrupoEmpID = CLI.GrupoEmpresarial
		INNER JOIN TIPOSOCIEDAD TIP ON TIP.TipoSociedadID = CLI.TipoSOciedadID
		WHERE Inv.InversionID = Par_InversionID;
 
 		SELECT 
			(CASE WHEN IFNULL(DIR.DirectivoID,Cadena_Vacia) <> 0  THEN Des_Si ELSE Des_No END) AS Directivo, 
		(CASE WHEN IFNULL(DIR.DirectivoID,Cadena_Vacia) = 1 THEN Var_X ELSE Cadena_Vacia END) AS Accionista,
		(CASE WHEN IFNULL(DIR.DirectivoID,Cadena_Vacia) = 2 THEN Var_X ELSE Cadena_Vacia END) AS PresidenteConsejoAdmon,
		(CASE WHEN IFNULL(DIR.DirectivoID,Cadena_Vacia) = 3 THEN Var_X ELSE Cadena_Vacia END) AS SecretarioConsejoAdmon,
		(CASE WHEN IFNULL(DIR.DirectivoID,Cadena_Vacia) = 4 THEN Var_X ELSE Cadena_Vacia END) AS TesoreroConsejoAdmon,
		(CASE WHEN IFNULL(DIR.DirectivoID,Cadena_Vacia) = 5 THEN Var_X ELSE Cadena_Vacia END) AS Administrador,
		(CASE WHEN IFNULL(DIR.DirectivoID,Cadena_Vacia) = 6 THEN Var_X ELSE Cadena_Vacia END) AS DirectorGeneral
			INTO
       		Var_DescDir,	Var_Accionista,	Var_PresidenteConsejoAdmon,		Var_SecretarioConsejoAdmon,			Var_TesoreroConsejoAdmon,
            Var_Administrador,	Var_DirectorGeneral
		FROM
		INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		INNER JOIN CATCARGOS CAT ON DIR.DirectivoID = CAT.CargoID 
		WHERE Inv.InversionID = Par_InversionID;

		SELECT ESC.FolioRegPub, ESC.FechaEsc
		INTO Var_FolioRegPub, Var_FechaEsc
		FROM INVERSIONES Inv 
		INNER JOIN ESCRITURAPUB ESC ON ESC.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID
        AND ESC.Estatus = Est_Vigente;
		
		SELECT FechaEscPub,FechaVenEst
		INTO Var_FechaEscPub, Var_FechaVenEst
		FROM INVERSIONES Inv 
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;

		-- DATOS DE RELACIONADOS EN DIRECTIVOS
 
		SELECT 
		(CASE WHEN IFNULL(RelacionadoID,0) <> 0 AND EsApoderado = 'S' THEN RelacionadoID ELSE 'N' END) AS Relacionado
		INTO Var_Relacionado
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;

		SELECT 
		(CASE WHEN IFNULL(GaranteID,0) <> 0 AND EsApoderado = 'S' THEN GaranteID ELSE 'N' END) AS Relacionado
		INTO Var_Garante
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;

		SELECT 
		(CASE WHEN IFNULL(AvalID,0) <> 0 AND EsApoderado = 'S' THEN AvalID ELSE 'N' END) AS Relacionado
		INTO Var_Aval
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;


-- REFERENCIAS CLIENTE
/*
				SELECT NombRefCom,NombRefCom2,TelRefCom,TelRefCom2,NoCuentaRefCom,NoCuentaRefCom2,DireccionRefCom,DireccionRefCom2,ExtTelRefCom,ExtTelRefCom2,
					BancoRef,BanTipoCuentaRef	,NoCuentaRef,BanSucursalRef,BanNoTarjetaRef,BanTarjetaInsRef,IF(BanCredOtraEnt='N','NO','SI'),BanInsOtraEnt,
				BancoRef2,NoCuentaRef2,
					NoCuentaRef2,BanTipoCuentaRef2,BanSucursalRef2,BanNoTarjetaRef2,BanTarjetaInsRef2,IF(BanCredOtraEnt2='N','NO','SI'),BanInsOtraEnt2,
				NombreRef,DomicilioRef,TelefonoRef,extTelefonoRefUno,NombreRef2,DomicilioRef2,TelefonoRef2,extTelefonoRefDos,PFuenteIng,TIP.Descripcion
				INTO
				Var_NombRefCom,Var_NombRefCom2,Var_TelRefCom,Var_TelRefCom2,Var_NoCuentaRefCom,Var_NoCuentaRefCom2,Var_DireccionRefCom,Var_DireccionRefCom2,Var_ExtTelRefCom,Var_ExtTelRefCom2,
				Var_BancoRef,Var_BanTipoCuentaRef,Var_NoCuentaRef,Var_BanSucursalRef,Var_BanNoTarjetaRef,Var_BanTarjetaInsRef,Var_BanCreOtraEnt1,Var_BanInsOtraEnt,Var_BancoRef2,Var_NoCuentaRef2,Var_BanSucursalRef2,Var_BanNoTarjetaRef2,Var_BanTarjetaInsRef2,Var_CredOtraEnt2,Var_BanInsOtraEnt2,Var_NombreRef,Var_DomicilioRef,Var_TelefonoRef,Var_extTelefonoRefUno,Var_NombreRef2,Var_DomicilioRef2,Var_TelefonoRef2,Var_extTelefonoRefDos,Var_PFuenteIng,Var_Descripcion
				FROM CUENTASAHO CUE
					INNER JOIN CONOCIMIENTOCTE CON ON CON.ClienteID = CUE.ClienteID
					INNER JOIN TIPORELACIONES TIP ON TIP.TipoRelacionID = CON.TipoRelacion1
				WHERE CuentaAhoID = Par_CuentaAhoID;
 
 */
		IF (Var_Relacionado != 'N') THEN
			SELECT CONCAT(CLI.PrimerNombre,' ',CLI.SegundoNombre),CLI.ApellidoMaterno,CLI.ApellidoPaterno,CLI.FechaNacimiento,EST.Nombre,PAI.Nombre,IF(CLI.Nacion = 'N','NACIONAL','EXTRANJERO'),IF(CLI.Sexo = 'H','HOMBRE','MUJER'),OCU.Descripcion,PAI.Nombre,CLI.CURP,IF(CLI.RegistroHacienda = 'N','NO','SI'),IDE.NumIdentific,CLI.FEA,CLI.PaisFea,CLI.RFC,CLI.Telefono,CLI.TelefonoCelular,CLI.Correo,CLI.Observaciones,TIP.Nombre ,IDE.FecVenIden, CLI.RazonSocial
			INTO NombreRelacionado, Var_ApellMatRel, Var_ApellPatRel , Var_FechaNacRela ,  Var_EstadoRela ,  Var_PaisRela , Var_NacionRela , Var_SexoRela ,  Var_OcupacionRela,  Var_PaisResideRela ,  Var_CURPRela ,  Var_RegistroHaRela ,  Var_NumIdentiRela,  Var_FEARela ,  Var_PaisFEARela ,  Var_RFCRela ,  Var_TelefonoRela,  Var_TelefonoCelRela,  Var_CorreoRela ,  Var_DescripcionRela ,  Var_IdentifiRela ,  Var_FechaVenIdenRela, Var_RazonSocialRela
			FROM CLIENTES CLI INNER JOIN DIRECTIVOS DIR ON DIR.RelacionadoID = CLI.CLienteID
			INNER JOIN PAISES PAI ON PAI.PaisID = CLI.PaisResidencia
			INNER JOIN ESTADOSREPUB EST ON EST.EstadoID = CLI.EstadoID
			INNER JOIN OCUPACIONES OCU ON OCU.OcupacionID = CLI.OCupacionID
			INNER JOIN IDENTIFICLIENTE IDE ON IDE.ClienteID = CLI.ClienteID
			INNER JOIN TIPOSIDENTI TIP ON TIP.TipoIdentiID = IdentificID
			WHERE RelacionadoID = Var_Relacionado;
		ELSE IF (Var_Garante !='N') THEN
			SELECT CONCAT(GAR.PrimerNombre,' ',GAR.SegundoNombre) ,GAR.ApellidoMaterno,GAR.ApellidoPaterno 
            INTO NombreRelacionado, Var_ApellMatRel, Var_ApellPatRel 
            FROM GARANTES GAR 
            INNER JOIN DIRECTIVOS DIR ON DIR.GaranteID = GAR.GaranteID 
            WHERE GAR.GaranteID = Var_Garante;
		ELSE IF (Var_Aval != 'N') THEN
			SELECT CONCAT (AVA.PrimerNombre, ' ',AVA.SegundoNombre),AVA.ApellidoMaterno,AVA.ApellidoPaterno 
            INTO NombreRelacionado, Var_ApellMatRel, Var_ApellPatRel 
            FROM AVALES AVA 
            INNER JOIN DIRECTIVOS DIR ON AVA.AvalID = DIR.AvalID 
            WHERE DIR.AvalID = Var_Aval;
		END IF;
		END IF;
		END IF;
 
-- INFORMACION ACCIONISTA
  
		SELECT 
		(CASE WHEN IFNULL(RelacionadoID,0) <> 0 AND PorcentajeAcciones >= 25 THEN RelacionadoID ELSE 'N' END) AS Relacionado
		INTO Var_RelacionadoAcciones
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;

		SELECT 
		(CASE WHEN IFNULL(GaranteID,0) <> 0 AND PorcentajeAcciones >= 25 THEN GaranteID ELSE 'N' END) AS Relacionado
		INTO Var_GaranteAcciones 
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;

		SELECT 
		(CASE WHEN IFNULL(AvalID,0) <> 0 AND PorcentajeAcciones >= 25 THEN AvalID ELSE 'N' END) AS Relacionado
		INTO Var_AvalAcciones
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;

 		IF (Var_RelacionadoAcciones != 'N') THEN
			SELECT CLI.PrimerNombre,CLI.SegundoNombre,CLI.ApellidoMaterno,CLI.ApellidoPaterno,CLI.RFC,CLI.RazonSocial 
			INTO Var_PrimerNombreAccMay25,Var_SegundoNombreAccMay25,  Var_ApellidoMaternoAccMay25, Var_ApellPatAccMay25 , Var_RFCAccMay25, Var_RazonSocialAccMay25
			FROM CLIENTES CLI INNER JOIN DIRECTIVOS DIR ON DIR.RelacionadoID = CLI.CLienteID
			INNER JOIN PAISES PAI ON PAI.PaisID = CLI.PaisResidencia
			INNER JOIN ESTADOSREPUB EST ON EST.EstadoID = CLI.EstadoID
			INNER JOIN OCUPACIONES OCU ON OCU.OcupacionID = CLI.OCupacionID
			INNER JOIN IDENTIFICLIENTE IDE ON IDE.ClienteID = CLI.ClienteID
			INNER JOIN TIPOSIDENTI TIP ON TIP.TipoIdentiID = IdentificID
			WHERE RelacionadoID = Var_RelacionadoAcciones;
		ELSE IF (Var_Garante !='N') THEN
			SELECT CONCAT(GAR.PrimerNombre,' ',GAR.SegundoNombre) ,GAR.ApellidoMaterno,GAR.ApellidoPaterno 
			INTO NombreRelacionado, Var_ApellMatRel, Var_ApellPatRel 
			FROM GARANTES GAR 
			INNER JOIN DIRECTIVOS DIR ON DIR.GaranteID = GAR.GaranteID 
			WHERE GAR.GaranteID = Var_Garante;
		ELSE IF (Var_Aval != 'N') THEN
			SELECT CONCAT (AVA.PrimerNombre, ' ',AVA.SegundoNombre),AVA.ApellidoMaterno,AVA.ApellidoPaterno 
			INTO NombreRelacionado, Var_ApellMatRel, Var_ApellPatRel 
			FROM AVALES AVA 
			INNER JOIN DIRECTIVOS DIR ON AVA.AvalID = DIR.AvalID 
			WHERE DIR.AvalID = Var_Aval;
		END IF;
		END IF;
		END IF; 
 
		 -- ESTRUCTURA ORGANIZACIONAL
		-- relacionado
		SELECT (CASE WHEN IFNULL(RelacionadoID,0) <> 0 THEN RelacionadoID ELSE 'N' END) AS ConsejoRelacionadoID
		INTO Var_ConsejoRelID
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;

		-- garante
		SELECT 
		(CASE WHEN IFNULL(GaranteID,0) <> 0 THEN GaranteID ELSE 'N' END) AS Relacionado
		INTO Var_ConsejoGarID 
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;

		-- aval
		SELECT 
		(CASE WHEN IFNULL(AvalID,0) <> 0 AND PorcentajeAcciones >= 25 THEN AvalID ELSE 'N' END) AS Relacionado
		INTO Var_ConsejoAvalID
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID;
 
		SELECT 
		(CASE WHEN IFNULL(RelacionadoID,0) <> 0 AND CargoID = 4 THEN IFNULL(Var_TesoreroConsejo,1) ELSE 'N' END) AS Tesorero,
		(CASE WHEN IFNULL(RelacionadoID,0) <> 0 AND CargoID = 3 THEN IFNULL(Var_SecretarioConsejo,1) ELSE 'N' END) AS Secretario,
		(CASE WHEN IFNULL(RelacionadoID,0) <> 0 AND CargoID = 2 THEN IFNULL(Var_PresidenteConsejo,1) ELSE 'N' END) AS Presidente,
		(CASE WHEN IFNULL(RelacionadoID,0) <> 0 AND CargoID = 1 OR 5 OR 6 THEN IFNULL(Var_OtroConsejo,1 )ELSE 'N' END) AS OtroMiembroConsejo
		INTO Var_TesoreroConsejo,Var_SecretarioConsejo,Var_PresidenteConsejo,Var_OtroConsejo
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID AND RelacionadoID = Var_ConsejoRelID;

		SELECT
		(CASE WHEN IFNULL(GaranteID,0) <> 0 AND CargoID = 4 THEN IFNULL(Var_TesoreroConsejo,1) ELSE 'N' END) AS Tesorero,
		(CASE WHEN IFNULL(GaranteID,0) <> 0 AND CargoID = 3 THEN IFNULL(Var_SecretarioConsejo,1) ELSE 'N' END) AS Secretario,
		(CASE WHEN IFNULL(GaranteID,0) <> 0 AND CargoID = 2 THEN IFNULL(Var_PresidenteConsejo,1) ELSE 'N' END) AS Presidente,
		(CASE WHEN IFNULL(RelacionadoID,0) <> 0 AND CargoID = 1 OR 5 OR 6 THEN IFNULL(Var_OtroConsejo,1 )ELSE 'N' END) AS OtroMiembroConsejo
		INTO Var_TesoreroConsejo,Var_SecretarioConsejo,Var_PresidenteConsejo,Var_OtroConsejo
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID AND RelacionadoID = Var_ConsejoGarID;

		SELECT 
		(CASE WHEN IFNULL(AvalID,0) <> 0 AND CargoID = 4 THEN IFNULL(Var_TesoreroConsejo,1) ELSE 'N' END) AS Tesorero,
		(CASE WHEN IFNULL(AvalID,0) <> 0 AND CargoID = 3 THEN IFNULL(Var_SecretarioConsejo,1) ELSE 'N' END) AS Secretario,
		(CASE WHEN IFNULL(AvalID,0) <> 0 AND CargoID = 2 THEN IFNULL(Var_PresidenteConsejo,1) ELSE 'N' END) AS Presidente,
		(CASE WHEN IFNULL(AvalID,0) <> 0 AND CargoID = 1 OR 5 OR 6 THEN IFNULL(Var_OtroConsejo,1 )ELSE 'N' END) AS OtroMiembroConsejo
		INTO Var_TesoreroConsejo,Var_SecretarioConsejo,Var_PresidenteConsejo,Var_OtroConsejo
		FROM INVERSIONES Inv
		INNER JOIN DIRECTIVOS DIR ON DIR.ClienteID = Inv.ClienteID
		WHERE Inv.InversionID = Par_InversionID AND RelacionadoID = Var_ConsejoAvalID;

		IF (Var_OtroConsejo != 'N') THEN
			SELECT CONCAT(CLI.PrimerNombre,' ',CLI.SegundoNombre),CLI.ApellidoPaterno,CLI.ApellidoMaterno
			INTO Var_NombresConsejo, Var_ApellidoPaternoConsejo, Var_ApellidoMaternoConsejo
			FROM CLIENTES CLI INNER JOIN DIRECTIVOS DIR ON DIR.RelacionadoID = CLI.CLienteID
			INNER JOIN PAISES PAI ON PAI.PaisID = CLI.PaisResidencia
			INNER JOIN ESTADOSREPUB EST ON EST.EstadoID = CLI.EstadoID
			INNER JOIN OCUPACIONES OCU ON OCU.OcupacionID = CLI.OCupacionID
			INNER JOIN IDENTIFICLIENTE IDE ON IDE.ClienteID = CLI.ClienteID
			INNER JOIN TIPOSIDENTI TIP ON TIP.TipoIdentiID = IdentificID
			WHERE RelacionadoID = Var_ConsejoRelID;
		ELSE IF (Var_TesoreroConsejo != 'N') THEN
			SELECT CONCAT(CLI.PrimerNombre,' ',CLI.SegundoNombre),CLI.ApellidoPaterno,CLI.ApellidoMaterno
			INTO Var_NombresConsejo, Var_ApellidoPaternoConsejo, Var_ApellidoMaternoConsejo
			FROM CLIENTES CLI INNER JOIN DIRECTIVOS DIR ON DIR.RelacionadoID = CLI.CLienteID
			INNER JOIN PAISES PAI ON PAI.PaisID = CLI.PaisResidencia
			INNER JOIN ESTADOSREPUB EST ON EST.EstadoID = CLI.EstadoID
			INNER JOIN OCUPACIONES OCU ON OCU.OcupacionID = CLI.OCupacionID
			INNER JOIN IDENTIFICLIENTE IDE ON IDE.ClienteID = CLI.ClienteID
			INNER JOIN TIPOSIDENTI TIP ON TIP.TipoIdentiID = IdentificID
			WHERE RelacionadoID = Var_ConsejoRelID;
		ELSE IF (Var_SecretarioConsejo != 'N') THEN
			SELECT CONCAT(CLI.PrimerNombre,' ',CLI.SegundoNombre),CLI.ApellidoPaterno,CLI.ApellidoMaterno
			INTO Var_NombresConsejo, Var_ApellidoPaternoConsejo, Var_ApellidoMaternoConsejo
			FROM CLIENTES CLI INNER JOIN DIRECTIVOS DIR ON DIR.RelacionadoID = CLI.CLienteID
			INNER JOIN PAISES PAI ON PAI.PaisID = CLI.PaisResidencia
			INNER JOIN ESTADOSREPUB EST ON EST.EstadoID = CLI.EstadoID
			INNER JOIN OCUPACIONES OCU ON OCU.OcupacionID = CLI.OCupacionID
			INNER JOIN IDENTIFICLIENTE IDE ON IDE.ClienteID = CLI.ClienteID
			INNER JOIN TIPOSIDENTI TIP ON TIP.TipoIdentiID = IdentificID
			WHERE RelacionadoID = Var_ConsejoRelID;
		END IF;
		END IF;
		END IF;
 
        SET Var_PaisDomPart := 'MÉXICO';
        
        SELECT  Var_ClienteID,					Var_Sucursal,				Var_FechaIngreso,  			TipoPersona,   				Var_TipoPersona,
				Var_RazonSocial,				Var_NombresCte,				Var_ApellidoPaterno,		Var_ApellidoMaterno,		Var_FechaNacimiento,
                Var_EdoNacimiento,				Var_PaisNacimiento,			Var_Nacionalidad,			Var_Genero,					Var_EdoCivil,
                Var_RegMatrimonial,				Var_Ocupacion,				Var_PaisResidencia,			Var_CURP,					Var_RegHacienda,
                Var_PaisAsignaRFC,				Var_FEA,					Var_RFC, 					Var_TelefonoLoc,			Var_TelefonoPart,
                Var_TelefonoCel,				Var_CorreoElec,				Var_Observaciones,			Var_TipoIdentific,			Var_NumIdentific,
                Var_VigIdentific,				Var_NombreConyuge,			Var_EsPEP,					Var_CargoPEP,				Var_FamiliarPEP,
                Var_NombresFamPEP,				Var_ApPatFamPEP,			Var_ApMatFamPEP,			Var_TipoDirecc,				Var_CalleDomPart,
                Var_NumExtDomPart,				Var_NumIntDomPart,			Var_PisoDomPart,			Var_ColDomPart, 			Var_MunDomPart,
                Var_CiudadDomPart,				Var_EdoDomPart,				Var_CPDomPart,				Var_PaisDomPart,			Var_PrimCalleDomPart,
                Var_SegCalleDomPart,			Var_LatitudDomPart,			Var_LongitudDomPart,		Var_TipoDomPart,			Var_DescDomPart,
                Var_LoteDomPart,				Var_ManzanaDomPart,			Var_TipoPropDomPart,		Var_AntigDomPart,			Var_CalleDomFisc,
                Var_NumExtDomFisc, 				Var_NumIntDomFisc,			Var_ColDomFisc,				Var_MunDomFisc,				Var_CiudadDomFisc,
                Var_EdoDomFisc,					Var_Puesto,					Var_CtoTrabajo,				Var_AntigTrabajo,			Var_DireccTrabajo,
                Var_TelTrabajo,					Var_ClasificCte, 			Var_MotAperCte, 			Var_SecGralCte, 			Var_ActBMXCte,
                Var_ActINEGICte,				Var_ActFRCte,				Var_ActFOMURCte,			Var_SecEcoCte, 				Var_PagaIVACte,
                Var_PagaISRCte,					Var_PersRelCta,				Var_PersRelCotCta,			Var_PersRelAutCta,			Var_PersRelPopRCta,
                Var_PersRelProvRCta,			Var_NomPrimRefCte,			Var_NumCtaPrimRefCte,		Var_DirPrimRefCte,			Var_TelPrimRefCte,
                Var_NomSegRefCte,				Var_NumCtaSegRefCte,		Var_DirSegRefCte,			Var_TelSegRefCte,			Var_BancoPrimRefCte,
                Var_TipoCtaPrimRefCte,			Var_CtaPrimRefCte,			Var_SucPrimRefCte,			Var_TDCPrimRefCte,			Var_InstPrimRefCte,
                Var_CredPrimRefCte,				Var_InstCPrimRefCte,		Var_BancoSegRefCte,			Var_TipoCtaSegRefCte,		Var_CtaSegRefCte,
                Var_SucSegRefCte,				Var_TDCSegRefCte,			Var_InstSegRefCte, 			Var_CredSegRefCte,			Var_InstCSegRefCte,
                Var_NomPrimerRef,				Var_DomPrimerRef,			Var_TelPrimerRef,			Var_RelPrimerRef,			Var_NomSegunRef,
                Var_DomSegunRef,				Var_TelSegunRef,			Var_RelSegunRef,			Var_IngresoMes,				Var_IngExtraMes,
                Var_IngOtrosMes,				Var_EgAliment,				Var_EgServicios				Var_EgEscuela,				Var_EgCasa,
                Var_EgOtros,					Var_DepCred,				Var_RetCargos,				Var_NumDep,					Var_NumRet,
                Var_FrecDep,					Var_FrecRet,				Var_ProcRec,				Var_ConcFondo,				Var_AdmonGasIng,
				Var_PagoNom,					Var_CtaInver,				Var_PagoCred,				Var_MediosElec,				Var_FinOtros,
                Var_CtaPropia,					Var_CtaTercero,				Var_NombreCompleto,			Var_FechIniTrabajo,			Var_CtaApoderado,
                Var_EjecAperCta,				Var_FechSistema,			Var_FechaConstitucion,		Var_NombreNotario, 			Var_NumNotario,
                Var_InscripcionReg, 			Var_EscrituraPubPM,			Var_GrupoEmpresarial,		Var_TipoSociedadDesc		Var_DescDir,
                Var_Accionista,					Var_PresidenteConsejoAdmon,	Var_SecretarioConsejoAdmon,	Var_TesoreroConsejoAdmon,	Var_Administrador,
                Var_DirectorGeneral, 			Var_FolioRegPub, 			Var_FechaEscPub, 			Var_FechaVenEst, 			Var_FechaEsc,
                NombreRelacionado,				Var_ApellMatRel,			Var_ApellPatRel ,			Var_FechaNacRela,			Var_EstadoRela,
                Var_PaisRela,					Var_NacionRela,				Var_SexoRela,				Var_OcupacionRela,			Var_PaisResideRela,
                Var_CURPRela,					Var_RegistroHaRela,			Var_NumIdentiRela,			Var_FEARela,				Var_PaisFEARela,
                Var_RFCRela,					Var_TelefonoRela,			Var_TelefonoCelRela,		Var_CorreoRela,				Var_DescripcionRela,
                Var_IdentifiRela,				Var_FechaVenIdenRela,		Var_RazonSocialRela,		Var_PrimerNombreAccMay25,	Var_SegundoNombreAccMay25,
                Var_ApellidoMaternoAccMay25,	Var_ApellPatAccMay25, 		Var_RFCAccMay25,			Var_RazonSocialAccMay25,	Var_NombresConsejo,
                Var_ApellidoPaternoConsejo, 	Var_ApellidoMaternoConsejo,	Var_ConsejoRelID;

END TerminaStore$$
