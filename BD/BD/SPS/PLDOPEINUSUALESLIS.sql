
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSUALESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUSUALESLIS`;

DELIMITER $$
CREATE PROCEDURE `PLDOPEINUSUALESLIS`(
/* ========= SP QUE ENLISTA LAS OPERACIONES INUSUALES ==========*/
	Par_Nombre			VARCHAR(200),		-- Nombre con el que se inicia la busqueda
	Par_Operaciones		CHAR(1),			-- Operaciones de: C = CLIENTES, U = USUARIOS DE SERVICIOS, "" = TODOS
	Par_NumLis			TINYINT UNSIGNED,	-- Tipo de Lista
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


-- Declaracion de Variables
DECLARE	Var_FechaSistema			DATE;		-- Fecha del Sistema
DECLARE	Var_DiasParaEnviar			INT(11);	-- Dias que restan por enviar
DECLARE	Var_PeriodoReporte			INT(11);	-- Periodo del reporte para nombre del archivo YYYYMMDD
DECLARE	Var_OrganoSupervisor		VARCHAR(6);	-- Clave del Organo Supervisor
DECLARE	Var_ClaveCasFim			    VARCHAR(7);	-- Clave de la Entidad Financiera
DECLARE Var_TipoInstitID   			INT(11);	-- Tipo de institucion financiera
DECLARE Var_NombreCorto   			VARCHAR(45);-- Nombre corto del tipo de institucion financiera
DECLARE Var_EntidadRegulada			VARCHAR(2);	-- Indica si la financiera es una entidad regulada,
DECLARE	Var_CliEspecif				INT(11);	-- Número de cliente específico.
DECLARE	Var_TipoNacionalidad		INT(11);	-- Parámetro para el Tipo de Nacionalidad.
DECLARE Var_MuestraConsCtasRel		CHAR(1);	-- Parámetro para Muestra mostrar los campos de Ctas Relacionadas.
DECLARE Var_InvierteCols			CHAR(1);	-- Parámetro para validar si se Invierten las últimas dos Cols.
DECLARE Var_TipoClaveMon			CHAR(1);	-- Parámetro para el Tipo de Clave de la Moneda.

-- Declaracion de Constantes
DECLARE Cadena_Vacia				CHAR(1);
DECLARE Fecha_Vacia					DATE;
DECLARE Entero_Cero					INT(11);
DECLARE	Str_SI						CHAR(1);
DECLARE	Str_NO						CHAR(1);
DECLARE	EstatusReportarOperacion	INT(11);
DECLARE ClavePersonalInterno		CHAR(2);
DECLARE ClavePersonalExterno		CHAR(2);
DECLARE ClaveSistemaAutomatico		CHAR(2);
DECLARE	ParamVigente				CHAR(1);
DECLARE	ActaConstitutiva			CHAR(1);
DECLARE	RegistroTitularCta			INT(11);
DECLARE	TipoRepInusuales			CHAR(1);
DECLARE	InstrumEfectivo				CHAR(2);
DECLARE PerFisica                   CHAR(1);
DECLARE PerMoral					CHAR(1);
DECLARE PerFisActEmp				CHAR(1);
DECLARE NumPerFisica   				CHAR(1);
DECLARE NumPerMoral   				CHAR(1);
DECLARE DiasEnviarListas			INT(11);
DECLARE MotLISN						VARCHAR(15);
DECLARE MotLISB						VARCHAR(15);
DECLARE EstatusVigente				VARCHAR(1);
DECLARE LongFolio					INT(11);
DECLARE LongRazonSocial				INT(11);
DECLARE LongNombre					INT(11);
DECLARE LongApMaterno				INT(11);
DECLARE LongDomicilio				INT(11);
DECLARE LongColonia					INT(11);
DECLARE LongLocalidad				INT(11);
DECLARE LongSucursal				INT(11);
DECLARE LongTelefono				INT(11);
DECLARE LongActEconomica6			INT(11);
DECLARE LongActEconomica7			INT(11);
DECLARE LongCuenta					INT(11);
DECLARE LongMoneda					INT(11);
DECLARE Mayusculas					CHAR(2);
DECLARE TipoSocap					VARCHAR(10);
DECLARE TipoSofipo					VARCHAR(10);
DECLARE TipoSofom					VARCHAR(10);
DECLARE NacMexicana             	CHAR(2);
DECLARE NacExtranjera             	CHAR(2);
DECLARE ClaveMX		             	CHAR(2);
DECLARE Tipo_UServ 					VARCHAR(3);
DECLARE Tipo_USer2 					VARCHAR(3);
DECLARE Tipo_Aval 					VARCHAR(3);
DECLARE Tipo_Prospecto 				VARCHAR(3);
DECLARE Tipo_Relacionado 			VARCHAR(3);
DECLARE Tipo_Proveedor	 			VARCHAR(3);
DECLARE Tipo_ObligSol	 			VARCHAR(3);
DECLARE Lis_Principal				INT(11);
DECLARE	Lis_OpeSeDebenReportar		INT(11);
DECLARE	Lis_OperacionesEnArchivo	INT(11);
DECLARE	ClienteNo15					INT(11);
DECLARE	Tipo_ClavePais				INT(11);

-- Asignacion de Constantes
SET	Cadena_Vacia				:= '';		-- Cadena Vacia
SET	Fecha_Vacia				    := '1900-01-01';	-- Fecha Vacia
SET	Entero_Cero				    := 0;		-- Entero Cero
SET	Str_SI					    := 'S';		-- Indica "Si"
SET	Str_NO					    := 'N';		-- Indica "No"
SET	EstatusReportarOperacion	:= 3;		-- Estatus de la operacion detectada (1.-Capturada   2.- En Seguimiento   3.- Reportarce a CNBV   4.- No Reportarcea CNBV)
SET	ClavePersonalInterno		:= '1';		-- clave del tipo de persona que detecta la operacion 1:personal interno,
SET	ClavePersonalExterno		:= '2';		-- clave del tipo de persona que detecta la operacion 2:personal externo
SET	ClaveSistemaAutomatico		:= '3';		-- clave del tipo de persona que detecta la operacion 3:sistema automa¡tico
SET	ParamVigente				:= 'V';		-- Estatus de Parametro Vigente
SET	ActaConstitutiva			:= 'C';		-- Indica que el registro corresponde a una Acta Constitutiva
SET	RegistroTitularCta			:= 0;		-- Indica que es el registro del titular  de la cuenta en la operacion detectada como inusual
SET	TipoRepInusuales			:= '2';		-- Indica que el reporte (archivo txt) que se genera es de Operaciones Inusuales
SET	InstrumEfectivo				:= '01';	-- Indica que el instrumento reportado en la operacion inusual es Efectivo
SET PerFisica                   := 'F';		-- Indica que la persona es fisica
SET PerMoral					:= 'M';		-- Indica que la persona es moral
SET PerFisActEmp				:= 'A';		-- Indica que la persona es fisica con actividada empresarial
SET NumPerFisica                := '1';		-- Indica que la persona es fisica en numero
SET NumPerMoral	                := '2';		-- Indica que la persona es moral en numero
SET DiasEnviarListas			:= 1;		-- Indica los dias maximos para enviar por concepto de listas negras o de lista de pers. bloqueadas (1 dia = 24 hrs)
SET MotLISN						:= 'LISNEG';	-- Motivo por Listas Negras
SET MotLISB						:= 'LISBLOQ';	-- Motivo por Listas de Pers. Bloqueadas
SET EstatusVigente				:= 'V';		-- Estatus Vigente

SET	Lis_Principal				:= 1;		-- Lista  de ayuda para busquedas por nombre, de las operaciones que no estan marcadas para reportarce a la CNBV
SET	Lis_OpeSeDebenReportar		:= 2;		-- Lista de Operacones Con estatus de Reportarce a CNBV  que aun no se han enviado
SET	Lis_OperacionesEnArchivo	:= 3;		-- Lista las Operaciones que se incluiran en el Archivo que se esta generando para entregar a la CNBV
SET LongFolio					:= 6;		-- Logitud en caracteres para Folio
SET LongRazonSocial				:= 125;		-- Logitud en caracteres para la Razon Social
SET LongNombre					:= 60;		-- Logitud en caracteres para el Nombre y Apellido Paterno
SET LongApMaterno				:= 30;		-- Logitud en caracteres para Apellido Materno
SET LongDomicilio				:= 60;		-- Logitud en caracteres para Domicilio
SET LongColonia					:= 30;		-- Logitud en caracteres para Colonia
SET LongLocalidad				:= 8;		-- Logitud en caracteres para Localidad
SET LongSucursal				:= 8;		-- Logitud en caracteres para la Sucursal
SET LongTelefono				:= 40;		-- Logitud en caracteres para Telefono
SET LongActEconomica6			:= 6;		-- Logitud en caracteres para la Actividad Economica
SET LongActEconomica7			:= 7;		-- Logitud en caracteres para la Actividad Economica
SET LongCuenta					:= 16;		-- Logitud en caracteres para la cuenta
SET LongMoneda					:= 1;		-- Logitud en caracteres para la Clave de la Moneda
SET Mayusculas					:= 'MA';	-- Obtener el resultado en Mayusculas
SET TipoSocap					:= 'scap';	-- Tipo SOCAP, corresponde a la tabla TIPOSINSTITUCION
SET TipoSofipo					:= 'sofipo';-- Tipo SOFIPO, corresponde a la tabla TIPOSINSTITUCION
SET TipoSofom					:= 'sofom';	-- Tipo SOFOM, corresponde a la tabla TIPOSINSTITUCION
SET NacMexicana   				:= '1';		-- Tipo de Nacionalidad Mexicana
SET NacExtranjera  				:= '2';		-- Tipo de Nacionalidad Extranjera
SET ClaveMX		  				:= 'MX';	-- Clave para Mexico
SET Tipo_UServ 					:='USU';	-- Tipo Usuario de Servicios
SET Tipo_USer2 					:='USS';	-- Tipo Usuario de Servicios
SET Tipo_Aval 					:='AVA';	-- Tipo Aval
SET Tipo_Prospecto 				:='PRO';	-- Tipo Prospecto
SET Tipo_Relacionado 			:='REL';	-- Tipo Relacionado a la Cuenta
SET Tipo_Proveedor	 			:='PRV';	-- Tipo Proveedor
SET Tipo_ObligSol 				:='OBS';	-- Tipo Obligado Solidario
SET ClienteNo15					:= 15;		-- Número de cliente específico para sofiexpress.
SET Tipo_ClavePais				:= 2;		-- Tipo de Clave CNBV para la Nacionalidas.

/* 1.- Lista de ayuda para busquedas por nombre, de las operaciones que no estan marcadas para reportarce a la CNBV
 * Usado en la pantalla de Prevencion LD -> Procesos -> Segto. Operaciones Inusuales */
IF(Par_NumLis = Lis_Principal) THEN
	SELECT	OpeInusualID,		NomPersonaInv,	Fecha
	  FROM PLDOPEINUSUALES
		WHERE Estatus <> EstatusReportarOperacion
			AND NomPersonaInv LIKE CONCAT("%", Par_Nombre, "%")
		ORDER BY Fecha DESC
		LIMIT 0, 15;
END IF;

/* 2.- Lista de Operacones Con estatus de Reportarce a la CNBV que aun no se han enviado
 * Usado en la pantalla de Prevencion LD -> Reportes -> Op. Inusuales (cuando se carga la pantalla) */
IF(Par_NumLis = Lis_OpeSeDebenReportar) THEN
	SET	Var_FechaSistema	:=	(SELECT FechaSistema FROM PARAMETROSSIS);
	SET	Var_DiasParaEnviar	:=	(SELECT DiasMaxDeteccion FROM PLDPARALEOPINUS WHERE Estatus = ParamVigente LIMIT 1);

	SELECT
		Pld.Fecha,
		CASE WHEN ((Pld.CatMotivInuID = MotLISN AND Pld.TipoListaID != 'PEP') OR Pld.CatMotivInuID = MotLISB)
			THEN (DiasEnviarListas - DATEDIFF(Var_FechaSistema, Pld.Fecha))
			ELSE (Var_DiasParaEnviar - DATEDIFF(Var_FechaSistema, Pld.Fecha))
		END AS DiasRestantes,
		Pld.OpeInusualID,
		Pld.ClaveRegistra,
		CASE WHEN Pld.ClaveRegistra = ClavePersonalInterno	THEN 'PERSONAL INTERNO'
			WHEN Pld.ClaveRegistra = ClavePersonalExterno	THEN 'PERSONAL EXTERNO'
			WHEN Pld.ClaveRegistra = ClaveSistemaAutomatico	THEN 'SISTEMA AUTOMATICO'
			ELSE 'CLAVE NO DEFINIDA'
		END AS ClaveRegistraDescri,
		Pld.NombreReg,			Pld.CatProcedIntID,	Proc.Descripcion AS CatProcedIntIDDescri,	Pld.CatMotivInuID,		Mot.DesCorta,
		Pld.FechaDeteccion,		Pld.SucursalID,		Suc.NombreSucurs,							Pld.ClavePersonaInv,	Pld.NomPersonaInv,
		Pld.EmpInvolucrado,		Pld.Frecuencia,		Pld.DesFrecuencia,							Pld.DesOperacion,		Pld.Estatus,
		Pld.ComentarioOC,		Pld.FechaCierre,	Pld.CreditoID,								Pld.CuentaAhoID,		Pld.TransaccionOpe,
		Pld.NaturaOperacion,	Pld.MontoOperacion,	Pld.MonedaID,								Pld.FolioInterno
	   FROM PLDOPEINUSUALES Pld
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Pld.SucursalID
		LEFT JOIN PLDCATPROCEDINT Proc ON Proc.CatProcedIntID = Pld.CatProcedIntID
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Pld.CatMotivInuID
		WHERE Pld.Estatus = EstatusReportarOperacion
		ORDER BY Pld.FechaDeteccion ;
END IF;

/* 3.- Lista las Operaciones que se incluiran en el Archivo que se esta generando para entregar a la CNBV
 * Usado en la pantalla de Prevencion LD -> Reportes -> Op. Inusuales (al generar el reporte) */
IF(Par_NumLis = Lis_OperacionesEnArchivo) THEN
	SET	Var_FechaSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET	Var_PeriodoReporte		:= DATE_FORMAT(FNGETPLDSITIPERIODO(Entero_Cero),'%Y%m%d');
	SET	Var_OrganoSupervisor	:= (SELECT ClaveOrgSupervisor FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET	Var_ClaveCasFim			:= (SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET Var_CliEspecif			:= FNPARAMGENERALES('CliProcEspecifico');
	SET Var_CliEspecif			:= IFNULL(Var_CliEspecif, Entero_Cero);
	SET Var_TipoNacionalidad	:= LEFT(FNPARAMGENERALES('PLDSITI_Nacionalidad'),1);
	SET Var_TipoNacionalidad	:= IF(TRIM(Var_TipoNacionalidad) = Cadena_Vacia, 1, Var_TipoNacionalidad);
	SET Var_MuestraConsCtasRel	:= LEFT(FNPARAMGENERALES('PLDSITI_ConsCtasRel'),1);
	SET Var_MuestraConsCtasRel	:= IF(TRIM(Var_MuestraConsCtasRel) = Cadena_Vacia, Str_NO, Var_MuestraConsCtasRel);
	SET Var_InvierteCols		:= LEFT(FNPARAMGENERALES('PLDSITI_Cols3540_3641'),1);
	SET Var_InvierteCols		:= IF(TRIM(Var_InvierteCols) = Cadena_Vacia, Str_NO, Var_InvierteCols);
	SET Var_TipoClaveMon		:= LEFT(FNPARAMGENERALES('PLDSITI_Col12ClaveMon'),1);
	SET Var_TipoClaveMon		:= IF(TRIM(Var_TipoClaveMon) = Cadena_Vacia, 1, Var_TipoClaveMon);

	-- Se obtiene el tipo de institucion financiera
	SELECT
		Ins.TipoInstitID,	Tip.NombreCorto,	Tip.EntidadRegulada
	INTO
		Var_TipoInstitID,	Var_NombreCorto,	Var_EntidadRegulada
		FROM PARAMETROSSIS Par
			INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
			INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID;

	SET Var_TipoInstitID	:= IFNULL(Var_TipoInstitID, Entero_Cero);
	SET Var_NombreCorto		:= IFNULL(Var_NombreCorto, Cadena_Vacia);
	SET Var_EntidadRegulada	:= IFNULL(Var_EntidadRegulada, Cadena_Vacia);

	DROP TABLE IF EXISTS TMPENVIOALERTASINUSUALES;
	CREATE TEMPORARY TABLE TMPENVIOALERTASINUSUALES(
		TipoDeReporte				CHAR(1),
		Periodo						INT(11),
		Folio 						INTEGER AUTO_INCREMENT PRIMARY KEY,
		OrganoSup					VARCHAR(6),
		ClaveCasfim					VARCHAR(6),
		LocalidadSuc				VARCHAR(10),
		SucursalCP					VARCHAR(11),
		TipoOperacion				CHAR(2),
		InstrumentoMon				CHAR(2),
		NumCuenta					VARCHAR(16),
		MontoOperacion				DECIMAL(18,2),
		Moneda						VARCHAR(3),
		FechaOperacion				INT(11),
		FechaDeteccion				INT(11),
		Nacionalidad				CHAR(2),
		TipoDePersona				VARCHAR(1),
		RazonSocioal				VARCHAR(60),
		Nombre						VARCHAR(60),
		ApellidoPaterno				VARCHAR(60),
		ApellidoMaterno				VARCHAR(30),
		RFC							VARCHAR(13),
		CURP						VARCHAR(18),
		FechaNacimiento				INT(11),
		Domicilio					VARCHAR(500),
		Colonia						VARCHAR(200),
		Localidad					VARCHAR(11),
		Telefonos					VARCHAR(40),
		ActividadEconomica			VARCHAR(15),
		NombreApoSeguros			VARCHAR(60),
		ApellidoPaternoApoSeguros	VARCHAR(60),
		ApellidoMaternoApoSeguros	VARCHAR(30),
		RFCApoSeguros			 	VARCHAR(13),
		CURPApoSeguros				VARCHAR(18),
		ConsecutivoCuenta			INT(11),
		NumCuentaRelacionado		VARCHAR(16),
		ClaveCasfimRelacionado		VARCHAR(6),
		NombreRelacionado			VARCHAR(100),
		ApellidoPaternoRelacionado	VARCHAR(100),
		ApellidoMaternoRelacionado	VARCHAR(100),
		DescriOperacion				VARCHAR(3000),# Descripción de la Op.
		DescriMotivo				VARCHAR(3000),# Comentario del O.C.
		OpeInusualID				BIGINT(11)
	);

	-- Seccion Clientes
	INSERT INTO TMPENVIOALERTASINUSUALES (
		TipoDeReporte,			Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		SucursalCP,				TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,					FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,			Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,					FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,				ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,			CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,		ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInusualID)
	SELECT
		TipoRepInusuales AS TipoDeReporte,
		Var_PeriodoReporte AS Periodo,
		Var_OrganoSupervisor AS OrganoSup,
		Var_ClaveCasFim AS ClaveCasfim,
		RIGHT(FNGETPLDSITILOC(Suc.EstadoID, Suc.MunicipioID, Suc.LocalidadID),8) AS LocalidadSuc,
		IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		CASE(FormaPago)
			WHEN 'E' THEN '01' # EFECTIVO
			WHEN 'H' THEN '02' # CHEQUES O DOCUMENTOS
			WHEN 'T' THEN '03' # TRANSFERENCIAS
			ELSE '01' # DEFAULT EFECTIVO
		END AS InstrumentoMon,
		CASE WHEN IFNULL(Inu.CuentaAhoID, Entero_Cero) = Entero_Cero THEN Cadena_Vacia ELSE CAST(Inu.CuentaAhoID AS CHAR) END AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		Ps.ClaveCNBV AS Nacionalidad,
		CASE Cli.TipoPersona WHEN PerFisica THEN NumPerFisica WHEN PerFisActEmp THEN NumPerFisica WHEN PerMoral THEN NumPerMoral ELSE NumPerFisica END AS TipoDePersona,
		CASE WHEN Cli.TipoPersona IN (PerMoral,PerFisActEmp) THEN UPPER(IFNULL(Cli.RazonSocial, Cadena_Vacia)) ELSE Cadena_Vacia END AS RazonSocioal,
		CASE WHEN Cli.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(TRIM(CONCAT(IFNULL(Cli.PrimerNombre, 'XXX')," ", IFNULL(Cli.SegundoNombre, Cadena_Vacia)," ", IFNULL(Cli.TercerNombre, Cadena_Vacia)))) END Nombre,
		CASE WHEN Cli.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(Cli.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
		CASE WHEN Cli.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(Cli.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
		UPPER(IFNULL(Cli.RFCOficial, Cadena_Vacia)) AS RFC,
		UPPER(IFNULL(Cli.CURP, Cadena_Vacia)) AS CURP,
		CASE WHEN Cli.TipoPersona IN (PerMoral) THEN DATE_FORMAT(IFNULL(Cli.FechaConstitucion, Fecha_Vacia),'%Y%m%d')  ELSE DATE_FORMAT(IFNULL(Cli.FechaNacimiento, Fecha_Vacia),'%Y%m%d') END AS FechaNacimiento,
		FNGENDIRECCION(3, Entero_Cero, Entero_Cero, Entero_Cero, Entero_Cero, Dir.Calle,Dir.NumeroCasa,Dir.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,Dir.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia) AS Domicilio,
		LEFT(FNGENDIRECCION(4, Dir.EstadoID, Dir.MunicipioID, Entero_Cero, Dir.ColoniaID, Dir.Calle,Dir.NumeroCasa,Dir.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,Dir.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia),200) AS Colonia,
		RIGHT(FNGETPLDSITILOC(Dir.EstadoID, Dir.MunicipioID, Dir.LocalidadID),8) AS Localidad,
		LEFT(FNGETPLDSITITELS(1,Inu.TipoPersonaSAFI,Cli.ClienteID,Entero_Cero),40) AS Telefonos,
		TRIM(IFNULL(Cli.ActividadBancoMX, Cadena_Vacia)) AS ActividadEconomica,
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Inu.ConsecutivoCuentaRel AS ConsecutivoCuenta,
		Inu.NumCuentaRelacionado AS NumCuentaRelacionado,
		Var_ClaveCasFim AS ClaveCasfimRelacionado,
		Inu.NombreRelacionado AS NombreRelacionado,
		Inu.ApellidoPaternoRelacionado AS ApellidoPaternoRelacionado,
		Inu.ApellidoMaternoRelacionado AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.ComentarioOC, Cadena_Vacia)))) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Inu.DesOperacion, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Inu.CuentaAhoID
		LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Inu.ClavePersonaInv
		LEFT JOIN ESCRITURAPUB Esc ON Esc.ClienteID = Cli.ClienteID AND Esc_Tipo = ActaConstitutiva
		LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND Dir.Oficial = Str_SI
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT OUTER JOIN PAISES Ps ON Ps.PaisID = IF(Cli.TipoPersona = PerMoral, Cli.PaisConstitucionID, Cli.LugarNacimiento)
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND Inu.TipoPersonaSAFI='CTE';

	-- Seccion de Usuarios de Servicios
	INSERT INTO TMPENVIOALERTASINUSUALES (
		TipoDeReporte,			Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		SucursalCP,				TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,					FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,			Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,					FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,				ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,			CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,		ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInusualID)
	SELECT
		TipoRepInusuales AS TipoDeReporte,
		Var_PeriodoReporte AS Periodo,
		Var_OrganoSupervisor AS OrganoSup,
		Var_ClaveCasFim AS ClaveCasfim,
		RIGHT(FNGETPLDSITILOC(Suc.EstadoID, Suc.MunicipioID, Suc.LocalidadID),8) AS LocalidadSuc,
		IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		Cadena_Vacia AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		Ps.ClaveCNBV AS Nacionalidad,
		CASE Userv.TipoPersona WHEN PerFisica THEN NumPerFisica WHEN PerFisActEmp THEN NumPerFisica WHEN PerMoral THEN NumPerMoral ELSE NumPerFisica END AS TipoDePersona,
		CASE WHEN Userv.TipoPersona IN (PerMoral, PerFisActEmp) THEN UPPER(IFNULL(Userv.RazonSocial, Cadena_Vacia)) ELSE Cadena_Vacia END AS RazonSocioal,
		CASE WHEN Userv.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(TRIM(CONCAT(IFNULL(Userv.PrimerNombre, 'XXX')," ", IFNULL(Userv.SegundoNombre, Cadena_Vacia)," ", IFNULL(Userv.TercerNombre, Cadena_Vacia)))) END Nombre,
		CASE WHEN Userv.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(Userv.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
		CASE WHEN Userv.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(Userv.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
		UPPER(IFNULL(Userv.RFCOficial, Cadena_Vacia)) AS RFC,
		UPPER(IFNULL(Userv.CURP, Cadena_Vacia)) AS CURP,
		CASE WHEN Userv.TipoPersona IN (PerMoral) THEN DATE_FORMAT(IFNULL(Userv.FechaConstitucion, Fecha_Vacia),'%Y%m%d')  ELSE DATE_FORMAT(IFNULL(Userv.FechaNacimiento, Fecha_Vacia),'%Y%m%d') END AS FechaNacimiento,
		FNGENDIRECCION(3, Entero_Cero, Entero_Cero, Entero_Cero, Entero_Cero, Userv.Calle,Userv.NumExterior,Userv.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,Userv.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia) AS Domicilio,
		LEFT(FNGENDIRECCION(4, Userv.EstadoID, Userv.MunicipioID, Entero_Cero, Userv.ColoniaID, Userv.Calle,Userv.NumExterior,Userv.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,Userv.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia),200) AS Colonia,
		RIGHT(FNGETPLDSITILOC(Userv.EstadoID, Userv.MunicipioID, Userv.LocalidadID),8) AS Localidad,
		LEFT(FNGETPLDSITITELS(1,Inu.TipoPersonaSAFI,Userv.UsuarioServicioID,Entero_Cero),40) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.ComentarioOC, Cadena_Vacia)))) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Inu.DesOperacion, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN USUARIOSERVICIO Userv ON Userv.UsuarioServicioID = Inu.ClavePersonaInv
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT JOIN PAISES Ps ON Userv.PaisNacimiento = Ps.PaisID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND Inu.TipoPersonaSAFI IN (Tipo_UServ,Tipo_USer2);


	-- Seccion de Prospectos
	INSERT INTO TMPENVIOALERTASINUSUALES (
		TipoDeReporte,			Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		SucursalCP,				TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,					FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,			Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,					FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,				ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,			CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,		ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInusualID)
	SELECT
		TipoRepInusuales AS TipoDeReporte,
		Var_PeriodoReporte AS Periodo,
		Var_OrganoSupervisor AS OrganoSup,
		Var_ClaveCasFim AS ClaveCasfim,
		RIGHT(FNGETPLDSITILOC(Suc.EstadoID, Suc.MunicipioID, Suc.LocalidadID),8) AS LocalidadSuc,
		IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		Cadena_Vacia AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		Ps.ClaveCNBV AS Nacionalidad,
		CASE Pros.TipoPersona WHEN PerFisica THEN NumPerFisica WHEN PerFisActEmp THEN NumPerFisica WHEN PerMoral THEN NumPerMoral ELSE NumPerFisica END AS TipoDePersona,
		CASE WHEN Pros.TipoPersona IN (PerMoral, PerFisActEmp) THEN UPPER(IFNULL(Pros.RazonSocial, Cadena_Vacia)) ELSE Cadena_Vacia END AS RazonSocioal,
		CASE WHEN Pros.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(TRIM(CONCAT(IFNULL(Pros.PrimerNombre, 'XXX')," ", IFNULL(Pros.SegundoNombre, Cadena_Vacia)," ", IFNULL(Pros.TercerNombre, Cadena_Vacia)))) END Nombre,
		CASE WHEN Pros.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(Pros.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
		CASE WHEN Pros.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(Pros.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
		UPPER(IFNULL(Pros.RFC, Cadena_Vacia)) AS RFC,
		Cadena_Vacia AS CURP,
		CASE WHEN Pros.TipoPersona IN (PerMoral) THEN DATE_FORMAT(Fecha_Vacia,'%Y%m%d')  ELSE DATE_FORMAT(IFNULL(Pros.FechaNacimiento, Fecha_Vacia),'%Y%m%d') END AS FechaNacimiento,
		FNGENDIRECCION(3, Entero_Cero, Entero_Cero, Entero_Cero, Entero_Cero, Pros.Calle,Pros.NumExterior,Pros.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,Pros.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia) AS Domicilio,
		LEFT(FNGENDIRECCION(4, Pros.EstadoID, Pros.MunicipioID, Entero_Cero, Pros.ColoniaID, Pros.Calle,Pros.NumExterior,Pros.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,Pros.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia),200) AS Colonia,
		RIGHT(FNGETPLDSITILOC(Pros.EstadoID, Pros.MunicipioID, Pros.LocalidadID),8) AS Localidad,
		LEFT(FNGETPLDSITITELS(1,Inu.TipoPersonaSAFI,Pros.ProspectoID,Entero_Cero),40) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.ComentarioOC, Cadena_Vacia)))) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Inu.DesOperacion, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN PROSPECTOS Pros ON Pros.ProspectoID = Inu.ClavePersonaInv
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT JOIN PAISES Ps ON Pros.LugarNacimiento = Ps.PaisID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND Inu.TipoPersonaSAFI=Tipo_Prospecto;

	-- Seccion de AVALES
	INSERT INTO TMPENVIOALERTASINUSUALES (
		TipoDeReporte,			Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		SucursalCP,				TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,					FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,			Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,					FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,				ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,			CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,		ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInusualID)
	SELECT
		TipoRepInusuales AS TipoDeReporte,
		Var_PeriodoReporte AS Periodo,
		Var_OrganoSupervisor AS OrganoSup,
		Var_ClaveCasFim AS ClaveCasfim,
		RIGHT(FNGETPLDSITILOC(Suc.EstadoID, Suc.MunicipioID, Suc.LocalidadID),8) AS LocalidadSuc,
		IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		Cadena_Vacia AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		Ps.ClaveCNBV AS Nacionalidad,
		CASE AV.TipoPersona WHEN PerFisica THEN NumPerFisica WHEN PerFisActEmp THEN NumPerFisica WHEN PerMoral THEN NumPerMoral ELSE NumPerFisica END AS TipoDePersona,
		CASE WHEN AV.TipoPersona IN (PerMoral, PerFisActEmp) THEN UPPER(IFNULL(AV.RazonSocial, Cadena_Vacia)) ELSE Cadena_Vacia END AS RazonSocioal,
		CASE WHEN AV.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(TRIM(CONCAT(IFNULL(AV.PrimerNombre, 'XXX')," ", IFNULL(AV.SegundoNombre, Cadena_Vacia)," ", IFNULL(AV.TercerNombre, Cadena_Vacia)))) END Nombre,
		CASE WHEN AV.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(AV.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
		CASE WHEN AV.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(AV.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
		UPPER(IFNULL(IF(AV.TipoPersona IN (PerMoral),AV.RFCpm,  AV.RFC),Cadena_Vacia)) AS RFC,
		Cadena_Vacia AS CURP,
		DATE_FORMAT(IFNULL(AV.FechaNac, Fecha_Vacia),'%Y%m%d') AS FechaNacimiento,
		FNGENDIRECCION(3, Entero_Cero, Entero_Cero, Entero_Cero, Entero_Cero, AV.Calle,AV.NumExterior,AV.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,AV.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia) AS Domicilio,
		LEFT(FNGENDIRECCION(4, AV.EstadoID, AV.MunicipioID, Entero_Cero, AV.ColoniaID, AV.Calle,AV.NumExterior,AV.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,AV.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia),200) AS Colonia,
		RIGHT(FNGETPLDSITILOC(AV.EstadoID, AV.MunicipioID, AV.LocalidadID),8) AS Localidad,
		LEFT(FNGETPLDSITITELS(1,Inu.TipoPersonaSAFI,AV.AvalID,Entero_Cero),40) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.ComentarioOC, Cadena_Vacia)))) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Inu.DesOperacion, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN AVALES AV ON AV.AvalID = Inu.ClavePersonaInv
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT JOIN PAISES Ps ON AV.LugarNacimiento = Ps.PaisID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND Inu.TipoPersonaSAFI=Tipo_Aval;

	-- Seccion de Relacionados a la Cuenta (Cuentas Persona)
	INSERT INTO TMPENVIOALERTASINUSUALES (
		TipoDeReporte,			Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		SucursalCP,				TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,					FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,			Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,					FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,				ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,			CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,		ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInusualID)
	SELECT
		TipoRepInusuales AS TipoDeReporte,
		Var_PeriodoReporte AS Periodo,
		Var_OrganoSupervisor AS OrganoSup,
		Var_ClaveCasFim AS ClaveCasfim,
		RIGHT(FNGETPLDSITILOC(Suc.EstadoID, Suc.MunicipioID, Suc.LocalidadID),8) AS LocalidadSuc,
		IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		Cadena_Vacia AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		Ps.ClaveCNBV AS Nacionalidad,
		NumPerFisica AS TipoDePersona,
		Cadena_Vacia AS RazonSocioal,
		UPPER(TRIM(CONCAT(IFNULL(CPers.PrimerNombre, 'XXX')," ", IFNULL(CPers.SegundoNombre, Cadena_Vacia)," ", IFNULL(CPers.TercerNombre, Cadena_Vacia)))) AS Nombre,
		UPPER(IFNULL(CPers.ApellidoPaterno, 'XXXX')) AS ApellidoPaterno,
		UPPER(IFNULL(CPers.ApellidoMaterno, 'XXXX')) AS ApellidoMaterno,
		UPPER(IFNULL(CPers.RFC, Cadena_Vacia)) AS RFC,
		UPPER(IFNULL(CPers.CURP, Cadena_Vacia)) AS CURP,
		DATE_FORMAT(IFNULL(CPers.FechaNac, Fecha_Vacia),'%Y%m%d') AS FechaNacimiento,
		'SIN CALLE' AS Domicilio,
		Cadena_Vacia AS Colonia,
		Cadena_Vacia AS Localidad,
		LEFT(FNGETPLDSITITELS(1,Inu.TipoPersonaSAFI,CPers.PersonaID,CPers.CuentaAhoID),40) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.ComentarioOC, Cadena_Vacia)))) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Inu.DesOperacion, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN CUENTASPERSONA CPers ON CPers.PersonaID = Inu.ClavePersonaInv AND CPers.CuentaAhoID = Inu.CuentaAhoID
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT JOIN PAISES Ps ON CPers.PaisNacimiento = Ps.PaisID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND Inu.TipoPersonaSAFI=Tipo_Relacionado;

	-- Seccion de Proveedores
	INSERT INTO TMPENVIOALERTASINUSUALES (
		TipoDeReporte,			Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		SucursalCP,				TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,					FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,			Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,					FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,				ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,			CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,		ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInusualID)
	SELECT
		TipoRepInusuales AS TipoDeReporte,
		Var_PeriodoReporte AS Periodo,
		Var_OrganoSupervisor AS OrganoSup,
		Var_ClaveCasFim AS ClaveCasfim,
		RIGHT(FNGETPLDSITILOC(Suc.EstadoID, Suc.MunicipioID, Suc.LocalidadID),8) AS LocalidadSuc,
		IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		Cadena_Vacia AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		Ps.ClaveCNBV AS Nacionalidad,
		IF(Prov.TipoPersona = PerMoral,NumPerMoral,NumPerFisica) AS TipoDePersona,
		IF(Prov.TipoPersona = PerMoral,Prov.RazonSocial,Cadena_Vacia) AS RazonSocioal,
		UPPER(TRIM(CONCAT(IFNULL(Prov.PrimerNombre, 'XXX')," ", IFNULL(Prov.SegundoNombre, Cadena_Vacia)))) AS Nombre,
		UPPER(IFNULL(Prov.ApellidoPaterno, 'XXXX')) AS ApellidoPaterno,
		UPPER(IFNULL(Prov.ApellidoMaterno, 'XXXX')) AS ApellidoMaterno,
		UPPER(IF(Prov.TipoPersona = PerMoral,IFNULL(Prov.RFCpm, Cadena_Vacia),IFNULL(Prov.RFC, Cadena_Vacia))) AS RFC,
		UPPER(IF(Prov.TipoPersona = PerMoral, Cadena_Vacia,IFNULL(Prov.CURP, Cadena_Vacia))) AS CURP,
		DATE_FORMAT(IFNULL(Prov.FechaNacimiento, Fecha_Vacia),'%Y%m%d') AS FechaNacimiento,
		'SIN CALLE' AS Domicilio,
		Cadena_Vacia AS Colonia,
		Cadena_Vacia AS Localidad,
		LEFT(FNGETPLDSITITELS(1,Inu.TipoPersonaSAFI,Prov.ProveedorID,Entero_Cero),40) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.ComentarioOC, Cadena_Vacia)))) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Inu.DesOperacion, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN PROVEEDORES Prov ON Prov.ProveedorID = Inu.ClavePersonaInv
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT JOIN PAISES Ps ON Prov.PaisNacimiento = Ps.PaisID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND Inu.TipoPersonaSAFI=Tipo_Proveedor;

	-- Seccion de Obligados Solidarios.
	INSERT INTO TMPENVIOALERTASINUSUALES (
		TipoDeReporte,			Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		SucursalCP,				TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,					FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,			Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,					FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,				ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,			CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,		ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInusualID)
	SELECT
		TipoRepInusuales AS TipoDeReporte,
		Var_PeriodoReporte AS Periodo,
		Var_OrganoSupervisor AS OrganoSup,
		Var_ClaveCasFim AS ClaveCasfim,
		RIGHT(FNGETPLDSITILOC(Suc.EstadoID, Suc.MunicipioID, Suc.LocalidadID),8) AS LocalidadSuc,
		IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		Cadena_Vacia AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		Ps.ClaveCNBV AS Nacionalidad,
		CASE OB.TipoPersona WHEN PerFisica THEN NumPerFisica WHEN PerFisActEmp THEN NumPerFisica WHEN PerMoral THEN NumPerMoral ELSE NumPerFisica END AS TipoDePersona,
		CASE WHEN OB.TipoPersona IN (PerMoral, PerFisActEmp) THEN UPPER(IFNULL(OB.RazonSocial, Cadena_Vacia)) ELSE Cadena_Vacia END AS RazonSocioal,
		CASE WHEN OB.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(TRIM(CONCAT(IFNULL(OB.PrimerNombre, 'XXX')," ", IFNULL(OB.SegundoNombre, Cadena_Vacia)," ", IFNULL(OB.TercerNombre, Cadena_Vacia)))) END Nombre,
		CASE WHEN OB.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(OB.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
		CASE WHEN OB.TipoPersona IN (PerMoral) THEN Cadena_Vacia ELSE UPPER(IFNULL(OB.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
		UPPER(IFNULL(IF(OB.TipoPersona IN (PerMoral),OB.RFCpm,  OB.RFC),Cadena_Vacia)) AS RFC,
		Cadena_Vacia AS CURP,
		DATE_FORMAT(IFNULL(OB.FechaNac, Fecha_Vacia),'%Y%m%d') AS FechaNacimiento,
		FNGENDIRECCION(3, Entero_Cero, Entero_Cero, Entero_Cero, Entero_Cero, OB.Calle,OB.NumExterior,OB.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,OB.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia) AS Domicilio,
		LEFT(FNGENDIRECCION(4, OB.EstadoID, OB.MunicipioID, Entero_Cero, OB.ColoniaID, OB.Calle,OB.NumExterior,OB.NumInterior,Cadena_Vacia,Cadena_Vacia, Cadena_Vacia,OB.CP,Cadena_Vacia,Cadena_Vacia,Cadena_Vacia),200) AS Colonia,
		RIGHT(FNGETPLDSITILOC(OB.EstadoID, OB.MunicipioID, OB.LocalidadID),8) AS Localidad,
		LEFT(FNGETPLDSITITELS(1,Inu.TipoPersonaSAFI,OB.OblSolidID,Entero_Cero),40) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.ComentarioOC, Cadena_Vacia)))) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Inu.DesOperacion, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN OBLIGADOSSOLIDARIOS OB ON OB.OblSolidID = Inu.ClavePersonaInv
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT JOIN PAISES Ps ON OB.LugarNacimiento = Ps.PaisID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND Inu.TipoPersonaSAFI=Tipo_ObligSol;

	-- Seccion No es persona que se haya registrado en el SAFI.
	INSERT INTO TMPENVIOALERTASINUSUALES (
		TipoDeReporte,			Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		SucursalCP,				TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,					FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,			Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,					FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,				ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,			CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,		ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInusualID)
	SELECT
		TipoRepInusuales AS TipoDeReporte,
		Var_PeriodoReporte AS Periodo,
		Var_OrganoSupervisor AS OrganoSup,
		Var_ClaveCasFim AS ClaveCasfim,
		Cadena_Vacia AS LocalidadSuc,
		IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		Cadena_Vacia AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		Cadena_Vacia AS Nacionalidad,
		NumPerFisica AS TipoDePersona,
		Cadena_Vacia AS RazonSocioal,
		IFNULL(NombresPersonaInv,'XXX') AS Nombre,
		IFNULL(ApPaternoPersonaInv,'XXXX') AS ApellidoPaterno,
		IFNULL(ApMaternoPersonaInv,'XXXX') AS ApellidoMaterno,
		Cadena_Vacia AS RFC,
		Cadena_Vacia AS CURP,
		DATE_FORMAT(Fecha_Vacia,'%Y%m%d') AS FechaNacimiento,
		'SIN CALLE' AS Domicilio,
		Cadena_Vacia AS Colonia,
		Cadena_Vacia AS Localidad,
		Cadena_Vacia AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.ComentarioOC, Cadena_Vacia)))) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Inu.DesOperacion, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND (Inu.TipoPersonaSAFI='NA' OR Inu.TipoPersonaSAFI='' OR Inu.TipoPersonaSAFI IS NULL);

	-- GENERACION DE LA INFORMACION PARA EL REPORTE DE OP INUSUALES
	SELECT	TipoDeReporte,				Periodo,
			LPAD(Folio,LongFolio, 0) AS Folio,
			OrganoSup,					ClaveCasfim,
			LEFT(LocalidadSuc,LongLocalidad) AS LocalidadSuc,
			LPAD(SucursalCP,LongSucursal,0) AS SucursalCP,
			IF((Var_NombreCorto=TipoSofom AND Var_EntidadRegulada = Str_NO AND TipoOperacion = '01'),
				'09',TipoOperacion) AS TipoOperacion,
			InstrumentoMon,
			LPAD(NumCuenta,LongCuenta,0) AS NumCuenta,
			MontoOperacion,
			FNGETPLDSITIMONEDA(Moneda) AS Moneda,
			FechaOperacion,				FechaDeteccion,
			IF(Var_TipoNacionalidad = Tipo_ClavePais,Nacionalidad,IF(Nacionalidad=ClaveMX,NacMexicana,NacExtranjera)) AS Nacionalidad,
			TipoDePersona,
			LEFT(RazonSocioal,LongRazonSocial) 	AS RazonSocioal,
			LEFT(Nombre, LongNombre) 			AS Nombre,
			LEFT(ApellidoPaterno,LongNombre) 	AS ApellidoPaterno,
			LEFT(ApellidoMaterno,LongApMaterno)	AS ApellidoMaterno,
			RFC,						CURP,				    FechaNacimiento,
			FNLIMPIACARACTERESGEN(LEFT(Domicilio,LongDomicilio),Mayusculas) AS Domicilio,
			FNLIMPIACARACTERESGEN(LEFT(Colonia,LongColonia),Mayusculas) AS Colonia,
			LEFT(Localidad,LongLocalidad) 		AS Localidad,
			LEFT(Telefonos,LongTelefono) 		AS Telefonos,
			CASE LENGTH(ActividadEconomica)
				WHEN 9 THEN
					LPAD(LEFT(ActividadEconomica,LongActEconomica6),LongActEconomica7,'0')
				WHEN 10 THEN
					LPAD(LEFT(ActividadEconomica,LongActEconomica7),LongActEconomica7,'0')
				ELSE ActividadEconomica
			END AS ActividadEconomica,
			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,	RFCApoSeguros,		    CURPApoSeguros,
			IF(Var_MuestraConsCtasRel = Str_SI, LPAD(ConsecutivoCuenta,2,'0'), Cadena_Vacia) AS ConsecutivoCuenta,
			IF((Var_NombreCorto=TipoSofom AND Var_EntidadRegulada = Str_NO),LPAD(NumCuenta,LongCuenta,0),LPAD(NumCuentaRelacionado,LongCuenta,0)) AS NumCuentaRelacionado,
			IF(IFNULL(ConsecutivoCuenta,Entero_Cero)!=Entero_Cero,ClaveCasfimRelacionado,Cadena_Vacia) AS ClaveCasfimRelacionado,
			IF(IFNULL(ConsecutivoCuenta,Entero_Cero)!=Entero_Cero,LEFT(NombreRelacionado, LongNombre),Cadena_Vacia) AS NombreRelacionado,
			IF(IFNULL(ConsecutivoCuenta,Entero_Cero)!=Entero_Cero,LEFT(ApellidoPaternoRelacionado,LongNombre),Cadena_Vacia) AS ApellidoPaternoRelacionado,
			IF(IFNULL(ConsecutivoCuenta,Entero_Cero)!=Entero_Cero,LEFT(ApellidoMaternoRelacionado,LongApMaterno),Cadena_Vacia) AS ApellidoMaternoRelacionado,
			FNLIMPIACARACTERESGEN(IF(Var_InvierteCols = Str_SI, DescriMotivo, DescriOperacion),Mayusculas) AS DescriOperacion,
			CONCAT(FNLIMPIACARACTERESGEN(IF(Var_InvierteCols = Str_SI, DescriOperacion, DescriMotivo),Mayusculas),';') AS DescriMotivo,
			OpeInusualID
	FROM TMPENVIOALERTASINUSUALES
	ORDER BY FechaOperacion;

END IF;

END TerminaStore$$

