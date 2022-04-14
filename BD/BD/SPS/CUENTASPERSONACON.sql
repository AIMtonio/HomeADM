-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASPERSONACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASPERSONACON`;DELIMITER $$

CREATE PROCEDURE `CUENTASPERSONACON`(
/** ***** STORE ENCARGADO DE REALIZAR UNA CONSULTA A LA TABLA CUENTASPERSONA ***** **/
	Par_CuentaAhoID			BIGINT(12),
	Par_PersonaID			INT(13),
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
		)
TerminaStore: BEGIN

	-- Declaracionde Variables
	DECLARE NumErr      		INT(11);
	DECLARE ErrMen      		VARCHAR(40);
	DECLARE Var_CuentaAhoID 	INT;
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Con_Principal		INT;
	DECLARE	Con_Foranea			INT;
	DECLARE	Con_Firmante		INT;
	DECLARE	Con_Existe			INT;
	DECLARE	Con_BenefCta	    INT;
	DECLARE EsBeneficiario      CHAR(1);
	DECLARE	Firmante			CHAR(1);
	DECLARE Vigente				CHAR(1);


	/* ***** ASIGNACION DE CONSTANTES ****** */
	SET	Cadena_Vacia	:= '';				-- String o cadena vacia.
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha vacia.
	SET	Entero_Cero		:= 0;				-- Entero cero.
	SET	Con_Principal	:= 1;				-- Consulta principal.
	SET	Con_Foranea		:= 2;				-- Consulta foranea.
	SET	Con_Firmante	:= 3;				-- Consulta	firmante.
	SET	Con_Existe		:= 4;				-- Consulta si existe.
	SET Con_BenefCta    := 5;				-- Consulta de Beneficiarios del titular de la cuenta.
	SET	EsBeneficiario	:= 'S';				-- Si es beneficiario.
	SET	Firmante		:= 'S';				-- Si es firmante.
	SET Vigente			:= 'V';				-- Estatus vigente.


	IF(Par_NumCon = Con_Principal) THEN
		SELECT	CP.CuentaAhoID, 	CP.PersonaID,			CP.EsApoderado,		CP.EsTitular,		CP.EsCotitular,
				CP.EsBeneficiario,	CP.EsProvRecurso,		CP.EsPropReal,		CP.EsFirmante,		CP.EmpresaID,
				CP.Titulo,			CP.PrimerNombre,		CP.SegundoNombre,	CP.TercerNombre,	CP.ApellidoPaterno,
				CP.ApellidoMaterno,	CP.NombreCompleto,		CP.FechaNac,		CP.PaisNacimiento,	CP.EstadoCivil,
				CP.Sexo,			CP.Nacionalidad,		CP.CURP,			CP.RFC,				CP.OcupacionID,
				CP.FEA,				CP.PaisFEA,				CP.PaisRFC,			CP.PuestoA,			CP.SectorGeneral,
				CP.ActividadBancoMX,CP.ActividadINEGI,		CP.SectorEconomico,	CP.TipoIdentiID,	CP.OtraIdentifi,
				CP.NumIdentific,	CP.FecExIden,			CP.FecVenIden,		CP.Domicilio,		CP.TelefonoCasa,
				CP.TelefonoCelular,	CP.Correo,				CP.PaisResidencia,	CP.DocEstanciaLegal,CP.DocExisLegal,
				CP.FechaVenEst,		CP.NumEscPub,			CP.FechaEscPub,		CP.EstadoID,		CP.MunicipioID,
				CP.NotariaID,		CP.TitularNotaria,		CP.RazonSocial,		CP.Fax,				CP.ParentescoID,
				CP.Porcentaje, 		CP.ClienteID, 			CP.EdoNacimiento,	CP.ExtTelefonoPart, CP.IngresoRealoRecur,
				CP.EsAccionista,	CP.PorcentajeAcciones
			FROM		CUENTASPERSONA CP
			WHERE		CP.CuentaAhoID 	= Par_CuentaAhoID
			AND			CP.PersonaID 	= Par_PersonaID
			AND			CP.EstatusRelacion = Vigente;
	END IF;


	IF(Par_NumCon = Con_Foranea) THEN
		SELECT		CuentaAhoID, 		PersonaID, 		EsApoderado,
					EsTitular,			EsCotitular,	EsBeneficiario,
					EsProvRecurso,		EsPropReal,		EsFirmante,
					NombreCompleto
		FROM		CUENTASPERSONA
		WHERE		CuentaAhoID 	= Par_CuentaAhoID
		AND			PersonaID 		= Par_PersonaID
		AND			EstatusRelacion = Vigente;
	END IF;

	IF(Par_NumCon = Con_Firmante) THEN
		SELECT		CuentaAhoID, 	PersonaID, 		NombreCompleto
		FROM		CUENTASPERSONA
		WHERE		CuentaAhoID 	= Par_CuentaAhoID
		AND			EstatusRelacion = Vigente
		AND			EsFirmante 		= Firmante;
	END IF;

	IF(Par_NumCon = Con_Existe) THEN
		SELECT		CuentaAhoID, 		PersonaID, 		NombreCompleto
			FROM		CUENTASPERSONA
			WHERE		CuentaAhoID 	= Par_CuentaAhoID
			AND			EstatusRelacion = Vigente
			LIMIT 1;
	END IF;

	IF(Par_NumCon = Con_BenefCta) THEN
		SELECT	Cta.NombreCompleto,	Cta.Domicilio,	Cta.TelefonoCasa,
				Tip.Descripcion, Cta.Porcentaje
					FROM CUENTASPERSONA Cta
					INNER JOIN TIPORELACIONES Tip
						 ON(Tip.TipoRelacionID= Cta.ParentescoID)
					WHERE Cta.CuentaAhoID = Par_CuentaAhoID
					AND	Cta.EstatusRelacion = Vigente
					AND	Cta.EsBeneficiario= EsBeneficiario;
	END IF;

END TerminaStore$$