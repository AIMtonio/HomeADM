-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSPDMCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSPDMCON`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSPDMCON`(
# =====================================================================================
# ------- STORE PARA LOS PARAMETROS DE LOS WS DE PADEMOBILE---------
# =====================================================================================
	Par_EmpresaID		INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	 Cadena_Vacia		CHAR(1);
	DECLARE	 Fecha_Vacia		DATE;
	DECLARE	 Hora_Vacia 		TIME;
	DECLARE	 Entero_Cero		INT;
	DECLARE	 Decimal_Cero		DECIMAL(12,2);
	DECLARE	 Con_Principal	    INT;

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia		    := '';           -- Constante cadena vacia
	SET	Fecha_Vacia			    := '1900-01-01'; -- Constante fecha vacia
	SET	Hora_Vacia			    := '00:00:00';   -- Constante hora vacia
	SET	Entero_Cero			    := 0;            -- Constante entero cero
	SET	Decimal_Cero		    := 0.0;          -- Constante decimal cero
	SET	Con_Principal		    := 1;			 -- Consulta Principal


	IF(Par_NumCon = Con_Principal) THEN
		SELECT 	EmpresaID,			TimeOut,				UrlWSDLLogout,		UrlWSDLLogin,		UrlWSDLAlta,
				UrlWSDLBloqueo,		UrlWSDLDesBloqueo,		NombreServicio,	 	NumeroPreguntas,   	NumeroRespuestas
			FROM PARAMETROSPDM
			WHERE EmpresaID = Par_EmpresaID;
	END IF;

END TerminaStore$$