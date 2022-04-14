-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUSUALESXMLREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUSUALESXMLREP`;
DELIMITER $$

CREATE PROCEDURE `PLDOPEINUSUALESXMLREP`(
/* ========= SP QUE ENLISTA LAS OPERACIONES INUSUALES ==========*/
	Par_Nombre			VARCHAR(200),		-- Nombre con el que se inicia la busqueda
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
DECLARE	RegistroTitularCta			CHAR(2);
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
DECLARE Tipo_Aval 					VARCHAR(3);
DECLARE Tipo_Prospecto 				VARCHAR(3);
DECLARE Tipo_Relacionado 			VARCHAR(3);
DECLARE Tipo_Proveedor	 			VARCHAR(3);

DECLARE Lis_Principal				INT(11);
DECLARE	Lis_OpeSeDebenReportar		INT(11);
DECLARE	Lis_OperacionesEnArchivo	INT(11);


DECLARE Var_NumCuentaAsociada 			VARCHAR(20);
DECLARE Var_RegimenCta 					INT(11);
DECLARE Var_NivelCta 					INT(11);
DECLARE Var_NacionalidadCta 			CHAR(6);
DECLARE Var_InstitucionCta 				VARCHAR(40);
DECLARE Var_ClabeCta 					VARCHAR(20);
DECLARE Var_TipoFinanciamiento 			INT(11);
DECLARE Var_EmpresaID 					INT(11);
DECLARE Var_Usuario 					INT(11);
DECLARE Var_FechaActual 				DATETIME;
DECLARE Var_DireccionIP 				VARCHAR(15);
DECLARE Var_ProgramaID 					VARCHAR(50);
DECLARE Var_Sucursal 					INT(11);
DECLARE Var_NumTransaccion 				BIGINT(20);
DECLARE Var_TipoITF						CHAR(6);
DECLARE Var_PrioridadReporte			CHAR(6);


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
SET	RegistroTitularCta			:= '00';	-- Indica que es el registro del titular  de la cuenta en la operacion detectada como inusual
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
SET LongMoneda					:= 3;		-- Logitud en caracteres para la Clave de la Moneda
SET Mayusculas					:= 'MA';	-- Obtener el resultado en Mayusculas
SET TipoSocap					:= 'scap';	-- Tipo SOCAP, corresponde a la tabla TIPOSINSTITUCION
SET TipoSofipo					:= 'sofipo';-- Tipo SOFIPO, corresponde a la tabla TIPOSINSTITUCION
SET TipoSofom					:= 'sofom';	-- Tipo SOFOM, corresponde a la tabla TIPOSINSTITUCION
SET NacMexicana   				:= '1';		-- Tipo de Nacionalidad Mexicana
SET NacExtranjera  				:= '2';		-- Tipo de Nacionalidad Extranjera
SET ClaveMX		  				:= 'MX';	-- Clave para Mexico
SET Tipo_UServ 					:='USU';	-- Tipo Usuario de Servicios
SET Tipo_Aval 					:='AVA';	-- Tipo Aval
SET Tipo_Prospecto 				:='PRO';	-- Tipo Prospecto
SET Tipo_Relacionado 			:='REL';	-- Tipo Relacionado a la Cuenta
SET Tipo_Proveedor	 			:='PRV';	-- Tipo Proveedor

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
	SET	Var_PeriodoReporte		:= DATE_FORMAT(Var_FechaSistema,'%Y%m%d');
	SET	Var_OrganoSupervisor	:= (SELECT ClaveOrgSupervisor FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET	Var_ClaveCasFim			:= (SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET	Var_TipoITF				:= (SELECT TipoITF FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET	Var_PrioridadReporte	:= (SELECT PrioridadReporte FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);

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
		ConsecutivoCuenta			VARCHAR(2),
		NumCuentaRelacionado		VARCHAR(16),
		ClaveCasfimRelacionado		VARCHAR(6),
		NombreRelacionado			VARCHAR(60),
		ApellidoPaternoRelacionado	VARCHAR(60),
		ApellidoMaternoRelacionado	VARCHAR(30),
		DescriOperacion				VARCHAR(500),
		DescriMotivo				VARCHAR(500),
		OpeInusualID				BIGINT(11),
		TipoCliente 				VARCHAR(100), 
		Genero 						VARCHAR(100),
		EdoNacimientoID				INT(11),
		EdoDomicilioID				INT(11),
		CalleDomicilio 				VARCHAR(100),
		FechaInicioTran 			INT(11),
		FechaFinTran				INT(11),
		MontoTotalOper				DECIMAL(14,2),
		NumOperaciones				BIGINT(12),
		Correo 						VARCHAR(60),
		CP 							CHAR(6)
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
		OpeInusualID,			TipoCliente,				Genero,						EdoNacimientoID,			EdoDomicilioID,
		CalleDomicilio,			FechaInicioTran,			FechaFinTran,				MontoTotalOper,				NumOperaciones,
		Correo,					CP)
	SELECT
		TipoRepInusuales AS TipoDeReporte,
		Var_PeriodoReporte AS Periodo,
		Var_OrganoSupervisor AS OrganoSup,
		Var_ClaveCasFim AS ClaveCasfim,
		RIGHT(IFNULL(MunSuc.Localidad, Cadena_Vacia),8) AS LocalidadSuc,
        IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
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
		UPPER(IFNULL(Dir.Colonia, Cadena_Vacia)) AS Colonia,
		RIGHT(UPPER(IFNULL(Mun.Localidad, Cadena_Vacia)),8) AS Localidad,
		CONCAT(TRIM(IFNULL(Cli.TelTrabajo, Cadena_Vacia)), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Cli.TelTrabajo, Cadena_Vacia))) > 0 THEN "/" ELSE Cadena_Vacia END,TRIM(IFNULL(Cli.Telefono, Cadena_Vacia))) AS Telefonos,
		TRIM(IFNULL(Cli.ActividadBancoMX, Cadena_Vacia)) AS ActividadEconomica,
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado	,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, Cadena_Vacia), " ", IFNULL(Inu.ComentarioOC, Cadena_Vacia)) )) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID,

		Cli.TipoPersona, Cli.Sexo, Cli.EstadoID, Dir.EstadoID, Dir.Calle,DATE_FORMAT(IFNULL(PT.FechaIniPerf, Fecha_Vacia),'%Y%m%d') , DATE_FORMAT(IFNULL(PT.FechaSigPerf, Fecha_Vacia),'%Y%m%d'), PT.DepositosMax, PT.NumDepositos,
		Cli.Correo,Dir.CP

	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
		LEFT JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Inu.CuentaAhoID
		LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Inu.ClavePersonaInv
		LEFT JOIN PLDPERFILTRANS PT ON Cli.ClienteID = PT.ClienteID
		LEFT JOIN ESCRITURAPUB Esc ON Esc.ClienteID = Cli.ClienteID AND Esc_Tipo = ActaConstitutiva
		LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND Dir.Oficial = Str_SI
		LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT JOIN PAISES Ps ON Cli.LugarNacimiento = Ps.PaisID
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
		RIGHT(IFNULL(MunSuc.Localidad, Cadena_Vacia),8) AS LocalidadSuc,
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
		LEFT(UPPER(IFNULL(concat(Col.TipoAsenta," ", Col.Asentamiento), Cadena_Vacia)),30) AS Colonia,
		RIGHT(UPPER(IFNULL(Mun.Localidad, Cadena_Vacia)),8) AS Localidad,
		CONCAT(TRIM(IFNULL(Userv.Telefono, Cadena_Vacia)), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Userv.Telefono, Cadena_Vacia))) > 0 THEN "/" ELSE Cadena_Vacia END,TRIM(IFNULL(Userv.TelefonoCelular, Cadena_Vacia))) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado	,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, Cadena_Vacia), " ", IFNULL(Inu.ComentarioOC, Cadena_Vacia)) )) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
		LEFT JOIN USUARIOSERVICIO Userv ON Userv.UsuarioServicioID = Inu.ClavePersonaInv
        LEFT JOIN COLONIASREPUB Col ON Col.EstadoID = Userv.EstadoID AND Col.MunicipioID = Userv.MunicipioID AND Col.ColoniaID=Userv.ColoniaID
		LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Userv.EstadoID AND Mun.MunicipioID = Userv.MunicipioID
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT JOIN PAISES Ps ON Userv.PaisNacimiento = Ps.PaisID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND Inu.TipoPersonaSAFI=Tipo_UServ;


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
		RIGHT(IFNULL(MunSuc.Localidad, Cadena_Vacia),8) AS LocalidadSuc,
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
		LEFT(UPPER(IFNULL(concat(Col.TipoAsenta," ", Col.Asentamiento), Cadena_Vacia)),30) AS Colonia,
		RIGHT(UPPER(IFNULL(Mun.Localidad, Cadena_Vacia)),8) AS Localidad,
		CONCAT(TRIM(IFNULL(Pros.Telefono, Cadena_Vacia)), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Pros.Telefono, Cadena_Vacia))) > 0 THEN "/" ELSE Cadena_Vacia END,TRIM(IFNULL(Pros.Telefono, Cadena_Vacia))) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado	,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, Cadena_Vacia), " ", IFNULL(Inu.ComentarioOC, Cadena_Vacia)) )) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
		LEFT JOIN PROSPECTOS Pros ON Pros.ProspectoID = Inu.ClavePersonaInv
        LEFT JOIN COLONIASREPUB Col ON Col.EstadoID = Pros.EstadoID AND Col.MunicipioID = Pros.MunicipioID AND Col.ColoniaID=Pros.ColoniaID
		LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Pros.EstadoID AND Mun.MunicipioID = Pros.MunicipioID
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
		RIGHT(IFNULL(MunSuc.Localidad, Cadena_Vacia),8) AS LocalidadSuc,
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
		LEFT(UPPER(IFNULL(concat(Col.TipoAsenta," ", Col.Asentamiento), Cadena_Vacia)),30) AS Colonia,
		RIGHT(UPPER(IFNULL(Mun.Localidad, Cadena_Vacia)),8) AS Localidad,
		CONCAT(TRIM(IFNULL(AV.Telefono, Cadena_Vacia)), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(AV.Telefono, Cadena_Vacia))) > 0 THEN "/" ELSE Cadena_Vacia END,TRIM(IFNULL(AV.TelefonoCel, Cadena_Vacia))) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado	,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, Cadena_Vacia), " ", IFNULL(Inu.ComentarioOC, Cadena_Vacia)) )) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
		LEFT JOIN AVALES AV ON AV.AvalID = Inu.ClavePersonaInv
        LEFT JOIN COLONIASREPUB Col ON Col.EstadoID = AV.EstadoID AND Col.MunicipioID = AV.MunicipioID AND Col.ColoniaID=AV.ColoniaID
		LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = AV.EstadoID AND Mun.MunicipioID = AV.MunicipioID
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
		RIGHT(IFNULL(MunSuc.Localidad, Cadena_Vacia),8) AS LocalidadSuc,
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
		CONCAT(TRIM(IFNULL(CPers.TelefonoCelular, Cadena_Vacia)), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(CPers.TelefonoCelular, Cadena_Vacia))) > 0 THEN "/" ELSE Cadena_Vacia END,TRIM(IFNULL(CPers.TelefonoCasa, Cadena_Vacia))) AS Telefonos,
		'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
		Cadena_Vacia AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		Cadena_Vacia AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
		RegistroTitularCta AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
		Cadena_Vacia AS NumCuentaRelacionado	,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, Cadena_Vacia), " ", IFNULL(Inu.ComentarioOC, Cadena_Vacia)) )) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
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
		RIGHT(IFNULL(MunSuc.Localidad, Cadena_Vacia),8) AS LocalidadSuc,
        IF(Var_NombreCorto=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		Cadena_Vacia AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
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
		CONCAT(TRIM(IFNULL(Prov.TelefonoCelular, Cadena_Vacia)), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Prov.TelefonoCelular, Cadena_Vacia))) > 0 THEN "/" ELSE Cadena_Vacia END,TRIM(IFNULL(Prov.Telefono, Cadena_Vacia))) AS Telefonos,
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
		UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, Cadena_Vacia), " ", IFNULL(Inu.ComentarioOC, Cadena_Vacia)) )) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
		LEFT JOIN PROVEEDORES Prov ON Prov.ProveedorID = Inu.ClavePersonaInv
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		LEFT JOIN PAISES Ps ON Prov.PaisNacimiento = Ps.PaisID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND Inu.TipoPersonaSAFI=Tipo_Proveedor;

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
		Cadena_Vacia AS NumCuentaRelacionado	,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, Cadena_Vacia), " ", IFNULL(Inu.ComentarioOC, Cadena_Vacia)) )) AS DescriOperacion,
		UPPER(TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia))) AS DescriMotivo,
		Inu.OpeInusualID
	  FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
		WHERE Inu.Estatus = EstatusReportarOperacion
			AND Inu.FolioInterno > Entero_Cero AND (Inu.TipoPersonaSAFI='NA' OR Inu.TipoPersonaSAFI='' OR Inu.TipoPersonaSAFI IS NULL);

SELECT 		NumCuentaAsociada, 					RegimenCta, 				NivelCta, 					NacionalidadCta, 					InstitucionCta,
			ClabeCta,							TipoFinanciamiento
	INTO 	Var_NumCuentaAsociada, 				Var_RegimenCta, 			Var_NivelCta, 				Var_NacionalidadCta, 				Var_InstitucionCta,
			Var_ClabeCta,						Var_TipoFinanciamiento
FROM 	PLDCUENTASASOCIADAS LIMIT 1; # PREGUNTAR COMO SE VA A EVALUAR PARA QUITAR EL LIMIT



SELECT	
		 Cadena_Vacia AS sujeto_obligado, 
			 OrganoSup AS organo_supervisor,
			 IF((Var_NombreCorto=TipoSofom AND Var_EntidadRegulada = Str_NO AND TipoOperacion = '01'),'09',TipoOperacion) AS tipo_itf,
			 ClaveCasfim AS clave_sujeto,
		 Cadena_Vacia AS reportes,
		 Cadena_Vacia AS reporte,
			 TipoDeReporte AS tipo_reporte,
			 Periodo AS fecha_reporte,
			 LPAD(Folio,LongFolio, 0) AS folio_consecutivo,
		 Cadena_Vacia AS cuenta,
			 Var_RegimenCta AS regimen,
			 Var_NivelCta AS nivel_cuenta,
			 Var_NumCuentaAsociada AS numero_cuenta_proyecto,
			 Var_NacionalidadCta AS nacionalidad_cuenta_asociada,
			 Var_InstitucionCta AS institucion_financiera,
			 Var_ClabeCta AS cuenta_asociada_institucion,
			 Var_TipoFinanciamiento AS tipo_financiamiento_colectivo,
		 Cadena_Vacia AS cliente,
			 TipoDePersona AS tipo_persona,
			 TipoCliente AS tipo_cliente,
			 IF(Nacionalidad=ClaveMX,NacMexicana,NacExtranjera) AS pais_nacionalidad,
			 LEFT(RazonSocioal,LongRazonSocial) AS razon_social_denominacion,
			 LEFT(Nombre, LongNombre) AS nombre,
			 LEFT(ApellidoPaterno,LongNombre) 	AS apellido_paterno,
			 LEFT(ApellidoMaterno,LongApMaterno) AS apellido_materno,
			 Genero AS genero,
			 RFC AS rfc_cliente,
			 CURP AS curp,
			 FechaNacimiento AS fecha_nacimiento_constitucion,
			 EdoNacimientoID AS entidad_nacimiento_constitucion,
		 Cadena_Vacia AS domicilio_cliente,
			 EdoDomicilioID AS entidad_federativa_domicilio,
			 CalleDomicilio AS calle_domicilio,
			 FNLIMPIACARACTERESGEN(LEFT(Colonia,LongColonia),Mayusculas) AS colonia,
			 LEFT(Localidad,LongLocalidad) AS ciudad_poblacion,
			 CP AS codigo_postal,
			 LEFT(Telefonos,LongTelefono) AS telefono,
			 Correo AS correo_electronico,
			 CASE LENGTH(ActividadEconomica) WHEN 9 THEN LPAD(LEFT(ActividadEconomica,LongActEconomica6),LongActEconomica7,'0')	WHEN 10 THEN LPAD(LEFT(ActividadEconomica,LongActEconomica7),LongActEconomica7,'0')	END AS actividad_economica,
		 Cadena_Vacia AS operacion,
			 Var_TipoITF AS tipo_operacion_itf,
			 InstrumentoMon AS instrumento_monetario,
			 MontoOperacion AS monto,
			 Moneda AS moneda,
			 FechaOperacion AS fecha_operacion,
			 FechaDeteccion AS fecha_deteccion,
		 Cadena_Vacia AS apoderado,
			 NombreApoSeguros AS nombre_apoderado,
			 ApellidoPaternoApoSeguros AS apellido_paterno_apoderado,
			 ApellidoMaternoApoSeguros AS apellido_materno_apoderado,
		 Cadena_Vacia AS analisis,
			 FNLIMPIACARACTERESGEN(DescriOperacion,Mayusculas) AS descripcion_operacion,
			 FNLIMPIACARACTERESGEN(DescriMotivo,Mayusculas) AS razon_inusual,
			 FechaInicioTran AS fecha_inicio_perfil,
			 FechaFinTran AS fecha_fin_perfil,
			 MontoTotalOper AS monto_total_perfil,
			 Moneda AS moneda_perfil,
			 NumOperaciones AS numero_operaciones,
			 Cadena_Vacia AS tipo_operacion_perfil,
			 Var_PrioridadReporte AS prioridad_reporte,
			 Cadena_Vacia AS alerta,
		Cadena_Vacia AS contraparte_ifcolectivo,
		Cadena_Vacia AS inversionistas,
			 000 AS numero_inversionistas,
		Cadena_Vacia AS inversionista,
			 0	AS tipo_persona_inversionista,
			 Cadena_Vacia AS razon_denominacion_inversionista,
			 Cadena_Vacia AS nombre_inversionista,
			 Cadena_Vacia AS apellido_paterno_inversionista,
			 Cadena_Vacia AS apellido_materno_inversionista,
		Cadena_Vacia AS solicitante,
			 0 AS tipo_persona_solicitante,
			 Cadena_Vacia AS razon_denominacion_solicitante,
			 Cadena_Vacia AS nombre_solicitante,
			 Cadena_Vacia AS apellido_paterno_solicitante,
			 Cadena_Vacia AS apellido_materno_solicitante,
		Cadena_Vacia AS contraparte_ifpago_electronico,
			 0 AS tipo_persona_contraparte,
			 Cadena_Vacia AS razon_denominacion_contraparte,
			 Cadena_Vacia AS  nombre_contraparte,
			 Cadena_Vacia AS apellido_paterno_contraparte,
			 Cadena_Vacia AS apellido_materno_contraparte,
			 Cadena_Vacia AS nacionalidad_cuenta_contraparte,
			 Cadena_Vacia AS institucion_financiera_contraparte,
			 Cadena_Vacia AS cuenta_clabe_contraparte
		FROM TMPENVIOALERTASINUSUALES;

END IF;

END TerminaStore$$