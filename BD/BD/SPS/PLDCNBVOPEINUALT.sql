-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCNBVOPEINUALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCNBVOPEINUALT`;
DELIMITER $$

CREATE PROCEDURE `PLDCNBVOPEINUALT`(

	Par_FolioSITI			VARCHAR(15),
	Par_UsuarioSITI			VARCHAR(15),
	Par_NombreArchivo		VARCHAR(45),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),

	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN


DECLARE	Var_FechaSistema			DATE;
DECLARE	Var_DiasParaEnviar			INT(11);
DECLARE	Var_PeriodoReporte			INT(11);
DECLARE	Var_OrganoSupervisor		VARCHAR(6);
DECLARE	Var_ClaveCasFim				VARCHAR(7);
DECLARE	Var_Control					VARCHAR(20);


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
DECLARE EstatusVigente				CHAR(1);


SET	Cadena_Vacia				:= '';
SET	Fecha_Vacia					:= '1900-01-01';
SET	Entero_Cero					:= 0;
SET	Str_SI						:= 'S';
SET	Str_NO						:= 'N';
SET	EstatusReportarOperacion	:= 3;
SET	ClavePersonalInterno		:= '1';
SET	ClavePersonalExterno		:= '2';
SET	ClaveSistemaAutomatico		:= '3';
SET	ParamVigente				:= 'V';
SET	ActaConstitutiva			:= 'C';
SET	RegistroTitularCta			:= '00';
SET	TipoRepInusuales			:= '2';
SET	InstrumEfectivo				:= '01';
SET EstatusVigente				:= 'V';

SET Var_Control					:= '';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDCNBVOPEINUALT');
		END;

	IF(CHAR_LENGTH(Par_FolioSITI)  <= Entero_Cero) THEN
		SET	Par_NumErr	:= 001;
		SET	Par_ErrMen	:= CONCAT('Debe indicar el Folio del SITI ');
		SET Var_Control := 'opeInusualID';
		LEAVE ManejoErrores;
	END IF;

	IF EXISTS(SELECT  1 FROM PLDCNBVOPEINU WHERE FolioSITI = Par_FolioSITI) THEN
		SET	Par_NumErr	:= 002;
		SET	Par_ErrMen	:= CONCAT('El Folio ', Par_FolioSITI, '  ya fue registrado con anterioridad.');
		SET Var_Control := 'opeInusualID';
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT FolioID
					FROM PARAMETROSPLD
						WHERE Estatus = EstatusVigente))THEN
		SET Par_NumErr = 003;
		SET Par_ErrMen = CONCAT('No Existen Parametros Vigentes para Organos Supervisores.');
		LEAVE ManejoErrores;
	END IF;

	SET	Var_FechaSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET	Var_PeriodoReporte		:= DATE_FORMAT(Var_FechaSistema,'%Y%m%d');
	SET	Var_OrganoSupervisor	:= (SELECT ClaveOrgSupervisor FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET	Var_ClaveCasFim			:= (SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);

	DROP TABLE IF EXISTS TMPENVIOALERTASINUSUALES;
	CREATE TEMPORARY TABLE TMPENVIOALERTASINUSUALES (
		TipoDeReporte				CHAR(1),
		Periodo						INT(11),
		Folio 						INTEGER AUTO_INCREMENT PRIMARY KEY,
		OrganoSup					VARCHAR(6),
		ClaveCasfim					VARCHAR(7),
		LocalidadSuc				VARCHAR(10),
		Sucursal					VARCHAR(8),
		TipoOperacion				VARCHAR(2),
		InstrumentoMon				VARCHAR(2),
		NumCuenta					VARCHAR(16),
		MontoOperacion				DECIMAL(18,2),
		Moneda						VARCHAR(3),
		FechaOperacion				INT(11),
		FechaDeteccion				INT(11),
		Nacionalidad				VARCHAR(1),
		TipoDePersona				VARCHAR(1),
		RazonSocioal				VARCHAR(150),
		Nombre						VARCHAR(150),
		ApellidoPaterno				VARCHAR(60),
		ApellidoMaterno				VARCHAR(30),
		RFC							VARCHAR(13),
		CURP						VARCHAR(18),
		FechaNacimiento				INT(11),
		Domicilio					VARCHAR(500),
		Colonia						VARCHAR(300),
		Localidad					VARCHAR(10),
		Telefonos					VARCHAR(40),
		ActividadEconomica			VARCHAR(15),
		NombreApoSeguros			VARCHAR(60),
		ApellidoPaternoApoSeguros	VARCHAR(60),
		ApellidoMaternoApoSeguros	VARCHAR(30),
		RFCApoSeguros				VARCHAR(13),
		CURPApoSeguros				VARCHAR(18),
		ConsecutivoCuenta			VARCHAR(2),
		NumCuentaRelacionado		VARCHAR(16),
		ClaveCasfimRelacionado		VARCHAR(6),
		NombreRelacionado			VARCHAR(60),
		ApellidoPaternoRelacionado	VARCHAR(60),
		ApellidoMaternoRelacionado	VARCHAR(60),
		DescriOperacion				VARCHAR(5000),
		DescriMotivo				VARCHAR(500),
		OpeInusualID				BIGINT(11),
		FolioInterno				INT(11)
	);


	INSERT INTO TMPENVIOALERTASINUSUALES (
		TipoDeReporte,			Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		Sucursal,				TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,					FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,			Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,					FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,				ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,			CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,		ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInusualID,			FolioInterno)
	SELECT
		TipoRepInusuales,		Var_PeriodoReporte,			Var_OrganoSupervisor,		Var_ClaveCasFim,			RIGHT(IFNULL(MunSuc.Localidad, Cadena_Vacia),8) AS LocalidadSuc,
		RIGHT(IFNULL(CAST(Inu.SucursalID AS CHAR), Cadena_Vacia),8) AS Sucursal,
		IFNULL(Inu.TipoOpeCNBV, Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		CASE WHEN IFNULL(Inu.CuentaAhoID, Entero_Cero) = Entero_Cero THEN Cadena_Vacia
			ELSE CAST(Inu.CuentaAhoID AS CHAR)
		END AS NumCuenta,
		CAST(Inu.MontoOperacion AS CHAR) AS MontoOperacion,
		CAST(Inu.MonedaID AS CHAR) AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		CASE Cli.Nacion
			WHEN 'N' THEN '1'
            WHEN 'E' THEN '2'
            ELSE '1'
		END AS Nacionalidad,
		CASE Cli.TipoPersona
			WHEN 'F' THEN '1'
            WHEN 'A' THEN '1'
            WHEN 'M' THEN '2'
            ELSE '1'
		END AS TipoDePersona,
		CASE WHEN Cli.TipoPersona IN ('M','A') THEN IFNULL(Cli.RazonSocial, Cadena_Vacia) ELSE Cadena_Vacia END AS RazonSocioal,
		CASE WHEN Cli.TipoPersona IN ('M') THEN Cadena_Vacia
			ELSE CONCAT(IFNULL(Cli.PrimerNombre, 'XXX')," ", IFNULL(Cli.SegundoNombre, Cadena_Vacia)," ", IFNULL(Cli.TercerNombre, Cadena_Vacia))
		END Nombre,
		CASE WHEN Cli.TipoPersona IN ('M') THEN Cadena_Vacia
			ELSE IFNULL(Cli.ApellidoPaterno, 'XXXX')
        END AS ApellidoPaterno,
		CASE WHEN Cli.TipoPersona IN ('M') THEN Cadena_Vacia
			ELSE IFNULL(Cli.ApellidoMaterno, 'XXXX')
		END AS ApellidoMaterno,
		IFNULL(Cli.RFCOficial, Cadena_Vacia) AS RFC,
		IFNULL(Cli.CURP, Cadena_Vacia) AS CURP,
		CASE WHEN Cli.TipoPersona IN ('M') THEN DATE_FORMAT(IFNULL(Esc.FechaEsc, Fecha_Vacia),'%Y%m%d')
			ELSE DATE_FORMAT(IFNULL(Cli.FechaNacimiento, Fecha_Vacia),'%Y%m%d')
		END AS FechaNacimiento,
		IFNULL(CONCAT(IFNULL(Dir.Calle, 'SIN CALLE'), " ", Dir.NumeroCasa, " ", Dir.NumInterior, " C.P.",Dir.CP), Cadena_Vacia) AS Domicilio,
		IFNULL(Dir.Colonia, Cadena_Vacia) AS Colonia,
		RIGHT(IFNULL(Mun.Localidad, Cadena_Vacia),8) AS Localidad,
		CONCAT(TRIM(IFNULL(Cli.TelTrabajo, Cadena_Vacia)),
        CASE WHEN CHAR_LENGTH(TRIM(IFNULL(Cli.TelTrabajo, Cadena_Vacia))) > 0 THEN "/"
			ELSE Cadena_Vacia
		END,
        TRIM(IFNULL(Cli.Telefono, Cadena_Vacia))) AS Telefonos,
		TRIM(IFNULL(Cli.ActividadBancoMX, Cadena_Vacia)) AS ActividadEconomica,
		Cadena_Vacia AS NombreApoSeguros,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,
		Cadena_Vacia AS RFCApoSeguros,
		Cadena_Vacia AS CURPApoSeguros,
		RegistroTitularCta AS ConsecutivoCuenta,
		Cadena_Vacia AS NumCuentaRelacionado	,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		Cadena_Vacia AS NombreRelacionado,
		Cadena_Vacia AS ApellidoPaternoRelacionado,
		Cadena_Vacia AS ApellidoMaternoRelacionado,
		TRIM(CONCAT(IFNULL(Inu.DesOperacion, Cadena_Vacia), " ", IFNULL(Inu.ComentarioOC, Cadena_Vacia)) ) AS DescriOperacion,
		TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia)) AS DescriMotivo,
		Inu.OpeInusualID ,
		Inu.FolioInterno
	FROM PLDOPEINUSUALES Inu
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
		LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
		LEFT JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Inu.CuentaAhoID
		LEFT JOIN CLIENTES Cli ON Cli.ClienteID = Inu.ClavePersonaInv
		LEFT JOIN ESCRITURAPUB Esc ON Esc.ClienteID = Cli.ClienteID AND Esc_Tipo = ActaConstitutiva
		LEFT JOIN DIRECCLIENTE Dir ON Dir.ClienteID = Cli.ClienteID AND Dir.Oficial = Str_SI
		LEFT JOIN MUNICIPIOSREPUB Mun ON Mun.EstadoID = Dir.EstadoID AND Mun.MunicipioID = Dir.MunicipioID
		LEFT JOIN PLDCATMOTIVINU Mot ON Mot.CatMotivInuID = Inu.CatMotivInuID
	WHERE Inu.Estatus = EstatusReportarOperacion
	    AND Inu.FolioInterno > Entero_Cero;

	SET	Aud_FechaActual	:=	NOW();

	INSERT INTO PLDCNBVOPEINU(
		TipoReporte,				PeriodoReporte,			Folio,							ClaveOrgSupervisor,			ClaveEntCasFim,
		LocalidadSuc,				SucursalID,				TipoOperacionID,				InstrumentMonID,			CuentaAhoID,
		Monto,						ClaveMoneda,			FechaOpe,						FechaDeteccion,				Nacionalidad,
		TipoPersona,				RazonSocial,			Nombre,							ApellidoPat,				ApellidoMat,
		RFC,						CURP,					FechaNac,						Domicilio,					Colonia,
		Localidad,					Telefono,				ActEconomica,					NomApoderado,				ApPatApoderado,
		ApMatApoderado,				RFCApoderado,			CURPApoderado,					CtaRelacionadoID,			CuenAhoRelacionado,
		ClaveCasfimRelacionado,		NomTitular,				ApPatTitular,					ApMatTitular,				DesOperacion,
		Razones,					FolioInterno,			FolioSITI,						UsuarioSITI,				NombreArchivo,
		EmpresaID,					Usuario,				FechaActual,					DireccionIP,				ProgramaID,
		Sucursal,					NumTransaccion)
	  SELECT
		TipoDeReporte,				Periodo,				LPAD(Folio,6,'0'),				OrganoSup,					ClaveCasfim,
		LocalidadSuc,				Sucursal,				TipoOperacion,					InstrumentoMon,				NumCuenta,
		MontoOperacion,				Moneda,					FechaOperacion,					FechaDeteccion,				Nacionalidad,
		TipoDePersona,				RazonSocioal,			Nombre,							ApellidoPaterno,			ApellidoMaterno,
		RFC,						CURP,					FechaNacimiento,				Domicilio,					Colonia,
		Localidad,					Telefonos,				ActividadEconomica,				NombreApoSeguros,			ApellidoPaternoApoSeguros,
		ApellidoMaternoApoSeguros,	RFCApoSeguros,			CURPApoSeguros,					ConsecutivoCuenta,			NumCuentaRelacionado,
		ClaveCasfimRelacionado,		NombreRelacionado,		ApellidoPaternoRelacionado,		ApellidoMaternoRelacionado,	LEFT(DescriOperacion,1800),
		DescriMotivo,				FolioInterno,			Par_FolioSITI,					Par_UsuarioSITI,			Par_NombreArchivo,
		Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,
		Aud_Sucursal,				Aud_NumTransaccion
		FROM TMPENVIOALERTASINUSUALES
	   ORDER BY Folio;

	CALL HISPLDOPEINUSUAALT(
		Par_FolioSITI,		Par_UsuarioSITI,		Par_NombreArchivo,			Str_NO,				Par_NumErr,
		Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	SET	Par_NumErr	:= Entero_Cero;
	SET	Par_ErrMen	:= CONCAT("Folio del SITI registrado con Exito.");
    SET Var_Control := 'opeInusualID';

END ManejoErrores;

IF(Par_Salida = Str_SI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
			Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$