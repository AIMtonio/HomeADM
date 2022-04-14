-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCNBVOPEREELCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCNBVOPEREELCON`;
DELIMITER $$


CREATE PROCEDURE `PLDCNBVOPEREELCON`(
	-- STORE QUE GENERA EL REPORTE DE OPERACIONES RELEVANTES SEGUN EL LAYOUT OFICIAL
	Par_EmpresaID			INT(11),			-- Numero de la Empresa
	Par_PeriodoFin			DATE,				-- Fecha Final del Periodo
	Par_Operaciones			CHAR(1),			-- Operaciones de: C = CLIENTES, U = USUARIOS DE SERVICIOS, "" = TODOS
	Par_TipoReporte			INT(11),			-- Tipo Reporte 1 = Txt   2 = Excel

	Par_NumCon				TINYINT UNSIGNED,	-- Tipo de Consulta
	-- Parametros de Auditoria
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_TipoInstitID        INT(11);    -- Tipo de institucion financiera
	DECLARE Var_NombreCorto         VARCHAR(45);-- Nombre corto del tipo de institucion financiera
	DECLARE Var_EntidadRegulada		CHAR(1);	-- Indica si es una entidad financiera regulada
	DECLARE Var_GeneraRepVacio		CHAR(1);	-- Indica si el reporte se genera vacío.
	DECLARE Var_NumTotalOpe			INT(11);    -- Núm. de operaciones del reporte.
	DECLARE	Var_ClaveOrgSupervisor	VARCHAR(6);
	DECLARE	Var_ClaveEntCasfim		VARCHAR(6);
	DECLARE Var_CliProEsp   		INT(11);	-- Almacena el Numero de Cliente para Procesos Especificos

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Con_Principal		INT;
	DECLARE	PerConver			VARCHAR(6);
	DECLARE	TipRep				INT;
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
	DECLARE LongTipoOp			INT(11);
	DECLARE Mayusculas			CHAR(2);
	DECLARE	FormatoFechaRep		VARCHAR(6);
	DECLARE TipoPerMoral		CHAR(1);
	DECLARE TipoSocap			INT(11);
	DECLARE TipoSofipo			INT(11);
	DECLARE TipoSofom			INT(11);
	DECLARE Str_NO				CHAR(1);
	DECLARE Str_SI				CHAR(1);
	DECLARE EstatusVigente		CHAR(1);
	DECLARE Separador 			CHAR(1);
	DECLARE Con_CliProcEspe     VARCHAR(20);
	DECLARE NumClienteCrece		INT(11);
    DECLARE TipoTxt				INT(11);
	DECLARE TipoExcel			INT(11);
	DECLARE OperaClientes		CHAR(1);
    DECLARE OperaUsuarios		CHAR(1);

	-- Asignacion de Constantes
	SET	TipRep					:= 1;				-- Tipo de Reporte de Operaciones Relevantes
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET	Con_Principal			:= 1;				-- Consulta Principal, para armar el reporte
	SET LongFolio				:= 6;				-- Logitud en caracteres para Folio
	SET LongRazonSocial			:= 125;				-- Logitud en caracteres para la Razon Social
	SET LongNombre				:= 60;				-- Logitud en caracteres para el Nombre y Apellido Paterno
	SET LongApMaterno			:= 30;				-- Logitud en caracteres para Apellido Materno
	SET LongDomicilio			:= 60;				-- Logitud en caracteres para Domicilio
	SET LongColonia				:= 30;				-- Logitud en caracteres para Colonia
	SET LongLocalidad			:= 8;				-- Logitud en caracteres para Localidad
	SET LongSucursal			:= 8;				-- Logitud en caracteres para la Sucursal
	SET LongTelefono			:= 40;				-- Logitud en caracteres para Telefono
	SET LongActEconomica6		:= 6;				-- Logitud en caracteres para la Actividad Economica
	SET LongActEconomica7		:= 7;				-- Logitud en caracteres para la Actividad Economica
	SET LongCuenta				:= 16;				-- Logitud en caracteres para la cuenta
	SET LongMoneda				:= 3;				-- Logitud en caracteres para la Clave de la Moneda
	SET LongTipoOp				:= 2;				-- Logitud en caracteres para el Tipo de Operación
	SET Mayusculas				:= 'MA';			-- Obtener el resultado en Mayusculas
	SET FormatoFechaRep			:= '%Y%m%d';		-- Formato de la fecha para el reporte
	SET TipoPerMoral			:= '2';				-- Tipo de Persona Moral segun el reporte
	SET TipoSocap				:= 6;				-- Tipo SOCAP, corresponde a la tabla TIPOSINSTITUCION
	SET TipoSofipo				:= 3;				-- Tipo SOFIPO, corresponde a la tabla TIPOSINSTITUCION
	SET TipoSofom				:= 4;				-- Tipo SOFOM, corresponde a la tabla TIPOSINSTITUCION
	SET Str_NO					:= 'N';				-- Constante No.
	SET Str_SI					:= 'S';				-- Constante Si.
	SET	EstatusVigente			:= 'V';				-- Estatus Vigente
	SET Separador				:=';';
    SET Con_CliProcEspe     	:= 'CliProcEspecifico'; -- Llave Parametro para Procesos Especificos
    SET NumClienteCrece			:= 4;				-- Corresponde al Numero de Cliente Especifico para Cre-ce
	SET TipoTxt					:= 1;				-- Tipo de Reporte: Txt
    SET TipoExcel				:= 2;				-- Tipo de Reporte: Excel
	SET OperaClientes			:= 'C';
    SET OperaUsuarios			:= 'U';

	SET PerConver :=  (DATE_FORMAT(Par_PeriodoFin,'%Y%m'));
    SET Aud_FechaActual := NOW();

	DELETE FROM TMPSITIPLDREP
		WHERE PeriodoReporte = PerConver
			AND	TipoReporte = TipRep
			AND NumTransaccion = Aud_NumTransaccion;

	DELETE FROM TMPOPERARELEV
	WHERE PeriodoReporte = PerConver
		AND	TipoReporte = TipRep
		AND NumTransaccion = Aud_NumTransaccion;

	-- Se obtiene el tipo de institucion financiera
	SET Var_TipoInstitID := (SELECT Ins.TipoInstitID FROM PARAMETROSSIS Par
								INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
								INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID LIMIT 1);

	SET Var_TipoInstitID := IFNULL(Var_TipoInstitID, Entero_Cero);

	SET Var_EntidadRegulada := (SELECT Tip.EntidadRegulada FROM PARAMETROSSIS Par
								INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
								INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID LIMIT 1);
	SET Var_EntidadRegulada := IFNULL(Var_EntidadRegulada, Cadena_Vacia);
	SET Var_GeneraRepVacio := FNPARAMGENERALES('RepVacioPLD');
	SET Var_GeneraRepVacio := IFNULL(Var_GeneraRepVacio, Str_NO);

	SET Var_NumTotalOpe := (SELECT COUNT(*) FROM PLDCNBVOPEREELE PLD
								WHERE PLD.PeriodoReporte = PerConver
									AND PLD.TipoReporte = TipRep);
	SET Var_NumTotalOpe := IFNULL(Var_NumTotalOpe, Entero_Cero);

	SET Var_ClaveOrgSupervisor := (SELECT ClaveOrgSupervisor FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET Var_ClaveEntCasfim := (SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);

	-- Se obtiene el Nombre Corto del Tipo de Institucion Financiera
	SET Var_NombreCorto :=(SELECT Tip.NombreCorto
							FROM PARAMETROSSIS Par
							INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
							INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID LIMIT 1);
	SET Var_NombreCorto := IFNULL(Var_NombreCorto, Cadena_Vacia);

    -- Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
	SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

	/* 1.- Consulta Principal
	 * Usada al momento de generar el reporte de operaciones relevantes
	 * Prevencion LD -> Reportes -> Op. Relevantes*/
	IF(Par_NumCon = Con_Principal) THEN
		IF(Var_GeneraRepVacio = Str_SI AND Var_NumTotalOpe = Entero_Cero)THEN
			INSERT INTO TMPSITIPLDREP(
				TipoReporte,	PeriodoReporte,	Folio,				ClaveOrgSupervisor,	ClaveEntCasFim,
				LocalidadSuc,	Sucursal,		TipoOperacionID,	InstrumentMonID,	CuentaAhoID,
				Monto,			ClaveMoneda,	FechaOpe,			FechaDeteccion,		Nacionalidad,
				TipoPersona,	RazonSocial,	Nombre,				ApellidoPat,		ApellidoMat,
				RFC,			CURP,			FechaNac,			Domicilio,			Colonia,
				Localidad,		Telefono,		ActEconomica,		NomApoderado,		ApPatApoderado,
				ApMatApoderado,	RFCApoderado,	CURPApoderado,		CtaRelacionadoID,	CuenAhoRelacionado,
				ClaveSujeto,	NomTitular,		ApPatTitular,		ApMatTitular,		DesOperacion,
				Razones,		ClaveCNBV,		NumTransaccion)
			VALUES (
				TipRep,			PerConver,		LPAD(Entero_Cero,LongFolio, Entero_Cero),
				Var_ClaveOrgSupervisor, 		Var_ClaveEntCasfim,
				Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
				Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
				Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
				Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
				Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
				Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
				Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,
				Cadena_Vacia,	Cadena_Vacia,	Aud_NumTransaccion);
		END IF;

		-- OPERACION DE: TODOS O CLIENTES
		IF(Par_Operaciones = Cadena_Vacia OR Par_Operaciones = OperaClientes)THEN

            -- OPERACIONES DE CLIENTES
			INSERT INTO TMPSITIPLDREP(
				TipoReporte,	PeriodoReporte,	Folio,				ClaveOrgSupervisor,	ClaveEntCasFim,
				LocalidadSuc,	Sucursal,		TipoOperacionID,	InstrumentMonID,	CuentaAhoID,
				Monto,			ClaveMoneda,	FechaOpe,			FechaDeteccion,		Nacionalidad,
				TipoPersona,	RazonSocial,	Nombre,				ApellidoPat,		ApellidoMat,
				RFC,			CURP,			FechaNac,			Domicilio,			Colonia,
				Localidad,		Telefono,		ActEconomica,		NomApoderado,		ApPatApoderado,
				ApMatApoderado,	RFCApoderado,	CURPApoderado,		CtaRelacionadoID,	CuenAhoRelacionado,
				ClaveSujeto,	NomTitular,		ApPatTitular,		ApMatTitular,		DesOperacion,
				Razones,		ClaveCNBV,		NumTransaccion)
			SELECT
				PLD.TipoReporte,		PLD.PeriodoReporte,
				LPAD(PLD.Folio,LongFolio, Entero_Cero) AS Folio,
				PLD.ClaveOrgSupervisor,	PLD.ClaveEntCasFim,
				LPAD(PLD.LocalidadSuc, LongLocalidad, Entero_Cero) AS LocalidadSuc,
				IF(Var_TipoInstitID=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS Sucursal,
				LPAD(IF((Var_TipoInstitID=TipoSofom AND Var_EntidadRegulada = Str_NO AND (PLD.TipoOperacionID = '01' OR PLD.TipoOperacionID = '1')),
					'09',PLD.TipoOperacionID), LongTipoOp, Entero_Cero) AS TipoOperacionID,
				PLD.InstrumentMonID,
				LPAD(PLD.CuentaAhoID, LongCuenta, Entero_Cero) AS CuentaAhoID,
				CAST(PLD.Monto AS DECIMAL(14,2)) AS Monto,
				PLD.ClaveMoneda AS ClaveMoneda,
				PLD.FechaOpe,			FechaDeteccion,
				IF(Var_TipoInstitID = TipoSofom, PLD.Nacionalidad, P.ClaveCNBV) AS Nacionalidad,
				PLD.TipoPersona,
				UPPER(LEFT(CONVERT(FNLIMPIANOMBRESPLD(PLD.RazonSocial) USING utf8), LongRazonSocial)) AS RazonSocial,
				IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, UPPER(LEFT(CONVERT(FNLIMPIANOMBRESPLD(PLD.Nombre) USING utf8), LongNombre))) AS Nombre,
				IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, UPPER(LEFT(IF(PLD.ApellidoPat IS NULL OR TRIM(PLD.ApellidoPat) = Cadena_Vacia,'XXXX', CONVERT(FNLIMPIANOMBRESPLD(PLD.ApellidoPat) USING utf8)), LongNombre))) AS ApellidoPat,
				IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, UPPER(LEFT(IF(PLD.ApellidoMat IS NULL OR TRIM(PLD.ApellidoMat) = Cadena_Vacia,'XXXX', CONVERT(FNLIMPIANOMBRESPLD(PLD.ApellidoMat) USING utf8)), LongNombre))) AS ApellidoMat,
				TRIM(PLD.RFC) AS RFC,
				IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, PLD.CURP) AS CURP,
				DATE_FORMAT(IF(PLD.TipoPersona = TipoPerMoral, IFNULL(C.FechaConstitucion, Fecha_Vacia), IFNULL(C.FechaNacimiento, Fecha_Vacia)), FormatoFechaRep) AS FechaNac,
				UPPER(LEFT(CONVERT(FNLIMPIAENIESPLD(PLD.Domicilio) USING utf8), LongDomicilio)) AS Domicilio,
				UPPER(LEFT(CONVERT(FNLIMPIAENIESPLD(PLD.Colonia) USING utf8), LongColonia)) AS Colonia,
				UPPER(LEFT(CONVERT(FNLIMPIAENIESPLD(PLD.Localidad) USING utf8), LongLocalidad)) AS Localidad,
				LEFT(PLD.Telefono, LongTelefono) AS Telefono,
				LPAD(LEFT(PLD.ActEconomica, LongActEconomica7), LongActEconomica7, Entero_Cero) AS ActEconomica,
				PLD.NomApoderado,		PLD.ApPatApoderado,			PLD.ApMatApoderado,				PLD.RFCApoderado,			PLD.CURPApoderado,
				PLD.CtaRelacionadoID,	PLD.CuenAhoRelacionado,		PLD.ClaveSujeto,				PLD.NomTitular,				PLD.ApPatTitular,
				PLD.ApMatTitular,		PLD.DesOperacion,			PLD.Razones,					PLD.ClaveCNBV,
				Aud_NumTransaccion
			FROM PLDCNBVOPEREELE PLD
				LEFT JOIN SUCURSALES Suc ON Suc.ClaveSucCNBV = PLD.SucursalID
				LEFT JOIN CUENTASAHO CA ON PLD.CuentaAhoID =CA.CuentaAhoID
				INNER JOIN CLIENTES C ON CA.ClienteID = C.ClienteID
				LEFT OUTER JOIN PAISES P ON P.PaisID = IF(PLD.TipoPersona = TipoPerMoral, C.PaisConstitucionID, C.LugarNacimiento)
				WHERE PLD.PeriodoReporte = PerConver
					AND	PLD.TipoReporte = TipRep
                    AND PLD.ClienteID > Entero_Cero;
		END IF;

		-- OPERACION DE: TODOS O USUARIOS DE SERVICIOS
		IF(Par_Operaciones = Cadena_Vacia OR Par_Operaciones = OperaUsuarios)THEN
			-- OPERACIONES DE USUARIOS DE SERVICIOS
			INSERT INTO TMPSITIPLDREP(
				TipoReporte,	PeriodoReporte,	Folio,				ClaveOrgSupervisor,	ClaveEntCasFim,
				LocalidadSuc,	Sucursal,		TipoOperacionID,	InstrumentMonID,	CuentaAhoID,
				Monto,			ClaveMoneda,	FechaOpe,			FechaDeteccion,		Nacionalidad,
				TipoPersona,	RazonSocial,	Nombre,				ApellidoPat,		ApellidoMat,
				RFC,			CURP,			FechaNac,			Domicilio,			Colonia,
				Localidad,		Telefono,		ActEconomica,		NomApoderado,		ApPatApoderado,
				ApMatApoderado,	RFCApoderado,	CURPApoderado,		CtaRelacionadoID,	CuenAhoRelacionado,
				ClaveSujeto,	NomTitular,		ApPatTitular,		ApMatTitular,		DesOperacion,
				Razones,		ClaveCNBV,		NumTransaccion)
			SELECT
				PLD.TipoReporte,		PLD.PeriodoReporte,
				LPAD(PLD.Folio,LongFolio, Entero_Cero) AS Folio,
				PLD.ClaveOrgSupervisor,	PLD.ClaveEntCasFim,
				LPAD(PLD.LocalidadSuc, LongLocalidad, Entero_Cero) AS LocalidadSuc,
				IF(Var_TipoInstitID=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS Sucursal,
				LPAD(IF((Var_TipoInstitID=TipoSofom AND Var_EntidadRegulada = Str_NO AND (PLD.TipoOperacionID = '01' OR PLD.TipoOperacionID = '1')),
					'09',PLD.TipoOperacionID), LongTipoOp, Entero_Cero) AS TipoOperacionID,
				PLD.InstrumentMonID,
				LPAD(PLD.NumTransaccion, LongCuenta, Entero_Cero) AS CuentaAhoID,
				CAST(PLD.Monto AS DECIMAL(14,2)) AS Monto,
				PLD.ClaveMoneda AS ClaveMoneda,
				PLD.FechaOpe,			FechaDeteccion,
				IF(Var_TipoInstitID = TipoSofom, PLD.Nacionalidad, P.ClaveCNBV) AS Nacionalidad,
				PLD.TipoPersona,
				UPPER(LEFT(CONVERT(FNLIMPIANOMBRESPLD(PLD.RazonSocial) USING utf8), LongRazonSocial)) AS RazonSocial,
				IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, UPPER(LEFT(CONVERT(FNLIMPIANOMBRESPLD(PLD.Nombre) USING utf8), LongNombre))) AS Nombre,
				IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, UPPER(LEFT(IF(PLD.ApellidoPat IS NULL OR TRIM(PLD.ApellidoPat) = Cadena_Vacia,'XXXX', CONVERT(FNLIMPIANOMBRESPLD(PLD.ApellidoPat) USING utf8)), LongNombre))) AS ApellidoPat,
				IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, UPPER(LEFT(IF(PLD.ApellidoMat IS NULL OR TRIM(PLD.ApellidoMat) = Cadena_Vacia,'XXXX', CONVERT(FNLIMPIANOMBRESPLD(PLD.ApellidoMat) USING utf8)), LongNombre))) AS ApellidoMat,
				TRIM(PLD.RFC) AS RFC,
				IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, PLD.CURP) AS CURP,
				DATE_FORMAT(IF(PLD.TipoPersona = TipoPerMoral, IFNULL(U.FechaConstitucion, Fecha_Vacia), IFNULL(U.FechaNacimiento, Fecha_Vacia)), FormatoFechaRep) AS FechaNac,
				UPPER(LEFT(CONVERT(FNLIMPIAENIESPLD(PLD.Domicilio) USING utf8), LongDomicilio)) AS Domicilio,
				UPPER(LEFT(CONVERT(FNLIMPIAENIESPLD(PLD.Colonia) USING utf8), LongColonia)) AS Colonia,
				UPPER(LEFT(CONVERT(FNLIMPIAENIESPLD(PLD.Localidad) USING utf8), LongLocalidad)) AS Localidad,
				LEFT(PLD.Telefono, LongTelefono) AS Telefono,
				LPAD(LEFT(PLD.ActEconomica, LongActEconomica7), LongActEconomica7, Entero_Cero) AS ActEconomica,
				PLD.NomApoderado,		PLD.ApPatApoderado,			PLD.ApMatApoderado,				PLD.RFCApoderado,			PLD.CURPApoderado,
				PLD.CtaRelacionadoID,	PLD.CuenAhoRelacionado,		PLD.ClaveSujeto,				PLD.NomTitular,				PLD.ApPatTitular,
				PLD.ApMatTitular,		PLD.DesOperacion,			PLD.Razones,					PLD.ClaveCNBV,
				Aud_NumTransaccion
			FROM PLDCNBVOPEREELE PLD
				LEFT JOIN SUCURSALES Suc ON Suc.ClaveSucCNBV = PLD.SucursalID
				INNER JOIN USUARIOSERVICIO U ON PLD.UsuarioServicioID = U.UsuarioServicioID
				LEFT OUTER JOIN PAISES P ON P.PaisID = U.PaisNacimiento
				WHERE PLD.PeriodoReporte = PerConver
					AND	PLD.TipoReporte = TipRep
                    AND PLD.UsuarioServicioID > Entero_Cero;
		END IF;

        -- Tipo de Reporte: Txt
		IF(Par_TipoReporte = TipoTxt)THEN

			IF(Var_NombreCorto = "scap" || Var_NombreCorto = "socap" ||
								Var_NombreCorto = "sofipo")THEN

				INSERT INTO TMPOPERARELEV(
					TipoReporte,	PeriodoReporte,		Folio,			OperaRelevante,		EmpresaID,
					Usuario,		FechaActual,		DireccionIP,	ProgramaID,			Sucursal,
					NumTransaccion)
				SELECT
					IFNULL(TipoReporte,Entero_Cero),	IFNULL(PeriodoReporte,Cadena_Vacia),	IFNULL(Folio,Cadena_Vacia),
					CONCAT_WS(Separador,
					IFNULL(TipoReporte,Entero_Cero),	IFNULL(PeriodoReporte,Cadena_Vacia),	IFNULL(Folio,Cadena_Vacia),				IFNULL(ClaveOrgSupervisor,Cadena_Vacia),				IFNULL(ClaveEntCasFim,Cadena_Vacia),
					IFNULL(LocalidadSuc,Cadena_Vacia),	IFNULL(Sucursal,Cadena_Vacia),			IFNULL(TipoOperacionID,Cadena_Vacia),	IFNULL(InstrumentMonID,Cadena_Vacia),					IFNULL(CuentaAhoID,Cadena_Vacia),
					IFNULL(Monto,Cadena_Vacia),			IFNULL(ClaveMoneda,Cadena_Vacia),		IFNULL(FechaOpe,Cadena_Vacia),			Cadena_Vacia,											IFNULL(Nacionalidad,Cadena_Vacia),
					IFNULL(TipoPersona,Cadena_Vacia),	IFNULL(RazonSocial,Cadena_Vacia),		IFNULL(Nombre,Cadena_Vacia),			IFNULL(ApellidoPat,Cadena_Vacia),						IFNULL(ApellidoMat,Cadena_Vacia),
					IFNULL(RFC,Cadena_Vacia),			IFNULL(CURP,Cadena_Vacia),				IFNULL(FechaNac,Cadena_Vacia),			IFNULL(Domicilio,Cadena_Vacia),							IFNULL(Colonia,Cadena_Vacia),
					IFNULL(Localidad,Cadena_Vacia),		IFNULL(Telefono,Cadena_Vacia),			IFNULL(ActEconomica,Cadena_Vacia),		Cadena_Vacia,											Cadena_Vacia,
					Cadena_Vacia,						Cadena_Vacia,							Cadena_Vacia,							Cadena_Vacia,											Cadena_Vacia,
					Cadena_Vacia,						Cadena_Vacia,							Cadena_Vacia,							Cadena_Vacia,											Cadena_Vacia,
					Cadena_Vacia,						Cadena_Vacia),							Par_EmpresaID,							Aud_Usuario,											Aud_FechaActual,
					Aud_DireccionIP,					Aud_ProgramaID,							Aud_Sucursal,							NumTransaccion
				FROM TMPSITIPLDREP
				WHERE TipoReporte = TipRep
					AND	PeriodoReporte = PerConver
					AND NumTransaccion = Aud_NumTransaccion;
			ELSE

				INSERT INTO TMPOPERARELEV(
					TipoReporte,	PeriodoReporte,		Folio,			OperaRelevante,		EmpresaID,
					Usuario,		FechaActual,		DireccionIP,	ProgramaID,			Sucursal,
					NumTransaccion)
				SELECT
					IFNULL(TipoReporte,Entero_Cero),	IFNULL(PeriodoReporte,Cadena_Vacia),	IFNULL(Folio,Cadena_Vacia),
					CONCAT_WS(Separador,
					IFNULL(TipoReporte,Entero_Cero),	IFNULL(PeriodoReporte,Cadena_Vacia),	IFNULL(Folio,Cadena_Vacia),				IFNULL(ClaveOrgSupervisor,Cadena_Vacia),				IFNULL(ClaveEntCasFim,Cadena_Vacia),
					IFNULL(LocalidadSuc,Cadena_Vacia),	Cadena_Vacia,							IFNULL(TipoOperacionID,Cadena_Vacia),	IFNULL(InstrumentMonID,Cadena_Vacia),					IFNULL(CuentaAhoID,Cadena_Vacia),
					IFNULL(Monto,Cadena_Vacia),			IFNULL(ClaveMoneda,Cadena_Vacia),		IFNULL(FechaOpe,Cadena_Vacia),			Cadena_Vacia,											IFNULL(Nacionalidad,Cadena_Vacia),
					IFNULL(TipoPersona,Cadena_Vacia),	IFNULL(RazonSocial,Cadena_Vacia),		IFNULL(Nombre,Cadena_Vacia),			IFNULL(ApellidoPat,Cadena_Vacia),						IFNULL(ApellidoMat,Cadena_Vacia),
					IFNULL(RFC,Cadena_Vacia),			IFNULL(CURP,Cadena_Vacia),				IFNULL(FechaNac,Cadena_Vacia),			IFNULL(Domicilio,Cadena_Vacia),							IFNULL(Colonia,Cadena_Vacia),
					IFNULL(Localidad,Cadena_Vacia),		IFNULL(Telefono,Cadena_Vacia),			IFNULL(ActEconomica,Cadena_Vacia),		Cadena_Vacia,											Cadena_Vacia,
					Cadena_Vacia,						Cadena_Vacia,							Cadena_Vacia,							Cadena_Vacia,											Cadena_Vacia,
					Cadena_Vacia,						Cadena_Vacia),							Par_EmpresaID,							Aud_Usuario,											Aud_FechaActual,
					Aud_DireccionIP,					Aud_ProgramaID,							Aud_Sucursal,							NumTransaccion
				FROM TMPSITIPLDREP
				WHERE TipoReporte = TipRep
					AND	PeriodoReporte = PerConver
					AND NumTransaccion = Aud_NumTransaccion;

				IF(Var_CliProEsp = NumClienteCrece)THEN
					UPDATE TMPOPERARELEV
					SET OperaRelevante = LEFT(OperaRelevante,LENGTH(OperaRelevante)-1)
					WHERE TipoReporte = TipRep
						AND	PeriodoReporte = PerConver
						AND NumTransaccion = Aud_NumTransaccion;
				END IF;
			END IF;

			SELECT OperaRelevante
			FROM TMPOPERARELEV
			WHERE TipoReporte = TipRep
				AND	PeriodoReporte = PerConver
				AND NumTransaccion = Aud_NumTransaccion;
		END IF;

		-- Tipo de Reporte: Excel
        IF(Par_TipoReporte = TipoExcel)THEN
			SELECT
				TipoReporte,	PeriodoReporte,	Folio,				ClaveOrgSupervisor,	ClaveEntCasFim,
				LocalidadSuc,	Sucursal,		TipoOperacionID,	InstrumentMonID,	CuentaAhoID,
				Monto,			ClaveMoneda,	FechaOpe,			FechaDeteccion,		Nacionalidad,
				TipoPersona,	RazonSocial,	Nombre,				ApellidoPat,		ApellidoMat,
				RFC,			CURP,			FechaNac,			Domicilio,			Colonia,
				Localidad,		Telefono,		ActEconomica,		NomApoderado,		ApPatApoderado,
				ApMatApoderado,	RFCApoderado,	CURPApoderado,		CtaRelacionadoID,	CuenAhoRelacionado,
				ClaveSujeto,	NomTitular,		ApPatTitular,		ApMatTitular,		DesOperacion,
				Razones,		ClaveCNBV
			FROM TMPSITIPLDREP
				WHERE TipoReporte = TipRep
					AND	PeriodoReporte = PerConver
					AND NumTransaccion = Aud_NumTransaccion;
        END IF;


		DELETE FROM TMPOPERARELEV
			WHERE TipoReporte = TipRep
				AND	PeriodoReporte = PerConver
				AND NumTransaccion = Aud_NumTransaccion;

        DELETE FROM TMPSITIPLDREP
			WHERE TipoReporte = TipRep
				AND	PeriodoReporte = PerConver
				AND NumTransaccion = Aud_NumTransaccion;

	END IF;

END TerminaStore$$