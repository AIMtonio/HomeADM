-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESLIS`;

DELIMITER $$
CREATE PROCEDURE `CLIENTESLIS`(
	# =====================================================================================
	# ----- SP QUE LISTA LOS CLIENTES REGISTRADOS -----------------
	# =====================================================================================
	Par_NombreComp				VARCHAR(50),			# Nombre del Cliente
	Par_SucursalID				INT(11),				# Numero de Sucursal
	Par_NumLis					TINYINT UNSIGNED,		# Numero de Lista
	Par_ClienteID				INT(11),				# Numero de Cliente

	-- Parametros de Auditoria
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	NumErr		 			INT(11);
DECLARE	ErrMen					VARCHAR(40);
DECLARE Var_FechaSis			DATE;

-- Declaracion de Constantes
DECLARE		Lis_Principal		INT(11);
DECLARE		Lis_CteSucursal	    INT(11);
DECLARE		Lis_EnvioSMS		INT(11);
DECLARE     Lis_EnvioSMSSUC     INT(11);
DECLARE		Lis_CorpRel			INT(11);
DECLARE     Lis_CorpRelSuc      INT(11);
DECLARE     Lis_Menor   		INT(11);
DECLARE     Lis_MenorSuc        INT(11);
DECLARE     Lis_Activos   		INT(11);
DECLARE     Lis_ActivosSuc      INT(11);
DECLARE 	Lis_Inactivacion	INT(11);
DECLARE  	Lis_InactivaSuc     INT(11);
DECLARE		Cons_Moral			CHAR(1);
DECLARE		Cons_CorpRel		CHAR(1);
DECLARE     Es_Menor     		CHAR(1);
DECLARE		Nac_Extranjero		CHAR(1);
DECLARE 	Lis_Nacion			INT(11);
DECLARE 	Lis_NacionSuc		INT(11);
DECLARE 	Lis_ClienteWS		INT(11);
DECLARE 	Lis_PersonaFisica	INT(11);
DECLARE     Lis_PersonaFisiSuc  INT(11);
DECLARE		Fisica_Empresa		CHAR(1);
DECLARE 	Fisica_NoEmpresa	CHAR(1);
DECLARE 	Estatus_Activo		CHAR(1);
DECLARE     Estatus_Inactivo	CHAR(1);
DECLARE 	Lis_MenoresInact	INT(11);
DECLARE 	Lis_MayoresActivos	INT(11);
DECLARE     Lis_MayoresEdadSuc	INT(11);
DECLARE 	Lis_MayoresActSuc	INT(11);
DECLARE 	Lis_ParaTutor		INT(11);
DECLARE 	Lis_MayoresEdad		INT(11);
DECLARE 	MayorEdad			INT(11);
DECLARE 	Lis_ReactivacionCte INT(11);
DECLARE     Lis_ReactCteSuc		INT(11);
DECLARE 	Lis_CtePorSucursal	INT(11);
DECLARE 	Lis_CteCancelado	INT(11);
DECLARE 	CadenaVacia			CHAR(1);
DECLARE 	Lis_General			INT(11);
DECLARE 	Lis_ReacCteSucVen	INT(11);
DECLARE		ListaExterna		INT(11);
DECLARE 	Lis_DepGarantiaGene	INT(11);
DECLARE     Lis_DepGarantiaSuc  INT(11);
DECLARE 	Lis_ActInact		INT(11);
DECLARE 	EstatusRegistrada	CHAR(1);
DECLARE 	Entero_Cero			INT(11);
DECLARE  	CadenaSi			CHAR(1);
DECLARE 	Lis_BusquedaSEIDO	INT(1);
DECLARE 	Lis_CliMoral		INT(11);
DECLARE 	EstaInactivo		VARCHAR(8);
DECLARE		EstaActivo			VARCHAR(6);
DECLARE 	Fecha_Vacia			DATE;
DECLARE		Cadena_Vacia		CHAR(1);
DECLARE		Activo				CHAR(1);
DECLARE		Inactivo			CHAR(1);
DECLARE		Lis_Aportaciones	INT(11);
DECLARE 	Lis_CliBitaDomici	INT(11);
DECLARE Est_Vigente				CHAR(1);
DECLARE Est_Vencido				CHAR(1);
DECLARE Lis_CliCreditoConsolidado	TINYINT UNSIGNED;-- Lista de Cliente Para la pantalla Solicitud de Credito Consolidada


-- Asignacion de Constantes
SET	Lis_Principal				:= 1;				-- Lista Principal
SET	Lis_EnvioSMS				:= 2;				-- lista para la pantalla envioSMS
SET	Lis_CorpRel					:= 3; 				-- lista para obtener los clientes corporativos
SET Lis_Menor	     			:= 5;				-- Lista de clientes menores --
SET Lis_Nacion					:= 6;				-- lista los clientes que son de nacionalidad extranjera*/
SET Lis_ClienteWS	    		:= 7;               -- lista clieNtes WS
SET Lis_PersonaFisica   		:= 8;				-- Lista los clientes que son personas fisicas y personas fisicas con actividad empresarial
SET Lis_Activos					:= 9;				-- Lista los clientes ACtivos*/
SET Lis_Inactivacion			:= 10;				-- lISTA TODOS LOS CLIENTES INACTIVOS*/
SET	Cons_Moral					:= 'M'; 			-- lista para obtener los clientes corporativos
SET	Cons_CorpRel				:= 'C'; 			-- lista para obtener los clientes corporativos
SET Es_Menor	     			:= 'S';      		-- Si es menor de edad --
SET Nac_Extranjero				:= 'E';				-- Nacionalidad Extranjero --
SET	Fisica_Empresa				:= 'A';				-- Persona fisica con actividad empresarial
SET Fisica_NoEmpresa			:= 'F';				-- Persona fisioa sin actividad empresarial
SET Estatus_Activo				:= 'A';				-- cliente con estatus activo
SET Estatus_Inactivo			:='I';				-- Estatus Inactivo
SET Lis_MenoresInact			:= 11;				-- Lista Los Menores Inactivos
SET Lis_MayoresActivos			:= 12;				-- lista clientes mayores de edad activos --
SET Lis_ParaTutor				:= 13;				-- lista clientes que pueden ser tutore --
SET Lis_MayoresEdad				:= 14;				-- lista clientes mayores de edad--
SET Lis_ReactivacionCte			:= 15;				-- Lista de clientes que pueden reactivarse y pagar en ventanilla --
SET Lis_CtePorSucursal			:= 16;				-- Lista los clientes de una sucursal --
SET MayorEdad					:= 18;				-- Lista Mayor edad --

SET Lis_CteSucursal				:= 19;				-- Lista Cliente Surcursal --
SET Lis_MayoresActSuc			:= 20;				-- Lista clientes mayores por sucursal actual--
SET Lis_NacionSuc				:= 21;				-- Lista Nacion Sucursal --
SET Lis_InactivaSuc				:= 22;				-- Lista clientes sucursal --
SET Lis_MenorSuc				:= 23;				-- Lista clientes menores sucursal --
SET Lis_PersonaFisiSuc			:= 24;				-- Lista de clientes como Personas Fisicas empreariales o no empresariales --
SET Lis_ActivosSuc				:= 25;				-- Lista de clientes activos de una sucursal --
SET Lis_MayoresEdadSuc			:= 26;				-- Lista de Mayores de edad de una sucursal --
SET Lis_ReactCteSuc				:= 27;				-- Lista de clientes de una sucursal que se pueden reactivar --
SET Lis_EnvioSMSSuc             := 28;				-- Lista de EnvioSMS de una sucursal --
SET Lis_CorpRelSuc              := 29;				-- Lista de clientes Corporativos de una sucursal --
SET Lis_CteCancelado			:= 30;				-- Lista los clientes que tienen una solicitud de cancelacion --
SET Lis_General					:= 31;				-- lista gral para boton ventanilla
SET Lis_ReacCteSucVen			:= 32;				-- Lista Para Ingresos Operaciones --
SET ListaExterna				:= 33;				-- Lista ulizada en  pantallas externas --
SET Lis_DepGarantiaGene			:= 34;				-- Lista para filtar clientes con garantia liquida
SET Lis_DepGarantiaSuc			:= 35;				-- Lista depositos de Garantia de una sucursal--
SET Lis_ActInact				:= 36;				-- Lista para filtrar clientes con solicitd por protecciones para la pantalla de proteccion ahorro y credito. --
SET Lis_BusquedaSEIDO			:= 37;				-- Lista de busqueda por nombre para requirimiento SEIDO --
SET Lis_CliMoral				:= 38;				-- Lista de Clientes Morales
SET Lis_CliBitaDomici			:= 39;				-- Lista de Clientes para bitacora de domiciliacion de pagos
SET Entero_Cero					:=	0;				-- Constante Cero --
SET CadenaVacia					:= '';				-- Constante Vacio --
SET EstatusRegistrada			:= 'R';				-- Estatus Registrado
SET CadenaSi					:= 'S'; 			-- Constante S --
SET EstaInactivo				:= 'INACTIVO'; 		-- Descripcion Estatus Inactivo --
SET EstaActivo					:= 'ACTIVO'; 		-- Descripcion Estatus Activo --
SET Fecha_Vacia					:= '1900-01-01';	-- Constante 1900-01-01 --
SET Cadena_Vacia				:= '';				-- Constante Vacio --
SET Activo						:= 'A';				-- Estatus Activo --
SET Inactivo					:= 'I'; 			-- Estatus Inactivo
SET Est_Vigente					:= 'V';				-- Estatus Vigente
SET Est_Vencido					:= 'B'; 			-- Estatus Vencido
SET Var_FechaSis  :=(SELECT FechaSistema FROM PARAMETROSSIS);
SET Lis_Aportaciones			:= 40;				-- Lista de clientes para alta de aportaciones
SET Lis_CliCreditoConsolidado	:= 41;				-- Lista para la pantalla Solicitud de Credito Consolidada

IF(Par_NumLis = Lis_Principal) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus!=Estatus_Inactivo
		LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_EnvioSMS) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,cte.TelefonoCelular
	FROM CLIENTES cte
	WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
	LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_CorpRel) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
	FROM CLIENTES cte
	WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
	AND cte.TipoPersona = Cons_Moral
	AND cte.Clasificacion = Cons_CorpRel
	LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_Menor) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.EsMenorEdad = Es_Menor
		LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_Nacion) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		   AND cte.Nacion = Nac_Extranjero
		   AND cte.Estatus!=Estatus_Inactivo
		LIMIT 0,15;
END IF;

-- Lista Direccion Cliente WS
IF(Par_NumLis = Lis_ClienteWS) THEN
	SELECT ClienteID, NombreCompleto
	FROM CLIENTES
	WHERE  NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
	LIMIT 0,15;
END IF;

-- Usado en la vista de Solicitud Apoyo Escolar
IF(Par_NumLis = Lis_PersonaFisica) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND (cte.TipoPersona = Fisica_Empresa OR cte.TipoPersona=Fisica_NoEmpresa)
			AND cte.Estatus = Estatus_Activo
		LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_Activos) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND		cte.Estatus = Estatus_Activo
		LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_Inactivacion) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_MenoresInact) THEN
	SELECT ClienteID, NombreCompleto
	FROM CLIENTES
	WHERE  NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
       AND EsMenorEdad = Es_Menor
	   AND Estatus =Estatus_Inactivo
	LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_MayoresActivos) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		   AND cte.Estatus != Estatus_Inactivo
		   AND (YEAR (Var_FechaSis)- YEAR (cte.FechaNacimiento)) - (RIGHT(Var_FechaSis,5)<RIGHT(cte.FechaNacimiento,5)) >= MayorEdad
		LIMIT 0,15;
END IF;

# 13. utilizada en pantalla de socio menor y en la pantalla capacidad de pago, y datos socioeconomicos
IF(Par_NumLis = Lis_ParaTutor) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus = Estatus_Activo
			AND cte.EsMenorEdad != Es_Menor
			AND (cte.TipoPersona = Fisica_Empresa OR cte.TipoPersona=Fisica_NoEmpresa)
		LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_MayoresEdad) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus = Estatus_Activo
			AND cte.EsMenorEdad != Es_Menor
		LIMIT 0,15;
END IF;

IF(Par_NumLis = Lis_ReactivacionCte) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		INNER JOIN MOTIVACTIVACION Mot ON Mot.MotivoActivaID=cte.TipoInactiva AND Mot.PermiteReactivacion="S" AND Mot.RequiereCobro="S"
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus="I"
		LIMIT 0,15;
END IF;

# Lista los clientes a los que se le dio de alta una solicitud de cancelacion
IF(Par_NumLis = Lis_CteCancelado) THEN
	SELECT Cli.ClienteID, 		Cli.NombreCompleto
	FROM PROTECCIONES Pro,
		 CLIENTESCANCELA Can,
		 CLIENTES Cli
		WHERE Can.ClienteID = Cli.ClienteID
			AND Pro.ClienteCancelaID = Can.ClienteCancelaID
			AND Cli.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		LIMIT 0,15;
END IF;

/* Lista nuevas para Ventanilla */
IF(Par_NumLis = Lis_CteSucursal) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),' ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion,cte.SucursalOrigen
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus!=Estatus_Inactivo
			AND cte.SucursalOrigen = Aud_Sucursal
		LIMIT 0,25;
END IF;

IF(Par_NumLis = Lis_EnvioSMSSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,cte.TelefonoCelular,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
	FROM CLIENTES cte
	LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
	WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.SucursalOrigen = Aud_Sucursal
	LIMIT 0,25;
END IF;

IF(Par_NumLis = Lis_CorpRelSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
	FROM CLIENTES cte
	LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
	WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
	AND cte.TipoPersona = Cons_Moral
	AND cte.Clasificacion = Cons_CorpRel
	AND cte.SucursalOrigen = Aud_Sucursal
	LIMIT 0,25;
END IF;

IF(Par_NumLis = Lis_MenorSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND EsMenorEdad = Es_Menor
			AND cte.SucursalOrigen=Aud_Sucursal
	   LIMIT 0, 25;
END IF;

IF(Par_NumLis = Lis_NacionSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		   AND cte.Nacion = Nac_Extranjero
		   AND cte.Estatus!=Estatus_Inactivo
		   AND cte.SucursalOrigen=Aud_Sucursal
		LIMIT 0, 25;
END IF;

IF(Par_NumLis = Lis_PersonaFisiSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND (cte.TipoPersona = Fisica_Empresa OR cte.TipoPersona=Fisica_NoEmpresa)
			AND cte.Estatus = Estatus_Activo
			AND cte.SucursalOrigen=Aud_Sucursal
		LIMIT 0, 25;
END IF;

IF(Par_NumLis = Lis_ActivosSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
		FROM CLIENTES cte
		INNER JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND		cte.Estatus = Estatus_Activo
			AND 	SucursalOrigen=Aud_Sucursal
		LIMIT 0, 25;
END IF;

IF(Par_NumLis = Lis_InactivaSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.SucursalOrigen=Aud_Sucursal
		LIMIT 0, 25;
END IF;

IF(Par_NumLis = Lis_MayoresActSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		   AND cte.Estatus != Estatus_Inactivo
		   AND (YEAR (Var_FechaSis)- YEAR (cte.FechaNacimiento)) - (RIGHT(Var_FechaSis,5)<RIGHT(cte.FechaNacimiento,5)) >= MayorEdad
		   AND cte.SucursalOrigen = Aud_Sucursal
		LIMIT 0,25;
END IF;

IF(Par_NumLis = Lis_MayoresEdadSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus = Estatus_Activo
			AND cte.EsMenorEdad != Es_Menor
			AND cte.SucursalOrigen=Aud_Sucursal
		LIMIT 0,25;
END IF;


IF(Par_NumLis = Lis_ReacCteSucVen) THEN
	IF IFNULL(Par_ClienteID,Entero_Cero)>Entero_Cero THEN
		SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion,suc.NombreSucurs
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		INNER JOIN MOTIVACTIVACION Mot ON Mot.MotivoActivaID=cte.TipoInactiva AND Mot.PermiteReactivacion="S" AND Mot.RequiereCobro="S"
		INNER JOIN SUCURSALES suc ON cte.SucursalOrigen=suc.SucursalID
		WHERE  cte.ClienteID=Par_ClienteID
			AND cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus="I"
		LIMIT 0,25;
	ELSE
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion,suc.NombreSucurs
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		INNER JOIN MOTIVACTIVACION Mot ON Mot.MotivoActivaID=cte.TipoInactiva AND Mot.PermiteReactivacion="S" AND Mot.RequiereCobro="S"
		INNER JOIN SUCURSALES suc ON cte.SucursalOrigen=suc.SucursalID
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus="I"
		LIMIT 0,25;
	END IF;
END IF;

IF(Par_NumLis = Lis_ReactCteSuc) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion,''
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		INNER JOIN MOTIVACTIVACION Mot ON Mot.MotivoActivaID=cte.TipoInactiva AND Mot.PermiteReactivacion="S" AND Mot.RequiereCobro="S"
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus="I"
			AND cte.SucursalOrigen=Aud_Sucursal
		LIMIT 0,25;
END IF;

/*FILTRA LOS CLIENTES POR LA SUCURSAL INDICADA*/
IF(Par_NumLis = Lis_CtePorSucursal) THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),', ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion
		FROM CLIENTES cte
		INNER JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.SucursalOrigen=Par_SucursalID
		LIMIT 0,15;
END IF;

/*Lista Gral para Ventanilla */
IF(Par_NumLis = Lis_General) THEN
	IF IFNULL(Par_ClienteID,Entero_Cero)>Entero_Cero THEN
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),' ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion,suc.NombreSucurs
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		INNER JOIN SUCURSALES suc ON cte.SucursalOrigen=suc.SucursalID
		WHERE cte.ClienteID=Par_ClienteID
			AND cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus!=Estatus_Inactivo
		ORDER BY cte.NombreCompleto ASC
		LIMIT 0,50;
	ELSE
	SELECT cte.ClienteID, cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),' ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion,suc.NombreSucurs
		FROM CLIENTES cte
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		INNER JOIN SUCURSALES suc ON cte.SucursalOrigen=suc.SucursalID
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus!=Estatus_Inactivo
		ORDER BY cte.NombreCompleto ASC
		LIMIT 0,50;
	END IF;
END IF;

IF(Par_NumLis = ListaExterna) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus!=Estatus_Inactivo
		LIMIT 0,15;
END IF;


IF(Par_NumLis = Lis_DepGarantiaGene) THEN

SELECT DISTINCT cte.ClienteID,cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),' ',IFNULL(dc.Colonia,CadenaVacia)) AS Direccion,suc.NombreSucurs
	FROM CLIENTES cte
		INNER JOIN SUCURSALES suc ON cte.SucursalOrigen=suc.SucursalID
		INNER JOIN CREDITOS cre ON cte.ClienteID=cre.ClienteID
		INNER JOIN ESQUEMAGARANTIALIQ esq ON cre.ProductoCreditoID=esq.ProducCreditoID
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		LIMIT 0,50;
END IF;

IF(Par_NumLis = Lis_DepGarantiaSuc) THEN
SELECT DISTINCT cte.ClienteID,cte.NombreCompleto,CONCAT(IFNULL(dc.calle,CadenaVacia),' ',IFNULL(dc.Colonia,CadenaVacia))  AS Direccion,cte.SucursalOrigen
	FROM CLIENTES cte
		INNER JOIN CREDITOS cre ON cte.ClienteID=cre.ClienteID
		INNER JOIN ESQUEMAGARANTIALIQ esq ON cre.ProductoCreditoID=esq.ProducCreditoID
		LEFT JOIN DIRECCLIENTE dc ON cte.ClienteID=dc.ClienteID AND dc.Oficial='S'
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.SucursalOrigen=Aud_Sucursal
		LIMIT 0,25;
END IF;

IF(Par_NumLis = Lis_ActInact) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND		(cte.Estatus = Estatus_Activo OR cte.Estatus =  Estatus_Inactivo)
		LIMIT 0,15;
END IF;

-- Lista para grid de personas para requerimiento SEIDO --
IF(Par_NumLis = Lis_BusquedaSEIDO)THEN
	SET Par_ClienteID :=IFNULL(Par_ClienteID,Entero_Cero);
		SELECT cli.ClienteID, cli.NombreCompleto, CONCAT(cli.SucursalOrigen,' .- ', suc.NombreSucurs) AS Sucursal, CASE cli.Estatus WHEN Activo THEN EstaActivo WHEN Inactivo THEN EstaInactivo END AS Estatus, cli.FechaAlta,
				CASE cli.FechaBaja WHEN Fecha_Vacia THEN Cadena_Vacia ELSE cli.FechaBaja END AS FechaBaja , IFNULL(dir.DireccionCompleta, Cadena_Vacia) AS DireccionCompleta, pai.Nombre AS LugarNacimiento, cli.FechaNacimiento, cli.CURP,
				cli.RFC,  ocu.Descripcion AS Ocupacion
			FROM CLIENTES cli
			LEFT JOIN DIRECCLIENTE dir ON cli.ClienteID = dir.ClienteID AND dir.Oficial = CadenaSi
			LEFT JOIN OCUPACIONES ocu ON cli.OcupacionID = ocu.OcupacionID
			INNER JOIN SUCURSALES suc ON cli.SucursalOrigen = suc.SucursalID
			LEFT JOIN PAISES pai ON cli.LugarNacimiento = pai.PaisID
			WHERE CASE  Par_ClienteID WHEN   0 THEN cli.NombreCompleto = Par_NombreComp   ELSE cli.ClienteID = Par_ClienteID END;
END IF;
-- LISTA DE CLIENTES MORALES - RIESGO COMUN
IF(Par_NumLis = Lis_CliMoral) THEN
	SELECT Cte.ClienteID, Cte.RazonSocial, IFNULL(Dir.DireccionCompleta, Cadena_Vacia ) AS Direccion
	FROM CLIENTES Cte
	LEFT JOIN  DIRECCLIENTE Dir ON Cte.ClienteID = Dir.ClienteID AND Dir.Oficial = CadenaSi
	WHERE  Cte.RazonSocial LIKE CONCAT("%", Par_NombreComp, "%")
	  AND Cte.TipoPersona = Cons_Moral
	LIMIT 0,15;
END IF;

IF Par_NumLis = Lis_CliBitaDomici THEN
	SELECT DISTINCT BTC.ClienteID,CLI.NombreCompleto
		FROM CLIENTES CLI
		INNER JOIN BITACORADOMICIPAGOS BTC ON CLI.ClienteID = BTC.ClienteID
		WHERE CLI.NombreCompleto LIKE CONCAT("%",Par_NombreComp,"%") LIMIT 0,15;
END IF;

-- LISTA PARA ALTA DE APORTACIONES
IF(Par_NumLis = Lis_Aportaciones) THEN
	SELECT cte.ClienteID, cte.NombreCompleto
		FROM CLIENTES cte
		WHERE  cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
			AND cte.Estatus = Estatus_Activo
		LIMIT 0,15;
END IF;

	--  Lista de Cliente Para la pantalla Solicitud de Credito Consolidada
	IF( Par_NumLis = Lis_CliCreditoConsolidado ) THEN
		SELECT 	 DISTINCT(Cre.ClienteID) AS ClienteID,	Cli.NombreCompleto AS NombreCliente
		FROM CREDITOS Cre
		INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
		WHERE Cli.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		  AND Cre.Estatus IN (Est_Vigente, Est_Vencido)
		  AND Cre.EsAgropecuario = CadenaSi
		ORDER BY Cre.ClienteID
		LIMIT 0,15;
	END IF;

END TerminaStore$$