-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDINGRESO029REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDINGRESO029REP`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDINGRESO029REP`(
/* SP DE REPORTE PARA LA SOLICITUD DE CREDITO, DEPENDE DEL FORMATO DE CADA CLIENTE */
	Par_ClienteID       INT(11),   -- Numero de la Solicitud de Credito
    Par_SolicitudCreID  INT(11),   -- Numero de la Solicitud de Credito

	Par_TipoReporte     INT(11),      -- Tipo o Seccion del Reporte de Solicitud de Credito.

  /* Parametros de Auditoria */
	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN


/* Declaracion de Variables */
DECLARE Var_FechaSistema      	DATE;
DECLARE Var_SI          		CHAR(1);
DECLARE Var_NO          		CHAR(1);
DECLARE Var_X          			CHAR(1);
DECLARE Cadena_Vacia        	CHAR(1);
DECLARE Entero_Cero				INT;
DECLARE Fecha_Vacia				DATE;
DECLARE CreditoGrupal			INT;
DECLARE Integrantes				INT;
DECLARE DatosCliente			INT;
DECLARE DatosCedula				INT;
DECLARE Var_NombreSucur			VARCHAR(100);
DECLARE Var_SolicitudCreID      BIGINT(20);
DECLARE Decimal_Cero            DECIMAL(12,2);


/*VARIABLES DATOS DEL GRUPO */

DECLARE Var_NombreGrupo			VARCHAR(200);
DECLARE Var_CicloGrupo			VARCHAR(5);
DECLARE Var_GrupoID				BIGINT;
DECLARE Var_NumAmor				INT;
DECLARE Var_FechaVen			DATE;
DECLARE Var_AntNumAmor				INT;
DECLARE Var_AntFechaVen			DATE;
DECLARE Var_Ciclo				INT;
DECLARE Var_CicloAnterior		INT;


/* VARIABLES DE DATOS DEL CLIENTE*/
DECLARE Var_ClienteID         	BIGINT;
DECLARE Var_NombreCliente	  	VARCHAR(200);
DECLARE Var_ApePaterno      	VARCHAR(50);
DECLARE Var_ApeMaterno      	VARCHAR(50);
DECLARE Var_CliFechaNac     	VARCHAR(10);
DECLARE Var_PaisNac           	VARCHAR(200);
DECLARE Var_CliCURP           	VARCHAR(20);
DECLARE Var_CliRFC            	VARCHAR(20);
DECLARE Var_CliSexo           	CHAR(1);
DECLARE Var_CliCorreo       	VARCHAR(60);
DECLARE Var_EstadoCivil 		CHAR(2);
DECLARE Var_CliTelCel     		VARCHAR(15);
DECLARE Var_TelefonoRef      	VARCHAR(15);
DECLARE Var_CliCalle          	VARCHAR(200);
DECLARE Var_CliNumCasa        	VARCHAR(10);
DECLARE Var_CliNumInt         	VARCHAR(10);
DECLARE Var_CliCP       		CHAR(10);
DECLARE Var_CliColonia         	VARCHAR(400);
DECLARE Var_1aEntreCalle      	VARCHAR(200);
DECLARE Var_2aEntreCalle      	VARCHAR(200);
DECLARE Var_NombreLoc     		VARCHAR(200);
DECLARE Var_CliMunici         	VARCHAR(200);
DECLARE Var_NomEstado			VARCHAR(100);
DECLARE Var_NomPais				VARCHAR(100);
DECLARE Var_CliNacion         	VARCHAR(50);
DECLARE Var_NumIdentif   		VARCHAR(30);
DECLARE Var_TipoIdentif  		VARCHAR(50);
DECLARE Var_Escolaridad			VARCHAR(50);
DECLARE Var_IngresDeclaFinS		DOUBLE(14,2);
DECLARE Var_Hipoteca			DOUBLE(14,2);
DECLARE Var_CliAniosRes         INT(11);
DECLARE Var_CliOcupacion        VARCHAR(500);
DECLARE Var_DomTrabajoCli       VARCHAR(500);
DECLARE Var_CliActividad        VARCHAR(200);
DECLARE Var_CliMontoIngrMen     DECIMAL(14,2);
DECLARE Var_NombreRef1          VARCHAR(100);
DECLARE Var_NombreRef2          VARCHAR(100);
DECLARE Var_TipoRel1            INT(11);
DECLARE Var_TipoRel2            INT(11);
DECLARE Var_DesRelacion1        VARCHAR(100);
DECLARE Var_DesRelacion2        VARCHAR(100);
DECLARE Var_CliPeps             CHAR(1);
DECLARE Var_ParentPeps          CHAR(1);
DECLARE Var_CliPepsNombre       VARCHAR(500);

DECLARE Var_DescProducto        VARCHAR(100);
DECLARE Var_NomGrupo            VARCHAR(200);
DECLARE Var_FOGA                DECIMAL(6,2);
DECLARE Var_PlazoID             VARCHAR(20);
DECLARE Var_MontoSolici         DECIMAL(12,2);
DECLARE Var_NomProyecto         VARCHAR (500);
DECLARE Var_TipoCredito         CHAR(1);
DECLARE Var_FrecuenciaCap       CHAR(1);



DECLARE Var_Dep1NombreHijo1     VARCHAR(500);
DECLARE Var_Dep1NombreHijo2     VARCHAR(500);
DECLARE Var_Dep1NombreHijo3     VARCHAR(500);
DECLARE Var_Dep1NombreHijo4     VARCHAR(500);
DECLARE Var_Dep1NombreHijo5     VARCHAR(500);
DECLARE Var_Dep1NombreHijo6     VARCHAR(500);
DECLARE Var_Dep1NombreHijo7     VARCHAR(500);




DECLARE Var_TelRef1             VARCHAR(20);
DECLARE Var_TelRef2             VARCHAR(20);
DECLARE Var_ExtTelRef1          VARCHAR(6);
DECLARE Var_ExtTelRef2          VARCHAR(6);
DECLARE Var_CreditoID           BIGINT(12);
DECLARE Var_SaldoCredAnteri     DECIMAL(12,2);
DECLARE Var_SaldoFOGAFI         DECIMAL(14,2);

DECLARE Var_MontoCuota           DECIMAL(12,2);
DECLARE Var_TasaFija             DECIMAL(12,4);
DECLARE Var_NombreCte            VARCHAR(500);
DECLARE Var_NombrePromotor       VARCHAR(500);





DECLARE Var_TipoVivienda		INT;

DECLARE Est_Soltero         	CHAR(2);
DECLARE Est_CasBieSep       	CHAR(2);
DECLARE Est_CasBieMan       	CHAR(2);
DECLARE Est_CasCapitu       	CHAR(2);
DECLARE Est_Viudo           	CHAR(2);
DECLARE Est_Divorciad       	CHAR(2);
DECLARE Est_Seperados       	CHAR(2);
DECLARE Est_UnionLibre      	CHAR(2);

-- VARIABLE DE DEPENDIENTES ECONOMICOS
DECLARE Var_NumDep				INT;
DECLARE Var_DepNomComp			VARCHAR(200);
DECLARE Var_DepOcupacion		VARCHAR(200);
DECLARE Var_DepParentesco		VARCHAR(200);

-- VARIABLES DEL CONYUGE
DECLARE Var_ConyNom        		VARCHAR(100);
DECLARE Var_ConyOcupa         	VARCHAR(350);
DECLARE Var_ConyFecNac        	DATE;
DECLARE Var_ConyID         		BIGINT;

-- VARIABLES DE LA OCUOACION, EMPLEO O NEGOCIO CLIENTE
DECLARE Var_TipoDireccion		INT;
DECLARE Var_Negocio				INT;
DECLARE Var_Trabajo 			INT;
DECLARE Var_LugarTrabajo		VARCHAR(100);
DECLARE Var_Puesto				VARCHAR(100);
DECLARE Var_Antiguedad			DECIMAL(14,2);
DECLARE Var_EmpCalle 			VARCHAR(200);
DECLARE Var_EmpNumCasa 			VARCHAR(10);
DECLARE Var_EmpNumInt			VARCHAR(10);
DECLARE Var_EmpCP				VARCHAR(10);
DECLARE Var_EmpColonia			VARCHAR(200);
DECLARE Var_Emp1aEntreCalle		VARCHAR(100);
DECLARE Var_Emp2aEntreCalle		VARCHAR(100);
DECLARE Var_EmpLoc				VARCHAR(100);
DECLARE Var_EmpMunici			VARCHAR(100);
DECLARE Var_EmpEstado			VARCHAR(100);
DECLARE Var_EmpTel 				VARCHAR(15);
DECLARE Var_EmpTelExt 			VARCHAR(10);

DECLARE Var_ImporteDep			DOUBLE(14,2);
DECLARE Var_ImporteRet			DOUBLE(14,2);
DECLARE Var_NumDepos			INT;
DECLARE Var_NumRet				INT;
DECLARE Var_RefNombre			VARCHAR(200);
DECLARE Var_RefParent			VARCHAR(100);
DECLARE Var_RefTel 				VARCHAR(15);
DECLARE Var_RefExtTel			VARCHAR(15);
DECLARE Var_RefNombre2			VARCHAR(200);
DECLARE Var_RefParent2			VARCHAR(100);
DECLARE Var_Ref2Tel				VARCHAR(15);
DECLARE Var_RefExtTel2			VARCHAR(15);

DECLARE Var_RelNombre 			VARCHAR(200);
DECLARE Var_RelParent			VARCHAR(100);

-- VARIABLES DE DATOS AVALES
DECLARE Var_NumAval				INT;
DECLARE Var_AvalNombre			VARCHAR(200);
DECLARE Var_AvalApePaterno		VARCHAR(50);
DECLARE Var_AvalApeMaterno		VARCHAR(50);
DECLARE Var_AvalFechaNac		VARCHAR(10);
DECLARE Var_AvalPaisNac			VARCHAR(50);
DECLARE Var_AvalNacion			VARCHAR(10);
DECLARE Var_AvalRFC				VARCHAR(20);
DECLARE Var_AvalCalle			VARCHAR(100);
DECLARE Var_AvalNumCasa			VARCHAR(10);
DECLARE Var_AvalNumInt			VARCHAR(10);
DECLARE Var_AvalCP 				VARCHAR(10);
DECLARE Var_AvalColonia 		VARCHAR(100);
DECLARE Var_AvalLocal 			VARCHAR(100);
DECLARE Var_AvalMuni 			VARCHAR(100);
DECLARE Var_AvalEstado 			VARCHAR(100);
DECLARE Var_AvalSexo 			VARCHAR(5);
DECLARE Var_AvalTel 			VARCHAR(15);
DECLARE Var_AvalTelCel 			VARCHAR(15);
DECLARE Var_AvalEstCivil 		VARCHAR(5);
DECLARE Var_AvalNomPais			VARCHAR(200);


-- SETEO DE VARIABLES
SET Var_SI        	  	:= 'S';    -- Constante SI
SET Var_NO        	  	:= 'N';    -- Constante No
SET Var_X       	  	:= 'X';    -- Constante X
SET Cadena_Vacia      	:= '';     -- String o Cadena Vacia
SET Entero_Cero			:= 0;
SET Fecha_Vacia			:='1900-01-01';
SET CreditoGrupal		:=1;
SET DatosCliente		:=2;
SET DatosCedula			:=3;
SET Integrantes			:=4;

SET Est_Soltero       	:= 'S';    -- Estado Civil Soltero
SET Est_CasBieSep     	:= 'CS';   -- Casado Bienes Separados
SET Est_CasBieMan     	:= 'CM';   -- Casado Bienes Mancomunados
SET Est_CasCapitu     	:= 'CC';   -- Casado Bienes Mancomunados Con Capitulacion
SET Est_Viudo         	:= 'V';    -- Viudo
SET Est_Divorciad     	:= 'D';    -- Divorciado
SET Est_Seperados     	:='SE';    -- Separado
SET Est_UnionLibre    	:= 'U';    -- Union Libre

SET Var_Negocio		  	:=2;		-- ID 2 = Negocio
SET Var_Trabajo		  	:=3;		-- ID 3 = Trabajo
SET Decimal_Cero        := 0.00;


	SELECT Par.FechaSistema
	INTO Var_FechaSistema
	FROM PARAMETROSSIS Par
		INNER JOIN INSTITUCIONES Inst ON Par.InstitucionID = Inst.InstitucionID
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Par.SucursalMatrizID
		INNER JOIN ESTADOSREPUB Est ON Est.EstadoID = Suc.EstadoID
		INNER JOIN MUNICIPIOSREPUB  Mun ON Mun.MunicipioID = Suc.MunicipioID AND Mun.EstadoID = Suc.EstadoID;


IF(IFNULL(Par_ClienteID,Entero_Cero)>0) THEN
	SELECT S.SolicitudCreditoID
	INTO Var_SolicitudCreID
	FROM CLIENTES C
		INNER JOIN  SOLICITUDCREDITO S ON  C.ClienteID=S.ClienteID
	WHERE C.ClienteID= Par_ClienteID ORDER BY S.SolicitudCreditoID DESC LIMIT 1;
ELSE
    SET Var_SolicitudCreID:=IFNULL(Par_SolicitudCreID,Entero_Cero);
END IF;

    SELECT Grup.GrupoID,Grup.NombreGrupo
	INTO Var_GrupoID,Var_NomGrupo
	FROM SOLICITUDCREDITO Sol
		INNER JOIN GRUPOSCREDITO Grup ON Sol.GrupoID = Grup.GrupoID
	WHERE Sol.SolicitudCreditoID = Var_SolicitudCreID;

	SELECT P.Descripcion,Sol.PorcGarLiq,CreP.Descripcion,Sol.MontoSolici,Sol.Proyecto,Sol.TipoCredito,Sol.FrecuenciaCap
	  INTO Var_DescProducto, Var_FOGA,Var_PlazoID, Var_MontoSolici, Var_NomProyecto, Var_TipoCredito,Var_FrecuenciaCap
	FROM SOLICITUDCREDITO Sol INNER JOIN
	PRODUCTOSCREDITO   P ON Sol.ProductoCreditoID=P.ProducCreditoID
	INNER JOIN CREDITOSPLAZOS CreP   ON CreP.PlazoID=Sol.PlazoID
	WHERE Sol.SolicitudCreditoID=Var_SolicitudCreID
	LIMIT 1;

	SELECT CreditoID,MontoCuota,round(TasaFija,2) INTO Var_CreditoID,Var_MontoCuota,Var_TasaFija
	FROM CREDITOS WHERE SolicitudCreditoID=Var_SolicitudCreID;

	SET Var_CreditoID:=IFNULL(Var_CreditoID,Entero_Cero);

	SELECT MAX(( ROUND(Capital + Interes + IVAInteres + IFNULL(MontoSeguroCuota,Decimal_Cero) + IFNULL(IVASeguroCuota,Decimal_Cero) + IFNULL(MontoOtrasComisiones,Decimal_Cero) + IFNULL(MontoIVAOtrasComisiones,Decimal_Cero),2))) INTO Var_MontoCuota
      FROM AMORTICREDITO
      WHERE CreditoID = Var_CreditoID;

	IF(Var_TipoCredito<>"N") THEN
		SELECT SaldoCredAnteri INTO Var_SaldoCredAnteri
		FROM REESTRUCCREDITO WHERE CreditoOrigenID = Var_CreditoID LIMIT 1;
	END IF;

    SELECT round(SaldoFOGAFI,Entero_Cero) INTO Var_SaldoFOGAFI
	FROM  DETALLEGARFOGAFI WHERE CreditoID=Var_CreditoID LIMIT 1;

    SELECT NombreSucurs
    INTO Var_NombreSucur
    FROM SUCURSALES
    WHERE SucursalID = Aud_Sucursal;

-- ---------------------------------------------------------------------------------
-- SOLICITUD DE MICRO CREDITO GRUPAL
-- ---------------------------------------------------------------------------------
IF(Par_TipoReporte = CreditoGrupal)THEN
	SELECT Grup.NombreGrupo, Grup.CicloActual
	INTO Var_NombreGrupo,	Var_CicloGrupo
	FROM SOLICITUDCREDITO Sol
		INNER JOIN GRUPOSCREDITO Grup ON Sol.GrupoID = Grup.GrupoID
	WHERE Sol.SolicitudCreditoID = Var_SolicitudCreID;

    SELECT CicloActual, (CicloActual-1)
    INTO Var_Ciclo, Var_CicloAnterior
    FROM GRUPOSCREDITO
    WHERE GrupoID = Var_GrupoID;

    -- CICLO ANTERIOR
    SELECT Cre.NumAmortizacion, Cre.FechaVencimien
    INTO Var_AntNumAmor, Var_AntFechaVen
	FROM CREDITOS Cre
		LEFT OUTER JOIN INTEGRAGRUPOSCRE IntGru ON Cre.SolicitudCreditoID = IntGru.SolicitudCreditoID
    	LEFT OUTER JOIN GRUPOSCREDITO Gru ON Cre.GrupoID = Gru.GrupoID
	WHERE Gru.GrupoID = Var_GrupoID AND IntGru.Ciclo = Var_CicloAnterior  ORDER BY IntGru.Cargo LIMIT 1;
    -- CICLO ACTUAL
    SELECT Cre.NumAmortizacion, Cre.FechaVencimien, Gru.CicloActual
    INTO Var_NumAmor, Var_FechaVen, Var_Ciclo
	FROM CREDITOS Cre
		LEFT OUTER JOIN INTEGRAGRUPOSCRE IntGru ON Cre.SolicitudCreditoID = IntGru.SolicitudCreditoID
    	LEFT OUTER JOIN GRUPOSCREDITO Gru ON Cre.GrupoID = Gru.GrupoID
	WHERE Gru.GrupoID = Var_GrupoID AND IntGru.Ciclo = Var_Ciclo  ORDER BY IntGru.Cargo LIMIT 1;

	SELECT
		IFNULL(Var_NombreGrupo,Cadena_Vacia) AS NombreGrupo,
		IFNULL(Var_CicloGrupo,Cadena_Vacia) AS CicloGrupo,
		IFNULL(Var_SolicitudCreID,Cadena_Vacia) AS SolicitudCreID,
		IFNULL(Var_GrupoID,Cadena_Vacia) AS GrupoID,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-8,1),Cadena_Vacia) AS GrupoID8,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-7,1),Cadena_Vacia) AS GrupoID7,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-6,1),Cadena_Vacia) AS GrupoID6,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-5,1),Cadena_Vacia) AS GrupoID5,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-4,1),Cadena_Vacia) AS GrupoID4,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-3,1),Cadena_Vacia) AS GrupoID3,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-2,1),Cadena_Vacia) AS GrupoID2,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-1,1),Cadena_Vacia) AS GrupoID1,
   		IFNULL(Var_CicloAnterior,Entero_Cero) AS CicloAnterior,
   		IFNULL(Var_AntNumAmor,Entero_Cero) AS AntNumAmor,
		IFNULL(Var_AntFechaVen,Cadena_Vacia) AS AntFechaVen,
		IFNULL(Var_Ciclo,Entero_Cero) AS Ciclo,
   		IFNULL(Var_NumAmor,Entero_Cero) AS NumAmor,
		IFNULL(Var_FechaVen,Cadena_Vacia) AS FechaVen
	;

END IF;
-- ---------------------------------------------------------------------------------
-- INTEGRANTES DEL GRUPO
-- ---------------------------------------------------------------------------------
IF(Par_TipoReporte = Integrantes)THEN
 SELECT  Gru.CicloActual
    INTO  Var_Ciclo
	FROM  GRUPOSCREDITO Gru
	WHERE Gru.GrupoID = Var_GrupoID;

 DROP TABLE IF EXISTS TMPIntegrantes;
    CREATE TABLE TMPIntegrantes (
        IntegranteID            INT AUTO_INCREMENT,
        ClienteID 				INT,
        SolicitudCreditoID 		INT,
        Nombre	  				VARCHAR(200),
		ApellidoPaterno      	VARCHAR(100),
		ApellidoMaterno      	VARCHAR(100),
		MontoCredito			DECIMAL(14,2),
        PRIMARY KEY (IntegranteID)
    );
INSERT INTO TMPIntegrantes (ClienteID, SolicitudCreditoID, ApellidoPaterno, ApellidoMaterno, Nombre)
SELECT  Cli.ClienteID, Sol.SolicitudCreditoID, Cli.ApellidoPaterno, Cli.ApellidoMaterno, FNGENNOMBRECOMPLETO(Cli.PrimerNombre,Cli.SegundoNombre,Cli.TercerNombre,Cadena_Vacia,Cadena_Vacia)
		FROM INTEGRAGRUPOSCRE IntGrup
		INNER JOIN CLIENTES Cli ON IntGrup.ClienteID = Cli.ClienteID
        LEFT OUTER JOIN SOLICITUDCREDITO Sol ON IntGrup.SolicitudCreditoID = Sol.SolicitudCreditoID
	WHERE IntGrup.GrupoID = Var_GrupoID ORDER BY IntGrup.Cargo;

UPDATE TMPIntegrantes tmp LEFT OUTER JOIN SOLICITUDCREDITO  Sol ON tmp.SolicitudCreditoID = Sol.SolicitudCreditoID
			LEFT OUTER JOIN CREDITOS cre ON Sol.SolicitudCreditoID = cre.SolicitudCreditoID
	SET tmp.MontoCredito = cre.MontoCredito
WHERE FechaMinistrado <> Fecha_Vacia;

SELECT IntegranteID, Nombre, ApellidoPaterno, ApellidoMaterno, MontoCredito FROM TMPIntegrantes;
END IF;

	SELECT
		C.ClienteID,		FNGENNOMBRECOMPLETO(C.PrimerNombre,C.SegundoNombre,C.TercerNombre,Cadena_Vacia,Cadena_Vacia),
		C.ApellidoPaterno,	C.ApellidoMaterno,	C.FechaNacimiento,	C.LugarNacimiento,		C.Nacion,
		C.CURP,				C.RFCOficial,		C.Sexo,					C.Correo,
		C.EstadoCivil,		C.Telefono,			C.TelefonoCelular, C.DomicilioTrabajo
	INTO
		Var_ClienteID,		Var_NombreCliente,
		Var_ApePaterno,		Var_ApeMaterno,		Var_CliFechaNac,	Var_PaisNac,			Var_CliNacion,
		Var_CliCURP,		Var_CliRFC,			Var_CliSexo,			Var_CliCorreo,
		Var_EstadoCivil,	Var_CliTelCel,		Var_TelefonoRef,  Var_DomTrabajoCli

	FROM SOLICITUDCREDITO S
		INNER JOIN CLIENTES C ON S.ClienteID = C.ClienteID
	WHERE S.SolicitudCreditoID = Var_SolicitudCreID;
		 -- Datos del Conyugue

	IF(Var_EstadoCivil = Est_CasBieSep OR Var_EstadoCivil = Est_CasBieMan OR Var_EstadoCivil = Est_CasCapitu OR Var_EstadoCivil = Est_UnionLibre )THEN
	      SELECT  FNGENNOMBRECOMPLETO(Coy.PrimerNombre,       Coy.SegundoNombre,      Coy.TercerNombre,       Coy.ApellidoPaterno	,Coy.ApellidoMaterno),
	          Ocu.Descripcion, 		Coy.FechaNacimiento,	  Coy.ClienteConyID
	      INTO
          Var_ConyNom,         Var_ConyOcupa,         Var_ConyFecNac,         Var_ConyID
	      FROM SOCIODEMOCONYUG Coy
	      LEFT OUTER JOIN OCUPACIONES Ocu ON Coy.OcupacionID = Ocu.OcupacionID
	      WHERE  Coy.ClienteID = Var_ClienteID;
	END IF;


		-- Dependientes Economicos
    SELECT COUNT(DependienteID)
		INTO Var_NumDep
		FROM SOCIODEMODEPEND WHERE ClienteID = Var_ClienteID;

    SET @REG := 0;
	DROP TEMPORARY TABLE IF EXISTS TMPSOCIODEMODEPEND;
	CREATE TEMPORARY TABLE TMPSOCIODEMODEPEND
	SELECT (@REG := @REG + 1) AS CONSECUTIVO,DependienteID,FNGENNOMBRECOMPLETO(PrimerNombre,SegundoNombre,TercerNombre,ApellidoPaterno,ApellidoMaterno) AS nombreCompleto,Edad,OcupacionID
			FROM SOCIODEMODEPEND
	WHERE ClienteID=Var_ClienteID and TipoRelacionID=3;

    SELECT  nombreCompleto INTO
	Var_Dep1NombreHijo1 FROM TMPSOCIODEMODEPEND
	WHERE CONSECUTIVO=1;

	 SELECT  nombreCompleto INTO
	Var_Dep1NombreHijo2 FROM TMPSOCIODEMODEPEND
	WHERE CONSECUTIVO=2;

	 SELECT  nombreCompleto INTO
	Var_Dep1NombreHijo3 FROM TMPSOCIODEMODEPEND
	WHERE CONSECUTIVO=3;



    SELECT  nombreCompleto INTO
	Var_Dep1NombreHijo4 FROM TMPSOCIODEMODEPEND
	WHERE CONSECUTIVO=4;

	 SELECT  nombreCompleto INTO
	Var_Dep1NombreHijo5 FROM TMPSOCIODEMODEPEND
	WHERE CONSECUTIVO=5;

	 SELECT  nombreCompleto INTO
	Var_Dep1NombreHijo6 FROM TMPSOCIODEMODEPEND
	WHERE CONSECUTIVO=6;

    SELECT  nombreCompleto INTO
	Var_Dep1NombreHijo7 FROM TMPSOCIODEMODEPEND
	WHERE CONSECUTIVO=7;
-- ---------------------------------------------------------------------------------
-- CEDULA DE IDENTIFICACION DEL CLIENTE
-- ---------------------------------------------------------------------------------
IF(Par_TipoReporte = DatosCliente)THEN

	SELECT
		Dir.Calle,				Dir.NumeroCasa,			Dir.NumInterior,		Dir.CP,			UPPER(CONCAT(Col.TipoAsenta,' ',Col.Asentamiento)),
		Dir.PrimeraEntreCalle,	Dir.SegundaEntreCalle,	Loc.NombreLocalidad,	Mun.Nombre,		Est.Nombre,         Dir.AniosRes
	INTO
		Var_CliCalle,			Var_CliNumCasa,			Var_CliNumInt,			Var_CliCP,		Var_CliColonia,
		Var_1aEntreCalle,		Var_2aEntreCalle,		Var_NombreLoc,			Var_CliMunici,	Var_NomEstado,     Var_CliAniosRes
		FROM DIRECCLIENTE Dir
			INNER JOIN ESTADOSREPUB		Est	ON  Dir.EstadoID = Est.EstadoID
			INNER JOIN MUNICIPIOSREPUB	Mun	ON Dir.EstadoID = Mun.EstadoID		AND Dir.MunicipioID = Mun.MunicipioID
			INNER JOIN LOCALIDADREPUB   Loc	ON Dir.EstadoID = Loc.EstadoID		AND Dir.MunicipioID = Loc.MunicipioID
																				AND Dir.LocalidadID = Loc.LocalidadID
			LEFT OUTER JOIN COLONIASREPUB Col ON Dir.EstadoID = Col.EstadoID	AND Dir.MunicipioID = Col.MunicipioID
																				AND Dir.ColoniaID = Col.ColoniaID
		WHERE Dir.ClienteID = Var_ClienteID
			AND Dir.Oficial = Var_SI ;

	SELECT
		I.NumIdentific, I.Descripcion
	INTO
		Var_NumIdentif,	Var_TipoIdentif
	FROM IDENTIFICLIENTE I
	WHERE I.ClienteID = Var_ClienteID
		AND I.Oficial = Var_SI
		LIMIT 1;

	SELECT Ocu.Descripcion INTO
	       Var_CliOcupacion
	FROM CLIENTES Cli
	INNER JOIN OCUPACIONES  Ocu ON Cli.OcupacionID=Ocu.OcupacionID
	WHERE Cli.ClienteID=Var_ClienteID;

		SELECT Act.Descripcion INTO
	       Var_CliActividad
	FROM CLIENTES Cli
	INNER JOIN ACTIVIDADESFR  Act ON Cli.ActividadFR=Act.ActividadFRID
	WHERE Cli.ClienteID=Var_ClienteID;

	SELECT 		Cli.Monto INTO
	Var_CliMontoIngrMen
	FROM	CLIDATSOCIOE Cli
	INNER JOIN CATDATSOCIOE Cat ON Cli.CatSocioEID = Cat.CatSocioEID
	WHERE Cli.ClienteID = Var_ClienteID AND Cat.CatSocioEID=1 LIMIT 1;


	SELECT Cte.NombreRef,      Cte.NombreRef2,          Cte.TipoRelacion1,          Cte.TipoRelacion2,        Cte.TelefonoRef,
	       Cte.TelefonoRef2,   Cte.extTelefonoRefUno,   Cte.extTelefonoRefDos,      Cte.PEPs,                 Cte.ParentescoPEP,
		   FNGENNOMBRECOMPLETO(Cte.NombFamiliar,'','',Cte.APaternoFam,Cte.AMaternoFam)
	    INTO
	       Var_NombreRef1,     Var_NombreRef2,           Var_TipoRel1,         Var_TipoRel2,        Var_TelRef1,
		   Var_TelRef2,        Var_ExtTelRef1,           Var_ExtTelRef2,       Var_CliPeps,         Var_ParentPeps,
		   Var_CliPepsNombre
	FROM CLIENTES Cli
	INNER JOIN CONOCIMIENTOCTE  Cte ON Cli.ClienteID=Cte.ClienteID
	WHERE Cli.ClienteID=Var_ClienteID;

	SELECT Descripcion INTO
	Var_DesRelacion1 FROM
	TIPORELACIONES WHERE TipoRelacionID=Var_TipoRel1;

	SELECT Descripcion INTO
	Var_DesRelacion2 FROM
	TIPORELACIONES WHERE TipoRelacionID=Var_TipoRel2;


	SELECT
		Nombre
	INTO
		Var_NomPais
	FROM PAISES
		WHERE PaisID = Var_PaisNac;

	SELECT Cat.Descripcion
		INTO Var_Escolaridad
		FROM SOCIODEMOGRAL Soc
		LEFT OUTER JOIN CATGRADOESCOLAR Cat ON Soc.GradoEscolarID = Cat.GradoEscolarID
		WHERE Soc.ClienteID = Var_ClienteID;

    SELECT SocV.TipoViviendaID
	INTO Var_TipoVivienda
		FROM SOCIODEMOVIVIEN SocV
			LEFT OUTER JOIN TIPOVIVIENDA TipV ON SocV.TipoViviendaID = TipV.TipoViviendaID
		WHERE SocV.ClienteID = Var_ClienteID;

    SELECT Cli.Monto
    INTO Var_Hipoteca
		FROM CLIDATSOCIOE Cli
			INNER JOIN CATDATSOCIOE Cat ON Cli.CatSocioEID = Cat.CatSocioEID
		WHERE  Cli.ClienteID = Var_ClienteID AND  Cat.CatSocioEID=7;-- HIPOTECA




	SELECT FNGENNOMBRECOMPLETO(Soc.PrimerNombre,       Soc.SegundoNombre,      Soc.TercerNombre,       Soc.ApellidoPaterno	,Soc.ApellidoMaterno), Ocu.Descripcion, Rel.Descripcion
		INTO Var_DepNomComp,	Var_DepOcupacion,	Var_DepParentesco
		FROM SOCIODEMODEPEND Soc
		LEFT OUTER JOIN OCUPACIONES Ocu ON Soc.OcupacionID = Ocu.OcupacionID
        LEFT OUTER JOIN TIPORELACIONES Rel ON Soc.TipoRelacionID = Rel.TipoRelacionID
        WHERE Soc.ClienteID= Var_ClienteID LIMIT 1;

	-- Datos de Ocupacion, Empleo o Negocio.

	SELECT Dir.TipoDireccionID
		INTO  Var_TipoDireccion
			FROM DIRECCLIENTE Dir
			WHERE Dir.ClienteID = Var_ClienteID AND Dir.TipoDireccionID IN (2,3) LIMIT 1;

	IF(Var_TipoDireccion = Var_Negocio OR Var_TipoDireccion = Var_Trabajo) THEN

	SELECT Cli.LugardeTrabajo,		Cli.Puesto,	 		Cli.AntiguedadTra, 			Dir.Calle,
				Dir.NumeroCasa, 		Dir.NumInterior, 	Dir.CP, 					Dir.Colonia,
				Dir.PrimeraEntreCalle, 	Dir.SegundaEntreCalle, Loc.NombreLocalidad,		Mun.Nombre ,
				Est.Nombre, Cli.TelTrabajo , Cli.ExtTelefonoTrab
		INTO Var_LugarTrabajo,	Var_Puesto, Var_Antiguedad, Var_EmpCalle,
			 Var_EmpNumCasa, Var_EmpNumInt, Var_EmpCP, Var_EmpColonia,
			 Var_Emp1aEntreCalle, Var_Emp2aEntreCalle, Var_EmpLoc, Var_EmpMunici,
			 Var_EmpEstado, Var_EmpTel, Var_EmpTelExt

			FROM CLIENTES Cli
				LEFT OUTER JOIN DIRECCLIENTE 	Dir ON Cli.ClienteID = Dir.ClienteID
				LEFT OUTER JOIN ESTADOSREPUB		Est	ON  Dir.EstadoID = Est.EstadoID
				LEFT OUTER JOIN MUNICIPIOSREPUB	Mun		ON 	Dir.MunicipioID = Mun.MunicipioID AND Dir.EstadoID = Mun.EstadoID
				LEFT OUTER JOIN LOCALIDADREPUB   Loc	ON  Dir.LocalidadID = Loc.LocalidadID  AND Dir.EstadoID = Loc.EstadoID AND Dir.MunicipioID = Loc.MunicipioID
			WHERE Cli.ClienteID = Var_ClienteID AND  Dir.TipoDireccionID = Var_TipoDireccion LIMIT 1;
	ELSE
		SELECT Cli.LugardeTrabajo,		Cli.Puesto,	 		Cli.AntiguedadTra, 	Cli.TelTrabajo,		Cli.ExtTelefonoTrab
			INTO Var_LugarTrabajo,		Var_Puesto,			Var_Antiguedad,		Var_EmpTel,		Var_EmpTelExt
		FROM CLIENTES Cli
		WHERE  Cli.ClienteID = Var_ClienteID;
	END IF;

	SELECT (SUM(Cli.Monto)/4)
		INTO Var_IngresDeclaFinS
		FROM CLIDATSOCIOE Cli
			INNER JOIN CATDATSOCIOE Cat ON Cli.CatSocioEID = Cat.CatSocioEID
		WHERE  Cli.ClienteID = Var_ClienteID AND  Cat.Tipo='I';

-- PERFIL TRANS
SELECT DepositosMax, RetirosMax, NumDepositos, NumRetiros
	INTO Var_ImporteDep, Var_ImporteRet, Var_NumDepos, Var_NumRet
	FROM PLDPERFILTRANS
	WHERE ClienteID = Var_ClienteID;

-- REFERENCIAS
	SELECT FNGENNOMBRECOMPLETO(Ref.PrimerNombre,Ref.SegundoNombre,Ref.TercerNombre, Ref.ApellidoPaterno, Ref.ApellidoMaterno),
		Rel.Descripcion, Ref.Telefono, Ref.ExtTelefonoPart
	INTO Var_RefNombre, Var_RefParent, Var_RefTel, Var_RefExtTel
 	FROM REFERENCIACLIENTE Ref
		LEFT OUTER JOIN TIPORELACIONES Rel ON Ref.TipoRelacionID = Rel.TipoRelacionID
	WHERE Rel.EsParentesco = Var_SI AND SolicitudCreditoID = Var_SolicitudCreID LIMIT 1;

	SELECT FNGENNOMBRECOMPLETO(Ref.PrimerNombre,Ref.SegundoNombre,Ref.TercerNombre, Ref.ApellidoPaterno, Ref.ApellidoMaterno),
		Rel.Descripcion, Ref.Telefono, Ref.ExtTelefonoPart
	INTO Var_RefNombre2, Var_RefParent2, Var_Ref2Tel, Var_RefExtTel2
 	FROM REFERENCIACLIENTE Ref
		LEFT OUTER JOIN TIPORELACIONES Rel ON Ref.TipoRelacionID = Rel.TipoRelacionID
	WHERE Rel.EsParentesco = Var_NO AND SolicitudCreditoID = Var_SolicitudCreID LIMIT 1;

-- RELACIONADAS

	SELECT FNGENNOMBRECOMPLETO(Emp.PrimerNombre,Emp.SegundoNombre,Cadena_Vacia,Emp.ApellidoPat,Emp.ApellidoMat),Tip.Descripcion
		INTO Var_RelNombre, Var_RelParent
	FROM EMPLEADOS Emp
		LEFT OUTER JOIN RELACIONCLIEMPLEADO Rel ON Emp.EmpleadoID = Rel.RelacionadoID
		LEFT OUTER JOIN CLIENTES Cli ON Cli.ClienteID = Rel.ClienteID
		LEFT OUTER JOIN TIPORELACIONES Tip ON Tip.TipoRelacionID = Rel.TipoRelacion
	WHERE Rel.ClienteID = Var_ClienteID LIMIT 1;




	-- SELECT DE LAS VARIABLES.
	SELECT
		IFNULL(Var_ClienteID,Cadena_Vacia) AS ClienteID,
		IFNULL(Var_SolicitudCreID,Cadena_Vacia) AS SolicitudCreID,
		IFNULL(SUBSTRING(LPAD(Var_ClienteID, 8, '0'),-8,1),Cadena_Vacia) AS ClienteID8,
		IFNULL(SUBSTRING(LPAD(Var_ClienteID, 8, '0'),-7,1),Cadena_Vacia) AS ClienteID7,
		IFNULL(SUBSTRING(LPAD(Var_ClienteID, 8, '0'),-6,1),Cadena_Vacia) AS ClienteID6,
		IFNULL(SUBSTRING(LPAD(Var_ClienteID, 8, '0'),-5,1),Cadena_Vacia) AS ClienteID5,
		IFNULL(SUBSTRING(LPAD(Var_ClienteID, 8, '0'),-4,1),Cadena_Vacia) AS ClienteID4,
		IFNULL(SUBSTRING(LPAD(Var_ClienteID, 8, '0'),-3,1),Cadena_Vacia) AS ClienteID3,
		IFNULL(SUBSTRING(LPAD(Var_ClienteID, 8, '0'),-2,1),Cadena_Vacia) AS ClienteID2,
		IFNULL(SUBSTRING(LPAD(Var_ClienteID, 8, '0'),-1,1),Cadena_Vacia) AS ClienteID1,

		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-8,1),Cadena_Vacia) AS GrupoID8,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-7,1),Cadena_Vacia) AS GrupoID7,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-6,1),Cadena_Vacia) AS GrupoID6,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-5,1),Cadena_Vacia) AS GrupoID5,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-4,1),Cadena_Vacia) AS GrupoID4,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-3,1),Cadena_Vacia) AS GrupoID3,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-2,1),Cadena_Vacia) AS GrupoID2,
		IFNULL(SUBSTRING(LPAD(Var_GrupoID, 8, '0'),-1,1),Cadena_Vacia) AS GrupoID1,

		IFNULL(Var_FechaSistema,Cadena_Vacia) AS FechaSistema,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_FechaSistema, '%Y'),4,'0'),-4,1), Cadena_Vacia) AS FechaSistemaY4,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_FechaSistema, '%Y'),4,'0'),-3,1), Cadena_Vacia) AS FechaSistemaY3,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_FechaSistema, '%Y'),4,'0'),-2,1), Cadena_Vacia) AS FechaSistemaY2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_FechaSistema, '%Y'),4,'0'),-1,1), Cadena_Vacia) AS FechaSistemaY1,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_FechaSistema, '%m'),2,'0'),-2,1), Cadena_Vacia) AS FechaSistemaM2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_FechaSistema, '%m'),2,'0'),-1,1), Cadena_Vacia) AS FechaSistemaM1,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_FechaSistema, '%d'),2,'0'),-2,1), Cadena_Vacia) AS FechaSistemaD2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_FechaSistema, '%d'),2,'0'),-1,1), Cadena_Vacia) AS FechaSistemaD1,

		IFNULL(Var_NombreSucur,Cadena_Vacia) AS NombreSucur,
		IFNULL(Var_NombreCliente,Cadena_Vacia) AS NombreCliente,
		IFNULL(Var_ApePaterno,Cadena_Vacia) AS ApePaterno,
		IFNULL(Var_ApeMaterno,Cadena_Vacia) AS ApeMaterno,
		IFNULL(FNGENNOMBRECOMPLETO (Var_NombreCliente,Cadena_Vacia,Cadena_Vacia,Var_ApePaterno,Var_ApeMaterno),Cadena_Vacia) AS CliNombreComplet,

		IFNULL(Var_CliFechaNac,Cadena_Vacia) AS CliFechaNac,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_CliFechaNac, '%Y'),4,'0'),-4,1), Cadena_Vacia) AS FechaNacY4,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_CliFechaNac, '%Y'),4,'0'),-3,1), Cadena_Vacia) AS FechaNacY3,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_CliFechaNac, '%Y'),4,'0'),-2,1), Cadena_Vacia) AS FechaNacY2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_CliFechaNac, '%Y'),4,'0'),-1,1), Cadena_Vacia) AS FechaNacY1,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_CliFechaNac, '%m'),2,'0'),-2,1), Cadena_Vacia) AS FechaNacM2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_CliFechaNac, '%m'),2,'0'),-1,1), Cadena_Vacia) AS FechaNacM1,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_CliFechaNac, '%d'),2,'0'),-2,1), Cadena_Vacia) AS FechaNacD2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_CliFechaNac, '%d'),2,'0'),-1,1), Cadena_Vacia) AS FechaNacD1,

		IFNULL(Var_NomPais,Cadena_Vacia) AS PaisNac,
		IF(IFNULL(Var_CliNacion,Cadena_Vacia)='N','MEXICANA','EXTRANJERA') AS CliNacion,

		IFNULL(Var_CliCURP,Cadena_Vacia) AS CliCURP,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-18,1),Cadena_Vacia) AS CURP18,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-17,1),Cadena_Vacia) AS CURP17,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-16,1),Cadena_Vacia) AS CURP16,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-15,1),Cadena_Vacia) AS CURP15,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-14,1),Cadena_Vacia) AS CURP14,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-13,1),Cadena_Vacia) AS CURP13,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-12,1),Cadena_Vacia) AS CURP12,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-11,1),Cadena_Vacia) AS CURP11,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-10,1),Cadena_Vacia) AS CURP10,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-9,1),Cadena_Vacia) AS CURP9,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-8,1),Cadena_Vacia) AS CURP8,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-7,1),Cadena_Vacia) AS CURP7,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-6,1),Cadena_Vacia) AS CURP6,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-5,1),Cadena_Vacia) AS CURP5,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-4,1),Cadena_Vacia) AS CURP4,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-3,1),Cadena_Vacia) AS CURP3,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-2,1),Cadena_Vacia) AS CURP2,
		IFNULL(SUBSTRING(LEFT(Var_CliCURP, 18),-1,1),Cadena_Vacia) AS CURP1,

		IFNULL(Var_CliRFC,Cadena_Vacia) AS CliRFC,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-13,1),Cadena_Vacia) AS RFC13,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-12,1),Cadena_Vacia) AS RFC12,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-11,1),Cadena_Vacia) AS RFC11,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-10,1),Cadena_Vacia) AS RFC10,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-9,1),Cadena_Vacia) AS RFC9,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-8,1),Cadena_Vacia) AS RFC8,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-7,1),Cadena_Vacia) AS RFC7,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-6,1),Cadena_Vacia) AS RFC6,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-5,1),Cadena_Vacia) AS RFC5,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-4,1),Cadena_Vacia) AS RFC4,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-3,1),Cadena_Vacia) AS RFC3,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-2,1),Cadena_Vacia) AS RFC2,
		IFNULL(SUBSTRING(LEFT(Var_CliRFC, 18),-1,1),Cadena_Vacia) AS RFC1,

		IFNULL(Var_Escolaridad,Cadena_Vacia) 	AS Escolaridad,
		IFNULL(Var_CliCalle,Cadena_Vacia) 		AS CliCalle,
		IFNULL(Var_CliNumCasa,Cadena_Vacia) 	AS CliNumCasa,
		IFNULL(Var_CliNumInt,Cadena_Vacia) 		AS CliNumInt,
		IFNULL(Var_CliCP,Cadena_Vacia) 			AS CliCP,
		IFNULL(Var_CliColonia,Cadena_Vacia) 	AS CliColoni,
		IFNULL(Var_1aEntreCalle,Cadena_Vacia) 	AS PriEntreCalle,
		IFNULL(Var_2aEntreCalle,Cadena_Vacia)	AS SegEntreCalle,
		IFNULL(Var_NombreLoc,Cadena_Vacia) 		AS NombreLoc,
        IFNULL(Var_CliAniosRes,Cadena_Vacia)   AS CliAniosRes,
		IFNULL(SUBSTRING(LPAD(Var_CliAniosRes, 2, '0'),-2,1),Cadena_Vacia) AS CliAniosRes1,
		IFNULL(SUBSTRING(LPAD(Var_CliAniosRes, 2, '0'),-1,1),Cadena_Vacia) AS CliAniosRes2,

		IFNULL(Var_CliOcupacion,Cadena_Vacia)   AS CliOcupacion,
		IFNULL(Var_DomTrabajoCli,Cadena_Vacia)   AS CliDomTrabajo,
		IFNULL(Var_CliActividad,Cadena_Vacia)   AS CliActividad,
		IFNULL(Var_CliMontoIngrMen,Cadena_Vacia)   AS CliIngrMensual,
		IFNULL(Var_CliPeps,Cadena_Vacia)   AS CliPeps,
		IFNULL(Var_ParentPeps,Cadena_Vacia)   AS CliParentPeps,
		IFNULL(Var_CliPepsNombre,Cadena_Vacia)   AS CliPepsNombre,


		IFNULL(Var_CliMunici,Cadena_Vacia) 		AS CliMunici,
		IFNULL(Var_NomEstado,Cadena_Vacia) 		AS NomEstado,
		IFNULL(Var_NumIdentif,Cadena_Vacia) 	AS NumIdentif,
		IFNULL(Var_TipoIdentif,Cadena_Vacia) 	AS TipoIdentif,
		IF(IFNULL(Var_CliSexo,Cadena_Vacia)='F',Var_X,Cadena_Vacia) AS CliSexoF,
		IF(IFNULL(Var_CliSexo,Cadena_Vacia)='M',Var_X,Cadena_Vacia) AS CliSexoM,
		IFNULL(Var_CliCorreo,Cadena_Vacia) 		AS CliCorreo,

		CASE WHEN IFNULL(Var_CliTelCel,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS CliTelCel,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-10,1),Cadena_Vacia) AS TelCel10,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-9,1),Cadena_Vacia) AS TelCel9,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-8,1),Cadena_Vacia) AS TelCel8,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-7,1),Cadena_Vacia) AS TelCel7,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-6,1),Cadena_Vacia) AS TelCel6,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-5,1),Cadena_Vacia) AS TelCel5,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-4,1),Cadena_Vacia) AS TelCel4,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-3,1),Cadena_Vacia) AS TelCel3,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-2,1),Cadena_Vacia) AS TelCel2,
		IFNULL(SUBSTRING(LPAD(Var_CliTelCel, 10, '0'),-1,1),Cadena_Vacia) AS TelCel1,
		CASE WHEN IFNULL(Var_CliTelCel,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS CliTelFijo,

		CASE WHEN IFNULL(Var_TelefonoRef,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS TelefonoRef,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-10,1),Cadena_Vacia) AS TelRef10,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-9,1),Cadena_Vacia) AS TelRef9,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-8,1),Cadena_Vacia) AS TelRef8,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-7,1),Cadena_Vacia) AS TelRef7,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-6,1),Cadena_Vacia) AS TelRef6,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-5,1),Cadena_Vacia) AS TelRef5,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-4,1),Cadena_Vacia) AS TelRef4,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-3,1),Cadena_Vacia) AS TelRef3,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-2,1),Cadena_Vacia) AS TelRef2,
		IFNULL(SUBSTRING(LPAD(Var_TelefonoRef, 10, '0'),-1,1),Cadena_Vacia) AS TelRef1,
        CASE WHEN IFNULL(Var_TelefonoRef,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS CliTelCelMovil,

		IFNULL(Var_TipoVivienda,Cadena_Vacia) AS TipoVivienda,
		IFNULL(Var_EstadoCivil,Cadena_Vacia) AS EstadoCivil,
		IFNULL(Var_Hipoteca,Cadena_Vacia) AS Hipoteca,

		-- DATOS DEPENDIENTES
		IFNULL(Var_NumDep,Cadena_Vacia) AS NumDep,
		IFNULL(Var_Dep1NombreHijo1,Cadena_Vacia) AS DepHijo1Nombre,
		IFNULL(Var_Dep1NombreHijo2,Cadena_Vacia) AS DepHijo2Nombre,
		IFNULL(Var_Dep1NombreHijo3,Cadena_Vacia) AS DepHijo3Nombre,
		IFNULL(Var_Dep1NombreHijo4,Cadena_Vacia) AS DepHijo4Nombre,
		IFNULL(Var_Dep1NombreHijo5,Cadena_Vacia) AS DepHijo5Nombre,
		IFNULL(Var_Dep1NombreHijo6,Cadena_Vacia) AS DepHijo6Nombre,
		IFNULL(Var_Dep1NombreHijo7,Cadena_Vacia) AS DepHijo7Nombre,


		IFNULL(Var_DepNomComp,Cadena_Vacia) AS DepNomComp,
		IFNULL(Var_DepOcupacion,Cadena_Vacia) AS DepOcupacion,
		IFNULL(Var_DepParentesco,Cadena_Vacia) AS DepParentesco,

		-- DATOS CONYUGE
		IFNULL(Var_ConyNom,Cadena_Vacia) 	AS ConyNom,
		IFNULL(Var_ConyOcupa,Cadena_Vacia) AS ConyOcupa,

		IFNULL(Var_ConyFecNac,Cadena_Vacia) AS ConyFecNac,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_ConyFecNac, '%Y'),4,'0'),-4,1), Cadena_Vacia) AS ConyFechaNacY4,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_ConyFecNac, '%Y'),4,'0'),-3,1), Cadena_Vacia) AS ConyFechaNacY3,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_ConyFecNac, '%Y'),4,'0'),-2,1), Cadena_Vacia) AS ConyFechaNacY2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_ConyFecNac, '%Y'),4,'0'),-1,1), Cadena_Vacia) AS ConyFechaNacY1,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_ConyFecNac, '%m'),2,'0'),-2,1), Cadena_Vacia) AS ConyFechaNacM2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_ConyFecNac, '%m'),2,'0'),-1,1), Cadena_Vacia) AS ConyFechaNacM1,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_ConyFecNac, '%d'),2,'0'),-2,1), Cadena_Vacia) AS ConyFechaNacD2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_ConyFecNac, '%d'),2,'0'),-1,1), Cadena_Vacia) AS ConyFechaNacD1,

		IFNULL(Var_ConyID,Cadena_Vacia) AS ConyID,
		IFNULL(SUBSTRING(LPAD(Var_ConyID, 8, '0'),-8,1),Cadena_Vacia) AS ConyID8,
		IFNULL(SUBSTRING(LPAD(Var_ConyID, 8, '0'),-7,1),Cadena_Vacia) AS ConyID7,
		IFNULL(SUBSTRING(LPAD(Var_ConyID, 8, '0'),-6,1),Cadena_Vacia) AS ConyID6,
		IFNULL(SUBSTRING(LPAD(Var_ConyID, 8, '0'),-5,1),Cadena_Vacia) AS ConyID5,
		IFNULL(SUBSTRING(LPAD(Var_ConyID, 8, '0'),-4,1),Cadena_Vacia) AS ConyID4,
		IFNULL(SUBSTRING(LPAD(Var_ConyID, 8, '0'),-3,1),Cadena_Vacia) AS ConyID3,
		IFNULL(SUBSTRING(LPAD(Var_ConyID, 8, '0'),-2,1),Cadena_Vacia) AS ConyID2,
		IFNULL(SUBSTRING(LPAD(Var_ConyID, 8, '0'),-1,1),Cadena_Vacia) AS ConyID1,

		-- DATOS DE LA OCUPACION, EMPLEO O NEGOCIO
		IFNULL(Var_TipoDireccion,Cadena_Vacia) 	AS TipoDireccion,
		IFNULL(Var_LugarTrabajo,Cadena_Vacia) 	AS LugarTrabajo,
		IFNULL(Var_Puesto,Cadena_Vacia) 		AS Puesto,
		IFNULL(Var_IngresDeclaFinS,Cadena_Vacia) 	AS IngresDeclaFinS,
		IFNULL(Var_Antiguedad,Cadena_Vacia) 	AS Antiguedad,

		IFNULL(SUBSTRING(LPAD(Var_Antiguedad, 5, '0'),-5,1),'') AS AntY2,
		IFNULL(SUBSTRING(LPAD(Var_Antiguedad, 5, '0'),-4,1),'') AS AntY1,
		IFNULL(SUBSTRING(LPAD(Var_Antiguedad, 5, '0'),-2,1),'') AS AntM2,
		IFNULL(SUBSTRING(LPAD(Var_Antiguedad, 5, '0'),-1,1),'') AS AntM1,

		IFNULL(Var_EmpCalle,Cadena_Vacia) 		AS EmpCalle ,
		IFNULL(Var_EmpNumCasa,Cadena_Vacia) 	AS EmpNumCasa,
		IFNULL(Var_EmpNumInt,Cadena_Vacia) 		AS EmpNumInt,
		IFNULL(Var_EmpCP,Cadena_Vacia) 			AS EmpCP,
		IFNULL(Var_EmpColonia,Cadena_Vacia) 	AS EmpColonia,
		IFNULL(Var_Emp1aEntreCalle,Cadena_Vacia) 	AS Emp1aEntreCalle	,
		IFNULL(Var_Emp2aEntreCalle,Cadena_Vacia) 	AS Emp2aEntreCalle,
		IFNULL(Var_EmpLoc,Cadena_Vacia) 		AS EmpLoc	,
		IFNULL(Var_EmpMunici,Cadena_Vacia) 		AS EmpMunici,
		IFNULL(Var_EmpEstado,Cadena_Vacia) 		AS EmpEstado,

		CASE WHEN IFNULL(Var_EmpTel,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS EmpTel,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-10,1),Cadena_Vacia) AS EmpTel10,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-9,1),Cadena_Vacia) AS EmpTel9,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-8,1),Cadena_Vacia) AS EmpTel8,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-7,1),Cadena_Vacia) AS EmpTel7,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-6,1),Cadena_Vacia) AS EmpTel6,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-5,1),Cadena_Vacia) AS EmpTel5,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-4,1),Cadena_Vacia) AS EmpTel4,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-3,1),Cadena_Vacia) AS EmpTel3,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-2,1),Cadena_Vacia) AS EmpTel2,
		IFNULL(SUBSTRING(LPAD(Var_EmpTel, 10, '0'),-1,1),Cadena_Vacia) AS EmpTel1,
        CASE WHEN IFNULL(Var_EmpTel,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS EmpTelFijo,
		IFNULL(Var_EmpTelExt,Cadena_Vacia) 		AS EmpTelExt,

        -- DATOS PERFIL TRANS
        IFNULL(Var_ImporteDep,Cadena_Vacia) AS ImporteDep,
		IFNULL(Var_ImporteRet,Cadena_Vacia) AS ImporteRet,
		IFNULL(Var_NumDepos,Cadena_Vacia) AS NumDepos,
		IFNULL(Var_NumRet,Cadena_Vacia) AS NumRet,

		-- DATOS DE REFERENCIAS

		IFNULL(Var_NombreRef1,Cadena_Vacia) AS RefNombre,
		IFNULL(Var_DesRelacion1,Cadena_Vacia) AS RefParent,

		CASE WHEN IFNULL(Var_TelRef1,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS RefTel,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-10,1),Cadena_Vacia) AS RefTel10,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-9,1),Cadena_Vacia) AS RefTel9,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-8,1),Cadena_Vacia) AS RefTel8,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-7,1),Cadena_Vacia) AS RefTel7,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-6,1),Cadena_Vacia) AS RefTel6,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-5,1),Cadena_Vacia) AS RefTel5,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-4,1),Cadena_Vacia) AS RefTel4,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-3,1),Cadena_Vacia) AS RefTel3,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-2,1),Cadena_Vacia) AS RefTel2,
		IFNULL(SUBSTRING(LPAD(Var_TelRef1, 10, '0'),-1,1),Cadena_Vacia) AS RefTel1,
		CASE WHEN IFNULL(Var_TelRef1,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS RefTelFijo,

		IFNULL(Var_ExtTelRef1,Cadena_Vacia) AS RefExtTel,
		IFNULL(Var_NombreRef2,Cadena_Vacia) AS RefNombre2,
		IFNULL(Var_DesRelacion2,Cadena_Vacia) AS RefParent2,

        CASE WHEN IFNULL(Var_TelRef2,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS Ref2Tel,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-10,1),Cadena_Vacia) AS RefTel210,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-9,1),Cadena_Vacia) AS RefTel29,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-8,1),Cadena_Vacia) AS RefTel28,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-7,1),Cadena_Vacia) AS RefTel27,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-6,1),Cadena_Vacia) AS RefTel26,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-5,1),Cadena_Vacia) AS RefTel25,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-4,1),Cadena_Vacia) AS RefTel24,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-3,1),Cadena_Vacia) AS RefTel23,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-2,1),Cadena_Vacia) AS RefTel22,
		IFNULL(SUBSTRING(LPAD(Var_TelRef2, 10, '0'),-1,1),Cadena_Vacia) AS RefTel21,
		IFNULL(Var_ExtTelRef2,Cadena_Vacia) AS RefExtTel2,
    	CASE WHEN IFNULL(Var_TelRef2,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS Ref2TelFijo,
        IFNULL(Var_RelNombre,Cadena_Vacia) AS RelNombre,
		IFNULL(Var_RelParent,Cadena_Vacia) AS RelParent,
      	CASE WHEN IFNULL(Var_RelNombre,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS Relacion

			;
END IF;

-- ---------------------------------------------------------------------------------
-- Cédula de identificación del cliente
-- ---------------------------------------------------------------------------------
IF(Par_TipoReporte = DatosCedula)THEN

	SELECT IFNULL(Cli.NombreCompleto, Cadena_Vacia), IFNULL(Pro.NombrePromotor,Cadena_Vacia)
	INTO   Var_NombreCte,   Var_NombrePromotor
	FROM SOLICITUDCREDITO Sol
	LEFT JOIN CLIENTES Cli              ON Sol.ClienteID = Cli.ClienteID
	INNER JOIN PROMOTORES  Pro     ON Pro.PromotorID=Sol.PromotorID
	WHERE   Sol.SolicitudCreditoID = Var_SolicitudCreID
	LIMIT 1;

	SELECT count(Ava.AvalID), FNGENNOMBRECOMPLETO(Ava.PrimerNombre,Ava.SegundoNombre,Ava.TercerNombre,Cadena_Vacia,Cadena_Vacia),
			Ava.ApellidoPaterno, Ava.ApellidoMaterno, Ava.FechaNac, Ava.LugarNacimiento, Ava.Nacion,
			Ava.RFC, Ava.Calle, Ava.NumExterior, Ava.NumInterior, Ava.CP, Ava.Colonia, Loc.NombreLocalidad,
			Mun.Nombre, Est.Nombre, Ava.Sexo, Ava.Telefono, Ava.TelefonoCel, Ava.EstadoCivil
	INTO Var_NumAval, Var_AvalNombre, Var_AvalApePaterno, Var_AvalApeMaterno, Var_AvalFechaNac, Var_AvalPaisNac, Var_AvalNacion,
		Var_AvalRFC, Var_AvalCalle, Var_AvalNumCasa, Var_AvalNumInt, Var_AvalCP, Var_AvalColonia, Var_AvalLocal,
		Var_AvalMuni, Var_AvalEstado, Var_AvalSexo, Var_AvalTel, Var_AvalTelCel, Var_AvalEstCivil
	FROM AVALES Ava
		INNER JOIN AVALESPORSOLICI AvaSol ON Ava.AvalID = AvaSol.AvalID
		LEFT OUTER JOIN ESTADOSREPUB		Est	ON  Ava.EstadoID = Est.EstadoID
				LEFT OUTER JOIN MUNICIPIOSREPUB	Mun		ON 	Ava.MunicipioID = Mun.MunicipioID AND Ava.EstadoID = Mun.EstadoID
				LEFT OUTER JOIN LOCALIDADREPUB   Loc	ON  Ava.LocalidadID = Loc.LocalidadID  AND Ava.EstadoID = Loc.EstadoID AND Ava.MunicipioID = Loc.MunicipioID
	WHERE AvaSol.SolicitudCreditoID = Var_SolicitudCreID GROUP BY Ava.AvalID LIMIT 1;


	SELECT
		Nombre
	INTO
		Var_AvalNomPais
	FROM PAISES
		WHERE PaisID = Var_AvalPaisNac;

	SELECT
		IFNULL(Var_SolicitudCreID,Cadena_Vacia) AS SolicitudCreID,
    	IFNULL(Var_NumAval,Entero_Cero) AS NumAval,
		IFNULL(Var_AvalNombre,Cadena_Vacia) AS AvalNombre,
		IFNULL(Var_AvalApePaterno,Cadena_Vacia) AS AvalApePaterno,
		IFNULL(Var_AvalApeMaterno,Cadena_Vacia) AS AvalApeMaterno,


		IFNULL(Var_AvalFechaNac,Cadena_Vacia) AS AvalFechaNac,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_AvalFechaNac, '%Y'),4,'0'),-4,1), Cadena_Vacia) AS AvalFechaNacY4,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_AvalFechaNac, '%Y'),4,'0'),-3,1), Cadena_Vacia) AS AvalFechaNacY3,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_AvalFechaNac, '%Y'),4,'0'),-2,1), Cadena_Vacia) AS AvalFechaNacY2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_AvalFechaNac, '%Y'),4,'0'),-1,1), Cadena_Vacia) AS AvalFechaNacY1,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_AvalFechaNac, '%m'),2,'0'),-2,1), Cadena_Vacia) AS AvalFechaNacM2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_AvalFechaNac, '%m'),2,'0'),-1,1), Cadena_Vacia) AS AvalFechaNacM1,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_AvalFechaNac, '%d'),2,'0'),-2,1), Cadena_Vacia) AS AvalFechaNacD2,
		IFNULL(SUBSTRING(LPAD(DATE_FORMAT(Var_AvalFechaNac, '%d'),2,'0'),-1,1), Cadena_Vacia) AS AvalFechaNacD1,

		IFNULL(Var_AvalNomPais,Cadena_Vacia) AS AvalPaisNac,
   		CASE WHEN IFNULL(Var_AvalNacion,Cadena_Vacia) = 'N' THEN 'MEXICANA'
			 WHEN IFNULL(Var_AvalNacion,Cadena_Vacia) = 'E' THEN 'EXTRANJERA'
        ELSE Cadena_Vacia END AS AvalNacion,

		IFNULL(Var_AvalRFC,Cadena_Vacia) AS AvalRFC,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-13,1),Cadena_Vacia) AS AvalRFC13,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-12,1),Cadena_Vacia) AS AvalRFC12,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-11,1),Cadena_Vacia) AS AvalRFC11,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-10,1),Cadena_Vacia) AS AvalRFC10,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-9,1),Cadena_Vacia) AS AvalRFC9,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-8,1),Cadena_Vacia) AS AvalRFC8,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-7,1),Cadena_Vacia) AS AvalRFC7,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-6,1),Cadena_Vacia) AS AvalRFC6,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-5,1),Cadena_Vacia) AS AvalRFC5,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-4,1),Cadena_Vacia) AS AvalRFC4,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-3,1),Cadena_Vacia) AS AvalRFC3,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-2,1),Cadena_Vacia) AS AvalRFC2,
		IFNULL(SUBSTRING(LEFT(Var_AvalRFC, 18),-1,1),Cadena_Vacia) AS AvalRFC1,

		IFNULL(Var_AvalCalle,Cadena_Vacia) AS AvalCalle,
		IFNULL(Var_AvalNumCasa,Cadena_Vacia) AS AvalNumCasa,
		IFNULL(Var_AvalNumInt,Cadena_Vacia) AS AvalNumInt,
		IFNULL(Var_AvalCP,Cadena_Vacia) AS AvalCP,
		IFNULL(Var_AvalColonia,Cadena_Vacia) AS AvalColonia,
		IFNULL(Var_AvalLocal,Cadena_Vacia) AS AvalLocal,
		IFNULL(Var_AvalMuni,Cadena_Vacia) AS AvalMuni,
		IFNULL(Var_AvalEstado,Cadena_Vacia) AS AvalEstado,
		IFNULL(Var_AvalSexo,Cadena_Vacia) AS AvalSexo,
		IF(IFNULL(Var_AvalSexo,Cadena_Vacia)='F',Var_X,Cadena_Vacia) AS AvalSexoF,
		IF(IFNULL(Var_AvalSexo,Cadena_Vacia)='M',Var_X,Cadena_Vacia) AS AvalSexoM,

		CASE WHEN IFNULL(Var_AvalTel,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS AvalTel,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-10,1),Cadena_Vacia) AS AvalTel10,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-9,1),Cadena_Vacia) AS AvalTel9,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-8,1),Cadena_Vacia) AS AvalTel8,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-7,1),Cadena_Vacia) AS AvalTel7,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-6,1),Cadena_Vacia) AS AvalTel6,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-5,1),Cadena_Vacia) AS AvalTel5,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-4,1),Cadena_Vacia) AS AvalTel4,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-3,1),Cadena_Vacia) AS AvalTel3,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-2,1),Cadena_Vacia) AS AvalTel2,
		IFNULL(SUBSTRING(LPAD(Var_AvalTel, 10, '0'),-1,1),Cadena_Vacia) AS AvalTel1,
		CASE WHEN IFNULL(Var_AvalTel,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS AvalTelFijo,

		CASE WHEN IFNULL(Var_AvalTelCel,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS AvalTelCel,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-10,1),Cadena_Vacia) AS AvalTelCel10,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-9,1),Cadena_Vacia) AS AvalTelCel9,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-8,1),Cadena_Vacia) AS AvalTelCel8,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-7,1),Cadena_Vacia) AS AvalTelCel7,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-6,1),Cadena_Vacia) AS AvalTelCel6,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-5,1),Cadena_Vacia) AS AvalTelCel5,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-4,1),Cadena_Vacia) AS AvalTelCel4,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-3,1),Cadena_Vacia) AS AvalTelCel3,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-2,1),Cadena_Vacia) AS AvalTelCel2,
		IFNULL(SUBSTRING(LPAD(Var_AvalTelCel, 10, '0'),-1,1),Cadena_Vacia) AS AvalTelCel1,
		CASE WHEN IFNULL(Var_AvalTelCel,Cadena_Vacia) = Cadena_Vacia THEN Var_NO ELSE Var_SI END AS AvalTelMovil,

		IFNULL(Var_AvalEstCivil,Cadena_Vacia) AS AvalEstCivil,
		IFNULL(Var_GrupoID,Cadena_Vacia) AS GrupoID,
		IFNULL(Var_DescProducto,Cadena_Vacia) AS DescProducto,
		IFNULL(Var_NomGrupo,Cadena_Vacia) AS     NombreGrupo,
		IFNULL(Var_FOGA,Cadena_Vacia) AS         PorcFOGA,

		IFNULL(Var_PlazoID,Cadena_Vacia) AS         SoliciPlazo,
		IFNULL(Var_MontoSolici,Cadena_Vacia) AS         SoliciMonto,
		IFNULL(Var_NomProyecto,Cadena_Vacia) AS         SoliciNomProyect,
		IFNULL(Var_TipoCredito,Cadena_Vacia) AS         TipoCredito,
		IFNULL(Var_FrecuenciaCap,Cadena_Vacia) AS       FrecuenciaCap,
		IFNULL(FNGENNOMBRECOMPLETO (Var_NombreCliente,Cadena_Vacia,Cadena_Vacia,Var_ApePaterno,Var_ApeMaterno),Cadena_Vacia) AS CliNombreComplet,
		IFNULL(Var_CliFechaNac,Cadena_Vacia) AS CliFechaNac,
		IFNULL(Var_ConyNom,Cadena_Vacia) 	AS ConyNom,
		IFNULL(Var_ConyFecNac,Cadena_Vacia) AS ConyFecNac,
		IFNULL(Var_Dep1NombreHijo1,Cadena_Vacia) AS DepHijo1Nombre,
		IFNULL(Var_Dep1NombreHijo2,Cadena_Vacia) AS DepHijo2Nombre,
		IFNULL(Var_Dep1NombreHijo3,Cadena_Vacia) AS DepHijo3Nombre,
		IFNULL(Var_Dep1NombreHijo4,Cadena_Vacia) AS DepHijo4Nombre,
		IFNULL(Var_Dep1NombreHijo5,Cadena_Vacia) AS DepHijo5Nombre,
		IFNULL(Var_Dep1NombreHijo6,Cadena_Vacia) AS DepHijo6Nombre,
		IFNULL(Var_Dep1NombreHijo7,Cadena_Vacia) AS DepHijo7Nombre,
		IFNULL(Var_CreditoID,Cadena_Vacia) AS CreditoID,
		IFNULL(Var_SaldoCredAnteri,Cadena_Vacia) AS SaldoCredAnteri,
		IFNULL(Var_SaldoFOGAFI,"0") AS SaldoFOGAFI,
		IFNULL(Var_MontoCuota,"0.00") AS MontoCuota,
		IFNULL(round(Var_TasaFija,2),Cadena_Vacia) AS TasaFija,
		IFNULL(Var_NombreCte,Cadena_Vacia) AS NombreCte,
		IFNULL(Var_NombrePromotor,Cadena_Vacia) AS NombrePromotor;
END IF;


END TerminaStore$$