-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPERACIONESCNBVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPERACIONESCNBVREP`;
DELIMITER $$


CREATE PROCEDURE `PLDOPERACIONESCNBVREP`(
/* STORE QUE GENERA EL REPORTE DE OPERACIONES PLD SEGUN EL LAYOUT OFICIAL */
	Par_FechaInicio			DATE,				-- Fecha Final del Periodo
	Par_FechaFinal			DATE,				-- Fecha Final del Periodo
	Par_Estatus				INT(11),			-- Estatus de la Operacion
	Par_Operaciones			CHAR(1),			-- Operaciones de: C = CLIENTES, U = USUARIOS DE SERVICIOS, "" = TODOS
	Par_NumCon				INT(11),			-- No. de Consulta 2: Reelevantes 3: Interna Preocupantes

	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Rep_Inusuales		INT(11);				# Tipo de Reporte Inusuales
	DECLARE Rep_Reelevantes		INT(11);				# Tipo de Reporte Reelevantes
	DECLARE Rep_IntPreocupantes	INT(11);				# Tipo de Reporte Interna Preocupantes
    DECLARE OperaClientes		CHAR(1);
    DECLARE OperaUsuarios		CHAR(1);
    DECLARE Cadena_Vacia		CHAR(1);

	-- Asignacion de constantes
	SET Rep_Inusuales			:= 1;
	SET Rep_Reelevantes			:= 2;
	SET Rep_IntPreocupantes		:= 3;
    SET OperaClientes			:= 'C';
    SET OperaUsuarios			:= 'U';
    SET Cadena_Vacia			:= '';

	SET	@Var_FechaSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET	@Var_PeriodoReporte		:= DATE_FORMAT(@Var_FechaSistema,'%Y%m%d');
	SET	@Var_OrganoSupervisor	:= (SELECT ClaveOrgSupervisor FROM PARAMETROSPLD WHERE Estatus = 'V');
	SET	@Var_ClaveCasFim		:= (SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = 'V');

	-- Se obtiene el tipo de institucion financiera
	SELECT IFNULL(Ins.TipoInstitID,0), 	Tip.NombreCorto,	Tip.EntidadRegulada
	  INTO @Var_TipoInstitID, 			@Var_NombreCorto,	@Var_EntidadRegulada
		FROM PARAMETROSSIS Par
			INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
			INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID;

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
		RazonSocioal				VARCHAR(150),
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
		OpeInusualID				BIGINT(11)
	);

	DROP TABLE IF EXISTS TMPENVIOALERTASPREOCUPANTES;
	CREATE TEMPORARY TABLE TMPENVIOALERTASPREOCUPANTES (
		TipoDeReporte 				CHAR(1),
		Periodo						INT(11),
		Folio 						INTEGER AUTO_INCREMENT PRIMARY KEY,
		OrganoSup					VARCHAR(6),
		ClaveCasfim					VARCHAR(6),
		LocalidadSuc				VARCHAR(8),
		SucursalCP					VARCHAR(8),
		TipoOperacion				VARCHAR(2),
		InstrumentoMon				VARCHAR(2),
		NumCuenta					VARCHAR(16),
		MontoOperacion				DECIMAL(18,2),
		Moneda						VARCHAR(3),
		FechaOperacion				INT(11),
		FechaDeteccion				INT(11),
		Nacionalidad				CHAR(2),
		TipoDePersona				VARCHAR(1),
		RazonSocioal				VARCHAR(150),
		Nombre						VARCHAR(100),
		ApellidoPaterno				VARCHAR(60),
		ApellidoMaterno				VARCHAR(60),
		RFC							VARCHAR(13),
		CURP						VARCHAR(18),
		FechaNacimiento				INT(11),
		Domicilio					VARCHAR(60),
		Colonia						VARCHAR(30),
		Localidad					VARCHAR(8),
		Telefonos					VARCHAR(40),
		ActividadEconomica			VARCHAR(15),
		NombreApoSeguros			VARCHAR(60),
		ApellidoPaternoApoSeguros	VARCHAR(60),
		ApellidoMaternoApoSeguros	VARCHAR(30),
		RFCApoSeguros			    VARCHAR(13),
		CURPApoSeguros			    VARCHAR(18),
		ConsecutivoCuenta			VARCHAR(2),
		NumCuentaRelacionado		VARCHAR(16),
		ClaveCasfimRelacionado		VARCHAR(6),
		NombreRelacionado			VARCHAR(100),
		ApellidoPaternoRelacionado	VARCHAR(60),
		ApellidoMaternoRelacionado	VARCHAR(60),
		DescriOperacion			    VARCHAR(2000),
		DescriMotivo				VARCHAR(500),
		OpeInterPreoID				BIGINT(11));

	IF(Par_NumCon = Rep_Inusuales) THEN
		-- Seccion Clientes
        IF(Par_Operaciones = OperaClientes OR Par_Operaciones = Cadena_Vacia)THEN
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
				2 AS TipoDeReporte,
				@Var_PeriodoReporte AS Periodo,
				@Var_OrganoSupervisor AS OrganoSup,
				@Var_ClaveCasFim AS ClaveCasfim,
				RIGHT(IFNULL(MunSuc.Localidad, ''),8) AS LocalidadSuc,
				IF(@Var_NombreCorto='sofom',IFNULL(Suc.CP, ''),IFNULL(Suc.ClaveSucCNBV, '')) AS SucursalCP,
				IFNULL(Inu.TipoOpeCNBV, '') AS TipoOperacion,
				'01' AS InstrumentoMon,
				CASE WHEN IFNULL(Inu.CuentaAhoID, 0) = 0 THEN '' ELSE CAST(Inu.CuentaAhoID AS CHAR) END AS NumCuenta,
				CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
				CAST(Inu.MonedaID AS CHAR) AS Moneda,
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaDeteccion,
				Ps.ClaveCNBV AS Nacionalidad,
				CASE Cli.TipoPersona WHEN 'F' THEN '1' WHEN 'A' THEN '1' WHEN 'M' THEN '2' ELSE '1' END AS TipoDePersona,
				CASE WHEN Cli.TipoPersona IN ('M','A') THEN UPPER(IFNULL(Cli.RazonSocial, '')) ELSE '' END AS RazonSocioal,
				CASE WHEN Cli.TipoPersona IN ('M') THEN '' ELSE UPPER(TRIM(CONCAT(IFNULL(Cli.PrimerNombre, 'XXX'),' ', IFNULL(Cli.SegundoNombre, ''),' ', IFNULL(Cli.TercerNombre, '')))) END Nombre,
				CASE WHEN Cli.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(Cli.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
				CASE WHEN Cli.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(Cli.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
				UPPER(IFNULL(Cli.RFCOficial, '')) AS RFC,
				UPPER(IFNULL(Cli.CURP, '')) AS CURP,
				CASE WHEN Cli.TipoPersona IN ('M') THEN DATE_FORMAT(IFNULL(Esc.FechaEsc, '1900-01-01'),'%Y%m%d')  ELSE DATE_FORMAT(IFNULL(Cli.FechaNacimiento, '1900-01-01'),'%Y%m%d') END AS FechaNacimiento,
				UPPER(IFNULL(CONCAT(IFNULL(Dir.Calle, 'SIN CALLE'), ' NO. ', Dir.NumeroCasa, ' ', Dir.NumInterior, ' C.P. ',Dir.CP), '')) AS Domicilio,
				UPPER(IFNULL(Dir.Colonia, '')) AS Colonia,
				RIGHT(UPPER(IFNULL(Mun.Localidad, '')),8) AS Localidad,
				CONCAT(TRIM(IFNULL(Cli.TelTrabajo, '')), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Cli.TelTrabajo, ''))) > 0 THEN '/' ELSE '' END,TRIM(IFNULL(Cli.Telefono, ''))) AS Telefonos,
				TRIM(IFNULL(Cli.ActividadBancoMX, '')) AS ActividadEconomica,
				'' AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'00' AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
				'' AS NumCuentaRelacionado	,
				'' AS ClaveCasfimRelacionado,
				'' AS NombreRelacionado,
				'' AS ApellidoPaternoRelacionado,
				'' AS ApellidoMaternoRelacionado,
				UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, ''), ' ', IFNULL(Inu.ComentarioOC, '')) )) AS DescriOperacion,
				UPPER(TRIM(IFNULL(Mot.DesCorta, ''))) AS DescriMotivo,
				Inu.OpeInusualID
			  FROM PLDOPEINUSUALES Inu
				LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
				LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
				LEFT JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Inu.CuentaAhoID
				LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Inu.ClavePersonaInv
				LEFT JOIN ESCRITURAPUB Esc ON Esc.ClienteID = Cli.ClienteID AND Esc_Tipo = 'C'
				LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND Dir.Oficial = 'S'
				LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
				LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
				LEFT JOIN PAISES Ps ON Cli.LugarNacimiento = Ps.PaisID
				WHERE IF(Par_Estatus = 0, TRUE, Inu.Estatus = Par_Estatus)
					AND Inu.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal
					AND Inu.TipoPersonaSAFI='CTE';

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
				2 AS TipoDeReporte,
				@Var_PeriodoReporte AS Periodo,
				@Var_OrganoSupervisor AS OrganoSup,
				@Var_ClaveCasFim AS ClaveCasfim,
				RIGHT(IFNULL(MunSuc.Localidad, ''),8) AS LocalidadSuc,
				IF(@Var_NombreCorto='sofom',IFNULL(Suc.CP, ''),IFNULL(Suc.ClaveSucCNBV, '')) AS SucursalCP,
				IFNULL(Inu.TipoOpeCNBV, '') AS TipoOperacion,
				'01' AS InstrumentoMon,
				CASE WHEN IFNULL(Inu.CuentaAhoID, 0) = 0 THEN '' ELSE CAST(Inu.CuentaAhoID AS CHAR) END AS NumCuenta,
				CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
				CAST(Inu.MonedaID AS CHAR) AS Moneda,
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaDeteccion,
				Ps.ClaveCNBV AS Nacionalidad,
				CASE Cli.TipoPersona WHEN 'F' THEN '1' WHEN 'A' THEN '1' WHEN 'M' THEN '2' ELSE '1' END AS TipoDePersona,
				CASE WHEN Cli.TipoPersona IN ('M','A') THEN UPPER(IFNULL(Cli.RazonSocial, '')) ELSE '' END AS RazonSocioal,
				CASE WHEN Cli.TipoPersona IN ('M') THEN '' ELSE UPPER(TRIM(CONCAT(IFNULL(Cli.PrimerNombre, 'XXX'),' ', IFNULL(Cli.SegundoNombre, ''),' ', IFNULL(Cli.TercerNombre, '')))) END Nombre,
				CASE WHEN Cli.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(Cli.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
				CASE WHEN Cli.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(Cli.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
				UPPER(IFNULL(Cli.RFCOficial, '')) AS RFC,
				UPPER(IFNULL(Cli.CURP, '')) AS CURP,
				CASE WHEN Cli.TipoPersona IN ('M') THEN DATE_FORMAT(IFNULL(Esc.FechaEsc, '1900-01-01'),'%Y%m%d')  ELSE DATE_FORMAT(IFNULL(Cli.FechaNacimiento, '1900-01-01'),'%Y%m%d') END AS FechaNacimiento,
				UPPER(IFNULL(CONCAT(IFNULL(Dir.Calle, 'SIN CALLE'), ' NO. ', Dir.NumeroCasa, ' ', Dir.NumInterior, ' C.P. ',Dir.CP), '')) AS Domicilio,
				UPPER(IFNULL(Dir.Colonia, '')) AS Colonia,
				RIGHT(UPPER(IFNULL(Mun.Localidad, '')),8) AS Localidad,
				CONCAT(TRIM(IFNULL(Cli.TelTrabajo, '')), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Cli.TelTrabajo, ''))) > 0 THEN '/' ELSE '' END,TRIM(IFNULL(Cli.Telefono, ''))) AS Telefonos,
				TRIM(IFNULL(Cli.ActividadBancoMX, '')) AS ActividadEconomica,
				'' AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'00' AS ConsecutivoCuenta, 			-- El 00 indica que es el Titular
				'' AS NumCuentaRelacionado	,
				'' AS ClaveCasfimRelacionado,
				'' AS NombreRelacionado,
				'' AS ApellidoPaternoRelacionado,
				'' AS ApellidoMaternoRelacionado,
				UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, ''), ' ', IFNULL(Inu.ComentarioOC, '')) )) AS DescriOperacion,
				UPPER(TRIM(IFNULL(Mot.DesCorta, ''))) AS DescriMotivo,
				Inu.OpeInusualID
			  FROM HISPLDOPEINUSUA Inu
				LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
				LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
				LEFT JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Inu.CuentaAhoID
				LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Inu.ClavePersonaInv
				LEFT JOIN ESCRITURAPUB Esc ON Esc.ClienteID = Cli.ClienteID AND Esc_Tipo = 'C'
				LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND Dir.Oficial = 'S'
				LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
				LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
				LEFT JOIN PAISES Ps ON Cli.LugarNacimiento = Ps.PaisID
				WHERE IF(Par_Estatus = 0, TRUE, Inu.Estatus = Par_Estatus)
					AND Inu.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal;
		END IF;

		-- Seccion de Usuarios de Servicios
        IF(Par_Operaciones = OperaUsuarios OR Par_Operaciones = Cadena_Vacia)THEN
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
				2 AS TipoDeReporte,
				@Var_PeriodoReporte AS Periodo,
				@Var_OrganoSupervisor AS OrganoSup,
				@Var_ClaveCasFim AS ClaveCasfim,
				RIGHT(IFNULL(MunSuc.Localidad, ''),8) AS LocalidadSuc,
				IF(@Var_NombreCorto='sofom',IFNULL(Suc.CP, ''),IFNULL(Suc.ClaveSucCNBV, '')) AS SucursalCP,
				IFNULL(Inu.TipoOpeCNBV, '') AS TipoOperacion,
				'01' AS InstrumentoMon,
				Inu.TransaccionOpe AS NumCuenta,
				CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
				CAST(Inu.MonedaID AS CHAR) AS Moneda,
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaDeteccion,
				Ps.ClaveCNBV AS Nacionalidad,
				CASE Userv.TipoPersona WHEN 'F' THEN '1' WHEN 'A' THEN '1' WHEN 'M' THEN '2' ELSE '1' END AS TipoDePersona,
				CASE WHEN Userv.TipoPersona IN ('M', 'A') THEN UPPER(IFNULL(Userv.RazonSocial, '')) ELSE '' END AS RazonSocioal,
				CASE WHEN Userv.TipoPersona IN ('M') THEN '' ELSE UPPER(TRIM(CONCAT(IFNULL(Userv.PrimerNombre, 'XXX'),' ', IFNULL(Userv.SegundoNombre, ''),' ', IFNULL(Userv.TercerNombre, '')))) END Nombre,
				CASE WHEN Userv.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(Userv.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
				CASE WHEN Userv.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(Userv.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
				UPPER(IFNULL(Userv.RFCOficial, '')) AS RFC,
				UPPER(IFNULL(Userv.CURP, '')) AS CURP,
				CASE WHEN Userv.TipoPersona IN ('M') THEN DATE_FORMAT(IFNULL(Userv.FechaConstitucion, '1900-01-01'),'%Y%m%d')  ELSE DATE_FORMAT(IFNULL(Userv.FechaNacimiento, '1900-01-01'),'%Y%m%d') END AS FechaNacimiento,
				UPPER(IFNULL(CONCAT(IFNULL(Userv.Calle, 'SIN CALLE'), ' NO. ', Userv.NumExterior, ' ', Userv.NumInterior, ' C.P. ',Userv.CP), '')) AS Domicilio,
				LEFT(UPPER(IFNULL(concat(Col.TipoAsenta,' ', Col.Asentamiento), '')),30) AS Colonia,
				RIGHT(UPPER(IFNULL(Mun.Localidad, '')),8) AS Localidad,
				CONCAT(TRIM(IFNULL(Userv.Telefono, '')), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Userv.Telefono, ''))) > 0 THEN '/' ELSE '' END,TRIM(IFNULL(Userv.TelefonoCelular, ''))) AS Telefonos,
				'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
				'' AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'00' AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
				'' AS NumCuentaRelacionado	,
				'' AS ClaveCasfimRelacionado,
				'' AS NombreRelacionado,
				'' AS ApellidoPaternoRelacionado,
				'' AS ApellidoMaternoRelacionado,
				UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, ''), ' ', IFNULL(Inu.ComentarioOC, '')) )) AS DescriOperacion,
				UPPER(TRIM(IFNULL(Mot.DesCorta, ''))) AS DescriMotivo,
				Inu.OpeInusualID
			  FROM PLDOPEINUSUALES Inu
				LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
				LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
				LEFT JOIN USUARIOSERVICIO Userv ON Userv.UsuarioServicioID = Inu.ClavePersonaInv
				LEFT JOIN COLONIASREPUB Col ON Col.EstadoID = Userv.EstadoID AND Col.MunicipioID = Userv.MunicipioID AND Col.ColoniaID=Userv.ColoniaID
				LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Userv.EstadoID AND Mun.MunicipioID = Userv.MunicipioID
				LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
				LEFT JOIN PAISES Ps ON Userv.PaisNacimiento = Ps.PaisID
				WHERE IF(Par_Estatus = 0, TRUE, Inu.Estatus = Par_Estatus)
					AND Inu.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal
					AND Inu.TipoPersonaSAFI='USU';
		END IF;

		-- Seccion de Prospectos
        IF(Par_Operaciones = OperaClientes OR Par_Operaciones = Cadena_Vacia)THEN
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
				2 AS TipoDeReporte,
				@Var_PeriodoReporte AS Periodo,
				@Var_OrganoSupervisor AS OrganoSup,
				@Var_ClaveCasFim AS ClaveCasfim,
				RIGHT(IFNULL(MunSuc.Localidad, ''),8) AS LocalidadSuc,
				IF(@Var_NombreCorto='sofom',IFNULL(Suc.CP, ''),IFNULL(Suc.ClaveSucCNBV, '')) AS SucursalCP,
				IFNULL(Inu.TipoOpeCNBV, '') AS TipoOperacion,
				'01' AS InstrumentoMon,
				'' AS NumCuenta,
				CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
				CAST(Inu.MonedaID AS CHAR) AS Moneda,
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaDeteccion,
				Ps.ClaveCNBV AS Nacionalidad,
				CASE Pros.TipoPersona WHEN 'F' THEN '1' WHEN 'A' THEN '1' WHEN 'M' THEN '2' ELSE '1' END AS TipoDePersona,
				CASE WHEN Pros.TipoPersona IN ('M', 'A') THEN UPPER(IFNULL(Pros.RazonSocial, '')) ELSE '' END AS RazonSocioal,
				CASE WHEN Pros.TipoPersona IN ('M') THEN '' ELSE UPPER(TRIM(CONCAT(IFNULL(Pros.PrimerNombre, 'XXX'),' ', IFNULL(Pros.SegundoNombre, ''),' ', IFNULL(Pros.TercerNombre, '')))) END Nombre,
				CASE WHEN Pros.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(Pros.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
				CASE WHEN Pros.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(Pros.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
				UPPER(IFNULL(Pros.RFC, '')) AS RFC,
				'' AS CURP,
				CASE WHEN Pros.TipoPersona IN ('M') THEN DATE_FORMAT('1900-01-01','%Y%m%d')  ELSE DATE_FORMAT(IFNULL(Pros.FechaNacimiento, '1900-01-01'),'%Y%m%d') END AS FechaNacimiento,
				UPPER(IFNULL(CONCAT(IFNULL(Pros.Calle, 'SIN CALLE'), ' NO. ', Pros.NumExterior, ' ', Pros.NumInterior, ' C.P. ',Pros.CP), '')) AS Domicilio,
				LEFT(UPPER(IFNULL(concat(Col.TipoAsenta,' ', Col.Asentamiento), '')),30) AS Colonia,
				RIGHT(UPPER(IFNULL(Mun.Localidad, '')),8) AS Localidad,
				CONCAT(TRIM(IFNULL(Pros.Telefono, '')), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Pros.Telefono, ''))) > 0 THEN '/' ELSE '' END,TRIM(IFNULL(Pros.Telefono, ''))) AS Telefonos,
				'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
				'' AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'00' AS ConsecutivoCuenta, 			-- El 00 indica que es el Titular
				'' AS NumCuentaRelacionado	,
				'' AS ClaveCasfimRelacionado,
				'' AS NombreRelacionado,
				'' AS ApellidoPaternoRelacionado,
				'' AS ApellidoMaternoRelacionado,
				UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, ''), ' ', IFNULL(Inu.ComentarioOC, '')) )) AS DescriOperacion,
				UPPER(TRIM(IFNULL(Mot.DesCorta, ''))) AS DescriMotivo,
				Inu.OpeInusualID
			  FROM PLDOPEINUSUALES Inu
				LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
				LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
				LEFT JOIN PROSPECTOS Pros ON Pros.ProspectoID = Inu.ClavePersonaInv
				LEFT JOIN COLONIASREPUB Col ON Col.EstadoID = Pros.EstadoID AND Col.MunicipioID = Pros.MunicipioID AND Col.ColoniaID=Pros.ColoniaID
				LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Pros.EstadoID AND Mun.MunicipioID = Pros.MunicipioID
				LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
				LEFT JOIN PAISES Ps ON Pros.LugarNacimiento = Ps.PaisID
				WHERE IF(Par_Estatus = 0, TRUE, Inu.Estatus = Par_Estatus)
					AND Inu.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal
					AND Inu.TipoPersonaSAFI='PRO';

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
				2 AS TipoDeReporte,
				@Var_PeriodoReporte AS Periodo,
				@Var_OrganoSupervisor AS OrganoSup,
				@Var_ClaveCasFim AS ClaveCasfim,
				RIGHT(IFNULL(MunSuc.Localidad, ''),8) AS LocalidadSuc,
				IF(@Var_NombreCorto='sofom',IFNULL(Suc.CP, ''),IFNULL(Suc.ClaveSucCNBV, '')) AS SucursalCP,
				IFNULL(Inu.TipoOpeCNBV, '') AS TipoOperacion,
				'01' AS InstrumentoMon,
				'' AS NumCuenta,
				CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
				CAST(Inu.MonedaID AS CHAR) AS Moneda,
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaDeteccion,
				Ps.ClaveCNBV AS Nacionalidad,
				CASE AV.TipoPersona WHEN 'F' THEN '1' WHEN 'A' THEN '1' WHEN 'M' THEN '2' ELSE '1' END AS TipoDePersona,
				CASE WHEN AV.TipoPersona IN ('M', 'A') THEN UPPER(IFNULL(AV.RazonSocial, '')) ELSE '' END AS RazonSocioal,
				CASE WHEN AV.TipoPersona IN ('M') THEN '' ELSE UPPER(TRIM(CONCAT(IFNULL(AV.PrimerNombre, 'XXX'),' ', IFNULL(AV.SegundoNombre, ''),' ', IFNULL(AV.TercerNombre, '')))) END Nombre,
				CASE WHEN AV.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(AV.ApellidoPaterno, 'XXXX')) END AS ApellidoPaterno,
				CASE WHEN AV.TipoPersona IN ('M') THEN '' ELSE UPPER(IFNULL(AV.ApellidoMaterno, 'XXXX')) END AS ApellidoMaterno,
				UPPER(IFNULL(IF(AV.TipoPersona IN ('M'),AV.RFCpm,  AV.RFC),'')) AS RFC,
				'' AS CURP,
				DATE_FORMAT(IFNULL(AV.FechaNac, '1900-01-01'),'%Y%m%d') AS FechaNacimiento,
				UPPER(IFNULL(CONCAT(IFNULL(AV.Calle, 'SIN CALLE'), ' NO. ', AV.NumExterior, ' ', AV.NumInterior, ' C.P. ',AV.CP), '')) AS Domicilio,
				LEFT(UPPER(IFNULL(concat(Col.TipoAsenta,' ', Col.Asentamiento), '')),30) AS Colonia,
				RIGHT(UPPER(IFNULL(Mun.Localidad, '')),8) AS Localidad,
				CONCAT(TRIM(IFNULL(AV.Telefono, '')), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(AV.Telefono, ''))) > 0 THEN '/' ELSE '' END,TRIM(IFNULL(AV.TelefonoCel, ''))) AS Telefonos,
				'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
				'' AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'00' AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
				'' AS NumCuentaRelacionado	,
				'' AS ClaveCasfimRelacionado,
				'' AS NombreRelacionado,
				'' AS ApellidoPaternoRelacionado,
				'' AS ApellidoMaternoRelacionado,
				UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, ''), ' ', IFNULL(Inu.ComentarioOC, '')) )) AS DescriOperacion,
				UPPER(TRIM(IFNULL(Mot.DesCorta, ''))) AS DescriMotivo,
				Inu.OpeInusualID
			  FROM PLDOPEINUSUALES Inu
				LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
				LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
				LEFT JOIN AVALES AV ON AV.AvalID = Inu.ClavePersonaInv
				LEFT JOIN COLONIASREPUB Col ON Col.EstadoID = AV.EstadoID AND Col.MunicipioID = AV.MunicipioID AND Col.ColoniaID=AV.ColoniaID
				LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = AV.EstadoID AND Mun.MunicipioID = AV.MunicipioID
				LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
				LEFT JOIN PAISES Ps ON AV.LugarNacimiento = Ps.PaisID
				WHERE IF(Par_Estatus = 0, TRUE, Inu.Estatus = Par_Estatus)
					AND Inu.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal
					AND Inu.TipoPersonaSAFI='AVA';

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
				2 AS TipoDeReporte,
				@Var_PeriodoReporte AS Periodo,
				@Var_OrganoSupervisor AS OrganoSup,
				@Var_ClaveCasFim AS ClaveCasfim,
				RIGHT(IFNULL(MunSuc.Localidad, ''),8) AS LocalidadSuc,
				IF(@Var_NombreCorto='sofom',IFNULL(Suc.CP, ''),IFNULL(Suc.ClaveSucCNBV, '')) AS SucursalCP,
				IFNULL(Inu.TipoOpeCNBV, '') AS TipoOperacion,
				'01' AS InstrumentoMon,
				'' AS NumCuenta,
				CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
				CAST(Inu.MonedaID AS CHAR) AS Moneda,
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaDeteccion,
				Ps.ClaveCNBV AS Nacionalidad,
				'1' AS TipoDePersona,
				'' AS RazonSocioal,
				UPPER(TRIM(CONCAT(IFNULL(CPers.PrimerNombre, 'XXX'),' ', IFNULL(CPers.SegundoNombre, ''),' ', IFNULL(CPers.TercerNombre, '')))) AS Nombre,
				UPPER(IFNULL(CPers.ApellidoPaterno, 'XXXX')) AS ApellidoPaterno,
				UPPER(IFNULL(CPers.ApellidoMaterno, 'XXXX')) AS ApellidoMaterno,
				UPPER(IFNULL(CPers.RFC, '')) AS RFC,
				UPPER(IFNULL(CPers.CURP, '')) AS CURP,
				DATE_FORMAT(IFNULL(CPers.FechaNac, '1900-01-01'),'%Y%m%d') AS FechaNacimiento,
				'SIN CALLE' AS Domicilio,
				'' AS Colonia,
				'' AS Localidad,
				CONCAT(TRIM(IFNULL(CPers.TelefonoCelular, '')), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(CPers.TelefonoCelular, ''))) > 0 THEN '/' ELSE '' END,TRIM(IFNULL(CPers.TelefonoCasa, ''))) AS Telefonos,
				'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
				'' AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'00' AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
				'' AS NumCuentaRelacionado	,
				'' AS ClaveCasfimRelacionado,
				'' AS NombreRelacionado,
				'' AS ApellidoPaternoRelacionado,
				'' AS ApellidoMaternoRelacionado,
				UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, ''), ' ', IFNULL(Inu.ComentarioOC, '')) )) AS DescriOperacion,
				UPPER(TRIM(IFNULL(Mot.DesCorta, ''))) AS DescriMotivo,
				Inu.OpeInusualID
			  FROM PLDOPEINUSUALES Inu
				LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
				LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
				LEFT JOIN CUENTASPERSONA CPers ON CPers.PersonaID = Inu.ClavePersonaInv AND CPers.CuentaAhoID = Inu.CuentaAhoID
				LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
				LEFT JOIN PAISES Ps ON CPers.PaisNacimiento = Ps.PaisID
				WHERE IF(Par_Estatus = 0, TRUE, Inu.Estatus = Par_Estatus)
					AND Inu.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal
					AND Inu.TipoPersonaSAFI='REL';

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
				2 AS TipoDeReporte,
				@Var_PeriodoReporte AS Periodo,
				@Var_OrganoSupervisor AS OrganoSup,
				@Var_ClaveCasFim AS ClaveCasfim,
				RIGHT(IFNULL(MunSuc.Localidad, ''),8) AS LocalidadSuc,
				IF(@Var_NombreCorto='sofom',IFNULL(Suc.CP, ''),IFNULL(Suc.ClaveSucCNBV, '')) AS SucursalCP,
				IFNULL(Inu.TipoOpeCNBV, '') AS TipoOperacion,
				'01' AS InstrumentoMon,
				'' AS NumCuenta,
				CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
				CAST(Inu.MonedaID AS CHAR) AS Moneda,
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaDeteccion,
				Ps.ClaveCNBV AS Nacionalidad,
				IF(Prov.TipoPersona = 'M','2','1') AS TipoDePersona,
				IF(Prov.TipoPersona = 'M',Prov.RazonSocial,'') AS RazonSocioal,
				UPPER(TRIM(CONCAT(IFNULL(Prov.PrimerNombre, 'XXX'),' ', IFNULL(Prov.SegundoNombre, '')))) AS Nombre,
				UPPER(IFNULL(Prov.ApellidoPaterno, 'XXXX')) AS ApellidoPaterno,
				UPPER(IFNULL(Prov.ApellidoMaterno, 'XXXX')) AS ApellidoMaterno,
				UPPER(IF(Prov.TipoPersona = 'M',IFNULL(Prov.RFCpm, ''),IFNULL(Prov.RFC, ''))) AS RFC,
				UPPER(IF(Prov.TipoPersona = 'M', '',IFNULL(Prov.CURP, ''))) AS CURP,
				DATE_FORMAT(IFNULL(Prov.FechaNacimiento, '1900-01-01'),'%Y%m%d') AS FechaNacimiento,
				'SIN CALLE' AS Domicilio,
				'' AS Colonia,
				'' AS Localidad,
				CONCAT(TRIM(IFNULL(Prov.TelefonoCelular, '')), CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Prov.TelefonoCelular, ''))) > 0 THEN '/' ELSE '' END,TRIM(IFNULL(Prov.Telefono, ''))) AS Telefonos,
				'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
				'' AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'00' AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
				'' AS NumCuentaRelacionado,
				'' AS ClaveCasfimRelacionado,
				'' AS NombreRelacionado,
				'' AS ApellidoPaternoRelacionado,
				'' AS ApellidoMaternoRelacionado,
				UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, ''), ' ', IFNULL(Inu.ComentarioOC, '')) )) AS DescriOperacion,
				UPPER(TRIM(IFNULL(Mot.DesCorta, ''))) AS DescriMotivo,
				Inu.OpeInusualID
			  FROM PLDOPEINUSUALES Inu
				LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
				LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
				LEFT JOIN PROVEEDORES Prov ON Prov.ProveedorID = Inu.ClavePersonaInv
				LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
				LEFT JOIN PAISES Ps ON Prov.PaisNacimiento = Ps.PaisID
				WHERE IF(Par_Estatus = 0, TRUE, Inu.Estatus = Par_Estatus)
					AND Inu.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal
					AND Inu.TipoPersonaSAFI='PRO';

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
				2 AS TipoDeReporte,
				@Var_PeriodoReporte AS Periodo,
				@Var_OrganoSupervisor AS OrganoSup,
				@Var_ClaveCasFim AS ClaveCasfim,
				'' AS LocalidadSuc,
				IF(@Var_NombreCorto='sofom',IFNULL(Suc.CP, ''),IFNULL(Suc.ClaveSucCNBV, '')) AS SucursalCP,
				IFNULL(Inu.TipoOpeCNBV, '') AS TipoOperacion,
				'01' AS InstrumentoMon,
				'' AS NumCuenta,
				CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
				CAST(Inu.MonedaID AS CHAR) AS Moneda,
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
				DATE_FORMAT(IFNULL(Inu.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaDeteccion,
				'' AS Nacionalidad,
				'1' AS TipoDePersona,
				'' AS RazonSocioal,
				IFNULL(NombresPersonaInv,'XXX') AS Nombre,
				IFNULL(ApPaternoPersonaInv,'XXXX') AS ApellidoPaterno,
				IFNULL(ApMaternoPersonaInv,'XXXX') AS ApellidoMaterno,
				'' AS RFC,
				'' AS CURP,
				DATE_FORMAT('1900-01-01','%Y%m%d') AS FechaNacimiento,
				'SIN CALLE' AS Domicilio,
				'' AS Colonia,
				'' AS Localidad,
				'' AS Telefonos,
				'9999999999' AS ActividadEconomica,			-- Actividad Economica No Clasificada
				'' AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
				'' AS RFCApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'' AS CURPApoSeguros,				-- Deberan ir vacios para CONSAR y la CNBV,
				'00' AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
				'' AS NumCuentaRelacionado	,
				'' AS ClaveCasfimRelacionado,
				'' AS NombreRelacionado,
				'' AS ApellidoPaternoRelacionado,
				'' AS ApellidoMaternoRelacionado,
				UPPER(TRIM(CONCAT(IFNULL(Inu.DesOperacion, ''), ' ', IFNULL(Inu.ComentarioOC, '')) )) AS DescriOperacion,
				UPPER(TRIM(IFNULL(Mot.DesCorta, ''))) AS DescriMotivo,
				Inu.OpeInusualID
			  FROM PLDOPEINUSUALES Inu
				LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
				LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
				WHERE IF(Par_Estatus = 0, TRUE, Inu.Estatus = Par_Estatus)
					AND Inu.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal
					AND (Inu.TipoPersonaSAFI='NA' OR Inu.TipoPersonaSAFI='' OR Inu.TipoPersonaSAFI IS NULL);
		END IF;

		-- GENERACION DE LA INFORMACION PARA EL REPORTE DE OP INUSUALES
		SELECT	TipoDeReporte AS TipoReporte,
			Periodo AS PeriodoReporte,
			LPAD(Folio,6, 0) AS Folio,
			OrganoSup AS ClaveOrgSupervisor,
			ClaveCasfim AS ClaveEntCasFim,
			LEFT(LocalidadSuc,8) AS LocalidadSuc,
			LPAD(SucursalCP,8,0) AS Sucursal,
			IF((@Var_NombreCorto='sofom' AND @Var_EntidadRegulada = 'N' AND TipoOperacion = '01'),
				'09',TipoOperacion) AS TipoOperacionID,
			InstrumentoMon AS InstrumentMonID,
			LPAD(NumCuenta,16,0) AS CuentaAhoID,
			MontoOperacion AS Monto,
			LPAD(Moneda,3,0) AS ClaveMoneda,
			FechaOperacion AS FechaOpe,
			FechaDeteccion AS FechaDeteccion,
			IF(Nacionalidad='MX','1','2') AS Nacionalidad,
			TipoDePersona AS TipoPersona,
			LEFT(RazonSocioal,125) 	AS RazonSocial,
			LEFT(Nombre, 60) 			AS Nombre,
			LEFT(ApellidoPaterno,60) 	AS ApellidoPat,
			LEFT(ApellidoMaterno,30)	AS ApellidoMat,
			RFC,
			CURP,
			FechaNacimiento AS FechaNac,
			FNLIMPIACARACTERESGEN(LEFT(Domicilio,60),'MA') AS Domicilio,
			FNLIMPIACARACTERESGEN(LEFT(Colonia,30),'MA') AS Colonia,
			LEFT(Localidad,8) 		AS Localidad,
			LEFT(Telefonos,40) 		AS Telefono,
			CASE LENGTH(ActividadEconomica)
				WHEN 9 THEN
					LPAD(LEFT(ActividadEconomica,6),7,'0')
				WHEN 10 THEN
					LPAD(LEFT(ActividadEconomica,7),7,'0')
			END AS ActEconomica,
			NombreApoSeguros AS NomApoderado,
			ApellidoPaternoApoSeguros AS ApPatApoderado,
			ApellidoMaternoApoSeguros AS ApMatApoderado,
			RFCApoSeguros AS RFCApoderado,
			CURPApoSeguros AS CURPApoderado,
			ConsecutivoCuenta AS CtaRelacionadoID,
			IF((@Var_NombreCorto='sofom' AND @Var_EntidadRegulada = 'N'),LPAD(NumCuenta,16,0),NumCuentaRelacionado) AS CuenAhoRelacionado,
			ClaveCasfimRelacionado AS ClaveSujeto,
			NombreRelacionado AS NomTitular,
			ApellidoPaternoRelacionado AS ApPatTitular,
			ApellidoMaternoRelacionado AS ApMatTitular,
			FNLIMPIACARACTERESGEN(DescriOperacion,'MA') AS DesOperacion,
			FNLIMPIACARACTERESGEN(DescriMotivo,'MA') AS Razones
		FROM TMPENVIOALERTASINUSUALES;
	END IF;

	IF(Par_NumCon = Rep_IntPreocupantes) THEN

		INSERT INTO TMPENVIOALERTASPREOCUPANTES (
			TipoDeReporte,		Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
			SucursalCP,			TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
			Moneda,				FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
			RazonSocioal,		Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
			CURP,				FechaNacimiento,			Domicilio,					Colonia,					Localidad,
			Telefonos,			ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
			RFCApoSeguros,		CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
			NombreRelacionado,	ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
			OpeInterPreoID)
		  SELECT
			'3',@Var_PeriodoReporte,			@Var_OrganoSupervisor,		@Var_ClaveCasFim,			RIGHT(IFNULL('01001002', ''),8) AS LocalidadSuc,
			IF(@Var_NombreCorto='sofom',IFNULL(Suc.CP, ''),IFNULL(Suc.ClaveSucCNBV, '')) AS SucursalCP,
			IFNULL('08', '') AS TipoOperacion,
			'01' AS InstrumentoMon,
			'0' AS NumCuenta,
			'00000000000000.00' AS MontoOperacion,
			'1' AS Moneda,
			DATE_FORMAT(IFNULL(Preo.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaOperacion, -- Es la misma de deteccion ya que se detecta el mismo dia en el cierre
			DATE_FORMAT(IFNULL(Preo.FechaDeteccion, '1900-01-01'),'%Y%m%d') AS FechaDeteccion,
			'1' AS Nacionalidad,
			'1'  AS TipoDePersona,
			'' AS RazonSocioal,
			IFNULL(TRIM(CONCAT(IFNULL(Emp.PrimerNombre,''),' ',IFNULL(Emp.SegundoNombre,''))), 'XXXX') AS Nombre,
			IFNULL(Emp.ApellidoPat, 'XXXX') AS ApellidoPat,
			IFNULL(Emp.ApellidoMat, 'XXXX') AS ApellidoMat,
			IFNULL(Emp.RFC, '') AS RFC,
			'' AS CURP,
			DATE_FORMAT(IFNULL(Emp.FechaNac, '1900-01-01'),'%Y%m%d')   AS FechaNacimiento,
			'' AS Domicilio,
			'' AS Colonia,
			'' AS Localidad,
			'' AS Telefonos,
			'8949903160' AS ActividadEconomica,
			'' AS NombreApoSeguros,   		-- Deberan ir vacios para CONSAR y la CNBV,
			'' AS ApellidoPaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
			'' AS ApellidoMaternoApoSeguros,  -- Deberan ir vacios para CONSAR y la CNBV,
			'' AS RFCApoSeguros,    			-- Deberan ir vacios para CONSAR y la CNBV,
			'' AS CURPApoSeguros,    			-- Deberan ir vacios para CONSAR y la CNBV,
			'00' AS ConsecutivoCuenta, 	-- El 00 indica que es el Titular
			'' AS NumCuentaRelacionado    ,
			'' AS ClaveCasfimRelacionado,
			TRIM(CONCAT(IFNULL(Emp.PrimerNombre,''),' ',IFNULL(Emp.SegundoNombre,''))) AS NombreRelacionado,
			IFNULL(Emp.ApellidoPat,'') AS ApellidoPaternoRelacionado,
			IFNULL(Emp.ApellidoMat,'') AS ApellidoMaternoRelacionado,
			TRIM(CONCAT(IFNULL(Preo.DesOperacion, ''), ' ', IFNULL(REPLACE(Preo.ComentarioOC,char(10 using utf8),'*'), ''))) AS DescriOperacion,
			TRIM(IFNULL(Mot.DesCorta, '')) AS DescriMotivo,
			Preo.OpeInterPreoID
			FROM PLDOPEINTERPREO Preo
				LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Preo.SucursalID
				LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
				LEFT JOIN EMPLEADOS Emp ON Preo.ClavePersonaInv=Emp.EmpleadoID
				LEFT JOIN PLDCATMOTIVPREO Mot ON Mot.CatMotivPreoID = Preo.CatMotivPreoID
				WHERE if(Par_Estatus = 0, true, Preo.Estatus = Par_Estatus)
				AND Preo.FechaDeteccion BETWEEN Par_FechaInicio AND Par_FechaFinal;

		-- GENERACION DE LA INFORMACION PARA EL REPORTE DE OP. INTERNAS PREOCUPANTES
		SELECT
			TipoDeReporte AS TipoReporte,
			Periodo AS PeriodoReporte,
			LPAD(Folio,6, 0) AS Folio,
			OrganoSup AS ClaveOrgSupervisor,
			ClaveCasfim AS ClaveEntCasFim,
			LEFT(LocalidadSuc,8) AS LocalidadSuc,
			LPAD(SucursalCP,8,0) AS Sucursal,
			TipoOperacion AS TipoOperacionID,
			InstrumentoMon AS InstrumentMonID,
			LPAD(NumCuenta,16,0) AS CuentaAhoID,
			MontoOperacion AS Monto,
			LPAD(Moneda,3,0) AS ClaveMoneda,
			FechaOperacion AS FechaOpe,
			FechaDeteccion,
			Nacionalidad,
			TipoDePersona AS TipoPersona,
			LEFT(RazonSocioal,125) AS RazonSocial,
			LEFT(Nombre, 60) AS Nombre,
			LEFT(ApellidoPaterno,60) AS ApellidoPat,
			LEFT(ApellidoMaterno,30) AS ApellidoMat,
			RFC,
			CURP,
			FechaNacimiento AS FechaNac,
			FNLIMPIACARACTERESGEN(LEFT(Domicilio,60),'MA') AS Domicilio,
			FNLIMPIACARACTERESGEN(LEFT(Colonia,30),'MA') AS Colonia,
			LEFT(Localidad,8) AS Localidad,
			LEFT(Telefonos,40) AS Telefono,
			CASE LENGTH(ActividadEconomica)
				WHEN 9 THEN
					LPAD(LEFT(ActividadEconomica,6),7,'0')
				WHEN 10 THEN
					LPAD(LEFT(ActividadEconomica,7),7,'0')
			END AS ActEconomica,
			NombreApoSeguros AS NomApoderado,
			ApellidoPaternoApoSeguros AS ApPatApoderado,
			ApellidoMaternoApoSeguros AS ApMatApoderado,
			RFCApoSeguros AS RFCApoderado,
			CURPApoSeguros AS CURPApoderado,
			ConsecutivoCuenta AS CtaRelacionadoID,
			NumCuentaRelacionado AS CuenAhoRelacionado,
			ClaveCasfimRelacionado AS ClaveSujeto,
			NombreRelacionado AS NomTitular,
			ApellidoPaternoRelacionado AS ApPatTitular,
			ApellidoMaternoRelacionado AS ApMatTitular,
			FNLIMPIACARACTERESGEN(DescriOperacion,'MA') AS DesOperacion,
			FNLIMPIACARACTERESGEN(DescriMotivo,'MA') AS Razones
		FROM TMPENVIOALERTASPREOCUPANTES;
	END IF;

	IF(Par_NumCon = Rep_Reelevantes) THEN
		-- GENERACION DE LA INFORMACION PARA EL REPORTE DE OP RELEVANTES
		SELECT	PLD.TipoReporte,
			DATE_FORMAT(@Var_PeriodoReporte,'%Y%m') AS PeriodoReporte,
			LPAD(PLD.Folio,6, 0) AS Folio,
			@Var_OrganoSupervisor AS ClaveOrgSupervisor,
			@Var_ClaveCasFim AS ClaveEntCasFim,
			LEFT(PLD.LocalidadSuc, 8) AS LocalidadSuc,
			LPAD(PLD.SucursalID, 8, 0) AS Sucursal,
			IF((@Var_NombreCorto='sofom' AND @Var_EntidadRegulada = 'N' AND PLD.TipoOperacionID = '01'),
				'09',PLD.TipoOperacionID) AS TipoOperacionID,
			PLD.InstrumentMonID,
			LPAD(PLD.CuentaAhoID, 16, 0) AS CuentaAhoID,
			CAST(PLD.Monto AS DECIMAL(14,2)) AS Monto,
			PLD.ClaveMoneda AS ClaveMoneda,
			PLD.FechaOpe,
			FechaDeteccion,
			P.ClaveCNBV AS Nacionalidad,
			PLD.TipoPersona,
			REPLACE(UPPER(LEFT(PLD.RazonSocial, 125)),'Ñ','N') AS RazonSocial,
			IF(PLD.TipoPersona = 'M', '', REPLACE(UPPER(LEFT(PLD.Nombre, 60)),'Ñ','N')) AS Nombre,
			IF(PLD.TipoPersona = 'M', '', REPLACE(UPPER(LEFT(IF(PLD.ApellidoPat IS NULL OR TRIM(PLD.ApellidoPat) = '','XXXX', PLD.ApellidoPat), 60)),'Ñ','N')) AS ApellidoPat,
			IF(PLD.TipoPersona = 'M', '', REPLACE(UPPER(LEFT(IF(PLD.ApellidoMat IS NULL OR TRIM(PLD.ApellidoMat) = '','XXXX', PLD.ApellidoMat), 60)),'Ñ','N')) AS ApellidoMat,
			TRIM(PLD.RFC) AS RFC,
			IF(PLD.TipoPersona = 'M', '', PLD.CURP) AS CURP,
			DATE_FORMAT(IF(PLD.TipoPersona = 'M', C.FechaConstitucion, C.FechaNacimiento), '%Y%m%d') AS FechaNac,
			REPLACE(UPPER(LEFT(PLD.Domicilio, 60)),'Ñ','N') AS Domicilio,
			UPPER(LEFT(PLD.Colonia, 30)) AS Colonia,
			UPPER(LEFT(PLD.Localidad, 8)) AS Localidad,
			LEFT(PLD.Telefono, 40) AS Telefono,
			CASE LENGTH(PLD.ActEconomica)
				WHEN 9 THEN
					LPAD(LEFT(PLD.ActEconomica, 6), 7, 0)
				WHEN 10 THEN
					LPAD(LEFT(PLD.ActEconomica, 7), 7, 0)
			END AS ActEconomica,
			PLD.NomApoderado,		PLD.ApPatApoderado,			PLD.ApMatApoderado,				PLD.RFCApoderado,			PLD.CURPApoderado,
			PLD.CtaRelacionadoID,	PLD.CuenAhoRelacionado,		PLD.ClaveSujeto,				PLD.NomTitular,				PLD.ApPatTitular,
			PLD.ApMatTitular,		PLD.DesOperacion,			PLD.Razones
		FROM PLDCNBVOPEREELE PLD
			LEFT JOIN CUENTASAHO CA ON PLD.CuentaAhoID =CA.CuentaAhoID
			INNER JOIN CLIENTES C ON CA.ClienteID = C.ClienteID
			INNER JOIN PAISES P ON P.PaisID = IF(PLD.TipoPersona = 'M', C.PaisConstitucionID, C.LugarNacimiento)
			WHERE str_to_date(PLD.FechaOpe,'%Y%m%d') BETWEEN Par_FechaInicio AND Par_FechaFinal;
	END IF;

END TerminaStore$$