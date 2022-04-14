
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCNBVOPEINTPREOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCNBVOPEINTPREOALT`;

DELIMITER $$
CREATE PROCEDURE `PLDCNBVOPEINTPREOALT`(
/* SP QUE SE MANDA A LLAMAR DENTRO DEL SP HISPLDOPEINTERPREALT AL MOMENTO DE LA GENERACION DEL
	ARCHIVO A ENVIAR A LA CNBV.*/
	Par_PeriodoInicio		DATE,			-- Fecha de Inicio del Periodo
	Par_PeriodoFin			DATE,			-- Fecha Final del Periodo
	Par_Salida           	CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),		-- Numero de Error
	INOUT Par_ErrMen     	VARCHAR(400),	-- Mensaje de Error

	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	Var_FechaSistema			DATE;
DECLARE	Var_PeriodoReporte			INT(11);
DECLARE	Var_OrganoSupervisor		VARCHAR(6);
DECLARE	Var_ClaveCasFim				VARCHAR(7);
DECLARE Var_TipoInstitID			INT(11);
DECLARE Var_NombreCorto				VARCHAR(45);
DECLARE Var_LimpiaDirPLD			CHAR(1);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE Str_SI				CHAR(1);
DECLARE Str_NO				CHAR(1);
DECLARE EstatusVigente		CHAR(1);
DECLARE TipoRep_IntPreoc	CHAR(1);
DECLARE Inst_Efectivo		CHAR(2);
DECLARE Num_CtaRel			CHAR(2);
DECLARE Estatus_Rep			INT(11);
DECLARE LongFolio			INT(11);
DECLARE LongRazonSocial		INT(11);
DECLARE LongNombre			INT(11);
DECLARE LongApMaterno		INT(11);
DECLARE LongDomicilio		INT(11);
DECLARE LongColonia			INT(11);
DECLARE LongLocalidad		INT(11);
DECLARE LongSucursal		INT(11);
DECLARE LongTelefono		INT(11);
DECLARE LongActEconomica6	INT(11);
DECLARE LongActEconomica7	INT(11);
DECLARE LongCuenta			INT(11);
DECLARE LongMoneda			INT(11);
DECLARE Mayusculas			CHAR(2);
DECLARE TipoSocap			INT(11);
DECLARE TipoSofipo			INT(11);
DECLARE TipoSofom			INT(11);
DECLARE Nac_Mexicana		CHAR(2);
DECLARE Clave_ActEco		VARCHAR(11);
DECLARE Clave_Localidad		VARCHAR(8);
DECLARE Monto_Cero			DECIMAL(18,2);

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';					-- Cadena Vacia
SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
SET Entero_Cero				:= 0;					-- Entero Cero
SET	Str_SI					:= 'S';					-- Constante SI
SET	Str_NO					:= 'N';					-- Constante NO
SET	EstatusVigente			:= 'V';					-- Estatus Vigente
SET TipoRep_IntPreoc		:= '3';					-- Tipo Reporte Internas Preocupantes.
SET Inst_Efectivo			:= '01';				-- Tipo de Instrumento en Efectivo.
SET Num_CtaRel				:= '00';				-- Número de Cuenta del Relacionado.
SET Estatus_Rep				:= 3;					-- Estatus de la operación: Reportado.
SET LongFolio				:= 6;					-- Longitud para campo Folio.
SET LongRazonSocial			:= 125;					-- Longitud para campo Razon Social.
SET LongNombre				:= 60;					-- Longitud para campo Nombre.
SET LongApMaterno			:= 30;					-- Longitud para campo Ap. Materno.
SET LongDomicilio			:= 60;					-- Longitud para campo Domicilio.
SET LongColonia				:= 30;					-- Longitud para campo Colonia.
SET LongLocalidad			:= 8;					-- Longitud para campo Localidad.
SET LongSucursal			:= 8;					-- Longitud para campo Sucursal.
SET LongTelefono			:= 40;					-- Longitud para campo Telefono.
SET LongActEconomica6		:= 6;					-- Longitud para campo ActEconomica6.
SET LongActEconomica7		:= 7;					-- Longitud para campo ActEconomica7.
SET LongCuenta				:= 16;					-- Longitud para campo Cuenta.
SET LongMoneda				:= 3;					-- Longitud para campo Moneda.
SET Mayusculas				:= 'MA';				-- Mayusculas.
SET TipoSocap				:= 6;					-- Tipo de Inst. Financiera: Socap.
SET TipoSofipo				:= 3;					-- Tipo de Inst. Financiera: Sofipo.
SET TipoSofom				:= 4;					-- Tipo de Inst. Financiera: Sofom.
SET Nac_Mexicana			:= '1';
SET Clave_ActEco			:= '8949903160';
SET Clave_Localidad			:= '01001002';
SET Monto_Cero				:= '00000000000000.00';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		GET DIAGNOSTICS condition 1
		@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDCNBVOPEINTPREOALT[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		END;

	IF(NOT EXISTS(SELECT FolioID FROM PARAMETROSPLD WHERE Estatus = EstatusVigente))THEN
		SET Par_NumErr = 001;
		SET Par_ErrMen = CONCAT('No Existen Parametros Vigentes para Organos Supervisores.');
		LEAVE ManejoErrores;
	END IF;

	SET Var_FechaSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_PeriodoReporte		:= DATE_FORMAT(Var_FechaSistema,'%Y%m%d');
	SET Var_OrganoSupervisor	:= (SELECT ClaveOrgSupervisor FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET Var_ClaveCasFim			:= (SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET Var_LimpiaDirPLD		:= LEFT(FNPARAMGENERALES('LimpiaDirPLD'),1);
	SET Var_LimpiaDirPLD		:= IF(Var_LimpiaDirPLD = Cadena_Vacia,Str_NO,Var_LimpiaDirPLD);
	SET @Var_Folio				:= 0;

	SELECT
		IFNULL(Ins.TipoInstitID,Entero_Cero), 	Tip.NombreCorto
	INTO
		Var_TipoInstitID, 						Var_NombreCorto
	FROM PARAMETROSSIS Par
		INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
		INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID;

	DELETE FROM TMPSITIPLDREP WHERE NumTransaccion = Aud_NumTransaccion;

	INSERT INTO TMPSITIPLDREP (
		TipoReporte,	PeriodoReporte,	Folio,				ClaveOrgSupervisor,	ClaveEntCasFim,
		LocalidadSuc,	Sucursal,		TipoOperacionID,	InstrumentMonID,	CuentaAhoID,
		Monto,			ClaveMoneda,	FechaOpe,			FechaDeteccion,		Nacionalidad,
		TipoPersona,	RazonSocial,	Nombre,				ApellidoPat,		ApellidoMat,
		RFC,			CURP,			FechaNac,			Domicilio,			Colonia,
		Localidad,		Telefono,		ActEconomica,		NomApoderado,		ApPatApoderado,
		ApMatApoderado,	RFCApoderado,	CURPApoderado,		CtaRelacionadoID,	CuenAhoRelacionado,
		ClaveSujeto,	NomTitular,		ApPatTitular,		ApMatTitular,		DesOperacion,
		Razones,		ClaveCNBV,		OperacionID,		Fecha,				NumTransaccion)
	SELECT
		TipoRep_IntPreoc,	Var_PeriodoReporte,		(@Var_Folio:=@Var_Folio+1),	Var_OrganoSupervisor,		Var_ClaveCasFim,

		RIGHT(FNGETPLDSITILOC(Suc.EstadoID, Suc.MunicipioID, Suc.LocalidadID),8) AS LocalidadSuc,
		IF(Var_TipoInstitID=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL('08', Cadena_Vacia) AS TipoOperacion,
		Inst_Efectivo AS InstrumentoMon,
		'0' AS NumCuenta,

		Monto_Cero AS MontoOperacion,
		'1' AS Moneda,
		DATE_FORMAT(IFNULL(PLD.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion,
		DATE_FORMAT(IFNULL(PLD.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		Nac_Mexicana AS Nacionalidad,

		'1'  AS TipoDePersona,
		Cadena_Vacia AS RazonSocioal,
		IFNULL(TRIM(CONCAT(IFNULL(Emp.PrimerNombre,Cadena_Vacia),' ',IFNULL(Emp.SegundoNombre,Cadena_Vacia))), 'XXXX') AS Nombre,
		IFNULL(Emp.ApellidoPat, 'XXXX') AS ApellidoPaterno,
		IFNULL(Emp.ApellidoMat, 'XXXX') AS ApellidoMaterno,

		IFNULL(Emp.RFC, Cadena_Vacia) AS RFC,
		Cadena_Vacia AS CURP,
		DATE_FORMAT(IFNULL(Emp.FechaNac, Fecha_Vacia),'%Y%m%d') AS FechaNacimiento,
		Cadena_Vacia AS Domicilio,
		Cadena_Vacia AS Colonia,

		Cadena_Vacia AS Localidad,
		Cadena_Vacia AS Telefonos,
		Clave_ActEco AS ActividadEconomica,
		Cadena_Vacia AS NombreApoSeguros,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,

		Cadena_Vacia AS ApellidoMaternoApoSeguros,
		Cadena_Vacia AS RFCApoSeguros,
		Cadena_Vacia AS CURPApoSeguros,
		Num_CtaRel AS ConsecutivoCuenta,
		Cadena_Vacia AS NumCuentaRelacionado    ,

		Cadena_Vacia AS ClaveCasfimRelacionado,
		TRIM(CONCAT(IFNULL(Emp.PrimerNombre,Cadena_Vacia)," ",IFNULL(Emp.SegundoNombre,Cadena_Vacia))) AS NombreRelacionado,
		IFNULL(Emp.ApellidoPat,Cadena_Vacia) AS ApellidoPaternoRelacionado,
		IFNULL(Emp.ApellidoMat,Cadena_Vacia) AS ApellidoMaternoRelacionado,
		TRIM(CONCAT(IFNULL(PLD.DesOperacion, Cadena_Vacia), " ", IFNULL(REPLACE(PLD.ComentarioOC,char(10 using utf8),'*'), Cadena_Vacia))) AS DescriOperacion,

		TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia)) AS DescriMotivo,
		Cadena_Vacia,			PLD.OpeInterPreoID,		PLD.Fecha,		Aud_NumTransaccion
	FROM HISPLDOPEINTERPREO PLD
		LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = PLD.SucursalID
		LEFT JOIN EMPLEADOS Emp ON PLD.ClavePersonaInv=Emp.EmpleadoID
		LEFT JOIN PLDCATMOTIVPREO Mot ON Mot.CatMotivPreoID = PLD.CatMotivPreoID
	WHERE PLD.Estatus = Estatus_Rep
		AND PLD.EstatusSITI = Str_NO
		AND PLD.Fecha BETWEEN Par_PeriodoInicio AND Par_PeriodoFin
	ORDER BY PLD.Fecha;


	INSERT INTO PLDCNBVOPEINTPREOC(
		TipoReporte,		PeriodoReporte,		Folio,				ClaveOrgSupervisor,		ClaveEntCasFim,
		LocalidadSuc,		SucursalID,			TipoOperacionID,	InstrumentMonID,		CuentaAhoID,
		Monto,				ClaveMoneda,		FechaOpe,			FechaDeteccion,			Nacionalidad,
		TipoPersona,		RazonSocial,		Nombre,				ApellidoPat,			ApellidoMat,
		RFC,				CURP,				FechaNac,			Domicilio,				Colonia,
		Localidad,			Telefono,			ActEconomica,		NomApoderado,			ApPatApoderado,
		ApMatApoderado,		RFCApoderado,		CURPApoderado,		CtaRelacionadoID,		CuenAhoRelacionado,
		ClaveSujeto,		NomTitular,			ApPatTitular,		ApMatTitular,			DesOperacion,
		Razones,			Fecha,				EmpresaID,			Usuario,				FechaActual,
		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
	SELECT
		TipoReporte,		PeriodoReporte,
		LPAD(Folio,LongFolio, 0) 			AS Folio,
		ClaveOrgSupervisor,	ClaveEntCasFim,

		LEFT(LocalidadSuc,LongLocalidad) 	AS LocalidadSuc,
		LPAD(Sucursal,LongSucursal,0) 		AS SucursalCP,
		TipoOperacionID,		InstrumentMonID,
		LPAD(CuentaAhoID,LongCuenta,0) 		AS NumCuenta,

		Monto,
		LPAD(ClaveMoneda,LongMoneda,0) 		AS Moneda,
		FechaOpe,		FechaDeteccion,		Nacionalidad,

		TipoPersona,
		LEFT(RazonSocial,LongRazonSocial) 	AS RazonSocioal,
		LEFT(Nombre, LongNombre) 			AS Nombre,
		LEFT(ApellidoPat,LongNombre) 		AS ApellidoPaterno,
		LEFT(ApellidoMat,LongApMaterno)		AS ApellidoMaterno,

		RFC,				CURP,				FechaNac,
		FNLIMPIACARACTERESGEN(LEFT(Domicilio,LongDomicilio),Mayusculas) AS Domicilio,
		FNLIMPIACARACTERESGEN(LEFT(Colonia,LongColonia),Mayusculas) AS Colonia,

		LEFT(Localidad,LongLocalidad) 		AS Localidad,
		LEFT(Telefono,LongTelefono) 		AS Telefonos,
		CASE LENGTH(ActEconomica)
			WHEN 9 THEN
				LPAD(LEFT(ActEconomica,LongActEconomica6),LongActEconomica7,'0')
			WHEN 10 THEN
				LPAD(LEFT(ActEconomica,LongActEconomica7),LongActEconomica7,'0')
		END AS ActividadEconomica,
		NomApoderado,				ApPatApoderado,

		ApMatApoderado,				RFCApoderado,			CURPApoderado,
		CtaRelacionadoID,			CuenAhoRelacionado,

		ClaveSujeto,				NomTitular,				ApPatTitular,
		ApMatTitular,
		FNLIMPIACARACTERESGEN(DesOperacion,Mayusculas) AS DescriOperacion,

		FNLIMPIACARACTERESGEN(Razones,Mayusculas) AS DescriMotivo,
		Fecha,
		Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,

		Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion
	FROM TMPSITIPLDREP
	WHERE NumTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPSITIPLDREP WHERE NumTransaccion = Aud_NumTransaccion;

	SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Datos Generados Exitosamente: ',Aud_NumTransaccion,'.');

END ManejoErrores;

IF(Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			'controlCNBV' AS control,
			Aud_NumTransaccion AS consecutivo;
END IF;

END TerminaStore$$

