
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDLISTANEGRASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDLISTANEGRASCON`;

DELIMITER $$
CREATE PROCEDURE `PLDLISTANEGRASCON`(
	/*SP para la consulta de personas en listas negras*/
	Par_ListaNegraID	BIGINT(12),				# ID de persona de Listas negras
	Par_NumCon			TINYINT UNSIGNED,		# Numero de consulta
	Par_TipoPersona		CHAR(1),				# Tipo de Persona F: Física M: Moral
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),

	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	ConsultaPrincipal	CHAR(1);
	DECLARE	Consulta_DatosLev	INT;
	DECLARE	Con_DatosLevMas		INT;
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Tipo_PersFisica		CHAR(1);
	DECLARE	Est_Activo			CHAR(1);

	-- asignacion de Constantes
	SET	ConsultaPrincipal	:= 1;			-- Consulta Principal
	SET	Consulta_DatosLev	:= 3;			-- Consulta lista por tipo de persona y estatus.
	SET	Con_DatosLevMas		:= 4;			-- Consulta lista por para búsqueda masiva.
	SET Cadena_Vacia		:= ''; 			-- CADENA VACIA
	SET Tipo_PersFisica		:= 'F';			-- Tipo Persona Fisica
	SET Est_Activo			:= 'A';			-- Estatus Activo

	IF(Par_NumCon = ConsultaPrincipal) THEN
		SELECT
			LPAD(ListaNegraID, 8, 0) AS ListaNegraID,
			IF(LENGTH(TRIM(PrimerNombre))>1,TRIM(PrimerNombre),Cadena_Vacia) AS PrimerNombre,
			IF(LENGTH(TRIM(SegundoNombre))>1,TRIM(SegundoNombre),Cadena_Vacia) AS SegundoNombre,
			IF(LENGTH(TRIM(TercerNombre))>1,TRIM(TercerNombre),Cadena_Vacia) AS TercerNombre,
			IF(LENGTH(TRIM(ApellidoPaterno))>1,TRIM(ApellidoPaterno),Cadena_Vacia) AS ApellidoPaterno,

			IF(LENGTH(TRIM(ApellidoMaterno))>1,TRIM(ApellidoMaterno),Cadena_Vacia) AS ApellidoMaterno,
			IF(LENGTH(TRIM(RFC))>1,TRIM(RFC),Cadena_Vacia) AS RFC,
			FechaNacimiento,
			IF(LENGTH(TRIM(NombresConocidos))>1,TRIM(NombresConocidos),Cadena_Vacia) AS NombresConocidos,
			PaisID,

			EstadoID,		TipoLista,		FechaAlta,		FechaReactivacion,		FechaInactivacion,

			Estatus,
			IF(LENGTH(TRIM(NumeroOficio))>1,TRIM(NumeroOficio),Cadena_Vacia) AS NumeroOficio,
			TipoPersona,
			IF(LENGTH(TRIM(RazonSocial))>1,TRIM(RazonSocial),Cadena_Vacia) AS RazonSocial,
			IF(LENGTH(TRIM(RFCm))>1,TRIM(RFCm),Cadena_Vacia) AS RFCm

			FROM PLDLISTANEGRAS
				WHERE ListaNegraID = Par_ListaNegraID;
	END IF;

	-- Consulta para la busqueda de coincidencias desde java.
	IF(Par_NumCon = Consulta_DatosLev) THEN
		SELECT
			ListaNegraID,	TipoLista,
			IF(TipoPersona = Tipo_PersFisica,
				CONCAT(SoloNombres, SoloApellidos),
				RazonSocialPLD) AS NombreCompleto
		FROM PLDLISTANEGRAS
		WHERE TipoPersona = Par_TipoPersona
			AND Estatus = Est_Activo;
	END IF;

	-- Consulta para la busqueda de coincidencias masiva desde java.
	IF(Par_NumCon = Con_DatosLevMas) THEN
		SELECT
			ListaNegraID AS ListaPLDID,	TipoPersona,	TipoLista,	IDQEQ,	FechaAlta,
			NumeroOficio,
			REPLACE(IF(TipoPersona = Tipo_PersFisica,
				CONCAT(SoloNombres, SoloApellidos),
				RazonSocialPLD),' ',Cadena_Vacia) AS NombreCompleto
		FROM PLDLISTANEGRAS
		WHERE Estatus = Est_Activo;
	END IF;

END TerminaStore$$

