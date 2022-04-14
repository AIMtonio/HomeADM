-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPERELEVANTXMLREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPERELEVANTXMLREP`;
DELIMITER $$


CREATE PROCEDURE `PLDOPERELEVANTXMLREP`(
/* STORE QUE GENERA EL REPORTE DE OPERACIONES RELEVANTES SEGUN EL LAYOUT XML OFICIAL  */
	Par_EmpresaID			INT(11),			-- Numero de la Empresa
	Par_PeriodoFin			DATE,				-- Fecha Final del Periodo
	Par_NumCon				TINYINT UNSIGNED,	-- Tipo de Consulta
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

	-- Declaracion de Variables
	DECLARE Var_TipoInstitID        INT(11);    -- Tipo de institucion financiera
	DECLARE Var_NombreCorto         VARCHAR(45);-- Nombre corto del tipo de institucion financiera
	DECLARE Var_EntidadRegulada		CHAR(1);	-- Indica si es una entidad financiera regulada

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

	SET PerConver :=  (DATE_FORMAT(Par_PeriodoFin,'%Y%m'));

	-- Se obtiene el tipo de institucion financiera
	SET Var_TipoInstitID := (SELECT Ins.TipoInstitID FROM PARAMETROSSIS Par
								INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
								INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID LIMIT 1);

	SET Var_TipoInstitID := IFNULL(Var_TipoInstitID, Entero_Cero);

	SET Var_EntidadRegulada := (SELECT Tip.EntidadRegulada FROM PARAMETROSSIS Par
								INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
								INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID LIMIT 1);
	SET Var_EntidadRegulada := IFNULL(Var_EntidadRegulada, Cadena_Vacia);


SELECT 		NumCuentaAsociada, 					RegimenCta, 				NivelCta, 					NacionalidadCta, 					InstitucionCta,
			ClabeCta,							TipoFinanciamiento
	INTO 	Var_NumCuentaAsociada, 				Var_RegimenCta, 			Var_NivelCta, 				Var_NacionalidadCta, 				Var_InstitucionCta,
			Var_ClabeCta,						Var_TipoFinanciamiento
FROM 	PLDCUENTASASOCIADAS LIMIT 1; # PREGUNTAR COMO SE VA A EVALUAR PARA QUITAR EL LIMIT


	/* 1.- Consulta Principal
	 * Usada al momento de generar el reporte de operaciones relevantes
	 * Prevencion LD -> Reportes -> Op. Relevantes*/
	IF(Par_NumCon = Con_Principal) THEN

		SELECT
			Cadena_Vacia as sujeto_obligado,
			PLD.ClaveOrgSupervisor AS organo_supervisor,
			PLD.TipoReporte AS tipo_itf,
			PLD.ClaveEntCasFim AS clave_sujeto,
			Cadena_Vacia as reportes,
			Cadena_Vacia as reporte,
			PLD.TipoReporte AS tipo_reporte,
			PLD.PeriodoReporte AS fecha_reporte,
			LPAD(PLD.Folio,LongFolio, Entero_Cero) AS folio_consecutivo,
			Cadena_Vacia as cuenta,
			Var_RegimenCta AS regimen,
			Var_NivelCta AS nivel_cuenta,
			Var_NumCuentaAsociada AS numero_cuenta_proyecto,
			Var_NacionalidadCta AS nacionalidad_cuenta_asociada,
			Var_InstitucionCta AS  institucion_financiera,
			Var_ClabeCta AS cuenta_asociada_institucion,
			Var_TipoFinanciamiento AS tipo_financiamiento_colectivo,
			Cadena_Vacia as cliente,
			PLD.TipoPersona AS tipo_persona,
			C.TipoPersona AS tipo_cliente,
			IF(Var_TipoInstitID = TipoSofom, PLD.Nacionalidad, P.ClaveCNBV) AS pais_nacionalidad,
			REPLACE(UPPER(LEFT(PLD.RazonSocial, LongRazonSocial)),'Ñ','N') AS razon_social_denominacion,
			IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, REPLACE(UPPER(LEFT(PLD.Nombre, LongNombre)),'Ñ','N')) AS nombre,
			IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, REPLACE(UPPER(LEFT(IF(PLD.ApellidoPat IS NULL OR TRIM(PLD.ApellidoPat) = Cadena_Vacia,'XXXX', PLD.ApellidoPat), LongNombre)),'Ñ','N')) AS apellido_paterno,
			IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, REPLACE(UPPER(LEFT(IF(PLD.ApellidoMat IS NULL OR TRIM(PLD.ApellidoMat) = Cadena_Vacia,'XXXX', PLD.ApellidoMat), LongNombre)),'Ñ','N')) AS apellido_materno,
			C.Sexo AS genero,
			TRIM(PLD.RFC) AS rfc_cliente,
			IF(PLD.TipoPersona = TipoPerMoral, Cadena_Vacia, PLD.CURP) AS curp,
			DATE_FORMAT(IF(PLD.TipoPersona = TipoPerMoral, IFNULL(C.FechaConstitucion, Fecha_Vacia), IFNULL(C.FechaNacimiento, Fecha_Vacia)), FormatoFechaRep) AS fecha_nacimiento_constitucion,
			C.EstadoID  AS entidad_nacimiento_constitucion,
			REPLACE(UPPER(LEFT(PLD.Domicilio, LongDomicilio)),'Ñ','N') AS domicilio_cliente,
			D.EstadoID AS entidad_federativa_domicilio,
			D.Calle AS calle_domicilio,
			UPPER(LEFT(PLD.Colonia, LongColonia)) AS colonia,
			UPPER(LEFT(PLD.Localidad, LongLocalidad)) AS ciudad_poblacion,
			D.CP AS codigo_postal,
			LEFT(PLD.Telefono, LongTelefono) AS telefono,
			C.Correo AS correo_electronico,
			LPAD(LEFT(PLD.ActEconomica, LongActEconomica7), LongActEconomica7, Entero_Cero) AS actividad_economica,
			Cadena_Vacia as operacion,
			LPAD(IF((Var_TipoInstitID=TipoSofom AND Var_EntidadRegulada = Str_NO AND (PLD.TipoOperacionID = '01' OR PLD.TipoOperacionID = '1')),
			'09',PLD.TipoOperacionID), LongTipoOp, Entero_Cero)  AS tipo_operacion_ift,
			PLD.InstrumentMonID AS instrumento_monetario,
			CAST(PLD.Monto AS DECIMAL(14,2)) AS monto,
			PLD.ClaveMoneda AS moneda,
			PLD.FechaOpe AS fecha_operacion,
			FechaDeteccion AS fecha_deteccion,
			Cadena_Vacia as apoderado,
			PLD.NomApoderado AS nombre_apoderado,
			PLD.ApPatApoderado AS apellido_paterno_apoderado,
			PLD.ApMatApoderado AS apellido_materno_apoderado

			FROM PLDCNBVOPEREELE PLD
			LEFT JOIN CUENTASAHO CA ON PLD.CuentaAhoID = CA.CuentaAhoID
			INNER JOIN CLIENTES C ON CA.ClienteID = C.ClienteID
			LEFT JOIN DIRECCLIENTE D ON C.ClienteID = D.ClienteID AND D.Oficial = 'S'
			LEFT OUTER JOIN PAISES P ON P.PaisID = IF(PLD.TipoPersona = TipoPerMoral, C.PaisConstitucionID, C.LugarNacimiento)
			WHERE PLD.PeriodoReporte = PerConver
				AND	PLD.tipoReporte = TipRep;

	END IF;

END TerminaStore$$