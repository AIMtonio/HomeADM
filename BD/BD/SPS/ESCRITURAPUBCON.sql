-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESCRITURAPUBCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESCRITURAPUBCON`;
DELIMITER $$

CREATE PROCEDURE `ESCRITURAPUBCON`(
# =====================================================================================
# ----- STORED QUE CONSULTA LA ESCRITURA PUBLICA DE UN CLIENTE -----------------
# =====================================================================================
	Par_ClienteID		INT(11),			# Numero de Cliente
	Par_Consecutivo 	INT(11), 			# Consecutivo
	Par_EscrituraPublic VARCHAR(50), 		# Numero de Escritura Publica
	Par_NumCon			TINYINT UNSIGNED,	# Numero de Consulta

    -- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Con_Principal	INT(11);
DECLARE	Con_Foranea		INT(11);
DECLARE	Con_Poderes		INT(11);
DECLARE Con_EscCliente	INT(11);


SET	Cadena_Vacia	:= '';				# Constante Cadena Vacia
SET	Fecha_Vacia		:= '1900-01-01';	# Constante Fecha Vacia
SET	Entero_Cero		:= 0;				# Constante 0
SET	Con_Principal	:= 1;				# Consulta Principal
SET	Con_Foranea		:= 2;				# Consulta Foranea
SET	Con_Poderes		:= 3;				# Consulta de Poderes
SET Con_EscCliente	:= 4;				# Consulta Escritura Publica de un Cliente Especifico

# CONSULTA PRINCIPAL
IF(Par_NumCon = Con_Principal) THEN
	SELECT	ClienteID,			Consecutivo,		Esc_Tipo, 			EscrituraPublic,		LibroEscritura,
			VolumenEsc, 		FechaEsc, 			EstadoIDEsc,		LocalidadEsc,			Notaria,
			DirecNotaria,		NomNotario,			NomApoderado,		RFC_Apoderado,			RegistroPub,
			FolioRegPub,		VolumenRegPub,		LibroRegPub,		AuxiliarRegPub,			FechaRegPub,
			EstadoIDReg,		LocalidadRegPub,	Estatus,			Observaciones

	FROM		ESCRITURAPUB
	WHERE		ClienteID = Par_ClienteID
	AND		Consecutivo = Par_Consecutivo;
END IF;

# CONSULTA FORANEA
IF(Par_NumCon = Con_Foranea) THEN
	SELECT	`Consecutivo`, Esc_Tipo
	FROM 		ESCRITURAPUB
	WHERE		ClienteID = Par_ClienteID
	AND		Consecutivo = Par_Consecutivo;
END IF;

# CONSULTA ACTA DE PODERES
IF(Par_NumCon = Con_Poderes) THEN
	SELECT 	EscrituraPublic,	FechaEsc,		EstadoIDEsc,	LocalidadEsc,		Notaria,
			NomNotario,			DirecNotaria
	FROM 	ESCRITURAPUB
	WHERE 	EscrituraPublic	= Par_EscrituraPublic
	AND   	Esc_Tipo 	= 'P';

END IF;

# ESCRITURA PUBLIA DE UN CLIENTE EN ESPECIFICO
IF(Par_NumCon = Con_EscCliente) THEN

	SELECT 	EscrituraPublic,	FechaEsc,		EstadoIDEsc,	LocalidadEsc,		Notaria
	FROM 	ESCRITURAPUB
	WHERE 	ClienteID	= Par_ClienteID
			AND EscrituraPublic	= Par_EscrituraPublic
	ORDER BY FechaActual DESC
    LIMIT 1;

END IF;

END TerminaStore$$